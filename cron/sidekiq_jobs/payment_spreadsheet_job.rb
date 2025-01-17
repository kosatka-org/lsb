require 'google/apis/sheets_v4'
require 'google_drive'

Google::Apis::RequestOptions.default.retries = 5

class PaymentSpreadsheetJob
  include Sidekiq::Worker
  GOOGLE_SESSION = GoogleDrive::Session.from_service_account_key(ENV['GOOGLE_SERVICE_ACCOUNT_KEY'])
  SERVICE = Google::Apis::SheetsV4::SheetsService.new
  SERVICE.authorization = GOOGLE_SESSION.drive.request_options.authorization
  SPREADSHEET = GOOGLE_SESSION.spreadsheet_by_title("Отчёт по приёму денег") || GOOGLE_SESSION.create_spreadsheet("Отчёт по приёму денег")

  def perform(args = {})
    date_from = args['date_from'] ? Date.parse(args['date_from']) : Date.today-1
    order_products = OrderProduct.where(status: 5).filter_by_year_month(status_date: date_from)

    payment_methods = Order.where(order_products: order_products).map(&:payment_method).compact.uniq.map(&:name)
    @columns = ["Дата", "Номер заказа", "Товары"] + payment_methods + ["Предоплата", "Способ предоплаты", "Депозит", "Сумма"]

    worksheet_title = date_from.strftime("%m/%Y")
    worksheet = SPREADSHEET.worksheet_by_title(worksheet_title) || SPREADSHEET.add_worksheet(worksheet_title)
    # if worksheet.num_rows == 0
      worksheet.update_cells(1, 1, [@columns])
      worksheet.save
    # end
    clear_worksheet(worksheet) if worksheet.num_rows > 1
    worksheet.reload

    Order.where(order_products: order_products).each do |order|
      accepted_products = order.order_products_dataset.where(status: 5)
      sum = accepted_products.sum(:price)
      payment_amount = sum - order.payment_prepaid - order.deposit_payment
      payment_method = order&.payment_method&.name || payment_methods.first
      values = {
        "Дата" => accepted_products.first.status_date.to_s,
        "Номер заказа" => "=HYPERLINK(\"https://lsboutique.ru/admin/index.php?section=Order&order_id=#{order.order_id}\",\"#{order.order_id}\")",
        "Товары" => accepted_products.to_a.map {|op| "#{op.product_name}: #{op.price}"}.join("\n"),
        "Предоплата" => order.payment_prepaid.to_s,
        "Способ предоплаты" => PaymentMethod[order.prepaid_method_id]&.name.to_s,
        "Депозит" => order.deposit_payment.to_s,
        "Сумма" => sum
      }
      values[payment_method] = [payment_amount, 0].max
      worksheet.list.push values
    end
    worksheet.save
    update_dimensions(worksheet)

    emails = args['emails'] || ["lsboutique.ru@gmail.com", "megacuba@gmail.com"]
    emails.each do |email|
      subbed_emails = []
      for entry in SPREADSHEET.acl
        subbed_emails.push entry.email_address
      end
      SPREADSHEET.acl.push({type: "user", email_address: email, role: "writer"}) unless subbed_emails.include?(email)
    end
  end

  def clear_worksheet(ws)
    req = {delete_dimension: {range: {sheet_id: ws.gid, dimension: "ROWS", start_index: 1, end_index: ws.num_rows}}}
    SERVICE.batch_update_spreadsheet(ws.spreadsheet.id, {requests: [req]}, {})
  end

  def update_dimensions(ws)
    requests = [
      {auto_resize_dimensions: {dimensions: {sheet_id: ws.gid, dimension: "COLUMNS", start_index: 0, end_index: @columns.size-1}}},
      # {update_dimension_properties: {range: {sheet_id: ws.gid, dimension: "COLUMNS", start_index: 7, end_index: 8}, properties: {pixel_size: 400}, fields: 'pixelSize'}}
    ]
    SERVICE.batch_update_spreadsheet(ws.spreadsheet.id, {requests: requests}, {})
  end

end
