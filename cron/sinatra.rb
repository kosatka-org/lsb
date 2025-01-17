require 'sinatra'
require 'oj'
require 'addressable'
require 'unicode'
require 'digest'
require 'slim'
require "sysrandom/securerandom"
require "sinatra/json"
require 'sinatra/cross_origin'
require 'sinatra/cookies'
require 'bugsnag'
require 'rotp'
require 'base32'
require 'uuid'
require './models.rb'
require './lock.rb'
require './sms_ru.rb'
require './email_class.rb'
require './remote_logger'
require './sidekiq_jobs/bau_order_job.rb'
require './sidekiq_jobs/push_job.rb'
require './sidekiq_jobs/sms_job.rb'
require './sidekiq_jobs/otp_job.rb'
require './sidekiq_jobs/offline_sale_products_job.rb'

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
end
use Bugsnag::Rack

register Sinatra::CrossOrigin
configure do
  enable :cross_origin
  enable :sessions
  set :session_secret, ENV['APP_SECRET']
  set :daemon, true
  set :raise_errors, true
end


helpers do
  def protected_photo! params
    return if params['user'] == ENV['DB_USER'] && params['password'] == ENV['DB_PASS']
    halt 401, "Not authorized\n"
  end

  def get_user
    if request.cookies['user_id'] && request.cookies['hashcode']
      user = User.where(user_id: request.cookies['user_id'], password: request.cookies['hashcode']).first
      return user if user
    end
    web_session = WebSession.where(phpsessid: request.cookies['session_id']).first || return
    web_session.user
  end

  def admin!
    return if authorized? {|user| user&.admin? }
    halt 401, "Not authorized\n"
  end

  def authorized? &block
    user = get_user
    session['user_id'] = user&.user_id
    yield user
  end

  def read_data request
    request.body.rewind
    MultiJson.load(request.body.read)
  end

  def all_images(large,small,rest)
    prefix = "http://lsboutique.ru/reimg/files/products/560x/"
    [prefix+large, prefix+small, *rest.map{|i| prefix+i.filename}]
  end

  def country_of_origin(country)
    return 'EU' unless country
    case Unicode::downcase(country.value)
    when 'италия'
      'Italy'
    when 'франция'
      'France'
    when 'англия'
      'England'
    else
      'EU'
    end
  end

  def json_templates
    hash = {}
    hash[:products] = Proc.new do |o|
      { "id" => o.product_id,
        "price"=> o.price,
        "oldPrice"=> o.old_price,
        "sizes"=> o.sizes_array,
        "description"=> o.full_description,
        "material"=> (o.material && o.material.value),
        "color"=> o.color ? o.color.name : '',
        "modelName"=> o[:model],
        "largeImage" => "http://lsboutique.ru/reimg/files/products/307x/"+o.large_image,
        "images" => all_images(o.large_image, o.small_image, o.images_dataset.where(cover_photo: 0)),
        "brandName" => o.brand.name,
        "countryName" => country_of_origin(o.country),
        "categoryName" => (o.category && o.category.name) }
    end
    hash
  end

  def save_image(product, img_params, filename)
    image = product.images_dataset.where(foto_id: img_params[:foto_id]).first ||
      Image.create( img_params )
    image.filename = filename
    image.save
  end

end


# Filters
before do
  cache_control :no_store, :no_cache, :must_revalidate, :proxy_revalidate, max_age: 0
  halt 421 if request.base_url.include? "https://luxurystore.pro"
end


## Routes

# Get sction

get '/' do
  "REST JSON API v1"
end

get '/check_session_id' do
  cookies[:session_id]
end

get '/users' do
  content_type :json
  manager = get_user
  halt(403) unless [2,9,10,13].include?(manager.group_id)
  query = params[:query]
  users = User.where(Sequel.ilike(:name, "%#{query}%")).take(10)
  if users.empty?
    users = User.where(Sequel.ilike(:phone_number, "%#{query}%")).take(10)
  end
  json users: users
end

get '/products/:id' do |id|
  product = Product[id] || halt(404)
  json product: [product].map(&json_templates[:products]).first
end

get '/products/by_code/:code' do |code|
  product = Product[code: code] || halt(404)
  json product: [product].map(&json_templates[:products]).first
end

