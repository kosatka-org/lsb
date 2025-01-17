<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('../placeholder.php');
require_once('StorefrontGeneral.admin.php');

############################################
# General class for storefront
############################################

class StorefrontGeneral extends Widget
{
  var $items_per_page = 10; # Количество товаров на странице
  var $uploaddir = '../files/products/'; # Папка для хранения картинок к товарам
  var $downloadsdir = '../files/downloads/'; # Папка для хранения файлов к цифровым товарам
  var $accepted_file_types = array('image/pjpeg', 'image/gif', 'image/jpeg', 'image/jpg', 'image/png');
  var $max_image_size = 4000; # Максимальный размер картинки
  var $fotos_num = 10; #Количество дополнительных изображения товара

  function StorefrontGeneral(&$parent)
  {
	parent::Widget($parent);
  }

  function get_product($id, $code = null)  # Возвращает товар из базы
  {
      $code = (int) $code;
      if ($code > 0) {
        $id = $this->db->result("SELECT products.product_id FROM products WHERE code = {$code}")->product_id;
      }
      # Берем из базы товар
  	  $query = sql_placeholder('SELECT products.*, brands.name as brand, categories.type_id as category_type, categories.name as category_name, categories.single_name as category_single_name FROM products LEFT JOIN brands ON products.brand_id=brands.brand_id LEFT JOIN categories ON products.category_id=categories.category_id WHERE products.product_id=?', $id);
  	  $this->db->query($query);
 	  $product = $this->db->result();

      # Берем из базы картинки к товару
      $query = sql_placeholder("SELECT * FROM products_fotos WHERE product_id=?", $id);
      $this->db->query($query);
      $fotos = $this->db->results();
      $product->fotos = array();

      # Нам нужны только имена файлов для товара
      if(!empty($fotos))
        foreach($fotos as $key=>$foto)
        {
          $product->fotos[$foto->foto_id] = $foto->filename;
        }

      # Связанные товары
      $product->related=array();
      $query=sql_placeholder("SELECT * FROM related_products WHERE product_id=?", $id);
      $this->db->query($query);
      $related = $this->db->results();
      if(!empty($related))
        foreach($related as $r)
      	$product->related[]=$r->related_sku;

      # Берем из базы дополнительные категории
      $product->additional_categories=array();
      $query=sql_placeholder("SELECT * FROM products_categories WHERE product_id=?", $id);
      $this->db->query($query);
      $add_cats = $this->db->results();
      foreach($add_cats as $cat)
      	$product->additional_categories[]=$cat->category_id;


      return $product;
  }

  function get_product_by_code($code) {
    return $this->get_product(0, $code);
  }

  function delete_promo_image($product_id) # Удаляем большую картинку товара
  {
        # Берем из базы товар, походу вычисляя количество товаров, использующих эту же картинку
        $query = "SELECT p1.*, count(*) as count FROM products p1, products p2 WHERE p1.promo_image = p2.promo_image AND p1.promo_image!='' AND p1.product_id = '$product_id' GROUP BY p1.promo_image";
        $this->db->query($query);
        $product = $this->db->result();
        if(!empty($product->promo_image))
        {
          $file = $this->uploaddir.$product->promo_image;

          # Если только этот товар использует этот файл картинки, удаляем файл
        if($product->count<=1 && is_file($file))
          unlink($file);
      }

        # И удаляем из товара картинку
        $this->db->query("UPDATE products SET promo_image='' WHERE product_id=$product_id");
  }

  function add_fotos($product_id)
  {
     $result = false;
     return $result;
  }


	// Функция возвращает подкатегории
	function categories_tree($categories)
	{
		$tree = array();

		// Указатели на узлы дерева
		$used_items = array();

		$end = false;

		// Не кончаем, пока не кончатся категории, или пока ниодну из оставшихся некуда приткнуть
		while(!empty($categories) && !$end)
		{
			foreach($categories as $k=>$category)
			{
				$flag = false;
				if($category->parent == 0)
				{
					// Добавляем элемент в дерево
					$cat = null;
					$cat->name = $category->name;
					$cat->category_id = $category->category_id;
					$cat->url = $category->url;
					$category->path[0] = $cat;

					$tree[$category->category_id] = $category;
					$used_items[$category->category_id] = &$tree[$category->category_id];
					unset($categories[$k]);
					$flag = true;
				}else
				{
					if($used_items[$category->parent])
					{
						$cat = null;
						$cat->name = $category->name;
						$cat->category_id = $category->category_id;
						$cat->url = $category->url;

						$category->path = $used_items[$category->parent]->path;
						$category->path[] = $cat;


						$used_items[$category->parent]->subcategories[$category->category_id] = $category;
						$used_items[$category->category_id] = &$used_items[$category->parent]->subcategories[$category->category_id];
						unset($categories[$k]);
						$flag = true;
					}
				}
			}
			if(!$flag)
				$end = true;
		}

		$used_items = array_reverse($used_items, true);
		foreach($used_items as $k=>$item)
		{
			$used_items[$item->category_id]->subcats_ids[] = $item->category_id;
			if(is_array($used_items[$item->parent]->subcats_ids))
				$used_items[$item->parent]->subcats_ids =  array_merge($used_items[$item->parent]->subcats_ids, $item->subcats_ids);
			else
				$used_items[$item->parent]->subcats_ids = $item->subcats_ids;
		}
		return $tree;
	}



	// Функция возвращает рекурсивно подкатегории
	function category_by_id($categories, $id) {
		foreach($categories as $category) {
			if($category->category_id == $id) {
			return $category;
			}
			elseif(is_array($category->subcategories) && $result =  StorefrontGeneral::category_by_id($category->subcategories, $id)) {
				return $result;
			}
		}
		return false;
	}



  // Функция возвращает категории товаров, и их подкатегории
  function get_categories($parent=0, $params = array()) {
		$where = '1';
		if ( isset($params['with_seo']) ) {
			$where .= " AND categories.seo_words <> '' ";
		}

    if ( isset($params['canonical']) ) {
			$where .= " AND categories.canonical_id IS NULL ";
		}
    else {
      $where .= " AND categories.canonical_id IS NOT NULL ";
    }

		// Выбираем все категории
		$temp_categories = $this->db->results("SELECT categories.*, canonical.name AS canonical_name FROM categories LEFT JOIN categories canonical ON canonical.category_id = categories.canonical_id WHERE {$where} ORDER BY categories.name");

    return $temp_categories;
    // if ( isset($params['canonical']) ) {
    // }
		// return StorefrontGeneral::categories_tree($temp_categories);
  }
}
