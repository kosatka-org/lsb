<?php

namespace console\import_products\app\helpers;

/**
 * Класс для импорта товаров в БД
 */
class Products
{
    public static function importProducts($products)
    {
        foreach ($products as $sku => $productSizes) {
            $productId = self::addProduct(current($productSizes));
        }
    }

    protected static function addProduct($product)
    {
        echo "TODO"; exit;
    }
}