get '/sales_to_csv' do
  admin!
  users = User.dataset
  if params[:shops]
    users = users.where(shops: Shop.where(shop_id: params[:shops]))
  end
  if params[:brands]
    users = users.where(brands: Brand.where(brand_id: params[:brands]))
  end
  if params[:sex] && [1,2].include?(params[:sex].to_i)
    users = users.where(sex: params[:sex])
  end
  if params[:sum_min]
    sum_min = params[:sum_min].to_i
    users = users.where{purchase_sum_real >= sum_min}
  end

  return users.count.to_s if params[:count]

  File.open('sales.csv', "w:utf-8") do |file|
    file.puts "ФИО;Телефон;Сумма покупок;Дата последней покупки;Покупки оффлайн;Покупки онлайн"
    users.each do |user|
      next if user.name.to_s.empty? || user.phone_number.to_s.empty?
      offline = user.offline_sales.last
      online = user.bought_products.last
      ar = []
      ar.push online.status_date.to_time if online && online.status_date
      ar.push offline.p_date if offline
      last_date = ar.compact.sort.last
      last_date = last_date.strftime("%Y-%m-%d") if last_date
      offline_sales = user.offline_sales.map {|m| m[:model]}.reverse.take(5).join(", ")
      online_sales = user.bought_products.map {|m| m[:product_name]}.reverse.take(5).join(", ")

      file.puts "#{user[:name]};#{user[:phone_number]};#{user.purchase_sum_real};#{last_date};#{offline_sales};#{online_sales}"
    end
  end

  send_file 'sales.csv', filename: 'sales.csv'
end

get '/bau_api/time' do
  Time.now.to_s
end


options '/*' do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Methods"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
end


# Post section

post '/app_session' do
  request.body.rewind
  data = MultiJson.load request.body.read
  session = AppSession.find_or_create(
    push_token: data['pushToken'], platform: data['platform'] )
  json session: session.values
end

post '/photo' do
  protected_photo! params
  halt "Error: no file uploaded" unless params['photo']

  name = params['filename']
  file = params['photo'][:tempfile]
  File.binwrite("../files/products/#{name}", file.read)
  product = Product[code: params['code']]
  type = params['type']
  order = params['order'] ? params['order'].to_i : nil
  create_params = {product: product, foto_id: order}
  case type
  when "main"
    if order == 0 && (product.large_image.to_s.empty? || product.images_dataset.where(model_photo: true).empty?)
      product.set(large_image: name)
      create_params[:cover_photo] = 1
    elsif order == 1 && (product.small_image.to_s.empty? || product.images_dataset.where(model_photo: true).empty?)
      product.set(small_image: name)
      create_params[:cover_photo] = 1
    end
    create_params[:foto_id] = order + 100
    save_image(product, create_params, name)
  when "model"
    create_params[:model_photo] = 1
    create_params[:foto_id] = order + 10
    if [0,1].include?(order)
      product_image = order == 0 ? product.large_image : product.small_image
      unless product_image.to_s.empty?
        Image.where(filename: product_image).update(cover_photo: 0)
      end
      if order == 0
        product.set(large_image: name)
      else
        product.set(small_image: name)
      end
      create_params[:cover_photo] = 1
    end
    save_image(product, create_params, name)
  when "female"
    create_params[:model_photo] = 1
    create_params[:female] = 1
    create_params[:foto_id] = order + 20
    save_image(product, create_params, name)
  when "promo_image"
    product.update(promo_image: name)
  when "look"
    look_name = "#{product[:model]} - #{product.sku}"
    look_params = {
      date: Time.now,
      main_product: product,
      name: look_name
    }
    look = product.main_look
    if type == "big_look"
      look = product.big_look
      look_params[:big_size] = 1
      look_params[:name].concat(" (Big size)")
    end
    look = look || ProductSet.create( look_params )
    look.image = name
    look.save_changes
  end
  product.set(photo_added: Time.now) unless type.to_s['look']
  product.set(enabled: 1, quantity: 10000)
  product.save_changes
  'OK'
end

post '/video' do
  protected_photo! params
  Product[code: params['code']].update(video: params['video_url'])
  'OK'
end

post '/sms' do
 user = get_user
 halt(403) unless [2,5].include?(user.group_id)
 args = params.slice('phone_number', 'user_id', 'message_text')
 args['sms_only'] = true
 SmsJob.perform_async( args )
 "OK"
end

