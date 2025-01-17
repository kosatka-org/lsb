# encoding: utf-8
require './db_connect.rb'
SUB_DB_NAMES = {
  products: :products_sub
}

# Exit if another import is already running
lock_file = "/tmp/importlive.lock"
File.write(lock_file, "") unless File.exist?(lock_file)
exit unless File.new(lock_file).flock( File::LOCK_NB | File::LOCK_EX )

# Prepare sub table
DB.drop_table?(:products_sub)
DB.run("CREATE TABLE products_sub LIKE products;")
DB.run("INSERT products_sub SELECT * FROM products;")

require './models.rb'
require './s3_class.rb'
require 'mail'
require 'csv'
require 'smarter_csv'
require 'date'
require 'sidekiq'
require 'redis-namespace'
require 'bugsnag/sidekiq'
Sidekiq.configure_client do |config|
  config.redis = { namespace: 'resque' }
end
require './sidekiq_jobs/image_fix_job.rb'
require './sidekiq_jobs/update_purchase_sum_job.rb'
require './error_service'

t1=Time.now

filename = "export.csv"

foi = ARGV.index('--filename')
if foi && ARGV[foi+1]
  filename = ARGV[foi+1]
end

@local = ARGV.include?("--local")

unless @local
  @s3 = S3Wrapper.new
  unless @s3.updated?(File.basename(__FILE__), filename) || ARGV.include?("--force")
    exit
  end
  File.open(filename, "w:utf-8") { |f| f.write @s3.get(filename) }
end

import_data = File.open(filename, "r:bom|utf-8") do |f|
  SmarterCSV.process(f, col_sep: ';', quote_char: '𝝻')
end

DB[:product_import_data].delete
import_data.each do |row|
  DB[:product_import_data].insert(product_id: row[:код].to_i+100000, data: row.to_json)
end

file = File.new(filename, "r:utf-8")

