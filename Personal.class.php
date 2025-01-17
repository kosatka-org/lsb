<?php
require_once('Widget.class.php');

class Personal extends Widget
{

	function fetch() {
		if ( isset($_GET['sex']) ) {
			setcookie('sex', $_GET['sex'], time()+60*60*24*365, '/');
			$_COOKIE['sex'] = $_GET['sex'];
		}
		$this->smarty->assign('title', 'Персонально');
		$this->smarty->assign('manOrWoman', $_COOKIE['sex'] ? $_COOKIE['sex'] : '0');
		$this->smarty->assign('filter_url', '/personal/?');
		$this->body = $this->smarty->fetch('personal.tpl');
		return $this->body;
	}
}