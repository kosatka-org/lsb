<?php
require_once('Widget.class.php');

class Subscription extends Widget
{
	function fetch() {
        $this->smarty->assign('brand_id', $_GET["brand_id"]);
		$this->body = $this->smarty->fetch('feedback.tpl');
		return $this->body;
	}
}