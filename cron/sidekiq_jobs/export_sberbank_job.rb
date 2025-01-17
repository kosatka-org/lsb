require './models'
require './s3_class'
require 'smarter_csv'

class ExportSberbankJob
  include Sidekiq::Worker

  def perform
    date = Date.today
    filename = "export_sberbank_#{date}.csv"
    File.open(filename, "w:utf-8") do |file|
      file.puts "НомерЗаказа;Время;Сумма;IDТранзакции"
      SberTransaction.where(operation: 'deposited', status: 1, datetime: (date...date+1)).each do |i|
        file.puts [
          i.order_key,
          i.datetime,
          i.amount.to_f,
          i.md_order
        ].join(";")
      end
    end

    S3Wrapper.new.put(filename)
    File.delete(filename)
  end
end
