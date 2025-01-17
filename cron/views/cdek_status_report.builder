xml.instruct!(:xml, :version=>"1.0", :encoding=>"utf-8")
xml.StatusReport(:Account => account, :Date => date.iso8601, :Secure => secure, :ShowHistory => "1") do |status_report|
   status_report.Order(:DispatchNumber => invoice_number)
end
