# encoding: utf-8
require "./models.rb"
require './error_service'

clothing_cats = DB[:categories].where(:parent => 1).map(:category_id)

$sizetables = DB[:sizetables].all.map do |sztb|
  sztb.delete(:name)
  sztb.delete(:sizetable_id)
  aa = sztb.to_a
  ab = aa.each_with_index.map do |x,i|
    if i==0
      [x[0], (0..x[1])]
    elsif i==9
      [x[0], ((x[1]-1)..100)]
    else
      [x[0], ((aa[i-1][1]+1)..x[1])]
    end
  end
  Hash[*ab.flatten]
end

def normalize_size(size,sex,cat,brand)
  if size[/\D/]
    size.gsub("5XL", "5XL+")
  else
    sztbl =
      if special_table = DB[:cats2sizetables].where(:sex => sex, :category_id => cat, :brand_id => brand).first
        $sizetables[special_table[:sizetable_id]-1]
      elsif special_table = DB[:cats2sizetables].where(:sex => sex, :category_id => cat, :brand_id => 0).first
        $sizetables[special_table[:sizetable_id]-1]
      end
    unless sztbl
      sztbl = (sex == 2 && $sizetables[1]) || $sizetables[0]
    end
    normal_size = size.to_i
    sztbl.each do |k,v|
      normal_size = k.to_s if v === size.to_i
    end
    normal_size
  end
end

def register_size(user_id, size, category_id, brand_id, sex)
  category = DB[:categories][category_id: category_id] || return
  case category[:parent]
  when 1
    type = 1
  when 2
    type = 2
  else
    return
  end
  size = normalize_size( size, sex, category_id, brand_id ) if type == 1
  return if size[/\//] || size[/\(/] || size[/\)/] || size[/не /i]
  scope = {user_id: user_id, type_id: type, size: size}
  DB[:users2sizes].where(scope).first || DB[:users2sizes].insert(scope)
end

counter = 0
Item.where(normal_size: '').each do |i|
  size = i.size
  product = i.product
  next unless product.category && product.brand
  if product.category[:parent] == 1
    size = normalize_size(size, product.sex, product.category_id, product.brand_id)
    counter += 1
  end
  i.update(normal_size: size)
end
puts "#{Time.now}: Normalized #{counter} sizes" unless counter == 0

if ARGV.include? "u2s"
  DB[:orders_products].where(status: 5).each do |op|
    next if op[:size].empty?
    product = DB[:products][product_id: op[:product_id]] || next
    order = DB[:orders][order_id: op[:order_id]] || next
    register_size(order[:user_id], op[:size], product[:category_id], product[:brand_id], product[:sex])
  end
end

if ARGV.include? "prodazhi"
  num = 0
  DB[:prodazhi].where{(user_id > 0) & (brand_id > 0) & (category_id > 0)}.exclude(size: '').where(sex: ['D', 'U']).each do |pro|
    sex = case pro[:sex]
    when 'U'
      1
    when 'D'
      2
    else
      next
    end
    register_size(pro[:user_id], pro[:size], pro[:category_id], pro[:brand_id], sex)
    num += 1
    print "\r#{num}"
  end
end
