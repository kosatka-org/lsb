<?PHP

require_once('Widget.class.php');


class OfflineSale extends Widget
{
    /* Конструктор */
    function OfflineSale(&$parent)
    {
        Widget::Widget($parent);
    }

    function get_cashbox($id, $user) {
        return $this->db->result("SELECT * FROM shop_cashbox WHERE id = {$id} AND id IN ({$user->cashbox_ids})");
    }

    /* Отображение */
    function fetch()
    {
        $uid = $this->db->escape($_SESSION['user']->user_id);
        $user = $this->db->result("SELECT * FROM users WHERE user_id = {$uid}");
        $this->smarty->assign("editable", true);

        if ($user->group_id == 2) {
            $user->cashbox_ids = $this->db->result("SELECT GROUP_CONCAT(id) as ids FROM shop_cashbox WHERE 1")->ids;
        }
        if (empty($user->cashbox_ids) && !in_array($user->group_id, [5,10,13])) {
            header("Location: /");
            exit();
        }
        $this->smarty->assign("offlineSales", 1);

        if ($_GET['product_query']) {
            $product_query = str_replace(' ', '%', trim($this->db->escape($_GET['product_query'])));
            $limit = 11; // Из шести товаров с одинаковым sku точно находится тот, который в продаже
            if ($_GET['shop_id']) {
                $shop_id = $this->db->escape($_GET['shop_id']);
                $shop_filter = " AND i.shop_id = {$shop_id} ";
            }
            if ($_GET['cashbox_id']) {
                $cbox_id = $this->db->escape($_GET['cashbox_id']);
                $cbox = $this->db->result("SELECT * FROM shop_cashbox WHERE id = {$cbox_id}");
                if (!empty($cbox->brands)) {
                  $brand_filter = " AND p.brand_id IN ({$cbox->brands}) ";
                }
            }
            if ($_GET['no_reserved']) {
                $shop_filter = " AND w.reservation = 0 ";
            }
            if (strpos($product_query, 'certificate') !== false) {
              $query = "
                SELECT p.*, p.offline_price AS price, IF(p.last_price>0, p.last_price, '') AS last_price
                  FROM products p
                WHERE p.sku LIKE '%{$product_query}%' AND enabled = 1
                GROUP BY p.product_id, p.offline_price";
            }
            else{
              $query = "
                SELECT p.*, p.offline_price AS price, IF(p.last_price>0, p.last_price, '') AS last_price, REPLACE(REPLACE(REPLACE(i.size, 'Р-р не задан', ''), 'р-р не зад', ''), 'не задан', '') AS size,
                       i.barcode AS barcode, i.item_id, w.name AS shop_name, c.name AS color_name, IF(i.quantity > 0, i.quantity, '') as quantity, ss.max_sale AS offline_max_sale, b.name AS brand_name
                  FROM items i
                  LEFT JOIN products p ON i.product_id = p.product_id
                  LEFT JOIN brands b ON p.brand_id = b.brand_id
                  LEFT JOIN sale_settings ss ON p.brand_id = ss.brand_id AND p.season_type = ss.season
                  LEFT JOIN colors c   ON c.color_id = p.color_id AND c.color_id NOT IN (2142, 1728, 2569, 2828, 2927)
                  LEFT JOIN warehouses w ON i.warehouse_id = w.warehouse_id
                WHERE i.quantity > 0 AND (i.barcode LIKE '%{$product_query}%' OR p.sku LIKE '%{$product_query}%') {$shop_filter} {$brand_filter}
                GROUP BY p.product_id, i.size, p.offline_price, p.color_id, i.shop_id
                LIMIT {$limit}";
            }
            $results = $this->db->results($query);
            header('Content-Type: application/json');
            echo json_encode($results);
            exit();
        }

        if ($_GET['user_query']) {
            $query = $this->db->escape($_GET['user_query']);
            $results = $this->db->results("SELECT * FROM users WHERE phone_number LIKE '%{$query}%' OR name LIKE '%{$query}%' OR card_number LIKE '%{$query}%' LIMIT 5");
            foreach ($results as $user) {
              $user->deposit_value = $this->db->result("SELECT COALESCE(SUM(dh.sum),0) AS deposit_value FROM deposit_history dh WHERE dh.user_id = {$user->user_id}")->deposit_value;
            }
            header('Content-Type: application/json');
            echo json_encode($results);
            exit();
        }

        if ($_POST['user_data']) {
            //Это для звонков
            $data = json_decode($_POST['user_data'], true);
            if ( !$data['shop_ids'] && !$data['brand_ids'] && !$data['search'] && !$data['f_date_start'] && !$data['c_date_end'] ) {
              header('Content-Type: application/json');
              echo json_encode(false);
              exit();
            }
            $filter = '';
            if ($data['shop_ids']) {
              $shop_ids = $this->db->escape($data['shop_ids']);
              $filter .= " AND u2s.shop_id IN ({$shop_ids}) ";
            }
            if ($data['city_ids']) {
              $city_ids = $this->db->escape($data['city_ids']);
              $filter .= " AND u.city_id IN ({$city_ids}) ";
            }
            if ($data['brand_ids']) {
              $brand_ids = $this->db->escape($data['brand_ids']);
              $filter .= " AND u2b.brand_id IN ({$brand_ids}) ";
            }
            if ($data['client_group_ids']) {
              $client_group_ids = $this->db->escape($data['client_group_ids']);
              $filter .= " AND ucg.client_group_id IN ({$client_group_ids}) ";
            }
            if ($data['client_manager_ids']) {
              $client_manager_ids = $this->db->escape($data['client_manager_ids']);
              $filter .= " AND ucm.client_manager_id IN ({$client_manager_ids}) ";
            }
            if ($data['birthday']) {
              $filter .= " AND DATE_FORMAT(u.birth_date,'%m-%d') = DATE_FORMAT(NOW(),'%m-%d') ";
            }
            if ($data['vip']) {
              $filter .= " AND u.vip = 1 ";
            }
            if ($data['my_clients']) {
              $filter .= " AND u.user_id IN (SELECT DISTINCT(user_id) FROM sr_manager2users WHERE manager_id = {$uid}) ";
            }
            if ($data['stars']) {
              $filter .= " AND ( u.purchase_sum_real > '300000') ";
            }
            if ($data['f_date_start']) {
              $date_start = $data['f_date_start'];
              $date_end = !empty($data['f_date_end']) ? $data['f_date_end'] : date('Y-m-d');
              $filter .= " AND (u.card_registered BETWEEN '{$date_start}' AND '{$date_end} 23:59:59') ";
            }
            if ($data['c_date_end']) {
              $date_end = $data['c_date_end'];
              $filter .= " AND (CL.last_call < '{$date_end} 23:59:59') ";
            }
            if ($data['search']) { // Если задана подстрока - ищем только по ней
              $query  = $this->db->escape($data['search']);
              $filter = " AND (u.phone_number LIKE '%{$query}%' OR u.name LIKE '%{$query}%' OR u.card_number LIKE '%{$query}%') ";
            }
            $limit = 100;
            $page = 1;
            if ($data['per_page'] && $data['page']) {
              $limit = (int) $data['per_page'];
              $page = (int) $data['page'];
            }
            $offset = $limit * ($page - 1);
            $offset = " OFFSET {$offset} ";

            $order = "ORDER BY u.name ASC";
            if ($data['sort_by_product_view_date']) {
              $order = "ORDER BY pv_date DESC";
            }
            elseif ($data['call_date_asc']) {
              $order = "ORDER BY CL.last_call ASC";
            }
            $s_manager = $this->db->result("SELECT id FROM sen_manager2manager WHERE sen_manager = {$uid}");
            $show_bin_button = ($s_manager || $user->group_id == 2 || $uid == 127619) ? true : false;

            $results = $this->db->results($sql="SELECT SQL_CALC_FOUND_ROWS u.user_id, u.original_user_id, u.purchase_sum_real AS total_sum, u.name, u.phone_number, u.card_number, u.personal_discount, u.city, u.birth_date, u.pref_messenger, u.last_view_date AS pv_date, u.p_manager_id, app_tracking.id AS track_id, u2s.shop_id
                        FROM users u
                        LEFT JOIN users2brands u2b ON u2b.user_id = u.user_id
                        LEFT JOIN users2shops u2s ON u2s.user_id = u.user_id
                        LEFT JOIN users_client_groups ucg ON ucg.user_id = u.user_id
                        LEFT JOIN users_client_managers ucm ON ucm.user_id = u.user_id
                        LEFT JOIN app_tracking ON app_tracking.user_id = u.user_id
                        LEFT JOIN (SELECT MAX(date) as last_call, user_id FROM calls_log GROUP BY user_id) CL ON CL.user_id = u.user_id
                        WHERE u.group_id = 1 AND u.phone_number != '' {$filter}
                        GROUP BY u.user_id
                        {$order}
                        LIMIT {$limit} {$offset}");
            $rowcount = $this->db->result("SELECT FOUND_ROWS() as count;")->count;
            foreach ($results as $key => $value) {
              $results[$key]->comments = $this->db->results("SELECT uc.text, uc.date, u.name AS manager_name FROM user_comments uc LEFT JOIN users u ON u.user_id = uc.commenter_id WHERE uc.user_id = {$value->user_id} ORDER BY uc.date DESC LIMIT 10");
              $results[$key]->last_purchase_date = $this->db->result("SELECT MAX(date) AS lpd FROM orders WHERE orders.user_id = {$value->user_id}")->lpd;
              $results[$key]->recent_items = $this->db->results("SELECT op.product_name, op.size, o.date, o.order_id, IF(o.receipt_number>0, o.receipt_number, '') AS receipt_number  FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.user_id = {$value->user_id} ORDER BY op.id DESC LIMIT 20");
              $results[$key]->last_seen_date = $this->db->result("SELECT MAX(date) AS lsd FROM product_views WHERE product_views.user_id = {$value->user_id}")->lsd;
              $results[$key]->seen_items = $this->db->results("SELECT p.model, pv.product_id, pv.date, IF(pv.app_view>0, pv.app_view, '') AS app_view FROM product_views pv LEFT JOIN products p ON pv.product_id = p.product_id WHERE pv.user_id = {$value->user_id} ORDER BY pv.id DESC LIMIT 20");
              $results[$key]->recent_calls = $this->db->results("SELECT c.date, c.status, u.name AS manager_name FROM calls_log c LEFT JOIN users u ON u.user_id = c.manager_id WHERE c.user_id = {$value->user_id} ORDER BY c.id DESC LIMIT 5");
              //$results[$key]->total_sum = $this->db->result($sql="SELECT SUM(price) AS sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.user_id IN (SELECT user_id FROM users WHERE original_user_id = '{$value->original_user_id}') AND ((op.status = 5 AND receipt_number = 0) OR receipt_number != 0)")->sum;
              //$results[$key]->total_sum += $this->db->result($sql="SELECT SUM(sum_with_discount) as sum FROM prodazhi WHERE user_id IN (SELECT user_id FROM users WHERE original_user_id = '{$value->original_user_id}')")->sum;
              $results[$key]->online_manager = $this->db->result("SELECT * FROM users WHERE user_id = {$value->p_manager_id}")->name;
              $results[$key]->offline_managers = $this->db->results("SELECT name FROM users WHERE user_id IN (SELECT manager_id FROM sr_manager2users WHERE user_id = {$value->user_id})");
              if(empty($results[$key]->recent_items) && $show_bin_button)$results[$key]->show_bin_button = true;
            }
            $pagination = ['page' => $page, 'per_page' => $limit, 'rowcount' => (int) $rowcount];
            $res = array('users' => $results, 'pagination' => $pagination);
            if ($data['shop_ids']) {
              $brands = $this->db->results("SELECT b.brand_id, b.name FROM brands b WHERE EXISTS (SELECT * FROM items ps INNER JOIN products p ON p.product_id = ps.product_id WHERE ps.shop_id IN ({$shop_ids}) AND b.brand_id = p.brand_id) ORDER BY b.name");
              $res['brands'] = $brands;
            }
            header('Content-Type: application/json');
            echo json_encode($res);
            exit();
        }

        if ($_POST['move_user_id_to_bin']) {
          $user_id = (int) $_POST['move_user_id_to_bin'];
          $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id} AND group_id = 1");
          if (empty($user)) {
            exit("Not allowed");
          }
          $this->db->query("UPDATE users SET group_id = (SELECT group_id FROM groups WHERE name = 'Корзина') WHERE user_id = {$user_id}");
          exit("OK");
        }

        if ($_POST['send_app_link_to_user']) {
          $user_id = (int) $_POST['send_app_link_to_user'];
          $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id}");
          if (empty($user)) {
            exit("Not allowed");
          }
          $platform = $_POST['platform'];
          $user->name = trim($user->name);

          if($_COOKIE['language'] == 'eng'){$message = "{$user->name}, You can install the Luxury Store app from this link: http://www.ls.net.ru/{$platform}";}
          else{$message = "Уважаемый {$user->name}, Вы можете установить приложение Лакшери Стор по этой ссылке: http://www.ls.net.ru/{$platform}";}
          $args = array( 'user_id' => $user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $user->phone_number, 'sms_only' => 1 );
          Job::push('SmsJob', $args, false, 'critical');
          $this->db->query("INSERT INTO calls_log (user_id, status, date, manager_id) VALUES ({$user_id}, 3, NOW(), {$uid})");
          exit("OK");
        }

