require './models'

File.open("../nvn_cl.csv", "w:utf-8") do |file|
  file.puts "﻿ФИО;Телефон;Сумма покупок;Покупки"
  User.where(user_id: DB[:users2shops].where(shop: "Luxury Store").map(:user_id)).where(original_user_id: :user_id, sex: 1).each do |user|
    last3 = user.offline_sales_dataset.order(:p_date).last(3).map {|s| s[:model]}.join(", ")
    file.puts "#{user.name};#{user.phone_number};#{user.sum_for_linked_accounts};#{last3}"
  end
end