<?php

namespace console\import_products\app;

use console\import_products\app\helpers\_Base;
use console\import_products\app\helpers\PriceList;
use console\import_products\app\helpers\Products;
use GuzzleHttp\Exception\GuzzleException;

/**
 * Входной класс импорта товаров
 */
class Import extends _Base
{
    /**
     * Запустить импорт
     *
     * @return void
     * @throws GuzzleException
     */
    public static function import()
    {
        self::print_l('Starting import...');

        $products = PriceList::getPrice();

        (new Products)->importProducts($products);
    }

}
