<?PHP
if (!function_exists('json_encode')) {
    function json_encode($value)
    {

        if (is_int($value)) {
            return (string)$value;
        } elseif (is_string($value)) {
	        $value = str_replace(array('\\', '/', '"', "\r", "\n", "\b", "\f", "\t"),
	                             array('\\\\', '\/', '\"', '\r', '\n', '\b', '\f', '\t'), $value);
	        $convmap = array(0x80, 0xFFFF, 0, 0xFFFF);
	        $result = "";
	        for ($i = mb_strlen($value) - 1; $i >= 0; $i--) {
	            $mb_char = mb_substr($value, $i, 1);
	            if (mb_ereg("&#(\\d+);", mb_encode_numericentity($mb_char, $convmap, "UTF-8"), $match)) {
	                $result = sprintf("\\u%04x", $match[1]) . $result;
	            } else {
	                $result = $mb_char . $result;
	            }
	        }
	        return '"' . $result . '"';
        } elseif (is_float($value)) {
            return str_replace(",", ".", $value);
        } elseif (is_null($value)) {
            return 'null';
        } elseif (is_bool($value)) {
            return $value ? 'true' : 'false';
        } elseif (is_array($value)) {
            $with_keys = false;
            $n = count($value);
            for ($i = 0, reset($value); $i < $n; $i++, next($value)) {
                        if (key($value) !== $i) {
			      $with_keys = true;
			      break;
                        }
            }
        } elseif (is_object($value)) {
            $with_keys = true;
        } else {
            return '';
        }
        $result = array();
        if ($with_keys) {
            foreach ($value as $key => $v) {
                $result[] = json_encode((string)$key) . ':' . json_encode($v);
            }
            return '{' . implode(',', $result) . '}';
        } else {
            foreach ($value as $key => $v) {
                $result[] = json_encode($v);
            }
            return '[' . implode(',', $result) . ']';
        }
    }
}

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('../placeholder.php');
require_once('Storefront.admin.php');
require_once('../models/copywriters.php');
############################################
# Class Product - edit the static section
############################################
class Product extends StorefrontGeneral
{
	var $item;
	var $copywriter_fields = array('description', 'body', 'text_sizes', 'uhod');

