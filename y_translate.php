<?php
  function translate ($text) {
    $yt_key = 'trnsl.1.1.20180826T190218Z.5f3bf01ab64e11ad.9180230948ed5135d8ddf54728332ac041fa376a';
    $yt_lang = "ru-en";
    $yt_text = urlencode($text);
    $url="https://translate.yandex.net/api/v1.5/tr.json/translate?key=".$yt_key."&text=".$yt_text."&lang=".$yt_lang;
    $result = json_decode(file_get_contents($url), true);
    $en_text = $result['text'][0];
    if($result === false){
      $_SERVER['NOTIFICATION_EMAIL_SEND'] = 1;
      $headers  = 'MIME-Version: 1.0' . "\r\n" . 'Content-type: text/html; charset="utf-8"' . "\r\n". 'From:  <info@lsboutique.ru>' . "\r\n" . 'X-Priority: 1' . "\r\n";
      mail("tirjen@gmail.com",'Google Translate Error: Curl error: ' . curl_error($ch).'.', $headers);
    }
    return $en_text;
  }
