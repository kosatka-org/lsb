<?php
require_once('Widget.class.php');

class Auth extends Widget
{
	function fetch() {
		$this->body = $this->smarty->fetch('vk_auth.tpl');
		return $this->body;
	}
}