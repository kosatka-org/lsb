require './models.rb'

class ProductViewJob
  include Sidekiq::Worker

  def perform(args)
    return if args['user_agent'].to_s[/bot/i]
    product = Product[args['product_id']]
    user = User[args['user_id']]
    ProductView.create(product: product, user: user, price_at_the_time: args['price'], app_view: args['app_view'])
    product.increment_views(logged_in: !!user)
  end
end
