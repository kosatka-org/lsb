<?php

namespace console\import_products\app\helpers;

use Exception;

/**
 * Класс для обработки прайса
 */
class PriceList
{
    /**
     * Спарсить файл прайса
     *
     * @param string $priceList
     * @return array
     * @throws Exception
     */
    public static function parse($priceList)
    {
        if (!is_file($priceList))
            throw new Exception("Файла прайса нет: '$priceList'");

        $products = json_decode(file_get_contents($priceList));

        if (json_last_error())
            throw new Exception('Ошибка обработки json-прайса. Ошибка: '.json_last_error_msg());

        $products = isset($products->items) ? $products->items : false;

        if (!$products)
            throw new Exception('Отсутствуют товары в прайсе');

        return self::groupBySize($products);
    }

    /**
     * Сгруппировать товары по размерам у товара
     *
     * @param array $products
     * @return array
     */
    protected static function groupBySize($products)
    {
        $result = [];

        foreach ($products as $product)
            $result[$product->sku][$product->size] = $product;

        return $result;
    }
}
