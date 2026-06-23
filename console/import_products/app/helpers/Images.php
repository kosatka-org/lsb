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

        self::addExtraImages($images->others, $productId);
    }

    /**
     * Скачать и добавить доп. рисунки к товару
     *
     * @param array $images
     * @param int   $productId
     * @return bool
     * @throws GuzzleException
     * @throws Exception
     */
    protected static function addExtraImages(array $images, $productId)
    {
        if (!$images)
            return false;

        $query = "SELECT extra FROM products_downloaded_img WHERE product_id = $productId";

        $downloadedImg = ($downloadedImg = self::$db->get_var($query)) ? json_decode($downloadedImg) : [];

        if ($downloadedImg == $images)
            return false;

        self::print_l("Start downloading extra images for product ID $productId...");

        foreach ($images as $k => $url) {
            $downloadedUrl = isset($downloadedImg[$k]) ? $downloadedImg[$k] : '';

            if ($downloadedUrl == $url)
                continue;

            $image = self::downloadImage($url, $productId, "extra_$k");

            if (!$image)
                continue;

            self::updateExtraImageInDB($image, $productId, $k);
        }

        self::markExtraImagesAsDownloaded($images, $productId);

        return true;
    }

    /**
     * Пометить доп. рисунки как скачанные
     *
     * @param array $images
     * @param int   $productId
     * @return void
     * @throws Exception
     */
    protected static function markExtraImagesAsDownloaded(array $images, $productId)
    {
        $images = json_encode($images);

        $query = "UPDATE products_downloaded_img SET extra = '$images' WHERE product_id = $productId";

        self::$db->query($query);
    }

    /**
     * Обновить запись о доп. рисунке товара в БД
     *
     * @param string $image
     * @param int    $productId
     * @param int    $num
     * @return void
     * @throws Exception
     */
    protected static function updateExtraImageInDB($image, $productId, $num)
    {
        $image = basename($image);

        $query = "SELECT EXISTS (SELECT 1 FROM products_fotos WHERE product_id = $productId AND foto_id = $num)";

        if (!self::$db->get_var($query))
            $query = "INSERT INTO products_fotos SET product_id = $productId, foto_id = $num, filename = '$image'";
        else
            $query = "UPDATE products_fotos SET filename = '$image' WHERE product_id = $productId AND foto_id = $num";

        self::$db->query($query);
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

        if (!$url)
            return false;

        if ($downloadedUrl and $downloadedUrl == $url)
            return false;

        self::print_l("Start downloading $type image for product ID $productId...");

        $image = self::downloadImage($url, $productId, $type);

        if (!$image)
            return false;

        self::updateDBImage($image, $url, $productId, $type);

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
        if (!$url and $type == 'second')
            return false;

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
            'second' => isset($product->ozon_product->images[0]) ? $product->ozon_product->images[0] : false,
            'others' => array_slice($product->ozon_product->images, 1, 6),
        ];
    }
}
