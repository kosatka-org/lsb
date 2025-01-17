# encoding: utf-8
require './db_connect.rb'
require './models.rb'

filename = "sales.csv"

# users = User.where(shop: "Ramsey").where{card_registered > Time.new(2015,10,1)}.all
users = User.where(offline_sales: OfflineSale.where{p_date > (Date.today - 180)})

File.open(filename,"w:utf-8") do |file|
  file.puts "ФИО;Телефон;Дата последней покупки;Покупки"
  users.each do |user|
      sales = user.offline_sales
      last_date, last_sales =
        sales.last.date, sales.map {|p| p[:model] }.take(5) unless sales.empty?
      file.puts "#{user.name};#{user.phone_number};#{last_date};#{last_sales}"
  end
end
