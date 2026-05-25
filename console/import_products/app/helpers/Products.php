<?php

namespace console\import_products\app\helpers;

use Exception, stdClass;
use helpers\StringHelper;

/**
 * Класс для импорта товаров в БД
 */
class Products extends _Base
{
    /**
     * @param $products
     * @return void
     * @throws Exception
     */
    public function importProducts($products)
    {
        foreach ($products as $sku => $productSizes) {
            $product = current($productSizes);

            if (!self::isAvailable($product))
                continue;

            self::addProduct($product);
        }
    }

    /**
     * @param stdClass $product
     * @return void
     * @throws Exception
     */
    protected static function addProduct(stdClass $product)
    {
        $params = [
            'model'    => $name = self::getProductName($product),
            'brand_id' => self::getDBBrandId($product),
            'sex'      => self::getGender($product),
        ];

        $id = self::addProductToDB($params);

        self::updateUrl($id, $name);

        (new Categories)->updateProductCategory($id, $product);

        echo "TODO";
        exit;
    }

    /**
     * Добавить товар в БД
     *
     * @param array $params
     * @return int
     * @throws Exception
     */
    protected static function addProductToDB(array $params)
    {
        $query = '';

        foreach ($params as $key => $value)
            $query .= "$key = '$value', ";

        $query = trim($query, ', ');

        $query = "INSERT INTO products SET $query";

        self::$db->query($query);

        $id = self::$db->insert_id();

        if (!$id)
            throw new Exception('Empty last insert id');

        return $id;
    }

    /**
     * Получить имя продукта
     *
     * @param stdClass $product
     * @return string mixed
     * @throws Exception
     */
    protected static function getProductName(stdClass $product)
    {
        $name = $product->wb_product->title ?: $product->ozon_product->title;

        if (!$name)
            throw new Exception('Empty product name');

        return $name;
    }

    /**
     * Получить id брендов в БД для Адамаса и Светлова
     *
     * @param stdClass $product
     * @return int
     * @throws Exception
     */
    protected static function getDBBrandId(stdClass $product)
    {
        switch ($brand = $product->wb_product->brand) {
            case 'ADAMAS':
                return 494;
            case 'SVETLOV':
                return 495;
            default:
                throw new Exception("Unknown brand '$brand'");
        }
    }


    /**
     * Обновить url товара
     *
     * @param $id
     * @param $name
     * @return void
     * @throws Exception
     */
    protected static function updateUrl($id, $name)
    {
        if (!$id or !$name)
            throw new Exception('Empty id or name');

        $url = $id.'-'.StringHelper::translit($name);

        $query = "UPDATE products SET url = '$url' WHERE product_id = $id";

        self::$db->query($query);
    }

    /**
     * Товар доступен?
     *
     * @param stdClass $product
     * @return bool
     */
    protected static function isAvailable(stdClass $product)
    {
        return $product->available_for_marketplace_qty and $product->wb_product and $product->ozon_product;
    }
}
