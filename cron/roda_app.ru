require "roda"
require "bugsnag"
require "./models"
require './push_sender'
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
end
use Bugsnag::Rack
use Rack::Session::Cookie, secret: ENV['APP_SECRET']

class App < Roda
  plugin :all_verbs
  plugin :halt
  plugin :render
  plugin :flash

  route do |r|
    web_session = WebSession.where(phpsessid: r.cookies['session_id']).first || r.halt(401)
    response['Access-Control-Allow-Origin'] = '*'

    r.options do
      response['Access-Control-Allow-Headers'] = 'content-type,x-requested-with'
      ""
    end

    r.on 'admin' do
      @current_user = web_session.user
      unless [2,5].include?(@current_user&.group_id) || @current_user&.user_id == 127707
        r.halt(401)
      end

      r.on 'push_test' do
        @admin_app_sessions = AppSession.where(user: User.where(group_id: [2,5])).exclude(firebase_token: '').all
        @admin_app_sessions.push( *@current_user.app_sessions_dataset.exclude(firebase_token: '').all )
        r.get do
          view('push_test')
        end

        r.post do
          begin
            data = JSON.parse(r.params['data'])
          rescue JSON::ParserError
            flash['json_error'] = true
            r.redirect 'push_test'
          end
          args = {'token' => r.params['token'], 'title' => r.params['title'],
           'message' => r.params['message'], 'badge' => r.params['badge'].to_i,
           'sound' => r.params['sound'], 'data' => data}
          resp = ::PushSender.send_fcm args
          flash['sent_succes'] = true
          flash['fcm_response'] = resp[:body]
          r.redirect 'push_test'
        end
      end

      r.get 'city_stats' do
        @date = r.params['year']&.yield_self {|y| Date.new y.to_i} || Date.today
        @stats = Order.dataset.filter_by_year({date: @date}).city_stats
        view('city_stats')
      end

    end
  end
end

run App.freeze.app

# bundle exec puma -p 17888 -d api.ru
