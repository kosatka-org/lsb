<?php
require_once('Widget.class.php');

class Orderform extends Widget
{
	function fetch() {
    
        $this->smarty->assign('weight', $_GET['weight']);
        $this->smarty->assign('total',  $_GET['total']);

        // Сформируем массив способов доставки и тоже в форму заказа
        $query = "SELECT * FROM delivery_methods WHERE enabled ORDER BY delivery_method_id";
        $this->db->query($query);
        $delivery_methods = $this->db->results();
        foreach ($delivery_methods as $k=>$method) {
            $delivery_methods[$k]->final_price = $method->price;
            if ($method->free_from <= $total_price) {
                $delivery_methods[$k]->final_price = 0;
            }
        }
        $this->smarty->assign('delivery_methods', $delivery_methods);

        $query = "SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;";
        $this->db->query($query);
        $delivery_cities_main = $this->db->results();
        $this->smarty->assign('delivery_cities_main', $delivery_cities_main);

        $query = "SELECT * FROM delivery_cities WHERE city_owner_id = '0' ORDER BY city_name;";
        $this->db->query($query);
        $delivery_cities = $this->db->results();
        $this->smarty->assign('delivery_cities', $delivery_cities);

        $this->smarty->assign('group_id', $_SESSION['user']->group_id);
        
        
        if (is_array($_SESSION['shopping_cart']) && is_array($_SESSION['shopping_cart_sizes'])) {
          $products = Storefront::get_products(array_keys($_SESSION['shopping_cart']));
          $res_products = array();
          if (!empty($products)) {
            $user = new luser( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 );
            foreach ($products as $k=>$product) {
              if ( is_array($_SESSION['shopping_cart_sizes'][$product->product_id]) && count($_SESSION['shopping_cart_sizes'][$product->product_id]) ) {
                  foreach ($_SESSION['shopping_cart_sizes'][$product->product_id] as $size => $v) {

                    // проверяем наличие данного размера в базе данных
                    $found_item = 1;//$this->db->result("SELECT * FROM `products` WHERE size LIKE '%|".$size."|%' AND product_id = ".$product->product_id);

                    // если товар есть в наличии - показываем его
                    if (!empty($found_item) && count($found_item)==1) {
                        $product = new stdClass(); foreach ($products[$k] as $kk=>$vv) $product->$kk = $vv; $product->amount = 1;

                        $product->prices    = $user->product_prices($product);
                        $product->price     = $product->prices['personal_price'];
                        if ( ($product->price - 0.1) > $product->last_price_online ) {
                          $product->with_online_discount = true;
                        }
                        if($_COOKIE['language'] === 'eng'){$product->model = $product->eng_single_name . ' ' . $product->brand;}
                        $total_price       += $product->price*$product->amount;
                        $product->size      = $size != 'undefined' && strpos($size, 'задан') === false && strpos($size, 'азмер') === false ? $size : '';
                        $res_products[]     = $product;

                        $weight_tmp = $this->db->result( sql_placeholder("SELECT weight FROM `categories` WHERE category_id=? LIMIT 1", $product->category_id) );
                        $weight += !empty($weight_tmp->weight) ? $weight_tmp->weight : 0;
                    }
                    // в противном случае - удаляем из корзины
                    else {
                        $this->update($product->product_id, 0);
                    }
                  }
              }
            }
          }
        }
        $this->smarty->assign('products', $res_products);

        $this->body = $this->smarty->fetch('order_form.tpl');
        return $this->body;
        die();
/*        
       // $this->smarty->assign('product_id', $_GET["product_id"]);
		$this->body = $this->smarty->fetch('order_form.tpl');
		return $this->body;
*/
	}
}