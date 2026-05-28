<?php

namespace console\import_products\app\helpers;

use stdClass, Exception;
use helpers\StringHelper;

/**
 * Класс для работы с цветом товара
 */
class Colors extends _Base
{
    protected static $rootCatId = 102012;

    /**
     * Обновить цвет товара
     *
     * @param int      $productId
     * @param stdClass $product
     * @return void
     * @throws Exception
     */
    public function updateProductColor($productId, stdClass $product)
    {
        $color = false;

        foreach ($product->wb_product->characteristics as $characteristic) {
            if ($characteristic->id == 14177449) {
                $color = $characteristic->value[0];
                break;
            }
        }

        if (!$color)
            throw new Exception("Empty color in product ID {$product->id}");

        $dbColor = self::getDBColorByName($color);

        $colorId = $dbColor ? $dbColor->color_id : self::createColor($color);

        self::updateProductColorAfterColorFinded($productId, $colorId);
    }

    /**
     * Обновить цвет товара, после того, как он найден
     *
     * @param int $productId
     * @param int $colorId
     * @return void
     * @throws Exception
     */
    protected static function updateProductColorAfterColorFinded($productId, $colorId)
    {
        $query = "UPDATE products SET color_id = $colorId WHERE product_id = $productId";

        self::$db->query($query);
    }

    /**
     * Создать цвет
     *
     * @param string $name
     * @return int
     * @throws Exception
     */
    protected static function createColor($name)
    {
        $query = "INSERT INTO colors SET name = '$name'";

        self::$db->query($query);

        return self::$db->insert_id();
    }

    /**
     * Получить цвет из БД по его имени
     *
     * @param string $name
     * @return stdClass|null
     */
    protected static function getDBColorByName($name)
    {
        $query = "SELECT * FROM colors WHERE name = '$name' LIMIT 1";

        $dbColor = self::$db->get_row($query);

        return $dbColor ?: null;
    }


}
