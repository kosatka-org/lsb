<?PHP
require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class Material extends Widget
{

	var $uploaddir = '../files/materials/';
	var $copywriter_fields = array('text');
	
	function Material(&$parent)
	{
		Widget::Widget($parent);
	}
	
	function fetch()
	{
	
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
			$material = $this->db->result(sql_placeholder('SELECT * FROM `s_materials` WHERE material_id=? LIMIT 1', $id));
			
			if (!$material) return false;
			
			if ($is_copywriter) {
				$this->prepare_copywriter_tasks( 's_materials', $id );
			}
		}
		
		if (isset($_POST['name'])) {
			$material->name 				= strip_tags($_POST['name']);
			$material->eng_name 				= strip_tags($_POST['eng_name']);
			$material->description 			= strip_tags($_POST['description']);
			$material->aliases				= strip_tags($_POST['aliases']);
			
			
			//проверки
			
			if (empty($material->name)) 	$this->error_msg .= '<li>Введите название</li>';
			
			// проверки (END)
			
			if (empty($this->error_msg)) {
				if (!empty($id)) {
					//Копирайтер
					if ($is_copywriter) {
						$good_old = $this->db->result(sql_placeholder('SELECT * FROM `s_materials` WHERE material_id=? LIMIT 1', $id));
						$this->process_copywriter_tasks( 's_materials', $id, $good, $good_old );
					}
					//Копирайтер (The End)
				
					//Удаляем картинку
					if ($_POST['delete_image']==1) {
						$file = $this->uploaddir.$material->image;
						if (is_file($file)) unlink($file);
						$material->image = '';
					}

					$query = sql_placeholder("UPDATE s_materials SET ?% WHERE material_id=?", (array)$material, $id);
					$this->db->query($query);
				}else{
					//Вставляем запись
					$query = sql_placeholder("INSERT INTO s_materials SET ?%", (array)$material); 
					$this->db->query($query);
					$id = $this->db->insert_id();
					$material = $this->db->result(sql_placeholder('SELECT * FROM `s_materials` WHERE material_id=? LIMIT 1', $id));
				}
				
				//Грузим картинку
				$uploadfile = $id.".jpg";
				
				if (isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
					if(move_uploaded_file($_FILES['image']['tmp_name'], $this->uploaddir.$uploadfile))
					{
						@chmod($this->uploaddir.$uploadfile, 0644); 
						$query = sql_placeholder("UPDATE s_materials SET `image`=? WHERE material_id=?", $uploadfile, $id);
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
							$query = sql_placeholder("UPDATE s_materials SET `image`=? WHERE material_id=?", $uploadfile, $id);
							$this->db->query($query);       
						}
					}     	         
				}				
				
				$get = $this->form_get(array('section'=>'Materials'));
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
		$this->smarty->assign('material', $material);
	
		$this->title = 'Эксклюзивные материалы';
		$this->body = $this->smarty->fetch('material.tpl');
	}

}