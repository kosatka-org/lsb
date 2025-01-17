require './models.rb'

class EmailNewsletterJob
  include Sidekiq::Worker

  def perform(args)
    if !args['body']
      template = Tilt.new('./views/lsboutique_email.erb')
      args['body'] = template.render(self, {args: args})
    end

    MailJob.perform_async(args)
  end
end
