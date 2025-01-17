require 'http'
require 'json'

class LifepayExportJob
  include Sidekiq::Worker

  def perform(args)
    payment = Payment[args['payment_id']]
    order = payment.order
    order_products = order.order_products_dataset
    total = order_products.sum(:price)

    if payment.amount.to_f < total
      order_products = order_products.with_partial_payment(payment.amount.to_f)
    end

    products = order_products.to_a.map do |op|
      { name: op.product_name,
        price: op.price.to_s,
        discount: op['remaining_payment'] ? {type: 'amount', value: op['remaining_payment']} : nil,
        quantity: 1,
        tax: 'none' }.compact
    end

    data = {
      apikey: ENV['LIFEPAY_API_KEY'],
      login: ENV['LIFEPAY_LOGIN'],
      mode: 'email',
      purchase: {
        products: products
      },
      customer_phone: order.user.phone_number,
      customer_email: order.user.email,
      ext_id: payment.id.to_s,
      card_amount: payment.amount
    }
    response = HTTP.post(ENV['LIFEPAY_API_URL'], json: data)
    if response.code == 200
      res_json = JSON.parse(response.body.to_s) rescue nil
      if res_json['code'] == 0
        lifepay_uuid = res_json.dig('data', 'uuid')
        payment.update(lifepay_uuid: lifepay_uuid)
      else
        SlackJob.perform_async({'channel' => 'lsboutique_log', "message" => "Lifepay error: ```#{res_json}``` \ndata: ```#{JSON.pretty_generate(data)}```"})
      end
    end
  end
end
