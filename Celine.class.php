<?PHP
 
require_once('Widget.class.php');


class Celine extends Widget
{
	/* Конструктор */
	function Celine(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
        $query = 'SELECT `current_new_season` FROM sections WHERE menu_id is not null ORDER BY name';
        $this->db->query($query);
        $season = explode('/', $this->settings->current_new_season);        
        $season_text = ($season[1] == '1') ? 'весна-лето 20' . $season[0] : 'осень-зима 20' . $season[0];
        $this->smarty->assign('season', $season_text);
        
        $brand = $this->db->result("SELECT * FROM brands WHERE name = 'Celine'");
        $this->smarty->assign('showbrand', $brand);
        
        $this->smarty->assign('title', 'Бутик одежды Celine | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('celine.tpl');
		return $this->body;
	}
}