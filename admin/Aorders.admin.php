<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('Order.admin.php');
require_once('../placeholder.php');

############################################
# Class Aorders
############################################
class Aorders extends Widget
{
  var $pages_navigation;
  var $items_per_page = 100;

  function Aorders(&$parent)
  {
	parent::Widget($parent);
	$this->add_param('page');
	$this->add_param('view');
	$this->add_param('delivery');
	$this->add_param('keyword');
	$this->pages_navigation = new PagesNavigation($this);
	$this->prepare();
  }

	function get_order_by_id($order_id)
	{
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
										FROM orders_products LEFT JOIN products ON products.product_id=orders_products.product_id WHERE orders_products.order_id=? ORDER BY orders_products.product_name, orders_products.id", $order_id);
			$this->db->query($query);
			$order->products = $this->db->results();
			if ( is_array($order->products) && count($order->products) ) {
				foreach ($order->products as $k=>$product) {
					$order->products[$k]->clone_url 	= "/admin/index.php?section=Order&view=delivery&clone_product_id={$product->id}&order_id={$product->order_id}&token={$this->token}";
					$order->products[$k]->delete_url 	= "/admin/index.php?section=Order&view=delivery&delete_product_id={$product->id}&order_id={$product->order_id}&token={$this->token}";
				}
			}
		}
		return $order;
	}

  function prepare()
  {
	// Изменение статуса заказа
	if(isset($_GET['change_status_id']))
	{

	  $change_status_id = intval($this->param('change_status_id'));
	  $money_received 		= intval($this->param('money_received'));
	  $prod_received = intval($this->param('prod_received'));
	  $delivery_paid = intval($this->param('delivery_paid'));
	  $order_id = intval($this->param('order_id'));


	  $order = $this->get_order_by_id($change_status_id);

	  // Если статус заказа изменился
	if (!empty($money_received))	{
	  if (isset($_GET['json'])) {
		$update_products = json_decode(urldecode($_GET['json']));
		if (!empty($update_products)) {
		  foreach ($update_products as $product_id => $price) {
			$query = sql_placeholder("UPDATE orders_products SET price = ? WHERE id = ?", $price, $product_id);
			$this->db->query($query);
		  }
		}
	  }
	  $query = sql_placeholder('UPDATE orders SET money_received=? WHERE order_id=?', $money_received, $change_status_id);
	  // Отправляем в слак
	  $message = "Получены деньги за заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$change_status_id}|{$change_status_id}>";
	  $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "money_received" );
	  Job::push('SlackJob', $args);
	}
	elseif (!empty($prod_received)) {
	  $query = sql_placeholder('UPDATE orders_products SET transaction_completed=? WHERE id=?;', $prod_received, $change_status_id);
	  $this->db->query($query);
	  $this->db->query("UPDATE orders SET products_received = 1 WHERE order_id = {$order_id} AND NOT EXISTS (SELECT * FROM orders_products WHERE order_id = {$order_id} AND status = 4 AND transaction_completed = 0)");

	  // Отправляем в слак
	  $prod   = $this->db->result($sql = "SELECT product_name, product_id, order_id FROM orders_products WHERE id = '{$change_status_id}' LIMIT 1;");
	  $prod_link   = $this->db->result($sql = "SELECT url FROM products WHERE product_id = '{$prod->product_id}' LIMIT 1;")->url;
	  $message = "Возвращен товар <https://lsboutique.ru/products/{$prod_link}|{$prod->product_name}> из заказа #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$prod->order_id}|{$prod->order_id}>";
	  $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "items_returned" );
	  Job::push('SlackJob', $args);
	}
	elseif (!empty($delivery_paid)) {
	  $query = sql_placeholder('UPDATE orders SET delivery_paid=? WHERE order_id=?', $delivery_paid, $change_status_id);
	}

		$this->db->query($query);

	//Отмечаем выполненные заказы

  	$this->db->query("UPDATE orders o SET o.status = 2 WHERE o.status = 6 AND o.delivery_status = 6 AND o.products_received = 1 AND NOT EXISTS (SELECT * FROM orders_products WHERE order_id = o.order_id AND status = 5)");

	$query = "UPDATE `orders`
		SET status = 2
		WHERE status = 6
			AND money_received = 1
			AND (delivery_status = 3 OR (delivery_status = 6 AND products_received = 1));";

	$this->db->query($query);

	}

  }

  function fetch()
  {
	$this->title = $this->lang->ORDERS;
	$current_page = intval($this->param('page'));

	$view = $this->param('view');
	if(empty($view))
	  $view = 'money';


	$filter = '';
	$product_filter = '';

	$delivery_stats = array(0 => 'доставка в ТК',
	  1 => 'доставка до города',
	  2 => 'вручение',
	  3 => 'товар доставлен',
	  4 => 'клиент недоступен',
	  5 => 'в возврате. у ТК',
	  6 => 'в возврате. у ЛС',
	  7 => 'выполнен, ждет оплаты',
	  8 => 'оплачен');
	$money_stats = array(0 => 'Не было оплаты по заказу',
	2 => 'Оплачен, деньги у ТК',
	3 => 'Деньги в Лакшери Стор');

	$del_view = $this->param('delivery');
	$delivery = $del_view;
	if(empty($del_view))
	  $del_view = 0;

	if ($view == 'money') {
	  $filter .= 'AND orders.delivery_status IN (3,6)
		AND orders.status IN (2,6)
		AND orders_products.status = 5
		AND orders.money_received = 0';
	  $product_filter .= ' AND orders_products.status = 5';
	}

	if ($view == 'return') {
	  $filter .= 'AND orders.status IN (2,6)
		AND orders.products_received = 0
		AND orders_products.status = 4
		AND orders.delivery_status IN (3,6)
		AND orders.order_id IN (SELECT DISTINCT order_id FROM orders_products WHERE transaction_completed = 0 AND status = 4) ';
	  $product_filter .= ' AND orders_products.status = 4 AND orders_products.transaction_completed = 0 ';
	}

	if ($view == 'delivery_pay') {
	  $filter .= 'AND orders.status IN (2,6)
		AND orders.delivery_agent_price > 0
		AND orders.delivery_paid = 0';
	}

	if ($view == 'done') {
	  $filter .= 'AND ((orders.delivery_status=6 AND orders.products_received=1 AND orders.money_received=1) OR (orders.delivery_status=3 AND orders.money_received=1))
		AND orders.status IN (2,6)
		AND orders.money_status = 3
		AND orders.delivery_paid = 1';
	}

	if ($view == 'delivery') {
	  $filter .= 'AND orders.delivery_status IN (0,1,2,5,6)
		AND orders.status = 6';
	}


	$dk = $this->param('delivery_keyword');

	if ($view == 'search')
	{
	  $keyword = mysql_real_escape_string($this->param('keyword'));
	  if (!empty($dk)) {
		$keyword = $dk;
	  }
      if(!empty($keyword))
      {
        if(substr($keyword, 0, 5) == 'user:')
        {
          $user_id = intval(substr($keyword, 5, strlen($keyword)-5));
          $filter .= " AND (orders.user_id = $user_id)";
        }
        elseif (preg_match("/(from:|to:)/i", $keyword)) {
          $filter .= " AND orders_products.status = 5 ";
    	  $kw_array = explode(",", $keyword);
    	  foreach ($kw_array as $key => $value) {
            $kw = explode(":", $value);
            if ($kw[0] == "from") {
                $filter .= " AND orders_products.status_date >= '{$kw[1]}' ";
            }
            elseif ($kw[0] == "to") {
                $filter .= " AND orders_products.status_date <= '{$kw[1]}' ";
            }
    	  }
        }
		else
		{
		  $filter .= " AND (orders.order_id LIKE '%$keyword%'
			OR orders.name LIKE '%$keyword%'
			OR orders.email LIKE '%$keyword%'
			OR orders.address LIKE '%$keyword%'
			OR orders.phone LIKE '%$keyword%'
			OR orders.order_id IN (SELECT order_id FROM orders_products WHERE sku LIKE '%$keyword%'))";
		}
	  }
	}

	####
	#### Выборка заказов

	$start_item = $current_page*$this->items_per_page;
	$this->db->query($sql = "SELECT SQL_CALC_FOUND_ROWS orders.*,
					  DATE_FORMAT(orders.date, '%d.%m.%Y %k:%i') as date,
					  delivery_methods.name as delivery_method,
					  payment_methods.name as payment_method,
					  SUM(orders_products.price*orders_products.quantity)+orders.delivery_price as total_amount, delivery_companies.name AS delivery_company
						FROM orders
						LEFT JOIN delivery_companies ON delivery_companies.id = orders.delivery_company_id
						LEFT JOIN delivery_methods ON delivery_methods.delivery_method_id = orders.delivery_method_id
						LEFT JOIN orders_products ON orders.order_id = orders_products.order_id
						LEFT JOIN payment_methods ON orders.payment_method_id = payment_methods.payment_method_id
					  WHERE 1 $filter
					  GROUP BY orders.order_id
					  ORDER BY orders.order_id DESC
					  LIMIT $start_item ,$this->items_per_page");
	$orders = $this->db->results();
	$total_money = 0;
	foreach ($orders as $k=>$order) {
	  $total_money = $total_money + $order->total_amount;
	}

	$this->db->query("SELECT FOUND_ROWS() as count;");
	$pages_num = $this->db->result();
	$pages_num = $pages_num->count/$this->items_per_page;

	global $products_statuses;
  $products_statuses = array(  0 => 'примерка', 1 => 'отказ клиента', 2 => 'потеря ТК', 3 => 'нет товара', 4 => 'отказ и возврат', 5 => 'принят' );

	foreach($orders as $k=>$order) {
	  $orders[$k]->set_to_process_url = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>1, 'token'=>$this->token));
	  $orders[$k]->set_to_fail_url    = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>3, 'token'=>$this->token));
	  $orders[$k]->set_done_url 	  = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>2, 'token'=>$this->token));
	  $orders[$k]->set_moneyreceived_url     = $this->form_get(array('change_status_id'=>$order->order_id, 'money_received'=>1, 'token'=>$this->token));
	  $orders[$k]->set_delpaymentreceived_url     = $this->form_get(array('change_status_id'=>$order->order_id, 'delivery_paid'=>1, 'token'=>$this->token));
	  $orders[$k]->edit_url 		  = $this->form_get(array('section'=>'Order', 'order_id'=>$order->order_id, 'view'=>$this->param('view'), 'page'=>$this->param('page'), 'token'=>$this->token));
	  $orders[$k]->delete_url 		  = $this->form_get(array('delete_id'=>$order->order_id, 'token'=>$this->token));
	  $this->db->query("SELECT orders_products.*, products.quantity as stock, products.url as url, products.large_image as image
						  FROM orders_products
						  LEFT JOIN products ON products.product_id = orders_products.product_id
						WHERE orders_products.order_id = '{$order->order_id}' {$product_filter}
						ORDER BY orders_products.status, orders_products.product_name, orders_products.id");
	  $products = $this->db->results();
	  foreach ( $products as $kk => $v ) if ( !empty($v->status) && !empty($products_statuses[$v->status]) ) {
		  $products[$kk]->status = $products_statuses[$v->status];
	  	  $products[$kk]->set_prodreceived_url = $this->form_get(array('change_status_id'=>$v->id, 'prod_received'=>1, 'order_id'=>$order->order_id));
	  }
	  $orders[$k]->products = $products;
      $orders[$k]->comments = $this->db->results("SELECT order_comments.*, users.name
                                        FROM order_comments
                                        LEFT JOIN users ON order_comments.user_id = users.user_id
                                        WHERE order_comments.order_id = {$order->order_id}");
      $orders[$k]->manager_name  = $this->db->result("SELECT name FROM `users` WHERE user_id = '{$order->manager_id}'")->name;
	}

	$this->pages_navigation->fetch($pages_num);
	$this->smarty->assign('DeliveryStats', $delivery_stats);
  $this->smarty->assign('MoneyStats', $money_stats);
	$this->smarty->assign('Orders', $orders);
	$this->smarty->assign('View', $view);

	$this->smarty->assign('DelView', $del_view);
  $this->smarty->assign('Total_money', $total_money);
	$this->smarty->assign('PagesNavigation', $this->pages_navigation->body);
	$this->smarty->assign('Lang', $this->lang);
	if (isset($_SESSION['delivery_agent'])) {
	$this->smarty->assign('DeliveryAgent',$_SESSION['delivery_agent']);
	}
	$this->body = $this->smarty->fetch('aorders.tpl');
  }
}
