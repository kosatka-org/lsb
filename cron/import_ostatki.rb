#encoding: utf-8
require 'time'
require 'unicode'
require './db_connect.rb'
require './s3_class.rb'
require './error_service'

t1 = Time.now

filename = "Ostatki.csv"

ostatki    = DB[:ostatki]      #set up the dataset
categs = DB[:categories]
brands = DB[:brands]

exp = /[a-zA-Zа-яА-Я]+/

if file = S3Wrapper.new.get(filename)
  ostatki.delete
  file.each_line do |li|
    y = li.split(";")
    code = y[0].to_i
    next if (code == 0 || y.size < 14)
    model = y[2].strip
    brand = y[5].strip
    brand_id = brands[name: brand][:brand_id] rescue 0
    size  = y[12].strip
    spl = model.split(/#{brand}/i)
    category = spl.first.strip.sub(/ (муж|жен).*/,"")
    category_id = categs[name: category][:category_id] rescue 0
    material = spl[1] || ""
    url = code.to_s+"-"+Unicode::downcase(model.scan(exp).join("-"))


    ostatki.insert( :code      => code,
      :sku        => y[1],
      :url        => url,
      :model      => model,
      :category_name   => category,
      :category_id => category_id,
      :brand_id   => brand_id,
      :sex        => y[3],
      :season     => y[4],
      :brand      => brand,
      :location   => y[6],
      :nomenk_group => y[7],
      :harakteristika_nomenk => y[8],
      :quantity  => y[9],
      :purchase_sum  => y[10].gsub(",",".").gsub(/[^\d.]/,''),
      :retail_price  => y[11].gsub(",",".").gsub(/[^\d.]/,''),
      :size       => size,
      :color      => y[13],
      :material   => material
    )
  end
end

DB.run("UPDATE ostatki SET brand_id = 287 WHERE brand_id IN (308, 107, 92);")

puts "operation took #{Time.now-t1} seconds"
