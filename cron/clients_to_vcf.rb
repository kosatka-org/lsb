require_relative "db_connect"
require_relative "models"

File.open("clients.vcf", "w:utf-8") do |file|
  User.exclude(phone_number: '').where(group_id: 1).each do |user|
    file.puts "BEGIN:VCARD"
    file.puts "VERSION:3.0"
    file.puts "FN:#{user.name}"
    split_name = (user.name.split.reverse.join(" ")+" ").sub(/ /, ";").strip
    file.puts "N:#{split_name};;;"
    file.puts "TEL;TYPE=CELL:#{user.phone_number}"
    file.puts "END:VCARD"
  end
end
