<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# Class Import
############################################
class Import extends Widget
{	
	var $csv_line_maxlength = 20000;	
	var $allowed_extensions = array('csv', 'txt');
	var $subcategory_delimiter = '/';
 
	var $products_added   = 0;
	var $products_updated = 0;
	var $only_update = false;

	function Import(&$parent)
	{
		parent::Widget($parent);
	}


	function fetch()
	{
		$this->title = $this->lang->PRODUCTS_IMPORT;

		if ( isset($_FILES['seo_rec']) && !empty($_FILES['seo_rec']['tmp_name']) && substr($_FILES['seo_rec']['name'], -3, 3) === "xls" ) {
			$path_parts = pathinfo($_FILES['seo_rec']['name']);
			if (!move_uploaded_file($_FILES['seo_rec']['tmp_name'], getcwd()."/../cron/rec.xls")) {
				$this->error_msg = $this->lang->FILE_UPLOAD_ERROR; 
			} 
			else {
				$cmd_output = exec("cd ../cron && /usr/local/bin/ruby seo_parse.rb rec.xls");
				if ($cmd_output === "OK") {
					$this->error_msg = 'Рекоммендации успешно загружены';
				}
				else {
					$this->error_msg = 'Не удалось загрузить рекоммендации';
				}
			}
		}

		if ( isset($_FILES['calls']) && !empty($_FILES['calls']['tmp_name']) && substr($_FILES['calls']['name'], -3, 3) === "csv" ) {
			$path_parts = pathinfo($_FILES['calls']['name']);
			if (!move_uploaded_file($_FILES['calls']['tmp_name'], getcwd()."/../cron/calls.csv")) {
				$this->error_msg = $this->lang->FILE_UPLOAD_ERROR; 
			} 
			else {
				$cmd_output = exec("cd ../cron && /usr/local/bin/ruby call_import.rb calls.csv");
				if ($cmd_output === "OK") {
					$this->error_msg = 'Звонки успешно загружены';
				}
				else {
					$this->error_msg = 'Не удалось загрузить звонки';
				}
			}
		}
	
		if ( isset($_GET['clear_size']) ) {
			$query = "UPDATE products SET size='';";
			$this->db->query($query);
			$this->error_msg = 'Наличие в базе очищено';
		}

		if ( isset($_GET['hide_without_pictures']) ) {
			$query = "UPDATE products SET enabled = 0 WHERE large_image = '' AND small_image = '' ;";
			$this->db->query($query);
			$this->error_msg = 'Товары без картинок скрыты';
		}
		
		if ( !empty($_FILES['file_u']['tmp_name']) ) {
			$_FILES['file'] = $_FILES['file_u'];
			$this->only_update = true;
		}
		if (isset($_POST['format']) && !empty($_POST['format']) && !empty($_FILES['file']['tmp_name']))
		{
		
			$format = $_POST['format'];
			$fname = $_FILES['file']['tmp_name'];
		  
			if(!in_array(end(explode(".", $_FILES['file']['name'])), $this->allowed_extensions))
			{
				$this->error_msg = 'Неподдерживаемый тип файла';
			}
			else
			{		  
				// Узнаем какая кодировка у файла
				$fh = fopen($fname, 'r');
				$teststring = fread($fh, 2048);
				fclose($fh);
		
				// Кодировки
				if (preg_match('//u', $teststring))
				{
					$charset = 'UTF8';
				}else
				{
					$charset = 'CP1251';
				}
		
				setlocale (LC_ALL, 'ru_RU.'.$charset);

				$this->db->query('SET NAMES '.$charset);
				$query = sql_placeholder('UPDATE settings SET value=? WHERE name="file_import_charset"', $charset);
				$this->db->query($query);
				   
				if($format == 'csv')
				{
					$csv_columns   = $_POST['csv_columns'];
					$csv_delimiter = $_POST['csv_delimiter'];
					$query = sql_placeholder('UPDATE settings SET value=? WHERE name="csv_import_columns"', $csv_columns);
					$this->db->query($query);
					$query = sql_placeholder('UPDATE settings SET value=? WHERE name="csv_import_delimiter"', $csv_delimiter);
					$this->db->query($query);
					$this->import_csv($fname, $csv_columns, $csv_delimiter);
				}

				$this->db->query('SET NAMES utf8');
				$query = 'UPDATE products SET order_num=product_id WHERE order_num=0';
				$this->db->query($query);
				$query = 'UPDATE products SET url=product_id WHERE url=""';
				$this->db->query($query);
				$query = 'UPDATE categories SET url=category_id WHERE url=""';
				$this->db->query($query);
				$query = 'UPDATE brands SET url=brand_id WHERE url=""';
				$this->db->query($query);


// Бренды
				$this->db->query("DELETE FROM products WHERE brand_id IN (95,97,78,85,74,94,23,24,62,91,72,81,27,28,29,31,33,35,15,36,76,18,37,38,64,87,60,41,82,42,93,43,84,44,19,45,46,20,79,47,48,49,50,88,83,40,65,51,52,96,61,56,57);");
				$this->db->query("UPDATE products SET brand_id = 11 WHERE brand_id = 89;");        
				$this->db->query("UPDATE products SET brand_id = 287 WHERE brand_id IN (308, 107, 92);");
				$this->db->query("UPDATE products SET brand_id = 63 WHERE brand_id IN (59, 101);");

//ALTER TABLE `brands` ADD `word` VARCHAR( 1 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL 
				$this->db->query("UPDATE `brands` SET word = UPPER( SUBSTRING( name, 1, 1 ) );");

//Категории

				$this->db->query("DELETE FROM products WHERE category_id IN (300, 292,291,229, 216, 217, 218, 196, 165, 134, 127);");

        //ботинки
				$this->db->query("UPDATE products SET category_id = 82 WHERE category_id IN (90,140,278);"); 
				//кроссовки       
				$this->db->query("UPDATE products SET category_id = 87 WHERE category_id IN (116, 141,277,367,380);");        
				//сапоги
				$this->db->query("UPDATE products SET category_id = 93 WHERE category_id IN (118, 119,289);");
				//тапки
				$this->db->query("UPDATE products SET category_id = 1175 WHERE category_id IN (8155);");
				//туфли
				$this->db->query("UPDATE products SET category_id = 97 WHERE category_id IN (156,185,290, 352, 358, 369);");
				//сланцы 
				$this->db->query("UPDATE products SET category_id = 107 WHERE category_id IN (199, 222, 343);");
				//босоножки
				$this->db->query("UPDATE products SET category_id = 109 WHERE category_id IN (206, 388);");
				//ботильоны
				$this->db->query("UPDATE products SET category_id = 178 WHERE category_id IN (112, 157, 184, 186, 243, 339, 356, 368);");
				//сандалии
				$this->db->query("UPDATE products SET category_id = 921 WHERE model LIKE 'Сандали%';");
				//мокасины
				$this->db->query("UPDATE products SET category_id = 392 WHERE category_id IN (182, 351, 357);");
				
				//носки
				$this->db->query("UPDATE products SET category_id = 129 WHERE category_id IN (212, 344);");
				//бабочки
				$this->db->query("UPDATE products SET category_id = 1177 WHERE category_id IN (1089,1103);");
				
				//юбка
				$this->db->query("UPDATE products SET category_id = 18 WHERE category_id IN (142);");
				//брюки
				$this->db->query("UPDATE products SET category_id = 22 WHERE category_id IN (79, 29, 213, 224, 170, 270, 161, 361, 2055, 245, 84, 463, 470);");
				//платье
				$this->db->query("UPDATE products SET category_id = 19 WHERE category_id IN (43, 230, 286);");
				//костюм
				$this->db->query("UPDATE products SET category_id = 23 WHERE category_id IN (128, 138, 74, 225, 316);");
				//куртка
				$this->db->query("UPDATE products p SET p.category_id = 478 WHERE p.model LIKE 'Куртк%'");
				//плащ
				$this->db->query("UPDATE products p SET p.category_id = 910 WHERE p.model LIKE 'Плащ%'");
				//пиджак
				$this->db->query("UPDATE products SET category_id = 57 WHERE category_id IN (16, 137, 159, 365, 246);");
				//пальто
				$this->db->query("UPDATE products SET category_id = 14 WHERE category_id IN (60, 139, 10, 11, 399, 75, 424, 59, 322, 323);");
				//полупальто
				$this->db->query("UPDATE products SET category_id = 918 WHERE category_id IN (8173);");
				//джинсы
				$this->db->query("UPDATE products SET category_id = 77 WHERE category_id IN (13, 267, 265, 294, 162);");
				$this->db->query("UPDATE products p LEFT JOIN categories c ON p.category_id = c.category_id SET p.category_id =77 WHERE c.name LIKE  'Джинсы%';");
				//футболки
        $this->db->query("UPDATE products SET category_id = 919 WHERE category_id IN (98, 88, 151, 71, 70, 172, 314, 231, 355, 385);");
				//рубашки
				$this->db->query("UPDATE products SET category_id = 479 WHERE category_id IN (81, 135, 27, 32, 179, 171, 248, 293);");
				$this->db->query("UPDATE products p LEFT JOIN categories c ON p.category_id = c.category_id SET p.category_id =479 WHERE c.name LIKE  'Рубашка%';");
				//блузка
				$this->db->query("UPDATE products SET category_id = 46 WHERE category_id IN (244, 271,315, 384, 268, 247, 1009);");
				//кофты и свитера
				$this->db->query("UPDATE products SET category_id = 20 WHERE category_id IN (52, 136, 150, 26, 24, 255, 275, 313, 283, 350, 40, 416, 360, 51, 985, 911, 876, 1031);");
				//шорты
				$this->db->query("UPDATE products SET category_id =101 WHERE category_id IN (175, 183, 341, 345, 434);");
				//плавки
				$this->db->query("UPDATE products SET category_id =105 WHERE category_id IN (402, 432, 450, 454, 8169);");
				//жакет
				$this->db->query("UPDATE products SET category_id = 15 WHERE category_id IN (21, 176, 226, 167, 426, 261, 8218);");
				//жилет
				$this->db->query("UPDATE products SET category_id = 1021 WHERE category_id IN (1172, 8209, 8212, 1088);");
				//пуловеры и кардиганы
				$this->db->query("UPDATE products SET category_id = 72 WHERE category_id IN (941, 913, 858, 868, 834, 826, 91, 363, 285, 376, 257, 338, 447, 41, 8168);");
				//поло
				$this->db->query("UPDATE products SET category_id = 89 WHERE category_id IN (181, 264, 455);");
				//шуба
				$this->db->query("UPDATE products p SET p.category_id = 923 WHERE p.model LIKE 'Шуба%'");
				//дубленка
				$this->db->query("UPDATE products p SET p.category_id = 892 WHERE p.model LIKE 'Дубленка%'");
				//Олимпийка
				$this->db->query("UPDATE products p SET p.category_id = 926 WHERE p.model LIKE 'Олимпийка%'");
				
				//обувь
				$this->db->query("UPDATE products SET category_id = 2 WHERE category_id IN (158, 407, 408, 414, 420, 429, 439, 445, 444, 457, 464, 471);");
				//аксессуары
				$this->db->query("UPDATE products SET category_id = 4 WHERE category_id IN (415, 76, 421, 452, 456, 468, 469, 472);");
				//повязка на голову
				$this->db->query("UPDATE products SET category_id = 8199 WHERE category_id IN (8200);");
				//платки
				$this->db->query("UPDATE products p LEFT JOIN categories c ON p.category_id = c.category_id SET p.category_id = 130 WHERE c.name LIKE  '%латок%';");
				//ремень
				$this->db->query("UPDATE products p LEFT JOIN categories c ON p.category_id = c.category_id SET p.category_id = 37 WHERE c.name LIKE  'Ремень%';");
				//чехол для айфона
				$this->db->query("UPDATE products SET category_id = 8215 WHERE category_id IN (1060, 8219, 1059, 1082);");
			}

			if($this->error_msg)
			{
				$this->smarty->assign('Error', $this->error_msg);
				$this->body = $this->smarty->fetch('import.tpl');
			}
			else
			{
				$this->smarty->assign('ProductsAdded', $this->products_added);
				$this->smarty->assign('ProductsUpdated', $this->products_updated);
				$this->body = $this->smarty->fetch('import_result.tpl');
			}

		}else
		{
			$this->smarty->assign('Lang', $this->lang);
			$this->smarty->assign('Error', $this->error_msg);
			$this->body = $this->smarty->fetch('import.tpl');
		}
	}
  
