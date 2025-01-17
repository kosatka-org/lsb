<?PHP
require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class Good extends Widget {

	var $uploaddir = '../files/goods/';
	var $copywriter_fields = array('text');

	function Good(&$parent) {
		Widget::Widget($parent);
	}
	
	function fetch() {
		//Инициализируем копирайтера
		$this->copywriters = new copywriters();
		$is_copywriter = $this->copywriters->get_copywriter($_SESSION['user']->user_id) ? true : false;
		$this->smarty->assign('is_copywriter', $is_copywriter);
	
		if (!empty($_GET['id'])) {
			$id = $_GET['id'];
		}
		elseif(!empty($_POST['id'])) {
			$id = $_POST['id'];
		}
		$id = intval($id);	
			
		if (!empty($id)) {
			$good = $this->db->result(sql_placeholder('SELECT * FROM `goods` WHERE id=? LIMIT 1', $id));
			
			if (!$good) return false;
			
			if ($is_copywriter) {
				$this->prepare_copywriter_tasks( 'brand-category', $id );
			}
		}
		
		if (isset($_POST['title'])) {
			$good->visible 				= intval($_POST['visible']);
			$good->title 				= strip_tags($_POST['title']);
			$good->brand_id 			= (int)$_POST['brand_id'];
			$good->category_id 			= strip_tags($_POST['category_id']);
			$good->annotation			= strip_tags($_POST['annotation']);
			$good->url 					= strip_tags($_POST['url']);
			$good->meta_title 			= strip_tags($_POST['meta_title']);
			$good->meta_keywords 		= strip_tags($_POST['meta_keywords']);
			$good->meta_description 	= strip_tags($_POST['meta_description']);
			$good->text 				= strip_custom_tags($_POST['text']);
			$good->text_modified 		= date('Y-m-d h:i:s'); 
			$good->editor_id 			= $_SESSION['user']->user_id;
			
			foreach($_POST as $k=>$post){
				file_put_contents('qw_'.$k.'.txt', $post);
			}
			//проверки
			$is_exist = false;
			$_is_exist = $this->db->result(sql_placeholder('SELECT `id` FROM `goods` WHERE brand_id=? AND category_id=? LIMIT 1', $good->brand_id, $good->category_id));
			$_is_exist = $_is_exist->id;
			if(!empty($_is_exist) AND $_is_exist != $id) $is_exist = true;
			
			$is_exist_url = false;
			if (!empty($good->url)) {
				$_is_exist_url = $this->db->result(sql_placeholder('SELECT `id` FROM `goods` WHERE url=? LIMIT 1', $good->url));
				$_is_exist_url = $_is_exist_url->id;				
				if(!empty($_is_exist_url) AND $_is_exist_url != $id) $is_exist_url = true;				
			}
			
			if (empty($good->title)) 	$this->error_msg .= '<li>Введите заголовок</li>';
			if (empty($good->url)) 		$this->error_msg .= '<li>Введите URL</li>';
			if ($is_exist) 				$this->error_msg .= '<li>Бренд-категория уже существует</li>';
			if ($is_exist_url) 			$this->error_msg .= '<li>URL уже занят</li>';
			
			// проверки (END)
			if (empty($this->error_msg)) {
				if (!empty($id)) {
					//Копирайтер
					if ($is_copywriter) {
						$good_old = $this->db->result(sql_placeholder('SELECT * FROM `goods` WHERE id=? LIMIT 1', $id));
						$this->process_copywriter_tasks( 'brand-category', $id, $good, $good_old );
					}
					//Копирайтер (The End)
				
					//Удаляем картинку
					if ($_POST['delete_image']==1) {
						$file = $this->uploaddir.$good->image;
						if (is_file($file)) unlink($file);
						$good->image = '';
					}

					$query = sql_placeholder("UPDATE goods SET ?% WHERE id=?", (array)$good, $id);
					$this->db->query($query);
				}else{
					//Вставляем запись
					$query = sql_placeholder("INSERT INTO goods SET ?%", (array)$good); 
					$this->db->query($query);
					$id = $this->db->insert_id();
					$query = sql_placeholder("UPDATE goods SET `position` = `id` WHERE id=?",  $id);
					$this->db->query($query);
					$good = $this->db->result(sql_placeholder('SELECT * FROM `goods` WHERE id=? LIMIT 1', $id));
				}
				
				//Грузим картинку
				$uploadfile = $id.".jpg";
				
				if (isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
					if(move_uploaded_file($_FILES['image']['tmp_name'], $this->uploaddir.$uploadfile))
					{
						@chmod($this->uploaddir.$uploadfile, 0644); 
						$query = sql_placeholder("UPDATE goods SET `image`=? WHERE id=?", $uploadfile, $id);
						$this->db->query($query); 	       
					}
				}
				elseif(isset($_POST['image_url'])) {
					$image_url = trim($_POST['image_url']);
					if(preg_match("/^http:\/\/.+(\.jpg|\.jpeg)/i", $image_url)) {
						$image_content = @file_get_contents($image_url);
						if (!empty($image_content)) {
							$image_file = fopen($this->uploaddir.$uploadfile, 'wb');
							fwrite($image_file, $image_content);
							fclose($image_file);
							$query = sql_placeholder("UPDATE goods SET `image`=? WHERE id=?", $uploadfile, $id);
							$this->db->query($query);       
						}
					}     	         
				}				
				
				$get = $this->form_get(array('section'=>'Goods'));
			    if (isset($_GET['from'])) {
					header("Location: ".$_GET['from']);
				}
				else {
					header("Location: index.php$get");
				}
			}
			else {
				$this->smarty->assign('Error', $this->error_msg); 
			}
		}
		$this->smarty->assign('good', $good);

		//Достаем данные и кидаем в шаблон
		$categories = Storefront::get_categories();
		$brands 	= $this->db->results("SELECT * FROM brands ORDER BY name");
		$this->smarty->assign('Categories', $categories);
		$this->smarty->assign('Brands', $brands);
	
		$this->title	= "Бренд-категория";
		$this->body 	= $this->smarty->fetch('good.tpl');
	}
}