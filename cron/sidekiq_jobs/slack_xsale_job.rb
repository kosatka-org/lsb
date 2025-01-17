require './models'

class SlackXsaleJob
  include Sidekiq::Worker

  def perform
    orders = Order.exclude(status: 3)
                  .where(order_products: OrderProduct.exclude(status: 4))
                  .where(:user_id)
                  .exclude(cashbox_id: 15) #услуги
                  .filter_by_date(date: Date.today-7)
    orders.each do |order|
      next if order.order_products.all? {|op| op.product&.product_sets.to_a.empty? }
      slack_user = order.offline? ? 'ls_offline_admin' : 'ls_admin'
      send_to_slack( message_for_xsale(order), slack_user )
    end
  end

  def message_for_xsale(order)
    user = order.user || return
    products = order.order_products_dataset.exclude(status: 4).all
      .reject { |op| op.product&.product_sets.to_a.empty? }
      .map { |op| "<#{op.product&.site_url}|#{op.product_name}>, вещи из наборов: #{set_prods_text(op.product)}" }
      .join("\n")
    phone_string = "<#{user.whatsapp_url}|Whatsapp>, #{user.phone.international}"
    "Клиент <#{order.offline? ? user.offline_url : user.admin_url}|#{user.name}>"\
    " (#{phone_string}) совершил <#{order.offline? ? order.offline_url : order.admin_url}|покупку>"\
    " неделю назад. Предложите ему купить другие вещи из набора.\n"\
    "Состав покупки: #{products} \n"\
    "Менеджеры: #{managers_string(order)}"
  end

  def set_prods_text(product)
    product.set_products.map {|sp| "<#{sp.site_url}|#{sp[:model]}>"}.join(", ")
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
    SlackJob.perform_async(user: user, channel: 'cross_sales',
      message: message)
  end
end
