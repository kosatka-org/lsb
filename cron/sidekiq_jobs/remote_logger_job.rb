require './remote_logger'

class RemoteLoggerJob
  include Sidekiq::Worker

  def perform(message)
    RemoteLogger.logger.info message
  end
end
