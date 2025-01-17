<?php
ini_set('display_errors', 'Off');
session_start();
include_once 'models/user.php';
require_once 'Storefront.class.php';
include_once 'Widget.class.php';

class Recomendation extends Widget
{

    var $products;
    var $filter = array();

    function Recomendation(&$parent) {
        Widget::Widget($parent);
    }



    public function get_html() {

        $filter = array();
        if ( !empty($this->filter['sex']) ) {
            $filter['sex'] = $this->filter['sex'];
        }
        $filter['not_sale'] = true;
        $tmp_products = Storefront::get_products($this->filter['product_ids'], null, null, null, $filter);
        if ( !is_array($tmp_products) || count($tmp_products) == 0 ) return ''; // Пусто - выходим
        $tmp_products2 = array(); // Переложим по-удобнее
        foreach($tmp_products as $product) {
            $tmp_products2[$product->product_id] = $product;
        }

        $this->products = array();

        @$remove_ids = array_flip($this->filter['remove_ids']);
        foreach($this->filter['product_ids'] as $id) if ( isset($tmp_products2[$id]) && !isset($remove_ids[$id]) ) {
            $this->products[] = $tmp_products2[$id];
            unset($tmp_products2[$id]);
        }

        if ($this->filter['limit']) { // Берем первые limit товаров
            $this->products = array_slice($this->products, 0, $this->filter['limit']);
        }

        $user = new luser( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 );

        foreach ($this->products as &$product) {
            $product->show_price = empty($product->prop_val);
            $product->brand      = strtoupper($product->brand);
            $product->size       = str_replace("|", ", ", trim($product->size, "|"));

            $product->discount_value    = $discount = $user->get_personal_discount($product, $user->get_sum_of_buy( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 ), !empty($_SESSION['group']->discount));
            $product->can_buy_from_site = $user->can_buy_from_site($product->brand_id);
            $sale_name = 'sale' . round((1 - ($product->price/$product->old_price)) * 100, -1);
            $product->sale_icon = $this->settings->$sale_name;

            if ( !empty($discount) ) {
                $product->discount_price = floor((100-$discount)*$product->price/100);
            }
            $product->week = strtotime($product->modified) > time() - 60*60*24*7 ? 1 : 2;
        }

        $currency->sign = 'рублей';
        $this->smarty->assign('currency', $currency);
        $this->smarty->assign('recommended_by', $_GET['type']);
        $this->smarty->assign('wallproducts', $this->products);
        $this->smarty->assign('only_products', true);
        return $this->smarty->fetch('catalogwall.tpl');
    }



    public function set_filter($name, $value) {
        $this->filter[$name] = $value;
    }
}

if (!empty($_GET['ids'])) { // Если не передали ids - делать вообще нечего
    $Recomendation = new Recomendation($a = NULL);
    $Recomendation->set_filter('product_ids', $_GET['ids']);

    $sex = !empty($_GET['sex']) ? $_GET['sex'] : ( !empty($_COOKIE['sex']) ? $_COOKIE['sex'] : 0 );
    if ( $sex ) {
        $Recomendation->set_filter('sex', intval($sex));
    }
    if(!empty($_GET['limit'])) {
        $Recomendation->set_filter('limit', intval($_GET['limit']));
    }
    if(is_array($_GET['remove_ids'])){
        $Recomendation->set_filter('remove_ids', $_GET['remove_ids']);
    }

    print $Recomendation->get_html();
}
die();