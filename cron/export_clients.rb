# encoding: utf-8
require './db_connect.rb'
require './s3_class.rb'
require './error_service.rb'

t1 = Time.now

clients = DB[:users]

filename = "pokupateli_import.csv"

File.open(filename,"w:utf-8") do |tr|
  tr.puts "Имя;Фамилия;Дата рождения;Домашний адрес;Телефон;Электронная почта;Размеры;Номер карты;Дата регистрации карты;Сумма покупок;Личная скидка;OriginalUserId;Код1С"
  clients.all.each do |client|
    next unless client[:original_user_id] == client[:user_id]
    p ={}
    if a = client[:name]
      a = a.split(" ",2)
      p[:name] = a[0]
      p[:surname] = a[1]
    end
    p[:birth_date] = client[:birth_date]
    p[:adress] = ""
    p[:adress] = "#{client[:city]}, " if client[:city] && client[:city] != ""
    p[:adress] = p[:adress]+client[:adress] if client[:adress]
    p[:phone] = client[:phone_number].gsub(/\D/,'') if client[:phone_number]
    p[:email] = client[:email]
    if client[:clothing_size] && !client[:clothing_size].empty?
      p[:sizes] = client[:clothing_size]
    elsif client[:shoe_size] && !client[:shoe_size].empty?
      p[:sizes] = client[:shoe_size]
    end
    p[:sizes] = "#{client[:clothing_size]}, #{client[:shoe_size]}" if client[:clothing_size] && !client[:clothing_size].empty? && client[:shoe_size] && !client[:shoe_size].empty?
    p[:card] = client[:card_number]
    p[:registered] = client[:card_registered]
    p[:purchase_sum] = client[:purchase_sum] if client[:purchase_sum] && client[:purchase_sum].to_i > 0
    p[:personal_discount] = client[:personal_discount] if client[:personal_discount] > 0
    p[:original_user_id] = client[:original_user_id]
    p[:code] = client[:code] if client[:code] != 0

    p.each do |k,v|
      p[k] = v.gsub(";",",") if v && v.respond_to?(:gsub)
    end
    tr.puts "#{p[:name]};#{p[:surname]};#{p[:birth_date]};#{p[:adress]};#{p[:phone]};#{p[:email]};#{p[:sizes]};#{p[:card]};#{p[:registered]};#{p[:purchase_sum]};#{p[:personal_discount]};#{p[:original_user_id]};#{p[:code]}".gsub(/[\n\r]/,"")
  end
end

# Upload to S3 and delete temp file
S3Wrapper.new.put(filename)
File.delete(filename)

#puts "successfully updated #{updated} items"
puts "operation took #{Time.now-t1} seconds"
