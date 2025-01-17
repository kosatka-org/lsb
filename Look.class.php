<?php
require_once('Widget.class.php');

class Look extends Widget
{
	function Look(&$parent)
	{
		Widget::Widget($parent);
	}

	function fetch() {
    $image_link = 'https://lsboutique.ru';
    if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
		$set_id = $this->url_filtered_param('look');
		$query = sql_placeholder("SELECT * FROM sets WHERE id = ? LIMIT 1", $set_id);
		$set = $this->db->result($query);
		$main_product = $this->db->result($sql="SELECT p.*, c.eng_name AS eng_cat, c.eng_single_name AS cat_eng_name, b.name AS brand_name, b.offline_only FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN brands b ON p.brand_id = b.brand_id WHERE p.product_id = {$set->main_product_id}");
		$items = $this->db->results("SELECT p.product_id as product_id, p.*, c.eng_name AS eng_cat, c.eng_single_name AS cat_eng_name, b.name AS brand_name, b.offline_only
			FROM products p
			LEFT JOIN brands b ON p.brand_id = b.brand_id
      LEFT JOIN categories c ON p.category_id = c.category_id
			LEFT JOIN sets_products sp ON p.product_id = sp.product_id
			WHERE sp.set_id = {$set->id} AND p.large_image !=''");
		if ($main_product) {
			array_unshift($items, $main_product);
		}

		if ($this->settings->theme == "discount") {
			$megasale_filter = "AND name LIKE 'SALE Online shop%'";;
		}
		else {
			$megasale_filter = "AND name NOT LIKE 'SALE Online shop%'";;
		}
    $s_user_id = $_SESSION['user']->original_user_id;
    if ($this->settings->theme == 'api') {$s_user_id = $_GET['user_id'];}
    $user      = new luser( !empty($s_user_id) ? $s_user_id : 0 );

		foreach ($items as $item) {
			$query = "SELECT size_id, size_type, size_system, size, shop_id
                  FROM items
                  WHERE quantity != 0 AND product_id={$item->product_id} AND shop_id IN (SELECT shop_id FROM shops WHERE enabled=1 {$megasale_filter}) GROUP BY size ORDER BY FIELD(size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+'), size + 0, size ASC ";

      $item->sizes = $this->db->results($query);
      $sizes_str = [];
      foreach ($item->sizes as $size) {
        if($size->size_system == 'Европа (EU)'){$size->str_size = $size->size;}
        else{
        $size->str_size = $this->db->result("SELECT size FROM size_names WHERE size_id = {$size->size_id} AND size_m_s = '{$size->size_system}'")->size;
          if (!$size->str_size) {
            $size->str_size = $size->size;
          }
        }
        $sizes_str[] = $size->str_size;
      }
      $sizes_str = array_unique($sizes_str);
      $item->size = implode("|", $sizes_str);
      
      $item->size_text = explode('|', trim($item->size, '|') );
      $item->prices = $user->product_prices($item);
      $item->brand_name = trim($item->brand_name);
      $brand_name_short = str_replace(array('.'), '', $item->brand_name);
      $brand_name_join  = str_replace(' ', '', $item->brand_name);
      $brand_name_ap  = str_replace('`', "'", $item->brand_name);
      $brands_names = array($item->brand_name, $brand_name_short, $brand_name_ap,
                    strtolower($item->brand_name), strtoupper($item->brand_name), ucfirst($item->brand_name),ucwords($item->brand_name),
                    strtolower($brand_name_join), strtoupper($brand_name_join), ucfirst($brand_name_join),ucwords($brand_name_join));
      $item->category_name = trim(str_replace($brands_names, '', $item->model));
      
      $item->can_buy_from_site = $user->can_buy_from_site($item->brand_id);
      if($_COOKIE['language'] === 'eng'){
        if($item->category_id == 97 && $_COOKIE['sex'] == 1){$item->cat_eng_name = 'Oxford shoes';}
        $item->model = $item->cat_eng_name . ' ' . $item->brand_name;
        $item->category_name = $item->cat_eng_name;
        $item->category = $item->eng_cat;
      }
			if ($this->settings->theme == 'api') {
        if($_COOKIE['language'] === 'eng'){
          $item->description = $item->body = $item->uhod = $item->seo_words = $item->text_sizes = '';
        }
        else{
          $item->description = strip_tags(str_replace('</p>', '\n ', $item->description));
          $item->body = strip_tags(str_replace('</p>', '\n ', $item->body));
          $item->size = strip_tags(str_replace('</p>', '\n ', $item->size));
          $item->seo_words = strip_tags(str_replace('</p>', '\n ', $item->seo_words));
          $item->text_sizes = strip_tags(str_replace('</p>', '\n ', $item->text_sizes));
          $item->text_sizes = strip_tags(str_replace('</p>', '\n ', $item->text_sizes));
          $item->uhod = strip_tags(str_replace('</p>', '\n ', $item->uhod));
        }
        $item->eng_text_sizes = strip_tags(str_replace('</p>', '\n ', $item->eng_text_sizes));
        $item->size = str_replace("|", ", ", trim($item->size, "|"));
        if($item->size == 'undefined' || strpos($item->size, 'зад') !== false || strpos($item->size, 'азмер') !== false ){
            if($_COOKIE['language'] === 'eng'){$item->size = 'No size';}
            else{$item->size = 'р-р не задан';}
        }
        $item->brand = $this->db->result("SELECT name FROM brands WHERE brand_id = {$item->brand_id}")->name;
        $item->prices = $user->product_prices_for_api($item, $_GET['currency'], $item->can_buy_from_site);
        if($_COOKIE['language'] != 'eng'){$item->category = $this->db->result("SELECT name FROM categories WHERE category_id = {$item->category_id}")->name;}
        if ( !empty($big_size) && $item->bsize_small_image != '' ) {
          $item->small_image_small = $image_link . '/reimg/files/items/340x/'.$item->bsize_small_image;
          $item->small_image_medium = $image_link . '/reimg/files/items/560x/'.$item->bsize_small_image;
          $item->small_image_full = $image_link . '/reimg/files/items/560x/'.$item->bsize_small_image;
        }
        else{
          $item->small_image_small = $image_link . '/reimg/files/products/340x/'.$item->small_image;
          $item->small_image_medium = $image_link . '/reimg/files/products/560x/'.$item->small_image;
          $item->small_image_full = $image_link . '/reimg/files/products/560x/'.$item->small_image;
        }
        if ( !empty($big_size) && $item->bsize_large_image != '' ){
          $item->large_image_small = $image_link . '/reimg/files/products/340x/'.$item->bsize_large_image;
          $item->large_image_medium = $image_link . '/reimg/files/products/560x/'.$item->bsize_large_image;
          $item->large_image_full = $image_link . '/reimg/files/products/560x/'.$item->bsize_large_image;
        }
        else{
          $item->large_image_small = $image_link . '/reimg/files/products/340x/'.$item->large_image;
          $item->large_image_medium = $image_link . '/reimg/files/products/560x/'.$item->large_image;
          $item->large_image_full = $image_link . '/reimg/files/products/560x/'.$item->large_image;
        }
        unset($item->url,$item->old_url,$item->tsum_url,$item->guarantee,$item->seo_words,$item->quantity,$item->sold,
          $item->hit,$item->order_num,$item->download,$item->meta_title,$item->meta_keywords,$item->meta_description,
          $item->created,$item->new_stuff,$item->modified,$item->sold_date,$item->desc_date,$item->editor_id,
          $item->last_price_update,$item->pack_id,$item->photo_added,$item->prop_val,$item->tsum_price,$item->discount_value,
          $item->second_image,$item->week,$item->show_price,$item->enabled,$item->small_image,$item->large_image,
          $item->bsize_small_image,$item->bsize_large_image,$item->eng_text_sizes,$item->eng_uhod,$item->eng_body,
          $item->eng_description,$item->trello_card,$item->video_added,$item->sizes_max_count,$item->col_code,$item->coll_active,$item->cat_enabled,$item->video);
      }
		}

		$user = new luser();
		$s_user_id = $_SESSION['user']->original_user_id;
        if ($this->settings->theme == 'api') {$s_user_id = $_GET['user_id'];}
		$is_logged_in = !empty($s_user_id);
		if ($is_logged_in) {
			$sum = $user->get_sum_of_buy( $s_user_id );
			foreach ($items as $key => $item) {
				$disc = $user->get_personal_discount( $item, $sum, 1, $s_user_id );
				$items[$key]->discount_percent = $disc;
				$items[$key]->discount_price = ($item->price * (100 - $disc)) / 100;
			}
		}

		if ($this->settings->theme == 'api') {
      if($_COOKIE['language'] === 'eng'){
        $set->name = $main_product->cat_eng_name .' '. $main_product->brand_name .' - '.$main_product->sku;
      }
			$set->image_small = $image_link . '/reimg/files/products/340x/'.$set->image;
			$set->image_medium = $image_link . '/reimg/files/products/560x/'.$set->image;
			$set->image_full = $image_link . '/reimg/files/products/560x/'.$set->image;
			$set->url = 'https://lsboutique.ru/look/'.$set->id . '/';
			unset($set->image);
      if($this->settings->theme_v == 'v2'){
        $return->obj[0] = $set;
        $return->obj[0]->products = $items;
        $return = $this->format_api_response($return);
      }
      else{
        $return->look->set = $set;
        $return->look->set->products = $items;
      }
			$return = json_encode($return);
			header('Content-Type: application/json');
			echo $return;
      die();
		}

    if($_COOKIE['language'] === 'eng'){$title = 'Total look from the stylist of Luxury Store | Luxury Store';}
    else{$title = 'Полный образ от стилиста Лакшери Store | бутик Лакшери Стор';}

		$this->smarty->assign('set', $set);
		$this->smarty->assign('products', $items);
		$this->smarty->assign('title', $title);
		$og_image = ($set->image) ? $set->image :  $items[0]->small_image;
		$this->smarty->assign('og_image', '/reimg/files/products/340x/'.$og_image);
		$this->body = $this->smarty->fetch('look.tpl');
		return $this->body;
	}
}
