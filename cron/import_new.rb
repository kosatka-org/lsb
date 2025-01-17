require 'smarter_csv'
require 'unicode'
require 'babosa'
require './models'
require './s3_class'
require './error_service'
require './sidekiq_jobs/sidekiq_jobs.rb'

def slug(name)
  name.to_slug.normalize(transliterations: :russian).to_s
end

def brand_is_valid? row
  text = row[:наименование].to_s
  brand_name = row[:дизайнер].to_s
  return if brand_name.empty?
  brand = Brand.where(names: BrandName.where(value: brand_name)).first
  unless brand
    brand = Brand.create(name: brand_name, url: slug(brand_name))
    brand.add_name(value: brand_name)
  end
  return unless brand
  names = brand.names_dataset.map(:value).map { |e| Regexp.quote e }
  r = Regexp.new(names.join("|"), Regexp::IGNORECASE)
  return true if text[r]
  return
end

def is_valid? row
  # Сезон должен выглядеть так: '15/1'
  # return unless row[:Сезон] && row[:Сезон].to_s[/\d\d\/\d/]
  # Цвет должен быть
  # return if !row[:Цвет]
  if row[:Цвет].is_a? Fixnum
    puts "Warning: color for #{row[:Код]} is a number"
  end
  # Наименование должно содержать имя дизайнера/бренда
  # return unless row[:Наименование].is_a?(String) && row[:Дизайнер].is_a?(String)
  brand_is_valid? row
  true
end

t1 = Time.now

@s3 = S3Wrapper.new
if ARGV[0]
  filename = ARGV[0]
  data = File.open(filename, "r:utf-8") do |f|
    SmarterCSV.process(f, col_sep: ';', quote_char: '𝝻')
  end
else
  filename = "export.csv"
  unless @s3.updated?(File.basename(__FILE__), filename)
    exit
  end
  File.open(filename, "w:utf-8") { |f| f.write S3Wrapper.new.get(filename) }
  data = File.open(filename, "r:bom|utf-8") do |f|
    SmarterCSV.process(f, col_sep: ';', quote_char: '𝝻')
  end
end


@count = 0
data.each do |r|
  product = Product.where(code: r[:код]).first
  next if (product && product.category && product.brand)
  is_valid? r

  code = r[:код].to_i
  next unless code > 0
  begin
    product ||= Product.create(product_id: code+100000, code: code)
  rescue Sequel::UniqueConstraintViolation => e
    prod = Product[code+100000]
    if prod && prod.code != code
      DB[:products].where(product_id: code+100000).update(product_id: code+9100000)
      product = Product.create(product_id: code+100000, code: code)
    else
      raise
    end
  end

  product[:model] = r[:наименование]

  unless r[:дизайнер].to_s.empty?
    brand_name = r[:дизайнер]
    product.brand = Brand.where(names: BrandName.where(value: brand_name)).first
    names = product.brand.names_dataset.map(:value)
    regex_names = Regexp.new(names.join("|"), Regexp::IGNORECASE)

    category, material = r[:наименование].split(regex_names).map(&:strip)
    unless category == r[:наименование]
      category.gsub!(/( муж| жен)(ск)?\.?(ой|ая|ое|ие|ий)?/i, '')
      cat = Category.find_or_create(name: category)
      product.category = cat.canonical || cat

      product[:model] = category + " " + product.brand.name
      if material && !material.empty? && !product.material
        PropertyValue.create(product: product, property: Property[name: 'Материал'], value: material)
      end
    end
  end


  if r[:страна_происхождения] && !r[:страна_происхождения].to_s.empty? && !product.country
    PropertyValue.create(product: product, property: Property[name: 'Страна происхождения'], value: r[:страна_происхождения])
  end

  color = r[:цвет].to_s.split(',').first
  product.color = Color.find_or_create(name: color) if color

  product.season = r[:сезон].to_s[/\d\d[\/ ]\d/].to_s.sub(" ", "/")
  ######### Achtung!!
  product.season = '19/1' if product.season == '18/2'
  ######### Achtung!!

  # Если сезон не новый
  new_season = DB[:settings].where(name: 'current_new_season').first&.to_hash&.fetch(:value)
  if product.season.sub("/", ".").to_f < new_season.sub("/", ".").to_f && product.category && product.brand
    url = "https://lsboutique.ru/admin/index.php?section=Product&item_id=#{product.product_id}"
    args = {'message' => "Внимание! Новому товару #{product[:model]} назначен старый сезон #{product.season}.
      Чтобы отредактировать его, воспользуйтесь этой ссылкой:\n #{url}",
      'channel' => 'new_category_brands',
      'user' => 'photo_bot'
    }
    SlackJob.perform_async(args)
  end
  product.sku = r[:артикул]

  sexes = {'U' => 1, 'D' => 2}
  product.sex = sexes[r[:пол].to_s[0]] || 0

  product.item_location = r[:месторасположение]
  if product.url.empty?
    product.old_url = product.sku.to_s.gsub(/[^\w]/,'') + '_'
  else
    product.old_url = product.url
  end
  product.url = product.product_id.to_s + "-" + slug(product[:model])
  product.save
  @count += 1
end

ProductImportJob.perform_async
@s3.save_last_modified
puts "Added #{@count} products in #{Time.now - t1} seconds"
