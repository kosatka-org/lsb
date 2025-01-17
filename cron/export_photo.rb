# encoding: utf-8
require './db_connect.rb'
require './s3_class.rb'
require './error_service.rb'

filename = "photo_import.csv"

products = DB[:products].exclude(:large_image => '')

File.open(filename,"w:utf-8") do |file|
  file.puts "﻿Код товара;URL фотографии"
  products.all.each do |item|
    next if !item[:code] || item[:large_image].start_with?("h")
    file.puts "#{item[:code]};https://lsboutique.ru/files/products/#{item[:large_image]}"
  end
end

# Upload to S3 and delete temp file
S3Wrapper.new.put(filename)
File.delete(filename)
