class RunScriptJob
  include Sidekiq::Worker

  def perform(args)
    case args['script']
    when 'importlive'
      `/bin/bash --login -c ". ~/.profile; cd ~/www/lsboutique.ru/cron; bundle exec ruby importlive.rb --force"`
    end
  end
end
