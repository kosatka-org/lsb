require './models'
require './error_service'
require 'google/apis/sheets_v4'
require 'google_drive'
require 'trello'
require 'pry'

@client = Trello::Client.new(
  developer_public_key: ENV['TRELLO_DEVELOPER_KEY'],
  member_token: ENV['TRELLO_MEMBER_TOKEN']
)

Google::Apis::RequestOptions.default.retries = 5
session = GoogleDrive::Session.from_service_account_key(
"Obed Store-ba61875be7e3.json")


PLUGIN_KEYS = {
  'D9kNacB6-d1eLwW' => 'partner_email',
  'D9kNacB6-RdZ5EL' => 'partner_rate'
}

def find_or_create_ws(spreadsheet, title, fields)
  ws = spreadsheet.worksheet_by_title(title)
  return ws if ws
  ws = spreadsheet.add_worksheet(title)
  ws.update_cells(1, 1, [fields])
  ws.synchronize
  ws
end

@d_points = Hash.new
d_board = @client.find(:board, ENV['BAU_DELIVERY_BOARD'])
d_board.cards.each do |card|
  next if @d_points[card.name] || card.plugin_data.empty?
  p_data_fields = card.plugin_data.first.value['fields']
  p_data_fields.keys.each do |k|
    p_data_fields[PLUGIN_KEYS[k]] = p_data_fields.delete(k) if PLUGIN_KEYS[k]
  end
  @d_points[card.name] = p_data_fields
end
@partner_emails = @d_points.values.select {|i| i['partner_rate'].to_i > 0}
  .map {|v| v['partner_email'] }.compact.uniq

@separate_delivery = {}
separate_delivery_board = @client.find(:board, ENV['BAU_SEPARATE_DELIVERY_BOARD'])
separate_delivery_board.cards.each do |card|
  @separate_delivery[card.name] = card.desc
end

today = Date.today
date = (today.wday == 5) ? today+3 : today.next_day
date = Date.parse(ARGV[1].to_s) if ARGV[1]
@nc = (ARGV[0] == 'nc') ? true : false
@weekly = (ARGV[0] == 'weekly') ? true : false

@coupon_domains = ["mim", "img", "img1"]

emails = ARGV[2..-1]
if emails.to_a.empty?
  emails = ["sonicdes@gmail.com", "order@obed.store", "megacuba@gmail.com", "mts@edok.ru", "human@kasatik.com"]
end

date_str = date.strftime("%d.%m.%Y")
spreadsheet = session.create_spreadsheet("#{date_str} - производство #{'NC' if @nc}") unless @weekly
if @weekly
  order_spreadsheet = session.create_spreadsheet("#{(date-4).strftime("%d.%m.%Y")}-#{date.strftime("%d.%m.%Y")} - заказы IMG за неделю")
else
  order_spreadsheet = session.create_spreadsheet("#{date_str} - заказы #{'NC' if @nc}")
end

all_orders_ws = order_spreadsheet.worksheets[0]
all_orders_ws.title = 'Все заказы'
all_orders_ws.save
order_fields = ["Дата", "Пункт выдачи", "Номер заказа", "Email", "Заказ", "Сумма", "Статус оплаты"]
partner_fields = order_fields + ["Комиссия", "Сумма с учетом комиссии"]
all_orders_ws.update_cells(1, 1, [order_fields])
unless @weekly
  separate_delivery_ws = find_or_create_ws(order_spreadsheet, "Отдельная доставка", order_fields)
end
@partner_spreadsheets = {}
@partner_emails.each do |pe|
  ps = session.create_spreadsheet("#{date_str} - заказы #{pe}")
  find_or_create_ws(ps, "Заказы партнера", partner_fields)
  @partner_spreadsheets[pe] = ps
end
@order_worksheets = {}

ii = {}
b_orders = BauOrder.where(delivery_date: date, enabled: 1)
if @nc
  b_orders = b_orders.where(domain: 'nc')
elsif @weekly
  b_orders = BauOrder.where(delivery_date: (date-4...date+1), enabled: 1, domain: ['img', 'img1'])
  sums = {'img' => {total: 0, with_coupon: 0}, 'img1' => {total: 0, with_coupon: 0}}
else
  b_orders = b_orders.exclude(domain: 'nc')
