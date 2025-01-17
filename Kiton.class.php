<?PHP
 
require_once('Widget.class.php');


class Kiton extends Widget
{
	/* Конструктор */
	function Kiton(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$this->smarty->assign('title', 'Бутик одежды Kiton | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('kiton.tpl');
		return $this->body;
	}
}
