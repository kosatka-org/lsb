require './models'
require './s3_class'
require 'smarter_csv'

class ExportDeliveryOrdersJob
  include Sidekiq::Worker

  def perform
    date = Date.today
    orders = Order.where(order_products: OrderProduct.accepted.where(status_date: (date-30)..date))
      .exclude(invoice_number: '').exclude(delivery_company_id: 0)
    filename = "export_delivery_orders.csv"
    File.open(filename, "w:utf-8") do |file|
      file.puts "НомерЗаказа;ДатаЗаказа;ТранспортнаяКомпания;НомерНакладной;Сумма;СпособОплаты"
      orders.each do |o|
        sum = o.order_products_dataset.accepted.sum(:price) - o.payment_prepaid - o.deposit_payment
        file.puts [
          o.order_id,
          o.date,
          o.delivery_company&.name,
          o.invoice_number,
          sum.to_f,
          o.payment_method&.name
        ].join(";")
      end
    end

    S3Wrapper.new.put(filename)
    File.delete(filename)
  end
end
