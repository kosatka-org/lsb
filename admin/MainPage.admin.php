<?PHP

require_once('Widget.admin.php');

class MainPage extends Widget
{
    var $menu;
    function MainPage(&$parent) {
        parent::Widget($parent);
    }

    function find_orders($agent, $order_date, $delivery_status, $product_status='', $order_status, $period_start, $period_end) {
        $order_status = $order_status ? $order_status : "status = 6";
        $period_start = $order_status ? $order_status : date("Y-m") . '-01 00:00:00';
        $period_end = $order_status ? $order_status : date("Y-m") . '-31 23:59:59';
        $query = "SELECT orders_products.order_id, orders.invoice_number, orders.delivery_status, SUBSTRING(orders.last_update, 1, 10) AS last_update, orders.delivery_date, orders.city, SUBSTRING(orders.agreed_delivery_date, 1, 10) AS agreed_delivery_date, users.name AS manager_name, u2.name AS courier_name, SUBSTRING(MAX(oe.date), 1, 10) as last_status
        FROM `orders_products`
        LEFT JOIN `orders` ON orders_products.order_id = orders.order_id
        LEFT JOIN users ON orders.manager_id = users.original_user_id
        LEFT JOIN users u2 ON orders.courier_id = u2.original_user_id
        LEFT JOIN (SELECT * FROM orders_events WHERE date BETWEEN '{$period_start}' AND '{$period_end}' ) oe ON orders.order_id = oe.order_id AND oe.type = 'delivery_status'
        WHERE orders_products.order_id IN (
            SELECT order_id
            FROM orders
            WHERE 1 AND {$order_status}
            {$agent}
            AND {$order_date}
            AND {$delivery_status}
            AND receipt_number = 0
        )
        {$product_status}
        GROUP BY orders_products.order_id";
        return $this->db->results($query);
    }

    function find_total($agent, $delivery_status, $product_status, $order_status = "status = 6") {
        $query = "SELECT SUM(price*quantity) AS total
            FROM `orders_products`
            WHERE order_id IN (
                SELECT order_id
                FROM orders
                WHERE date > '2013-10'
                {$agent}
                AND {$order_status}
                AND {$delivery_status}
                AND receipt_number = 0
            )
            AND {$product_status}";
        $arr = $this->db->result($query);
        return $arr->total;
    }

    function sort_users($shops_count, $users){
        foreach ($shops_count as $item) {
            $item->shop_id = ($item->shop_id == null) ? 0 : $item->shop_id;
            $item->shop = ($item->shop_id == null) ? 'Не указан' : $item->shop;
            $key = $item->shop_id;
            $i = 0;
            foreach ($users as $item2){
                $item2->shop_id = ($item2->shop_id == null) ? 0 : $item2->shop_id;
                if ($item2->shop_id == $key){
                    $item->users[$i]->user_id = $item2->original_user_id;
                    $item->users[$i]->name = $item2->name;
                    $item->users[$i]->last_login_date = $item2->last_login_date;
                    $item->users[$i]->card_number = $item2->card_number;
                    $item->users[$i]->ref_source = $item2->ref_source;
                    $i++;
                }
            }
        }
        return $shops_count;
    }
    function sort_sources($sources){
        $referral->ref_source = 'total_referral';
        $referral2->ref_source = 'total_email';
        foreach ($sources as $key => $item) {
            if (strpos($item->ref_source, 'refe') !== false){
                $referral->total += $item->total;
                $referral->count += $item->count;
                $referral->acc_total += $item->acc_total;
                unset($sources[$key]);
            }
            if (strpos($item->ref_source, 'email') !== false){
                $referral2->total += $item->total;
                $referral2->count += $item->count;
                $referral2->acc_total += $item->acc_total;
                unset($sources[$key]);
            }
        }
        $sources[] = $referral;
        $sources[] = $referral2;
        foreach ($sources as $key => $item) {
            $count[$key] = $item->count;
        }
        array_multisort($count,SORT_DESC,$sources);
        return $sources;
    }
    
    function apps2shops($arr,$shops){
        $clone = array_map(function ($object) { return clone $object; }, $shops);
        foreach ($arr as $k=>$user) {
            $cashboxes = explode(',',$user->cashbox_ids);
            foreach($clone as $kk=>$shop){
              foreach($cashboxes as $cashbox){
                if (in_array($cashbox,$shop->cashboxes)){
                  $clone[$kk]->app_count += $arr[$k]->app_count;
                  break 2;
                }
              }
            }
        }
        return $clone;
    }

    function get_orderlist($products_status = ''){
        $prods = $this->db->results("SELECT orders_products.price AS price, orders_products.sku AS sku, orders_products.order_id AS order_id, products.url AS url FROM orders_products LEFT JOIN products ON orders_products.product_id = products.product_id WHERE orders_products.sku != '' {$products_status}");
        $orderlist = array();
        foreach ($prods as $v) {
          if (!empty($orderlist[$v->order_id])) {
            $orderlist[$v->order_id]["skus"] = $orderlist[$v->order_id]["skus"] .= ', <a href="/products/'.$v->url.'/" target="_blank">'.$v->sku.'</a>';
            $orderlist[$v->order_id]["value"] = $orderlist[$v->order_id]["value"] + $v->price;
          }
          else {
            $orderlist[$v->order_id] = array("skus" => '<a href="/products/'.$v->url.'/" target="_blank">'.$v->sku.'</a>', "value" => $v->price);
          }
        }
        return $orderlist;
    }



