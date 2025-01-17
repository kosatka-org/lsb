require './models'
require './sms_ru.rb'
require './push_sender'
require 'digest'
require 'rotp'
require 'base32'


class OtpJob
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(args)
    # Create new HMAC-based OTP generator
    base32 = Base32.encode(args['phone'].to_s+ENV['APP_SECRET']).gsub("=","")
    hotp = ROTP::HOTP.new(base32)
    # Increment counter in Redis for given phone number
    counter = Sidekiq.redis { |r| r.incr("otp_counter:#{args['phone']}") }
    otp = hotp.at(counter)
    text = "LuxuryStore - ваш пароль для входа: #{otp}"
    sms = SmsRu::SMS.new(:api_id => ENV['SMS_RU_API_ID'])
    sms.send_sms(to: args['phone'], from: 'lsboutique', text: text)
    user = User[args['user_id']]
    if user
      DB[:users_crm].insert(
      user_id: user.user_id,
      type: 'sms',
      admin_id: 0,
      date: Time.now,
      subject: '',
      text: text.gsub(/\d+/, 'XXXXXX') )
    end
  end
end
