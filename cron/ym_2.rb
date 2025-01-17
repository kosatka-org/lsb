# encoding: utf-8
require 'builder'
require 'sanitize'
require 'cgi'
require './models.rb'
require './error_service.rb'

YANDEX_FORBIDDEN_KEYWORDS = /(для вина|для курения|^очки| очки|набор|оправы|солнцезащитные| ножи| карты|зажигалк|для сигар|хьюмидор)/i

YML_EXPORTS = [
  {
    name: "Yandex Market",
    file: "ym_export.yml",
    products: Product.buyable.exclude(category: Category.where(name: YANDEX_FORBIDDEN_KEYWORDS)),
    items: Item.buyable,
    compact_sizes: false, #отдельный offer для каждого размера
    include_utm: true
  },
  {
    name: "Getpremium main",
    file: "gp_export.yml",
    products: Product.buyable,
    items: Item.buyable,
    compact_sizes: true #все размеры в одном оффере
  },
  {
    name: "Criteo stream",
    file: "criteo_export.yml",
    products: Product.buyable,
    items: Item.buyable,
    compact_sizes: false #отдельный offer для каждого размера
  },
  {
    name: "Admitad stream",
    file: "admitad_export.yml",
    products: Product.buyable,
    items: Item.buyable,
    compact_sizes: false #отдельный offer для каждого размера
  },
  {
    name: "Criteo new stream",
    file: "criteo_new_export.yml",
    products: Product.buyable(with_ean: true),
    items: Item.buyable,
    compact_sizes: false #отдельный offer для каждого размера
  }
]
XML_EXPORTS = [
  {
    name: "Facebook",
    file: "facebook_export.xml",
    products: Product.buyable(with_ean: true),
    items: Item.buyable,
    compact_sizes: false #отдельный offer для каждого размера
  }
]

YML_EXPORTS.each do |yml_export|
  products = yml_export[:products]

  puts "Building XML for export #{yml_export[:name]}."
  puts "Total products: #{products.count}"

  f = File.new("../#{yml_export[:file]}", 'w:utf-8')

  xml = Builder::XmlMarkup.new(:target => f, :indent => 2)
  xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
  xml.declare! :DOCTYPE, :yml_catalog, :SYSTEM, "shops.dtd"

  xml.yml_catalog(date: Time.now.strftime('%F %R')) {
    xml.shop {
      xml.name 'Лакшери Стор'
      xml.company 'ИП Жехарева Елена Николаевна'
      xml.url 'https://lsboutique.ru'

      xml.currencies {
        xml.currency(id: 'RUR', rate: '1')
      }

      xml.categories {
        Category.each do |category|
          next if (yml_export[:name] == "Yandex Market" && category.name[YANDEX_FORBIDDEN_KEYWORDS])
          attrs = { id: category.category_id }
          attrs.merge!({ :parentId => category.parent }) unless category.parent.to_i == 0
          xml.category(attrs, category.name)
        end
      }

      xml.local_delivery_cost '500'

      xml.offers {
        products.each do |product|

          sizes = yml_export[:items].where(product: product).group_by(:size).order_by_size
          if yml_export[:compact_sizes]
            sizes = [{
              ls_sizes: "|" + sizes.map(:size).join("|") + "|",
              us_sizes: "|" + sizes.map(:normal_size).join("|") + "|",
            }]
          end

          images = product.images_dataset.map(:filename)
            .unshift(product.large_image, product.small_image)
            .reject {|i| i.empty? }.take(8)

          url = "https://lsboutique.ru/products/#{product.url}"
          url << '?utm_source=yandex&utm_medium=market&utm_campain=market' if yml_export[:include_utm]
          if yml_export[:name] == "Criteo stream"
            if product.col_code.to_i != 0 && product.coll_active
              valuecoefficient = 1.5
            else
              valuecoefficient = 0.5
            end
          end

          if yml_export[:name] == "Criteo new stream"
            if product.category.parent == 1
              google_product_category = 'Apparel & Accessories > Clothing'
            elsif product.category.parent == 2
              google_product_category = 'Apparel & Accessories > Shoes'
            elsif product.category.parent == 38
              google_product_category = 'Apparel & Accessories > Handbags, Wallets & Cases > Handbags'
            elsif product.category.parent == 4
              google_product_category = 'Apparel & Accessories > Clothing Accessories'
            end
            if product.category.category_id == 1170
              google_product_category = 'Apparel & Accessories > Clothing Accessories > Sunglasses'
            end
          end

          sizes.each do |size|
            offer_id = size[:barcode] || product.product_id
            xml.offer(:type => "vendor.model", :id => offer_id,
              :group_id => product.product_id, :available => "true") {
              xml.url url
              if product.brand.show_sale_external && product.old_price > product.price
                if yml_export[:name] == "Admitad stream"
                  xml.oldprice product.old_price
                  xml.price product.price
                else
                  xml.price product.old_price
                  xml.saleprice product.price
                end
              else
                if yml_export[:name] == "Admitad stream"
                  xml.oldprice product.price
                  xml.price product.price
                else
                  xml.price product.price
                  xml.saleprice product.price
                end
              end
              xml.currencyId 'RUR'
              xml.categoryId product.category_id
              if yml_export[:name] == "Criteo new stream"
                xml.brand(product.brand && product.brand.name)
              else
                xml.vendor(product.brand && product.brand.name)
              end
              if yml_export[:name] == "Admitad stream"
                xml.name product[:model]
              else
                xml.model product[:model]
              end
              if yml_export[:name] == "Criteo stream"
                xml.valuecoefficient valuecoefficient
              end
              if yml_export[:name] == "Criteo new stream"
                xml.gtin size.ean
                xml.google_product_category google_product_category
              end
              xml.country_of_origin(product.country && product.country.value)
              xml.description Sanitize.fragment(product.full_description)
              images.each { |i| xml.picture "https://lsboutique.ru/files/products/#{i}" }
              if yml_export[:compact_sizes]
                xml.param({name: "Размер", unit: "US"}, size[:us_sizes])
                xml.param({name: "Размер", unit: "LS"}, size[:ls_sizes])
              else
                xml.param({name: "Размер", unit: "RU"}, size.size)
              end
              xml.param({name: "Цвет"}, product.color && product.color.name)
              xml.param({name: "SKU"}, product.sku )
              sex = product.sex == 2 ? "Женский" : "Мужской"
              xml.param({name: "Пол"}, sex )
              xml.param({name: "Возраст"}, "Взрослый")
              xml.param({name: "Материал"}, (product.material && product.material.value))
              xml.param({name: "Сезон"}, product.season)
              xml.store "true"
              xml.pickup "true"
              xml.delivery "true"
              xml.local_delivery_cost "500"
            }
          end
        end
      }
    }
  }

  f.close
