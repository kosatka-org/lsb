require "json"
require_relative "db_connect"
require_relative "helpers"
require_relative "remote_logger"
require_relative "cdek"
require_relative "evotor_client"
require "sidekiq"
require "digest"
require "unicode"
require "uuid"
require "babosa"
require "phonelib"
require "sysrandom/securerandom"
require "redis-namespace"
require "bugsnag/sidekiq"

# MySQL-specific dataset extensions
module Sequel
  class Dataset
    def filter_by_year(hash = {date: Date.today})
      field, date = hash.to_a.flatten
      where { (year(field) =~ date.year) }
    end

    def filter_by_year_month(hash = {date: Date.today})
      field, date = hash.to_a.flatten
      where { (month(field) =~ date.month) & (year(field) =~ date.year) }
    end

    def filter_by_date(hash = {date: Date.today})
      field, date = hash.to_a.flatten
      where { date(field) =~ date }
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = {namespace: "resque"}
end

if ENV["ENVIRONMENT"] == "production"
  require "./sidekiq_jobs/product_to_trello_job"
  require "./sidekiq_jobs/mailchimp_list_job"
  require "./sidekiq_jobs/slack_job"
end

SUB_DB_NAMES ||= {}

LS_HOST = ENV["LS_HOST"] || "https://lsboutique.ru/"

Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :def_dataset_method

class Product < Sequel::Model(SUB_DB_NAMES[:products] || :products)
  unrestrict_primary_key
  many_to_one :category
  many_to_one :brand
  many_to_one :color

  one_to_one :country, class: :PropertyValue do |ds|
    ds.where(property_id: 1)
  end

  one_to_one :material, class: :PropertyValue do |ds|
    ds.where(property_id: 3)
  end

  one_to_one :tsum_price

  one_to_many :items
  many_to_many :product_sets, join_table: :sets_products, right_key: :set_id
  many_to_many :materials, join_table: :products_materials
  many_to_many :orders, join_table: :orders_products
  many_to_many :shops, join_table: :items do |ds|
    ds.group(:shop_id)
  end

  one_to_one :main_look, class: :ProductSet, key: :main_product_id do |ds|
    ds.where(big_size: 0)
  end
  one_to_one :big_look, class: :ProductSet, key: :main_product_id do |ds|
    ds.where(big_size: 1)
  end

  one_to_many :images, order: :foto_id do |ds|
    ds.where(big_size: 0)
  end
  one_to_many :bsize_images, class: :Image, order: :foto_id do |ds|
    ds.where(big_size: 1)
  end
  one_to_many :all_images, class: :Image, order: :foto_id

  one_to_many :order_products, key: :product_id, class: :OrderProduct

  one_to_many :product_views
  one_to_many :product_view_counters
  one_to_many :price_changes
  one_to_many :payments
  subset :enabled, enabled: 1
  subset :with_photo, Sequel.~(large_image: "")
  subset :in_stock, Sequel.~(size: "")

  def sale_setting
    ::SaleSetting.where(season: season_type, brand_id: brand_id).first
  end

  dataset_module do
    def buyable(level: :buyable, visibility_level: 1, with_ean: false)
      items = ::Item.public_send(level)
      items = items.exclude(ean: "") if with_ean
      brands = ::Brand.where { visibility <= visibility_level }.where(offline_only: false)
      items_exist = items.where(product_id: Sequel[Product.table_name][:product_id]).select(1).exists
      categories = Category.where(enabled: true)
      where(items_exist)
        .enabled.with_photo
        .where(brand: brands, category: categories)
    end
  end

  def admin_url(hostname = LS_HOST)
    hostname + "admin/index.php?section=Product&item_id=#{product_id}"
  end

  def site_url(hostname = LS_HOST)
    hostname + "products/#{url}/"
  end

  def full_description
    return description unless description.empty?
    brand, category = self.brand, self.category
    return "" unless brand && category
    parent_id = category.parent
    cat_id = (parent_id == 0) ? category.category_id : parent_id
    desc = brand[:"text#{cat_id}_#{sex}"].to_s
    desc = brand[:"text#{cat_id}"] if desc.to_s.empty?
    desc
  end

  def set_products
    Product.where(product_sets: product_sets_dataset)
      .exclude(product_id: product_id).all
      .push(*product_sets.map(&:main_product).select { |prod| prod != self }).uniq
  end

  def images_files
    [large_image, small_image, *all_images_dataset.map(:filename)].uniq.compact
  end

  def sizes_array(megasale: false, normal: false)
    items = items_dataset
    items = megasale ? items.megasale : items.buyable
    items.order_by_size.map { |i| normal ? i.normal_size : i.size }
  end

  def increment_views(count: 1, logged_in: false)
    pvc = ProductViewCounter.find_or_create(product_id: product_id)
    hash = {count: Sequel.expr(count) + :count}
    hash.merge!({count_logged_in: Sequel.expr(count) + :count_logged_in}) if logged_in
    pvc.update(hash)
  end

  def before_create
    self.modified = self.created ||= Time.now
    self.uuid = UUID.new.generate
    super
  end

  def after_create
    super
    ::ProductToTrelloJob.perform_in(20 * 60, {product_id: product_id}) if ENV["ENVIRONMENT"] == "production"
  end
