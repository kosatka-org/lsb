<?php
// если была нажата кнопка "Отправить"
if($_POST['submit']) {
        $title 	= trim($_POST['title']);
        $mess 	= trim($_POST['mess']);

        $to 	= trim($_POST['email']);
        $from 	= trim($_POST['from_email']);

		$headers  = 'MIME-Version: 1.0' . "\r\n";
		$headers .= 'Content-type: text/html; charset="utf-8"' . "\r\n";
		$headers .= 'From:  <' . $from . '>' . "\r\n";
		$headers .= 'X-Priority: 1' . "\r\n";

        // функция, которая отправляет наше письмо.
        mail($to, $title, $mess, $headers);
        echo 'Спасибо! Ваше письмо отправлено.';
}
?>
<form action="" method=post>

<p>Вводный текст перед формой <p>
              <div align="center">
              Куда<br />
              <input type="text" name="email" value="a.shesternina@gmail.com" size="40"><br />
              От кого<br />
              <input type="text" name="from_email" value="a.shesternina@gmail.com" size="40"><br />
              Teма<br />
              <input type="text" name="title" size="40"><br />
              Сообщение<br />
              <textarea name="mess" rows="10" cols="40"></textarea>
              <br />
              <input type="submit" value="Отправить" name="submit"></div>
</form> 