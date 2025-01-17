require './models'
require 'twisted-caldav'

class ExportCalendarJob
  include Sidekiq::Worker

  def perform
    uri, c_user, pwd = ENV.to_hash.fetch_values('CALDAV_URI', 'CALDAV_USER','CALDAV_PASSWORD')
    DeliveryCompany.exclude(calendar_id: '').each do |delivery_company|
      calendar_id = delivery_company.calendar_id
      cal = TwistedCaldav::Client.new(uri: uri.sub('default', calendar_id),
        user: c_user, password: pwd)
      date = Date.today
      events = cal.find_events(start: date.to_s, end: (date+30).to_s) || []
      events.each do |event|
        cal.delete_event event.uid
      end
      orders = delivery_company.orders_dataset
        .where{agreed_delivery_date > Date.today}.where(status: 6)
      orders.each do |o|
        man_name = o.courier&.name || o.manager&.name
        title = [o.order_id, o.user&.name, man_name].join(" | ")
        cal.create_event(start: o.agreed_delivery_date.to_s,
          end: (o.agreed_delivery_date+(60*60)).to_s,
          description: "https://lsboutique.ru/admin/index.php?section=Order&order_id=#{o.order_id}",
          title: title)
      end
    end
  end
end
