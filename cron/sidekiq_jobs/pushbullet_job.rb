require './models'
require 'washbullet'

class PushbulletJob
  include Sidekiq::Worker

  def perform(args)
    pb_client = Washbullet::Client.new(ENV['PUSHBULLET_API_KEY'])
    pb_client.push_note(
      receiver: :device,
      params: {
        title: args['title'],
        body: args['body']
      })
  end
end
