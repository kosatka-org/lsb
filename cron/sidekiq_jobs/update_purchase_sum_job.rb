require './models'

class UpdatePurchaseSumJob
  include Sidekiq::Worker

  def perform(user_ids = [])
    if user_ids.empty?
      users = User.where(orders: Order.where{date >= Date.today-2})
    else
      users = User.where(user_id: user_ids)
    end
    users.each do |user|
      user.update(purchase_sum_real: user.sum_for_linked_accounts)
    end
  end
end
