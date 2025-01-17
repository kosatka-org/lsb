class TestJob
  include Sidekiq::Worker

  def perform(args)
    puts args
    sleep 10
  end
end
