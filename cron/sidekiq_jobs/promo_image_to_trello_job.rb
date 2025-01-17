require 'trello'
require 'sanitize'
Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

class ProductToTrelloJob
  include Sidekiq::Worker

  def perform(product_id)
    video_board = Trello::Board.find(ENV['TRELLO_VIDEO_BOARD'])
    product = Product[product_id]
    return if product&.trello_card.to_s.empty?

    card = Trello::Card.find(product.trello_card)
    card.add_attachment(File.new("../files/products/#{product.promo_image}"))
  end
end
