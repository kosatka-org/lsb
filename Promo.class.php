<?PHP
 
require_once('Widget.class.php');


class Promo extends Widget
{
	/* Конструктор */
	function Promo(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$name = $this->url_filtered_param('name');
		if (!empty($name)) {
			$promo = $this->db->result("SELECT * FROM promo WHERE name = '{$name}'");
		}
		else {
			exit();
		}
		$promo->brands = $this->db->results("SELECT * FROM brands WHERE brand_id IN ({$promo->brands})");
		
		$this->smarty->assign('item', $promo);
		$this->body = $this->smarty->fetch($name.'_promo.tpl');
		echo $this->body;
		exit();
	}
}

?>
