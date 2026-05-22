<?php

namespace console\import_products\app\helpers;

use Database, Config, Exception;

/**
 * Класс для импорта товаров в БД
 */
class Products
{
    /* @var $db Database */
    protected static $db;

    public static function importProducts($products)
    {
        self::initDb();

        foreach ($products as $sku => $productSizes) {
            $productId = self::addProduct(current($productSizes));
        }
    }

    protected static function addProduct($product)
    {
        if (!$product->available_for_marketplace_qty or !$product->other_shops_qty)
            return null;

        $name = $product->wb_product->title ?: $product->ozon_product->title;

        $query = "INSERT INTO products SET model = '$name'";

        self::$db->query($query);

        echo "TODO";
        exit;
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

        self::$db = new Database($config->dbname, $config->dbhost, $config->dbuser, $config->dbpass);

        self::$db->connect();

        self::$db->query('SET NAMES UTF8');
    }
}
