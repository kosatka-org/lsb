#encoding: utf-8
require './db_connect.rb'

users = DB[:users]
u2s = DB[:users2shops]
prodazhi = DB[:prodazhi]

users.exclude(:shop => '').each do |user|
  u2s.insert(user_id: user[:user_id], shop: user[:shop]) rescue nil
end

prodazhi.exclude(user_id: 0, p_location: '').each do |prod|
  u2s.insert(user_id: prod[:user_id], shop: prod[:p_location]) rescue nil
end