<?php

spl_autoload_register(function ($class) {
    $files[] = realpath(__DIR__.'/../').DIRECTORY_SEPARATOR.$class.'.php';
    $files[] = realpath(__DIR__.'/../').DIRECTORY_SEPARATOR.$class.'.class.php';

    foreach ($files as &$file) {
        $file = str_replace('\\', '/', $file);

        is_file($file) and require_once $file;
    }
});
