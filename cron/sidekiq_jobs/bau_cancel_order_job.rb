require './models'
require 'trello'

class BauCancelOrderJob
  include Sidekiq::Worker

  def perform(args)
    order = BauOrder[args['order_id'].to_i]
    return unless order

    @client = Trello::Client.new(
      developer_public_key: ENV['TRELLO_DEVELOPER_KEY'],
      member_token: ENV['TRELLO_MEMBER_TOKEN']
    )
    card = @client.find(:card, order.card_id)
    cancelled_board = @client.find(:board, ENV['BAU_CANCELLED_BOARD'])
    card.move_to_board cancelled_board

    order.update(enabled: false)
  end
end
