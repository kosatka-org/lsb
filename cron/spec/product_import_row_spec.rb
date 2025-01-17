require './spec/spec_helper'
require './models'
require './product_import_row'

describe ProductImportRow, focus: true do
  before do
    @product_import_row = ProductImportRow.new({:код=>51864,
  :категория=>"Боксеры",
  :дизайнер=>"D&G",
  :наименование=>"Боксеры муж DOLCE&GABBANA Regular 100%хлопок",
  :пол=>"U",
  :артикул=>"N4A77J FR7B8 S8056",
  :страна_происхождения=>"ITALY",
  :размер=>"4#6",
  :цвет=>"белый",
  :наличие=>"4  белый#6  белый",
  :цена=>"6 500",
  :сезон=>"20/1main",
  :скидка=>0,
  :месторасположение=>"Жехаревы",
  :штрихкод=>"2000001327777#2000001327784#2000001327791#2000001327807#2000001327814",
  :новый_артикул=>"D&G00851",
  :предыдущаяцена=>0,
  :последняяцена=>0,
  :использоватьмахскидку=>0,
  :остатки=>"4#белый#30#1@6#белый#30#2"}, {
    new_season: DB[:settings].where(name: 'current_new_season').first&.to_hash&.fetch(:value),
    previous_season: DB[:settings].where(name: 'previous_season').first&.to_hash&.fetch(:value),
    sale_settings: DB[:sale_settings].all,
    fields: ["sold",
      "price",
      "old_price",
      "offline_price",
      "last_price",
      "size",
      "sku",
      "sex",
      "item_location",
      "season_type",
      "last_price_online"].freeze
    })
  end

  describe "#process" do
    before do
    end

    it "returns an Array" do
      expect( @product_import_row.process ).to be_a(Array)
    end
  end

  describe "#price" do
    it "returns 48000.0" do
      expect( @product_import_row.price ).to be_eql(6500.0)
    end
  end

  describe "#size" do
    it "returns |4|6|" do
      expect( @product_import_row.size ).to be_eql('|4|6|')
    end
  end

  describe "#sex" do
    it "returns 1 if sex string contains 'U'" do
      @product_import_row.row[:пол] = "U***"
      expect( @product_import_row.sex ).to be_eql(1)
    end
    it "returns 2 if sex string contains 'D'" do
      @product_import_row.row[:пол] = "D***"
      expect( @product_import_row.sex ).to be_eql(2)
    end
    it "returns 0 if sex string does not contain 'D' or 'U'" do
      @product_import_row.row[:пол] = "KJHFHF***"
      expect( @product_import_row.sex ).to be_eql(0)
    end
  end

  describe "#parse_price" do
    it "returns a float parsed from string" do
      expect( @product_import_row.parse_price("43522.00") ).to be_eql(43522.00)
    end
  end

  describe "#season" do
    it "returns a string that looks like 19/1" do
      expect( @product_import_row.season ).to match(/^\d{1,2}\/\d{1}$/)
    end

    it "changes 18/2 to 19/1 if older than 2018-11-15" do
      @product_import_row.row[:сезон] = "18/2"
      @product_import_row.product.created = Time.new(2018,11,20)
      expect( @product_import_row.season ).to be_eql('19/1')
      @product_import_row.product.created = Time.new(2018,10,20)
    end

    it "changes 19/1 to 19/2 if older than 2019-05-06" do
      @product_import_row.row[:сезон] = "19/1"
      @product_import_row.product.created = Time.new(2019,5,7)
      expect( @product_import_row.season ).to be_eql('19/2')
      @product_import_row.product.created = Time.new(2018,10,20)
    end

    it "does not update if `preserve_season` for product is true" do
      @product_import_row.product.preserve_season = true
      @product_import_row.product.season = '16/1'
      @product_import_row.row[:сезон] = "22/2"
      expect( @product_import_row.season ).to be_eql('16/1')
      @product_import_row.product.preserve_season = false
    end
  end

  describe "#season_type" do
    before do
      @new_season = DB[:settings].where(name: 'current_new_season').first&.to_hash&.fetch(:value)
      @previous_season = DB[:settings].where(name: 'previous_season').first&.to_hash&.fetch(:value)
    end
    context "Higher than current new season" do
      it "returns next season" do
        expect( @product_import_row.season_type("20/0") ).to be_eql('next_season')
      end
    end

    context "Equal current new season" do
      it "returns new season" do
        expect( @product_import_row.season_type(@new_season) ).to be_eql('new_season')
      end
    end

    context "Equal previous season" do
      it "returns previous season" do
        expect( @product_import_row.season_type(@previous_season) ).to be_eql('previous_season')
      end
    end

    context "All other" do
      it "returns old seasons" do
        expect( @product_import_row.season_type("13/1") ).to be_eql('old_seasons')
      end
    end
  end

  after do

  end
end
