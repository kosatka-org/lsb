require './models'
require './error_service'
require 'mail'
require 'sanitize'

since = (Date.today-3).strftime("%d-%b-%Y")
sip_domain = "lstore.mangosip.ru"
mp3_dir = "sip_calls"
Dir.mkdir(mp3_dir) unless File.directory?(mp3_dir)

Mail.defaults do
  retriever_method :imap, :address    => "imap.yandex.ru",
    :port       => 993,
    :user_name  => ENV['MANGO_EMAIL'],
    :password   => ENV['MANGO_PASSWORD'],
    :enable_ssl => true
end

retries = 0
begin
  Mail.find(count: 1500, keys: ["SINCE", since, "UNSEEN"]) do |mail|
    next unless mail.subject&.include?("Запись") && mail.multipart?
    text_part = mail.all_parts.find {|part| part.content_type.include? "text\/html"} || next
    attachment = mail.attachments.find {|att| ['.mp3', sip_domain].all? {|i| att.filename.include? i}} || next
    filename = attachment.filename
    call = {filename: filename}

    numbers = filename.sub(/\.mp3$/, '').split("__")[2..-1]
    next if numbers.length < 3
    numbers.map! {|t| t.sub(/^7/, '+7').gsub(/[\(\)]/,'').gsub("sip-", "sip:")}
    call[:line_number] = numbers.pop

    if numbers[0][sip_domain]
      call[:direction] = "out"
    else
      call[:direction] = "in"
      numbers.reverse!
    end
    call[:sip_id] = numbers[0]
    call[:phone_number] = numbers[1]

    text = Sanitize.fragment( text_part.body.decoded.strip.force_encoding("UTF-8") )
    call[:date] = Time.parse(text[/Время звонка: (\S+)$/, 1].to_s, Time.now) rescue mail.date.to_time
    call[:duration] = text[/(\d+) мин\./, 1].to_i*60 + text[/(\d+) сек\./, 1].to_i

    File.open("sip_calls/#{filename}", "w+b", 0644) {|f| f.write attachment.body.decoded}
    real_call = Call.create(call)

    next if call[:phone_number].empty?
    user_phone = call[:phone_number].sub(/^\+?7/, '').sub('+', '')
    client = User.where(phone_number: /#{user_phone}/).first || next
    real_call.update(client: client)
  end
rescue => e
  retries += 1
  retry if retries < 3
  Bugsnag.notify(e)
end
