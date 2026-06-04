<?php

namespace console\import_products\app\helpers;

use Config, Exception;
use GuzzleHttp\Exception\GuzzleException;

/**
 * Класс для обработки json-прайса
 */
class PriceList extends _Base
{

    /**
     * Скачать и распарсить прайс
     *
     * @return array
     * @throws GuzzleException
     * @throws Exception
     */
    public static function getPrice()
    {
        $price = self::download();

        return self::parse($price);
    }

    /**
     * Скачать прайс
     *
     * @return string
     * @throws GuzzleException
     */
    protected static function download()
    {
        self::print_l('Downloading json-price...');

        $price = self::getTmpDir().'/marketplace_items.json';

        self::getHttpClient()->request('GET', 'https://adamas-analytics-vm-1.kosatka.org/exports/marketplace_items.json', [
            'sink' => $price,
            'auth' => Config::$importAuth,
        ]);

        return $price;
    }

    /**
     * Спарсить файл прайса
     *
     * @param string $priceList
     * @return array
     * @throws Exception
     */
    protected static function parse($priceList)
    {
        self::print_l("Start parsing price from file '$priceList'...");

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

        foreach ($products as $product) {
            $product->size = $product->size ?: 'не задан';

            $result[$product->sku][$product->size] = $product;
        }

        return $result;
    }
}
