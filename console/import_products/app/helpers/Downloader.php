<?php

namespace console\import_products\app\helpers;

/**
 * Класс для загрузки прайса
 */
class Downloader
{
    public static function downloadPriceList()
    {
        return __DIR__.'/marketplace_items.json';
    }
}
