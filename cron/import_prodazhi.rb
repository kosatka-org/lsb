#encoding: utf-8
require 'time'
require 'unicode'
require 'mail'
require './db_connect.rb'
require './s3_class.rb'
require './sms_ru.rb'
require './error_service'

t1 = Time.now

filename = "Prodazhi.csv"
if ARGV[0] == "daily"
    filename = "Prodazhi_" + (Date.today-1).strftime("%d.%m.%Y") + ".csv"
end

prodazhi    = DB[:prodazhi]      #set up the dataset
categs = DB[:categories]
brands = DB[:brands]
users = DB[:users]
users_crm = DB[:users_crm]

exp = /[a-zA-Zа-яА-Я]+/

inserted = 0
updated = 0
begin
  file = S3Wrapper.new.get(filename)
rescue
  exit!
end

file.each_line do |li|
  y = li.split(";")
  next if (y[3].to_i == 0 || y.size < 20)
  model = y[5]+" "
  brand = y[8].strip
  brand_id = brands[name: brand][:brand_id] rescue 0
  spl = model.split(/#{brand}/i)
  if spl.size < 2
    spl = model.split(/(corneliani|kiton|zilli|isaia)/i)
  end
  category = spl.first.strip.sub(/ (муж|жен).*/,"")
  category_id = categs[name: category][:category_id] rescue 0
  code = y[3].to_i
  card = y[2]
  url = code.to_s+"-"+Unicode::downcase(model.scan(exp).join("-"))
  date = y[0]
  p_date = Time.parse(date) rescue nil

  s = prodazhi.where(:date => date, :code => code, :harakteristika_nomenk => y[10]).update(p_date: p_date)

  user = users[code: y[16].to_i] unless y[16].to_i.zero?
  if user
    user_id = user[:user_id]
  else
    user_id = 0
  end

  if s==0
    prod_id = prodazhi.insert(
      :date       => date,
      :url        => url,
      :p_date     => p_date,
      :location   => y[1],
      :card       => card,
      :code       => code,
      :sku        => y[4],
      :model      => y[5],
      :sex        => y[6],
      :season     => y[7],
      :brand      => brand,
      :brand_id   => brand_id,
      :category_name => category,
      :category_id => category_id,
      :nomenk_group => y[9],
      :harakteristika_nomenk => y[10],
      :quantity  => y[11],
      :sum_without_discount => y[12].gsub(",",".").gsub(/[^\d.]/,''),
      :sum_with_discount  => y[13].gsub(",",".").gsub(/[^\d.]/,''),
      :discount   => y[14],
      :client     => y[15],
      :original_user_id      => y[16],
      :user_id      => user_id,
      :size       => y[17],
      :color      => y[18],
      :purchase_price => y[19].gsub(",",".").gsub(/[^\d.]/,'')
    )
    inserted += 1
  else
    updated += 1
  end

end

DB.run("UPDATE `prodazhi` SET `card_prepeared` = SUBSTR(REPLACE(REPLACE(`card`, '?', ''), ' ', ''), -16) WHERE card <> '' AND `card_prepeared` = '';")
DB.run("UPDATE `prodazhi` SET `card_prepeared` = `card` WHERE card <> '' AND `card_prepeared` = '';")

DB.run("UPDATE `prodazhi` p SET user_id = (SELECT user_id FROM `users` u WHERE u.`card_prepeared` = p.`card_prepeared` LIMIT 1) WHERE user_id = 0 AND p.`card_prepeared` <> '';")

DB.run("UPDATE `prodazhi` p SET p.brand_id = ( SELECT brand_id FROM brands b WHERE p.brand = b.name LIMIT 1 ) WHERE brand_id = '0' AND brand <> '';")

DB.run("UPDATE `prodazhi` p SET user_id = (SELECT original_user_id FROM `users` u WHERE u.`card_prepeared` = p.`card_prepeared` LIMIT 1) WHERE user_id = 0 AND p.`card_prepeared` <> '';")

DB.run("UPDATE `prodazhi` SET `p_sum_with_discount`    = REPLACE(REPLACE(`sum_with_discount`, ' ', ''), ',', '.');")
DB.run("UPDATE `prodazhi` SET `p_sum_without_discount` = REPLACE(REPLACE(`sum_without_discount`, ' ', ''), ',', '.');")
DB.run("UPDATE `prodazhi` SET `p_discount` = REPLACE(REPLACE(`discount`, ' ', ''), ',', '.');")
DB.run("UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(`season`, ' обувь', ''), ' НН', ''), ' MF', ''), 'Cen Keren', '');")
# DB.run("UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`season`, ' main', ''), ' pre', ''), ' sfilata', ''), ' обувь', ''), ' НН', ''), ' MF', '');")
DB.run("UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, ' V', ''), ' P', ''), ' C', ''), ' W', ''), ' AB', ''), ' AR', '');")
DB.run("UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'CORNELIANI', ''), 'ISAIA', ''), 'Kiton', ''), 'Versace', ''), 'Сезон', ''), 'реализ', '');")
DB.run("UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, ' k', ''), ' LF', ''), ' T', ''), ' T', ''), '/1A', '/1'), '<>', ''), ' E', '');")
DB.run("UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'I', ''), 'II', ''), 'III', ''), 'IV', ''), 'V', ''), 'VII', ''), 'VI', '');")
DB.run("UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'MTM', ''), ' ICE Iceberg', ''), ' Iceberg', ''), 'D', ''), 'Сезон', ''), 'U/D', ''), 'Брй', ''), 'U/', ''), 'U', '');")
DB.run("UPDATE `prodazhi` SET `p_season` = 'Не установлен' WHERE p_season = '';")
DB.run("UPDATE `prodazhi` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`sex`, '-%', ''), '04.03.13', ''), '08.11.10', ''), '11.03.11', '');")
DB.run("UPDATE `prodazhi` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, '12/2', ''), '13/1', ''), '14.04.11', ''), '15.07.10', '');")
DB.run("UPDATE `prodazhi` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, '20.06.11', ''), '24.01.12', ''), '25.04.11', ''), '31.01.11', '');")
DB.run("UPDATE `prodazhi` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, 'AI/11', ''), 'AI/12', ''), 'FENDI', ''), 'FPC/12', '');")
DB.run("UPDATE `prodazhi` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, 'mtm', ''), 'PE/12', ''), 'PE/13', ''), 'костюмы', '');")
DB.run("UPDATE `prodazhi` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, 'костюмы (-%)', ''), 'реализация', ''), 'рубашки', ''), 'эконом коллекция', '');")
DB.run("UPDATE `prodazhi` SET `p_sex` = REPLACE(REPLACE(`p_sex`, '()', ''), '10/1', '');")
DB.run("UPDATE `prodazhi` SET `p_location` = REPLACE(REPLACE(REPLACE(`location`, ' опт', ''), ' (Республика)', ''), 'Сток', 'Склад');")

# process new sales

def send_email(user)
  sum_offline = DB[:prodazhi].where(card: user[:card_number]).sum(:sum_with_discount) || 0
  sum_online = DB[:orders_products].where(
    status: 5,
    order_id: DB[:orders].where(
      user_id: user[:user_id]
    ).select(:order_id)
  ).sum(:price) || 0
  sum = sum_online + sum_offline
  discount = case sum
  when 0..250000
    10
  when 250000...500001
    15
  when 500000...900001
    20
  when 900000...1500001
    25
  else
    30
  end

  email_body = <<-HEREDOC
    <html>
    <body style="margin:10px 0 0 0;" bgcolor="#ffffff" color="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
      <table width="686" align="center" border="0" cellpadding="0" cellspacing="0" style="font-size: 11px; line-height: 13pt; font-family: Tahoma, Helvetica;" rules="none">
        <tr height="142">
          <td><a href="http://lsboutique.ru/" style="color: #787878; font-size: 18px; text-decoration: none; font-weight: bold;"><img alt="Luxury Store" src="http://lsboutique.ru/email_img/logo.png" width="220" height="64" /></a></td>
          <td>
            <div style="float: right; padding: 16px 20px 0 0;">
              <div style="font-size: 10px;">По частным вопросам</div>
              <a href="mailto:mail@lsboutique.ru" style="color: #787878; text-decoration: underline; font-weight: bold;">mail@lsboutique.ru</a>
            </div>
          </td>
        </tr>
        <tr style="background: #f2f2f1;">
          <td colspan="2" style="color: #80807d; font-size: 18px; font-weight: bold; padding: 8px 12px; border-top: 1px solid #e8e8e6; border-bottom: 1px solid #e8e8e6;">Благодарим за покупку в Лакшери Стор!</td>
        </tr>
        <tr>
          <td colspan="2" style="padding: 32px 12px 32px 12px;">
            <div style="color: #424243; font-size: 18px; font-weight: bold;">Здравствуйте, #{user[:name]}</div><br>
            <div>
              Сумма ваших покупок по карте № #{user[:card_number]} в магазинах "Лакшери стор" теперь составляет #{sum.to_i} рублей. Это дает вам возможность покупать товары из новых коллекций со скидкой до #{discount}%.
              <br><br>
              Напоминаем что вы можете вернуть купленные товары в течении 30 дней. Для этого необходимо сохранить их товарный вид, желательно сохранить фирменную упаковку, и сообщить нам о вашем желании осуществить возврат.
              <br>
              <br>
              С уважением, <span style="font-weight: bold;">Ирина</span>, Руководитель службы Вашей поддержки <a href="mailto:mail@lsboutique.ru" style="color: #787878; text-decoration: underline; font-weight: bold;">mail@lsboutique.ru</a>
            </div>
          </td>
        </tr>
        <tr style="background: #e0ded9;">
          <td style="padding: 10px 12px;">Справочная служба с готовностью даст ответ<br> круглосуточно, 24/7 звонок по России бесплатно </td>
          <td style="padding: 10px 0;">
            <img src="http://lsboutique.ru/email_img/phone.png" width="17" height="16" style="vertical-align: middle;"/>
            <span style="font-size: 18px; vertical-align: bottom; line-height: 20px;">&nbsp;8 800 333 2138&nbsp;</span>
            <a href="https://issa.mangotele.com/widget/MTAzOTY4" style="color: #787878; text-decoration: underline; font-weight: bold; vertical-align: bottom;">или с компьютера</a>
          </td>
        </tr>
        <tr>
          <td colspan="2" style="font-size: 10px; padding: 32px 12px 16px;">
            Сообщение было отправлено на <a href="mailto:#{user[:email]}" style="color: #787878; text-decoration: underline;">#{user[:email]}</a>.
            <!--Если Вы не хотите получать письма от <a href="lsboutique.ru" style="color: #787878; text-decoration: none;">lsboutique.ru</a>, пожалуйста, <a href="#" style="color: #787878; text-decoration: none; border-bottom: 1px solid #787878;">отпишитесь</a>-->
          </td>
        </tr>
        <tr>
          <td colspan="2" style="font-size: 10px; padding: 0px 12px 16px 12px; color: #787878;">&copy; Luxury Store #{Time.now.year}</td>
        </tr>
      </table>
    </html>
  HEREDOC

  if user[:email] != ""
    mail = Mail.new do
      to      user[:email]
      from    'no-reply@lsboutique.ru'
      subject "Благодарим за покупку в Лакшери Стор"

      text_part do
        body  "Сумма ваших покупок #{sum}, персональная скидка по карте #{discount}%
                Спасибо за покупку!"
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body email_body
      end
    end

    mail.delivery_method :smtp, :openssl_verify_mode  => "none", :enable_starttls_auto => false
    mail.deliver!
  end

  if user[:phone_number].length >= 7
    sms_text = "Спасибо за покупку в Лакшери Стор! www.lsboutique.ru"
    # @sms.send_sms(to: user[:phone_number], from: "Luxury Store", text: sms_text)
  end


end

def register_brand(user_id, brand_id)
  a = DB[:users2brands].where(user_id: user_id, brand_id: brand_id).update(status: 1)
  if a == 0
    DB[:users2brands].insert(user_id: user_id, brand_id: brand_id, status: 1)
  end
end

def normalize_size(size,sex,cat,brand)
  if size[/\D/]
    size
  else
    if special_table = DB[:cats2sizetables].where(:sex => sex, :category_id => cat, :brand_id => brand).first
      sztbl = $sizetables[special_table[:sizetable_id]-1]
    elsif special_table = DB[:cats2sizetables].where(:sex => sex, :category_id => cat, :brand_id => 0).first
      sztbl = $sizetables[special_table[:sizetable_id]-1] rescue DB[:cats2sizetables].first
    else
      sztbl = $sizetables[0] if sex == 1
      sztbl = $sizetables[1] if sex == 2
    end
    normal_size = size.to_i
    sztbl.each do |k,v|
      normal_size = k.to_s if v === size.to_i
    end
    normal_size
  end
end

def register_size(user_id, size, category_id, brand_id, sex)
  category = DB[:categories][category_id: category_id] || return
  case category[:parent]
  when 1
    type = 1
  when 2
    type = 2
  else
    return
  end
  size = normalize_size( size, sex, category_id, brand_id ) if type == 1
  size = size.to_s
  return if size[/\//] || size[/\(/] || size[/\)/] || size[/не /i]
  scope = {user_id: user_id, type_id: type, size: size}
  DB[:users2sizes].where(scope).first || DB[:users2sizes].insert(scope)
end

if ARGV[0] == "daily"
  $sizetables = DB[:sizetables].all.map do |sztb|
    sztb.delete(:name)
    sztb.delete(:sizetable_id)
    aa = sztb.to_a
    ab = aa.each_with_index.map do |x,i|
      if i==0
        [x[0], (0..x[1])]
      elsif i==9
        [x[0], ((x[1]-1)..100)]
      else
        [x[0], ((aa[i-1][1]+1)..x[1])]
      end
    end
    Hash[*ab.flatten]
  end
  emails_sent = []
  @sms = SmsRu::SMS.new(:api_id => ENV['SMS_RU_API_ID'])
  prodazhi.where(:card).where(crm_id: 0).where{p_date > (Date.today-30)}.each do |prod|
    if (user = users.where( Sequel.|({card_number: prod[:card]}, {user_id: prod[:user_id]} )).first)
      text = "#{user[:name]} купил товар #{prod[:model]} (код #{prod[:code]}) по цене #{prod[:sum_with_discount]} рублей в магазине '#{prod[:location]}'"
      crm_id = users_crm.insert(user_id: user[:user_id], type: "buy", subject: text, text: text, admin_id: 0, date: prod[:p_date])
      prodazhi.where(prodazha_id: prod[:prodazha_id]).update(crm_id: crm_id)
      users.where(user_id: user[:user_id]).where{purchase_last_date < prod[:p_date]}.update(purchase_last_date: prod[:p_date], purchase_last_what: prod[:model])
      unless prod[:brand_id] == 0
        register_brand(user[:user_id], prod[:brand_id])
      end
      if !prod[:size].empty? && prod[:category_id] != 0 && prod[:brand_id] != 0 && ['U','D'].include?(prod[:sex])
        sex = prod[:sex] == 'U' ? 1 : 2
        register_size(user[:user_id], prod[:size], prod[:category_id], prod[:brand_id], sex)
      end

      unless emails_sent.include? user[:user_id]
        send_email user
        emails_sent.push user[:user_id]
      end

    end
  end

  unless emails_sent.empty?
    u = users.where(user_id: emails_sent).to_a
    ulist = u.map {|o| "Клиент #{o[:name]}, номер карты #{o[:card_number]}"}.join("\n")
    mail = Mail.new do
      to      'mail@lsboutique.ru'
      from    'no-reply@lsboutique.ru'
      subject "Отчет об отправленных сообщениях"
      body  "Отправлено #{u.length} сообщений следующим клиентам:\n#{ulist}"
    end
    mail.delivery_method :smtp, :openssl_verify_mode  => "none", :enable_starttls_auto => false
    mail.deliver!
  end

end


puts "inserted #{inserted} items"
puts "updated #{updated} items"
puts "operation took #{Time.now-t1} seconds"
