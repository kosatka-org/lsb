<?php

namespace console\import_products\app\helpers;

use Exception, stdClass;

/**
 * Входной класс для импорта товаров в БД
 */
class Products extends _Base
{
    protected static $adamasBrandId = 1;

    protected static $svetlovBrandId = 2;

    /**
     * Импортировать все товары в БД
     *
     * @param $products
     * @return void
     * @throws Exception
     */
    public function importProducts($products)
    {
        $total = count($products);

        self::print_l("Start import products. Total products: $total...");

        $i = 0;
        foreach ($products as $sku => $productSizes) {
            $i++;

            if ($i % 10 == 0)
                self::print_l("Handled next $i products of $total...");

            $product = self::getFirstAvailableSize($productSizes);

            if (!$product)
                continue;

            if (ImportedProducts::isNewProduct($sku))
                self::addProduct($product, $productSizes);
            else
                self::updateProduct($sku, $product, $productSizes);
        }

        self::print_l('Import products completed');
    }

    /**
     * Добавить товар и его размеры в БД
     *
     * @param stdClass $product
     * @param array    $productSizes
     * @return void
     * @throws Exception
     */
    protected static function addProduct($product, $productSizes)
    {
        $productId = (new ProductDB)->addProduct($product);

        (new ProductSizes)->addAllProductSizes($productId, $productSizes);
    }

    /**
     * Обновить товар и его размеры в БД
     *
     * @param string   $sku
     * @param stdClass $product
     * @param array    $productSizes
     * @return void
     * @throws Exception
     */
    protected static function updateProduct($sku, $product, $productSizes)
    {
        $productId = (new ProductDB)->updateProduct($sku, $product);

        (new ProductSizes)->updateAllProductSizes($productId, $productSizes);
    }


    /**
     * Получить первый доступный товар, у которого есть в наличии размер для продажи
     *
     * @param array $productSizes
     * @return null
     */
    protected static function getFirstAvailableSize($productSizes)
    {
        foreach ($productSizes as $product) {
            if (!self::isAvailable($product))
                continue;

            return $product;
        }

        return null;
    }

    /**
     * Получить имя продукта
     *
     * @param stdClass $product
     * @return string mixed
     * @throws Exception
     */
    public static function getProductName(stdClass $product)
    {
        $name = $product->wb_product->title ?: $product->ozon_product->title;

        if (!$name)
            throw new Exception('Empty product name');

        return $name;
    }

    /**
     * Получить id брендов в БД для Адамаса и Светлова
     *
     * @param stdClass $product
     * @return int
     * @throws Exception
     */
    public static function getDBBrandId(stdClass $product)
    {
        switch ($brand = $product->wb_product->brand) {
            case 'ADAMAS':
                return self::$adamasBrandId;
            case 'SVETLOV':
                return self::$svetlovBrandId;
            default:
                throw new Exception("Unknown brand '$brand'");
        }
    }

    /**
     * Товар доступен?
     *
     * @param stdClass $product
     * @return bool
     */
    public static function isAvailable(stdClass $product)
    {
        return $product->wb_product and $product->ozon_product;
    }
}
