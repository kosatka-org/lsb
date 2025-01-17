xml.instruct!(:xml, version: "1.0", encoding: "utf-8")
xml.DeliveryRequest(Number: order_id, Account: account, Date: date.iso8601, Secure: secure, OrderCount: 1) do |delivery_request|
  delivery_request.Order(
    Number: order_id,
    DeliveryRecipientCost: delivery_price,
    SendCityCode: 414,
    RecCityCode: cdek_city_id,
    RecipientName: name,
    RecipientEmail: email,
    Phone: phone,
    Address: address,
    TariffTypeCode: tariff_type_code,
    RecipientCurrency: "RUB",
    ItemsCurrency: "RUB") do |order|
      order.Address(Street: address, House: '-', Flat: '')
      order.Package(Number: 1, BarCode: barcode, Weight: order_products.count*500) do |package|
        order_products_dataset.with_partial_payment(payment_prepaid).each do |op|
          package.Item(
            WareKey: op.id,
            Cost: op.price*0.3,
            Payment: op['remaining_payment'],
            Weight: 2000,
            Amount: 1,
            Comment: "#{op.product_name} размер: #{op.size} SKU: #{op.sku}"
          )
        end
      end
      [30,36,37].each {|s_code| order.AddService(ServiceCode: s_code) }
  end
end
