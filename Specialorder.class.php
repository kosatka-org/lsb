<?php
require_once('Widget.class.php');

class Specialorder extends Widget
{
	function fetch() {
        $product = $this->db->result("SELECT p.*, c.parent, c.name as category, b.name as brand FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN brands b ON b.brand_id = p.brand_id WHERE p.product_id = '{$_GET['product_id']}' ");
        $this->smarty->assign('product', $product);
        $user = new luser( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 );
        $product->prices = $user->product_prices($product);
        $product->price = $product->prices['personal_price'];
        $this->smarty->assign('sizes', array('XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL', '5XL+', '6XL'));
        $this->smarty->assign('shoesizes', array('35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46'));
        
        $this->smarty->assign('product_id', $_GET["product_id"]);
		$this->body = $this->smarty->fetch('special_order.tpl');
		return $this->body;
	}
}