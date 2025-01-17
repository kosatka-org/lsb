# encoding: utf-8
require './db_connect.rb'
require './error_service'
require './s3_class.rb'
require './models.rb'
require 'csv'

filename = "Pokup_export.csv"
updated = 0

CSV.parse(S3Wrapper.new.get(filename), headers: true, col_sep: ";", quote_char: "\x00") do |li|
  if li['Код1С'].to_i != 0 && li['OriginalUserID'].to_i != 0
    DB[:users].where(user_id: li['OriginalUserID'].to_i).update(code: li['Код1С'].to_i)
    updated += 1
  end
end

puts "updated #{updated} users"

# puts clients.size.to_s+" records fetched"

# clients.collect! do |i|
#   y = i.split(";")
#   birthdate = Date.parse(y[2]) rescue nil
#   card_date = Date.parse(y[8]) rescue nil
#   { :email      => y[5],
#     :group_id   => 1,
#     :name       => y[0..1].join(" "),
#     :enabled    => 1,
#     :size       => y[6],
#     :cardno     => y[7].strip,
#     :phone      => y[4].gsub(/[^\s\d]+/,"").strip,
#     :adress     => y[3],
#     :birth      => birthdate,
#     :card_date  => card_date,
#     :purchases  => y[9].gsub(/[^\d]/,'').to_i,
#     :discount   => y[10].to_i,
#     :code       => y[11].to_i,
#     :orig_user_id => y[12].to_i }
# end

# users    = DB[:users]      #set up the dataset

# cards = users.map(:card_number).uniq
# codes = users.map(:code).uniq

# email_body = ""
# updated = 0
# clients.each do |cl|
#   next if codes.include?(cl[:code])
#   if cards.include?(cl[:cardno])
#     s = users.insert(
#       :order_email     => cl[:email],
#       :group_id        => cl[:group_id],
#       :name            => cl[:name],
#       :enabled         => cl[:enabled],
#       :clothing_size   => cl[:size],
#       :phone_number    => cl[:phone],
#       :adress          => cl[:adress],
#       :birth_date      => cl[:birth],
#       :card_registered => cl[:card_date],
#       :purchase_sum    => cl[:purchases],
#       :code            => cl[:code]
#     )
#   else
#     s = users.insert(
#       :order_email     => cl[:email],
#       :group_id        => cl[:group_id],
#       :name            => cl[:name],
#       :enabled         => cl[:enabled],
#       :clothing_size   => cl[:size],
#       :card_number     => cl[:cardno],
#       :phone_number    => cl[:phone],
#       :adress          => cl[:adress],
#       :birth_date      => cl[:birth],
#       :card_registered => cl[:card_date],
#       :purchase_sum    => cl[:purchases],
#       :code            => cl[:code]
#     )
#   end

#   if s>0
#     updated += 1
#     email_body += "\nПользователь с именем #{cl[:name]}, код 1С #{cl[:code]}, телефон #{cl[:phone]}"
#   end

# end

# if updated > 0
#   mail = Mail.new do
#     to      'sonicdes@gmail.com'
#     cc      'mail@lsboutique.ru'
#     from    'no-reply@lsboutique.ru'
#     subject "Импортированы клиенты"
#     body    email_body
#   end

#   mail.delivery_method :smtp, :openssl_verify_mode  => "none", :enable_starttls_auto => false
#   mail.deliver!
# end

# puts "successfully updated #{updated} items"
# puts "operation took #{Time.now-t1} seconds"
