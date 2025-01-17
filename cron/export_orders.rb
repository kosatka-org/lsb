# encoding: utf-8
require './db_connect.rb'
require './models.rb'
require './s3_class.rb'
require './error_service'

filename = "order_import.csv"
t1 = Time.now

orders = Order.where( status: [2,6] ).where{ date > Date.new(2014,12,1) }
File.open(filename,"w:utf-8") do |file|
  orders.each do |o|
    file.puts "[header]\n"
    data = [ o.order_id,
      o.date.strftime('%d.%m.%Y'),
      o.order_products.map(&:price).reduce(:+),
      o.user_id,
      o.user && o.user.code,
      o.delivery_company && o.delivery_company.name,
      o.payment_method && o.payment_method.name,
      o.comment ]
    file.puts data.join(";")+";\n"
    file.puts "[body]\n"
    o.order_products.each do |order_item|
      p = order_item.product
      next unless p
      file.puts "#{p.code};#{p[:model]};#{order_item.size};#{order_item.price};"
    end
  end
end

# Upload to S3 and delete temp file
S3Wrapper.new.put(filename)
File.delete(filename)

puts "successfully exported #{orders.count} orders"
puts "operation took #{Time.now-t1} seconds"
