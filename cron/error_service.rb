require 'dotenv'

Dotenv.load

if ["production", "staging"].include? ENV["ENVIRONMENT"]
  require 'bugsnag'
  Bugsnag.configure do |config|
    config.api_key = ENV["BUGSNAG_API_KEY"]
    config.release_stage = ENV["BUGSNAG_RELEASE_STAGE"]
    config.project_root = ENV["APP_ROOT"] || Dir.pwd
  end

  at_exit do
    if $!
      Bugsnag.notify($!)
    end
  end
end
