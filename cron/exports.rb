# encoding: utf-8
require './db_connect.rb'
require './s3_class.rb'

clients = DB[:users]

filename = "card_numbers.csv"
File.open(filename,"w:utf-8") do |tr|
  tr.puts "Номер карты"

	clients.where(:card_number).each do |client|
		tr.puts client[:card_number]
	end
end
S3Wrapper.new.put(filename)
File.delete(filename)

filename = "users_list.csv"
File.open(filename,"w:utf-8") do |tr|
  tr.puts "Имя клиента;Email;OriginalUserId"
  clients.where('user_id = original_user_id').exclude(name: "").each do |client|
    tr.puts "#{client[:name]};#{client[:email]};#{client[:original_user_id]}"
  end
end
S3Wrapper.new.put(filename)
File.delete(filename)

filename = "userid_card.csv"
File.open(filename,"w:utf-8") do |tr|
  tr.puts "OriginalUserId;Номер карты"
  clients.where('user_id = original_user_id').where(:card_number).exclude(name: "").each do |client|
    tr.puts "#{client[:original_user_id]};#{client[:card_number]}"
  end
end
S3Wrapper.new.put(filename)
File.delete(filename)
