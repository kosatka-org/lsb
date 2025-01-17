require './error_service.rb'
require 'slack'
require 'uri'
require 'net/http'
require 'net/ftp'
require 'http'
require 'aws-sdk-s3'
require 'celluloid/autostart'
require './db_connect'


class MyWorker
  include Celluloid
  finalizer :finalizer

  def initialize
    super
    @ftp = Net::FTP.new(ENV['FTP_HOST'])
    @ftp.login(ENV['FTP_USER'], ENV['FTP_PASSWORD'])
    @s3 = Aws::S3::Resource.new(access_key_id: ENV['SCALEWAY_ACCESS_KEY'], secret_access_key: ENV['SCALEWAY_SECRET_KEY'], region: 'nl-ams', endpoint: 'https://s3.nl-ams.scw.cloud')
    @bucket = @s3.bucket('slack-backup')
    @http = HTTP.auth("Bearer #{ENV['SLACK_API_TOKEN_LS_ADMIN']}")
  end

  def process_page(file, dir)
    unless @ftp.nlst.include?(dir)
      @ftp.mkdir(dir) rescue nil
    end
    file_ext = File.extname(file['url_private'])
    filename = Time.at(file['created']).strftime("%Y%m%d_%H%M%S") + "_#{file['id']}#{file_ext}"
    response = @http.get(file['url_private'])
    if response.code == 200
      File.write(filename, response.body)
      @bucket.object("#{dir}/#{filename}").upload_file(filename)
      @ftp.chdir(dir)
      @ftp.putbinaryfile(filename)
      @ftp.chdir("..")
      File.delete(filename)
    end
  end

  def finalizer
    @ftp.close
  end
end

@client = Slack::Client.new(token: ENV['SLACK_API_TOKEN_LS_ADMIN'])
@channels = @client.channels_list['channels']

supervisor = Celluloid::SupervisionGroup.run!
supervisor.pool(MyWorker, as: :work, size: 6)

days = ARGV[0].to_i

(1..Float::INFINITY).each do |page|
  from = days > 0 ? (Date.today - days).to_time.to_i : 0

  response = {}
  until response['files']
    response = @client.files_list(types: 'images', page: page, ts_from: from)
    puts "getting page #{page}"
  end

  response['files'].each do |file|
    channel = @channels.find { |c| c['id'] == file['channels'].first }
    next unless (channel && !channel['name'].empty?)
    dir = channel['name']
    supervisor[:work].async.process_page(file, dir)
  end
  break if response['paging']['pages'].to_i <= page
end

loop do
  sleep 0.01
  queue = supervisor[:work].mailbox.size
  puts "mailbox size: #{queue}" if queue % 50 == 0
  break if supervisor[:work].busy_size == 0 && supervisor[:work].mailbox.size == 0
end
