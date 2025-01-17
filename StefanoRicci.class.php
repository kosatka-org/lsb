<?PHP

require_once('Widget.class.php');


class Stefanoricci extends Widget
{
	/* Конструктор */
	function Stefanoricci(&$parent)
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
        
        $brand = $this->db->result("SELECT * FROM brands WHERE name = 'Stefano Ricci'");
        $this->smarty->assign('showbrand', $brand);
        $this->smarty->assign('no_show', true);
		$this->smarty->assign('title', 'Бутик одежды Stefano Ricci | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('stefano_ricci.tpl');
		return $this->body;
	}
}
