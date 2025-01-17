<?php

require_once 'smsru.php';

$sms = new smsru( '7c9505b0-13d3-cd74-515f-9c9d6369c329', '89524442636', '88003332138' );
// $sms = new \Zelenin\smsru( 'api_id' );
// $sms = new \Zelenin\smsru( null, 'login', 'password' );

echo $sms->sms_send( '89202944697,79524442636,79202508074', 'Покупайте в Лакшери Стор, блеать', 'lsboutique' );
die('ok');

// $sms->sms_send( '79112223344,79115556677,79118889900', 'Текст SMS' );

// $sms->sms_send( '79112223344', 'Текст SMS', 'Имя отправителя', time(), $test = true, $partner_id );

// $sms->sms_mail( '79112223344', 'Текст SMS' );

// $sms->sms_mail( '79112223344', 'Текст SMS', 'Имя отправителя' );

// $sms->sms_status( 'SMS id' );

// $sms->sms_cost( '79112223344', 'Текст SMS' );

// $sms->my_balance();

// $sms->my_limit();

// $sms->my_senders();

// $sms->auth_check();

// $sms->stoplist_add( '79112223344', 'ban' );

// $sms->stoplist_get();

// $sms->stoplist_del( '79112223344' );