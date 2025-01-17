require 'rufus-scheduler'
require 'cgi'
require 'trello'
require 'bugsnag'
require 'net/http'
require "./db_connect.rb"
require "./models.rb"
require "./sms_ru.rb"

Bugsnag.configure do |config|
  config.api_key = ENV["BUGSNAG_API_KEY"]
end

Trello.configure do |c|
  c.developer_public_key = ENV['TRELLO_PUBLIC_KEY']
  c.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

scheduler = Rufus::Scheduler.new

def scheduler.on_error(job, error)
  Bugsnag.notify("intercepted error in #{job.id}: #{error.message}")
end

class Inflection_rus
  def build(num,arr)
    if num.is_a?(Fixnum) && arr.is_a?(Array) && arr.size == 3
      num = num.to_s
      if num[-1] == "1" && num[-2,2] != "11"
        arr[0]
      elsif ["2","3","4"].include?(num[-1]) && !(["12","13","14"].include?(num[-2,2]))
        arr[1]
      else
        arr[2]
      end
    else
      nil
    end
  end
end


scheduler.cron '0 15 * * *' do
  count = DB[:copywriters_tasks].where(status: 'need_check').count
  if count > 0
    infl = Inflection_rus.new.build(count,
      ["новый текст ожидает", "новых текста ожидают", "новых текстов ожидают"])
    sms = SmsRu::SMS.new(:api_id => ENV['SMS_RU_API_ID'])
    sms.send_sms(to: '89108800786', from: 'lsboutique',
      text: "Дорогой редактор, #{count} #{infl} проверки.")
  end
end

#ping dm.lsboutique.ru
scheduler.cron '0,20,40 11-23 * * *' do
  Net::HTTP.get_response( URI.parse("http://dm.lsboutique.ru") )
end

trap('TERM') do
  scheduler.shutdown(:kill)
  exit
end

scheduler.join
