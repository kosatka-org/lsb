<?php

// Функция для вырезания лишних символов при выводе на FE
function strip_custom_tags($text) {
    return trim(strip_tags( $text, '<p><b><a><i><span><div><br><iframe>' ));
}


function utm($source, $medium, $campaign, $params) {
    if ( empty($source) || empty($medium) || empty($campaign) ) return '';
    global $smarty;
    $smarty->assign('utm_source',   $source);
    $smarty->assign('utm_medium',   $medium);
    $smarty->assign('utm_campaign', $campaign);
    return "&utm_source={$source}&utm_medium={$medium}&utm_campaign={$campaign}";
}

require_once('Config.class.php');
require_once('Database.class.php');
require_once('placeholder.php');
include_once $_SERVER['DOCUMENT_ROOT'] . '/models/user_agent.php';
require_once('third_party/Smarty/libs/Smarty.class.php');


class Widget
{
    var $parent; // Родительский контейнер
    var $params = array(); // get-параметры
    var $title       = null; // meta title
    var $description = null; // meta description
    var $keywords    = null; // metakeywords
    var $body        = null; // содержимое блока

    var $db;       // база данных
    var $smarty;   // смарти
    var $config;   // конфиг (из конфиг-класса)
    var $settings; // параметры сайта (из таблицы settings)
    var $user;     // пользователь, если залогинен
    var $promos;   // акции
    var $currency; // текущая валюта
    var $gd_loaded   = false; // подключена ли графическая библиотека
    var $mobile_user = false; // подключена ли графическая библиотека

