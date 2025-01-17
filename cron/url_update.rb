require './db_connect.rb'
require './error_service.rb'
require 'unicode'

products = DB[:products].where(old_url: "").or(old_url: :url)
specials = DB[:specials]
brands = DB[:brands]
categories = DB[:categories]
exp = /[a-zA-Zа-яА-Я0-9]+/

["brands","categories"].each do |e|
  field = e.gsub(/ies$/,"y_id").gsub(/s$/,"_id").to_sym
  DB[e.to_sym].each do |i|
    url = Unicode::downcase(i[:name].scan(exp).join("-"))
    DB[e.to_sym].where(field => i[field]).update(url: url)
  end
end

unless ARGV[0] == "fast"
	products.each do |i|
		url = i[:product_id].to_s+"-"+Unicode::downcase(i[:model].scan(exp).join("-"))
		products.where(product_id: i[:product_id]).update(old_url: i[:url], url: url)
	end
end
