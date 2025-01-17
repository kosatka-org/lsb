require './models'
require './email_class'
require 'trello'
require 'sanitize'
require "sysrandom/securerandom"


class BauOrderJob
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(args)
    @client = Trello::Client.new(
      developer_public_key: ENV['TRELLO_DEVELOPER_KEY'],
      member_token: ENV['TRELLO_MEMBER_TOKEN']
    )
    @board = @client.find(:board, ENV['BAU_ORDERS_BOARD'])
    orders = []
    args['items'].group_by { |i| Date.parse i['date'] }.sort_by {|k,v| k}.to_h.each do |date, items|
      next if date == Date.today
      order = create_order(args, date, items)
      card = find_or_create_card(order, args)
      begin
        card.add_label delivery_label(order.delivery_point)
      rescue Trello::Error
        nil
      end
      orders.push order
    end
    send_email(orders)
  end

  def create_order(args, date, items)
    order = BauOrder.where(code: args['code'], delivery_date: date).first
    return order if order
    order = BauOrder.create(
      code: args['code'],
      email: args['email'],
      domain: args['domain'].to_s,
      delivery_date: date,
      delivery_point: args['delivery'],
      enabled: (args['enabled'] ? true : false),
      items: items.to_json,
      order_number: SecureRandom.hex
    )
    order.reload
    id_array = BauOrder.where(delivery_date: order.delivery_date).map(:id).sort
    id = id_array.index(order.id) + 1
    order_num = order.delivery_date.strftime("%d%m%y") + id.to_s.rjust(4, "0")[-4..-1]
    begin
      order.update(order_number: order_num)
    rescue Sequel::UniqueConstraintViolation => e
      order_num = order_num.to_i.next.to_s
      retry
    end

    if args['token']
      user = BauUser.where(token: args['token']).first
      order.update(bau_user: user) if user
    end
    order
  end

  def find_or_create_card(order, args)
    if order.card_id.to_s.empty?
      card = create_card(order, args)
      order.update(card_id: card.id)
      card
    else
      @client.find(:card, order.card_id)
    end
  end

  def find_or_create_list(name)
    @board.lists.detect {|l| l.name == name} || @client.create(:list, {'idBoard' => @board.id, 'name' => name})
  end

  def create_card(order, args)
    list_name = order.delivery_date.strftime('%d.%m.%y')
    list = find_or_create_list(list_name)

    name = "Заказ №" +
      [order.order_number, order.delivery_date.strftime('%d.%m.%Y'), order.email].join(" / ")
    name.prepend "Новый клиент! " if order.first_order?

    items = JSON.parse order.items
    desc = items.map {|i| "#{i['name']} - #{i['quantity']} шт."}.join("\n")
      .concat "\nТочка выдачи: #{order.delivery_point}"
      .concat "\nОплата: #{args['payment']}"

    card = @client.create( :card,
      {
        'idList' => list.id,
        'name' => name,
        'desc' => Sanitize.fragment(desc)
      }
    )
  end

  def delivery_label(delivery_point)
    @board.labels.find {|l| l.name == delivery_point} ||
    @client.create( :label,
      {
        'idBoard' => @board.id,
        'name' => delivery_point,
        'color' => "red"
      }
    )
  end

  def send_email(orders)
    email = orders.first.email
    orders = orders.map {|o| o.items = JSON.parse o.items; o}
    @daynames = %w(Воскресенье Понедельник Вторник Среда Четверг Пятница Суббота)
    layout = Tilt.new('./views/obed_email.erb')
    html_template = Tilt.new('./views/order_email.erb')
    html_body = html_template.render(self, {orders: orders, email: email})
    html = layout.render { html_body }
    plain_template = Tilt.new('./views/order_email_plain.erb')
    plain_text = plain_template.render(self, {orders: orders, email: email})

    Email.new(
        to: email,
        bcc: 'order@obed.store',
        from: "Obed.store <order@obed.store>",
        subject: "Заказ на сайте obed.store",
        html: html,
        plain_text: plain_text
    ).deliver
  end

end
