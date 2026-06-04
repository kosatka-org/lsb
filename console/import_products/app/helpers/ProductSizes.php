<?php

namespace console\import_products\app\helpers;

use stdClass, Exception;

/**
 * Класс для работы размерами товара
 */
class ProductSizes extends _Base
{

    /**
     * Добавить в БД все размеры товара
     *
     * @param int   $productId
     * @param array $productSizes
     * @return void
     * @throws Exception
     */
    public function addAllProductSizes($productId, $productSizes)
    {
        foreach ($productSizes as $product)
            self::addProductSize($productId, $product);
    }

    /**
     * Обновить в БД все размеры товара
     *
     * @param int   $productId
     * @param array $productSizes
     * @return void
     * @throws Exception
     */
    public function updateAllProductSizes($productId, $productSizes)
    {
        if ($newSizes = self::getNewSizes($productId, $productSizes))
            self::addNewSizes($newSizes, $productSizes, $productId);

        foreach ($productSizes as $product)
            self::updateProductSize($productId, $product);
    }

    /**
     * Обновить размер товара в БД
     *
     * @param int      $productId
     * @param stdClass $product
     * @return bool
     * @throws Exception
     */
    protected static function updateProductSize($productId, stdClass $product)
    {
        if (!Products::isAvailable($product))
            return false;

        self::updateProductSizeToDB($productId, $product);

        return true;
    }

    /**
     * Добавить размер товара в БД
     *
     * @param int      $productId
     * @param stdClass $product
     * @return bool
     * @throws Exception
     */
    protected static function addProductSize($productId, stdClass $product)
    {
        if (!Products::isAvailable($product))
            return false;

        self::addProductSizeToDB($productId, $product);

        return true;
    }

    /**
     * Обновить размер товара в БД
     *
     * @param int      $productId
     * @param stdClass $product
     * @return bool
     * @throws Exception
     */
    protected static function updateProductSizeToDB($productId, stdClass $product)
    {
        $quantity = 1000;

        if (!$size = $product->size)
            return false;

        $query = "UPDATE items SET
                      price = ".round($product->base_price  * Products::$priceMultiplier).",
                      quantity = $quantity
                  WHERE product_id = $productId AND size = '$size'
                   ";

        self::$db->query($query);

        return true;
    }

    /**
     * Добавить размер товара в БД
     *
     * @param int      $productId
     * @param stdClass $product
     * @return int|null
     * @throws Exception
     */
    protected static function addProductSizeToDB($productId, stdClass $product)
    {
        $quantity = 1000;

        if (!$size = $product->size)
            throw new Exception("Нет размера у товара ID $productId");

        $query = "INSERT INTO items SET
                      product_id = $productId,
                      size = '$size',
                      price = ".round($product->base_price * Products::$priceMultiplier).",
                      quantity = $quantity
                   ";

        self::$db->query($query);

        return self::$db->insert_id();
    }


    /**
     * Добавить новые размеры из прайса в БД
     *
     * @param array $newSizes
     * @param array $productSizes
     * @param int   $productId
     * @return void
     * @throws Exception
     */
    protected static function addNewSizes($newSizes, $productSizes, $productId)
    {
        foreach ($productSizes as $size => $product) {
            if (!in_array($size, $newSizes))
                continue;

            self::addProductSize($productId, $product);
        }
    }

    /**
     * Получить новые размеры, которые есть в прайсе но нет в БД
     *
     * @param int   $productId
     * @param array $productSizes
     * @return array|null
     */
    protected static function getNewSizes($productId, $productSizes)
    {
        $priceSizes = array_keys($productSizes);

        $dbSizes = self::getSizesOfProduct($productId);

        if (!$dbSizes)
            return $priceSizes;

        return array_diff($priceSizes, $dbSizes);
    }

    /**
     * Получить все размеры товарв в БД
     *
     * @param int $productId
     * @return array|null
     */
    protected static function getSizesOfProduct($productId)
    {
        $query = "SELECT size FROM items WHERE product_id = $productId";

        $sizesDB = self::$db->results($query);

        if (!$sizesDB)
            return null;

        $sizes = [];

        foreach ($sizesDB as $size)
            $sizes[] = $size->size;

        return $sizes;
    }
}
