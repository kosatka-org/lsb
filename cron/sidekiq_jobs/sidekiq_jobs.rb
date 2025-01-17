require 'dotenv'
require 'tilt'
require 'erb'
require 'sidekiq'
require 'sidekiq/cron'
require 'sidekiq-rate-limiter/server'
require 'redis-namespace'
require 'bugsnag'
require 'bugsnag/sidekiq'

Dotenv.load
Bugsnag.configure do |config|
  config.api_key = ENV["BUGSNAG_API_KEY"]
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'resque' }
end
Sidekiq.configure_server do |config|
  config.redis = { namespace: 'resque' }

  schedule_file = "schedule.yml"

  if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Dir.glob("sidekiq_jobs/*_job.rb").each do |job_file|
  require "./"+job_file
end

# command to run sidekiq server:
# sidekiq -r ./sidekiq_jobs/sidekiq_jobs.rb -q critical,2 -q default --logfile logs/sidekiq.log --pidfile pids/sidekiq.pid
#
# command to run sidekiq web UI:
# bundle exec puma sidekiq_web.ru -p 4567 -q --pidfile pids/sidekiq_web.pid
