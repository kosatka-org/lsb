require 'concurrent'
require 'smarter_csv'
require './models'
require './item_import_row.rb'

class ItemImport
  def initialize(csv = "shop.csv")
    @csv = csv
    @fields = ["item_id",
      "shop_id",
      "entity_id",
      "product_id",
      "size",
      "size_id",
      "normal_size",
      "quantity",
      "ean"].freeze

    @new_season = Settings.current_new_season
    @previous_season = Settings.previous_season
    @sale_settings = DB[:sale_settings].all.freeze
  end

  attr_accessor :fields

  def run!
    DB.create_table(:p_tmp, temp: true, as: "SELECT * FROM products LIMIT 0")
    DB[:p_tmp].import(fields.map(&:to_sym), get_update_data)
    update = fields.inject({}) do |m, f|
      next m if f == "product_id"
      m[Sequel[:products][f.to_sym]] = Sequel[:p_tmp][f.to_sym]
      m
    end
    update.merge!(Sequel[:products][:sold] => 0)
    Product.where(sold: 0, show_out_of_stock: 0).update(sold: 1, sold_date: Date.today)
    Product.dataset.join(:p_tmp, {product_id: :product_id})
      .exclude{Sequel.&(Sequel[:products][:super_price] =~ 1,
                        Sequel[:p_tmp][:price] !~ Sequel[:p_tmp][:price])}
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
