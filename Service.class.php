<?PHP

require_once('Widget.class.php');


class Service extends Widget
{
    function Service(&$parent)
    {
        Widget::Widget($parent);
    }

    function fetch()
    {
      $uid = $this->db->escape($_SESSION['user']->user_id);
      $user = $this->db->result("SELECT * FROM users WHERE user_id = {$uid}");
      $services_cashbox = $this->db->result("SELECT * FROM shop_cashbox WHERE name = 'Услуги'");
      if (!in_array($services_cashbox->id, explode(',', $user->cashbox_ids)) && $this->settings->theme != 'api') {
          header("Location: /");
          exit();
      }

      if ($_POST['service_order']) {
        $data = json_decode($_POST['service_order'], true);
        if ( $data['user'] ) {
            $user_id = $this->db->escape($data['user']['user_id']);
        }
        else {
            $user_id = 0;
        }

        if ( $data['id'] ) {
            $order_id = $data['id'];
            $order = $this->db->result("SELECT * FROM services_orders WHERE id = {$order_id};");
            if (!$order) {
              exit('No order with given ID');
            }
            $r_order = $this->db->result("SELECT * FROM orders WHERE order_id = {$order->real_order_id};");
            $r_order_id = $order->real_order_id;
            $this->db->query("UPDATE services_orders SET client_id = {$user_id}, shop_id = {$data['shop_id']}, order_type = '{$data['order_type']}' WHERE id = {$order_id}");
            $this->db->query("UPDATE orders SET user_id = {$user_id}, manager_id = {$uid} WHERE order_id = {$order->real_order_id}");
        }
        else {
            $code = md5(uniqid('', true));
            $rn = $this->db->result("SELECT IFNULL(MAX(receipt_number), 0)+1 as rn FROM orders WHERE cashbox_id = {$data['cashbox_id']};");
            $this->db->query("INSERT INTO orders (status, user_id, date, code, cashbox_id, receipt_number, manager_id) VALUES (5, {$user_id}, NOW(), '{$code}', {$data['cashbox_id']}, {$rn->rn}, $uid)");
            $r_order_id = $this->db->insert_id();
            $this->db->query("INSERT INTO services_orders (client_id, date, real_order_id, shop_id, order_type) VALUES ({$user_id}, NOW(), {$r_order_id}, {$data['shop_id']}, '{$data['order_type']}')");
            $order_id = $this->db->insert_id();
        }

        $this->db->query("DELETE FROM orders_products WHERE order_id = {$r_order_id}");
        $item_ids = array();
        foreach ($data['items'] as $item) {
          $this->db->query("INSERT INTO orders_products(order_id, user_id, product_id, barcode, product_name, price, quantity, size, item_location, sku, new_order)
            VALUES({$r_order_id}, {$user_id}, 0, '', '{$item['product_name']} - {$item['defect_description']} - {$item['name']}', {$item['price']}, 1, '', '', '', 0)");
          $eng_statuses = array(  'Принято' => 'Accepted', 'В работе' => 'In process', 'В бутике, ждет клиента' => 'At boutique, ready', 'Выдано клиенту' => 'Complete' );
          $eng_status = $eng_statuses[$item['status']];
          if ($item['id']) {
            $item_id = $item['id'];
            $item_status = $this->db->result("SELECT status FROM services_orders_items WHERE id = {$item_id}")->status;
            if ($item_status != $item['status']) {
              $this->db->query("INSERT INTO service_order_log(service_order_item_id, manager_id, date, status, status_eng) VALUES({$item_id}, {$uid}, NOW(), '{$item['status']}', '{$eng_status}') ");
              if ($item['status'] == 'В бутике, ждет клиента'){
                $user = $this->db->result("SELECT name, phone_number FROM users WHERE user_id = {$user_id}");
                $user->name = trim($user->name);
                if($_COOKIE['language'] == 'eng'){$message = "Dear {$user->name}, your order for {$item['name']} for {$data['item_name']} is completed, and is waiting for you in the boutique.";}
                else{$message = "Уважаемый {$user->name}, Ваш заказ на услугу {$item['name']} для {$data['item_name']} выполнен, и ожидает Вас в бутике.";}
                $user->phone_number = '79202944697';
                $args = array( 'user_id' => $user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $user->phone_number );
                Job::push('SmsJob', $args);
                $user->phone_number = '79877536745';
                $args = array( 'user_id' => $user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $user->phone_number );
                Job::push('SmsJob', $args);
              }
            }
            $this->db->query("UPDATE services_orders_items SET service_type_id = {$item['service_type_id']}, status = '{$item['status']}', status_eng = '{$eng_status}', price = {$item['price']} WHERE id = {$item_id}");
          }
          else {
            $this->db->query("INSERT INTO services_orders_items(order_id, service_type_id, status, status_eng, price, product_name, defect_description) VALUES({$order_id}, {$item['service_type_id']}, '{$item['status']}', '{$eng_status}', {$item['price']}, '{$item['product_name']}', '{$item['defect_description']}')");
            $item_id = $this->db->insert_id();
          }
          $item_ids[] = $item_id;
        }
        $item_id_str = implode($item_ids, ", ");
        $this->db->query("DELETE FROM services_orders_items WHERE order_id = {$order_id} AND id NOT IN ({$item_id_str})");
        header('Content-Type: application/json');
        exit(json_encode(["order_id" => $order_id, "item_ids" => $item_ids]));
      }

      if ($_GET['service_order_id']) {
        $service_order_id = intval($_GET['service_order_id']);
        $service_order = $this->db->result("SELECT * FROM services_orders WHERE id = {$service_order_id}");
        $service_order->items = $this->db->results("SELECT *, soi.id AS id FROM services_orders_items soi LEFT JOIN service_types st ON soi.service_type_id = st.id WHERE soi.order_id = {$service_order_id}");
        foreach ($service_order->items as $item) {
          $item->changes = $this->db->results("SELECT sol.*, u.name AS name FROM service_order_log sol LEFT JOIN users u ON u.user_id = sol.manager_id WHERE sol.service_order_item_id = {$item->id}");
        }
        if ($service_order->client_id) {
            $service_order->user = $this->db->result("SELECT user_id, name, card_number, phone_number, personal_discount, photo FROM users WHERE user_id = {$service_order->client_id}");
        }
        $this->smarty->assign('order', json_encode($service_order));
      }

      if ($_GET['service_list']) {
        $join = $group_by = '';
        if($this->settings->theme == 'api'){
            $date = date('Y-m-d', strtotime('2017-11-20 00:00:00'));
            $filter = " AND (so.date >= '{$date}' OR (soi.status != 'Выдано клиенту' AND so.date < '{$date}'))";
            $join = ' LEFT JOIN services_orders_items soi ON soi.order_id = so.id ';
            $group_by = ' GROUP BY so.id ';
            if (isset($_GET['user_id']) && !empty($_GET['user_id'])){
                $o_user_id = $this->db->result("SELECT original_user_id FROM users WHERE user_id = {$_GET['user_id']}")->original_user_id;
                $keys = $this->db->results("SELECT user_id FROM users WHERE original_user_id = {$o_user_id}");
                foreach ($keys as $k) {$keys_arr[] = $k->user_id;}
                $keys = implode(',',$keys_arr);
                $filter .= " AND so.client_id IN ({$keys})";
            }
            else{$return->message="Отсутствует идентификация пользователя";}
        }
        else{
            if ($_GET['delete_service_order_id']) {
              $order_id = intval($_GET['delete_service_order_id']);
              $order = $this->db->result("SELECT * FROM services_orders WHERE id = {$order_id}");
              $this->db->query("DELETE FROM services_orders_items WHERE order_id = {$order_id}");
              $this->db->query("DELETE FROM services_orders WHERE id = {$order_id}");
              $this->db->query("DELETE FROM orders WHERE order_id = {$order->real_order_id}");
              $this->db->query("DELETE FROM orders_products WHERE order_id = {$order->real_order_id}");
            }
            $filter = '';
            $date_filter = '';
            if (isset($_GET['order_query'])) {
              $q = $this->db->escape($_GET['order_query']);
              if (!empty($q)) {
                $filter .= " AND (u.name LIKE '%{$q}%' OR u.phone_number LIKE '%{$q}%' OR u.card_number LIKE '%{$q}%') OR (so.id LIKE '%{$q}%')";
              }
            }
            if (isset($_GET['date_start']) && !empty($_GET['date_start'])) {
              $date_check = date($_GET['date_start']) . ' 00:00:00';
              $date_filter .= " AND so.date >= '{$date_check}' ";
            }
            if (isset($_GET['date_end']) && !empty($_GET['date_end'])) {
              $date_check = date($_GET['date_end']) . ' 23:59:59';
              $date_filter .= " AND so.date <= '{$date_check}' ";
            }
            if (isset($_GET['shop_id']) && !empty($_GET['shop_id'])) {
              $shop_id = (int)$_GET['shop_id'];
              $filter .= "  AND shop_id = {$shop_id} ";
            }
            if((!isset($_GET['order_query']) || empty($_GET['order_query'])) && (!isset($_GET['date_start']) || empty($_GET['date_start'])) && (!isset($_GET['date_end']) || empty($_GET['date_end']))) {
              $date_filter .= " AND so.date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) ";
            }

            if ($_GET['order_filter']) {
              $filter_data = json_decode($_GET['order_filter'], true);
              if ( $filter_data['status'] && count($filter_data['status']) > 0 ) {
                $st = implode($filter_data['status'], "','");
                $filter .= " AND EXISTS (SELECT 1 FROM services_orders_items soi WHERE soi.order_id = so.id AND soi.status IN ('{$st}')) ";
              }
              if ( $filter_data['type'] && count($filter_data['type']) > 0 ) {
                $tp = implode($filter_data['type'], "','");
                $filter .= " AND so.order_type IN ('{$tp}') ";
              }
            }
            $shop_filter = '';
            if($_SESSION['user']->cashbox_ids && $_SESSION['user']->group_id == 9){
              $shops = $this->db->results("SELECT shop_id FROM shop_cashbox WHERE id IN ({$_SESSION['user']->cashbox_ids}) GROUP BY shop_id");
              foreach($shops as $sh){$stmp[] = $sh->shop_id;}
              $shop_filter = " AND shop_id IN (".implode(',',$stmp).") ";
            }
        }

        $fields = "so.*";
        if($this->settings->theme == 'api'){$fields = "so.id,so.client_id,so.comment,so.item_name,so.defect_description";}
        $services = $this->db->results($sql="SELECT {$fields}, DATE_FORMAT(so.date, \"%Y-%m-%d\") AS date, o.manager_id
                                            FROM services_orders so
                                            LEFT JOIN orders o ON o.order_id = so.real_order_id
                                            LEFT JOIN users u ON u.user_id = so.client_id
                                            {$join}
                                            WHERE 1 {$date_filter}{$filter}{$shop_filter}{$group_by} ORDER BY id DESC LIMIT 100");
        if (empty($services)){
          $services = $this->db->results($sql="SELECT {$fields}, DATE_FORMAT(so.date, \"%Y-%m-%d\") AS date, o.manager_id
                                            FROM services_orders so
                                            LEFT JOIN orders o ON o.order_id = so.real_order_id
                                            LEFT JOIN users u ON u.user_id = so.client_id
                                            {$join}
                                            WHERE 1 {$filter}{$shop_filter}{$group_by} ORDER BY id DESC LIMIT 100");
        }
        foreach ($services as $i => $service) {
          $service->w_date = $this->rus_date("j F", strtotime($service->date));
          if((time()-(60*60*24)) < strtotime($service->date)) $service->redactable = true;
          $fields = "*";
          if($this->settings->theme == 'api'){$fields = "user_id,name";}
          $filter = " AND (so.date >= '{$date}' OR (soi.status != 'Выдано клиенту' AND so.date < '{$date}'))";
          $service->manager = $this->db->result("SELECT name FROM users WHERE user_id = {$service->manager_id}")->name;
          $service->user = $this->db->result("SELECT {$fields} FROM users WHERE user_id = {$service->client_id}");
          if($this->settings->theme == 'api'){
            if($_COOKIE['language'] == 'eng'){
              $fields = "st.eng_name AS name, soi.price, soi.status_eng AS status";
              $fields2 = "'Total', SUM(price) AS price, NULL";
            }
            else{
              $fields = "st.name, soi.price, soi.status";
              $fields2 = "'Всего', SUM(t.price) AS price, NULL";
            }
          }
          else{
            if($_COOKIE['language'] == 'eng'){
              $fields = "st.eng_name AS name, soi.price, soi.status_eng AS status, sp.payment_id";
              $fields2 = "'Total', SUM(price) AS price, NULL, SUM(payment_id) AS payment_id";
            }
            else{
              $fields = "st.name, soi.price, soi.status, sp.payment_id";
              $fields2 = "'Всего', SUM(t.price) AS price, NULL, SUM(t.payment_id) AS payment_id";
            }
          }
          $service->items = $this->db->results($sql="SELECT {$fields}, soi.product_name, soi.defect_description
                      FROM services_orders_items soi
                      LEFT JOIN service_types st ON st.id = soi.service_type_id
                      LEFT JOIN services_orders so ON soi.order_id = so.id
                      LEFT JOIN orders_payments sp ON so.real_order_id = sp.order_id
                        WHERE soi.order_id = {$service->id} {$filter} GROUP BY soi.id
                        UNION ALL SELECT {$fields2}, '', ''
                        FROM
                          (SELECT soi.price, sp.payment_id FROM services_orders_items soi
                          LEFT JOIN services_orders so ON soi.order_id = so.id
                          LEFT JOIN orders_payments sp ON so.real_order_id = sp.order_id
                          WHERE soi.order_id = {$service->id} GROUP BY soi.id) t");
          foreach ($service->items as $ii => $item) {
            if($this->settings->theme == 'api'){$service->items[$ii]->price = (string)(int)$item->price;}
            else{$service->items[$ii]->price = (int)$item->price;}
          }
        }
        if (isset($_GET['order_query']) && !$_GET['show_page']) {
          header('Content-Type: application/json');
          exit(json_encode($services));
        }
        if($this->settings->theme == 'api'){
            $return->services = $services;
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
            die;
        }



        $this->smarty->assign('date_start', date('Y-m-d', strtotime('-1 week')));
        $this->smarty->assign('date_end', date('Y-m-d'));
        $sum = $this->db->result("SELECT SUM(op.price) AS sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.cashbox_id = (SELECT id FROM shop_cashbox WHERE name = 'Услуги') AND o.manager_id = {$uid} AND o.date >= CURDATE() ")->sum;
        $paid = $this->db->result("SELECT SUM(op.money_paid) AS paid FROM orders_payments op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.cashbox_id = (SELECT id FROM shop_cashbox WHERE name = 'Услуги') AND o.manager_id = {$uid} AND o.date >= CURDATE() ")->paid;
        $uncommitted = $sum - $paid;
        $this->smarty->assign('services', json_encode($services));
        $this->smarty->assign('status_options', array("Принято", "В работе", "В бутике<b class='ShAA_miniStatusMob'>, ждет клиента</b>", "Выдано клиенту"));
        $this->smarty->assign('order_types', array("default" => 'Магазин', "masters" => 'Руководство', "slaves" => 'Сотрудники', "clients" => 'Клиенты'));
        $this->smarty->assign('shops', $this->db->results("SELECT * FROM shops WHERE enabled = 1"));
        $this->smarty->assign('sum', $sum);
        $this->smarty->assign('paid', $paid);
        $this->smarty->assign('uncommitted', $uncommitted);
        $this->body = $this->smarty->fetch('service_list.tpl');
        return $this->body;
      }

      $service_items = $this->db->results("SELECT * FROM services_items");
      $this->smarty->assign('service_items', json_encode($service_items));
      $service_types = $this->db->results("SELECT * FROM service_types");
      $this->smarty->assign('service_types', json_encode($service_types));
      $this->smarty->assign('order_types', array("default" => 'Магазин', "masters" => 'Руководство', "slaves" => 'Сотрудники', "clients" => 'Клиенты'));
      $this->smarty->assign('cashbox_id', $this->db->result("SELECT * FROM shop_cashbox WHERE name = 'Услуги'")->id);
      $this->smarty->assign('shops', $this->db->results("SELECT * FROM shops WHERE enabled = 1"));
      $this->body = $this->smarty->fetch('service.tpl');
      return $this->body;
    }
}
