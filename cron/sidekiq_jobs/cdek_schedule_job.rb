require './models'

class CdekScheduleJob
  include Sidekiq::Worker
  MAX_RETRIES = 5

  def perform(args)
    @args = args
    order = Order[args['order_id']] || return
    res = order.cdek_api_client.schedule_request
    handle_error res
  end

  def handle_error(res)
    error_code = res.dig(:response, :order, 0, :error_code)
    case error_code
    when 408
      # retry timeout errors
      @args['retry_count'] ||= 0
      @args['retry_count'] += 1
      raise HTTP::TimeoutError if @args['retry_count'] > MAX_RETRIES
      CdekScheduleJob.perform_in(120, @args)
      return
    when Integer
      msg = "CDEK schedule request error. Data: ```#{JSON.pretty_generate(res.merge(@args))}```"
      SlackJob.perform_async({'channel' => 'lsboutique_log', "message" => msg})
    end
  end

end
