require './models'

class ItemMovementJob
  include Sidekiq::Worker

  def perform(args)
    product_id = args['product_id'] || return
    item = Item.where(product_id: product_id)
    item = item.where(size: args['size']) if args['size']
    item = item.first || return
    lost_wh = Warehouse.where(name: 'Потерянные товары').first
    movement = Movement.create(original_warehouse: item.warehouse, destination_warehouse: lost_wh)
    movement.add_item item
  end
end
