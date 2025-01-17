require "net/http"
require 'cgi'
require 'digest/sha2'

module SmsRu
  class SMS
    def initialize(params)
      @api_id = params[:api_id]
      @login = params[:login]
      @password = params[:password]
      @auth_token_expire = nil
    end

    def send_sms(params)
      if ENV['ENVIRONMENT'] == 'development'
        File.write('logs/sms_dev.log', params.to_s + "\n", {mode: "a"})
        return {code: 100, body: "OK"}
      end
      query_params = ""
      params.each do |key, value|
        query_params += "&#{key.to_s}=#{CGI.escape(value.to_s)}"
      end
      if @api_id.nil?
        hash = Digest::SHA512.hexdigest(@password+auth_token+@api_id)
        uri = URI.parse("http://sms.ru/sms/send?api_id=#@api_id#{query_params}")
      else
        uri = URI.parse("http://sms.ru/sms/send?api_id=#@api_id#{query_params}")
        response = Net::HTTP.get_response(uri)
        code = response.body.split("\n").first
        {code: code, body: response.body}
      end
    end

    def auth_token
      if @auth_token_expire < Time.now
        renew_auth_token
      else
        @auth_token
      end
    end

    private
    def renew_auth_token
      @auth_token_expire = Time.now + 10.minutes
      @auth_token = Net::HTTP.get_response(URI.parse("http://sms.ru/auth/get_token")).body.strip
    end
  end
end
