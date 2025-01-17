require './models'
require './sms_ru.rb'
require './push_sender'

class SmsJob
  include Sidekiq::Worker

  def perform(args)
    sms = SmsRu::SMS.new(:api_id => ENV['SMS_RU_API_ID'])
    user = User[args['user_id']]
    if user
      phone = user.phone_number
    else
      phone = args['phone_number'].to_s
    end
    return if phone.empty?

    if user&.app_sessions.to_a.empty? || args['sms_only']
      response = sms.send_sms(to: phone, from: args['sender'], text: args['message_text'])

      # Mask sensitive data
      args['message_text'].gsub!(/otll\/.+/, "otll/******")

      if response[:code].to_i == 100
        log_message(args, user)
      else
        RemoteLogger.logger.info("Ошибка при отправке СМС, код #{response[:body]} \nтелефон: #{phone}, текст: \"#{args['message_text']}\"")
      end
    else
      user.app_sessions.each do |as|
        case as.platform
        when 'Android'
          PushSender.send_fcm({'token' => as.push_token, 'message' => args['message_text']})
          DB[:sms_to_push_log].insert(user_id: user.user_id, date: Time.now, token: as.push_token, body: args['message_text'])
        else
          PushSender.send_fcm({"token" => as.firebase_token, "message" => args['message_text']})
          DB[:sms_to_push_log].insert(user_id: user.user_id, date: Time.now, token: as.firebase_token, body: args['message_text'])
        end
      end
    end

    if user
      user.update(last_sms_send: Time.now)
      DB[:users_crm].insert(
      user_id: user.user_id,
      type: 'sms',
      admin_id: 0,
      date: Time.now,
      subject: args['message_text'],
      text: args['message_text'])
    end

    if args['sms_id']
      DB[:sms_history].where(id: args['sms_id']).update(clients_processed: Sequel.expr(1) + :clients_processed)
    end
  end

  def log_message(args, user)
    campaign = Campaign[args['campaign_id']]
    Message.create(campaign_id: campaign&.id.to_i,
      phone: args['phone_number'].to_s,
      user_id: user&.user_id.to_i,
      type: 1)
  end
end
