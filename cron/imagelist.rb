# -*- encoding: utf-8 -*-
require 'net/http'
require 'fileutils'
require 'mail'
require 'net/ftp'
require './db_connect.rb'

products    = DB[:products]      #set up the dataset
brands      = DB[:brands]

date=Date.today
list = products.where("created > '#{date-7} 00:00:00' AND large_image != '' AND size != ''").all
puts list.length
Dir.chdir("images")
  list.each do |item|
    col = DB[:colors][:color_id => item[:color_id]][:name].gsub("/","")
    br  = brands[:brand_id => item[:brand_id]][:name]
    FileUtils.mkdir(br) unless Dir.exist?(br)
    Net::HTTP.start("www.lsboutique.ru") do |http|
      resp = http.get("/files/products/#{item[:large_image]}")
      open("#{br}/#{item[:url].gsub(/\//,'')+col}.jpg", "wb") do |file|
          file.write(resp.body)
      end
    end
  end
Dir.chdir("..")
`export LANG=ru_RU.UTF-8 && 7za a images#{date}.zip images/*`
`rm -r images/*`

while File.mtime("export.csv").to_s == "2013-05-20 13:01:41 +0400"
  sleep 180
end

mail = Mail.new do
  to   	  'sonicdes@gmail.com'
  from    'no-reply@lsboutique.ru'
  subject "Обновились"
  body    "Пришла новая выгрузка!" 
end

mail.delivery_method :smtp, :openssl_verify_mode  => "none", :enable_starttls_auto => false
mail.deliver!

`rm images#{date}.zip`
puts "Done!"
