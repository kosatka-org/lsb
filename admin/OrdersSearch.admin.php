<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('Orders.admin.php');
require_once('../placeholder.php');
require_once('../models/user.php');

class OrdersSearch extends Orders
{
	var $pages_navigation;
	var $items_per_page = 15;
  
	function OrdersSearch(&$parent)
	{
		parent::Widget($parent);
		$this->add_param('page');
		$this->add_param('type');
		$this->add_param('keyword');
		$this->pages_navigation = new PagesNavigation($this);
		$this->prepare();
	
	}
	
	
	function fetch()
	{
	
		$this->title = $this->lang->ORDERS;
	
		$type = $_GET['type'];
		switch($type){
		
			case '': $this->search_online(); break;			
			case 'offline': $this->search_offline(); break;	
		
		}
		
	}
	
	function search_online(){
		
		$current_page = intval($this->param('page'));

		$filter = '';

	
		$keyword = mysql_real_escape_string($this->param('keyword'));
		$this->smarty->assign('keyword', $keyword);
		if(substr($keyword, 0, 6) == 'promo:') {
			$coupon_code = substr($keyword, 6, strlen($keyword)-6);
			$filter .= " AND (orders.coupon_code = '{$coupon_code}')";  
		}else{
			$filter .= " AND 1 = 2 ";
		}
	  

		#### Выборка заказов
		$start_item = $current_page*$this->items_per_page;
		$sql = "SELECT SQL_CALC_FOUND_ROWS orders.*,
			  DATE_FORMAT(orders.date, '%d.%m.%Y %k:%i') as date,
			  SUM(orders_products.price*orders_products.quantity)+orders.delivery_price as total_amount, delivery_companies.name AS delivery_company
				FROM orders 
				LEFT JOIN delivery_companies ON delivery_companies.id = orders.delivery_company_id
				LEFT JOIN orders_products ON orders.order_id = orders_products.order_id
			  WHERE 1 {$filter}
			  GROUP BY orders.order_id
			  ORDER BY orders.order_id DESC
			  LIMIT {$start_item}, {$this->items_per_page}";
		$orders = $this->db->results($sql);

		$pages_num = $this->db->result("SELECT FOUND_ROWS() as count;");
		$pages_num = $pages_num->count/$this->items_per_page;


		foreach ($orders as $k=>$order) {
		
			if(!empty($order->coupon_code)){
				if($order->coupon_type == 'absolute'){
					$orders[$k]->total_amount = max(0, $order->total_amount-$order->coupon_discount);
				}else{
					$orders[$k]->total_amount = round($order->total_amount*(1-$order->coupon_discount/100), 2);
				}
			}
		
			$orders[$k]->set_to_process_url = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>1, 'token'=>$this->token));
			$orders[$k]->set_to_fail_url    = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>3, 'token'=>$this->token));
			$orders[$k]->set_done_url 	  = $this->form_get(array('change_status_id'=>$order->order_id, 'new_status'=>2, 'token'=>$this->token));
			$orders[$k]->edit_url 		  = $this->form_get(array('section'=>'Order', 'order_id'=>$order->order_id, 'view'=>$this->param('view'), 'page'=>$this->param('page'), 'token'=>$this->token));
			$orders[$k]->delete_url 		  = $this->form_get(array('delete_id'=>$order->order_id, 'token'=>$this->token));
			$products = $this->db->results("
				SELECT orders_products.*, products.quantity as stock, products.url as url
				  FROM orders_products 
				  LEFT JOIN products ON products.product_id = orders_products.product_id
				WHERE orders_products.order_id = '{$order->order_id}' 
				ORDER BY orders_products.status, orders_products.product_name, orders_products.id");

			$orders[$k]->money_sum  = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id = '{$order->order_id}' AND status = 5");
			$orders[$k]->return_sum = $this->db->result("SELECT SUM(price) AS total FROM `orders_products` WHERE order_id = '{$order->order_id}' AND status = 4");
			$orders[$k]->user_return_rate = luser::get_return_rate($order->user_id);
			foreach ( $products as $kk => $v ) if ( !empty($v->status) && !empty($this->products_statuses[$v->status]) ) {
				$products[$kk]->status = $this->products_statuses[$v->status];
			}
			$orders[$k]->products = $products;
		}


		$this->pages_navigation->fetch($pages_num);
		$this->smarty->assign('DeliveryStats', $this->delivery_stats);
		$this->smarty->assign('MoneyStats', $this->money_stats);
	
		if (isset($res)){
			$this->smarty->assign('Results', $res);
		}else{
			$this->smarty->assign('Orders', $orders);
		}
		

		$this->smarty->assign('DelView', $del_view);
		$this->smarty->assign('PagesNavigation', $this->pages_navigation->body);
		$this->smarty->assign('Lang', $this->lang);
	
		$this->body = $this->smarty->fetch('OrdersSearch.tpl');
		
	}
	
	function search_offline(){
	
		$current_page = intval($this->param('page'));

		$filter = '';

	
		$keyword = mysql_real_escape_string($this->param('keyword'));
		$this->smarty->assign('keyword', $keyword);
		if(substr($keyword, 0, 6) == 'promo:') {
			$coupon_code = substr($keyword, 6, strlen($keyword)-6);
			$filter .= sql_placeholder(" AND (o.original_user_id in (SELECT c.user_id FROM coupons c WHERE c.code = '".$coupon_code."'))");  
		}else{
			$filter .= " AND 1 = 2 ";
		}
	  

		#### Выборка заказов
		$start_item = $current_page*$this->items_per_page;
		$sql = sql_placeholder("SELECT o.p_sum_with_discount, o.p_date, o.sku, o.model, o.client FROM prodazhi o WHERE 1 $filter ORDER BY o.p_date DESC LIMIT ?, ?", $start_item, $this->items_per_page);
		$this->db->Query($sql);
		$orders = $this->db->results();
		$this->smarty->assign('Orders', $orders);
		
		$sql = sql_placeholder("SELECT count(o.original_user_id) as count FROM prodazhi o WHERE 1 $filter ");
		$this->db->Query($sql);
		$pages_num = $this->db->result();
		$pages_num = $pages_num->count/$this->items_per_page;
		$this->pages_navigation->fetch($pages_num);		
		$this->smarty->assign('PagesNavigation', $this->pages_navigation->body);
		$this->smarty->assign('Lang', $this->lang);
	
		$this->smarty->assign('type', 'offline');
		$this->body = $this->smarty->fetch('OrdersSearch.tpl');
	
	}

}
