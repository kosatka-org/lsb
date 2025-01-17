<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');



class Analytics extends Widget
{
    protected $_date_to   = false;
    protected $_date_from = false;

  function Analytics(&$parent)
  {
    if ($_SESSION['user']->user_id == 12625 && !isset($_GET['call_report'])){header("Location: /admin/index.php?section=Analytics&call_report=1");}
    elseif ($_SESSION['user']->user_id == 12625){}
    elseif ( isset($_SERVER["PHP_AUTH_USER"]) && ($_SERVER["PHP_AUTH_USER"] == "giorgio" && $_SERVER["PHP_AUTH_PW"] == "armani")) {
    }
    else {
        header('WWW-Authenticate: Basic realm="Restricted Area"');
        header('HTTP/1.1 401 Unauthorized');
        die();
    }
    parent::Widget($parent);
  }


  function run_prepare() {
        $results = $this->db->results("SELECT DISTINCT date FROM `prodazhi` WHERE p_date = '0000-00-00 00:00:00';");
        if ( is_array($results) && count($results) ) {
            foreach ( $results as $res ) {
                $tmp_date = explode(' ', $res->date);
                $tmp_date2= explode('.', $tmp_date[0]);
                $this->db->query(" UPDATE `prodazhi` SET p_date = '{$tmp_date2[2]}-{$tmp_date2[1]}-{$tmp_date2[0]} 00:00:00' WHERE date = '{$res->date}';");
            }
        }

        // Остатки
        $this->db->query("UPDATE `ostatki` SET `p_location`     = REPLACE(REPLACE(REPLACE(`location`, ' опт', ''), ' (Республика)', ''), 'Сток', 'Склад');");
        $this->db->query("UPDATE `ostatki` SET `p_purchase_sum` = REPLACE(REPLACE(`purchase_sum`, ' ', ''), ',', '.');");
        $this->db->query("UPDATE `ostatki` SET `p_retail_price` = REPLACE(REPLACE(`retail_price`, ' ', ''), ',', '.');");
//      $this->db->query("UPDATE `ostatki` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`season`, ' main', ''), ' pre', ''), ' sfilata', ''), ' обувь', ''), ' НН', ''), ' MF', '');");
        $this->db->query("UPDATE `ostatki` SET `p_season` = REPLACE(REPLACE(REPLACE(`season`, ' обувь', ''), ' НН', ''), ' MF', '');");
        $this->db->query("UPDATE `ostatki` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, ' V', ''), ' P', ''), ' C', ''), ' W', ''), ' AB', ''), ' AR', '');");
        $this->db->query("UPDATE `ostatki` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, ' k', ''), ' LF', ''), ' T', ''), ' T', ''), '/1A', '/1'), '<>', ''), ' E', '');");
        $this->db->query("UPDATE `ostatki` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'CORNELIANI', ''), 'ISAIA', ''), 'Kiton', ''), 'Versace', ''), 'Сезон', ''), 'реализ', '');");
        $this->db->query("UPDATE `ostatki` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'MTM', ''), ' ICE Iceberg', ''), ' Iceberg', ''), 'D', ''), 'Сезон', ''), 'U/D', ''), 'Брй', ''), 'U/', ''), 'U', '');");
        $this->db->query("UPDATE `ostatki` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'I', ''), 'II', ''), 'III', ''), 'IV', ''), 'V', ''), 'VII', ''), 'VI', ''), 'ация Сокол', '');");
        $this->db->query("UPDATE `ostatki` SET `p_season` = 'Не установлен' WHERE p_season = '';");
        //
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`sex`, '-%', ''), '04.03.13', ''), '08.11.10', ''), '11.03.11', '');");
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, '12/2', ''), '13/1', ''), '14.04.11', ''), '15.07.10', '');");
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, '20.06.11', ''), '24.01.12', ''), '25.04.11', ''), '31.01.11', '');");
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, 'AI/11', ''), 'AI/12', ''), 'FENDI', ''), 'FPC/12', '');");
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, 'mtm', ''), 'PE/12', ''), 'PE/13', ''), 'костюмы', '');");
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, 'костюмы (-%)', ''), 'реализация', ''), 'PE/13', ''), 'костюмы', '');");
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(REPLACE(REPLACE(`p_sex`, 'костюмы (-%)', ''), 'реализация', ''), 'рубашки', ''), 'эконом коллекция', '');");
        $this->db->query("UPDATE `ostatki` SET `p_sex` = REPLACE(REPLACE(`p_sex`, '()', ''), '10/1', '');");
  }


  function fetch()
  {
    if ( $this->param('run_prepare') ) {
        $this->run_prepare();
    }

    $this->_date_from   = $this->param('date_from') ? $this->param('date_from') : date('Y-m-d');
    if ($_GET['mtm_report'] && !$this->param('date_from') && !$this->param('date_to')) {
      $this->_date_from   = date("Y-m-d",strtotime("-1 month"));
    }
    $this->_date_to     = $this->param('date_to') ? $this->param('date_to') : date('Y-m-d');
    $date_fragment = "BETWEEN '{$this->_date_from}' AND '{$this->_date_to} 23:59:59'";

    $group    = array( 'p_location' => 'Магазин', 'brand' => 'Бренд', 'p_sex' => 'Пол', 'category_name' => 'Категория', 'p_season' => 'Сезон', 'size' => 'Размер' );
    $group_by = $this->param('group_by') ? $this->param('group_by') : "p_location";
    $filter_o = array();


    $filter = $this->param('filter');
    $title  = ": {$group[$group_by]}";
    $where  = '';
    if ( is_array($filter) && count($filter) > 0 ) {
        $title  = '';
        foreach ( $filter as $field => $values ) {
            $title  .= "<br> {$group[$field]}: ";
            $where .= " AND (0 ";
            foreach ( $values as $k=>$v ) {
                $where .= " OR " . mysql_real_escape_string($field) . "='" . mysql_real_escape_string($v) . "' ";
                $title .= " {$v} /";
            }
            $where .= " ) ";
        }
    }
    $this->smarty->assign('title', $title);
    //echo $where;

    foreach ( $group as $field => $name ) {
        $filter_o[$field] = $this->db->results( $sql = "SELECT value FROM ((SELECT {$field} as value FROM `prodazhi` WHERE p_date {$date_fragment}) UNION (SELECT {$field} as value FROM `ostatki`)) as t ORDER BY value");
		if (isset($_GET['debug'])) echo $sql . '<br><br>';
    }

    $this->smarty->assign('group',      $group);
    $this->smarty->assign('filter_o',   $filter_o);


    $group_by = $this->param('group_by') ? $this->param('group_by') : "p_location";
    $items_sum_present = $total = $ost_sum = $ost_count = $items_sum = $items_count = $locations = array();
    $total['sum'] = $total['count'] = 0;


    if ( $this->param('view_mode') ) {
        $group_by = 'day';
        $tmp_items = $this->db->results($sql = "
            SELECT COUNT(`p_sum_with_discount`) AS count, SUM(`p_sum_with_discount`) as sum, p_date, CONCAT(MONTH(p_date), '/', DAY(p_date), '/', YEAR(p_date)) as day
              FROM `prodazhi`
            WHERE p_date {$date_fragment}
                {$where}
            GROUP BY day
            ORDER BY p_date
        ");
        $last_date = "{$this->_date_from} 00:00:00";
        if ( is_array($tmp_items) && count($tmp_items) ) {
            foreach ( $tmp_items as $tmp_item ) {
                for ($i=strtotime($last_date)+60*60*24; $i<strtotime($tmp_item->p_date); $i+=60*60*24) {
                    $items_sum[]   = array( date('n/j/Y', $i), 0.01 );
                    $items_count[] = array( date('n/j/Y', $i), 0.01 );
                }

                $items_sum[]   = array( $tmp_item->$group_by, (int)$tmp_item->sum );
                $items_count[] = array( $tmp_item->$group_by, (int)$tmp_item->count );
                $total['sum']   += (int)$tmp_item->sum;
                $total['count'] += (int)$tmp_item->count;

                $last_date = $tmp_item->p_date;
            }
        }
        $this->smarty->assign('view_mode', $this->param('view_mode'));
    }
    else {
        $tmp_items = $this->db->results($sql = "
            SELECT COUNT(`p_sum_with_discount`) AS count, SUM(`p_sum_with_discount`) as sum, {$group_by}
              FROM `prodazhi`
            WHERE p_date {$date_fragment}
                {$where}
            GROUP BY {$group_by}
            ORDER BY sum DESC
        ");
		if (isset($_GET['debug'])) echo $sql . '<br><br>';
        if ( is_array($tmp_items) && count($tmp_items) ) {
            foreach ( $tmp_items as $tmp_item ) {
                if ( !isset( $locations[$tmp_item->$group_by] ) ) {
                    $locations[$tmp_item->$group_by] = count($locations)+1;
                }
                $items_sum[]   = array( $tmp_item->$group_by . ' (' . number_format(round($tmp_item->sum/1000)*1000) . ')', (int)$tmp_item->sum );
                $items_count[] = array( $tmp_item->$group_by . ' (' . number_format($tmp_item->count) . ')', (int)$tmp_item->count );
                $total['sum']   += (int)$tmp_item->sum;
                $total['count'] += (int)$tmp_item->count;
            }
        }
        $tmp_items = $this->db->results($sql = "
            SELECT SUM(`quantity`) AS count, SUM(`p_retail_price`) as sum, {$group_by}
              FROM `ostatki`
            WHERE 1 {$where}
            GROUP BY {$group_by}
            ORDER BY sum DESC
        ");
		if (isset($_GET['debug'])) echo $sql . '<br><br>';
        if ( is_array($tmp_items) && count($tmp_items) ) {
            foreach ( $tmp_items as $tmp_item ) {
                if ( !isset( $locations[$tmp_item->$group_by] ) ) {
                    $locations[$tmp_item->$group_by] = count($locations)+1;
                }
                $ost_sum[]   = array( $tmp_item->$group_by . ' (' . number_format(round($tmp_item->sum/1000)*1000) . ')', (int)$tmp_item->sum );
                $ost_count[] = array( $tmp_item->$group_by . ' (' . number_format($tmp_item->count) . ')', (int)$tmp_item->count );
            }
        }
    }
    $total['sum']   = number_format($total['sum']);
    $total['count'] = number_format($total['count']);
    $this->smarty->assign('total', $total);

    if ($_GET['cash_report']) {
        $shop_filter = '';
        if (!empty($_GET['shop'])) {
            $shop_filter = "AND (sc.shop_id = {$_GET['shop']})";
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
        $this->smarty->assign("inkass_total", $this->db->result("SELECT SUM(sum) AS s FROM inkass WHERE (date {$date_fragment}) AND rejected = 0 AND (im_agent_fee = 0 AND im_sber_ai = 0 AND im_sber_is = 0 AND im_inkass = 0 OR ((im_agent_fee = 1 OR im_sber_ai = 1 OR im_sber_is = 1 OR im_inkass = 1) AND confirmed = 1))")->s);

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
        $this->smarty->assign("im_fee", $im_fee);$this->smarty->assign("pure_money",   $pure_money);
        $this->smarty->assign("price_sum",    $oborot);
        $this->smarty->assign("debt_payment", $debt_payment);
        $this->smarty->assign("debt_payment_methods", $debt_payment_methods);
        $this->smarty->assign("uncommitted",  $uncommitted);
    }

    if (isset($_GET['mtm_report'])) {
      $brands = $this->db->results("SELECT SUM(op.price) AS total, b.name, o.mtm_brand_id AS brand_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN brands b ON o.mtm_brand_id = b.brand_id WHERE (o.date {$date_fragment}) AND o.mtm_brand_id != 0 AND op.mtm_status != 'Отказ' GROUP BY o.mtm_brand_id WITH ROLLUP");
      $summary = array_pop($brands);
      $summary->debt = 0;
      foreach ($brands as $k=>$b) {
        $b->debt = 0;
        $brands[$k]->by_user = $this->db->results("SELECT u.name, o.user_id, SUM(op.price) AS sum, GROUP_CONCAT(DISTINCT o.order_id SEPARATOR ',') AS orders
          FROM orders_products op
          LEFT JOIN orders o ON o.order_id = op.order_id
          LEFT JOIN users u ON u.user_id = o.user_id
          WHERE (o.date {$date_fragment}) AND o.mtm_brand_id = {$b->brand_id}
          AND op.mtm_status != 'Отказ'
          GROUP BY o.user_id");
        foreach ($brands[$k]->by_user as $by_user) {
          $debts = $this->db->result("SELECT SUM(money_paid) AS sum, GROUP_CONCAT(id) AS debt_ids FROM orders_payments WHERE order_id IN ({$by_user->orders}) AND payment_id = 4 GROUP BY order_id");
          $debt_minus = $this->db->result("SELECT SUM(money_paid) AS debt_minus FROM orders_payments WHERE debt_id IN ({$debts->debt_ids})")->debt_minus;
          $by_user->debt = $debts->sum - $debt_minus;
          $summary->debt += $by_user->debt;
          $b->debt += $by_user->debt;
        }
      }
      $this->smarty->assign("brands",  $brands);
      $this->smarty->assign('summary', $summary);
    }

    if (isset($_GET['call_report'])) {
      $cashbox = $this->param('cashbox');
      $cashbox_filter = '';
      if(!empty($cashbox))$cashbox_filter = " AND u.cashbox_ids RLIKE '(^|,){$cashbox}(,|$)' ";
      $this->_date_from   = $this->param('date_from') ? $this->param('date_from') : date('Y-m').'-01';
      $date_fragment = "BETWEEN '{$this->_date_from}' AND '{$this->_date_to} 23:59:59'";
      $managers = $this->db->results($sql="SELECT name, cashbox_ids, debt_limit, manager_id, MAX(total) AS total, MAX(success) AS success, MAX(fail) AS fail FROM  
          (SELECT u.name as name, u.cashbox_ids as cashbox_ids, u.debt_limit, op.offline_manager_id AS manager_id, 0 AS total, 0 AS success, 0 AS fail 
            FROM orders_products op 
            LEFT JOIN users u ON u.user_id = op.offline_manager_id 
            LEFT JOIN orders o ON o.order_id = op.order_id 
          WHERE (o.date {$date_fragment}) {$cashbox_filter} AND u.group_id = 13
            GROUP BY op.offline_manager_id 
          UNION ALL 
          SELECT u.name as name, u.cashbox_ids as cashbox_ids, u.debt_limit, cl.manager_id, COUNT(*) AS total, SUM(cl.status=1) AS success, SUM(cl.status=2) AS fail 
            FROM calls_log cl 
            LEFT JOIN users u ON u.user_id = cl.manager_id 
          WHERE (cl.date {$date_fragment}) {$cashbox_filter}
          GROUP BY cl.manager_id WITH ROLLUP ) t
        GROUP BY t.manager_id
        ORDER BY t.manager_id DESC");

      foreach ($managers as $m) if ($m->manager_id) $manager_ids[] = $m->manager_id;
      foreach ($managers as $k=>$m) {
        if ($m->manager_id) {
          $c_filter = "AND commenter_id = {$m->manager_id}";
          $m_filter = "AND manager_id = {$m->manager_id}";
          $m2_filter = "= {$m->manager_id}";
          $m->app_reg_users = '';
          $m->app_reg = '';
          $u = new luser();
          $m->debt_total = $u->debts4manager($m->manager_id);
          $m->debt_mtm = $u->debts4manager($m->manager_id, true, " = 13");
          $debt_total += $m->debt_total;
          $debt_mtm += $m->debt_mtm;
          $m->users_total = $this->db->result("SELECT COUNT(user_id) AS total FROM sr_manager2users WHERE 1 {$m_filter}")->total;
          $m->users_called = $this->db->result("SELECT COUNT(DISTINCT(user_id)) AS total FROM calls_log WHERE 1 {$m_filter} AND date {$date_fragment} AND status = 1 AND user_id IN (SELECT DISTINCT(user_id) FROM sr_manager2users WHERE 1 {$m_filter})")->total;
          $m->users_bought = $this->db->result("SELECT COUNT(DISTINCT(op.user_id)) AS total FROM orders_products op LEFT JOIN orders o ON op.order_id = o.order_id WHERE op.offline_manager_id {$m2_filter} AND o.date {$date_fragment} AND op.user_id IN (SELECT DISTINCT(user_id) FROM sr_manager2users WHERE 1 {$m_filter})")->total;
          if(strpos($m->cashbox_ids,'15')){
            $m->services_today = $this->db->result($sql="SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.user_id IN (SELECT user_id FROM sr_manager2users WHERE manager_id = {$m->manager_id}) AND o.date {$date_fragment} AND o.cashbox_id = 15")->st;
            $m->debt_serv = $u->debts4manager($m->manager_id, true, " = 15");
            $debt_serv += $m->debt_serv;
          }
        }
        else {
          $m->name = "Общая статистика";
          $c_filter = "AND commenter_id IN (SELECT DISTINCT manager_id FROM calls_log WHERE date {$date_fragment})";
          $m_filter = "AND manager_id IN (SELECT DISTINCT manager_id FROM calls_log WHERE date {$date_fragment})";
          $m2_filter = "IN (".implode(',',$manager_ids).")";
          $m->app_reg_users = $this->db->results($sql="SELECT SQL_CALC_FOUND_ROWS u.name, u.phone_number, u.user_id FROM users u WHERE u.reg_source = 1 AND u.card_registered {$date_fragment} GROUP BY u.user_id");
          $m->services_today = $this->db->result($sql="SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.date {$date_fragment} AND o.cashbox_id = 15")->st;
          $m->app_reg = $this->db->result("SELECT FOUND_ROWS() as count;")->count;
          $m->debt_total = $debt_total;
          $m->debt_mtm = $debt_mtm;
          $m->debt_serv = $debt_serv;
          $m->users_total = $m->users_called = $m->users_bought = 0;
        }
        $m->uniq = $this->db->result("SELECT cl.manager_id, SUM( cl.status IN (1,2)) AS total, SUM( cl.status=1) AS success, SUM( cl.status=2) AS fail, SUM( cl.status=3) AS sms_app, SUM( cl.status=4) AS sms_wal
                                              FROM (SELECT * FROM calls_log WHERE (date {$date_fragment}) AND manager_id {$m2_filter} GROUP BY user_id,status) cl ");
          
        $m->sales_today = $this->db->result($sql="SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id {$m2_filter} AND o.date {$date_fragment} AND o.cashbox_id NOT IN (13,15)")->st;
        $m->mtm_today = $this->db->result($sql="SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id {$m2_filter} AND o.date {$date_fragment} AND o.cashbox_id = 13")->st;
        $m->app_users = $this->db->results("SELECT SQL_CALC_FOUND_ROWS u.name, u.phone_number, u.user_id FROM calls_log cl LEFT JOIN users u ON u.user_id = cl.user_id WHERE (cl.date {$date_fragment}) AND status = 3 {$m_filter} GROUP BY u.user_id");
        $m->sms_app = $this->db->result("SELECT FOUND_ROWS() as count;")->count;
        $m->wal_users = $this->db->results("SELECT SQL_CALC_FOUND_ROWS u.name, u.phone_number, u.user_id FROM calls_log cl LEFT JOIN users u ON u.user_id = cl.user_id WHERE (cl.date {$date_fragment}) AND status = 4 {$m_filter} GROUP BY u.user_id");
        $m->sms_wal = $this->db->result("SELECT FOUND_ROWS() as count;")->count;
        $m->comments = $this->db->result("SELECT COUNT(*) AS comments FROM `user_comments` WHERE (user_comments.date {$date_fragment}) {$c_filter}")->comments;
        $m->wal_downloads = $this->db->result("SELECT COUNT(*) AS total FROM `apple_pkpass` WHERE (upd_date {$date_fragment}) AND user_id IN (SELECT user_id FROM calls_log WHERE 1 {$m_filter} AND status=4)")->total;
        
        $m->app_track_users = $this->db->results($sql="SELECT SQL_CALC_FOUND_ROWS u.name, u.phone_number, u.user_id FROM `app_tracking` at LEFT JOIN users u ON u.user_id = at.user_id WHERE (at.date {$date_fragment}) AND at.user_id IN (SELECT user_id FROM calls_log WHERE 1 {$m_filter} AND status=3) GROUP BY u.user_id");
        $m->app_track = $this->db->result("SELECT FOUND_ROWS() as count;")->count;
        $m->app_auth_users = $this->db->results($sql="SELECT SQL_CALC_FOUND_ROWS u.name, u.phone_number, u.user_id FROM `app_sessions` a_s LEFT JOIN users u ON u.user_id = a_s.user_id WHERE (a_s.date {$date_fragment}) AND a_s.user_id IN (SELECT user_id FROM calls_log WHERE 1 {$m_filter} AND status=3) GROUP BY u.user_id");
        $m->app_auth = $this->db->result("SELECT FOUND_ROWS() as count;")->count;
      }
      $this->smarty->assign("managers", $managers);
      $this->smarty->assign("cashboxes", $this->db->results($sql="SELECT sc.id, sc.name, s.name AS shop_name FROM shop_cashbox sc LEFT JOIN shops s ON s.shop_id = sc.shop_id WHERE sc.enabled=1"));
    }
    
    if ($_GET['sales_report']) {
      if(!empty($_GET['cashboxes']) || !empty($_GET['user_phone']) || !empty($_GET['brand']) || !empty($_GET['date_from'])){
        $user_filter = $shop_filter = $brand_filter = $date_filter = '';
        if (!empty($_GET['cashboxes'])) {
            $shop_filter = "AND o.cashbox_id IN (" . implode(',',$_GET['cashboxes']) . ")";
        }
        $date_filter = " AND (o.date {$date_fragment})";
        if(!empty($_GET['user_phone'])){
          $user_phone = substr($_GET['user_phone'], -10);
          $user = $this->db->result("SELECT * FROM users WHERE phone_number  LIKE '%{$user_phone}';");
          $user_filter = " AND (o.user_id = {$user->user_id} OR u.phone_number LIKE '%{$user_phone}')";
        }
        if(!empty($_GET['brand'])) $brand_filter = " AND (p.brand_id = {$_GET['brand']})";
        
        $data = $this->db->results($sql="SELECT u.name, o.name AS order_name, u.phone_number, o.phone AS order_phone, p.model, p.sku, p.large_image, o.date, o.receipt_number, o.order_id, o.cashbox_id, s.name AS shop_name, op.price
                                                  FROM orders_products op 
                                                  LEFT JOIN orders o ON op.order_id = o.order_id 
                                                  LEFT JOIN shop_cashbox sc ON sc.id = o.cashbox_id 
                                                  LEFT JOIN shops s ON s.shop_id = sc.shop_id
                                                  LEFT JOIN products p ON p.product_id = op.product_id 
                                                  LEFT JOIN users u ON o.user_id = u.user_id 
                                                  WHERE o.status != 3 AND o.cashbox_id NOT IN (15,17) AND u.name NOT LIKE '%test%' AND u.name NOT LIKE '%тест%' AND p.model NOT LIKE '%тест%' {$shop_filter}{$date_filter}{$user_filter}{$brand_filter} 
                                                  ORDER BY o.user_id, o.order_id");
        foreach($data as $d){
          if(empty($d->name) && empty($d->order_name))$d->name = 'Не указано';
          if(empty($d->name) && !empty($d->order_name))$d->name = $d->order_name;
          if(empty($d->phone_number) && !empty($d->order_phone))$d->phone_number = $d->order_phone;
          if($u_name != $d->name)$u_name = $d->name;
          else $d->name = $d->phone_number = '';
          if($d->cashbox_id == 13)$d->sign = 'МТМ';
          elseif(!empty($d->cashbox_id))$d->sign = 'из наличия';
          else {
            $d->sign = 'ИМ';$d->shop_name = 'ИМ';
          }
        }
        $this->smarty->assign('data', $data);
      }
      $this->_date_from = $this->param('date_from') ? $this->param('date_from') : date("Y-m-d",strtotime("-1 month"));
      $this->smarty->assign("cashboxes", $this->db->results($sql="SELECT sc.id, sc.name, s.name AS shop_name FROM shop_cashbox sc LEFT JOIN shops s ON s.shop_id = sc.shop_id WHERE sc.enabled=1 AND sc.id != 17"));
      $this->smarty->assign("brands", $this->db->results($sql="SELECT name, brand_id FROM brands WHERE meta_title !='' ORDER BY name"));
      
    }

    $this->smarty->assign('items_sum',      json_encode($items_sum));
    $this->smarty->assign('items_count',    json_encode($items_count));
    $this->smarty->assign('ost_sum',        json_encode($ost_sum));
    $this->smarty->assign('ost_count',      json_encode($ost_count));

    $this->smarty->assign('locations', $locations);
    $this->smarty->assign('height',    count($locations)*20 > 400 ? count($locations)*20 : 400);

    $this->smarty->assign('group_by',     $group_bys[$group_by]);
    $this->smarty->assign('group_by_old', $group_by);
    $this->smarty->assign('query',        $_SERVER['QUERY_STRING']);

    $this->smarty->assign('date_to', $this->_date_to); 
    $this->smarty->assign('date_from', $this->_date_from);
    $this->smarty->assign('cashbox_f', $cashbox);

    if ($_GET['cash_report']) {
        $this->body = $this->smarty->fetch('cash_report.tpl');
    }
    elseif ($_GET['call_report']) {
      $this->body = $this->smarty->fetch('call_report.tpl');
    }
    elseif ($_GET['mtm_report']) {
      $this->body = $this->smarty->fetch('mtm_report.tpl');
    }
    elseif ($_GET['sales_report']) {
      if(!empty($_GET['cashboxes']) || !empty($_GET['user_phone']) || !empty($_GET['brand']) || !empty($_GET['date_from'])){
        $response = $this->smarty->fetch('sales_report_blank.tpl');
        exit($response);
      }
      else $this->body = $this->smarty->fetch('sales_report.tpl');
    }
    else{
      $this->body = $this->smarty->fetch('analytics.tpl');
    }
  }
}
