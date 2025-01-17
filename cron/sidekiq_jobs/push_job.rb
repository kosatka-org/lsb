require './push_sender'

class PushJob
  include Sidekiq::Worker

  def perform(args)
    PushSender.send_fcm(args)
  end
end
