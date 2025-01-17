require 'http'

class EvotorClient
  def initialize(api_key: ENV['EVOTOR_API_KEY'], order: Object.new,
      api_url: 'https://www.1c-tools.ru/proxy/v1')
    @api_key = api_key
    @api_url = api_url
    @order = order
  end

  def print_receipt_data(order = @order)
    return unless order.respond_to?(:cashbox) && order.cashbox&.device_uuid.to_s.length > 0
    [
      {
        "uuid": order.generate_uuid!,
        "type": "SELL",
        "mode": 1,
        "fiscal": true,
        "description": "Продажа №#{order.receipt_number}",
        "email": "Email@email.ru",
        "phone": "5890000000000",
        "payments": order.offline_payments.map { |payment|
          {
            type: payment.payment_type.evotor_type,
            sum:  payment.money_paid.to_f
          }
        },
        "positions": order.order_products.map { |op|
          {
            uuid: op.product&.uuid,
            type: "NORMAL",
            name: op.product_name,
            quantity: op.quantity,
            measureName: "шт",
            price: op.price,
            priceWithDiscount: op.price,
            taxNumber: "NO_VAT"
          }
        },
        extra: {
          "Комментарий" => order.comment
        }
      }
    ]
  end

  def print_receipt(order = @order)
    endpoint = @api_url + "/putReceipts/#{order.cashbox.device_uuid}"
    data = print_receipt_data(order)
    send_request(endpoint, data)
  end

  def send_request(url, data)
    begin
      HTTP.timeout(connect: 10, write: 10, read: 30)
        .headers("X-Authorization" => @api_key)
        .post(url, json: data)
    rescue HTTP::TimeoutError
      return {response: {order: [{error_code: 408, msg: "Сервер внешнего API не отвечает"}]}}
    end
  end
end
