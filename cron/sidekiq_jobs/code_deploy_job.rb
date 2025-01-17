class CodeDeployJob
  include Sidekiq::Worker

  def perform(args)
    `cd ../ && sh update.sh`
  end
end
