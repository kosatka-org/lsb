require './models.rb'
require 'mechanize'

class TsumImportJob
  include Sidekiq::Worker

  def tsum_price(url)
    page = Mechanize.new.get(url)
    price_element = page.search("div.price.price_type_new").first || page.search("div.price.js-price").first
    return unless price_element
    price_element.text.delete(' ').to_i
  end

  def perform(args)
    product = Product[args['product_id']]
    begin
      price = tsum_price(product.tsum_url)
    rescue Mechanize::ResponseCodeError
      price = 0
    end
    if price.to_i < 5000
      product.tsum_price_dataset.delete
    else
      TsumPrice.find_or_create(product: product).update(price: price)
      adjusted_price = price - 1000
      if product.price != adjusted_price
        product.add_price_change(old_price: product.price, new_price: adjusted_price, date: Time.now)
      end
      product.update(price: adjusted_price)
    end
  end
end
