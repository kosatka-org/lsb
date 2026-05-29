<?php

namespace console\import_products\app\helpers;

use Database, Config, stdClass, Exception;

/**
 * Базовый класс для классов импорта
 */
abstract class _Base
{
    /* @var $db Database */
    protected static $db;

    /**
     * @throws Exception
     */
    public function __construct()
    {
        self::initDb();
    }

    /**
     * Получить пол для товара
     *
     * @param stdClass $product
     * @return int
     * @throws Exception
     */
    protected static function getGender(stdClass $product)
    {
        $genders = [];

        foreach ($product->wb_product->characteristics as $characteristic) {
            if ($characteristic->id != 204557)
                continue;

            foreach ($characteristic->value as $gender) {
                $genders[] = $gender;
            }
        }

        if (!$genders or in_array('Детский', $genders) or (in_array('Женский', $genders) and in_array('Мужской', $genders)))
            return 0;

        if (in_array('Мужской', $genders))
            return 1;

        if (in_array('Женский', $genders) or in_array('Девочки', $genders))
            return 2;

        throw new Exception("Can't find gender in product {$product->id}");
    }

    /**
     * Инициализация БД
     *
     * @return void
     * @throws Exception
     */
    protected static function initDb()
    {
        require_once __DIR__.'/../../../../Config.class.php';

        $config = new Config;

        self::$db = $db = new Database($config->dbname, $config->dbhost, $config->dbuser, $config->dbpass);

        $db::$exceptionOnError = true;

        $db->connect();

        $db->query('SET NAMES UTF8');
    }

    /**
     * Вывести строку в консоль
     *
     * @param string $str
     * @return void
     */
    public static function print_l($str)
    {
        echo $str.PHP_EOL;
    }
}
