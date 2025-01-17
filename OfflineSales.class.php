<?PHP

require_once('Widget.class.php');


class OfflineSales extends Widget
{
    /* Конструктор */
    function OfflineSales(&$parent)
    {
        Widget::Widget($parent);
    }

    /* Отображение */
    function fetch()
    {
        if ($_GET['inkass_confirm']) {
          $confirm = 2;
          if($_POST['inkass_id']){
            $confirm = (int)$_POST['confirm'];
            if ($confirm == 1)$this->db->query("UPDATE inkass SET confirmed = {$confirm}, confirm_date = NOW() WHERE id = {$_POST['inkass_id']}");
            if ($confirm == 0)$this->db->query("UPDATE inkass SET rejected = 1, confirm_date = NOW() WHERE id = {$_POST['inkass_id']}");
          }
          $inkass = $this->db->result($sql="SELECT it.name AS user_name, s.name AS shop_name, i.sum, i.id, i.hash, i.date, i.confirmed, i.rejected, i.confirm_date, i.cashbox_id FROM inkass i LEFT JOIN shops s ON i.shop_id = s.shop_id LEFT JOIN inkassators it ON i.responsible_user_id = it.id WHERE i.hash = '{$_GET['inkass_confirm']}'");
          if (empty($inkass) || (($inkass->confirmed == 1 || $inkass->rejected == 1) && (time()-(60*60*24)) > strtotime($inkass->date))) return false;
          elseif ($inkass->confirmed == 1) $confirm = 1;
          elseif ($inkass->rejected == 1) $reject = 1;

          $cids = array(1=>1,3=>2,2=>3,4=>4,19=>6,20=>5);
          $inkass->cid = $cids[$inkass->cashbox_id];
          $this->smarty->assign('inkass', $inkass);
          $this->smarty->assign('confirm', $confirm);
          $this->smarty->assign('reject', $reject);
          $this->body = $this->smarty->fetch('inkass_confirm.tpl');
          return $this->body;
        }

        if (isset($_GET['sbr_online'])) {
          $order = $this->db->result($sql="SELECT pay.*, o.order_id AS main_order_id, o.receipt_number, o.code, TRIM(u.name) AS user_name FROM online_payments pay LEFT JOIN orders o ON pay.order_id = o.order_id LEFT JOIN orders_payments op ON pay.payment_id = op.payment_id LEFT JOIN users u ON pay.user_id = u.user_id WHERE pay.hash = '{$_GET['sp_token']}'");
          if (empty($order->main_order_id) && !empty($order->payment_id)){
            $pay = $this->db->result($sql="SELECT * FROM orders_payments WHERE id = '{$order->payment_id}'");
            $order = $this->db->result($sql="SELECT pay.*, o.order_id AS main_order_id, o.receipt_number, o.code, TRIM(u.name) AS user_name FROM online_payments pay LEFT JOIN orders o ON pay.order_id = o.order_id LEFT JOIN orders_payments op ON pay.payment_id = op.payment_id LEFT JOIN users u ON pay.user_id = u.user_id WHERE op.id = '{$order->debt_id}'");
          }
          $confirm = $order->paid;
          if (empty($order) || $order->paid == 2 ) return false;
          elseif ($order->paid == 4) {
            $this->db->query("UPDATE online_payments SET paid = 2 WHERE hash = '{$_GET['sp_token']}'");
          }
          $this->smarty->assign('order', $order);
          $this->smarty->assign('confirm', $confirm);
          $this->body = $this->smarty->fetch('sbr_online.tpl');
          return $this->body;
        }

        $uid = $this->db->escape($_SESSION['user']->user_id);
        $user = $this->db->result("SELECT * FROM users WHERE user_id = {$uid}");

        if ($_GET['m_token'] && $_GET['confirmation']) {
          $m_id = (int)$_GET['movement_id'];
          $movement = $this->db->result("SELECT * FROM movements WHERE movement_id = {$m_id} AND need_confirmation = 1");
          $wh_to = $this->db->result("SELECT * FROM warehouses WHERE warehouse_id = {$movement->warehouse_to}");
          $m_user = $this->db->result("SELECT * FROM users WHERE user_id = {$wh_to->user_id}");
          $m_token = substr(hash('sha256', $m_id . $m_user->password . "movementconfirm"), 0, 8);
          if ($_GET['m_token'] == $m_token) {
            $uid = $m_user->user_id;
            $user = $m_user;
          }
        }

        if ($_GET['accepted'] && $_GET['movement_id']) {
          $m_id = (int)$_GET['movement_id'];
          $this->db->query("UPDATE movements SET accepted = 1, accepted_user_id = {$uid}, accepted_time = NOW() WHERE movement_id = {$m_id}");
          exit("OK");
        }

        if (empty($user->cashbox_ids) && !in_array($_SESSION['group']->group_id, [2,5,15]) && $uid != 15532) {
            header("Location: /");
            exit();
        }

        $shop = $this->db->result("SELECT GROUP_CONCAT(DISTINCT shop_id) as ids FROM shop_cashbox WHERE id IN ({$user->cashbox_ids}) AND shop_id NOT IN (0,7,8)")->ids;
        if ($_SESSION['group']->group_id == 2 || $shop != 1) {
            $this->smarty->assign("allow_to_reserve", true);
            $this->smarty->assign("allow_from_reserve", true);
        }
        else{
          $this->smarty->assign("allow_to_reserve", false);
          $this->smarty->assign("allow_from_reserve", false);
          if (strpos($user->bookmarks, '23') !== false ) $this->smarty->assign("allow_to_reserve", true);
          if (strpos($user->bookmarks, '24') !== false ) $this->smarty->assign("allow_from_reserve", true);
        }

        if ($_SESSION['group']->group_id == 2) {
            $user->cashbox_ids = $this->db->result("SELECT GROUP_CONCAT(id) as ids FROM shop_cashbox WHERE 1")->ids;
        }

        if ($_GET['cashbox_id'] && strpos($user->cashbox_ids, $_GET['cashbox_id']) !== false ) {
            $user->cashbox_ids = $this->db->escape($_GET['cashbox_id']);
        }
        $this->smarty->assign("offlineSales", 1);

        if ($_GET['manager_orders']) {
          $this->smarty->assign("date_from", date('Y-m-d', strtotime('-7 days')));
          $this->smarty->assign("date_to", date('Y-m-d'));
          $this->body = $this->smarty->fetch('manager_orders.tpl');
          return $this->body;
        }

        if ($_GET['deposit_add']) {
          $payment_options = $this->db->results("SELECT * FROM payment_offline WHERE enabled = 1 AND `return` = 0 AND name NOT IN ('Долг', 'Погашение долга','Сертификат','Жехаревы','Расчетный счет') ORDER BY id");
          $this->smarty->assign("payment_options", json_encode($payment_options));
          $this->body = $this->smarty->fetch('deposit_add.tpl');
          return $this->body;
        }

        if ($_GET['delete_order_id']) {
            $order_id = $this->db->escape($_GET['delete_order_id']);
            $order    = $this->db->result("SELECT * FROM orders WHERE order_id = {$order_id} AND cashbox_id IN ({$user->cashbox_ids})");
            if ($order) {
                $this->db->query("UPDATE orders SET status = 3 WHERE order_id = {$order_id}");
                $this->db->query("DELETE FROM orders_payments WHERE order_id = {$order_id}");
            }
            exit('OK');
        }

        if ($_GET['delete_movement_id']) {
            $movement_id = $this->db->escape($_GET['delete_movement_id']);
            $movement    = $this->db->result("SELECT * FROM movements WHERE movement_id = {$movement_id}");
            if ($movement) {
                $this->db->query("DELETE FROM movements WHERE movement_id = {$movement_id}");
                $this->db->query("DELETE FROM movement_items WHERE movement_id = {$movement_id}");
            }
        }

        if ($_GET['confirm_movement_id']) {
            $movement_id = $this->db->escape($_GET['confirm_movement_id']);
            $movement    = $this->db->result("SELECT * FROM movements WHERE movement_id = {$movement_id}");
            if ($movement) {
                $this->db->query("UPDATE movements SET need_confirmation = 0 WHERE movement_id = {$movement_id}");
            }
            exit('OK');
        }

        if ($_GET['return_reservation_id']) {
            $movement_id = $this->db->escape($_GET['return_reservation_id']);
            $movement    = $this->db->result("SELECT * FROM movements WHERE movement_id = {$movement_id}");
            if ($movement) {
              $this->db->query("INSERT INTO movements (warehouse_to, warehouse_from, date) VALUES ({$movement->warehouse_from}, {$movement->warehouse_to}, NOW())");
              $new_movement_id = $this->db->insert_id();
              $wh_to = $this->db->result("SELECT * FROM warehouses WHERE warehouse_id = {$movement->warehouse_from}");
              $movement->items = $this->db->results("SELECT * FROM movement_items WHERE movement_id = {$movement_id}");
              foreach ($movement->items as $i) {
                $this->db->query("UPDATE items SET warehouse_id = {$movement->warehouse_from}, shop_id = {$wh_to->shop_id} WHERE item_id = {$i->item_id}");
                $this->db->query(sql_placeholder('INSERT INTO movement_items(movement_id, item_id, quantity) VALUES(?, ?, ?)',
                  $new_movement_id, $i->item_id, $i->quantity));
              }
              $this->db->query("UPDATE movements SET reservation_returned = 1 WHERE movement_id = {$movement_id}");
            }
        }

        if ($_GET['movement']) {
            $warehouse_filter = ($_SESSION['user']->group_id == 2) ? '' : " AND admin_only = 0 ";
            if(!empty($user->warehouses)) $warehouse_filter = " AND warehouse_id IN ({$user->warehouses})";
            if($_GET['reservation']){
              $shop = $this->db->result($sql = "SELECT GROUP_CONCAT(DISTINCT shop_id) AS shop_id FROM shop_cashbox WHERE id IN ({$user->cashbox_ids})")->shop_id;
              $shop_filter = ($_SESSION['user']->group_id == 15) ? '' : " AND shop_id IN ({$shop})";
            }
            if($_SESSION['user']->group_id == 6 || ($_SESSION['user']->group_id == 2 && in_array($_SESSION['user']->original_user_id,array(14,1330,1334,1808,2446,4877,14029)))){
              $sql = "SELECT * FROM warehouses WHERE movement_enabled = 1 AND reservation = 0 {$warehouse_filter}";
            }
            elseif($_GET['reservation']){
              $sql = "SELECT * FROM warehouses WHERE movement_enabled = 1 AND reservation = 0 {$shop_filter} AND warehouse_id NOT IN (61,46,37,59,54) {$warehouse_filter}";
            }
            else{$sql = "SELECT * FROM warehouses WHERE movement_enabled = 1 AND reservation = 0 AND warehouse_id NOT IN (61,46,37,59,54) {$warehouse_filter}";}
            $warehouses = $this->db->results($sql);

            if ($_GET['reservation']) {
              $sql = "SELECT * FROM warehouses WHERE (reservation = 1 OR warehouse_id IN (137,138,139,140,141,142,143,144,145,146,147,148)) {$shop_filter} {$warehouse_filter}";
              $warehouses_to = $this->db->results($sql);
              // Менеджеры торгового зала
              $managers = $this->db->results("SELECT * FROM users WHERE group_id = 13");
              $cashboxes = explode(',',$_SESSION['user']->cashbox_ids);
              foreach($managers as $k=>$manager){
                $m_cashboxes = explode(',',$manager->cashbox_ids);
                if(!array_intersect($cashboxes,$m_cashboxes)) unset($managers[$k]);
              }
              $this->smarty->assign("responsible_for_reservation", $managers);
              if ($_SESSION['user']->group_id == 13) {
                $this->smarty->assign("responsible_for_reservation", $this->db->results("SELECT * FROM users WHERE user_id = {$_SESSION['user']->user_id}"));
              }
              $this->smarty->assign("reservation", 1);
            }
            else {
              $warehouses_to = $warehouses;
            }
            $this->smarty->assign("warehouses_to", $warehouses_to);
            if(!empty($user->m_types)) $m_types_filter = " AND id IN ({$user->m_types})";
            $m_types = $this->db->results("SELECT * FROM movement_types WHERE 1 {$m_types_filter}");
            $this->smarty->assign("m_types", $m_types);

            if ($_GET['movement_id']) {
                $movement_id = $this->db->escape($_GET['movement_id']);
                $movement = $this->db->result("SELECT m.*, wf.name AS wf_name, wt.name AS wt_name, wt.reservation FROM movements m LEFT JOIN warehouses wf ON m.warehouse_from = wf.warehouse_id LEFT JOIN warehouses wt ON m.warehouse_to = wt.warehouse_id WHERE m.movement_id = {$movement_id}");
                $products = $this->db->results("SELECT p.model, p.sku, p.offline_price, i.barcode, i.item_id, i.size, w.name AS shop_name, mi.price, mi.quantity AS quantity, mi.accepted FROM items i LEFT JOIN products p ON p.product_id = i.product_id LEFT JOIN movement_items mi ON mi.item_id = i.item_id LEFT JOIN warehouses w ON w.warehouse_id = i.warehouse_id WHERE mi.movement_id = {$movement_id}");
                $movement->products = new StdClass();
                foreach ($products as $key => $product) {
                    $barcode = $product->barcode;
                    $movement->products->$barcode = $product;
                }
                if ($movement->user_id != 0) {
                  $movement->user = $this->db->result("SELECT user_id, name, card_number, phone_number, personal_discount, photo FROM users WHERE user_id = {$movement->user_id}");
                }
                if ($_GET['m_token']) {
                  $movement->token = $_GET['m_token'];
                }
                if ($_GET['confirmation'] && $movement->need_confirmation == 1) {
                  $this->smarty->assign("confirmation", 1);
                  $movement->confirmation = 1;
                }
                if ($_GET['acceptance']) {
                  $this->smarty->assign("acceptance", 1);
                  $movement->acceptance = 1;
                }
                $this->smarty->assign("movement_object", json_encode($movement));
                $this->smarty->assign("movement", $movement);
            }
            $this->smarty->assign("warehouses", $warehouses);
            $this->smarty->assign('title', 'Бутик одежды больших размеров | бутик Лакшери Стор');
            if(date('G') >= 21 || date('G') < 9)$this->smarty->assign("block", true);
            $this->body = $this->smarty->fetch('item_movement.tpl');
            return $this->body;
        }

        if ($_GET['movement_list']) {
            $where = " m.date > subdate(current_date, 7) ";
            $join = '';
            if ($_GET['reservation']) {
              $shop = $this->db->result("SELECT GROUP_CONCAT(DISTINCT shop_id) AS shop_id FROM shop_cashbox WHERE id IN ({$user->cashbox_ids})")->shop_id;
              $wh = $this->db->result("SELECT GROUP_CONCAT(DISTINCT warehouse_id) AS ids FROM warehouses WHERE shop_id IN ({$shop})")->ids;
              $where .= " AND w2.reservation = 1 AND m.reservation_returned = 0 AND (m.warehouse_from IN ({$wh}) OR m.warehouse_to IN ({$wh}))";
              $this->smarty->assign("reservation", true);
              if ($_GET['query']) {
                $where = " w2.reservation = 1 AND m.reservation_returned = 0 ";
                $query = $this->db->escape($_GET['query']);
                $join .= "LEFT JOIN movement_items mi ON mi.movement_id = m.movement_id
                          LEFT JOIN items i ON i.item_id = mi.item_id
                          LEFT JOIN products p ON p.product_id = i.product_id
                          LEFT JOIN users cl ON cl.user_id = m.user_id";
                $where .= " AND (m.movement_id LIKE '%{$query}%' OR resp.phone_number LIKE '%{$query}%' OR resp.name LIKE '%{$query}%' OR cl.phone_number LIKE '%{$query}%' OR cl.name LIKE '%{$query}%' OR i.barcode LIKE '%{$query}%' OR p.sku LIKE '%{$query}%') ";
                $this->smarty->assign("query", $query);
              }
            }
            elseif ($_GET['acceptance']) {
              $this->smarty->assign("acceptance", true);
              $where .= " AND w1.reservation = 0 AND w2.reservation = 0 AND m.accepted = 0 ";
            }
            else {
              $where .= " AND w1.reservation = 0 AND w2.reservation = 0 ";
            }
            $movements = $this->db->results("
                SELECT m.*, w1.name AS shop_from_name, w2.name AS shop_to_name, resp.name as responsible_name, mt.name as type_name
                  FROM movements m
                  LEFT JOIN warehouses w1 ON w1.warehouse_id = m.warehouse_from
                  LEFT JOIN warehouses w2 ON w2.warehouse_id = m.warehouse_to
                  LEFT JOIN users resp ON resp.user_id = m.responsible
                  LEFT JOIN movement_types mt ON mt.id = m.type
                  {$join}
                WHERE {$where}
                GROUP BY m.movement_id
                ORDER BY m.date DESC");
            foreach ($movements as $k => $mvmt) {
                $mvmt->items = $this->db->results("SELECT p.model, p.sku, c.name, i.size, p.offline_price, mi.price as res_price, mi.accepted as item_accepted FROM items i LEFT JOIN movement_items mi ON mi.item_id = i.item_id LEFT JOIN products p ON i.product_id = p.product_id LEFT JOIN colors c ON c.color_id = p.color_id WHERE mi.movement_id = {$mvmt->movement_id}");
                $mvmt->editable = (time() - strtotime($mvmt->date) < (50*60));
                if ($_GET['reservation'] && $mvmt->user_id != 0) {
                  $mvmt->user = $this->db->result("SELECT * FROM users WHERE user_id = {$mvmt->user_id}");
                }
                if ($mvmt->created_user_id != 0) $mvmt->created_user = $this->db->result("SELECT name FROM users WHERE user_id = {$mvmt->created_user_id}")->name;
                if ($mvmt->accepted_user_id != 0) $mvmt->accepted_user = $this->db->result("SELECT name FROM users WHERE user_id = {$mvmt->accepted_user_id}")->name;
            }
            if(date('G') >= 21 || date('G') < 9)$this->smarty->assign("block", true);
            $this->smarty->assign("movements", $movements);
            $this->smarty->assign('title', 'Бутик одежды больших размеров | бутик Лакшери Стор');
            $this->body = $this->smarty->fetch('item_movement_list.tpl');
            return $this->body;
        }

        if ($_GET['expense']) {
          if ($_GET['expense_id']) {
            $expense_id = (int) $_GET['expense_id'];
            $expense = $this->db->result("SELECT * FROM expenses WHERE id = {$expense_id}");
            if ($expense->date < date('Y-m-d') . ' 00:00:00')$this->smarty->assign('block', true);
            $this->smarty->assign('expense', $expense);
          }
          else {
            $this->smarty->assign('expense', null);
          }
          $this->smarty->assign('cashbox_ids', $this->db->results("SELECT DISTINCT * FROM shop_cashbox WHERE id IN ({$user->cashbox_ids}) AND enabled = 1"));
          $this->smarty->assign('shops', $this->db->results("SELECT DISTINCT s.* FROM shops s LEFT JOIN shop_cashbox sc ON sc.shop_id = s.shop_id WHERE sc.id IN ({$user->cashbox_ids}) AND s.enabled = 1"));
          $this->body = $this->smarty->fetch('expense.tpl');
          return $this->body;
        }

        if ($_GET['expenses_list']) {
          $date_check = " AND e.date >= '" . date('Y-m-d', strtotime('-7 day')) . " 00:00:00'";
          if ($_GET['date']) {
            $date_check = " AND e.date >= '" . date($_GET['date']) . " 00:00:00'";
          }
          if (isset($_GET['date_start']) && !empty($_GET['date_start'])) {
            $date = date($_GET['date_start']) . ' 00:00:00';
            $date_check = " AND e.date >= '{$date}' ";
          }
          if (isset($_GET['date_end']) && !empty($_GET['date_end'])) {
            $date = date($_GET['date_end']) . ' 23:59:59';
            $date_check .= " AND e.date <= '{$date}' ";
          }
          $shop_check = "";
          if (isset($_GET['shop_id']) && !empty($_GET['shop_id'])) {
            $shop_check = " AND e.shop_id = '{$_GET['shop_id']}' ";
          }
          if ($_GET['delete_expense_id']) {
            $e_id = (int) $_GET['delete_expense_id'];
            $this->db->query("DELETE FROM expenses WHERE id = {$e_id}");
          }
          if($_SESSION['user']->group_id == 9) $filter = " (e.shop_id IN (SELECT shop_id FROM shop_cashbox sc WHERE sc.id IN ({$user->cashbox_ids})) OR e.cashbox_id IN ({$user->cashbox_ids}))";
          else $filter .= "e.cashbox_id IN ({$user->cashbox_ids})";
          $expenses = $this->db->results($sql="SELECT e.*, s.name AS shop_name FROM expenses e LEFT JOIN shops s ON s.shop_id = e.shop_id WHERE {$filter} {$date_check} {$shop_check} ORDER BY e.id DESC");
          $expense_types = array('general' => 'Расходы персонала', 'advance_payment' => 'Аванс', 'other' => 'Прочие расходы');
          foreach ($expenses as $e) {
            $e->expense_type = $expense_types[$e->expense_type];
            if ($e->date < date('Y-m-d') . ' 00:00:00')$e->block = true;
          }
          $this->smarty->assign('date_start', isset($_GET['date_start']) ? $_GET['date_start'] : date('Y-m-d', strtotime('-4 days')));
          $this->smarty->assign('date_end', isset($_GET['date_end']) ? $_GET['date_end'] : date('Y-m-d'));
          $this->smarty->assign('shop_id', $_GET['shop_id']);
          $this->smarty->assign('shops', $this->db->results("SELECT DISTINCT s.* FROM shops s LEFT JOIN shop_cashbox sc ON sc.shop_id = s.shop_id WHERE sc.id IN ({$user->cashbox_ids}) AND s.enabled = 1"));
          $this->smarty->assign('expenses', $expenses);
          $this->body = $this->smarty->fetch('expenses_list.tpl');
          return $this->body;
        }

        if ($_POST['expense_type'] && $_POST['sum'] && $_POST['shop_id']) {
          if ($_POST['expense_id']) {
            $this->db->query(sql_placeholder("UPDATE expenses SET cashbox_id = ?, shop_id = ?, expense_type = ?, sum = ?, comment = ?, user_id = ? WHERE id = ?",
                $_POST['cashbox_id'], $_POST['shop_id'], $_POST['expense_type'], $_POST['sum'], $_POST['comment'], $user->user_id, (int) $_POST['expense_id']));
          }
          else {
            $this->db->query(sql_placeholder("INSERT INTO expenses(cashbox_id, shop_id, expense_type, sum, comment, date, user_id) VALUES(?, ?, ?, ?, ?, NOW(), ?)",
              $_POST['cashbox_id'], $_POST['shop_id'], $_POST['expense_type'], $_POST['sum'], $_POST['comment'], $user->user_id));

          }
          header("Location: /index.php?module=OfflineSales&expenses_list=1");
          exit();
        }

        if ($_GET['inkass']) {
          if ($_GET['inkass_id']) {
            $inkass_id = (int) $_GET['inkass_id'];
            $inkass = $this->db->result("SELECT * FROM inkass WHERE id = {$inkass_id}");
            $this->smarty->assign('inkass', $inkass);
          }
          else {
            $this->smarty->assign('inkass', null);
          }
          $filter ='AND user_id NOT IN (4877,1330)';
          if (in_array($_SESSION['user']->user_id, array(4877,1330))) $filter ='';
          $this->smarty->assign('inkassators', $this->db->results("SELECT * FROM inkassators WHERE 1 {$filter} ORDER BY id ASC"));
          $this->smarty->assign('cashbox_ids', $this->db->results("SELECT DISTINCT * FROM shop_cashbox WHERE id IN ({$user->cashbox_ids}) AND enabled = 1 AND id NOT IN (14,17)"));
          $this->smarty->assign('shops', $this->db->results("SELECT DISTINCT s.* FROM shops s LEFT JOIN shop_cashbox sc ON sc.shop_id = s.shop_id WHERE sc.id IN ({$user->cashbox_ids}) AND s.enabled = 1"));
          $this->smarty->assign('title', 'Инкассация | бутик Лакшери Стор');
          $this->body = $this->smarty->fetch('inkass.tpl');
          return $this->body;
        }

        if ($_GET['inkass_list']) {
          if ($_GET['delete_inkass_id']) {
            $i_id = (int) $_GET['delete_inkass_id'];
            $this->db->query("DELETE FROM inkass WHERE id = {$i_id}");
          }
          $date_check =  ' AND i.date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)';
          if($_SESSION['user']->user_id == 139026 || $_SESSION['user']->user_id == 127296)$date_check =  ' AND i.date >= DATE_SUB(CURDATE(), INTERVAL 45 DAY)';//$date_check =  " AND i.date >= '".date('Y-m')."-01 00:00:00'";

          $shop_check = "";
          if (isset($_GET['shop_id']) && !empty($_GET['shop_id'])) {
            $shop_check = " AND i.shop_id = '{$_GET['shop_id']}' ";
          }
          if (isset($_GET['date_start']) && !empty($_GET['date_start'])) {
            $date = date($_GET['date_start']) . ' 00:00:00';
            $date_check = " AND i.date >= '{$date}' ";
          }
          if (isset($_GET['date_end']) && !empty($_GET['date_end'])) {
            $date = date($_GET['date_end']) . ' 23:59:59';
            $date_check .= " AND i.date <= '{$date}' ";
          }
          if($_SESSION['user']->group_id == 9) $filter = " (i.shop_id IN (SELECT shop_id FROM shop_cashbox sc WHERE sc.id IN ({$user->cashbox_ids})) OR i.cashbox_id IN ({$user->cashbox_ids}))";
          else $filter .= "i.cashbox_id IN ({$user->cashbox_ids})";
          $this->smarty->assign('date_start', isset($_GET['date_start']) ? $_GET['date_start'] : date('Y-m-d', strtotime('-4 days')));
          $this->smarty->assign('date_end', isset($_GET['date_end']) ? $_GET['date_end'] : date('Y-m-d'));
          $this->smarty->assign('shop_id', $_GET['shop_id']);
          $this->smarty->assign('shops', $this->db->results("SELECT DISTINCT s.* FROM shops s LEFT JOIN shop_cashbox sc ON sc.shop_id = s.shop_id WHERE sc.id IN ({$user->cashbox_ids}) AND s.enabled = 1"));
          $this->smarty->assign('inkass', $this->db->results("SELECT i.*, s.name AS shop_name, it.name FROM inkass i LEFT JOIN shops s ON s.shop_id = i.shop_id LEFT JOIN inkassators it ON it.id = i.responsible_user_id WHERE {$filter} {$date_check} {$shop_check} ORDER BY i.id DESC"));
          $this->smarty->assign('title', 'Инкассация | бутик Лакшери Стор');
          $this->body = $this->smarty->fetch('inkass_list.tpl');
          return $this->body;
        }

        if ($_POST['inkass'] && $_POST['sum'] && $_POST['shop_id']) {
          $im_agent_fee = isset($_POST['im_agent_fee']) ? 1 : 0;
          $im_sber_ai   = isset($_POST['im_sber_ai']) ? 1 : 0;
          $im_sber_is   = isset($_POST['im_sber_is']) ? 1 : 0;
          $im_inkass    = isset($_POST['im_inkass']) ? 1 : 0;
          if ($_POST['responsible_user_id']){
            $inkassator = $this->db->result("SELECT * FROM inkassators WHERE id = {$_POST['responsible_user_id']}");
            $responsible_user_id = $_POST['responsible_user_id'];
            $phones = explode(',',$inkassator->phone);
          }
          else{$responsible_user_id = 0;}
          if ($_POST['inkass_id']) {
            $inkass = $this->db->result("SELECT * FROM inkass WHERE id = {$_POST['inkass_id']}");
            if ($_POST['responsible_user_id'] && $inkass->confirmed == 0){
              $inkass_link = "Подтвердите инкассацию https://{$_SERVER['HTTP_HOST']}/i/c/{$inkass->hash}/";
              foreach($phones as $phone){
                $args = array('sender' => 'lsboutique', 'message_text' => $inkass_link, 'phone_number' => $phone, 'user_id' => (!empty($inkassator->user_id) ? $inkassator->user_id : 0), 'sms_only' => 1);
                Job::push( 'SmsJob', $args, false, 'critical' );
              }
            }
            $this->db->query(sql_placeholder("UPDATE inkass SET cashbox_id = ?, shop_id = ?, sum = ?, comment = ?, user_id = ?, responsible_user_id = ?, im_agent_fee = ?, im_sber_ai = ?, im_sber_is = ?, im_inkass = ? WHERE id = ?",
                $_POST['cashbox_id'], $_POST['shop_id'], $_POST['sum'], $_POST['comment'], $user->user_id, $responsible_user_id, $im_agent_fee, $im_sber_ai, $im_sber_is, $im_inkass, (int) $_POST['inkass_id']));
          }
          else {
            set_include_path(get_include_path() . PATH_SEPARATOR . $_SERVER['DOCUMENT_ROOT'] . '/third_party/RandomLib/');
            require_once 'autoload.php';
            $string = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            $factory = new RandomLib\Factory;
            $generator = $factory->getMediumStrengthGenerator();
            $inkass_hash = $generator->generateString(16, $string);
            $cids = array(1=>1,3=>2,2=>3,4=>4,19=>6,20=>5);
            $this->db->query(sql_placeholder("INSERT INTO inkass(cashbox_id, shop_id, sum, comment, date, user_id, responsible_user_id, hash, im_agent_fee, im_sber_ai, im_sber_is, im_inkass) VALUES(?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?, ?, ?)",
              $_POST['cashbox_id'], $_POST['shop_id'], $_POST['sum'], $_POST['comment'], $user->user_id, $responsible_user_id, $inkass_hash, $im_agent_fee, $im_sber_ai, $im_sber_is, $im_inkass));
              if ($_POST['responsible_user_id']){
                $inkass_link = "Подтвердите инкассацию https://{$_SERVER['HTTP_HOST']}/i/c/{$inkass_hash}/ касса {$cids[$_POST['cashbox_id']]}";
                foreach($phones as $phone){
                  $args = array('sender' => 'lsboutique', 'message_text' => $inkass_link, 'phone_number' => $phone, 'user_id' => (!empty($inkassator->user_id) ? $inkassator->user_id : 0), 'sms_only' => 1);
                  Job::push( 'SmsJob', $args, false, 'critical' );
                }
              }

          }
          header("Location: /index.php?module=OfflineSales&inkass_list=1");
          exit();
        }

        if ($_GET['debts']) {
          $shops = $this->db->results("SELECT * FROM shops WHERE shop_id IN (SELECT shop_id FROM shop_cashbox WHERE shop_id != 0)");
          $this->smarty->assign("shops", $shops);
          $cashboxes = $this->db->results("SELECT * FROM shop_cashbox WHERE enabled = 1 AND id NOT IN (14,17)");
          $this->smarty->assign("cashboxes", $cashboxes);

          $where = '';
          $s_where = '';
          if(!empty($_GET['search'])){
            $q = $this->db->escape($_GET['search']);
            $where .= " AND ((o.order_id = '{$q}' OR o.receipt_number = '{$q}')
               OR EXISTS (SELECT * FROM users u WHERE (u.name LIKE '%{$q}%' OR u.phone_number LIKE '%{$q}%' OR u.card_number LIKE '%{$q}%') AND o.user_id = u.user_id)
               OR EXISTS (SELECT * FROM orders_products WHERE (orders_products.barcode LIKE '%{$q}%' OR orders_products.sku LIKE '%{$q}%' OR orders_products.product_id LIKE '%{$q}%') AND orders_products.order_id = o.order_id) )";
          }
          if (!empty($_GET['shop_id'])) {
              $where .= " AND sc.shop_id = " . (int)$_GET['shop_id'];
          }
          if (!empty($_GET['cashbox'])) {
              $where .= " AND o.cashbox_id = " . (int)$_GET['cashbox'];
          }
          if (!empty($_GET['responsible_person_id'])) {
              $s_where .= " AND responsible_person_id IN (" . implode(',',$_GET['responsible_person_id']) . ")";
          }
          if (!empty($_GET['offline_manager_id'])) {
              $where .= " AND op.offline_manager_id = " . (int)$_GET['offline_manager_id'];
          }

          if (!empty($_GET['all_time']) || !empty($_GET['shop_id']) || !empty($_GET['search'])) {
              $where .= " AND o.date > '2016-12-04 00:00' ";
          }
          else {
            $where .= " AND o.date >= DATE_SUB(CURDATE(), INTERVAL 45 DAY) ";
          }
          if (!empty($_GET['responsible_person_id'])) {

            $debts_tmp = $this->db->results($sql="SELECT op.*, op.money_paid AS debt_amount, osp.name AS rp_name, osp.id AS rp_id, op.id AS debt_id
              FROM orders_payments op
              LEFT JOIN orders o        ON o.order_id = op.order_id
              LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id
              LEFT JOIN shops s         ON sc.shop_id = s.shop_id
              LEFT JOIN offline_sales_person osp ON osp.id = responsible_person_id
              WHERE op.debt_paid_off = 0 AND op.payment_id = 4 AND o.date > '2016-12-04 00:00' {$s_where} {$where}
              ORDER BY op.date ASC;");
            foreach ($debts_tmp as $debt) {
              $debt->paid_off_amount = $this->db->result($sql="SELECT SUM(op.money_paid) AS s FROM orders_payments op WHERE op.debt_id = {$debt->debt_id};")->s;
              $debt->debt_amount    -= $debt->paid_off_amount;
              if ($debt->debt_amount < 501) {
                // Тут по идее надо сделать отметку о том, что заказ оплачен
              }
              else {
                $debts_total[$debt->rp_id]->rp_name = $debt->rp_name;
                $debts_total[$debt->rp_id]->debt_amount += $debt->debt_amount;
              }
            }
            $this->smarty->assign("debts_total", $debts_total);
          }
          $offline_sales_person = $this->db->results($sql="SELECT osp.*, SUM(op.money_paid) AS money_total FROM offline_sales_person osp
            LEFT JOIN orders_payments op ON op.responsible_person_id = osp.id
            LEFT JOIN orders o ON o.order_id = op.order_id
            LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id
            WHERE op.debt_paid_off = 0 AND op.payment_id = 4 AND o.date > '2016-12-04 00:00' {$where}
            GROUP BY op.responsible_person_id");

          $offline_managers = $this->db->results($sql="SELECT osp.*
            FROM users osp
            LEFT JOIN orders_products op ON op.offline_manager_id = osp.user_id
            LEFT JOIN orders o ON o.order_id = op.order_id
            LEFT JOIN orders_payments opay ON opay.order_id = o.order_id
            LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id
            WHERE opay.debt_paid_off = 0 AND opay.payment_id = 4 AND o.date > '2016-12-04 00:00' {$where}
            GROUP BY op.offline_manager_id");

          $debts = $this->db->results($sql="SELECT op.*, op.money_paid AS debt_amount, sc.name AS cashbox_name, DATEDIFF(CURDATE(), op.date) AS days, s.name AS shop, o.receipt_number
            FROM orders_payments op
            LEFT JOIN orders o        ON o.order_id = op.order_id
            LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id
            LEFT JOIN shops s         ON sc.shop_id = s.shop_id
            WHERE op.debt_paid_off = 0 AND op.payment_id = 4 AND o.date > '2016-12-04 00:00' {$s_where} {$where}
            ORDER BY op.date ASC;");

          $grouped_debts = array();
          foreach ($debts as $k => $debt) {
            $a = array();
            $debt->user            = $this->db->result("SELECT * FROM users WHERE user_id = {$debt->user_id};");
            $debt->paid_off_amount = $this->db->result($sql = "SELECT SUM(op.money_paid) AS s FROM orders_payments op WHERE op.debt_id = {$debt->id};")->s;
            $debt->payments        = $this->db->results("SELECT op.*, po.name AS payment_option, sc.name AS cashbox_name FROM orders_payments op LEFT JOIN payment_offline po ON po.id = op.payment_id LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id WHERE op.debt_id = {$debt->id}");
            $debt->products        = $this->db->results("SELECT * FROM orders_products WHERE order_id = {$debt->order_id}");
            foreach($debt->products as $p) $a[] = $p->offline_manager_id;
            $ids = implode(',',$a);
            $debt->resp            = $this->db->result($sql = "SELECT GROUP_CONCAT(name SEPARATOR ', ') AS s FROM users WHERE user_id IN ({$ids});")->s;
            $debt->remain = $debt->debt_amount - $debt->paid_off_amount;
            if ($debt->remain < 501) {
              // Тут по идее надо сделать отметку о том, что заказ оплачен
            }
            else {
                $grouped_debts["{$debt->user->name}, {$debt->user->phone_number}"]['debts'][] = $debt;
                $grouped_debts["{$debt->user->name}, {$debt->user->phone_number}"]['user']    = $debt->user;
                $grouped_debts["{$debt->user->name}, {$debt->user->phone_number}"]['debt']   += $debt->remain;
                $grouped_debts["{$debt->user->name}, {$debt->user->phone_number}"]['user_id'] = $debt->user_id;
            }
          }

          $this->smarty->assign("offline_managers", $offline_managers);
          $this->smarty->assign("offline_sales_person", $offline_sales_person);
          $this->smarty->assign("grouped_debts", $grouped_debts);
          $this->smarty->assign('title', 'Задолженности | бутик Лакшери Стор');
          $this->body = $this->smarty->fetch('debts.tpl');
          return $this->body;
        }

        if ($_GET['debt']) {
          $debt_id = $this->db->escape($_GET['debt']);
          $debt    = $this->db->result("SELECT *, money_paid AS debt_amount FROM orders_payments WHERE id = {$debt_id}");
          $payment_options = $this->db->results("SELECT * FROM payment_offline WHERE enabled = 1 AND name NOT IN ('Долг', 'Погашение долга') ORDER BY id");
          $debt->payments  = $this->db->results("SELECT op.*, po.name AS payment_option, sc.name AS cashbox_name FROM orders_payments op LEFT JOIN payment_offline po ON po.id = op.payment_id LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id WHERE op.debt_id = {$debt_id}");
          $debt->products  = $this->db->results("SELECT * FROM orders_products op WHERE op.order_id = {$debt->order_id}");
          $debt->user      = $this->db->result("SELECT * FROM users WHERE user_id = {$debt->user_id};");
          $debt->paid_off_amount = $this->db->result("SELECT SUM(op.money_paid) AS s FROM orders_payments op WHERE op.debt_id = {$debt->id};")->s;
          $debt->cashbox   = $this->db->result("SELECT * FROM shop_cashbox WHERE id = (SELECT cashbox_id FROM orders WHERE order_id = {$debt->order_id});");
          $debt->rn   = $this->db->result("SELECT receipt_number AS rn FROM orders WHERE order_id = {$debt->order_id};")->rn;
          $cashboxes_json  = json_encode($this->db->results("SELECT * FROM shop_cashbox WHERE id IN ({$user->cashbox_ids})"));
          $this->smarty->assign('cashboxes_json', $cashboxes_json);
          $this->smarty->assign("debt", $debt);
          $this->smarty->assign("payment_options", json_encode($payment_options));
          $this->smarty->assign('title', 'Бутик одежды больших размеров | бутик Лакшери Стор');
          $this->body = $this->smarty->fetch('debt.tpl');
          return $this->body;
        }

        if ($_GET['personal_debt']) {
          $this->smarty->assign('title', 'Бутик одежды больших размеров | бутик Лакшери Стор');
          $user_id = $this->db->escape($_GET['personal_debt']);
          $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id}");
          $where = "op.payment_id = (SELECT id FROM payment_offline WHERE name='Долг') AND op.debt_paid_off = 0 AND op.user_id = {$user_id}";
          $debts = $this->db->results("SELECT op.*, osp.name AS manager_name, o.receipt_number FROM orders_payments op LEFT JOIN offline_sales_person osp ON op.responsible_person_id = osp.id LEFT JOIN orders o ON o.order_id = op.order_id WHERE {$where}");
          $user->debt_sum = 0;
          foreach ($debts as $k => $debt) {
            $debt->total_order = $this->db->result("SELECT SUM(price) AS sum FROM orders_products WHERE order_id = {$debt->order_id}")->sum;
            $debt->products        = $this->db->results("SELECT * FROM orders_products WHERE order_id = {$debt->order_id}");
            foreach($debt->products as $p) $a[] = $p->offline_manager_id;
            $ids = implode(',',$a);
            $debt->resp            = $this->db->result($sql = "SELECT GROUP_CONCAT(name SEPARATOR '<br>') AS s FROM users WHERE user_id IN ({$ids});")->s;
            $debt->paid_off_amount = $this->db->result("SELECT SUM(money_paid) AS sum FROM orders_payments WHERE debt_id = {$debt->id}")->sum;
            $debt->remaining_debt = $debt->money_paid - $debt->paid_off_amount;
            if($debt->remaining_debt == 0 || $debt->total_order == 0) unset($debts[$k]);
            else $user->debt_sum += $debt->remaining_debt;
          }
          if (strtoupper(substr(PHP_OS, 0, 3)) != 'WIN') {
              $user->debt_sum_words = Numbers_Words::toWords($user->debt_sum, "ru");
          }
          $this->smarty->assign("debts", $debts);
          $this->smarty->assign("user", $user);
          $response = $this->smarty->fetch('personal_debt.tpl');
          exit($response);
        }

        if ($_GET['returns']) {
          $this->body = $this->smarty->fetch('returns.tpl');
          return $this->body;
        }

        if ($_POST['movement']) {
            $data = json_decode($_POST['movement'], true);

            if ( $data['movement_id'] ) {
                $movement_id = $data['movement_id'];
                if ($data['reservation_date'] || $data['responsible'] || $data['user_id']) {
                  $this->db->query("UPDATE movements SET reservation_date = '{$data['reservation_date']}', responsible = {$data['responsible']}, user_id = {$data['user_id']}, created_user_id = {$_SESSION['user']->user_id} WHERE movement_id = {$data['movement_id']}");
                }
            }
            else {
                $this->db->query("INSERT INTO movements (warehouse_to, warehouse_from, date, reservation_date, responsible, user_id, created_user_id, type) VALUES ({$data['warehouse_to']}, {$data['warehouse_from']}, NOW(), '{$data['reservation_date']}', {$data['responsible']}, {$data['user_id']}, {$_SESSION['user']->user_id}, {$data['type']})");
                $movement_id = $this->db->insert_id();
            }

            $this->db->query("DELETE FROM movement_items WHERE movement_id = {$movement_id}");
            foreach ($data['products'] as $item_id => $product) {
                $this->db->query(sql_placeholder('INSERT INTO movement_items(movement_id, item_id, quantity, price) VALUES(?, ?, ?, ?)',
                    $movement_id, $product['item_id'], $product['quantity'], $product['price']));
                // Move items only if reservation
                if ($data['reservation_date'] || $data['responsible'] || $data['user_id']) {
                  $shop_id = $this->db->result("SELECT shop_id FROM warehouses WHERE warehouse_id = {$data['warehouse_to']}")->shop_id;
                  $this->db->query(sql_placeholder('UPDATE items SET shop_id = ?, warehouse_id = ? WHERE item_id = ?',
                          $shop_id, $data['warehouse_to'], $product['item_id']));
                }
            }

            //confirmation
            $whto = $this->db->result("SELECT * FROM warehouses WHERE warehouse_id = {$data['warehouse_to']}");
            $movement = $this->db->result("SELECT * FROM movements WHERE movement_id = {$movement_id}");
            if ($whto->user_id && $whto->confirm && $movement->need_confirmation == 0) {
              //send sms
              $user = $this->db->result("SELECT * FROM inkassators WHERE warehouse = {$whto->warehouse_id}");
              $m_token = substr(hash('sha256', $movement_id.$user->password."movementconfirm"), 0, 8);
              $msg = "Подтвердите перемещение товара по ссылке: https://{$_SERVER['SERVER_NAME']}/m_confirm/{$movement_id}/{$m_token}";
              $phones = explode(',',$user->phone);
              foreach($phones as $phone){
                $args = array( 'sender' => 'lsboutique', 'message_text' => $msg, 'phone_number' => $phone, 'user_id' => (isset($user->user_id) ? $user->user_id : 0), 'sms_only' => true);
                Job::push( 'SmsJob', $args, false, 'critical' );
              }
              //put a flag
              $this->db->query("UPDATE movements SET need_confirmation = 1 WHERE movement_id = {$movement_id}");
            }

            echo $movement_id;
            exit();
        }

        if ($_POST['edit_user_id']) {
            $user_id = (int) $_POST['edit_user_id'];
            $data   = json_decode($_POST['user_data'], true);
            $hidden = $data['hidden'] ? $data['hidden'] : 0;
            $vip    = $data['vip'] ? $data['vip'] : 0;
            $data['phone_number'] = str_replace(array('(', ')', ' ', '-'), '', $data['phone_number']);
            $phone_query = '';
            if(!empty($data['phone_number']))$phone_query = "phone_number = '{$data['phone_number']}',";
            $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id}");
            $show_hidden_brands = implode(",", $data['hidden_brands']);
            if ($user->group_id != 1) {
              exit('Not Allowed');
            }
            $this->db->query("UPDATE users SET
              name = '{$data['name']}',
              email = '{$data['email']}',
              birth_date = '{$data['birth_date']}',
              personal_discount = {$data['personal_discount']},
              pref_messenger = '{$data['msg_str']}',
              {$phone_query}
              show_hidden_brands = '{$show_hidden_brands}',
              hidden = {$hidden},
              vip = {$vip}
              WHERE user_id = {$user_id}");

            // update client_groups
            $this->db->query("DELETE FROM users_client_groups WHERE user_id = {$user_id}");
            foreach ($data['client_groups'] as $cg) {
                $this->db->query("INSERT INTO users_client_groups (user_id, client_group_id) VALUES ({$user_id}, {$cg})");
            }
            // update client_managers
            $this->db->query("DELETE FROM sr_manager2users WHERE user_id = {$user_id}");
            foreach ($data['managers'] as $man) {
                $this->db->query("INSERT INTO sr_manager2users (manager_id, user_id) VALUES ({$man}, {$user_id})");
            }
            // update shops
            $this->db->query("DELETE FROM users2shops WHERE user_id = {$user_id}");
            foreach ($data['shops'] as $sh) {
                $this->db->query("INSERT INTO users2shops (user_id, shop_id) VALUES ({$user_id}, {$sh})");
            }
            // update brands
            $this->db->query("DELETE FROM users2brands WHERE user_id = {$user_id}");
            foreach ($data['brands'] as $br) {
                $this->db->query("INSERT INTO users2brands (user_id, brand_id) VALUES ({$user_id}, {$br})");
            }
            exit('OK');
        }

        if ($_POST['debt']) {
          $data = json_decode($_POST['debt'], true);
          $debt_id = $data['debt_id'];
          foreach ($data['payments'] as $k => $payment) {
            $order = $this->db->result("SELECT * FROM orders_payments WHERE id = {$debt_id} ");
            $this->db->query(sql_placeholder('INSERT INTO orders_payments(debt_id, payment_id, money_paid, date, responsible_person_id, cashbox_id) VALUES(?, ?, ?, NOW(), ?, ?)',
                $debt_id, $payment['payment_option'], $payment['money_paid'], $_SESSION['user']->user_id, $payment['cashbox_id']));
            if($payment['payment_option'] == 21 && !empty($order->user_id)){
              $payment_id = $this->db->insert_id();
              $m_user = $this->db->result("SELECT * FROM users WHERE user_id = {$order->user_id} ");
              $m_token = substr(hash('sha256', $order_id . $payment_id . $m_user->password . "onlinepay"), 0, 16);
              $text = "Оплата на сумму {$payment['money_paid']}р https://lsboutique.ru/spay/{$m_token}/";
              $m = "Оплата на сумму {$payment['money_paid']}р, по задолжности {$debt_id} https://lsboutique.ru/spay/{$m_token}/";
              $this->db->query($sql="INSERT INTO online_payments (order_id, payment_id, user_id, amount, hash, date) VALUES ({$order->order_id}, {$payment_id}, {$order->user_id}, {$payment['money_paid']}, '{$m_token}', NOW())");
              $args = array('sender' => 'lsboutique', 'message_text' => $text, 'phone_number' => $m_user->phone, 'user_id' => (!empty($m_user->user_id) ? $m_user->user_id : 0), 'sms_only' => 1);
              Job::push( 'SmsJob', $args, false, 'critical' );
              $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "online_payments" );
              Job::push('SlackJob', $args);
            }
          }
          if ($data['total_paid'] == $data['total_debt']) {
            $this->db->query("UPDATE orders_payments SET debt_paid_off = 1 WHERE id = {$debt_id};");
          }
          exit('OK');
        }

        $mtm_cashbox = $this->db->result("SELECT id FROM shop_cashbox WHERE name = 'Индивидуальный пошив'")->id;
        $filter = '';
        $limit = 'LIMIT 50';
        if ($_GET['order_query'] || $_GET['shop_id'] || $_GET['cashbox'] || $_GET['offline_manager_id']) {
          $date_end = $_GET['date_end'];
          $date_start = $_GET['date_start'];
            if ($_GET['mtm']) {
              $data = $_GET['order_query'];
              $q = $data['client'];
              if(!empty($data['year']) && empty($data['brands'])){
                $filter .= " AND o.date >= '{$data['year']}'-01-01 AND date <= '{$data['year']}-12-31 23:59:59' ";
              }
              if(!empty($data['brands'])){
                $filter .= " AND o.mtm_brand_id IN (".implode(',',$data['brands']).") ";
              }
            }
            else{
              $q = $this->db->escape($_GET['order_query']);
            }
            if(!empty($q)){
              $filter .= " AND ((o.order_id = '{$q}' OR o.receipt_number = '{$q}')
                 OR EXISTS (SELECT * FROM users u WHERE (u.name LIKE '%{$q}%' OR u.phone_number LIKE '%{$q}%' OR u.card_number LIKE '%{$q}%') AND o.user_id = u.user_id)
                 OR EXISTS (SELECT * FROM orders_products WHERE (orders_products.barcode LIKE '%{$q}%' OR orders_products.sku LIKE '%{$q}%' OR orders_products.product_id LIKE '%{$q}%') AND orders_products.order_id = o.order_id) )";
            }
            if (!empty($_GET['shop_id'])) {
                $filter .= " AND c.shop_id = " . (int)$_GET['shop_id'];
            }
            if (!empty($_GET['cashbox'])) {
                $filter .= " AND o.cashbox_id = " . (int)$_GET['cashbox'];
            }
            if (!empty($_GET['offline_manager_id'])) {
                $filter .= " AND op.offline_manager_id = " . (int)$_GET['offline_manager_id'];
            }
            if ($_GET['mtm_query']) {
              $filter .= " AND o.cashbox_id = {$mtm_cashbox} ";
            }
            $date_filter = "";
            if ($_GET['debt_query']) {
              $filter .= " AND EXISTS (SELECT * FROM orders_payments or_p WHERE o.order_id = or_p.order_id AND or_p.payment_id = 4 AND or_p.debt_paid_off = 0) ";
              if ($_GET['all_time'] != 'true' && empty($_GET['order_query'])) $date_filter = " AND o.date >= DATE_SUB(CURDATE(), INTERVAL 45 DAY) ";
            }
        }
        elseif ($_GET['date']) {
            $date = $this->db->escape($_GET['date']);
            $date_filter = " AND o.date >= '{$date}' AND date <= '{$date} 23:59:59' ";
        }
        elseif ($_GET['returns_date_from'] && $_GET['returns_date_to']) {
            $from = $this->db->escape($_GET['returns_date_from']);
            $to   = $this->db->escape($_GET['returns_date_to']);
            $filter .= " AND o.order_id IN (SELECT order_id FROM `orders_payments` WHERE money_paid < 0 AND order_id > 0 AND date <= '{$to} 23:59:59' AND date > '{$from} 00:00:00') ";
        }
        elseif ($user->group_id == 12) {
            $date_filter = " AND o.date >= DATE_SUB(CURDATE(), INTERVAL 2 DAY) ";
        }
        else {
            $date_filter = " AND o.date >= CURDATE() ";
            $date_start = date('Y-m-d');
        }

        if (isset($_GET['date_start']) && !empty($_GET['date_start'])) {
          $date_check = date($_GET['date_start']) . ' 00:00:00';
          $date_start = $_GET['date_start'];
          $date_filter = " AND o.date >= '{$date_check}' ";
          $limit = '';
        }
        if (isset($_GET['date_end']) && !empty($_GET['date_end'])) {
          $date_check = date($_GET['date_end']) . ' 23:59:59';
          $date_filter .= " AND o.date <= '{$date_check}' ";
          $limit = '';
        }

        if ($_GET['mtm']) {
          $user->cashbox_ids = $mtm_cashbox;
          if (!$_GET['order_query']) {
            $date_filter = " AND o.date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) ";
          }
        }
        elseif (!$_GET['debt_query']) {
          $user->cashbox_ids = preg_replace("/(^|,)".$mtm_cashbox."(,|$)/", ",", $user->cashbox_ids);
          $user->cashbox_ids = preg_replace("/,$/", "", $user->cashbox_ids);
        }

        $cbox_filter = "AND o.cashbox_id IN ({$user->cashbox_ids}) AND o.cashbox_id NOT IN (SELECT id FROM shop_cashbox WHERE name = 'Услуги') ";
        if (($_GET['order_query'] && $_GET['all_cashboxes']) || $_GET['cashbox'] == 15) {
          $cbox_filter = "AND o.cashbox_id != 0";
        }

        if ($_SESSION['user']->user_id != 139026 && $_SESSION['user']->user_id != 127296) {
          $cancelled_filter = " AND o.status != 3 ";
        }

        $orders = $this->db->results($sql = "SELECT o.*, c.name AS cashbox_name
            FROM orders o
            LEFT JOIN orders_products op ON op.order_id = o.order_id
            LEFT JOIN shop_cashbox c ON o.cashbox_id = c.id
            WHERE 1
                {$date_filter}
                {$cbox_filter}
                {$filter}
                {$cancelled_filter}
            GROUP BY o.order_id
            ORDER BY o.date DESC {$limit}");
        if (isset($_GET['debug'])) echo "{$sql}<br><br>";
        foreach ($orders as $k=>$order) {

            if (date('Ymd') == date('Ymd', strtotime($order->date))) {
              $order->editable = true;
            }
            if ($order->status == 3) {
              $order->editable = false;
            }
            if ($_SESSION['user']->user_id == 139026 || $_SESSION['user']->user_id == 127296) {
              $order->editable = true;
              $order->cancellable = true;
            }
            if ($_SESSION['user']->group_id == 9) {
              $order->readonly = true;
            }

            if ($_SESSION['group']->group_id == 2) $image = ', p.large_image AS image ';
            $order->products  = $this->db->results("
                SELECT op.*, p.offline_price AS offline_price, c.name AS color, CONCAT(op.product_name, IF(op.status = 4, ' (возврат)', '')) as product_name{$image}
                  FROM orders_products op
                  LEFT JOIN products p ON p.product_id = op.product_id
                  LEFT JOIN colors c ON c.color_id = p.color_id
                WHERE order_id = {$order->order_id}");
            if ($order->mtm_brand_id) {
              $order->brand_name = $this->db->result("SELECT name FROM brands WHERE brand_id = {$order->mtm_brand_id}")->name;
            }
            $order->total_sum = $this->db->result("SELECT SUM(price) AS total_sum FROM orders_products op WHERE order_id = {$order->order_id}")->total_sum;
            if ($order->user_id) {
                $order->user = $this->db->result("SELECT name, card_number, phone_number, personal_discount, photo FROM users WHERE user_id = {$order->user_id}");
            }
            if ($_GET['debt_query']) {
              if (!empty($_GET['offline_manager_id'])) {
                $u = new luser();
                $total->debt_total = $u->debts4manager($_GET['offline_manager_id']);
                $total->debt_total_month = $u->debts4manager($_GET['offline_manager_id'], true, null, "'".date('Y-m-d', strtotime('-45 days'))." 00:00:00'");
                $total->debt_total_mtm = $u->debts4manager($_GET['offline_manager_id'], true, " = 13", "'".date('Y-m-d', strtotime('-45 days'))." 00:00:00'");
                $debt_limit = $this->db->result("SELECT debt_limit FROM users WHERE user_id = {$_GET['offline_manager_id']}")->debt_limit;
                if ($total->debt_total > $debt_limit)$total->debt_overflow = true;
                //$total->debt_total_service = $u->debts4manager($_GET['offline_manager_id'], true, " = 15", "'".date('Y-m-d', strtotime('-45 days'))." 00:00:00'");
              }
              $debt    = $this->db->result("SELECT op.*, op.money_paid AS debt_amount, sc.name AS cashbox_name, s.name AS shop
                                  FROM orders_payments op
                                  LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id
                                  LEFT JOIN shops s ON s.shop_id = sc.shop_id
                                  WHERE op.order_id = {$order->order_id} AND op.payment_id = 4");
              $debt_id = $debt->id;
              $debt->date = $this->rus_date("j F Y", strtotime($debt->date));
              $a = array();
              foreach($order->products as $p) $a[] = $p->offline_manager_id;
              $ids = implode(',',$a);
              $debt->resp             = $this->db->result($sql = "SELECT GROUP_CONCAT(name SEPARATOR ', ') AS s FROM users WHERE user_id IN ({$ids});")->s;
              $debt->payments         = $this->db->results("SELECT op.*, po.name AS payment_option FROM orders_payments op LEFT JOIN payment_offline po ON po.id = op.payment_id WHERE op.debt_id = {$debt_id}");
              $order->paid_off_amount = $this->db->result("SELECT SUM(op.money_paid) AS s FROM orders_payments op WHERE op.debt_id = {$debt->id};")->s;
              $order->remain          = $debt->debt_amount - $order->paid_off_amount;
              if ($order->remain < 501) unset($orders[$k]);
              else {
                  if ($order->paid_off_amount > 0) {
                      $order->paid_off_amount = number_format($order->paid_off_amount, 0, '', ' ');
                  }
                  $order->remain     = number_format($order->remain, 0, '', ' ');
                  $debt->debt_amount = number_format($debt->debt_amount, 0, '', ' ');
                  $order->debt = $debt;
              }
            }
            else {
              $order->payments = $this->db->results("
                SELECT op.payment_id, op.money_paid, op.id, po.name
                  FROM orders_payments op
                  LEFT JOIN payment_offline po ON po.id = op.payment_id
                WHERE op.order_id = {$order->order_id} AND op.money_paid > 0");
              $order->total_paid = $order->total_debt = $order->total_debt_paid = 0;
              foreach ($order->payments as $payment) {
                $order->total_paid += $payment->money_paid;
                if($payment->payment_id == 4){
                  $payment->is_debt = true;
                  $order->total_debt += $payment->money_paid;
                  $order->debt_id = $payment->id;
                  $debt_payments = $this->db->results("SELECT money_paid FROM orders_payments WHERE debt_id = {$payment->id}");
                  if(!empty($debt_payments)){
                    foreach($debt_payments as $ppay){
                      $order->total_debt_paid += $ppay->money_paid;
                    }
                  }
                }
              }
              if($order->total_debt_paid <= $order->total_debt && $order->total_debt != 0) {
                $order->debts_show = true;
                if($order->total_debt_paid == $order->total_debt)$order->debt_paid = true;
              }
              $order->total_unpaid = $order->total_sum - $order->total_paid;
            }
        }
        if (!empty($total)) {
          array_unshift($orders, $total);
        }

        if (($_GET['order_query'] || $_GET['date_start'] || $_GET['date_end'] || $_GET['date'] || $_GET['shop_id'] || $_GET['cashbox'] || $_GET['offline_manager_id']) && (!$_GET['no_json'] && !$_GET['report_query'])) {
            header('Content-Type: application/json');
            exit(json_encode($orders));
        }


        if (isset($_GET['date_start']) && !empty($_GET['date_start'])) $date_check = date($_GET['date_start']) . ' 00:00:00';
        else $date_check = date('Y-m-d') . ' 00:00:00';
        $date_filter2 = " BETWEEN '{$date_check}' ";
        if (isset($_GET['date_end']) && !empty($_GET['date_end'])) $date_check = date($_GET['date_end']) . ' 23:59:59';
        else $date_check = date('Y-m-d') . ' 23:59:59';
        $date_filter2 .= " AND '{$date_check}' ";

        $cashboxes = $this->db->results("
            SELECT sc.id, sc.name, SUM(op.money_paid) AS total
              FROM orders_payments op
              LEFT JOIN orders o ON o.order_id = op.order_id
              LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id
            WHERE o.cashbox_id > 0 AND o.status != 3 AND sc.id IN ({$user->cashbox_ids})
              AND op.date {$date_filter2} AND sc.name NOT IN ('Услуги')
            GROUP BY o.cashbox_id");
        foreach ($cashboxes as $k => $v) {
            $cashboxes[$k]->payment_methods = $this->db->results("SELECT SUM(op.money_paid) AS sum, po.name FROM orders_payments op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id LEFT JOIN payment_offline po ON op.payment_id = po.id WHERE o.cashbox_id = {$v->id} AND o.status != 3 AND op.date {$date_filter2} GROUP BY op.payment_id");
        }


        $total_debt_returns = $this->db->results("SELECT SUM(op.money_paid) AS sum, po.name FROM orders_payments op LEFT JOIN payment_offline po ON op.payment_id = po.id WHERE op.cashbox_id IN ({$user->cashbox_ids}) AND op.date {$date_filter2} AND debt_id !=0 AND op.money_paid !=0 GROUP BY op.payment_id");
        $total_payments = $this->db->results("SELECT SUM(op.money_paid) AS sum, po.name FROM orders_payments op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id LEFT JOIN payment_offline po ON op.payment_id = po.id WHERE o.cashbox_id IN ({$user->cashbox_ids}) AND o.status != 3 AND op.date {$date_filter2} AND sc.name NOT IN ('Услуги') GROUP BY op.payment_id");

        $total_total = 0;
        foreach ($total_payments as $k => $v) {
            $total_total += $v->sum;
        }
        $total_total_return = 0;
        foreach ($total_debt_returns as $k => $v) {
            $total_total_return += $v->sum;
        }

        $expenses = $this->db->results("SELECT SUM(e.sum) AS sum, s.name AS shop_name FROM expenses e LEFT JOIN shops s ON s.shop_id = e.shop_id WHERE e.date {$date_filter2} AND EXISTS (SELECT 1 FROM shop_cashbox sc WHERE sc.shop_id = e.shop_id AND sc.id IN ({$user->cashbox_ids})) GROUP BY s.shop_id");
        $inkass = $this->db->results("SELECT SUM(i.sum) AS sum, s.name AS shop_name FROM inkass i LEFT JOIN shops s ON s.shop_id = i.shop_id WHERE i.date {$date_filter2} AND EXISTS (SELECT 1 FROM shop_cashbox sc WHERE sc.shop_id = i.shop_id AND sc.id IN ({$user->cashbox_ids})) AND rejected = 0 AND im_agent_fee = 0 AND im_sber_ai = 0 AND im_sber_is = 0 AND im_inkass = 0 GROUP BY s.shop_id");
        $inkass_total = $this->db->result("SELECT SUM(i.sum) AS s FROM inkass i WHERE i.date {$date_filter2} AND EXISTS (SELECT 1 FROM shop_cashbox sc WHERE sc.shop_id = i.shop_id AND i.rejected = 0 AND sc.id IN ({$user->cashbox_ids})) AND (i.im_agent_fee = 0 AND i.im_sber_ai = 0 AND i.im_sber_is = 0 AND i.im_inkass = 0 OR ((i.im_agent_fee = 1 OR i.im_sber_ai = 1 OR i.im_sber_is = 1 OR i.im_inkass = 1) AND i.confirmed = 1))")->s;

        $products    = $this->db->result("SELECT SUM(op.price) AS price_sum, COUNT(*) AS products_count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id WHERE o.cashbox_id IN ({$user->cashbox_ids}) AND o.status != 3 AND sc.name NOT IN ('Услуги') AND o.date {$date_filter2} ");
        $uncommitted = $products->price_sum-$total_total;


        $im_fee->unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_agent_fee = 1 AND confirmed = 0 AND rejected = 0 AND date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH) AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        $im_fee->confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_agent_fee = 1 AND confirmed = 1 AND rejected = 0 AND date {$date_filter2} AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        $im_fee->ai_unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_ai = 1 AND confirmed = 0 AND rejected = 0 AND date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH) AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        $im_fee->ai_confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_ai = 1 AND confirmed = 1 AND rejected = 0 AND date {$date_filter2} AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        $im_fee->is_unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_is = 1 AND confirmed = 0 AND rejected = 0 AND date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH) AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        $im_fee->is_confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_is = 1 AND confirmed = 1 AND rejected = 0 AND date {$date_filter2} AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        $im_fee->im_unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_inkass = 1 AND confirmed = 0 AND rejected = 0 AND date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH) AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        $im_fee->im_confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_inkass = 1 AND confirmed = 1 AND rejected = 0 AND date {$date_filter2} AND cashbox_id IN ({$_SESSION['user']->cashbox_ids})")->s;
        if($_GET['report_query']){
          if (isset($_GET['date_start']) && isset($_GET['date_end']) && $_GET['date_start'] != $_GET['date_end']) $res->dates =  date_format(date_create($_GET['date_start']), "d.m") . ' - ' . date_format(date_create($_GET['date_end']), "d.m");
          elseif($_GET['date_start'] == $_GET['date_end']) $res->dates = date_format(date_create($_GET['date_start']), "d.m");
          else $res->dates = date('d.m');
          $res->im_fee = $im_fee;
          $res->expenses = $expenses;
          $res->inkass = $inkass;
          $res->uncommitted = $uncommitted;
          $res->total_total = $total_total;
          $res->total_total_return = $total_total_return;
          $res->cashboxes = $cashboxes;
          $res->total_debt_returns = $total_debt_returns;
          $res->total_payments = $total_payments;
          $res->inkass_total = $inkass_total;
          $res->price_sum = $products->price_sum;
          $res->products_count = $products->products_count;
          header('Content-Type: application/json');
          exit(json_encode($res));
        }

        $cashboxes_select = $this->db->results("SELECT * FROM shop_cashbox WHERE id IN ({$user->cashbox_ids})");

        $sale_brands = $this->db->results("SELECT * FROM brands WHERE 1 ORDER BY name");
        foreach ($sale_brands as $i => $brand) {
          $brand->new_season = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'new_season'");
          $brand->previous_season = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'previous_season'");
          $brand->old_seasons = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'old_seasons'");
        }
        $this->smarty->assign('sale_brands',      $sale_brands);
        $this->smarty->assign('im_fee',           $im_fee);
        $this->smarty->assign('expenses',         $expenses);
        $this->smarty->assign('inkass',           $inkass);
        $this->smarty->assign('inkass_total',     $inkass_total);
        $this->smarty->assign('cashboxes',        $cashboxes);
        $this->smarty->assign('cashboxes_select', $cashboxes_select);
        $this->smarty->assign('total_debt_returns',$total_debt_returns);
        $this->smarty->assign('total_total_return',$total_total_return);
        $this->smarty->assign('total_payments',   $total_payments);
        $this->smarty->assign('total_total',      $total_total);
        $this->smarty->assign('price_sum',        $products->price_sum);
        $this->smarty->assign('products_count',   $products->products_count);
        $this->smarty->assign('uncommitted',      $uncommitted);
        $this->smarty->assign('orders',           $orders);
        $this->smarty->assign('title', 'Бутик одежды больших размеров | бутик Лакшери Стор');
        if ($_GET['mtm']) {
          $brands = $this->db->results("SELECT b.name, b.brand_id FROM brands b
                  LEFT JOIN orders o ON o.mtm_brand_id = b.brand_id
                  WHERE o.cashbox_id = 13 AND o.status != 3 GROUP BY b.brand_id");
          $this->smarty->assign('years',  $this->db->results("SELECT SUBSTR(date,1,4) AS year FROM orders WHERE cashbox_id = 13 GROUP BY year"));
          $this->smarty->assign('brands', $brands);
          $this->body = $this->smarty->fetch('mtm_orders.tpl');
        }
        elseif ($_GET['sale_brands']) {
          $this->body = $this->smarty->fetch('sale_brands.tpl');
        }
        elseif ($_GET['calls']) {
          $this->smarty->assign("brands_select",    json_encode($this->db->results("SELECT brand_id, name FROM brands WHERE `prod_count_m` + `prod_count_w` > 3 || show_on_brandwall = 1 || show_on_main = 1 ORDER BY `brands`.`name` ASC")));
          $this->smarty->assign("messengers",       json_encode($this->db->results("SELECT * FROM messengers WHERE name != ''")));
          $this->smarty->assign("shops_select",     $this->db->results("SELECT s.shop_id, s.name FROM shops s WHERE EXISTS (SELECT * FROM users2shops u2s LEFT JOIN users u ON u.user_id = u2s.user_id WHERE u2s.shop_id = s.shop_id AND u.group_id < 2) AND s.shop_id NOT IN(7,1048,1049,1050)"));
          if ($_SESSION['user']->group_id == 5) {
            $this->smarty->assign("shops_select",     $this->db->results("SELECT shop_id, name FROM shops WHERE name = 'Интернет-Магазин'"));
            $this->smarty->assign("cities_select",     $this->db->results("SELECT * FROM cities WHERE visible=1 ORDER BY position"));
          }
          $this->smarty->assign("client_groups",    $this->db->results("SELECT * FROM client_groups WHERE 1"));
          $this->smarty->assign("managers", $this->db->results("SELECT * FROM client_managers WHERE active = 1"));
          $this->body = $this->smarty->fetch('calls_offline.tpl');
        }
        elseif ($_GET['edit_user_id']) {
          $user_id = $this->db->escape($_GET['edit_user_id']);
          $user    = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id} AND group_id = 1");
          if (empty($user)) {
              header("Location: /");
              exit();
          }
          $this->smarty->assign("user", $user);
          $this->smarty->assign("shops",    $this->db->results("SELECT s.name, s.shop_id, (u2s.user_id IS NOT NULL) AS checked FROM shops s LEFT OUTER JOIN `users2shops` u2s ON u2s.user_id = {$user_id} AND u2s.shop_id = s.shop_id ORDER BY s.name ASC"));
          $this->smarty->assign("brands",   $this->db->results("SELECT s.name, s.brand_id, (u2b.user_id IS NOT NULL) AS checked FROM brands s LEFT OUTER JOIN `users2brands` u2b ON u2b.user_id = {$user_id} AND u2b.brand_id = s.brand_id WHERE `prod_count_m` + `prod_count_w` > 3 || show_on_brandwall = 1 || show_on_main = 1 ORDER BY s.name ASC"));
          if ($user->show_hidden_brands) {
            $this->smarty->assign("hidden_brands",   $this->db->results("SELECT s.name, s.brand_id, (shb.brand_id IS NOT NULL) AS checked FROM brands s LEFT OUTER JOIN `brands` shb ON shb.brand_id IN ({$user->show_hidden_brands}) AND shb.brand_id = s.brand_id WHERE s.visibility = 4 ORDER BY s.name ASC"));
          }
          else {
            $this->smarty->assign("hidden_brands",   $this->db->results("SELECT s.name, s.brand_id, 0 AS checked FROM brands s WHERE s.visibility = 4 ORDER BY s.name ASC"));
          }
          $this->smarty->assign("managers", $this->db->results("SELECT u.name, u.user_id, (sr2u.user_id IS NOT NULL) AS checked FROM users u LEFT OUTER JOIN `sr_manager2users` sr2u ON sr2u.user_id = {$user_id} AND sr2u.manager_id = u.user_id WHERE u.group_id = 13 AND u.user_id != '15477'"));
          $this->smarty->assign("managers_serv", $this->db->results("SELECT u.name, u.user_id, (sr2u.user_id IS NOT NULL) AS checked FROM users u LEFT OUTER JOIN `sr_manager2users` sr2u ON sr2u.user_id = {$user_id} AND sr2u.manager_id = u.user_id WHERE u.cashbox_ids LIKE('%15%') AND u.group_id = 10"));
          $this->smarty->assign("client_groups",   $this->db->results("SELECT cg.id, cg.name, (ucg.user_id IS NOT NULL) AS checked FROM client_groups cg LEFT OUTER JOIN `users_client_groups` ucg ON ucg.user_id = {$user_id} AND ucg.client_group_id = cg.id ORDER BY cg.name ASC"));
          $this->smarty->assign('viewed_products', $this->db->results("SELECT pv.date AS view_date, pv.price_at_the_time AS view_price, p.* FROM product_views pv LEFT JOIN products p ON p.product_id = pv.product_id WHERE pv.user_id = {$user_id} ORDER BY pv.date DESC LIMIT 100"));
          $messengers = $this->db->results("SELECT * FROM messengers WHERE name != ''");
          $messenger_string = $this->db->result("SELECT pref_messenger FROM users WHERE user_id = {$user_id}")->pref_messenger;
          $msg_array = explode(",", $messenger_string);
          foreach ($messengers as $k=>$msg) {
            if (in_array($msg->id, $msg_array)) {
              $messengers[$k]->checked = 1;
            }
          }
          $this->smarty->assign("messengers", $messengers);
          $this->body = $this->smarty->fetch('user_offline.tpl');
        }
        elseif ( isset($_GET['storeroom'])) {
          if($_POST['period']) $this->_date = $_POST['period'];
          else $this->_date = date('Y-m');
          $date_check = "BETWEEN '{$this->_date}-01' AND '{$this->_date}-31 23:59:59'";
          if(isset($_GET['underling']) && !empty($_GET['underling']))$uid = (int)$_GET['underling'];
          $u = new luser();
          $users_debts = $u->debts4manager($uid, false);
          $users_debts_mtm = $u->debts4manager($uid, false, " = 13");

          $users_list = $this->db->results("SELECT u.* FROM sr_manager2users sr LEFT JOIN users u ON sr.user_id = u.user_id WHERE sr.manager_id = '{$uid}' AND u.name != '' ORDER BY u.name");
          $users->total = $this->db->result("SELECT COUNT(user_id) AS total FROM sr_manager2users WHERE manager_id = {$uid}")->total;
          $users->called = $this->db->result("SELECT COUNT(DISTINCT(user_id)) AS total FROM calls_log WHERE manager_id = {$uid} AND date {$date_check} AND status = 1 AND user_id IN (SELECT DISTINCT(user_id) FROM sr_manager2users WHERE manager_id = {$uid})")->total;
          $users->bought = $this->db->result("SELECT COUNT(DISTINCT(op.user_id)) AS total FROM orders_products op LEFT JOIN orders o ON op.order_id = o.order_id WHERE op.offline_manager_id = {$uid} AND o.date {$date_check} AND op.user_id IN (SELECT DISTINCT(user_id) FROM sr_manager2users WHERE manager_id = {$uid})")->total;
          $users_tmp = $this->db->results("SELECT SUM(pay.money_paid) AS money_paid, pay.order_id, pay.user_id, users.name, users.phone_number FROM orders_payments pay LEFT JOIN orders_products prod ON prod.order_id = pay.order_id LEFT JOIN users ON users.user_id = pay.user_id WHERE prod.offline_manager_id = {$uid} AND pay.date {$date_check} AND pay.user_id IN (SELECT DISTINCT(user_id) FROM sr_manager2users WHERE manager_id = {$uid}) GROUP BY pay.order_id HAVING money_paid > 0 ORDER BY users.name");
          $k=-1;$u_purchases = Array();
          foreach($users_tmp as $user){
            if($id != $user->user_id){
              $k++;$i=0;$id = $user->user_id;
              $u_purchases[$k] = $user;
            }
            $u_purchases[$k]->purchases[$i]->sum = $user->money_paid;
            $u_purchases[$k]->purchases[$i]->order_id = $user->order_id;
            unset($u_purchases[$k]->money_paid, $u_purchases[$k]->id);
            $i++;
          }
          foreach($u_purchases as $k=>$purchase){if (empty($purchase->purchases)) unset($u_purchases[$k]);}

          $personal_total->month    = $this->db->result($sql="SELECT SUM((op.money_paid/100)*om.share) AS total FROM orders_payments op LEFT JOIN order_managers om ON op.order_id = om.order_id WHERE op.debt_id = 0 AND op.date {$date_check} AND om.user_id = '{$uid}'")->total;

          $mc_month = $this->db->result("SELECT cl.manager_id, SUM(cl.status IN (1,2)) AS total, SUM(cl.status=1) AS success, SUM(cl.status=2) AS fail, SUM(cl.status=3) AS sms_app, SUM(cl.status=4) AS sms_wal FROM calls_log cl WHERE (cl.date {$date_check}) AND cl.manager_id = {$uid} GROUP BY cl.manager_id");
          $mc_month->uniq = $this->db->result(" SELECT cl.manager_id, SUM( cl.status IN (1,2)) AS total, SUM( cl.status=1) AS success, SUM( cl.status=2) AS fail, SUM( cl.status=3) AS sms_app, SUM( cl.status=4) AS sms_wal
                                              FROM (SELECT * FROM calls_log WHERE (date {$date_check}) AND manager_id = {$uid} GROUP BY user_id,status) cl ");
          $mc_month->app_users = $this->db->results("SELECT u.name, u.phone_number, u.user_id FROM calls_log cl LEFT JOIN users u ON u.user_id = cl.user_id WHERE (cl.date {$date_check}) AND status = 3 AND manager_id = {$uid}");
          $mc_month->wal_users = $this->db->results("SELECT u.name, u.phone_number, u.user_id FROM calls_log cl LEFT JOIN users u ON u.user_id = cl.user_id WHERE (cl.date {$date_check}) AND status = 4 AND manager_id = {$uid}");
          $mc_month->wal_downloads = $this->db->result("SELECT COUNT(*) AS total FROM `apple_pkpass` WHERE (upd_date {$date_check}) AND user_id IN (SELECT user_id FROM calls_log WHERE manager_id = {$uid} AND status=4)")->total;
          $mc_month->app_install = $this->db->result("SELECT COUNT(*) AS total FROM `app_tracking` WHERE (date {$date_check}) AND user_id IN (SELECT user_id FROM calls_log WHERE manager_id = {$uid} AND status=3)")->total;

          $this->smarty->assign('sales_this_month',$this->db->result($sql="SELECT SUM(op.price) as stm FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id = {$uid} AND o.date {$date_check} AND o.cashbox_id NOT IN (13,15)")->stm);
          $this->smarty->assign('mtm_this_month',$this->db->result("SELECT SUM(op.price) as stm FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id = {$uid} AND o.date {$date_check} AND o.cashbox_id = (SELECT id FROM shop_cashbox WHERE name = 'Индивидуальный пошив')")->stm);
          if ( strpos($_SESSION['user']->cashbox_ids, '15') !== false ) {
            $this->smarty->assign('services_this_month',$this->db->result($sql="SELECT SUM(op.price) as stm FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.user_id IN (SELECT user_id FROM sr_manager2users WHERE manager_id = {$uid}) AND o.date {$date_check} AND o.cashbox_id = 15")->stm);
            $this->smarty->assign('services_today',$this->db->result("SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.user_id IN (SELECT user_id FROM sr_manager2users WHERE manager_id = {$uid}) AND o.date >= CURDATE() AND o.cashbox_id = 15")->st);
            $this->smarty->assign('debts_serv',$u->debts4manager($uid, false, " = 15"));
          }

          $date_check = "BETWEEN '".date('Y-m-d')." 00:00:00' AND '".date('Y-m-d')." 23:59:59'";
          $personal_total->today    = $this->db->result("SELECT SUM((op.money_paid/100)*om.share) AS total FROM orders_payments op LEFT JOIN order_managers om ON op.order_id = om.order_id WHERE op.debt_id = 0 AND op.date {$date_check} AND om.user_id = '{$uid}'")->total;

          $mc_today = $this->db->result("SELECT cl.manager_id, SUM(cl.status IN (1,2)) AS total, SUM(cl.status=1) AS success, SUM(cl.status=2) AS fail, SUM(cl.status=3) AS sms_app, SUM(cl.status=4) AS sms_wal FROM calls_log cl WHERE (cl.date {$date_check}) AND cl.manager_id = {$uid} GROUP BY cl.manager_id");
          $mc_today->uniq = $this->db->result(" SELECT cl.manager_id, SUM( cl.status IN (1,2)) AS total, SUM( cl.status=1) AS success, SUM( cl.status=2) AS fail, SUM( cl.status=3) AS sms_app, SUM( cl.status=4) AS sms_wal
                                              FROM (SELECT * FROM calls_log WHERE (date {$date_check}) AND manager_id = {$uid} GROUP BY user_id,status) cl ");
          $mc_today->app_users = $this->db->results("SELECT u.name, u.phone_number, u.user_id FROM calls_log cl LEFT JOIN users u ON u.user_id = cl.user_id WHERE (cl.date {$date_check}) AND status = 3 AND manager_id = {$uid}");
          $mc_today->wal_users = $this->db->results("SELECT u.name, u.phone_number, u.user_id FROM calls_log cl LEFT JOIN users u ON u.user_id = cl.user_id WHERE (cl.date {$date_check}) AND status = 4 AND manager_id = {$uid}");
          $mc_today->wal_downloads = $this->db->result("SELECT COUNT(*) AS total FROM `apple_pkpass` WHERE (upd_date {$date_check}) AND user_id IN (SELECT user_id FROM calls_log WHERE manager_id = {$uid} AND status=4)")->total;
          $mc_today->app_install = $this->db->result("SELECT COUNT(*) AS total FROM `app_tracking` WHERE (date {$date_check}) AND user_id IN (SELECT user_id FROM calls_log WHERE manager_id = {$uid} AND status=3)")->total;


          $this->smarty->assign('sales_today',$this->db->result("SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id = {$uid} AND o.date >= CURDATE() AND o.cashbox_id NOT IN (13,15)")->st);
          $this->smarty->assign('mtm_today',$this->db->result("SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id = {$uid} AND o.date >= CURDATE() AND o.cashbox_id = (SELECT id FROM shop_cashbox WHERE name = 'Индивидуальный пошив')")->st);
          $this->smarty->assign('mc_month',$mc_month);
          $this->smarty->assign('mc_today',$mc_today);
          $this->smarty->assign('payment_total',$payment_total);
          $this->smarty->assign('personal_total',$personal_total);
          $this->smarty->assign('debts',$users_debts);
          $this->smarty->assign('debts_mtm',$users_debts_mtm);
          $this->smarty->assign('purchases',$u_purchases);
          $this->smarty->assign('users',$users);
          $this->smarty->assign('users_list',$users_list);
          $this->smarty->assign('underlings',$this->db->results("SELECT s2m.manager, u.name FROM sen_manager2manager s2m LEFT JOIN users u ON s2m.manager = u.user_id WHERE s2m.sen_manager = {$uid};"));
          $this->smarty->assign('Pparam',  $_POST['period'] ? $_POST['period'] : date('Y-m'));
          $this->smarty->assign('title', 'Личный кабинет менеджера | бутик Лакшери Стор');
          if(isset($_GET['underling']) && !empty($_GET['underling'])){
            $unname = $this->db->result("SELECT name FROM users WHERE user_id = {$uid};")->name;
            $this->smarty->assign('title', $unname . ' - Личный кабинет менеджера | бутик Лакшери Стор');
          }
          $this->body = $this->smarty->fetch('storeroom_sales.tpl');
        }
        elseif ( isset($_GET['sklad'])) {
          if ( isset($_GET['product_query'])) {
            $q = trim($_GET['product_query']);
            $products = $this->db->results("SELECT p.*, c.name AS category_name, b.name AS brand_name FROM products p
                        LEFT JOIN brands b ON b.brand_id = p.brand_id
                        LEFT JOIN items i ON i.product_id = p.product_id
                        LEFT JOIN categories c ON c.category_id = p.category_id
                        WHERE p.model LIKE '%{$q}%' OR p.model_full LIKE '%{$q}%' OR p.sku LIKE '%{$q}%' OR p.product_id LIKE '%{$q}%' OR i.barcode LIKE '%{$q}%' GROUP BY p.product_id ORDER BY product_id DESC");
            foreach($products as $p){
              $p->image = !empty($p->large_image) ? $p->large_image : $p->small_image;
              $p->items = $this->db->results("SELECT i.*, w.name AS warehouse_name, s.name AS shop_name FROM items i
                        LEFT JOIN warehouses w ON i.warehouse_id = w.warehouse_id
                        LEFT JOIN shops s ON i.shop_id = s.shop_id
                        WHERE i.product_id = '{$p->product_id}' ");
              $p->sales = $this->db->results("SELECT op.*, sc.name AS cashbox_name, s.name AS shop_name, o.date, i.size as i_size, i.size_system FROM orders o
                        LEFT JOIN orders_products op ON o.order_id = op.order_id
                        LEFT JOIN items i ON i.barcode = op.barcode
                        LEFT JOIN shop_cashbox sc ON o.cashbox_id = sc.id
                        LEFT JOIN shops s ON sc.shop_id = s.shop_id
                        WHERE op.product_id = '{$p->product_id}' AND (op.status = 5 OR (o.status = 5 AND (op.status = 5 OR op.status = 0))) GROUP BY op.id");
                foreach($p->items as $i){
                  $i->movements = $this->db->results("SELECT m.*, mi.*, w1.name AS warehouse_from_name, w2.name AS warehouse_to_name, u.name AS resp_name FROM movements m
                          LEFT JOIN movement_items mi ON m.movement_id = mi.movement_id
                          LEFT JOIN warehouses w1 ON m.warehouse_from = w1.warehouse_id
                          LEFT JOIN warehouses w2 ON m.warehouse_to = w2.warehouse_id
                          LEFT JOIN users u ON m.responsible = u.user_id
                          WHERE mi.item_id = '{$i->item_id}' ");
                  foreach($i->movements as $m){
                    $m->date = date('Y/m/d',strtotime($m->date));
                  }
                }
                foreach($p->sales as $s){
                  $s->date = date('Y/m/d',strtotime($s->date));
                }
            }
            header('Content-Type: application/json');
            exit(json_encode($products));
          }
          else{
            $this->smarty->assign('title', 'Личный кабинет | бутик Лакшери Стор');
            $this->body = $this->smarty->fetch('sklad_work.tpl');
          }
        }
        elseif ( isset($_GET['payments'])) {
          $date_start = date('Y-m-d', strtotime('-3 day'));
          $date_end = date('Y-m-d');
          if ( isset($_GET['date_from']) ) $date_start = $_GET['date_from'];
          if ( isset($_GET['date_to']) ) $date_end = $_GET['date_to'];
          $filter = " AND op.date BETWEEN '{$date_start}' AND '{$date_end} 23:59:59'";
          if ( isset($_GET['pay_cashbox']) && !empty($_GET['pay_cashbox']) ) {
            if($_GET['pay_cashbox'] == 15 || $_GET['pay_cashbox'] == 13)$filter .= " AND o.cashbox_id = '{$_GET['pay_cashbox']}'";
            else $filter .= " AND op.cashbox_id = '{$_GET['pay_cashbox']}'";
          }
          if ( isset($_GET['payment_method']) && !empty($_GET['payment_method']) ) {
            $filter .= " AND op.payment_id = '{$_GET['payment_method']}'";
          }
          $payments = $this->db->results($sql="SELECT op.*, o.cashbox_id AS order_cashbox, sc.name AS cashbox_name, s.name AS shop_name, po.name AS payment_method, u.name AS resp
                        FROM orders_payments op
                        LEFT JOIN orders o ON o.order_id = op.order_id
                        LEFT JOIN users u ON u.user_id = op.responsible_person_id
                        LEFT JOIN payment_offline po ON po.id = op.payment_id
                        LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id
                        LEFT JOIN shops s ON sc.shop_id = s.shop_id
                        WHERE payment_id NOT IN (4,5) {$filter} GROUP BY op.id ORDER BY op.id DESC");
          foreach($payments as $p){
            $p->date = date('Y', strtotime($p->date)) == date('Y') ? date('m-d H:i', strtotime($p->date)) : date('y-m-d H:i', strtotime($p->date));
          }
          if ( isset($_GET['date_from']) || isset($_GET['pay_cashbox']) ) {
            foreach($payments as $p){
              if($p->order_cashbox == 13) $p->order_type = 'МТМ';
              elseif($p->order_cashbox == 15) $p->order_type = 'Услуга';
              else $p->order_type = 'Продажа';
              $p->sh_order_id = !empty($p->order_id) ? true : false;
              $p->sh_debt_id = !empty($p->debt_id) ? true : false;
            }
            header('Content-Type: application/json');
            exit(json_encode($payments));
          }
          $this->smarty->assign("date_start", $date_start);
          $this->smarty->assign("date_end", $date_end);
          $this->smarty->assign("cashbox_id", $_GET['pay_cashbox']);
          $this->smarty->assign("method_id", $_GET['payment_method']);
          $this->smarty->assign("payments", $payments);
          $this->smarty->assign("payment_methods", $this->db->results("SELECT DISTINCT * FROM payment_offline WHERE id NOT IN (4,5) AND enabled = 1"));
          $this->smarty->assign('cashboxes', $this->db->results("SELECT DISTINCT * FROM shop_cashbox WHERE id NOT IN (14,17) AND enabled = 1"));
          $this->smarty->assign('title', 'Поиск по оплатам | бутик Лакшери Стор');
          $this->body = $this->smarty->fetch('offline_payments.tpl');
        }
        elseif ($_GET['cash_report']) {

            $date_from   = $_POST['date_from'] ? $_POST['date_from'] : date('Y-m-d');
            $date_to     = $_POST['date_to'] ? $_POST['date_to'] : date('Y-m-d');
            $date_fragment = "BETWEEN '{$date_from}' AND '{$date_to} 23:59:59'";
            $shop_filter = '';
            if (!empty($_POST['shop'])) {
                $shop_id = (int)$_POST['shop'];
                $shop_filter = "AND (sc.shop_id = {$shop_id})";
            }
            $date_filter = "(op.date {$date_fragment})";
            $cash = $this->db->results("
                SELECT sc.id, sc.name, SUM(op.money_paid) AS total, s.name AS shop_name
                    FROM orders_payments op
                    LEFT JOIN orders o        ON o.order_id = op.order_id
                    LEFT JOIN shop_cashbox sc ON sc.id      = op.cashbox_id
                    LEFT JOIN shops s         ON s.shop_id  = sc.shop_id
                  WHERE sc.id > 0 AND (o.cashbox_id NOT IN (13,15) OR o.cashbox_id IS NULL)
                    AND {$date_filter} {$shop_filter}
                  GROUP BY sc.id
                UNION ALL
                SELECT sc.id, sc.name, SUM(op.money_paid) AS total, s.name AS shop_name
                    FROM orders o
                    LEFT JOIN orders_payments op ON o.order_id = op.order_id
                    LEFT JOIN shop_cashbox sc ON sc.id      = o.cashbox_id
                    LEFT JOIN shops s         ON s.shop_id  = sc.shop_id
                  WHERE sc.id IN (13,15)
                    AND {$date_filter} {$shop_filter}
                  GROUP BY sc.id
                ");
            foreach ($cash as $k => $v) {
                if(in_array($v->id, array(13,15))){
                  $cash[$k]->c_boxes = $this->db->results("SELECT sc.name, s.name AS shop_name, SUM(op.money_paid) AS total FROM orders_payments op LEFT JOIN orders o ON o.order_id  = op.order_id LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id LEFT JOIN shops s ON s.shop_id  = sc.shop_id WHERE o.cashbox_id = {$v->id} AND debt_id = 0 AND op.payment_id != 4 AND {$date_filter} {$shop_filter} GROUP BY op.cashbox_id");
                }
                $cash[$k]->payment_methods      = $this->db->results("SELECT SUM(op.money_paid) AS sum, po.name, op.debt_id FROM orders_payments op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id LEFT JOIN payment_offline po ON op.payment_id = po.id WHERE o.cashbox_id = {$v->id} AND debt_id = 0 AND {$date_filter} GROUP BY op.payment_id");
                $cash[$k]->debt_payment_methods = $this->db->results("SELECT SUM(op.money_paid) AS sum, po.name FROM orders_payments op LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id LEFT JOIN payment_offline po ON op.payment_id = po.id WHERE op.cashbox_id = {$v->id} AND op.debt_id != 0 AND op.payment_id != 9 AND {$date_filter} GROUP BY op.payment_id");
                $cash[$k]->price_sum            = $this->db->result("SELECT SUM(op.price) AS price_sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id WHERE o.cashbox_id = {$v->id} AND (o.date {$date_fragment}) $shop_filter")->price_sum;
                $cash[$k]->debt_sum             = $this->db->result("SELECT SUM(op.money_paid) AS debt_sum FROM orders_payments op WHERE op.debt_id != 0 AND $date_filter AND op.cashbox_id = {$v->id} ")->debt_sum;
                $cash[$k]->return_sum           = $this->db->result("SELECT SUM(op.money_paid) AS return_sum FROM orders_payments op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN payment_offline po ON po.id = op.payment_id WHERE po.return = 1 AND $date_filter AND o.cashbox_id = {$v->id} ")->return_sum;
                $cash[$k]->payment_sum          = $this->db->result("SELECT SUM(op.money_paid) AS payment_sum FROM orders_payments op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN payment_offline po ON po.id = op.payment_id WHERE po.return = 0 AND op.debt_id = 0 AND $date_filter AND o.cashbox_id = {$v->id} ")->payment_sum;
                $cash[$k]->uncommitted          = $cash[$k]->price_sum - $cash[$k]->payment_sum;
                $cash[$k]->orders               = $this->db->results("SELECT order_id FROM orders WHERE cashbox_id = {$v->id} AND (`date` {$date_fragment})");
                $cash[$k]->uncommitted_orders   = array();
                foreach ($cash[$k]->orders as $order) {
                    $order->price   = $this->db->result("SELECT SUM(price) AS price FROM orders_products WHERE order_id = {$order->order_id}")->price;
                    $order->paid    = $this->db->result("SELECT SUM(op.money_paid) AS paid FROM orders_payments op LEFT JOIN payment_offline po ON po.id = op.payment_id WHERE op.order_id = {$order->order_id} AND po.return = 0 ")->paid;
                    $order->unc_sum = $order->price - $order->paid;
                    if ($order->unc_sum > 0) {
                        $cash[$k]->uncommitted_orders[] = $order;
                    }
                }
                $cash[$k]->pure_money = 0;
                foreach ($cash[$k]->payment_methods as $pm) {
                    if ($pm->name != "Долг") {
                        $cash[$k]->pure_money += $pm->sum;
                    }
                }
                $cash[$k]->itogo = $cash[$k]->pure_money + $cash[$k]->debt_sum;
                $cash[$k]->debt_payments = $this->db->results($sql="SELECT SUM(op.money_paid) AS sum, o.order_id
                                    FROM orders_payments op
                                    LEFT JOIN orders_payments debts ON op.debt_id = debts.id
                                    LEFT JOIN orders o ON o.order_id = debts.order_id
                                    WHERE op.debt_id != 0 AND $date_filter AND op.cashbox_id = {$v->id} GROUP BY o.order_id");
            }

            $total_payments = $this->db->results("
                SELECT SUM(op.money_paid) AS sum, po.name, op.debt_id, po.return
                  FROM orders_payments op
                  LEFT JOIN orders o ON o.order_id = op.order_id
                  LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id
                  LEFT JOIN payment_offline po ON op.payment_id = po.id
                WHERE {$date_filter} {$shop_filter} AND op.cashbox_id <> 13 AND op.debt_id = 0 GROUP BY op.payment_id");
            $debt_payment   = $this->db->result("
                SELECT SUM(op.money_paid) AS price_sum
                  FROM orders_payments op
                  LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id
                WHERE {$date_filter} {$shop_filter} AND op.debt_id != 0 AND op.payment_id != 9")->price_sum;
            $debt_payment_methods = $this->db->results("
                SELECT SUM(op.money_paid) AS sum, po.name
                  FROM orders_payments op
                  LEFT JOIN orders_payments debts ON op.debt_id = debts.id
                  LEFT JOIN orders o ON o.order_id = debts.order_id
                  LEFT JOIN shop_cashbox sc ON sc.id = op.cashbox_id
                  LEFT JOIN payment_offline po ON op.payment_id = po.id
                WHERE op.debt_id != 0 AND {$date_filter} {$shop_filter} AND op.payment_id != 9 GROUP BY op.payment_id");
            $price_sum      = $this->db->result("
                SELECT SUM(op.price) AS price_sum
                  FROM orders_products op
                  LEFT JOIN orders o ON o.order_id = op.order_id
                  LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id
                WHERE o.cashbox_id > 0 AND o.cashbox_id <> 13 AND (o.date {$date_fragment}) $shop_filter")->price_sum;

            $expenses = $this->db->results("SELECT SUM(e.sum) AS sum, s.name AS shop_name, s.shop_id FROM expenses e LEFT JOIN shops s ON s.shop_id = e.shop_id WHERE (e.date {$date_fragment}) GROUP BY s.shop_id");
            $inkass = $this->db->results("SELECT SUM(i.sum) AS sum, s.name AS shop_name, s.shop_id FROM inkass i LEFT JOIN shops s ON s.shop_id = i.shop_id WHERE (i.date {$date_fragment}) AND rejected = 0 AND im_agent_fee = 0 AND im_sber_ai = 0 AND im_sber_is = 0 AND im_inkass = 0 GROUP BY s.shop_id");
            $this->smarty->assign("expenses",  $expenses);
            $this->smarty->assign("inkass", $inkass);
            $this->smarty->assign("inkass_total", $this->db->result("SELECT SUM(i.sum) AS s FROM inkass i WHERE (i.date {$date_fragment}) AND i.rejected = 0 AND (i.im_agent_fee = 0 AND i.im_sber_ai = 0 AND i.im_sber_is = 0 AND i.im_inkass = 0 OR ((i.im_agent_fee = 1 OR i.im_sber_ai = 1 OR i.im_sber_is = 1 OR i.im_inkass = 1) AND i.confirmed = 1))")->s);

            // Статистика по интернет магазину
            $online_rfi_income   = $this->db->result("SELECT SUM(partner_income) AS s FROM `rfi_transactions` WHERE (`datetime` {$date_fragment})")->s;
            $online_tk_income    = $this->db->result("SELECT SUM(price) AS s FROM `orders_products` WHERE status = 5 AND (`status_date` {$date_fragment})")->s;
            $online_total_income = $online_rfi_income + $online_tk_income;
            $this->smarty->assign("online_rfi_income",   $online_rfi_income);
            $this->smarty->assign("online_tk_income",    $online_tk_income);
            $this->smarty->assign("online_total_income", $online_total_income);

            $total_total = $pure_money = $oborot = 0;
            foreach ($total_payments as $k => $v) {
                if (!$v->return) {
                    $total_total += $v->sum;
                }
                if ($v->name != "Долг" && $v->debt_id == 0) {
                    $pure_money += $v->sum;
                }
                $oborot += $v->sum;
            }

            $uncommitted = $price_sum-$total_total;
            if ($uncommitted < 0) {
                $uncommitted = 0;
            }
            $shops = $this->db->results("SELECT * FROM shops WHERE shop_id IN (SELECT shop_id FROM shop_cashbox WHERE shop_id != 0)");

            $this->smarty->assign("cash",  $cash);
            $this->smarty->assign("shops", $shops);
            $this->smarty->assign("total_payments", $total_payments);
            if (empty($_GET['shop'])) { // Если выбран магазин - не показываем общий отчет - он просто дубль
                $this->smarty->assign("total_total",  $pure_money+$debt_payment);
            }
            $im_fee->unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_agent_fee = 1 AND confirmed = 0 AND rejected = 0 AND (date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH))")->s;
            $im_fee->confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_agent_fee = 1 AND confirmed = 1 AND rejected = 0 AND (date {$date_fragment})")->s;
            $im_fee->ai_unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_ai = 1 AND confirmed = 0 AND rejected = 0 AND (date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH))")->s;
            $im_fee->ai_confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_ai = 1 AND confirmed = 1 AND rejected = 0 AND (date {$date_fragment})")->s;
            $im_fee->is_unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_is = 1 AND confirmed = 0 AND rejected = 0 AND (date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH))")->s;
            $im_fee->is_confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_sber_is = 1 AND confirmed = 1 AND rejected = 0 AND (date {$date_fragment})")->s;
            $im_fee->im_unconfirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_inkass = 1 AND confirmed = 0 AND rejected = 0 AND (date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH))")->s;
            $im_fee->im_confirmed = $this->db->result("SELECT SUM(sum) AS s FROM `inkass` WHERE im_inkass = 1 AND confirmed = 1 AND rejected = 0 AND (date {$date_fragment})")->s;
            $this->smarty->assign("im_fee", $im_fee);
            $this->smarty->assign("pure_money",   $pure_money);
            $this->smarty->assign("price_sum",    $oborot);
            $this->smarty->assign("debt_payment", $debt_payment);
            $this->smarty->assign("debt_payment_methods", $debt_payment_methods);
            $this->smarty->assign("uncommitted",  $uncommitted);
            $this->smarty->assign('date_to', $date_to);
            $this->smarty->assign('date_from', $date_from);
            $this->smarty->assign('shop_id', $shop_id);
            $this->body = $this->smarty->fetch('cash_report.tpl');
        }
        else {
          $date_start = isset($date_start) ? $date_start : $_GET['date_start'];
          $this->smarty->assign('date_start', !empty($date_start) ? $date_start : date('Y-m-d', strtotime('-4 days')));
          $this->smarty->assign('date_end', isset($_GET['date_end']) ? $_GET['date_end'] : date('Y-m-d'));
          $this->body = $this->smarty->fetch('offline_sales.tpl');
        }
        return $this->body;
    }

}
