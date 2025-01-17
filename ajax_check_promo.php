<?php
ini_set('display_errors', 'Off');

header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");		

session_start();
include_once 'models/user.php';
include_once 'Widget.class.php';

$data = new StdClass;

if (!empty($_GET['promo_code'])) {
	$Widget = new Widget($a = NULL);
	$query = sql_placeholder("SELECT c.*, u.card_number FROM coupons c LEFT JOIN users u ON u.original_user_id = c.user_id WHERE c.code=?", $_GET['promo_code']);
	$Widget->db->query($query);
	$coupon = $Widget->db->result();
	
	if ($_GET['moder'] == 1) {
		if ( !empty($coupon) ) { 
			$coupon->date_finish 	= date('d.m', strtotime($coupon->date_finish));
			$coupon->date_start		= date('d.m', strtotime($coupon->date_start));
		}
		$data = $coupon;
	}
	else {
		if($coupon && strtotime($coupon->date_start) <= time() AND strtotime($coupon->date_finish) >= time()) {
			$data->value = $coupon->value;
			$data->type = $coupon->type;
		}
	}
	
}

print json_encode($data);
die();