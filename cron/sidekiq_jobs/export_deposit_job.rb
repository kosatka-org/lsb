require './models'
require './s3_class'

class ExportDepositJob
  include Sidekiq::Worker

  def perform
    date = Date.today
    filename = "export_deposit_#{date}.csv"
    File.open(filename, "w:utf-8") do |file|
      file.puts "НомерЗаказа;Время;ОбщаяСумма;ОплатаДепозитом"
      Order.where(date: (date...date+1)).exclude(deposit_payment: 0).each do |o|
        file.puts [
          o.order_id,
          o.date,
          o.order_products_dataset.sum(:price),
          o.deposit_payment
        ].join(";")
      end
    end

    # upload to S3 if more than one line
    if `wc -l '#{filename}'`.to_i > 1
      S3Wrapper.new.put(filename)
    end
    File.delete(filename)
  end
end
