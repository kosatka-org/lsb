require 'sidekiq'
require 'sidekiq/cron'
require 'dotenv'

Dotenv.load

Sidekiq.configure_client do |config|
  config.redis = { :size => 1, namespace: 'resque' }
end

require 'sidekiq/web'
require 'sidekiq/cron/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV['SIDEKIQ_WEB_USER'] && password == ENV['SIDEKIQ_WEB_PASSWORD']
  end

  run Sidekiq::Web
end
