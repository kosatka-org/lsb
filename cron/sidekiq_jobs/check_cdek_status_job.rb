require './models'

class CheckCdekStatusJob
  include Sidekiq::Worker

  def perform
    Order.where(status: 6).where(:delivery_ip).where{date > Date.today-60}.each do |order|
      data = order.check_cdek_status.dig(:status_report, :order, :status, :state)
      next unless data
      data = [data] if data.is_a?(Hash)
      data.each do |event|
        event[:date] = Time.parse(event[:date]).getlocal
        insert_event(order.order_id, event)
      end
    end
  end

  def insert_event(order_id, event)
    OrderDeliveryEvent.find_or_create(**event, order_id: order_id)
  end
end
