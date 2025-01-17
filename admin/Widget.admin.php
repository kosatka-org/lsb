<?php

////////////////////////////////////////////////
// class Widget - базовый класс для всех модулей
////////////////////////////////////////////////

require_once('../Config.class.php');
require_once('../Database.class.php');
require_once('../models/copywriters.php');


class Widget
{
    var $params = array(); // get-параметры
    var $title = null; // meta-title
    var $description = null; // meta-description
    var $keywords = null; // meta-keywords
    var $body = null; // тело страницы
    var $error_msg = null; // сообщение об ошибке

    var $db; // база данный (класса Database)
    var $smarty; //  шаблонизатор
    var $config; // Config.class.php - класс с найтройками
    var $settings; // настройки сайта (из таблицы settings)
    var $lang;  // язык панели управления
    var $parent;  // родитель текущего объекта (в плане иерархии simpla)
    var $main_currency;  // родитель текущего объекта (в плане иерархии simpla)
    var $use_gd = true;
    var $root_url = '';
    var $root_dir = '';

    var $copywriters;
    var $check_task;
    var $copywriter_fields = array(); // Список полей для копирайтера в конкретной сущности



    // Функция инициализирует задачи копирайтера для фронтенда
    public function prepare_copywriter_tasks( $doc_type, $doc_id ) {
        $doc_id = (int)$doc_id;
        if ( empty($doc_type) || empty($doc_id) || count($this->copywriter_fields) == 0 || !is_array($this->copywriter_fields) ) return false; // Делать нечего - выходим
        foreach ( $this->copywriter_fields as $field ) if (!empty($field)) {
            $this->check_task->$field = $this->copywriters->get_copywriter_tasks(
                array('doc_type' => $doc_type, 'doc_id' => $doc_id, 'field' => $field), true);
        }
        $this->smarty->assign('check_task', $this->check_task);
    }



