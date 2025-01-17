require 'concurrent'
require 'smarter_csv'
require './models'
require './product_import_row.rb'

class ProductImport
  def initialize(csv = "export.csv")
    @csv = csv
    @fields = ["product_id",
      "price",
      "old_price",
      "offline_price",
      "last_price",
      "size",
      "sku",
      "sex",
      "item_location",
      "season",
      "season_type",
      "last_price_update",
      "last_price_online"].freeze

    @new_season = DB[:settings].where(name: 'current_new_season').first&.to_hash&.fetch(:value).freeze
    @previous_season = DB[:settings].where(name: 'previous_season').first&.to_hash&.fetch(:value).freeze
    @sale_settings = DB[:sale_settings].all.freeze
  end

  attr_accessor :fields

  def run!
    DB.drop_table?(:products_temp)
    DB.run("CREATE TABLE products_temp LIKE products;")
    DB[:products_temp].import(fields.map(&:to_sym), get_update_data)
    update = fields.inject({}) do |m, f|
      next m if f == "product_id"
      m[Sequel[:products][f.to_sym]] = Sequel[:products_temp][f.to_sym]
      m
    end
    update.merge!(Sequel[:products][:sold] => 0)
    Product.where(sold: 0, show_out_of_stock: 0).update(sold: 1, sold_date: Date.today)
    Product.dataset.join(:products_temp, {product_id: :product_id})
      .exclude{Sequel.&(Sequel[:products][:super_price] =~ 1, Sequel[:products_temp][:price] !~ Sequel[:products_temp][:price])}
      .update(update)
  end

  def get_update_data
    tasks = File.open(@csv, "r:bom|utf-8") do |f|
      SmarterCSV.process(f, col_sep: ';', quote_char: '𝝻', chunk_size: 4000).map do |arr|
        Concurrent::Promises.future(arr) {|arr| process_rows(arr) }
      end
    end
    Concurrent::Promises.zip(*tasks).value!.reduce(&:+).compact
  end

  def process_rows(rows)
    rows.map {|row| process_row row}
  end

  def process_row(row)
    opts = {
      new_season: @new_season,
      previous_season: @previous_season,
      sale_settings: @sale_settings
    }
    ProductImportRow.new(row, opts).process
  end
end
