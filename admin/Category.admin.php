<?php
require_once('Widget.admin.php');
require_once('Storefront.admin.php');


############################################
# Class Category - Edit the good gategory
############################################
class Category extends Widget {
	var $category;
	var $max_level = 5;
	var $uploaddir = '../files/categories/';

	var $copywriter_fields = array('description', 'mens_description', 'womens_description');


	function Category(&$parent) {
		Widget::Widget($parent);
		$this->add_param('parent');
		$this->prepare();
	}



	function prepare() {
		$this->copywriters 	= new copywriters();
		$is_copywriter 		= $this->copywriters->get_copywriter($_SESSION['user']->user_id) ? true : false;
		$this->smarty->assign('is_copywriter', $is_copywriter);

		$this->category->category_id = $this->param('item_id');
		$this->category->enabled=1;

		if ($this->category->category_id) {
			$this->category = $this->db->result(sql_placeholder('SELECT * FROM categories WHERE category_id=?', $this->category->category_id));
			$this->category->weight *= 1;
			if ( $is_copywriter && !empty($this->category->category_id) ) {
				$this->prepare_copywriter_tasks( 'category', $this->category->category_id );
			}
		}

		if (isset($_POST['name'])) {
			$this->category->name 				= strip_tags($_POST['name']);
			$this->category->single_name 		= strip_tags($_POST['single_name']);
			$this->category->eng_name 				= strip_tags($_POST['eng_name']);
			$this->category->eng_single_name 		= strip_tags($_POST['eng_single_name']);
			$this->category->meta_title 		= strip_tags($_POST['meta_title']);
			$this->category->meta_keywords 		= strip_tags($_POST['meta_keywords']);
			$this->category->meta_description 	= strip_tags($_POST['meta_description']);
			$this->category->gender           	= isset($_POST['sex']) ? (int)$_POST['sex'] : 0;
			$this->category->description    	= strip_custom_tags($_POST['description']);
			$this->category->mens_description   = strip_custom_tags($_POST['mens_description']);
			$this->category->womens_description = strip_custom_tags($_POST['womens_description']);
			$this->category->weight 			= $_POST['weight'];
			$this->category->url 				= strip_tags($_POST['url']);
			$this->category->enabled 			= 0;
			$this->category->parent 			= (int)$_POST['parent'];
			$this->category->type_id 			= (int)$_POST['type_id'];
			$this->category->mens_size_type_id 			= (int)$_POST['mens_size_type_id'];
			$this->category->womens_size_type_id 			= (int)$_POST['womens_size_type_id'];
			if ( isset($_POST['enabled']) ) {
				$this->category->enabled = 1;
			}

			$canonical_id = intval($_POST['canonical']);
			if ( $canonical_id > 0 ) {
				$this->db->query("UPDATE categories SET canonical_id = {$canonical_id} WHERE category_id = {$this->category->category_id}");
			}
			else {
				$this->db->query("UPDATE categories SET canonical_id = NULL WHERE category_id = {$this->category->category_id}");
			}

			$category_id = $this->category->category_id;

			if (empty($this->category->name)) {
				$this->error_msg = $this->lang->ENTER_NAME;
			}
			elseif (!empty($this->category->category_id)) {
				if (empty($this->category->url)) {
					$this->category->url = $category_id;
				}

				//����������
				if ( $is_copywriter && !empty($this->category->category_id) ) {
					$category_old = $this->db->result(sql_placeholder('SELECT * FROM categories WHERE category_id=?', $this->category->category_id));
					$this->process_copywriter_tasks( 'category', $this->category->category_id, $this->category, $category_old );
				}
				//���������� (The End)

				$query = sql_placeholder('UPDATE categories
										SET name=?, single_name=?, eng_name=?, eng_single_name=?, meta_title=?, meta_keywords=?, meta_description=?, description=?,
										mens_description=?, womens_description=?, weight=?, url=?, gender=?, enabled=?, parent=?, type_id=?,
										mens_size_type_id=?, womens_size_type_id=?
										WHERE category_id=?',
										$this->category->name,
										$this->category->single_name,
										$this->category->eng_name,
										$this->category->eng_single_name,
										$this->category->meta_title,
										$this->category->meta_keywords,
										$this->category->meta_description,
										$this->category->description,
										$this->category->mens_description,
										$this->category->womens_description,
										$this->category->weight,
										$this->category->url,
										$this->category->gender,
										$this->category->enabled,
										$this->category->parent,
										$this->category->type_id,
										$this->category->mens_size_type_id,
										$this->category->womens_size_type_id,
										$this->category->category_id);
				$this->db->query($query);
			}
			else {
				$query = sql_placeholder('INSERT INTO categories (parent, type_id, name, single_name, meta_title, meta_keywords, meta_description, description, mens_description, womens_description, weight, url, gender, enabled) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
										$this->category->parent,
										$this->category->type_id,
										$this->category->name,
										$this->category->single_name,
										$this->category->meta_title,
										$this->category->meta_keywords,
										$this->category->meta_description,
										$this->category->description,
										$this->category->mens_description,
										$this->category->womens_description,
										$this->category->weight,
										$this->category->url,
										$this->category->gender,
										$this->category->enabled );
				$this->db->query($query);
				$category_id = $last_insert_id = $this->db->insert_id();
				if (empty($this->category->url)) {
					$this->category->url = $category_id;
				}
				$this->db->query(sql_placeholder('UPDATE categories SET order_num=category_id, url=? WHERE category_id=?', $this->category->url, $last_insert_id ));
			}
			$this->ping('/categories/' . $this->category->url . '/');

			if (!empty($category_id) && isset($_POST['delete_image']) && $_POST['delete_image']==1) {
				$category 	= $this->db->result("SELECT * FROM categories WHERE category_id = '{$category_id}'");
				$file 		= $this->uploaddir.$category->image;
				if (is_file($file)) unlink($file);
				$this->db->query("UPDATE categories SET image='' WHERE category_id=$category_id");
			}

			if(!empty($category_id)) {
				$uploadfile = $category_id.".jpg";
				if(isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
					if (!move_uploaded_file($_FILES['image']['tmp_name'], $this->uploaddir.$uploadfile)) {
						$this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
					}
					else {
						@chmod($this->uploaddir.$uploadfile, 0644);
						$this->db->query("UPDATE categories SET image='{$uploadfile}' WHERE category_id='{$category_id}'");
					}
				}
				elseif (isset($_POST['image_url'])) {
					$image_url = trim($_POST['image_url']);
					if(preg_match("/^http:\/\/.+(\.jpg|\.jpeg)/i", $image_url)) {
						$image_content = @file_get_contents($image_url);
						if (!empty($image_content)) {
							$image_file = fopen($this->uploaddir.$uploadfile, 'wb');
							fwrite($image_file, $image_content);
							fclose($image_file);
							$this->db->query("UPDATE categories SET image='{$uploadfile}' WHERE category_id='{$category_id}'");
						}
					}
				}
			}

			if (empty($this->error_msg)) {
				$get = $this->form_get(array('section'=>'Categories'));
				if (isset($_GET['from'])) {
					header("Location: ".$_GET['from']);
				}
				else {
					header("Location: index.php$get");
				}
			}
		}
	}



	function fetch() {
		$categories = Storefront::get_categories();
		foreach ($categories as $k=>$v) {
			unset($categories[$k]->subcategories);
		}
		$this->title = !empty($this->category->category_id) ? $this->lang->EDIT_CATEGORY.' &laquo;'.$this->category->name.'&raquo;' : $this->lang->NEW_CATEGORY;
		$canonical_categories = $this->db->results("SELECT * FROM categories WHERE canonical_id IS NULL AND category_id != {$this->category->category_id} ORDER BY name");
		$root_categories = $this->db->results("SELECT * FROM categories WHERE parent = 0 ORDER BY name");

		$this->smarty->assign('size_types', $this->db->results("SELECT * FROM size_types"));
		$this->smarty->assign('Item', 		$this->category);
		$this->smarty->assign('weights', 	array(0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
		$this->smarty->assign('Categories', $categories);
		$this->smarty->assign('canonicalCategories', $canonical_categories);
		$this->smarty->assign('rootCategories', $root_categories);
		$this->smarty->assign('MaxLevel', 	$this->max_level);
		$this->smarty->assign('Lang', 		$this->lang);
		$this->smarty->assign('Error', 		$this->error_msg);
		$this->body = $this->smarty->fetch('category.tpl');
	}
}