    /**
     *
     * Конструктор
     *
     */
    function Widget(&$parent) {
        // если текущий блок входит в некий другой блок
        if (is_object($parent)) {
            // стырить у того все параметры
            $this->parent   =$parent;
            $this->db       =&$parent->db;
            $this->smarty   =&$parent->smarty;
            $this->config   =&$parent->config;
            $this->params   =&$parent->params;
            $this->settings =&$parent->settings;
            $this->user     =&$parent->user;
            $this->promos   =&$parent->promos;
            $this->root_dir =&$parent->root_dir;
            $this->root_url =&$parent->root_url;
            $this->currency =&$parent->currency;
            $this->gd_loaded=&$parent->gd_loaded;
            $this->currencies=&$parent->currencies;
            $this->main_currency=&$parent->main_currency;
        }
        else
        {

            // Читаем конфиг
            $this->config = new Config();
            global $visitorGeolocation;
            $this->config->homeRegion = isset($visitorGeolocation['regionName']) && $visitorGeolocation['regionName'] == $this->config->homeRegion;
            if (!isset($this->config->image_link) || isset($_GET['sw_cdn_test']) || isset($_GET['sw_cdn_test2'])){
                $cdn_image_link = '//lsboutique.ru';
                if (isset($_GET['cdn_test'])){
                    $cdn_image_link = '//lsboutique.cdnvideo.ru';
                }
                if (isset($_GET['sw_cdn_test'])){
                    $cdn_image_link = '//user51680.clients-cdnnow.ru';
                }
                if (isset($_GET['sw_cdn_test2'])){
                    $cdn_image_link = '//cdn.lsboutique.ru';
                }

            }
            else{$cdn_image_link = $this->config->image_link;}

            // Если установлены magic_quotes, убираем лишние слеши
            if(get_magic_quotes_gpc()) {
                $_POST  = $this->stripslashes_recursive($_POST);
                $_GET   = $this->stripslashes_recursive($_GET);
            }

            // Подключаемся к базе данных
            global $database_object;
            $this->db = new Database($this->config->dbname, $this->config->dbhost, $this->config->dbuser, $this->config->dbpass);
            $database_object = $this->db;

            if (!$this->db->connect()) {
                print "Не могу подключиться к базе данных. Проверьте настройки подключения";
                exit();
            }
            $this->db->query('SET NAMES utf8');


            // Выбираем из базы настройки, которые задаются в разделе Настройки в панели управления
            $sts = $this->db->results('SELECT name, value FROM settings');
            $this->settings = new stdClass();
            foreach($sts as $s) {
                $name = $s->name;
                $this->settings->$name = $s->value;
            }
            if ($this->config->enviroment != 'live'){
                $this->settings->rfi_key = '';
                $this->settings->rfi_open_key = '';
            }
            else{
                $key = "rfi_key_".$this->settings->rfi_active;
                $openkey = "rfi_open_key_".$this->settings->rfi_active;
                $this->settings->rfi_key = $this->settings->$key;
                $this->settings->rfi_open_key = $this->settings->$openkey;
            }
            
            // Тащим валюты
            $curs = $this->db->results('SELECT name, LOWER(code) AS code, rate_to, main FROM currencies');
            foreach($curs as $cur) {
              $name = $cur->code;
              $this->currencies->$name = $cur;
            }
            $curs = $this->db->results('SELECT name, sign, LOWER(code) AS code, rate_to, main FROM currencies WHERE def=0');
            

            global $smarty;
            // Настраиваем смарти
            $smarty = $this->smarty = new Smarty();


            // Кеширование контента
            $url  = base64_encode($this->db->escape(urldecode(trim($_SERVER['REQUEST_URI'], '/'))));
            $link = $this->db->results("SELECT * FROM links WHERE link = '{$url}' LIMIT 1");
            if ( !empty($link) ) {
                $link = $link[0];
                $link->tcache = str_replace('_', ' ', base64_decode($link->tcache));
                $link->cache  = base64_decode($link->cache);
                //echo base64_decode($link->link) . ' ' . $link->tcache . ' ' . $link->cache . '<br>';
                $this->smarty->assign('cache_link', $link);
            }

            if ( !empty($_GET['history_back']) ) {
                $this->smarty->assign('history_back', 1);
            }
            elseif ( !empty($_SESSION['USER_MESSAGE']) ) {
                $this->smarty->assign('user_message', $_SESSION['USER_MESSAGE']);
                $_SESSION['USER_MESSAGE'] = '';
            }

            $tmp_url = parse_url($_SERVER['REQUEST_URI']);
            parse_str( !empty($tmp_url['query']) ? $tmp_url['query'] : '', $tmp_get);
            if($_GET['REGION']){$tmp_get['REGION'] = $_GET['REGION'];}
            $region_on_city_page = !empty($tmp_get['REGION']) ? $tmp_get['REGION'] : '';

            if ( isset($_SESSION['user']) ) {
                $region_id = $this->db->get_var("SELECT region_id FROM delivery_cities WHERE city_id = {$_SESSION['user']->city_id} AND country_id = '209' LIMIT 1");
                if ( !empty($region_id) ) {
                    $_SERVER['HTTP_X_REGION'] = $region_id . ',209,' . $_SESSION['user']->city_id;
                }
            }
            if ( isset($_COOKIE['X_REGION']) && !empty($_COOKIE['X_REGION']) ) {
                $_SERVER['HTTP_X_REGION'] = $_COOKIE['X_REGION'];
            }
            if ( isset($_GET['REGION']) && !empty($_GET['REGION']) ) {
                $_SERVER['HTTP_X_REGION'] = $_GET['REGION'];
            }
            if ( isset($region_on_city_page) && !empty($region_on_city_page) ) {
                $_SERVER['HTTP_X_REGION'] = $region_on_city_page;
            }

            if ( isset($_SERVER['HTTP_X_REGION']) ) {
                $region = explode(',', $_SERVER['HTTP_X_REGION']);
                if ( isset($region[1]) && $region[1] == '209' ) {
                    $this->smarty->assign('x_region_id', $region[0]);
                    if ( !empty($region[2]) ) {
                        $region_temp = $this->db->get_var("SELECT city_name FROM delivery_cities WHERE city_id = {$region[2]} AND country_id = '209' LIMIT 1");
                        $city        = $this->db->result("SELECT url, image, image_right FROM cities WHERE city_id = {$region[2]} LIMIT 1");
                        $user        = $this->db->result("SELECT city_id FROM users WHERE original_user_id = {$_SESSION['user']->original_user_id} LIMIT 1");
                        if ( isset($_SESSION['user']) && empty($user->city_id)) {
                            $this->db->query(sql_placeholder(" UPDATE `users` SET city = ?, city_id = ? WHERE original_user_id = ? LIMIT 1; ", $region_temp, $region[2], $_SESSION['user']->original_user_id));
                        }
                        $region_tmp_name = $region_temp;
                        $this->smarty->assign('x_city', $region_temp);
                        $this->smarty->assign('city',   $city);
                    }
                    else{
                        $region = $this->db->get_row("SELECT * FROM delivery_cities WHERE region_id = '{$region[0]}' AND country_id = '209' AND city_is_main = '1' LIMIT 1");
                    }
                    $region = str_replace('респ.', '', (isset($region_tmp_name) ? $region_tmp_name : ''));
                    $this->smarty->assign('x_region',    $region);
                    setcookie('X_REGION', $_SERVER['HTTP_X_REGION'], time()+60*60*24*365, '/');
                }
            }

            $this->smarty->assign('datetime', date('Y-m-d H:i:s'));
            $this->smarty->compile_check  = true;
            $this->smarty->caching        = false;
            $this->smarty->cache_lifetime = 0;
            $this->smarty->debugging      = false;

            // Для мобильного клиента подменяем тему дизайна на мобильную
            $user_agent = new user_agent();

            $this->settings->catalog = new stdClass();
            $this->settings->catalog->page_first = 30;
            $this->settings->catalog->page_limit = 30;

            // Перекрывающий баннер с мехами
            if ( empty($_COOKIE['show_furs']) && date('Y-m-d H:i') > '2015-09-15 18:00' && date('Y-m-d') < '2015-11-01' ) { // Первый раз зашел в каталог
                setcookie("show_furs", '1', time()+3600*6, '/'); // Не показываем 6 часов
                $this->smarty->assign('show_furs', 1);
            }
            
            //Настройка языка
            if (isset($_GET['lang']) || $_COOKIE['language']) {
              if (isset($_GET['lang'])) {
                setcookie("language", $_GET['lang'], time()+3600*24*365*10, '/');
                $_COOKIE['language'] = $_GET['lang'];
              }
              $this->smarty->assign('language', $_COOKIE['language']);
            }

            // Сохраняем выбор адаптивного дизайна
            if (isset($_GET['adaptive'])) {
                setcookie("adaptive", (int)$_GET['adaptive'], time()+3600*24*365*10, '/');
                $_COOKIE['adaptive'] = (int)$_GET['adaptive'];
            }
            if (isset($_GET['old_design'])) {
                setcookie("old_design", (int)$_GET['old_design'], time()+3600*24*365*10, '/');
                $_COOKIE['old_design'] = (int)$_GET['old_design'];
            }

            // Сохраняем выбор мобильной или десктопной версии в Cookie
            if (isset($_GET['mobile'])) {
                setcookie("mobile", (int)$_GET['mobile'], time()+3600*24*365*10, '/');
                $_COOKIE['mobile'] = (int)$_GET['mobile'];
            }

            // Сохраняем выбор НЕмобильной в Cookie
            if ( empty($_COOKIE['notmobile']) ) { // Первый раз показываем сверху серую плашку
                setcookie("notmobile", '1', time()+3600*24*365*10, '/'); //не показываем больше
                $this->smarty->assign('notmobile', 1);
            }

            // Баннер Isaia пошив
            if ( date('Y-m-d H:i') > '2015-09-15 18:00' && date('Y-m-d') < '2015-12-03' ) { // Показываем до 2 декабря включительно
                $this->smarty->assign('show_isaia', 1);
            }

            // Баннер Тотальная распродажа Итальянской верхней одежды
            if ( date('Y-m-d H:i') < '2017-07-13 00:00' ) { // Показываем до 13 июля 00:00
                $this->smarty->assign('show_total_fur', 1);
            }

            // Баннер PreSALE
            if ( date('Y-m-d H:i') < '2016-05-15 15:00' ) { // Показываем до 15 мая 15:00
                $this->smarty->assign('show_presale', 1);
            }

            // Баннер Шубизм
            if ( date('Y-m-d H:i') < '2018-02-01 00:00' ) { // Показываем до 01 февраля 00:00
                $this->smarty->assign('show_super_furs', 1);
            }
            // Определяем нужно ли включать треккинг миксмаркет
            include_once "models/order.php";
            $this->smarty->assign('mixmarket_enabled', orders::mixmarket_enabled($this->config));

            $this->settings->theme     = 'adaptive';
            $this->smarty->compile_dir = 'compiled/adaptive';
            if ( isset($_COOKIE['old_design']) && $_COOKIE['old_design'] == 1 ) {
                $this->settings->theme     = 'default';
                $this->smarty->disable     = true;
                $this->smarty->compile_dir = 'compiled';
            }

            if ( strpos($_SERVER['HTTP_USER_AGENT'], 'iPhone') && strpos($_SERVER['HTTP_USER_AGENT'], '8_') ) {
                $this->settings->catalog->page_first = 10;
                $this->settings->catalog->page_limit = 10;
            }

            if ( @$_COOKIE['mobile'] == 1 /*|| strpos($_SERVER['SERVER_NAME'], 'dev') === false && @$_COOKIE['old_design'] != 1 && strpos($_SERVER['HTTP_USER_AGENT'], 'iPhone') && strpos($_SERVER['HTTP_USER_AGENT'], '8_')*/ ) {
                $this->settings->theme = 'mobile';
                $this->smarty->disable = true;
                $this->smarty->compile_dir = 'compiled/mobile';
            }
            // Однозначно показываем версию для приложения
            if ( strpos($_SERVER['SERVER_NAME'], 'mobile.') !== false ) {
                $this->settings->theme = 'application';
                $this->smarty->disable = true;
                $this->smarty->compile_dir = 'compiled/application';
            }

            // Версия для API
            if ( strpos($_SERVER['SERVER_NAME'], 'api2.') !== false ) {
                $this->settings->theme = 'api';
                if ( strpos($_SERVER['REQUEST_URI'], '/v2/') !== false ) {
                  $this->settings->theme_v = 'v2';
                  $_SERVER['REQUEST_URI'] = str_replace('/v2/','/',$_SERVER['REQUEST_URI']);
                }
                if (!isset($_GET['lang'])) {unset($_COOKIE['language']);}
                $this->smarty->disable = true;
                $this->smarty->compile_dir = 'compiled/api';
            }

            // Для lstore.moscow
            if ( strpos($_SERVER['SERVER_NAME'], 'lstore.moscow') !== false ) {
                $this->settings->theme = 'discount';
                $this->smarty->disable = true;
                $this->smarty->compile_dir = 'compiled/discount';
                if ( $_SERVER['REQUEST_URI'] == '/' ) $_SERVER['REQUEST_URI'] = '/catalog/?category=megasale';
            }

            // Определение iPhone
            // $user_agent->is_mobile('iphone') || $user_agent->is_mobile('ipod') || $user_agent->is_mobile('ipad')

            $this->smarty->assign('cdn_image_link',   $cdn_image_link);
            $this->smarty->assign('browser',   $user_agent->browser());
            $this->smarty->assign('is_mobile', $user_agent->is_mobile());
            $this->smarty->assign('is_iphone', $user_agent->is_mobile('iphone'));
            $this->smarty->assign('is_ipod',   $user_agent->is_mobile('ipod'));
            $this->smarty->assign('is_ipad',   $user_agent->is_mobile('ipad'));
            $this->smarty->template_dir = 'design/'.$this->settings->theme.'/html';
            $this->smarty->config_dir   = 'configs';
            $this->smarty->cache_dir    = 'cache';

            $this->smarty->assign('cat_currencies', $curs);
            $this->smarty->assign('currencies', $this->currencies);
            $this->smarty->assign('settings', $this->settings);
            $this->smarty->assign('config',   $this->config);

            $this->smarty->assign('rfi_open_key', $this->settings->rfi_open_key);
            $this->smarty->assign('preorder_id',  rand(1000000, 10000000));

            // Активные акции
            $promo_tmp = $this->db->results("SELECT * FROM promo WHERE enabled = 1");
            $promo = array();
            foreach ($promo_tmp as $i => $v) {
                $promo[$v->name] = $v;
                if (!empty($v->brands)) {
                    $promo[$v->name]->brands_array = $this->db->results("SELECT * FROM brands WHERE brand_id IN ({$v->brands})");
                }
            }
            $this->promos = $promo;
            $this->smarty->assign('promos', $this->promos);


            // Определяем корневую директорию сайта
            $this->root_dir = str_replace(basename($_SERVER["PHP_SELF"]), '', $_SERVER["PHP_SELF"]);
            $this->smarty->assign('root_dir', $this->root_dir);

            // Корневой url сайта
            $dir = str_replace("\\", '/', trim(dirname($_SERVER['SCRIPT_NAME'])));
            $this->root_url = $_SERVER['HTTP_HOST'];
            if ($dir!='/') $this->root_url = $this->root_url.$dir;
            $this->smarty->assign('root_url', $this->root_url);

            // проверяем на роботов
            $user_obj = new luser();
            $user_obj->check_robots(); 
            
            // Залогиниваем юзера
            $this->user = null;
            if ( !isset($_SESSION['user']) && !empty($_COOKIE['user_id']) && !empty($_COOKIE['hashcode']) ) {
                $params = array(    'user_id'       => $_COOKIE['user_id'],
                                    'password'      => $_COOKIE['hashcode'] );
                $user_cookie = $user_obj->found($params, false);
                if ( !empty($user_cookie->original_user_id) ) {
                    $user_obj->login($user_cookie->original_user_id);
                    header("Location: {$_SERVER['REQUEST_URI']}");
                    die();
                }
            }
            if( isset($_SESSION['user']) ) {
                if ( !$user_obj->check_user(array(
                    'phone_number' => $_SESSION['user']->phone_number,
                    'card_number'  => $_SESSION['user']->card_number,
                    'user_id'      => $_SESSION['user']->user_id,
                    'password'     => $_SESSION['user']->password)) ) {
                    $user_obj->logout();
                    header("Location: /");
                    die();
                }
                $this->user = $_SESSION['user'];
                $this->smarty->assign('user', $_SESSION['user']);
            }
            if( $this->settings->theme == 'api' && isset($_GET['user_id']) && !empty($_GET['user_id']) ) {
              $user_id = (int)$_GET['user_id'];
              $currency = isset($_GET['currency']) ? $_GET['currency'] : '';
              $user_obj->api_login($user_id, $currency);
            }
            
            if ((!isset($_SESSION['user']) && empty($_COOKIE['user_id']) && empty($_COOKIE['hashcode'])) && (!isset($_COOKIE['session_id']) || empty($_COOKIE['session_id']))){
                $user_obj->set_session_id();
            }

            $currency = new stdClass();
            $currency->sign = 'руб';
            if ($this->settings->theme == 'application' || $this->settings->theme == 'mobile') {
                $currency->sign = '<span class="rouble">i</span>';
            }
            $this->smarty->assign('currency', $currency);

            $this->smarty->assign('pages_menu', $this->db->results("SELECT * FROM sections WHERE menu_id = '1' AND enabled = '1' ORDER BY order_num"));
        }
    }



