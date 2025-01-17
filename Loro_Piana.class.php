<?PHP
 
require_once('Widget.class.php');


class Loro_piana extends Widget
{
	/* Конструктор */
	function Loro_piana(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$this->smarty->assign('title', 'Бутик одежды Loro Piana | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('loro_piana.tpl');
		return $this->body;
	}
}
