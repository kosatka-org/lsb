<?php

namespace console\import_products\app\helpers;

use stdClass, Exception;

/**
 * Класс для работы размерами товара
 */
class ProductSizes extends _Base
{
    /**
     * Добавить размер товара
     *
     * @param int      $productId
     * @param stdClass $product
     * @return int
     * @throws Exception
     */
    public function addProductSize($productId, stdClass $product)
    {
        $quantity = 1000;

        $query = "INSERT INTO items SET
                      product_id = $productId,
                      size = '{$product->size}',
                      price = ".round($product->base_price).",
                      quantity = $quantity
                   ";

        self::$db->query($query);

        return self::$db->insert_id();
    }
}
