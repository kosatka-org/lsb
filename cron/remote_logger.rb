require 'remote_syslog_logger'
require 'dotenv'
Dotenv.load

module RemoteLogger
  def self.logger
    @logger ||= RemoteSyslogLogger.new(ENV['PAPERTRAIL_HOST'], ENV['PAPERTRAIL_PORT'], :program => "lsboutique")
  end
end
