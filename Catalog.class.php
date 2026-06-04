<?PHP

require_once('Widget.class.php');
class Catalog extends Widget
{
    var $items_per_page = 5; // Количество товаров на странице
    var $use_optional_categories = true; // Использовать допкатегории
    var $categories = array();
    var $error = '';
    var $cols  = 3;
    var $words_cols  = 3;

    function Catalog($parent) {
        Widget::Widget($parent);
        if ( isset($_COOKIE['new_user']) && $_COOKIE['new_user'] == 1 || isset($_GET['new_user']) ) { // Второй раз зашел
            setcookie("new_user", '2', time()+3600*24*365*10, '/'); // Фиксируем второй заход в каталог
            if ( (empty($_SESSION['user']) || empty($_COOKIE['sex']) || isset($_GET['new_user'])) && empty($_GET['sex']) ) { // Покажем welcome-screen
                $this->smarty->assign('new_user', 1);
            }
        }
        if ( empty($_COOKIE['new_user']) ) { // Первый раз зашел в каталог
            setcookie("new_user", '1', time()+3600*24*365*10, '/');
        }
        if ( !empty($_SESSION['1click_purchase_data']) ) {
            $this->smarty->assign('purchase_data', $_SESSION['1click_purchase_data']);
            unset($_SESSION['1click_purchase_data']);
        }
    }