    function fetch() {
        return $this->body="";
    }



    function stripslashes_recursive($var) {
        $res = null;
        if(is_array($var))
          foreach($var as $k=>$v)
            $res[stripcslashes($k)] = $this->stripslashes_recursive($v);
          else
            $res = stripcslashes($var);
        return $res;
    }



    function param($name) {
        if (!empty($name)) {
            if (isset($this->params[$name])) {
                return $this->params[$name];
            }
            elseif(isset($_GET[$name])) {
                return $_GET[$name];
            }
            else {
                $tmp = parse_url($_SERVER['REQUEST_URI']);
                if ( !empty($tmp['query']) ) {
                    parse_str($tmp['query'], $tmp);
                    if (isset($tmp[$name])) return $tmp[$name];
                }
            }
        }
        return null;
    }



    function add_param($name) {
        if (!empty($name) && isset($_GET[$name])) {
            $this->params[$name] = $_GET[$name];
            return true;
        }
        return false;
    }



    function url_filter($val) {
        $val =  preg_replace('/[^A-zА-я0-9_\-\.\%\s]/ui', '', $val);
        return $val;
    }

    function url_filtered_param($name)
    {
        return $this->url_filter($this->param($name));
    }

    function form_get($extra_params)
    {
        $copy=$this->params;
        foreach($extra_params as $key=>$value)
        {
            if(!is_null($value))
            {
                $copy[$key]=$value;
            }
        }

        $get='';
        foreach($copy as $key=>$value)
        {
            if(strval($value)!="")
            {
                if(empty($get))
                  $get .= '?';
                else
                  $get .= '&';
                $get .= urlencode($key).'='.urlencode($value);
            }
        }
        return $get;
    }
    
    
    function gaParseCookie() {
      $cid = 88888;//это на случай ошибки
      if (isset($_COOKIE['_ga'])) {
        list($version,$domainDepth, $cid1, $cid2) = split('[\.]', $_COOKIE["_ga"],4);
        $contents = array('version' => $version, 'domainDepth' => $domainDepth, 'cid' => $cid1.'.'.$cid2);
        $cid = $contents['cid'];
      }
      else $cid = '';//gaGenUUID();
      return $cid;
    }

