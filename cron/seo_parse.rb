# encoding: utf-8

require 'csv'
require 'roo'
require 'multi_json'
require './db_connect.rb'

if ARGV[0]
	filename = ARGV[0]
else
	filename = "rec.xls"
end

xls = Roo::Spreadsheet.open(filename)
xls.to_csv("rec.csv")
brands = {}
categories = {}
specials = {}
products = {}
db_cat = DB[:categories]
db_brand = DB[:brands]
db_special = DB[:specials]
db_prod = DB[:products]

CSV.open("rec.csv", "r:utf-8", headers: true, col_sep: ",").each do |li|
  str = li["Целевая страница"]
  next unless (str =~ /(products)\/(.+)\// || str =~ /(brand|category|special)=(\d+)/) && (li["Рек"].to_i != 0 || li["Title"].to_i != 0)
  if li["Рек"].to_i != 0
    body = "в тексте <b style=\"color:green;\">#{li["Рек"]}</b> "
  end
  if li["Title"].to_i != 0
    title = "в title <b style=\"color:green;\">#{li["Title"]}</b>"
  end
  insert = li["Ключевое слово"]+" (#{body} #{title})"
  case $1
  when "brand"
    brands[$2].push insert rescue brands[$2] = [insert]
  when "category"
    categories[$2].push insert rescue categories[$2] = [insert]
  when "special"
    specials[$2].push insert rescue specials[$2] = [insert]
  when "products"
    url = $2
    prod = db_prod[url: url] || db_prod[old_url: url] || next
    products[prod[:product_id]].push insert rescue products[prod[:product_id]] = [insert]
  end
end

categories.each do |c,w|
	db_cat.where(category_id: c).update(seo_words: w.join(', '))
end

brands.each do |b,w|
	db_brand.where(brand_id: b).update(seo_words: w.join(', '))
end

specials.each do |s,w|
  db_special.where(special_id: s).update(seo_words: w.join(', '))
end

products.each do |p,w|
  db_prod.where(product_id: p).update(seo_words: w.join(', '))
end

puts "OK"
