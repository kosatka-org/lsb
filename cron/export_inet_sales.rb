require './models'
require './s3_class'
require './email_class'
require './error_service'

EXPORTS = [
  {name: "internet_sales", products: OrderProduct.accepted},
  {name: "internet_returns", products: OrderProduct.returned}
]

if ARGV[0]
  date = Date.parse(ARGV[0])
else
  date = Date.today
end

EXPORTS.each do |params|
  filename = "#{params[:name]}_#{date}.csv"
  File.open(filename, "w:utf-8") do |file|
    file.puts "Код1с;Артикул;Номенкулатура;Характеристика номенкулатуры;Сумма;Дата;Номер заказа;Клиент;Транспортная компания;Штрихкод"
    params[:products].where(status_date: date).each do |op|
      size_color = "#{op.size}, #{op.product&.color&.name}"
      barcode = op.barcode.empty? ? op.guess_barcode : op.barcode
      delivery_company = op.order&.delivery_company
      file.puts [
        op.product&.code,
        op.sku.strip,
        op.product_name,
        size_color,
        op.price,
        op.status_date,
        op.order_id,
        op.order&.name,
        delivery_company&.name,
        barcode
      ].join(";")
    end
  end
  S3Wrapper.new.put(filename)
  File.delete(filename)
end
