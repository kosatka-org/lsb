<?PHP

require_once('Widget.admin.php');
require_once('Storefront.admin.php');
require_once('PagesNavigation.admin.php');

class Coupons extends Widget
{

	var $pages_navigation;

	function Coupons(&$parent)
	{
		Widget::Widget($parent);
		$this->add_param('page');
		$this->add_param('status');
		$this->pages_navigation = new PagesNavigation($this);
	}

	function fetch()
	{
	
		if (isset($_GET['delete'])) {
			$this->check_token();
			$id = intval($_GET['delete']);
			
			$query = sql_placeholder('SELECT `user_id` FROM `coupons` WHERE id=? LIMIT 1', $id);
			$this->db->query($query);
			$user_id = $this->db->result('user_id');
			$this->db->query(sql_placeholder('DELETE FROM `coupons` WHERE id=? LIMIT 1', $id));
			$this->db->query(sql_placeholder('DELETE FROM `users` WHERE original_user_id=? LIMIT 1', $user_id));
		}
	
		$row_at_page = 25;
		$current_page = (int)$this->param('page');
		$current_page = $current_page;
		
		$filter_status = "";
		$filter_status_tpl = '0';
		
		if(isset($_GET['status'])){
			switch($_GET['status']){
				case 'active': $filter_status = sql_placeholder(" AND c.date_start <= NOW() AND c.date_finish >= NOW() "); $filter_status_tpl = 'active'; break;
				case 'noactive': $filter_status = sql_placeholder(" AND (c.date_start > NOW() OR c.date_finish < NOW()) ");  $filter_status_tpl = 'noactive'; break;
			}
		}
		$this->smarty->assign('filter_status_tpl', $filter_status_tpl);
		
		$query = sql_placeholder("SELECT count(c.id) as count FROM coupons c WHERE 1 {$filter_status} ORDER BY c.date_finish DESC");
		$this->db->query($query);
		$pages_num = $this->db->result(); 
		$pages_num = ceil($pages_num->count/$row_at_page);
		
		if ($pages_num > 0) {		
			$start_item = ($current_page)*$row_at_page;
			
			$query = sql_placeholder("
				SELECT c.*, u.card_number
				FROM coupons c
				LEFT JOIN users u ON u.original_user_id = c.user_id 
				WHERE 1 {$filter_status} ORDER BY c.date_finish DESC LIMIT ?, ?", $start_item, $row_at_page);
			$this->db->query($query);
			$coupons = $this->db->results();
			
			foreach($coupons as $key=>$coupon){
				$coupons[$key]->delete_get	= ($coupon->num_uses == 0) ? $this->form_get(array('delete' => $coupon->id)) : false;
				$coupons[$key]->active		= (strtotime($coupon->date_start) <= time() AND strtotime($coupon->date_finish) >= time()) ? true : false;
			}

			$this->smarty->assign('coupons', $coupons);

			$this->pages_navigation->fetch($pages_num);
			$this->smarty->assign('PagesNavigation', $this->pages_navigation->body);
		}

		$this->title = "Купоны";
		$this->body = $this->smarty->fetch('coupons.tpl');
	}
}