	//////////////////////
	//////////////////////  
	function process_category($name)
	{
		// Поле "категория" может состоять из нескольких имен, разделенных subcategory_delimiter-ом
		// Только неэкранированный subcategory_delimiter может разделять категории
		//$delimeter = $this->subcategory_delimiter;
		//$regex = "/\\DELIMETER((?:[^\\\\\DELIMETER]|\\\\.)*)/";
		//$regex = str_replace('DELIMETER', $delimeter, $regex);
		//$names = preg_split($regex, $name, 0, PREG_SPLIT_DELIM_CAPTURE);
		$result_category_id = 0;   
		$current_parent = 0; 
		
		//foreach($names as $name)
		//{
			//$name = trim(str_replace("\\$delimeter", $delimeter, $name));
			if(!empty($name))
			{
				$query = sql_placeholder("SELECT category_id FROM categories WHERE name=? LIMIT 1", $name);
				$this->db->query($query);
				$cat = $this->db->result();
						
				if(!empty($cat))
				{
					$result_category_id = $cat->category_id;
					$current_parent = $result_category_id;
				}
				else
				{
					$query = sql_placeholder("INSERT INTO categories(name, enabled) VALUES(?, 1)", $name, $current_parent);
					$this->db->query($query);
					$result_category_id = $this->db->insert_id();
					$current_parent = $result_category_id;		
				}
			}	
		//}
		return $result_category_id;
	}

