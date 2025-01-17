<?PHP
 
require_once('Widget.class.php');


class Zilli extends Widget
{
	/* Конструктор */
	function Zilli(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$this->smarty->assign('title', 'Бутик одежды Zilli | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('zilli.tpl');
		return $this->body;
	}
}
