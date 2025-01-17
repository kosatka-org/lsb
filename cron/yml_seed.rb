# encoding: utf-8
require './db_connect.rb'

specials = DB[:specials]
sp = specials.where(enabled: 1).all

sp.each do |i|
	`ruby ym.rb #{i[:special_id]}`
end