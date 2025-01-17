require './models'
require './s3_class'
require 'smarter_csv'

class ImportPaymentsJob
  include Sidekiq::Worker

  def perform
    filename = "ImportOplatIM.csv"
    File.open(filename, "w:utf-8") { |f| f.write S3Wrapper.new.get(filename) }
    data = File.open(filename, "r:bom|utf-8") do |f|
      SmarterCSV.process(f, col_sep: ';', quote_char: '無')
    end

    data.each do |r|
      barcode = (r[:штрихкод] || next).to_s
      sum = r[:сумма].to_s.gsub(",", ".").gsub(/[^0-9.]/, "").to_f
      op = OrderProduct.where(barcode: barcode,
        status: 5, #только принятые
        price: sum,
        transaction_completed: false).last || next
      op.update(transaction_completed: true)
      unpaid_items = op.order.order_products_dataset.where(
        transaction_completed: false,
        status: 5).count
      op.order.update(money_received: true) if unpaid_items == 0
    end
  end
end
