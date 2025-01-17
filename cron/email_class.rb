require './models'
require 'mail'
require 'mailgun'

class Email
  Email_regex = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  def initialize(to: 'mail@lsboutique.ru', cc: nil, bcc: nil, from: 'no-reply@lsboutique.ru', subject: 'No subject', html: '', plain_text: '', attachments: [])
    if ENV['ENVIRONMENT'] == 'production'
      @mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']

      @mail = Mailgun::MessageBuilder.new()
      @mail.set_from_address from
      @mail.add_recipient :to, to
      @mail.add_recipient :cc, cc if cc
      @mail.add_recipient :bcc, bcc if bcc
      @mail.set_subject subject
      @mail.set_text_body plain_text
      @mail.set_html_body html
      attachments.each {|att| @mail.add_attachment att }

      @domain = from.to_s.gsub(/>$/, '').split('@')[1] || 'lstore.moscow'
    else
      @mail = Mail.new do
        to      to
        cc      cc if cc
        bcc     bcc if bcc
        from    from
        subject subject

        text_part do
          body plain_text
        end

        html_part do
          content_type 'text/html; charset=UTF-8'
          body html
        end
      end
    end

    if ENV['ENVIRONMENT'] == "development"
      @mail.delivery_method :smtp, address: "localhost", port: 1025
    elsif ENV['ENVIRONMENT'] != 'production'
      @mail.delivery_method :smtp, openssl_verify_mode: "none", enable_starttls_auto: false
    end
  end

  def deliver
    if ENV['ENVIRONMENT'] == 'production'
      begin
        @mg_client.send_message @domain, @mail
      rescue Mailgun::CommunicationError
        to = @mail.message[:to].first
        User.where(email: to).update(email: '') unless to[Email_regex]
      end
    else
      @mail.deliver!
    end
  end
end
