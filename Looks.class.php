<?php
require_once('Widget.class.php');

class Looks extends Widget
{
    function Looks(&$parent)
    {
        Widget::Widget($parent);
    }

    function fetch() {
        $brand_id = (int)$this->url_filtered_param('brand');
        $special_url = $this->url_filtered_param('special_url');
        $mw = $_GET['sex'] ? (int)$this->url_filtered_param('sex') : $_COOKIE['sex'];
        $offset = (int)$this->url_filtered_param('offset');
        $lim = (int)$this->url_filtered_param('limit');

        if($this->settings->theme == 'api'){
            $filters_only   = isset($_GET['filters_only']) ? true : false;
            $fisizes        = $_GET['sizes'] ? preg_split("/,(?!5)/", $_GET['sizes']) : '';
            $fisize_ids     = !empty($_GET['size_ids'])  ? explode(',', $_GET['size_ids']) : '';
            $fibrands       = $_GET['brands'] ? explode(',', $_GET['brands']) : '';
            $ficats         = $_GET['cats'] ? explode(',', $_GET['cats']) : '';
            if(isset($_GET['special'])){
              $special = (int)$_GET['special'];
              $special_fields = $this->db->result("SELECT * FROM specials WHERE special_id = '{$special}' LIMIT 1");
              $special_url = $special_fields->url;
            }
        }

        if ($_POST['json']) {
            $json_obj = json_decode($_POST['json']);
                if ($json_obj->brand_id) {
                $brand_id = (int)$json_obj->brand_id;
            }
            if ($json_obj->special_url) {
                $special_url = $json_obj->special_url;
            }
            if ($json_obj->offset) {
                $offset = (int)$json_obj->offset;
            }
            if ($json_obj->sex) {
                $mw = (int)$json_obj->sex;
            }
        }

        $filter_url = array();
        $limit   = $where_brands = $where_sizes = $where_cats = "";
        // только товары в наличии
        $where = " AND products.size <> '' ";
        $where .= " AND products.enabled=1 ";

        // только с фотографией
        $where .= " AND products.large_image <> '' ";

        $order_by = "id DESC";

        if (!empty($special_url)) {
            $special = $this->db->result(sql_placeholder("SELECT * FROM specials WHERE url = ?", $special_url));
            $mw = $special->gender;
            $sp_urls = str_replace("/", "", $special->urls);
            $sp_filter = " AND id IN ({$sp_urls}) ";
            $order_by = " FIELD (id, {$sp_urls}) ASC";
            if($_COOKIE['language'] === 'eng'){$this->smarty->assign('header', $special->eng_name);}
            else{$this->smarty->assign('header', $special->name);}
            $this->smarty->assign('description', $special->description);
        }
        if($_COOKIE['language'] === 'eng' && empty($special_url)){
          $this->smarty->assign('header', 'Total looks from the stylist of Luxury Store');
        }

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

        if (!empty($brand_id)) {
            $where .= " AND products.brand_id = {$brand_id} ";
            $brand = $this->db->result("SELECT * FROM brands WHERE brand_id = {$brand_id}");
        }

        if ( !isset($_COOKIE['sex']) ) {
            $this->smarty->assign('need_select_sex', true);
        }

        // показывать скрытые бренды только избранным
        if ($this->settings->theme == 'discount') {
            $where .= " AND brands.visibility < 4 ";
        }
        else {
            if ($this->settings->theme == 'api'){$s_user_id = $_GET['user_id'];}
            else {$s_user_id = $_SESSION['user']->user_id;}
            $brands_str = implode(",", luser::visible_brands($s_user_id));
            $where .= " AND products.brand_id IN ({$brands_str}) ";
        }

        //ajax where
        if ( $_SERVER['REQUEST_METHOD'] === 'POST' ) {
            if (isset($json_obj->brands) && count($json_obj->brands)>0) {
                $where_brands .= " AND products.brand_id IN (".implode(",", $json_obj->brands).") ";
            }
            if (isset($json_obj->categories) && count($json_obj->categories)>0) {
                $where_cats .= " AND products.category_id IN (".implode(",", $json_obj->categories).") ";
            }
            $sizes_array = array();
            if (isset($json_obj->csizes) && count($json_obj->csizes)>0) {
                $sizes_array = array_merge($sizes_array, $json_obj->csizes);
            }
            if (isset($json_obj->fsizes) && count($json_obj->fsizes)>0) {
                $sizes_array = array_merge($sizes_array, $json_obj->fsizes);
            }
            if (count($sizes_array) > 0) {
                $where_sizes .= " AND items.size_id IN ('".implode("','", $sizes_array)."') ";
            }
        }
        //end of ajax where

        //Фильтры для API
        if($this->settings->theme == 'api'){
            if ( !empty($fibrands)) {
                $where_brands = " AND products.brand_id IN (".implode(",", $fibrands).") ";
            }
            if ( !empty($fisizes)) {
                $where_sizes = " AND items.normal_size IN ('".implode("','", $fisizes)."') ";
            }
            if ( !empty($fisize_ids)) {
                $where_sizes = " AND items.size_id IN ('" . implode("','", $fisize_ids) . "') ";
            }
            if ( !empty($ficats)) {
                $where_cats = " AND products.category_id IN (".implode(",", $ficats).") ";
            }
        }

        // определить размеры для чекбокса
        $query = "SELECT size_names.size AS size, items.size_id, items.normal_size, categories.parent AS parent, products.category_id AS category_id 
          FROM (SELECT main_product_id as product_id FROM sets
                  UNION ALL
                SELECT product_id FROM sets_products) as SS
          LEFT JOIN items ON items.product_id = SS.product_id
          LEFT JOIN size_names ON items.size_id = size_names.size_id AND size_m_s = 'Европа (EU)'
          LEFT JOIN products ON SS.product_id = products.product_id
          LEFT JOIN categories ON categories.category_id = products.category_id
          WHERE 1 AND items.normal_size <> '' {$where} {$where_cats} {$where_brands}
          GROUP BY size
          ORDER BY FIELD(items.normal_size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL', '5XL+', '6XL'), normal_size ASC";
        $sizes = $this->db->results($query);

        // определить категории для чекбокса
        $scope = ($_SERVER['REQUEST_METHOD'] === 'POST' || $this->settings->theme == 'api') ? $where.$where_sizes.$where_brands.$where_materials : $where.$where_sizes.$where_brands.$where_cats.$where_materials;
        $name = 'categories.name AS name';
        if($_COOKIE['language'] == 'eng'){$name = 'categories.eng_name AS name';}
        $query = "SELECT products.category_id AS id, {$name}, categories.url AS url, categories.prod_count_m AS prod_count_m, categories.prod_count_w AS prod_count_w
                    FROM (SELECT main_product_id as product_id, id FROM sets
                      UNION ALL
                    SELECT product_id, set_id AS id FROM sets_products) as SS
                    LEFT JOIN products ON SS.product_id = products.product_id
                    LEFT JOIN brands ON brands.brand_id = products.brand_id
                    LEFT JOIN items ON items.product_id = products.product_id
                    LEFT JOIN categories ON categories.category_id = products.category_id
                    WHERE 1 {$scope} AND EXISTS (SELECT 1 FROM sets_products WHERE sets_products.set_id = SS.id) GROUP BY products.category_id ORDER BY name ASC";
        $this->db->query($query);
        $categories = $this->db->results();
        foreach($categories as $cat)if($cat->id == 97 && $mw == 1 && $_COOKIE['language'] == 'eng'){$cat->name = 'Oxford shoes';}

        // определить бренды для чекбокса
        $scope = ($_SERVER['REQUEST_METHOD'] === 'POST' || $this->settings->theme == 'api') ? $where.$where_sizes.$where_cats.$where_materials : $where.$where_sizes.$where_brands.$where_cats.$where_materials;
        $query = "SELECT products.brand_id AS id, brands.name AS name
                    FROM sets
                    LEFT JOIN products ON sets.main_product_id = products.product_id
                    LEFT JOIN categories ON categories.category_id = products.category_id
                    LEFT JOIN brands ON brands.brand_id = products.brand_id
                    LEFT JOIN items ON items.product_id = products.product_id
                    WHERE 1 {$scope}
                    GROUP BY products.brand_id ORDER BY name ASC";
        $brands = $this->db->results($query);

        $filtersizes = array("clothes" => array(), "footwear" => array());
        $filtersizes_api_old = array("clothes" => array(), "footwear" => array());
        foreach ($sizes as $value) {
            if ($value->parent == 1 && !empty($value->size)) {
                if($this->settings->theme == 'api') array_push($filtersizes_api_old['clothes'], $value->normal_size);
                unset($value->parent,$value->category_id,$value->normal_size);
                array_push($filtersizes['clothes'], $value);
            }
            elseif (($value->parent == 2 || $value->category_id == 2) && $value->size != 0) {
                if($this->settings->theme == 'api') array_push($filtersizes_api_old['footwear'], $value->normal_size);
                unset($value->parent,$value->category_id,$value->normal_size);
                array_push($filtersizes['footwear'], $value);
            }
        }

        if(!($this->settings->theme == 'api' && $filters_only === true)){
            $where = $where . $where_sizes . $where_cats . $where_brands;

            $filter = " AND (sets.main_product_id IN (SELECT products.product_id
                            FROM products
                            LEFT JOIN items ON items.product_id = products.product_id
                            LEFT JOIN brands ON brands.brand_id = products.brand_id
                            WHERE 1 {$where}) 
                            OR 
                            sp.product_id IN (SELECT products.product_id
                            FROM products
                            LEFT JOIN items ON items.product_id = products.product_id
                            LEFT JOIN brands ON brands.brand_id = products.brand_id
                            WHERE 1 {$where})) {$sp_filter} ";

            $rowcount = $this->db->result("SELECT COUNT(*) AS rowcount FROM sets WHERE image != '' {$filter} AND EXISTS (SELECT 1 FROM sets_products WHERE sets_products.set_id = sets.id)")->rowcount;
            if ($this->settings->theme == 'api') {
              if (empty($lim)) $lim = $offset ? 60 : 120;
              $limit = $offset ? "{$offset},{$lim}" : "{$lim}";
            }
            else $limit = $offset ? "{$offset},60" : "120";
            
            $sets = $this->db->results($sql="SELECT * 
                  FROM sets 
                  LEFT JOIN sets_products sp ON sp.set_id = sets.id
                  WHERE image != '' 
                  {$filter} 
                  AND EXISTS (SELECT 1 FROM sets_products WHERE sets_products.set_id = sets.id) GROUP BY sets.id ORDER BY {$order_by} LIMIT {$limit}");

            if ( (isset($json_obj->categories) && count($json_obj->categories) > 0) || (isset($json_obj->csizes) && count($json_obj->csizes) > 0) || (isset($json_obj->fsizes) && count($json_obj->fsizes) > 0) ) {
                $listbrands = Array();
                foreach ($brands as $br) {
                    $listbrands[] = "{$br->id}";
                }
                $listbrands = json_encode($listbrands);
            }
            else {
                $listbrands = null;
            }

            if ( (isset($json_obj->brands) && count($json_obj->brands) > 0) || (isset($json_obj->csizes) && count($json_obj->csizes) > 0) || (isset($json_obj->fsizes) && count($json_obj->fsizes) > 0) ) {
                $listcateg = Array();
                foreach ($categories as $ctg) {
                    $listcateg[] = "{$ctg->id}";
                }
                $listcateg = json_encode($listcateg);
            }
            else {
                $listcateg = null;
            }

            if (!isset($json_obj->sizes) || count($json_obj->sizes) == 0) {
                $listsizes = Array();
                foreach ($sizes as $szs) {
                    $listsizes[] = "{$szs->size_id}";
                }
                $listsizes = json_encode($listsizes);
            }
            else {
                $listsizes = null;
            }


            $image_link = 'https://lsboutique.ru';
            if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
            foreach ($sets as $index => $set) {
                $products = array();
                $main_product = $this->db->result("SELECT p.*, c.eng_name AS eng_cat, c.eng_single_name AS cat_eng_name, b.name AS brand_name FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN brands b ON p.brand_id = b.brand_id WHERE p.product_id = {$set->main_product_id}");
                $products[] = $main_product;
                $other_products = $this->db->results("SELECT p.*, sp.*, c.eng_name AS eng_cat, c.eng_single_name AS cat_eng_name, b.name AS brand_name FROM products p LEFT JOIN sets_products sp ON p.product_id = sp.product_id LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN brands b ON p.brand_id = b.brand_id WHERE sp.set_id = {$set->id}");
                $products = array_merge($products, $other_products);
                if($_COOKIE['language'] === 'eng'){
                  foreach($products as $k=>$p){
                    if($p->category_id == 97 && $mw == 1){$p->cat_eng_name = 'Oxford shoes';}
                    $products[$k]->model = $p->cat_eng_name . ' ' . $p->brand_name;
                  }
                }
                if ($this->settings->theme == 'api') {
                    $set->image_small  = $image_link . '/reimg/files/products/340x/'.$set->image;
                    $set->image_medium = $image_link . '/reimg/files/products/560x/'.$set->image;
                    $set->image_full   = $image_link . '/reimg/files/products/560x/'.$set->image;
                    if($_COOKIE['language'] === 'eng'){
                      $set->name = $main_product->cat_eng_name .' '. $main_product->brand_name .' - '.$main_product->sku;
                    }
                    unset($set->image);
                    foreach ($products as $product) {
                        $product->size = str_replace("|", ", ", trim($product->size, "|"));
                        $user = new luser( !empty($_GET['user_id']) ? $_GET['user_id'] : 0 );
                        $product->prices = $user->product_prices_for_api($product, $_GET['currency']);
                        if($_COOKIE['language'] === 'eng'){
                          $set->name = $main_product->cat_eng_name .' '. $main_product->brand_name .' - '.$main_product->sku;
                          $item->category_name = $item->cat_eng_name;
                          $item->category = $item->eng_cat;
                          $product->description = $product->body = $product->size = $product->seo_words = $product->text_sizes = $product->size = $product->uhod = '';
                        }
                        else{
                          $product->description = strip_tags(str_replace('</p>', '\n ', $product->description));
                          $product->body = strip_tags(str_replace('</p>', '\n ', $product->body));
                          $product->size = strip_tags(str_replace('</p>', '\n ', $product->size));
                          $product->seo_words = strip_tags(str_replace('</p>', '\n ', $product->seo_words));
                          $product->text_sizes = strip_tags(str_replace('</p>', '\n ', $product->text_sizes));
                          $product->uhod = strip_tags(str_replace('</p>', '\n ', $product->uhod));
                        }
                        if ( !empty($big_size) && $product->bsize_small_image != '' ) {
                            $product->small_image_small = $image_link . '/reimg/files/products/340x/'.$product->bsize_small_image;
                            $product->small_image_medium = $image_link . '/reimg/files/products/560x/'.$product->bsize_small_image;
                            $product->small_image_full = $image_link . '/reimg/files/products/560x/'.$product->bsize_small_image;
                        }
                        else{
                            $product->small_image_small = $image_link . '/reimg/files/products/340x/'.$product->small_image;
                            $product->small_image_medium = $image_link . '/reimg/files/products/560x/'.$product->small_image;
                            $product->small_image_full = $image_link . '/reimg/files/products/560x/'.$product->small_image;
                        }
                        if ( !empty($big_size) && $product->bsize_large_image != '' ){
                            $product->large_image_small = $image_link . '/reimg/files/products/340x/'.$product->bsize_large_image;
                            $product->large_image_medium = $image_link . '/reimg/files/products/560x/'.$product->bsize_large_image;
                            $product->large_image_full = $image_link . '/reimg/files/products/560x/'.$product->bsize_large_image;
                        }
                        else{
                            $product->large_image_small = $image_link . '/reimg/files/products/340x/'.$product->large_image;
                            $product->large_image_medium = $image_link . '/reimg/files/products/560x/'.$product->large_image;
                            $product->large_image_full = $image_link . '/reimg/files/products/560x/'.$product->large_image;
                        }
                        unset($product->url,$product->old_url,$product->tsum_url,$product->guarantee,$product->seo_words,$product->quantity,$product->sold,
                        $product->hit,$product->order_num,$product->download,$product->meta_title,$product->meta_keywords,$product->meta_description,
                        $product->created,$product->new_stuff,$product->modified,$product->sold_date,$product->desc_date,$product->editor_id,
                        $product->last_price_update,$product->pack_id,$product->photo_added,$product->prop_val,$product->tsum_price,$product->discount_value,
                        $product->second_image,$product->week,$product->show_price,$product->enabled,$product->small_image,$product->large_image,
                        $product->bsize_small_image,$product->bsize_large_image,$product->text_sizes,$product->seo_words,$product->body,$product->description,
                        $product->uhod,$product->code,$product->category_id,$product->brand_id,$product->color_id,$product->sku,$product->old_price,$product->offline_price,
                        $product->sex,$product->season,$product->item_location,$product->s_material,$product->special_sale,$product->super_price,$product->no_discount,
                        $product->fur_sale,$product->eng_text_sizes,$product->eng_uhod,$product->eng_body,$product->eng_description,$product->trello_card,$product->video_added,
                        $product->sizes_max_count,$product->col_code,$product->coll_active,$product->cat_enabled,$product->video);
                    }
                }
                $sets[$index]->products = $products;
            }
        }
        if ($this->settings->theme == 'api') {
            foreach ($categories as $category){
                unset($category->url,$category->prod_count_m,$category->prod_count_w);
            }

            if($filters_only === false)$return->sets = $sets;
            $return->sizes = $filtersizes_api_old;
            $return->size_ids = $filtersizes;
            $return->brands = $brands;
            $return->categories = $categories;
            if($this->settings->theme_v == 'v2'){
              $return = $this->format_api_response($return);
            }
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
            die();
        }

        if($_COOKIE['language'] === 'eng'){$title = "Total looks gallery | Luxury Store";}
        else{$title = "Галерея образов | бутик Лакшери Стор";}

        $this->smarty->assign('listcateg', $listcateg);
        $this->smarty->assign('listbrands',   $listbrands);
        $this->smarty->assign('listsizes',   $listsizes);

        $this->smarty->assign('filtercategories', $categories);
        $this->smarty->assign('filterbrands',   $brands);
        $this->smarty->assign('filtersizes',   $filtersizes);

        $this->smarty->assign('brand',       $brand);
        $this->smarty->assign('special_url', $special_url);
        $this->smarty->assign('rowcount',    $rowcount);
        $this->smarty->assign('looks',       $sets);
        $this->smarty->assign('manOrWoman',  $mw);
        $this->smarty->assign('title',       $title);
        $this->smarty->assign('filter_url',  "/index.php?module=Looks");
        if ($_POST['json']) {
            echo ($this->smarty->fetch('looks_block.tpl'));
            exit();
        }
        $this->body = $this->smarty->fetch('looks.tpl');
        return $this->body;
    }
}
