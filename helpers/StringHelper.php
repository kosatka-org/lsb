<?php

namespace helpers;

/**
 * Helper по работе со строками
 */
class StringHelper
{
    /**
     * Транслитерация русской строки в английскую
     *
     * @param $str
     * @return string
     */
    public static function translit($str)
    {
        $s = (string)$str;

        $s = trim($s);

        $s = mb_strtolower($s);

        return strtr($s, array(
            'а' => 'a',
            'б' => 'b',
            'в' => 'v',
            'г' => 'g',
            'д' => 'd',
            'е' => 'e',
            'ё' => 'e',
            'ж' => 'j',
            'з' => 'z',
            'и' => 'i',
            'й' => 'y',
            'к' => 'k',
            'л' => 'l',
            'м' => 'm',
            'н' => 'n',
            'о' => 'o',
            'п' => 'p',
            'р' => 'r',
            'с' => 's',
            'т' => 't',
            'у' => 'u',
            'ф' => 'f',
            'х' => 'h',
            'ц' => 'c',
            'ч' => 'ch',
            'ш' => 'sh',
            'щ' => 'shch',
            'ы' => 'y',
            'э' => 'e',
            'ю' => 'yu',
            'я' => 'ya',
            'ъ' => '',
            'ь' => '',
            ' ' => '-',
        ));
    }
}
