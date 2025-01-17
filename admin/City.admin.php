<?PHP
require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class City extends Widget
{

	var $uploaddir = '../files/cities/';
	var $copywriter_fields = array('text', 'text2');

	function City(&$parent) {
		Widget::Widget($parent);
	}



	function fetch() {

        if (isset($_GET['delete_comment_id']) && isset($_GET['city_id'])) {
            $city_id = (int) $_GET['city_id'];
            $delete_comment_id  = (int) $_GET['delete_comment_id'];
            $this->db->query("DELETE FROM city_comments WHERE id = {$delete_comment_id} AND city_id = {$city_id}");

            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }

		//Инициализируем копирайтера
		$this->copywriters = new copywriters();
		$is_copywriter = $this->copywriters->get_copywriter($_SESSION['user']->user_id) ? true : false;
		$this->smarty->assign('is_copywriter', $is_copywriter);

		if (!empty($_GET['id'])) {
			$id = $_GET['id'];
		}
		elseif (!empty($_POST['id'])) {
			$id = $_POST['id'];
		}
		$id = intval($id);

		if (!empty($id)) {
			$city = $this->db->result(sql_placeholder('SELECT * FROM `cities` WHERE id=? LIMIT 1', $id));
			if (empty($city)) return false;

			if ($is_copywriter) {
				$this->prepare_copywriter_tasks( 'city', $id );
			}
		}

		if (isset($_POST['name'])) {
			$city->visible 				= intval($_POST['visible']);
			$city->city_id 				= $_POST['city_id'];
			$city->delivery_methods		= implode(',', (array)$_POST['delivery_methods']);
			$city->payment_methods 		= implode(',', (array)$_POST['payment_methods']);
			$city->name 				= $_POST['name'];
			$city->map_url 				= $_POST['map_url'];
			$city->url 					= $_POST['url'];
			$city->meta_title 			= $_POST['meta_title'];
			$city->meta_keywords 		= strip_tags($_POST['meta_keywords']);
			$city->meta_description 	= strip_tags($_POST['meta_description']);
			$city->text 				= strip_custom_tags($_POST['text']);
			$city->text2 				= strip_custom_tags($_POST['text2']);
			$city->editor_id 			= $_SESSION['user']->user_id;
			$city->lastmod 				= date('Y-m-d H:i:s');

			if(!empty($_POST['comment'])){
				$comment = $_POST['comment'];
                $this->db->query("INSERT INTO city_comments (city_id, commenter_id, text, date) VALUES ({$city->city_id}, {$_SESSION['user']->user_id}, '{$comment}', NOW())");
			}

			foreach ($_POST['delivery_prices'] as $dm_id => $city_price) {
				$this->db->query("INSERT INTO delivery_prices VALUES (NULL, {$dm_id}, {$id}, {$city_price}) ON DUPLICATE KEY UPDATE price = {$city_price}");
			}

			//проверки
			$is_exist_url = false;
			if(!empty($city->url)){
				$query 	= sql_placeholder('SELECT `id` FROM `cities` WHERE url=? LIMIT 1', $city->url);
				$this->db->query($query);
				$_is_exist_url = $this->db->result();
				$_is_exist_url = $_is_exist_url->id;
				if(!empty($_is_exist_url) AND $_is_exist_url != $id) $is_exist_url = true;
			}

			if (empty($city->name))	$this->error_msg .= '<li>Введите заголовок</li>';
			if (empty($city->url))	$this->error_msg .= '<li>Введите URL</li>';
			if ($is_exist_url)		$this->error_msg .= '<li>URL уже занят</li>';
			// проверки (END)

			if (empty($this->error_msg)) {
				if (!empty($id)) {
					//Копирайтер
					if ($is_copywriter) {
						$city_old = $this->db->result(sql_placeholder('SELECT * FROM `cities` WHERE id=? LIMIT 1', $id));
						//$this->process_copywriter_tasks( 'city', $id, $city, $city_old );
					}
					//Копирайтер (The End)

					//Удаляем картинку
					if($_POST['delete_image']==1){
						$file = $this->uploaddir.$city->image;
						if (is_file($file)) unlink($file);
						$city->image = '';
					}
					if($_POST['delete_image_right']==1){
						$file = $this->uploaddir.$city->image_right;
						if (is_file($file)) unlink($file);
						$city->image_right = '';
					}
					$this->db->query(sql_placeholder("UPDATE cities SET ?% WHERE id=?", (array)$city, $id));
				}
				else {
					//Вставляем запись
					$query = sql_placeholder("INSERT INTO cities SET ?%", (array)$city);
					$this->db->query($query);
					$id = $this->db->insert_id();
					$query = sql_placeholder("UPDATE cities SET `position` = `id` WHERE id=?",  $id);
					$this->db->query($query);
					$city = $this->db->result(sql_placeholder('SELECT * FROM cities WHERE id=? LIMIT 1', $id));
				}

				//Грузим картинку
				$uploadfile = $id.".jpg";
				if(isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
					if(move_uploaded_file($_FILES['image']['tmp_name'], $this->uploaddir.$uploadfile)) {
						@chmod($this->uploaddir.$uploadfile, 0644);
						$query = sql_placeholder("UPDATE cities SET image=? WHERE id=?", $uploadfile, $id);
						$this->db->query($query);
					}
				}
				elseif(isset($_POST['image_url'])) {
					$image_url = trim($_POST['image_url']);
					if (preg_match("/^http:\/\/.+(\.jpg|\.jpeg)/i", $image_url)) {
						$image_content = @file_get_contents($image_url);
						if (!empty($image_content)) {
							$image_file = fopen($this->uploaddir.$uploadfile, 'wb');
							fwrite($image_file, $image_content);
							fclose($image_file);
							$query = sql_placeholder("UPDATE cities SET `image`=? WHERE id=?", $uploadfile, $id);
							$this->db->query($query);
						}
					}
				}
				//Грузим картинку
				$uploadfile = $id."_right.jpg";
				if(isset($_FILES['image_right']) && !empty($_FILES['image_right']['tmp_name'])) {
					if(move_uploaded_file($_FILES['image_right']['tmp_name'], $this->uploaddir.$uploadfile)) {
						@chmod($this->uploaddir.$uploadfile, 0644);
						$query = sql_placeholder("UPDATE cities SET image_right=? WHERE id=?", $uploadfile, $id);
						$this->db->query($query);
					}
				}
				elseif(isset($_POST['image_url_right'])) {
					$image_url = trim($_POST['image_url_right']);
					if (preg_match("/^http:\/\/.+(\.jpg|\.jpeg)/i", $image_url)) {
						$image_content = @file_get_contents($image_url);
						if (!empty($image_content)) {
							$image_file = fopen($this->uploaddir.$uploadfile, 'wb');
							fwrite($image_file, $image_content);
							fclose($image_file);
							$query = sql_placeholder("UPDATE cities SET `image_right`=? WHERE id=?", $uploadfile, $id);
							$this->db->query($query);
						}
					}
				}
				//

				$get = $this->form_get(array('section'=>'Cities'));
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

		if (!empty($city->delivery_methods)) {
			$city->delivery_methods = explode(',', $city->delivery_methods);
		}
		if (!empty($city->payment_methods)) {
			$city->payment_methods = explode(',', $city->payment_methods);
		}
		$this->smarty->assign('city', $city);

		$comments = $this->db->results("SELECT city_comments.*, users.name
            FROM city_comments
            LEFT JOIN users ON city_comments.commenter_id = users.user_id
            WHERE city_comments.city_id = {$city->city_id}");

		//Достаем данные и кидаем в шаблон
		$delivery_methods	= $this->db->results("SELECT dm.*, dp.price as city_price FROM delivery_methods dm LEFT JOIN delivery_prices dp ON dp.delivery_method_id = dm.delivery_method_id AND dp.city_id = {$city->id} ORDER BY dm.delivery_method_id");
		$payment_methods	= $this->db->results("SELECT payment_methods.* FROM payment_methods ORDER BY payment_methods.payment_method_id");
		$delivery_cities	= $this->db->results("SELECT delivery_cities.* FROM delivery_cities ORDER BY delivery_cities.city_name");
		$this->smarty->assign('delivery_methods',	$delivery_methods);
        $this->smarty->assign('comments', $comments);
		$this->smarty->assign('payment_methods',	$payment_methods);
		$this->smarty->assign('delivery_cities',	$delivery_cities);

		$this->title = "Города";
		$this->body = $this->smarty->fetch('city.tpl');
	}
}
