<?PHP
 
require_once('Widget.class.php');


class BigSize extends Widget
{
	/* Конструктор */
	function BigSize(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
		$mw = (int)$this->url_filtered_param('sex') ? (int)$this->url_filtered_param('sex') : ($this->url_filtered_param('enter_mobile') ? $this->url_filtered_param('enter_mobile') : $_COOKIE['sex']);
		
		$this->smarty->assign('manOrWoman', $mw ? $mw : '1');
		$this->smarty->assign('title', 'Бутик одежды больших размеров | бутик Лакшери Стор');
		$this->body = $this->smarty->fetch('BigSize.tpl');
		return $this->body;
	}
}
