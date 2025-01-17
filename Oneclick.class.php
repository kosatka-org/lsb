<?php
require_once('Widget.class.php');

class Oneclick extends Widget
{
	function fetch() {
        $product_id = (int)$_GET['product_id'];
        $user = new luser( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 );
        $product = $this->db->result("SELECT p.*, c.name as category, b.name as brand FROM `products` p LEFT JOIN categories c ON c.category_id = p.category_id LEFT JOIN brands b ON b.brand_id = p.brand_id WHERE p.product_id = '{$product_id}' LIMIT 1");
        $product->prices = $user->product_prices($product);
        $product->price = $product->prices['personal_price'];
        $this->smarty->assign('product', $product);
        $this->smarty->assign('product_id', $_GET["product_id"]);
		$this->body = $this->smarty->fetch('one_click.tpl');
		return $this->body;
	}
}