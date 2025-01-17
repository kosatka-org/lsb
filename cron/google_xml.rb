require 'nokogiri'
require 'cgi'
require 'uri'
require 'sanitize'
require './models.rb'
require './error_service'


builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|

  # декларация DTD
  xml.rss("xmlns:g" => "http://base.google.com/ns/1.0", "version" => "2.0") do
    xml.channel do
      xml.title { xml.text('Лакшери Стор') }
      xml.link { xml.text('https://lsboutique.ru') }

      Product.buyable.each do |product|
        sizes = Item.buyable.where(product: product).group_by(:size).order_by_size

          if product.category.parent == 1
            google_product_category = 1604
          elsif product.category.parent == 2
            google_product_category = 187
          elsif product.category.parent == 38
            google_product_category = 3032
          elsif product.category.parent == 4
            google_product_category = 167
          end
          if product.category.category_id == 1170
            google_product_category = 178
          end

          sizes.each do |size|
            xml.item do
              xml['g'].id { xml.text(product.sku+product.color_id.to_s+size.size) }
              xml['g'].title { xml.text(product[:model]) }
              xml['g'].description { xml.text( Sanitize.fragment( product.full_description ) ) }
              xml['g'].link { xml.text("http://lsboutique.ru/products/#{product.url}") }
              product.images.each_with_index do |image, index|
                if index == 0
                  xml['g'].image_link { xml.text("http://lsboutique.ru/files/products/#{image.filename}") }
                else
                  xml['g'].additional_image_link { xml.text("http://lsboutique.ru/files/products/#{image.filename}") }
                end
              end
              xml['g'].condition { xml.text("new") }
              xml['g'].availability { xml.text("in stock") }
              xml['g'].price { xml.text( "#{product.price} RUB" ) }
              xml['g'].brand { xml.text( product.brand.name ) }
              g_select = {0 => "Unisex", 1 => "Male", 2 => "Female"}
              xml['g'].gender { xml.text( g_select[product.sex] ) }
              xml['g'].google_product_category { xml.text( google_product_category ) }
              if size.ean != ''
                xml['g'].gtin { xml.text( size.ean ) }
              end
              xml['g'].age_group { xml.text( "Adult" ) }
              xml['g'].color { xml.text( product.color && product.color.name ) }
              xml['g'].size { xml.text( size.size ) }
              xml['g'].custom_label_0 {
                xml.text(
                  ['next_season', 'new_season'].include?(product.season_type) ? 'new_season' : 'old_season'
                )
              }
              xml['g'].custom_label_1 { xml.text( product.season ) }
              unless product.category.parent == 0
                product_type = "#{product.category.parent_category.name} > #{product.category.name}"
              else
                product_type = product.category.name
              end
              xml['g'].product_type { xml.text( product_type ) }
            end
          end

        end

    end
  end
end

File.write("google_shop.xml", builder.to_xml, encoding: 'utf-8')

`cp google_shop.xml ../`

exit!
