require './models'
require './s3_class'
require 'smarter_csv'

class ImportPremoderationItemsJob
  include Sidekiq::Worker

  def perform(filename: "ImportZakazovPostavshiku.csv", local: false)
    unless local
      File.open(filename, "w:utf-8") { |f| f.write S3Wrapper.new.get(filename) }
    end

    data = File.open(filename, "r:bom|utf-8") do |f|
      SmarterCSV.process(f, col_sep: ';', quote_char: '無')
    end

    data.each do |r|
      barcode = (r[:штрихкод] || next).to_s
      next if PremoderationItem[barcode: barcode]
      PremoderationItem.create(
        code: r[:кодтовара],
        ean: r[:баркод].to_s,
        sku: r[:артикул],
        sku_search: r[:артикул].to_s.gsub(/\s/, ""),
        name: r[:наименование],
        size: r[:размер],
        color: r[:цвет],
        barcode: r[:штрихкод],
        quantity: r[:количество],
        sum: r[:сумма].to_s.sub(",", ".").to_f,
        created_at: r[:дата],
        order_number: r[:номерзаказа],
        sex: (r[:пол] || 'муж'),
        material: r[:состав].to_s,
        supplier: r[:поставщик]
      )
    end
  end
end