line_count = %x{wc -l #{filename}}.split.first.to_i
puts "#{line_count} records fetched"

products = DB[SUB_DB_NAMES[:products]]
categories = DB[:categories]
brands = DB[:brands]

new_season = DB[:settings].where(name: 'current_new_season').first&.to_hash&.fetch(:value)
previous_season = DB[:settings].where(name: 'previous_season').first&.to_hash&.fetch(:value)

hidden_brand_ids = brands.where{visibility >= 4}.map(:brand_id)
products.where(sold: 0, show_out_of_stock: 0).update(sold: 1, sold_date: Date.today)
updated = 0
email_body = ""
file.each_line do |li|

  fields=li.split(";")

  # Сортировка размеров
  size_order = %w(XXS XS S M L XL XXL XXXL 3XL XXXXL 4XL 5XL 6XL)
  sizes = fields[8].split("#")
  sizes.sort_by! {|si| i = size_order.index(si); (i && ("%03d" % i)) || si}

  sexes = {'U' => 1, 'D' => 2}

  p = {
    code: fields[0].to_i,
    brand: fields[2],
    sku: fields[6],
    sex: sexes[fields[5].to_s[0]] || 0,
    stock: "|#{sizes.join("|")}|",
    color: fields[9].strip,
    price: fields[11].gsub(/[^\d,\.]/,'').gsub(/,/,".").to_f,
    last_price: fields[18].to_s.gsub(/[^\d,\.]/,'').gsub(/,/,".").to_f,
    discount: fields[13].gsub(/[^\d,\.]/,'').gsub(/,/,".").to_f,
    item_location: fields[14].to_s,
    special_sale: 0
  }
  p[:offline_price] = p[:price]
  next if p[:code] == 0

  prod = products[code: p[:code]]
  next unless prod

  if prod[:season].sub("/", ".").to_f > new_season.sub("/", ".").to_f
    season_type = 'next_season'
  elsif prod[:season].sub("/", ".").to_f == new_season.sub("/", ".").to_f
    season_type = 'new_season'
  elsif prod[:season][/#{previous_season}/]
    season_type = 'previous_season'
  else
    season_type = 'old_seasons'
  end

  sale_settings = DB[:sale_settings].where(brand_id: prod[:brand_id], season: season_type).first

  current_price = prod[:price].to_f

  if sale_settings && sale_settings[:max_sale]
    last_price_online = p[:price]*(100-sale_settings[:max_sale])/100.0
  else
    last_price_online = p[:last_price]
  end

  if sale_settings
    sale_price = [p[:price]*(100-sale_settings[:sale])/100.0, last_price_online].max
    p[:oldprice] = p[:price] == sale_price ? 0 : p[:price]
    p[:price] = sale_price
  else
    if p[:discount] == 0
      p[:oldprice] = 0
    else
      p[:oldprice] = p[:price]
      p[:price] = p[:price] - p[:discount]
    end
  end

  p[:price] = last_price_online if last_price_online > p[:price]

  #Tsum prices
  unless prod[:tsum_url].empty?
    TsumImportJob.perform_in(30, {product_id: prod[:product_id]})
    if DB[:tsum_prices].where(product_id: prod[:product_id]).first
      p[:price], p[:oldprice] = current_price, 0
    end
  end

  # Супер-цена (не обновляется из 1С)
  if prod[:super_price] == 1
    p[:price] = prod[:price]
    p[:oldprice] = prod[:old_price]
    if prod[:old_price] == 0 && prod[:offline_price] > 0 && prod[:offline_price] != prod[:price]
      p[:oldprice] = prod[:offline_price]
    end
  end

  p[:price] = p[:price].to_f.round(2)
  s = products.where(:code => p[:code]).update(
    sold: 0,
    price: p[:price],
    old_price: p[:oldprice],
    offline_price: p[:offline_price],
    last_price: p[:last_price],
    size: p[:stock],
    sku: p[:sku],
    sex: p[:sex],
    special_sale: p[:special_sale],
    item_location: p[:item_location],
    season_type: season_type,
    last_price_online: last_price_online
  )

  if s>0 && fields[8]
    sizes.each do |size|
      a = size
      if a =~ /.+\((.+)\)/ || a =~ /(.+)\//
        a = $1
      end
      a.gsub!('2XL', 'XXL')
      if a =~ /(X+)XXL/
        a = "#{$1.length+2}XL"
      end
      a.gsub!(/^[е]/,"")
    end

    if current_price != p[:price]
      DB[:price_changes].insert(
        product_id: prod[:product_id],
        old_price: prod[:price],
        new_price: p[:price],
        date: Time.now
      )
      products.where(code: p[:code]).update(last_price_update: Time.now)
      email_body = email_body + "Изменена цена товара #{fields[3]}, артикул #{p[:sku]}, код №#{p[:code]}: было #{prod[:price]}, стало #{p[:price]}\n"
    end

  end

  updated += s
end

# wipe size for all sold products
Product.where(sold: true).exclude(size: '').update(size: '')

Category.each do |cat|
  prods = cat.products_dataset.buyable
  prod_count_m = prods.where(sex: 1).count
  prod_count_w = prods.where(sex: 2).count
  cat.update( prod_count_m: prod_count_m, prod_count_w: prod_count_w )
end

Brand.each do |brand|
  prods = brand.products_dataset.buyable
  prod_count_m = prods.where(sex: 1).count
  prod_count_w = prods.where(sex: 2).count
  brand.update( prod_count_m: prod_count_m, prod_count_w: prod_count_w )
end

File.delete(filename)

unless email_body.empty?
  mail = Mail.new do
    to      'mail@lsboutique.ru'
    from    'no-reply@lsboutique.ru'
    subject "Изменения цены на товары"
    body    email_body
  end

  mail.delivery_method :smtp, :openssl_verify_mode  => "none", :enable_starttls_auto => false
  mail.deliver! if ENV['environment'] == 'production'
end

OrderProduct.where(order: Order.where(status: [1,6]).where{ date > Date.today - 60 }, barcode: '').each do |op|
  if op.item
    op.update(barcode: op.item.barcode)
    next
  end
  items = Item.where(product_id: op.product_id).all
  if items.length == 1
    barcode = items.first.barcode
    op.update(barcode: barcode)
  end
end

# Swap sub table with main
DB.run("RENAME TABLE products TO products_old, products_sub TO products;")
DB.drop_table?(:products_old)

# Fix for disappearing images
ImageFixJob.perform_async

@s3.save_last_modified unless @local

puts "successfully updated #{updated} items"
puts "operation took #{Time.now-t1} seconds"
