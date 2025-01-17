require './models'
require './s3_class'
require 'smarter_csv'

class ExportPremoderationItemsJob
  include Sidekiq::Worker

  def perform
    date = Date.today
    items = PremoderationItem.where(accepted: true, accepted_at: (date...date+1), exported: false)
    return if items.count == 0
    filename = "export_premoderation_#{date}_#{Time.now.strftime('%H')}.csv"
    item_ids = []
    File.open(filename, "w:utf-8") do |file|
      file.puts "КодТовара;Баркод;Артикул;Наименование;Размер;Цвет;Штрихкод;Количество;Сумма;Дата;НомерЗаказа;Пол;Состав;Поставщик;КодСклада"
      items.each do |i|
        file.puts [
          i.code,
          i.ean,
          i.sku,
          i.name,
          i.size,
          i.color,
          i.barcode,
          i.quantity_accepted,
          i.sum,
          i.created_at,
          i.order_number,
          i.sex,
          i.material,
          i.supplier,
          i.user&.warehouse&.code
        ].join(";")
        item_ids.push i.id
      end
    end

    S3Wrapper.new.put(filename)
    PremoderationItem.where(id: item_ids).update(exported: true)
    File.delete(filename)
  end
end
