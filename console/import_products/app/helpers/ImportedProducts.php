<?php

namespace console\import_products\app\helpers;

use stdClass, Exception;

/**
 * Класс для отметки уже импортированых ранее товаров
 */
class ImportedProducts extends _Base
{
    /**
     * Товар новый или был импортирован ранее?
     *
     * @param string $sku
     * @return bool
     * @throws Exception
     */
    public static function isNewProduct($sku)
    {
        return !(new self)->getProductBySku($sku);
    }

    /**
     * Получитть товар по его sku
     *
     * @param string $sku
     * @return stdClass|null
     * @throws Exception
     */
    public function getProductBySku($sku)
    {
        if (!$sku)
            throw new Exception('Empty product sku');

        $query = "SELECT * FROM products WHERE sku = '$sku' LIMIT 1";

        return self::$db->get_row($query) ?: null;
    }
}
