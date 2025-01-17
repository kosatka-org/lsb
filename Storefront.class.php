<?PHP

if (!function_exists('mb_ucfirst')) {
    function mb_ucfirst($str, $encoding = "UTF-8", $lower_str_end = false) {
        $first_letter = mb_strtoupper(mb_substr($str, 0, 1, $encoding), $encoding);
        $str_end = "";
        if ($lower_str_end) {
            $str_end = mb_strtolower(mb_substr($str, 1, mb_strlen($str, $encoding), $encoding), $encoding);
        }
        else {
            $str_end = mb_substr($str, 1, mb_strlen($str, $encoding), $encoding);
        }
        return $first_letter . $str_end;
    }
}

require_once('Widget.class.php');

class Storefront extends Widget
{
    var $items_per_page = 24; // Количество товаров на странице
    var $use_optional_categories = true; // Использовать допкатегории
    var $categories = array();
    var $error = '';


    function Storefront($parent) {
        Widget::Widget($parent);

        // Если у родителя уже выбраны категории
        if (is_array($parent->categories)) {
            $this->categories = $parent->categories;
        }
        else {
            // иначе выбираем
            $this->categories = $this->get_categories();
        }

        if ( !empty($_SESSION['1click_purchase_data']) ) {
            $this->smarty->assign('purchase_data', $_SESSION['1click_purchase_data']);
            unset($_SESSION['1click_purchase_data']);
        }
    }

    function fetch() {
        if ( !empty($_SESSION['user']->user_id) && !empty($_COOKIE['checkbox']) ) {
            $saved_data = serialize($_COOKIE['checkbox']);
            $this->db->query(" UPDATE users SET saved_data = '{$saved_data}' WHERE user_id = '{$_SESSION['user']->user_id}' ");
        }


        // Все возможные GET-параметры. Фильтруем для безопасности
        $category = $this->url_filtered_param('category');
        $brand    = $this->url_filtered_param('brand');
        $product  = $this->url_filtered_param('product');
        $stock    = $this->url_filtered_param('stock');
        $big_size = $this->url_filtered_param('big_size');
        $set_info = $this->url_filtered_param('set_info');

        // Если задан id товара для приложения
        if ($this->settings->theme == 'api' && !empty($_GET['product'])) {
            $product_id = preg_replace('/[^0-9]/', '', $_GET['product']);
            $product = $this->db->result($sql="SELECT url FROM products WHERE product_id = {$product_id} LIMIT 1")->url;
            return $this->fetch_product($product);
        }
        if (!empty($product)) {
            // Если задан товар, выводим его
            return $this->fetch_product($product);
        }
        elseif (!empty($stock)) {
            return $this->fetch_stock($stock);
        }
        elseif (!empty($category) || !empty($brand)) {
            // Если задана категория, выводим товары этой категории
            return $this->fetch_products($category, $brand);
        }
        elseif (!empty($set_info)) {
            return $this->set_info($set_info);
        }
        else {
            // По умолчанию выводим каталог
            return $this->fetch_catalog();
        }
    }

    /**
     * Отображение каталога товаров
     */
    function fetch_catalog() {
        // Если пользователь залогиен, применим сразу его скидку к ценам на товар
        $discount=isset($this->user->discount)?$this->user->discount:0;

        // Популярные товары
        $query = "SELECT SQL_CALC_FOUND_ROWS *,
                products.*, brands.name as brand, brands.url as brand_url,
                categories.single_name as category, categories.url as category_url, categories.image as category_image,
                products.price*(100-$discount)/100 as discount_price
                  FROM products
                  LEFT JOIN categories ON categories.category_id = products.category_id
                  LEFT JOIN brands ON products.brand_id = brands.brand_id
                WHERE products.enabled=1
                  AND categories.enabled=1
                  AND products.hit=1
                ORDER BY products.order_num DESC";
        $this->db->query($query);
        $products = $this->db->results();

        $this->smarty->assign('products', $products);
        $this->body = $this->smarty->fetch('catalog.tpl');
        return $this->body;
    }


