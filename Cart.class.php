<?PHP
require_once('Widget.class.php');
require_once('Order.class.php');
require_once('models/order.php');
require_once('models/email_template.php');


class Cart extends Widget
{

    function Cart(&$parent) {
        Widget::Widget($parent);
        // Вызовем фунцию, обрататывающую действия с товарами в корзине
        $this->prepare();
    }

    function prepare() {
        // Добавление нескольких товаров одним запросом через параметр product_id[]
        if (is_array($this->param('product_id'))) {
            $product_ids = $this->param('product_id');
            if(is_array($product_ids[0])){
                $prod_tmp = array();
                foreach ($product_ids as $product) {
                    $prod_tmp[$product[0]] = $product[1];
                }
                $product_ids = array_keys($prod_tmp);
            }
            $products   = Storefront::get_products($product_ids);
            foreach ($products as $product) {
                /*if ( !empty($_SESSION['user']->original_user_id) ) {
                    $_SESSION['wish_list'][$product->product_id][$this->param('size')] = $product->price;
                    $this->save_wishlist();
                }*/
                $this->update($product->product_id, 1, true, $prod_tmp[$product->product_id]);
            }
            header("Location: /cart/");
            die();
        }

        if($product_id = intval($this->param('product_id'))) {
            if ( isset($_GET['add_to_wishlist']) ) {
                $products = Storefront::get_products(array($product_id));
                $product = $products[0];
                if ( !empty($product) ) {
                    $size = ($this->param('size') != null) ? $this->param('size') : '';
                    $_SESSION['wish_list'][$product_id][$this->param('size')] = $product->price;
                    $this->save_wishlist();
                    if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'You have successfully put product in the wishlist.<br/><br/>You&nbsp;can&nbsp;<a href="/cart/show_wl/"><b>go to wishlist</b></a>&nbsp;or&nbsp;<a href="#" onclick="jQuery.fancybox.close();"><b>continue</b></a>';}
                    else{$_SESSION['USER_MESSAGE'] = 'Вы успешно отложили товар в&nbsp;вишлист.<br/><br/>Вы&nbsp;можете&nbsp;<a href="/cart/show_wl/"><b>перейти в вишлист</b></a>&nbsp;или&nbsp;<a href="#" onclick="jQuery.fancybox.close();"><b>продолжить</b></a>';}
                    if ( !empty($_SERVER["HTTP_REFERER"]) ) {
                        header("Location: {$_SERVER["HTTP_REFERER"]}");
                    }
                    else {
                        header("Location: /cart/show_wl/");
                    }
                    die();
                }
            }
            elseif ( isset($_GET['remove_from_wishlist']) ) {
                $products = Storefront::get_products(array($product_id));
                $product = $products[0];
                if ( !empty($product) ) {
                    $size = ($this->param('size') != null) ? $this->param('size') : '';
                    //var_dump($_GET);
                    if (isset($_GET['size']) && $_GET['size'] == 'all') {
                        $size = 'all';
                    }
                    $_SESSION['wish_list'][$product_id][$this->param('size')] = $product->price;
                    $this->delete_from_wl($product_id, $size);
                    if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'You successfully deleted the item from & nbsp; wishlist.<br/><br/>You&nbsp;can&nbsp;<a href="/cart/show_wl/"><b>go to wishlist</b></a>&nbsp;or&nbsp;<a href="#" onclick="jQuery.fancybox.close();"><b>continue</b></a>';}
                    else{$_SESSION['USER_MESSAGE'] = 'Вы успешно удалили товар из&nbsp;вишлиста.<br/><br/>Вы&nbsp;можете&nbsp;<a href="/cart/show_wl/"><b>перейти в вишлист</b></a>&nbsp;или&nbsp;<a href="#" onclick="jQuery.fancybox.close();"><b>продолжить</b></a>';}
                    if ( !empty($_SERVER["HTTP_REFERER"]) ) {
                        header("Location: {$_SERVER["HTTP_REFERER"]}");
                    }
                    else {
                        header("Location: /cart/show_wl/");
                    }
                    die();
                }
            }
            else {
                // Выберем товар из базы, заодно убедившись в его существовании
                $products   = Storefront::get_products(array($product_id));
                $product    = $products[0];
                if ( !empty($product) ) {
                    /*if ( !empty($_SESSION['user']->original_user_id) ) { // Если пользователь залогинен - добавим товар в корзину и в вишлист, сохраним желание человека
                        $_SESSION['wish_list'][$product_id][$this->param('size')] = $product->price;
                        $this->save_wishlist();
                    }*/
                    $this->update($product_id, 1, true, $this->db->escape($this->param('size')));
                    if($_COOKIE['language'] == 'eng'){$_SESSION['CHANGE_TITILE'] = 'Make an order';}
                    else{$_SESSION['CHANGE_TITILE'] = 'Оформить заказ';}
                    //$_SESSION['USER_MESSAGE'] = 'Вы успешно положили товар в&nbsp;корзину.<br/><br/>Вы&nbsp;можете&nbsp;<a href="/cart/"><b>оформить заказ</b></a>&nbsp;или&nbsp;<a href="#" onclick="jQuery.fancybox.close();"><b>продолжить</b></a>';
                    if ( !empty($_SERVER["HTTP_REFERER"]) ) {
                        header("Location: {$_SERVER["HTTP_REFERER"]}");
                    }
                    else {
                        header("Location: /cart/");
                    }
                    die();
                }
            }
            die();
        }

        // Удаление товара из корзины
        if($delete_product_id = intval($this->param('delete_product_id'))) {
            $delete_product_size = ($this->param('size') != null) ? $this->param('size') : '';
            $this->update($delete_product_id, 0, false, $delete_product_size);

            header("Location: /cart/");
            die();
        }

        // Добавим в вишлист (удалим из корзины)
        if($product_id = intval($this->param('towl_product_id'))) {
            if ( isset($_SESSION['shopping_cart_sizes'][$product_id]) ) {
                $size = ($this->param('size') != null) ? $this->param('size') : '';
                $_SESSION['wish_list'][$product_id][$size] = $_SESSION['shopping_cart_sizes'][$product_id][$size];
                $this->update($product_id, 0);
                $this->save_wishlist();
            }
            header("Location: /cart/show_wl/");
            die();
        }
        // Добавим в корзину из вишлиста
        if ($product_id = intval($this->param('fromwl_product_id'))) {
            if ( isset($_SESSION['wish_list'][$product_id]) ) {
                $size = ($this->param('size') != null) ? $this->param('size') : '';
                $_SESSION['shopping_cart_sizes'][$product_id][$size] = $_SESSION['wish_list'][$product_id][$size];
                $this->update($product_id, 1, true, $size);
                $this->delete_from_wl($product_id, $size);
                $this->save_wishlist();
            }
            header("Location: /cart/");
            die();
        }
        // Удалим из вишлиста
        if($product_id = intval($this->param('deletewl_product_id'))) {
            $size = ($this->param('size') != null) ? $this->param('size') : '';
            $this->delete_from_wl($product_id, $size);
            header("Location: /cart/show_wl/");
            die();
        }
    }

  //////////////////////////////////////////
  // Основная функция
  //////////////////////////////////////////
  function fetch() {
    $this->smarty->assign('title',       ($_COOKIE['language'] == 'eng') ? 'Cart' : 'Корзина');
    $this->smarty->assign('keywords',    'Корзина');
    $this->smarty->assign('description', 'Корзина');

    if ( !empty( $_COOKIE['save_card_number'] ) ) {
        $this->smarty->assign('save_card_number', substr($_COOKIE['save_card_number'], -16));
    }
    if ( !empty( $_COOKIE['save_phone_number'] ) ) {
        $this->smarty->assign('save_phone_number', substr($_COOKIE['save_phone_number'], -10));
    }


    if (isset($_GET['query'])) {
        return $this->get_cities($_GET['query']);
    }
    if (isset($_GET['import_cities'])) {
        return $this->import_cities();
    }
    if (isset($_GET['finish'])) {
        return $this->show_finish();
    }
    if (isset($_GET['vk_auth'])) {
        return $this->vk_auth();
    }
    if (isset($_GET['otp_auth'])) {
        return $this->otp_auth();
    }
    if (isset($_GET['otll_auth'])) {
        return $this->otll_auth();
    }
    if (isset($_GET['self_register'])) {
        return $this->self_register();
    }
    if (isset($_GET['save_data'])) {
        return $this->save_data();
    }
    if (isset($_GET['save_user'])) {
        return $this->save_user();
    }
    if (isset($_GET['personal_data'])) {
        return $this->personal_data();
    }
    if (isset($_GET['soc_add'])) {
      return $this->soc_add();
    }
    if (isset($_GET['user_mail_add'])) {
      return $this->user_mail_add();
    }
    if (isset($_GET['one_click'])) {
        return $this->one_click();
    }
    if (isset($_GET['call_me'])) {
        return $this->call_me();
    }
    if (isset($_GET['crime_teilor_tickets'])) {
        return $this->crime_teilor_tickets();
    }
    if (isset($_GET['card_select'])) {
        return $this->card_select();
    }
    if (isset($_GET['person_select'])) {
        return $this->person_select();
    }
    if (isset($_GET['phone_check'])) {
      return $this->phone_check();
    }

    if(isset($_GET['avatar_change'])){
      return $this->avatar_change();
    }

    // Если нажали выбор города
    if(isset($_GET['geo_select'])) {
        return $this->geo_select();
    }

    // Если нажали error (видят только админы и модераторы)
    if (isset($_GET['error_message'])) {
        return $this->error_message();
    }

    // Если нажали client_add (видят только админы и модераторы)
    if (isset($_GET['client_add'])) {
        return $this->client_add();
    }
    // Если нажали client_find (видят только админы и модераторы)
    if (isset($_GET['client_find'])) {
        return $this->client_find();
    }
/*
    if(isset($_GET['helpform'])) {
        return $this->helpform();
    }

    if (isset($_GET['special_order'])) {
      return $this->special_order();
    }
*/
    if (isset($_GET['special_order_save'])) {
      return $this->special_order_save();
    }

    elseif ($this->settings->theme == 'api' && empty($_POST['submit_order']) && !empty($_REQUEST['submit_order'])){
        $_POST = $_REQUEST;
        return $this->save_order();
    }
    // Если нажали кнопку "оформить заказ"
    elseif (isset($_POST['submit_order']) && $_POST['submit_order']==1) {
      return $this->save_order();
    }
    // Если нажали кнопку "оформить заказ"
    elseif (isset($_GET['form_order'])) {
        return $this->form_order();
    }
    elseif (isset($_GET['man_or_woman'])) {
      return $this->man_or_woman();
    }
    elseif (isset($_GET['cities_select'])) {
      return $this->cities_select();
    }
    elseif (isset($_GET['api_get_cities'])) {
      return $this->api_get_cities();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_networks']) ) {
        $this->get_networks();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_managers']) ) {
        $this->get_managers();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_pay_methods']) ) {
        $this->get_pay_methods();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['api_apple_pay']) ) {
        $this->api_apple_pay();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['api_g_pay']) ) {
        $this->api_g_pay();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['api_sber_pay']) ) {
        $this->api_sber_pay();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['sber_pay_check']) ) {
        $this->sber_pay_check();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_wardrobe']) ) {
        $this->get_wardrobe();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_wishlist']) ) {
        $this->get_wishlist();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_cart']) ) {
        $this->get_cart();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['api_update_cart']) ) {
        $this->api_update_cart();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_keys']) ) {
        $this->get_keys();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_all_sizes']) ) {
        $this->get_all_sizes();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['get_orders']) ) {
        $this->get_orders();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['api_save_wishlist']) ) {
        $this->api_save_wishlist();
    }
    elseif ( $this->settings->theme == 'api' && isset($_GET['api_get_currencies']) ) {
        $this->api_get_currencies();
    }
    // Иначе просто выведем корзину на экран
    else {
      return $this->show_cart();
    }
  }

  function get_pay_methods() {
    $sber_on = $this->db->result("SELECT COUNT(enabled) AS t FROM payment_methods WHERE payment_method_id IN (15) AND (enabled = 1 OR (enabled = 0 AND block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND block_date != 0))" )->t;
    if($sber_on){
      $this->db->query("UPDATE payment_methods SET enabled=1, block_date = 0 WHERE payment_method_id IN (15)" );
      $this->db->query("UPDATE app_payments SET ad_enabled=1, ios_enabled=1, block_date = 0 WHERE id = 1" );
      $this->db->query("UPDATE app_payments SET ios_enabled=1, block_date = 0 WHERE id = 3" );
      $this->db->query("UPDATE app_payments SET ad_enabled=1, block_date = 0 WHERE id = 4" );
    }

    $rfi_on = $this->db->result("SELECT COUNT(enabled) AS t FROM payment_methods WHERE payment_method_id IN (18) AND (enabled = 1 OR (enabled = 0 AND block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND block_date != 0))" )->t;
    if($rfi_on){
      $this->db->query("UPDATE payment_methods SET enabled=1, block_date = 0 WHERE payment_method_id IN (18)" );
      $this->db->query("UPDATE app_payments SET ad_enabled=1, ios_enabled=1, block_date = 0 WHERE id = 2" );
    }
    if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false){
      $return = $this->db->results("SELECT id, name, currencies, ios_enabled AS enabled, refund FROM app_payments WHERE ios_enabled = 1 ");
    }
    else {
      $return = $this->db->results("SELECT id, name, currencies, ad_enabled AS enabled, refund FROM app_payments WHERE ad_enabled = 1");
    }
    foreach($return as $r){
      $r->currencies = $this->db->results("SELECT name, code, rate_to FROM currencies WHERE currency_id IN ({$r->currencies})");
      if(empty($r->currencies)) $r->currencies = array();
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die();
  }

  function api_apple_pay() {
    if ((empty($_GET['token']) && !empty($_REQUEST['token']))) $_GET = $_REQUEST;
    if ( isset($_GET['token']) && !empty($_GET['token'])) {
      $order = new orders();
      if(isset($_GET['test']))$test=true;
      $user_id=(int)$_GET['user_id'];
      $order_id=(int)$_GET['orderNumber'];
      $data = $order->apple_pay_relay($_GET['token'], $order_id, $user_id, $test);
      $return->success = $data->success;
      if($data->error->message) $return->message = $data->error->message;
    }
    else{
      $return->success = false;$return->message = 'Empty token';
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die();
  }

  function api_g_pay() {
    if ((empty($_GET['token']) && !empty($_REQUEST['token']))) $_GET = $_REQUEST;
    if ( isset($_GET['token']) && !empty($_GET['token'])) {
        mail('tirjen@gmail.com', "GPGET  data", $_GET);
      $order = new orders();
      if(isset($_GET['test']))$test=true;
      $user_id=(int)$_GET['user_id'];
      $order_id=(int)$_GET['orderNumber'];
      $order_data = $this->db->result("SELECT * FROM orders WHERE order_id = '{$order_id}' ");
      $order_products = $this->db->results("SELECT p.product_id, p.sku, p.price, p.old_price, p.offline_price, p.brand_id, p.season_type, op.currency, op.price AS order_price FROM orders_products op LEFT JOIN products p ON op.product_id = p.product_id WHERE order_id = '{$order_id}' ");
      $order_total = 0;
      foreach($order_products AS $product){
        if($product->sku != 'testproduct'){
          $start_price = $product->old_price != 0 ? $product->old_price : $product->offline_price;
          if(empty($start_price))$start_price = $product->price;
          $max_sale = $this->db->result($sql = "SELECT max_sale FROM sale_settings WHERE brand_id = '{$product->brand_id}' AND season = '{$product->season_type}' LIMIT 1;")->max_sale;
          $min_price = $start_price*((100-$max_sale)/100);
          $price_online = (string)($product->order_price*0.95);
          if ($price_online < $min_price)$price_online = $product->order_price;
        }
        else{
          $currency_rate = $this->db->result("SELECT rate_to FROM currencies WHERE code = '{$product->currency}'")->rate_to;
          $price_online = (string)round($product->order_price*$currency_rate,2);
        }
        $order_total += $price_online;
      }
      if($order_total < 1)$order_total = 1;
      if($order_total == $order_data->payment_prepaid){
        $return->success = true;
        $return->message = $_COOKIE['language'] == 'eng' ? 'Payment already paid' : 'Чек уже оплачен';
      }
      $data = $order->google_pay_relay($_GET['token'], $order_id, $order_total, $user_id, $test);
      $return->success = $data->success;
      if(isset($data->data->acsUrl)){
        $return->data->mdOrder = $data->data->orderId;
        $return->data->acsUrl = $data->data->acsUrl;
        $return->data->paReq = $data->data->paReq;
        $return->data->termUrl = $data->data->termUrl;
      }
      if($data->error->message) $return->message = $data->error->message;
    }
    else{
      $return->success = false;$return->message = 'Empty token';
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die();
  }

  function api_sber_pay() {
    if (isset($_GET['order_id']) && !empty($_GET['order_id']) && ctype_digit($_GET['order_id'])) {
      $user_id=(int)$_GET['user_id'];
      $order_id=(int)$_GET['order_id'];
      $order = $this->db->result("SELECT * FROM orders WHERE order_id = '{$order_id}' ");
      $order_products = $this->db->results("SELECT p.product_id, p.price, p.old_price, p.offline_price, p.brand_id, p.season_type, op.price AS order_price FROM orders_products op LEFT JOIN products p ON op.product_id = p.product_id WHERE order_id = '{$order_id}' ");
      $order_total = 0;
      foreach($order_products AS $product){
        if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false) {$price_online = $product->order_price;}
        else{
          $start_price = $product->old_price != 0 ? $product->old_price : $product->offline_price;
          if(empty($start_price))$start_price = $product->price;
          $max_sale = $this->db->result($sql = "SELECT max_sale FROM sale_settings WHERE brand_id = '{$product->brand_id}' AND season = '{$product->season_type}' LIMIT 1;")->max_sale;
          $min_price = $start_price*((100-$max_sale)/100);
          $price_online = (string)($product->order_price*0.95);
          if ($price_online < $min_price)$price_online = $product->order_price;
        }
        $order_total += $price_online;
      }
      if($order_total < 1)$order_total = 1;
      if($order_total == $order->payment_prepaid){
        $return->success = true;
        $return->message = $_COOKIE['language'] == 'eng' ? 'Payment already paid' : 'Чек уже оплачен';
      }
      else{
        if(!empty($order->code) && empty($order->sber_order_id)){
          require_once('Sberbankpayment.class.php');
          $sb = new CSberbank();
          $url = 'https://lsboutique.ru/';
          $data = $sb->registerOrder($order_total, $order->code, $url, $order->order_id);
          $this->db->query("UPDATE orders SET sber_order_id = '{$data['orderId']}' WHERE code = '{$order->code}'");
          if($data['formUrl'] !='' || $data['orderId'] !=''){
            $return->success = true;
            $return->url = $data['formUrl'];
            $return->termUrl = "https://lsboutique.ru/";
            $return->orderId = $data['orderId'];
          }
          else{
            $mess = var_export($data, true);
            mail('tirjen@gmail.com', "API Sber error", $mess);
            $return->success = false;
            $return->message = $_COOKIE['language'] == 'eng' ? 'Internal ERROR' : 'Ошибка сервера';
          }
        }
        elseif(!empty($order->sber_order_id)){
          $return->success = true;
          $return->url = "https://securepayments.sberbank.ru/payment/merchants/sbersafe/payment_ru.html?mdOrder={$order->sber_order_id}";
          $return->termUrl = "https://lsboutique.ru/";
          $return->orderId = $order->sber_order_id;
        }
        else{
          $return->success = false;
          $return->message = $_COOKIE['language'] == 'eng' ? 'No such order found' : 'Заказ не найден';
        }
      }
    }
    else{
      $return->success = false;
      $return->message = $_COOKIE['language'] == 'eng' ? 'Invalid order number' : 'Некорректный номер заказа';
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die();
  }

  function sber_pay_check() {
    if (isset($_GET['payment']) && !empty($_GET['payment'])) {
      $md_order = $_GET['payment'];
      $payment = $this->db->result("SELECT * FROM sber_transactions WHERE md_order = '{$md_order}' ");
      if(!empty($payment) && $payment->status == 1){
        $return->success = true;
      }
      elseif(!empty($payment) && $payment->status != 1){
        $return->success = false;
        $return->message = $_COOKIE['language'] == 'eng' ? 'Declined by timeout' : "Истекло время на оплату заказа";
      }
      else{
        $return->success = false;
        $return->message = $_COOKIE['language'] == 'eng' ? 'No such payment found' : 'Оплата не найдена';
      }
    }
    else{
      $return->success = false;
      $return->message = $_COOKIE['language'] == 'eng' ? 'Invalid payment id' : 'Некорректный ID оплаты';
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die();
  }

  function api_save_wishlist() {
    if (isset($_GET['user_id']) && !empty($_GET['user_id']) && isset($_GET['p_id']) && !empty($_GET['p_id'])){
      $user_id = intval($_GET['user_id']);
      $product_id = intval($_GET['p_id']);
      $delete = isset($_GET['del']) ? true : false;
      $user = new luser($user_id);
      $product = $this->db->result("SELECT * FROM products WHERE product_id = '{$product_id}' ");
      $can_buy_from_site = $user->can_buy_from_site($product->brand_id);
      if($can_buy_from_site || $delete){
        $size = isset($_GET['size']) ? preg_split("/,(?!5)/", $_GET['size']) : array(0);
        $sizes = isset($_GET['sizes']) ? preg_split("/,(?!5)/", trim($_GET['sizes'],'][')) : array(0);
        $sizes = array_unique(array_filter(array_merge($sizes,$size)));
        if(empty($sizes)){$sizes=array(0);}
        foreach($sizes as $k=>$size){$sizes[$k] = trim($size);}

        $wish_tmp = $this->db->results("SELECT * FROM users2wishlist WHERE user_id = '{$user_id}' ");
        foreach($wish_tmp as $item){$res_wish[$item->product_id][$item->size] = $item->price;}
        $fail = array();
        $success = array();
        $products   = Storefront::get_products(array($product_id));
        $product    = $products[0];
        foreach($sizes as $size){
          if(!empty($size)){$product_check = isset($res_wish[$product_id][$size]);}
          else{$product_check = isset($res_wish[$product_id]);}
          if($delete === true){
            if (empty($product_check)) {array_push($fail,$size);}
            else{
              if(!empty($size)){
                unset($res_wish[$product_id][$size]);
                //if(empty($res_wish[$product_id])){unset($res_wish[$product_id]);}
              }
              else{unset($res_wish[$product_id]);}
              array_push($success,$size);
            }
          }else{
            if (empty($product_check)) {
              if(!empty($size)){$res_wish[$product_id][$size] = $product->price;}
              else{$res_wish[$product_id][''] = $product->price;}
              array_push($success,$size);
            }
            else{array_push($fail,$size);}
          }
        }
        $user->save_wishlist($user_id, $res_wish);
        $s = ' ';
        $success = array_filter($success);
        $fail = array_filter($fail);
        if(count($success) > 0){
          $return->success = true;
          if(!in_array('',$success)){
            if($_COOKIE['language'] == 'eng'){$s = (count($success) > 1) ? " (sizes " : "(size ";}
            else{$s = (count($success) > 1) ? " (размеры " : "(размер ";}
            $s .=  implode(',',$success).") ";
          }
        }else{
          $return->success = false;
          if(!in_array('',$fail)){
            if($_COOKIE['language'] == 'eng'){$s = (count($fail) > 1) ? " (sizes " : "(size ";}
            else{$s = (count($fail) > 1) ? " (размеры " : "(размер ";}
            $s .=  implode(',',$fail).") ";
          }
        }
        if($delete === true){
          if($return->success === true){
            if($_COOKIE['language'] == 'eng'){$return->message = "You had successfully removed product" . $s . "from Wishlist";}
            else{$return->message = "Вы успешно удалили товар" . $s . "из Отложено";}
          }
          else{
            if($_COOKIE['language'] == 'eng'){$return->message = "No such product in wishlist" . $s;}
            else{$return->message = "В Отложено нет такого товара" . $s;}
          }
        }else{
          if($return->success === true){
            if($_COOKIE['language'] == 'eng'){$return->message = "You had successfully added product". $s . "to Wishlist";}
            else{$return->message = "Вы успешно добавили товар". $s . "в Отложено";}
          }
          else{
            if($_COOKIE['language'] == 'eng'){$return->message = "This product is already in Wishlist". $s;}
            else{$return->message = "Этот товар уже находится в Отложено". $s;}
          }
        }
      }
      else{
        $return->success = false;
        $return->message = $_COOKIE['language'] == 'eng' ? "This product can't be plaсed in wishlist" : 'Этот товар нельзя добавить в Отложено';
      }
    }
    else{
      $return->success = false;
      if(!isset($_GET['user_id']) || empty($_GET['user_id']) || !is_numeric($_GET['user_id'])){
        $return->message = "invalid user id";
      }
      if(!isset($_GET['p_id']) || empty($_GET['p_id']) || !is_numeric($_GET['p_id'])){
        $return->message = "invalid product id";
      }
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die();
  }

  function get_wardrobe() {
    if ( isset($_GET['user_id']) && !empty($_GET['user_id']) && is_numeric($_GET['user_id']) ) {
        $user_id = $_GET['user_id'];
        ini_set('memory_limit', '256M');
        $users = $this->db->results("SELECT user_id FROM users WHERE original_user_id = '{$user_id}' ");
        $user_keys = array();
        foreach ($users as $key) {$user_keys[] = $key->user_id;}
        $user_keys = implode(',', $user_keys);
        $query = "SELECT p.model, CONCAT('https://lsboutique.ru/reimg/files/products/340x/', p.large_image) as image, CONCAT('https://lsboutique.ru/reimg/files/products/560x/', p.large_image) as image_medium, CONCAT('https://lsboutique.ru/files/products/', p.large_image) as image_full, op.product_id, op.size, op.price, op.currency, op.currency_rate, o.order_id, brands.name as brand, brands.brand_id, categories.name as category, categories.category_id
                  FROM `orders_products` op
                  LEFT JOIN orders o    ON op.order_id = o.order_id
                  LEFT JOIN products p  ON op.product_id = p.product_id
                  LEFT JOIN categories  ON categories.category_id = p.category_id
                  LEFT JOIN brands      ON p.brand_id = brands.brand_id
                WHERE o.user_id IN ({$user_keys}) AND o.status IN ('2','6') AND op.status = '5' AND o.cashbox_id = '0'
                GROUP BY op.product_id
                ORDER BY o.order_id DESC";
        $products = $this->db->results($query);
        foreach($products as $k=>$p){
          if(isset($_GET['currency']) && $_GET['currency'] != $p->currency){
            $currency_rate = $this->db->result("SELECT rate_to FROM currencies WHERE code = '".strtoupper($_GET['currency'])."'")->rate_to;
          }
          else{$currency_rate = $p->currency_rate;}
          $products[$k]->price = (string)round($p->price/$currency_rate,2);
        }
        $return->online_purchase = $products;

        $query = "SELECT p.model, CONCAT('https://lsboutique.ru/reimg/files/products/340x/', p.large_image) as image, CONCAT('https://lsboutique.ru/reimg/files/products/560x/', p.large_image) as image_medium, CONCAT('https://lsboutique.ru/files/products/', p.large_image) as image_full, pr.size as size, brands.name as brand, brands.brand_id, categories.name as category, categories.category_id
                    FROM `prodazhi` pr
                    RIGHT JOIN products p   ON pr.sku = p.sku
                    LEFT JOIN categories    ON categories.category_id = p.category_id
                    LEFT JOIN brands        ON p.brand_id = brands.brand_id
                WHERE pr.user_id IN ({$user_keys}) ORDER BY date DESC";
        $return->offline_purchase = $this->db->results($query);

        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    }
    die;
  }

  function get_wishlist() {
    if ( isset($_GET['user_id']) && !empty($_GET['user_id']) && is_numeric($_GET['user_id']) ) {
        $user_id = $_GET['user_id'];
        $user_data = $this->db->result("SELECT * FROM users WHERE user_id = '{$user_id}'");
        $wishlist = $this->db->results("SELECT * FROM users2wishlist WHERE user_id = '{$user_id}'");
        $product_tmp = array();
        if (!empty($wishlist)) {
          $image_link = 'https://lsboutique.ru';
          if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
          $user = new luser($user_id);
          $p_ids = array();
          foreach ($wishlist as $p) {$p_ids[] = $p->product_id;}
          $products = Storefront::get_products($p_ids);
          $res_products = array();
          foreach ($products as $pr) {$res_products[$pr->product_id] = $pr;}
          $ccode = isset($_GET['currency']) ? strtoupper($_GET['currency']) : 'RUB';
          $currency = $this->db->get_row("SELECT * FROM currencies WHERE code = '{$ccode}'");
          if (empty($currency)) $currency = $this->db->get_row("SELECT * FROM currencies WHERE code = 'RUB'");
          if (!empty($products)) {
            foreach ($wishlist as $product) {
              $id = $product->product_id;
              if($res_products[$id]){
                if(!isset($product_tmp[$id])){
                  $large_image = str_replace($image_link . '/reimg/files/products/560x/','',$res_products[$id]->large_image);
                  // Дополнительные фото товара
                  if ( $res_products[$id]->sex == 0 ) {
                      $female_images = $this->db->results("SELECT * FROM products_fotos WHERE product_id = {$res_products[$id]->product_id} AND female = 1");
                      if ($female_images && $user_data->sex == 2) {
                        $res_products[$id]->large_image = $female_images[0]->filename;
                      }
                      $male_only = ($user_data->sex == 1) ? ' AND female = 0 ' : '';
                      $query = "SELECT * FROM products_fotos WHERE product_id = {$res_products[$id]->product_id} AND foto_id NOT IN (20,21) AND cover_photo=0 {$male_only} ORDER BY foto_id";
                  }
                  else {
                      $query = "SELECT * FROM products_fotos WHERE product_id = {$res_products[$id]->product_id} AND big_size=0 AND cover_photo=0 ORDER BY foto_id";
                  }
                  $res_products[$id]->fotos = $this->db->results($query);
                  if($_COOKIE['language'] == 'eng'){$product_tmp[$id]->model = $res_products[$id]->eng_single_name . ' ' . $res_products[$id]->brand;}
                  else{$product_tmp[$id]->model = $res_products[$id]->model;}
                  $product_tmp[$id]->product_id = intval($id);
                  $product_tmp[$id]->price = (string)round($product->price/$currency->rate_to,2);
                  $product_tmp[$id]->category_id = $res_products[$id]->category_id;
                  $product_tmp[$id]->category = ($_COOKIE['language'] == 'eng') ? $res_products[$id]->eng_single_name : $res_products[$id]->category;
                  $product_tmp[$id]->brand_id = $res_products[$id]->brand_id;
                  $product_tmp[$id]->brand = '';
                  $product_tmp[$id]->large_image = $image_link . '/reimg/files/products/340x/'.$large_image;
                  $product_tmp[$id]->large_image_medium = $image_link . '/reimg/files/products/560x/'.$large_image;
                  $product_tmp[$id]->large_image_full = $image_link . '/files/products/'.$large_image;
                  $product_tmp[$id]->fotos = array();
                  foreach ($res_products[$id]->fotos as $foto)$product_tmp[$id]->fotos[] = $image_link . '/reimg/files/products/560x/'.$foto->filename;
                  $product_tmp[$id]->size  = $product->size != 'undefined' && strpos($product->size, 'задан') === false && strpos($product->size, 'азмер') === false ? $product->size.'' : '';
                  $product_tmp[$id]->sizes = array();
                  array_push($product_tmp[$id]->sizes,$product_tmp[$id]->size);
                  $product_tmp[$id]->prices = $user->product_prices_for_api($res_products[$id], $_GET['currency']);
                }
                else{
                  $size = $product->size != 'undefined' && strpos($product->size, 'задан') === false && strpos($product->size, 'азмер') === false ? $product->size.'' : '';
                  if(!empty($size)) {
                    array_push($product_tmp[$id]->sizes,$size);
                    if(!empty($product_tmp[$id]->size)) $product_tmp[$id]->size .= ', ' . $size;
                    else $product_tmp[$id]->size = $size;
                  }
                  $product_tmp[$id]->price += round($product->price/$currency->rate_to,2);
                  $product_tmp[$id]->price = (string)$product_tmp[$id]->price;
                }
              }
            }
          }
        }
        if($this->settings->theme_v == 'v2'){
          $return->obj = array_values($product_tmp);
          $return = $this->format_api_response($return);
        }
        else{
          $return->wishlist = array_values($product_tmp);
        }
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    }
    die;
  }

  function get_cart() {
    if ( isset($_GET['user_id']) && !empty($_GET['user_id']) && is_numeric($_GET['user_id']) ) {
        $user_id = $_GET['user_id'];
        $user_cart = $this->db->results("SELECT * FROM users2carts WHERE user_id = '{$user_id}'");
        $product_tmp = array();
        if (!empty($user_cart)) {
          $image_link = 'https://lsboutique.ru';
          if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
          $user = new luser($user_id);
          $p_ids = array();
          foreach ($user_cart as $p) {$p_ids[] = $p->product_id;}
          $products = Storefront::get_products($p_ids);
          $res_products = array();
          foreach ($products as $pr) {$res_products[$pr->product_id] = $pr;}
          $ccode = isset($_GET['currency']) ? strtoupper($_GET['currency']) : 'RUB';
          $currency = $this->db->get_row("SELECT * FROM currencies WHERE code = '{$ccode}'");
          if (empty($currency)) $currency = $this->db->get_row("SELECT * FROM currencies WHERE code = 'RUB'");
          if (!empty($products)) {
            foreach ($user_cart as $product) {
                $id = $product->product_id;
                if($res_products[$id]){
                  if(!isset($product_tmp[$id])){
                    $large_image = str_replace($image_link . '/reimg/files/products/560x/','',$res_products[$id]->large_image);
                    if($_COOKIE['language'] == 'eng'){$product_tmp[$id]->model = $res_products[$id]->eng_single_name . ' ' . $res_products[$id]->brand;}
                    else{$product_tmp[$id]->model = $res_products[$id]->model;}
                    $product_tmp[$id]->product_id = intval($id);
                    $product_tmp[$id]->price = (string)round($product->price/$currency->rate_to,2);
                    $product_tmp[$id]->category_id = $res_products[$id]->category_id;
                    $product_tmp[$id]->category = ($_COOKIE['language'] == 'eng') ? $res_products[$id]->eng_single_name : $res_products[$id]->category;
                    $product_tmp[$id]->brand_id = $res_products[$id]->brand_id;
                    $product_tmp[$id]->brand = '';
                    $product_tmp[$id]->large_image = $image_link . '/reimg/files/products/340x/'.$large_image;
                    $product_tmp[$id]->large_image_medium = $image_link . '/reimg/files/products/560x/'.$large_image;
                    $product_tmp[$id]->large_image_full = $image_link . '/files/products/'.$large_image;
                    $product_tmp[$id]->size  = $product->size != 'undefined' && strpos($product->size, 'задан') === false && strpos($product->size, 'азмер') === false ? $product->size.'' : '';
                    $product_tmp[$id]->sizes = array();
                    array_push($product_tmp[$id]->sizes,$product_tmp[$id]->size);
                    $product_tmp[$id]->prices = $user->product_prices_for_api($res_products[$id], $_GET['currency']);
                  }
                  else{
                    $size = $product->size != 'undefined' && strpos($product->size, 'задан') === false && strpos($product->size, 'азмер') === false ? $product->size.'' : '';
                    if(!empty($size)) {
                      array_push($product_tmp[$id]->sizes,$size);
                      if(!empty($product_tmp[$id]->size)) $product_tmp[$id]->size .= ', ' . $size;
                      else $product_tmp[$id]->size = $size;
                    }
                    $product_tmp[$id]->price += (string)round($product->price/$currency->rate_to,2);
                    $product_tmp[$id]->price = (string)$product_tmp[$id]->price;
                  }
                }
            }
          }
        }
        if($this->settings->theme_v == 'v2'){
          $return->obj = array_values($product_tmp);
          $return = $this->format_api_response($return);
        }
        else{
          $return->wishlist = array_values($product_tmp);
        }
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    }
    die;
  }

  function api_update_cart() {
    if ( isset($_GET['user_id']) && !empty($_GET['user_id']) && is_numeric($_GET['user_id']) && isset($_GET['p_id']) && !empty($_GET['p_id']) ) {
      $user_id = (int)$_GET['user_id'];
      $delete = isset($_GET['del']) ? true : false;
      $user = new luser($user_id);

      if(is_array($_GET['p_id'])){
        foreach(($_GET['p_id']) as $k=>$s) $products[$k]->sizes = $s;
      }
      else{
        $products[$_GET['p_id']]->size = $_GET['size'];
        $products[$_GET['p_id']]->sizes = $_GET['sizes'];
      }
      $products_tmp = $this->db->results($sql="SELECT product_id,brand_id FROM products WHERE product_id IN (".implode(',',array_keys($products)).") ");
      foreach($products_tmp as $product) $products[(int)$product->product_id]->can_buy_from_site = $user->can_buy_from_site($product->brand_id);
      $fail = array();
      $success = array();
      foreach($products as $product_id=>$product){
        if($product->can_buy_from_site || $delete){
          $size = !empty($product->size) ? preg_split("/,(?!5)/", $product->size) : array(0);
          $sizes = !empty($product->sizes) ? preg_split("/,(?!5)/", trim($product->sizes,'][')) : array(0);
          $sizes = array_unique(array_filter(array_merge($sizes,$size)));
          if(empty($sizes)){$sizes=array(0);}
          foreach($sizes as $k=>$size) $sizes[$k] = trim($size);

          $user_cart = $this->db->results("SELECT * FROM users2carts WHERE user_id = '{$user_id}' ");
          foreach($user_cart as $item) $res_cart[$item->product_id][$item->size] = true;
          foreach($sizes as $size){
            if(!empty($size)) $product_check = isset($res_cart[$product_id][$size]);
            else $product_check = isset($res_cart[$product_id]);
            if($delete === true){
              if (empty($product_check)) {array_push($fail,$size);}
              else{
                if(!empty($size))unset($res_cart[$product_id][$size]);
                else unset($res_cart[$product_id]);
                array_push($success,$size);
              }
            }else{
              if (empty($product_check)) {
                if(!empty($size)) $res_cart[$product_id][$size] = true;
                else $res_cart[$product_id][''] = true;
                array_push($success,$size);
              }
              else{array_push($fail,$size);}
            }
          }
          $user->save_cart($user_id, $res_cart);
          if(count($success) > 0) $return->success = true;
          else $return->success = false;
          if($_COOKIE['language'] == 'eng') $t = (count($success) > 1) ? 's' : '';
          else $t = (count($success) > 1) ? 'ы' : '';
          if($delete === true){
            if($return->success === true){
              if($_COOKIE['language'] == 'eng') $return->message = "You had successfully removed product{$t} from cart";
              else $return->message = "Вы успешно удалили товар{$t} из корзины";
            }
            else{
              if($_COOKIE['language'] == 'eng') $return->message = "No such product{$t} in cart";
              else {
                $t = (count($success) > 1) ? 'такого товара' : 'таких товаров';
                $return->message = "В корзине нет {$t}";
              }
            }
          }else{
            if($return->success === true){
              if($_COOKIE['language'] == 'eng') $return->message = "Product{$t} in cart";
              else $return->message = "Товар{$t} в корзине";
            }
            else{
              if($_COOKIE['language'] == 'eng') $return->message = "This product{$t} is already in cart";
              else {
                $t = (count($success) > 1) ? 'Такой товар' : 'Такие товары';
                $return->message = "{$t} уже есть в корзине";
              }
            }
          }
        }
        else{
          $return->success = false;
          $return->message = $_COOKIE['language'] == 'eng' ? "This product can't be plaсed in cart" : 'Этот товар нельзя положить в корзину';
        }
      }
    }
    else{
      $return->success = false;
      if(!isset($_GET['user_id']) || empty($_GET['user_id']) || !is_numeric($_GET['user_id'])){
        $return->message = "invalid user id";
      }
      if(!isset($_GET['p_id']) || empty($_GET['p_id']) || (!is_numeric($_GET['p_id']) && !is_array($_GET['p_id']))){
        $return->message = "invalid product id";
      }
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die;
  }

  function get_keys() {
    if ( isset($_GET['user_id']) && !empty($_GET['user_id']) && is_numeric($_GET['user_id']) ) {
        $user = new luser();
        $user_id = $_GET['user_id'];
        $keys = $user->get_keys($user_id);
        $i=0;
        if (is_array($keys) && count($keys)) {
            foreach ($keys as $user) {
                $return->keys[$i]->name = $user->name;
                $return->keys[$i]->network = '';
                $return->keys[$i]->card_number = '';
                if ( !empty($user->network) ) {
                    $return->keys[$i]->network = $user->network;
                }
                if ( !empty($user->card_number) ) {
                    $return->keys[$i]->card_number = $user->card_number;
                }
                $i++;
            }
        }
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    }
    die;
  }

  function get_networks() {
        $return->networks = $this->db->results("SELECT name, keyword, app_keys FROM `networks` WHERE active = 1 ");
        foreach($return->networks as $k=>$network){
          $keys = explode(',',$network->app_keys);
          foreach($keys as $key){
            $network->keys->$key = $this->settings->$key;
          }
          unset($network->app_keys);
        }
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    die;
  }

  function api_get_currencies() {
    if ( $this->settings->theme == 'api') {
      if($_COOKIE['language'] === 'eng')$name = 'eng_name AS name';
      else $name = 'name';
      $return->currencies = $this->db->results("SELECT {$name}, code, rate_to FROM `currencies` ");
      $return = json_encode($return);
      header('Content-Type: application/json');
      echo $return;
    }
    die();
  }

  function api_get_cities() {
    if ( $this->settings->theme == 'api') {
        if ( isset($_GET['delivery_page']) ) {
            $return->cities = $this->db->results("SELECT city_id, name as city_name FROM `cities` WHERE `visible` =1;");
        }
        elseif( isset($_GET['c_search']) && !empty($_GET['c_search']) ){
            $search = mysql_real_escape_string($_GET['c_search']);
            $return->cities = $this->db->results("SELECT city_id, city_name FROM `delivery_cities` WHERE  city_owner_id = '0' AND city_name LIKE '%".$search."%' ORDER BY city_name LIMIT 30;");
        }
        else{
            $where = '';
            if ( isset($_GET['main']) ) {
                $where = ' AND city_is_main = 1 ';
            }
            $return->cities = $this->db->results("SELECT city_id, city_name FROM `delivery_cities` WHERE  city_owner_id = '0' ".$where." ORDER BY city_name;");
        }
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    }
    die();
  }

  function get_all_sizes() {
    if ( $this->settings->theme == 'api') {
        $sizes = array('XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+');
        $return->sizes->topsizes->type_id = 1;
        $return->sizes->topsizes->sizes = $sizes;
        $return->sizes->bottomsizes->type_id = 2;
        $return->sizes->bottomsizes->sizes = $sizes;
        $return->sizes->shoesizes->type_id = 3;
        $return->sizes->shoesizes->sizes = array('35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46');
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    }
    die();
  }

  function get_orders() {
    if ( isset($_GET['user_id']) && !empty($_GET['user_id']) ) {
        $u_id = intval($_GET['user_id']);
        $u_phone = substr($this->db->result("SELECT phone_number FROM users WHERE user_id = '{$u_id}'")->phone_number, -10);
        $status = 'AND status != 3';
        if($_GET['status'] == 'delivery')$status = 'AND status = 6';
        if($_GET['status'] == 'done')$status = 'AND status = 2';
        //Заказы
        $orders = $this->db->results("SELECT order_id, invoice_number, weight, status, delivery_price, delivery_date, agreed_delivery_date, payment_prepaid, date, name, user_id, address, city, country, phone, email, code, manager_id, delivery_company_id FROM orders WHERE user_id = '{$u_id}' {$status} AND cashbox_id = 0 ORDER BY date DESC");
        if(!empty($orders)){
            if($_COOKIE['language'] === 'eng'){$O_statuses = array(0 => 'New',1 => 'Processed',2 => 'Completed',3 => 'Order cancelled',4 => 'Item unavailable',5 => 'Pickup',6 => 'Delivery');}
            else{$O_statuses = array(0 => 'Новый',1 => 'В обработке',2 => 'Выполнен',3 => 'Отмена заказа',4 => 'Товар отсутствует',5 => 'Самовывоз',6 => 'Доставка');}
            $orders_object = array();
            foreach ($orders as $k=>$order) {
                $order->status = $O_statuses[$order->status];
                $total = 0;
                $products = $this->db->results("SELECT p.product_id, p.model, p.price, p.sku, p.category_id, p.brand_id, p.season, p.small_image, p.large_image, op.size AS size, op.status, op.price AS order_price, op.currency, op.currency_rate, b.name AS brand_name, c.eng_single_name
                                                        FROM orders_products op
                                                        LEFT JOIN products p ON p.product_id = op.product_id
                                                        LEFT JOIN brands b ON b.brand_id = p.brand_id
                                                        LEFT JOIN categories c ON c.category_id = p.category_id
                                                        WHERE op.order_id = {$order->order_id}");
                if($_COOKIE['language'] === 'eng'){$product_st = array(  0 => 'Processed', 1 => 'Order cancelled', 4 => 'Returned', 5 => 'Received' );}
                else{$product_st = array(  0 => 'Примерка', 1 => 'Заказ отменен', 4 => 'Оформлен возврат', 5 => 'Получен' );}
                foreach ($products as $key=>$prod) {
                    $products[$key]->status_name = $product_st[$prod->status];
                    if(strpos($prod->size, ')') !== false){
                      preg_match_all("/\((.*?)\)/",$prod->size,$m);
                      $products[$key]->size = $m[1][0];
                    }
                    if($_COOKIE['language'] === 'eng'){$products[$key]->model = $prod->eng_single_name . ' ' . $prod->brand_name;}
                    if(isset($_GET['currency']) && $_GET['currency'] != $prod->currency){
                      $currency_rate = $this->db->result("SELECT rate_to FROM currencies WHERE code = '".strtoupper($_GET['currency'])."'")->rate_to;
                    }
                    else{$currency_rate = $prod->currency_rate;}
                    $products[$key]->price = (string)round($prod->price/$currency_rate,2);
                    $products[$key]->order_price = (string)round($prod->order_price/$currency_rate,2);
                    $total += $products[$key]->order_price;
                    $products[$key]->small_image_small = 'https://lsboutique.ru/reimg/files/products/340x/'.$prod->small_image;
                    $products[$key]->large_image_small = 'https://lsboutique.ru/reimg/files/products/340x/'.$prod->large_image;
                    unset($prod->currency_rate,$prod->small_image,$prod->large_image);
                }
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
                $orders_object[$k] = array('order' => $order, 'total' => $total);
                $orders_object[$k]['products'] = $products;
                $orders_object[$k]['count_prod'] = count($products);
            }
        }
        // Заявки в 1 клик
        $ccode = isset($_GET['currency']) ? strtoupper($_GET['currency']) : 'RUB';
        $currency = $this->db->get_row("SELECT * FROM currencies WHERE code = '{$ccode}'");
        if (empty($currency)) $currency = $this->db->get_row("SELECT * FROM currencies WHERE code = 'RUB'");
        $new_orders = $this->db->results("SELECT oc.id, oc.name, oc.phone, oc.email, p.product_id, p.model, p.price, p.sku, p.category_id, p.brand_id, p.season, p.small_image, p.large_image FROM products p LEFT JOIN one_click oc ON oc.product_id = p.product_id WHERE (oc.phone LIKE '%{$u_phone}' OR oc.user_id = {$u_id}) AND oc.enabled = 1");
        foreach ($new_orders as $key=>$prod) {
            $new_orders[$key]->price = (string)round($prod->price/$currency->rate_to,2);
            $new_orders[$key]->small_image_small = 'https://lsboutique.ru/reimg/files/products/340x/'.$prod->small_image;
            $new_orders[$key]->large_image_small = 'https://lsboutique.ru/reimg/files/products/340x/'.$prod->large_image;
        }
        $return->new_orders = $new_orders;
        $return->orders = $orders_object;

        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
    }
    die();
  }
/*
  function special_order() {
        $product = $this->db->result("SELECT products.product_id, categories.parent, products.category_id FROM products LEFT JOIN categories ON products.category_id = categories.category_id  WHERE products.product_id = '{$_GET['product']}' ");
        $this->smarty->assign('product', $product);
        $this->smarty->assign('sizes', array('XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+'));
        $this->smarty->assign('shoesizes', array('35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46'));

        $this->body = $this->smarty->fetch('special_order.tpl');
        echo $this->body;
        die();
    }
*/

  function special_order_save() {
    if ($this->settings->theme == 'api' && empty($_POST['phone_number']) && !empty($_REQUEST['phone_number'])){
        $_POST = $_REQUEST;
    }
    if ( isset($_POST['phone_number']) && (isset($_POST['product_id']) || $_POST['p_id']) ) {
      $user_text = $name = mysql_real_escape_string($_POST['name']);
      $phone = mysql_real_escape_string($_POST['phone_number']);
      $email = !empty($_POST['email']) ? mysql_real_escape_string($_POST['email']) : '';
      $product = $this->settings->theme == 'api' ? (int) $_POST['p_id'] : (int)$_POST['product_id'];
      $size = $this->settings->theme == 'api' ? mysql_real_escape_string($_POST['size']) : mysql_real_escape_string($_POST['product_size']);
      $create_date = date('Y-m-d H:i:s');
      $end_date = date('Y-m-d', strtotime("+6 month"));
      if ( (isset($_SESSION['user']) && $_SESSION['user']->group_id != 5) || (isset($_POST['user_id']) && !empty($_POST['user_id'])) ) {
        $user_id = $this->settings->theme == 'api' ? $_POST['user_id'] : $_SESSION['user']->original_user_id;
        $user       = $this->db->result("SELECT * FROM `users` WHERE user_id = {$user_id} LIMIT 1");
      }
      else{
        $user       = $this->db->result("SELECT * FROM `users` WHERE `phone_number` LIKE '%{$phone}' LIMIT 1");
        if (!empty($user->original_user_id)){
            $user_id = $user->original_user_id;
        }
      }
      if(!empty($user_id)){
        $manager = $this->db->result("SELECT name, slack_name FROM users WHERE user_id = {$user->p_manager_id}");
        $manager_m = !empty($manager->slack_name) ? "<@{$manager->slack_name}>" : '';
        $user_text = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_id}|{$name}> {$manager_m}";
        $us = $this->db->result("SELECT order_id FROM `orders` WHERE `phone` LIKE '%{$phone}' OR user_id = '{$user_id}' LIMIT 1")->order_id;
      }
      else{
        $params = array( 'phone_number' => $phone, 'email' => $email, 'name' => $name, 'shop' => 'Internet');
        $luser = new luser();
        $user  = $luser->found($params);
        $user_id = $user->original_user_id;
      }
      if ( !isset($us) || empty($us) ) {$_SESSION['NEW_USER_ORDER'] = true;}
      $ga_client_id = '';
      $cr_manager = 0;
      if ( isset($_SESSION['user']) && $_SESSION['user']->group_id == 5 ) {//если заказ делает менеджер за клиента
          $cr_manager = $_SESSION['user']->original_user_id;
      }
      if ( !$admin && $cr_manager == 0 ) {$ga_client_id = $this->gaParseCookie();}
      $this->db->query("INSERT INTO `special_orders` (user_id, user_name, user_phone, user_email, product_id, product_size, create_date, end_date, enabled, ga_client_id, cr_manager) VALUES ('{$user_id}', '{$name}', {$phone}, '{$email}', {$product}, '{$size}', '{$create_date}', '{$end_date}', 1, '{$ga_client_id}', '{$cr_manager}' ); ");
      $s_order_id = $this->db->insert_id();
      // Отправляем в слак
      $message = "Оставлена заявка #<https://lsboutique.ru/admin/index.php?section=Special_orders&s_order={$s_order_id}|{$s_order_id}> на товар #<https://lsboutique.ru/products/{$product}/|{$product}> пользователем {$user_text}";
      $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "special_orders" );
      Job::push('SlackJob', $args);

      $message = "Спецзаказ! Оставлена заявка #<https://lsboutique.ru/admin/index.php?section=Special_orders&s_order={$s_order_id}|{$s_order_id}> на товар #<https://lsboutique.ru/products/{$product}/|{$product}> пользователем {$user_text}, телефон {$phone}";
      $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "all_orders" );
      Job::push('SlackJob', $args);

      if(!empty($user_id))luser::save_to_crm( $user_id, 'special_order', "Оставлен спецзаказ <a href='/admin/index.php?section=Special_orders&s_order={$s_order_id}' target='_blank'>#{$s_order_id}</a> на товар <a href='/products/{$product}' target='_blank'>{$product}</a>", '');
      if($this->settings->theme == 'api'){
        if($_COOKIE['language'] == 'eng'){$return->message = "Your order has been received. We will call you back soon.";}
        else{$return->message = "Ваш заказ был получен. Мы вам перезвоним в ближайшее время.";}
      }
      else{
          if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = "Your order has been received.<br>We will call you back soon.";}
          else{$_SESSION['USER_MESSAGE'] = "Ваш заказ был получен.<br>Мы вам перезвоним в ближайшее время.";}
          $_SESSION['special_order'] = $s_order_id;
      }
    }
    if($this->settings->theme == 'api'){
      $return = json_encode($return);
      header('Content-Type: application/json');
      echo $return;
    }
    else{
        $back_url = '/products/'.$_POST['product_id'].'/';
        header("Location: {$back_url}");
    }
    die();
  }

  function save_user($die = true) {
    if ($this->settings->theme == 'api' && empty($_POST['user_id']) && !empty($_REQUEST['user_id'])){
        $_POST = $_REQUEST;
    }
    if ( !empty($_SESSION['user']->user_id) || ($this->settings->theme == 'api' && !empty($_POST['user_id']))) {
        $user_id = $this->settings->theme == 'api' ? $_POST['user_id'] : $_SESSION['user']->user_id;
        if(ctype_digit($_POST['city_id'])){
          $city_id = (int)$_POST['city_id'];
          $_POST['city'] = @$this->db->get_var("SELECT city_name FROM `delivery_cities` WHERE city_id = '{$city_id}' LIMIT 1");
        }
        else{
          $_POST['city'] = $_POST['city_id'];
          $_POST['city_id'] = @$this->db->result("SELECT city_id FROM delivery_cities WHERE city_name = '{$_POST['city']}' LIMIT 1")->city_id;
        }
        if ($this->settings->theme == 'api' && isset($_POST['phone_number'])){
           $_POST['phone_number'] = str_replace(array(' ','-',')','(','+'), '', $_POST['phone_number']);
           if (strlen($_POST['phone_number']) < 10 || strlen($_POST['phone_number']) > 16  || !ctype_digit($_POST['phone_number'])){
              if($_COOKIE['language'] == 'eng'){$m='Data error. Invalid phone number';}
              else{$m = 'Ошибка данных. Неправильный номер телефона';}
              if($this->settings->theme_v == 'v2'){$return->success = false;$return->message = $m;}
              else{$return = $m;}
              $return = json_encode($return);
              header('Content-Type: application/json');
              echo $return;
              exit();
           }
        }
        if ( strlen($_POST['phone_number']) == 10 ) $_POST['phone_number'] = '7' . $_POST['phone_number'];
        if($_POST['alt_phone']){
          foreach($_POST['alt_phone'] as $k=>$ap){
            if ( strlen($ap) == 10 ) $_POST['alt_phone'][$k] = '7' . $ap;
          }
        }
        $params = array(    'phone_number'  => isset($_POST['phone_number']) ? $_POST['phone_number'] : '',
                            'email'         => isset($_POST['email'])        ? $_POST['email'] : '',
                            'city'          => isset($_POST['city'])         ? $_POST['city'] : '',
                            'name'          => isset($_POST['name'])         ? $_POST['name'] : '',
                            'city_id'       => isset($_POST['city_id'])      ? $_POST['city_id'] : '',
                            'sex'           => isset($_POST['sex'])          ? $_POST['sex'] : '',
                            'adress'        => isset($_POST['address'])      ? $_POST['address'] : '',
                            'p_manager_id'  => isset($_POST['p_manager_id']) ? $_POST['p_manager_id'] : '',
                            'alt_phones'    => isset($_POST['alt_phone'])    ? implode('|',array_filter($_POST['alt_phone'])) : '',
                            'alt_addresses' => isset($_POST['alt_address'])  ? implode('|',array_filter($_POST['alt_address'])) : '',
                            );
        //var_dump($params);
        $user_t = $this->db->get_row("SELECT * FROM `users` WHERE user_id = {$user_id}")->user_id;
        if (!empty($user_t)){
            $user = new luser();
            $user->update_user( $user_id, $params, true );
            if ($this->settings->theme == 'api') {
                if($this->settings->theme_v == 'v2'){$return->success = true;}
                $return->user = $user->api_user_data($user_id);
            }
            else{
                $_SESSION['user'] = $this->db->result(sql_placeholder('SELECT * FROM users WHERE user_id=? LIMIT 1', $_SESSION['user']->user_id));
                setcookie('sex', $_POST['sex'], time()+60*60*24*365, '/');
            }
        }
        else{
          if($_COOKIE['language'] == 'eng'){$m='No such user exists.';}
          else{$m = 'Такого пользователя не существует.';}
          if($this->settings->theme_v == 'v2'){$return->success = false;$return->message = $m;}
          else{$return = $m;}
        }
    }
    else{
        if ($this->settings->theme == 'api') {
          if($_COOKIE['language'] == 'eng'){$m='No user id.';}
          else{$m = 'Отсутствует id пользователя';}
            if($this->settings->theme_v == 'v2'){$return->success = false;$return->message = $m;}
            else{$return = $m;}
        }
    }
    if ($die) {
        if ($this->settings->theme == 'api') {
      if($this->settings->theme_v == 'v2'){
        $r->obj[0] = $return;
        $return = $this->format_api_response($r);
      }
            $return = json_encode($return);
      header('Content-Type: application/json');
            echo $return;
        }
        else{
            header("Location: /personal_data/");
        }
    exit();
    }
  }



  function save_data() {
    if ( !empty($_SESSION['user']->user_id) && !empty($_COOKIE['checkbox']) ) {
        $saved_data = serialize($_COOKIE['checkbox']);
        $this->db->query(" UPDATE users SET saved_data = '{$saved_data}' WHERE user_id = '{$_SESSION['user']->user_id}' ");
        die('ok');
    }
    die('fail');
  }



  function user_mail_add() {
    $this->smarty->assign('server_name',$_SERVER['HTTP_HOST']);
    $this->body = $this->smarty->fetch('user_mail_add.tpl');
    echo $this->body;
    die();
  }



  function soc_add() {
    $this->smarty->assign('server_name',$_SERVER['HTTP_HOST']);
    $this->body = $this->smarty->fetch('soc_add.tpl');
    echo $this->body;
    die();
  }



  function vk_auth() {
    $this->db->query("SELECT * FROM `groups` WHERE group_id = 1");
    $group_info = $this->db->result();
    $this->smarty->assign('group_info', $group_info);
    $this->smarty->assign('vk_app_id',  $this->config->vk_app_id);
    $this->smarty->assign('server_name',$_SERVER['HTTP_HOST']);
    $this->body = $this->smarty->fetch('vk_auth.tpl');
    if ($this->settings->theme == 'mobile') {
        return $this->body;
    }
    else {
        echo $this->body;
        die();
    }
  }

  function otp_auth() {
    $this->body = $this->smarty->fetch('otp_auth.tpl');
    return $this->body;
  }

  function otll_auth() {
    $this->body = $this->smarty->fetch('otll_auth.tpl');
    return $this->body;
  }


   function self_register() {
    $this->db->query("SELECT * FROM `groups` WHERE group_id = 1");
    $group_info = $this->db->result();
    $this->smarty->assign('group_info', $group_info);
    $this->smarty->assign('vk_app_id',  $this->config->vk_app_id);
    $this->smarty->assign('server_name',$_SERVER['HTTP_HOST']);
    $this->body = $this->smarty->fetch('self_register.tpl');
    echo $this->body;
    die();
  }



  function personal_data() {

	//если нажали 'все' в переключателе пола
	if(isset($_GET['allsex'])) {
		setcookie('sex', '0', time()+60*60*24*365, '/');
		$_COOKIE['sex'] = 0;
	}
	$mw = $_GET['sex'] ? (int)$this->url_filtered_param('sex') : $_COOKIE['sex'];

    $user = new luser();
    $keys = $user->get_keys($_SESSION['user']->user_id);
    $str = '';
    if (is_array($keys) && count($keys)) {
        foreach ($keys as $user) {
            $str .= '<div style="float: left; width: 100%; margin: 0 0 12px 0;">';
            if ( !empty($user->network) ) {
              if($_COOKIE['language'] === 'eng'){$str .= "The account {$user->name} from {$user->network}";}
              else{$str .= "Аккаунт {$user->name} из {$user->network}";}
            }
            else{
				if($_COOKIE['language'] === 'eng'){$str .= "The account {$user->name}";}
				else{$str .= "Аккаунт {$user->name}";}
			}
            if ( !empty($user->card_number) ) {
              if($_COOKIE['language'] === 'eng'){$str .= " uses the personal card of Luxury Store №{$user->card_number}";}
              else{$str .= " использует персональную карту №{$user->card_number}";}
            }
            if($user->user_id != $user->original_user_id){
              if($_COOKIE['language'] === 'eng'){$str .= '<span style="margin-left: 12px;"><a href="/login/unlink_acc/' . $user->user_id . '/" title="unlink account" alt="unlink account"><i class="icon-close"></i></a></span></div>';}
              else{$str .= '<span style="margin-left: 12px;"><a href="/login/unlink_acc/' . $user->user_id . '/" title="отсоединить аккаунт" alt="отсоединить аккаунт"><i class="icon-close"></i></a></span></div>';}
            }
            else{$str .= '</div>';}
        }
    }
    // показывать скрытые бренды только избранным
    $brands_str = implode(",", luser::visible_brands($_SESSION['user']->user_id));
    $squery .= " AND brand_id IN ({$brands_str}) ";
    // определить бренды
    $this->smarty->assign('brands', $this->db->results("SELECT * FROM `brands` WHERE show_on_brandwall=1 {$squery} ORDER BY name ASC;"));
    $subscriptions = $this->db->results($sql = "SELECT * FROM users2brands WHERE user_id = '{$_SESSION['user']->user_id}' AND status = '1';");
    $user = $this->db->get_row($sql = "SELECT * FROM users WHERE user_id = '{$_SESSION['user']->user_id}';");
    $user->alt_phones = explode('|',$user->alt_phones);
    $user->alt_addresses = explode('|',$user->alt_addresses);
    $subscribed_brands[] = array();
    foreach ($subscriptions as $sub) {
        $subscribed_brands[] = $sub->brand_id;
    }
    $this->smarty->assign('subscribed_brands', $subscribed_brands);
    $this->smarty->assign('stop_sms', $user->stop_sms);

    // определить размеры
        $size_types = $this->db->results($sql = "SELECT * FROM size_types LEFT JOIN sizes ON sizes.size_type = size_types.type_id WHERE 1;");

        foreach($size_types as $size){
            $i=0;
            if($_COOKIE['language'] === 'eng'){$all_sizes[$size->type_id]->name = str_replace(array("Men`s", "Women`s"), "", $size->eng_name);}
            else{$all_sizes[$size->type_id]->name = str_replace(array("Мужская", "Женская", "Мужские", "Мужское", "Женские", "Женское"), "", $size->type_name);}

            $all_sizes[$size->type_id]->sizes[$size->size_id]->id = $size->size_id;
/*
            if (!empty($size->ru_size)){
                if (!in_array('Россия (RU)',$all_sizes[$size->type_id]->sizes[0]->values)){
                  if($_COOKIE['language'] === 'eng'){$all_sizes[$size->type_id]->sizes[0]->values[$i] = 'Russia (RU)';}
                  else{$all_sizes[$size->type_id]->sizes[0]->values[$i] = 'Россия (RU)';}
                }
                $all_sizes[$size->type_id]->sizes[$size->size_id]->values[$i] = $size->ru_size;
                $i++;
            }
*/
            if (!empty($size->int_size)){
                if (!in_array('Между<br>народный<br>(INT)',$all_sizes[$size->type_id]->sizes[0]->values)){
                  if($_COOKIE['language'] === 'eng'){$all_sizes[$size->type_id]->sizes[0]->values[$i] = 'Inter<br>national<br>(INT)';}
                  else{$all_sizes[$size->type_id]->sizes[0]->values[$i] = 'Между<br>народный<br>(INT)';}
                }
                $all_sizes[$size->type_id]->sizes[$size->size_id]->values[$i] = $size->int_size;
                $i++;
            }
            $sizes_add = $this->db->results($sql = "SELECT * FROM size_names WHERE size_id = {$size->size_id};");
            foreach($sizes_add as $sa){
                if (!in_array($sa->size_m_s,$all_sizes[$size->type_id]->sizes[0]->values)){
                  if($_COOKIE['language'] === 'eng'){$all_sizes[$size->type_id]->sizes[0]->values[$i] = $sa->eng_size_m_s;}
                  else{$all_sizes[$size->type_id]->sizes[0]->values[$i] = $sa->size_m_s;}
                }
                $all_sizes[$size->type_id]->sizes[$size->size_id]->values[$i] = $sa->size;
                $i++;
            }
            asort($all_sizes[$size->type_id]->sizes);
        }
        $this->smarty->assign('sizes',  $all_sizes );

    // определить размеры пользователя
    $user_sizes = $this->db->results($sql = "SELECT * FROM users2sizes_n WHERE `user_id` = '{$_SESSION['user']->user_id}';");
    $user_sizes_res[] = array();
    foreach ($user_sizes as $size) {
        $user_sizes_res[] = $size->size_id;
    }
    $this->smarty->assign('user_sizes', $user_sizes_res);

    // определить услуги пользователя
    $date_lim = date('Y-m-d', strtotime('2017-11-20 00:00:00'));
    $keys = $this->db->results("SELECT user_id FROM users WHERE original_user_id = {$_SESSION['user']->original_user_id}");
    foreach ($keys as $k) {$keys_arr[] = $k->user_id;}
    $keys = implode(',',$keys_arr);

    $services_done = $this->db->results("SELECT so.*
                                        FROM services_orders so
                                        LEFT JOIN orders o ON o.order_id = so.real_order_id
                                        LEFT JOIN users u ON u.user_id = so.client_id
                                        LEFT JOIN services_orders_items soi ON soi.order_id = so.id
                                        WHERE  so.client_id IN ({$keys}) AND soi.status = 'Выдано клиенту' GROUP BY so.id ORDER BY date DESC");

    $services_work = $this->db->results("SELECT so.*
                                        FROM services_orders so
                                        LEFT JOIN orders o ON o.order_id = so.real_order_id
                                        LEFT JOIN users u ON u.user_id = so.client_id
                                        LEFT JOIN services_orders_items soi ON soi.order_id = so.id
                                        WHERE  so.client_id IN ({$keys}) AND soi.status != 'Выдано клиенту' AND so.date >= '{$date_lim}' GROUP BY so.id ORDER BY date DESC");

    foreach ($services_done as $i => $service) {
        $service->date = $this->rus_date("j F", strtotime($service->date));
        $service->items = $this->db->results("SELECT st.name, st.eng_name, soi.price, soi.status, soi.status_eng, soi.product_name, soi.defect_description FROM services_orders_items soi LEFT JOIN service_types st ON st.id = soi.service_type_id LEFT JOIN services_orders so ON soi.order_id = so.id WHERE soi.order_id = {$service->id} AND soi.status LIKE 'Выдано клиенту'");
    }
    foreach ($services_work as $i => $service) {
        $service->date = $this->rus_date("j F", strtotime($service->date));
        $service->items = $this->db->results("SELECT st.name, st.eng_name, soi.price, soi.status, soi.status_eng, soi.product_name, soi.defect_description FROM services_orders_items soi LEFT JOIN service_types st ON st.id = soi.service_type_id LEFT JOIN services_orders so ON soi.order_id = so.id WHERE soi.order_id = {$service->id} AND soi.status != 'Выдано клиенту' AND so.date >= '{$date_lim}'");
    }

    if($user->p_manager_id){
        $user->p_manager = $this->db->results("SELECT name, phone_number, email, photo, wh.start, wh.end FROM `users` u LEFT JOIN work_hours wh ON wh.user_id = u.user_id AND wh.date = DATE(NOW()) WHERE u.user_id = '{$user->p_manager_id}'");
    }

    $this->smarty->assign('services_done', $services_done);
    $this->smarty->assign('services_work_count', count($services_work));
    $this->smarty->assign('services_work', $services_work);

    $this->smarty->assign('user',           $user);
    $this->smarty->assign('social',         $str);
    $this->smarty->assign('server_name',    $_SERVER['HTTP_HOST']);
    $this->smarty->assign('delivery_cities_main', $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;"));
    $this->smarty->assign('delivery_cities',      $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '0' ORDER BY city_name;"));
    $this->smarty->assign('managers',             $this->db->results("SELECT * FROM users WHERE group_id = 5 AND subgroup_id IN (1) ORDER BY name DESC"));

    $this->smarty->assign('title',       ($_COOKIE['language'] == 'eng') ? 'User profile' : 'Профиль пользователя');
    $this->smarty->assign('keywords',    'Профиль пользователя');
    $this->smarty->assign('description', 'Профиль пользователя');

	$this->smarty->assign('manOrWoman', $mw);
	$this->smarty->assign('filter_url', '/personal_data/?');
    return $this->body = $this->smarty->fetch('personal_data.tpl');
  }

  function get_managers() {
    $return->managers = $this->db->results("SELECT original_user_id, email, name, photo, phone_number, pref_messenger as messengers FROM users WHERE group_id = 5 AND subgroup_id IN (1) ORDER BY name DESC");
    foreach ( $return->managers as $manager) {
      $manager->messengers = $this->db->results("SELECT * FROM messengers WHERE `id` IN ({$manager->messengers});");
      if(empty($manager->messengers))$manager->messengers = null;
      $work_hours = $this->db->result("SELECT * FROM work_hours WHERE `user_id` = {$manager->original_user_id} ORDER BY date LIMIT 1;");
      if(!empty($work_hours)){
        if($work_hours->date == date('Y-m-d')) $date = ($_COOKIE['language'] == 'eng') ? 'Today' : 'Сегодня';
        elseif($work_hours->date == date('Y-m-d',strtotime('+1 day'))) $date = ($_COOKIE['language'] == 'eng') ? 'Tomorrow' : 'Завтра';
        else  $date = ($_COOKIE['language'] == 'eng') ? date("j F", strtotime($work_hours->date)) : $this->rus_date("j F", strtotime($work_hours->date));;
        $manager->work_hours = $date . ' c ' . $work_hours->start . ' до ' . $work_hours->end;
      }
      else{$manager->work_hours = null;}
      foreach($manager->messengers as $m)$m->icon = 'https://lsboutique.ru/admin/images/icons/' . $m->icon;
      if(strpos($manager->photo, 'http') === false) $manager->photo = 'https://lsboutique.ru/' . ($manager->photo ? $manager->photo : '/images/empty_photo.png');
    }
    $return = json_encode($return);
    header('Content-Type: application/json');
    echo $return;
    die('');
  }



    function one_click() {
        $this->smarty->assign('phone_number', isset($_COOKIE['SAVED_PHONE_NUMBER']) ? $_COOKIE['SAVED_PHONE_NUMBER'] : '+7');
        $this->smarty->assign('product_id',    $_GET['oneclick_product']);
        $this->smarty->assign('product_price', $_GET['price_product']);

        if ($this->settings->theme == 'mobile') {
            $from_page = "one_click_mobile";
        }
        if ($this->settings->theme == 'application') {
            $from_page = "one_click_application";
        }
        else {
            $from_page = "one_click_desktop";
        }

        $product_id = (int)$_GET['oneclick_product'];
        $product = $this->db->result("SELECT p.*, c.name as category, b.name as brand FROM `products` p LEFT JOIN categories c ON c.category_id = p.category_id LEFT JOIN brands b ON b.brand_id = p.brand_id WHERE p.product_id = '{$product_id}' LIMIT 1");
        $this->smarty->assign('product', $product);

        $this->smarty->assign('from_page', $from_page);
        $this->body = $this->smarty->fetch('one_click.tpl');
        if ( isset( $_GET['clear_template'] ) ) {
            echo $this->body; die();
        }
        return $this->body;
    }

    function call_me() {
        $this->smarty->assign('phone_number', isset($_COOKIE['SAVED_PHONE_NUMBER']) ? $_COOKIE['SAVED_PHONE_NUMBER'] : '+7');
        $this->smarty->assign('product_id', $_GET['oneclick_product']);
        $this->smarty->assign('from_page', "call_me_mobile");
        $this->body = $this->smarty->fetch('call_me.tpl');
        return $this->body;
    }

    function crime_teilor_tickets() {
        $this->smarty->assign('phone_number', isset($_COOKIE['SAVED_PHONE_NUMBER']) ? $_COOKIE['SAVED_PHONE_NUMBER'] : '+7');
        echo $this->smarty->fetch('crime_teilor_tickets.tpl');
        die();
    }

    function card_select() {
        if ( isset($_GET['term']) ) {
            $_GET['term'] = mysql_real_escape_string($_GET['term']);
            $card_numbers = $this->db->results($sql = "SELECT number FROM cards WHERE number LIKE '%{$_GET['term']}%' AND assign='0' ORDER BY number;");

            $numbers[] = array();
            foreach ($card_numbers as $number) {
                $numbers[] = $number->number;
            }
            echo json_encode($numbers);
        }
        die();
    }


    function person_select() {
        if ( isset($_GET['term']) ) {
            $_GET['term'] = mysql_real_escape_string($_GET['term']);
            $users         = $this->db->results($sql = "SELECT DISTINCT name FROM users WHERE enabled = '1' AND (name LIKE '%{$_GET['term']}%') ORDER BY name;");
            $phone_numbers = $this->db->results($sql = "SELECT DISTINCT phone_number FROM users WHERE enabled = '1' AND (phone_number LIKE '%{$_GET['term']}%') ORDER BY phone_number;");
            $emails        = $this->db->results($sql = "SELECT DISTINCT email FROM users WHERE enabled = '1' AND (email LIKE '%{$_GET['term']}%') ORDER BY email;");

            $data[] = array();
            if (is_array($users) && count($users)) {
                foreach ($users as $user) {
                    $data[] = $user->name;
                }
            }
            if (is_array($phone_numbers) && count($phone_numbers)) {
                foreach ($phone_numbers as $phone_number) {
                    $data[] = $phone_number->phone_number;
                }
            }
            if (is_array($emails) && count($emails)) {
                foreach ($emails as $email) {
                    $data[] = $email->email;
                }
            }
            echo json_encode($data);
        }
       die();
    }



    function avatar_change() {
        $this->body = $this->smarty->fetch('avatar_change.tpl');
        echo $this->body;
        die();
    }



    function geo_select() {
        $this->body = $this->smarty->fetch('geo_select.tpl');
        echo $this->body;
        die();
    }



    function client_add() {
        // определить магазины
        $this->smarty->assign('shops', $this->db->results("SELECT * FROM shops WHERE enabled = 1"));
        $this->smarty->assign('default_store', (!empty($_SESSION['user']->store) ? $_SESSION['user']->store : "Internet"));

        // определить размеры
        $this->smarty->assign('top_sizes',     $this->db->results("SELECT ru_size AS size FROM sizes WHERE size_type IN (3,4) GROUP BY size ORDER BY size ASC;") );
        $this->smarty->assign('bottom_sizes',     $this->db->results("SELECT ru_size AS size FROM sizes WHERE size_type IN (5,6) GROUP BY size ORDER BY size ASC;") );
        $this->smarty->assign('shoe_sizes',     $this->db->results("SELECT ru_size AS size FROM sizes WHERE size_type IN (1,2) GROUP BY size ORDER BY size ASC;") );

        // определить менеджеров
        $this->smarty->assign('managers',     $this->db->results("SELECT user_id, name FROM `users` WHERE group_id = 13 AND user_id!=15477 ORDER BY name ASC;") );

        // определить города
        $this->smarty->assign('delivery_cities_main', $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;"));
        $this->smarty->assign('delivery_cities',      $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' ORDER BY city_name;"));

        echo $this->smarty->fetch('client_add.tpl');
        die();
    }



    function client_find() {
        if ( isset($_GET['user_id']) && isset($_GET['send_sms']) ) {
            $users = $this->db->results("SELECT * FROM users WHERE enabled = '1' AND original_user_id = '" . ((int)$_GET['user_id']) . "' AND group_id = 1;");
            if ( !empty($users[0]) ) {
                if($_COOKIE['language'] == 'eng'){$m = "Your link: " . $_SERVER['HTTP_REFERER'] . ". 88003332138.";}
                else{$m = "Ваша ссылка: " . $_SERVER['HTTP_REFERER'] . ". 88003332138.";}
                send_sms_to_phone( $users[0]->phone_number, $m, $users[0]->original_user_id );
                die("Send to: {$users[0]->phone_number}");
            }
            die();
        }
        if ( isset($_GET['search']) && strlen($_GET['search']) > 3 ) {
            $search = mysql_real_escape_string($_GET['search']);
            $users  = $this->db->results($sql = "SELECT * FROM users WHERE enabled = '1' AND user_id = original_user_id AND group_id = 1 AND (phone_number LIKE '%{$search}%' OR name LIKE '%{$search}%' OR email LIKE '%{$search}%' OR order_email LIKE '%{$search}%' OR city LIKE '%{$search}%' OR adress LIKE '%{$search}%' OR card_number LIKE '%{$search}' OR user_id LIKE '{$search}') ORDER BY name;");
            if ( is_array($users) && count($users) )
            foreach ($users as $k=>$v) {
                $users[$k]->phone_length = strlen( $users[$k]->phone_number );
                $users[$k]->sizes_top = $this->db->results("SELECT size FROM users2sizes WHERE `user_id` = '{$users[$k]->user_id}' AND `type_id` = '1';");
                $users[$k]->sizes_bottom = $this->db->results("SELECT size FROM users2sizes WHERE `user_id` = '{$users[$k]->user_id}' AND `type_id` = '2';");
                $users[$k]->sizes_shoes = $this->db->results("SELECT size FROM users2sizes WHERE `user_id` = '{$users[$k]->user_id}' AND `type_id` = '3';");
            }
            $this->smarty->assign('users', $users);
            if (isset($_GET['spec'])){
                $this->smarty->assign('spec', 1);
            }
            if (isset($_GET['add'])){
                $this->smarty->assign('add', 1);
            }
        }
        $this->smarty->assign('back_url', $_SERVER['HTTP_REFERER']);
        echo $this->smarty->fetch('client_find.tpl');
        die();
    }



    function phone_check() {
        if ( isset($_GET['search']) || !empty($_SESSION['user']->user_id) ) {
            $search = mysql_real_escape_string($_GET['search']);
            if (strlen($search) > 9){
                $user   = $this->db->result($sql = "SELECT * FROM users WHERE enabled = '1' AND phone_number LIKE '%{$search}' LIMIT 1;");
                if( !empty($user) ){
                    echo $this->smarty->fetch('one_click_autorization.tpl');
                }
            }
        }
        if ( isset($_GET['send']) ) {
            $user_card  = substr($user->card_number, -5);
            if($_COOKIE['language'] == 'eng'){$m = "Your code: " . $user_card . ". 88003332138.";}
            else{$m = "Ваш код: " . $user_card . ". 88003332138.";}
            send_sms_to_phone( $user->phone_number, $m, $user->original_user_id );
        }
        die();
    }





    function form_order() {
        $this->smarty->assign('weight', $_GET['weight']);
        $this->smarty->assign('total',  $_GET['total']);

        // Сформируем массив способов доставки и тоже в форму заказа
        $query = "SELECT * FROM delivery_methods WHERE enabled ORDER BY delivery_method_id";
        $this->db->query($query);
        $delivery_methods = $this->db->results();
        foreach ($delivery_methods as $k=>$method) {
            $delivery_methods[$k]->final_price = $method->price;
            if ($method->free_from <= $total_price) {
                $delivery_methods[$k]->final_price = 0;
            }
        }
        $this->smarty->assign('delivery_methods', $delivery_methods);

        $query = "SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;";
        $this->db->query($query);
        $delivery_cities_main = $this->db->results();
        $this->smarty->assign('delivery_cities_main', $delivery_cities_main);

        $query = "SELECT * FROM delivery_cities WHERE city_owner_id = '0' ORDER BY city_name;";
        $this->db->query($query);
        $delivery_cities = $this->db->results();
        $this->smarty->assign('delivery_cities', $delivery_cities);

        $this->smarty->assign('group_id', $_SESSION['user']->group_id);

        $this->body = $this->smarty->fetch('order_form.tpl');
        echo $this->body;
        die();
    }



    function man_or_woman() {
        echo $_GET['back'];
        $this->smarty->assign('filter_url', $_SERVER['HTTP_REFERER']);
        $this->body = $this->smarty->fetch('man_or_woman.tpl');
        echo $this->body;
        die();
    }



    function cities_select() {
        $query = " SELECT cities.name, SUBSTR(cities.name,1,1) AS f_letter, cities.city_id, delivery_cities.region_id, cities.url FROM cities
                  LEFT JOIN delivery_cities ON cities.city_id = delivery_cities.city_id
                  WHERE cities.visible = 1  ORDER BY cities.name";
        $delivery_cities = $this->db->results($query);
        $del_cities_sorted = array();
        $frst_l = '';
        $col = round(count($delivery_cities)/4);
        foreach($delivery_cities as $k=>$ds){
          if($frst_l != $ds->f_letter){
            $frst_l = $ds->f_letter;
          }
          $del_cities_sorted[$k/$col][$frst_l][] = $ds;
        }
        file_put_contents('qwertyu',1);
        $this->smarty->assign('big_cities',  array(642,992,1054,893) );
        $this->smarty->assign('del_cities_sorted',  $del_cities_sorted );
        $this->smarty->assign('delivery_cities',    $delivery_cities );
        $this->body = $this->smarty->fetch('cities_select.tpl');
        echo $this->body;
        die();
    }


    // Функция отображения корзины
    function show_cart() {
        $total_price = 0;
        $products = array();

        $user = new luser( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 );
        // Сформируем массив товаров в корзине
        if(isset($_SESSION['user']->original_user_id) && !empty($_SESSION['user']->original_user_id)){
          $user->load_cart($_SESSION['user']->original_user_id);
          $_SESSION['wish_list'] = $user->get_wishlist($_SESSION['user']->original_user_id);
        }
        if (is_array($_SESSION['shopping_cart']) && is_array($_SESSION['shopping_cart_sizes'])) {
          $products = Storefront::get_products(array_keys($_SESSION['shopping_cart']));
          $res_products = array();
          if (!empty($products)) {
            foreach ($products as $k=>$product) {
              if ( is_array($_SESSION['shopping_cart_sizes'][$product->product_id]) && count($_SESSION['shopping_cart_sizes'][$product->product_id]) ) {
                  foreach ($_SESSION['shopping_cart_sizes'][$product->product_id] as $size => $v) {

                    // проверяем наличие данного размера в базе данных
                    $found_item = 1;//$this->db->result("SELECT * FROM `products` WHERE size LIKE '%|".$size."|%' AND product_id = ".$product->product_id);

                    // если товар есть в наличии - показываем его
                    if (!empty($found_item) && count($found_item)==1) {
                        $product = new stdClass(); foreach ($products[$k] as $kk=>$vv) $product->$kk = $vv; $product->amount = 1;

                        $product->prices    = $user->product_prices($product);
                        $product->price     = $product->prices['personal_price'];
                        $product->c_prices  = new stdClass();
                        foreach($this->currencies as $c){
                          if ($c->code == 'rub') continue;
                          $code = 'price_'.$c->code;
                          $product->c_prices->$code = $product->prices['personal_price']/$c->rate_to;
                        }
                        if ( ($product->price - 0.1) > $product->last_price_online ) {
                          $product->with_online_discount = true;
                        }
                        if(strpos(mb_strtolower($product->model), 'боксеры') !== false || strpos(mb_strtolower($product->model), 'трусы') !== false || strpos(mb_strtolower($product->model), 'белье') !== false || strpos(mb_strtolower($product->model), 'купальник') !== false || strpos(mb_strtolower($product->model), 'плавки') !== false){
                          $product->unreturnable = true;
                        }
                        if($_COOKIE['language'] === 'eng'){$product->model = $product->eng_single_name . ' ' . $product->brand;}
                        $total_price       += $product->price*$product->amount;
                        $product->size      = $size != 'undefined' && strpos($size, 'задан') === false && strpos($size, 'азмер') === false ? $size : '';

                        $product->size_data = false;

                        if($product->size)
                            $product->size_data = Storefront::getSizeData($product->size, $product->product_id);

                        $res_products[]     = $product;
                        $visibility_check = $this->db->result("SELECT * FROM products p LEFT JOIN brands b ON p.brand_id = b.brand_id LEFT JOIN categories c ON p.category_id = c.category_id WHERE c.enabled = 1 AND b.visibility <= 1 AND b.offline_only = 0 AND b.hidden = 0 AND p.product_id = ".$product->product_id);
                        if(!empty($visibility_check)){
                          $DL_products[] = $product->product_id;
                        }

                        $weight_tmp = $this->db->result( sql_placeholder("SELECT weight FROM `categories` WHERE category_id=? LIMIT 1", $product->category_id) );
                        $weight += !empty($weight_tmp->weight) ? $weight_tmp->weight : 0;

                        $product->with_online_discount = false;
                    }
                    // в противном случае - удаляем из корзины
                    else {
                        $this->update($product->product_id, 0);
                    }
                  }
              }
            }
          }
        }
        $weight = !empty($weight) ? $weight : 2;
        $this->smarty->assign('products_price',  $total_price);
        $this->smarty->assign('products_weight', $weight);
        // Передаем товары в шаблон
        $this->smarty->assign('DL_products', $DL_products);
        $this->smarty->assign('products', $res_products);

        if ( !empty($_SESSION['user']->phone_number) ||  !empty($_SESSION['user']->user_id) ) {
            // Заявки в 1 клик
            $query      = "SELECT * FROM products p, b.name AS brand_name, c.eng_single_name
                      LEFT JOIN one_click oc ON oc.product_id = p.product_id
                      LEFT JOIN categories c  ON c.category_id = p.category_id
                      LEFT JOIN brands b      ON p.brand_id = b.brand_id
                      WHERE (oc.phone = '{$_SESSION['user']->phone_number}' OR oc.user_id = {$_SESSION['user']->user_id})
                      AND oc.enabled = 1";
            $new_orders = $this->db->results($query);
            $this->smarty->assign('new_orders', $new_orders);
        }

        // Гардероб
        if ( !empty($_SESSION['user']->original_user_id) ) {
            $users = $this->db->results("SELECT user_id FROM users WHERE original_user_id = '{$_SESSION['user']->original_user_id}' ");
            $user_keys = array();
            foreach ($users as $key) {
                $user_keys[] = $key->user_id;
            }
            $user_keys = implode(',', $user_keys);
            $query = "SELECT p.*,
             op.product_id, op.size, op.price, o.order_id, op.status as product_status, o.status as order_status, o.delivery_status as delivery_status, b.name as brand, b.url as brand_url, c.name as category, c.url as category_url, c.image as category_image, b.name AS brand_name, c.eng_single_name
                      FROM `orders_products` op
                      LEFT JOIN orders o    ON op.order_id = o.order_id
                      LEFT JOIN products p  ON op.product_id = p.product_id
                      LEFT JOIN categories c  ON c.category_id = p.category_id
                      LEFT JOIN brands b      ON p.brand_id = b.brand_id
                    WHERE o.user_id IN ({$user_keys}) AND o.status IN ('2','5','6') AND op.status = '5'
                    GROUP BY op.product_id
                    ORDER BY o.order_id DESC";
            $tmp_products = $this->db->results($query);
            $products = array();

            if($_COOKIE['language'] === 'eng'){
              foreach($tmp_products as $key=>$prod){
                $tmp_products[$key]->model = $prod->eng_single_name . ' ' . $prod->brand;
              }
            }

            // Передаем товары в шаблон
            $this->smarty->assign('products_g',         $tmp_products );
            $this->smarty->assign('products_g_count', 1*count($res_products));
        }



        // Все заказы клиента
        if ( !empty($_SESSION['user']->original_user_id) ) {
            $u_id = intval($_SESSION['user']->original_user_id);
            $orders = $this->db->results("SELECT * FROM orders WHERE user_id = '{$u_id}' AND status != 3 AND cashbox_id = 0 AND (EXISTS (SELECT 1 FROM orders_products op WHERE op.order_id = orders.order_id AND op.status = 0)) ORDER BY date DESC");
            $orders_object = array();
            $delivery_st = array(
              0 => 'доставка в ТК',
              1 => 'доставка до города',
              2 => 'вручение',
              3 => 'товар доставлен');
            foreach ($orders as $order) {
                $orders_object[$order->order_id] = array('order' => $order, 'total' => 0);
                $products = $this->db->results("SELECT *, op.size AS size, op.price AS order_price, b.name AS brand_name, c.eng_single_name
                                        FROM orders_products op
                                        LEFT JOIN products p ON p.product_id = op.product_id
                                        LEFT JOIN brands b ON b.brand_id = p.brand_id
                                        LEFT JOIN categories c ON c.category_id = p.category_id
                                        WHERE op.order_id = {$order->order_id}");
                if($_COOKIE['language'] === 'eng'){$product_st = array(  0 => 'Processed', 1 => 'Order cancelled', 4 => 'Returned', 5 => 'Received' );}
                else{$product_st = array(  0 => 'Примерка', 1 => 'Заказ отменен', 4 => 'Оформлен возврат', 5 => 'Получен' );}
                foreach ($products as $key=>$prod) {
                    $products[$key]->status_name = $product_st[$prod->status];
                    if($_COOKIE['language'] === 'eng'){$products[$key]->product_name = $prod->eng_single_name . ' ' . $prod->brand_name;}
                    $orders_object[$order->order_id]['total'] += $prod->order_price;
                }
                $orders_object[$order->order_id]['products'] = $products;
                $orders_object[$order->order_id]['count_prod'] = count($products);
                $order->delivery_company = $this->db->result("SELECT * FROM delivery_companies WHERE id = " . $orders_object[$order->order_id]['order']->delivery_company_id ."");
                $order->delivery_status = $delivery_st[$order->delivery_status];
                $order->manager_id = $orders_object[$order->order_id]['order']->manager_id;
                $order->manager = $this->db->results("SELECT name, phone_number, email, wh.start, wh.end FROM `users` u LEFT JOIN work_hours wh ON wh.user_id = u.user_id AND wh.date = DATE(NOW()) WHERE u.user_id = '{$order->manager_id}'");

				$orders_object[$order->order_id]->with_online_discount = false;
				foreach ($orders_object[$order->order_id]['products'] as $product) {
				  if ( ($product->order_price - 0.1) > $product->last_price_online ) {
					$orders_object[$order->order_id]->with_online_discount = $product->with_online_discount = true;
					$order_price = ($order_paid === true || $product->sku == "testproduct") ? $product->order_price : $product->order_price*0.95;
					$orders_object[$order->order_id]['total_amount_online'] += $order_price;
				  }
				  else {
					$orders_object[$order->order_id]['total_amount_online'] += $product->order_price;
				  }
				  $product->c_prices  = new stdClass();
				  foreach($this->currencies as $c){
					if ($c->code == 'rub') continue;
					$code = 'order_price_'.$c->code;
					$product->c_prices->$code = $product->order_price/$c->rate_to;
				  }
				}
				$sber_on = $this->db->result("SELECT COUNT(enabled) AS t FROM payment_methods WHERE payment_method_id = 15 AND (enabled = 1 OR (enabled = 0 AND block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND block_date != 0))" )->t;
				if($sber_on){
				  $this->db->query("UPDATE payment_methods SET enabled=1, block_date = 0 WHERE payment_method_id = 15" );
				  $this->db->query("UPDATE app_payments SET ad_enabled=1, ios_enabled=1, block_date = 0 WHERE id = 1" );
				  $this->db->query("UPDATE app_payments SET ios_enabled=1, block_date = 0 WHERE id = 3" );
				  $this->db->query("UPDATE app_payments SET ad_enabled=1, block_date = 0 WHERE id = 4" );
				}
				$this->smarty->assign('sber_on', $sber_on);
            }

            $this->smarty->assign('orders', $orders_object);
        }
        $this->smarty->assign('count_orders', (!empty($orders_object) ? count($orders_object) : 0) + (!empty($new_orders) ? count($new_orders) : 0));


        // Сформируем массив товаров в виш листе
        if ( is_array($_SESSION['wish_list']) ) {
          $products = Storefront::get_products(array_keys($_SESSION['wish_list']));
          $res_products = array();
          if (!empty($products)) {
            foreach ($products as $k=>$product) {
              if ( is_array($_SESSION['wish_list'][$product->product_id]) && count($_SESSION['wish_list'][$product->product_id]) ) {
                foreach ($_SESSION['wish_list'][$product->product_id] as $size => $v) {
                    $product = new stdClass(); foreach ($products[$k] as $kk=>$vv) $product->$kk = $vv; $product->amount = 1;

                    $product->prices = $user->product_prices($product);
                    $product->discount_value    = $discount = $user->get_personal_discount($product, $user->get_sum_of_buy( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 ), !empty($_SESSION['group']->discount));
                    $product->size  = $size != 'undefined' && strpos($size, 'задан') === false && strpos($size, 'азмер') === false ? $size : '';
                    $discount       = $user->get_personal_discount($product, $user->get_sum_of_buy( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 ), !empty($_SESSION['group']->discount));
                    $total_price   += $product->price*$product->amount;
                    $res_products[] = $product;
                    $product->can_buy_from_site = $user->can_buy_from_site($product->brand_id);
                    $product->show_price = empty($product->prop_val);

                }
              }
            }
          }
          // Передаем товары в шаблон
          $this->smarty->assign('products_wl',       $res_products);
          $this->smarty->assign('products_wl_count', 1*count($res_products));
        }
        $this->smarty->assign('show_wl',           isset($_GET['show_wl']));
        $this->smarty->assign('show_z',            isset($_GET['show_z']));


        // Передаем общую стоимость в шаблон
        $this->smarty->assign('total_price', $total_price);

        $this->smarty->assign('delivery_cities_main',   $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;"));
        $this->smarty->assign('delivery_cities',        $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' ORDER BY city_name;"));

        // Сформируем массив способов доставки и тоже в шаблон
        $delivery_methods = $this->db->results("SELECT * FROM delivery_methods WHERE enabled ORDER BY delivery_method_id");
        foreach ($delivery_methods as $k=>$method) {
            $delivery_methods[$k]->final_price = $method->price;
            if ($method->free_from <= $total_price) {
                $delivery_methods[$k]->final_price = 0;
            }
        }
        $this->smarty->assign('delivery_methods', $delivery_methods);

        // Передаем параметры заказа по умолчанию.
        // Если постили форму, передаем то что запостили,
        if (isset($_POST['submit_order']) && $_POST['submit_order']==1) {
          $this->smarty->assign('name',     $_POST['name']);
          $this->smarty->assign('email',    $_POST['email']);
          $this->smarty->assign('phone',    $_POST['phone']);
          $this->smarty->assign('address',  $_POST['address']);
          $this->smarty->assign('comment',  $_POST['comment']);
          $this->smarty->assign('delivery_method_id', $_POST['delivery_method_id']);
        }
        // Иначе берем из профиля пользователя
        else {
          if (isset($this->user)) {
            $this->smarty->assign('name', isset($this->user->name)?$this->user->name:'');
            $this->smarty->assign('email', isset($this->user->email)?$this->user->email:'');

            $query = sql_placeholder("SELECT * FROM orders WHERE user_id=? ORDER BY order_id DESC LIMIT 1", $this->user->user_id);
            $this->db->query($query);
            $last_order = $this->db->result();

            $this->smarty->assign('phone',      isset($last_order->phone)   ? $last_order->phone:'');
            $this->smarty->assign('address',    isset($last_order->address) ? $last_order->address:'');
          }
          // Способ доставки установим по умолчанию первым элементом массива
          if (is_array($delivery_methods)) {
            $this->smarty->assign('delivery_method_id', $delivery_methods[0]->delivery_method_id);
          }
        }

        $user = $this->db->get_row($sql = "SELECT * FROM users WHERE user_id = '{$_SESSION['user']->user_id}';");
        $this->smarty->assign('user',      $user);

        //переменная, которая подтверждает, что мы в корзине
        $this->smarty->assign('in_cart', 1);

        $group_info = $this->db->result("SELECT * FROM `groups` WHERE group_id = 1");
        $this->smarty->assign('group_info', $group_info);

        $s_count = $this->db->result("SELECT COUNT(*) AS s_count FROM `users2sizes` WHERE user_id = {$_SESSION['user']->original_user_id}")->s_count;

        if(!isset($_COOKIE['CartNewUser']) && ($s_count < 2)){
            $this->smarty->assign('reminder', 1);
        }
        $this->smarty->assign('server_name',$_SERVER['HTTP_HOST']);

        return $this->body = $this->smarty->fetch('cart.tpl');
    }



    function save_wishlist() {
        if ( !empty($_SESSION['user']->original_user_id) ) {
            $user = new luser();
            $user->save_wishlist($_SESSION['user']->original_user_id, $_SESSION['wish_list']);
        }
    }



    //////////////////////////////////////////
    // Сохранение заказа
    //////////////////////////////////////////
    function save_order() {
        // Создание заказа из админки
        $admin = isset($_POST['order_json'])? 1 : 0;
        if ($admin) {
            $order_json = json_decode($_POST['order_json'], true);
            $client_obj = $order_json['client'];
            $cart_obj   = $order_json['products'];
            $oneclick_products = $order_json['oneclick_products'];
            $prod_array = array_keys($cart_obj);

            $oc_array = array_keys($oneclick_products);
            $oc_array_s = implode(',',$oc_array);

            $user_id = isset($client_obj['user_id'])? $client_obj['user_id'] : '';
            $no_notification = isset($client_obj['no_notification'])? $client_obj['no_notification'] : 0;

            $name    = $client_obj['name'];
            $email   = $client_obj['email'];
            $phone   = $client_obj['phone'];
            $city_id = $client_obj['city_id'];
            $address = $client_obj['address'];
            $admin_comment = $client_obj['comment'];
        }
        else {
            // Параметры заказа
            if ($this->settings->theme == 'api'){
                if ((empty($_POST['phone']) && !empty($_REQUEST['phone'])) || (empty($_POST['user_id']) && !empty($_REQUEST['user_id']))){
                    $_POST = $_REQUEST;
                }
                if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false) $platform = "iOS";
                else $platform = "Android";
                if (isset($_POST['phone'])){$_POST['phone'] = str_replace(array(' ','-',')','(','+'), '', $_POST['phone']);}
                if (isset($_POST['user_id']) && !empty($_POST['user_id'])) {
                    $user_id = (int) $_POST['user_id'];
                    $user_tmp = $this->db->get_row("SELECT * FROM `users` WHERE user_id = '{$user_id}' AND enabled = '1'; ");
                }
                elseif (isset($_POST['phone']) && !empty($_POST['phone'])) {
                    $p=substr($_POST['phone'], -10);
                    if($_COOKIE['language']=='eng'){$p=$_POST['phone'];}
                    $user_tmp = $this->db->get_row("SELECT * FROM `users` WHERE phone_number LIKE '%" . $p . "' AND enabled = '1'; ");
                }
                if (isset($_POST['token']) && !empty($_POST['token'])) {
                    $token = $this->db->get_row("SELECT * FROM `app_sessions` WHERE push_token = '{$_POST['token']}'; ");
                    $platform = $token->platform;
                    if (empty($user_tmp) && !empty($token->user_id)) {
                        $user_tmp = $this->db->get_row("SELECT * FROM `users` WHERE user_id = '{$user_id}' AND enabled = '1'; ");
                    }
                }
                if(empty($user_tmp) && (empty($_POST['phone']) || strlen($_POST['phone']) < 10 || !ctype_digit($_POST['phone']))){
                    $data = print_r($_POST,true);
                    mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - POST log', $data);
                    if($_COOKIE['language'] == 'eng'){$response->message = "An error occurred. Check your authorization data.";}
                    else{$response->message = "Произошла ошибка. Проверьте ваши авторизационные данные.";}
                    if($this->settings->theme_v == 'v2'){
                      $response->success = false;
                      $r->obj[0] = $response;
                      $response = $this->format_api_response($r);
                    }
                    header('Content-Type: application/json');
                    echo json_encode($response);
                    exit();
                }
                if (isset($_POST['platform']) && !empty($_POST['platform'])) {
                    $platform = $_POST['platform'];
                }

            }

            $cr_manager = 0;
            if ( !empty($_SESSION['user']) && $_SESSION['user']->group_id == 5 ) {//если заказ делает менеджер за клиента
                $cr_manager = $_SESSION['user']->original_user_id;
            }

            if (!empty($_POST['name'])) {
                $name = $_POST['name'];
            }
            elseif ($this->settings->theme == 'api') {
                $name = $user_tmp->name;
            }
            elseif (isset($_SESSION['user']->name) && $cr_manager == 0) {
                $name = $_SESSION['user']->name;
            }
            else {
                $name = '';
            }

            $email = isset($email) ? $email : '';
            if (!empty($_POST['email'])) {
                $email = $_POST['email'];
            }
            elseif ($this->settings->theme == 'api' && !empty($user_tmp->email)) {
                $email = $user_tmp->email;
            }
            elseif (isset($_SESSION['user']->email) && $cr_manager == 0) {
                $email = $_SESSION['user']->email;
            }
            else {
                $email = '';
            }

            if (!empty($_POST['phone'])) {
                $phone = $_POST['phone'];
            }
            elseif ($this->settings->theme == 'api') {
                $phone = $user_tmp->phone_number;
            }
            elseif (isset($_SESSION['user']->phone_number) && $cr_manager == 0) {
                $phone = $_SESSION['user']->phone_number;
            }
            else {
                $phone = '';
            }

            if (isset($_SESSION['user']->card_number) && $cr_manager == 0) {
                $user_card_number = $_SESSION['user']->card_number;
            }
            else {
                $user_card_number = '';
            }

            $address = isset($address) ? $address : '';
            if (!empty($_POST['address'])) {
                $address = $_POST['address'];
            }
            elseif ($this->settings->theme == 'api' && !empty($user_tmp->adress)) {
                $address = $user_tmp->adress;
            }
            elseif (isset($_SESSION['user']->adress) && $cr_manager == 0) {
                $address = $_SESSION['user']->adress;
            }
            else {
                $address = '';
            }

            $no_notification = isset($_POST['no_notification']) ? $_POST['no_notification'] : 0;

            $x_region = explode(',', $_SERVER['HTTP_X_REGION']);

            if (!empty($_POST['city_id'])) {
                $city_id = (int)$_POST['city_id'];
            }
            elseif ($this->settings->theme == 'api') {
                $city_id = $user_tmp->city_id;
            }
            elseif (isset($_SESSION['user']->city_id) && $cr_manager == 0) {
                $city_id = $_SESSION['user']->city_id;
            }
            elseif (count($x_region) > 1 && $x_region[1] == '209') {
                $region_id = (int)$x_region[0];
                $city_id = $this->db->result("SELECT * FROM delivery_cities WHERE region_id = '{$region_id}' AND country_id = '209' AND city_is_main = '1' LIMIT 1")->city_id;
            }
            else {
                $city_id = 0;
            }

            if (!isset($city_id) || empty($city_id)) {
                $city_id = 0;
            }
            if (isset($_POST['so_id']) && isset($_POST['products'])) {//если из спецзаказа
                $so_id = $_POST['so_id'];
                $products = $_POST['products'];
            }

        }
        $comment = isset($_POST['comment'])? $_POST['comment'] : '';

        if ( strlen($phone) == 10 ) {
            $phone = '8' . $phone;
        }

        if ($city_id) {
            $delivery_info = $this->db->get_row("SELECT * FROM `delivery_cities` WHERE city_id = '{$city_id}' LIMIT 1");
            $_POST['city'] = $delivery_info->city_name;
        }
        if (!$delivery_info) {
            $delivery_info->city_name    = '';
            $delivery_info->region_name  = '';
            $delivery_info->country_name = '';
        }


        // Если залогинены, добавим пользователя в заказ
        // Если не залогинены - просто добавляем пользователя
        $user   = new luser();
        $params = array( 'phone_number' => $phone, 'email' => $email, 'city' => $delivery_info->city_name, 'city_id' => $city_id, 'adress' => $address, 'name' => $name, 'shop' => 'Internet');

        if ($this->settings->theme == 'api') {
            $user_id = $user_tmp->original_user_id;
        }
        elseif ( !$admin && $cr_manager == 0 ) {
            $user_id = $_SESSION['user']->original_user_id;
        }

        if ( !empty($user_id) ) {
            $user->update_user( $user_id, $params );
            $user       = $this->db->result("SELECT * FROM `users` WHERE `original_user_id` = '{$user_id}'");
            $user_id    = $user->original_user_id;
            $deposit    = $user->deposit;
        }
        else {
            $user_id    = $user->found($params)->original_user_id;
            $name       = $user->found($params)->name;
            $new_user   = true;
        }
        $name = trim($name);

        $check       = $this->db->result("SELECT order_id FROM `orders` WHERE `phone` LIKE '%{$phone}' OR user_id = '{$user_id}' LIMIT 1")->order_id;
        if ( empty($check) ) {
            $_SESSION['NEW_USER_ORDER'] = true;
        }

        $coupon_type = '';
        $coupon_discount = 0;
        //Если нам запостили купон
        $coupon_code = trim($_POST['coupon_code']);
        $this->smarty->assign('coupon_code', $coupon_code);
        if(!empty($coupon_code)){
            $query = sql_placeholder("SELECT * FROM coupons WHERE code=?", $coupon_code);
            $this->db->query($query);
            $coupon = $this->db->result();
            if($coupon){
                if(strtotime($coupon->date_start) <= time() AND strtotime($coupon->date_finish) >= time()) {
                    $coupon_discount = $coupon->value;
                    $coupon_code = $coupon->code;
                    $coupon_type = $coupon->type;

                    $query = sql_placeholder("UPDATE coupons SET num_uses = num_uses + 1 WHERE id=?", $coupon->id);
                    $this->db->query($query);
                }
            }
        }

        // Генерируем уникальный код заказа, по которому пользователь сможет посмотреть заказ
        $code = md5(uniqid('', true));
        $ga_client_id = '';
        $ip = isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : $_SERVER['REMOTE_ADDR'];
        $cr_manager = isset($cr_manager) ? $cr_manager : 0;
        if ( !$admin && $cr_manager == 0 ) {$ga_client_id = $this->gaParseCookie();}
        // Формируем запрос на добавление заказа
        $sql = sql_placeholder("INSERT INTO orders(delivery_method_id, date, user_id, name, email, address, city, city_id, region, country, phone, user_comment, status, code, ip, coupon_discount, coupon_code, coupon_type, cr_manager, ga_client_id)
                                                      VALUES(1, NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, ?, ?, ?, ?)",
                                                      $user_id, $name, $email, $address, $delivery_info->city_name, $city_id, $delivery_info->region_name, $delivery_info->country_name,
                                                      $phone, $comment, $code, $ip, $coupon_discount, $coupon_code, $coupon_type, $cr_manager, $ga_client_id);

        $this->db->query($sql);
        $order_id = $this->db->insert_id();


        if ($admin) {
            // нужно отметить товары в заказе как не новый товар
            $new_order = 0;
            // сохранить комментарий администратора
            if ($admin_comment) {
                $ac_q = sql_placeholder("INSERT INTO order_comments(user_id, order_id, text, date) VALUES (?,?,?,NOW())", $user_id, $order_id, $admin_comment);
                $this->db->query( $ac_q );
            }
        }

        if ( empty($order_id) ) {
            mail('shesternin@gmail.com, sonicdes@gmail.com, tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - WRONG REQUEST', $sql);
            if ($this->settings->theme == 'api') {
                $data = print_r($_POST,true);
                mail('shesternin@gmail.com, tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - POST api_error_log', $data);

                if($_COOKIE['language'] == 'eng'){$response->message = "Sorry, something went wrong. Please try again.";}
                else{$response->message = "Извините, что-то пошло не так. Пожалуйста попробуйте повторить ваше действие.";}
                if($this->settings->theme_v == 'v2'){
                  $response->success = false;
                  $r->obj[0] = $response;
                  $response = $this->format_api_response($r);
                }
                header('Content-Type: application/json');
                echo json_encode($response);
            }
            else{
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = "Sorry, something went wrong. Please try again.";}
                else{$_SESSION['USER_MESSAGE'] = 'Извините, что-то пошло не так. Пожалуйста попробуйте повторить ваше действие.';}
                header("Location: /cart/");
            }
            exit();
        } else {
            luser::save_to_crm( $user_id, 'order', "Оформлен новый заказ №<a href='/admin/index.php?section=Order&order_id={$order_id}' target='_blank'>{$order_id}</a>", '');
        }

        // Генерируем баркод
        $this->db->query("UPDATE orders SET barcode = '" . orders::gen_barcode4order($order_id) . "' WHERE order_id = '{$order_id}';");

        // Добавим все товары в базу к этому заказу
        // Попутно вычислим сумму заказа для определения стоимости доставки
        $total_price = $weight = 0;

        if ($admin) {
            $products   = Storefront::get_products( $prod_array );
            $user       = new luser( $user_id );
        }
        elseif (isset($so_id)) {//если из спецзаказа
            $user = new luser( !empty($user->original_user_id) ? $user->original_user_id : 0 );
            $discount = isset($user->discount) ? $user->discount : 0;
            $group_d = $this->db->result($sql = "SELECT discount FROM groups WHERE group_id = '{$user->group_id}';")->discount;
            $productst = array_keys($products);
                foreach ($productst as $k=>$product_id) {
                    $products[$k] = $this->db->result($sql = "SELECT model, product_id, price, item_location, sku FROM products WHERE product_id = '{$product_id}' LIMIT 1;");
                    $products[$k]->discount_value = $discount = $user->get_personal_discount($product, $user->get_sum_of_buy( !empty($user->original_user_id) ? $user->original_user_id : 0 ), !empty($group_d));
                    $products[$k]->size = $this->db->result("SELECT product_size FROM `special_orders` WHERE product_id = '{$product_id}' AND so_id = '{$so_id}'")->product_size;
                    $products[$k]->amount = 1;
                    if ( !empty($discount) ) {
                        $products[$k]->discount_price = floor((100-$discount)*$product->price/100);
                    }
                }
        }
        elseif ($this->settings->theme == 'api') {
            $user = new luser( !empty($user->original_user_id) ? $user->original_user_id : 0 );
            $productst = array_keys($_POST['products']);
            foreach ($productst as $k=>$product_id) {
                $products[$k] = $this->db->result($sql = "SELECT model, url, product_id, price, old_price, offline_price, brand_id, season_type, item_location, sku, large_image, small_image FROM products WHERE product_id = '{$product_id}' LIMIT 1;");
            }
        }
        else {
            if (empty($_SESSION['shopping_cart'])) {
                header("Location: /");
                exit();
            }
            $products   = Storefront::get_products(array_keys($_SESSION['shopping_cart']));
            $user       = new luser( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 );
        }

        // Бренды для подписки
        $sub_brands = [];

        foreach ($products as $k=>$product) {
            unset($_SESSION['wish_list'][$product->product_id]);
            if ($admin) {
                $sizes_ar = $cart_obj[$product->product_id];
            }
            elseif ($this->settings->theme == 'api') {
                $sizes_ar = explode(', ', $_POST['products'][$product->product_id]);
            }
            else {
                $sizes_ar = $_SESSION['shopping_cart_sizes'][$product->product_id];
            }

            // Показывать ли заказанные товары в Новых заказах
            $new_order = (isset($new_order)) ? $new_order : 1;

            // Расчет скидки
            $product->price = $user->personal_product_price($product);
            if ($this->settings->theme == 'api') {
                $product->price = strpos($product->price,'.') !=false ? $product->price .'' : $product->price . '.00';
                if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false) {$product->price_online = $product->price;}
                else{
                  $start_price = $product->old_price != 0 ? $product->old_price : $product->offline_price;
                  if(empty($start_price))$start_price = $product->price;
                  $product->discount_value = round((($start_price-$product->price)*100)/$start_price, 2);
                  $product_max_sale = $this->db->result($sql = "SELECT max_sale FROM sale_settings WHERE brand_id = '{$product->brand_id}' AND season = '{$product->season_type}' LIMIT 1;")->max_sale;
                  $product_min_price = $start_price*((100-$product_max_sale)/100);
                  $product->price_online = (string)($product->price*0.95);
                  if ($product->price_online < $product_min_price)$product->price_online = $product->price;
                }
            }

            // Проверяем подписку
            $subscribtion   = $this->db->result($sql = "SELECT * FROM users2brands WHERE user_id = '{$user_id}' AND brand_id = '{$product->brand_id}' LIMIT 1;");
            if(empty($subscribtion) || ($subscribtion->status != 1)){
                // Подписка клиента на бренд
                $user->subscribe_to_brand( $user_id, $product->brand_id );
                // Отправляем в слак
                $brand   = $this->db->result($sql = "SELECT name FROM brands WHERE brand_id = '{$product->brand_id}' LIMIT 1;")->name;
                $sub_brands[] = $brand;
            }
            // Проверяем магазин
            $shop_subs   = $this->db->result($sql = "SELECT * FROM users2shops WHERE user_id = '{$user_id}' AND shop_id = '7' LIMIT 1;")->id;
            if(empty($shop_subs)){
                $this->db->query("INSERT INTO users2shops (shop_id, user_id) VALUES ('7', {$user_id})");
            }

            if ($admin) {
              $product->currency = $this->db->result("SELECT currency FROM users WHERE user_id = '{$user_id}' LIMIT 1;")->currency;
              $product->currency = !empty($product->currency) ? $product->currency : 'rub';
            }
            if ($this->settings->theme == 'api') {
              $product->currency = (isset($_POST['currency']) && !empty($_POST['currency'])) ? $_POST['currency']: 'rub';
            }
            else{
              $product->currency = isset($_COOKIE['currency']) ? $_COOKIE['currency'] : 'rub';
            }
            $product->currency_rate = $this->db->result("SELECT rate_to FROM currencies WHERE code = '".strtoupper($product->currency)."' LIMIT 1;")->rate_to;
            if (empty($product->currency_rate)) $product->currency_rate = 1.0;
            $currency_rate = $product->currency_rate;

            // Если несколько размеров одного товара
            if ( is_array($sizes_ar) && count($sizes_ar) ) {
              foreach ($sizes_ar as $size => $v) {
                $product = new stdClass();
                foreach ($products[$k] as $kk=>$vv) {
                    $product->$kk = $vv;
                    $product->amount = 1;
                }

                $product->size  = $size != 'undefined' && strpos($size, 'задан') === false && strpos($size, 'азмер') === false ? $size : '';
                if ($this->settings->theme == 'api') {
                    $product->size  = $v != 'undefined' && strpos($v, 'зад') === false && strpos($v, 'азмер') === false ? $v : '';
                }

                  $product->size_data = false;

                if($product->size)
                    $product->size_data = Storefront::getSizeData($product->size, $product->product_id);

                  $product->price = $product->size_data->price  ?: $product->price;

                $total_price   += $product->price*$product->amount;
                $res_products[] = $product;

                $query = sql_placeholder("SELECT weight FROM `categories` WHERE category_id=? LIMIT 1", $product->category_id);
                $this->db->query($query);
                $weight_tmp = $this->db->result();
                $weight += !empty($weight_tmp->weight) ? $weight_tmp->weight : 0;

                $this->db->query(sql_placeholder('INSERT INTO orders_products(order_id, user_id, product_id, product_name, price, currency, currency_rate, quantity, size, item_location, sku, new_order) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                    $order_id, $user_id, $product->product_id, $product->model, $product->price, $product->currency, $product->currency_rate, $product->amount, $product->size, $product->item_location, $product->sku, $new_order));

                if (isset($oneclick_products)) {
                    $oneclick_id = array_search($product->product_id, $oneclick_products);
                    $this->db->query("UPDATE orders_products SET one_click_id = {$oneclick_id} WHERE order_id = {$order_id} AND product_id = {$product->product_id} AND one_click_id=0");
                    unset($oneclick_products[$oneclick_id]);
                }
              }
            }
            else {
                $total_price   += $product->price;
                $this->db->query(sql_placeholder('INSERT INTO orders_products(order_id, user_id, product_id, product_name, price, currency, currency_rate, quantity, size, new_order) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                    $order_id, $user_id, $product->product_id, $product->model, $product->price, $product->currency, $product->currency_rate, $product->amount, $product->size, $new_order));
                if (isset($oneclick_products)) {
                    $oneclick_id = array_search($product->product_id, $oneclick_products);
                    $this->db->query("UPDATE orders_products SET one_click_id = {$oneclick_id} WHERE order_id = {$order_id} AND product_id = {$product->product_id} AND one_click_id=0");
                }
                if(isset($so_id) && !empty($product->model) && !empty($name)){
                $res_products[] = $product;
                    //Отправляем смс пользователю
                    if($_COOKIE['language'] == 'eng'){$message = "Dear {$name}, Your special order for {$product->model} has been completed and will be sent after the last details have been clarified. With any questions you can contact us by phone 8-800-333-21-38";}
                    else{$message = "Уважаемый {$name}, Ваш спецзаказ на {$product->model} был выполнен и будет отправлен после уточнения последних деталей. С любыми вопросами Вы можете обратиться по телефону 8-800-333-21-38";}
                    $args = array( 'user_id' => $user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $phone );
                    Job::push('SmsJob', $args, false, 'critical');
                }
            }
        }

        if (!empty($sub_brands)) {
          $brands_str = implode(", ", $sub_brands);
          $message = "Автоподписка для пользователя <https://lsboutique.ru/admin/index.php?section=User&user_id={$user_id}|{$name}> на обновления брендов: {$brands_str}.";
          $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "autosubscribe" );
          Job::push('SlackJob', $args);
        }
        // Удалим из вишлиста заказанные
        $this->save_wishlist();

        // Расчитаем доставку, вес и страховку
        $weight = $weight ? $weight : 2;
        $delivery_price = 1000;
        if ($city_id) {
            $delivery_price = $this->get_delivery_price($total_price, $weight, $city_id, $real_delivery_price);
            $this->db->query(sql_placeholder("UPDATE orders SET weight=?, delivery_method_id=?, delivery_price=?, real_delivery_price=? WHERE order_id=?", $weight, 1, $delivery_price, $real_delivery_price, $order_id));
        }
        elseif ( $total_price >= 10000 ) {
            $delivery_price = 0;
        }

        if (!isset($_POST['test'])) {
            // Отправляем в слак
            $us = $this->db->result("SELECT user_status, p_manager_id FROM `users` WHERE `user_id` = '{$user_id}'");
            $vip = ($us->user_status == 'VIP' || $total_price >= 1000000) ? ":star: VIP! " : "";
            $manager = $this->db->result("SELECT name, slack_name FROM `users` WHERE `user_id` = '{$us->p_manager_id}'");
            $manager = !empty($manager) ? "персональный менеджер {$manager->name} <@{$manager->slack_name}>" :  "нет персонального менеджера";
            $us = $this->db->result("SELECT order_id FROM `orders` WHERE (`user_id` = '{$user_id}' OR `phone` LIKE '%{$phone}') AND order_id != '{$order_id}' LIMIT 1")->order_id;
            $new = empty($us) ? ":tulip: New! " : "";
            $api = ($this->settings->theme == 'api') ? ':iphone: API!' : '';

            $message = "{$new}{$vip}{$api}Новый заказ №<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>, пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user_id}|{$name}>, телефон {$phone}, {$manager}";
            $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "order" );
            Job::push('SlackJob', $args);
            if ( !$admin && $this->settings->theme != 'api' && !isset($so_id)){
                $message = "Корзина! Новый заказ №<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>, пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user_id}|{$name}>, телефон {$phone}";
                $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "all_orders" );
                Job::push('SlackJob', $args);
                $order_source = 1;

                //Отправляем смс пользователю
                if($_COOKIE['language'] == 'eng'){$message = "Dear {$name}, Your order №{$order_id} has been received, our manager will contact you shortly. With any questions you can contact by phone 8-800-333-21-38";}
                else{$message = "Уважаемый {$name}, Ваш заказ №{$order_id} был получен, наш менеджер свяжется с Вами в ближайшее время. С любыми вопросами Вы можете обратиться по телефону 8-800-333-21-38";}
                $args = array( 'user_id' => $user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $phone );
                Job::push('SmsJob', $args, false, 'critical');
            }
        }


        if ( !$admin && orders::mixmarket_enabled($this->config) ) { // Сохраняем запрос из миксмаркета
            $this->db->query(sql_placeholder("UPDATE orders SET from_mixmarket=1 WHERE order_id=?", 1, $order_id));
        }

        // Сохраняем откуда заказ
        if ( $admin ) {
            $order_source = 2;
            $oc_orders = $this->db->result("SELECT MAX(order_source) AS o_s FROM `one_click` WHERE `id` IN ({$oc_array_s})")->o_s;
            switch($oc_orders){
                case 4: $order_source = 4;break;
                case 3: $order_source = 5;break;
                case 2: $order_source = 6;break;
                case 1: $order_source = 2;break;
            }
        }
        elseif ( isset($so_id) ) {
            $order_source = 3;
        }
        elseif ( $platform == "iOS" ) {
            $order_source = 4;
        }
        elseif ( $platform == "Android" ) {
            $order_source = 5;
        }
        elseif ( $cr_manager != 0 ) {
            $order_source = 6;
        }
        if (isset($order_source)){
            $this->db->query("UPDATE orders SET order_source = {$order_source} WHERE order_id = '{$order_id}'");
        }
        $ua  = $this->db->escape($_SERVER['HTTP_USER_AGENT']);
        if(!empty($ua)){
            $this->db->query("UPDATE orders SET user_agent = '{$ua}' WHERE order_id = '{$order_id}'");
        }
        $ref_source  = $_POST['referrer'];
        if(!empty($ref_source)){
            $this->db->query("UPDATE orders SET ref_source = '{$ref_source}' WHERE order_id = '{$order_id}'");
        }
        $language  = $_COOKIE['language'];
        if(!empty($language)){
            $this->db->query("UPDATE orders SET language = '{$language}' WHERE order_id = '{$order_id}'");
        }

        if ( empty($_SESSION['user']->group_id) || $_SESSION['user']->group_id == 1 ) {
            $_SESSION['ADD_TO_ECOMMERCE'] = 1;
        }

        // добавляем email из учетной записи клиента, если он не был указан
        $this->db->query("UPDATE orders o LEFT JOIN users u ON o.user_id = u.user_id SET o.email = u.email WHERE o.order_id = '{$order_id}' AND o.email = ''");

        // Получаем наш заказ из базы
        // (он у нас и так есть, но для надежности берем из базы)
        $order = Order::get_order_by_code($code);
        $order->products = $res_products;
        $this->smarty->assign('order', $order);

        if($_COOKIE['language'] == 'eng'){$delivery_text = "Shipping will cost " . number_format($delivery_price, 0) . ', ';}
        else{$delivery_text = "Доставка будет стоить " . number_format($delivery_price, 0) . ', ';}
        if ( $delivery_price == 0 ) {
            if($_COOKIE['language'] == 'eng'){$delivery_text = 'The order will be delivered at the store`s expense, ';}
            else{$delivery_text = 'Заказ будет доставлен за счет магазина, ';}
        }
        elseif ( $delivery_price == 1000 ) {
            if($_COOKIE['language'] == 'eng'){$delivery_text = "Preliminarily, shipping will cost " . number_format($delivery_price, 0) . ', ';}
            else{$delivery_text = "Предварительно, доставка будет стоить " . number_format($delivery_price, 0) . ', ';}
        }

        // Письмо пользователю
        if( !empty($email) && !$no_notification && !isset($_POST['test']) && $this->settings->theme != 'api' ) {
            $order_link = $this->settings->theme == 'api' ? 'lsboutique.ru' : $_SERVER['HTTP_HOST'];
            $this->smarty->assign('order_link', $order_link);
            $et = new email_template('order_received');
            $et ->assign('SITE', "https://{$order_link}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('ORDER_ID',        $order->order_id)
                ->assign('ORDER_PRICE',     ($total_price+$delivery_price))
                ->assign('ORDER_LINK',      "https://{$order_link}/order/{$code}")
                ->assign('ORDER_DELIVERY',  $delivery_text)
                ->assign('ORDER_PRODUCTS',  $this->smarty->fetch('email_products.tpl'))
                ->assign('USER_NAME',       $name)
                ->assign('USER_PHONE',      $phone)
                ->assign('USER_EMAIL',      $email)
                ->assign('USER_LOGIN_URL',  !empty($_SESSION['user']->phone_number) && !empty($_SESSION['user']->card_number) ? "<br>Войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$_SESSION['user']->phone_number}&card_number={$_SESSION['user']->card_number}\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\">ссылкой</a><br>" : '')
                ->assign('USER_ADDRESS',    $address)
                ->assign('USER_CITY',       $order->city)
                ->assign('USER_COMMENT',    $comment)
                ->assign('USER_DISCOUNT',   '') //'вы воспользовались персональной скидкой и сэкономили 999р.')
                ->assign('USER_PHONE_NUMBER',   $phone)
                ->assign('USER_CARD_NUMBER',    $user_card_number)
                ->send( $email, $name );
            luser::save_to_crm( $user_id, 'email', 'EMAIL: ' . $et->getMergedField('subject'), $et->getMergedBodyHtml());
        }

        if ($this->settings->theme == 'api') {
            $usr = $this->db->get_row($sql = "SELECT * FROM users WHERE user_id = '{$user_id}' LIMIT 1;");
            $this->smarty->assign('user',      $usr);
        }


        if (!empty($so_id)) {//если из спецзаказа
            $this->db->query("UPDATE `special_orders` SET `order_id`='{$order->order_id}', `enabled`=0 WHERE `so_id` = {$so_id}");
            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }

        unset($_SESSION['shopping_cart']);
        unset($_SESSION['shopping_cart_sizes']);
        $user->clear_cart($user_id);

        if ($admin || $this->settings->theme == 'api') {
            if ($this->settings->theme == 'api') {
                $order->total_amount = 0;
                $order->total_amount_online = 0;
                $order->delivery_price = (string)round($delivery_price/$currency_rate,2);
                foreach($order->products as $product){
                    unset($product->large_image,$product->small_image,$product->url,$product->old_price,$product->offline_price);
                    if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false){
                      $order->total_amount += $product->price;
                      $order->total_amount_online += $product->price_online;
                    }
                    if($product->sku != "testproduct"){
                      $product->price = (string)round($product->price/$product->currency_rate,2);
                      $product->price_online = (string)round($product->price_online/$product->currency_rate,2);
                    }
                    else $order->delivery_price = '0';
                    if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') === false){
                      $order->total_amount += $product->price;
                      $order->total_amount_online += $product->price_online;
                    }
                }
                $order->total_amount = (string)$order->total_amount;
                if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false) $order->total_amount_online = $order->total_amount;
                else $order->total_amount_online = (string)$order->total_amount_online;
                if($this->settings->theme_v == 'v2'){$response->success = true;}
                if($_COOKIE['language'] == 'eng'){$response->message = "Your order № {$order->order_id} has been received. We will call you back soon.";}
                else{$response->message = "Ваш заказ № {$order->order_id} получен. Мы вам перезвоним в ближайшее время.";}
                header('Content-Type: application/json');
                if ($_POST['test'] == 1) {
                    $this->db->query("DELETE FROM orders WHERE order_id={$order->order_id}");
                    $this->db->query("DELETE FROM orders_products WHERE order_id={$order->order_id}");
                    $this->db->query("DELETE FROM order_comments WHERE order_id={$order->order_id}");
                }
            }
            else{
                $response->success = 1;
            }
            $response->order   = $order;

            if($this->settings->theme == 'api' && $this->settings->theme_v == 'v2'){
              $r->obj[0] = $response;
              $response = $this->format_api_response($r);
            }
            echo json_encode($response);
            exit();
        }

        $_SESSION['order_code'] = $code;

        // Если не залогинился, надо залогинить
        if ( empty($_SESSION['user']->user_id) && !empty($user_id) ) {
            $user_group_id = $this->db->result("SELECT group_id FROM users WHERE user_id = {$user_id}")->group_id;
            if ($user_group_id == 1) {
                $user->login($user_id);
            }
        }

        if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = "Your order № {$order->order_id} has been received. We will call you back soon.";}
        else{$_SESSION['USER_MESSAGE'] = "Ваш заказ №{$order->order_id} получен.<br>Мы вам перезвоним в ближайшее время.";}

        header("Location: /order/$code");
        exit();
    }


    //////////////////////////////////////////
    // Функция для обновления товаров в корзине
    // $product_id - id товара
    // $quantity - количество товара
    // $add - флаг, определяющий дополнять количество или изменять
    //////////////////////////////////////////
    function update($product_id, $amount = 1, $add = false, $size = '') {
        if ( $amount == 0 && !$add ) {
            // Если количества товара 0, удаляем его из корзины
            if ($size != ''){
                unset($_SESSION['shopping_cart_sizes'][$product_id][$size]);
            }
            else {
                if(isset($_SESSION['shopping_cart_sizes'][$product_id]["undefined"])){
                    unset($_SESSION['shopping_cart_sizes'][$product_id]["undefined"]);
                }
                if(isset($_SESSION['shopping_cart_sizes'][$product_id][""])){
                    unset($_SESSION['shopping_cart_sizes'][$product_id][""]);
                }
                if(isset($_SESSION['shopping_cart_sizes'][$product_id][0])){
                    unset($_SESSION['shopping_cart_sizes'][$product_id][0]);
                }
            }
            if (empty($_SESSION['shopping_cart_sizes'][$product_id])){
                unset($_SESSION['shopping_cart'][$product_id]);
                unset($_SESSION['shopping_cart_sizes'][$product_id]);
            }
        }
        else {
            if ( !isset($_SESSION['shopping_cart'][$product_id]) ) {
                $_SESSION['shopping_cart'][$product_id]         = 0;
                $_SESSION['shopping_cart_sizes'][$product_id]   = array();
            }
            $_SESSION['shopping_cart'][$product_id]                 += intval($amount);
            $_SESSION['shopping_cart_sizes'][$product_id][$size]     = true;
        }
        if(isset($_SESSION['user']->original_user_id) && !empty($_SESSION['user']->original_user_id)){
            $user = new luser($_SESSION['user']->original_user_id);
            $user->save_cart($_SESSION['user']->original_user_id, $_SESSION['shopping_cart_sizes']);
        }
        $this->smarty->assign('cart_products_num', is_array($_SESSION['shopping_cart']) ? count($_SESSION['shopping_cart']) : 0);
    }

    function delete_from_wl($product_id, $size = '') {
        if ( isset($_SESSION['wish_list'][$product_id]) ) {
            if($size == 'all') {
                unset($_SESSION['wish_list'][$product_id]);
            }
            elseif(!empty($size)){
                unset($_SESSION['wish_list'][$product_id][$size]);
            }
            else {
                if(isset($_SESSION['wish_list'][$product_id]["undefined"])){
                    unset($_SESSION['wish_list'][$product_id]["undefined"]);
                }
                if(isset($_SESSION['wish_list'][$product_id][""])){
                    unset($_SESSION['wish_list'][$product_id][""]);
                }
                if(isset($_SESSION['wish_list'][$product_id][0])){
                    unset($_SESSION['wish_list'][$product_id][0]);
                }
            }
            if (empty($_SESSION['wish_list'][$product_id])){
                unset($_SESSION['wish_list'][$product_id]);
            }
            $this->save_wishlist();
        }
    }



    function import_cities() {
        set_time_limit(0);
        $words = 'QWERTYUIOPASDFGHJKLZXCVBNM';
        for ( $i=0; $i<mb_strlen($words); $i++) {
            $cities = simplexml_load_file('http://www.cpcr.ru/cgi-bin/postxml.pl?GetCityName&CityName=' . mb_substr($words, $i, 1));
            echo "Liter: " . mb_substr($words, $i, 1) . "<br>";
            foreach ($cities->City as $city) {
                $query = sql_placeholder("INSERT INTO `delivery_cities` (`city_id` , `city_owner_id` , `city_name` , `region_id` , `region_owner_id` , `region_name` , `country_id` , `country_owner_id` , `country_name` )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                $city->City_id, $city->city_owner_id, $city->CityName, $city->Region_ID, $city->Region_owner_ID, $city->RegionName, $city->Countries_id, $city->Countries_owner_id, $city->Countries_name);
                echo $city->Countries_name . ' -> ' . $city->City_id . ' -> ' . $city->CityName . '<br>';
                $this->db->query($query);
            }
            echo '<br>';
        }
        $words = 'ЙЦУКЕНГШЩЗХЪЭЖДЛОРПАВЫФЯЧСМИТЬБЮЁ';
        for ( $i=0; $i<mb_strlen($words); $i+=2) {
            $cities = simplexml_load_file('http://www.cpcr.ru/cgi-bin/postxml.pl?GetCityName&CityName=' . mb_substr($words, $i, 2));
            echo "Liter: " . mb_substr($words, $i, 2) . "<br>";
            foreach ($cities->City as $city) {
                $query = sql_placeholder("INSERT INTO `delivery_cities` (`city_id` , `city_owner_id` , `city_name` , `region_id` , `region_owner_id` , `region_name` , `country_id` , `country_owner_id` , `country_name` )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                $city->City_id, $city->city_owner_id, $city->CityName, $city->Region_ID, $city->Region_owner_ID, $city->RegionName, $city->Countries_id, $city->Countries_owner_id, $city->Countries_name);
                echo $city->Countries_name . ' -> ' . $city->City_id . ' -> ' . $city->CityName . '<br>';
                $this->db->query($query);
                echo $query . '<br>';
            }
            echo '<br>';
        }
        die('');
    }



    function get_delivery_price($total_price, $weight, $city_id, &$real_delivery_price = 0) {
        // Вычислим стоимость доставки
        $delivery_price = 1000;
        $total_agent      = 0;
        $agent        = array(0 => 7.32, 1000 => 4.9, 3000 => 3.78, 5000 => 2.83, 8000 => 2.12, 15000 => 1.77, 25000 => 1.53);
        foreach ($agent as $sum=>$percent) if ( $sum <= $total_price) {
            $total_agent = floor($total_price * $percent / 100 + 0.5);
        }
        @$res = simplexml_load_file($request = "http://www.cpcr.ru/cgi-bin/postxml.pl?TARIFFCOMPUTE_2&ToCity={$city_id}|0&FromCity=1054|0&Weight={$weight}&Amount={$total_price}&Nature=2&BeforeSignal=1&PlatType=2&DuesOrder=0");
        if ( !empty($res->Tariff) ) {
            foreach ($res->Tariff as $tariff) {
                $delivery_price = $tariff->Total_Dost + $tariff->Insurance + $total_agent + 82 /*Фиксированный сбор за наложенный платеж*/;
                if ($tariff->TariffType == '"ГЕПАРД-ЭКСПРЕСС"') {
                    break;
                }
            }
        }
        $real_delivery_price = $delivery_price;
        if ($total_price >= 10000) {
            $delivery_price = 0;
        }
        return ceil($delivery_price / 10) * 10;
   }


    function error_message() {
      if($this->settings->theme == 'api'){$_POST = $_REQUEST;}
        if ( !empty($_POST["error_mess"]) ) {
            $em     = $_POST['error_mess'];
            if($this->settings->theme == 'api'){
              $user_id = (int) $_POST['user_id'];
              $user = $this->db->get_row("SELECT name, email, group_id FROM `users` WHERE user_id = '{$user_id}' AND enabled = '1'; ");
              header('Content-Type: application/json');
              if(!ctype_digit($user_id) || !ctype_digit($_POST['p_id']) || !in_array($user->group_id,array(2,5))){
                $return->success = false;
                if(!ctype_digit($user_id) || !in_array($user->group_id,array(2,5))){
                  $return->message = 'Неверные данные пользователя';
                }elseif(!ctype_digit($_POST['p_id'])){$return->message = 'Неверные идентификатор товара';}
                echo (json_encode($return));
                die();
              }
              if (strpos($_POST['error_page'], 'products') !== false || strpos($_POST['error_page'], 'look') !== false){
                $_POST['error_page'] = str_replace('api2.','',$_POST['error_page']);
              }
              if ($em == 'product_aviability_error'){
                $em = 'Товара нет в наличии';
              }
              elseif ($em == 'foto_error'){
                $em = 'Некачественно обработанная фотография';
              }
              elseif ($em == 'description_error'){
                $em = 'Ошибка в описании товара';
              }
              else{
                $return->success = false;
                $return->message = 'Неизвестный тип ошибки';
                echo (json_encode($return));
                die();
              }
            }
            else{
              $user = $_SESSION['user'];
            }
            $product_text = "";
            if ( $em == 'Товара нет в наличии') {
              $product_text = " Товар {$_POST['p_id']}, размер {$_POST['size']}.<br>";
            }
            $message = "
            Привет, %USERNAME%!<br><br><br>

            Ошибка: <b>{$em}</b><br>
            Дополнительный комментарий: <b>{$_POST['comment']}</b><br>{$product_text}
            Произошло на странице: {$_POST['error_page']}<br>
            Модератор: <b>{$user->name}</b><br><br><br>


            Ваш lsboutique.ru
            ";


            // Создаем карточку на Trello
            $args = array( 'error' => $em, 'message' => $message );
            // Resque::enqueue('default', 'TrelloJob', $args);

            $from = "{$user->name} <{$user->email}>";
            if ( $em == 'Ошибка в описании товара' ) {
                $this->email('text@lsboutique.ru, mail@lsboutique.ru', "Модератор {$user->name} сообщает об ошибке", $message, $from);
            } else
            if ( $em == 'Не работает оборудование торговой точки') {
                $this->email('buhall@ls.net.ru, aleris@mail.ru, mail@lsboutique.ru', "Модератор {$user->name} сообщает об ошибке", $message, $from);
            } else
            if ( $em == 'Товара нет в наличии') {
                $this->email('buhall@ls.net.ru, mail@lsboutique.ru', "Модератор {$user->name} сообщает об ошибке", $message, $from);
                $args = array( 'product_id' => $_POST['p_id'], 'size' => $_POST['size'] );
                Job::push( 'ItemMovementJob', $args );
                if($this->settings->theme != 'api'){exit('OK');}
            } else
            if ( $em == 'Ошибка в размерах') {
                $this->email('buhall@ls.net.ru, mail@lsboutique.ru', "Модератор {$user->name} сообщает об ошибке", $message, $from);
            } else
            if ( $em == 'Некачественно обработанная фотография') {
                $this->email('aspius@yandex.ru, redlayne@gmail.com, mail@lsboutique.ru', "Модератор {$user->name} сообщает об ошибке", $message, $from);
            } else { // "Другая ошибка"
                $this->email('mail@lsboutique.ru', "Модератор {$user->name} сообщает об ошибке", $message, $from);
            }
            if($this->settings->theme == 'api'){
              $return->success = true;
              $return->message = 'Сообщение об ошибке отправлено';
              echo (json_encode($return));
              die();
            }
            else{
              header("Location: {$_POST['error_page']}");
            }
            die();
        }
        if($_GET['p_id']){
          $sizes = $this->db->result("SELECT size FROM products WHERE product_id = '{$_GET['p_id']}'");
          $product->sizes = explode('|', trim($sizes->size, '|') );
          $product->product_id = $_GET['p_id'];
          $this->smarty->assign('product', $product);
        }
        $this->smarty->assign('error_page', $_SERVER['HTTP_REFERER']);
        $this->body = $this->smarty->fetch('error_message.tpl');
        echo $this->body;
        die();
    }


    function get_cities($query) {
        $query = mysql_escape_string($query);
        $this->db->query("SELECT * FROM `delivery_cities` WHERE `city_name` LIKE '{$query}%'");
        $res = $this->db->results();
        $out = array('query'=>$query, 'suggestions'=>array(), 'data'=>array());
        if ( is_array($res) && count($res) ) {
            foreach ( $res as $city ) {
                $out['suggestions'][] = $city->city_name;
                $out['data'][]        = $city->city_id;
            }
        }
        echo json_encode($out);
        die();
    }
}
