<?PHP
 
require_once('Widget.class.php');


class Berluti extends Widget
{
	/* Конструктор */
	function Berluti(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$this->smarty->assign('title', 'Бутик одежды Berluti | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('berluti.tpl');
		return $this->body;
	}
}
