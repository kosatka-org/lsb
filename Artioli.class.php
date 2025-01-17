<?PHP
 
require_once('Widget.class.php');


class Artioli extends Widget
{
	/* Конструктор */
	function Artioli(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$this->smarty->assign('title', 'Бутик одежды Artioli | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('artioli.tpl');
		return $this->body;
	}
}
