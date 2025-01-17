<?PHP
 
require_once('Widget.class.php');



class Crimeteilor extends Widget
{
	/* Конструктор */
	function Crimeteilor(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$this->smarty->assign('title', 'Преступление портного | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('crimeteilor.tpl');
		return $this->body;
	}
}
