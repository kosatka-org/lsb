class OfflineSaleProductsJob
  include Sidekiq::Worker

  def perform(args)
    products = args['products']
    tmp_warehouse = Warehouse.find_or_create(name: "Отложка")
    products.each do |unique_id, product|
      op = OrderProduct[id: product['op_id']] || OrderProduct[unique_id: unique_id]
      unless op
        item = Item[product['item_id']]
        item&.move_to_warehouse(tmp_warehouse)
        op = OrderProduct.create(
          product_id: product['product_id'],
          order_id: args['order_id'],
          product_name: (product['product_name'] || product['model']),
          user_id: args['user_id'],
          barcode: product['barcode'].to_s,
          quantity: 1,
          item_location: product['item_location'],
          sku: product['sku'],
          new_order: 0,
          unique_id: unique_id,
          item_id: (product['item_id'] || 0)
        )
        link_user_to_brand(product_id: product['product_id'], user_id: args['user_id'])
      end
      op.update(price: product['price'], offline_manager_id: product['offline_manager_id'], size: product['size'])
      link_user_to_manager(manager_id: product['offline_manager_id'], user_id: args['user_id'])
    end
    remove_deleted_products(unique_ids: products.keys, order_id: args['order_id']) if products.is_a? Hash
  end

  def link_user_to_brand(product_id:, user_id:)
    product = Product[product_id]
    user = User[user_id]
    if product && user
      user.link_brand(product.brand.brand_id)
    end
  end

  def link_user_to_manager(manager_id:, user_id:)
    user = User[user_id]
    manager = OfflineManager[manager_id]
    if user && manager && !manager.clients.include?(user)
      manager.add_client(user)
    end
  end

  def remove_deleted_products(unique_ids:, order_id:)
    ops = OrderProduct.where(order_id: order_id).exclude(unique_id: unique_ids)
    return if ops.count == 0
    Item.where(order_products: ops).update(:quantity => Sequel.expr(1) + :quantity, do_not_update: false)
    ops.delete
  end
end
