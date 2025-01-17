require 'smarter_csv'
require "./db_connect"
require "./models"

filename = "201601180401.csv"
File.open(filename, "w:utf-8") { |f| f.write S3Wrapper.new.get(filename) }
data = File.open(filename, "r:bom|utf-8") do |f|
  SmarterCSV.process(f, col_sep: ';', quote_char: '𝝻')
end

data.each do |r|
  product = Product.where(code: r[:Код]).first
  next unless product
  price = r[:Цена]
  unless price.to_i == product.price.to_i
    product.add_price_change(old_price: price.to_f, new_price: product.price)
  end
end