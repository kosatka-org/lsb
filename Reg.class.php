<?php
require_once('Widget.class.php');

class Reg extends Widget
{
	function fetch() {
		$this->body = $this->smarty->fetch('self_register.tpl');
		return $this->body;
	}
}