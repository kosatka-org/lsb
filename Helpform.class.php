<?php
require_once('Widget.class.php');

class Helpform extends Widget
{
	function fetch() {
        $this->smarty->assign('product_id', $_GET["oneclick_product"]);
        $this->smarty->assign('from_page', "help_form_desktop");
		$this->body = $this->smarty->fetch('helpform.tpl');
		return $this->body;
	}
}