    function fetch() {
        $period = date("Y-m");
        $pparam = "current";

        $period_start = $period . '-01 00:00:00';
        $period_end = $period . '-31 23:59:59';

        $res = new stdClass();

        if (isset($_POST['period'])) {
          $pparam = $_POST['period'];
          if ($_POST['period'] != 'current') {
            $period = $_POST['period'];
          }
        }

        $dates_array = array(
            "green"  => "((last_update > DATE_SUB(CURDATE(), INTERVAL 5 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date > DATE_SUB(CURDATE(), INTERVAL 5 DAY)))",
            "yellow" => "((last_update < DATE_SUB(CURDATE(), INTERVAL 5 DAY) AND last_update > DATE_SUB(CURDATE(), INTERVAL 10 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date < DATE_SUB(CURDATE(), INTERVAL 5 DAY) AND date > DATE_SUB(CURDATE(), INTERVAL 10 DAY)))",
            "red"    => "((last_update > '2013-10' AND last_update < DATE_SUB(CURDATE(), INTERVAL 10 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date > '2013-10' AND date < DATE_SUB(CURDATE(), INTERVAL 10 DAY)))"
        );

        $agent = isset($_POST['delagent']) ? mysql_real_escape_string($_POST['delagent']) : 0;
        $delagent = '';
        if($agent != 0){
            $delagent = " AND delivery_company_id = {$agent}";
        }

        //ajax
        if (isset($_GET['get_users_count'])) {
            $period = mysql_real_escape_string($_GET['period']);
            if (!empty($period)){
                if ($period == 'all'){
                    $arr = $this->db->results("SELECT COUNT(DISTINCT(u.original_user_id)) AS SoPro, s.shop_id, s.name AS shop FROM users u LEFT JOIN users2shops u2s ON u2s.user_id = u.user_id LEFT JOIN shops s ON u2s.shop_id = s.shop_id WHERE u.group_id < 2 GROUP BY u2s.shop_id ");
                    $arr2 = $this->db->results("SELECT u2s.shop_id, u.original_user_id, u.name, u.last_login_date, u.card_number, GROUP_CONCAT(DISTINCT(o.ref_source), '') AS ref_source FROM users u LEFT JOIN users2shops u2s ON u2s.user_id = u.user_id LEFT JOIN shops s ON u2s.shop_id = s.shop_id LEFT JOIN orders o ON u.user_id = o.user_id WHERE u.group_id < 2 GROUP BY u.original_user_id, u2s.shop_id  ORDER BY u2s.shop_id, u.last_login_date DESC");
                    $res->users2shops_count = $this->sort_users($arr, $arr2);
                    $res->users_with_sizes_count = $this->db->result("SELECT COUNT(DISTINCT `user_id`) AS S_users FROM `users2sizes`")->S_users;
                    $res->users_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users")->SoPro;
                    $res->users_without_sizes_count = $res->users_count - $res->users_with_sizes_count;
                }
                if ($period == 'new'){
                    $arr = $this->db->results("SELECT COUNT(DISTINCT(u.original_user_id)) AS SoPro, s.shop_id, s.name AS shop FROM users u LEFT JOIN users2shops u2s ON u2s.user_id = u.user_id LEFT JOIN shops s ON u2s.shop_id = s.shop_id WHERE u.group_id < 2 AND `card_registered` >= '{$period_start}' GROUP BY shop");
                    $arr2 = $this->db->results("SELECT u2s.shop_id, u.original_user_id, u.name, u.last_login_date, u.card_number, GROUP_CONCAT(DISTINCT(o.ref_source), '') AS ref_source FROM users u LEFT JOIN users2shops u2s ON u2s.user_id = u.user_id LEFT JOIN shops s ON u2s.shop_id = s.shop_id LEFT JOIN orders o ON u.user_id = o.user_id WHERE u.group_id < 2 AND u.card_registered >= '{$period_start}' GROUP BY u.original_user_id, u2s.shop_id  ORDER BY u2s.shop_id, u.last_login_date DESC");
                    $res->users2shops_count = $this->sort_users($arr, $arr2);
                }
                if ($period == 'month' || $period == 'year' || $period == 'h_year'){
                    if ($period == 'year'){
                        $period_start = date('Y-m', strtotime('-1 year')) . '-01 00:00:00';
                        $period_end = date("Y") . '-12-31 23:59:59';
                    }
                    if ($period == 'h_year'){
                        $period_start = date('Y-m-d', strtotime('-6 month')) . ' 00:00:00';
                        $period_end = date("Y-m-d") . ' 23:59:59';
                    }
                    $arr  = $this->db->results("SELECT COUNT(DISTINCT(u.original_user_id)) AS SoPro, s.shop_id, s.name AS shop FROM users u LEFT JOIN users2shops u2s ON u2s.user_id = u.user_id LEFT JOIN shops s ON u2s.shop_id = s.shop_id WHERE u.group_id < 2 AND u.last_login_date >= '{$period_start}' AND u.last_login_date <= '{$period_end}' GROUP BY u2s.shop_id");
                    $arr2 = $this->db->results("SELECT u2s.shop_id, u.original_user_id, u.name, u.last_login_date, u.card_number, GROUP_CONCAT(DISTINCT(o.ref_source), '') AS ref_source FROM users u LEFT JOIN users2shops u2s ON u2s.user_id = u.user_id LEFT JOIN shops s ON u2s.shop_id = s.shop_id  LEFT JOIN orders o ON u2s.user_id = o.user_id WHERE u.group_id < 2 AND u.last_login_date >= '{$period_start}' AND u.last_login_date <= '{$period_end}' GROUP BY u.original_user_id, u2s.shop_id  ORDER BY u2s.shop_id, u.last_login_date DESC");
                    $res->users2shops_count = $this->sort_users($arr, $arr2);
                    $res->users2off_shops_count = $this->db->results("SELECT COUNT( DISTINCT `card_prepeared`) AS SoPro, p_location FROM prodazhi WHERE `card_prepeared` != '' AND `p_date` >= '{$period_start}' AND `p_date` <= '{$period_end}' GROUP BY p_location");
                }
                $this->smarty->assign('Results', $res);
                $body = $this->smarty->fetch('users_results.tpl');
                echo $body;
            }
            die();
        }
        if (isset($_GET['get_users'])) {
            $period = mysql_real_escape_string($_GET['period']);
            $shop = mysql_real_escape_string($_GET['shop']);
            if (!empty($period) && !empty($shop)){

                if ($period == 'h_year'){
                    $period_start = date('Y-m-d', strtotime('-6 month')) . ' 00:00:00';
                    $period_end = date("Y-m-d") . ' 23:59:59';
                }
                if ($period == 'year'){
                    $period_start = date('Y-m', strtotime('-1 year')) . '-01 00:00:00';
                    $period_end = date("Y") . '-12-31 23:59:59';
                }
                $id_arr = $this->db->result("SELECT CONCAT(DISTINCT `card_prepeared` SEPARATOR ', ') AS ids FROM prodazhi WHERE `card_prepeared` != '' AND `p_date` >= '{$period_start}' AND `p_date` <= '{$period_end}' AND p_location = '{$shop}'")->ids;
                $sql = "SELECT name, original_user_id AS user_id, card_number FROM users WHERE `card_prepeared` IN ('{$id_arr}') GROUP BY original_user_id ORDER BY name ASC";
                $arr = $this->db->results($sql);
                $User_results = '';
                foreach($arr as $user){
                    $x = '<a href="/admin/index.php?section=User&user_id='.$user->user_id.'">'.$user->user_id.' - '.$user->name.' № карты - '.$user->card_number.'</a><br />';
                    $User_results .= $x;
                }
                echo $User_results;
            }
            die();
        }

        $period_start = $period . '-01 00:00:00';
        $period_end   = $period . '-31 23:59:59';

        $res->delagent = isset($_POST['delivery_company'])? $_POST['delivery_company'] : 0;
        $delagent = '';
        if($res->delagent != 0){
            $delagent = " AND delivery_company_id = {$res->delagent}";
        }
        if($res->delagent == 9999){
            $delagent = " AND delivery_company_id = 0";
        }

        if ($_SESSION['user']->group_id == 6) {
            $aorders = "Aorders";
        }
        else {
            $aorders = "Orders";
        }

        //ajax
        if (isset($_GET['ajax_get_orders'])) {
            $status = mysql_real_escape_string($_GET['status']);
            $substatus = mysql_real_escape_string($_GET['substatus']);
            $agent = isset($_GET['delagent']) ? mysql_real_escape_string($_GET['delagent']) : 0;
            $delagent = '';
            if($agent != 0){
                $delagent = " AND delivery_company_id = {$agent}";
            }
            $manager = "";
            if ($_GET['manager']){
                $manager = "AND manager_id = {$_SESSION['user']->user_id}";
            }
            $dates = 1;
            $agreed_delivery_date = " AND agreed_delivery_date = 0";
            $period = mysql_real_escape_string($_GET['period']);
            if (!empty($period) && $period != 'current') {
                $period_start = $period . '-01 00:00:00';
                $period_end = $period . '-31 23:59:59';
                $agreed_delivery_date = "";
                $dates = "last_update >= '{$period_start}' AND `last_update` <= '{$period_end}'";
                $dates_array = array(
                    "green"  => 1,
                    "yellow" => 1,
                    "red"    => 1
                );
            }
            if (!empty($status)){
                switch($status){
                    case($status == 'new'):
                        $res->orderlist = $this->get_orderlist('AND orders_products.status = 0');
                        $res->count_all = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 0 {$manager}")->SoPro;
                        $res->count_cart = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 0 AND order_source = 1 {$manager}")->SoPro;
                        $res->count_oc = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 0 AND order_source = 2 {$manager}")->SoPro;
                        $res->count_spec = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 0 AND order_source = 3 {$manager}")->SoPro;
                        $res->count_iOS = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 0 AND order_source = 4 {$manager}")->SoPro;
                        $res->count_android = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 0 AND order_source = 5 {$manager}")->SoPro;
                        $res->count_manager = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 0 AND order_source = 6 {$manager}")->SoPro;
                        $res->list_red = $this->find_orders($delagent, $dates_array['red'], 'delivery_status = 0 AND agreed_delivery_date = 0', 'AND orders_products.status = 0', "status = 0", $period_start, $period_end);
                        $res->list_blue = $this->find_orders($delagent, 1, 'delivery_status = 0 AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW()', 'AND orders_products.status = 0', "status = 0");
                        $res->list_D_red = $this->find_orders($delagent, 1, 'delivery_status = 0 AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW()', 'AND orders_products.status = 0', "status = 0");
                        $res->list_yellow = $this->find_orders($delagent, $dates_array['yellow'], 'delivery_status = 0 AND agreed_delivery_date = 0', 'AND orders_products.status = 0', "status = 0");
                        $res->list_green = $this->find_orders($delagent, $dates_array['green'], 'delivery_status = 0 AND agreed_delivery_date = 0', 'AND orders_products.status = 0', "status = 0");
                    break;

                    case($status == 'sorted'):
                      $filter = ' AND (`delayed` = 0 AND packed = 0) ';
                      if($substatus == 'packed')$filter = ' AND packed = 1 ';
                      if($substatus == 'delayed')$filter = ' AND `delayed` = 1 ';
                        $res->orderlist = $this->get_orderlist('AND orders_products.status = 0');
                        $res->count_all = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 1 {$filter} {$manager}")->SoPro;
                        $res->count_cart = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 1 AND order_source = 1 {$filter} {$manager}")->SoPro;
                        $res->count_oc = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 1 AND order_source = 2 {$filter} {$manager}")->SoPro;
                        $res->count_spec = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 1 AND order_source = 3 {$filter} {$manager}")->SoPro;
                        $res->count_iOS = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE  delivery_status = 0 AND status = 1 AND order_source = 4 {$filter} {$manager}")->SoPro;
                        $res->count_android = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 1 AND order_source = 5 {$filter} {$manager}")->SoPro;
                        $res->count_manager = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE delivery_status = 0 AND status = 1 AND order_source = 6 {$filter} {$manager}")->SoPro;
                        $res->list_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status = 0 {$filter} {$agreed_delivery_date} {$manager}", "AND orders_products.status = 0", "status = 1", $period_start, $period_end);
                        if (empty($period) || $period == 'current') {
                            $res->list_blue = $this->find_orders($delagent, 1, "delivery_status = 0 AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW() {$filter} {$manager}", "AND orders_products.status = 0", "status = 1");
                            $res->list_D_red = $this->find_orders($delagent, 1, "delivery_status = 0 AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW() {$filter} {$manager}", "AND orders_products.status = 0", "status = 1");
                            $res->list_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status = 0 AND agreed_delivery_date = 0 {$filter} {$manager}",  "AND orders_products.status = 0", "status = 1");
                            $res->list_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status = 0 AND agreed_delivery_date = 0 {$filter} {$manager}",  "AND orders_products.status = 0", "status = 1");
                        }
                    break;
                    case($status == 'to_tk'):
                        $res->orderlist = $this->get_orderlist('AND orders_products.status = 0');
                        $res->count_all = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (0) AND orders_products.status = 0 AND orders.status = 6 {$manager};")->SoPro;
                        $res->count_cart = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (0) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 1 {$manager};")->SoPro;
                        $res->count_oc = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (0) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 2 {$manager};")->SoPro;
                        $res->count_spec = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (0) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 3 {$manager};")->SoPro;
                        $res->count_iOS = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (0) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 4 {$manager};")->SoPro;
                        $res->count_android = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (0) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 5 {$manager};")->SoPro;
                        $res->count_manager = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (0) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 6 {$manager};")->SoPro;
                        $res->list_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status IN (0) {$agreed_delivery_date} {$manager}", "AND orders_products.status = 0", null, $period_start, $period_end);
                        if (empty($period) || $period == 'current') {
                            $res->list_blue = $this->find_orders($delagent, 1, "delivery_status IN (0) {$manager} AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW()", "AND orders_products.status = 0");
                            $res->list_D_red = $this->find_orders($delagent, 1, "delivery_status IN (0) {$manager} AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW()", "AND orders_products.status = 0");
                            $res->list_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status IN (0) {$manager} AND agreed_delivery_date = 0", "AND orders_products.status = 0");
                            $res->list_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status IN (0) {$manager} AND agreed_delivery_date = 0", "AND orders_products.status = 0");
                        }
                    break;
                    case($status == 'to_city'):
                        $res->orderlist = $this->get_orderlist('AND orders_products.status = 0');
                        $res->count_all = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (1) AND orders_products.status = 0 AND orders.status = 6 {$manager};")->SoPro;
                        $res->count_cart = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (1) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 1 {$manager};")->SoPro;
                        $res->count_oc = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (1) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 2 {$manager};")->SoPro;
                        $res->count_spec = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (1) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 3 {$manager};")->SoPro;
                        $res->count_iOS = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (1) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 4 {$manager};")->SoPro;
                        $res->count_android = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (1) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 5 {$manager};")->SoPro;
                        $res->count_manager = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status IN (1) AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 6 {$manager};")->SoPro;
                        $res->list_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status IN (1) {$agreed_delivery_date} {$manager}", "AND orders_products.status = 0", null, $period_start, $period_end);
                        if (empty($period) || $period == 'current') {
                            $res->list_blue = $this->find_orders($delagent, 1, "delivery_status IN (1) {$manager} AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW()", "AND orders_products.status = 0");
                            $res->list_D_red = $this->find_orders($delagent, 1, "delivery_status IN (1) {$manager} AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW()", "AND orders_products.status = 0");
                            $res->list_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status IN (1) {$manager} AND agreed_delivery_date = 0", "AND orders_products.status = 0");
                            $res->list_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status IN (1) {$manager} AND agreed_delivery_date = 0", "AND orders_products.status = 0");
                        }
                    break;
                    case($status == 'to_client'):
                        $res->orderlist = $this->get_orderlist('AND orders_products.status = 0');
                        $res->count_all = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 2 AND orders_products.status = 0 AND orders.status = 6 {$manager};")->SoPro;
                        $res->count_cart = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 2 AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 1 {$manager};")->SoPro;
                        $res->count_oc = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 2 AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 2 {$manager};")->SoPro;
                        $res->count_spec = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 2 AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 3 {$manager};")->SoPro;
                        $res->count_iOS = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 2 AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 4 {$manager};")->SoPro;
                        $res->count_android = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 2 AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 5 {$manager};")->SoPro;
                        $res->count_manager = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 2 AND orders_products.status = 0 AND orders.status = 6 AND orders.order_source = 6 {$manager};")->SoPro;
                        $res->list_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status = 2 {$agreed_delivery_date} {$manager}", "AND orders_products.status = 0", null, $period_start, $period_end);
                        if (empty($period) || $period == 'current') {
                            $res->list_blue = $this->find_orders($delagent, 1, "delivery_status = 2 {$manager} AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW()", "AND orders_products.status = 0");
                            $res->list_D_red = $this->find_orders($delagent, 1, "delivery_status = 2 {$manager} AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW()", "AND orders_products.status = 0");
                            $res->list_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status = 2 {$manager} AND agreed_delivery_date = 0", "AND orders_products.status = 0");
                            $res->list_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status = 2 {$manager} AND agreed_delivery_date = 0", "AND orders_products.status = 0");
                        }
                    break;
                    case($status == 'to_ls'):
                        $res->orderlist = $this->get_orderlist('AND orders_products.status = 4');
                        $res->count_all = $this->db->result("SELECT COUNT(orders.order_id) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 5 AND orders.status = 6 AND orders_products.status = 4 {$manager};")->SoPro;
                        $res->count_cart = $this->db->result("SELECT COUNT(orders.order_id) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 5 AND orders.status = 6 AND orders_products.status = 4 AND orders.order_source = 1 {$manager};")->SoPro;
                        $res->count_oc = $this->db->result("SELECT COUNT(orders.order_id) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 5 AND orders.status = 6 AND orders_products.status = 4 AND orders.order_source = 2 {$manager};")->SoPro;
                        $res->count_spec = $this->db->result("SELECT COUNT(orders.order_id) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 5 AND orders.status = 6 AND orders_products.status = 4 AND orders.order_source = 3 {$manager};")->SoPro;
                        $res->count_iOS = $this->db->result("SELECT COUNT(orders.order_id) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 5 AND orders.status = 6 AND orders_products.status = 4 AND orders.order_source = 4 {$manager};")->SoPro;
                        $res->count_android = $this->db->result("SELECT COUNT(orders.order_id) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 5 AND orders.status = 6 AND orders_products.status = 4 AND orders.order_source = 5 {$manager};")->SoPro;
                        $res->count_manager = $this->db->result("SELECT COUNT(orders.order_id) AS SoPro FROM orders LEFT JOIN orders_products ON orders_products.order_id = orders.order_id WHERE orders.delivery_status = 5 AND orders.status = 6 AND orders_products.status = 4 AND orders.order_source = 6 {$manager};")->SoPro;
                        $res->list_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status = 5 {$manager}", "AND orders_products.status = 4", null, $period_start, $period_end);
                        if (empty($period) || $period == 'current') {
                            $res->list_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status = 5 {$manager}", "AND orders_products.status = 4");
                            $res->list_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status = 5 {$manager}", "AND orders_products.status = 4");
                        }
                    break;
                    case($status == 'agent'):
                        $res->orderlist = $this->get_orderlist();
                        $res->list_red = $this->find_orders($delagent, $dates_array['red'], 'money_status = 2 AND money_received = 0');
                        $res->list_yellow = $this->find_orders($delagent, $dates_array['yellow'], 'money_status = 2 AND money_received = 0');
                        $res->list_green = $this->find_orders($delagent, $dates_array['green'], 'money_status = 2 AND money_received = 0');
                    break;
                }
                $this->smarty->assign('aorders', $aorders);
                $this->smarty->assign('Results', $res);
                $body = $this->smarty->fetch('orders_results.tpl');
                echo $body;
            }
            die();
        }

        if ($_SESSION['user']->group_id == 5) {
            $manager = "AND manager_id = {$_SESSION['user']->user_id}";
            $dates = 1;
            $agreed_delivery_date = " AND agreed_delivery_date = 0";

            if (isset($_POST['period']) && $_POST['period'] != 'current') {
                $agreed_delivery_date = "";
                $dates = "last_update >= '{$period_start}' AND `last_update` <= '{$period_end}'";
                $dates_array = array(
                    "green"  => 1,
                    "yellow" => 1,
                    "red"    => 1
                );
            }


            $res->delivery_total = $this->db->result("SELECT SUM( delivery_agent_price ) + SUM( delivery_return_price ) AS total FROM  `orders` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' ".$delagent." AND receipt_number = 0 AND status != 3")->total;
            $res->delivery_price_list = $this->db->results("SELECT order_id, code, delivery_price, real_delivery_price, delivery_agent_price, delivery_return_price, delivery_agent_fee FROM `orders` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' ".$delagent." AND receipt_number = 0 AND status != 3");

            $res->money_received = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 5")->total;
            $res->manager_money_received = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager} {$delagent} AND receipt_number = 0) AND status = 5")->total;
            $res->money_received_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");
            $res->manager_money_received_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager} {$delagent} AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");


            $res->money_returns = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 4")->total;
            $res->manager_money_returns = $this->db->result("SELECT SUM(price) AS total, (SUM(price)/({$res->manager_money_received}+SUM(price)))*100 AS returns_percent FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager}  AND receipt_number = 0{$delagent}) AND status = 4");
            $res->money_returns_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");
            $res->manager_money_returns_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager} {$delagent} AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");

            $res->orders_delivered = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND receipt_number = 0 AND courier_id != 0) AND status = 5")->total;
            $res->manager_orders_delivered = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND receipt_number = 0 AND courier_id = {$_SESSION['user']->user_id}) AND status = 5")->total;
            $res->orders_delivered_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id != 0 AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");
            $res->manager_orders_delivered_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id = {$_SESSION['user']->user_id} AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");

            $res->orders_returned = $this->db->results("SELECT SUM(price) AS total, (SUM(price)/({$res->orders_delivered}+SUM(price)))*100 AS returns_percent  FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}'  AND courier_id != 0 AND receipt_number = 0) AND status = 4");
            $res->manager_orders_returned = $this->db->results("SELECT SUM(price) AS total, (SUM(price)/({$res->orders_delivered}+SUM(price)))*100 AS returns_percent  FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}'  AND courier_id = {$_SESSION['user']->user_id} AND receipt_number = 0) AND status = 4");
            $res->orders_returned_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id != 0 AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");
            $res->manager_orders_returned_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id = {$_SESSION['user']->user_id} AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");

            $res->manager_list_sort = $this->find_total($delagent, "delivery_status = 0 {$manager} AND {$dates}", "status = 0", "status = 1");
            $res->list_sort = $this->find_total($delagent, "delivery_status = 0 AND {$dates}", "status = 0", "status = 1");

            $res->manager_orders_to_tk = $this->find_total($delagent, "delivery_status IN (0) {$manager} AND {$dates}", 'status = 0');
            $res->manager_orders_to_city = $this->find_total($delagent, "delivery_status IN (1) {$manager} AND {$dates}", "status = 0");
            $res->orders_to_tk = $this->find_total($delagent, "delivery_status IN (0) AND {$dates}", 'status = 0');
            $res->orders_to_city = $this->find_total($delagent, "delivery_status IN (1) AND {$dates}", "status = 0");
            
            $res->manager_orders_to_client = $this->find_total($delagent, "delivery_status = 2 {$manager} AND {$dates}", "status IN (0,1,6)");
            $res->orders_to_client = $this->find_total($delagent, "delivery_status = 2 AND {$dates}", "status IN (0,1,6)");

            $res->manager_orders_to_ls = $this->find_total($delagent, "delivery_status = 5 {$manager} AND {$dates}", "status = 4");
            $res->orders_to_ls = $this->find_total($delagent, "delivery_status = 5 AND {$dates}", "status = 4");

            $sale_brands = $this->db->results("SELECT * FROM brands WHERE 1 ORDER BY name");
        		foreach ($sale_brands as $i => $brand) {
        			$brand->new_season = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'new_season'");
        			$brand->previous_season = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'previous_season'");
        			$brand->old_seasons = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'old_seasons'");
        		}
        		$this->smarty->assign("sale_brands", $sale_brands);

            $sips = $this->db->results("SELECT sip_id FROM `users2sips` WHERE user_id = {$_SESSION['user']->user_id}");
            $sip_arr = array();
            foreach ($sips as $sip) {
              $sip_arr[] = "'sip:".$sip->sip_id."'";
            }
            $sips = implode(',',$sip_arr);
            $res->manager_calls_count = $this->db->result("SELECT COUNT(*) AS total FROM `calls` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND sip_id IN ({$sips})")->total;
            $res->manager_calls = $this->db->results("SELECT calls.*, users.name FROM `calls`
                          LEFT JOIN users ON users.user_id = calls.client_id
                          WHERE calls.date >= '{$period_start}' AND calls.date <= '{$period_end}'
                          AND calls.sip_id IN ({$sips}) ORDER BY calls.date DESC");
                  $res->calls_count = $this->db->result("SELECT COUNT(*) AS total FROM `calls` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}'")->total;
            $res->calls = $this->db->results("SELECT calls.*, users.name FROM `calls`
                          LEFT JOIN users ON users.user_id = calls.client_id
                          WHERE calls.date >= '{$period_start}' AND calls.date <= '{$period_end}'
                          ORDER BY calls.date DESC");
        }
        else{
            $res->added = $this->db->result("SELECT COUNT(*) AS NumberOfProducts FROM products WHERE `created` >= '{$period_start}' AND `created` <= '{$period_end}'")->NumberOfProducts;

            $res->sold = $this->db->result("SELECT COUNT(*) AS SoPro FROM products WHERE sold=1 AND `sold_date` >= '{$period_start}' AND `sold_date` <= '{$period_end}'")->SoPro;

            $res->total = $this->db->result("SELECT COUNT(*) AS SoPro FROM products WHERE large_image != '' AND enabled = 1 AND sold = 0")->SoPro;

            $res->orders = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}'")->SoPro;

            $arr = $this->db->results("SELECT COUNT(DISTINCT(o.order_id)) AS count, o.ref_source, SUM(op.price) AS total, (SELECT SUM(op2.price) FROM orders o2 LEFT JOIN orders_products op2 ON o2.order_id = op2.order_id WHERE o2.date >= '{$period_start}' AND o2.date <= '{$period_end}' AND o2.order_source = 1 AND op2.status = 5 AND o2.ref_source = o.ref_source) AS acc_total 
                        FROM orders o 
                        LEFT JOIN orders_products op ON o.order_id = op.order_id 
                        WHERE o.date >= '{$period_start}' 
                          AND o.date <= '{$period_end}' 
                          AND o.order_source = 1 
                        GROUP BY o.ref_source");
            $res->orders_sourced = $this->sort_sources($arr);
            $arr = $this->db->results("SELECT COUNT(oc.id) AS count, oc.ref_source, SUM(p.price) AS total, (SELECT SUM(op.price) FROM one_click oc2 LEFT JOIN orders_products op ON oc2.id = op.one_click_id WHERE oc2.date >= '{$period_start}' AND oc2.date <= '{$period_end}' AND oc2.order_source != 0 AND op.status = 5 AND oc2.ref_source = oc.ref_source) AS acc_total 
                        FROM one_click oc 
                        LEFT JOIN products p ON oc.product_id = p.product_id 
                        WHERE oc.date >= '{$period_start}' 
                          AND oc.date <= '{$period_end}' 
                          AND oc.order_source != 0 
                        GROUP BY oc.ref_source");
            $res->oneclick_sourced = $this->sort_sources($arr);

            $res->descriptions = $this->db->result("SELECT COUNT(*) AS SoPro FROM products WHERE `desc_date` >= '{$period_start}' AND `desc_date` <= '{$period_end}'")->SoPro;

            $desc_urls = array();
            if (isset($arr) && is_array($arr)){
                foreach ($arr as $key => $value) {
                  $editor = $this->db->result("SELECT * FROM users WHERE name = '{$key}'");
                  $desc_urls[$key] = $this->db->results("SELECT editor_id, url, name, 'categories' AS type FROM categories WHERE `text_modified` >= '{$period_start}' AND `text_modified` <= '{$period_end}' AND description != '' AND editor_id = {$editor->user_id}
                    UNION
                    SELECT editor_id, url, name, 'brands' AS type FROM brands WHERE `text_modified` >= '{$period_start}' AND `text_modified` <= '{$period_end}' AND description != '' AND editor_id = {$editor->user_id}
                    UNION
                    SELECT editor_id, url, products.model AS name, 'products' AS type FROM products WHERE `desc_date` >= '{$period_start}' AND `desc_date` <= '{$period_end}' AND description != '' AND editor_id = {$editor->user_id}
                  ");
                }
            }
            $res->desc_urls = $desc_urls;

            $res->banners = $this->db->result("SELECT
              (SELECT COUNT(*) FROM brands WHERE banner_m_modified >= '{$period_start}' AND `banner_m_modified` <= '{$period_end}')
              +
              (SELECT COUNT(*) FROM brands WHERE banner_w_modified >= '{$period_start}' AND `banner_w_modified` <= '{$period_end}')
              AS SoPro")->SoPro;

            $res->banners_m_list = $this->db->results("SELECT * FROM `brands` WHERE  `banner_m_modified` >= '{$period_start}' AND `banner_w_modified` <= '{$period_end}' ");

            $res->banners_w_list = $this->db->results("SELECT * FROM `brands` WHERE  `banner_w_modified` >= '{$period_start}' AND `banner_w_modified` <= '{$period_end}' ");

            $h_year_period_start = date('Y-m-d', strtotime('-6 month')) . ' 00:00:00';
            $h_year_period_end = date("Y-m-d") . ' 23:59:59';
            $res->h_year_users_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users WHERE group_id < 2 AND `last_login_date` >= '{$h_year_period_start}' AND `last_login_date` <= '{$h_year_period_end}'")->SoPro;

            $year_period_start = date('Y-m', strtotime('-1 year')) . '-01 00:00:00';
            $year_period_end = date("Y") . '-12-31 23:59:59';
            $res->year_users_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users WHERE group_id < 2 AND `last_login_date` >= '{$year_period_start}' AND `last_login_date` <= '{$year_period_end}'")->SoPro;

            $res->month_users_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users WHERE group_id < 2 AND `last_login_date` >= '".date('Y-m')."-01 00:00:00' AND `last_login_date` <= '".date('Y-m')."-31 23:59:59'")->SoPro;

            $res->new_users_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users WHERE group_id < 2 AND `card_registered` >= '".date('Y-m')."-01 00:00:00'")->SoPro;

            $res->users_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users WHERE group_id < 2")->SoPro;
            
            $res->measured_users = $this->db->result("SELECT COUNT(DISTINCT user_id) AS SoPro FROM users_measuring WHERE 1")->SoPro;
            
            $shops_arr = $this->db->results("SELECT sc.id, sc.shop_id, s.name FROM shop_cashbox sc LEFT JOIN shops s ON sc.shop_id = s.shop_id WHERE sc.shop_id != 0;");
            $shops = array();
            foreach($shops_arr as $shop){
              if(!is_array($shops[$shop->shop_id]->cashboxes))$shops[$shop->shop_id]->cashboxes = array();
              array_push($shops[$shop->shop_id]->cashboxes, $shop->id);
              if(!isset($shops[$shop->shop_id]->name))$shops[$shop->shop_id]->name = $shop->name;
            }
            $res->app_track_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM app_tracking")->SoPro;
            $res->app_track_auth_count = $this->db->result("SELECT COUNT(DISTINCT(at.user_id)) AS SoPro 
                                      FROM app_tracking at 
                                      LEFT JOIN app_sessions a_s ON at.user_id = a_s.user_id
                                      WHERE a_s.user_id IS NOT NULL AND a_s.user_id != 0")->SoPro;
            $arr = $this->db->results("SELECT COUNT(DISTINCT(at.user_id)) AS app_count, u.cashbox_ids, at.manager_id 
                                      FROM app_tracking at 
                                      LEFT JOIN users u ON at.manager_id = u.user_id
                                      GROUP BY at.manager_id");
            
            $res->app_track_by_shop = $this->apps2shops($arr,$shops);
            $arr = $this->db->results("SELECT COUNT(DISTINCT(at.user_id)) AS app_count, u.cashbox_ids, at.manager_id  
                                      FROM app_tracking at 
                                      LEFT JOIN app_sessions a_s ON at.user_id = a_s.user_id
                                      LEFT JOIN users u ON at.manager_id = u.user_id
                                      WHERE a_s.user_id IS NOT NULL AND a_s.user_id != 0
                                      GROUP BY at.manager_id");
            $res->app_track_auth_by_shop = $this->apps2shops($arr,$shops);
            $res->app_sms_count = $this->db->result("SELECT COUNT(DISTINCT(user_id)) AS SoPro FROM calls_log WHERE status = 3")->SoPro;
            $res->app_sms_auth_count = $this->db->result("SELECT COUNT(DISTINCT(cl.user_id)) AS SoPro 
                                      FROM calls_log cl 
                                      LEFT JOIN app_sessions a_s ON cl.user_id = a_s.user_id
                                      WHERE a_s.user_id IS NOT NULL AND cl.status = 3")->SoPro;
            $res->app_sms_reg_count = $this->db->result("SELECT COUNT(DISTINCT(cl.user_id)) AS SoPro 
                                      FROM calls_log cl 
                                      LEFT JOIN users u ON cl.manager_id = u.user_id
                                      WHERE u.reg_source = 1 AND cl.status = 3")->SoPro;
            $arr = $this->db->results("SELECT COUNT(DISTINCT(cl.user_id)) AS app_count, u.cashbox_ids, cl.manager_id  
                                      FROM calls_log cl 
                                      LEFT JOIN users u ON cl.manager_id = u.user_id
                                      WHERE cl.user_id IS NOT NULL AND cl.user_id != 0 AND cl.status = 3
                                      GROUP BY cl.manager_id");
            $res->app_sms_by_shop = $this->apps2shops($arr,$shops);
            $arr = $this->db->results("SELECT COUNT(DISTINCT(a_s.user_id)) AS app_count, u.cashbox_ids, cl.manager_id  
                                      FROM calls_log cl 
                                      LEFT JOIN app_sessions a_s ON cl.user_id = a_s.user_id
                                      LEFT JOIN users u ON cl.manager_id = u.user_id
                                      WHERE a_s.user_id IS NOT NULL AND a_s.user_id != 0 AND cl.status = 3
                                      GROUP BY cl.manager_id");
            $res->app_sms_auth_by_shop = $this->apps2shops($arr,$shops);
            $arr = $this->db->results("SELECT COUNT(DISTINCT(a_s.user_id)) AS app_count, u.cashbox_ids, cl.manager_id  
                                      FROM calls_log cl 
                                      LEFT JOIN users u ON cl.manager_id = u.user_id
                                      WHERE u.reg_source = 1 AND cl.status = 3
                                      GROUP BY cl.manager_id");
            $res->app_sms_reg_by_shop = $this->apps2shops($arr,$shops);

            $res->orders_NEW = $this->find_total($delagent, "delivery_status = 0", "status = 0", "status = 0");

            $res->orders_Sorted = $this->find_total($delagent, 'delivery_status = 0 AND (`delayed` = 0 AND packed = 0) ', 'status = 0', "status = 1");
            $res->orders_Sorted_packed = $this->find_total($delagent, 'delivery_status = 0 AND packed = 1 ', 'status = 0', "status = 1");
            $res->orders_Sorted_delayed = $this->find_total($delagent, 'delivery_status = 0 AND `delayed` = 1 ', 'status = 0', "status = 1");

            $res->orders_to_tk = $this->find_total($delagent, "delivery_status IN (0)", "status = 0");
            $res->orders_to_city = $this->find_total($delagent, "delivery_status IN (1)", "status = 0");
            
            $res->orders_to_client = $this->find_total($delagent, "delivery_status = 2", 'status = 0');

            $res->orders_to_ls = $this->find_total($delagent, "delivery_status = 5", "status = 4");

            //$res->money_at_agent = $this->find_total($delagent, "money_status = 2 AND money_received = 0", "status = 5");

            //$res->money_confirm = $this->find_total($delagent, " money_received = 0 AND delivery_status IN (3,6)", "status = 5", "status IN (2,6)");

            //$res->products_confirm = $this->find_total($delagent, "delivery_status = 6 AND products_received = 0", "status = 4");

            $res->money_received = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 5")->total;

            $res->money_received_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");

            $res->money_returns = $this->db->results("SELECT SUM(price) AS total, (SUM(price)/({$res->money_received}+SUM(price)))*100 AS returns_percent  FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 4");

            $res->money_returns_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$delagent} AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");

            $res->orders_delivered = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND receipt_number = 0 AND courier_id != 0) AND status = 5")->total;

            $res->orders_delivered_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id != 0 AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");

            $res->orders_returned = $this->db->results("SELECT SUM(price) AS total, (SUM(price)/({$res->orders_delivered}+SUM(price)))*100 AS returns_percent  FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}'  AND courier_id != 0 AND receipt_number = 0) AND status = 4");

            $res->orders_returned_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id != 0 AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");

            if(isset($_GET['exp'])){
              $res->money_count_iOS_acc = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 4 AND receipt_number = 0) AND status = 5")->total;
              $res->money_count_Android_acc = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 5 AND receipt_number = 0) AND status = 5")->total;
              $this->smarty->assign('exp', true);
            }
            $res->order_count_iOS = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 4 AND status NOT IN (3,4);")->SoPro;
            $res->money_count_iOS = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 4 AND status NOT IN (3,4))")->total;
            $res->money_count_iOS_0 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 4 AND status NOT IN (3,4)) AND status = 0")->total;
            $res->money_count_iOS_1 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 4 AND status NOT IN (3,4)) AND status = 5")->total;
            $res->money_count_iOS_2 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 4 AND status NOT IN (3)) AND status = 4")->total;
            $res->iOS_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 4 AND status NOT IN (3,4)) ORDER BY order_id, status_date");

            $res->order_count_Android = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 5 AND status NOT IN (3,4);")->SoPro;
            $res->money_count_Android = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 5 AND status NOT IN (3,4))")->total;
            $res->money_count_Android_0 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 5 AND status NOT IN (3,4)) AND status = 0")->total;
            $res->money_count_Android_1 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 5 AND status NOT IN (3,4)) AND status = 5")->total;
            $res->money_count_Android_2 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 5 AND status NOT IN (3)) AND status = 4")->total;
            $res->Android_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source = 5 AND status NOT IN (3,4)) ORDER BY order_id, status_date");
            
            $res->delivery_total = $this->db->results("SELECT SUM(delivery_agent_price) + SUM( delivery_return_price ) + SUM( agent_fee ) AS total, ((SUM(delivery_agent_price) + SUM( delivery_return_price ) + SUM( agent_fee ))/({$res->money_received}+SUM(delivery_agent_price) + SUM( delivery_return_price ) + SUM( agent_fee )))*100 AS delivery_percent FROM  `orders` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' ".$delagent." AND receipt_number = 0 AND status != 3");

            $res->delivery_price_list = $this->db->results("SELECT order_id, code, delivery_price, real_delivery_price, delivery_agent_price, delivery_return_price, delivery_agent_fee FROM `orders` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' ".$delagent." AND receipt_number = 0 AND status != 3");

            $res->total_deposit = $this->db->result("SELECT SUM(deposit) AS total FROM `users`")->total;

            $res->deposits_list = $this->db->results("SELECT * FROM `users` WHERE  `deposit` !=0 ORDER BY  `user_id` DESC ");

            $res->prepaid_total = $this->db->result("SELECT SUM( payment_prepaid ) AS total FROM  `orders` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}'")->total;

            $res->prepaid_list = $this->db->results("SELECT * FROM `orders` WHERE  `payment_prepaid` !=0 AND `date` >= '{$period_start}' AND `date` <= '{$period_end}' ORDER BY  `order_id` DESC ");

            $res->app_auth_count = $this->db->result("SELECT COUNT(DISTINCT(user_id)) AS SoPro FROM `app_sessions` WHERE user_id > 0")->SoPro;
            $res->app_auth_list = $this->db->results("SELECT ap.*, u.name, u.original_user_id FROM `app_sessions` ap LEFT JOIN users u ON ap.user_id = u.original_user_id  WHERE ap.user_id > 0 GROUP BY ap.user_id");

            $res->month_push_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM sms_to_push_log WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}'")->SoPro;
            $res->month_push_list = $this->db->results("SELECT COUNT(p.id) AS SoPro, u.name, u.original_user_id FROM sms_to_push_log p LEFT JOIN users u ON p.user_id = u.original_user_id WHERE p.date >= '{$period_start}' AND p.date <= '{$period_end}' GROUP BY u.original_user_id ORDER BY u.name<'а',u.name");
            $res->month_calls_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM calls_log WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' AND status = 1")->SoPro;
            $res->month_sms_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users_crm WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' AND type = 'sms'")->SoPro;
            $res->month_emails_count = $this->db->result("SELECT COUNT(*) AS SoPro FROM users_crm WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' AND type = 'email'")->SoPro;

            $res->photos = $this->db->result("SELECT COUNT(*) AS photos FROM products_fotos WHERE created >= '{$period_start}' AND created <= '{$period_end}'")->photos;

            $res->alltime = $this->db->result("SELECT COUNT(*) AS SoPro FROM products WHERE 1")->SoPro;

            $res->profit = $this->db->result("SELECT SUM(price) AS SoPro FROM `orders_products` WHERE order_id IN
                (SELECT order_id FROM orders WHERE status = 2 AND `date` >= '{$period_start}' AND `date` <= '{$period_end}')")->SoPro;

            $res->alltime_orders = $this->db->result("SELECT COUNT(*) AS SoPro FROM orders WHERE 1")->SoPro;

            $res->alltime_descriptions = $this->db->result("SELECT COUNT(*) AS SoPro FROM products WHERE description != ''")->SoPro;
            
            $res->alltime_eng_descriptions = $this->db->result("SELECT COUNT(*) AS cont FROM `eng_text_upload` WHERE 1 ;")->cont;

            $res->alltime_photos = $this->db->result("SELECT
                  (SELECT COUNT(large_image) FROM products WHERE large_image != '')
                  +
                  (SELECT COUNT(small_image) FROM products WHERE small_image != '')
                  +
                  (SELECT COUNT(*) FROM products_fotos WHERE product_id IN
                    (SELECT product_id FROM products WHERE 1)
                  ) AS SoPro")->SoPro;

            $res->alltime_profit = $this->db->result("SELECT SUM(price) AS SoPro FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE status = 2)")->SoPro;
        }
        
        $res->order_count_Instagramm = $this->db->result("SELECT COUNT(DISTINCT(orders.order_id)) AS SoPro FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND user_id IN (SELECT user_id FROM users WHERE p_manager_id = 128379 OR intagramm_user != '') AND status NOT IN (3,4);")->SoPro;
        $res->money_count_Instagramm = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND user_id IN (SELECT user_id FROM users WHERE p_manager_id = 128379 OR intagramm_user != '') AND status NOT IN (3,4))")->total;
        $res->money_count_Instagramm_0 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND user_id IN (SELECT user_id FROM users WHERE p_manager_id = 128379 OR intagramm_user != '') AND status NOT IN (3,4)) AND status = 0")->total;
        $res->money_count_Instagramm_1 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND user_id IN (SELECT user_id FROM users WHERE p_manager_id = 128379 OR intagramm_user != '') AND status NOT IN (3,4)) AND status = 5")->total;
        $res->money_count_Instagramm_2 = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND user_id IN (SELECT user_id FROM users WHERE p_manager_id = 128379 OR intagramm_user != '') AND status NOT IN (3)) AND status = 4")->total;
        $res->Instagramm_list = $this->db->results($sql="SELECT order_id, product_id, product_name, status_date, price, status FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND user_id IN (SELECT user_id FROM users WHERE p_manager_id = 128379 OR intagramm_user != '') AND status NOT IN (3,4)) ORDER BY order_id, status_date");


        $this->title = 'lsboutique.ru';
        $this->smarty->assign('dcompanies', $this->db->results("SELECT * FROM delivery_companies WHERE active =1"));
        $this->smarty->assign('aorders', $aorders);
        $this->smarty->assign('Lang',    $this->lang);
        $this->smarty->assign('Results', $res);
        $this->smarty->assign('Pparam',  $pparam);
        $this->body=$this->smarty->fetch('main_page.tpl');
    }
}
