#encoding: utf-8
require './db_connect.rb'
require 'date'
require 'csv'

if ARGV[0]
  filename = ARGV[0]
else
  filename = "calls.csv"
end

in_calls = DB[:users_calls_incoming]
crm = DB[:users_crm]
users = DB[:users]

months = {"янв."=>"Jan", "фев."=>"Feb", "мар."=>"Mar", "апр."=>"Apr", "май."=>"May", "июн."=>"Jun", "июл."=>"Jul", "авг."=>"Aug", "сен."=>"Sep", "окт."=>"Oct", "ноя."=>"Nov", "дек."=>"Dec"}
file = File.read(filename, encoding: "windows-1251:utf-8")

file.gsub!(/\W{3}\./, months).gsub(/\n\n/, "\n")

csv = CSV.parse(file, col_sep: ";", headers: true)

csv.each do |row|
	phone = row["От кого"]
	date = DateTime.parse(row["Дата"])
	dur = row["Длительность"].to_i
	in_calls.insert(date: date, phone: phone, duration: dur)


	if u = users[phone_number: /#{phone[1..-1]}/]
		text = "#{u['name']} совершил звонок длительностью #{dur} секунд"
    unless crm[date: date]
		  crm.insert(user_id: u['user_id'], type: 'call', subject: text, text: text, date: date)
    end
	end
	
end

puts "OK"