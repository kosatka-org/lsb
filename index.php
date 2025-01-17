<?php
// Говорим миру, что сайт может быть разным для различных устройств
header("Vary: Accept-Language,Accept-Encoding,User-Agent");

// отрубаем кеш
header('Expires: Sun, 09 May 2010 06:00:00 GMT');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header("Last-Modified: ".gmdate("D, d M Y H:i:s")."GMT");
header("X-Accel-Expires: 0");

define('IS_PAGE_PROFILED', isset($_GET['profiler']) || isset($_GET['c_debug']));
if ( IS_PAGE_PROFILED ) { // Профилировщик php кода
    include_once "models/xhprof.php";
    $profiler = new profiler();
    $profiler->start();
}


// Засекаем время
$time_start = microtime(true);
// Обработка ошибок при выходе
function myShutdownHandler() {
    if (@is_array($e = @error_get_last())) {
        $code = isset($e['type'])   ? $e['type']    : 0;
        $msg  = isset($e['message'])? $e['message'] : '';
        $file = isset($e['file'])   ? $e['file']    : '';
        $line = isset($e['line'])   ? $e['line']    : '';
        if ( $code == 1 || $code == 4  || $code == 16 || $code == 64 ) {
            mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - FATAL ERROR', "Fatal error!\nURL: https://{$_SERVER['SERVER_NAME']}{$_SERVER['REQUEST_URI']}\n\n file: $file, line $line.\n Error: $msg");
            mail('a.shesternina@gmail.com', $_SERVER['SERVER_NAME'] . ' - FATAL ERROR', "Fatal error!\nURL: https://{$_SERVER['SERVER_NAME']}{$_SERVER['REQUEST_URI']}\n\n file: $file, line $line.\n Error: $msg");
            mail('sonicdes@gmail.com', $_SERVER['SERVER_NAME'] . ' - FATAL ERROR', "Fatal error!\nURL: https://{$_SERVER['SERVER_NAME']}{$_SERVER['REQUEST_URI']}\n\n file: $file, line $line.\n Error: $msg");
            echo $file . '   ' . $line . '   ' . $msg . 'Бригада скорой помощи в курсе и уже выехала:)';
        }
    }
}
register_shutdown_function('myShutdownHandler');

# Composer
# Dummy class for Windows
if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
  class Resque {
    public function enqueue( $a, $b, $c) {
      return 0;
    }
  }
}
else {
  if ( is_file($_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php') ) {
    include_once $_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php';
  }
  $bugsnag_api_key = getenv('BUGSNAG_KEY_PHP');
  if ($bugsnag_api_key) {
    $bugsnag = Bugsnag\Client::make(getenv('BUGSNAG_KEY_PHP'));
    $bugsnag->setErrorReportingLevel(E_ERROR | E_PARSE);
    Bugsnag\Handler::registerWithPrevious($bugsnag);
  }
}

// Стабилизируем скрипт
set_time_limit(60);
ini_set('memory_limit',   '256M');
ini_set('display_errors', 'Off');


if ( $_SERVER['REQUEST_URI'] == '/sale/' || $_SERVER['REQUEST_URI'] == '/sale' ) {
    header("Location: /catalog/?category=sale");die();
}
if (($strpos = strpos($_SERVER['REQUEST_URI'], '&amp;amp;')) !== false) {
    $url = str_replace('&amp;amp;','&',$_SERVER['REQUEST_URI']);
    header("Location: $url");die();
}

session_start();

include_once $_SERVER['DOCUMENT_ROOT'] . "/job_queue.php";
include_once $_SERVER['DOCUMENT_ROOT'] . "/sms_api.php";
include_once $_SERVER['DOCUMENT_ROOT'] . "/slack_sender.php";
include_once $_SERVER['DOCUMENT_ROOT'] . '/models/user.php';
include_once $_SERVER['DOCUMENT_ROOT'] . '/Router.php';


$ip = isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : $_SERVER['REMOTE_ADDR'];
if ( $ip != '127.0.0.1' && $_SERVER['SERVER_NAME'] != 'luxurystore.pro' || isset($_GET['test_geo_err']) ) {
    include_once "third_party/syrexgeo/SxGeo.php";
    $SxGeo   = new SxGeo('third_party/syrexgeo/SxGeo.dat');
    $country = $SxGeo->getCountry($ip);

    // IT FR
    if (isset($_GET['geoip_off'])) {
      setcookie('geoip_off', "1", time()+60*60*24*30, '/');
      $_COOKIE['geoip_off'] = 1;
    }

    if ((($country == 'IT' || $country == 'FR') && !$_COOKIE['geoip_off']) || isset($_GET['test_geo_err'])) {
        if ($_SERVER['SERVER_NAME'] == 'api2.lsboutique.ru') {
            $return->error_id = "599";
            if($_COOKIE['language'] == 'eng' || $_GET['lang'] == 'eng'){$return->message = "The application does not work for this region.";}
            else{$return->message = "Приложение не работает для данного региона.";}
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
        } else {
            header("Location: http://it.lsboutique.ru");
        }
        die();
    }
    $geolocation = $country;
    unset($SxGeo);
}
else {
    // echo 'Geo-filter disabled';
}
if ($_SERVER['SERVER_NAME'] == 'luxurystore.pro') {
    global $filter_brands;
    $filter_brands = array(13,66,73,77,103,104,115,124,252,287,305,311,351,353,359,366,368,371,393,413,422,21,123,401,410,443,466);
}

if ( isset($_GET['token']) ) {
    setcookie('token', $_GET['token'], time()+60*60*24*30, '/');
    $_COOKIE['token'] = $_GET['token'];
}

require_once('Site.class.php');
$site = new Site($a = null);

if ( !empty($_SESSION['user']->group_id) && $_SESSION['user']->group_id != 1 ) {
    $site->smarty->assign('is_admin', true);
}
$site->smarty->assign('geolocation', $geolocation);
// Если все хорошо
if($site->fetch() !== false) {
    // Выводим результат
    print $site->body;
}
else  {
    // Иначе страница об ошибке
    header("http/1.0 404 not found");
    // Подменим переменную, чтобы вывести страницу 404
    $_GET['section'] = '404';
    $site = new Site($a = 0);
    $site->fetch();
    print $site->body;
}

if ( IS_PAGE_PROFILED ) {
    $profiler->stop();
    global $database_object;
    echo '<pre>';
    var_dump($database_object->queries);
}
