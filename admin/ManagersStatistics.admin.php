<?PHP
require_once('Widget.admin.php');

class ManagersStatistics extends Widget
{
    
    function ManagersStatistics(&$parent)
    {
        Widget::Widget($parent);
    }

    function find_orders($agent, $order_date, $delivery_status, $product_status='', $order_status) {
        $order_status = $order_status ? $order_status : "status = 6";
        $query = "SELECT orders_products.order_id, orders.invoice_number, SUBSTRING(orders.last_update, 1, 10) AS last_update, orders.delivery_date, SUBSTRING(orders.agreed_delivery_date, 1, 10) AS agreed_delivery_date, users.name AS manager_name
        FROM `orders_products`
        LEFT JOIN `orders` ON orders_products.order_id = orders.order_id
        LEFT JOIN users ON orders.manager_id = users.original_user_id
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
    $arr = $this->db->results($query);
    return $arr;
    }

    function find_total($agent, $delivery_status, $product_status, $order_status) {
        $order_status = $order_status ? $order_status : "status = 6";
        $query = "SELECT SUM(price) AS total
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
    $this->db->query($query);
    $arr = $this->db->result();
    return $arr->total;
    }

	function fetch() {
		
		$delagent = '';
		
		$dates_array = array(
			"green" => "((last_update > DATE_SUB(CURDATE(), INTERVAL 5 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date > DATE_SUB(CURDATE(), INTERVAL 5 DAY)))",
			"yellow" => "((last_update < DATE_SUB(CURDATE(), INTERVAL 5 DAY) AND last_update > DATE_SUB(CURDATE(), INTERVAL 10 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date < DATE_SUB(CURDATE(), INTERVAL 5 DAY) AND date > DATE_SUB(CURDATE(), INTERVAL 10 DAY)))",
			"red" => "((last_update > '2013-10' AND last_update < DATE_SUB(CURDATE(), INTERVAL 10 DAY)) OR (last_update = '0000-00-00 00:00:00' AND date > '2013-10' AND date < DATE_SUB(CURDATE(), INTERVAL 10 DAY)))"
		);
		
		$period = date("Y-m");
		$pparam = "current";

		if (isset($_POST['period'])) {
		  $pparam = $_POST['period'];
		  if ($_POST['period'] != 'current') {
			$period = $_POST['period'];
		  }
		}
		$period_start = $period . '-01 00:00:00';
		$period_end = $period . '-31 23:59:59';
	
		$managers = $this->db->results("SELECT * FROM users WHERE group_id = 5 AND subgroup_id IN (0,1) ORDER BY name DESC");
		foreach($managers as $manager){
			$manager_id = "AND manager_id = {$manager->original_user_id}";
			$dates = 1;
			$agreed_delivery_date = " AND agreed_delivery_date = 0";
			if (isset($_POST['period']) && $_POST['period'] != 'current') {
				$agreed_delivery_date = "";
				$dates = "last_update >= '{$period_start}' AND `last_update` <= '{$period_end}'";
				$dates_array = array(
					"green" => 1,
					"yellow" => 1,
					"red" => 1
				);
			}
			
      $manager->manager_money_received = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager_id} AND receipt_number = 0) AND status = 5")->total;
      $manager->manager_money_returns = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager_id} AND receipt_number = 0) AND status = 4")->total;
      $manager->money_received_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager_id} AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");
      $manager->money_returns_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' {$manager_id} AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");
      
      $manager->manager_orders_delivered = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND receipt_number = 0 AND courier_id = {$manager->original_user_id}) AND status = 5")->total;
      $manager->manager_orders_delivered_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id = {$manager->original_user_id} AND receipt_number = 0) AND status = 5 ORDER BY order_id, status_date");

      $manager->manager_orders_delivering = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND receipt_number = 0 AND courier_id = {$manager->original_user_id} AND delivery_status = 2)")->total;
      $manager->manager_orders_delivering_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id = {$manager->original_user_id} AND delivery_status = 2 AND receipt_number = 0) ORDER BY order_id, status_date");
            
      $manager->manager_orders_returned = $this->db->results("SELECT SUM(price) AS total, (SUM(price)/({$res->manager_orders_delivered}+SUM(price)))*100 AS returns_percent  FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}'  AND courier_id = {$manager->original_user_id} AND receipt_number = 0) AND status = 4");
      $manager->manager_orders_returned_list = $this->db->results("SELECT order_id, product_id, product_name, status_date, price FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND courier_id = {$manager->original_user_id} AND receipt_number = 0) AND status = 4 ORDER BY order_id, status_date");
      
      
      $manager->manager_list_sort = $this->find_total($delagent, "delivery_status = 0 {$manager_id} AND {$dates}", "status = 0", "status = 1");
      $manager->manager_list_sort_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status = 0 {$agreed_delivery_date} {$manager_id}", "AND orders_products.status = 0", "status = 1");
      
      $manager->manager_orders_to_client = $this->find_total($delagent, "delivery_status IN (0,1,2) {$manager_id} AND {$dates}", "status = 0");
      $manager->manager_to_client_list_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status IN (0,1,2) {$agreed_delivery_date} {$manager_id}", "AND orders_products.status = 0");
      
      $manager->manager_orders_to_ls = $this->find_total($delagent, "delivery_status = 5 {$manager_id} AND {$dates}", "status = 4");
      $manager->manager_to_ls_list_red = $this->find_orders($delagent, "{$dates} AND {$dates_array["red"]}", "delivery_status = 5 {$manager_id}", "AND orders_products.status = 4");
			
			if (!$_POST['period'] || $_POST['period'] == 'current') {
				$manager->manager_list_sort_blue = $this->find_orders($delagent, 1, "delivery_status = 0 AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW() {$manager_id}", "AND orders_products.status = 0", "status = 1");
				$manager->manager_list_sort_D_red = $this->find_orders($delagent, 1, "delivery_status = 0 AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW() {$manager_id}", "AND orders_products.status = 0", "status = 1");
				$manager->manager_list_sort_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status = 0 AND agreed_delivery_date = 0 {$manager_id}",  "AND orders_products.status = 0", "status = 1");
				$manager->manager_list_sort_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status = 0 AND agreed_delivery_date = 0 {$manager_id}",  "AND orders_products.status = 0", "status = 1");

				$manager->manager_to_client_list_blue = $this->find_orders($delagent, 1, "delivery_status IN (0,1,2) {$manager_id} AND agreed_delivery_date != 0 AND agreed_delivery_date > NOW()", "AND orders_products.status = 0");
				$manager->manager_to_client_list_D_red = $this->find_orders($delagent, 1, "delivery_status IN (0,1,2) {$manager_id} AND agreed_delivery_date != 0 AND agreed_delivery_date < NOW()", "AND orders_products.status = 0");
				$manager->manager_to_client_list_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status IN (0,1,2) AND agreed_delivery_date = 0 {$manager_id}", "AND orders_products.status = 0");
				$manager->manager_to_client_list_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status IN (0,1,2) AND agreed_delivery_date = 0 {$manager_id}", "AND orders_products.status = 0");

				$manager->manager_to_ls_list_yellow = $this->find_orders($delagent, $dates_array["yellow"], "delivery_status = 5 {$manager_id}", "AND orders_products.status = 4");
				$manager->manager_to_ls_list_green = $this->find_orders($delagent, $dates_array["green"], "delivery_status = 5 {$manager_id}", "AND orders_products.status = 4");
			}
			$manager->manager_orders_count = $this->db->result("SELECT COUNT(DISTINCT order_id) AS total FROM `orders` WHERE last_update >= '{$period_start}' AND `last_update` <= '{$period_end}' {$manager_id}")->total;
			$manager->manager_clients_count = $this->db->result("SELECT COUNT(DISTINCT user_id) AS total FROM `orders` WHERE last_update >= '{$period_start}' AND `last_update` <= '{$period_end}' {$manager_id}")->total;
			
			$sips = $this->db->results("SELECT sip_id FROM `users2sips` WHERE user_id = {$manager->original_user_id}");
			$sip_arr = array();
			foreach ($sips as $sip) {
				$sip_arr[] = "'sip:".$sip->sip_id."'";
			}
			$sips = implode(',',$sip_arr);
			$manager->manager_calls_count = $this->db->result("SELECT COUNT(*) AS total FROM `calls` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND sip_id IN ({$sips})")->total;
			$manager->manager_calls = $this->db->results("SELECT calls.client_id, calls.date, users.name FROM `calls`
										LEFT JOIN users ON users.user_id = calls.client_id
										WHERE calls.date >= '{$period_start}' AND calls.date <= '{$period_end}' 
										AND calls.sip_id IN ({$sips}) ORDER BY calls.date DESC");
		}
		
		$prods = $this->db->results("SELECT orders_products.price AS price, orders_products.sku AS sku, orders_products.order_id AS order_id, products.url AS url FROM orders_products LEFT JOIN products ON orders_products.product_id = products.product_id WHERE orders_products.sku != ''");
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
		
		if ($_SESSION['user']->group_id == 6) {
			$aorders = "Aorders";
		}
		else {
			$aorders = "Orders";
		}
		
		$this->smarty->assign('dcompanies', $this->db->results("SELECT * FROM delivery_companies WHERE active =1"));
		$this->smarty->assign('orderlist', $orderlist);
		$this->smarty->assign('Managers', $managers);
		$this->smarty->assign('Pparam', $pparam);
		$this->smarty->assign('aorders', $aorders);
		$this->title = "Статистика по менеджерам";
		$this->body = $this->smarty->fetch('ManagersStatistics.tpl');
		return $this->body;
	}
}