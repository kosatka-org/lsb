require './models'
require './s3_class'
require 'smarter_csv'

class ImportMovementsJob
  include Sidekiq::Worker

  def perform
    filename = "ImportMovements.csv"
    File.open(filename, "w:utf-8") { |f| f.write S3Wrapper.new.get(filename) }
    data = File.open(filename, "r:bom|utf-8") do |f|
      SmarterCSV.process(f, col_sep: ';', quote_char: '無')
    end

    data.each do |r|
      wh_from = Warehouse.where(code: r[:складотправитель].to_i).first
      wh_to = Warehouse.where(code: r[:складполучатель].to_i).first
      movement = Movement.find_or_create(
        movement_id_1s: r[:номердокумента],
        warehouse_from: wh_from.warehouse_id,
        warehouse_to: wh_to.warehouse_id,
        date: Date.parse(r[:датадокумента].to_s)
      )

      barcode = (r[:шк] || next).to_s
      quantity = r[:количество].to_i
      item = Item.where(barcode: barcode).first
      movement.add_item(item) if item && !movement.items.include?(item)
      if quantity > 1 && item
        DB[:movement_items].where(movement_id: movement.id, item_id: item.id).update(quantity: quantity)
      end

      OrderProduct.where(barcode: barcode, transaction_completed: false).last&.update(transaction_completed: true)
    end
  end
end
