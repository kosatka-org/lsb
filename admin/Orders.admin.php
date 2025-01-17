<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('Order.admin.php');
require_once('../placeholder.php');
require_once('../models/user.php');

############################################
# Class Orders
############################################
class Orders extends Widget {
    var $pages_navigation;
    var $items_per_page = 20;
    var $delivery_stats = array(
        0 => 'доставка в ТК',
        1 => 'доставка до города',
        3 => 'товар доставлен',
        5 => 'в возврате. у ТК',
        6 => 'в возврате. у ЛС',
        7 => 'выполнен, ждет оплаты',
        8 => 'оплачен');
    var $money_stats = array(
        0 => 'Не было оплаты по заказу',
        1 => 'Оплачен, деньги у партнера',
        2 => 'Оплачен, деньги у ТК',
        3 => 'Деньги в Лакшери Стор');
    var $products_statuses = array(  0 => 'примерка', 1 => 'отказ клиента', 2 => 'потеря ТК', 3 => 'нет товара', 4 => 'отказ и возврат', 5 => 'принят' );



    function Orders(&$parent) {
        parent::Widget($parent);
        $this->add_param('page');
        $this->add_param('view');
        $this->add_param('delayed');
        $this->add_param('packed');
        $this->add_param('delivery');
        $this->add_param('keyword');
        $this->pages_navigation = new PagesNavigation($this);
        $this->off_pages_navigation = new PagesNavigation($this);
        $this->prepare();
    }



    function find_orders($agent, $order_date, $delivery_status, $order_status='') {
        $query = "SELECT orders_products.order_id, orders.invoice_number, orders.delivery_date, SUBSTRING(orders.agreed_delivery_date, 1, 10) AS agreed_delivery_date, users.name AS manager_name
        FROM `orders_products`
        LEFT JOIN `orders` ON orders_products.order_id = orders.order_id
        LEFT JOIN users ON orders.manager_id = users.original_user_id
        WHERE orders_products.order_id IN (
            SELECT order_id
            FROM orders
            WHERE delivery_company_id = {$agent}
            AND status = 6
            AND {$order_date}
            AND {$delivery_status}
        )
        {$order_status}
        GROUP BY orders_products.order_id";
        $arr = $this->db->results($query);
        return $arr;
    }



    function find_total($agent, $delivery_status, $order_status) {
        $query = "SELECT SUM(price) AS total
            FROM `orders_products`
            WHERE order_id IN (
                SELECT order_id
                FROM orders
                WHERE delivery_company_id = {$agent}
                AND date > '2013-10'
                AND status = 6
                AND {$delivery_status}
            )
            AND {$order_status}";
        $this->db->query($query);
        $arr = $this->db->result();
        return $arr->total;
    }



