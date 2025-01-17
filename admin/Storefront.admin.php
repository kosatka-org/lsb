<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('../placeholder.php');
require_once('StorefrontGeneral.admin.php');

########################################
class Storefront extends StorefrontGeneral {
    var $pages_navigation; # Класс для постраничной навигации
    var $error = '';

    function Storefront(&$parent) {

        parent::StorefrontGeneral($parent);
        $this->add_param('page');
        $this->add_param('category');
        $this->add_param('brand_id');
        $this->add_param('seo_words');
        $this->add_param('no_description');
        $this->add_param('no_eng_description');
        $this->add_param('sort_by_views');
        if ($this->param('keyword')) {
            $this->add_param('keyword');
        }
        $this->pages_navigation = new PagesNavigation($this);
        $this->prepare();
    }


    function prepare() {
        $current_brand_id = $this->param('brand_id');

        # Удаление товара
        if((isset($_GET['act']) && $_GET['act']=='delete' && isset($_GET['item_id'])) || (isset($_POST['delete_items']))) {
            $this->check_token();

            $items = isset($_POST['delete_items'])?$_POST['delete_items']:null;
            if(isset($_GET['item_id']) && !empty($_GET['item_id']))
              $items = array($_GET['item_id']);

            $items_sql = implode("', '", $items);
            $query = "DELETE products, products_fotos, products_comments, related_products, products_categories, properties_values FROM products
                      LEFT JOIN products_fotos ON products.product_id = products_fotos.product_id
                      LEFT JOIN products_comments ON products_comments.product_id = products.product_id
                      LEFT JOIN related_products ON (products.product_id = related_products.product_id OR products.product_id = related_products.related_sku)
                      LEFT JOIN products_categories ON products_categories.product_id = products.product_id
                      LEFT JOIN properties_values ON products.product_id = properties_values.product_id
                      WHERE products.product_id IN ('$items_sql')";
            $this->db->query($query);
            $get = $this->form_get(array());
        }


        # Создание копии товара
        if (isset($_GET['action']) && $_GET['action']=='copy' && isset($_GET['item_id'])) {
            $this->check_token();

            $id = $_GET['item_id'];
            $this->db->query("CREATE TEMPORARY TABLE tmp SELECT * FROM products WHERE product_id={$id};");
            $new_id = $id + 9000000;
            $this->db->query("UPDATE tmp SET product_id = {$new_id};");
            $this->db->query("INSERT INTO products SELECT * FROM tmp;");
            $new_id = $this->db->insert_id();
            $query = sql_placeholder("UPDATE products SET order_num=?, url=product_id WHERE product_id=?", $id, $new_id);
            $this->db->query($query);
            $query = "INSERT INTO products_fotos (product_id, foto_id, filename, created, big_size, model_photo, cover_photo) SELECT $new_id, foto_id, filename, created, big_size, model_photo, cover_photo FROM products_fotos WHERE product_id=$id";
            $this->db->query($query);
            $query = "INSERT INTO properties_values (product_id, property_id, value) SELECT $new_id, property_id, value FROM properties_values WHERE product_id=$id";
            $this->db->query($query);
        }

        # Изменение цен товаров
        if(isset($_POST['prices'])) {
            $this->check_token();

            $prices = $_POST['prices'];
            foreach($prices as $id=>$price)
            {
                $quantity =  $_POST['quantities'][$id];
                $this->db->query("UPDATE products SET price='$price', quantity='$quantity' WHERE product_id='$id'");
            }
        }

        # Сделать товар видимым
        if(isset($_GET['set_enabled'])) {
          $this->check_token();

          $id = $_GET['set_enabled'];
          $query = sql_placeholder('UPDATE products SET enabled=1-enabled WHERE product_id=?',$id);
          $this->db->query($query );

          $get = $this->form_get(array());
          if(isset($_GET['from']))
            header("Location: ".$_GET['from']);
          else
            header("Location: index.php$get");
        }

        # Сдвинуть товар вверх
        if(isset($_GET['action']) and $_GET['action']=='move_up') {
            $this->check_token();

            $product_id = $_GET['item_id'];
            $this->db->query("SELECT @id:=s1.product_id
                              FROM products s1, products s2
                              WHERE s1.category_id=s2.category_id AND s1.order_num>s2.order_num
                              AND s2.product_id = '$product_id'
                              ORDER BY s1.order_num ASC
                              LIMIT 1");
            $this->db->query("UPDATE products s1, products s2
                              SET s1.order_num = (@a:=s1.order_num)*0+s2.order_num, s2.order_num = @a
                              WHERE s1.product_id = '$product_id'
                              AND s2.product_id = @id");
            $get = $this->form_get(array());
            if(isset($_GET['from']))
              header("Location: ".$_GET['from']);
            else
              header("Location: index.php$get");
        }

        # Сдвинуть товар вниз
        if(isset($_GET['action']) and $_GET['action']=='move_down')
        {
            $this->check_token();

            $product_id = $_GET['item_id'];
            $this->db->query("SELECT @id:=s1.product_id
                              FROM products s1, products s2
                              WHERE s1.category_id=s2.category_id AND  s1.order_num<s2.order_num
                              AND s2.product_id = '$product_id'
                              ORDER BY s1.order_num DESC
                              LIMIT 1");
            $this->db->query("UPDATE products s1, products s2
                              SET s1.order_num = (@a:=s1.order_num)*0+s2.order_num, s2.order_num = @a
                              WHERE s1.product_id = '$product_id'
                              AND s2.product_id = @id");
            $get = $this->form_get(array());
            if(isset($_GET['from']))
              header("Location: ".$_GET['from']);
            else
              header("Location: index.php$get");
        }
    }

    function fetch() {
        $this->title  = $this->lang->PRODUCTS;
        $current_page = $this->param('page');

        if (!empty($this->settings->products_num_admin)) $this->items_per_page = $this->settings->products_num_admin*2;

        $current_brand_id = $this->param('brand_id');
        if ($current_brand_id) {
            $this->db->query("SELECT * FROM brands WHERE brand_id = '$current_brand_id'");
            $current_brand = $this->db->result();
        }

        $categories = Storefront::get_categories(0, ['canonical' => true]);

        $current_category_id = $this->param('category');
        $category_filter = '';
        if ($current_category_id) {
            $category_filter = " AND categories.category_id = $current_category_id ";
        }

        if (!empty($current_category))
            $query = "SELECT brands.* FROM products, categories, brands WHERE products.brand_id = brands.brand_id AND products.category_id = categories.category_id AND (categories.category_id='$current_category->category_id' or categories.parent='$current_category->category_id') GROUP BY brands.name ORDER BY brands.name";
        else
            $query = "SELECT brands.* FROM products, brands WHERE products.brand_id = brands.brand_id GROUP BY brands.name ORDER BY brands.name";
        $this->db->query($query);
        $brands = $this->db->results();
        foreach($brands as $k=>$brand) {
              $brands[$k]->brand_url = $this->form_get(array('brand_id'=>$brand->brand_id, 'page'=>''));
        }

        $brand_filter = '';
        if($current_brand_id) {
          $brand_filter = "AND products.brand_id = '$current_brand_id' ";
        }

        $keyword = $this->param('keyword');
        $keyword_filter = '';
        if ($keyword) {
          $keywords = split(' ', $keyword);
          foreach ($keywords as $keyword) {
            $keywords = mysql_real_escape_string(trim($keyword));
            $keyword_filter .= "AND (products.code = '$keyword' OR products.sku LIKE '%$keyword%' OR products.url LIKE '%$keyword%' OR products.model LIKE '%$keyword%' OR products.description LIKE '%$keyword%' OR products.body LIKE '%$keyword%' ) ";
          }
        }

        $seo_words = $this->param('seo_words');
        if ( $seo_words ) {
            $keyword_filter = " AND products.seo_words <> '' ";
        }

        $no_description = $this->param('no_description');
        if ( $no_description ) {
            $keyword_filter = " AND products.description = '' AND size != '' ";
        }

        $no_eng_description = $this->param('no_eng_description');
        if ( $no_eng_description ) {
            $keyword_filter = " AND (products.eng_body = '' OR products.eng_text_sizes = '' OR products.eng_uhod = '') AND size != '' AND large_image != '' ";
            $order_by = " ORDER BY products.created DESC, products.product_id ASC ";
        }

        $sort_by_views = $this->param('sort_by_views');
        if ( !$order_by ) {
          if ( $sort_by_views ) {
            $order_by = " ORDER BY pvc.count DESC ";
          }
          else {
            $order_by = " ORDER BY products.modified DESC, products.product_id ASC ";
          }
        }


        $start_item = $current_page*$this->items_per_page;
        $query = sql_placeholder("SELECT SQL_CALC_FOUND_ROWS products.*, categories.name as category_name, categories.single_name as category_single_name,  categories.url as category_url, brands.name as brand, brands.url as brand_url, COUNT(products_comments.comment_id) AS comments_num, pvc.count AS pv_count
                          FROM products
                          LEFT JOIN brands ON products.brand_id = brands.brand_id
                          LEFT JOIN product_view_counters pvc ON products.product_id = pvc.product_id
                          LEFT JOIN products_comments ON products.product_id = products_comments.product_id,
                          categories
                          WHERE
                          products.category_id = categories.category_id
                          $category_filter
                          $brand_filter $keyword_filter
                          GROUP BY products.product_id
                          $order_by
                          LIMIT ? ,?", $start_item, $this->items_per_page);

        $this->db->query($query);
        $items = $this->db->results();

        $this->db->query("SELECT FOUND_ROWS() as count");
        $pages_num = $this->db->result();
        $pages_num = $pages_num->count/$this->items_per_page;

        if($items) foreach($items as $key=>$item) {
           $items[$key]->edit_get        = $this->form_get(array('section'=>'Product','item_id'=>$item->product_id, 'token'=>$this->token));
           $items[$key]->copy_get        = $this->form_get(array('action'=>'copy','item_id'=>$item->product_id, 'token'=>$this->token));
           $items[$key]->set_hit_get     = $this->form_get(array('set_hit'=>$item->product_id, 'token'=>$this->token));
           $items[$key]->set_enabled_get = $this->form_get(array('set_enabled'=>$item->product_id, 'token'=>$this->token));
           $items[$key]->delete_get      = $this->form_get(array('act'=>'delete', 'item_id'=>$item->product_id, 'token'=>$this->token));
           $items[$key]->move_up_get     = $this->form_get(array('action'=>'move_up','item_id'=>$item->product_id, 'token'=>$this->token));
           $items[$key]->move_down_get   = $this->form_get(array('action'=>'move_down','item_id'=>$item->product_id, 'token'=>$this->token));
        }

        $this->pages_navigation->fetch($pages_num);
        $this->smarty->assign('Items', $items);
        $this->smarty->assign('Brands', $brands);
        $this->smarty->assign('keyword', $this->param('keyword'));
        $this->smarty->assign('Categories', $categories);
        $this->smarty->assign('CurrentCategory', empty($current_category)?0:$current_category);
        $this->smarty->assign('CurrentBrand', empty($current_brand)?0:$current_brand);
        $this->smarty->assign('PagesNavigation', $this->pages_navigation->body);
        $this->smarty->assign('CreateGoodURL', $this->form_get(array('section'=>'Product', 'category'=>empty($category_id)?0:$category_id, 'brand'=>empty($current_brand->brand_id)?0:$current_brand->brand_id, 'token'=>$this->token)));
        $this->smarty->assign('Lang', $this->lang);
        $this->smarty->assign('Error', $this->error);
        $this->body = $this->smarty->fetch('products.tpl');
    }
}