        if ($_POST['send_wallet_link_to_user']) {
          $user_id = (int) $_POST['send_wallet_link_to_user'];
          $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id}");
          if (empty($user)) {
            exit("Not allowed");
          }
          $card = substr($user->card_number, -5);
          if($_COOKIE['language'] == 'eng'){$message = "{$user->name}, You can download your Luxury Store card to Wallet from this link: https://lsboutique.ru/pass/{$user->phone_number}/{$card}/";}
          else{$message = "Уважаемый {$user->name}, Вы можете загрузить свою карту Лакшери Стор в Wallet по этой ссылке: https://lsboutique.ru/pass/{$user->phone_number}/{$card}/";}

          $args = array( 'user_id' => $user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $user->phone_number, 'sms_only' => 1 );
          Job::push('SmsJob', $args, false, 'critical');
          $this->db->query("INSERT INTO calls_log (user_id, status, date, manager_id) VALUES ({$user_id}, 4, NOW(), {$uid})");
          exit("OK");
        }

        if($_POST['app_installed']) {
          $user_id = (int) $_POST['app_installed'];
          $app = $this->db->result("SELECT * FROM app_tracking WHERE user_id = {$user_id}");
          if(empty($app)){
            $this->db->query("INSERT INTO app_tracking (`user_id`,`manager_id`,`date`) VALUES ('{$user_id}','{$uid}',NOW()); ");
          }
          exit("OK");
        }

        if ($_POST['call_data']) {
            $data = json_decode($_POST['call_data'], true);
            if ($data['user_id'] && $data['status']) {
              $this->db->query("INSERT INTO calls_log (user_id, status, date, manager_id) VALUES ({$data['user_id']}, {$data['status']}, NOW(), {$uid})");
              if ($data['status'] == 1) {
                $this->db->query("UPDATE users SET last_phone_call = NOW() WHERE user_id = {$data['user_id']}");
              }
            }
            exit();
        }

        if ($_POST['comment_data']) {
            $data = json_decode($_POST['comment_data'], true);
            if ($data['user_id'] && $data['text']) {
              $this->db->query("INSERT INTO user_comments (user_id, text, date, commenter_id) VALUES ({$data['user_id']}, '{$data['text']}', NOW(), {$uid})");
            }
            exit();
        }

        if ($_POST['save_managers']) {
            $products = json_decode($_POST['save_managers'], true);
            foreach ($products as $prod) {
              $this->db->query("UPDATE orders_products SET offline_manager_id = {$prod->offline_manager_id}");
            }
            exit();
        }


        if ($_GET['receipt_for'] || $_GET['act']) {
            $order_id = $this->db->escape($_GET['receipt_for']);
            if (!$order_id) {
              $order_id = $this->db->escape($_GET['act']);
            }
            $order = $this->db->result("SELECT * FROM orders WHERE order_id = {$order_id}");
            $cashbox = $this->get_cashbox( $order->cashbox_id, $user );
            $order->total = $this->db->result("SELECT SUM(price) AS total_sum, count(id) AS total_num FROM orders_products op WHERE order_id = {$order_id} AND status !=4");
            if($order->total->total_sum != 0){
              $payments = $this->db->results("SELECT * FROM orders_payments WHERE order_id = {$order_id}");
              foreach($payments as $p){
                if($p->payment_id != 4 && $p->payment_id != 9)$order->payment += $p->money_paid;
                else {
                  $debt_paid = $this->db->result("SELECT SUM(money_paid) as total FROM orders_payments WHERE debt_id = {$p->id}")->total;
                  $order->debt += $p->money_paid - $debt_paid;
                  $order->payment += $debt_paid;
                }
              }
            }

            if ($cashbox->name == "Услуги") {
              $order->service_order = $this->db->result("SELECT * FROM services_orders WHERE real_order_id = {$order_id}");
              $order->receipt_number = $order->service_order->id;
            }

            $where = "order_id = {$order_id}";
            if ($_GET['receipt_for']) {
              $where .= " AND op.mtm_status != 'Отказ' AND op.status !=4";
            }
            $order->products = $this->db->results("SELECT op.*, p.offline_price AS offline_price, ((p.offline_price - op.price)/(p.offline_price/100)) AS discount, c.name AS color FROM orders_products op LEFT JOIN products p ON p.product_id = op.product_id LEFT JOIN colors c ON c.color_id = p.color_id WHERE {$where}");
            // Вдруг на винде не работает?
            if (strtoupper(substr(PHP_OS, 0, 3)) != 'WIN') {
                $order->total_sum_words = Numbers_Words::toWords($order->total->total_sum, "ru");
                $order->payment_words = Numbers_Words::toWords($order->payment, "ru");
                $order->debt_words = Numbers_Words::toWords($order->debt, "ru");
            }
            $this->smarty->assign("client_name", $this->db->result("SELECT name FROM users WHERE user_id = '{$order->user_id}'")->name);
            $this->smarty->assign("cashbox", $cashbox);
            $this->smarty->assign("order", $order);
            if ($_GET['receipt_for']) {
              $response = $this->smarty->fetch('blank.tpl');
            }
            elseif ($_GET['act']) {
              $response = $this->smarty->fetch('blank_act.tpl');
            }
            exit($response);
        }

        if ($_GET['movement_receipt_for']) {
            $movement_id = $this->db->escape($_GET['movement_receipt_for']);
            $movement = $this->db->result("SELECT m.*, w1.name AS shop_from_name, w2.name AS shop_to_name, (CASE WHEN (w1.reservation = 1 OR w2.reservation = 1) THEN 1 ELSE 0 END) AS reservation FROM movements m LEFT JOIN warehouses w1 ON w1.warehouse_id = m.warehouse_from LEFT JOIN warehouses w2 ON w2.warehouse_id = m.warehouse_to WHERE m.movement_id = {$movement_id}");
            $movement->products = $this->db->results("SELECT i.*, p.sku, p.model, c.name AS color, mi.price, mi.quantity AS quantity FROM items i LEFT JOIN movement_items mi ON i.item_id = mi.item_id LEFT JOIN products p ON p.product_id = i.product_id LEFT JOIN colors c ON c.color_id = p.color_id WHERE mi.movement_id = {$movement_id}");
            $movement->totals = $this->db->result("SELECT SUM(quantity) AS total_quantity, SUM(price) AS total_price FROM movement_items WHERE movement_id = {$movement_id} GROUP BY movement_id");
            $movement->created_user = $this->db->result("SELECT user_id, name FROM users WHERE user_id = {$movement->created_user_id}");
            $movement->accepted_user = $this->db->result("SELECT user_id, name FROM users WHERE user_id = {$movement->accepted_user_id}");
            $movement->responsible_user = $this->db->result("SELECT user_id, name FROM users WHERE user_id = {$movement->responsible}");
            $movement->user = $this->db->result("SELECT user_id, name FROM users WHERE user_id = {$movement->user_id}");
            $this->smarty->assign("movement", $movement);
            $response = $this->smarty->fetch('blank_movement.tpl');
            exit($response);
        }

        if ($_GET['order_id']) {
            $order_id = $this->db->escape($_GET['order_id']);
            $order = $this->db->result("SELECT * FROM orders WHERE order_id = {$order_id}");
            $cashbox = $this->get_cashbox( $order->cashbox_id, $user );
            $p_order = new StdClass();
            $p_order->order_id = $order_id;
            $p_order->date = $order->date;
            $p_order->comment = $order->comment;
            $p_order->mtm_brand_id = $order->mtm_brand_id;
            if (date('Ymd') == date('Ymd', strtotime($order->date))) {
              $p_order->today = true;
              $p_order->editable = true;
            }
            else {
              $p_order->today = false;
            }
            if ($order->status == 3) {
              $p_order->editable = false;
              $p_order->cancelled = true;
            }
            if ($_SESSION['user']->user_id == 139026 || $_SESSION['user']->user_id == 127296) {
              $p_order->editable = true;
            }

            $p_order->products = $this->db->results("SELECT op.*, op.id AS op_id, p.offline_price, IF(p.last_price>0, p.last_price, '') AS last_price, p.large_image, p.model FROM orders_products op LEFT JOIN products p ON p.product_id = op.product_id WHERE order_id = {$order_id}");

            $managers = $this->db->results("SELECT user_id, share FROM order_managers WHERE order_id = {$order_id}");
            if ($managers) {
              $p_order->managers = $managers;
            }

            if ($order->user_id) {
                $p_order->user = $this->db->result("SELECT user_id, name, card_number, phone_number, personal_discount, photo FROM users WHERE user_id = {$order->user_id}");
                $p_order->user->deposit_value = $this->db->result("SELECT COALESCE(SUM(dh.sum),0) AS deposit_value FROM deposit_history dh WHERE dh.user_id = {$p_order->user->user_id}")->deposit_value;
            }
            $year = date('Y');
            $p_order->payments = $this->db->results("SELECT id, payment_id, money_paid, debt_by_date, cashbox_id, responsible_person_id FROM orders_payments WHERE order_id = {$order_id}");
            foreach ($p_order->payments as $payment) {
              if($payment->payment_id == 21){
                $op = $this->db->result($sql="SELECT paid, hash FROM online_payments WHERE payment_id = {$payment->id}");
                $payment->paid = $op->paid;
                $payment->hash = $op->hash;
              }
              if($payment->payment_id == 4){
                $payment->debt_payments = $this->db->results("SELECT op.money_paid, op.date, po.name FROM orders_payments op LEFT JOIN payment_offline po ON op.payment_id = po.id WHERE op.debt_id = {$payment->id}");
                $payment->total_debt_paid = 0;
                if(!empty($payment->debt_payments)){
                  foreach($payment->debt_payments as $ppay){
                    $payment->total_debt_paid += $ppay->money_paid;
                    $ppay->money_paid = number_format($ppay->money_paid, 2, '.', ' ');
                    $ppay->date = substr($ppay->date,0,4) == $year ? $this->rus_date("j F H:i", strtotime($ppay->date)) : $this->rus_date("j F Y H:i", strtotime($ppay->date));
                  }
                  $payment->total_debt_paid = number_format($payment->total_debt_paid, 0, '', ' ');
                  if($_SESSION['user']->group_id != 2)unset($payment->debt_payments);
                }
              }
            }
            $this->smarty->assign("editable", $p_order->editable);
            $this->smarty->assign("order", json_encode($p_order));
        }

        if ($_POST['order']) {
            $data = json_decode($_POST['order'], true);
            if ( $data['user'] ) {
                $user_id = $this->db->escape($data['user']['user_id']);
            }
            else {
                $user_id = 0;
            }

            if ( $data['order_id'] ) {
                $order_id = $data['order_id'];
                $order = $this->db->result("SELECT * FROM orders WHERE order_id = {$order_id};");
                if (!$order) {
                  exit('No order with given ID');
                }
                $this->db->query("UPDATE orders SET user_id = {$user_id} WHERE order_id = {$order_id}");
                if ($data['comment']) {
                  $this->db->query("UPDATE orders SET comment = '{$data['comment']}' WHERE order_id = {$order_id}");
                }
            }
            else {
                $code = md5(uniqid('', true));
                $rn = $this->db->result("SELECT IFNULL(MAX(receipt_number), 0)+1 as rn FROM orders WHERE cashbox_id = {$data['cashbox_id']};");
                $this->db->query("INSERT INTO orders (status, user_id, date, code, cashbox_id, receipt_number) VALUES (5, {$user_id}, NOW(), '{$code}', {$data['cashbox_id']}, {$rn->rn})");
                $order_id = $this->db->insert_id();
                if ($user_id) {
                    $order_user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id}");
                    $this->db->query("UPDATE orders SET name = '{$order_user->name}', phone='{$order_user->phone_number}' WHERE order_id = {$order_id}");
                    // Привязка клиента к магазину
                    $shop_id = $this->db->result("SELECT shop_id FROM shop_cashbox WHERE id = {$data['cashbox_id']}")->shop_id;
                    $assoc = $this->db->result("SELECT COUNT(*) AS count FROM users2shops WHERE shop_id = {$shop_id} AND user_id = {$user_id}")->count;
                    if ($assoc == 0) {
                      $this->db->query("INSERT INTO users2shops(user_id, shop_id) VALUES ({$user_id}, {$shop_id})");
                    }
                }
            }

            if ($data['mtm_items']) {
              $this->db->query("DELETE FROM orders_products WHERE order_id = {$order_id}");
              foreach ($data['mtm_items'] as $i => $mtm) {
                $mtm_product = $this->db->result("SELECT * FROM products WHERE model = 'Индивидуальный пошив'");
                $this->db->query(sql_placeholder('INSERT INTO orders_products(order_id, user_id, product_id, barcode, product_name, price, quantity, size, item_location, sku, new_order, mtm_status, offline_manager_id) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                $order_id, $user_id, $mtm_product->product_id, '', $mtm['name'], $mtm['price'], 1, $mtm['size'], '', '', 0, $mtm['mtm_status'], $mtm['manager_id']));
              }
            }
            if ($data['mtm_brand_id']) {
              $this->db->query("UPDATE orders SET mtm_brand_id = {$data['mtm_brand_id']} WHERE order_id = {$order_id}");
            }

            $removed_payments = join($data['removed_payments'], ',');
            $deposit_payment_id = $this->db->result("SELECT * FROM payment_offline WHERE name = \"Оплата депозитом\"")->id;
            foreach ($data['removed_payments'] as $payment_id) {
              $payment = $this->db->result("SELECT * FROM orders_payments WHERE id = {$payment_id}");
              if ($payment->payment_id == $deposit_payment_id) {
                $reason = "Отмена оплаты заказа депозитом";
                $this->db->query("INSERT INTO deposit_history (user_id, order_id, admin_id, sum, reason)
                  VALUES ({$payment->user_id}, {$payment->order_id}, {$_SESSION['user']->user_id}, {$payment->money_paid}, '{$reason}')");
              }
              $this->db->query("DELETE FROM orders_payments WHERE id = {$payment_id}");
            }
            $responsible_person_id = $_SESSION['user']->original_user_id;
            $ids = array(0);
            foreach ($data['payments'] as $i => $payment) {
              if ($payment['id']) {
                $p_id = (int) $payment['id'];
                $this->db->query("UPDATE orders_payments SET
                  payment_id = {$payment['payment_id']},
                  order_id = {$order_id},
                  money_paid = {$payment['money_paid']},
                  cashbox_id = {$payment['cashbox_id']},
                  user_id = {$user_id},
                  responsible_person_id = {$responsible_person_id},
                  debt_by_date = '{$payment['debt_by_date']}'
                  WHERE id = {$payment['id']}");
              }
              else {
                $this->db->query("INSERT INTO orders_payments (payment_id, order_id, money_paid, date, cashbox_id, user_id, responsible_person_id, debt_by_date) VALUES ({$payment['payment_id']}, {$order_id}, {$payment['money_paid']}, NOW(), {$payment['cashbox_id']}, {$user_id}, {$responsible_person_id}, '{$payment['debt_by_date']}')");
                $data['payments'][$i]['id'] = $this->db->insert_id();
                if ($payment['is_deposit']) {
                  $reason = "Оплата заказа депозитом";
                  $this->db->query("INSERT INTO deposit_history (user_id, order_id, admin_id, sum, reason, payment_method_id)
                    VALUES ({$user_id}, {$order_id}, {$_SESSION['user']->user_id}, -{$payment['money_paid']}, '{$reason}', {$payment['payment_id']})");
                }
                if($payment['payment_id'] == 21 && !empty($user_id)){
                  $payment_id = $this->db->insert_id();
                  array_push($ids, $payment_id);
                  $check = $this->db->result("SELECT * FROM online_payments WHERE amount = {$payment['money_paid']} AND order_id = {$order_id} ");
                  if(empty($check)){
                    $m_user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id} ");
                    $m_token = substr(hash('sha256', $order_id . $payment_id . $m_user->password . "onlinepay"), 0, 16);
                    $text = "Оплата на сумму {$payment['money_paid']}р https://lsboutique.ru/spay/{$m_token}/";
                    $m = "Оплата на сумму {$payment['money_paid']}р, по заказу {$order_id} https://lsboutique.ru/spay/{$m_token}/";
                    $this->db->query($sql="INSERT INTO online_payments (order_id, payment_id, user_id, amount, hash, date) VALUES ({$order_id}, {$payment_id}, {$user_id}, {$payment['money_paid']}, '{$m_token}', NOW())");
                    $args = array('sender' => 'lsboutique', 'message_text' => $text, 'phone_number' => $m_user->phone, 'user_id' => (!empty($m_user->user_id) ? $m_user->user_id : 0), 'sms_only' => 1);
                    Job::push( 'SmsJob', $args, false, 'critical' );
                    $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "online_payments" );
                    Job::push('SlackJob', $args);
                  }
                  else{
                    $this->db->query($sql="UPDATE online_payments SET payment_id = '{$payment_id}', date = NOW() WHERE order_id = {$order_id} AND amount = {$payment['money_paid']}");
                  }
                }
              }
            }
            $this->db->query($sql="DELETE FROM online_payments WHERE order_id = {$order_id} AND payment_id NOT IN (".implode(',',$ids).");");
            if ($_POST['return_payment_ids']) {
              echo json_encode($data['payments']);
              exit();
            }
            else {
              echo $order_id;
              exit();
            }
        }

        if ($_POST['return_obj']) {
          $data = json_decode($_POST['return_obj'], true);
          $order = json_decode($_POST['o_obj'], true);
          $user_id = $order['user']['user_id'];
          if (!$user_id) { $user_id = 0; }

          // Move item
          foreach ($data['returns'] as $product) {
              $this->db->query("UPDATE orders_products SET status = 4, status_date = NOW() WHERE id = {$product['id']}");
          }

          // Return payment
          foreach ($data['returns'] as $product) {
            $debt = $this->db->result("SELECT money_paid AS sum, id FROM orders_payments WHERE order_id = {$order['order_id']} AND debt_paid_off = 0 AND payment_id = (SELECT id FROM `payment_offline` WHERE name = 'Долг')");
            if ($debt) {
              $debt_paid = $this->db->result("SELECT SUM(money_paid) AS sum FROM orders_payments WHERE debt_id = {$debt->id} ")->sum;
              $debt_remaining = $debt->sum - $debt_paid;
              if ($debt_remaining <= $product['price']) {
                $this->db->query("INSERT INTO orders_payments(debt_id, payment_id, money_paid, date, cashbox_id) VALUES({$debt->id}, (SELECT id FROM payment_offline WHERE name = 'Возврат наличными'), {$debt_remaining}, NOW(), {$data['cashbox_id']})");
                $this->db->query("UPDATE orders_payments SET debt_paid_off = 1 WHERE id = {$debt->id}");
              }
              else {
                $this->db->query("INSERT INTO orders_payments(debt_id, payment_id, money_paid, date, cashbox_id) VALUES({$debt->id}, (SELECT id FROM payment_offline WHERE name = 'Возврат наличными'), {$product['price']}, NOW(), {$data['cashbox_id']})");
              }
            }
            $this->db->query("INSERT INTO orders_payments (payment_id, order_id, money_paid, date, cashbox_id, user_id) VALUES ({$data['method_id']}, {$order['order_id']}, '-{$product['price']}', NOW(), {$data['cashbox_id']}, {$user_id})");
          }
          exit("OK");
        }

        if (empty($cashbox)) {
            $cashbox_id = (int) $_GET['cashbox_id'];
            if (!$cashbox_id) {
                header("Location: /");
                exit();
            }
            $cashbox = $this->get_cashbox($cashbox_id, $user);
        }
        $filter = '';
        if(in_array($cashbox->id, array(12,5))) $filter = ' AND id NOT IN (3,20)';


        if (!empty($cashbox->brands)) {
          $cashbox->description = $this->db->result($sql="SELECT GROUP_CONCAT(name SEPARATOR ', ') AS d FROM brands WHERE brand_id IN ({$cashbox->brands})")->d;
        }

        $order_data = $this->db->result("SELECT * FROM orders WHERE order_id = {$order_id} LIMIT 1");
        $order_data->w_date = $this->rus_date("j F", strtotime($order_data->date));
        if($cashbox->id == 15) $cashboxes = $this->db->results("SELECT * FROM shop_cashbox WHERE id NOT IN (14,13,17) ");
        else $cashboxes = $this->db->results("SELECT * FROM shop_cashbox WHERE id IN ({$user->cashbox_ids})");
        $cashbox->debt_users = json_encode($this->db->results("SELECT * FROM `offline_sales_person` WHERE LOCATE(',{$cashbox->id},',  `cashbox_ids`) > 0"));
        $payment_options = $this->db->results($sql="SELECT * FROM payment_offline WHERE id IN ({$cashbox->payments_ids}) {$filter}");
        $return_options = $this->db->results("SELECT * FROM payment_offline WHERE `return` = 1 AND enabled = 1");
        $this->smarty->assign("order_id", $order_id);
        $this->smarty->assign("order_data", $order_data);
        $this->smarty->assign("brands", $this->db->results("SELECT * FROM brands ORDER BY name ASC"));
        $this->smarty->assign("payment_options", json_encode($payment_options));
        $this->smarty->assign("return_options", $return_options);
        $this->smarty->assign("return_options_json", json_encode($return_options));
        $this->smarty->assign("cashbox", $cashbox);
        $this->smarty->assign("cashboxes", $cashboxes);
        $this->smarty->assign("cashboxes_json", json_encode($cashboxes));
        $shop_cashboxes = $this->db->results("SELECT id FROM shop_cashbox WHERE shop_id = (SELECT shop_id FROM shop_cashbox WHERE id = {$cashbox->id})");
        $ids = array();
        foreach($shop_cashboxes as $sc) $ids[] = $sc->id;
        $off_m = $this->db->results("SELECT name as manager_name, user_id as manager_id, debt_limit FROM `users` WHERE group_id = 13 AND cashbox_ids REGEXP '(,|^)(".implode('|',$ids).")(,|$)'");
        $u = new luser();
        foreach ($off_m as $manager) {
          $manager->debt_limit = $manager->debt_limit - ($u->debts4manager($manager->manager_id) + $u->debts4manager($manager->manager_id, true, " = 13"));
        }
        $this->smarty->assign("off_managers", $off_m);
        $this->smarty->assign("managers_json", json_encode($off_m));
        $this->smarty->assign("return", $_GET['return']);
        $this->smarty->assign('title', 'Бутик одежды больших размеров | бутик Лакшери Стор');
        $this->body = $this->smarty->fetch('offline_sale.tpl');
        return $this->body;
    }
}