post '/push_notification' do
  admin!
  data = read_data(request)
  scope = User.dataset
  filter = data['filter']
  if !filter['sex'].empty? && filter['sex'].to_i != 0
    scope = scope.where(sex: filter['sex'])
  end

  if !filter['sum'].empty? && filter['sum'].to_i > 0
    scope = scope.where{ purchase_sum_real >= filter['sum'].to_i}
  end

  if !filter['shops'].empty?
    scope = scope.where(shops: Shop.where(shop_id: filter['shops']))
  end

  if !filter['cities'].empty?
    scope = scope.where(city_id: filter['cities'])
  end

  if !filter['brands'].empty?
    scope = scope.where(brands: Brand.where(brand_id: filter['brands']))
  end

  sessions = AppSession.dataset
  unless scope == User.dataset
    sessions = sessions.where(user: scope)
  end
  args = -> session { {"platform" => session.platform, "token" => (session.platform == "Android" ? session.push_token : session.firebase_token), "message" => data['body']} }
  case data['type']
  when 'count'
    json( {users_count: sessions.count} )
  when 'test'
    admin_session = User[session['user_id']].app_sessions.last
    if admin_session
      PushJob.perform_async args[admin_session]
      json( {success: "Test message sent"} )
    else
      json( {error: "App not installed for this user"} )
    end
  when 'send'
    sessions.each do |sess|
      at = !data['date'].empty? && (Time.parse(data['date']) rescue nil)
      if at
        PushJob.perform_at(at, args[sess])
      else
        PushJob.perform_async args[sess]
      end
    end
    json( {success: "Messages sent successfully"} )
  end
end

get '/request_otp/:phone' do
  halt(400, "Phone must be at least 10 characters long") if params[:phone].length < 10
  phone = params[:phone].to_i.to_s.chars.last(10).join
  user = User.where(Sequel.like(:phone_number, "%#{phone}")).first
  halt(404, "User with given phone number is not found") unless user
  lock = LockManager.lock("otp_lock:#{phone}", 60000)
  halt(429, "Too many requests, retry in 1 minute.") unless lock
  OtpJob.perform_async({"phone" => phone, "user_id" => user.user_id})
  json( {status: "OK", phone: phone, time: Time.now.to_i} )
end

post '/verify_otp' do
  request.body.rewind
  data = MultiJson.load request.body.read
  phone, otp = data.values_at('phone', 'otp').map(&:to_s)
  base32 = Base32.encode(phone.to_s+ENV['APP_SECRET']).gsub("=","")
  hotp = ROTP::HOTP.new(base32)
  counter = Sidekiq.redis { |r| r.get("otp_counter:#{phone}") }.to_i
  if hotp.verify(otp.to_s, counter)
    # increment the counter to avoid password reuse
    Sidekiq.redis { |r| r.incr("otp_counter:#{phone}") }
    user = User.where(Sequel.like(:phone_number, "%#{phone}")).first
    session['user_id'] = cookies[:user_id] = user.user_id
    cookies[:hashcode] = user.password
  else
    halt(401, json({error: "Wrong password"}))
  end
  "OK"
end

get '/otll/:token' do |token|
  code = Digest::SHA256.hexdigest(token.to_s + ENV['APP_SECRET'])
  otl = OneTimeLink.where(code: code).first
  user = otl&.user
  halt(401, json({error: "Unauthorized"})) unless (otl && user)
  otl.delete
  session['user_id'] = cookies[:user_id] = otl.user.user_id
  cookies[:hashcode] = otl.user.password
  redirect "/"
end

post '/otll/:user_id/:type' do |user_id, type|
  user = get_user
  halt(403) unless [2,5].include?(user.group_id)
  recipient = User[user_id]
  halt(403) if user.group_id == 5 && recipient.group_id != 1
  token = OneTimeLink.create_for_user(recipient)
  text = "Ссылка для входа на сайт: #{request.base_url}/otll_auth/#{token}"
  case type
  when 'sms'
    SmsJob.perform_async({user_id: recipient.user_id, message_text: text})
  when 'email'
    Email.new( to: recipient.email, subject: "Ссылка для входа на сайт Luxury Store",
      plain_text: text ).deliver
  end
  "OK"
end

get '/offline_orders' do
  user = get_user
  op = OrderProduct.where(offline_manager_id: user.user_id)
  op = OrderProduct.exclude(offline_manager_id: 0) if (user.group_id == 2 || user.user_id == 137263 || user.user_id == 127296)
  orders = Order.where(order_products: op).exclude(status: 3)
  if params[:date_from]
    df = Date.parse(params[:date_from])
    orders = orders.where{ date >= df }
  end
  if params[:date_to]
    dt = Date.parse(params[:date_to])
    orders = orders.where{ date < (dt+1) }
  end
  if params[:query].to_s.size > 3
    orders = orders.full_text_search([:name, :phone], params[:query])
  end
  content_type 'application/json'
  orders.reverse_order(:order_id).limit(50).to_json( include:
    {
      :order_products => {},
      :cashbox => {only: :name, include: :shop},
      :offline_payments => {include: :payment_type}
    })
