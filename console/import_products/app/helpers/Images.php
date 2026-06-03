<?php

namespace console\import_products\app\helpers;

use stdClass, Exception;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;

/**
 * Класс для работы с изображениями
 */
class Images extends _Base
{
    /**
     * Скачать рисунки
     *
     * @param int      $productId
     * @param stdClass $product
     * @return void
     * @throws GuzzleException
     */
    public function downloadImages($productId, stdClass $product)
    {
        $images = self::getImagesUrls($product);

        self::addImage($images->first, $productId, 'first');

        self::addImage($images->second, $productId, 'second');
    }

    /**
     * Добавить 1й или 2й рисунок в товар
     *
     * @param string $url
     * @param int    $productId
     * @param string $type
     * @return bool
     * @throws GuzzleException
     * @throws Exception
     */
    protected static function addImage($url, $productId, $type)
    {
        $query = "SELECT $type"."_img FROM products_downloaded_img WHERE product_id = $productId";

        $downloadedUrl = self::$db->get_var($query);

        if ($downloadedUrl and $downloadedUrl == $url)
            return false;

        self::print_l("Start downloading $type image for product ID $productId...");

        $image = self::downloadImage($url, $productId, $type);

        self::updateDBImage($image, $url, $productId, $type);

        self::print_l("Downloading $type image completed");

        return true;
    }

    /**
     * Обновить 1й или 2й рисунок в БД
     *
     * @param string $image
     * @param string $url
     * @param int    $productId
     * @param string $type
     * @return void
     * @throws Exception
     */
    protected static function updateDBImage($image, $url, $productId, $type)
    {
        $image = basename($image);

        switch ($type) {
            case 'first':
                $set = "large_image = '$image'";
                $set2 = "first_img = '$url'";
                break;

            case 'second':
                $set = "small_image = '$image'";
                $set2 = "second_img = '$url'";
                break;
            default:
                throw new Exception("Incorrect type '$type'");
        }

        $query = "UPDATE products SET $set WHERE product_id = $productId";

        self::$db->query($query);

        $query = "SELECT EXISTS (SELECT 1 FROM products_downloaded_img WHERE product_id = $productId)";

        if (!self::$db->get_var($query))
            $query = "INSERT INTO products_downloaded_img SET product_id = $productId, $set2";
        else
            $query = "UPDATE products_downloaded_img SET $set2 WHERE product_id = $productId";

        self::$db->query($query);
    }

    /**
     * Скачать 1й или 2й рисунок
     *
     * @param string $url
     * @param int    $productId
     * @param string $type
     * @return string
     * @throws GuzzleException
     * @throws Exception
     */
    protected static function downloadImage($url, $productId, $type)
    {
        if (!$url)
            throw new Exception("Empty url of $type image");

        if (!filter_var($url, FILTER_VALIDATE_URL))
            throw new Exception("Incorrect url of $type image");

        $image = self::getImagePath($url, $productId, $type);

        self::getHttpClient()->request('GET', $url, ['sink' => $image]);

        if (!file_exists($image))
            throw new Exception("Can't download image '$image' of product ID $productId");

        return $image;
    }

    /**
     * Получить путь к картинке
     *
     * @param string $url
     * @param int    $productId
     * @param string $type
     * @return string
     */
    protected static function getImagePath($url, $productId, $type)
    {
        $ext = pathinfo($url, PATHINFO_EXTENSION);

        return self::getImageDir().'/'.$productId."_$type".'.'.$ext;
    }

    /**
     * Получить http-клиента
     *
     * @return Client
     */
    protected static function getHttpClient()
    {
        return new Client([
            'http_errors' => true,
            'verify'      => false,
        ]);
    }

    /**
     * Получить директорию рисунков
     *
     * @return string
     */
    protected static function getImageDir()
    {
        return SITE_DIR.'/files/products';
    }

    /**
     * Получить url-ы картинок для скачивания
     *
     * @param stdClass $product
     * @return object
     */
    protected static function getImagesUrls(stdClass $product)
    {
        return (object)[
            'first'  => $product->ozon_product->primary_image[0],
            'second' => $product->ozon_product->images[0] ?: false,
            'others' => array_slice($product->ozon_product->images, 1),
        ];
    }
}