    // Отображение
    function fetch() {
        if ($this->url_filtered_param('copy_products_by_sku')) {
            $this->copy_products_by_sku();
            die();
        }


        // Все возможные GET-параметры. Фильтруем для безопасности
        $category       = $this->url_filtered_param('category');
        $category_url   = $this->url_filtered_param('category_url');
        $brand_url      = $this->url_filtered_param('brand_url');
        $special_url    = $this->url_filtered_param('special_url');
        $search         = $this->url_filtered_param('search');
        $brand          = $this->url_filtered_param('brand');
        $goods          = $this->url_filtered_param('goods');
        $showbrand      = $this->url_filtered_param('showbrand');
        $special        = $this->url_filtered_param('special');
        $mobile_mw      = $this->url_filtered_param('enter_mobile');
        $show_all       = $this->url_filtered_param('show_all');

		//если нажали 'все' в переключателе пола
		if(isset($_GET['allsex'])) {
			setcookie('sex', '0', time()+60*60*24*365, '/');
			$_COOKIE['sex'] = 0;
		}

        $mw             = (int)$this->url_filtered_param('sex') ? (int)$this->url_filtered_param('sex') : ($this->url_filtered_param('enter_mobile') ? $this->url_filtered_param('enter_mobile') : $_COOKIE['sex']);
        $from           = $this->url_filtered_param('from');
        $leaving        = $this->url_filtered_param('leaving');
        $P_id           = $this->url_filtered_param('p_id');
        $page           = $this->url_filtered_param('page');
        $tip_s          = $this->url_filtered_param('tip_search');
        $limit_ovr      = $this->url_filtered_param('limit');
        $mf = ($mw == 2) ? "_woman" : "_man";//for ecommerce list

        if($this->settings->theme == 'api'){
            $filters_only   = isset($_GET['filters_only']) ? true : false;
            $fisizes        = !empty($_GET['sizes'])     ? preg_split("/,(?!5)/", $_GET['sizes']) : '';
            $fisize_ids     = !empty($_GET['size_ids'])  ? explode(',', $_GET['size_ids']) : '';
            $fimats         = !empty($_GET['materials']) ? explode(',', $_GET['materials']) : '';
            $fibrands       = !empty($_GET['brands'])    ? explode(',', $_GET['brands']) : '';
            $ficats         = !empty($_GET['cats'])      ? explode(',', $_GET['cats']) : '';
        }

        if (!empty($leaving) && !empty($P_id)) {
            $set_id = $this->db->result("SELECT id FROM sets WHERE main_product_id = {$P_id}")->id;
            $set_products = $this->db->results("SELECT * FROM sets_products sp
                                LEFT JOIN products p ON sp.product_id = p.product_id
                                WHERE sp.set_id = {$set_id} AND sp.product_id != {$P_id}
                                LIMIT 3");

            $this->smarty->assign('set', $set_products);
            $this->body = $this->smarty->fetch('leaving.tpl');
            echo $this->body;
            die();
        }

        if (isset($tip_s) && !empty($tip_s)) {
            $tip_s = mysql_real_escape_string(trim($tip_s));
            if(mb_strlen($tip_s) > 6){$tip_s = mb_substr($tip_s, 0, -1);}
            $s_user_id = $_GET['user_id'];
            $brands_str = implode(",", luser::visible_brands($s_user_id));

            $results = $this->db->results("(SELECT name FROM `brands` WHERE  brand_id IN ({$brands_str}) AND name LIKE '%".$tip_s."%' LIMIT 3)
                                                        UNION ALL
                                                   (SELECT categories.name AS name FROM `products` LEFT JOIN categories ON categories.category_id = products.category_id WHERE categories.name LIKE '%".$tip_s."%' AND products.brand_id IN ({$brands_str}) AND products.size <> '' AND products.enabled=1 AND products.large_image <> '' GROUP BY products.category_id ORDER BY name ASC)
                                                   ORDER BY name;");
            foreach($results as $res){
              $res->name = trim(trim($res->name),'.,');
            }
            if($this->settings->theme_v == 'v2'){
              $r->obj = array_unique($results,SORT_REGULAR);
              $return = $this->format_api_response($r);
            }
            else{$return->results = array_unique($results,SORT_REGULAR);}

            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
            die();
        }

        $log_search = false;
        if ( !empty($search) ) {
            $search = trim($search);
            $search_tmp = mb_strtolower( $search, 'UTF-8');
            $search_replace_array = array(
                'платья'            => 'платье',
                'польто'            => 'пальто',
                'веспуччи'          => 'vespucci',
                'versachi'          => 'versace',
                'lord piano'        => 'Loro Piana',
                'lord piano'        => 'Loro Piana',
                'лоро пьяна'        => 'Loro Piana',
                'лоро пьяно'        => 'Loro Piana',
                'loro piano'        => 'Loro Piana',
                'lora piana'        => 'Loro Piana',
                'loro piana'        => 'Loro Piana',
                'lora'              => 'Loro Piana',
                'botega veneta'     => 'BOTTEGA VENETA',
                'водолахка'         => 'водолазки',
                'кепки'             => 'кепка',
                'бейсболки'         => 'бейсболка',
                'форд'              => 'Ford',
                'почотти'           => 'Paciotti',
                'castello d pro'    => 'Castello d Oro',
                'dolce  gabbana'    => 'dolce & gabbana',
                'айсберг'           => 'ICEBERG',
                'зили'              => 'Zilli',
                'cornelian i'       => 'Corneliani',
                'борсалино'         => 'Borsalino',
                'zili'              => 'Zilli',
                'зилли'             => 'Zilli',
                'zilly'             => 'Zilli',
                'рубашки'           => 'рубашка',
                'форд'              => 'Ford',
                'cesare paccioti'   => 'Cesare Paciotti',
                'chezare'           => 'Cesare',
                'сумки'             => 'сумка',
                'блузки'            => 'блузка',
                'zarffes'           => 'Zaffers',
                'zafferi'           => 'Zaffers',
                'Долче габана'      => 'D&G',
                'шубы'              => 'шуба',
                'ринди'             => 'RinDi',
                'tomford'           => 'Tom Ford',
                'том форд'          => 'Tom Ford',
                'пуховики'          => 'пуховик',
                'якоб коэн'         => 'JACOB COH',
                'артиоли'           => 'ARTIOLI',
                'deor'              => 'dior',
                'stella makartni'   => 'STELLA McCARTNEY',
                'стелла маккартни'  => 'STELLA McCARTNEY',
                'billionare'        => 'Billionaire',
                'биллионери'        => 'Billionaire',
                'billion ear'       => 'Billionaire',
                'billoinere'        => 'Billionaire',
                'billonaire'        => 'Billionaire',
                'биллионара'        => 'Billionaire',
                'беллионара'        => 'Billionaire',
                'Билионер'          => 'Billionaire',
                'BILLIANARE'        => 'Billionaire',
                'мала мати'         => 'MalaMati',
                'Botega'            => 'BOTTEGA VENETA',
                'рамсей'            => 'Ramsey',
                'китон'             => 'Kiton',
                'Рубашку'           => 'Рубашка',
                'Сарочка'           => 'Сорочка',
                'icberg'            => 'iceberg',
                'Ремни мужские'     => 'Ремень',
                'Zilli 2014'        => 'Zilli',
                'Красовки'          => 'Кросовки',
                'Costello D oRo'    => 'Castello',
                'Costello'          => 'Castello',
                'Шлпки'             => 'Шляпа',
                'Макасины'          => 'Мокасины',
                'hetabrats'         => 'HETTABRETZ',
                'курта'             => 'Куртка',
                'celine'            => 'CELINE',
                'Celine'            => 'CELINE',
                'селин'             => 'CELINE',
            );
            if ( isset($search_replace_array[$search_tmp]) ) {
                $search = $search_replace_array[$search_tmp];
            }
            //echo $search . '<br>';
            $mw = false; // При поиске убираем пол
            $ecommerce_list = 'search';
            $log_search = true;
        }

        // Для скидки выходного дня
        if (!empty($from)) {
            if ($from == 'swd' && isset($_SESSION['user']) && !empty($_SESSION['user']->user_id) ) {
                $swd_user = $_SESSION['user'];
                $this->db->query("INSERT INTO feedback (date,name,message) VALUES (NOW(), {$swd_user->user_id}, 'swd user id')");
                $s = 'Клиент '.$swd_user->name.' заинтересован скидкой выходного дня';
                $m = 'Зарегистрированный клиент '.$swd_user->name.' прошел по ссылке "скидки выходного дня".';
                $this->email('mail@lsboutique.ru', $s, $m);
            }
        }

        // Для мобильной версии
        if ($this->settings->theme == 'mobile' || $this->settings->theme == 'application') {
            // Центральный баннер бренда
            if (isset($mw)) {
                $suffix = ($mw == 2) ? "w" : "m";
                $squery = " products.sex = {$mw} AND brands.banner_{$suffix} != '' ";
            }
            else {
                $squery = " (brands.banner_w != '' OR brands.banner_m != '') ";
            }
            $squery = $squery . " AND products.enabled = 1 AND products.size != '' ";

            // показывать скрытые бренды только избранным
            $s_user_id = $_SESSION['user']->user_id;
            if ($this->settings->theme == 'api') {
                $s_user_id = $_GET['user_id'];
            }
            $brands_str = implode(",", luser::visible_brands($s_user_id));
            $squery .= " AND brands.brand_id IN ({$brands_str}) ";

            $banner_obj = $this->db->result( "SELECT brands.name AS name,
                brands.brand_id AS id,
                brands.url AS url,
                brands.banner_w AS banner_w,
                brands.banner_m AS banner_m,
                brands.meta_title AS title,
                products.sex AS mw,
                MAX( products.photo_added ) AS photo_added
                FROM products
                LEFT JOIN brands ON products.brand_id = brands.brand_id
                LEFT JOIN banners ON products.brand_id = banners.brand_id
                WHERE {$squery} AND NOT (banners.brand_id IS NOT NULL AND banners.sex IN (0,products.sex) AND banners.enabled = 1)
                GROUP BY brands.name
                ORDER BY photo_added DESC
                LIMIT 1" );

            if ( !isset($suffix) ) {
                $suffix = ($banner_obj->mw == 2) ? "w" : "m";
            }
            $banner_obj->banner = $banner_obj->{"banner_".$suffix};
            $this->smarty->assign('banner_obj', $banner_obj);

            $greeting_text = $this->db->result('SELECT * FROM sections WHERE url="greeting_text"');
            $this->smarty->assign('greeting_text', $greeting_text);
            if (!empty($mobile_mw)) {
                $mw = $mobile_mw;
            }
            $this->smarty->assign('manOrWoman', $mw ? $mw : '1');
            if (!empty($mobile_mw)) {
                setcookie('sex', $mobile_mw, time()+60*60*24*365, '/');
                $_COOKIE['sex'] = $mobile_mw;
                $this->smarty->assign('main_page', true);
                $this->body = $this->smarty->fetch('main_categories.tpl');
                return $this->body;
            }
            if (!isset($_COOKIE['sex'])) {
                $this->smarty->assign('no_header', true);
                $this->body = $this->smarty->fetch('welcome.tpl');
                return $this->body;
            }
            elseif (count($_GET) < 2 && !isset($_GET['search']) && empty($_POST)) {
                $this->smarty->assign('main_page', true);
                $this->body = $this->smarty->fetch('main_categories.tpl');
                return $this->body;
            }
        }

        // При переходе по URL категории
        if (!empty($category_url)) {
            $fcat = $this->db->result( "SELECT * FROM categories WHERE url='{$category_url}' LIMIT 1" );
            if ($fcat->parent == 0 && ($this->settings->theme == 'mobile' || $this->settings->theme == 'application') && !$show_all) {
                $show_categories = true;
            }
            $category = $fcat->category_id;

            $ecommerce_list = strtr($fcat->url, array('а'=>'a','б'=>'b','в'=>'v','г'=>'g','д'=>'d','е'=>'e','ё'=>'e','ж'=>'j','з'=>'z','и'=>'i','й'=>'y','к'=>'k','л'=>'l','м'=>'m','н'=>'n','о'=>'o','п'=>'p','р'=>'r','с'=>'s','т'=>'t','у'=>'u','ф'=>'f','х'=>'h','ц'=>'c','ч'=>'ch','ш'=>'sh','щ'=>'shch','ы'=>'y','э'=>'e','ю'=>'yu','я'=>'ya','ъ'=>'','ь'=>'')).$mf;
            // Сохраняем url, чтобы вернуть пользователя туда
            $_SESSION['LAST_CATALOG_URL'] = "/categories/{$category_url}/";
        }

        // Редирект для SEO
        if ($showbrand && $brand && !$brand_url) {
            $brand_o = $this->db->result("SELECT * FROM brands WHERE brand_id = {$brand}");
            http_response_code(301);
            header('Location: /brands/' . $brand_o->url . '/');
        }

        // При переходе по URL бренда
        if (!empty($brand_url)) {
            $fbrand = $this->db->result("SELECT * FROM brands WHERE url='{$brand_url}' LIMIT 1");
            $brand  = $showbrand = $fbrand->brand_id;

            $visible_brands = luser::visible_brands($_SESSION['user']->user_id);
            //id=385 Dior
            if (!(in_array($brand, $visible_brands)) && $brand == "385") {
                header("Location: /dior/");
                exit();
            }
            //id=394 Celine
            if (!(in_array($brand, $visible_brands)) && $brand == "394") {
                header("Location: /celine/");
                exit();
            }

            if ($this->settings->theme == 'application') {
                $this->smarty->assign('catBrand', true);
            }

            $ecommerce_list = (strpos($fbrand->name, "'") !== false) ? strtolower(str_replace("'","",$fbrand->name)) . $mf : strtolower($fbrand->name) . $mf;
            // Сохраняем url, чтобы вернуть пользователя туда
            $_SESSION['LAST_CATALOG_URL'] = "/brands/{$brand_url}/";
        }

        // При переходе по URL подборки
        if (!empty($special_url)) {
            $fspecial = $this->db->result( "SELECT * FROM specials WHERE url='{$special_url}' LIMIT 1" );
            $special  = $fspecial->special_id;

            $ecommerce_list = strtr($special_url, array('а'=>'a','б'=>'b','в'=>'v','г'=>'g','д'=>'d','е'=>'e','ё'=>'e','ж'=>'j','з'=>'z','и'=>'i','й'=>'y','к'=>'k','л'=>'l','м'=>'m','н'=>'n','о'=>'o','п'=>'p','р'=>'r','с'=>'s','т'=>'t','у'=>'u','ф'=>'f','х'=>'h','ц'=>'c','ч'=>'ch','ш'=>'sh','щ'=>'shch','ы'=>'y','э'=>'e','ю'=>'yu','я'=>'ya','ъ'=>'','ь'=>''));
            // Сохраняем url, чтобы вернуть пользователя туда
            $_SESSION['LAST_CATALOG_URL'] = "/specials/{$special_url}/";
        }

        //При переходе по бренд-категория
        if (!empty($goods)) {
            $query="SELECT * FROM goods WHERE url='{$goods}' LIMIT 1";
            if (is_numeric($goods)) {
                $query="SELECT * FROM goods WHERE id='{$goods}' LIMIT 1";
            }
            $showgood = $this->db->result($query);
            if ($showgood) {
                $brand          = $showgood->brand_id;
                $category       = $showgood->category_id;
                $showgood->text = strip_custom_tags($showgood->text);
                $this->smarty->assign('showgood', $showgood);
            }

            $ecommerce_list = strtr($goods, array('а'=>'a','б'=>'b','в'=>'v','г'=>'g','д'=>'d','е'=>'e','ё'=>'e','ж'=>'j','з'=>'z','и'=>'i','й'=>'y','к'=>'k','л'=>'l','м'=>'m','н'=>'n','о'=>'o','п'=>'p','р'=>'r','с'=>'s','т'=>'t','у'=>'u','ф'=>'f','х'=>'h','ц'=>'c','ч'=>'ch','ш'=>'sh','щ'=>'shch','ы'=>'y','э'=>'e','ю'=>'yu','я'=>'ya','ъ'=>'','ь'=>''));
            // Сохраняем url, чтобы вернуть пользователя туда
            $_SESSION['LAST_CATALOG_URL'] = "/goods/{$goods}/";
        }

        // корневая категория и бренд идут в шаблон
        $this->smarty->assign('rootbrand', $brand);
        $this->smarty->assign('rootcateg', $category);


        if ( $_SERVER['REQUEST_METHOD'] === 'POST' ) {
            $json_obj = json_decode($_POST['json']);
            if (!empty($json_obj->rootcateg)) {
                $category = $json_obj->rootcateg;
            }
            if (!empty($json_obj->rootbrand)) {
                $brand = $json_obj->rootbrand;
            }
            if (!empty($json_obj->special)) {
                $special = $json_obj->special;
            }
            if (!empty($json_obj->sex)) {
                $mw = $json_obj->sex;
            }
            if (!empty($json_obj->form_search)) {
                $search = $json_obj->form_search;
                $mw = false;
            }
        }

        $filter_url = array();
        $limit   = $where_brands = $where_materials = $where_sizes = $where_cats = "";
        $where   = " products.enabled = 1 ";
        if(isset($_GET['sort']) && $_GET['sort'] == 'hits') $sort_by = "pvc.count DESC";
        else $sort_by = " products.photo_added DESC ";

        if ( !empty($special) ) {
            $special = (int)$special;
            $special_fields = $this->db->result("SELECT * FROM specials WHERE special_id = '{$special}' LIMIT 1");
            $special_fields->description = $special_fields->description;
            $this->smarty->assign('special_fields', $special_fields);
            $this->smarty->assign('special',        $special);
            $this->smarty->assign('keywords',       $special_fields->meta_keywords);
            $this->smarty->assign('description',    $special_fields->meta_description);
            $mw = $special_fields->gender;

            if (!empty($special_fields->urls)) {
                $sp_urls = str_replace("/","",urldecode($special_fields->urls));
                $where  .= " AND (products.url IN ({$sp_urls}) OR products.old_url IN ({$sp_urls}))";
                $sort_by = " FIELD (products.url, {$sp_urls}) ASC";
            }
            else {
                $sp_params = json_decode($special_fields->query_params);
                if (isset($sp_params->brands) && count($sp_params->brands)>0) {
                    $where_brands .= " AND products.brand_id IN (".implode(",", $sp_params->brands).") ";
					if (count($sp_params->brands) == 1) {
						$brand_for_special = $this->db->result("SELECT * FROM brands WHERE brand_id = {$sp_params->brands[0]} LIMIT 1");
						$this->smarty->assign('brand_for_special',    $brand_for_special);
					}
                }
                if (isset($sp_params->categories) && count($sp_params->categories)>0) {
                    $where_cats   .= " AND products.category_id IN (".implode(",", $sp_params->categories).") ";
                }
                if ($special_fields->sale) {
                    $where_cats   .= " AND products.price < products.old_price AND brands.show_delta = 1 AND products.season_type NOT IN ('new_season', 'next_season') ";
                }
            }
      }

        if ( !empty($search) ) {
            $where .= " AND (products.product_id = '{$search}' OR products.sku LIKE '%{$search}%' OR products.model LIKE '%{$search}%' OR categories.name LIKE '%{$search}%' OR categories.eng_name LIKE '%{$search}%' OR brands.name LIKE '%{$search}%') ";
            $this->smarty->assign('form_search', $search);
            $filter_url[] = "search={$search}";
            $this->smarty->assign('filter_url', $filter_url = '/catalog/?' . implode('&', $filter_url));
        }

        if ( !empty($brand)) {
            $where .= " AND products.brand_id = '{$brand}' ";
            $brand_item = $this->db->result("SELECT * FROM brands WHERE brands.brand_id = '{$brand}'");
            $this->smarty->assign('brand_item', $brand_item);
            if(empty($showgood)) {
                $filter_url[] = "brand={$brand}";
            }

            $year = date('Y', time() + 60*60*24*150);
            $addNameStore = (strpos($_SERVER['SERVER_NAME'], 'lstore.moscow') !== false ) ? 'lstore.moscow' : 'Лакшери стор';
            $this->smarty->assign('title',       "коллекция {$year} в фирменном магазине {$brand_item->name} | бутик {$addNameStore}");
            $this->smarty->assign('keywords',    $brand_item->meta_keywords);
            $this->smarty->assign('description', $brand_item->meta_description);
            $this->smarty->assign('brand', true);
        }

        $this->smarty->assign('whatsnew', false);
        $this->smarty->assign('furs', false);

        if (!empty($category) && $category == 'megasale') {
            $this->smarty->assign('sale', true);
            $megasale_filter = "AND name LIKE 'SALE Online shop%'";
            $filter_url[] = "category=megasale";
            $category = '';
            $ecommerce_list = 'megasale'.$mf;

            $this->smarty->assign('title', "бутик фирменной одежды из Италии и Франции - lstore.moscow");
            $this->smarty->assign('keywords', "бутик, интернет магазин, фирменная одежда из Италии, фирменная одежда из Франции, бутик, lstore.moscow");
            $this->smarty->assign('description', "бутик, интернет магазин фирменной одежды из Италии и Франции - lstore.moscow");
        }
        else {
            $megasale_filter = "AND name NOT LIKE 'SALE Online shop%'";
        }

        $user_group = isset($_SESSION['user']->group_id) ? $_SESSION['user']->group_id : 0;
        if($this->settings->theme == 'api') {
            $user_group = $this->db->result("SELECT group_id FROM users WHERE user_id = '{$_GET['user_id']}'")->group_id;
        }

        if ( !empty($category)) {
            if ($category == 'new') {
                $this->smarty->assign('whatsnew', true);
                $limit        = " LIMIT 99 ";
                $filter_url[] = "category=new";
                $ecommerce_list = 'whatsnew'.$mf;
            }
            elseif ($category == 'new_season' || isset($_GET['new_season'])) {
                $this->smarty->assign('new_season', true);
                $where .= " AND (products.season_type IN ('new_season', 'previous_season', 'next_season')) ";
                $filter_url[] = "category=new_season";
                $ecommerce_list = 'new_season'.$mf;
            }
            elseif ($category == 'furs') {
                $this->smarty->assign('furs', true);
                $where .= " AND products.brand_id IN (377, 357, 373, 358, 351, 124, 374, 396, 409, 400) AND products.category_id IN (8342, 8341, 8346) ";
                $filter_url[] = "category=furs";
                $ecommerce_list = 'furs'.$mf;
            }
            elseif ($category == 'sale') {
                $this->smarty->assign('sale', true);
                $ecommerce_list = 'sale'.$mf;
                $where .= " AND products.old_price > products.price AND products.item_location != 'Podium VIP' AND products.season_type NOT IN ('next_season','new_season') AND brands.show_delta = 1 ";

                if (array_key_exists('swd', $this->promos) && !empty($this->promos['swd']->brands)) {
                    $sort_by = "FIElD(products.brand_id, '{$this->promos['swd']->brands}') DESC, products.created DESC";
                }
                else {
                    $sort_by = "products.photo_added DESC";
                }

                $filter_url[] = "category=sale";
            }
            elseif ($category == 'big_size') {
                $big_size = true;
                $this->smarty->assign('big_size', true);
                $ecommerce_list = 'big_size'.$mf;
                $where .= " AND products.bsize_small_image != '' ";
                $filter_url[] = "category=big_size";
            }
            else {
                $category = (int)$category;
                $where .= " AND (categories.category_id = '{$category}' OR categories.parent = '{$category}') ";
                $this->smarty->assign('category', $category);
                if (empty($showgood)) {
                    $filter_url[] = "category={$category}";
                }

                $category_item = $this->db->result( "SELECT * FROM categories WHERE category_id = '{$category}'" );
                if($_COOKIE['language'] === 'eng'){
                  $type = 'designer ' . $category_item->eng_name;
                  $title = "{$type} | Luxury Store";
                }else{
                  $type = ($category_item->category_id == 2 || $category_item->category_id == 1 ? 'дизайнерская ' : 'дизайнерские ') . $category_item->name;
                  $title = "{$type} | бутик Лакшери Стор";
                }
                if ($mw == '2') {
                    $categ_desc = strip_custom_tags($category_item->womens_description);
                }
                elseif ($mw == '1') {
                    $categ_desc = strip_custom_tags($category_item->mens_description);
                }
                else {
                    $categ_desc = strip_custom_tags($category_item->description);
                }
                if (!$categ_desc) {
                    $categ_desc = strip_custom_tags($category_item->description);
                }
                $this->smarty->assign('categ_name', $_COOKIE['language'] === 'eng' ? $category_item->eng_name : $category_item->name);
                $this->smarty->assign('categ_desc', $categ_desc);
                $this->smarty->assign('title',       $title);
                $this->smarty->assign('keywords',    "{$type}, бутик, Лакшери Стор");
                $this->smarty->assign('description', $category_item->meta_description);
				$this->smarty->assign('categ_url', $category_item->url);
            }
        }

        if (!empty($showgood)) {
            $filter_url[] = "goods={$showgood->id}";
        }

        if ( !empty($showbrand) ) {
            $brand = $this->db->result("SELECT * FROM brands WHERE brand_id = '{$showbrand}'");
            $filter_url[] = "showbrand={$showbrand}";
            if ($brand->gender) {
                $mw = $brand->gender;
            }
            else {
                $unisex = true;
            }
            $brand->description     = $brand->description;
            $brand->description_m   = strip_custom_tags($brand->description_m);
            $brand->description_w   = strip_custom_tags($brand->description_w);
			$this->smarty->assign('og_image', '/files/brands/'.$brand->image);
            $this->smarty->assign('showbrand', $brand);
        }

        if ( isset($mw)) {
            $mw = (int)$mw;
			if ($mw!=0) {
				$where .= " AND (sex = '0' OR sex = '{$mw}') ";
			}
            if ((empty($showbrand) && empty($special)) || isset($unisex)) {
                setcookie('sex', $mw, time()+60*60*24*365, '/');
                if ( isset($_SESSION['user']) && !empty($_SESSION['user']->user_id) ) {
                    $query = "UPDATE users SET sex = '{$mw}' WHERE user_id = '{$_SESSION['user']->user_id}'";
                    $this->db->query($query);
                }
            }
            $_COOKIE['sex'] = $mw;
        }

        if ( !isset($_COOKIE['sex']) ) {
            $this->smarty->assign('need_select_sex', true);
        }

        if ( ($user_group == 1 || $user_group == 0) || (empty($search) && $user_group == 2) ) {
            $where .= " AND products.enabled=1 ";

            // показывать скрытые бренды только избранным
            if ($this->settings->theme == 'discount') {
                $where .= " AND brands.visibility < 4 ";
            }
            else {
                $s_user_id = 0;
                if ($this->settings->theme == 'api') {$s_user_id = $_GET['user_id'];}
                elseif (!empty($_SESSION['user']->original_user_id)) {$s_user_id = $_SESSION['user']->original_user_id;}
                $brands_str = implode(",", luser::visible_brands($s_user_id));
                $where .= " AND brands.brand_id IN ({$brands_str}) ";

                // Отображать товары в разделе SALE только
                // если клиент видит скидку на товар
                if ($category == 'sale') {
                  $sale_brands = luser::sale_visible_brands($s_user_id);
                  $s_brand_filter = array();
                  foreach ($sale_brands as $v) {
                    $s_brand_filter[] = "(brands.brand_id IN ({$v->brand_ids}) AND products.season_type = '{$v->season}')";
                  }
                  $where .= (' AND (' . implode(" OR ", $s_brand_filter) . ')');
                }
            }
        }


        //ajax where
        if ( $_SERVER['REQUEST_METHOD'] === 'POST' ) {
            if (isset($json_obj->brands) && count($json_obj->brands)>0) {
                $where_brands .= " AND products.brand_id IN (".implode(",", $json_obj->brands).") ";
            }
            if (isset($json_obj->categories) && count($json_obj->categories)>0) {
                $where_cats .= " AND products.category_id IN (".implode(",", $json_obj->categories).") ";
            }
            if (isset($json_obj->materials) && count($json_obj->materials)>0) {
                $where_materials .= " AND (products.product_id IN (SELECT products_materials.product_id FROM products_materials WHERE products_materials.material_id IN (".implode(",", $json_obj->materials).") )) ";
            }
            $sizes_array = array();
            if (isset($json_obj->csizes) && count($json_obj->csizes)>0) {
                $sizes_array = array_merge($sizes_array, $json_obj->csizes);
            }
            if (isset($json_obj->fsizes) && count($json_obj->fsizes)>0) {
                $sizes_array = array_merge($sizes_array, $json_obj->fsizes);
            }
            if (count($sizes_array) > 0) {
                // Не использовать в основном запросе
                $where_sizes .= " AND EXISTS (SELECT 1 FROM items it WHERE products.product_id = it.product_id AND it.quantity != 0 AND it.normal_size IN ('".implode("','", $sizes_array)."')) ";

                // А вот это использовать
                $size_list = "'" . implode("','", $sizes_array) . "'";
                $size_filter = " AND i.normal_size IN ({$size_list}) ";
            }
        }
        //end of ajax where

        //Фильтры для API
        $full_brands = '';
        $full_cats = '';
        if($this->settings->theme == 'api'){
            if ( !empty($fimats)) {
                $where_materials = " AND (products.product_id IN (SELECT products_materials.product_id FROM products_materials WHERE products_materials.material_id IN (".implode(",", $fimats).") )) ";
            }
            if ( !empty($fibrands)) {
                if ( !empty($special)) {
                    $full_brands = $where_brands;
                }
                $where_brands = " AND products.brand_id IN (".implode(",", $fibrands).") ";
            }
            if ( !empty($fisizes)) {
                $as = array_search('5XL ', array_map('strtoupper', $fisizes));
                if ($as !== false){$fisizes[$as] = "5XL+";}
                $where_sizes = " AND items.normal_size IN ('".implode("','", $fisizes)."') ";
                $size_filter = " AND i.normal_size IN ('".implode("','", $fisizes)."') ";
            }
            if ( !empty($fisize_ids)) {
                $where_sizes = " AND EXISTS (SELECT 1 FROM items it WHERE products.product_id = it.product_id AND it.quantity != 0 AND it.size_id IN ('".implode("','", $fisize_ids)."')) ";

                $size_filter = " AND i.size_id IN ('" . implode("','", $fisize_ids) . "') ";
            }
            if ( !empty($ficats)) {
                if ( !empty($special)) {
                    $full_cats = $where_cats;
                }
                $where_cats = " AND products.category_id IN (".implode(",", $ficats).") ";
            }
        }

        $user_shop_filter = isset($user_shop_filter) ? $user_shop_filter : '';

        $where .= " AND (EXISTS (SELECT 1 FROM items i WHERE i.product_id = products.product_id AND i.quantity != 0 {$user_shop_filter} {$size_filter}) OR products.show_out_of_stock = 1) ";


        // определить размеры для чекбокса
        $where_without_sizes = str_replace($size_filter, "", $where);
        $query = "SELECT items.normal_size AS size, categories.parent AS parent, products.category_id AS category_id FROM `items`
          LEFT JOIN products ON items.product_id = products.product_id
          LEFT JOIN categories ON categories.category_id = products.category_id
          LEFT JOIN brands ON brands.brand_id = products.brand_id
          WHERE {$where_without_sizes} {$where_cats} {$where_brands} {$where_materials} AND items.quantity > 0 AND items.normal_size != ''
          GROUP BY items.normal_size
          ORDER BY FIELD(items.normal_size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL', '5XL+', '6XL', '7XL'), normal_size ASC";
        $sizes = $this->db->results($query);

        // определить категории для чекбокса
        $scope = ($_SERVER['REQUEST_METHOD'] === 'POST' || ($this->settings->theme == 'api' && !$special)) ? $where.$where_sizes.$where_brands.$where_materials.$full_cats : $where.$where_sizes.$where_brands.$where_cats.$where_materials;
        $name = 'categories.name AS name';
        $eng_filter='';
        if($_COOKIE['language'] == 'eng'){$name = 'categories.eng_name AS name';$eng_filter=" AND categories.eng_name !=''";}
        $query = "SELECT products.category_id AS id, {$name}, categories.url AS url, categories.prod_count_m AS prod_count_m, categories.prod_count_w AS prod_count_w FROM `products` LEFT JOIN brands ON brands.brand_id = products.brand_id LEFT JOIN items ON items.product_id = products.product_id LEFT JOIN categories ON categories.category_id = products.category_id WHERE {$scope} {$eng_filter} AND (categories.prod_count_m != 0 OR categories.prod_count_w != 0) GROUP BY products.category_id ORDER BY name ASC";
        $this->db->query($query);
        $categories = $this->db->results();
        if($_COOKIE['language'] == 'eng') foreach($categories as $cat)if($cat->id == 97 && $mw == 1){$cat->name = 'Oxford shoes';}

        // определить бренды для чекбокса
        $scope = ($_SERVER['REQUEST_METHOD'] === 'POST' || ($this->settings->theme == 'api' && !$special)) ? $where.$where_sizes.$where_cats.$where_materials.$full_brands : $where.$where_sizes.$where_brands.$where_cats.$where_materials;
        $query = "SELECT products.brand_id AS id, brands.name AS name FROM `products` LEFT JOIN items ON items.product_id = products.product_id LEFT JOIN categories ON categories.category_id = products.category_id LEFT JOIN brands ON brands.brand_id = products.brand_id WHERE {$scope} GROUP BY products.brand_id ORDER BY name ASC";
        $brands = $this->db->results($query);

        // определить материалы для чекбокса
        $scope = ($_SERVER['REQUEST_METHOD'] === 'POST' || ($this->settings->theme == 'api' && !$special)) ? $where.$where_sizes.$where_brands.$where_cats : $where.$where_sizes.$where_brands.$where_cats.$where_materials;
        $name = 's_materials.name';
        if($_COOKIE['language'] == 'eng'){$name = 's_materials.eng_name AS name';}
        $materials = $this->db->results("SELECT s_materials.material_id, {$name} FROM s_materials LEFT JOIN products_materials ON products_materials.material_id = s_materials.material_id LEFT JOIN `products` ON products_materials.product_id = products.product_id LEFT JOIN items ON items.product_id = products.product_id LEFT JOIN categories ON categories.category_id = products.category_id LEFT JOIN brands ON brands.brand_id = products.brand_id WHERE {$scope} GROUP BY s_materials.material_id ORDER BY name ASC");

        if(!($this->settings->theme == 'api' && $filters_only === true)){
            $where = $where . $where_cats . $where_brands . $where_materials;

            // set limit and offset
            if (isset($json_obj->offset)) {
                $offset = $json_obj->offset;
                $lim = $this->settings->catalog->page_limit;
            }
            elseif (!empty($page)) {
                $offset = $page*$this->settings->catalog->page_limit;
                $lim = $this->settings->catalog->page_limit;
            }
            elseif (!empty($limit_ovr)){
                $offset = "0";
                $lim = $limit_ovr;
                $this->smarty->assign('limit_ovr', 1);
            }
            else {
                $offset = "0";
                $lim = $this->settings->catalog->page_first;
            }
            $limit = " LIMIT ".$offset.",".$lim;

            // set limit and offset for api
            if($this->settings->theme == 'api'){
                if (isset($_GET['offset']) && $_GET['offset'] != 0) $offset = (int) $_GET['offset'];
                else $offset = "0";
                if (isset($_GET['limit']) && $_GET['limit'] != 0) $lim = (int) $_GET['limit'];
                else $lim = 60;
                $limit = " LIMIT ".$offset.",".$lim;
            }


            $this->smarty->assign('manOrWoman', $mw);


            // Посчитать количество товаров, соответствующих критериям отбора
            $rowcount = $this->db->result("SELECT COUNT(*) AS rowcount FROM products LEFT JOIN categories ON categories.category_id = products.category_id LEFT JOIN brands ON brands.brand_id = products.brand_id WHERE ".$where)->rowcount;
            $this->smarty->assign('rowcount', (int)$rowcount);
            $this->smarty->assign('pages_num', ceil($rowcount/$this->settings->catalog->page_first));
            $this->smarty->assign('current_page', max(1, (int)$page));

            $cat_name = 'categories.name';$scat='';
            if($_COOKIE['language'] == 'eng'){$name = 'categories.eng_name';$scat=' categories.eng_single_name,';}

            $query = "SELECT products.*, brands.name as brand, brands.offline_only as offline_only, brands.hide_sizes as hide_sizes, brands.golden_sale as golden_sale, brands.no_sale as no_sale, brands.show_delta as show_delta,{$scat} {$cat_name} as category, categories.parent as parent, categories.enabled as cat_enabled, pv.value as prop_val, (tp.price-products.price) as tsum_price
                    FROM products
                    LEFT JOIN categories ON categories.category_id = products.category_id
                    LEFT JOIN brands     ON brands.brand_id = products.brand_id
                    LEFT JOIN properties_values pv ON pv.product_id = products.product_id AND property_id = '5'
                    LEFT JOIN tsum_prices tp ON tp.product_id = products.product_id
                    LEFT JOIN product_view_counters pvc ON pvc.product_id = products.product_id
                  WHERE {$where}
                  ORDER BY {$sort_by} {$limit}";

            $products = $this->db->results($query);

            foreach ($products as $k=>$proditem) {
                $proditem->brand = trim($proditem->brand);
                $proditem->model = trim($proditem->model);
                $brand_name_short = str_replace(array('.'), '', $proditem->brand);
                $brand_name_join  = str_replace(' ', '', $proditem->brand);
                $brand_name_ap  = str_replace("`", "'", $proditem->brand);
                $brands_names = array($proditem->brand, $brand_name_short, $brand_name_ap,
                                strtolower($proditem->brand), strtoupper($proditem->brand), ucfirst($proditem->brand),ucwords($proditem->brand),
                                strtolower($brand_name_join), strtoupper($brand_name_join), ucfirst($brand_name_join),ucwords($brand_name_join));
                $products[$k]->group_name = str_replace($brands_names, '', $proditem->model);
                if($_COOKIE['language'] == 'eng'){
                  if($proditem->category_id == 97 && $mw == 1){$proditem->eng_single_name = 'Oxford shoes';}
                  $products[$k]->model = $proditem->eng_single_name . ' ' . $proditem->brand;
                  $products[$k]->group_name = $proditem->eng_single_name;
                }

                $products[$k]->size_price = Storefront::getMaxPriceFromSizes($proditem->product_id);
            }

            if ( $log_search && !empty($_SESSION['user']->user_id) && (!isset($_SESSION['group']->group_id) || $_SESSION['group']->group_id == 1 || $_SESSION['group']->group_id == 0) ) {
                $user_id = !empty($_SESSION['user']->user_id) ? (int)$_SESSION['user']->user_id : 0;
                // Логируем поисковый запрос
                $ref    = mysql_real_escape_string($_SERVER['HTTP_REFERER']);
                $ip     = mysql_real_escape_string($_SERVER['HTTP_X_REAL_IP']);
                $ua     = mysql_real_escape_string($_SERVER['HTTP_USER_AGENT']);
                $results_count = count($products);
                $this->db->query(" INSERT INTO `search_history` (`word`, `results_count`, `user_id`, `datetime`, `ip`, `user_agent`, `referrer` )
                                                         VALUES ('{$search}', '{$results_count}', '{$user_id}', CURRENT_TIMESTAMP, '{$ip}', '{$ua}', '{$ref}'); ");
            }

            // Для ссылки 'Вернуться к категориям' в мобильной версии
            $query = "SELECT name FROM categories WHERE category_id = {$products['0']->parent} LIMIT 1";
            $this->db->query($query);
            $parent_name = $this->db->result()->name;

            $s_user_id = !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0;
            if ($this->settings->theme == 'api' && !empty($_GET['user_id'])){$s_user_id = $_GET['user_id'];}
            $user = new luser( !empty($s_user_id) ? $s_user_id : 0 );
            if ( is_array($products) && count($products)) {
                foreach ($products as $k=>$product) {
                    // Нулевая скидка
                    if ($product->season == '18/2' && ($product->old_price > $product->price)) {
                        $product->super_price = true;
                    }

                    // Отображение количества просмотров для админов
                    if ($_SESSION['user']->group_id == 2 || $_SESSION['user']->group_id == 5) {
                      $product->product_views     = $this->db->result("SELECT `count`, `count_logged_in` FROM product_view_counters WHERE product_id = {$product->product_id}");
                    }

                    $product->can_buy_from_site = $user->can_buy_from_site($product->brand_id);

                    $product_from_wl = $this->db->results($sql="SELECT * FROM users2wishlist WHERE product_id = '{$product->product_id}' AND user_id = '{$s_user_id}'");
                    if($product_from_wl) $product->product_from_wl = true;
                    else $product->product_from_wl = false;

                    $cart = $this->db->result($sql="SELECT * FROM users2carts WHERE product_id = '{$product->product_id}' AND user_id = '{$s_user_id}'");
                    if($cart) $product->product_from_cart = true;
                    else $product->product_from_cart = false;

                    // Отображение скидки в зависимости от статуса пользователя
                    if ($this->settings->theme == 'api') {
                        $product->prices = $user->product_prices_for_api($product, $_GET['currency'], $product->can_buy_from_site);
                    }
                    else{
                        $product->prices = $user->product_prices($product);
                        $product->price = $product->prices['personal_price'];
                        $product->old_price = $product->prices['first_price'];
                    }

                    // Замена фотографий для унисекса в женском разделе каталога
                    $product->second_image = $product->small_image;
                    if ( $product->sex == 0 && $mw == 2 ) {
                      $female_images = $this->db->results("SELECT * FROM products_fotos WHERE product_id = {$product->product_id} AND female = 1");
                      if ($female_images) {
                        $product->large_image = $female_images[0]->filename;
                        $product->second_image = $female_images[1]->filename;
                      }
                    }

                    $product->week = strtotime($product->modified) > time() - 60*60*24*7 ? 1 : 2;

                    if ($_SESSION['user']->group_id != 2) {
                      $shop_filter = "AND shop_id IN (SELECT shop_id FROM shops WHERE enabled=1 {$megasale_filter})";
                    }
                    $query = "SELECT GROUP_CONCAT(DISTINCT size
                        ORDER BY FIELD(size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL', '5XL+', '6XL', '7XL'), size + 0, size ASC SEPARATOR '|') AS size
                        FROM items
                        WHERE quantity != 0 AND product_id={$product->product_id} {$shop_filter}
                        GROUP BY product_id;";
                    $product->size = $this->db->result($query)->size;
                    if ($this->settings->theme == 'api' && strpos($product->size, 'зад') !== false && strpos($product->size, 'не ') !== false) {
                        $product->size  = '';
                    }
                    if ($this->settings->theme == 'api' && $product->hide_sizes) {
                        $product->size = $_COOKIE['language'] === 'eng' ? 'Inquire for sizes' : 'Размеры по запросу';
                    }
                }
            }
            else { // Если ничего не найдено
                //ajax
                if ( $_SERVER['REQUEST_METHOD'] === 'POST' ) {
                    echo "<p>Ничего не найдено</p>";
                    die();
                }
                //end of ajax
                if ($this->settings->theme == 'api') {
                    $return->products = array();
                    if(strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false){
                      $return->sizes = array();
                      $return->size_ids = array();
                    }
                    else {
                      $return->sizes = null;
                      $return->size_ids = null;
                    }
                    $return->materials = $materials;
                    $return->brands = $brands;
                    $return->categories = $categories;
                    $return = json_encode($return);
                    echo $return;
                    die;
                }

                $mw = (int)$mw;
                $where = '';
                if ( !empty($mw) ) {
                    $where = " AND (sex = '0' OR sex = '{$mw}') ";
                }

                if ($this->settings->theme == 'api'){$s_user_id = $_GET['user_id'];}
                else {$s_user_id = $_SESSION['user']->user_id;}
                $brands_str = implode(",", luser::visible_brands($s_user_id));
                $b_query = " AND brand_id IN ({$brands_str}) ";
                $this->db->query("SELECT * FROM brands WHERE brand_id IN (SELECT DISTINCT brand_id FROM products WHERE products.enabled=1 AND products.size <> '' {$where}) {$b_query} ORDER BY name ASC");
                $brands = $this->db->results();
                $this->smarty->assign('brands_full', $brands);

                $this->db->query("SELECT * FROM categories WHERE category_id IN (SELECT DISTINCT category_id FROM products WHERE products.enabled=1 AND products.size <> '' {$where}) ORDER BY name ASC");
                $tmp_categories = $this->db->results();

                $this->db->query("SELECT * FROM categories WHERE parent = '0' ORDER BY name ASC");
                $categories = $this->db->results();
                foreach ($categories as $k=>$category) {
                    $category->subcategories = array();
                    foreach ($tmp_categories as $tmp_category) {
                        if ($category->category_id == $tmp_category->parent) {
                            $category->subcategories[] = $tmp_category;
                        }
                    }
                    if ( !count($category->subcategories) ) {
                        unset($categories[$k]);
                    }
                }
                // проверяем вдруг это Stefano Ricci для простого пользователя, тогда подсовываем ему красивую страницу
                $resultsr = strpos($_SERVER[REQUEST_URI], 'stefano-ricci');
                if ($resultsr == true) {
                    header("Location: /stefano_ricci/");
                    die();
                }

                // проверяем вдруг это Шубизм для мужиков
                $resultsr = strpos($_SERVER[REQUEST_URI], 'furs');
                if ($resultsr == true && $_COOKIE['sex'] == 1) {
                    header("Location: /show_fur/");
                    die();
                }

                $this->smarty->assign('filter_url', $filter_url = '/catalog/?' . implode('&', $filter_url));
                $this->smarty->assign('filter_url_encode', urlencode($filter_url));
                $this->smarty->assign('categories_full', $categories);

                if ($this->settings->theme == 'mobile' || $this->settings->theme == 'application') {
                    $this->smarty->assign('searchfail', true);
                    $this->smarty->assign('main_page', true);
                    $this->body = $this->smarty->fetch('main_categories.tpl');
                    return $this->body;
                }
                else {
                    $this->body = $this->smarty->fetch('catalogwallfail.tpl');
                }
                return $this->body;
            }


            if ( (isset($json_obj->categories) && count($json_obj->categories) > 0) || (isset($json_obj->csizes) && count($json_obj->csizes) > 0) || (isset($json_obj->fsizes) && count($json_obj->fsizes) > 0) || (isset($json_obj->materials) && count($json_obj->materials) > 0) ) {
                $listbrands = Array();
                foreach ($brands as $br) {
                    $listbrands[] = "{$br->id}";
                }
                $listbrands = json_encode($listbrands);
            }
            else {
                $listbrands = null;
            }

            if ( (isset($json_obj->brands) && count($json_obj->brands) > 0) || (isset($json_obj->csizes) && count($json_obj->csizes) > 0) || (isset($json_obj->fsizes) && count($json_obj->fsizes) > 0) || (isset($json_obj->materials) && count($json_obj->materials) > 0) ) {
                $listcateg = Array();
                foreach ($categories as $ctg) {
                    $listcateg[] = "{$ctg->id}";
                }
                $listcateg = json_encode($listcateg);
            }
            else {
                $listcateg = null;
            }

            if ( (isset($json_obj->brands) && count($json_obj->brands) > 0) || (isset($json_obj->categories) && count($json_obj->categories) > 0) || (isset($json_obj->csizes) && count($json_obj->csizes) > 0) || (isset($json_obj->fsizes) && count($json_obj->fsizes) > 0) ) {
                $listmater = Array();
                foreach ($materials as $mat) {
                    $listmater[] = "{$mat->material_id}";
                }
                $listmater = json_encode($listmater);
            }
            else {
                $listmater = null;
            }
        }

        if (!isset($json_obj->sizes) || count($json_obj->sizes) == 0) {
            $listsizes = Array();
            foreach ($sizes as $szs) {
                $listsizes[] = "{$szs->size}";
            }
            $listsizes = json_encode($listsizes);
        }
        else {
            $listsizes = null;
        }

        $criteo_p_list = array();
        $hbs = $this->db->results("SELECT brand_id FROM brands WHERE hidden = 1");
        foreach ($hbs as $hb) {
            $hidden_brands[] = $hb->brand_id;
        }
        if (is_array($products) && count($products)) {
            foreach ($products as $k=>$v) {
                $products[$k]->show_price = empty($v->prop_val);
                $products[$k]->brand      = strtoupper($v->brand);
                if (!empty($big_size)) {
                    $sizes_s = array();
                    $sizes_xx = $this->db->results("SELECT * FROM items WHERE product_id = {$v->product_id}");
                    foreach ($sizes_xx as $key => $value) {
                        if (strpos($value->normal_size, 'L') !== false) {
                            $sizes_s[] = "<span class='big_black_text'>" . $value->size . "</span>";
                        }
                        else {
                            $sizes_s[] = $value->size;
                        }
                    }
                    $products[$k]->size = implode(", ", $sizes_s);
                }
                else {
                    $products[$k]->size = str_replace("|", ", ", trim($products[$k]->size, "|"));
                }
                if (!empty($v->s_material)){
                    $name = 'name';
                    if($_COOKIE['language'] == 'eng'){$name = 'eng_name AS name';}

                    $query = sql_placeholder("SELECT {$name}, description FROM s_materials WHERE material_id IN (".$v->s_material.")");
                    $this->db->query($query);
                    $products[$k]->s_material = $this->db->results();
                }
                if (!in_array($products[$k]->brand_id, $hidden_brands) && $products[$k]->cat_enabled == 1 && count($criteo_p_list) < 3){
                    $criteo_p_list[] = $this->db->result("SELECT barcode FROM items WHERE product_id = '{$v->product_id}'")->barcode;
                }
            }
        }
        $this->smarty->assign('criteo_p_list', implode(', ',$criteo_p_list));

        $filtersizes = array("clothes" => array(), "footwear" => array());
        $filtersizes_api_old = array("clothes" => array(), "footwear" => array());
        foreach ($sizes as $key => $value) {
            if ($value->parent == 1) {
                array_push($filtersizes['clothes'], $value->size);
            }
            elseif ($value->parent == 2 || $value->category_id == 2) {
                array_push($filtersizes['footwear'], $value->size);
            }
        }

        if ($this->settings->theme == 'api' && isset($_GET['categories'])) {
            foreach ($categories as $category){unset($category->url);}
            if($this->settings->theme_v == 'v2'){
              $return->obj = $categories;
              $return = $this->format_api_response($return);
            }
            else{$return->categories = $categories;}
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
            die();
        }
        if(isset($_GET['user_id']) && !empty($_GET['user_id']) && $this->settings->theme == 'api') $user_group = $this->db->result("SELECT group_id FROM users WHERE user_id = '{$_GET['user_id']}'")->group_id;
        if ((!empty($_SESSION['user']->user_id) && in_array($_SESSION['user']->user_id, array(4877,1330,1334,14029,137520,135534))) || ($this->settings->theme == 'api' && ($user_group == 2 || in_array($_GET['user_id'], array(126903,13973,14029,137520,135534))))){
          $test_p = $this->db->result($sql="SELECT products.*, '' as brand, 0 as offline_only, 0 as hide_sizes, 0 as golden_sale, 0 as no_sale, '' as category, '' as parent, 1 as cat_enabled, '' as prop_val, 0 as tsum_price FROM products WHERE sku = 'testproduct'");
          array_unshift($products, $test_p);
        }

        if ($this->settings->theme == 'api' && (isset($_GET['products']) || isset($search))) {
            if($filters_only === false){
                $image_link = 'https://lsboutique.ru';
                if ($this->config->image_link) $image_link = 'https:'.$this->config->image_link;
                foreach ($products as $product){
                    $product->videoID = substr($product->video, -11);
                    $product->price = strpos($product->price,'.') !=false ? $product->price .'' : $product->price . '.00';
                    $product->last_price_online = $product->price;
                    if(($product->offline_price == $product->price && $product->old_price == 0) || $product->old_price == $product->price){
                        unset($product->offline_price, $product->old_price);
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
                    unset($product->code,$product->offline_price,$product->sku,$product->old_url,$product->tsum_url,$product->guarantee,$product->seo_words,$product->quantity,$product->sold,
                    $product->hit,$product->order_num,$product->download,$product->meta_title,$product->meta_keywords,$product->meta_description,$product->description,
                    $product->created,$product->new_stuff,$product->modified,$product->sold_date,$product->desc_date,$product->editor_id,$product->body,
                    $product->last_price_update,$product->pack_id,$product->photo_added,$product->prop_val,$product->tsum_price,$product->old_price,$product->text_sizes,
                    $product->second_image,$product->week,$product->show_price,$product->enabled,$product->small_image,$product->large_image,$product->uhod,
                    $product->bsize_small_image,$product->bsize_large_image,$product->brand_url,$product->category_url,$product->eng_text_sizes,$product->eng_uhod,$product->eng_body,
                    $product->eng_description,$product->trello_card,$product->video_added,$product->sizes_max_count,$product->col_code,$product->coll_active,$product->cat_enabled,$product->video);
                }
                $return->products = $products;
            }
            foreach ($categories as $category){
                unset($category->url,$category->prod_count_m,$category->prod_count_w);
            }
            $return->sizes = $filtersizes;
            $return->materials = $materials;
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

        if (isset($_SESSION['one_click_ordered'])){
            $oc_ordered = $_SESSION['one_click_ordered'];
            unset($_SESSION['one_click_ordered']);
            $oc_ordered = $this->db->get_row($sql = "SELECT * FROM `one_click` WHERE `id` = {$oc_ordered}; ");
            $oc_ordered_product = $this->db->get_row($sql = "SELECT products.*, items.barcode, brands.name as brand_name, categories.enabled as cat_enabled, categories.name as category
                                                                        FROM products
                                                                        LEFT JOIN brands ON products.brand_id = brands.brand_id
                                                                        LEFT JOIN categories ON products.category_id = categories.category_id
                                                                        LEFT JOIN items ON products.product_id = items.product_id
                                                                        WHERE categories.enabled = 1 AND brands.visibility <= 1 AND brands.offline_only = 0 AND brands.hidden = 0 AND products.product_id = {$oc_ordered->product_id}
                                                                        GROUP BY products.product_id; ");
            if($oc_ordered_product){
              $oc_ordered_product->prices = $user->product_prices($oc_ordered_product);
              $oc_ordered_product->price = $oc_ordered_product->prices['personal_price'];
              $this->smarty->assign('oc_ordered', $oc_ordered);
              $this->smarty->assign('oc_ordered_product', $oc_ordered_product);
            }
        }

        if (isset($_SESSION['NEW_USER_ORDER'])){
            $this->smarty->assign('new_user_order', $_SESSION['NEW_USER_ORDER']);
            unset($_SESSION['NEW_USER_ORDER']);
        }

        $currency = new stdClass();
        $currency->sign = 'рублей';
        if ($this->settings->theme == 'application' || $this->settings->theme == 'mobile') {
            $currency->sign = '<span class="rouble">i</span>';
        }
        $this->smarty->assign('currency', $currency);

        $this->smarty->assign('wallproducts', $products);

        $this->smarty->assign('checkallBrands', !empty($checkallBrands) ? $checkallBrands : '');
        $this->smarty->assign('checkall',       !empty($checkall) ? $checkall : '');

        $this->smarty->assign('ecommerce_list', (isset($ecommerce_list) && !empty($ecommerce_list)) ? $ecommerce_list : 'catalog');

        if (!empty($brand_url)){$this->smarty->assign('fbrand', $fbrand);}
        if (!empty($category_url)){$this->smarty->assign('fcat', $fcat);}

        $this->smarty->assign('listcateg', $listcateg);
        $this->smarty->assign('listbrands',   $listbrands);
        $this->smarty->assign('listsizes',   $listsizes);
        $this->smarty->assign('listmater',   $listmater);

        $this->smarty->assign('filtercategories', $categories);
        $this->smarty->assign('filterbrands',   $brands);
        $this->smarty->assign('filtersizes',   $filtersizes);
        $this->smarty->assign('filtermaterials',   $materials);

        $this->smarty->assign('filter_url', $filter_url = '/catalog/?' . implode('&', $filter_url));
        $this->smarty->assign('filter_url_encode', urlencode($filter_url));
        $this->smarty->assign('cart_products', isset($_SESSION['shopping_cart_sizes']) ? array_keys($_SESSION['shopping_cart_sizes']) : array());

        if ($category != 'sale') {
            $this->smarty->assign('parent_name',   $parent_name);
        }

        if (isset($show_categories)) {
            if ($this->settings->theme == 'application') {
                $this->smarty->assign('maincategory', $fcat->name);
            }
            $this->body = $this->smarty->fetch('categories.tpl');
            return $this->body;
        }

        // ajax
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->body = $this->smarty->fetch('items_json.tpl');
            die($this->body);
        }

        // end of ajax
        $this->body = $this->smarty->fetch('catalogwall.tpl');
        return $this->body;
    }



    function copy_products_by_sku() {
        set_time_limit(0);
        $this->db->query("SELECT * FROM colors");
        $colors_tmp = $this->db->results();
        $colors = array();
        foreach ($colors_tmp as $color) {
            $colors[$color->color_id] = $color;
        }

        $this->db->query("SELECT * FROM products WHERE large_image <> '' OR small_image <> ''");
        $products = $this->db->results();

        $folder = date('Y_m_d') . '/';
        @mkdir($_SERVER['DOCUMENT_ROOT'] . '/files/products_by_sku/' . $folder);
        if (is_array($products) && count($products)) {
            foreach ($products as $k=>$v) {
                $image = $v->large_image ? $v->large_image : $v->small_image;
                $image = $_SERVER['DOCUMENT_ROOT'] . '/files/products/' . $image;
                $name  = str_replace('/', '_', $v->sku . '__' . iconv( "utf-8", "windows-1251", $colors[$v->color_id]->name)) . '.jpg';
                if ( is_file($image) && !is_file($_SERVER['DOCUMENT_ROOT'] . '/files/products_by_sku/' . $name) ) {
                    copy($image, $_SERVER['DOCUMENT_ROOT'] . '/files/products_by_sku/' . $name);
                    copy($image, $_SERVER['DOCUMENT_ROOT'] . '/files/products_by_sku/' . $folder . $name);
                    echo $name . '<br>';
                }
            }
        }
        die('ok');
    }
}