end

XML_EXPORTS.each do |xml_export|
  products = xml_export[:products]

  puts "Building XML for export #{xml_export[:name]}."
  puts "Total products: #{products.count}"

  f = File.new("../#{xml_export[:file]}", 'w:utf-8')

  xml = Builder::XmlMarkup.new(:target => f, :indent => 2)
  xml.instruct!
  xml.rss( "xmlns:g" => "http://base.google.com/ns/1.0",  "version" => "2.0"){

  xml.channel {
    xml.title 'Лакшери Стор'
    xml.description 'LSboutique фирменная одежда из Италии'
    xml.link 'https://lsboutique.ru'

    xml.local_delivery_cost '500'

    products.each do |product|

      sizes = xml_export[:items].where(product: product).exclude(ean: '').group_by(:size).order_by_size

      images = product.images_dataset.map(:filename)
        .unshift(product.small_image)
        .reject {|i| i.empty? }.take(10)
      images.map! { |i| i =  "https://lsboutique.ru/files/products/#{i}"}
      images_links = images.join(",")

      case product.sex
        when 0
          sex = "unisex"
        when 1
          sex = "male"
        when 2
          sex = "female"
      end

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

      url = "https://lsboutique.ru/products/#{product.url}"

      sizes.each do |size|
        item_id = size[:barcode] || product.product_id
        xml.item {
          xml.g :id, item_id
          xml.g :link, url
          xml.g :price, "#{product.price} RUB"
          xml.g :brand, (product.brand && product.brand.name)
          xml.g :title, product[:model]
          xml.g :gtin, size.ean
          xml.g :condition, "new"
          xml.g :description, Sanitize.fragment(product.full_description)
          xml.g :image_link, "https://lsboutique.ru/files/products/#{product.large_image}"
          xml.g :additional_image_link, images_links
          xml.g :google_product_category, google_product_category
          xml.g :availability, "in stock"
          xml.g :size, size.size
          xml.g :color, (product.color && product.color.name)
          xml.g :gender, sex
          xml.g :age_group, "adult"
        }
      end
    end
  }
}
  f.close
end
