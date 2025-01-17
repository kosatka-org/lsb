require './db_connect.rb'
require 'trello'
require 'sanitize'


class TrelloJob
  include Sidekiq::Worker

  def perform(args)
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_DEVELOPER_KEY']
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end

    list_id = '54b95bfa4ddbaa3d1d269b2b'

    error_name = args['error']
    message = args['message']
    begin
      member = case error_name
      when 'Некачественно обработанная фотография'
        # Евгений Шапошников
        Trello::Member.find('redlayne')
      when 'Ошибка в описании товара'
        # Татьяна Неровня
        Trello::Member.find('nerovnya')
      when 'Не работает оборудование торговой точки'
        # Алексей Костин
        Trello::Member.find('alekseikostin')
      else
        nil
      end
    rescue
      member = nil
    end
    card = Trello::Card.create(name: error_name, desc: Sanitize.fragment(message), list_id: list_id)
    card.add_member(member) if member
  end

end
