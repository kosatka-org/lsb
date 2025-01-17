require './models'
require 'trello'
require 'sanitize'


class BauPaymentJob
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(args)
    @client = Trello::Client.new(
      developer_public_key: ENV['TRELLO_DEVELOPER_KEY'],
      member_token: ENV['TRELLO_MEMBER_TOKEN']
    )

    card = @client.find(:card, args['card_id'])
    card.name = card.name + " - Оплачен"
    str = ["Время оплаты: #{Time.now.strftime('%Y-%m-%d %H:%M')}",
      "Сумма: #{args['sum']}",
      "ID заказа: #{args['code']}",
      "ID транзакции: #{args['transaction_id']}"].join("\n")
    card.desc = card.desc + "\n #{str}"
    card.save
  end
end
