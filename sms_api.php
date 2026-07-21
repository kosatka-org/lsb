<?php

require_once __DIR__.'/third_party/smsru/smsru.php';

$sended_phones = array();

function send_sms_to_phone($phone, $message, $user_id = 0, $sender = 'Svetlov', $save_last_send = false, $useJob = false)
{
    $args = [
        'sender'       => $sender,
        'message_text' => $message,
        'phone_number' => $phone,
        'sms_only'     => 1,
        'user_id'      => $user_id,
    ];

    if ($useJob)
        Job::push('SmsJob', $args, false, 'critical');
    else
        (new smsru(Config::$smsru_key))->sms_send($args['phone_number'], $args['message_text'], $args['sender']);
}
