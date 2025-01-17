<?php

require_once('Widget.class.php');
require_once('Storefront.class.php');

ini_set('memory_limit','512M');

class Sitemap extends Widget
{
	var $single = false;

	var $title = 'Карта сайта';

	var $sections = array();
	var $news = array();
	var $articles = array();
	var $catalog = array();
	var $goods = array();
	var $cities = array();

	/**
	 *
	 * Конструктор
	 *
	 */
	function Sitemap(&$parent)
	{
		Widget::Widget($parent);
	}

	/**
	 *
	 * Отображение
	 *
	 */
	function fetch()
	{
		// Разделы меню
		$this->db->query("SELECT url, DATE_FORMAT(modified, '%Y-%m-%d') as lastmod FROM sections WHERE enabled=1 AND menu_id>0 AND url!='404' ORDER BY order_num");
		$this->sections = $this->db->results();

		// Новости
		$this->db->query("SELECT url, DATE_FORMAT(modified, '%Y-%m-%d') as lastmod FROM news WHERE enabled=1 ORDER BY news_id DESC");
		$this->news = $this->db->results();

		//  Статьи
		$this->db->query("SELECT url, DATE_FORMAT(modified, '%Y-%m-%d') as lastmod  FROM articles WHERE enabled=1 ORDER BY order_num DESC");
		$this->articles = $this->db->results();

		//  Остатки
		$this->db->query("SELECT DISTINCT(url), category_name, brand, code as code FROM ostatki
											UNION
											SELECT DISTINCT(url), category_name, brand, NULL as code FROM prodazhi WHERE enabled = 1");
		$this->stock = $this->db->results();

		// Каталог
		$this->catalog = Storefront::get_catalog();

		//Бренд
		$this->db->query("SELECT brands.* FROM brands INNER JOIN products ON products.brand_id=brands.brand_id WHERE brands.show_on_brandwall=1 AND brands.image != '' AND (products.small_image != '' OR products.large_image != '') GROUP BY brands.brand_id ORDER BY brands.name ASC");
		$brands = $this->db->results();
		$this->brands = $brands;

		//Бренд-категория
		$categories = Storefront::get_categories();

		$query = "SELECT * FROM `goods` WHERE `visible` = 1 ORDER BY `position`";
		$this->db->query($query);
		$goods = array(); $category_ids = array(); $brand_ids = array();
		foreach($this->db->results() as  $good){

			$goods[$good->id] = $good;

			$current_category = Storefront::category_by_id($categories, $good->category_id);
			$subcats_list = $current_category->subcats_ids;

			$goods[$good->id]->subcats_list = $current_category->subcats_ids;

			//----
			foreach ($subcats_list as $row) {
				$category_ids[$row] = $row;
			}
			$brand_ids[] = $good->brand_id;
		}
		if(!empty($goods)){
			foreach(Storefront::get_products(null, $category_ids, $brand_ids) as $product){
				foreach($goods as $key=>$good){
					if(in_array($product->category_id, $good->subcats_list) AND $product->brand_id == $good->brand_id){
						$goods[$key]->products[] = $product;
					}
				}
			}
		}

		$this->goods = $goods;


		$query = sql_placeholder('SELECT * FROM `cities` WHERE `visible` =? ORDER BY `position`', 1);
		$this->db->query($query);
		$cities = $this->db->results();
		if(!empty($cities))
			$this->cities = $cities;

		if($this->param('format')=='google') {
			$this->single = true;
			return $this->google_site_map();
		}
		else {
			return $this->site_map();
		}

	}

	function google_site_map()
	{
		header('Content-Type: text/xml');
		$map = '<?xml version="1.0" encoding="UTF-8"?>'."\n";
		$map.= '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n";

		// Главная страница

		$url = "https://$this->root_url";
		$lastmod = date("Y-m-d");
		$map.= "\t<url>"."\n";
		$map.= "\t\t<loc>$url</loc>"."\n";
		$map.= "\t\t<lastmod>$lastmod</lastmod>"."\n";
		$map.= "\t</url>"."\n";


		// Разделы меню
		if(!empty($this->sections))
		foreach($this->sections as $section) {
			$url = "https://$this->root_url/sections/".$this->esc($section->url).'/';
			$map.= "\t<url>"."\n";
			$map.= "\t\t<loc>$url</loc>"."\n";
			$map.= "\t\t<lastmod>{$lastmod}</lastmod>"."\n";
			$map.= "\t</url>"."\n";
		}

		// Новости
		if(!empty($this->news))
		foreach($this->news as $n) {
			$url = "https://$this->root_url/news/".$this->esc($n->url).'/';
			$map.= "\t<url>"."\n";
			$map.= "\t\t<loc>$url</loc>"."\n";
			$map.= "\t\t<lastmod>$n->lastmod</lastmod>"."\n";
			$map.= "\t</url>"."\n";
		}

		//  Статьи
		if(!empty($this->articles))
		foreach($this->articles as $article) {
			$url = "https://$this->root_url/articles/".$this->esc($article->url).'/';
			$map.= "\t<url>"."\n";
			$map.= "\t\t<loc>$url</loc>"."\n";
			$map.= "\t\t<lastmod>$article->lastmod</lastmod>"."\n";
			$map.= "\t</url>"."\n";
		}

		//  Товары
		$map.= $this->category_map_recursive($this->catalog);
        
		//  Бренды
		$map.= $this->brands_map_recursive($this->brands);

		// Бренд-категория
		if(!empty($this->goods))
		foreach($this->goods as $good) {
			if($good->products) {
				$url = "https://$this->root_url/goods/".$this->esc($good->url).'/';
				$map.= "\t<url>"."\n";
				$map.= "\t\t<loc>$url</loc>"."\n";
				$map.= "\t\t<lastmod>".date("Y-m-d")."</lastmod>"."\n";
				$map.= "\t</url>"."\n";
				foreach($good->products as $product) {
					$url = "https://$this->root_url/products/".$this->esc($product->url).'/';
					$map.= "\t<url>"."\n";
					$map.= "\t\t<loc>$url</loc>"."\n";
					$map.= "\t\t<lastmod>$product->modified</lastmod>"."\n";
					$map.= "\t</url>"."\n";
				}
			}
		}

		//  города
		if(!empty($this->cities))
		foreach($this->cities as $city) {
			$url = "https://$this->root_url/city/".$this->esc($city->url).'/';
			$map.= "\t<url>"."\n";
			$map.= "\t\t<loc>$url</loc>"."\n";
			$map.= "\t\t<lastmod>" . date('Y-m-d', strtotime($city->lastmod)). "</lastmod>\n";
			$map.= "\t</url>"."\n";
		}

		$map.= '</urlset>';

		$this->body = $map;
		return $map;

	}

	function category_map_recursive($categories)
	{
		foreach($categories as $category) {
			if($category->products) {
				$url = "https://$this->root_url/categories/".$this->esc($category->url).'/';
				$map.= "\t<url>"."\n";
				$map.= "\t\t<loc>$url</loc>"."\n";
				$map.= "\t\t<lastmod>".date("Y-m-d")."</lastmod>"."\n";
				$map.= "\t</url>"."\n";

				$url = "https://$this->root_url/categories/".$this->esc($category->url)."/?sex=1";
				$map.= "\t<url>"."\n";
				$map.= "\t\t<loc>$url</loc>"."\n";
				$map.= "\t\t<lastmod>".date("Y-m-d")."</lastmod>"."\n";
				$map.= "\t</url>"."\n";

/*				foreach($category->products as $product) {
					if ($product->sex == 1) {
						$url = "https://$this->root_url/products/".$this->esc($product->url);
						$map.= "\t<url>"."\n";
						$map.= "\t\t<loc>$url</loc>"."\n";
						$map.= "\t\t<lastmod>$product->modified</lastmod>"."\n";
						$map.= "\t</url>"."\n";
					}
				}*/

				$url = "https://$this->root_url/categories/".$this->esc($category->url)."/?sex=2";
				$map.= "\t<url>"."\n";
				$map.= "\t\t<loc>$url</loc>"."\n";
				$map.= "\t\t<lastmod>".date("Y-m-d")."</lastmod>"."\n";
				$map.= "\t</url>"."\n";

/*				foreach($category->products as $product) {
					if ($product->sex == 2) {
						$url = "https://$this->root_url/products/".$this->esc($product->url).'/';
						$map.= "\t<url>"."\n";
						$map.= "\t\t<loc>$url</loc>"."\n";
						$map.= "\t\t<lastmod>$product->modified</lastmod>"."\n";
						$map.= "\t</url>"."\n";
					}
				}*/
			}
			if($category->subcategories) {
				$map .= $this->category_map_recursive($category->subcategories);
			}
		}
		return $map;
	}
    
    function brands_map_recursive($brands)
	{
		foreach($brands as $brand) {
            $url = "https://$this->root_url/brands/".$this->esc($brand->url).'/';
            $map.= "\t<url>"."\n";
            $map.= "\t\t<loc>$url</loc>"."\n";
            $map.= "\t\t<lastmod>".date("Y-m-d")."</lastmod>"."\n";
            $map.= "\t</url>"."\n";

            if($brand->gender == 1 || $brand->gender == 0){
                $url = "https://$this->root_url/brands/".$this->esc($brand->url)."/?sex=1";
                $map.= "\t<url>"."\n";
                $map.= "\t\t<loc>$url</loc>"."\n";
                $map.= "\t\t<lastmod>".date("Y-m-d")."</lastmod>"."\n";
                $map.= "\t</url>"."\n";
            }

            if($brand->gender == 2 || $brand->gender == 0){
                $url = "https://$this->root_url/brands/".$this->esc($brand->url)."/?sex=2";
                $map.= "\t<url>"."\n";
                $map.= "\t\t<loc>$url</loc>"."\n";
                $map.= "\t\t<lastmod>".date("Y-m-d")."</lastmod>"."\n";
                $map.= "\t</url>"."\n";
            }
		}
		return $map;
	}

	function site_map()
	{
		// Передаем в шаблон
		$this->smarty->assign('stock', $this->stock);
		$this->smarty->assign('catalog', $this->catalog);
		$this->smarty->assign('brands', $this->brands);
		$this->smarty->assign('goods', $this->goods);
		$this->smarty->assign('updates', $this->updates);
		$this->smarty->assign('cities', $this->cities);
		$this->body = $this->smarty->fetch('sitemap.tpl');

		return $this->body;

	}


	function esc($s)
	{
		return(htmlspecialchars($s, ENT_QUOTES, 'UTF-8'));
	}

}