end

class Category < Sequel::Model(:categories)
  def after_create
    super
    update(url: name.to_slug.normalize(transliterations: :russian).to_s)
    url = "#{LS_HOST}admin/index.php?section=Category&item_id=#{category_id}"
    args = {"message" => "Автоматическим импортом добавлена новая категория #{name},
      которая по умолчанию помещена в раздел 'Одежда'. Чтобы переместить её в другой раздел,
      воспользуйтесь этой ссылкой:\n #{url}"}
    ::SlackJob.perform_async(args.merge("channel" => "new_category_brands", "user" => "photo_bot")) if ENV["ENVIRONMENT"] == "production"
  end

  one_to_many :products

  many_to_one :parent_category, key: :parent, class: self
  one_to_many :children, key: :parent, class: self

  many_to_one :canonical, key: :canonical_id, class: self
  one_to_many :variants, key: :canonical_id, class: self

  subset :canonical_categories, canonical_id: nil

  def canonical_root
    cr = canonical || self
    cr = cr.canonical while cr.canonical
    cr
  end

  dataset_module do
    def by_canonical(canonical_name)
      where(canonical: ::Category.where(name: canonical_name))
    end
  end
end

class Color < Sequel::Model(:colors)
  one_to_many :products
end

class Brand < Sequel::Model(:brands)
  def after_create
    super
    args = {"message" => "Автоматическим импортом добавлен новый бренд #{name}.
      Чтобы отредактировать его, воспользуйтесь этой ссылкой:\n #{admin_url}"}
    ::SlackJob.perform_async(args.merge("channel" => "new_category_brands", "user" => "photo_bot")) if ENV["ENVIRONMENT"] == "production"
  end
  one_to_many :products
  many_to_many :users, join_table: :users2brands do |ds|
    ds.where(status: 1)
  end
  one_to_many :names, class: :BrandName
  one_to_many :sale_settings

  def admin_url(hostname = LS_HOST)
    "#{hostname}admin/index.php?section=Brand&item_id=#{brand_id}"
  end
end

class BrandName < Sequel::Model(:brand_names)
  many_to_one :brand
end

class Order < Sequel::Model(:orders)
  many_to_one :user
  many_to_one :delivery_company
  many_to_one :payment_method
  many_to_one :cashbox
  many_to_one :manager, key: :manager_id, class: :User
  many_to_one :courier, key: :courier_id, class: :User
  one_to_many :order_products, key: :order_id, class: :OrderProduct
  one_to_many :order_comments
  one_to_many :order_events
  one_to_many :order_delivery_events
  one_to_many :payments
  one_to_many :offline_payments, eager: [:payment_type]
  many_to_many :products, join_table: :orders_products

  subset :online_orders, cashbox_id: 0
  subset :offline_orders, Sequel.~(cashbox_id: 0)

  def admin_url(hostname = LS_HOST)
    "#{hostname}admin/index.php?section=Order&order_id=#{order_id}"
  end

  def offline_url(hostname = LS_HOST)
    "#{hostname}index.php?module=OfflineSale&order_id=#{order_id}"
  end

  def sum
    order_products_dataset.sum(:price).to_f
  end

  def payment_sum
    payments_dataset.sum(:money_paid).to_f
  end

  def offline?
    cashbox_id != 0
  end

  def generate_uuid!
    return uuid if uuid.size > 0
    self.uuid = UUID.new.generate
    save
    uuid
  end

  def evotor_client
    @evotor_client ||= EvotorClient.new(order: self)
  end

  def print_receipt
    evotor_client.print_receipt
  end

  def cdek_city_id
    city = DB[:cities_cdek].where(city: self.city, oblast: region).first ||
      DB[:cities_cdek].where(city: self.city).first
    city ? city[:id] : 0
  end

  def cdek_api_client
    cdek_account = CdekAccount[delivery_ip] || CdekAccount.first
    CdekClient.new(account: cdek_account.key1, password: cdek_account.key2, order: self)
  end

  def check_cdek_status
    cdek_api_client.status_report(invoice_number: invoice_number)
  end

  dataset_module do
    def city_stats
      online_orders.exclude(city: ["", "Нижний Новгород"])
        .eager_graph(:order_products)
        .select_group(:city, Sequel[:order_products][:status])
        .select_append { sum(price).as(sum) }.having(:sum).to_a
        .group_by { |i| i[:city] }
        .values.each_with_object({}) { |i, m|
        m[i.first[:city]] = Hash[*i.map { |e| e.fetch_values(:status, :sum) }.flatten]
      }
        .sort_by { |k, v| v[5].to_f }.reverse
        .yield_self { |s| Hash[*s.flatten] }
    end
  end
end

class OrderProduct < Sequel::Model(:orders_products)
  many_to_one :order
  many_to_one :product
  many_to_one :user
  many_to_one :item
  many_to_one :offline_manager
  subset :accepted, status: 5
  subset :returned, status: 4
  def item
    ::Item.where(product_id: product_id, size: size).first
  end

  def guess_barcode
    items = ::Item.where(product_id: product_id)
    return if items.empty?
    if items.map(:size).uniq.size == 1
      return items.first.barcode
    end
    s = Helpers.process_size(size)
    (items.where(size: s).first || items.where(:size.ilike("%#{s}%")).first || items.first).barcode
  end

  dataset_module do
    def with_partial_payment(delta)
      if delta.to_i <= 0
        return map { |op|
          op["remaining_payment"] = op.price
          op["partial_payment"] = 0
          op
        }
      end
      total = sum(:price)
      delta_amount = total - delta
      each_with_index.map do |op, i|
        if i == count - 1
          op["remaining_payment"] = delta_amount
        else
          op["remaining_payment"] = (op.price * (delta_amount / total)).to_i
          delta_amount -= op["remaining_payment"]
        end
        op["partial_payment"] = op.price - op["remaining_payment"]
        op
      end
    end
  end
end

class OrderEvent < Sequel::Model(:orders_events)
  many_to_one :order
  many_to_one :user
end

class OrderDeliveryEvent < Sequel::Model(:order_delivery_events)
  many_to_one :order
end

class OfflineSale < Sequel::Model(:prodazhi)
  many_to_one :user
  many_to_one :category
  many_to_one :brand
end

class User < Sequel::Model(:users)
  one_to_many :orders
  one_to_many :order_products
  one_to_many :bought_products, class: :OrderProduct do |ds|
    ds.where(status: 5)
  end
  one_to_many :calls, key: :client_id
  one_to_many :offline_sales, class: OfflineSale do |ds|
    ds.exclude(location: "Интернет-магазин")
  end
  one_to_many :one_clicks
  one_to_many :product_views
  one_to_many :app_sessions
  one_to_many :work_hours
  one_to_many :user_comments
  one_to_many :order_events
  many_to_one :group
  many_to_one :warehouse
  many_to_one :manager, class: :Manager, key: :p_manager_id
  many_to_many :web_sessions, join_table: :users2web_sessions
  many_to_many :shops, join_table: :users2shops
  subset :online_customers, order_products: ::OrderProduct.where(status: 5), group_id: 1
  subset :offline_customers, offline_sales: ::OfflineSale.dataset, group_id: 1

  many_to_many :brands, join_table: :users2brands do |ds|
    ds.where(status: 1)
  end
  many_to_many :offline_managers, join_table: :sr_manager2users, right_key: :manager_id
  many_to_many :offline_brands, class: :Brand, join_table: :users_offline_brands, right_key: :brand_id

  def link_brand(brand_id)
    unless brands_dataset.map(:brand_id).include?(brand_id)
      begin
        add_brand(brand_id)
      rescue Sequel::UniqueConstraintViolation
      end
    end
  end

  def online_sum
    bought_products_dataset.sum(:price).to_f
  end

  def offline_sum
    offline_sales_dataset.sum(:sum_with_discount).to_f
  end

  def total_sum
    online_sum + offline_sum
  end

  def admin?
    group&.name == "Админ"
  end

  def admin_url(hostname = LS_HOST)
    "#{hostname}admin/index.php?section=User&user_id=#{user_id}"
  end

  def offline_url(hostname = LS_HOST)
    "#{hostname}index.php?module=OfflineSales&edit_user_id=#{user_id}"
  end

  def slack_link_or_name
    slack_name.empty? ? name : "<@#{slack_name}>"
  end

  def phone
    Phonelib.parse(phone_number, "RU")
  end

  def international_phone
    Phonelib.parse(phone_number, "RU").international
  end

  def national_phone
    Phonelib.parse(phone_number, "RU").national
  end

  def e164_phone
    Phonelib.parse(phone_number, "RU").e164
  end

  def whatsapp_url
    "https://wa.me/#{phone}"
  end

  def sum_for_linked_accounts
    sum = User.where(original_user_id: original_user_id).map(&:total_sum).reduce(:+)
    (sum.zero? && has_purchase) ? 100000 : sum
  end
end

class GenericManager < User
  def manager_calls_dataset
    sip_ids = DB[:users2sips].where(user_id: user_id).map { |i| "sip:" + i[:sip_id] }
    Call.where(sip_id: sip_ids)
  end

  def manager_calls
    manager_calls_dataset.all
  end
end

class Manager < GenericManager
  set_dataset(where(group_id: 5))
  one_to_many :personal_clients, class: User, key: :p_manager_id
  def monthly_target
    fresh_orders = Order.where(date: ((Date.today - 90)..Date.today), user: personal_clients)
    OrderProduct.where(order: fresh_orders, status: 5).sum(:price).to_f / 3
  end
end

class OfflineManager < GenericManager
  set_dataset(where(group_id: 13))
  one_to_many :order_products
  many_to_many :clients, class: User, join_table: :sr_manager2users,
    left_key: :manager_id, right_key: :user_id
  many_to_many :orders, join_table: :orders_products,
    right_key: :order_id

  def debts
    non_mtm = order_products_dataset.where(mtm_status: ["", "Выдано клиенту"])
    ::Debt.where(order: Order.where(order_products: non_mtm))
  end

  def total_debt
    debts.unpaid.all.map(&:remaining).reduce(:+).to_f
  end

  def remaining_debt_limit
    debt_limit - total_debt
  end
end

class SaleSetting < Sequel::Model
  def products
    ::Product.where(season_type: season, brand_id: brand_id)
  end
  many_to_one :brand
end

class Group < Sequel::Model(:groups)
  one_to_many :users
end

class Material < Sequel::Model(:s_materials)
  many_to_many :products, join_table: :products_materials
end

class Property < Sequel::Model(:properties)
  one_to_many :property_values
end

class PropertyValue < Sequel::Model(:properties_values)
  many_to_one :product
  many_to_one :property
end

class Image < Sequel::Model(:products_fotos)
  def after_create
    super
    if [10, 100].include? foto_id
      url_admin = "https://lsboutique.ru/admin/index.php?section=Product&item_id=#{product_id}"
      url_store = "https://lsboutique.ru/products/#{product_id}/"
      image_product = product
      img_type = (foto_id == 10) ? "с моделью" : "деталей"
      args = {"message" => "Загружены фото #{img_type} <#{url_store}|#{image_product[:model]}>, арт. #{image_product[:sku]}. <#{url_admin}|Редактировать>"}
      ::SlackJob.perform_async(args.merge("channel" => "photo_team", "user" => "photo_bot"))
      if foto_id == 100
        args["message"] = "Добавлен товар <#{url_store}|#{image_product[:model]}>, арт. #{image_product[:sku]}."
        ::SlackJob.perform_async(args.merge("channel" => "new_items", "user" => "ls_admin"))
        ::SlackJob.perform_async(args.merge("channel" => "luxury_new_items", "user" => "gp_bot"))
        ::SlackJob.perform_async(args.merge("channel" => "new_items", "user" => "ls_offline_admin"))
      end
    end
  end
  many_to_one :product
end

class OneClick < Sequel::Model(:one_click)
  many_to_one :product
  many_to_one :user
end

class DeliveryCompany < Sequel::Model(:delivery_companies)
  one_to_many :orders
end

class PaymentMethod < Sequel::Model(:payment_methods)
  one_to_many :orders
  one_to_many :payments
end

class Payment < Sequel::Model(:payments)
  many_to_one :payment_method
  many_to_one :order
  many_to_one :user
end

class AppSession < Sequel::Model(:app_sessions)
  many_to_one :user
end

class WebSession < Sequel::Model(:web_sessions)
  many_to_one :user
  one_to_many :product_views
  def after_create
    super
    update(created: Time.now)
  end
end

class ProductView < Sequel::Model(:product_views)
  many_to_one :web_session
  many_to_one :user
  many_to_one :product
end

class ProductViewCounter < Sequel::Model(:product_view_counters)
  many_to_one :product
end

class ProductSet < Sequel::Model(:sets)
  many_to_many :products, join_table: :sets_products, left_key: :set_id
  many_to_one :main_product, class: :Product
  def after_create
    super
    args = {"channel" => "photo_team", "user" => "photo_bot"}
    product = main_product
    url_store = "https://lsboutique.ru/products/#{product.product_id}/"
    args["message"] = "Добавлен набор для <#{url_store}|#{product[:model]}>, арт. #{product[:sku]}."
    ::SlackJob.perform_async args
  end
end

class PriceChange < Sequel::Model(:price_changes)
  many_to_one :product
end

class OrderComment < Sequel::Model(:order_comments)
  many_to_one :order
  many_to_one :user
end

class UserComment < Sequel::Model(:user_comments)
  many_to_one :commenter, class: :User, key: :commenter_id
  many_to_one :user
end

class Banner < Sequel::Model(:banners)
  plugin :list
end

class TsumPrice < Sequel::Model(:tsum_prices)
  many_to_one :product
end

class Call < Sequel::Model(:calls)
  many_to_one :client, class: :User, key: :client_id
  many_to_one :manager, class: :User, key: :manager_id
end

class OfflineCall < Sequel::Model(:calls_log)
  many_to_one :user
  many_to_one :offline_manager, key: :manager_id
end

class Shop < Sequel::Model(:shops)
  one_to_many :names, class: :ShopName
  one_to_many :items
  one_to_many :warehouses
  one_to_many :cashboxes, class: :Cashbox
  many_to_many :products, join_table: :items do |ds|
    ds.group(:product_id)
  end
  many_to_many :users, join_table: :users2shops

  def after_create
    super
    add_name(name: name)
  end

  dataset_module do
    def by_name(name)
      where(names: ::ShopName.where(name: name))
    end
  end
end

class ShopName < Sequel::Model(:shop_names)
  many_to_one :shop
end

class Warehouse < Sequel::Model
  one_to_many :items
  many_to_one :shop
  one_to_many :movements_to, class: :Movement, key: :warehouse_to
  one_to_many :movements_from, class: :Movement, key: :warehouse_from
  def after_create
    super
    s_shop = ::Shop.where(name: name).first || ::Shop.create(name: name, enabled: false)
    update(shop: s_shop)
  end
end

class Item < Sequel::Model(SUB_DB_NAMES[:items] || :items)
  many_to_one :product
  many_to_one :shop
  many_to_one :warehouse
  many_to_one :entity
  many_to_one :super_size, key: :size_id
  one_to_many :order_products
  subset :megasale, shop: ::Shop.where(:name.ilike("SALE Online Shop%"))
  subset :buyable, Sequel.&(Sequel.~(quantity: 0), warehouse: ::Warehouse.where(im_show: true))

  def move_to_warehouse(warehouse, qty = 1)
    tmp_item = ::Item.where(barcode: barcode, warehouse: warehouse).first ||
      copy_to_warehouse(warehouse)
    if quantity <= qty
      update(do_not_update: true, quantity: 0)
    else
      update(do_not_update: true, quantity: :quantity - Sequel.expr(qty))
    end
    tmp_item.update(do_not_update: true, quantity: :quantity + Sequel.expr(qty))
  end

  def copy_to_warehouse(warehouse)
    tmp_values = to_hash.dup
    tmp_values.delete(:item_id)
    tmp_values.delete(:accepted)
    tmp_values.merge!(warehouse_id: warehouse.warehouse_id,
      shop_id: warehouse.shop_id, entity_id: 0, quantity: 0)
    ::Item.create(tmp_values)
  end

  def compute_size
    if size_system.empty? || size_type.zero?
      update(size_system: compute_size_system!)
    end
    case size_system
    when "ru"
      SuperSize.where(size_type: size_type, ru_size: size).first
    when "int"
      SuperSize.where(size_type: size_type, int_size: size).first
    else
      ss = SuperSize.where(size_type: size_type)
      SizeName.where(size: size, size_m_s: size_system, super_size: ss).first&.super_size
    end
  end

  def compute_normal_size
    ss = super_size
    unless ss
      ss = compute_size
      return "" unless ss
      update(super_size: ss)
    end
    case product.category[:parent]
    when 1
      return ss.int_size
    when 2
      return ss.size_names_dataset.where(size_m_s: "Европа (EU)").first&.size
    end
    ""
  end

  def compute_size_type
    (product.sex == 2) ? product.category&.womens_size_type_id : product.category&.mens_size_type_id
  end

  def compute_size_system!
    compute_size_system(update: true)
  end

  def compute_size_system(update: false)
    if size_type.zero? || update
      self.update(size_type: compute_size_type)
    end
    case size_type
    when 0
      nil
    when 1, 2
      (size.to_i < 20) ? "Англия (UK)" : "Европа (EU)"
    when 3, 4
      size[/^\d?[XSML]+$/] ? "int" : "Италия (IT)"
    when 5
      return "int" if size[/^\d?[XSML]+$/]
      return "Деним" if size.to_i < 44
      return "Италия (IT)" if size.to_i > 44
      if size == "44"
        all_items = Item.where(product_id: product_id).map(:size).map(&:to_i).sort
        (all_items.first == size.to_i) ? "Италия (IT)" : "Деним"
      end
    when 6
      return "int" if size[/^\d?[XSML]+$/]
      return "Деним" if size.to_i < 34
      return "Италия (IT)" if size.to_i > 34
      if size == "34"
        all_items = Item.where(product_id: product_id).map(:size).map(&:to_i).sort
        (all_items.first == size.to_i) ? "Италия (IT)" : "Деним"
      end
    when 13
      return "int" if size[/^\d?[XSML]+$/]
      return "Италия (IT)" if size.to_i > 47
      "Размер по вороту (Обхват шеи) (см)"
    end
  end

  dataset_module do
    def order_by_size
      order(Sequel.lit("FIELD(items.size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+'), items.size ASC"))
    end
  end
end

class SuperSize < Sequel::Model(:sizes)
  one_to_many :items, key: :size_id
  one_to_many :size_names, key: :size_id
end

class SizeName < Sequel::Model(:size_names)
  many_to_one :super_size, key: :size_id
end

class PremoderationItem < Sequel::Model
  many_to_one :user, key: :accepted_user_id
end

class RfiTransaction < Sequel::Model
  many_to_one :order
end

class SberTransaction < Sequel::Model
  many_to_one :order, key: :order_key
end

class DepositTransaction < Sequel::Model(:deposit_history)
  many_to_one :user
  many_to_one :manager, key: :admin_id
  many_to_one :payment_method_offline, key: :payment_method_id
end

class Cashbox < Sequel::Model(:shop_cashbox)
  one_to_many :orders
  one_to_many :offline_payments
  many_to_one :shop
  many_to_one :entity
end

class PaymentMethodOffline < Sequel::Model(:payment_offline)
  one_to_many :offline_payments, key: :payment_id
end

class OfflinePayment < Sequel::Model(:orders_payments)
  many_to_one :payment_type, class: PaymentMethodOffline, key: :payment_id
  many_to_one :order
  many_to_one :user
  many_to_one :cashbox
  many_to_one :debt
end

class Debt < OfflinePayment
  set_dataset(where(payment_type: PaymentMethodOffline.where(name: "Долг")))
  one_to_many :debt_payoffs
  subset :unpaid, debt_paid_off: false

  def paid_off
    debt_payoffs_dataset.sum(:money_paid).to_f
  end

  def remaining
    money_paid - paid_off
  end
end

class DebtPayoff < OfflinePayment
  set_dataset(exclude(debt_id: 0))
  many_to_one :user
  def validate
    super
    errors.add(:debt_id, "can't be zero") if debt_id.zero?
    errors.add(:user_id, "can't be zero") if user_id.zero?
  end
end

class Return < OfflinePayment
  set_dataset(where(payment_type: PaymentMethodOffline.where(name: ["Возврат наличными", "Возврат на карту"])))
  many_to_one :user
end

class Movement < Sequel::Model
  many_to_many :items, join_table: :movement_items, select: [Sequel.lit("items.*"), Sequel[:movement_items][:quantity], Sequel[:movement_items][:accepted]]
  many_to_one :original_warehouse, class: Warehouse, key: :warehouse_from
  many_to_one :destination_warehouse, class: Warehouse, key: :warehouse_to
end

class Reservation < Movement
  set_dataset(where(Sequel.|(
    {original_warehouse: Warehouse.where(reservation: 1)},
    {destination_warehouse: Warehouse.where(reservation: 1)}
  )))
end

class Entity < Sequel::Model(:entities)
  one_to_many :items
  one_to_many :cashboxes
end

class OneTimeLink < Sequel::Model(:one_time_links)
  many_to_one :user

  def self.create_for_user(user)
    if user.is_a? User
      user_id = user.user_id
    elsif user.is_a? Integer
      user_id = user
    else
      return nil
    end
    token = SecureRandom.hex(32)
    code = Digest::SHA256.hexdigest(token + ENV["APP_SECRET"])
    OneTimeLink.create(user_id: user_id, code: code, created: Time.now)
    token
  end
end

class Service < Sequel::Model(:services_orders)
  one_to_many :service_items, key: :order_id
  many_to_one :user, key: :client_id
  many_to_one :order, key: :real_order_id

  def offline_url(hostname = LS_HOST)
    hostname + "index.php?module=Service&service_order_id=#{id}"
  end
end

class ServiceItem < Sequel::Model(:services_orders_items)
  many_to_one :service, key: :order_id
  subset :drycleaning, service_type_id: 1
end

class Message < Sequel::Model
  many_to_one :campaign
  many_to_one :user
  many_to_one :app_session
end

class Campaign < Sequel::Model
  one_to_many :messages
end

class WorkHour < Sequel::Model
  many_to_one :user
end

class City < Sequel::Model
  many_to_one :editor, key: :editor_id, class: :User
  plugin :list
  one_to_many :delivery_prices
end

class CdekAccount < Sequel::Model(:TK_ip)
  set_dataset(where(company_id: 5))
end

class Expense < Sequel::Model
  many_to_one :user
  many_to_one :cashbox
  many_to_one :shop
end

class Inkass < Sequel::Model(:inkass)
  many_to_one :user
  many_to_one :cashbox
  many_to_one :shop
end

class DeliveryMethod < Sequel::Model
  one_to_many :delivery_prices
end
