require 'fcm'
require './models'

class PushSender
  FCM_SENDER = FCM.new(ENV['FCM_KEY'])

  def self.send_fcm(args)
    registration_ids = [args['token']]
    options = {notification: {
      body: args['message'],
      badge: args['badge'] || 1,
      sound: args['sound'] || "default",
      title: (args['title'] || "Luxury Store")
      }}
    if args['data']
      options.merge!({data: args['data']})
    end
    response = FCM_SENDER.send(registration_ids, options)
    # TODO: error handling
    PushSender.log_message(args)
    response
  end

  def self.log_message(args)
    session = AppSession.where(push_token: args['token']).first || AppSession.where(firebase_token: args['token']).first
    campaign = Campaign[args['campaign_id']]
    Message.create(campaign_id: campaign&.id.to_i,
      push_token: args['token'],
      app_session_id: session&.id.to_i,
      user_id: session&.user_id.to_i,
      type: 2)
  end
end
