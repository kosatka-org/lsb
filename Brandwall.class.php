<?PHP


require_once('Widget.class.php');

class Brandwall extends Widget
{
	var $items_per_page = 5; // Количество товаров на странице
	var $use_optional_categories = true; // Использовать допкатегории
	var $categories = array();
	var $error = '';
	var $cols  = 3;
	var $words_cols  = 1;

	/**
	 *
	 * Конструктор
	 *
	 */
	function Brandwall($parent)
	{
		Widget::Widget($parent);

		$categories = Storefront::get_categories();
		foreach ($categories as $k=>$v) {
			unset($categories[$k]->subcategories);
		}
		$this->categories = $categories;

        $this->smarty->assign('wall_categories', $categories);
        $this->smarty->assign('manOrWoman', true);
        $this->smarty->assign('filter_url', '/brandwall/');
	}

	/**
	 *
	 * Отображение
	 *
	 */
	function fetch()
	{
		//если нажали 'все' в переключателе пола
		if(isset($_GET['allsex'])) {
			setcookie('sex', '0', time()+60*60*24*365, '/');
			$_COOKIE['sex'] = 0;
		}
		$mw = $_GET['sex'] ? (int)$this->url_filtered_param('sex') : $_COOKIE['sex'];
		if ( !empty($mw) ) {
            $mw = (int)$mw;
            $where .= " AND (products.sex = '0' OR products.sex = '{$mw}') ";
            if ((empty($showbrand) && empty($special)) || isset($unisex)) {
                setcookie('sex', $mw, time()+60*60*24*365, '/');
                if ( isset($_SESSION['user']) && !empty($_SESSION['user']->user_id) ) {
                    $query = "UPDATE users SET sex = '{$mw}' WHERE user_id = '{$_SESSION['user']->user_id}'";
                    $this->db->query($query);
                }
            }
            $_COOKIE['sex'] = $mw;
        }
		$brand = (int)$this->url_filtered_param('brand');
		if ( !empty($brand) ) {
			header("Location: /catalog/?brand=".$brand."&showbrand=".$brand);
			die();
		}
		else {
			return $this->wall();
		}
	}

	function brand($brand) {
		$query  = "SELECT * FROM brands WHERE brand_id = '{$brand}'";
		$brands = $this->db->result($query);
		$this->smarty->assign('brand', $brands[0]);

		$this->smarty->assign('title',       $brands[0]->meta_title);
		$this->smarty->assign('keywords',    $brands[0]->meta_keywords);
		$this->smarty->assign('description', $brands[0]->meta_description);

		$where  = " products.enabled=1 ";
		$where .= " AND products.brand_id = '{$brand}' ";
		$where .= " AND products.size <> '' ";

		$query = "SELECT products.*, brands.name as brand, categories.name as category
					FROM products
					LEFT JOIN categories ON categories.category_id = products.category_id
					LEFT JOIN brands     ON brands.brand_id = products.brand_id
				  WHERE {$where}
				  GROUP BY product_id
				  ORDER BY product_id DESC";

  	    $this->db->query($query);
		$products = $this->db->results();
        $this->smarty->assign('products', $products);

		$this->body = $this->smarty->fetch('brand.tpl');

		return $this->body;
	}



	function wall() {
		$this->smarty->assign('title',       'Дизайнеры и бренды из Италии и Франции | фирменный бутик Лакшери стор');
		$this->smarty->assign('keywords',    'Дизайнеры и бренды из Италии и Франции, фирменный бутик Лакшери стор');
		$this->smarty->assign('description', 'Дизайнеры и бренды из Италии и Франции, фирменный бутик Лакшери стор');

   	    // Все возможные GET-параметры. Фильтруем для безопасности
		$category = $this->url_filtered_param('category');
		$type     = $this->url_filtered_param('type');
		$word     = $this->url_filtered_param('word');
		$brand    = $this->url_filtered_param('brand');
		$app	  = $this->url_filtered_param('app');
		$user_id    = $this->url_filtered_param('user_id');
		$mw       = (int)$this->url_filtered_param('sex') ? (int)$this->url_filtered_param('sex') : $_COOKIE['sex'];
		$this->smarty->assign('category', $category);
		$this->smarty->assign('type',     $type);


		$mw = (int)$mw;
		$where_mw = '';
		if ( !empty($mw) ) {
			$where_mw = " AND (gender = '0' OR gender = '{$mw}') ";
		}
        $this->smarty->assign('filter_url', '/brandwall/?');
        $this->smarty->assign('manOrWoman', $mw ? $mw : '0');

        // показывать скрытые бренды только избранным
        $s_user_id = $_SESSION['user']->user_id;
		if ($this->settings->theme == 'api') {
			$s_user_id = $user_id;
		}
        $user = new luser;
		$brands_str = implode(",", $user->visible_brands($s_user_id));
        $squery = " AND brands.brand_id IN ({$brands_str}) ";

        if ($this->settings->theme == 'api' && isset($_GET['all'])){
            $where_mw = '';
        }

		$query = "SELECT brands.* FROM brands INNER JOIN products ON products.brand_id=brands.brand_id WHERE brands.show_on_brandwall=1 AND brands.image != ''  {$where_mw} {$squery} GROUP BY brands.brand_id ORDER BY brands.name ASC";

		$this->db->query($query);
		$brands = $this->db->results();

		if ($this->settings->theme == 'api'){
			$return->brands = array();
			foreach($brands as $k=>$brand){
				$return->brands[$k]->id = $brand->brand_id;
				$return->brands[$k]->name = $brand->name;
				$return->brands[$k]->logo = 'https://lsboutique.ru/images/loggoss/'.$brand->app_image;
			}
      if($this->settings->theme_v == 'v2'){
        $r->obj = $return->brands;
        $return = $this->format_api_response($r);
      }
			$return = json_encode($return);
			header('Content-Type: application/json');
      echo $return;
      die();
		}
		$this->smarty->assign('brands_full',	$brands);
		$this->body = $this->smarty->fetch('brandwall.tpl');
		return $this->body;
	}
}
