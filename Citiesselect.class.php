<?php
require_once('Widget.class.php');

class Citiesselect extends Widget
{
	function fetch() {
        $query = " SELECT cities.name, SUBSTR(cities.name,1,1) AS f_letter, cities.city_id, delivery_cities.region_id, cities.url FROM cities
                  LEFT JOIN delivery_cities ON cities.city_id = delivery_cities.city_id
                  WHERE cities.visible = 1  ORDER BY cities.name";
        $delivery_cities = $this->db->results($query);
        $del_cities_sorted = array();
        $frst_l = '';
        $col = round(count($delivery_cities)/4);
        foreach($delivery_cities as $k=>$ds){
          if($frst_l != $ds->f_letter){
            $frst_l = $ds->f_letter;
          }
          $del_cities_sorted[$k/$col][$frst_l][] = $ds;
        }
        $this->smarty->assign('big_cities',  array(642,992,1054,893) );
        $this->smarty->assign('del_cities_sorted',  $del_cities_sorted );
        $pos = strpos($_SERVER['HTTP_REFERER'], '?');
        $back_url = ($pos == false) ? $_SERVER['HTTP_REFERER'] : substr($_SERVER['HTTP_REFERER'], 0 ,$pos);
        $this->smarty->assign('back_url', $back_url);
		$this->body = $this->smarty->fetch('cities_select.tpl');
		return $this->body;
	}
}