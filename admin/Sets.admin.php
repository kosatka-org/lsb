<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


class Sets extends Widget
{
	var $item;
	function Sets(&$parent)
	{
		Widget::Widget($parent);
		$this->prepare();
	}

	function prepare()
	{
		if (isset($_POST['query'])) {
			$q = mysql_real_escape_string($_POST['query']);
			$data = $this->db->results("SELECT * FROM products WHERE sku LIKE \"%{$q}%\"");
		}

		if ($_GET['brand_id']) {
			$brand_id = mysql_real_escape_string($_GET['brand_id']);
			$this->smarty->assign("brand_id", $brand_id);
			$brand_filter = " AND main_product_id IN (SELECT product_id FROM products WHERE brand_id = {$brand_id}) ";
		}

		if (isset($_POST['name'])) {
			$name = mysql_real_escape_string($_POST['name']);
			$this->db->query("INSERT INTO sets (name) VALUES ('{$name}')");
			$id = $this->db->insert_id();
			$data = $this->db->result("SELECT * FROM sets WHERE id = {$id}");
		}

		$product_id = $_POST['product_id'];
		$set_id = $_POST['set_id'];

		if (isset($_POST['add_product'])) {
			$this->db->query("INSERT INTO sets_products (set_id, product_id) VALUES ({$set_id},{$product_id}) ON DUPLICATE KEY UPDATE set_id = set_id");
			$data = "OK";
		}

		if (isset($_POST['remove_product'])) {
			$this->db->query("DELETE FROM sets_products WHERE set_id={$set_id} AND product_id={$product_id}");
			$data = "OK";
		}

		if (isset($_POST['show_on_product_page'])) {
			$show_on_product_page = $_POST['show_on_product_page'];
			$this->db->query("UPDATE sets_products SET show_on_product_page={$show_on_product_page} WHERE set_id={$set_id} AND product_id={$product_id}");
			$data = "OK";
		}

		if (isset($data)) {
			header('Content-Type: application/json');
			echo json_encode($data);
			exit();
		}

		$this->items = $this->db->results("SELECT * FROM sets WHERE 1 {$brand_filter} ORDER BY date DESC LIMIT 340");

		foreach ($this->items as $key => $item) {
			$this->items[$key]->main_product = $this->db->result("SELECT * FROM products WHERE product_id = {$item->main_product_id}");
			$this->items[$key]->products = $this->db->results("SELECT * FROM products p LEFT JOIN sets_products sp ON sp.product_id = p.product_id WHERE sp.set_id = {$item->id}");
		}
	}

	function fetch() {
		$this->title = "Наборы товаров";

		$this->smarty->assign('Items', $this->items);
		$this->smarty->assign('brands', $this->db->results("SELECT * FROM brands ORDER BY name ASC"));
		$this->smarty->assign('Error', $this->error_msg);
		$this->smarty->assign('Lang', $this->lang);
		$this->smarty->assign('Modernjs', 'true');
		$js = $this->smarty->fetch('sets.js.tpl');
		$this->smarty->assign('JavaScript', $js);
		$this->body = $this->smarty->fetch('sets.tpl');
	}
}
