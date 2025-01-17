require './error_service'
require 'slack'
require 'celluloid/autostart'
require './db_connect'


class DeleteWorker
  include Celluloid

  def initialize
    super
    @client ||= Slack::Client.new(token: ENV['SLACK_API_TOKEN_LS_ADMIN'])
  end

  def delete_file(file)
    tries ||= 5
    @client.files_delete(file: file['id'])
  rescue Slack::Error => e
    sleep 1
    retry unless (tries -= 1).zero?
  end

end

client = Slack::Client.new(token: ENV['SLACK_API_TOKEN_LS_ADMIN'])

supervisor = Celluloid::SupervisionGroup.run!
supervisor.pool(DeleteWorker, as: :work, size: 3)

(1..Float::INFINITY).each do |page|
  to = (Date.today - 100).to_time.to_i
  response = client.files_list(types: 'images', page: page, ts_to: to)
  response['files'].each do |file|
    supervisor[:work].async.delete_file(file)
  end
  break if response['paging']['pages'].to_i <= page
end

loop do
  sleep 0.01
  queue = supervisor[:work].mailbox.size
  puts "mailbox size: #{queue}" if queue % 50 == 0
  break if supervisor[:work].busy_size == 0 && supervisor[:work].mailbox.size == 0
end
