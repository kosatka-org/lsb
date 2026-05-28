<?php

namespace console\import_products\app;

use console\import_products\app\helpers\_Base;
use console\import_products\app\helpers\Downloader;
use console\import_products\app\helpers\PriceList;
use console\import_products\app\helpers\Products;
use Exception;

/**
 * Основной класс импорта товаров
 */
class Import extends _Base
{
    /**
     * @return void
     * @throws Exception
     */
    public static function import()
    {
        self::print_l('Starting import...');

        $priceList = Downloader::downloadPriceList();

        $products = PriceList::parse($priceList);

        (new Products)->importProducts($products);
    }

}
