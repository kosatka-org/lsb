require './models'

class SlackUpsaleJob
  include Sidekiq::Worker

  def perform
    orders = Order.exclude(status: 3)
                  .where(order_products: OrderProduct.exclude(status: 4))
                  .where(:user_id)
                  .exclude(cashbox_id: 15) #услуги
                  .filter_by_date(date: Date.today-365)
    orders.each do |order|
      next unless order.user
      slack_user = order.offline? ? 'ls_offline_admin' : 'ls_admin'
      send_to_slack( message_for_upsale(order), slack_user)
    end
  end

  def message_for_upsale(order)
    return unless order.user

    action_string(order) +
    "Состав покупки: #{prod_string(order)} \n" +
    "Менеджеры: #{managers_string(order)}"
  end

  def action_string(order)
    user = order.user
    "Клиент <#{order.offline? ? user.offline_url : user.admin_url}|#{user.name}> "\
    "(<#{user.whatsapp_url}|Whatsapp>, #{user.phone.international}) "\
    "совершил <#{order.offline? ? order.offline_url : order.admin_url}|покупку>"\
    " год назад. Предложите ему обновить купленные вещи.\n"
  end

  def prod_string(order)
    order.order_products_dataset.exclude(status: 4).all
      .map { |op| "<#{op.product&.site_url}|#{op.product_name}> - #{op.price}р" }
      .join(", ")
  end

  def managers_string(order)
    if order.offline?
      order.order_products.map(&:offline_manager)
        .push(*order.user.offline_managers).uniq.compact
    else
      [order.manager, order.user.manager].uniq.compact
    end.map(&:slack_link_or_name).join(", ")
  end

  def send_to_slack(message, user)
    SlackJob.perform_async(user: user, channel: 'up_sale',
      message: message)
  end
end
