<?php

namespace console\import_products\app\helpers;

use stdClass, Exception;
use GuzzleHttp\Exception\GuzzleException;

/**
 * Класс для работы с видео
 */
class Video extends _Base
{

    /**
     * Скачать и добавить видео для товара
     *
     * @param int      $productId
     * @param stdClass $product
     * @return bool
     * @throws GuzzleException
     * @throws Exception
     */
    public function downloadVideo($productId, stdClass $product)
    {
        $url = $product->ozon_video;

        if (!$url)
            return false;

        $query = "SELECT video FROM products_downloaded_img WHERE product_id = $productId";

        $downloadedUrl = self::$db->get_var($query);

        if ($downloadedUrl and $downloadedUrl == $url)
            return false;

        self::print_l("Start downloading video for product ID $productId...");

        $video = self::download($url, $productId);

        self::updateDBVideo($video, $url, $productId);

        return true;
    }

    /**
     * Обновить запись о видео в БД, для товара
     *
     * @param string $video
     * @param string $url
     * @param int    $productId
     * @return void
     * @throws Exception
     */
    protected static function updateDBVideo($video, $url, $productId)
    {
        $video = basename($video);

        $query = "UPDATE products SET local_video = '$video' WHERE product_id = $productId";

        self::$db->query($query);

        $query = "UPDATE products_downloaded_img SET video = '$url'  WHERE product_id = $productId";

        self::$db->query($query);
    }


    /**
     * Скачать видео-файл
     *
     * @param string $url
     * @param int    $productId
     * @return string
     * @throws GuzzleException
     * @throws Exception
     */
    protected static function download($url, $productId)
    {
        if (!filter_var($url, FILTER_VALIDATE_URL))
            throw new Exception("Incorrect video url '$url'");

        $video = self::getVideoPath($url, $productId);

        self::getHttpClient()->request('GET', $url, ['sink' => $video]);

        if (!file_exists($video))
            throw new Exception("Can't download video from '$url' of product ID $productId");

        return $video;
    }

    /**
     * Путь к папке с видео-файлом
     *
     * @param string $url
     * @param int    $productId
     * @return string
     */
    protected static function getVideoPath($url, $productId)
    {
        $ext = pathinfo($url, PATHINFO_EXTENSION);

        return Images::getImageDir().'/'.$productId."_video.$ext";
    }
}