    function email($to, $subject, $message, $from = '') {
        if (empty($from)) {
            $site_name = "=?utf-8?B?".base64_encode($this->settings->site_name)."?=";
            $from = "{$site_name} <".$this->settings->notify_from_email.">";
        }

        $headers = "MIME-Version: 1.0\n" ;
        $headers .= "Content-type: text/html; charset=utf-8; \r\n";
        $headers .= "From: {$from} \r\n";

        $subject = "=?utf-8?B?".base64_encode($subject)."?=";

        @mail($to, $subject, $message, $headers);

        return $this;
    }
    
    function email_attach($to, $subject, $message, $from = '', $path, $name) {
        /* Email Detials */
        $mail_to = $to;
        $from_mail = $from;
        $from_name = "Test";
        $reply_to = "noreply";
        $subject = $subject;
        $message = $message;
     
        // Attaching File
        $file_name = $name;
        $path = $path;
         
        // Read the file content
        $file = $path.$file_name;
        $file_size = filesize($file);
        $handle = fopen($file, "r");
        $content = fread($handle, $file_size);
        fclose($handle);
        $content = chunk_split(base64_encode($content));
         
        // Set header
        // Generate a boundary
        $boundary = md5(uniqid(time()));
         
        // Email header
        $header = "From: ".$from_name." \r\n";
        $header .= "Reply-To: ".$reply_to."\r\n";
        $header .= "MIME-Version: 1.0\r\n";
         
        // Multipart wraps the Email Content and Attachment
        $header .= "Content-Type: multipart/mixed;\r\n";
        $header .= " boundary=\"".$boundary."\"";
     
        $message .= "This is a multi-part message in MIME format.\r\n\r\n";
        $message .= "--".$boundary."\r\n";
         
        // Email content
        // Content-type can be text/plain or text/html
        $message .= "Content-Type: text/plain; charset=\"iso-8859-1\"\r\n";
        $message .= "Content-Transfer-Encoding: 7bit\r\n";
        $message .= "\r\n";
        $message .= "$message_body\r\n";
        $message .= "--".$boundary."\r\n";
         
        // Attachment
        // Edit content type for different file extensions
        $message .= "Content-Type: application/xml;\r\n";
        $message .= " name=\"".$file_name."\"\r\n";
        $message .= "Content-Transfer-Encoding: base64\r\n";
        $message .= "Content-Disposition: attachment;\r\n";
        $message .= " filename=\"".$file_name."\"\r\n";
        $message .= "\r\n".$content."\r\n";
        $message .= "--".$boundary."--\r\n";
         
        // Send email
        if (mail($mail_to, $subject, $message, $header)) {
            echo "Sent";
        } else {
            echo "Error";
        }
    }
    
