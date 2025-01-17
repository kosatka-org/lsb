<?PHP

// отрубаем кеш
header('Expires: Sun, 09 May 2010 06:00:00 GMT');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header("Last-Modified: ".gmdate("D, d M Y H:i:s")."GMT");
header("X-Accel-Expires: 0");

define('IS_PAGE_PROFILED', isset($_GET['profiler']));
if ( IS_PAGE_PROFILED ) { // Профилировщик php кода
    include_once "../models/xhprof.php";
    $profiler = new profiler();
    $profiler->start();
}

function strip_custom_tags($text) {
    return trim(strip_tags( $text, '<p><b><a><i><span><div><br><iframe>' ));
}

// Обработка ошибок при выходе
function myShutdownHandler() {
    if (@is_array($e = @error_get_last())) {
        $code = isset($e['type'])   ? $e['type']    : 0;
        $msg  = isset($e['message'])? $e['message'] : '';
        $file = isset($e['file'])   ? $e['file']    : '';
        $line = isset($e['line'])   ? $e['line']    : '';
        if ( $code == 1 || $code == 4  || $code == 16 || $code == 64 ) {
            mail('sonicdes@gmail.com, tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - FATAL ERROR', "Fatal error!\nURL: http://{$_SERVER['SERVER_NAME']}{$_SERVER['REQUEST_URI']}\n\n file: $file, line $line.\n Error: $msg");
            echo 'Бригада скорой помощи в курсе и уже выехала:)';
        }
    }
}
// Стабилизируем скрипт
set_time_limit(300);
ini_set('memory_limit',   '256M');
ini_set('display_errors', 'Off');
register_shutdown_function('myShutdownHandler');


session_start();

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
}

include_once $_SERVER['DOCUMENT_ROOT'] . "/sms_api.php";
include_once $_SERVER['DOCUMENT_ROOT'] . "/slack_sender.php";
include_once $_SERVER['DOCUMENT_ROOT'] . "/job_queue.php";
include_once $_SERVER['DOCUMENT_ROOT'] . '/models/user.php';

// Засекаем время
$time_start = microtime(true);

include_once 'Page.admin.php';

// Кеширование в админке нам не нужно
Header("Cache-Control: no-cache, must-revalidate");
Header("Pragma: no-cache");

// Page ни от кого не наследуется так что передаем ноль
$page = new Page($a = 0);

$page->smarty->assign('allowed_admin',      luser::is_allowed('admin'));
$page->smarty->assign('allowed_moderator',  luser::is_allowed('moderator'));
$page->smarty->assign('allowed_transport',  luser::is_allowed('transport'));
$page->smarty->assign('allowed_manager',    luser::is_allowed('manager'));
$page->smarty->assign('allowed_accountant', luser::is_allowed('accountant'));
$page->smarty->assign('allowed_copywriter', luser::is_allowed('copywriter'));

$page->fetch();
$page->db->disconnect();

// Выводим страницу на экран
print $page->body;

if ( IS_PAGE_PROFILED ) {
    $profiler->stop();
    global $database_object;
    echo '<pre>';
    var_dump($database_object->queries);
}
