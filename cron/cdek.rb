require 'http'
require 'builder'
require 'tilt'
require 'rexml/document'
require 'nori'
require 'digest/md5'

# Interact with the CDEK XML API
class CdekClient
  CDEK_API_METHODS = {
    delivery_request: { endpoint: 'new_orders.php' },
    update_request: { endpoint: 'update' },
    delete_request: { endpoint: 'new_orders.php' },
    orders_print: { endpoint: 'new_orders.php' },
    call_courier: { endpoint: 'new_orders.php' },
    schedule_request: { endpoint: 'new_schedule.php' },
    orders_packages_print: { endpoint: 'new_orders.php' },
    pre_alert: { endpoint: 'new_orders.php' },
    status_report: { endpoint: 'status_report_h.php' },
    info_request: { endpoint: 'new_orders.php' }
  }.freeze

  def initialize(account: ENV['CDEK_ACCOUNT'], password: ENV['CDEK_PASSWORD'],
                 api_url: 'https://integration.cdek.ru/', order: Object.new)
    @account = account
    @password = password
    @api_url = api_url
    @order = order
    @parser = Nori.new(
      parser: :rexml,
      convert_tags_to: ->(tag) { tag.snakecase.sub('@', '').to_sym },
      advanced_typecasting: true
    )
  end

  def method_missing(method, *args)
    opts = CDEK_API_METHODS[method] || super
    opts[:template] = "./views/cdek_#{method}.builder" unless opts[:template]
    if args.empty?
      args = [@order, {}]
    elsif args.first.is_a?(Hash)
      args.unshift @order
    end
    send_request(*args, opts)
  end

  def respond_to_missing?(method, *args)
    CDEK_API_METHODS.key?(method) || super
  end

  def send_request(context, params, opts)
    options = auth_hash.merge(params)
    xml = Tilt.new(opts[:template]).render(context, options)
    begin
      res = HTTP.timeout(connect: 10, write: 10, read: 30)
        .post(@api_url + opts[:endpoint], form: { xml_request: xml })
    rescue HTTP::TimeoutError
      return {response: {order: [{error_code: 408, msg: "Сервер транспортной компании не отвечает"}]}}
    end
    @parser.parse res.to_s
  end

  def auth_hash
    date = Time.now
    { account: @account, date: date, secure: secure_code(date) }
  end

  def secure_code(date)
    Digest::MD5.hexdigest(date.iso8601 + '&' + @password)
  end
end