    function get_city_total($city_id, $product_status = 'accepted') {
        if ($product_status == 'accepted') {
            $p_st = 5;
        }
        elseif ($product_status == 'rejected') {
            $p_st = 4;
        }
        return $this->db->result($sql="SELECT total
            FROM `cities_totals`
            WHERE city_id = {$city_id}
            AND status = {$p_st}")->total;

    }



    function get_order_by_id($order_id) {
        // На всякий случай приводим к числу
        $order_id = (int)$order_id;
        $query = sql_placeholder("SELECT orders.*,
                                     SUM(orders_products.price*orders_products.quantity) as amount,
                                     SUM(orders_products.price*orders_products.quantity)+orders.delivery_price as total_amount,
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


        if ($order) {
            // Все товары в этом заказе
            $query = sql_placeholder("SELECT orders_products.*, products.url as url, products.download as download
                                        FROM orders_products
                                        LEFT JOIN products ON products.product_id=orders_products.product_id
                                        WHERE orders_products.order_id=?
                                        ORDER BY orders_products.product_name, orders_products.id", $order_id);
            $this->db->query($query);
            $order->products = $this->db->results();
            if ( is_array($order->products) && count($order->products) ) {
                foreach ($order->products as $k=>$product) {
                    $order->products[$k]->clone_url     = "/admin/index.php?section=Order&view=delivery&clone_product_id={$product->id}&order_id={$product->order_id}&token={$this->token}";
                    $order->products[$k]->delete_url    = "/admin/index.php?section=Order&view=delivery&delete_product_id={$product->id}&order_id={$product->order_id}&token={$this->token}";
                }
            }
        }
        return $order;
    }

    function prepare() {
        // Удаление заказа
        if (isset($_GET['delete_id'])) {
            $this->check_token();

            $delete_id = intval($_GET['delete_id']);
            $query = sql_placeholder('SELECT * FROM orders WHERE order_id=? LIMIT 1', $delete_id);
            $this->db->query($query);
            $order = $this->db->result();

            // Можно удалять только неоплаченные заказы
            if ($order->payment_status == 0) {
                $this->db->query(sql_placeholder("DELETE FROM orders WHERE order_id = ? LIMIT 1", $order->order_id));
                $this->db->query(sql_placeholder("DELETE FROM orders_products WHERE order_id =?", $order->order_id));
                $get = $this->form_get(array());
                header("Location: index.php$get");
            }
        }

        // Изменение статуса заказа
        if (isset($_GET['change_status_id'])) {
            $this->check_token();

            $change_status_id = intval($this->param('change_status_id'));
            $new_status       = intval($this->param('new_status'));

            $order = $this->get_order_by_id($change_status_id);

            // Если статус заказа изменился
            if ( $order->status != $new_status ) {
                $statuses = array(  0 => 'Новый', 1 => 'В обработке', 2 => 'Выполнен', 3 => 'Отказ клиента',
                                    4 => 'Товар отсутствует', 5 => 'Самовывоз', 6 => 'Доставка');
                if ( $new_status == 1 ) {
                    $old_manager_id = $this->db->result("SELECT manager_id FROM orders WHERE order_id = {$change_status_id}")->manager_id;
                    if ($old_manager_id == 0){
                        $this->db->query("UPDATE orders SET manager_id = {$_SESSION['user']->user_id} WHERE order_id = {$change_status_id}");
                        $text = "Автоназначение! Назначен менеджер заказа <b>{$_SESSION['user']->name}</b>";
                        $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$change_status_id}, {$_SESSION['user']->user_id}, 'manager', '{$text}')");
                        $manager = $this->db->result("SELECT name, slack_name FROM users WHERE user_id = {$_SESSION['user']->user_id}");
                        $message = "Заказу #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$change_status_id}|{$change_status_id}> назначен менеджер {$_SESSION['user']->name} <@{$manager->slack_name}>";
                        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "order_manager_change" );
                        Job::push('SlackJob', $args);
                    }

                }
                if ( $new_status == 2 ) {
                    //$message = "{USERNAME}, благодарим Вас за удачную покупку! Ваш Лакшери Стор www.lsboutique.ru, по любым вопросам звоните 88003332138.";
                    if($_COOKIE['language'] == 'eng'){$message = "{USERNAME}, thank you for your successful purchase! Your Luxury Store www.lsboutique.ru. Please leave a review about our work on Yandex Market - http://www.ls.net.ru/market";}
                    else{$message = "{USERNAME}, благодарим Вас за удачную покупку! Ваш Лакшери Стор www.lsboutique.ru. Пожайлуста оставьте отзыв о нашей работе на Яндекс Маркет - http://www.ls.net.ru/market";}
                    $message = str_replace(array('{USERNAME}'), array($order->name), $message);
                    $args = array( 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $order->phone, 'user_id' => $order->user_id );
                    Job::push( 'SmsJob', $args, false, 'critical' );
                }
                if ( $new_status == 3 ) {
                    $fault_reason       = $this->param('fault_reason');
                    $date_check = $this->db->result("SELECT date_to_decline FROM `orders` WHERE order_id = '{$change_status_id}'")->date_to_decline;
                    if ( empty((int)$date_check)) {
                        $this->db->query($sql="UPDATE `orders` SET date_to_decline = NOW(), fault_reason = '{$fault_reason}' WHERE order_id = '{$change_status_id}'");
                    }
                }
                $query = sql_placeholder('UPDATE orders SET status=?, last_update = NOW() WHERE order_id=?', $new_status, $change_status_id);
                $this->db->query($query);
                $text = "Статус заказа изменен на <b>{$statuses[$new_status]}</b> пользователем <b>{$_SESSION['user']->name}</b>";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$change_status_id}, {$_SESSION['user']->user_id}, 'order_status', '{$text}')");
                // Отправляем в слак
                $message = "Статус заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order->order_id}|{$order->order_id}> изменен на {$statuses[$new_status]} пользователем {$_SESSION['user']->name}";
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "orders_statuses" );
                Job::push('SlackJob', $args);
            }


            //Отмечаем выполненные заказы
            $query = "UPDATE orders
                SET status = 2
                WHERE money_status = 3
                    AND status = 6
                    AND money_received = 1
                    AND (delivery_status = 3 OR (delivery_status = 6 AND products_received = 1));

                UPDATE orders o
                LEFT JOIN orders_products op ON o.order_id = op.order_id AND op.status = 5
                SET o.status = 2
                WHERE o.money_status = 0
                    AND o.delivery_status = 6
                    AND o.status = 6
                    AND o.products_received = 1
                    AND o.money_received = 0
                    AND op.id IS NULL;";
            $this->db->query($query);
        }

        // Применение скидки
        if ( isset($_GET['apply_discount']) && isset($_GET['discount_order'])) {
            $discount = abs( intval($_GET['apply_discount']) );
            $order_id = intval($_GET['discount_order']);
            if ($discount) {
                $query = "UPDATE `orders_products` op LEFT JOIN products p ON op.product_id = p.product_id";

                if (isset($_GET['initial'])) {
                    $query .= " SET op.price = p.price * ((100-{$discount})/100) ";
                }
                else {
                    $query .= " SET op.price = op.price * ((100-{$discount})/100) ";
                }
                $query .= " WHERE op.order_id = {$order_id} ";
                    $this->db->query($query);
                    $name = $_SESSION['user']->name;
                    mail('mail@lsboutique.ru', "Добавлена скидка для заказа №{$order_id}",
                        "Администратор {$name} установил скидку {$discount}% для заказа №{$order_id}\nhttps://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}");
            }
        }

        // Копия товара
        if ( isset($_GET['duplicate_order_product_id']) ) {
            $op_id = intval($_GET['duplicate_order_product_id']);
            if ($op_id) {
                $query = "INSERT INTO `orders_products` (`order_id`, `user_id`, `product_id`, `status`, `status_date`, `barcode`, `product_name`, `price`, `quantity`, `size`, `item_location`, `sku`, `new_order`) SELECT `order_id`, `user_id`, `product_id`, `status`, `status_date`, `barcode`, `product_name`, `price`, `quantity`, `size`, `item_location`, `sku`, `new_order` FROM `orders_products` WHERE id={$op_id};";
                $this->db->query($query);
                $data = $this->db->result("SELECT order_id, product_name, product_id, one_click_id FROM orders_products WHERE id = {$op_id}");
                $text = "<b>{$_SESSION['user']->name}</b> клонировал товар {$data->product_name}";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$data->order_id}, {$_SESSION['user']->user_id}, 'product_clone', '{$text}')");
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
            }
        }

        // Удаление товара
        if ( isset($_GET['delete_order_product_id']) ) {
            $op_id = intval($_GET['delete_order_product_id']);
            if ($op_id) {
                $product = $this->db->result("SELECT order_id, product_id, product_name, size, one_click_id FROM orders_products WHERE id = {$op_id}");
                $query = "DELETE FROM orders_products WHERE id = {$op_id};";
                $this->db->query($query);
                $text = '<b>'.$_SESSION['user']->name.'</b> удалил из заказа товар <a href="/products/'.$product->product_id.'" target="_blank">'.$product->product_name.'</a> размер '.$product->size.'.';
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$product->order_id}, {$_SESSION['user']->user_id}, 'product_del', '{$text}')");
                if (!empty($product->one_click_id)){
                    $datacheck = $this->db->result("SELECT cr_manager FROM one_click WHERE id = {$product->one_click_id}")->cr_manager;
                }
                else{
                   $datacheck = $this->db->result("SELECT cr_manager FROM orders WHERE order_id = {$product->order_id}")->cr_manager;
                }
                if(empty($datacheck)){
                    // Отправляем в слак
                    $message = "{$_SESSION['user']->name} удалил товар <https://lsboutique.ru/products/{$product->product_id}|{$product->product_name}> в заказе #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$product->order_id}|{$product->order_id}>";
                    $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "price_change_log" );
                    Job::push('SlackJob', $args);
                }
            }
        }

        // Упаковка товара
        if ( isset($_GET['pack_order']) || isset($_GET['unpack_order']) ) {
            $order_id = intval($_GET['pack_order']);
            if (!$order_id) {
              $order_id = intval($_GET['unpack_order']);
            }
            $packed = isset($_GET['pack_order']) ? 1 : 0;
            if ($order_id) {
                $query = "UPDATE orders SET packed = {$packed} WHERE order_id = {$order_id};";
                $this->db->query($query);
                if($packed == 1){
                    $text = "Пользователь <b>{$_SESSION['user']->name}</b> поставил статус <b>отправляем</b>";
                    $message = "Для заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> поставлен статус 'отправляем' пользователем {$_SESSION['user']->name}";
                }else{
                    $text = "Пользователь <b>{$_SESSION['user']->name}</b> убрал статус <b>отправляем</b>";
                    $message = "Для заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}> убран статус 'отправляем' пользователем {$_SESSION['user']->name}";
                }
                // Отправляем в слак
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "orders_statuses" );
                Job::push('SlackJob', $args);

                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, {$_SESSION['user']->user_id}, 'pack_status', '{$text}')");
            }
            die('ok');
        }

        // Перемещение товаров из одного заказа в другой
        if ( isset($_GET['move_products_order']) ) {
            $order_id = intval($_GET['move_products_order']);
            $dest_id  = intval($_GET['destination_order_id']);
            if ($order_id && $dest_id) {
                $query = "UPDATE orders_products SET order_id = {$dest_id} WHERE order_id = {$order_id};";
                $this->db->query($query);
            }
        }

        // Изменение цены товара
        if ( isset($_GET['change_price_product']) ) {
            $op_id = intval($_GET['change_price_product']);
            $price = floatval($_GET['price']);
            if ($op_id && $price) {
                $product = $this->db->result("SELECT order_id, product_name, price, product_id, one_click_id FROM orders_products WHERE id = {$op_id};");
                $query = "UPDATE orders_products SET price = {$price} WHERE id = {$op_id};";
                $this->db->query($query);

                $text = "Пользователь <b>{$_SESSION['user']->name}</b> изменил цену товара {$product->product_name} с {$product->price} р на {$price} р";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$product->order_id}, {$_SESSION['user']->user_id}, 'price_change', '{$text}')");

                $message = "{$_SESSION['user']->name} <@{$_SESSION['user']->slack_name}> изменил цену на товар <https://lsboutique.ru/admin/index.php?section=Product&item_id={$product->product_id}|{$product->product_name}> в заказе #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$product->order_id}|{$product->order_id}> с {$product->price} р на {$price} р";
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
        }

        // Изменение цены доставки
        if ( isset($_GET['change_delivery_price']) ) {
            $order_id = intval($_GET['change_delivery_price']);
            $price = floatval($_GET['price']);
            if ($order_id && $price) {
                $query = "UPDATE orders SET delivery_price = {$price} WHERE order_id = {$order_id};";
                $this->db->query($query);
            }
        }
    }

  function fetch() {
    $this->title = $this->lang->ORDERS;
    $current_page = intval($this->param('page'));

    $view = $this->param('view');
    if(empty($view))
      $view = 'new';


    $filter = '';



    $del_view   = $this->param('delivery');
    $show_stats = ($this->param('delivery') == 'stats') ? 1 : 0;
    $delivery   = $del_view;
    if(empty($del_view))
      $del_view = 0;

    if (isset($_SESSION['delivery_agent'])) {
      $filter .= 'AND orders.status != 3 AND orders.delivery_company_id='.$_SESSION['delivery_agent'];
      if ($delivery == 7) {
        $filter .= ' AND orders.delivery_status IN (3,6) AND orders.money_status = 3 AND orders.delivery_paid = 0 AND orders.delivery_agent_price > 0';
      }
      elseif ($delivery == 8) {
        $filter .= ' AND orders.delivery_status IN (3,6) AND orders.money_status = 3 AND orders.delivery_paid = 1 AND orders.delivery_agent_price > 0';
      }
      elseif ($delivery == 3) {
        $filter .= ' AND orders.delivery_status = 3 AND orders.money_received = 0';
      }
      elseif ($delivery != "search") {
        $filter .= ' AND orders.delivery_status='.$del_view;
      }
      $view = '';
    }

    if($view == 'new' || $view == 'filter')
      $filter .= 'AND orders.status=0';

    if($view == 'cancel')
      $filter .= 'AND orders.status IN (3,4)';

    if ($view == 'process') {
        $filter .= 'AND orders.status=1';
        if ($this->param('delayed')) {
            $filter .= ' AND orders.delayed = 1 ';
            $this->smarty->assign("delayed", 1);
        }
        elseif ($this->param('packed')) {
            $filter .= ' AND orders.packed = 1 AND orders.delayed IN (0,1) ';
            $order_by = " ORDER BY orders.delivery_company_id ASC ";
            $this->smarty->assign("packed", 1);
        }
        else {
            $filter .= ' AND orders.delayed = 0 AND orders.packed = 0 ';
        }
    }

    if($view == 'return')
      $filter .= 'AND orders_products.status=1';

    if($view == 'done')
      $filter .= 'AND orders.status IN (2,6) AND orders.cashbox_id = 0 AND (NOT EXISTS (SELECT 1 FROM orders_products op WHERE op.order_id = orders.order_id AND op.status = 0))';

    if($view == 'delivery')
      $filter .= 'AND orders.status=6 AND orders.cashbox_id = 0 AND (EXISTS (SELECT 1 FROM orders_products op WHERE op.order_id = orders.order_id AND op.status = 0))';

    if($view == 'pickup')
      $filter .= 'AND orders.status=5';

    $dk = $this->param('delivery_keyword');
    if($view == 'search' || !empty($dk)) {
      $keyword = mysql_real_escape_string($this->param('keyword'));
      if (!empty($dk)) {
        $keyword = $dk;
      }
      if(!empty($keyword)) {
        if(substr($keyword, 0, 5) == 'user:') {
          $user_id = intval(substr($keyword, 5, strlen($keyword)-5));
          $filter .= " AND (orders.user_id = '{$user_id}')";
          $off_filter .= " AND (pr.user_id = '{$user_id}')";
        }
        elseif (substr($keyword, 0, 6) == 'order:') {
          $order_id = intval(substr($keyword, 6, strlen($keyword)-6));
          $filter .= " AND (orders.order_id = '{$order_id}')";
        }
        elseif (substr($keyword, 0, 6) == 'promo:') {
            $coupon_code = substr($keyword, 6, strlen($keyword)-6);
            $filter .= " AND (orders.coupon_code = '{$coupon_code}')";
        }
        else {
            $filter .= " AND (orders.order_id = '{$keyword}' ";
            $off_filter .= " AND pr.user_id = 1";
            $user_filter = " user_id = 1 ";

            $keywords = preg_split('/[\s]+/', $keyword);
            foreach($keywords as $tmp_keyword) if (!empty($tmp_keyword)) {
                $tmp_keyword = mysql_real_escape_string($tmp_keyword);
                $filter .= "
                    OR orders.name LIKE '%{$tmp_keyword}%'
                    OR orders.phone LIKE '%{$tmp_keyword}%'
                    OR orders.invoice_number LIKE '%{$tmp_keyword}%'
                    OR orders.return_invoice_number LIKE '%{$tmp_keyword}%'
                    OR orders.delivery_code LIKE '%{$tmp_keyword}%'
                    OR orders.email LIKE '%{$tmp_keyword}%'
                    OR orders.address LIKE '%{$tmp_keyword}%'";
                $user_filter .= " OR name LIKE '%{$tmp_keyword}%'
                OR phone_number LIKE '%{$tmp_keyword}%'
                OR email LIKE '%{$tmp_keyword}%'
                OR adress LIKE '%{$tmp_keyword}%'";
            }

            // Поиск по покупкам
            $tmp_users = $this->db->results(" SELECT user_id FROM users WHERE {$user_filter} ");
            if ( is_array($tmp_users) && count($tmp_users) > 0 ) {
                $off_filter .= " OR pr.user_id IN (1 ";
                foreach ( $tmp_users AS $tmp_user ) {
                    $off_filter .= ", {$tmp_user->user_id}";
                }
                $off_filter .= " )";
            }
            $off_filter .= " OR pr.sku LIKE '%{$keyword}%'
                            OR pr.model LIKE '%{$keyword}%'";

            // Поиск по продуктам
            $tmp_orders = $this->db->results(" SELECT order_id FROM orders_products WHERE sku LIKE '%{$keyword}%' OR product_name LIKE '%{$keyword}%' OR barcode LIKE '%{$keyword}%' ");
            if ( is_array($tmp_orders) && count($tmp_orders) > 0 ) {
                $filter .= " OR orders.order_id IN (0 ";
                foreach ( $tmp_orders AS $tmp_order ) {
                    $filter .= ", {$tmp_order->order_id}";
                }
                $filter .= " )";
            }
            $filter .= ")";
        }
      }
      else {
        $filter .= " AND 1 = 2 ";
        $off_filter .= " AND 1 = 2 ";
      }
    }

    $city_filter = '';
    if($view == 'new' || $view == 'filter' || !isset($view)) {
      switch ($_SESSION['user']->workcity_id){
        case 992:
          $city_filter = ' AND (orders.city_id = 992 OR orders.city_id = 0)';
          break;
        case 1054:
          $city_filter = ' AND orders.city_id != 992';
          break;
      }
    }


    if($this->param('login')) {
      $filter .= 'AND orders.login = "'.$this->param('login').'"';
    }

    #### Выборка заказов
    $start_item = $current_page*$this->items_per_page;
    if ($order_by) {
      $order_sql = $order_by;
    }
    else {
      $order_sql = " ORDER BY orders.order_id DESC ";
    }
    $sql = "SELECT SQL_CALC_FOUND_ROWS orders.*,
              DATE_FORMAT(orders.date, '%d.%m.%Y %k:%i') as date,
              SUM(orders_products.price*orders_products.quantity)+orders.delivery_price as total_amount, delivery_companies.name AS delivery_company, users.name AS user_name, users.user_status AS user_status, users.last_login_date, users.last_api_login_date, users.card_number, users.purchase_sum_real, users.p_manager_id, users.email AS user_email, users.pref_messenger, users.pref_delivery_methods, users.adress AS user_adress, users.sex AS user_sex, users.birth_date AS birth_date, PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'),DATE_FORMAT(users.card_registered,'%Y%m')) AS user_age, special_orders.so_id
                FROM orders
                LEFT JOIN delivery_companies ON delivery_companies.id = orders.delivery_company_id
                LEFT JOIN orders_products ON orders.order_id = orders_products.order_id
                LEFT JOIN users ON orders.user_id = users.user_id
                LEFT JOIN special_orders ON orders.order_id = special_orders.order_id
              WHERE 1 {$filter} {$city_filter}
              GROUP BY orders.order_id
              {$order_sql}
              LIMIT {$start_item}, {$this->items_per_page}";
    $orders = $this->db->results($sql);

    $finds_num = $this->db->result("SELECT FOUND_ROWS() as count;");
    $pages_num = $finds_num->count/$this->items_per_page;

    $period_start = date("Y-m") . '-01 00:00:00';
    $period_end = date("Y-m") . '-31 23:59:59';
    $money_received = $this->db->result($sql="SELECT COALESCE(SUM(price), 0) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND manager_id = '{$_SESSION['user']->user_id}' AND receipt_number = 0) AND status = 5")->total;
    $D_rate = $this->db->result($sql="SELECT COALESCE((SUM(price)/({$money_received}+SUM(price)))*100, 0) AS rate  FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND manager_id = '{$_SESSION['user']->user_id}' AND receipt_number = 0) AND status = 4")->rate;
    $manager_D_rate = $this->db->result("SELECT decline_rate FROM `users` WHERE user_id = '{$_SESSION['user']->user_id}'")->decline_rate;

    foreach ($orders as $k=>$order) {

        if(!empty($order->coupon_code)){
            if($order->coupon_type == 'absolute'){
                $orders[$k]->total_amount = max(0, $order->total_amount-$order->coupon_discount);
            }else{
                $orders[$k]->total_amount = round($order->total_amount*(1-$order->coupon_discount/100), 2);
            }
        }

        $purchase_sum_off    = (int)$this->db->result("SELECT SUM(sum_with_discount) as P_sum_off FROM prodazhi WHERE OR user_id = '{$order->user_id}'")->sum;
        $purchase_sum_online = (int)$this->db->result(sql_placeholder("SELECT SUM(price) AS sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.user_id = ? AND op.status = 5", $order->user_id))->sum;
        $orders[$k]->total_purchase_sum = $purchase_sum_off + $purchase_sum_online;
        if($order->purchase_sum_real > $orders[$k]->total_purchase_sum){
            $orders[$k]->total_purchase_sum = $user->purchase_sum_real;
        }

        $orders[$k]->comments = $this->db->results("SELECT order_comments.*, users.name
                                        FROM order_comments
                                        LEFT JOIN users ON order_comments.user_id = users.user_id
                                        WHERE order_comments.order_id = {$order->order_id} ORDER BY order_comments.date");
        if(!empty($order->city_id)){
            $orders[$k]->city_comments = $this->db->results("SELECT city_comments.*, users.name
                                        FROM city_comments
                                        LEFT JOIN users ON city_comments.commenter_id = users.user_id
                                        WHERE city_comments.city_id = {$order->city_id} ORDER BY city_comments.date");
        }
        if(!empty($order->user_id)){
            $user = $this->db->result("SELECT * FROM `users` WHERE user_id = '{$order->user_id}' LIMIT 1");
            $orders[$k]->user_comments = $this->db->results("SELECT user_comments.*, users.name
                                        FROM user_comments
                                        LEFT JOIN users ON user_comments.commenter_id = users.user_id
                                        WHERE user_comments.user_id = {$order->user_id} ORDER BY user_comments.date");
            if($view == 'filter'){
              $user_measurments = $this->db->results($sql="SELECT * FROM `users_measuring` WHERE user_id ={$user->user_id}");
              $mcat = array();
              foreach($user_measurments as $um) {
                $mcat[] = $um->category_id;
                $um->fitting = explode(',',$um->fitting);
                $um->stretch = explode(',',$um->stretch);
                $user_measurments[$um->category_id] = $um;
              }
            }
            if(empty($user->user_id)){unset($order->user_id);}
          
            if($user->p_manager_id){
                $orders[$k]->users_p_manager = $this->db->result("SELECT name FROM `users` WHERE user_id = '{$user->p_manager_id}'")->name;
            }
        }

        $orders[$k]->set_to_process_url = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>1, 'token'=>$this->token));
        $orders[$k]->set_to_fail_url    = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>3, 'token'=>$this->token));
        $orders[$k]->set_done_url       = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>2, 'token'=>$this->token));
        $orders[$k]->edit_url           = $this->form_get(array('section'=>'Order', 'order_id'=>$order->order_id, 'view'=>$this->param('view'), 'page'=>$this->param('page'), 'token'=>$this->token));
        $orders[$k]->delete_url         = $this->form_get(array('delete_id'=>$order->order_id, 'token'=>$this->token));
        $products = $this->db->results("
            SELECT op.*, p.quantity as stock, p.category_id, p.url as url, p.old_price, p.offline_price, p.price, op.price as sale_price, p.large_image as image, p.season, p.season_type
              FROM orders_products op
              LEFT JOIN products p ON p.product_id = op.product_id
            WHERE op.order_id = '{$order->order_id}'
            ORDER BY op.status, op.product_name, op.id");

        $orders[$k]->money_sum  = $this->db->result("SELECT SUM(price*quantity) AS total FROM `orders_products` WHERE order_id = '{$order->order_id}' AND status = 5");
        $orders[$k]->return_sum = $this->db->result("SELECT SUM(price*quantity) AS total FROM `orders_products` WHERE order_id = '{$order->order_id}' AND status = 4");
        $orders[$k]->user_return_rate = luser::get_return_rate($order->user_id);
        $orders[$k]->city_accepted = $this->get_city_total($orders[$k]->city_id, 'accepted');
        $orders[$k]->city_rejected = $this->get_city_total($orders[$k]->city_id, 'rejected');
        $orders[$k]->manager_name  = $this->db->result("SELECT name FROM `users` WHERE user_id = '{$order->manager_id}'")->name;

        $orders[$k]->can_process = false;
        if($D_rate < $manager_D_rate || $order->p_manager_id == $_SESSION['user']->user_id || $_SESSION['user']->group_id == 2) $orders[$k]->can_process = true;

        foreach ( $products as $kk => $v ) {
            if($view == 'filter' && in_array($v->category_id,$mcat)){
              $products[$kk]->warning = luser::check_measurments($user_measurments,$v);
            }
            $products[$kk]->measurings = $this->db->result($sql="SELECT im.*, f.name AS fitting, ms.name AS stretch, ms.stretch AS koef
                                        FROM `items_measuring` im
                                        LEFT JOIN products p ON im.product_id = p.product_id
                                        LEFT JOIN items i ON im.item_id = i.item_id
                                        LEFT JOIN fitting f ON f.id = p.fitting
                                        LEFT JOIN materials_stretch ms ON ms.id = p.stretch
                                        WHERE i.barcode = '{$v->barcode}'");
            $season_types = [
              'old_seasons' => 'старый сезон',
              'previous_season' => 'прошлый сезон',
              'new_season' => 'новый сезон',
              'next_season' => 'следующий сезон'
            ];
            $products[$kk]->season_type = $season_types[$products[$kk]->season_type];

            if ( !empty($v->status) && !empty($this->products_statuses[$v->status])){
                $products[$kk]->status = $this->products_statuses[$v->status];
            }
            if ( $v->old_price == 0){
                $v->old_price = $this->db->result("SELECT new_price FROM `price_changes` WHERE product_id = '{$v->product_id}' ORDER BY date ASC LIMIT 1")->new_price;
            }
            if ( $v->old_price != 0){$p = $v->old_price;}
            if ( $v->offline_price != 0){$p = $v->offline_price;}
            else{$p = $v->price;}
            $products[$kk]->sale    = round((($p-$v->sale_price)*100)/$p, 2);
            if ( $v->currency != "rub" ){
                $products[$kk]->currency_sign = $this->db->result("SELECT sign FROM `currencies` WHERE code = '".strtoupper($v->currency)."'")->sign;
                $products[$kk]->old_price_conv = round($v->old_price/$v->currency_rate,2);
                $products[$kk]->offline_price_conv = round($v->offline_price/$v->currency_rate,2);
                $products[$kk]->sale_price_conv = round($v->sale_price/$v->currency_rate,2);
                $products[$kk]->price_conv = round($v->price/$v->currency_rate,2);
                $orders[$k]->total_amount_conv = round($orders[$k]->total_amount/$v->currency_rate,2);
                $orders[$k]->currency_sign = $products[$kk]->currency_sign;
            }
            $size_system = $this->db->result("SELECT size_system, size_type FROM `items` WHERE product_id = {$v->product_id} AND size_system != '' LIMIT 1 ");
            if (!empty($size_system->size_type)){
              $user_sizes = $this->db->results($sql="SELECT size_id FROM `users2sizes_n` WHERE user_id = {$order->user_id} AND type_id = '{$size_system->size_type}' ");
              if ( !empty($user_sizes) ) {
                $v->u_sizes = array();
                foreach($user_sizes as $us) {
                  if ($size_system->size_system != 'int' && $size_system->size_system != 'ru') $v->u_sizes[] = $this->db->result($sql="SELECT size FROM `size_names` WHERE size_id = {$us->size_id} AND size_m_s ='{$size_system->size_system}'  ")->size;
                  elseif ($size_system->size_system == 'int') $v->u_sizes[] = $this->db->result($sql="SELECT int_size FROM `sizes` WHERE size_id = {$us->size_id}")->int_size;
                  elseif ($size_system->size_system == 'ru') $v->u_sizes[] = $this->db->result("SELECT ru_size FROM `sizes` WHERE size_id = {$us->size_id} ")->ru_size;
                }
                $v->u_sizes = implode(',',$v->u_sizes);
              }
            }
            else {$v->u_sizes = 1;}
        }
        $orders[$k]->products = $products;
    }

    if ($show_stats) {
        $res->delagent = $_SESSION['delivery_agent'];
        $prods = $this->db->results("SELECT orders_products.price AS price, orders_products.sku AS sku, orders_products.order_id AS order_id, products.url AS url FROM orders_products LEFT JOIN products ON orders_products.product_id = products.product_id WHERE orders_products.sku != ''");
        $orderlist = array();
        foreach ($prods as $v) {
            if (!empty($orderlist[$v->order_id])) {
                $orderlist[$v->order_id]["skus"]  = $orderlist[$v->order_id]["skus"] .= ', <a href="https://lsboutique.ru/products/'.$v->url.'/" target="_blank">'.$v->sku.'</a>';
                $orderlist[$v->order_id]["value"] = $orderlist[$v->order_id]["value"] + $v->price;
            }
            else {
                $orderlist[$v->order_id] = array("skus" => '<a href="https://lsboutique.ru/products/'.$v->url.'/" target="_blank">'.$v->sku.'</a>', "value" => $v->price);
            }
        }
        $res->orderlist = $orderlist;

        $dates_array = array(
            "green"  => "((last_update > DATE_SUB(CURDATE(), INTERVAL 5 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date > DATE_SUB(CURDATE(), INTERVAL 5 DAY)))",
            "yellow" => "((last_update < DATE_SUB(CURDATE(), INTERVAL 5 DAY) AND last_update > DATE_SUB(CURDATE(), INTERVAL 10 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date < DATE_SUB(CURDATE(), INTERVAL 5 DAY) AND date > DATE_SUB(CURDATE(), INTERVAL 10 DAY)))",
            "red"    => "((last_update > '2013-10' AND last_update < DATE_SUB(CURDATE(), INTERVAL 10 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date > '2013-10' AND date < DATE_SUB(CURDATE(), INTERVAL 10 DAY)))"
        );

        $res->orders_to_client = $this->find_total($res->delagent, "delivery_status IN (0,1,2)", "status = 0");

        $res->to_client_list_blue   = $this->find_orders($res->delagent, 1, "delivery_status IN (0,1,2) AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW()", "AND orders_products.status = 0");
        $res->to_client_list_D_red  = $this->find_orders($res->delagent, 1, "delivery_status IN (0,1,2) AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW()", "AND orders_products.status = 0");
        $res->to_client_list_red    = $this->find_orders($res->delagent, $dates_array['red'], 'delivery_status IN (0,1,2) AND agreed_delivery_date = 0', 'AND orders_products.status = 0');
        $res->to_client_list_yellow = $this->find_orders($res->delagent, $dates_array['yellow'], 'delivery_status IN (0,1,2) AND agreed_delivery_date = 0', 'AND orders_products.status = 0');
        $res->to_client_list_green  = $this->find_orders($res->delagent, $dates_array['green'], 'delivery_status IN (0,1,2) AND agreed_delivery_date = 0', 'AND orders_products.status = 0');

        $res->orders_to_ls = $this->find_total($res->delagent, "delivery_status = 5", "status = 4");

        $res->to_ls_list_red    = $this->find_orders($res->delagent, $dates_array['red'], 'delivery_status = 5', 'AND orders_products.status = 4');
        $res->to_ls_list_yellow = $this->find_orders($res->delagent, $dates_array['yellow'], 'delivery_status = 5', 'AND orders_products.status = 4');
        $res->to_ls_list_green  = $this->find_orders($res->delagent, $dates_array['green'], 'delivery_status = 5', 'AND orders_products.status = 4');

        $res->money_at_partners = $this->find_total($res->delagent, "money_status = 1 AND money_received = 0", "status = 5");

        $res->partners_list_red    = $this->find_orders($res->delagent, $dates_array['red'], 'money_status = 1 AND money_received = 0');
        $res->partners_list_yellow = $this->find_orders($res->delagent, $dates_array['yellow'], 'money_status = 1 AND money_received = 0');
        $res->partners_list_green  = $this->find_orders($res->delagent, $dates_array['green'], 'money_status = 1 AND money_received = 0');

        $res->money_at_agent = $this->find_total($res->delagent, "money_status = 2 AND money_received = 0", "status = 5");

        $res->agent_list_red    = $this->find_orders($res->delagent, $dates_array['red'], 'money_status = 2 AND money_received = 0');
        $res->agent_list_yellow = $this->find_orders($res->delagent, $dates_array['yellow'], 'money_status = 2 AND money_received = 0');
        $res->agent_list_green  = $this->find_orders($res->delagent, $dates_array['green'], 'money_status = 2 AND money_received = 0');

        $query = "SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE delivery_company_id = {$del_agent_id} AND date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH)) AND status = 5";
        $this->db->query($query);
        $arr = $this->db->result();
        $res->money_received = $arr->total;

        $query = "SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE delivery_company_id = {$del_agent_id} AND date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH)) AND status = 4";
        $this->db->query($query);
        $arr = $this->db->result();
        $res->money_returns = $arr->total;

        $query = "SELECT SUM( delivery_agent_price ) AS total FROM  `orders` WHERE date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH)";
        $this->db->query($query);
        $arr = $this->db->result();
        $res->delivery_total = $arr->total;
    }

    $this->off_pages_navigation->fetch($off_pages_num);
    $this->pages_navigation->fetch($pages_num);
    $this->smarty->assign('DeliveryStats', $this->delivery_stats);
    $this->smarty->assign('MoneyStats',    $this->money_stats);
    $this->smarty->assign('prodazhi',      $prodazhi);
    $this->smarty->assign('off_finds_num', $off_finds_num->count);
    $this->smarty->assign('finds_num',     $finds_num->count);

    if (isset($res)) {
    $this->smarty->assign('Results', $res);
  }
  else {
    $this->smarty->assign('Orders', $orders);
  }
    if (isset($_GET['tk_del'])) {
        $this->smarty->assign('tk_del',1);
    }

    $this->smarty->assign('View', $view);
    $this->smarty->assign('DelView', $del_view);
    $this->smarty->assign('off_PagesNavigation', $this->off_pages_navigation->body);
    $this->smarty->assign('PagesNavigation',     $this->pages_navigation->body);
    $this->smarty->assign('Lang', $this->lang);
    $this->smarty->assign('cur_hour', (int)date('H'));
    if (isset($_SESSION['delivery_agent'])) {
        $this->smarty->assign('DeliveryAgent',$_SESSION['delivery_agent']);
    }
    $this->body = $this->smarty->fetch('orders.tpl');
  }
}
