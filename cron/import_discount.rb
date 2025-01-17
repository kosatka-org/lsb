# encoding: utf-8
require 'set'
require './db_connect.rb'
require './s3_class.rb'
require './error_service'

t1 = Time.now

discounts = Set.new
S3Wrapper.new.get_all_with_prefix("Discount_").each.to_a.last.get.body.read.force_encoding("utf-8").each_line.each_with_index { |li,i| next if i == 0; discounts.merge([li]) if li.split(";")[0] != "" }

puts discounts.size.to_s+" records fetched"

discounts.collect! do |i|
  y = i.split(";")
  date = DateTime.parse(y[3]) rescue nil
  { :card_number  => y[0],
    :name         => y[1],
    :lastname     => y[2],
    :date         => date,
    :sku          => y[4],
    :value        => y[5].gsub(/[^\d]/,'').to_i,
    :location     => y[6],
    :size         => y[7],
    :color        => y[8],
    :code         => y[9] }
end

disc_db    = DB[:discount]      #set up the dataset

updated = 0
discounts.each do |cl|
  s = disc_db.where(:card_number => cl[:card_number], :date => cl[:date], :product_code => cl[:code]).first

  unless s
    s = disc_db.insert(
      :card_number  => cl[:card_number],
      :product_code => cl[:code],
      :name         => cl[:name],
      :lastname     => cl[:lastname],
      :date         => cl[:date],
      :sku          => cl[:sku],
      :value        => cl[:value],
      :location     => cl[:location],
      :size         => cl[:size],
      :color        => cl[:color]
    )
    updated += 1 if s
  end

end

DB.run("UPDATE `discount` SET `card_prepeared` = SUBSTR(REPLACE(REPLACE(`card_number`, '?', ''), ' ', ''), -16) WHERE card_number <> '' AND `card_prepeared` = '';")
DB.run("UPDATE `discount` SET `card_prepeared` = `card_number` WHERE card_number <> '' AND `card_prepeared` = '';")
DB.run("UPDATE `discount` p SET user_id = (SELECT user_id FROM `users` u WHERE u.`card_prepeared` = p.`card_prepeared` LIMIT 1) WHERE user_id = 0 AND p.`card_prepeared` <> '';")

DB.run("UPDATE `discount` p SET user_id = (SELECT original_user_id FROM `users` u WHERE u.`card_prepeared` = p.`card_prepeared` LIMIT 1) WHERE user_id = 0 AND p.`card_prepeared` <> '';")

puts "successfully updated #{updated} items"
puts "operation took #{Time.now-t1} seconds"
