require './models'
require './s3_class'
require './email_class'
require './error_service'

parsed_date = if ARGV[0]
  Date.parse(ARGV[0].to_s)
else
  Date.today
end

filename = "offline_sales_#{parsed_date}.csv"
File.open(filename, "w:utf-8") do |file|
  file.puts "Код1с;Артикул;Номенкулатура;Характеристика номенкулатуры;Сумма;Дата;Время;Номер заказа;Клиент;Название кассы;ID кассы;Номер чека;Штрихкод"
  mtm_cashbox = Cashbox.where(name: "Индивидуальный пошив").first
  service_cashbox = Cashbox.where(name: "Услуги").first
  OrderProduct.where(order: Order.where(status: 5).where(date: parsed_date...parsed_date+1).exclude(cashbox_id: 0).exclude(cashbox: [mtm_cashbox, service_cashbox])).each do |op|
    size_color = "#{op.size}, #{op.product&.color&.name}" rescue ''
    order = op.order
    cashbox = order&.cashbox || next
    barcode = op.barcode.empty? ? op.guess_barcode : op.barcode
    file.puts [
      op.product&.code,
      op.sku.strip,
      op.product_name,
      size_color,
      op.price,
      order.date.to_date,
      order.date,
      op.order_id,
      order.user&.name,
      cashbox.name,
      cashbox.id,
      order.receipt_number,
      barcode
    ].join(";").gsub(/[\r\n]/, "")
  end
end

if ENV['ENVIRONMENT'] == 'production'
  S3Wrapper.new.put(filename)
  File.delete(filename)
  Item.dataset.update(do_not_update: false)
end
