require './models'

class ManagerUnlinkJob
  include Sidekiq::Worker

  def perform(args)
    @offline = args['offline']
    # Select users with orders
    users = @offline ? stale_offline_users : stale_users
    users.each do |user|
      (user.update(p_manager_id: 0) && next) unless (@offline || user.manager)
      managers = @offline ? user.offline_managers : [user.manager]
      message_text = create_message(user, managers)
      SlackJob.perform_async({"user" => "ls_#{'offline_' if @offline}admin",
        "channel" => "free_clients", "message" => message_text})
      remove_managers(user, managers)
    end
    Manager.each {|m| m.update(target: m.monthly_target) } unless args['offline']
  end

  def stale_users
    users = User.where(Order.where(user_id: Sequel[:users][:user_id]).select(1).exists)
    fresh_orders = Order.where(date: ((Date.today-90)...Date.today+1), cashbox_id: 0)
    users.exclude(p_manager_id: 0).exclude(orders: fresh_orders)
  end

  def stale_offline_users
    fresh_orders = Order.where(date: ((Date.today-30)...Date.today+1)).exclude(cashbox_id: 0)
    User.where(offline_managers: OfflineManager.dataset).exclude(orders: fresh_orders)
  end

  def remove_managers(user, managers)
    managers.each do |manager|
      case manager
      when OfflineManager
        user.remove_offline_manager(manager)
      when Manager
        user.update(p_manager_id: 0)
      end
    end
  end

  def user_url(user)
    host = "https://lsboutique.ru/"
    @offline ? "#{host}index.php?module=OfflineSales&edit_user_id=#{user.user_id}" :
    "#{host}admin/index.php?section=User&user_id=#{user.user_id}"
  end

  def create_message(user, managers)
    "Клиент <#{user_url(user)}|#{user.name}> (<#{user.whatsapp_url}|Whatsapp>, #{user.phone.international}) стал свободным агентом. "\
    "Бывши#{managers.size > 1 ? 'е' : 'й'} менеджер#{'ы' if managers.size > 1}: "\
    "#{managers.map(&:slack_link_or_name).join(", ")}"
  end
end
