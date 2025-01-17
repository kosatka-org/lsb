<?PHP

require_once('Widget.class.php');


class Showfurs extends Widget
{
	/* Конструктор */
	function Showfurs(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
        $query = 'SELECT `current_new_season` FROM sections WHERE menu_id is not null ORDER BY name';
        $this->db->query($query);
        $season = explode('/', $this->settings->current_new_season);        
        $season_text = 'зима 20' . $season[0]; //($season[1] == '1') ? 'весна-лето 20' . $season[0] : 'осень-зима 20' . $season[0];
        $this->smarty->assign('season', $season_text);
        
        
        $this->smarty->assign('no_show', true);
        
		$this->smarty->assign('title', 'Бутик фирменной одежды из Италии и Франции | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('show_furs.tpl');
		return $this->body;
	}
}
