<?php

session_start();
$_SESSION['user'] = 1;

define(PATH, $_SERVER['DOCUMENT_ROOT']);
include_once PATH.'/Widget.class.php';

$Widget = new Widget($a = NULL);

$query = sql_placeholder('SELECT * FROM coupons WHERE user_id = 0');
$Widget->db->Query($query);
$coupons = $Widget->db->results();


$chars_card = '0123456789';

foreach($coupons as $coupon){
	
	$user = new stdClass;
	
	$user->name = 'Промокод: ' . $coupon->text;
	$user->enabled  = 1;
	if ($coupon->type == 'percentage') {
		$user->personal_discount = $coupon->value;
	}
	else {
		$user->deposit = $coupon->value;
	}
	$user->shop = 'Internet';
	$user->store = 'Internet';
	do {
		$user->card_number = NULL;
		$numChars = strlen($chars_card);
		for ($i = 1; $i <= 16; $i++) {
			$user->card_number .= substr($chars_card, rand(1, $numChars) - 1, 1);
		}
		$Widget->db->query(sql_placeholder("SELECT COUNT(id) as count FROM users WHERE card_number=?", $user->card_number));
	} while($Widget->db->result('count') > 0);
	
	$user = (array)$user;
	$query = sql_placeholder("INSERT INTO users SET ?%", $user); 
	$Widget->db->query($query);
	$user_id = $Widget->db->insert_id();
	$query = sql_placeholder("UPDATE users SET original_user_id = user_id WHERE user_id =?", $user_id); 
	$Widget->db->query($query);
	
	$query = sql_placeholder("UPDATE coupons SET user_id = ? WHERE id =?", $user_id, $coupon->id); 
	$Widget->db->query($query);
	
}

echo 'Готово:)';


