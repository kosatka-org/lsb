require './models'
require 'httparty'
require 'oj'
require 'multi_json'

@items = MultiJson.load(HTTParty.get("https://getpremium.ru/price/tsum.json").body)

Product.each do |product|
  sku = product.tsum_sku
  sku = product.sku.gsub(" ","").gsub("/","") if sku.empty?

  tsum_product = @items.find { |k,v| sku.start_with?(k) || k.start_with?(sku) } || next
  tsum_price = TsumPrice.find_or_create(
    product: product
  )
  tsum_price.update(
    sku: tsum_product[0],
    url: tsum_product[1]['url'],
    price: tsum_product[1]['price'].to_i
  )
end
