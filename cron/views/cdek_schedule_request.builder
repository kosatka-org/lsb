xml.instruct!(:xml, version: "1.0", encoding: "utf-8")
xml.ScheduleRequest(Number: order_id, Account: account, Date: date.iso8601, Secure: secure, OrderCount: 1) do |schedule_request|
  schedule_request.Order( Number: order_id, DispatchNumber: invoice_number,
    Date: date.iso8601) do |order|
    order.Attempt(Id: 1, Date: agreed_delivery_date.strftime("%Y-%m-%d"),
      TimeBeg: agreed_delivery_date.strftime("%H:%M:%S"),
      TimeEnd: (agreed_delivery_date+(60*60*3)).strftime("%H:%M:%S"))
  end
end
