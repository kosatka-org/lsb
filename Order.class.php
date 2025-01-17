<?php

require_once('Widget.class.php');
class Order extends Widget {
    var $title = 'Заказ';

    function Order(&$parent) {
        Widget::Widget($parent);
    }


    function fetch() {
        $user = new luser($_SESSION['user']->user_id);
        if ($this->settings->theme == 'api' && empty($_POST['update_object']) && !empty($_REQUEST['update_object'])){
            $_POST = $_REQUEST;
        }
        if ($_POST['update_object']) {
            if ($this->settings->theme == 'api') {
                $this->update_order(json_decode(json_encode($_POST)));
            }
            $this->update_order(json_decode($_POST['update_object']));
            exit();
        }
        if ($this->settings->theme == 'api' && isset($_GET['get_rfi'])) {
            $this->get_rfi();
        }
        if ($this->settings->theme == 'api' && isset($_GET['get_order'])) {
            $order_id = (int)$_GET['get_order'];
            $return->order = Order::get_order_by_id($order_id);
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
            die();
        }

        if (!$this->param('order_code')) {
            if( !isset($_SESSION['order_code']) && !isset($_GET['order_code']) ) {
                return false;
            }
            $code = isset($_SESSION['order_code']) ? $_SESSION['order_code'] : $_GET['order_code'];
        }
        else {
            $code = $this->param('order_code');
        }

        if ( !empty($_SESSION['ADD_TO_ECOMMERCE']) ) {
            $this->smarty->assign('add_to_ecommerce', 1);
            unset($_SESSION['ADD_TO_ECOMMERCE']);
        }

        // Получаем наш заказ из базы
        $order = Order::get_order_by_code($code);

        if ( isset($_GET['invoice']) ) {
            // Ссылка: http://ok.luxury.ru/?module=Order&invoice=123&order_code=ed78c70dc2b7f98303d2baeffb3136ac
            require_once($_SERVER['DOCUMENT_ROOT'] . '/models/order.php');
            $order = new orders($order->order_id);
            echo $order->get_invoice_form();
            die();
        }
        if ( isset($_GET['ponyinvoice']) ) {
            // Ссылка: http://ok.luxury.ru/?module=Order&ponyinvoice=123&order_code=ed78c70dc2b7f98303d2baeffb3136ac
            require_once($_SERVER['DOCUMENT_ROOT'] . '/models/order.php');
            $order = new orders($order->order_id);
            echo $order->get_ponyinvoice_form();
            die();
        }
        if ( isset($_GET['kasatkainvoice']) ) {
            // Ссылка: http://ok.luxury.ru/?module=Order&kasatkainvoice=123&order_code=ed78c70dc2b7f98303d2baeffb3136ac
            require_once($_SERVER['DOCUMENT_ROOT'] . '/models/order.php');
            $order = new orders($order->order_id);
            echo $order->get_kasatkainvoice_form();
            die();
        }
        if ( isset($_GET['maximainvoice']) ) {
            // Ссылка: http://ok.luxury.ru/?module=Order&maximainvoice=123&order_code=ed78c70dc2b7f98303d2baeffb3136ac
            require_once($_SERVER['DOCUMENT_ROOT'] . '/models/order.php');
            $order = new orders($order->order_id);
            echo $order->get_maximainvoice_form();
            die();
        }
        if ( isset($_GET['labels']) ) {
            // Ссылка: http://ok.luxury.ru/?module=Order&invoice=123&order_code=ed78c70dc2b7f98303d2baeffb3136ac
            require_once($_SERVER['DOCUMENT_ROOT'] . '/models/order.php');
            $order = new orders($order->order_id);
            echo $order->get_labels();
            die();
        }

        // Если заказ не существует
        if (!$order) {
            return false;
        }
        
        $total_price = $this->db->result("SELECT SUM(price) as total FROM `orders_products` WHERE order_id = {$order->order_id} AND status != 4")->total;
        $delivery_price = $this->db->result("SELECT delivery_price FROM `orders` WHERE order_id = {$order->order_id}")->delivery_price;
        $paid_already = $this->db->result("SELECT (payment_prepaid + deposit_payment) as total FROM `orders` WHERE order_id = {$order->order_id}")->total;
        $order_paid = ($paid_already >= ($total_price + $delivery_price)) ? true : false;
        $this->smarty->assign('order_paid', $order_paid);

        $order->total_amount_online = 0.000000001;
        if ( $order->total_amount < 10000 && empty($order->delivery_paid) && empty($order->payment_prepaid) ) { // Автоматически добавим доставку
            $order->total_amount   += 2000;
            $order->total_amount_online += 2000;
            $order->delivery_price  = 2000;
            $order->c_delivery_prices  = new stdClass();
            foreach($this->currencies as $c){
              if ($c->code == 'rub') continue;
              $code = $c->code;
              $order->c_delivery_prices->$code = $order->delivery_price/$c->rate_to;
            }
        }
        $order_user = new luser($order->user_id);
        $order->with_online_discount = false;
        foreach ($order->products as $product) {
          if ( ($product->order_price - 0.1) > $product->last_price_online ) {
            $order->with_online_discount = $product->with_online_discount = true;
            $order_price = ($order_paid === true || $product->sku == "testproduct") ? $product->order_price : $product->order_price*0.95;
            $order->total_amount_online += $order_price;
          }
          else {
            $order->total_amount_online += $product->order_price;
          }
          $product->c_prices  = new stdClass();
          foreach($this->currencies as $c){
            if ($c->code == 'rub') continue;
            $code = 'order_price_'.$c->code;
            $product->c_prices->$code = $product->order_price/$c->rate_to;
          }
          $visibility_check = $this->db->result("SELECT * FROM products p LEFT JOIN brands b ON p.brand_id = b.brand_id LEFT JOIN categories c ON p.category_id = c.category_id WHERE c.enabled = 1 AND b.visibility <= 1 AND b.offline_only = 0 AND b.hidden = 0 AND p.product_id = ".$product->product_id);
          if(!empty($visibility_check)){
            $DL_products[] = $product->product_id;
          }
        }
        $order->c_total_amount  = new stdClass();
        foreach($this->currencies as $c){
          if ($c->code == 'rub') continue;
          $code = 'total_amount_'.$c->code;
          $order->c_total_amount->$code = $order->total_amount/$c->rate_to;
        }
        $order->c_total_amount_online  = new stdClass();
        foreach($this->currencies as $c){
          if ($c->code == 'rub') continue;
          $code = 'total_amount_online_'.$c->code;
          $order->c_total_amount_online->$code = $order->total_amount_online/$c->rate_to;
        }
        if ($order->payment_prepaid){
          $order->c_payment_prepaid  = new stdClass();
          foreach($this->currencies as $c){
            if ($c->code == 'rub') continue;
            $code = $c->code;
            $order->c_payment_prepaid->$code = $order->deposit_payment/$c->rate_to;
          }
        }
        if ($order->deposit_payment){
          $order->c_deposit_payment  = new stdClass();
          foreach($this->currencies as $c){
            if ($c->code == 'rub') continue;
            $code = $c->code;
            $order->c_deposit_payment->$code = $order->deposit_payment/$c->rate_to;
          }
        }
        if ($order->coupon_type == "absolute"){
          $order->c_coupon_discount  = new stdClass();
          foreach($this->currencies as $c){
            if ($c->code == 'rub') continue;
            $code = $c->code;
            $order->c_coupon_discount->$code = $order->c_coupon_discount/$c->rate_to;
          }
        }
        $this->smarty->assign('order', $order);
        $this->smarty->assign('DL_products', $DL_products);
        
        $sber_on = $this->db->result("SELECT COUNT(enabled) AS t FROM payment_methods WHERE payment_method_id = 15 AND (enabled = 1 OR (enabled = 0 AND block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND block_date != 0))" )->t;
        if($sber_on){
          $this->db->query("UPDATE payment_methods SET enabled=1, block_date = 0 WHERE payment_method_id = 15" );
          $this->db->query("UPDATE app_payments SET ad_enabled=1, ios_enabled=1, block_date = 0 WHERE id = 1" );
          $this->db->query("UPDATE app_payments SET ios_enabled=1, block_date = 0 WHERE id = 3" );
          $this->db->query("UPDATE app_payments SET ad_enabled=1, block_date = 0 WHERE id = 4" );
        }
        $this->smarty->assign('sber_on', $sber_on);
        
        $rfi_on = $this->db->result("SELECT COUNT(enabled) AS t FROM payment_methods WHERE payment_method_id = 18 AND (enabled = 1 OR (enabled = 0 AND block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND block_date != 0))" )->t;
        if($rfi_on){
          $this->db->query("UPDATE payment_methods SET enabled=1, block_date = 0 WHERE payment_method_id = 18" );
          $this->db->query("UPDATE app_payments SET ad_enabled=1, ios_enabled=1, block_date = 0 WHERE id = 2" );
        }
        $this->smarty->assign('rfi_on', $rfi_on);

        // Сформируем массив способов оплаты
        if (!empty($order->delivery_method_id)) {
            // Если указан способ доставки - выберем соответствующие ему варианты оплаты
            $query = sql_placeholder("
                SELECT payment_methods.*, currencies.rate_from as currency_rate_from, currencies.rate_to as currency_rate_to, currencies.sign as currency_sign, currencies.code as currency_code
                  FROM payment_methods, delivery_payment, currencies
                WHERE (payment_methods.enabled OR (payment_methods.enabled = 0 AND payment_methods.block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND payment_methods.block_date != 0))
                  AND delivery_payment.payment_method_id = payment_methods.payment_method_id
                  AND delivery_payment.delivery_method_id = ?
                  AND currencies.currency_id = payment_methods.currency_id
                ORDER BY payment_method_id", $order->delivery_method_id);
        }
        else {
            // Иначе - все варианты оплаты
            $query = sql_placeholder("
                SELECT payment_methods.*, currencies.rate_from as currency_rate_from, currencies.rate_to as currency_rate_to, currencies.sign as currency_sign, currencies.code as currency_code
                  FROM payment_methods, currencies
                WHERE (payment_methods.enabled OR (payment_methods.enabled = 0 AND payment_methods.block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND payment_methods.block_date != 0))
                  AND currencies.currency_id = payment_methods.currency_id
                ORDER BY payment_method_id");
        }
        $this->db->query($query);
        $payment_methods = $this->db->results();
        foreach ($payment_methods as $k=>$payment_method) {
            $payment_methods[$k]->amount         = round($order->total_amount, 2);
            $payment_methods[$k]->online_amount         = round($order->total_amount_online, 2);
            $payment_methods[$k]->payment_button = $this->payment_button($payment_method, $order);
            if (file_exists("images/".$payment_method->module.".png")) {
                $payment_methods[$k]->image = $payment_method->module.".png";
            }
        }
        $this->smarty->assign('PaymentMethods', $payment_methods);

        // Выберем способы доставки
        if (!empty($order->city_id)) {
            $sity2del = $this->db->result("SELECT delivery_methods FROM cities WHERE city_id = '{$order->city_id}';")->delivery_methods;
            $delivery_methods = $this->db->results("SELECT * FROM delivery_methods
                                    WHERE delivery_method_id IN ({$sity2del}) AND enabled = 1
                                    ORDER BY delivery_method_id");
            $this->smarty->assign('delivery_methods', $delivery_methods);
            $this->smarty->assign('delivery_id', explode(', ', $this->db->result("SELECT pref_delivery_methods FROM users WHERE user_id = '{$order->user_id}' LIMIT 1")->pref_delivery_methods));
        }

        // Cities list
        $this->smarty->assign('delivery_cities_main', $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;"));
        $this->smarty->assign('delivery_cities',      $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '0' ORDER BY city_name;"));

        if (isset($_GET['status_order'])) {
            $status_order = $_GET['status_order'];
            $this->smarty->assign('status_order', $status_order);
        }

        $need_social_account = false;
        if ( $_SESSION['user']->user_id ) {
            $need_social_account = !luser::has_social_account($_SESSION['user']->user_id);
        }
        $this->smarty->assign('need_social_account', $need_social_account);

        if (isset($_SESSION['NEW_USER_ORDER'])){
            $this->smarty->assign('new_user_order', $_SESSION['NEW_USER_ORDER']);
            unset($_SESSION['NEW_USER_ORDER']);
        }

        $rfi_comment = $this->db->results("SELECT * FROM `rfi_transactions` WHERE `order_id` = '{$order->order_id}' ORDER BY `datetime` DESC ");
        if (!empty($rfi_comment)) {
           $this->smarty->assign('rfi_comment', $rfi_comment);
        }
        if (isset($_GET['getsber'])) {
            $this->smarty->assign('getsber', $_GET['getsber']);
        }
        return $this->body = $this->smarty->fetch('order.tpl');
    }


    // Кнопка для оплаты определенного заказа определенным способом
    function payment_button($method, $order) {
        $shopId     = '2013263';
        $secretKey  = 'SDFsdef132DFSjkh3746';

        switch ($method->module) {

        case 'rbk_money':
            // RBK Money
            $success_url = 'https://'.$this->root_url.'/order/'.$order->code;
            $fail_url    = 'https://'.$this->root_url.'/order/'.$order->code;

            $serviceNames = array();
            if (is_array($order->products) && count($order->products)) {
                foreach ($order->products as $item) {
                    $serviceNames[] = $item->model;
                }
            }
            $serviceName = implode(", ", $serviceNames);

            $hash = MD5("{$shopId}::{$method->amount}::RUR::{$order->email}::{$serviceName}::{$order->order_id}::::{$secretKey}");
            $button = "<form action='https://rbkmoney.ru/acceptpurchase.aspx' id='{$method->module}' name='pay' method='POST'>
                        <input type='hidden' name='eshopId' value='{$shopId}'>
                        <input type='hidden' name='orderId' value='{$order->order_id}'>
                        <input type='hidden' name='serviceName' value='{$serviceName}'>
                        <input type='hidden' name='recipientAmount' value='{$method->amount}'>
                        <input type='hidden' name='recipientCurrency' value='RUR'>
                        <input type='hidden' name='successUrl' value='{$success_url}'>
                        <input type='hidden' name='failUrl' value='{$fail_url}'>
                        <input type='hidden' name='user_email' value='{$order->email}'>
                        <input type='hidden' name='hash' value='{$hash}'>
                        </form>";
            break;

        case 'visa_mc': // Visa/MasterCard
            $success_url = 'https://'.$this->root_url.'/order/'.$order->code;
            $fail_url    = 'https://'.$this->root_url.'/order/'.$order->code;

            $serviceNames = array();
            if (is_array($order->products) && count($order->products)) {
                foreach ($order->products as $item) {
                    $serviceNames[] = $item->model;
                }
            }
            $serviceName = implode(", ", $serviceNames);

            $hash = MD5("{$shopId}::{$method->amount}::RUR::{$order->email}::{$serviceName}::{$order->order_id}::::{$secretKey}");
            $button = "<form action='https://rbkmoney.ru/acceptpurchase.aspx' id='{$method->module}' name='pay' method='POST'>
                        <input type='hidden' name='eshopId' value='{$shopId}'>
                        <input type='hidden' name='orderId' value='{$order->order_id}'>
                        <input type='hidden' name='serviceName' value='{$serviceName}'>
                        <input type='hidden' name='recipientAmount' value='{$method->amount}'>
                        <input type='hidden' name='recipientCurrency' value='RUR'>
                        <input type='hidden' name='successUrl' value='{$success_url}'>
                        <input type='hidden' name='failUrl' value='{$fail_url}'>
                        <input type='hidden' name='user_email' value='{$order->email}'>
                        <input type='hidden' name='hash' value='{$hash}'>
                        </form>";
            break;

        case 'rfi_payment': // RFI - Visa/MasterCard
            if (!$order->no_payment_discount) {
                $method->amount = $method->online_amount;
            }
            $button =  "<form method='POST'  class='application' id='{$method->module}' name='pay' accept-charset='UTF-8' action='https://partner.rficb.ru/alba/input/'>
                            <input type='hidden' name='key' value='{$this->settings->rfi_open_key}' />
                            <input type='hidden' name='cost' value='{$method->amount}' />
                            <input type='hidden' name='type' value='spg' />
                            <input type='hidden' name='name' value='Заказ №{$order->order_id}' />
                            <input type='hidden' name='default_email' value='{$order->email}' />
                            <input type='hidden' name='order_id' value='{$order->order_id}' />
                        </form>";
            break;

        case 'ya_money': // Yandex Money
            $serviceNames = array();
            if (is_array($order->products) && count($order->products)) {
                foreach ($order->products as $item) {
                    $serviceNames[] = $item->model;
                }
            }
            $serviceName = 'Покупка товаров в Лакшери Стор: ' . implode(", ", $serviceNames);

            $button = "<form id='{$method->module}' action='https://money.yandex.ru/quickpay/confirm.xml' target='_top' method='POST'>
                        <input type='hidden' value='41001351609845' name='receiver'>
                        <input type='hidden' value='' name='label'>
                        <input type='hidden' value='Лакшери Стор' name='FormComment'>
                        <input type='hidden' value='{$serviceName}' name='short-dest'>
                        <input type='hidden' value='false' name='writable-targets'>
                        <input type='hidden' value='false' name='writable-sum'>
                        <input type='hidden' value='true' name='comment-needed'>
                        <input type='hidden' value='small' name='quickpay-form'>
                        <input type='hidden' value='{$serviceName}' name='targets'>
                        <input type='hidden' value='{$method->amount}' maxlength='8' name='sum'>
                        <input type='hidden' value='{$order->email}' name='mail'>
                        </form>";
            break;
        default:
            $button = '';
        }
        return $button;
    }

    /**
     * Возвращает заказ по коду
     */
    function get_order_by_code($code) {
        $order = $this->db->result("SELECT * FROM orders WHERE code='{$code}' LIMIT 1");
        return $order ? Order::get_order_by_id($order->order_id) : false;
    }

    /**
     * Возвращает заказ по id
     */
    function get_order_by_id($order_id)
    {
        // На всякий случай приводим к числу
        $order_id = intval($order_id);
        if ($this->settings->theme == 'api') {
            $fields = 'orders.order_id, orders.invoice_number, orders.delivery_company_id, orders.weight, orders.delivery_status, orders.delivery_price, orders.delivery_paid, orders.money_status, orders.delivery_price, orders.real_delivery_price, orders.payment_prepaid, orders.coupon_code, orders.date, orders.user_id, orders.manager_id, orders.name, orders.address, orders.city_id, orders.city, orders.region, orders.country, orders.phone, orders.email, orders.user_comment, orders.status, orders.code, orders.deposit_payment';
        }
        else{$fields = 'orders.*';}
        $query    = sql_placeholder("SELECT ".$fields.",
                                     SUM(orders_products.price*orders_products.quantity)-orders.deposit_payment-orders.payment_prepaid as total_amount,
                                     DATE_FORMAT(orders.date, '%d.%m.%Y %H:%i') as date,
                                     DATE_FORMAT(orders.payment_date, '%d.%m.%Y %H:%i') as payment_date,
                                     delivery_methods.name as delivery_method
                                FROM orders
                                   LEFT JOIN orders_products ON orders.order_id = orders_products.order_id
                                   LEFT JOIN delivery_methods ON orders.delivery_method_id = delivery_methods.delivery_method_id
                                WHERE orders.order_id=?
                                GROUP BY orders.order_id
                                LIMIT 1", $order_id);
        $this->db->query($query);
        $order = $this->db->result();

        if(!empty($order->coupon_code)){
            if($order->coupon_type == 'absolute'){
                $order->total_amount = max(0, $order->total_amount-$order->coupon_discount);
            }else{
                $order->total_amount = round($order->total_amount*(1-$order->coupon_discount/100), 2);
            }
        }
        if ($this->settings->theme == 'api') {
          $statuses = array(
            0 => 'Новый',
            1 => 'В обработке',
            2 => 'Выполнен',
            3 => 'Отмена заказа',
            4 => 'Товар отсутствует',
            5 => 'Самовывоз',
            6 => 'Доставка');
          $order->status = $statuses[$order->status];
          $order->manager_info = $this->db->result("SELECT original_user_id, email, name, photo, phone_number, pref_messenger as messengers, wh.start as wh_start, wh.end as wh_end FROM users u LEFT JOIN work_hours wh ON wh.user_id = u.user_id AND wh.date = DATE(NOW()) WHERE u.user_id = '{$order->manager_id}';");
          if ( $order->manager_info ) {
            $order->manager_info->messengers = $this->db->results("SELECT * FROM messengers WHERE `id` IN ({$order->manager_info->messengers});");
            if(empty($order->manager_info->messengers))$order->manager_info->messengers = null;
            foreach($order->manager_info->messengers as $m)$m->icon = 'https://lsboutique.ru/admin/images/icons/' . $m->icon;
            if(strpos($order->manager_info->photo, 'http') === false) $order->manager_info->photo = 'https://lsboutique.ru' . ($order->manager_info->photo ? $order->manager_info->photo : '/images/empty_photo.png');
          }
          else {$order->manager_info = null;}
          $order->tk_info = $this->db->result("SELECT name,phone,track_link FROM delivery_companies WHERE id = '{$order->delivery_company_id}'");
          if(!empty($order->tk_info->track_link))$order->tk_info->track_link = $order->tk_info->track_link . $order->invoice_number;
          if(!$order->tk_info)$order->tk_info = null;
          $order->money_status = ($order->total_amount == 0) ? "2" : $order->money_status;
        }

        if ($order) {
            // Все товары в этом заказе
            $query = sql_placeholder("SELECT orders_products.*, orders_products.price as order_price, items.barcode, products.url as url, products.model as model, products.season_type, products.old_price, products.offline_price, products.last_price_online, products.price as price, brands.brand_id, brands.name as brand_name, categories.name as category_name, categories.eng_single_name as eng_category_name, categories.enabled as category_enabled
                                        FROM orders_products
                                        LEFT JOIN products ON products.product_id=orders_products.product_id
                                        LEFT JOIN brands ON brands.brand_id=products.brand_id
                                        LEFT JOIN items ON items.product_id=products.product_id
                                        LEFT JOIN categories ON categories.category_id=products.category_id
                                      WHERE orders_products.order_id=? GROUP BY orders_products.id", $order_id);
            $this->db->query($query);
            $order->products = $this->db->results();
            if ($this->settings->theme == 'api') {
              $currency = isset($_GET['currency']) ? $_GET['currency'] : 'rub';
              $c_rate = $this->db->result("SELECT COALESCE(rate_to,1) as rate_to FROM currencies WHERE code = '{$currency}'")->rate_to;
              foreach($order->products as $k=>$p){
                $p->url = 'https://lsboutique.ru/products/'.$p->url;
                $start_price = $p->old_price != 0 ? $p->old_price : $p->offline_price;
                if(empty($start_price))$start_price = $p->price;
                $max_sale = $this->db->result($sql = "SELECT max_sale FROM sale_settings WHERE brand_id = '{$p->brand_id}' AND season = '{$p->season_type}' LIMIT 1;")->max_sale;
                $min_price = $start_price*((100-$max_sale)/100);
                $price_online = (string)($p->order_price*0.95);
                if ($price_online < $min_price)$price_online = $p->order_price;
                $order->total_amount_online += $price_online;
                $p->order_price_online = (string)(round($price_online/$c_rate, 0));
                $p->order_price = (string)(round($p->order_price/$c_rate, 0));
                $p->price = (string)(round($p->price/$c_rate, 0));
                $p->offline_price = (string)(round($p->offline_price/$c_rate, 0));
                if ($c_rate != 1){
                  $p->currency_rate = $c_rate;
                  $p->currency = $currency;
                }
                if($_COOKIE['language'] === 'eng')$p->category_name = $p->eng_category_name;
                unset($p->item_location,$p->offline_manager_id,$p->user_id,$p->barcode,$p->new_order,$p->transaction_completed,$p->one_click_id,$p->mtm_status,$p->process_status,$p->unique_id,$p->item_id,$p->model,$p->old_price,$p->last_price_online,$p->eng_category_name,$p->category_enabled);
              }
              $order->total_amount = (string)(round($order->total_amount/$c_rate, 0));
              $order->total_amount_online = (string)(round($order->total_amount_online/$c_rate, 0));
            }
            if($_COOKIE['language'] === 'eng'){
              foreach($order->products as $k=>$p){
                $order->products[$k]->model = $p->eng_category_name . ' ' . $p->brand_name;
              }
            }
        }
        return $order;
    }

    function get_rfi() {
        $v = $this->db->result("SELECT value FROM settings WHERE name = 'rfi_active'")->value;
        $return->data->rfi_service_id = $this->db->result("SELECT value FROM settings WHERE name = 'rfi_m_serviceid_{$v}'")->value;
        $return->data->rfi_key = $this->db->result("SELECT value FROM settings WHERE name = 'rfi_m_key_{$v}'")->value;
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
        die;
    }


    function update_order($update_object) {
        $user_id =  ($this->settings->theme == 'api' && !empty($_POST['user_id'])) ? $_POST['user_id'] : $_SESSION['user']->user_id;
        if (!$user_id && !empty($user_id)) {
            exit();
        }
        $o_id = (int)$update_object->order_id;
        if ($this->settings->theme == 'api') {
            if($this->settings->theme_v == 'v2'){$return->success = false;}
            if (!$o_id){$return->error = 'no order_id';}
            if (!$user_id){$return->error = 'no user_id';}
        }

        foreach ($update_object->data as $k => $v) {
            $k = $this->db->escape($k);
            $v = $this->db->escape($v);
            if ($k == 'city_id') {
                if(ctype_digit($v)){
                  $c = $this->db->result("SELECT * FROM delivery_cities WHERE city_id = {$v}");
                }
                else{
                  $c = $this->db->result("SELECT * FROM delivery_cities WHERE city_name = '{$v}'");
                  $v = $c->city_id;
                }
                $add = ",city = '{$c->city_name}'";
                $sity2del = $this->db->result("SELECT delivery_methods FROM cities WHERE city_id = '{$v}';")->delivery_methods;
                $delivery_methods = $this->db->results("SELECT * FROM delivery_methods
                                    WHERE delivery_method_id IN ({$sity2del}) AND enabled = 1
                                    ORDER BY delivery_method_id");
                $metods_return = '';
                if(!empty($delivery_methods)){
                    $pdm = explode(', ', $this->db->result("SELECT pref_delivery_methods FROM users WHERE user_id = '{$user_id}' LIMIT 1")->pref_delivery_methods);
                    $metods_return = "<option value='0'>Вы можете выбрать способ доставки</option>";
                    foreach($delivery_methods as $method){
                        $selected = ($method->delivery_method_id == $pdm[0]) ? 'selected' : '';
                        $metods_return .= "<option value='{$method->delivery_method_id}' {$selected}>{$method->name}</option>";
                    }
                }
            }
            $original_user_id = isset($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0;
            $this->db->query($q = sql_placeholder("UPDATE orders SET $k='$v'{$add} WHERE order_id=? AND user_id IN (?,?)", $o_id, $original_user_id, $user_id));

            if ($k != 'user_comment') {
                if ($k == 'address') {
                    $k = 'adress';
                }
                $this->db->query(sql_placeholder("UPDATE users SET $k='$v'{$add} WHERE user_id IN (?,?)", $original_user_id, $user_id));
            }
            if ($k == 'delivery_method_id' && $v != 0) {
                $c = $this->db->result("SELECT pref_delivery_methods FROM users WHERE user_id = '{$user_id}' LIMIT 1")->pref_delivery_methods;
                if (!in_array($v, explode(', ', $c))){
                    $k = 'pref_delivery_methods';
                    $v = !empty($c) ? $v . ', ' . $c : $v;
                    $this->db->query(sql_placeholder("UPDATE users SET $k='$v' WHERE user_id IN (?,?)", $original_user_id, $user_id));
                }
            }
            if ($this->settings->theme == 'api' && !empty($o_id) && !empty($user_id)) {
              if($this->settings->theme_v == 'v2'){$return->success = true;}
              else{$return = 'ok';}
            }
        }
        if ($this->settings->theme == 'api') {
            if($this->settings->theme_v == 'v2'){
              $r->obj[0] = $return;
              $return = $this->format_api_response($r);
            }
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
            die;
        }else{
            $_SESSION['user'] = $this->db->result(sql_placeholder('SELECT * FROM users WHERE user_id=? LIMIT 1', $_SESSION['user']->user_id));
            if (isset($metods_return)){
                echo $metods_return;
            }else{
                echo 'ok';
            }
            return true;
        }
    }
}
