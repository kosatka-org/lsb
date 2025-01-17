<?PHP

require_once('Widget.class.php');

class StaticPage extends Widget
{

    /**
     *
     * Конструктор
     *
     */
    function StaticPage(&$parent)
    {
        Widget::Widget($parent);
    }


    /**
     *
     * Отображение
     *
     */
    function fetch()
    {
        // url страницы
        $section_url = $this->url_filtered_param('section');
        $section_id  = $this->url_filtered_param('section_id');
        $user_id     = $this->url_filtered_param('user_id');
        $mw = (int)$this->url_filtered_param('sex') ? (int)$this->url_filtered_param('sex') : $_COOKIE['sex'];
        setcookie('sex', $mw, time()+60*60*24*365, '/');
        $_COOKIE['sex']=$mw;


        if ($this->settings->theme == 'api' && !isset($_GET['banners']) && !isset($_GET['mainpage'])){
          if ( $_COOKIE['language'] == 'eng' ){
            $ids = array(174=>184,181=>183,161=>182);
            $section_id = $ids[$section_id];
          }
            $query = sql_placeholder("SELECT section_id, name, header, body
                                FROM sections
                                WHERE section_id = ? LIMIT 1", $section_id);
        }
        else{
            $query = sql_placeholder("SELECT sections.*
                                FROM sections
                                WHERE enabled=1 AND sections.url = ? LIMIT 1", $section_url);
        }
        $this->db->query($query);
        $page = $this->db->result();

        if (!$page) {
            // return false приводит к отображению ошибки 404
            return false;
        }

        // Определяем уровень пользователя
        $s_user_id = !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0;
        if ($this->settings->theme == 'api') {
            $s_user_id = $user_id;
            $user = $this->db->result("SELECT * FROM users WHERE user_id = {$s_user_id}");
        }
        $user_level = 1;
        if (!empty($_SESSION['user']->purchase_sum_real) || !empty($user->purchase_sum_real)) {
            $user_level = 3;
        }
        elseif (!empty($s_user_id)) {
            $user_level = 2;
        }
        $luser = new luser( !empty($s_user_id) ? $s_user_id : 0 );

        // показывать скрытые бренды только избранным
        $brands_str = implode(",", luser::visible_brands($s_user_id));
        
        if ($this->settings->theme == 'api' && isset($_GET['mainpage'])) {
          $gender_query = $mw ? "IN (0,".$mw.")" : "IN (0,1,2,3)";
          $return->storis = array();
          $return->new_season = $this->db->results($sql="SELECT p.product_id, p.sku, p.model, p.size, p.old_price, p.price, p.super_price, p.brand_id, p.season_type, p.no_discount, CONCAT('https://lsboutique.ru/reimg/files/products/560x/', p.large_image) as large_image, b.name as brand, b.offline_only as offline_only, b.hide_sizes as hide_sizes, b.golden_sale as golden_sale, b.no_sale as no_sale, b.show_delta as show_delta, c.name as category, c.parent as parent, c.enabled as cat_enabled
                    FROM products p
                    LEFT JOIN categories c ON c.category_id = p.category_id
                    LEFT JOIN brands b    ON b.brand_id = p.brand_id
                  WHERE  p.enabled = 1  AND (p.season_type IN ('new_season', 'previous_season', 'next_season'))  AND (sex = '0' OR sex = '{$mw}')  AND p.size <> ''  AND p.large_image <> ''  AND b.brand_id IN ({$brands_str})  AND (EXISTS (SELECT 1 FROM items i WHERE i.product_id = p.product_id AND i.quantity != 0  ) OR p.show_out_of_stock = 1) 
                  ORDER BY  p.photo_added DESC LIMIT 10");
          foreach($return->new_season as $product){
            $product->can_buy_from_site = $luser->can_buy_from_site($product->brand_id);
            $product->prices = $luser->product_prices_for_api($product, $_GET['currency'], $product->can_buy_from_site);
          }
          
          $banners = $this->db->results("SELECT * FROM banners WHERE enabled=1 AND sex ".$gender_query." AND user_level <= {$user_level} AND (brand_id IN ({$brands_str}) OR brand_id IS NULL) ORDER BY position");
          $return->banners = $this->sort_banners($banners);
          
          $return->sets = $this->db->results("SELECT CONCAT('https://lsboutique.ru/reimg/files/products/340x/', s.image) as image, s.id, s.main_product_id
                  FROM sets s
                  LEFT JOIN sets_products sp ON sp.set_id = s.id
                  WHERE image != '' 
                   AND (s.main_product_id IN (SELECT products.product_id
                            FROM products
                            LEFT JOIN items ON items.product_id = products.product_id
                            LEFT JOIN brands ON brands.brand_id = products.brand_id
                            WHERE 1  AND products.size <> ''  AND products.enabled=1  AND products.large_image <> ''  AND (products.sex = '0' OR products.sex = '{$mw}')  AND products.brand_id IN ({$brands_str}) ) 
                            OR 
                            sp.product_id IN (SELECT products.product_id
                            FROM products
                            LEFT JOIN items ON items.product_id = products.product_id
                            LEFT JOIN brands ON brands.brand_id = products.brand_id
                            WHERE 1  AND products.size <> ''  AND products.enabled=1  AND products.large_image <> ''  AND (products.sex = '0' OR products.sex = '{$mw}')  AND products.brand_id IN ({$brands_str}) ))   
                  AND EXISTS (SELECT 1 FROM sets_products WHERE sets_products.set_id = s.id) GROUP BY s.id ORDER BY id DESC LIMIT 10");
          foreach ($return->sets as $index => $set) {
                $products = array();
                $main_product = $this->db->result("SELECT p.model, p.product_id, c.eng_name AS eng_cat, c.eng_single_name AS cat_eng_name, b.name AS brand_name FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN brands b ON p.brand_id = b.brand_id WHERE p.product_id = {$set->main_product_id}");
                $products[] = $main_product;
                $other_products = $this->db->results("SELECT p.model, p.product_id, sp.*, c.eng_name AS eng_cat, c.eng_single_name AS cat_eng_name, b.name AS brand_name FROM products p LEFT JOIN sets_products sp ON p.product_id = sp.product_id LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN brands b ON p.brand_id = b.brand_id WHERE sp.set_id = {$set->id}");
                $products = array_merge($products, $other_products);
                if($_COOKIE['language'] === 'eng'){
                  foreach($products as $k=>$p){
                    if($p->category_id == 97 && $mw == 1){$p->cat_eng_name = 'Oxford shoes';}
                    $products[$k]->model = $p->cat_eng_name . ' ' . $p->brand_name;
                    $set->name = $main_product->cat_eng_name .' '. $main_product->brand_name .' - '.$main_product->sku;
                  }
                }
                $set->products = $products;
          }
          
          $return->brands = $this->db->results("
                SELECT b.name, b.brand_id, CONCAT('https://lsboutique.ru/images/loggoss/', b.app_image) as banner, b.meta_title AS title, b.gender AS sex
                  FROM brands b
                  INNER JOIN products p ON b.brand_id = p.brand_id AND p.size != '' AND p.sex {$gender_query}
                WHERE gender {$gender_query} AND b.show_on_main = 1 AND b.brand_id IN ({$brands_str})
                GROUP BY b.brand_id
                ORDER BY FIELD(b.position, '1', '2', '3', '4', '5', '6', '7', '8', '0'), b.name ASC");
            
          $return = json_encode($return);
          header('Content-Type: application/json');
          echo $return;
          die;
        }


        if ($page->section_id == 161 || $page->section_id == 182) {// Если страница доставки и оплаты
            $tmp_url = parse_url($_SERVER['REQUEST_URI']);
            parse_str( !empty($tmp_url['query']) ? $tmp_url['query'] : '', $tmp_get);
            $region_on_city_page = !empty($tmp_get['REGION']) ? $tmp_get['REGION'] : '';

            if ( isset($region_on_city_page) ) {
                $region = explode(',', $region_on_city_page);
                if ( isset($region[1]) && $region[1] == '209' ) {
                    if ( $region[2] ) {
                        $city = $this->db->result("SELECT url, image, image_right FROM cities WHERE city_id = {$region[2]} LIMIT 1");
                }
                $redirect_city_url = ($city->url) ? '/city/'.$city->url : '/sections/shipping';
                header("HTTP/1.1 301 Moved Permanently");
                header("Location: {$redirect_city_url}/");
                die('ok');
            }
        }
            $query = "SELECT * FROM delivery_methods WHERE enabled=1";
            $this->db->query($query);
            $delivery = $this->db->results();

            $query = "SELECT * FROM payment_methods WHERE enabled=1";
            $this->db->query($query);
            $payment = $this->db->results();

            $this->smarty->assign('delivery', $delivery);
            $this->smarty->assign('payment', $payment);

            if ($page->section_id != 182) {
              $query = " SELECT cities.name, SUBSTR(cities.name,1,1) AS f_letter, cities.city_id, delivery_cities.region_id, cities.url FROM cities
                  LEFT JOIN delivery_cities ON cities.city_id = delivery_cities.city_id
                  WHERE cities.visible = 1  ORDER BY cities.name";
              $delivery_cities = $this->db->results($query);
              $del_cities_sorted = array();
              $frst_l = '';
              $col = round(count($delivery_cities)/4);
              foreach($delivery_cities as $k=>$ds){
                if($frst_l != $ds->f_letter){
                  $frst_l = $ds->f_letter;
                }
                $del_cities_sorted[$k/$col][$frst_l][] = $ds;
              }
              $this->smarty->assign('big_cities',  array(642,992,1054,893) );
              $this->smarty->assign('del_cities_sorted',  $del_cities_sorted );
              $this->smarty->assign('delivery_cities',    $delivery_cities );
            }
            if ($this->settings->theme == 'api') {
                $texts = explode('<div class="ShAA_staticPageChange"><h1 style="font-weight: 500;">', $this->db->result("SELECT body FROM sections WHERE section_id = 161")->body);
                $search = array("<p>&nbsp;</p>","<span>&nbsp;</span>",'<p class="MsoNormal"></p>',"&nbsp;", "\n", "\r", "“",'"',"'", "</p>", "\x08", "\x0c", "\"");
                $replace = array(' ', ' ', ' ', ' ', ' ', ' ', '', '', '', '\n ', "\\f", "\\b", "\\\"");
                $pattern = '/[\x00-\x1F\x7F]/u';
                foreach($delivery as $del){
                    $del->image = $del->image ? '/files/deliveries/'.$del->image : '';
                    $del->description =  preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $del->description))),'\n'));
                    unset($del->enabled);
                }
                foreach($payment as $pay){
                    $pay->image = $pay->image ? '/files/payments/'.$pay->image : '';
                    $pay->description = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $pay->description))),'\n'));
                    unset($pay->module, $pay->currency_id, $pay->is_local, $pay->params, $pay->enabled);
                }
                $return->section_id = $page->section_id;
                $return->name = $page->name;
                $return->header = $page->header;
                $return->delivery_methods = $delivery;
                $return->payment_methods = $payment;
                $return->return_text = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $texts[1]))),'\n'));
                $return->license_text = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $texts[0]))),'\n'));
                $return = json_encode($return);
                header('Content-Type: application/json');
                echo $return;
                die;
            }
            $this->body = $this->smarty->fetch('cities_select.tpl');
        }
        elseif ($page->section_id == 160) { // Если главная
            if ($_SERVER['SERVER_NAME'] != 'luxurystore.pro') {
                // Подборки товаров
                $gender_query = $mw ? "IN (0,".$mw.")" : "IN (0,1,2,3)";
                $query = sql_placeholder("SELECT * FROM specials WHERE enabled=1 AND gender ".$gender_query);
                $this->db->query($query);
                $specials = $this->db->results();

                if (count($specials) <= 3) {
                  $this->smarty->assign('specials', $specials);
                }
                else {
                  $rand_keys = array_rand($specials, 3);
                  $specials_rand = array();
                  foreach ($rand_keys as $rk) {
                    $specials_rand[] = $specials[$rk];
                  }
                  $this->smarty->assign('specials', $specials_rand);
                }
            }

            $banners = $this->db->results("SELECT * FROM banners WHERE enabled=1 AND sex ".$gender_query." AND user_level <= {$user_level} AND (brand_id IN ({$brands_str}) OR brand_id IS NULL) ORDER BY position");
            $this->smarty->assign("banners", $banners);

            // Центральный баннер бренда
            $suffix = '';
            if (isset($mw)) {
                $suffix = ($mw == 2) ? "_w" : "_m";
                if ( $_COOKIE['language'] == 'eng' ) $suffix .= '_eng';
                $squery = "products.sex = {$mw} AND brands.banner{$suffix} != ''";
            }
            else {
                if ( $_COOKIE['language'] == 'eng' ) $suffix = '_eng';
                $squery = " (brands.banner_w{$suffix} != '' OR brands.banner_m{$suffix} != '') ";
            }
            $squery = $squery . " AND products.enabled = 1 AND products.size != '' ";

            $squery    .= " AND brands.brand_id IN ({$brands_str}) ";

            $banner_obj = $this->db->results( "SELECT brands.name AS name,
                brands.url AS url,
                brands.brand_id AS brand_id,
                brands.banner_w AS banner_w,
                brands.banner_m AS banner_m,
                brands.banner_w_eng AS banner_w_eng,
                brands.banner_m_eng AS banner_m_eng,
                brands.banner_w_r AS banner_w_r,
                brands.banner_m_r AS banner_m_r,
                brands.banner_w_eng_r AS banner_w_eng_r,
                brands.banner_m_eng_r AS banner_m_eng_r,
                brands.meta_title AS title,
                products.sex AS mw,
                MAX( products.photo_added ) AS photo_added
                FROM products
                LEFT JOIN brands ON products.brand_id = brands.brand_id
                LEFT JOIN banners ON products.brand_id = banners.brand_id
                WHERE {$squery} AND NOT (banners.brand_id IS NOT NULL AND banners.sex IN (0,products.sex) AND banners.enabled = 1)
                GROUP BY brands.name
                ORDER BY photo_added DESC
                LIMIT 12" );
            $even = true;
            foreach ($banner_obj as $i => $b) {
              if ( !isset($mw) ) {
                if ( $_COOKIE['language'] == 'eng' ) $suffix = '_eng';
                $s = $even ? "banner_m".$suffix.'_r' : "banner_m".$suffix;
                if (empty($b->$s)) $s = $even ? "banner_w".$suffix.'_r' : "banner_w".$suffix;
                $banner_obj[$i]->banner = $b->$s;
              }
              else {
                $s = $even ? "banner".$suffix.'_r' : "banner".$suffix;
                $banner_obj[$i]->banner = $b->$s;
              }
              $even = !$even;
            }


            $this->smarty->assign('banner_obj', $banner_obj);

            if ( $mw != 1 && $mw != 2 ) {
                $gender_query = " IN (0,1,2) ";
            }
            $brands = $this->db->results("
                SELECT b.*
                  FROM brands b
                  INNER JOIN products p ON b.brand_id = p.brand_id AND p.size != '' AND p.sex {$gender_query}
                WHERE gender {$gender_query} AND b.show_on_main = 1 AND b.brand_id IN ({$brands_str})
                GROUP BY b.brand_id
                ORDER BY FIELD(b.position, '1', '2', '3', '4', '5', '6', '7', '8', '0'), b.name ASC");
            $this->smarty->assign("brands", $brands);

            $video = $this->db->results("SELECT video FROM `adv_video` WHERE video !='' ORDER BY id");
            if(count($video) < 16){
              $lim = 16 - count($video);
              $videos_ = $this->db->results("SELECT video, SUBSTRING(video,-11) AS v_id FROM products WHERE video !='' GROUP BY v_id ORDER BY video_added DESC LIMIT {$lim}");
              $video = array_merge($video,$videos_);
            }
            foreach($video as $vid){
              preg_match('%(?:youtube(?:-nocookie)?\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/ ]{11})%i', $vid->video, $match);
              $vid->youtube_id = $match[1];
            }
            $this->smarty->assign("video", $video);

            if ($this->settings->theme == 'api' && isset($_GET['banners'])) {
                $bannersw->banner_obj = $this->sort_banners($banners, $banner_obj, $brands);
                if($this->settings->theme_v == 'v2'){
                  $return->obj = $bannersw->banner_obj;
                  $return = $this->format_api_response($return);
                }
                else{$return = $bannersw;}
                $return = json_encode($return);
                header('Content-Type: application/json');
                echo $return;
                die();
            }

        }
        if ($this->settings->theme == 'api') {
            $search = array("<p>&nbsp;</p>","<span>&nbsp;</span>",'<p class="MsoNormal"></p>',"&nbsp;", "\n", "\r", "“",'"',"'", "</p>", "\x08", "\x0c", "\"");
            $replace = array('\n', ' ', '\n', ' ', '', '', '', '', '', '\n', "\\f", "\\b", "\\\"");
            $pattern = '/[\x00-\x1F\x7F]/u';
            $page->body = preg_replace($pattern, '', trim(trim(strip_tags(str_replace($search, $replace, $page->body))),'\n'));
            $return = json_encode($page);
            header('Content-Type: application/json');
            echo $return;
            die;
        }

        // Метатеги
        $this->title = $page->meta_title;
        $this->keywords = $page->meta_keywords;
        $this->description = $page->meta_description;

        // Передаем в шаблон
        $this->smarty->assign('page', $page);
        $this->smarty->assign('manOrWoman', $mw);
        $this->body = $this->smarty->fetch('static_page.tpl');
        return $this->body;
    }
    
    public function sort_banners ($banners, $banner_obj, $brands){
      $i=0;
      $bobj=array();
      $image_link = 'https://lsboutique.ru';
      if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
      if(!empty($banners)){
        foreach($banners as $banner){
          if(strpos($banner->url, 'ru.lsboutique.ru') !== false && $_COOKIE['language'] === 'eng')continue;
            if(!in_array($banner->id,array(119,82))){
                if(strpos($banner->url, '?category=') !== false){
                    $banner->category_id = substr($banner->url, strpos($banner->url, '?category=')+10);
                    if(strpos($banner->category_id, '&') !== false){
                        $banner->category_id = strstr($banner->category_id, '&', true);
                    }
                    $banner->call = 'category';
                }
                elseif(strpos($banner->url, 'goods') !== false){
                    $cq = trim(substr($banner->url, strpos($banner->url, 'goods')+6),'/');
                    $banner->category_id = $this->db->result("SELECT category_id FROM goods WHERE url = '{$cq}'")->category_id;
                    $banner->call = 'brand-category';
                }
                elseif(strpos($banner->url, 'specials') !== false){
                    $cq = trim(substr($banner->url, strpos($banner->url, 'specials')+9),'/');
                    $banner->special_id = $this->db->result("SELECT special_id FROM specials WHERE url = '{$cq}'")->special_id;
                    $banner->call = 'special';
                    if(strpos($banner->url, 'look_specials') !== false){
                      $banner->type = 'look_specials';
                      $banner->call = 'look_special';
                    }
                }
                elseif(strpos($banner->url, 'news') !== false){
                    $cq = trim(substr($banner->url, strpos($banner->url, 'news')+5),'/');
                    $banner->news_id = $this->db->result("SELECT news_id FROM news WHERE url = '{$cq}'")->news_id;
                    $banner->call = 'news';
                }
                elseif(strpos($banner->url, '//lsboutique.ru') === false || $banner->id == 244){$banner->call = 'outer';}
                else{$banner->call = 'brand';}

                $bobj[$i]->name =        ($_COOKIE['language'] === 'eng' && !empty($banner->eng_title)) ? $banner->eng_title : $banner->title;
                $bobj[$i]->brand_id =    $banner->brand_id;
                $bobj[$i]->special_id =  $banner->special_id;
                $bobj[$i]->category_id = $banner->category_id;
                $bobj[$i]->news_id = 	   $banner->news_id;
                $bobj[$i]->banner =      ($_COOKIE['language'] === 'eng') ? $image_link . '/files/banners/'.$banner->eng_image : $image_link . '/files/banners/'.$banner->image;
                $bobj[$i]->title =       ($_COOKIE['language'] === 'eng' && !empty($banner->eng_title)) ? $banner->eng_title : $banner->title;
                $bobj[$i]->sex =         $banner->sex;
                $bobj[$i]->url =         (strpos($banner->url, '//lsboutique.ru') === false || $banner->id == 244) ? $banner->url : null;
                $bobj[$i]->type =        isset($banner->type) ? $banner->type : 'banner';
                $bobj[$i]->call =        isset($banner->call) ? $banner->call : '';
                $i++;
            }
          }
        }
        if(!empty($banner_obj)){
          foreach($banner_obj as $banner){
              $bobj[$i]->name =        $banner->name;
              $bobj[$i]->brand_id =    $banner->brand_id;
              $bobj[$i]->special_id =  null;
              $bobj[$i]->category_id = null;
              $bobj[$i]->news_id = 	   null;
              $bobj[$i]->banner =      $image_link . '/files/brand_banners/'.$banner->banner;
              $bobj[$i]->title =       ($_COOKIE['language'] === 'eng') ? $banner->name : $banner->title;
              $bobj[$i]->sex =         $banner->mw;
              $bobj[$i]->url =         null;
              $bobj[$i]->type =        'banner';
              $bobj[$i]->call =        'brand';
              $i++;
          }
        }
        if(!empty($brands)){
          foreach($brands as $brand){
              $bobj[$i]->name =        $brand->name;
              $bobj[$i]->brand_id =    $brand->brand_id;
              $bobj[$i]->special_id =  null;
              $bobj[$i]->category_id = null;
              $bobj[$i]->news_id = 	   null;
              $bobj[$i]->banner =      'https://lsboutique.ru/images/loggoss/'.$brand->app_image;
              $bobj[$i]->title =       $brand->meta_title;
              $bobj[$i]->sex =         $brand->gender;
              $bobj[$i]->url =         null;
              $bobj[$i]->type =        'brand';
              $bobj[$i]->call =        'brand';
              $i++;
          }
        }
      return $bobj;
    }
}
