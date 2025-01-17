require './db_connect.rb'
require 'slack'
require 'json'

class SlackJob
  include Sidekiq::Worker
  sidekiq_options rate: {limit: 10, period: 10}

  def perform(args)
    clients = {
      'photo_bot' => Slack::Client.new(token: ENV['SLACK_API_TOKEN_PHOTO_BOT']),
      'ls_admin'  => Slack::Client.new(token: ENV['SLACK_API_TOKEN_LS_ADMIN']),
      'ls_offline_admin'  => Slack::Client.new(token: ENV['SLACK_API_TOKEN_LS_OFFLINE_ADMIN']),
      'gp_bot'    => Slack::Client.new(token: ENV['SLACK_API_TOKEN_GP_BOT'])
    }
    client = clients[args['user']] || clients['photo_bot']
    channel = args['channel'].sub(/^[^@]/) {|w| '#'+w}.sub('@', '')
    options = {channel: channel, text: args['message'], as_user: true, unfurl_links: false}
    if (img = args['image_url'])
      options[:attachments] = [ {image_url: img, fallback: img} ].to_json
    end
    begin
      client.chat_postMessage(options)
    rescue Exception => error
      retries ||= 0
      if retries < 3
        sleep rand(2.0..5.0)
        retries += 1
        retry
      else
        raise error
      end
    end
  end
end
