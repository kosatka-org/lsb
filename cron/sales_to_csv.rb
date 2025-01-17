# encoding: utf-8
require './models'

filename = "sales.csv"

prodazhi = DB[:prodazhi].where{p_date > Date.today-365}
if ARGV[0]
  prodazhi = prodazhi.where(location: ARGV[0].split(','))
end
if ARGV[1]
  prodazhi = prodazhi.where(brand: ARGV[1].split(','))
end
users = prodazhi.where(:user_id).map(:user_id).uniq

File.open(filename,"w:utf-8") do |file|
  file.puts "﻿ФИО;Телефон;Дата последней покупки;Покупки"
  # sales.each do |brand, sales_array|
    # users = sales_array.map {|i| i[:user_id]}.uniq.compact
    users.each do |u_id|
      user = DB[:users][user_id: u_id] || next
      next if user[:name].empty? || user[:phone_number].empty?
      last_date = prodazhi.where(user_id: u_id).order(:p_date).last[:p_date].strftime("%d.%m.%Y")
      last_sales = prodazhi.where(user_id: u_id).map(:model).reverse.first(5).join(", ")
      file.puts "#{user[:name]};#{user[:phone_number]};#{last_date};#{last_sales}"
    end
  # end
end
