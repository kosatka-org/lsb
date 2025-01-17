require './models.rb'
require 'slack'

class SlackReportJob
  include Sidekiq::Worker

  def tsum_price(url)
    page = Mechanize.new.get(url)
    price_element = page.search("div.price.price_type_new").first || page.search("div.price.js-price").first
    return unless price_element
    price_element.text.delete(' ').to_i
  end

  def perform(date = Date.today)
    orders = Order.offline_orders.filter_by_date(date: date)
    order_products = OrderProduct.where(order: orders)
    text = "Всего продано товаров стоимостью #{order_products.sum(:price)} Российских рублей.\n"
    payments = OfflinePayment.where(order: orders)
    total_payments = payments.sum(:money_paid).to_f
    text << "Всего оплат на #{total_payments} рублей.\n Из них:\n"
    payments.all.group_by {|p| p.payment_type.name }.each do |name, payment_group|
      text << "#{name}: #{payment_group.map(&:money_paid).reduce(&:+).to_f} руб\n"
    end
    payments.all.group_by {|p| p.order.cashbox.name }.each do |name, payment_group|
      text << "#{name}: #{payment_group.map(&:money_paid).reduce(&:+).to_f} руб\n"
    end
    SlackJob.perform_async({'user' => 'ls_offline_admin', 'channel' => '@daily_stats', 'message' => text})

    OfflineManager.each do |om|
      rep = []
      m_products = order_products.where(offline_manager: om)
      if m_products.count > 0
        rep.push "продал #{m_products.count} товаров на сумму #{m_products.sum(:price)}"
      end
      m_calls_count = om.manager_calls_dataset.filter_by_date(date: date).count
      rep.push "совершил #{m_calls_count} звонков" if m_calls_count > 0
      m_comments = UserComment.where(commenter: om).filter_by_date(date: date).count
      rep.push "оставил #{m_comments} комментариев к клиентам" if m_comments > 0
      next if rep.empty?

      m_text = "Сотрудник #{om.slack_link_or_name} за #{date} #{rep.join(", ")}."
      SlackJob.perform_async({'user' => 'ls_offline_admin', 'channel' => '@daily_report', 'message' => m_text})
    end
  end
end
