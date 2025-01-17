require './models'

class SlackServiceJob
  include Sidekiq::Worker

  def perform
    orders = Order.offline_orders
                  .where(order_products: OrderProduct.exclude(status: 4))
                  .where(:user_id)
                  .exclude(cashbox_id: 15) #услуги
                  .filter_by_date(date: Date.today-90)
    orders.each do |order|
      send_to_slack( message_for_new_service(order) )
    end

    service_orders = Service.where(order_type: 'clients')
      .filter_by_date(date: Date.today-90)
    service_orders.each do |service|
      next if service.service_items_dataset.drycleaning.count == 0
      send_to_slack( message_for_repeat_service(service) )
    end
  end

  def message_for_new_service(order)
    user = order.user
    products = order.order_products_dataset.exclude(status: 4).all
      .map { |op| "<#{op.product&.site_url}|#{op.product_name}>" }
      .join(", ")
    managers = order.order_products.map(&:offline_manager)
      .push(*user.offline_managers).uniq.compact
      .map(&:slack_link_or_name).join(", ")
    "Клиент <#{user.offline_url}|#{user.name}> (#{phone_string(user)}) совершил <#{order.offline_url}|покупку>"\
    " 3 месяца назад. Нужно предложить услуги Химчистки.\n"\
    "Состав покупки: #{products} \n"\
    "Менеджеры: #{managers}"
  end

  def message_for_repeat_service(service)
    user = service.user
    items = service.service_items_dataset.where(service_type_id: 1).all
      .map { |si| "Товар: #{si.product_name}" +
      (si.defect_description.empty? ? '' : ", описание работ: #{si.defect_description}") }
      .join("\n")
    managers = user.offline_managers.map(&:slack_link_or_name).join(", ")
    "Клиент <#{user.offline_url}|#{user.name}> (#{phone_string(user)}) совершил <#{service.offline_url}|заказ>"\
    " на химчистку 3 месяца назад. Нужно повторно предложить услуги Химчистки.\n "\
    "Состав заказа: \n#{items} \n "\
    "Менеджеры: #{managers}"
  end

  def phone_string(user)
    "<#{user.whatsapp_url}|Whatsapp>, #{user.phone.international}"
  end

  def send_to_slack(message)
    SlackJob.perform_async(user: 'ls_offline_admin', channel: 're_service',
      message: message)
  end
end
