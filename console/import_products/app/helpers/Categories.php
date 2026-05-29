<?php

namespace console\import_products\app\helpers;

use stdClass, Exception;
use helpers\StringHelper;

/**
 * Класс для работы с категориями
 */
class Categories extends _Base
{
    protected static $rootCatId = 1;

    /**
     * Обновить категорию товара
     *
     * @param int      $productId
     * @param stdClass $product
     * @return void
     * @throws Exception
     */
    public function updateProductCategory($productId, stdClass $product)
    {
        $category = $product->wb_product->subjectName;

        if (!$category)
            throw new Exception('Empty category');

        $dbCategory = self::getDBCategoryByName($category);

        $catId = $dbCategory ? $dbCategory->category_id : self::createCategory($category, $product);

        self::updateProductCategoryAfterCatFinded($productId, $catId);
    }

    /**
     * Обновить категорию товара, после того, как она найдена
     *
     * @param int $productId
     * @param int $catId
     * @return void
     * @throws Exception
     */
    protected static function updateProductCategoryAfterCatFinded($productId, $catId)
    {
        $query = "UPDATE products SET category_id = $catId WHERE product_id = $productId";

        self::$db->query($query);
    }

    /**
     * Создать категорию
     *
     * @param string   $name
     * @param stdClass $product
     * @return int
     * @throws Exception
     */
    protected static function createCategory($name, stdClass $product)
    {
        $url = StringHelper::translit($name);

        $gender = self::getGender($product);

        $query = "INSERT INTO categories SET
                            name = '$name',
                            parent = ".self::$rootCatId.",
                            meta_title = '$name',
                            meta_keywords = '$name',
                            url = '$url',
                            gender =  $gender,
                            enabled =  1
                       ";

        self::$db->query($query);

        return self::$db->insert_id();
    }

    /**
     * Получить категорию из БД по её имени
     *
     * @param string $name
     * @return stdClass|null
     */
    protected static function getDBCategoryByName($name)
    {
        $query = "SELECT * FROM categories WHERE name = '$name' LIMIT 1";

        $dbCategory = self::$db->get_row($query);

        return $dbCategory ?: null;
    }


}
