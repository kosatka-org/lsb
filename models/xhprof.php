<?php
class profiler {
    protected static $_runned = false;



    public function start()
    {
        if ( isset($_GET['c_debug']) ) {
            $phone = isset($_COOKIE['save_phone_number']) ? $_COOKIE['save_phone_number'] : (isset($_COOKIE['SAVED_PHONE_NUMBER']) ? $_COOKIE['SAVED_PHONE_NUMBER'] : '');
            $email = isset($_COOKIE['save_email']) ? $_COOKIE['save_email'] : (isset($_COOKIE['SAVED_USER_EMAIL']) ? $_COOKIE['SAVED_USER_EMAIL'] : '');
            echo "window.spnvar = '{$phone}';\n";
            echo "window.sevar  = '{$email}';\n";
            echo "window.unvar  = '"  . $_COOKIE['user_name'] . "';\n";
            die();
        }
        if (extension_loaded('xhprof')) {
            xhprof_enable(XHPROF_FLAGS_CPU + XHPROF_FLAGS_MEMORY);
            self::$_runned = true;
        }
    }



    public function stop()
    {
        if (self::$_runned) {
            include_once $_SERVER['DOCUMENT_ROOT'] . '/third_party/xhprof/xhprof_lib/utils/xhprof_lib.php';
            include_once $_SERVER['DOCUMENT_ROOT'] . '/third_party/xhprof/xhprof_lib/utils/xhprof_runs.php';

            $profiler_namespace = 'lsboutique'; // namespace for your application
            $xhprof_data = xhprof_disable();
            $xhprof_runs = new XHProfRuns_Default($_SERVER['DOCUMENT_ROOT'] . '/third_party/xhprof/reports/');
            $run_id = $xhprof_runs->save_run($xhprof_data, $profiler_namespace);

            // url to the XHProf UI libraries (change the host name and path)
            $profiler_url = sprintf('http://' . $_SERVER['HTTP_HOST'] . '/third_party/xhprof/xhprof_html/index.php?run=%s&source=%s', $run_id, $profiler_namespace);
            echo '<br><br><a href="' . $profiler_url . '" target="_blank">profile</a>';
        }
        else {
            echo '<br><br>Profiler not runned';
        }
    }
}