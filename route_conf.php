<?php


$routes = array(

    array('%catalog/([^/]+)/?(.+)%','/goods/$1/'),


    #Города
    array('%city/([^/]+)%','index.php?module=City&city_url=$1'),

    #Товары
    array('%^/products/([^/]+)/profiler/%','index.php?module=Storefront&product=$1&profiler'),
    array('%^/products/([^/]+)/%','index.php?module=Storefront&product=$1','params'),
    array('%^/product/set_info/([^/]+)/%','index.php?module=Storefront&set_info=$1','params'),
    //array('%products/%','index.php?module=Storefront'),

    array('%personal/%','index.php?module=Personal','params'),

    array('%stock/([^/]+)/%','index.php?module=Storefront&stock=$1'),
    array('%^/bproducts/([^/]+)/%','/products/$1/', null, true),

    array('%sale/%','index.php'),

    array('%furs/%','index.php'),

    //array('%catalog/%','index.php'),

    //array('%brandwall/%','index.php'),

    #Лэндинги
    //array('%berluti/%','index.php?module=Berluti'),
    //array('%artioli/%','index.php?module=Artioli'),
    //array('%kiton/%','index.php?module=Kiton'),
    //array('%loro-piana/%','index.php?module=Loro_piana'),
    //array('%zilli/%','index.php?module=Zilli'),
    //array('%celine/%','index.php?module=Celine'),
    array('%^/celine/%','index.php?module=Celine'),

    array('%big_size/%','index.php?module=BigSize'),
    array('%crimeteilor/%','index.php?module=Crimeteilor'),
    array('%stefano_ricci/%','index.php?module=StefanoRicci'),
    array('%^/dior/%','index.php?module=Dior'),

    array('%^/show_fur/%','index.php?module=ShowFurs'),

    #Каталог
    array('%categories/([^/]+)/%','catalog/?category_url=$1'),
    array('%brands/([^/]+)/profiler/%','catalog/?brand_url=$1&profiler'),
    array('%brands/([^/]+)/%','catalog/?brand_url=$1'),
    array('%goods/([^/]+)/%','catalog/?goods=$1'),
    array('%/new/%','catalog/?new=1'),
    array('%\/specials/([^/]+)/%','catalog/?special_url=$1'),
    array('%\/look_specials/([^/]+)/%','index.php?module=Looks&special_url=$1'),
    array('%swd/%','index.php?module=Promo&name=swd'),


    #Look
    array('%look/([^/]+)/%',  'index.php?module=Look&look=$1','params'),
    array('%looks/%','index.php?module=Looks','params'),

    # Поиск товаров
    array('%search/([^/]+)/%','index.php?module=Search&keyword=$1'),
    array('%search/%','index.php?module=Search'),

    # Вопросы и ответы
    array('%faq/question/%','index.php?module=Faq&action=question','params'),
    array('%faq%','index.php?module=Faq','params'),

    # Фид
    array('%feed/generate_page/([^/]+)%','index.php?module=Feed&generate_page=$1','params'),
    array('%newsline/([^/]+)/%','index.php?module=Feed&newsline&type=$1','params'),
    array('%feed%','index.php?module=Feed','params'),

    # Страницы
    array('%sections/([^/]+)%','index.php?section=$1'),
    array('%section/([^/]+)%','index.php?section_id=$1'),


    # RSS
    array('%rss/%','index.php?module=Rss'),

    # Ателье
    array('%cart/service_add/%','index.php?module=Atelier&service_add'),

    #Auth
    array('%\/otp_auth/%','index.php?module=Cart&otp_auth=1'),
    array('%\/otll_auth/(.+)%','index.php?module=Cart&otll_auth=1&otll_token=$1'),
    array('%auth/%','index.php?module=Auth'),

    #Reg
    array('%reg/%','index.php?module=Reg'),

    #OneClick
    array('%oneclick/([^/]+)/%','index.php?module=Oneclick&product_id=$1'),

    #Special Order
    array('%specialorder/([^/]+)/%','index.php?module=Specialorder&product_id=$1'),

    #HelpForm
    array('%helpform/([^/]+)/%','index.php?module=Helpform&oneclick_product=$1'),
    array('%helpcall/%','index.php?module=Feedback&helpform','params'),

    #Subscription
    array('%subscription/([^/]+)/%','index.php?module=Subscription&brand_id=$1'),

    #City select
    array('%citiesselect/%','index.php?module=Citiesselect'),

    #Orderform
    array('%orderform/([^/]+)/([^/]+)%','index.php?module=Orderform&products_price=$1&products_weight=$2'),

    #SberbankPayment
    array('%sberbankpayment/confirm/%','index.php?module=Sberbankpayment&confirm'),
    array('%sberbankpayment/%','index.php?module=Sberbankpayment&order_id=$1'),
    array('%spay/([^/]+)/%','index.php?module=OfflineSales&sbr_online=1&sp_token=$1'),


    # Корзина и заказы
    array('%cart/add/([^/]+)/%',          'index.php?module=Cart&product_id=$1'),
    array('%cart/form/([^/]+)/([^/]+)%', 'index.php?module=Cart&form_order&total=$1&weight=$2'),
    array('%cart/form/%',                 'index.php?module=Cart&form_order'),
    array('%cart/vk_auth/%',              'index.php?module=Cart&vk_auth'),
    array('%cart/self_register/%',        'index.php?module=Cart&self_register','params'),
    array('%cart/avatar_change/%',        'index.php?module=Cart&avatar_change'),
    array('%cart/save_data/%',            'index.php?module=Cart&save_data'),
    array('%cart/save_user/%',            'index.php?module=Cart&save_user','params'),
    array('%cart/import_cities/%',        'index.php?module=Cart&import_cities'),
    array('%cart/geo_select/%',           'index.php?module=Cart&geo_select'),
    array('%cart/error_message/%',        'index.php?module=Cart&error_message','params'),
    array('%cart/client_add/%',           'index.php?module=Cart&client_add'),
    array('%cart/delete/([^/]+)/%',       'index.php?module=Cart&delete_product_id=$1','params'),
    array('%cart/addtowl/([^/]+)/%',      'index.php?module=Cart&towl_product_id=$1','params'),
    array('%cart/movefromwl/([^/]+)/%',   'index.php?module=Cart&fromwl_product_id=$1','params'),
    array('%cart/deletewl/([^/]+)/%',     'index.php?module=Cart&deletewl_product_id=$1','params'),
    array('%cart/show_wl/%',              'index.php?module=Cart&show_wl=1'),
    array('%cart/show_z/%',               'index.php?module=Cart&show_z=1'),
    array('%personal_data/%',             'index.php?module=Cart&personal_data'),
    array('%cart/user_mail_add/%',        'index.php?module=Cart&user_mail_add'),
    array('%cart/soc_add/%',              'index.php?module=Cart&soc_add'),
    array('%cart/one_click/%',            'index.php?module=Cart&one_click'),
    array('%cart/person_select/%',        'index.php?module=Cart&person_select'),
    array('%cart/card_select/%',          'index.php?module=Cart&card_select'),
    array('%cart/helpform/%',             'index.php?module=Cart&helpform'),
    array('%cart/cities_select/%',        'index.php?module=Cart&cities_select'),
    array('%cart/get_cities/%',           'index.php?module=Cart&api_get_cities','params'),
    array('%cart/get_wardrobe/%',         'index.php?module=Cart&get_wardrobe','params'),
    array('%cart/get_wishlist/%',         'index.php?module=Cart&get_wishlist','params'),
    array('%cart/get_cart/%',             'index.php?module=Cart&get_cart','params'),
    array('%cart/update_cart/%',          'index.php?module=Cart&api_update_cart','params'),
    array('%cart/get_keys/%',             'index.php?module=Cart&get_keys','params'),
    array('%cart/get_orders/%',           'index.php?module=Cart&get_orders','params'),
    array('%cart/get_all_sizes/%',        'index.php?module=Cart&get_all_sizes'),
    array('%cart/api_save_wishlist/%',    'index.php?module=Cart&api_save_wishlist','params'),
    array('%cart/special_order_save/%',   'index.php?module=Cart&special_order_save','params'),
    array('%cart/api_get_currencies/%',   'index.php?module=Cart&api_get_currencies','params'),
    array('%cart/api_apple_pay/%',        'index.php?module=Cart&api_apple_pay','params'),
    array('%cart/g_pay/%',                'index.php?module=Cart&api_g_pay','params'),
    array('%cart/get_pay_methods/%',      'index.php?module=Cart&get_pay_methods','params'),
    array('%cart/sber_pay/%',             'index.php?module=Cart&api_sber_pay','params'),
    array('%cart/sber_pay_check/%',       'index.php?module=Cart&sber_pay_check','params'),
    array('%cart/get_managers/%',         'index.php?module=Cart&get_managers','params'),
    array('%cart/get_networks/%',         'index.php?module=Cart&get_networks','params'),

    array('%cart/crime_teilor_tickets/%', 'index.php?module=Cart&crime_teilor_tickets'),

    array('%cart/%',                      'index.php?module=Cart','params'),


    # feedback
    array('%/api_order/%','index.php?module=Feedback&one_click','params'),

    #downloads
    array('%order/([^/]+)/([^/]+)/%','download.php?order_code=$1&file=$2'),

    array('%order/get_rfi/%', 'index.php?module=Order&get_rfi'),
    array('%order/([^/]+)%', 'index.php?module=Order&order_code=$1'),
    array('%order/%',         'index.php?module=Order','params'),

    # Для пользователей
    array('%/logout/%',                    'index.php?module=Login&action=logout'),
    array('%logoutforce/%',               'index.php?module=Login&action=logout&force'),
    array('%login/remind/%',              'index.php?module=Login&remind=1'),
    array('%login/check_wishlist/%',      'index.php?module=Login&check_wishlist=1'),
    array('%login/check_viewed/%',        'index.php?module=Login&check_viewed=1'),
    array('%login/self_register/%',       'index.php?module=Login&self_register','params'),
    array('%login/save_sizes/%',          'index.php?module=Login&users2sizes','params'),
    array('%login/save_token/%',          'index.php?module=Login&save_token','params'),
    array('%login/subscribe/%',           'index.php?module=Login&subscribe','params'),
    array('%login/get_subscription/%',    'index.php?module=Login&get_subscription','params'),
    array('%account/%',                   'index.php?module=Account'),
    array('%login/unlink_acc/([^/]+)/%',  'index.php?module=Login&unlink_acc=$1'),
    array('%slog/([^/]+)/([^/]+)/%',      'index.php?module=Login&action=logout&nordr&phone=$1&card_number=$2'),
    array('%/pass/([^/]+)/([^/]+)/%',     'index.php?module=Login&generate_pass=1&phone=$1&card_number=$2'),
    array('%/pass_upd/([^/]+)/([^/]+)/([^/]+)/%', 'index.php?module=Login&update_pass=1&serial=$1&type=$2&auth_token=$3'),
    array('%login/([^/]+)/%',             'index.php?module=Login&net-work=$1','params'),

    array('%login/%',                     'index.php?module=Login','params'),

    # Cron
    array('%crontask/test_email/%',           'index.php?module=Cron&test_email'),
    array('%crontask/daily_email/%',          'index.php?module=Cron&daily_email'),
    array('%crontask/copywriter_tasks/%',     'index.php?module=Cron&copywriter_tasks'),
    array('%crontask/commit/%',               'index.php?module=Cron&commit'),
    array('%crontask/api_tests/%',            'index.php?module=Cron&api_tests'),
    array('%crontask/daily_report/%',         'index.php?module=Cron&daily_report'),
    array('%crontask/daily_rep_analitics/%',  'index.php?module=Cron&daily_rep_analitics'),
    array('%crontask/new_supply_spam/%',      'index.php?module=Cron&new_supply_spam'),
    array('%crontask/new_collection/%',       'index.php?module=Cron&new_collection'),
    array('%rfi_payment_confirm/%',           'index.php?module=Cron&rfi_payment_confirm'),
    array('%sber_payment_confirm/%',          'index.php?module=Cron&sber_payment_confirm'),
    array('%crontask/services_check/%',       'index.php?module=Cron&services_check'),
    array('%crontask/brand_report/([^/]+)/%', 'index.php?module=Cron&brand_report&brands=$1'),
    array('%crontask/exchange_rates_update/%','index.php?module=Cron&exchange_rates_update'),
    array('%crontask/managers_check/%',       'index.php?module=Cron&managers_check'),
    array('%crontask/cities_tolal/%',         'index.php?module=Cron&cities_tolal'),
    array('%crontask/confirm_report/%',       'index.php?module=Cron&confirm_report'),
    array('%crontask/mass_logout/%',          'index.php?module=Cron&mass_logout'),
    array('%crontask/cleanup/%',              'index.php?module=Cron&cleanup'),
    array('%crontask/sales_check/%',          'index.php?module=Cron&sales_check'),
    array('%crontask/m4u/%',                  'index.php?module=Cron&m4u'),
    array('%crontask/google_ad_stream/%',     'index.php?module=Cron&google_ad_stream'),
    array('%crontask/check_movements/%',      'index.php?module=Cron&check_movements'),


    array('%/pass_service/v1/devices/([^/]+)/registrations/([^/]+)/([^/]+)%',  'index.php?module=PassService&devices&registrations&deviceLI=$1&pass_type=$2&serial=$3'),
    array('%/pass_service/v1/devices/([^/]+)/registrations/([^/]+)%',          'index.php?module=PassService&devices&registrations&deviceLI=$1&pass_type=$2'),
    array('%/pass_service/v1/passes/([^/]+)/([^/]+)%',                         'index.php?module=PassService&passes&pass_type=$1&serial=$2'),

    # google sitemap
    array('%sitemap.xml%','index.php?module=Sitemap&format=google'),

    # Анкета для работников
    array('%work/%','index.php?module=Feedback&employment'),

    # Sale Versace
    array('%saleversace/%','catalog/?brand=66&category=sale'),

    # Услуги для АПИ
    array('%services/%','index.php?module=Service&service_list=1'),

    # Новости
    array('%news/([^/]+)/%','index.php?module=NewsLine&news_url=$1'),
    array('%news/%','index.php?module=NewsLine','params'),

    # Подвтерждение перемещения товара
    array('%\/m_confirm/([^/]+)/([^/]+)%','index.php?module=OfflineSales&movement=1&movement_id=$1&confirmation=1&m_token=$2'),

    array('%gallery2/%','index.php?c_debug'),

    array('%i/c/([^/]+)/%',       'index.php?module=OfflineSales&inkass_confirm=$1'),
 );
