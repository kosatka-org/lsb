<?php
$sended_phones = array();

function send_sms_to_phone( $phone, $message, $user_id = 0, $sender = 'lsboutique', $save_last_send = false ) {
	$args = array( 'sender' => $sender,
		'message_text' => $message,
		'phone_number' => $phone,
		'sms_only' => 1,
		'user_id' => $user_id );
	Job::push( 'SmsJob', $args, false, 'critical' );
}
