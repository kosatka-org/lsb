require './models.rb'
require './email_class.rb'


class MailJob
  include Sidekiq::Worker

  def perform(args)
    email = args['email'].to_s
    return if email.empty?

    user = User[args['user_id']]

    if (user && user.email.to_s != '' && user.stop_email.to_i == 0) || !args['user_id']
      mail = Email.new(
        to: email,
        from: args['from'],
        subject: args['subject'],
        html: args['body'],
        plain_text: args['message_text']
      )
      mail.deliver

      # Mask sensitive data
      args['message_text'].gsub!(/otll\/.+/, "otll/******")

      log_message(args, email, user)
      DB[:users_crm].insert(
        user_id: user.user_id,
        type: 'email',
        admin_id: 0,
        date: Time.now,
        subject: args['subject'],
        text: args['message_text']) if user
    end
  end

  def log_message(args, email, user)
    campaign = Campaign[args['campaign_id']]
    Message.create(campaign_id: campaign&.id.to_i,
      email: email,
      user_id: user&.user_id.to_i,
      type: 3)
  end
end
