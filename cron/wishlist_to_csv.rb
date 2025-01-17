# encoding: utf-8
require './db_connect.rb'

filename = "wishlist.csv"

wishlist = DB[:users2wishlist]

sales = wishlist.all.group_by {|i| i[:user_id]}

File.open(filename,"w:utf-8") do |file|
  file.puts "﻿ФИО;Телефон;Товары в вишлисте"
  sales.each do |user_id, wl_array|
      user = DB[:users][user_id: user_id] || next
      next if user[:name].empty? || user[:phone_number].empty?
      wl_items = DB[:products].where(product_id: wl_array.map{|wl| wl[:product_id]} ).all.map {|prod| prod[:model]}.join("; ")
      file.puts "#{user[:name]};#{user[:phone_number]};#{wl_items}"
  end
end
