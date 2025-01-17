require './models'
require './error_service'
require 'google_drive'

session = GoogleDrive::Session.from_service_account_key(
  "Obed Store-ba61875be7e3.json")

today = Date.today
end_date = Date.new(today.year, today.month)
start_date = end_date.prev_month

period_str = start_date.strftime("%Y.%m")
spreadsheet = session.create_spreadsheet("Отчёт obed.store #{period_str}")
main_ws = spreadsheet.worksheets[0]
main_ws.title = "Всего за месяц"
main_ws.update_cells(1, 1, [["Дата", "Сумма"]])

total_sum = (start_date..end_date).map do |date|
  orders = BauOrder.where(delivery_date: date, enabled: 1)
  next if orders.count == 0

  ws = spreadsheet.add_worksheet(date.to_s)
  ws.update_cells(1, 1, [["Номер заказа", "Пункт выдачи", "Заказ", "Сумма"]])

  day_sum = orders.all.map do |o|
    items = JSON.parse o.items
    sum = items.map {|i| i['price'].to_i * i['quantity'].to_i }.reduce(:+)
    ws.list.push({
      "Номер заказа" => o.order_number,
      "Пункт выдачи" => o.delivery_point,
      "Заказ" => items.map {|i| "#{i['name']} X#{i['quantity']}"}.join("\n"),
      "Сумма" => sum
    })
    sum
  end.reduce(:+)
  ws.save

  main_ws.list.push({"Дата" => date.to_s, "Сумма" => day_sum})
  day_sum
end.compact.reduce(:+)

main_ws.list.push({"Дата" => "Всего за месяц", "Сумма" => total_sum})
main_ws.save

["sonicdes@gmail.com", "order@obed.store", "megacuba@gmail.com"].each do |email|
  spreadsheet.acl.push({type: "user", email_address: email, role: "writer"})
end
