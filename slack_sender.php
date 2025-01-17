<?php
function send_to_slack ($message, $channel, $url) {
    $config = new Config();
    if($config->enviroment == 'live'){
      //generate message
        $data = json_encode(array(         
                "channel"       =>  "#{$channel}",
                "text"          =>  $message,
                "icon_emoji"    =>  ":slack:"
            ));
        
      //send message
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_POSTFIELDS, array('payload' => $data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $result = curl_exec($ch);
        // echo var_dump($result);
        if($result === false)
        {
            $_SERVER['NOTIFICATION_EMAIL_SEND'] = 1;
            $headers  = 'MIME-Version: 1.0' . "\r\n" . 'Content-type: text/html; charset="utf-8"' . "\r\n". 'From:  <info@lsboutique.ru>' . "\r\n" . 'X-Priority: 1' . "\r\n";
            mail("tirjen@gmail.com",'Slack notification Error: Curl error: ' . curl_error($ch).'.', $headers);
        }
        curl_close($ch);
    }
}