    /**
     * Отображение списка товаров в категории
     */
    function fetch_products($category_url, $brand_url) {
        // берем количество товаров из настроек
        if(!empty($this->settings->products_num))
            $this->items_per_page = $this->settings->products_num;

        // Если задан бренд, выберем его из базы
        if (isset($brand_url) && !empty($brand_url)) {
            $query = sql_placeholder('SELECT * FROM brands WHERE url=? LIMIT 1', $brand_url);
            $this->db->query($query);
            $brand = $this->db->result();
            if (empty($brand))
            {
                return false;
            }
            $this->smarty->assign('brand', $brand);
        }

        // Выберем текущую категорию
        if (isset($category_url) && !empty($category_url)) {
            $category = $this->category_by_url($this->categories, $category_url);
            if (empty($category))
            {
                return false;
            }
            $this->smarty->assign('category', $category);
        }

        // Текущая страница в постраничном выводе
        // Единицу отнимаем, потому что в коде страницы нумеруются с 0 а не с 1 как снаружи
        $current_page = intval($this->param('page'))-1;

        // Если не задана, то равна 0
        $current_page = max(0, $current_page);
        $this->smarty->assign('page', $current_page);

        // Порядковый номер первого товара на странице
        $start_item = $current_page*$this->items_per_page;

        // Выбираем свойства категории
        $query = sql_placeholder("SELECT * FROM properties, properties_categories
                                    WHERE properties.property_id = properties_categories.property_id
                                    AND properties_categories.category_id=?
                                    AND enabled AND in_filter AND options!='' ORDER BY properties.order_num", $category->category_id);
        $this->db->query($query);
        if($properties = $this->db->results()) {
            foreach($properties as $k=>$property)
                $this->add_param($property->property_id);
            foreach($properties as $k=>$property)
            {
                $properties[$k]->clear_url = $this->form_get(array($property->property_id=>''));
                $options = array();
                $opts = unserialize($property->options);
                foreach($opts as $i=>$o)
                {
                    $options[$i]->value = $o;
                    $options[$i]->url = $this->form_get(array($property->property_id=>$o));
                }
                $properties[$k]->options = $options;
            }
            $this->smarty->assign('properties', $properties);
            $this->smarty->assign('filter_params', $this->form_get(array()));
            ////////////////////////


            // Переданные значения свойств для фильтра
            $filter = array();
            foreach ($properties as $k=>$property) {
                if ($val = $this->param($property->property_id))
                    $filter[$property->property_id] = $val;
            }
        }

        // Выбираем из базы товары
        $products = $this->get_products(null, $category->subcats_ids, isset($brand->brand_id)?$brand->brand_id:null, $start_item, $filter);

        $this->smarty->assign('products', $products);

        // Вычисляем количество страниц
        $this->db->query("SELECT FOUND_ROWS() as count");
        $pages_num = $this->db->result();
        $pages_num = ceil($pages_num->count/$this->items_per_page);
        $this->smarty->assign('total_pages', $pages_num);

        // Устанавливаем мета-теги
        if($category) {
            $this->title = $category->meta_title;
            $this->description = $category->meta_description;
            $this->keywords = $category->meta_keywords;
        } elseif($brand) {
            $this->title = $brand->meta_title;
            $this->description = $brand->meta_description;
            $this->keywords = $brand->meta_keywords;
        }

        // Выбираем все бренды, они нужны нам в шаблоне
        if (is_array($category->subcats_ids)) {
            if($this->use_optional_categories) {
                //С дополнительными категориями

                // Если задана категория, добавляем фильт по категории
                $category_filter = "AND ( (products.category_id in(".join($category->subcats_ids, ',').") ) OR (products_categories.category_id in(".join($category->subcats_ids, ',').") ) )";

                $query = sql_placeholder("SELECT DISTINCT brands.*
                            FROM brands, products LEFT JOIN products_categories ON products.product_id = products_categories.product_id
                            WHERE
                            products.brand_id = brands.brand_id
                            AND products.enabled=1
                            $category_filter
                            ORDER BY brands.name", $category->category_id);
            }else{

                $category_filter = "AND products.category_id in(".join($category->subcats_ids, ',').")";

                $query = sql_placeholder("SELECT DISTINCT brands.*
                                      FROM brands, products
                                      WHERE products.brand_id = brands.brand_id
                                      AND products.enabled=1
                                      $category_filter
                                      ORDER BY brands.name", $category->category_id);
            }
            $this->db->query($query);
            $brands = $this->db->results();
        }
        $this->smarty->assign('brands', $brands);

        $this->body = $this->smarty->fetch('products.tpl');
        return $this->body;
    }

    // Показывает товары из остатков без фотографий
    function fetch_stock($stock_url)
    {
        $stock = $this->get_stock($stock_url);
        if(empty($stock)) {
          return false;
        }

        $this->smarty->assign('no_size', false);
        if ($stock->size == "|Р-р не задан|" || $stock->size == "|р-р не зад|" || isset($stock->p_date))
        {
          $this->smarty->assign('no_size', true);
        }
        $stock->size_text = explode('|', str_replace(' ', '', trim($stock->size, '|')));
        natsort($stock->size_text);

        $query = sql_placeholder("SELECT * FROM locations2links WHERE item_location = ?", $stock->location);
        $this->db->query($query);
        $location = $this->db->result();

        if ($stock->brand_id != 0) {
            $query = sql_placeholder("SELECT * FROM brands WHERE brand_id = ?", $stock->brand_id);
            $this->db->query($query);
            $brand = $this->db->result();
            $this->smarty->assign('brand', $brand);
        }

        if ($stock->category_id != 0) {
            $query = sql_placeholder("SELECT * FROM categories WHERE category_id = ?", $stock->category_id);
            $this->db->query($query);
            $category = $this->db->result();
            $this->smarty->assign('category', $category);
        }

        if (isset($brand) && isset($category)) {
            $linkproducts = $this->db->results("SELECT * FROM products WHERE brand_id = {$brand->brand_id} AND category_id = {$category->category_id} AND enabled=1 AND size != '' LIMIT 12");
        }
        elseif (isset($brand) && !isset($category)) {
            $linkproducts = $this->db->results("SELECT * FROM products WHERE brand_id = {$brand->brand_id} AND enabled=1 AND size != '' LIMIT 12");
        }
        elseif (!isset($brand) && isset($category)) {
            $linkproducts = $this->db->results("SELECT * FROM products WHERE category_id = {$category->category_id} AND enabled=1 AND size != '' LIMIT 12");
        }
        else {
            $linkproducts = $this->db->results("SELECT * FROM products WHERE enabled=1 AND size != '' LIMIT 12");
        }

        if (isset($linkproducts)) {
            $this->smarty->assign('linkproducts', $linkproducts);
        }

        $amazon_url = "https://s3-eu-west-1.amazonaws.com/luxurystore/foto/";
        $file_name = str_pad($stock->code, 11, "0", STR_PAD_LEFT) . ".jpg";
        $command = "curl -s -o /dev/null -I -w \"%{http_code}\" {$amazon_url}{$file_name}";

        if (shell_exec($command) == '200') {
                $stock->image = $amazon_url . $file_name;
        }
        else {
                $stock->image = '/images/noimage.png';
        }


        $this->smarty->assign('title', "{$stock->category_name} из Италии сезона " . date('Y') . " | интернет магазин одежды Лакшери стор");
        $this->smarty->assign('location', $location);
        $this->smarty->assign('product', $stock);

        $this->body = $this->smarty->fetch('stock.tpl');
        return $this->body;
    }

    /**
     * Отображение отдельного товара
     */
    function fetch_product($product_url)
    {
        $s_user_id = isset($_SESSION['user']->user_id) ? $_SESSION['user']->user_id : 0;
        if ($this->settings->theme == 'api') $s_user_id = $_GET['user_id'];

        // Редирект для старых ссылок
        $prod = $this->db->result(sql_placeholder("SELECT * FROM products WHERE old_url = ? OR url = ? LIMIT 1", $product_url, $product_url));

        if (!empty($prod)) {
          // Редирект Диор
          $visible_brands = luser::visible_brands($s_user_id);
          if (!(in_array($prod->brand_id, $visible_brands)) && $prod->brand_id == 385) {
              header("Location: /dior/");
              exit();
          }
          if ($product_url == $prod->old_url && $prod->url != $prod->old_url) {
            header("HTTP/1.1 301 Moved Permanently");
            header("Location: /products/{$prod->url}/");
            die('ok');
          }
        }

        // Выбираем товар из базы
        $product = $this->get_product($product_url);
        if (empty($product)) {
            // страница 404
            return false;
        }

        //Сетрификаты
        $product->sertif = array();
        //сертиф для бренда и пустой категории
        $query = "SELECT link_to_sertif FROM sertif WHERE brand_id = {$product->brand_id} AND category_id=0";
        if ($this->db->results($query)) {
            $product->sertif[] = $this->db->results($query);
        }

        //сертиф для бренда с этой категорией и пустой подкатегорией
        $query = "SELECT link_to_sertif FROM sertif WHERE brand_id = {$product->brand_id} AND category_id={$product->category_parent} AND podcat_id=LIKE '%,0,%'";
        if ($this->db->results($query)) {
            $product->sertif[] = $this->db->results($query);
        }

        //сертиф для конкретной группы товаров
        $query = "SELECT link_to_sertif FROM sertif WHERE brand_id = {$product->brand_id} AND category_id={$product->category_parent} AND podcat_id LIKE '%,{$product->category_id},%'";
        if ($this->db->results($query)) {
            $product->sertif[] = $this->db->results($query);
        }

        $user_sex = !empty($_COOKIE['sex']) ? $_COOKIE['sex'] : 1;
        // Дополнительные фото товара
        if ( $product->sex == 0 ) {

            $female_images = $this->db->results("SELECT * FROM products_fotos WHERE product_id = {$product->product_id} AND female = 1");
            if ($female_images && $user_sex == 2) {
              $product->large_image = $female_images[0]->filename;
              $product->small_image = $female_images[1]->filename;
            }
            $male_only = ($user_sex == 1) ? ' AND female = 0 ' : '';
            $query = "SELECT * FROM products_fotos WHERE product_id = {$product->product_id} AND foto_id NOT IN (20,21) AND cover_photo=0 {$male_only} ORDER BY foto_id";
        }
        else {
            $query = "SELECT * FROM products_fotos WHERE product_id = {$product->product_id} AND big_size=0 AND cover_photo=0 ORDER BY foto_id";
        }
        $product->fotos = $this->db->results($query);

        // Замена видео для унисекс женский раздел
        if ( $product->sex == 0 && $user_sex == 2 && !empty($product->vimeo_w)) {
          $product->vimeo = $product->vimeo_w;
        }

        // Цена из ЦУМа
        $product->tsum_price = $this->db->result("SELECT * FROM tsum_prices WHERE product_id = {$product->product_id}");

        $this->smarty->assign('color_name', $this->db->result("SELECT * FROM colors WHERE colors.color_id = {$product->color_id}"));


        // И передаем его в шаблон
        $this->smarty->assign('no_size', false);
        if (strpos($product->size, 'зад') !== false && strpos($product->size, 'не ') !== false) {
            $this->smarty->assign('no_size', true);
            if ($_COOKIE['language'] == 'eng') $product->size  = 'without size';
        }
        // размеры size_text должны соответствовать тому, что в БД, чтобы можно было фильтровать неактуальные товары в корзине
        // т.е. не удалять пробелы
        $product->size_text = explode('|', trim($product->size, '|') );
        if ($this->settings->theme == 'api') {
            if(isset($_GET['user_id']) && !empty($_GET['user_id'])) $user_group = $this->db->result("SELECT group_id FROM users WHERE user_id = '{$_GET['user_id']}'")->group_id;
            if ($user_group != 2) {
              $shop_filter = "AND shop_id IN (SELECT shop_id FROM shops WHERE enabled=1 {$megasale_filter})";
            }
            $query = "SELECT GROUP_CONCAT(DISTINCT size
                ORDER BY FIELD(size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL', '5XL+', '6XL', '7XL'), size + 0, size ASC SEPARATOR ', ') AS size
                FROM items
                WHERE quantity != 0 AND product_id={$product->product_id} {$shop_filter}
                GROUP BY product_id;";
            $size = $this->db->result($query)->size;
            $product->size = (!empty($size)) ? $size : '';
            if (strpos($product->size, 'зад') !== false && strpos($product->size, 'не ') !== false) {
                $product->size  = '';
            }
        }
        else{
            $product->size = '<option selected="selected">' . implode('</option><option selected="selected">', explode('|', str_replace(' ', '', trim($product->size, '|')))) . '</option>';
        }

        $s_tmp = $this->db->results("SELECT shop_id FROM shops WHERE enabled=0");
        $hid_shops=array();
        foreach($s_tmp as $s) $hid_shops[]=$s->shop_id;
        $this->smarty->assign('hid_shops', $hid_shops);

        $user      = new luser($s_user_id);

        $user->view_product($product->product_id);

        $this->smarty->assign('mixmarket_product_id', $product->product_id);


        $product->discount_value = $discount = $user->get_personal_discount($product, $user->get_sum_of_buy($s_user_id), !empty($_SESSION['group']->discount));

        if ( !empty($discount) && $product->old_price == 0 ) {
            $product->discount_price = floor((100-$discount)*$product->price/100);
        }

        // product_views log
        if ($product->product_id) {
            $product_view_args = array(
                'product_id' => $product->product_id,
                'user_agent' => $_SERVER['HTTP_USER_AGENT']
            );
            $product_view_args['user_id'] = $s_user_id;
            $product_view_args['app_view'] = $this->settings->theme == 'api' ? 1 : 0;
            if (isset($product->discount_price) && $product->discount_price < $product->price) {
                $product_view_args['price'] = $product->discount_price;
            }
            else {
                $product_view_args['price'] = $product->price;
            }
            // Resque::Enqueue('default', 'ProductViewJob', $product_view_args);
            if($s_user_id){
                $this->db->query(" UPDATE users SET last_view_date = NOW() WHERE user_id = '{$s_user_id}' ");
            }
        }

        // Выберем текущую категорию
        $category = $this->db->result("SELECT * FROM categories WHERE category_id = {$product->category_id}");

        $view_category  = $category->category_id == 38 ? $category->category_id : $category->parent;
        $this->smarty->assign('view_category', $view_category);
        $view_category_word = 'accessory';
        if ( $view_category == 2 ) {
            $view_category_word = 'shoe';
        }
        if ( $view_category == 1 ) {
            $view_category_word = 'upper'; // lower upper accessory
        }
        $view_sizes = 'null';
        if ( is_array($product->size_text) && count($product->size_text) > 0 ) {
            $view_sizes = array();
            foreach ( $product->size_text as $k=>$s ) {
                $ns = trim(str_replace(',', '.', $s));
                if ( strpos($ns, '(') ) {
                    $ns = substr($ns, strpos($ns, '(')+1, -1);
                }
                if ( $ns == ''.(float)$ns ) {
                    $ns = 'e' . $ns;
                }
                $view_sizes[] = "'{$ns}'";
                $tmp = new stdClass();
                $tmp->size  = $s;
                $tmp->nsize = $ns;
                $product->tmp_size_text[$k] = $tmp;
            }
            $view_sizes = implode(',', $view_sizes);
            if ($_COOKIE['language'] == 'eng' && strpos($s, 'зад') !== false && strpos($s, 'не ') !== false) {
                $product->size_text[$k]  = 'without size';
            }
        }

        $this->smarty->assign('view_sizes', $view_sizes);

        $this->smarty->assign('view_category_word', $view_category_word);
        $this->smarty->assign('category', $category);
        $this->smarty->assign('manOrWoman', !empty($_COOKIE['sex']) ? $_COOKIE['sex'] : '1');

        // Рыбный текст
        $brand = $this->db->result("SELECT * FROM brands WHERE brand_id =  {$product->brand_id}");
        $field = "text{$view_category}";
        $this->smarty->assign('product_brand_text', $brand->$field);
        $this->smarty->assign('brand', $brand);

        $product->can_buy_from_site = $user->can_buy_from_site($product->brand_id);
        if(strpos($product->sku,'тест') !== false || strpos($product->sku,'test') !== false)$product->can_buy_from_site = true;
        $this->smarty->assign('can_buy_from_site', $product->can_buy_from_site);

        $product->sizes_url = '';
        switch( $view_category ) {
            case 2:
                $product->sizes_url = '/sizes/wsizeshoes.php?sex=' . $product->sex;
            break;
            case 1:
                $product->sizes_url = '/sizes/wsizeclothes.php?sex=' . $product->sex;
            break;
            case 3:
                $product->sizes_url = '/sizes/wsizelinen.php?sex=' . $product->sex;
            break;
            case 4:
                $product->sizes_url = '/sizes/wsizeAccessories.php?sex=' . $product->sex;
            break;
        }
        $country_name = array(
           "италия"  => "Italy",
           "канада"  => "Canada",
           "англия"  => "England",
           "франция" => "France"
        );

        if ( is_array($product->properties) && count($product->properties) ) {
            foreach ($product->properties as $k=>$property) {
                if ($property->name == 'Страна происхождения' ) {
                    $product->properties[$k]->value = isset($country_name[mb_strtolower(trim($property->value), 'UTF-8')]) ? $country_name[mb_strtolower(trim($property->value), 'UTF-8')] : $property->value;
                    $country = $product->properties[$k]->value;
                }
            }
        }

        //$this->smarty->assign('group_name', str_replace(str_replace(' ', '', $product->brand), '', $product->model));
        $entry = array('.');
        $product->brand = trim($product->brand);
        $product->model = str_replace('"', "'", trim($product->model));
        $brand_name_short = str_replace(array('.'), '', $product->brand);
        $brand_name_join  = str_replace(' ', '', $product->brand);
        $brand_name_ap  = str_replace('`', "'", $product->brand);
        $brands_names = array($product->brand, $brand_name_short, $brand_name_ap,
                    strtolower($product->brand), strtoupper($product->brand), ucfirst($product->brand),ucwords($product->brand),
                    strtolower($brand_name_join), strtoupper($brand_name_join), ucfirst($brand_name_join),ucwords($brand_name_join));
        if($_COOKIE['language'] === 'eng'){
          if($category->category_id == 97 && $_COOKIE['sex'] == 1){$category->eng_single_name = 'Oxford shoes';}
          $group_name = $category->eng_single_name;
        }
        else{$group_name = str_replace($brands_names, '', $product->model);}
        $this->smarty->assign('group_name', $group_name);

        if ($this->settings->theme == 'api') {
            $product->prices = $user->product_prices_for_api($product, $_GET['currency'], $product->can_buy_from_site);
        }
        else{
            $product->prices = $user->product_prices($product);
            $product->price = $product->prices['personal_price'];
        }

        if(isset($_GET['user_id']) && !empty($_GET['user_id']) && $this->settings->theme == 'api') $user_group = $this->db->result("SELECT group_id FROM users WHERE user_id = '{$_GET['user_id']}'")->group_id;
        if ($_SESSION['user']->group_id > 1 || $user_group > 1){
          $product->admin_details = new stdClass();
          if ($product->season == '18/2' && ($product->old_price > $product->price)) $product->super_price = true;
          if($product->super_price) $product->admin_details->super_sale = round((1 - ($product->price / $product->old_price))*100, 0);
          $product->admin_details->sales = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = '{$product->brand_id}' AND season LIKE '{$product->season_type}' ");
          if ($_GET['currency']){
            $c_name = !empty($_GET['currency']) ? strtolower($_GET['currency']) : 'rub';
            $c_rate = isset($this->currencies->$c_name->rate_to) ? $this->currencies->$c_name->rate_to : 1;
            $product->admin_details->offline_price = (string)round($product->offline_price/$c_rate,2);
          }
          else $product->admin_details->offline_price = $product->offline_price;
          $product->admin_details->sku = $product->sku;
          $warehouse_filter = ($_SESSION['user']->group_id == 2 || $user_group == 2) ? '' : " AND w.admin_only = 0 ";
          $product->admin_details->wares = $this->db->results("SELECT i.barcode, sn.size, i.normal_size, i.size as i_size, i.quantity, i.shop_id, s.ru_size, s.int_size, w.admin_only, w.name AS warehouse_name
                                                FROM items i
                                                LEFT JOIN warehouses w ON i.warehouse_id = w.warehouse_id
                                                LEFT JOIN size_names sn ON i.size_id = sn.size_id AND i.size_system = sn.size_m_s
                                                LEFT JOIN sizes s ON i.size_id = s.size_id
                                                WHERE i.quantity != 0
                                                AND i.product_id = {$product->product_id} {$warehouse_filter}
                                                GROUP BY i.size, i.warehouse_id ORDER BY FIELD(i.size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+'), size ASC ");
          if(empty($product->admin_details->wares))$product->admin_details->wares = null;
          foreach($product->admin_details->wares as $w){
            $product->admin_details->sizes_allowed[$w->i_size] = true;
            $w->allowed = false;
            if(!in_array($w->shop_id,$hid_shops) && ($w->shop_id != 0 || $w->admin_only == 0)){
              $product->admin_details->sizes_allowed[$w->i_size] = false;
              $w->allowed = true;
            }
          }
          $product->admin_details->history = $this->db->results($sql="SELECT pv.*, DATE_FORMAT(pv.date, '%m/%d') as date, u.name, u.user_id, u.phone_number
                                      FROM product_views pv
                                      LEFT JOIN users u ON u.user_id = pv.user_id
                                      LEFT JOIN users2shops us ON u.user_id = us.user_id AND shop_id != 7
                                      WHERE pv.product_id = {$product->product_id} AND u.group_id = 1 AND pv.user_id IS NOT NULL AND us.shop_id IS NOT NULL AND pv.date > DATE_SUB(CURDATE(), INTERVAL 14 DAY) GROUP BY u.user_id ORDER BY pv.date DESC");

        }

        $product_from_wl = $this->db->results($sql="SELECT * FROM users2wishlist WHERE product_id = '{$product->product_id}' AND user_id = '{$s_user_id}'");
        $this->smarty->assign('product_from_wl',    $product_from_wl);
        if($product_from_wl) $product->product_from_wl = true;
        else $product->product_from_wl = false;

        $this->smarty->assign('product',    $product);
        // Определяем новый сезон
        $this->smarty->assign('new_season', $product->season == '18/1' || $product->season == '18/2');

        if(isset($this->user->name)) {
            $this->smarty->assign('name', $this->user->name);
        }

        ###
        if ($product->sex > 0) {
            $sex = $product->sex == 1 ? 'мужской' : 'женской';
        }
        $season = trim(str_replace(array('sfilata', 'main', 'обувь', 'аксс', 'пре', 'pre', '/1', '/2'), '', $product->season));
        $season = strlen($season) == 2 ? "сезона 20{$season}" : '';

        $product->img_desc = "{$product->model} из Италии {$season}";

        $addNameStore = (strpos($_SERVER['SERVER_NAME'], 'lstore.moscow') !== false ) ? 'lstore.moscow' : 'Лакшери стор';

        $title = "{$product->model} из Италии {$season}" . " | интернет магазин {$sex} одежды {$addNameStore}";
        if($_COOKIE['language'] === 'eng'){$title = "{$group_name} {$product->brand} made in Italy {$season}" . " | Luxury Store";}
        $this->smarty->assign('title',       $title);
        $this->smarty->assign('keywords',    "{$product->model}, одежда из Италии, {$season}" . ", интернет магазин {$sex} одежды, {$addNameStore}");
        $this->smarty->assign('description', strip_tags($product->description));
        $this->smarty->assign('sertifs', $product->sertif);

        if ($product->category_parent) {
            $Fname = "text{$product->category_parent}";
            if ($product->sex > 0) {
                $Fname = $product->sex == 1 ? "{$Fname}_1": "{$Fname}_2";
            }
            if ($brand->$Fname){
                $brand->$field = $brand->$Fname;
            }
        }
        $File = file('replaceLinks.txt');
        if($File) {
            $Find = array();
            $Replace = array();
            foreach ($File as $line) {
                $u = explode ('=>', $line);
                $Find[] = $u[0];
                $Replace[] = $u[1];
            }
            $description  = preg_replace($Find, $Replace, $product->description, 1);
            $descriptionB = preg_replace($Find, $Replace, $brand->$field, 1);
        }

        //убираем пустые строки, которые добавили из админки
        $description = str_replace('<p>&nbsp;</p>', '', $description);

        $this->smarty->assign('description', $description);
        $this->smarty->assign('product_brand_text', $descriptionB);

        $comments = array();


        $this->smarty->assign('comments', $comments);
        $this->smarty->assign('error', $this->error);

        $show_price = 0;

        foreach ($product->properties as $property) {
            if ($property->name == 'Предложение') {
                $show_price = 1;
            }
        }
        $this->smarty->assign('show_price', $show_price);

        $item_loc = str_replace("#",", ",$product->item_location);
        $this->smarty->assign('item_location', $item_loc);

        if (strpos($product->item_location, 'Podium VIP') !== FALSE || strpos($product->item_location, 'Лакшери Этажи') !== FALSE || $brand->low_discount) {
            $this->smarty->assign('podium', true);
        }
        else {
            $this->smarty->assign('podium', false);
        }

        $set_product_id = $this->db->result("SELECT id FROM sets WHERE main_product_id = '{$product->product_id}'");
        $set_id         = !empty($set_product_id->id) ? $set_product_id->id : 0;
        $set_products = $this->db->results("SELECT product_id
            FROM sets_products
            WHERE set_id = '{$set_id}' AND product_id != {$product->product_id}");
        if (!empty($set_products)){
            $set_product_ids = array();
            foreach ($set_products as $key => $value) {
                $set_product_ids[] = $value->product_id;
            }
            $set_product_ids = array_unique($set_product_ids);
            $set_products = Storefront::get_products($set_product_ids);
            foreach ($viewed_products as $v) $v->model = str_replace('"', "'", trim($v->model));
            $this->smarty->assign('set_products', $set_products);
        }


        // Недавно просмотренные товары
        $vp_query = sql_placeholder("SELECT a.product_id FROM (
        SELECT pv.product_id, pv.date FROM product_views pv
            WHERE pv.product_id != ?
            AND pv.web_session_id IN (SELECT ws.id FROM web_sessions ws WHERE ws.phpsessid = ?) GROUP BY pv.product_id
        UNION
        SELECT pv.product_id, pv.date FROM product_views pv
            WHERE pv.product_id != ?
            AND pv.user_id =  '?' GROUP BY pv.product_id) a
        ORDER BY a.date DESC LIMIT 5", $product->product_id, (!empty($_COOKIE['PHPSESSID']) ? $_COOKIE['PHPSESSID'] : ''), $product->product_id, $_SESSION['user']->original_user_id);

        $viewed_products = $this->db->results($vp_query);
        $viewed_product_ids = array();
        foreach ($viewed_products as $key => $value) {
            $viewed_product_ids[] = $value->product_id;
        }
        $viewed_product_ids = array_unique($viewed_product_ids);
        $viewed_products = Storefront::get_products($viewed_product_ids);
        foreach ($viewed_products as $v) $v->model = str_replace('"', "'", trim($v->model));

        $config = new Config();
        $this->smarty->assign('config', $config);

        $this->smarty->assign('cart_products', isset($_SESSION['shopping_cart_sizes']) ? array_keys($_SESSION['shopping_cart_sizes']) : array());
        $this->smarty->assign('set_id', $set_id);
        $this->smarty->assign('viewed_products', $viewed_products);

        $this->smarty->assign('product_brand', $product->brand);

        if ( !empty($_SESSION['CHANGE_TITILE']) ) {
            $this->smarty->assign('change_title', $_SESSION['CHANGE_TITILE']);
            $_SESSION['CHANGE_TITILE'] = '';
        }

        if ($this->settings->theme == 'api') {
            $image_link = 'https://lsboutique.ru';
            if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
            $search = array("<p>&nbsp;</p>","<span>&nbsp;</span>",'<p class="MsoNormal"></p>',"&nbsp;", "\n", "\r", "“",'"',"'", "</p>", "\x08", "\x0c", "\"");
            $replace = array(' ', ' ', ' ', ' ', ' ', ' ', '', '', '', '\n', "\\f", "\\b", "\\\"");
            $pattern = '/[\x00-\x1F\x7F]/u';
            if($_COOKIE['language'] === 'eng'){
              $product->text_sizes = $product->eng_text_sizes;
              $product->description = $product->eng_description;
              $product->body = $product->eng_body;
              $product->uhod = $product->eng_uhod;
              $product->details = "Season: ".$product->season;
              $product->category = $category->eng_name;
              $product->model = $category->eng_single_name . ' ' . $product->brand;
            }
            $product->description = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $product->description))),'\n'));
            if($product->admin_details){
              $product->admin_details->max_sale = $product->admin_details->sales->max_sale;
              $product->admin_details->sale = $product->admin_details->sales->sale;
              $product->admin_details->season = $product->admin_details->sales->season;
              unset($product->admin_details->sales);
            }
            if((ctype_space($product->description) || empty($product->description)) && !$_COOKIE['language']){
                $brand = $this->db->result(sql_placeholder("SELECT * FROM brands WHERE brand_id =  ?", $product->brand_id));
                $view_category = $product->category_id == 38 ? $product->category_id : $product->category_parent;
                $field = "text{$view_category}";
                $product->description =  $brand->$field;
                $product->description = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $product->description))),'\n'));
                if (ctype_space($product->description) || empty($product->description))$product->description = null;
            }
            $product->category = $category->name;
            if (ctype_space($product->body) || empty($product->body))$product->body = null;
            $product->body = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $product->body))),'\n'));
            $product->uhod = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $product->uhod))),'\n'));
            if (ctype_space($product->uhod) || empty($product->uhod))$product->uhod = null;
            if (ctype_space($product->text_sizes) || empty($product->text_sizes))$product->text_sizes = null;
            $product->text_sizes = preg_replace($pattern, '', trim(strip_tags(str_replace($search, $replace, $product->text_sizes))));
            $product->sizes_url = 'https://lsboutique.ru'.$product->sizes_url;
            $product->url = 'https://lsboutique.ru/products/'.$product->url;
            $product->videoID = substr($product->video, -11);
            $product->color_name = $this->db->result("SELECT * FROM colors WHERE colors.color_id = {$product->color_id}")->name;
            if(empty($product->materials))$product->materials = array();
            if(empty($product->sizes))$product->sizes = array();
            if(empty($product->fotos))$product->fotos = array();
            if(empty($product->related_products))$product->related_products = array();
            $cart = $this->db->result($sql="SELECT * FROM users2carts WHERE product_id = '{$product->product_id}' AND user_id = '{$s_user_id}'");
            if($cart) $product->product_from_cart = true;
            else $product->product_from_cart = false;
            foreach ($product->fotos as $foto){
                $foto->filename_small = $image_link . '/reimg/files/products/340x/'.$foto->filename;
                $foto->filename_medium = $image_link . '/reimg/files/products/560x/'.$foto->filename;
                $foto->filename_full = $image_link . '/reimg/files/products/560x/'.$foto->filename;
                unset($foto->created,$foto->model_photo,$foto->cover_photo,$foto->foto_id,$foto->filename,$foto->product_foto_id);
            }
            if ( isset($_GET['big_size']) && $product->bsize_large_image != '' ){
                $product->large_image_small = $image_link . '/reimg/files/products/340x/'.$product->bsize_large_image;
                $product->large_image_medium = $image_link . '/reimg/files/products/560x/'.$product->bsize_large_image;
                $product->large_image_full = $image_link . '/reimg/files/products/560x/'.$product->bsize_large_image;
            }
            else{
                $product->large_image_small = $image_link . '/reimg/files/products/340x/'.$product->large_image;
                $product->large_image_medium = $image_link . '/reimg/files/products/560x/'.$product->large_image;
                $product->large_image_full = $image_link . '/reimg/files/products/560x/'.$product->large_image;
            }
            if ( isset($_GET['big_size']) && $product->bsize_small_image != '' ) {
                $product->small_image_small = $image_link . '/reimg/files/products/340x/'.$product->bsize_small_image;
                $product->small_image_medium = $image_link . '/reimg/files/products/560x/'.$product->bsize_small_image;
                $product->small_image_full = $image_link . '/reimg/files/products/'.$product->bsize_small_image;
            }
            elseif(!empty($product->small_image)){
                $product->small_image_small = $image_link . '/reimg/files/products/340x/'.$product->small_image;
                $product->small_image_medium = $image_link . '/reimg/files/products/560x/'.$product->small_image;
                $product->small_image_full = $image_link . '/reimg/files/products/560x/'.$product->small_image;
            }
            foreach ($product->related_products as $sproduct){
                $product->text_sizes = $product->eng_text_sizes = $product->description = $product->eng_description = $product->body = $product->eng_body = $product->uhod = $product->eng_uhod = '';
                $sproduct->small_image_small = !empty($sproduct->small_image) ? $image_link . '/reimg/files/products/340x/'.$sproduct->small_image : '';
                $sproduct->large_image_small = !empty($sproduct->small_image) ? $image_link . '/reimg/files/products/340x/'.$sproduct->large_image : '';
                $sproduct->small_image_medium = !empty($sproduct->small_image) ? $image_link . '/reimg/files/products/560x/'.$sproduct->small_image : '';
                $sproduct->large_image_medium = !empty($sproduct->small_image) ? $image_link . '/reimg/files/products/560x/'.$sproduct->large_image : '';
                $sproduct->small_image_full = !empty($sproduct->small_image) ? $image_link . '/reimg/files/products/560x/'.$sproduct->small_image : '';
                $sproduct->large_image_full = !empty($sproduct->small_image) ? $image_link . '/reimg/files/products/560x/'.$sproduct->large_image : '';
                unset($sproduct->url,$sproduct->guarantee,$sproduct->description,$sproduct->body,$sproduct->quantity,$sproduct->hit,
                $sproduct->order_num,$sproduct->modified,$sproduct->enabled,$sproduct->discount_value,$sproduct->small_image,$sproduct->large_image);
            }
            unset($product->code,$product->offline_price,$product->sku,$product->old_url,$product->tsum_url,$product->guarantee,$product->seo_words,$product->quantity,$product->sold,
            $product->hit,$product->order_num,$product->download,$product->meta_title,$product->meta_keywords,$product->meta_description,
            $product->created,$product->new_stuff,$product->modified,$product->sold_date,$product->desc_date,$product->editor_id,
            $product->last_price_update,$product->pack_id,$product->photo_added,$product->prop_val,$product->tsum_price,$product->old_price,
            $product->second_image,$product->week,$product->show_price,$product->enabled,$product->small_image,$product->large_image,
            $product->bsize_small_image,$product->bsize_large_image,$product->brand_url,$product->category_url,$product->eng_text_sizes,$product->eng_uhod,$product->eng_body,
            $product->eng_description,$product->trello_card,$product->video_added,$product->sizes_max_count,$product->col_code,$product->coll_active,$product->cat_enabled,$product->video);

            if($this->settings->theme_v == 'v2'){
              $return->obj[] = $product;
              $return = $this->format_api_response($return);
            }else{
              $return->product = $product;
            }
            $return = json_encode($return);
            header('Content-Type: application/json; charset=utf-8', true);
            echo $return;
            die();
        }

        if (isset($_SESSION['one_click_ordered']) || isset($_SESSION['special_order'])){
          if (isset($_SESSION['one_click_ordered'])){
              $oc_ordered = $_SESSION['one_click_ordered'];
              unset($_SESSION['one_click_ordered']);
              $oc_ordered = $this->db->get_row($sql = "SELECT * FROM `one_click` WHERE `id` = {$oc_ordered}; ");
              $ordered_product = $this->db->get_row($sql = "SELECT products.*, items.barcode, brands.name as brand_name, categories.enabled as cat_enabled, categories.name as category
                                                                          FROM products
                                                                          LEFT JOIN brands ON products.brand_id = brands.brand_id
                                                                          LEFT JOIN categories ON products.category_id = categories.category_id
                                                                          LEFT JOIN items ON products.product_id = items.product_id
                                                                          WHERE categories.enabled = 1 AND brands.visibility <= 1 AND brands.offline_only = 0 AND brands.hidden = 0 AND products.product_id = {$oc_ordered->product_id}
                                                                          GROUP BY products.product_id; ");
              if ($ordered_product)$this->smarty->assign('oc_ordered', $oc_ordered);
          }
          if (isset($_SESSION['special_order'])){
              $so = (int) $_SESSION['special_order'];
              unset($_SESSION['special_order']);
              $so = $this->db->get_row($sql = "SELECT * FROM `special_orders` WHERE `so_id` = {$so}; ");
              $ordered_product = $this->db->get_row($sql = "SELECT products.*, items.barcode, brands.name as brand_name, categories.enabled as cat_enabled, categories.name as category
                                                                          FROM products
                                                                          LEFT JOIN brands ON products.brand_id = brands.brand_id
                                                                          LEFT JOIN categories ON products.category_id = categories.category_id
                                                                          LEFT JOIN items ON products.product_id = items.product_id
                                                                          WHERE categories.enabled = 1 AND brands.visibility <= 1 AND brands.offline_only = 0 AND brands.hidden = 0 AND products.product_id = {$so->product_id}
                                                                          GROUP BY products.product_id; ");
              if ($ordered_product)$this->smarty->assign('so_ordered', $so);
          }
          if ($ordered_product){
            $ordered_product->prices = $user->product_prices($ordered_product);
            $ordered_product->price = $ordered_product->prices['personal_price'];
            $this->smarty->assign('ordered_product', $ordered_product);
          }
        }
        if (isset($_SESSION['NEW_USER_ORDER'])){
            $this->smarty->assign('new_user_order', $_SESSION['NEW_USER_ORDER']);
            unset($_SESSION['NEW_USER_ORDER']);
        }


        if (empty($product->large_image) && empty($product->small_image) && empty($product->fotos)) {
          $this->smarty->assign('empty_foto', true);
        }

        $this->smarty->assign('ecommerce_list', $_COOKIE['ecommerce_list']);
		$this->smarty->assign('og_image', '/reimg/files/products/340x/'.$product->large_image);
        $this->body = $this->smarty->fetch('product.tpl');
        return $this->body;
    }


    // Функция возвращает подкатегории
    function categories_tree($categories) {
        $tree = array();

        // Указатели на узлы дерева
        $used_items = array();

        $end = false;

        // Не кончаем, пока не кончатся категории, или пока ниодну из оставшихся некуда приткнуть
        while(!empty($categories) && !$end) {
            foreach($categories as $k=>$category) {
                $flag = false;
                if($category->parent == 0) {
                    // Добавляем элемент в дерево
                    $cat = new stdClass();
                    $cat->name = $category->name;
                    if($_COOKIE['language'] === 'eng'){$cat->eng_name = $category->eng_name;}
                    $cat->category_id = $category->category_id;
                    $cat->url = $category->url;
                    $category->path[0] = $cat;

                    $tree[$category->category_id] = $category;
                    $used_items[$category->category_id] = &$tree[$category->category_id];
                    unset($categories[$k]);
                    $flag = true;
                }
                else {
                    if( !empty($used_items[$category->parent]) ) {
                        $cat = new stdClass();
                        $cat->name = $category->name;
                        if(isset($_COOKIE['language']) && $_COOKIE['language'] === 'eng'){$cat->eng_name = $category->eng_name;}
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
            if (!$flag) $end = true;
        }

        $used_items = array_reverse($used_items, true);
        foreach($used_items as $k=>$item)
        {
            $used_items[$item->category_id]->subcats_ids[] = $item->category_id;
            if(isset($used_items[$item->parent]->subcats_ids) && is_array($used_items[$item->parent]->subcats_ids))
                $used_items[$item->parent]->subcats_ids =  array_merge($used_items[$item->parent]->subcats_ids, $item->subcats_ids);
            else{
                $used_items[$item->parent]->subcats_ids = $item->subcats_ids;
            }
        }
        return $tree;
    }


    // Функция возвращает рекурсивно подкатегории
    function category_by_url($categories, $url)
    {
        foreach ($categories as $category)
        {
            if ($category->url == $url)
            {
                return $category;
            }
            elseif (isset($category->subcategories) && is_array($category->subcategories))
            {
                if ($result = Storefront::category_by_url($category->subcategories, $url))
                {
                    return $result;
                }
            }
        }
        return false;
    }


    // Функция возвращает категории товаров, и их подкатегории
    function get_categories($parent=0) {
        // Выбираем все категории
        $query = sql_placeholder("SELECT * FROM categories WHERE enabled=1 ORDER BY parent, name, order_num LIMIT 500", $parent);
        $temp_categories = $this->db->results($query);
        $categories = Storefront::categories_tree($temp_categories);
        return $categories;
    }



    // Функция возвращает товары
    function get_products($ids = null, $categories = null, $brand_id = null, $start_item=null, $filter=null, $sort_by='') {
        // Если заданы id
        $id_filter = '';
        if (is_array($ids)) {
            foreach ($ids as $k=>$id) {
                $ids[$k]=intval($id);
            }
            $id_filter = is_null($ids)?"":"AND (p.product_id in(".join($ids, ',')."))";
            $enabled_filter = '';
        }
        else {
          $enabled_filter = " AND p.enabled=1 AND p.large_image <> ''";
        }


        // Если задан бренд, добавляем фильт по бренду
        $brand_filter = is_null($brand_id) ? "" : " AND brands.brand_id in ( " . (int)$brand_id . " ) ";

        if ( isset($filter['sex']) ) {
            $sex = (int)$filter['sex'];
            $brand_filter .= " AND ( p.sex = '{$sex}' OR p.sex = '0' ) ";
            unset($filter['sex']);
        }

        if ( isset($filter['not_sale']) ) {
            $brand_filter .= " AND ( p.old_price = 0 OR 2*p.price > p.old_price ) ";
            unset($filter['not_sale']);
        }

        if (!$this->items_per_page) {
          $this->items_per_page = 30;
        }

        $limit = is_null($start_item) ? " LIMIT {$this->items_per_page} " : " LIMIT {$start_item}, {$this->items_per_page} ";

        // Если пользователь залогиен, применим сразу его скидку к ценам на товар
        $discount=isset($this->user->discount)?$this->user->discount:0;

        // Фильтр по свойствам
        $properties_filter = '';
        if ($filter) {
            foreach($filter as $property=>$value) {
                $properties_filter .= sql_placeholder(" AND p.product_id in (SELECT properties_values.product_id FROM properties_values WHERE properties_values.product_id = p.product_id AND properties_values.value=? AND properties_values.property_id=?) ", $value, $property);
            }
        }


        if ($this->use_optional_categories) {
            //С дополнительными категориями

            // Если задана категория, добавляем фильт по категории
            $category_filter = is_null($categories)?"":"AND ( (categories.category_id in(".join($categories, ',').") ) OR (products_categories.category_id in(".join($categories, ',').") ) )";
            $fields = "SQL_CALC_FOUND_ROWS
                    p.product_id, p.url, p.model, p.category_id, p.brand_id, p.color_id, p.color_id, p.sku, p.price, p.old_price, p.offline_price, p.last_price, p.last_price_online, p.size, p.sex, p.season, p.season_type, p.text_sizes, p.eng_text_sizes, p.quantity, p.enabled, p.sold, p.small_image, p.large_image, p.bsize_small_image, p.bsize_large_image, p.item_location, p.special_sale, p.super_price, p.no_discount, p.fur_sale, p.video, p.show_out_of_stock,
                    DATE_FORMAT(p.created, '%Y-%m-%d') as created, DATE_FORMAT(p.modified, '%Y-%m-%d') as modified,
                    brands.name as brand, brands.url as brand_url,
                    categories.single_name as category, categories.eng_name, categories.eng_single_name, categories.url as category_url, categories.image as category_image, categories.enabled as category_enabled,
                    items.barcode,
                    p.price*(100-{$discount})/100 as discount_price";
            if($this->settings->theme == 'api'){
              $fields = "p.product_id, p.url, p.model, p.category_id, p.brand_id, p.price, p.old_price, p.size, p.sex, p.season, p.season_type, p.small_image, p.large_image, p.bsize_small_image, p.bsize_large_image, p.special_sale, p.super_price, p.no_discount, p.fur_sale, p.show_out_of_stock,
                    brands.name as brand,
                    categories.name as category, categories.eng_name, categories.eng_single_name";
            }
            $query = "SELECT {$fields}
                    FROM products p
                    LEFT JOIN categories ON categories.category_id = p.category_id
                    LEFT JOIN brands ON p.brand_id = brands.brand_id
                    LEFT JOIN products_categories ON p.product_id = products_categories.product_id
                    LEFT JOIN items ON p.product_id = items.product_id
                    WHERE 1 $enabled_filter
                    $id_filter $category_filter $brand_filter $properties_filter
                    GROUP BY p.product_id
                    ORDER BY {$sort_by} categories.order_num, p.order_num DESC
                    $limit";

        } else {
            //Без дополнительных категорий

            // Если задана категория, добавляем фильт по категории
            $category_filter = is_null($categories)?"":"AND (categories.category_id in(".join($categories, ',')."))";
            $fields = "SQL_CALC_FOUND_ROWS
                    p.product_id, p.url, p.model, p.category_id, p.brand_id, p.color_id, p.sku, p.price, p.old_price, p.offline_price, p.last_price, p.last_price_online, p.size, p.sex, p.season, p.season_type, p.text_sizes, p.eng_text_sizes, p.quantity, p.enabled, p.sold, p.small_image, p.large_image, p.bsize_small_image, p.bsize_large_image, p.item_location, p.special_sale, p.super_price, p.no_discount, p.fur_sale, p.video, p.show_out_of_stock,
                    DATE_FORMAT(p.created, '%Y-%m-%d') as created, DATE_FORMAT(p.modified, '%Y-%m-%d') as modified,
                    brands.name as brand, brands.url as brand_url,
                    categories.name as category, categories.eng_name, categories.eng_single_name, categories.url as category_url, categories.image as category_image, categories.enabled as category_enabled,
                    colors.name as color,
                    items.barcode,
                    p.price*(100-{$discount})/100 as discount_price";
            if($this->settings->theme == 'api'){
              $fields = "p.product_id, p.url, p.model, p.category_id, p.brand_id, p.price, p.old_price, p.size, p.sex, p.season, p.season_type, p.small_image, p.large_image, p.bsize_small_image, p.bsize_large_image, p.special_sale, p.super_price, p.no_discount, p.fur_sale, p.show_out_of_stock,
                    brands.name as brand,
                    categories.name as category, categories.eng_name, categories.eng_single_name";
            }

            $query = "SELECT {$fields}
                    FROM products p
                    LEFT JOIN categories ON categories.category_id = p.category_id
                    LEFT JOIN brands ON p.brand_id = brands.brand_id
                    LEFT JOIN colors ON p.color_id = colors.color_id
                    LEFT JOIN items ON p.product_id = items.product_id
                    WHERE 1 $enabled_filter
                    $id_filter $category_filter $brand_filter $properties_filter
                    GROUP BY p.product_id
                    ORDER BY {$sort_by} brand ASC, categories.order_num, price ASC, p.order_num DESC
                    $limit";
        }

        $products = $this->db->results($query);

        // Определяем цену со скидкой
        if ( is_array($products) && count($products)) {
            $s_user_id = !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0;
            if ($this->settings->theme == 'api') {
              $s_user_id = !empty($_GET['user_id']) ? $_GET['user_id'] : 0;
              $user = $this->db->result("SELECT * FROM users WHERE user_id = {$s_user_id}");
            }
            $user       = new luser(!empty($s_user_id));
            $image_link = 'https://lsboutique.ru';
            if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
            foreach ($products as $k=>$product) {
                $product->brand = trim($product->brand);
                $product->model = str_replace('"', "'", trim($product->model));
                $brand_name_short = str_replace(array('.', "'"), '', $product->brand);
                $brand_name_join  = str_replace(' ', '', $product->brand);
                $brands_names = array($product->brand, $brand_name_short,
                              strtolower($product->brand), strtoupper($product->brand), ucfirst($product->brand),ucwords($product->brand),
                              strtolower($brand_name_join), strtoupper($brand_name_join), ucfirst($brand_name_join),ucwords($brand_name_join));
                $product->category_name = trim(str_replace($brands_names, '', $product->model));
                if($_COOKIE['language'] === 'eng'){
                  $product->model = $product->eng_single_name . ' ' . $product->brand;
                  $product->category_name = str_replace('"', "'", $product->eng_single_name);
                  $product->category = $product->eng_name;
                  $product->text_sizes = $product->eng_text_sizes;
                  unset($product->eng_text_sizes);
                  $product->description = $product->body = $product->uhod = '';
                }
                $product->discount_value = $discount = $user->get_personal_discount($product, $user->get_sum_of_buy( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 ), !empty($_SESSION['group']->discount));
                if ( !empty($discount) && $product->old_price == 0 ) {
                    $product->discount_price = floor((100-$discount)*$product->price/100);
                }
                elseif ($product->old_price > 0) {
                    $product->sale_value = (1 - ($product->price/$product->old_price)) * 100;
                }
                if(preg_match('/боксеры|трусы|белье|купальник|плавки/i', mb_strtolower($product->model))){
                  $product->unreturnable = true;
                }
                $product_from_wl = $this->db->results($sql="SELECT * FROM users2wishlist WHERE product_id = '{$product->product_id}' AND user_id = '{$s_user_id}'");
                if($product_from_wl) $product->product_from_wl = true;
                else $product->product_from_wl = false;

                $cart = $this->db->result($sql="SELECT * FROM users2carts WHERE product_id = '{$product->product_id}' AND user_id = '{$s_user_id}'");
                if($cart) $product->product_from_cart = true;
                else $product->product_from_cart = false;

                $product->can_buy_from_site = $user->can_buy_from_site($product->brand_id);
                $product->prices = $user->product_prices($product, $_GET['currency'], $product->can_buy_from_site);

                // Отображение количества просмотров для админов
                if ($_SESSION['user']->group_id == 2 || $_SESSION['user']->group_id == 5 || $user->group_id == 2 || $user->group_id == 5) {
                  $product->product_views     = $this->db->result("SELECT `count`, `count_logged_in` FROM product_view_counters WHERE product_id = {$product->product_id}");
                }

                if($this->settings->theme == 'api'){
                  // Дополнительные фото товара
                  if ( $product->sex == 0 ) {

                      $female_images = $this->db->results("SELECT * FROM products_fotos WHERE product_id = {$product->product_id} AND female = 1");
                      if ($female_images && $user_sex == 2) {
                        $product->large_image = $female_images[0]->filename;
                        $product->small_image = $female_images[1]->filename;
                      }
                      $male_only = ($user_sex == 1) ? ' AND female = 0 ' : '';
                      $query = "SELECT * FROM products_fotos WHERE product_id = {$product->product_id} AND foto_id NOT IN (20,21) AND cover_photo=0 {$male_only} ORDER BY foto_id";
                  }
                  else {
                      $query = "SELECT * FROM products_fotos WHERE product_id = {$product->product_id} AND big_size=0 AND cover_photo=0 ORDER BY foto_id";
                  }
                  $product->fotos = $this->db->results($query);
                  if(empty($product->fotos)){$product->fotos = array();}
                  else{
                    foreach ($product->fotos as $foto){
                      $foto->filename = $image_link . '/reimg/files/products/560x/'.$foto->filename;
                      unset($foto->created,$foto->model_photo,$foto->cover_photo,$foto->foto_id,$foto->product_foto_id);
                    }
                  }

                  $product->url = 'https://lsboutique.ru/products/'.$product->url;

                  $product->small_image = $image_link . '/reimg/files/products/560x/'.$product->small_image;
                  $product->large_image = $image_link . '/reimg/files/products/560x/'.$product->large_image;
                  if(isset($_GET['big_size']) && $product->bsize_large_image != '')$product->small_image = $image_link . '/reimg/files/products/560x/'.$product->bsize_small_image;
                  if(isset($_GET['big_size']) && $product->bsize_small_image != '')$product->large_image = $image_link . '/reimg/files/products/560x/'.$product->bsize_large_image;

                  $product->prices = $user->product_prices_for_api($product, $_GET['currency'], $product->can_buy_from_site);

                  // Фильтр по магазинам
                  if ($_SESSION['user']->group_id <= 1 || $user->group_id <= 1) {
                    $shop_filter = "AND warehouse_id IN (SELECT warehouse_id FROM warehouses WHERE im_show=1)";
                  }
                  else {
                    $shop_filter = "";
                  }
                  $query = "SELECT size_id, size_type, size_system, size, shop_id
                              FROM items
                              WHERE quantity != 0 AND product_id={$product->product_id} {$shop_filter} GROUP BY size ORDER BY FIELD(size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+'), size + 0, size ASC ";

                  $product->sizes = $this->db->results($query);
                  $sizes_str = [];
                  foreach ($product->sizes as $size) {
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
                  $product->size = implode("|", $sizes_str);
                  unset($product->bsize_small_image,$product->bsize_large_image,$product->eng_name,$product->eng_single_name,$product->category);
                }
            }
        }
        return $products;
    }



    // Функция возвращает товар по url
    function get_product($product_url) {
        // Если пользователь залогиен, применим сразу его скидку к ценам на товар
        $discount=isset($this->user->discount)?$this->user->discount:0;

        // Контроль доступа к ограниченным брендам
        $s_user_id = $_SESSION['user']->user_id;
        if ($this->settings->theme == 'api') {
            $s_user_id = $_GET['user_id'];
        }
        $user       = new luser( !empty($s_user_id) ? $s_user_id : 0 );
        $brands_str = implode(",", $user->visible_brands($s_user_id));
        $squery = " AND b.brand_id IN ({$brands_str}) ";

        $tquery = '';
        if(strpos($product_url,'тест') !== false || strpos($product_url,'test') !== false)$tquery = " OR sku = 'testproduct'";

        $product = $this->db->result($sql="SELECT p.*, i.barcode,
                b.name as brand, b.url as brand_url, c.name as category_name, c.single_name as category, c.url as category_url, c.image as category_image, c.enabled as category_enabled, c.parent as category_parent, b.offline_only, b.hide_sizes,
                l.link as item_location_link, l.name as item_location_name
                FROM products p
                LEFT JOIN brands b ON p.brand_id = b.brand_id
                LEFT JOIN items i ON i.product_id = p.product_id
                LEFT JOIN categories c ON c.category_id = p.category_id
                LEFT JOIN locations2links l ON l.item_location = p.item_location AND l.sex = p.sex
                WHERE (p.url = '{$product_url}' OR p.product_id = '{$product_url}') 
                GROUP BY p.product_id
                LIMIT 1");

        if(preg_match('/боксеры|трусы|белье|купальник|плавки/i', mb_strtolower($product->model))){
          $product->unreturnable = true;
        }

        // Фильтр по магазинам
        if ($_SESSION['user']->group_id <= 1) {
          $shop_filter = "AND warehouse_id IN (SELECT warehouse_id FROM warehouses WHERE im_show=1)";
        }
        else {
          $shop_filter = "";
        }
        $query = "SELECT item_id, size_id, size_type, size_system, size, shop_id, barcode
                    FROM items
                    WHERE quantity != 0 AND product_id={$product->product_id} {$shop_filter} GROUP BY size ORDER BY FIELD(size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+'), size + 0, size ASC ";

        $product->sizes = $this->db->results($query);
        $sizes_str = [];
        foreach ($product->sizes as $size) {
          if($size->size_system == 'Европа (EU)'){$size->str_size = $size->size;}
          else{
          $size->str_size = $this->db->result("SELECT size FROM size_names WHERE size_id = {$size->size_id} AND size_m_s = '{$size->size_system}'")->size;
            if (!$size->str_size) {
              $size->str_size = $size->size;
            }
          }
          $sizes_str[] = $size->str_size;
          $shop_name = $this->db->result("SELECT name FROM shops WHERE shop_id = {$size->shop_id}")->name;
          $op_status = $this->db->result("SELECT status FROM orders_products WHERE barcode = '{$size->barcode}' ORDER BY id DESC")->status;
          if ($shop_name == "Интернет-Магазин" && $op_status === "4") {
            $size->remote_warehouse = "return";
          }
          elseif ($shop_name == "Интернет-Магазин" && $op_status === "0") {
            $size->remote_warehouse = "chance";
          }
          else {
            $size->remote_warehouse = 0;
          }
        }
        $sizes_str = array_unique($sizes_str);
        $product->size = implode("|", $sizes_str);
        // Временно показываем одну линейку для всех размеров
        $product->size_system = $product->sizes[0]->size_system;
        if($_COOKIE['language'] === 'eng' && $product->size_system != 'int' && $product->size_system != 'ru'){
          $product->size_system = $this->db->result($sql="SELECT eng_size_m_s FROM size_names WHERE size_m_s = '{$product->sizes[0]->size_system}' LIMIT 1")->eng_size_m_s;
        }
        switch ($product->size_system) {
          case 'int':
            if($_COOKIE['language'] === 'eng'){$product->size_system = 'International (INT)';}
            else{$product->size_system = "Международный (INT)";}
            break;
          case 'ru':
            if($_COOKIE['language'] === 'eng'){$product->size_system = 'Russia (RUS)';}
            else{$product->size_system = "Россия (RUS)";}
            break;
        }

        //убираем пустые строки, которые добавили из админки
        if($_COOKIE['language'] === 'eng'){
          $product->description   = strip_custom_tags($product->eng_description);
          $product->body = str_replace('<p>&nbsp;</p>', '', $product->eng_body);
          $product->uhod = str_replace('<p>&nbsp;</p>', '', $product->eng_uhod);
          $product->text_sizes = str_replace('<p>&nbsp;</p>', '', $product->eng_text_sizes);
        }
        else{
          $product->description   = strip_custom_tags($product->description);
          $product->body = str_replace('<p>&nbsp;</p>', '', $product->body);
          $product->uhod = str_replace('<p>&nbsp;</p>', '', $product->uhod);
          $product->text_sizes = str_replace('<p>&nbsp;</p>', '', $product->text_sizes);
        }
        $product->text_sizes    = strip_custom_tags($product->text_sizes);


        // Поменять названия магазинов
        $product->item_location_name = str_replace( array("Podium VIP", "Podium Элита"), array("Лакшери ПЛАЗА", "Лакшери ЭТАЖИ"), $product->item_location_name );
        if(empty($product))
          return false;

        // связанные товары
        $products = array();
        //$query = sql_placeholder('SELECT products.product_id FROM products, related_products WHERE (products.sku=related_products.related_sku OR products.product_id=related_products.related_sku) AND related_products.product_id = ?', $product->product_id);
        $related = $this->db->results("SELECT related_sku FROM related_products WHERE product_id={$product->product_id}");
        if (empty($related)) {
            $related = $this->db->results(sql_placeholder('SELECT product_id FROM products WHERE products.category_id=? AND products.sex=? AND product_id != ? AND size != "" AND enabled=1 ORDER BY FIELD(products.brand_id, ?) DESC, products.product_id DESC LIMIT 12', $product->category_id, $product->sex, $product->product_id, $product->brand_id));
        }
        if (empty($related)) {
            $related = $this->db->results(sql_placeholder('SELECT product_id FROM products WHERE products.color_id=? AND products.sex=? AND product_id != ? AND size != "" AND enabled=1 ORDER BY products.product_id DESC LIMIT 12', $product->color_id,$product->sex,$product->product_id));
        }
        $rel_ids = array();
        foreach ($related as $r) {
            $rel_ids[] = $r->product_id;
        }

        if (count($rel_ids)>0) {
            $sort_by = "FIELD(products.brand_id, {$product->brand_id}) DESC,";
            $rproducts = $this->get_products($rel_ids, null, null, null, null, $sort_by);
        }
        else {
            $rproducts = array();
        }

        if (is_array($rproducts) && count($rproducts)>0) {
            foreach ($rproducts as $k=>$v) {
                $rproducts[$k]->size       = str_replace("|", ", ", trim($rproducts[$k]->size, "|"));
                $v->sale_icon = '';
                if ($product->old_price != 0){
                    $sale_name = 'sale' . round((1 - ($product->price/$product->old_price)) * 100, -1);
                    $v->sale_icon = $this->settings->$sale_name;
                }
            }
        }

        $product->related_products = $rproducts;

        // параметры товара
        $product->properties = $this->db->results("SELECT pr.name as name, prv.value as value
                                                      FROM properties pr
                                                      INNER JOIN properties_values prv ON prv.property_id = pr.property_id
                                                    WHERE prv.product_id = {$product->product_id} AND enabled AND in_product
                                                    ORDER BY pr.order_num");

        // чикухи материалов
        $name = 's_materials.name';
        if($_COOKIE['language'] === 'eng'){$name = 's_materials.eng_name AS name';}
        $product->materials = $this->db->results("SELECT {$name}, s_materials.description FROM s_materials
                                  LEFT JOIN products_materials ON products_materials.material_id = s_materials.material_id
                                  WHERE products_materials.product_id = {$product->product_id}");
        if (!empty($product->properties)){
            $product->is_sale = $product->properties[3]->value == 'Sale';
        }
        else{$product->properties = array();}
        return $product;
    }



    // Функция возвращает дерево категорий с товарами
    function get_catalog()
    {
        // Выбираем все категории
        $query = sql_placeholder("SELECT * FROM categories WHERE enabled=1 ORDER BY parent, order_num LIMIT 500", $parent);
        $this->db->query($query);
        $temp_categories = $this->db->results();

        foreach($temp_categories as $temp_category)
            $categories[$temp_category->category_id] = $temp_category;

        $categories = Storefront::categories_tree($categories);

        return $categories;
    }

    // Функция добывает для нас товары из несфотографированных остатков
    function get_stock($stock_url)
    {
        $query = sql_placeholder("SELECT * FROM ostatki WHERE url = ?", $stock_url);
        $this->db->query($query);
        $rr = $this->db->result($query);
        if (!$rr) {
            $query = sql_placeholder("SELECT * FROM prodazhi WHERE url = ?", $stock_url);
            $this->db->query($query);
            $rr = $this->db->result($query);
            $rr->size = '';
        }
        return $rr;
    }



    // Функция возвращает рекурсивно подкатегории
    function category_by_id($categories, $id) {
        if ( is_array($categories) && count($categories) )
        foreach($categories as $category) {
            if ($category->category_id == $id) {
                return $category;
            }
            else
            if (is_array($category->subcategories)) {
                if($result =  Storefront::category_by_id($category->subcategories, $id))
                return $result;
            }
        }
        return false;
    }

    function set_info($product_id) {
      if ( !empty($product_id) ){
        $set = $this->db->result("SELECT * FROM sets WHERE main_product_id = {$product_id}");
        if(empty($set)){
          $set_id = $this->db->result("SELECT set_id FROM sets_products WHERE product_id = {$product_id}")->set_id;
          if(!empty($set_id))$set = $this->db->result("SELECT * FROM sets WHERE id = {$set_id}");
        }
        if(!empty($set)){
          $main_product = $this->db->result($sql="SELECT product_id FROM products WHERE product_id = {$set->main_product_id} AND large_image !='' AND product_id != {$product_id}");
          $items = $this->db->results("SELECT p.product_id as product_id
            FROM products p
            LEFT JOIN sets_products sp ON p.product_id = sp.product_id
            WHERE sp.set_id = {$set->id} AND p.large_image !='' AND p.large_image !='' AND p.product_id != {$product_id}");
          if ($main_product) {
            array_unshift($items, $main_product);
          }
          foreach ($items as $item) $ids[]=$item->product_id;
          $return->set = Storefront::get_products($ids);
        }
        else {$return = array();}
      }
      $return = json_encode($return);
      header('Content-Type: application/json');
      echo $return;
      die;
    }
}