end
b_orders.each do |o|
  card = @client.find(:card, o.card_id) rescue nil
  if !card || card.closed?
    next
  end

  dp = o.delivery_point
  items = JSON.parse o.items
  sum = items.reduce(0) {|sum,i| sum += (i['price'].to_i * i['quantity'].to_i)}
  order_values = {
    "Дата" => o.delivery_date.strftime("%Y.%m.%d"),
    "Пункт выдачи" => dp,
    "Номер заказа" => o.order_number,
    "Email" => o.email,
    "Заказ" => items.map {|i| "#{i['quantity']}X #{i['name']}"}.join("\n"),
    "Сумма" => sum,
    "Статус оплаты" => (o.paid ? "Оплачен" : "Не оплачен")
  }
  all_orders_ws.list.push(order_values)
  if dp_data = @d_points[dp]
    rate = dp_data['partner_rate'].to_i / 100.0
    if dp_data['partner_rate'].to_i > 0
      ps = @partner_spreadsheets[dp_data['partner_email']]
      if o.email == dp_data['partner_email']
        p_ws = find_or_create_ws(ps, "Заказы партнера", partner_fields)
      else
        p_ws = find_or_create_ws(ps, dp, partner_fields)
      end
      p_ws.list.push order_values.merge({"Комиссия" => sum*rate, "Сумма с учетом комиссии" => sum*(1 - rate)})
    elsif o.email != dp_data['partner_email']
      p_ws = find_or_create_ws(order_spreadsheet, dp, order_fields)
      p_ws.list.push order_values
    else
      p_ws = find_or_create_ws(order_spreadsheet, "Заказы #{dp_data['partner_email']}", order_fields)
      p_ws.list.push order_values
    end
    p_ws.synchronize
  else
    dp = o.domain if @weekly
    order_ws = @order_worksheets[dp]
    unless order_ws
      fields = @coupon_domains.include?(o.domain) ? order_fields + ["Сумма с учетом талона"] : order_fields
      order_ws = find_or_create_ws(order_spreadsheet, dp, fields)
      @order_worksheets[dp] = order_ws
    end
    if @coupon_domains.include?(o.domain)
      sum_with_coupon = (sum-50) > 0 ? (sum-50) : 0
      if @weekly
        sums[dp][:total] += sum
        sums[dp][:with_coupon] += sum_with_coupon
      end
      order_values.merge!({"Сумма с учетом талона" => sum_with_coupon})
    end
    if @separate_delivery[o.email]
      order_values["Пункт выдачи"] = @separate_delivery[o.email]
      order_ws = separate_delivery_ws
    end
    order_ws.list.push(order_values)
    order_ws.save
  end

  items.each do |i|
    q = (ii[i['name']] || 0) + i['quantity']
    ii[i['name']] = q
  end
end
all_orders_ws.save

if @weekly
  @order_worksheets.each do |dp, ws|
    next unless ["img", "img1"].include? dp
    ws.list.push({
      "Дата" => '',
      "Пункт выдачи" => '',
      "Номер заказа" => '',
      "Email" => '',
      "Заказ" => '',
      "Сумма" => sums[dp][:total],
      "Сумма с учетом талона" => sums[dp][:with_coupon],
      "Статус оплаты" => ''
      })
    ws.save
  end
end

unless @weekly
  ws = spreadsheet.worksheets[0]
  ws[1, 1] = "Наименование"
  ws[1, 2] = "Количество"
  ii.each do |name, q|
    ws.list.push({"Наименование" => name, "Количество" => q})
  end
  ws.save
end

service = Google::Apis::SheetsV4::SheetsService.new
service.authorization = session.drive.request_options.authorization

[order_spreadsheet, *@partner_spreadsheets.values].each do |ss|
  requests = []
  ss.worksheets.each do |w|
    requests.push({
      auto_resize_dimensions:
      {
        dimensions:
        {
          sheet_id: w.gid,
          dimension: "COLUMNS",
          start_index: 0,
          end_index: 8
        }
      }
    })
  end
  service.batch_update_spreadsheet(ss.id, {requests: requests}, {})

  requests = []
  ss.worksheets.each do |w|
    requests.push({
      repeat_cell: {
        range: {sheet_id: w.gid, start_column_index: 1, end_column_index: 2},
        cell: {user_entered_format: {wrap_strategy: 'WRAP'}},
        fields: 'userEnteredFormat.wrapStrategy'
      }
    })
    requests.push({
      repeat_cell: {
        range: {sheet_id: w.gid, start_column_index: 4, end_column_index: 5},
        cell: {user_entered_format: {wrap_strategy: 'WRAP'}},
        fields: 'userEnteredFormat.wrapStrategy'
      }
    })
  end
  service.batch_update_spreadsheet(ss.id, {requests: requests}, {})

  requests = []
  ss.worksheets.each do |w|
    wgid = w.gid
    requests.push({
      update_dimension_properties:
      {
        range:
        {
          sheet_id: wgid,
          dimension: "COLUMNS",
          start_index: 1,
          end_index: 2
        },
        properties: {pixel_size: 400},
        fields: 'pixelSize'
      }
    })
    requests.push({
      update_dimension_properties:
      {
        range:
        {
          sheet_id: wgid,
          dimension: "COLUMNS",
          start_index: 4,
          end_index: 5
        },
        properties: {pixel_size: 600},
        fields: 'pixelSize'
      }
    })
  end
  service.batch_update_spreadsheet(ss.id, {requests: requests}, {})
end

emails.each do |email|
  unless @weekly
    spreadsheet.acl.push({type: "user", email_address: email, role: "writer"})
  end
  order_spreadsheet.acl.push({type: "user", email_address: email, role: "writer"})
  @partner_spreadsheets.select! {|_, ps| ps.worksheets.find {|ws| ws.num_rows > 1}}
  @partner_spreadsheets.each do |partner_email, ps|
    ps.acl.push({type: "user", email_address: email, role: "writer"})
  end
end
