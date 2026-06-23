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


		// Каталог
		$this->catalog = Storefront::get_catalog();

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