	//////////////////////
	//////////////////////  
	function process_brand($name, $table='brands', $id='brand_id')
	{
		$name = trim($name);
		if(!empty($name))
		{
			$query = "SELECT * FROM {$table} WHERE name=\"{$name}\" LIMIT 1";
			$this->db->query($query);
			$exist_brand = $this->db->result();
			$brand_id = $exist_brand->{$id};
			if(!empty($brand_id))
				return $brand_id;
          
			$query = sql_placeholder("INSERT INTO {$table}(name) VALUES(?)", $name);
			$this->db->query($query);
			$brand_id = $this->db->insert_id();
/*			$this->brands[$k]->brand_id = $brand_id;
			$this->brands[$k]->name = $name;*/
			return $brand_id;
		}
		return 0;
	}

	//////////////////////
	//////////////////////  
	function process_product($params)
	{
    
    if(isset($params['code']))  $code = (int) $params['code']; else $code = '';
		if(isset($params['ctg']))  $category = trim($params['ctg']); else $category = '';
		if(isset($params['brnd'])) $brand = trim($params['brnd']); else $brand = '';
		if ($brand == 'VII') {
			$brand = 'ICEBERG';
		}
		if(isset($params['name'])) $model = trim($params['name']); else $model = '';
		if(isset($params['sku']))  $sku = trim($params['sku']); else $sku = '';
		if(isset($params['prc']))  $price = preg_replace ("/[^\.0-9]/", "", str_replace(',','.',$params['prc'])); else $price = '';
		if(isset($params['oprc'])) $old_price = str_replace(',','.',$params['oprc']); else $old_price = '';
		// Скидка 
		if( !empty($params['disc']) ) {
			$params['disc'] = preg_replace ("/[^\.0-9]/", "", str_replace(',','.', $params['disc']));
			$old_price = $price;
			$price = $old_price - $params['disc'];
		}
		if(isset($params['qty']))  $quantity = intval($params['qty']); else $quantity = '';
		if(isset($params['ann']))  $description = trim($params['ann']); else $description = '';
		if(isset($params['dsc']))  $body = trim($params['dsc']); else $body = '';
		if(isset($params['url']))  $url = trim($params['url']); else $url = str_replace(array(" ", "\"", "/"), '', trim($params['sku']));
		if(isset($params['mttl'])) $meta_title = trim($params['mttl']); else $meta_title = '';
		if(isset($params['mkwd'])) $meta_keywords = trim($params['mkwd']); else $meta_keywords = '';
		if(isset($params['mdsc'])) $meta_description = trim($params['mdsc']); else $meta_description = '';
		if(isset($params['enbld']))$enabled = trim($params['enbld']); else $enabled = '1';
		if(isset($params['hit']))  $hit = trim($params['hit']); else $hit = '';
		if(isset($params['simg'])) $small_image = trim($params['simg']); else $small_image = '';
		if(isset($params['limg'])) $large_image = trim($params['limg']); else $large_image = '';          
		if(isset($params['imgs'])) $images_string = trim($params['imgs']); else $images_string = '';
		if(isset($params['rel']))  $related = trim($params['rel']); else $related = '';
		if(isset($params['season']))  $season = trim($params['season']); else $season = '';
		if(isset($params['pack_id']))  $pack_id = trim($params['pack_id']); else $pack_id = '';
		
		$sex = !isset($params['sex']) ? 0 : ($params['sex'] == 'U' ? 1 : 2);
		//echo $sex . '<br>';
		
		//var_dump($params);die();

		$images = explode(',', $images_string);
		
		if (!empty($params['cat_brand_desc']) && empty($category) && !empty($brand)) {
			$tmp_brands = array(
				'Y-3' 				=> array('Y - 3', 'Y3', 'Y-3'),
				'RALPH LAUREN'      => array('Ralf Loren', 'Ralph Lauren'),
				'RALPH LAUREN USA'  => array('POLO RALPH LAUREN USA', 'RALPH LAUREN USA'),
				'Diego Mazzi'       => array('Diego Mazzi', 'Diego'),
				'Gallotti'          => array('Gallotti', 'Galotti'),
				'GF Ferre'			=> array('GF Ferre', 'FERRE'),
			);
			$tmp_brand = $brand;
			if (isset($tmp_brands[$brand])) {
				foreach ($tmp_brands[$brand] as $tmp_brand) {
				    if (stripos($params['cat_brand_desc'], $tmp_brand) !== false) {
						break;
					}
				}
			}
			$pos = stripos($params['cat_brand_desc'], $tmp_brand);
			
			//list($category, $body) = explode($tmp_brand, $params['cat_brand_desc']);
			$category = trim(substr($params['cat_brand_desc'], 0, $pos));
			$material = trim(substr($params['cat_brand_desc'], $pos+strlen($tmp_brand)));
			if (preg_match('/%/', $material)) {
			  $mat_matches=preg_split('/ /', $material);
			  $material="";
				  foreach ($mat_matches as $mat) {
            $piece=preg_split('/%/', $mat);
            if (count($piece)>1) {
              $material=$material.$piece[1]." ".$piece[0]."% ";
            }
            else
            {
              $material=$piece[0];
            }
          }
        }
			$model    = $category . ' ' . $brand;
		}



		if( !empty($sku) && isset($params['color']) ) { 
			$category_id = $this->process_category($category);
			$brand_id    = $this->process_brand($brand);
			
			if ($category_id == 0) {
			  var_dump($params);
			  die('stop');
			}
			
			$color_ids   = array();
			$colors      = explode(',', $params['color']);
			foreach ($colors as $color) {
				$params['color'] = trim($color);
				$color_id 		 = $this->process_brand($params['color'], 'colors', 'color_id');
				$color_ids[$color_id] = $color;

				$url 		.= '-' . $code;

				$sizes = array();
				if (!empty($params['size_color'])) {
				    //'M  Коричневый,XL  Коричневый,XXL  Коричневый';
					$params['size_color'] = str_replace('  ', ' ', $params['size_color']);
					$size_delim = !empty($_POST['size_delimiter']) ? $_POST['size_delimiter'] : ',';
					$sizes = explode($size_delim, $params['size_color']);
					foreach ($sizes as $k=>$v) {
						if (stripos($v, $params['color'])) {
							$sizes[$k] = trim(str_replace($params['color'], '', $sizes[$k]));
						} else {
							unset($sizes[$k]);
						}
					}
				}
/*				echo $params['size_color'] . '<br>';
				var_dump($sizes);
				die();*/

        
				if(!empty($code)) {
					$query = sql_placeholder('SELECT * FROM products WHERE code=? LIMIT 1', $code);
					$this->db->query($query);        
					$exist_prod = $this->db->result();
				}

			
/*			if(empty($sku) || !$exist_prod)
			{
				$query = sql_placeholder("SELECT * FROM products WHERE products.category_id=? AND products.model=? LIMIT 1", $category_id, $model);
				$this->db->query($query);        
				$exist_prod = $this->db->result();
			}*/
	 
				if(empty($exist_prod)) {             
					if ( !$this->only_update ) {
						$query = sql_placeholder('INSERT INTO products(url, code, category_id,  brand_id,  model, sku,   color_id, price,   old_price, description,  body,  season,  quantity, enabled, hit,  meta_title,  meta_keywords,  meta_description, small_image, large_image, created, modified, pack_id) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now(), ?)',
																	  $url, $code, $category_id, $brand_id, $model, $sku, $color_id, $price, $old_price, $description, $body, $season, $quantity, 0, $hit, $meta_title, $meta_keywords, $meta_description, $small_image, $large_image, $pack_id);

						$this->db->query($query);
						$product_id = $this->db->insert_id();
						$this->products_added++;

						if (!empty($params['country'])) {
							$country = mysql_real_escape_string(trim($params['country']));
							$query   = sql_placeholder('INSERT INTO properties_values(product_id, property_id,  value) VALUES(?, 1, ?)', $product_id, $country);
							$this->db->query($query);
						}
						
						if (!empty($material)) {
							$query = sql_placeholder('INSERT INTO properties_values(product_id, property_id,  value) VALUES(?, 3, ?)', $product_id, trim($material));
							$this->db->query($query);
						}
					}
				}
				else {
					$product_id = $exist_prod->product_id;
				}

				$query_set = '';
	//			if(!empty($category_id))   $query_set .= 'category_id="'.mysql_real_escape_string($category_id).'", ';
	//			if(!empty($url))		   $query_set .= 'url="'.mysql_real_escape_string($url).'", ';
	//			if(!empty($brand_id)) 	   $query_set .= 'brand_id="'.mysql_real_escape_string($brand_id).'", ';
	// 			if(!empty($model))         $query_set .= 'model="'.mysql_real_escape_string($model).'", ';
				if(!empty($sex))           $query_set .= 'sex="' . $sex . '", ';
				if (isset($params['prc']) && !empty($price))  $query_set .= 'price="'.mysql_real_escape_string($price).'", ';
				if ( count($sizes) ) {
					$tmp_size = isset($exist_prod->size) ? $exist_prod->size : '';
					foreach ($sizes as $size) {
						$tmp_size = str_replace("|$size|", '|', $tmp_size);
						$tmp_size.= !empty($tmp_size) ? "$size|" : "|$size|";
						//echo $tmp_size . '<br>';
					}
					$query_set .= 'size="' . $tmp_size . '", ';
				}

	//			if(isset($params['sku']))  $query_set .= 'sku="'.mysql_real_escape_string($sku).'", ';

				if(isset($params['qty']))  $query_set .= 'quantity="'		 .mysql_real_escape_string($quantity).'", ';
				if(isset($params['dsc']))  $query_set .= 'body="'			 .mysql_real_escape_string($body).'", ';
				if( !empty($old_price) )   $query_set .= 'old_price="'		 .mysql_real_escape_string($old_price).'", ';
				if(isset($params['ann']))  $query_set .= 'description="'	 .mysql_real_escape_string($description).'", ';
				if(isset($params['mttl'])) $query_set .= 'meta_title="'      .mysql_real_escape_string($meta_title).'", ';
				if(isset($params['mkwd'])) $query_set .= 'meta_keywords="'   .mysql_real_escape_string($meta_keywords).'", ';
				if(isset($params['mdsc'])) $query_set .= 'meta_description="'.mysql_real_escape_string($meta_description).'", ';
				if(isset($params['season']))$query_set .= 'season="'    	 .mysql_real_escape_string($season).'", ';
				if(isset($params['enbld']))$query_set .= 'enabled="'    	 .mysql_real_escape_string($enabled).'", ';
				if(isset($params['hit']))  $query_set .= 'hit="'        	 .mysql_real_escape_string($hit).'", ';
				if(isset($params['simg'])) $query_set .= 'small_image="'	 .mysql_real_escape_string($small_image).'", ';
				if(isset($params['limg'])) $query_set .= 'large_image="'	 .mysql_real_escape_string($large_image).'", ';					
					
				if (!empty($product_id) && !empty($price)) {
					$query = sql_placeholder("UPDATE products SET $query_set modified=now() WHERE product_id =?", $product_id);
					$this->db->query($query);
					$this->products_updated++;
				}
				
				if (!empty($material)) {
							$query = sql_placeholder('UPDATE properties_values SET value = ? WHERE product_id = ? AND property_id = 3', trim($material), $product_id);
							$this->db->query($query);
				}

				if (!empty($description)) {
					$copytask = $this->db->results("SELECT * FROM copywriters_tasks WHERE doc_type = 'product' AND doc_id = {$product_id}");
					if (empty($copytask)) {
						$this->db->query("INSERT INTO copywriters_tasks (doc_type, doc_id, field, text, copywriter_id, status, moderator_id) VALUES ('product', {$product_id}, 'description', \"{$description}\", 9028, 'accepted', 9028)");
					}
				}

				if (!empty($product_id) && !empty($images)) {
					$i = 0;
					foreach($images as $image) {
						$image=trim($image);
						if(!empty($image)) {
							$query = sql_placeholder('INSERT INTO products_fotos (product_id, foto_id, filename) VALUES(?, ?, ?)', $product_id, $i, trim($image));
							$this->db->query($query);
							$i++;
						}
					}
				}
			}
		}
		
		if ($_POST['desc'] && $_POST['desc'] == 'yes')
		{
		  if(!empty($params['url'])) 
		  {
          $query = sql_placeholder('SELECT * FROM products WHERE url=? LIMIT 1', $url);
					$this->db->query($query);        
					$exist_prod = $this->db->result();
					$query = sql_placeholder('SELECT * FROM related_products WHERE product_id=?', $exist_prod->product_id);
					$this->db->query($query);
					$exist_rel = $this->db->result();
			}
		  if(!empty($exist_prod)) 
		  {
		    $product_id = $exist_prod->product_id;
		    if (!empty($params['ann']) || !empty($params['dsc']))
		    {
		      $query_set = '';
		      if(!empty($params['ann']))  $query_set .= 'description="'	 .mysql_real_escape_string($description).'", ';
		      if(!empty($params['dsc']))  $query_set .= 'body="'			 .mysql_real_escape_string($body).'", ';
		      $query = sql_placeholder("UPDATE products SET $query_set modified=now() WHERE product_id =?", $product_id);
				  $this->db->query($query);
				  $this->products_updated++;
				}
		    if(!empty($params['rel']) && empty($exist_rel)) 
		    {
		      $related_products = explode(',', $related);
			    foreach($related_products as $rp)
		    	{
			    	$rp = trim($rp);
			    	if(!empty($rp))
		    		{
		    		  $query = sql_placeholder('SELECT product_id FROM products WHERE url=? LIMIT 1',$rp);
				      $this->db->query($query);
			    	  $prod = $this->db->result();
		    		  if(!empty($prod) && $product_id != $prod->product_id)
		    		  {
			    		  $query = sql_placeholder('INSERT INTO related_products VALUES (?, ?)',
			    					  $product_id, $prod->product_id);
		    			  $this->db->query($query);
		    		  }
		    		}
			    }
			  }
			}
	  }
		return false;
	}