	function Product(&$parent) {
		StorefrontGeneral::StorefrontGeneral($parent);
		$this->add_param('page');
		$this->add_param('brand_id');
		$this->add_param('category');
		$this->prepare();
	}

function prepare() {
  if ($_POST['order_add'] && ($_SESSION['user']->group_id == 2 || $_SESSION['user']->group_id == 5)) {
    $order_add = json_decode($_POST['order_add']);
    $product = $this->db->result("SELECT * FROM products WHERE product_id = {$order_add->product_id}");
    $order = $this->db->result("SELECT * FROM orders WHERE order_id = {$order_add->order_id}");
    $datas = $this->db->results("SELECT order_id, one_click_id FROM orders_products WHERE order_id = {$order_add->order_id}");

    $sql = "INSERT INTO orders_products(order_id, user_id, product_id, product_name, price, quantity, size, sku) VALUES({$order->order_id}, {$order->user_id}, {$product->product_id}, '{$product->model}', {$order_add->price}, 1, '{$order_add->size}', '{$product->sku}')";
    $this->db->query($sql);
    $message = "{$_SESSION['user']->name} <@{$_SESSION['user']->slack_name}> добавил в заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order->order_id}|{$order->order_id}> товар <https://lsboutique.ru/admin/index.php?section=Product&item_id={$product->product_id}|{$product->model}> с ценой {$order_add->price} р";
    $text = "<b>{$_SESSION['user']->name}</b> добавил в заказ товар <b>{$product->model} ID:{$product->product_id}</b> по цене <b>{$order_add->price}</b> р.";
    if ($product->price != $order_add->price){
        $message = "{$_SESSION['user']->name} <@{$_SESSION['user']->slack_name}> добавил в заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order->order_id}|{$order->order_id}> товар <https://lsboutique.ru/admin/index.php?section=Product&item_id={$product->product_id}|{$product->model}>изменив цену с {$product->price} р на {$order_add->price} р";
        $text = "<b>{$_SESSION['user']->name}</b> добавил в заказ товар <b>{$product->model} ID:{$product->product_id}</b> изменив цену с <b>{$product->price}</b> р на <b>{$order_add->price}</b> р.";
    }
    $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "orders_price_changes" );
    Job::push('SlackJob', $args);
    $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order->order_id}, {$_SESSION['user']->user_id}, 'add_product', '{$text}')");


    foreach ($datas as $k=>$v){
        if (!empty($v->one_click_id)){
            $dcheck = $this->db->result("SELECT cr_manager FROM one_click WHERE id = {$v->one_click_id}")->cr_manager;

        }
        else{
           $dcheck = $this->db->result("SELECT cr_manager FROM orders WHERE order_id = {$v->order_id}")->cr_manager;
        }
        if(!empty($dcheck)){$datacheck = $dcheck;}
    }
    if(!isset($datacheck) && empty($datacheck)){
        // Отправляем в слак
        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "price_change_log" );
        Job::push('SlackJob', $args);
    }
    exit(var_dump($sql));
  }

  if(isset($_GET['measuring']) && !empty($_GET['measuring'])){
    $product_id = (int)$_GET['measuring'];
    $items = $this->db->results($sql="SELECT i.item_id AS item, i.product_id AS product, i.size, im.*, i.barcode FROM items i
        LEFT JOIN items_measuring im ON im.barcode = i.barcode
        WHERE i.quantity != 0 AND i.product_id = {$product_id}
        ORDER BY i.item_id");
    $ids = array();
    foreach($items as $item){
      $ids[] = $item->barcode;
    }
    $ids = implode(',',$ids);
    $sold_items = $this->db->results($sql="SELECT i.item_id AS item, i.product_id AS product, i.barcode, i.size, im.* FROM items i
        LEFT JOIN items_measuring im ON im.item_id = i.item_id
        WHERE i.product_id = {$product_id} AND i.barcode NOT IN ({$ids}) AND im.id IS NOT NULL
        ORDER BY i.item_id");
    $this->smarty->assign('items', $items);
    $this->smarty->assign('sold_items', $sold_items);
    $body = $this->smarty->fetch('measuring_form.tpl');
    exit($body);
  }

  if(isset($_POST['measurings_send']) && !empty($_POST['measurings_send'])){
    $items = json_decode($_POST['measurings_send']);
    if(!empty($items)){
      foreach($items as $item){
        if($item->shoulders != 0 || $item->chest != 0 || $item->waist != 0 || $item->lenght_on_back != 0 || $item->sleeve != 0 || $item->bottom_band != 0 || $item->hips != 0 || $item->thigh != 0 || $item->waist_height != 0 || $item->bottom_width != 0 || $item->knee_width != 0 || $item->leg_lenght != 0 || $item->insole_width != 0 || $item->insole_length != 0){
          $id = $this->db->result("SELECT id FROM items_measuring WHERE barcode = {$item->barcode}")->id;
          if(empty($id)){
            $this->db->query($sql="INSERT INTO items_measuring (item_id,barcode,user_id,product_id,date,shoulders,chest,waist,lenght_on_back,sleeve,bottom_band,hips,thigh,waist_height,bottom_width,knee_width,leg_lenght,insole_width,insole_length)
                           VALUES ({$item->item_id},{$item->barcode},{$_SESSION['user']->user_id},{$item->product_id},NOW(),'{$item->shoulders}','{$item->chest}','{$item->waist}','{$item->lenght_on_back}','{$item->sleeve}','{$item->bottom_band}','{$item->hips}','{$item->thigh}','{$item->waist_height}','{$item->bottom_width}','{$item->knee_width}','{$item->leg_lenght}','{$item->insole_width}','{$item->insole_length}')");
          }
          else{
            $this->db->query($sql="UPDATE items_measuring SET date = NOW(), shoulders = '{$item->shoulders}',chest = '{$item->chest}',waist = '{$item->waist}',lenght_on_back = '{$item->lenght_on_back}',sleeve = '{$item->sleeve}',bottom_band = '{$item->bottom_band}',hips = '{$item->hips}',thigh = '{$item->thigh}',waist_height = '{$item->waist_height}',bottom_width = '{$item->bottom_width}',knee_width = '{$item->knee_width}',leg_lenght = '{$item->leg_lenght}',insole_width = '{$item->insole_width}',insole_length = '{$item->insole_length}' WHERE barcode = {$item->barcode}");
          }
        }
      }
      exit('ok');
    }
    exit('fail');
  }

  if(isset($_GET['y_translate']) && !empty($_GET['y_translate'])){
    require_once('../y_translate.php');
    $text = translate($_GET['y_translate']);
    exit($text);
  }

	$this->copywriters = new copywriters();

	$is_copywriter = $this->copywriters->get_copywriter($_SESSION['user']->user_id) ? true : false;
	$this->smarty->assign('is_copywriter', $is_copywriter);

  	$this->item->product_id = intval($this->param('item_id'));
  	$this->item->product_code = intval($this->param('item_code'));
  	if (!$this->item->product_id) {
		$this->item->product_id = intval(isset($_POST['product_id'])?$_POST['product_id']:null);
	}

    $this->item->category_id	= $this->param('category');
    $this->item->brand_id		= $this->param('brand_id');

  	if (!empty($this->item->product_id) || !empty($this->item->product_code)) {
      $this->item = $this->get_product($this->item->product_id, $this->item->product_code);
      if ($is_copywriter) {
        $this->prepare_copywriter_tasks( 'product', $this->item->product_id );
      }
      if ((!empty($_POST['video']) && trim($_POST['video']) != $this->item->video) || (!empty($_POST['vimeo']) && trim($_POST['vimeo']) != $this->item->vimeo) || (!empty($_POST['vimeo_w']) && trim($_POST['vimeo_w']) != $this->item->vimeo_w)) {
        $message = "{$_SESSION['user']->name} добавил видео к товару #<https://lsboutique.ru/products/{$this->item->url}|{$this->item->model}>";
        $this->db->query("UPDATE products SET video_added = NOW() WHERE product_id = {$this->item->product_id}");
        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "video_add" );
        Job::push('SlackJob', $args);
        $args    = array( 'user' => 'ls_offline_admin', 'message' => $message, 'channel' => "video" );
        Job::push('SlackJob', $args);
      }
  	}

  	if (isset($_POST['category_id']) && isset($_POST['brand_id']) && isset($_POST['model']) && isset($_POST['price']) ) {
      $this->item->url                = str_replace("/", "", $_POST['url']);
      $this->item->category_id        = $_POST['category_id'];
      $this->item->brand_id           = $_POST['brand_id'];
      $this->item->color_id           = $_POST['color_id'];
      $this->item->fitting            = $_POST['fitting'];
      $this->item->stretch            = $_POST['stretch'];
      $this->item->model              = trim($_POST['model']);
      $this->item->model_full         = trim($_POST['model_full']);
      $this->item->sku                = trim($_POST['sku']);
      $this->item->video              = trim($_POST['video']);
      $this->item->vimeo              = trim($_POST['vimeo']);
      $this->item->vimeo_w              = trim($_POST['vimeo_w']);
      $this->item->tsum_url           = trim($_POST['tsum_url']);
      $this->item->price              = intval(preg_replace('/[^0-9]/', '', $_POST['price']));
      $this->item->old_price          = intval(preg_replace('/[^0-9]/', '', $_POST['old_price']));
      $this->item->description        = strip_custom_tags($_POST['description']);
      $this->item->eng_description    = strip_custom_tags($_POST['eng_description']);
      $this->item->body               = strip_custom_tags($_POST['body']);
      $this->item->eng_body           = strip_custom_tags($_POST['eng_body']);
      $this->item->text_sizes         = strip_custom_tags($_POST['text_sizes']);
      $this->item->eng_text_sizes     = strip_custom_tags($_POST['eng_text_sizes']);
      $this->item->uhod               = strip_custom_tags($_POST['uhod']);
      $this->item->eng_uhod           = strip_custom_tags($_POST['eng_uhod']);
      $this->item->quantity           = $_POST['quantity'];
      $this->item->meta_title         = strip_tags($_POST['meta_title']);
      $this->item->related            = trim($_POST['related']);
      $this->item->size               = strtoupper(trim($_POST['size']));
      $this->item->season             = trim($_POST['season']);
      $this->item->categories         = $_POST['categories'];
      $this->item->meta_keywords      = strip_tags($_POST['meta_keywords']);
      $this->item->meta_description   = strip_tags($_POST['meta_description']);
      $this->item->no_discount        = $_POST['no_discount'] == 1 ? 1 : 0;
      $this->item->show_out_of_stock  = $_POST['show_out_of_stock'] == 1 ? 1 : 0;

		$this->item->s_material = '';
		if ($_POST['materials']){
			$this->db->query("DELETE FROM products_materials WHERE product_id = {$this->item->product_id}");
			foreach ($_POST['materials'] as $material) {
				$this->db->query("INSERT INTO products_materials VALUES ({$this->item->product_id}, {$material})");
			}
			$materials = implode(',', $_POST['materials']);
			$this->item->s_material = $materials;
		}

		if ($_POST['super_price']) {
			$this->db->query("UPDATE products SET super_price = 1 WHERE product_id = {$this->item->product_id}");
		}
		else {
			$this->db->query("UPDATE products SET super_price = 0 WHERE product_id = {$this->item->product_id}");
		}

		$this->item->enabled	= isset($_POST['enabled']) ? 1 : 0;

        ## Не допустить одинаковые URL товаров.
        $res = $this->db->result(sql_placeholder('select count(*) as count from products where url=? and product_id!=?', $this->item->url, $this->item->product_id));


  		if (empty($this->item->model))
  		  $this->error_msg = $this->lang->ENTER_MODEL;
  		elseif($res->count>0)
  		  $this->error_msg = 'Товар с таким URL уже существует. Выберите другой URL.';
        else {
  			if(empty($this->item->product_id)) {
  			   $query = sql_placeholder('INSERT INTO products(url, sex, category_id, brand_id, color_id, model, model_full, sku, price, old_price, description, eng_description, body, eng_body, `size`, text_sizes, eng_text_sizes, uhod, eng_uhod, quantity, enabled, meta_title, meta_keywords, meta_description, created, modified, s_material, fitting, stretch)
											 VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now())',
                                  $this->item->url,
                                  isset($_POST['sex']) ? (int)$_POST['sex'] : 0,
                                  $this->item->category_id,
                                  $this->item->brand_id,
                                  $this->item->color_id,
                                  $this->item->model,
                                  $this->item->model_full,
                                  $this->item->sku,
                                  $this->item->price,
                                  $this->item->old_price ? $this->item->old_price : 0,
                                  $this->item->description,
                                  $this->item->eng_description,
                                  $this->item->body,
                                  $this->item->eng_body,
                                  $this->item->size,
                                  $this->item->text_sizes,
                                  $this->item->eng_text_sizes,
                                  $this->item->uhod,
                                  $this->item->eng_uhod,
                                  $this->item->quantity,
                                  $this->item->enabled,
                                  $this->item->meta_title,
                                  $this->item->meta_keywords,
                                  $this->item->meta_description,
                                  $this->item->s_material,
                                  $this->item->fitting,
                                  $this->item->stretch
                                      );
				$this->db->query($query);
  			    $this->item->product_id = $this->db->insert_id();
  		    	$query = sql_placeholder('UPDATE products SET order_num=product_id WHERE product_id=?', $this->item->product_id);
  			    $this->db->query($query);

          if ($_POST['eng_description'] || $_POST['eng_body'] || $_POST['eng_text_sizes'] || $_POST['eng_uhod']) {
            if ($_POST['eng_description']) $types[] = 'eng_description';
            if ($_POST['eng_body']) $types[] = 'eng_body';
            if ($_POST['eng_text_sizes']) $types[] = 'eng_text_sizes';
            if ($_POST['eng_uhod']) $types[] = 'eng_uhod';
            foreach($types as $type){
              $this->db->query("INSERT INTO eng_text_upload(`product_id`,`type`,`group`,`date`) VALUES({$product->product_id},'{$type}','product',NOW())");
            }
          }

                ### Save product to session
                $_SESSION['last_added_product'] = $this->item;
  			}
  			else {
 				if (empty($this->error_msg)) {

					//Копирайтер
					if ($is_copywriter) {
						$product_old = $this->get_product($this->item->product_id);
						$this->process_copywriter_tasks( 'product', $this->item->product_id, $this->item, $product_old );
					}
					//Копирайтер (The End)
					$product = $this->db->result("SELECT * FROM products WHERE product_id = {$this->item->product_id}");
					//Дата добавления текста описания и ID редактора
					if ($_POST['description'] && $_POST['description'] != $product->description) {
						$query = sql_placeholder('UPDATE products SET desc_date = NOW(), editor_id = ? WHERE product_id=?', $_SESSION['user']->user_id, $this->item->product_id);
						$this->db->query($query);
						$this->ping('/products/' . $this->item->url . '/');
					}
					if(($product->old_price == 0 && $this->item->old_price != 0 && ($this->item->price + 500) < $this->item->old_price) || ($product->old_price != 0 && ($this->item->price + 500) < $product->price)){
						// Отправляем в слак
						if ($product->old_price == 0){
							$message = "Пользователь {$_SESSION['user']->name} изменил цену товара #<https://lsboutique.ru/admin/index.php?section=Product&item_id={$product->product_id}|{$product->model}> с {$this->item->old_price}р на {$this->item->price}р";
						}
						else{
							$message = "Пользователь {$_SESSION['user']->name} изменил цену товара #<https://lsboutique.ru/admin/index.php?section=Product&item_id={$product->product_id}|{$product->model}> с {$product->price}р на {$this->item->price}р";
						}
						$args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "sale_items" );
						Job::push('SlackJob', $args);
					}

          // Если цена была изменена вручную
          if ($product->price != $this->item->price) {
            $this->db->query("INSERT INTO price_changes(`product_id`, `old_price`, `new_price`, `date`, `user_id`) VALUES({$product->product_id}, {$product->price}, {$this->item->price}, NOW(), {$_SESSION['user']->user_id});");
            $message = "Пользователь {$_SESSION['user']->name} изменил цену товара #<https://lsboutique.ru/admin/index.php?section=Product&item_id={$product->product_id}|{$product->model}> с {$product->price}р на {$this->item->price}р";
            $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "sale_items" );
            Job::push( 'SlackJob', $args );
          }

          // Если сезон был изменен вручную
          // сохраняем этот сезон при импорте
          if ($product->season != $this->item->season) {
            $this->db->query("UPDATE products SET preserve_season = 1 WHERE product_id = {$this->item->product_id};");
          }

          if (($_POST['eng_description'] && empty($product->eng_description)) || ($_POST['eng_body'] && empty($product->eng_body)) || ($_POST['eng_text_sizes'] && empty($product->eng_text_sizes)) || ($_POST['eng_uhod'] && empty($product->eng_uhod))) {
            if ($_POST['eng_description'] && empty($product->eng_description)) $types[] = 'eng_description';
            if ($_POST['eng_body'] && empty($product->eng_body)) $types[] = 'eng_body';
            if ($_POST['eng_text_sizes'] && empty($product->eng_text_sizes)) $types[] = 'eng_text_sizes';
            if ($_POST['eng_uhod'] && empty($product->eng_uhod)) $types[] = 'eng_uhod';
            foreach($types as $type){
              $check = $this->db->result("SELECT * FROM eng_text_upload WHERE product_id = {$product->product_id} AND type = '{$type}' AND `group` = 'product'");
              if(empty($check)) $this->db->query($sql="INSERT INTO eng_text_upload (`product_id`,`type`,`group`,`date`) VALUES({$product->product_id},'{$type}','product',NOW())");
            }
          }
					$query = sql_placeholder('UPDATE products SET url=?, sex=?, category_id=?, brand_id=?, color_id=?, model=?, model_full=?, sku=?, video=?, vimeo=?, vimeo_w=?, tsum_url=?, price=?, old_price=?, description=?, eng_description=?, body=?, eng_body=?, season=?, text_sizes=?, eng_text_sizes=?, uhod=?, eng_uhod=?, quantity=?, enabled=?, meta_title=?, meta_keywords=?, meta_description=?, modified=now(), s_material=?, no_discount=?, show_out_of_stock=?, fitting=?, stretch=? WHERE product_id=?',
                        $this->item->url,
                        isset($_POST['sex']) ? (int)$_POST['sex'] : 0,
                        $this->item->category_id,
                        $this->item->brand_id,
                        $this->item->color_id,
                        $this->item->model,
                        $this->item->model_full,
                        $this->item->sku,
                        $this->item->video,
                        $this->item->vimeo,
                        $this->item->vimeo_w,
                        $this->item->tsum_url,
                        $this->item->price,
                        $this->item->old_price ? $this->item->old_price : 0,
                        $this->item->description,
                        $this->item->eng_description,
                        $this->item->body,
                        $this->item->eng_body,
                        $this->item->season,
                        $this->item->text_sizes,
                        $this->item->eng_text_sizes,
                        $this->item->uhod,
                        $this->item->eng_uhod,
                        $this->item->quantity,
                        $this->item->enabled,
                        $this->item->meta_title,
                        $this->item->meta_keywords,
                        $this->item->meta_description,
                        $this->item->s_material,
                        $this->item->no_discount,
                        $this->item->show_out_of_stock,
                        $this->item->fitting,
                        $this->item->stretch,
                        $this->item->product_id);
					$this->db->query($query);
				}
  			}

			$this->db->query("UPDATE products SET url=product_id WHERE url=''");

      // Update Trello card if exists
      if ($product->trello_card) {
        Job::push('ProductToTrelloJob', ['product_id' => $product->product_id]);
      }

			## Если нужно, удаляем фотографии товара

      if(isset($_POST['delete_promo_image']) && $_POST['delete_promo_image']==1) {
				$this->delete_promo_image($this->item->product_id);
			}

      // Промо-лук
      if (isset($_FILES['promo_image']) && !empty($_FILES['promo_image']['tmp_name'])) {
        $path_parts = pathinfo($_FILES['promo_image']['name']);
        $uploadfile = $this->item->product_id . "_promo_image_". time() . "." . strtolower($path_parts['extension']);

        $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/products/' . $uploadfile;

        if (!move_uploaded_file($_FILES['promo_image']['tmp_name'], $full_path)) {
          $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
        }
        else {
          @chmod($full_path, 0644);
          $this->db->query($sql = "UPDATE products SET promo_image='{$uploadfile}' WHERE product_id='{$this->item->product_id}'");
          Job::push('S3UploadJob', ['remote_path' => 'files/products/'.$uploadfile, 'local_path' => $full_path]);
          Job::push('PromoImageToTrelloJob', [$this->item->product_id]);
        }
      }

            // Связанные товары
            $query = sql_placeholder('DELETE from related_products WHERE product_id=?', $this->item->product_id);
            $this->db->query($query);

            $related_products = split(',', $this->item->related);
            foreach($related_products as $related_url) {
                $related_url = trim($related_url);
                // существует ли такой товар?
                if (!empty($related_url)) {
                    $prod = $this->db->result(sql_placeholder('SELECT product_id FROM products WHERE product_id=? OR url=? LIMIT 1',$related_url,$related_url));
                    if(!empty($prod) && $this->item->product_id != $prod->product_id) {
                        $query = sql_placeholder('INSERT INTO related_products VALUES (?, ?)', $this->item->product_id, $prod->product_id);
                        $this->db->query($query);
                    }
                }
            }

            // Дополнительные категории
            $query = sql_placeholder('DELETE from products_categories WHERE product_id=?', $this->item->product_id);
            $this->db->query($query);

            if ($_POST['use_additional_categories'])
            foreach($this->item->categories as $additional_category_id) {
                $additional_category_id = intval($additional_category_id);
                // существует ли такой товар?
                if(!empty($additional_category_id)) {
                    $query = sql_placeholder('INSERT INTO products_categories VALUES (?, ?)', $this->item->product_id, $additional_category_id);
                    $this->db->query($query);
                }
            }



            // Характеристики товара
            $query = sql_placeholder('DELETE from properties_values WHERE product_id=?', $this->item->product_id);
            $this->db->query($query);

            $category_properties = $this->db->results(sql_placeholder("SELECT * FROM properties"));

            foreach($category_properties as $property) {
                if(isset($_POST[properties][$property->property_id]) && $_POST[properties][$property->property_id] != '') {
                    $query = sql_placeholder('INSERT INTO properties_values VALUES (?, ?, ?)', $this->item->product_id, $property->property_id, $_POST[properties][$property->property_id]);
                    $this->db->query($query);
                }
            }

            if (empty($this->error_msg)) {
                if($fotos_added ||  $download_added) {
                    $get = $this->form_get(array('section'=>'Product', 'item_id'=>$this->item->product_id, 'from'=>$this->param('from'), 'token'=>$this->token));
                    header("Location: index.php$get");
                }
                elseif(isset($_GET['from'])) {
                    header("Location: ".$this->param('from'));
                }
                else {
                    $get = $this->form_get(array('section'=>'Storefront', 'page'=>$this->param('page'), 'category'=>$this->param('category'), 'brand_id'=>$this->param('brand_id')));
                    header("Location: index.php$get");
                }
            }

        }
    }
    elseif(isset($_SESSION['last_added_product']) && $_SESSION['last_added_product']->category_id == $this->item->category_id && $_SESSION['last_added_product']->brand == $this->item->brand && !$this->item->product_id) {
       $this->item = $_SESSION['last_added_product'];
       unset($this->item->product_id);
    }
  }

  function fetch() {
    if (isset($_GET['query'])) {
        $result = array('query' => $_GET['query']);
        $search = addslashes(str_replace('*', '%', $_GET['query']));
        $query = "SELECT *, color.name as color
                    FROM products
                    LEFT JOIN brands ON products.brand_id = brands.brand_id
                    LEFT JOIN color ON products.color_id = colors.color_id
                WHERE products.model LIKE '%{$search}%' OR brands.name LIKE '%{$search}%'";
        $this->db->query($query);
        $properties = $this->db->results();

        $suggestions = array();
        $data        = array();
        if (is_array($properties) && count($properties)) {
            foreach ($properties as $property) {
                $suggestions[] = $property->model . ' ' . $property->name . ' ' . $property->color;
                $data[]        = $property->product_id;
            }
        }
        $result['suggestions'] = $suggestions;
        $result['data']        = $data;

        echo json_encode($result);
        die();
    }
    if ($this->item->product_id && !$_POST) {
      $this->title = $this->lang->EDIT_PRODUCT.' &laquo;'.$this->item->brand.' '.$this->item->model.'&raquo;';
    }
    else {
      $this->title = $this->lang->NEW_PRODUCT;
    }


    $category_id = $this->param('category');
    if(empty($category_id)) $category_id = $this->item->category_id;
    $category = $this->db->result("SELECT * FROM categories WHERE category_id = {$category_id}");
    $categories = Storefront::get_categories(0, ['canonical' => true]);

    $this->item->super_price = $this->db->result("SELECT super_price FROM products WHERE product_id = {$this->item->product_id}")->super_price;

    $this->db->query("SELECT * FROM brands  ORDER BY name");
    $brands = $this->db->results();

    $this->db->query("SELECT * FROM colors ORDER BY name");
    $colors = $this->db->results();

    $query = sql_placeholder("SELECT properties.*, properties_values.value as value FROM properties
                              LEFT JOIN properties_values ON properties_values.product_id = ? AND properties_values.property_id = properties.property_id
                              WHERE properties.enabled
                              ORDER BY properties.order_num",
                              $this->item->product_id);
    $properties = $this->db->results($query);

    if($properties)
    foreach($properties as $k=>$property) {
      $query = sql_placeholder("SELECT properties_categories.category_id FROM properties_categories WHERE property_id=?", $property->property_id);
      $this->db->query($query);
      $property_categories = $this->db->results();
      $properties[$k]->categories = $property_categories;

      if(!empty($property->options))
          $properties[$k]->options = unserialize($property->options);
    }

    $s_materials = $this->db->results("SELECT * FROM s_materials ORDER BY name");
    if ($s_materials) {
      $mat = $this->db->results("SELECT * FROM s_materials sm LEFT JOIN products_materials pm ON pm.material_id = sm.material_id WHERE pm.product_id = {$this->item->product_id} ");
      $item_materials = array();
      foreach ($mat as $m) {
          $item_materials[] = $m->material_id;
      }
    }

    // Размеры в наличии на складах
    $items = $this->db->results("SELECT i.*, wh.name as warehouse_name, COUNT(i.size) as quantity
        FROM items i
        LEFT JOIN warehouses wh ON i.warehouse_id = wh.warehouse_id
        WHERE i.quantity != 0 AND i.product_id = {$this->item->product_id}
        GROUP BY i.size
        ORDER BY FIELD(i.size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+'), size + 0 ASC");
    $this->smarty->assign('items', $items);

    foreach($items as $i){
      $p_sizes[] = $i->size_id;
    }
    $size_type = $items[0]->size_type;

    $price_changes = $this->db->results("SELECT pc.*, u.name AS username FROM price_changes pc LEFT JOIN users u ON pc.user_id = u.user_id WHERE product_id = {$this->item->product_id} ORDER BY 'date' DESC");
    $product_views = $this->db->results($sql="SELECT pv.*, GROUP_CONCAT(s.ru_size) AS ru_size, GROUP_CONCAT(s.int_size) AS int_size, GROUP_CONCAT(us.size_id) AS sizes, u.name, u.user_id
                                      FROM product_views pv
                                      LEFT JOIN users u ON u.user_id = pv.user_id
                                      LEFT JOIN users2sizes_n us ON u.user_id = us.user_id
                                      LEFT JOIN sizes s ON s.size_id = us.size_id AND us.type_id = '{$size_type}'
                                      WHERE pv.product_id = {$this->item->product_id} AND u.group_id = 1 AND pv.user_id IS NOT NULL GROUP BY pv.id ORDER BY pv.date DESC");

    foreach($product_views as $pv){
      $pv->sizes = explode(',',$pv->sizes);
      if(array_intersect($p_sizes, $pv->sizes)) $pv->available = true;
    }

    $import_data = $this->db->result("SELECT * FROM product_import_data WHERE product_id = {$this->item->product_id}");
    $import_data->parsed_data = json_decode($import_data->data, true);
    $this->smarty->assign('ImportData', $import_data);

    $this->smarty->assign('orders', $this->db->results("SELECT * FROM orders WHERE status IN (0,1) ORDER BY order_id DESC"));
    $this->smarty->assign('fittings', $this->db->results("SELECT * FROM fitting WHERE 1"));
    $this->smarty->assign('materials', $this->db->results("SELECT * FROM materials_stretch WHERE 1"));

    $this->smarty->assign('Categories', $categories);
    $this->smarty->assign('Category', $category);
    $this->smarty->assign('Properties', $properties);
    $this->smarty->assign('Brands', $brands);
    $this->smarty->assign('Colors', $colors);
    $this->smarty->assign('S_materials', $s_materials);
    $this->smarty->assign('item_materials', $item_materials);
    $this->smarty->assign('price_changes', $price_changes);
    $this->smarty->assign('product_views', $product_views);
    $this->smarty->assign('Item', $this->item);
    $this->smarty->assign('Error', $this->error_msg);
    $this->smarty->assign('MaxImageSize', $this->max_image_size*1024);
    $this->smarty->assign('Lang', $this->lang);
    $this->smarty->assign('FotosNum', $this->fotos_num);
    $this->body = $this->smarty->fetch('product.tpl');
  }
}
