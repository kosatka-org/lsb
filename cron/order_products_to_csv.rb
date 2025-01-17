require './models.rb'

filename = "../order_products.csv"

File.open(filename,"w:utf-8") do |file|
  file.puts "Дата получения;Город;Имя клиента;Номер накладной;Количество мест;Артикул;Наименование;Размер;Цена;Комментарии"
  OrderProduct.where(status: 5).where{status_date > Date.new(2015)}.where{status_date < Date.new(2016)}.order(:order_id).each do |product|
      order = product.order
      number_of_products = order.order_products_dataset.where(status: 5).count
      comments = order.order_comments_dataset.map(:text).join("||")
      file.puts "#{product.status_date};#{order.city};#{order.name};#{order.invoice_number};#{number_of_products};#{product.sku};#{product.product_name};#{product.size};#{product.price};\"#{comments}\""
  end
end