    // Функция инициализирует задачи копирайтера для фронтенда
    public function process_copywriter_tasks( $doc_type, $doc_id, &$doc, $doc_old ) {
        $doc_id = (int)$doc_id;
        if ( empty($doc_old) || empty($doc) || empty($doc_type) || empty($doc_id) || count($this->copywriter_fields) == 0 || !is_array($this->copywriter_fields) ) return false; // Делать нечего - выходим
        foreach ( $this->copywriter_fields as $field ) if (!empty($field)) {
            $this->do_copywriter_task( $doc_type, $doc_id, $field, $doc->$field, $doc_old->$field );
            // Отправляем в слак
            $message = "Написан текст для <https://lsboutique.ru/admin/index.php?section=CopywriterTasksManager|ID#{$doc_id}> копирайтером {$_SESSION['user']->name}";
            $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "texts_progress" );
            Job::push('SlackJob', $args);
            //дублируем в другую команду
            $channel = "texts_progress";
            $url = "https://hooks.slack.com/services/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";
            send_to_slack($message, $channel, $url);
        }
    }



    // Общая функция для создания или редактирования копирайтерской задачи
    // new_val - отредактирование значение текста
    // old_val - значение из базы
    public function do_copywriter_task($doc_type, $doc_id, $field, &$new_val, $old_val) {
        if ( !is_object($this->check_task) || empty($new_val) || !(empty($old_val) OR ($this->check_task->$field->copywriter_id == $_SESSION['user']->user_id AND in_array($this->check_task->$field->status, array('need_check', 'declined'))))) {
            $new_val = $old_val;
            return false;
        }

        if (!is_object($this->copywriters)) {
            $this->copywriters = new copywriters();
        }

        if ( empty($this->check_task->$field) ) { // Если задачи нет - создаем
            $this->copywriters->add_copywriter_task(array('doc_type'=>$doc_type, 'doc_id'=>$doc_id, 'field'=>$field, 'text'=>$new_val, 'copywriter_id'=>$_SESSION['user']->user_id, 'status'=>'need_check'));
        }
        elseif(     ( in_array($this->check_task->$field->copywriter_id, array(0, $_SESSION['user']->user_id))
                    && in_array($this->check_task->$field->status, array('new', 'declined')))
                OR  ( $this->check_task->$field->copywriter_id == $_SESSION['user']->user_id
                    && in_array($this->check_task->$field->status, array('need_check', 'declined')))) { // Или задача ничья, или копирайтер правит свою задачу
            $this->copywriters->update_copywriter_task($this->check_task->$field->id, array('text'=>$new_val, 'copywriter_id'=>$_SESSION['user']->user_id, 'status'=>'need_check'));
        }
        $new_val = $old_val;
    }



    function stripslashes_recursive($var)
    {
        if(is_array($var))
          foreach($var as $k=>$v)
            $var[$k] = $this->stripslashes_recursive($v);
          else
            $var = stripcslashes($var);
        return $var;
    }

    function Widget(&$parent)
    {
        if (is_object($parent))
        {
            $this->parent=$parent;
            $this->db=&$parent->db;
            $this->smarty=&$parent->smarty;
            $this->config=&$parent->config;
            $this->params=&$parent->params;
            $this->settings=&$parent->settings;
            $this->main_currency=&$parent->main_currency;
            $this->lang=&$parent->lang;
            $this->root_url=&$parent->root_url;
            $this->root_dir=&$parent->root_dir;
            $this->token=&$parent->token;
        }
        else {
            if(get_magic_quotes_gpc()) {
              $_POST = $this->stripslashes_recursive($_POST);
              $_GET = $this->stripslashes_recursive($_GET);
            }

            $this->config=new Config();

            require_once("Language.".$this->config->lang.".admin.php");
            $this->lang = new Language();

            require_once("../third_party/Smarty/libs/Smarty.class.php");
            $this->smarty = new Smarty();
            $this->smarty->compile_check = true;
            $this->smarty->caching = false;
            $this->smarty->cache_lifetime = 0;
            $this->smarty->debugging = false;
            $this->smarty->template_dir = 'templates/';
            $this->smarty->compile_dir = 'compiled/';
            $this->smarty->config_dir = 'configs/';
            $this->smarty->cache_dir = 'cache/';

            global $database_object;
            $this->db = new Database($this->config->dbname, $this->config->dbhost, $this->config->dbuser, $this->config->dbpass);
            $database_object = $this->db;

            $this->db->connect();
            $this->db->query("SET NAMES utf8");

            $query = 'SELECT * FROM settings';
            $this->db->query($query);
            $sts = $this->db->results();
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

            // Определяем корневую директорию сайта
            $this->root_dir = rtrim(dirname(dirname(($_SERVER["PHP_SELF"]))), '/');
            $this->smarty->assign('root_dir', $this->root_dir);

            // Корневой url сайта
            $dir = trim(dirname(dirname($_SERVER['SCRIPT_NAME'])));
            $dir = str_replace("\\", '/', $dir);
            $this->root_url = $_SERVER['HTTP_HOST'];
            if($dir!='/')
                $this->root_url = $this->root_url.$dir;
            $this->smarty->assign('root_url', $this->root_url);


            $query = 'SELECT * FROM currencies WHERE main=1 LIMIT 1';
            $this->db->query($query);
            $this->main_currency = $this->db->result();

            // Если не установлена библиотека GD, не используем ее
            if(!extension_loaded('gd')) $this->use_gd = false;

            $this->smarty->assign('Token', $this->token);

            $this->smarty->assign('UseGd', $this->use_gd);

            $this->smarty->assign('Settings', $this->settings);
            $this->smarty->assign('Config', $this->config);
            $this->smarty->assign('MainCurrency', $this->main_currency);
            $this->smarty->assign('Lang', $this->lang);
        }
    }


    function fetch() {
        $this->body="";
    }



    function ping( $url = '' ) {
        if ( empty($url) ) {
            return false;
        }
        include '../third_party/IXR_Library/IXR_Library.php';

        // Что посылаем в пингах
        // Название сайта
        $siteName = 'интернет магазин фирменной одежды из Италии и Франции - Лакшери стор';
        // Адрес сайта
        $siteURL  = 'https://lsboutique.ru';
        // Адрес страницы, которая изменилась (например)
        $pageURL  = $siteURL . $url;
        // Адрес страницы с фидом
        $feedURL  = 'https://lsboutique.ru/rss/';

        // Яндекс.Блоги
        $pingClient = new IXR_Client('ping.blogs.yandex.ru', '/RPC2');
        $pingClient->query('weblogUpdates.ping', $siteName, $siteURL, $pageURL, $feedURL);

        // Google
        $pingClient = new IXR_Client('blogsearch.google.com', '/ping/RPC2');
        $pingClient->query('weblogUpdates.extendedPing', $siteName, $siteURL, $pageURL, $feedURL);
    }



    function param($name) {
        if (!empty($name)) {
            if(isset($this->params[$name])) {
                return $this->params[$name];
            }
            elseif(isset($_GET[$name])) {
                return $_GET[$name];
            }
        }
        return null;
    }



    function add_param($name) {
        if ( !empty($name) && isset($_GET[$name]) ) {
            $this->params[$name] = $_GET[$name];
            return true;
        }
        return false;
    }



    function form_get($extra_params)
    {
        $copy = $this->params;
        foreach ($extra_params as $key=>$value) {
            if (!is_null($value)) {
                $copy[$key]=$value;
            }
        }
        $get='';
        foreach($copy as $key=>$value) {
            if(strval($value)!="") {
                if (empty($get)) {
                  $get .= '?';
                } else {
                  $get .= '&';
                }
                $get .= urlencode($key).'='.urlencode($value);
            }
        }
        return $get;
    }



    function email($to, $subject, $message)
    {
        $site_name = "=?utf-8?B?".base64_encode($this->settings->site_name)."?=";

        if(!empty($this->settings->notify_from_email))
            $from = "$site_name <".$this->settings->notify_from_email.">";
        else
            $from = "$site_name <simpla@".$_SERVER['HTTP_HOST'].">";

        $headers = "MIME-Version: 1.0\n" ;
        $headers .= "Content-type: text/html; charset=utf-8; \r\n";
        $headers .= "From: $from \r\n";


        $subject = "=?utf-8?B?".base64_encode($subject)."?=";
        @mail($to, $subject, $message, $headers);
    }

    function check_token()
    {
        return true;
    }

    function filter_text($text)
    {
        $Ftext = strip_tags($text, '<p><a><br><div><span>');
        return $Ftext;
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

?>