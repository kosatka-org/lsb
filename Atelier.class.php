<?PHP
 
require_once('Widget.class.php');


class Atelier extends Widget
{
	/* Конструктор */
	function Atelier(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		if (isset($_GET['service_add'])) {
			$this->smarty->assign('atelier_items', $this->db->results("SELECT * FROM services_items WHERE type = 'atelier'"));
			$this->smarty->assign('clean_items', $this->db->results("SELECT * FROM services_items WHERE type = 'clean'"));
			$this->smarty->assign('shoes_items', $this->db->results("SELECT * FROM services_items WHERE type = 'shoes'"));
			echo $this->smarty->fetch('service_add.tpl');
			die();
		}

		if (isset($_POST['client_id']) && isset($_POST['service_items'])) {
			$client_id = (int) $_POST['client_id'];
			$items = explode(",", $_POST['service_items']);
			$this->db->query(sql_placeholder("INSERT INTO services_orders (client_id) VALUES (?)", $client_id));
			$order_id = $this->db->insert_id();
			foreach ($items as $key => $item_id) {
				$this->db->query(sql_placeholder("INSERT INTO services_orders_items (order_id, item_id) VALUES (?, ?)", $order_id, $item_id));
			}
			echo $order_id;
			exit();
		}
	}
}
