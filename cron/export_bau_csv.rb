require './models'
require './error_service'
require 'dropbox'
require 'trello'

@client = Trello::Client.new(
  developer_public_key: ENV['TRELLO_DEVELOPER_KEY'],
  member_token: ENV['TRELLO_MEMBER_TOKEN']
)

parsed_date = if ARGV[0]
  Date.parse(ARGV[0].to_s)
else
  Date.today
end

filename = "obed_store_orders_#{parsed_date}.csv"

orders = BauOrder.where(delivery_date: parsed_date, enabled: 1)
if orders.count.zero?
  puts "No orders for given date #{parsed_date}, exiting"
  exit
end

ifilename = filename.sub("orders", "items")
ifile = File.new(ifilename, "w:windows-1251")
ifile.puts "IDЗаказа;ЦенаЗаШт;Количество;IDТовара;Наименование"

File.open(filename, "w:windows-1251") do |file|
  file.puts "ID;Цена;Email;Организация"
  orders.each do |o|
    if parsed_date == Date.today
      begin
        card = @client.find(:card, o.card_id)
        if card.closed?
          o.update(enabled: false)
          next
        end
      rescue Trello::Error
        o.update(enabled: false)
        next
      end
    end
    items = JSON.parse o.items
    sum = items.map {|i| i['price'].to_i * i['quantity'] }.reduce(:+)
    file.puts [
      o.id,
      sum,
      o.email,
      o.domain
    ].join(";")
    items.each do |i|
      ifile.puts [
        o.id,
        i['price'],
        i['quantity'],
        i['t_url'],
        i['name']
      ].join(";")
    end
  end
end

ifile.close

dbx = Dropbox::Client.new(ENV['DROPBOX_ACCESS_TOKEN'])
[filename, ifilename].each do |f|
  dbx.upload("/ObedStore/#{f}", File.read(f, encoding: 'windows-1251'))
end