end

post '/offline_order' do
  request.body.rewind
  data = MultiJson.load request.body.read
  user = get_user
  order = Order[data['order_id']] || halt(404)
  # halt(401) unless user.cashbox_ids.split(",").include? order.cashbox_id.to_s
  # safe for now
  OfflineSaleProductsJob.new.perform(data)
  "OK"
end

post '/accept_movement' do
  request.body.rewind
  data = MultiJson.load request.body.read
  user = get_user
  movement = Movement[data['movement_id']] || halt(404)
  halt(401) unless user.group_id > 1
  items = movement.items_dataset.where(Sequel[:movement_items][:item_id] => data['item_ids'])
  items.update(accepted: true)
  items.each { |item| item.move_to_warehouse(movement.destination_warehouse, item.quantity) }
  movement.update(accepted: true, accepted_date: Time.now, accepted_user_id: user.user_id)
  "OK"
end

post '/deposit' do
  request.body.rewind
  data = MultiJson.load request.body.read
  user = get_user
  halt(401) unless user.group_id > 1
  client = User[data['user_id']] || halt(404)
  payment_method = PaymentMethodOffline[data['payment_id']] || halt(404)
  reason = "Начисление средств (#{payment_method.name})"
  transaction = DepositTransaction.create(
    user: client,
    manager: user,
    payment_method_offline: payment_method,
    sum: data['sum'],
    reason: reason
  )
  json transaction: transaction
end

get '/online_receipt/:order_id' do |order_id|
  user = get_user
  order = Order[order_id] || halt(404)
  halt(401) unless user.cashbox_ids.split(",").include? order.cashbox_id.to_s
  res = order.print_receipt
  if res.code == 200
    "OK"
  else
    RemoteLogger.logger.info("Ошибка evotor API: #{res.inspect}")
    res.code
  end
end

get '/cdek_delivery_request/:a/:b/:c' do |order_id, cdek_account_id, tariff_type_code|
  content_type :json
  user = get_user || halt(401)
  order = Order[order_id] || halt(404)
  cdek_account = CdekAccount[cdek_account_id]
  order.set(delivery_ip: cdek_account_id, delivery_company_id: cdek_account.company_id)
  res = order.cdek_api_client.delivery_request(tariff_type_code: tariff_type_code)
  error_code = res.dig(:response, :order, 0, :error_code)
  error_msg = res.dig(:response, :order, 0, :msg)
  if error_code
    msg = "CDEK delivery request: ```#{params.to_json}``` data: ```#{JSON.pretty_generate(res)}```"
    SlackJob.perform_async({'channel' => 'lsboutique_log', "message" => msg})
    return JSON.generate({error_code: error_code, error_msg: error_msg})
  end
  order.invoice_number = res.dig(:response, :order, 0, :dispatch_number)
  order.save
  msg_text = "Пользователем <b>#{user.name}</b> сформирована накладная "\
             "#{cdek_account.name}, код тарифа #{tariff_type_code}, "\
             "номер накладной #{order.invoice_number}"
  order.add_order_event(user: user, date: Time.now, type: 'autoinvoice', text: msg_text)
  json({order: order.values.slice(:delivery_company_id, :invoice_number)})
end

# Delete section

delete 'products/by_code/:code/look' do |code|
  protected_photo! params
  product = Product[code: code] || halt(404)
  product.main_look.delete
  "OK"
end

delete '/products/code/:code/photos' do
  protected_photo! params
  product = Product[code: params['code']] || halt(404)
  product.update(large_image: '', small_image: '', bsize_small_image: '')
  product.remove_all_images
  product.remove_all_bsize_images
  "OK"
end

delete '/products/code/:code/look' do
  protected_photo! params
  product = Product[code: params['code']] || halt(404)
  product.main_look.destroy if product.main_look
  "OK"
end

delete '/products/code/:code/big_look' do
  protected_photo! params
  product = Product[code: params['code']] || halt(404)
  product.big_look.destroy if product.big_look
  "OK"
end

delete '/looks/:id' do
  protected_photo! params
  ps = ProductSet[params[:id]] || halt(404)
  ps.destroy
  "OK"
end

delete '/bau_api/unsub/:code' do |code|
  user = BauUser.where(unsub_code: code).first || halt(404)
  user.destroy
  "OK"
end
