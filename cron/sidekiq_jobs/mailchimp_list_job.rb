require 'gibbon'
require 'digest/md5'

class MailchimpListJob
  include Sidekiq::Worker

  def perform(args)
    gibbon = Gibbon::Request.new(api_key: "728bc74770c86047fc18f8f5c0cfb3dd-us15")
    email = args['email'] || return

    domain = 'obed.store'
    unless args['domain'].to_s.empty? || args['domain'] == 'all'
      domain = [args['domain'], domain].join('.')
    end

    email_hash = Digest::MD5.hexdigest(email.downcase)

    begin
      gibbon.lists(ENV['MAILCHIMP_LIST_ID']).members(email_hash).upsert(
      body: {
        email_address: email,
        language: 'ru',
        status_if_new: "subscribed",
        merge_fields: {DOMAIN: domain}
        })
    rescue Gibbon::MailChimpError => e
      Bugsnag.notify(e)
    end
  end
end
