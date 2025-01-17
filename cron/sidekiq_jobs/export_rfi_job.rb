require './models'
require './s3_class'
require 'smarter_csv'

class ExportRfiJob
  include Sidekiq::Worker

  def perform
    date = Date.today
    filename = "export_rfi_#{date}.csv"
    File.open(filename, "w:utf-8") do |file|
      file.puts "НомерЗаказа;Время;ОбщаяСумма;СуммаБезКомиссии;IDТранзакции"
      RfiTransaction.where(datetime: (date...date+1)).each do |i|
        file.puts [
          i.order_id,
          i.datetime,
          i.system_income,
          i.partner_income,
          i.tid
        ].join(";")
      end
    end

    S3Wrapper.new.put(filename)
    File.delete(filename)
  end
end
