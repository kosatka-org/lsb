<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');
require_once('../models/email_template.php');

global $products_statuses;
$products_statuses = array(  0 => 'примерка', 2 => 'потеря ТК', 4 => 'отказ и возврат', 5 => 'принят' );

class Order extends Widget {
    var $order;

    function Order(&$parent) {
        parent::Widget($parent);
        $this->add_param('order_id');
        $this->add_param('view');
        $this->add_param('page');

        $this->prepare();
    }



    function prepare() {
        if (isset($_GET['delayed']) && isset($_GET['order_id'])) {
            $order_id = (int) $_GET['order_id'];
            $delayed  = (int) $_GET['delayed'];
            $this->db->query("UPDATE orders SET `delayed` = {$delayed} WHERE order_id = {$order_id}");
            if($delayed == 1){
                $text = "Пользователь <b>{$_SESSION['user']->name}</b> поставил статаус <b>отложено</b>";
                $message = "Для заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> поставлен статус 'отложено' пользователем {$_SESSION['user']->name}";
            }else{
                $text = "Пользователь <b>{$_SESSION['user']->name}</b> убрал статаус <b>отложено</b>";
                $message = "Для заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> убран статус 'отложено' пользователем {$_SESSION['user']->name}";
            }
            // Отправляем в слак
            $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "orders_statuses" );
            Job::push('SlackJob', $args);

            $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'status', '{$text}')");
            header("Location: index.php?section=Orders&view=process");
            exit();
        }
        if (isset($_GET['delete_comment_id']) && isset($_GET['order_id'])) {
            $order_id = (int) $_GET['order_id'];
            $delete_comment_id  = (int) $_GET['delete_comment_id'];
            $comment = $this->db->result("SELECT * FROM order_comments WHERE id = {$delete_comment_id} AND order_id = {$order_id}");
            $this->db->query("DELETE FROM order_comments WHERE id = {$delete_comment_id} AND order_id = {$order_id}");

            $text = "Пользователь <b>{$_SESSION['user']->name}</b> удалил комментарий `{$comment->text}` ";
            $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'comment', '{$text}')");

            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }
        if (isset($_GET['autocomplete'])) {
            $word = $_GET['query'];
            $results = $this->db->results($sql="SELECT city_name, region_name, city_id FROM `delivery_cities` WHERE `city_name` LIKE '{$word}%'");
            $res->suggestions = array();
            foreach($results as $k=>$r){
              $res->suggestions[$k]->value = $r->city_name . ' (' . $r->region_name . ')';
              $res->suggestions[$k]->data = $r->city_id;
            }
            $res = json_encode($res);
            die($res);
        }
        // Изменение цены товара
        if ( isset($_GET['change_price_product']) ) {
            $op_id = intval($_GET['change_price_product']);
            $price = floatval($_GET['price']);
            if ($op_id && $price) {
                $product = $this->db->result("SELECT order_id, product_name, price, product_id, one_click_id FROM orders_products WHERE id = {$op_id};");
                $query = "UPDATE orders_products SET price = {$price} WHERE id = {$op_id};";
                $this->db->query($query);
                $product_name = str_replace("'", "`", $product->product_name);
                $text = "Пользователь <b>{$_SESSION['user']->name}</b> изменил цену товара {$product_name} с {$product->price} р на {$price} р";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$product->order_id}, {$_SESSION['user']->user_id}, 'price_change', '{$text}')");

                $message = "{$_SESSION['user']->name} <@{$_SESSION['user']->slack_name}>  изменил цену на товар <https://lsboutique.ru/admin/index.php?section=Product&item_id={$product->product_id}|{$product_name}> в заказе #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$product->order_id}|{$product->order_id}> с {$product->price} р на {$price} р";
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "orders_price_changes" );
                Job::push('SlackJob', $args);
                if (!empty($product->one_click_id)){
                $datacheck = $this->db->result("SELECT cr_manager FROM one_click WHERE id = {$product->one_click_id}")->cr_manager;
                }
                else{
                   $datacheck = $this->db->result("SELECT cr_manager FROM orders WHERE order_id = {$product->order_id}")->cr_manager;
                }
                if(empty($datacheck)){
                    // Отправляем в слак
                    $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "price_change_log" );
                    Job::push('SlackJob', $args);
                }
            }
            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }

        require_once($_SERVER['DOCUMENT_ROOT'] . '/models/order.php');
        $orders = new orders($_GET['order_id']);
        if ( isset($_GET['pay_from_deposit']) ) {
          $user_id = (int) $_POST['user_id'];
          $order_id = (int) $_POST['order_id'];
          $user = $this->db->result("SELECT * FROM `users` WHERE user_id = {$user_id} ");
          if ( !empty($user->deposit) ) {
            if(!empty($_POST['sum'])){
              $total_sum = (int) $_POST['sum'];
            }
            else{
              $total_price = $this->db->result("SELECT SUM(price) as total FROM `orders_products` WHERE order_id = {$order_id} AND status != 4")->total;
              $delivery_price = $this->db->result("SELECT delivery_price FROM `orders` WHERE order_id = {$order_id}")->delivery_price;
              $paid_already = $this->db->result("SELECT (payment_prepaid + deposit_payment) as total FROM `orders` WHERE order_id = {$order_id}")->total;
              $total_sum = ($total_price + $delivery_price) - $paid_already;
            }
            $change_sum = $user->deposit >= $total_sum ? $total_sum : $user->deposit;
            $luser = new luser($user->original_user_id);
            $luser->change_deposit( -1*$change_sum, "Оплата заказа #{$order_id}", $order_id);
            $orders->set_deposit_payment($order_id, $change_sum);
            $text = "Пользователем <b>{$_SESSION['user']->name}</b> добавлена оплата с депозитного счета в сумме {$change_sum} р";
            $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'deposit', '{$text}')");
            echo $change_sum;
            die();
          }
        }

        $this->smarty->assign('order_print_link',         $orders->get_invoice_link());
        $this->smarty->assign('order_print_ponylink',     $orders->get_ponyinvoice_link());
        $this->smarty->assign('order_print_kasatkalink',  $orders->get_kasatkainvoice_link());
        $this->smarty->assign('order_print_maximalink',   $orders->get_maximainvoice_link());
        $this->smarty->assign('print_reversinvoice_link', $orders->get_reversinvoice_link());
        $this->smarty->assign('order_labels_link',        $orders->get_labels_link());

        set_time_limit(60);
        if ( isset($_GET['request_spsr']) ) {
            $invoice_link = $orders->get_invoice_link();
            $order = $this->get_order_by_id($_GET['order_id']); // Данные заказа
            if ( $_GET['norequest_spsr'] == 5 ) {
                $tariff = (int)$_GET['tariff'];
                // $cdek = new cdek_api('ad865a3a1003a36be8d53f05ae5701d6', '6fd26517ed75b3d455eb51f85882733a'); // тестовые параметры
                if (isset($_GET['ev'])) { // ИП Жехарев ЕВ
                    $cdek = new cdek_api('e7de5474a171f56230dba483d003527d', '057e391eeeb581c58c6811dd51958465');
                    $ip = 1;
                }
                elseif (isset($_GET['en'])) { // ИП Жехарева ЕН
                    $cdek = new cdek_api('4afe64f63986304f089e68ad36cc8549', '08b5b44c24f131d3a0136478195ccfdb');
                    $ip = 2;
                }
                else { // ИП Жехарев ВН
                    $cdek = new cdek_api('92f459b91b081285bd76b2d3c331ec0f', '21ac98c55453112fcc297a13e2573e37');
                    $ip = 3;
                }
                $this->smarty->assign('tariff',$tariff);
                if ($cdek->new_orders($order, $message, $tariff)) {
                  if($tariff == 3)$ttext = "Супер-Экспресс 18";
                  else $ttext = "Экспресс-Лайт";
                    $this->smarty->assign('request_spsr_status', "Накладная ТК CDEK сформирована<br>Тариф {$ttext}");
                    $text = "Пользователем <b>{$_SESSION['user']->name}</b> сформирована накладная ТК CDEK, тариф {$ttext}";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$_GET['order_id']}, {$_SESSION['user']->user_id}, 'autoinvoice', '{$text}')");
                    $this->db->query("UPDATE `orders` SET delivery_ip = {$ip} WHERE order_id = '{$_GET['order_id']}'");
                }
                elseif ($cdek->new_orders($order, $message, 1)) {
                    $this->smarty->assign('request_spsr_status', 'Накладная ТК CDEK сформирована<br>Тариф Экспресс-Лайт');
                    $text = "Пользователем <b>{$_SESSION['user']->name}</b> сформирована накладная ТК CDEK, тариф Экспресс-Лайт";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$_GET['order_id']}, {$_SESSION['user']->user_id}, 'autoinvoice', '{$text}')");
                    $this->db->query("UPDATE `orders` SET delivery_ip = {$ip} WHERE order_id = '{$_GET['order_id']}'");
                }
                else {
                    if ( mb_substr($message, 0, 21) != 'ERR_ORDER_DUBL_EXISTS' ) {
                        $this->smarty->assign('request_spsr_status', 'Накладная ТК CDEK не сформирована: <br>' . $message);
                    }
                    else {
                        $this->smarty->assign('request_spsr_status', 'Накладная ТК CDEK сформирована,<br>имейл отправлен в магазин');
                    }
                }
            }
            elseif ( $_GET['norequest_spsr'] == 3 ) {
                $this->smarty->assign('request_spsr_status', 'Накладная ТК Касатка сформирована');
                $text = "Пользователем <b>{$_SESSION['user']->name}</b> сформирована автоматическая накладная ТК Касатка";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$_GET['order_id']}, {$_SESSION['user']->user_id}, 'autoinvoice', '{$text}')");
                $invoice_link = $orders->get_kasatkainvoice_link();
            }
            elseif ( $_GET['norequest_spsr'] == 4 ) {
                $this->smarty->assign('request_spsr_status', 'Обратная накладная сформирована');
                $text = "Пользователем <b>{$_SESSION['user']->name}</b> сформирована автоматическая обратная накладная";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$_GET['order_id']}, {$_SESSION['user']->user_id}, 'autoinvoice', '{$text}')");
                $invoice_link = $orders->get_reversinvoice_link();
            }
            elseif ( $_GET['norequest_spsr'] == 2 ) { // Запрос в ПОНИ
                $orders->request_poni_set_key($this->config->poni_key);
                if ($result = $orders->request_poni($order, $message) ) {
                    $this->smarty->assign('request_spsr_status', 'Накладная ТК ПОНИ Экспресс сформирована');
                    $text = "Пользователем <b>{$_SESSION['user']->name}</b> сформирована автоматическая накладная ПОНИ";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$_GET['order_id']}, {$_SESSION['user']->user_id}, 'autoinvoice', '{$text}')");
                }
                else {
                    $this->smarty->assign('request_spsr_status', 'Накладная ПОНИ не сформирована: <br>' . $message);
                }
                $invoice_link = $orders->get_ponyinvoice_link();
            }
            else {
                $SID = $orders->api_login('lsboutique', '5200346811', '5200346811');
//                $SID = $orders->api_login('vusachev', 'N0!0460711', '5200460711');
                if ( $spsrNum = $orders->api_create_invoice() ) { // Обновим delivery code
                    $spsrNum = $this->db->escape($spsrNum);
                    $this->db->query("UPDATE orders SET barcode = '{$spsrNum}' WHERE order_id = '" . $orders->get('order_id') . "'");
                    $orders->copy_bc2dc();
                    $orders->api_logout();
                    $this->smarty->assign('request_spsr_status', 'Накладная ТК СПСР сформирована');
                    $text = "Пользователем <b>{$_SESSION['user']->name}</b> сформирована автоматическая накладная СПСР";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$_GET['order_id']}, {$_SESSION['user']->user_id}, 'autoinvoice', '{$text}')");
                }
                else {
                    $this->smarty->assign('request_spsr_status', 'Накладная СПСР не сформирована! Ошибка!');
                }
            }

            // Отправим имейл Ире
            $et = new email_template('create_invoice_out');
            $et->assign('SITE', "http://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
               ->assign('CALL_BY_CLICK',       $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
               ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
               ->assign('ORDER_NUMBER',        $order->order_id)
               ->assign('ORDER_STATUS',        $statuses[$order->status])
               ->assign('ORDER_LINK',          "http://{$_SERVER['HTTP_HOST']}/order/{$order->code}")
               ->assign('ORDER_INVOICE_LINK',  $invoice_link)
               ->assign('ORDER_LABELS_LINK',   $orders->get_labels_link())
               ->assign('USER_NAME',           $order->name)
               ->assign('USER_EMAIL',          $order->email)
               ->send($this->config->support_email);
            if ( $_GET['norequest_spsr'] == 3 ) { // Накладная в Касатку
                $et->send('vova@lsboutique.ru')->send('artem@lsboutique.ru');
            }
        }

        // С каким заказом работаем?
        $this->order_id = intval($this->param('order_id'));
        $this->order = $this->get_order_by_id($this->order_id);

        if ( intval($this->param('delete_product_id')) && intval($this->param('order_id')) ) {
            $product_id = intval($this->param('delete_product_id'));
            $order_id = intval($this->param('order_id'));
            $data = $this->db->result("SELECT order_id, product_name, product_id, one_click_id FROM orders_products WHERE id = {$product_id} AND order_id = {$order_id} LIMIT 1");
            $query = sql_placeholder("DELETE FROM orders_products WHERE orders_products.order_id=? AND orders_products.id=? LIMIT 1", $this->param('order_id'), $this->param('delete_product_id') );
            $this->db->query($query);
            $product_name = str_replace("'", "`", $this->order->products[$product_id]->product_name);
            $text = '<b>'.$_SESSION['user']->name.'</b> удалил из заказа товар <a href="/products/'.$this->order->products[$product_id]->url.'" target="_blank">'.$product_name.'</a> размер '.$this->order->products[$product_id]->size.'.';
            $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->param('order_id')}, {$_SESSION['user']->user_id}, 'product_del', '{$text}')");

            if (!empty($data->one_click_id)){
                $datacheck = $this->db->result("SELECT cr_manager FROM one_click WHERE id = {$data->one_click_id}")->cr_manager;
            }
            else{
               $datacheck = $this->db->result("SELECT cr_manager FROM orders WHERE order_id = {$data->order_id}")->cr_manager;
            }
            if(empty($datacheck)){
                // Отправляем в слак
                $message = "{$_SESSION['user']->name}  удалил товар <https://lsboutique.ru/products/{$data->product_id}|{$data->product_name}> в заказе #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$data->order_id}|{$data->order_id}>";
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "price_change_log" );
                Job::push('SlackJob', $args);
            }

            header("Location: /admin/index.php?section=Order&order_id={$order_id}");
            exit();
        }
        if ( intval($this->param('clone_product_id')) && intval($this->param('order_id')) ) {
            $product_id = intval($this->param('clone_product_id'));
            $order_id = intval($this->param('order_id'));
            $data = $this->db->result("SELECT order_id, product_name, product_id, one_click_id FROM orders_products WHERE id = {$product_id} AND order_id = {$order_id} LIMIT 1");
            $query = "INSERT INTO `orders_products` (`order_id`, `user_id`, `product_id`, `status`, `status_date`, `barcode`, `product_name`, `price`, `quantity`, `size`, `item_location`, `sku`, `new_order`) SELECT `order_id`, `user_id`, `product_id`, `status`, `status_date`, `barcode`, `product_name`, `price`, `quantity`, `size`, `item_location`, `sku`, `new_order` FROM `orders_products` WHERE id={$product_id} AND orders_products.order_id={$order_id};";
            $this->db->query($query);
            $product_name = str_replace("'", "`", $this->order->products[$product_id]->product_name);
            $text = "<b>{$_SESSION['user']->name}</b> клонировал товар {$product_name}";
            $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'product_clone', '{$text}')");

            if (!empty($data->one_click_id)){
                $datacheck = $this->db->result("SELECT cr_manager FROM one_click WHERE id = {$data->one_click_id}")->cr_manager;
            }
            else{
               $datacheck = $this->db->result("SELECT cr_manager FROM orders WHERE order_id = {$data->order_id}")->cr_manager;
            }
            if(empty($datacheck)){
                // Отправляем в слак
                $message = "{$_SESSION['user']->name} клонировал товар <https://lsboutique.ru/products/{$data->product_id}|{$data->product_name}> в заказе #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$data->order_id}|{$data->order_id}>";
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "price_change_log" );
                Job::push('SlackJob', $args);
            }
            header("Location: /admin/index.php?section=Order&order_id={$order_id}");
            exit();
        }

        $this->order = $this->get_order_by_id($this->order_id);

        $money_sum = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id = {$this->order_id}");
        $money_sum = $money_sum->total;

        $this->smarty->assign("cdek_accounts", $this->db->results("SELECT * FROM TK_ip WHERE company_id = 5"));

        // Если что-то запостили, нужно обновить запись в базе
        if(isset($_POST['name']) || isset($_POST['delivery_status'])) {
            // Статус товара в заказе
            if ( is_array($_POST['products_status']) && count($_POST['products_status']) ) {
                $manager = $this->db->result("SELECT name, slack_name FROM `users` WHERE `user_id` = '{$this->order->manager_id}'");
                foreach ( $_POST['products_status'] as $product_id => $status) {
                    if ( $this->order->products[$product_id]->status != $status ) {
                        if ( $status == 1 ) { // Отказ от товара
                            luser::save_to_crm( $this->order->user_id, 'failure', "Клиент отказался от <a href='/products/{$this->order->products[$product_id]->url}' target='_blank'>вещи {$this->order->products[$product_id]->product_name}</a> в заказе №<a href='/admin/index.php?section=Order&order_id={$this->order_id}' target='_blank'>{$this->order_id}</a>", '');
                        }
                        if ( $status == 5 ) { // Товар принят клентом
                            $this->db->query("DELETE FROM users2wishlist WHERE user_id = '{$this->order->user_id}' AND product_id = '{$this->order->products[$product_id]->product_id}'");
                            $size  = $this->db->result("SELECT i.size_id, i.size_type, i.size, i.size_system FROM orders_products op LEFT JOIN items i ON i.barcode = op.barcode WHERE op.product_id = '{$this->order->products[$product_id]->product_id}' AND op.order_id = '{$this->order->order_id}'");
                            $size_check = $this->db->result("SELECT size_id FROM users2sizes_n WHERE user_id = {$this->order->user_id} AND size_id = {$size->size_id}");
                            if($size->size_id ==0 && $size->size !=0 && $size->size_system !=''){
                                $size->size_id = $this->db->result("SELECT size_id FROM size_names WHERE size = '{$size->size}' AND size_m_s = '{$size->size_system}'")->size_id;
                            }
                            if (empty($size_check->size_id) && !empty($size->size_id) && !empty($size->size_type)){
                                $this->db->query("INSERT INTO users2sizes_n (user_id, type_id, size_id) VALUES ( {$this->order->user_id}, {$size->size_type}, {$size->size_id} );");
                            }
                            $o_product = $this->db->result("SELECT * FROM orders_products WHERE id = {$product_id}");
                            $mp .= "<https://lsboutique.ru/products/{$o_product->product_id}|{$o_product->product_name}> артикул {$o_product->sku} стоимостью {$o_product->price} ";
                            $set = $this->db->result($sql="SELECT id FROM sets WHERE main_product_id = {$o_product->product_id}")->id;
                            if(empty($set)) $set = $this->db->result($sql="SELECT set_id FROM sets_products WHERE product_id = {$o_product->product_id}")->set_id;
                            if(!empty($set)){
                              $user_sizes = $this->db->result($sql="SELECT GROUP_CONCAT(size_id) AS sizes FROM users2sizes_n WHERE user_id = {$this->order->user_id}")->sizes;
                              $query = "SELECT SS.product_id, p.model
                                      FROM (SELECT main_product_id as product_id FROM sets WHERE id = {$set}
                                              UNION ALL
                                            SELECT product_id FROM sets_products WHERE set_id = {$set}) as SS
                                      LEFT JOIN items ON items.product_id = SS.product_id
                                      LEFT JOIN products p ON SS.product_id = p.product_id
                                      WHERE items.size_id IN ({$user_sizes}) AND items.quantity > 0 AND SS.product_id != {$o_product->product_id}
                                      GROUP BY p.product_id";
                              $set_products = $this->db->results($query);
                              if(!empty($set_products)){
                                foreach($set_products as $prod){
                                  $sp[] = "<https://lsboutique.ru/products/{$prod->product_id}|{$prod->model}>";
                                }
                                $mp .= "(Набор: " . implode(', ',$sp) . ")";
                              }
                            }
                            if ( !empty($this->order->products[$product_id]->one_click_id) ) { // Проверим, если заказ пришел с партнерской системы
                                $oc = $this->db->result("SELECT * FROM `one_click` WHERE id = '{$this->order->products[$product_id]->one_click_id}' LIMIT 1");
                                if ( !empty($oc->from_mixmarket) ) {
                                    orders::mixmarket_notify(1000000+$oc->id, $this->order->products[$product_id]->price, 'complete');
                                }
                            }
                            $message = "Из заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$this->order->order_id}|{$this->order->order_id}>, менеджер {$manager->name} <@{$manager->slack_name}> приняты: {$mp}";


                        }
                        $this->log_product_status_change($this->order->order_id, $status, $product_id);
                        $p_status_change = true;
                    }
                    $pquery = " status = '{$status}' ";
                    if (isset($_POST['products_status_date'][$product_id])) {
                        $p_date = $_POST['products_status_date'][$product_id];
                        $pquery .= ", status_date = '{$p_date}' ";
                    }
                    if ( $this->order->products[$product_id]->status != $status && ($status == 5 || $status == 4) && !isset($p_date)) {
                        $pquery .= ", status_date = NOW() ";
                    }
                    $this->db->query("UPDATE orders_products SET {$pquery} WHERE order_id = '{$this->order_id}' AND id = '{$product_id}' LIMIT 1");
                }
                $channel = "items_accepted";
                $url = "https://hooks.slack.com/services/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";
                send_to_slack($message, $channel, $url);

                $arr  = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id = '{$this->order_id}' AND status = 5");
                if (!empty($arr->total)){
                    $money_sum = $arr->total;
                }
            }

            // Размер товара в заказе
            if ( is_array($_POST['products_size']) && count($_POST['products_size']) ) {
                foreach ( $_POST['products_size'] as $product_id => $item_id) {
                  $item = $this->db->result("SELECT * FROM items WHERE item_id = {$item_id}");
                    if (!empty($item)){
                      if ($this->order->products[$product_id]->size != $item->size){
                          $product_name = str_replace("'", "`", $this->order->products[$product_id]->product_name);
                          $text = "Пользователь <b>{$_SESSION['user']->name}</b> изменил размер товара {$product_name} с {$this->order->products[$product_id]->size} на {$item->size}";
                          $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'size_change', '{$text}')");
                      }
                      $this->db->query("UPDATE `orders_products` SET `size`='{$item->size}', `barcode`='{$item->barcode}', `item_id`={$item->item_id}  WHERE `id`= '{$product_id}'");
                    }
                }
            }

            // Если статус заказа изменился
            $order->status = isset($_POST['status']) ? $_POST['status'] : $this->order->status;
            if ( $this->order->status != $order->status ) {
                $statuses = array(
                    0 => 'Новый',
                    1 => 'В обработке',
                    2 => 'Выполнен',
                    3 => 'Отмена заказа',
                    4 => 'Товар отсутствует',
                    5 => 'Самовывоз',
                    6 => 'Доставка');
                if(isset($_POST['notify_user']) && $_POST['notify_user']==1) {
                    $notify_user = 1;
                }
                if ( $_POST['status'] == 1) {
                    if ( empty($_POST['manager_id'])) {
                        if ( $this->order->manager_id == 0) {
                            $this->db->query("UPDATE orders SET manager_id = {$_SESSION['user']->user_id} WHERE order_id = {$this->order->order_id}");
                            $text = "Автоназначение! Назначен менеджер заказа <b>{$_SESSION['user']->name}</b>";
                            $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'manager', '{$text}')");
                        }
                    }
                }
                if ( $_POST['status'] == 2  && $notify_user==1) { // Заказ выполнен
                    if($_COOKIE['language'] == 'eng'){$message = "{USERNAME}, thank you for your successful purchase! Your Luxury Store www.lsboutique.ru. Please leave a review about our work on Yandex Market - http://www.ls.net.ru/market";}
                    else{$message = "{USERNAME}, благодарим Вас за удачную покупку! Ваш Лакшери Стор www.lsboutique.ru. Пожайлуста оставьте отзыв о нашей работе на Яндекс Маркет - http://www.ls.net.ru/market";}
                    $message = str_replace(array('{USERNAME}'), array($_POST['name']), $message);
                    $args = array( 'user_id' => $this->order->user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $_POST['phone'] );
                    Job::push( 'SmsJob', $args, false, 'critical' );
                    if ( !empty($this->order->from_mixmarket) ) {
                        $total = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id = '{$this->order->order_id}' AND status IN (0,5)");
                        orders::mixmarket_notify($this->order->order_id, $total->total, 'complete');
                    }
                }
                if ( $_POST['status'] == 3 ) { // Заказ отменён
                    if ( !empty($this->order->from_mixmarket) ) {
                        orders::mixmarket_notify($this->order->order_id, 0, 'decline');
                    }
                    $date_check = $this->db->result("SELECT date_to_decline FROM `orders` WHERE order_id = '{$this->order->order_id}'")->date_to_decline;
                    if ( empty((int)$date_check)) {
                        $this->db->query("UPDATE `orders` SET date_to_decline = NOW() WHERE order_id = '{$this->order->order_id}'");
                    }
                }
                if ( $_POST['status'] == 6 ) { // Заказ поменял статус на доставку
                    if ( $notify_user==1 ) {
                        $delivery_company_name = $this->db->result("SELECT name FROM delivery_companies WHERE id = {$_POST['delivery_company_id']};")->name;
                        if($_COOKIE['language'] == 'eng'){$message = "{$_POST['name']}, your order №{$this->order->order_id} transferred to the delivery company {$delivery_company_name}, invoice number: {$_POST['invoice_number']}. Your Luxury Store +74953748934";}
                        else{$message = "{$_POST['name']}, ваш заказ №{$this->order->order_id} передан в доставку компанией {$delivery_company_name}, номер накладной: {$_POST['invoice_number']}. Ваш Лакшери Стор +74953748934";}
                        $args = array( 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $_POST['phone'] );
                        Job::push( 'SmsJob', $args, false, 'critical' );
                    }
                    $p_manager_id = $this->db->result("SELECT p_manager_id FROM `users` WHERE user_id = '{$this->order->user_id}'")->p_manager_id;
                    if ( empty($p_manager_id)) {
                        $this->db->query("UPDATE users SET p_manager_id = {$this->order->manager_id} WHERE user_id = {$this->order->user_id}");
                    }
                    $date_check = $this->db->result("SELECT date_to_delivery FROM `orders` WHERE order_id = '{$this->order->order_id}'")->date_to_delivery;
                    if ( empty((int)$date_check)) {
                        $this->db->query("UPDATE `orders` SET date_to_delivery = NOW() WHERE order_id = '{$this->order->order_id}'");
                    }
                }
                $this->log_order_status_change($this->order->order_id, $_POST['status']);
            }

            if ( $_POST['delivery_status'] && $this->order->delivery_status != $_POST['delivery_status'] ) {
                $this->log_delivery_status_change($this->order->order_id, $_POST['delivery_status']);
            }
            if ( $_POST['user_id'] && $this->order->user_id != $_POST['user_id'] ) {
                $text = "ID пользователя заказа изменено с <b>{$this->order->user_id}</b> на <b>{$_POST['user_id']}</b>";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'manager', '{$text}')");
            }

            if ( (isset($_POST['status']) && $this->order->status != $_POST['status']) || (isset($_POST['delivery_status']) && $this->order->delivery_status != $_POST['delivery_status']) || (isset($_POST['money_status']) && $this->order->money_status != $_POST['money_status']) ) {
                $query = sql_placeholder("UPDATE orders SET last_update = NOW() WHERE order_id = ?", $this->order_id);
                $this->db->query($query);
            }

            $manager_id = $this->order->manager_id;
            if ($_POST['manager_id']) {
                $manager_id = $_POST['manager_id'];
            }
            $order->packer_id = $this->order->packer_id;
            if (isset($_POST['packer_id'])) {
                $order->packer_id = $_POST['packer_id'];
            }
            $order->return_manager_id = $this->order->return_manager_id;
            if (isset($_POST['return_manager_id'])) $order->return_manager_id = $_POST['return_manager_id'];
            $courier_id = $this->order->courier_id;
            if (isset($_POST['courier_id']) && (($courier_id == 0 && $_SESSION['user']->group_id == 5) || $_SESSION['user']->group_id == 2 || ($_SESSION['user']->group_id == 5 && $_SESSION['user']->subgroup_id == 3))) {
                $courier_id = $_POST['courier_id'];
            }

            $order->user_id             = isset($_POST['user_id']) ? $_POST['user_id'] : $this->order->user_id;
            $order->name                = $_POST['name'];
            $order->email               = $_POST['email'];
            $order->phone               = $_POST['phone'];
            $order->manager_id          = $manager_id;
            $order->courier_id          = $courier_id;
            $order->address             = $_POST['address'];
            $order->city_id             = $_POST['city_id'];
            $order->comment             = $_POST['comment'];
            $order->delivery_status     = isset($_POST['delivery_status']) ? $_POST['delivery_status'] : $this->order->delivery_status;
            $order->money_status        = $_POST['money_status'];
            $order->delivery_paid       = isset($_POST['delivery_paid']) && $_POST['delivery_paid']==1 ? 1 : 0;
            $order->delivery_agent_price= $_POST['delivery_agent_price'];
            $order->delivery_return_price= $_POST['delivery_return_price'];
            $order->delivery_agent_fee  = $_POST['delivery_agent_fee'];
            $order->invoice_number      = $_POST['invoice_number'];
            $order->return_invoice_number= $_POST['return_invoice_number'];
            $order->delivery_method_id  = 1;//$_POST['delivery_method_id'];
            $order->delivery_company_id = $_POST['delivery_company_id'];
            $order->delivery_code       = $_POST['delivery_code'];
            $order->delivery_price      = $_POST['delivery_price'];
            $order->delivery_date       = $_POST['delivery_date'];
            $order->agreed_delivery_date= $_POST['agreed_delivery_date'];
            $order->payment_method_id   = $_POST['payment_method_id'];
            $order->prepaid_method_id   = $_POST['prepaid_method_id'];
            $order->fault_reason        = $_POST['fault_reason'];
            $order->payment_status      = isset($_POST['payment_status']) && $_POST['payment_status']==1 ? 1 : 0;
            $order->payment_prepaid     = isset($_POST['payment_prepaid']) ? (float)$_POST['payment_prepaid'] : $this->order->payment_prepaid;
            $order->no_payment_discount = isset($_POST['no_payment_discount']) && $_POST['no_payment_discount']==1 ? 1 : 0;
            $order->coupon_code         = $_POST['coupon_code'];
            $order->coupon_discount     = $_POST['coupon_discount'];
            $order->coupon_type         = $_POST['coupon_type'];
            $order->partner_order       = (isset($_POST['partner_order']) && $_POST['partner_order']==1) ? 1 : $this->order->partner_order;

            $sql_set_payment_date = '';
            if($order->payment_status==1 && $this->order->payment_status==0)
                $sql_set_payment_date = 'payment_date = NOW(),';

            $error = '';

            // Если ошибок не возникло, обновим заказ в базе
            if (empty($error)) {
                $agreed_delivery_date = '';
                if ($order->agreed_delivery_date){
                    $agreed_delivery_date = date('Y-m-d H:i', strtotime($order->agreed_delivery_date));
                }
                if (isset($_SESSION['delivery_agent'])) {
                    $query = sql_placeholder("UPDATE orders SET
                        comment=?,
                        delivery_status=?,
                        delivery_date=?,
                        agreed_delivery_date=?,
                        money_status=?,
                        delivery_paid=?,
                        delivery_agent_price=?,
                        delivery_return_price=?,
                        delivery_agent_fee=?,
                        invoice_number=?,
                        return_invoice_number=?,
                        partner_order=?
                        WHERE order_id=?",
                        $order->comment,
                        $order->delivery_status,
                        $order->delivery_date,
                        $agreed_delivery_date,
                        $order->money_status,
                        $order->delivery_paid,
                        $order->delivery_agent_price,
                        $order->delivery_return_price,
                        $order->delivery_agent_fee,
                        $order->invoice_number,
                        $order->return_invoice_number,
                        $order->partner_order,
                        $this->order->order_id);
                }
                else {
                    $query = sql_placeholder("UPDATE orders SET
                        user_id=?,
                        name=?,
                        email=?,
                        phone=?,
                        address=?,
                        comment=?,
                        delivery_status=?,
                        delivery_agent_price=?,
                        delivery_return_price=?,
                        delivery_agent_fee=?,
                        invoice_number=?,
                        return_invoice_number=?,
                        delivery_method_id=?,
                        delivery_price=?,
                        agreed_delivery_date=?,
                        delivery_company_id=?,
                        status=?,
                        fault_reason=?,
                        payment_method_id=?,
                        prepaid_method_id=?,
                        $sql_set_payment_date
                        payment_status=?,
                        payment_prepaid=?,
                        no_payment_discount=?,
                        coupon_code=?,
                        coupon_discount=?,
                        coupon_type=?,
                        partner_order=?,
                        courier_id=?,
                        packer_id=?,
                        return_manager_id=?
                        WHERE order_id=?",
                        $order->user_id,
                        $order->name,
                        $order->email,
                        $order->phone,
                        $order->address,
                        $order->comment,
                        $order->delivery_status,
                        $order->delivery_agent_price,
                        $order->delivery_return_price,
                        $order->delivery_agent_fee,
                        $order->invoice_number,
                        $order->return_invoice_number,
                        $order->delivery_method_id,
                        $order->delivery_price,
                        $agreed_delivery_date,
                        $order->delivery_company_id,
                        $order->status,
                        $order->fault_reason,
                        $order->payment_method_id,
                        $order->prepaid_method_id,
                        $order->payment_status,
                        $order->payment_prepaid,
                        $order->no_payment_discount,
                        $order->coupon_code,
                        $order->coupon_discount,
                        $order->coupon_type,
                        $order->partner_order,
                        $order->courier_id,
                        $order->packer_id,
                        $order->return_manager_id,
                        $this->order->order_id);
                }
                $this->db->query($query);

                if ($_POST['manager_id'] && $_POST['manager_id'] != $this->order->manager_id) {
                    $this->db->query("UPDATE orders SET manager_id = {$_POST['manager_id']} WHERE order_id = {$this->order->order_id}");
                    $manager = $this->db->result("SELECT name, slack_name FROM users WHERE user_id = {$_POST['manager_id']}");
                    $text = "Назначен менеджер заказа <b>{$manager->name}</b>";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'manager', '{$text}')");
                    // Отправляем в слак
                    $message = "{$_SESSION['user']->name} сменил менеджера у заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$this->order->order_id}|{$this->order->order_id}> на {$manager->name} <@{$manager->slack_name}>";
                    $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "order_manager_change" );
                    Job::push('SlackJob', $args);
                }
                if ($_POST['agreed_delivery_date'] && $_POST['agreed_delivery_date'] != $this->order->agreed_delivery_date) {
                    $text = "Назначена дата доставки <b>{$agreed_delivery_date}</b> пользователем <b>{$_SESSION['user']->name}</b>";
                    if($this->order->delivery_company_id == 5){
                      Job::push('CdekScheduleJob', ['order_id' => $this->order->order_id]);
                    }
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'agreed_date', '{$text}')");
                }
                $lastcomment = $this->db->result("SELECT * FROM order_comments WHERE order_id = {$this->order->order_id} ORDER BY id DESC LIMIT 1")->text;
                if ($_POST['comment'] && $_POST['comment'] != $lastcomment) {
                    $this->db->query("INSERT INTO order_comments (order_id, user_id, text, date) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, '{$order->comment}', NOW())");

                    $text = "Пользователь <b>{$_SESSION['user']->name}</b> добавил комментарий `{$order->comment}` ";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'comment', '{$text}')");
                }
                if ($_POST['payment_prepaid'] && $_POST['payment_prepaid'] != $this->order->payment_prepaid) {
                    $text = "Пользователь <b>{$_SESSION['user']->name}</b> добавил предоплату <b>{$order->payment_prepaid}</b> руб";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'payment_prepaid', '{$text}')");
                }
                if ($_POST['invoice_number'] && $_POST['invoice_number'] != $this->order->invoice_number) {
                    $text = "Пользователь <b>{$_SESSION['user']->name}</b> добавил номер накладной <b>{$order->invoice_number}</b>";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'invoice_number', '{$text}')");
                }
                if ($_POST['return_invoice_number'] && $_POST['return_invoice_number'] != $this->order->return_invoice_number) {
                    $text = "Пользователь <b>{$_SESSION['user']->name}</b> добавил номер возвратной накладной <b>{$order->return_invoice_number}</b>";
                    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'return_invoice', '{$text}')");
                }
                if ($_POST['money_status'] == 2 && $_POST['money_status'] != $this->order->money_status) {
                    // Отправляем в слак
                    $message = "Оплата заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$this->order->order_id}|{$this->order->order_id}> была передана в ТК";
                    $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "money_with_tk" );
                    Job::push('SlackJob', $args);
                }
                if ($_POST['money_status'] == 3 && $_POST['money_status'] != $this->order->money_status) {
                    // Отправляем в слак
                    $message = "Оплата заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$this->order->order_id}|{$this->order->order_id}> была передана в LS";
                    $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "money_with_ls" );
                    Job::push('SlackJob', $args);
                    if ( $this->order->partner_order == 1) {
                        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "order_partners" );
                        Job::push('SlackJob', $args);
                    }
                }
                if ( $_POST['partner_order'] == 1 && $_POST['partner_order'] != $this->order->partner_order) {
                    $message = "Заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$this->order->order_id}|{$this->order->order_id}> был отмечен, как партнерский.";
                    $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "order_partners" );
                    Job::push('SlackJob', $args);
                }
                if ($order->delivery_company_id == 3) {
                    $query = sql_placeholder('UPDATE orders SET barcode=? WHERE order_id=?', date('HisdmY'), $this->order->order_id);
                    $this->db->query($query);
                }

                if (isset($p_status_change) || $order->delivery_company_id != $this->order->delivery_company_id){
                    if ($order->delivery_company_id == 3 && isset($money_sum)) {
                        if ($order->city_id != 1054 && (in_array($order->city_id, array(992,893)))){
                            $cal_delivery_price = ($money_sum * 7 / 100);
                            $this->db->query("UPDATE orders SET real_delivery_price = {$cal_delivery_price}, delivery_agent_price = {$cal_delivery_price} WHERE order_id={$this->order->order_id} LIMIT 1");
                        }
                    }
                }
            if ($order->delivery_company_id == 1 && !empty($order->city_id) && empty($_POST['delivery_agent_price'])) {
                    $zone  = $this->db->result("SELECT `spsr_zone` FROM `delivery_cities` WHERE `city_id` = '{$order->city_id}'");
                    $price = $this->db->result("SELECT * FROM orders WHERE order_id={$this->order->order_id};");
                    switch($zone->spsr_zone){
                        case 0 : break;
                        case 1 :  $first_kg = 150; $rest_kg = 6; break;
                        case 2 :  $first_kg = 200; $rest_kg = 44; break;
                        case 3 :  $first_kg = 200; $rest_kg = 45; break;
                        case 4 :  $first_kg = 160; $rest_kg = 23; break;
                        case 5 :  $first_kg = 170; $rest_kg = 23; break;
                        case 6 :  $first_kg = 200; $rest_kg = 43; break;
                        case 7 :  $first_kg = 200; $rest_kg = 50; break;
                        case 8 :  $first_kg = 220; $rest_kg = 74; break;
                        case 9 :  $first_kg = 300; $rest_kg = 106; break;
                        case 10 : $first_kg = 350; $rest_kg = 141; break;
                    }
                    if ($price->delivery_agent_price == 0){
                        $cal_delivery_price  = $first_kg + ($rest_kg*($this->order->weight - 1)) + 129 + ($money_sum * 1.5 / 100) + ($money_sum * 0.2 / 100);
                        $cal_delivery_price += ($cal_delivery_price * 18 / 100);
                        $this->db->query("UPDATE orders SET real_delivery_price = {$cal_delivery_price}, delivery_agent_price = {$cal_delivery_price} WHERE order_id={$this->order->order_id} LIMIT 1");
                    }
                    if ( count($_POST['products_status']) && !(in_array(0, $_POST['products_status'])) ){
                        $products_arr  = $this->db->results("SELECT * FROM `orders_products` WHERE order_id = {$this->order_id} AND status = 4");
                        $delivery_price = $price->real_delivery_price;
                        if (empty($products_arr)){
                            $delivery_price = $delivery_price - 35;
                            $this->db->query("UPDATE `users` SET `deposit` =`deposit` + 35 WHERE `user_id`={$this->order->user_id} LIMIT 1");
                            $this->db->query("UPDATE `orders` SET `real_delivery_price` = {$delivery_price}, `delivery_agent_price` = {$delivery_price} WHERE `order_id`={$this->order->order_id} LIMIT 1");
                        }
                        else {
                            $weight = 0;
                            foreach ($products_arr as $product){
                                $weight_tmp = $this->db->result("SELECT categories.weight AS weight FROM `products` LEFT JOIN `categories` ON products.category_id = categories.category_id WHERE products.product_id={$product->product_id} LIMIT 1");
                                $weight += $weight_tmp->weight;
                            }
                            if ($weight > 1) {
                                $cal_return_price = $first_kg + ($rest_kg*($weight - 1));
                            }
                            else {
                                $cal_return_price = $first_kg;
                            }
                            $cal_return_price += ($cal_return_price * 18 / 100);
                            $cal_delivery_price = $delivery_price + $cal_return_price;
                            $this->db->query("UPDATE `orders` SET `real_delivery_price` = {$cal_delivery_price}, `delivery_agent_price` = {$cal_delivery_price} WHERE `order_id`={$this->order->order_id} LIMIT 1");
                        }
                    }
                }

                $request_spsr = "/admin/index.php?section=Order&request_spsr=1&order_id={$this->order_id}&token={$this->token}";
                $this->smarty->assign('request_spsr', $request_spsr);

                // Найдем менеджеров
                $this->db->query("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 5 ORDER BY name;");
                $managers = $this->db->results();

                if (!empty($order->city_id)) {
                    $city = $this->db->result("SELECT * FROM delivery_cities WHERE city_id = '{$order->city_id}'");
                    $this->db->query("UPDATE orders SET city_id = {$order->city_id}, city = '{$city->city_name}' WHERE order_id = {$this->order->order_id}");
                    $this->db->query("UPDATE users SET city_id = {$order->city_id}, city = '{$city->city_name}' WHERE user_id = {$this->order->user_id}");
                    if ($order->city_id != $this->order->city_id) {
                        if($this->order->city_id != 0){
                            $text = "Пользователь <b>{$_SESSION['user']->name}</b> сменил город с <b>{$this->order->city}</b> на <b>{$city->city_name}</b>";
                        }else{
                            $text = "Пользователь <b>{$_SESSION['user']->name}</b> указал город доставки <b>{$city->city_name}</b>";
                        }
                        $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$this->order->order_id}, {$_SESSION['user']->user_id}, 'city_change', '{$text}')");
                    }
                    if ($order->delivery_company_id == 3 && $order->city_id == 1054) {
                        $cal_delivery_price = 350;
                        $this->db->query("UPDATE orders SET real_delivery_price = {$cal_delivery_price}, delivery_agent_price = {$cal_delivery_price} WHERE order_id={$this->order->order_id} LIMIT 1");
                    }
                }

                $this->smarty->assign('order', $this->order);
                $products = $this->smarty->fetch('email_products.tpl');
                if ( $order->status == 3 && $this->order->status != $order->status ) {
                    $order = $this->get_order_by_id($this->order_id);
                    $et = new email_template('order_declined');
                    $et ->assign('SITE', "http://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                        ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                        ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                        ->assign('ORDER_NUMBER',    $order->order_id)
                        ->assign('ORDER_STATUS',    $statuses[$order->status])
                        ->assign('PRODUCTS',        $products )
                        ->assign('ORDER_LINK',      "http://{$_SERVER['HTTP_HOST']}/order/{$order->code}")
                        ->assign('FAULT_REASON',    ($order->fault_reason ? "Причина: <b>{$order->fault_reason}</b>" : ''))
                        ->assign('USER_NAME',       $order->name)
                        ->assign('USER_EMAIL',      $order->email)
                        ->send('mail@lsboutique.ru');
                }
                if ( $order->status == 2 && $this->order->status != $order->status ) {
                    $order = $this->get_order_by_id($this->order_id);
                    $et = new email_template('order_complete');
                    $et ->assign('SITE', "http://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                        ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                        ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                        ->assign('ORDER_NUMBER',    $order->order_id)
                        ->assign('ORDER_STATUS',    $statuses[$order->status])
                        ->assign('PRODUCTS',        $products )
                        ->assign('ORDER_LINK',      "http://{$_SERVER['HTTP_HOST']}/order/{$order->code}")
                        ->assign('USER_NAME',       $order->name)
                        ->assign('USER_EMAIL',      $order->email)
                        ->send('mail@lsboutique.ru');
                }

                // Уведомление пользователя
                if(isset($notify_user) && $notify_user==1) {
                    global $database_object;
                    $database_object = $this->db;
                    $order = $this->get_order_by_id($this->order_id);
                    if ( $order->delivery_status == 3 ) {
                        $user = new luser( $order->user_id );
                        $psum = $user->get_sum_of_buy( $order->user_id ) + $order->total_amount - $order->delivery_price;
                        // Скидки Лакшери Стор
                        $sums_borders = array(250000 => 15, 500000 => 20, 900000 => 25, 1500000 => 30);
                        $user_discount = 10;
                        foreach ($sums_borders as $sb => $disc) if ($psum > $sb) $user_discount = $disc;

                        $et = new email_template('order_complete');
                        $et ->assign('SITE', "http://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                            ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                            ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                            ->assign('ORDER_NUMBER',    $order->order_id)
                            ->assign('ORDER_STATUS',    $statuses[$order->status])
                            ->assign('ORDER_LINK',      "http://{$_SERVER['HTTP_HOST']}/order/{$order->code}")
                            ->assign('USER_NAME',       $order->name)
                            ->assign('USER_EMAIL',      $order->email)
                            ->assign('TOTAL_SUM',       $psum)
                            ->assign('DISCOUNT',        $user_discount)
                            ->assign('USER_PHONE_NUMBER', 	$user->phone_number)
                            ->assign('USER_CARD_NUMBER', 	$user->card_number)
                            ->send( $order->email, $order->name )->send('mail@lsboutique.ru');
                        luser::save_to_crm( $this->order->user_id, 'email', $et->getMergedField('subject'), $et->getMergedBodyHtml());
                    }
                    else {
                        $et = new email_template('order_update');
                        $et ->assign('SITE', "http://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                            ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                            ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                            ->assign('ORDER_NUMBER',    $order->order_id)
                            ->assign('ORDER_STATUS',    $statuses[$order->status])
                            ->assign('ORDER_LINK',      "http://{$_SERVER['HTTP_HOST']}/order/{$order->code}")
                            ->assign('USER_NAME',       $order->name)
                            ->assign('USER_EMAIL',      $order->email)
                            ->send( $order->email, $order->name )->send('mail@lsboutique.ru');
                        luser::save_to_crm( $this->order->user_id, 'email', $et->getMergedField('subject'), $et->getMergedBodyHtml());
                    }
                }
            }
            else {
                $this->smarty->assign('Error', $error);
            }
        }
    }


    // Вывод заказа на экран
    function fetch() {
        $tabs = array(
        0 => 'доставка в ТК',
        1 => 'доставка до города',
        2 => 'вручение',
        3 => 'товар доставлен',
        5 => 'в возврате. у ТК',
        6 => 'в возврате. у ЛС',
        7 => 'выполнен, ждет оплаты',
        8 => 'оплачен');

        $delivery_stats = array(
        0 => 'доставка в ТК',
        1 => 'доставка до города',
        2 => 'вручение',
        3 => 'товар доставлен',
        5 => 'в возврате. у ТК',
        6 => 'в возврате. у ЛС');

        $money_stats = array(
        0 => 'Не было оплаты по заказу',
        2 => 'Оплачен, деньги у ТК',
        3 => 'Деньги в Лакшери Стор');

        $statuses = array(
        0 => 'Новый',
        1 => 'В обработке',
        2 => 'Выполнен',
        3 => 'Отмена заказа',
        4 => 'Товар отсутствует',
        5 => 'Самовывоз',
        6 => 'Доставка');

        $this->title = 'Заказ №' . $this->order_id;

        // Ещё раз находим товар, с учётом обновлений
        $this->order = $this->get_order_by_id($this->order_id);

        $request_spsr = "/admin/index.php?section=Order&request_spsr=1&order_id={$this->order_id}&token={$this->token}";
        $this->smarty->assign('request_spsr', $request_spsr);

        // Найдем менеджеров
        $this->db->query("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 5 ORDER BY name;");
        $managers = $this->db->results();

        // Найдем менеджеров-логистов
        $this->db->query("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 5 AND subgroup_id = 3 ORDER BY name;");
        $logists = $this->db->results();

        // Сформируем массив способов доставки
        $query = "SELECT * FROM delivery_methods WHERE enabled ORDER BY delivery_method_id";
        $this->db->query($query);
        $delivery_methods = $this->db->results();
        foreach ($delivery_methods as $k=>$method) {
            $delivery_methods[$k]->final_price = $method->price;
            if ($method->free_from <= $this->order->amount) $delivery_methods[$k]->final_price = 0;
        }

        // Передаем их в шаблон
        $this->smarty->assign('DeliveryMethods', $delivery_methods);

        // Сформируем массив форм оплаты & Передаем их в шаблон
        $this->smarty->assign('PaymentMethods', $this->db->results("SELECT * FROM payment_methods WHERE enabled_admin ORDER BY payment_method_id"));

        // Сформируем массив транспортных компаний
        $this->smarty->assign('DeliveryCompanies', $this->db->results("SELECT * FROM delivery_companies WHERE active = '1' ORDER BY id"));

        // определить ТК
        $pref_delivery = $this->db->result("SELECT pref_delivery FROM users WHERE user_id = {$this->order->user_id}")->pref_delivery;
        $this->smarty->assign('U_companies', $this->db->results("SELECT * FROM delivery_companies WHERE active = '1' AND id IN ({$pref_delivery}) ORDER BY id"));

        //begin delivery agent
        $products_status_select = array( 0 => 'примерка', 2 => 'потеря ТК' );
        if (isset($_SESSION['delivery_agent']) || $_SESSION['user']->group_id == 2 || ($_SESSION['user']->group_id == 5 && $_SESSION['user']->subgroup_id == 3)) {
            $products_status_select = array(  0 => 'примерка', 5 => 'принят', 4 => 'возврат', 2 => 'потеря ТК'  );
        }

        // депозитный счет пользователя
        $deposit = $this->db->result("SELECT deposit FROM users WHERE user_id = {$this->order->user_id}")->deposit;
        $this->smarty->assign('deposit', $deposit);

        $comments = $this->db->results("SELECT order_comments.*, users.name
                                        FROM order_comments
                                        LEFT JOIN users ON order_comments.user_id = users.user_id
                                        WHERE order_comments.order_id = {$this->order->order_id} ORDER BY order_comments.date");
        if(!empty($this->order->city_id)){
            $city_comments = $this->db->results("SELECT city_comments.*, users.name
                                        FROM city_comments
                                        LEFT JOIN users ON city_comments.commenter_id = users.user_id
                                        WHERE city_comments.city_id = {$this->order->city_id} ORDER BY city_comments.date");
        }

        $this->smarty->assign('Manager_comment', $this->db->result("SELECT * FROM order_comments WHERE order_id = {$this->order->order_id} ORDER BY id DESC LIMIT 1"));
        $this->smarty->assign('Managers', $managers);
        $this->smarty->assign('Logists', $logists);
        $this->smarty->assign('events', $this->db->results("SELECT * FROM orders_events WHERE order_id = {$this->order->order_id}"));
        $this->smarty->assign('delivery_events', $this->db->results("SELECT * FROM order_delivery_events WHERE order_id = {$this->order->order_id}"));
        $this->smarty->assign('comments', $comments);
        $this->smarty->assign('city_comments', $city_comments);
        $this->smarty->assign('DeliveryStats', $delivery_stats);
        $this->smarty->assign('Tabs', $tabs);
        $this->smarty->assign('Group', $_SESSION['group']);
        $this->smarty->assign('MoneyStats', $money_stats);
        $this->smarty->assign('DelView', $this->order->delivery_status);
        if(isset($_SESSION['delivery_agent'])) {
            $this->smarty->assign('DeliveryAgent',$_SESSION['delivery_agent']);
        }
        //end delivery agent

        if (in_array($_SESSION['user']->original_user_id, array(4877,1330,10552,14,10405))){
            $show_partner = 1;
            $this->smarty->assign('show_partner', $show_partner);
        }
        $cur_hour = (int)date('H');
         if( $cur_hour > 8 && $cur_hour < 21){$this->smarty->assign('SCenabled', true);}

        $period_start = date("Y-m") . '-01 00:00:00';
        $period_end = date("Y-m") . '-31 23:59:59';
        $money_received = $this->db->result($sql="SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND `date` <= NOW() AND manager_id = '{$_SESSION['user']->user_id}' AND receipt_number = 0) AND status = 5")->total;
        $D_rate = $this->db->result("SELECT (SUM(price)/({$money_received}+SUM(price)))*100 AS rate  FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND `date` <= NOW() AND manager_id = '{$_SESSION['user']->user_id}' AND receipt_number = 0) AND status = 4")->rate;
        $p_manager_id = $this->db->result("SELECT p_manager_id FROM users WHERE user_id = {$this->order->user_id}")->p_manager_id;
        $manager_D_rate = $this->db->result("SELECT decline_rate FROM `users` WHERE user_id = '{$_SESSION['user']->user_id}'")->decline_rate;

        $can_process = false;
        if($D_rate < $manager_D_rate || $p_manager_id == $_SESSION['user']->user_id || $_SESSION['user']->group_id == 2) $can_process = true;

        $this->smarty->assign('can_process', $can_process);
        $this->smarty->assign('delivery_cities_main', $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;"));
        $this->smarty->assign('delivery_cities',      $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '0' ORDER BY city_name;"));
        $this->smarty->assign('products_statuses', $products_statuses);
        $this->smarty->assign('products_status_select', $products_status_select);
        $this->smarty->assign('cur_date', date('Y-m-d'));

        // И сам заказ передадим в шаблон
        // Этот заказ может быть из базы, а может быть и из $_post
        $this->smarty->assign('Order', $this->order);
        $this->body = $this->smarty->fetch('order.tpl');
    }

    /**
     * Возвращает заказ по id
     */
    function get_order_by_id($order_id)
    {
        // На всякий случай приводим к числу
        $order_id = intval($order_id);
        $query = sql_placeholder("SELECT orders.*,
                                     SUM(orders_products.price*orders_products.quantity) as amount,
                                     SUM(orders_products.price*orders_products.quantity)+orders.delivery_price as total_amount,
                                     DATE_FORMAT(orders.date, '%d.%m.%Y %H:%i') as date,
                                     DATE_FORMAT(orders.payment_date, '%d.%m.%Y %H:%i') as payment_date,
                                     delivery_methods.name as delivery_method,
                                     delivery_companies.name as delivery_company
                                FROM orders
                                   LEFT JOIN orders_products ON orders.order_id = orders_products.order_id
                                   LEFT JOIN delivery_methods ON orders.delivery_method_id = delivery_methods.delivery_method_id
                                   LEFT JOIN delivery_companies ON orders.delivery_company_id = delivery_companies.id
                                WHERE orders.order_id=?
                                GROUP BY orders.order_id
                                LIMIT 1", $order_id);
        $this->db->query($query);
        $order = $this->db->result();

        $order->delivery_date = strtotime($order->delivery_date) > time() ? date('Y-m-d', strtotime($order->delivery_date)) : '';

        if ($order) {
            if(!empty($order->coupon_code)){
                if($order->coupon_type == 'absolute'){
                    $order->discount_amount = max(0, $order->total_amount-$order->coupon_discount);
                } else {
                    $order->discount_amount = round($order->total_amount*(1-$order->coupon_discount/100), 2);
                }
            }

            // Все товары в этом заказе
            $query = sql_placeholder("SELECT orders_products.*, products.url as url, products.price as main_price, products.old_price, products.offline_price, products.small_image, products.large_image, products.model, deposit_history.id as deposit_id
                                        FROM orders_products
                                        LEFT JOIN products ON products.product_id=orders_products.product_id
                                        LEFT JOIN deposit_history ON deposit_history.order_product_id=orders_products.id
                                        WHERE orders_products.order_id=? ORDER BY orders_products.product_name, orders_products.id", $order_id);
            $tmp_products = $this->db->results($query);
            $order->region = $this->db->result($sql="SELECT region_name FROM `delivery_cities` WHERE city_id = {$order->city_id}")->region_name;

            $orders = new orders($order_id);
            $order->products = array();
            $order->accepted_amount = $order->returned_amount = 0;
            if ( is_array($tmp_products) && count($tmp_products) ) {
                foreach ($tmp_products as $k => $product) {
                    $order->products[$product->id] = $product;
                    $order->products[$product->id]->sizes = $orders->get_sizes4products($product->product_id);
                    $order->products[$product->id]->items = $this->db->results("SELECT * FROM items WHERE quantity != 0 AND product_id = {$product->product_id}");
                    $order->products[$product->id]->clone_url   = "/admin/index.php?section=Order&view=delivery&clone_product_id={$product->id}&order_id={$product->order_id}";
                    $order->products[$product->id]->delete_url  = "/admin/index.php?section=Order&view=delivery&delete_product_id={$product->id}&order_id={$product->order_id}";
                    if ( $product->old_price == 0){
                        $product->old_price = $this->db->result("SELECT new_price FROM `price_changes` WHERE product_id = '{$product->product_id}' ORDER BY date ASC LIMIT 1")->new_price;
                    }
                    if ( $product->old_price != 0){$p = $product->old_price;}
                    if ( $product->offline_price != 0){$p = $product->offline_price;}
                    else{$p = $product->main_price;}
                    if($product->status == 5) $order->accepted_amount += $product->price;
                    if($product->status == 4) $order->returned_amount += $product->price;
                    $order->products[$product->id]->sale    = round((($p-$product->price)*100)/$p, 2);
                    $size_system = $this->db->result("SELECT size_system, size_type FROM `items` WHERE product_id = {$product->product_id} AND size_system != '' LIMIT 1 ");
                    if (!empty($size_system->size_type)){
                      $user_sizes = $this->db->results($sql="SELECT size_id FROM `users2sizes_n` WHERE user_id = {$order->user_id} AND type_id = '{$size_system->size_type}' ");
                      if ( !empty($user_sizes) ) {
                        $order->products[$product->id]->u_sizes = array();
                        foreach($user_sizes as $us) {
                          if ($size_system->size_system != 'int' && $size_system->size_system != 'ru') $order->products[$product->id]->u_sizes[] = $this->db->result($sql="SELECT size FROM `size_names` WHERE size_id = {$us->size_id} AND size_m_s ='{$size_system->size_system}'  ")->size;
                          elseif ($size_system->size_system == 'int') $order->products[$product->id]->u_sizes[] = $this->db->result($sql="SELECT int_size FROM `sizes` WHERE size_id = {$us->size_id}")->int_size;
                          elseif ($size_system->size_system == 'ru') $order->products[$product->id]->u_sizes[] = $this->db->result("SELECT ru_size FROM `sizes` WHERE size_id = {$us->size_id} ")->ru_size;
                        }
                        $order->products[$product->id]->u_sizes = implode(',',$order->products[$product->id]->u_sizes);
                      }
                    }
                    else {$order->products[$product->id]->u_sizes = 1;}
                }
            }
        }
        return $order;
    }



    function log_order_status_change($order_id, $status) {
        $statuses = array(
            0 => 'Новый',
            1 => 'В обработке',
            2 => 'Выполнен',
            3 => 'Отмена заказа',
            4 => 'Товар отсутствует',
            5 => 'Самовывоз',
            6 => 'Доставка');
        $status = (int) $status;
        $text = "Статус заказа изменен на <b>{$statuses[$status]}</b> пользователем <b>{$_SESSION['user']->name}</b>";
        $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'order_status', '{$text}')");
        // Отправляем в слак
        $message = "Статус заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> изменен на {$statuses[$status]} пользователем {$_SESSION['user']->name}";
        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "orders_statuses" );
        Job::push('SlackJob', $args);
        if ($status == 6){
            $o_products = $this->db->results("SELECT sku FROM orders_products WHERE order_id = {$order_id} AND status != 1");
            $skus = "";
            foreach($o_products as $product){
                $skus .= "{$product->sku}, ";
            }
            $sum = $this->db->result("SELECT SUM(price) AS sum FROM orders_products WHERE order_id = {$order_id} AND status != 1")->sum;
            $order = $this->db->result("SELECT city, name, delivery_company_id FROM orders WHERE order_id = {$order_id}");
            $message = "Заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> отправлен в {$order->city} на имя {$order->name}. Товары артикул {$skus} общей стоимостью {$sum} р.";
            if ($order->delivery_company_id == 4){
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "pony_out" );
            }
            if ($order->delivery_company_id == 1){
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "spsr_out" );
            }
            if ($order->delivery_company_id == 5){
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "cdek_out" );
            }
            Job::push('SlackJob', $args);
        }
    }



    function log_delivery_status_change($order_id, $status) {
        $statuses = array(
            0 => 'доставка в ТК',
            1 => 'доставка до города',
            2 => 'вручение',
            3 => 'товар доставлен',
            4 => '4',
            5 => 'в возврате. у ТК',
            6 => 'в возврате. у ЛС');
        $text = "Статус доставки изменен на <b>{$statuses[$status]}</b> пользователем <b>{$_SESSION['user']->name}</b>";
        $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'delivery_status', '{$text}')");
        // Отправляем в слак
        $message = "Статус доставки заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> изменен на \"{$statuses[$status]}\" пользователем {$_SESSION['user']->name}";
        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "orders_statuses" );
        Job::push('SlackJob', $args);
    }


    function log_product_status_change($order_id, $status, $product_id) {
        $status = (int) $status;
        $products_statuses = array(  0 => 'примерка', 1 => 'отказ клиента', 2 => 'потеря ТК', 3 => 'нет товара', 4 => 'отказ и возврат', 5 => 'принят' );
        $o_product = $this->db->result("SELECT * FROM orders_products WHERE id = {$product_id}");
        $product = $this->db->result("SELECT price FROM products WHERE product_id = {$o_product->product_id}");
        $order = $this->db->result("SELECT money_status, partner_order, delivery_company_id, manager_id FROM orders WHERE order_id = {$order_id}");
        $manager = $this->db->result("SELECT name, slack_name FROM `users` WHERE `user_id` = '{$order->manager_id}'");
        $product_name = str_replace("'", "`", $o_product->product_name);

        $text = "Статус товара {$product_name} изменен на <b>{$products_statuses[$status]}</b> пользователем <b>{$_SESSION['user']->name}</b>";
        $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'product_status', '{$text}')");
        if ($status == 5){
            if ( $order->money_status != 2) {
                $this->db->query("UPDATE orders SET money_status = 2 WHERE order_id = {$order_id}");
                // Отправляем в слак
                $message = "Оплата заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> была передана в ТК";
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "money_with_tk" );
                Job::push('SlackJob', $args);
            }
            if ( $order->partner_order == 1) {
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "order_partners" );
                Job::push('SlackJob', $args);

                if($o_product->price != $product->price){
                    $d = $o_product->price - $product->price;
                    $price_text = ", изначальная цена {$product->price}";
                    //if($d >= 0){
                    //    $this->db->query("UPDATE orders_products SET price = {$product->price} WHERE id = {$product_id}");
                    //    $price_text .= " разница {$d}";
                    //}
                }
                $user = $this->db->result("SELECT user_id, name, phone_number FROM users WHERE user_id = {$o_product->user_id}");
                $message = "Здравствуйте!<br><br><br>
                        Клиентом <a href='https://lsboutique.ru/admin/index.php?section=User&user_id={$o_product->user_id}'>{$user->name}</a>(телефон {$user->phone_number})
                        был принят товар <a href='https://lsboutique.ru/products/{$o_product->product_id}'>{$o_product->product_name}</a>
                        из заказа <a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}'>#{$order_id}</a>
                        по цене {$o_product->price}{$price_text}.<br><br>
                        lsboutique.ru";
                $to = "delta@ooook.info, shesternin@gmail.com, ovtyukaeva@gmail.com";
                if($order->delivery_company_id == 5){$to .= ", oleg.klaus@mail.ru";}
                elseif($order->delivery_company_id == 7){$to .= ", v.usachev.sl@gmail.com";}
                $this->email($to, "Оповещение об изменении цены.", $message);
            }
        }
        if ($status == 4){
            $message = "Отказались от товара <https://lsboutique.ru/products/{$o_product->product_id}|{$o_product->product_name}> артикул {$o_product->sku} стоимостью {$o_product->price} из заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>, менеджер заказа {$manager->name} <@{$manager->slack_name}>";
            $channel = "items_rejected";
            $url = "https://hooks.slack.com/services/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";
            send_to_slack($message, $channel, $url);
            if ( $order->partner_order == 1) {
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "order_partners" );
                Job::push('SlackJob', $args);

                $user = $this->db->result("SELECT user_id, name, phone_number FROM users WHERE user_id = {$o_product->user_id}");
                $message = "Здравствуйте!<br><br><br>
                        Клиент <a href='https://lsboutique.ru/admin/index.php?section=User&user_id={$o_product->user_id}'>{$user->name}</a>(телефон {$user->phone_number})
                        отказался от товара <a href='https://lsboutique.ru/products/{$o_product->product_id}'>{$o_product->product_name}</a>
                        из заказа <a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}'>#{$order_id}</a>
                        по цене {$o_product->price}.<br><br>
                        lsboutique.ru";
                $to = "delta@ooook.info, shesternin@gmail.com, ovtyukaeva@gmail.com";
                $this->email($to, "Оповещение об отказе от товара.", $message);
            }
        }
        if ($status == 3 && $order->partner_order == 1) {
            $user = $this->db->result("SELECT user_id, name, phone_number FROM users WHERE user_id = {$o_product->user_id}");
            $message = "Здравствуйте!<br><br><br>
                    Нет в наличии товара <a href='https://lsboutique.ru/products/{$o_product->product_id}'>{$o_product->product_name}</a>
                    из заказа <a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}'>#{$order_id}</a>
                    клиента <a href='https://lsboutique.ru/admin/index.php?section=User&user_id={$o_product->user_id}'>{$user->name}</a>(телефон {$user->phone_number}).<br><br>
                    lsboutique.ru";
            $to = "delta@ooook.info, shesternin@gmail.com, ovtyukaeva@gmail.com";
            $this->email($to, "Оповещение об отказе от товара.", $message);
        }
    }
}
