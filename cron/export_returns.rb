require './models'
require './s3_class'
require './error_service'

parsed_date = if ARGV[0]
  Date.parse(ARGV[0].to_s)
else
  Date.today
end

filename = "returns_#{parsed_date}.csv"
File.open(filename, "w:utf-8") do |file|
  file.puts "ID возврата;Склад;Название кассы;ID кассы;Штрихкод;Цена;Дата"
  OrderProduct.where(
    order: Order.where(status: 5).exclude(cashbox_id: 0),
    status: 4,
    status_date: parsed_date
  ).each do |op|
    order = op.order
    cashbox = order.cashbox || next
    warehouse = cashbox.shop.warehouses.first || {name: "Склад"}
    file.puts [
      op.id,
      warehouse[:name],
      cashbox.name,
      cashbox.id,
      op.barcode,
      op.price,
      op.status_date,
    ].join(";")
  end
end

if ENV['ENVIRONMENT'] == 'production'
  S3Wrapper.new.put(filename)
  File.delete(filename)
end