    function format_field($key, $item){
      if (is_object($item) || is_array($item)){
        $f_item = $this->format_loop($key,$item);
      }
      else{
        $f_item = $item;
        if(in_array(strtolower($item),array('1','0','true','false')) && strpos($key, 'sex') === false && strpos($key, 'price') === false && strpos($key, 'count') === false && strpos($key, 'id') === false && strpos($key, 'deposit') === false && strpos($key, 'status') === false){
          if($item === '1' || $item === 'true'){$f_item = true;}
          elseif($item === '0' || $item === 'false'){$f_item = false;}
        }
        elseif(is_numeric($item)){
          $f_item = (float)$item;
        }
        elseif(is_string($item)){$f_item = mysql_real_escape_string($item);}

      }
      return $f_item;
    }
    function format_loop($key,$item) {
      $f_item = $item;
      foreach ($item as $key => $field){
        $f_item->$key = $this->format_field($key,$field);
      }
      
      return $f_item;
    }
    function format_api_response($object) {
      foreach ($object as $key => $item){
        if (is_object($item) || is_array($item)){
          $item->$key = $this->format_loop($key,$item);
        }
        else{$item->$key = $this->format_field($key,$item);}
        
      }
      //var_dump($object);
      return $object;
    }
    
    function rus_date() {
      $translate = array(
        "am" => "дп",
        "pm" => "пп",
        "AM" => "ДП",
        "PM" => "ПП",
        "Monday" => "Понедельник",
        "Mon" => "Пн",
        "Tuesday" => "Вторник",
        "Tue" => "Вт",
        "Wednesday" => "Среда",
        "Wed" => "Ср",
        "Thursday" => "Четверг",
        "Thu" => "Чт",
        "Friday" => "Пятница",
        "Fri" => "Пт",
        "Saturday" => "Суббота",
        "Sat" => "Сб",
        "Sunday" => "Воскресенье",
        "Sun" => "Вс",
        "January" => "Января",
        "Jan" => "Янв",
        "February" => "Февраля",
        "Feb" => "Фев",
        "March" => "Марта",
        "Mar" => "Мар",
        "April" => "Апреля",
        "Apr" => "Апр",
        "May" => "Мая",
        "May" => "Мая",
        "June" => "Июня",
        "Jun" => "Июн",
        "July" => "Июля",
        "Jul" => "Июл",
        "August" => "Августа",
        "Aug" => "Авг",
        "September" => "Сентября",
        "Sep" => "Сен",
        "October" => "Октября",
        "Oct" => "Окт",
        "November" => "Ноября",
        "Nov" => "Ноя",
        "December" => "Декабря",
        "Dec" => "Дек",
        "st" => "ое",
        "nd" => "ое",
        "rd" => "е",
        "th" => "ое"
      );
      if (func_num_args() > 1) {
        $timestamp = func_get_arg(1);
        return strtr(date(func_get_arg(0), $timestamp), $translate);
      } 
      else {
        return strtr(date(func_get_arg(0)), $translate);
      }
    }
}

