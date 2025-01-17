require 'concurrent'

class ProductImportRow
  def initialize(row, opts)
    @product = Product[code: row[:код]]
    @row = row
    @opts = opts
  end

  attr_accessor :product, :row, :opts

  def process
    return unless product
    [
      product.product_id,
      final_price,
      old_price,
      offline_price,
      last_price,
      size,
      sku,
      sex,
      item_location,
      season,
      season_type,
      last_price_update,
      last_price_online
    ]
  end

  def price
    @price ||= parse_price(row[:цена])
  end

  def final_price
    return product.price if product.super_price
    fp = sale_setting ? sale_price : (price - discount)
    [last_price_online, fp].max
  end

  def old_price
    return product.old_price if product.super_price
    if sale_setting
      price == sale_price ? 0 : price
    else
      discount == 0 ? 0 : price
    end
  end

  def offline_price
    price
  end

  def last_price
    parse_price row[:последняяцена]
  end

  def discount
    parse_price row[:скидка]
  end

  def sale_price
    @sale_price ||= [price*(100-sale_setting[:sale])/100.0, last_price_online].max
  end

  def size
    return unless row[:размер]
    "|" + row[:размер].to_s.gsub('#', '|') + "|"
  end

  def sku
    row[:артикул].to_s
  end

  def sex
    case row[:пол]
    when /U/ then 1
    when /D/ then 2
    else 0
    end
  end

  def season
    return @season if @season
    if product.preserve_season
      @season = product.season
    else
      @season = row[:сезон].to_s[/\d\d[\/ ]\d/].to_s.sub(" ", "/")
      @season = product.created > Time.new(2018,11,15) ? @season.sub('18/2', '19/1') : @season
      @season = product.created > Time.new(2019,5,6) ? @season.sub('19/1', '19/2') : @season
    end
  end

  def item_location
    row[:месторасположение].to_s
  end

  def last_price_update
    @last_price_update ||=
    if final_price == product.price
      product.last_price_update
    else
      t = Time.now
      PriceChange.create(
        product: product,
        old_price: product.price,
        new_price: final_price,
        date: t
      )
      t
    end
  end

  def last_price_online
    @last_price_online ||=
    if sale_setting && sale_setting[:max_sale]
      price*(100-sale_setting[:max_sale])/100.0
    else
      last_price
    end
  end

  def season_type(season_str = season)
    @season_type ||=
    case season_str
    when /#{opts[:new_season]}/
      'new_season'
    when /#{opts[:previous_season]}/
      'previous_season'
    when ->(s) { s.sub("/", ".").to_f > opts[:new_season].sub("/", ".").to_f }
      'next_season'
    else
      'old_seasons'
    end
  end

  def sale_setting
    @sale_setting ||= opts[:sale_settings].find do |s|
      s[:brand_id] == product.brand_id && s[:season] == season_type
    end
  end

  def parse_price(str)
    str.to_s.delete("  ").to_f
  end

end
