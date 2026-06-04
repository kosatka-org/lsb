<?php

namespace console\import_products\app\helpers;

use helpers\StringHelper;
use stdClass, Exception;

/**
 * Класс для работы с таблицей продуктов в БД
 */
class ProductDB extends _Base
{
    /**
     * Добавить товар в БД
     *
     * @param stdClass $product
     * @return int
     * @throws Exception
     */
    public function addProduct(stdClass $product)
    {
        $params = self::getParams($product);

        $id = self::addProductToDB($params);

        self::commonUpdFunc($id, $product);

        return $id;
    }

    /**
     * Обновить товар в БД
     *
     * @param string   $sku
     * @param stdClass $product
     * @return int
     * @throws Exception
     */
    public function updateProduct($sku, stdClass $product)
    {
        $productDB = (new ImportedProducts)->getProductBySku($sku);

        if (!$productDB)
            throw new Exception("Can't find product with sku '$sku'");

        $productId = $productDB->product_id;

        $params = self::getParams($product);

        self::updateProductInDB($productId, $params);

        self::commonUpdFunc($productId, $product);

        return $productId;
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
        $query = "INSERT INTO products SET ".self::createSetQuery($params);

        self::$db->query($query);

        $id = self::$db->insert_id();

        if (!$id)
            throw new Exception('Empty last insert id');

        return $id;
    }

    /**
     * Обновить товар в БД
     *
     * @param int   $productId
     * @param array $params
     * @return void
     * @throws Exception
     */
    protected static function updateProductInDB($productId, $params)
    {
        if (!$productId)
            throw new Exception('Empty product id');

        $query = "UPDATE products SET ".self::createSetQuery($params)." WHERE product_id = $productId LIMIT 1";

        self::$db->query($query);
    }


    /**
     * Общие операции обновления товара в БД при добавлении/обновлении товара
     *
     * @param int      $productId
     * @param stdClass $product
     * @return void
     * @throws Exception
     */
    protected static function commonUpdFunc($productId, stdClass $product)
    {
        self::updateUrl($productId, Products::getProductName($product));

        (new Categories)->updateProductCategory($productId, $product);

        (new Colors)->updateProductColor($productId, $product);
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
     * Получить параметры для добавления/обновления товара в БД
     *
     * @param stdClass $product
     * @return array
     * @throws Exception
     */
    protected static function getParams(stdClass $product)
    {
        return [
            'model'    => Products::getProductName($product),
            'sku'      => $product->sku,
            'price'    => round($product->base_price  * Products::$priceMultiplier),
            'brand_id' => Products::getDBBrandId($product),
            'sex'      => self::getGender($product),
        ];
    }

    /**
     * Создать SET часть SQL-запроса
     *
     * @param array $params
     * @return string
     */
    protected static function createSetQuery(array $params)
    {
        $query = '';

        foreach ($params as $key => $value)
            $query .= "$key = '$value', ";

        return trim($query, ', ');
    }
}
