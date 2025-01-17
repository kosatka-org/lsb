require 'google/apis/sheets_v4'
require 'google_drive'

Google::Apis::RequestOptions.default.retries = 5

class OrderProductsSpreadsheetJob
  include Sidekiq::Worker
  GOOGLE_SESSION = GoogleDrive::Session.from_service_account_key(ENV['GOOGLE_SERVICE_ACCOUNT_KEY'])
  SERVICE = Google::Apis::SheetsV4::SheetsService.new
  SERVICE.authorization = GOOGLE_SESSION.drive.request_options.authorization
  COLUMNS = ["Магазин", "ID товара", "Наименование", "Артикул", "Размер", "Номер заказа", "Менеджер", "Статус обработки"]
  WORKSHEET_TITLE = "Товары"

  def perform(args = {})
    spreadsheet = GOOGLE_SESSION.spreadsheet_by_title("Список товаров для сборки") || create_new_spreadsheet
    worksheet = spreadsheet.worksheet_by_title(WORKSHEET_TITLE) || spreadsheet.worksheets.first
    order_products = OrderProduct.where(order: Order.where(status: 1, delayed: false))
    op_hash = {}
    order_products.each do |op|
      shop_name = Item.where(product_id: op.product_id, size: op.size).exclude(quantity: 0).first&.shop&.name
      shop_name = op.item_location if shop_name.to_s.empty?
      shop_name = op.product&.item_location if shop_name.to_s.empty?
      values = {
        "Магазин" => shop_name,
        "ID товара" => op.id,
        "Наименование" => "=HYPERLINK(\"https://lsboutique.ru/products/#{op.product_id}/\",\"#{op.product_name.gsub('"', "'")}\")",
        "Артикул" => op.sku,
        "Размер" => op.size,
        "Номер заказа" => op.order_id,
        "Менеджер" => op.order&.manager&.name
      }
      op_hash[op.id] = values
    end

    existing_rows = worksheet.list.to_hash_array.map do |row|
      item = op_hash.delete(row["ID товара"].to_i) || next
      item["Статус обработки"] = row["Статус обработки"]
      op = OrderProduct[item["ID товара"]]
      op&.update(process_status: item["Статус обработки"])
      item
    end.compact
    clear_worksheet(worksheet) unless worksheet.num_rows == 1
    worksheet.reload

    existing_rows.each {|r| worksheet.list.push r}
    op_hash.values.each {|r| worksheet.list.push r}
    worksheet.save
    update_dimensions(worksheet) if existing_rows.empty?

    emails = args['emails'] || ["lsboutique.ru@gmail.com", "megacuba@gmail.com"]
    emails.each do |email|
      subbed_emails = []
      for entry in spreadsheet.acl
        subbed_emails.push entry.email_address
      end
      spreadsheet.acl.push({type: "user", email_address: email, role: "writer"}) unless subbed_emails.include?(email)
    end
  end

  def clear_worksheet(ws)
    req = {delete_dimension: {range: {sheet_id: ws.gid, dimension: "ROWS", start_index: 1, end_index: ws.num_rows}}}
    SERVICE.batch_update_spreadsheet(ws.spreadsheet.id, {requests: [req]}, {})
  end

  def update_dimensions(ws)
    requests = [
      {auto_resize_dimensions: {dimensions: {sheet_id: ws.gid, dimension: "COLUMNS", start_index: 0, end_index: 7}}},
      {update_dimension_properties: {range: {sheet_id: ws.gid, dimension: "COLUMNS", start_index: 7, end_index: 8}, properties: {pixel_size: 400}, fields: 'pixelSize'}}
    ]
    SERVICE.batch_update_spreadsheet(ws.spreadsheet.id, {requests: requests}, {})
  end

  def create_new_spreadsheet
    spreadsheet = GOOGLE_SESSION.create_spreadsheet("Список товаров для сборки")
    worksheet = spreadsheet.worksheets.first
    worksheet.title = WORKSHEET_TITLE
    worksheet.update_cells(1, 1, [COLUMNS])
    worksheet.save
  end

end
