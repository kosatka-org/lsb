<?php

use console\import_products\app\Import;

if (PHP_SAPI != 'cli')
    exit('Run only in console');

ini_set('memory_limit', '2G');

require_once __DIR__.'/../../vendor/autoload.php';

require_once __DIR__.'/../../include/autoload.php';

Import::import();