	///////////////////////////////////////////
	///////////////////////////////////////////
	function import_csv($fname, $cols_order, $delimiter)
	{
		$this->db->query('SET NAMES utf8;');
		$handle = fopen($fname, "r");
		if(!$handle)
		{
			$this->error_msg = 'Не могу загрузить файл. Проверьте настройки сервера';
		}
		else
		{  
			// Максимальное время выполнения скрипта
			$max_time = @ini_get('max_execution_time');
			if(!$max_time)
				$max_time = 30;
			
			// Порядок колонок
			$temp = explode($delimiter, $cols_order);
			$i = 0;
			foreach($temp as $tmp)
			{
				$columns[trim($tmp)] = $i;
				$i++;
			}
			if(!(isset($columns['code'])))
			{
				$this->error_msg = 'Среди колонок должен присутствовать код товара';
				return false;
			}
       
			$start_time = microtime(true);
			$time_elapsed = 0;
			$cols = true;
        
			# Идем по всем строкам
			while (($raw_row=fgets($handle,20000)) && $exec_time_ok = $time_elapsed < $max_time-1)
      {
        $cols = explode($delimiter,$raw_row);
        foreach($columns as $name=>$index)
        {
                if(isset($cols[$index]))
                        $values[$name] = $cols[$index];
                else
                        $values[$name] = '';
        }
        if ($values['sku'] != 'Артикул' ) {
                $this->process_product($values);
        }
        $current_time = microtime(true);
        $time_elapsed = $current_time - $start_time;
      }
      fclose($handle);
		}
	}
}
