require 'smarter_csv'
require 'unicode'
require './db_connect'

SUB_DB_NAMES = {
  items: :items_sub
}

# Prepare sub table
DB.drop_table?(:items_sub)
DB.run("CREATE TABLE items_sub LIKE items;")
DB.run("INSERT items_sub SELECT * FROM items;")

require './models'
require './s3_class'
require './error_service'

t1 = Time.now

filename = ARGV[0].to_s[/--file=(.+)/, 1] || "shop.csv"
@s3 = S3Wrapper.new
unless @s3.updated?(File.basename(__FILE__), filename) || ARGV.include?("--force")
  exit
end
File.open(filename, "w:utf-8") { |f| f.write @s3.get(filename) }
data = File.open(filename, "r:bom|utf-8") do |f|
  SmarterCSV.process(f, col_sep: ';', quote_char: '𝝻')
end

Item.exclude(do_not_update: true).update(quantity: 0)
@count = 0
data.each do |r|
  product = Product.where(code: r[:код]).first || next
  barcode = (r[:штрихкод] || next).to_s
  warehouse = Warehouse.where(code: r[:кодсклада]).first
  warehouse = Warehouse.create(name: r[:склад], code: r[:кодсклада]) unless warehouse
  e_name = r[:организация]
  entity = e_name.to_s.empty? ? nil : Entity.find_or_create(name: e_name)
  item = Item.find_or_create(barcode: barcode, product: product, warehouse: warehouse)
  next if item.do_not_update
  item.update(
    shop: warehouse.shop,
    entity: entity,
    product: product,
    size: Helpers.process_size(r[:размер].to_s),
    quantity: (r[:количество] || 1),
    ean: r[:баркод].to_s,
  )
  item.update(normal_size: item.compute_normal_size) if (item.normal_size.empty? || item.size_id.to_i.zero?)
  @count += 1
end

# Swap sub table with main
DB.run("RENAME TABLE items TO items_old, items_sub TO items;")
DB.drop_table?(:items_old)

@s3.save_last_modified
puts "Added #{@count} items in #{Time.now - t1} seconds"
