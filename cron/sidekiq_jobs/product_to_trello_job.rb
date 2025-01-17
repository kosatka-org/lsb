require 'trello'
require 'sanitize'
Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

class ProductToTrelloJob
  include Sidekiq::Worker

  def perform(args)
    video_board = Trello::Board.find(ENV['TRELLO_VIDEO_BOARD'])
    product_id = args['product_id'] || return
    product = Product[args['product_id']]
    return unless product.price > 50000

    list = video_board.lists.find {|l| l.name == 'Новые' }

    if product.trello_card
      begin
        card = Trello::Card.find(product.trello_card)
      rescue Trello::Error => e
        return
      end
      return unless card.list_id == list.id
    else
      card = nil
    end

    text = "ID: #{product.product_id}\n"
    text << "Ссылка в магазине: https://lsboutique.ru/products/#{product.url}/\n"
    text << "Ссылка в админке: https://lsboutique.ru/admin/index.php?section=Product&item_id=#{product.product_id}\n\n"

    unless product.description.empty?
      text << "#От редактора\n"
      text << Sanitize.fragment(product.description)
      text << "\n\n"
    end

    unless product.body.empty?
      text << "#Детали\n"
      text << Sanitize.fragment(product.body, :whitespace_elements => {
        'br'  => { :before => "\n", :after => "" },
        'div' => { :before => "\n", :after => "\n" },
        'p'   => { :before => "\n", :after => "\n" }
      }).lstrip
      text << "\n"
    end

    unless product.text_sizes.empty?
      text << "#Состав\n"
      text << Sanitize.fragment(product.text_sizes)
      text << "\n\n"
    end

    unless product.uhod.empty?
      text << "#Уход\n"
      text << Sanitize.fragment(product.uhod)
    end

    name = "#{product.product_id} #{product[:model]} #{product.sku} #{product.price} руб."

    if card
      card.desc = text
      card.name = name
      card.save
    else
      card = Trello::Card.create(name: name, desc: text, list_id: list.id)
      product.update(trello_card: card.short_url.split("/").last)
    end
  end

end
