<?PHP
require_once('Widget.class.php');
require_once('models/email_template.php');



class Login extends Widget
{
    /**
     *
     * Конструктор
     *
     */
    function Login(&$parent)
    {
        Widget::Widget($parent);

        if ( isset($_GET['delete_avatar']) ) {
            $this->delete_avatar();
        }
        if ( isset($_GET['do_not_disturb']) ) {
            $this->do_not_disturb();
        }
        if ( isset($_GET['do_not_disturb_email']) ) {
            $this->do_not_disturb_email();
        }
        if ( isset($_GET['spam']) ) {
            $this->spam();
        }
        if ( isset($_GET['fix_users']) ) {
            $this->fix_users();
        }
        if ( isset($_GET['update_purchase_sum']) ) {
            $this->update_purchase_sum();
        }
        if ( isset($_GET['client_add']) ) {
            $this->client_add();
        }
        if ( isset($_GET['check_wishlist']) ) {
            $this->check_wishlist();
        }
        if ( isset($_GET['check_viewed']) ) {
            $this->check_wishlist(true);
        }
        if ( isset($_GET['restore_card_number']) ) {
            $this->restore_card_number();
        }
        if ( isset($_GET['check_novelty']) ) {
            $this->check_novelty();
        }
        if ( isset($_GET['self_register']) ) {
            $this->self_register();
        }
        if ( isset($_GET['deposit']) ) {
            $this->deposit();
        }
        if ( isset($_GET['avatar_change']) ) {
            $this->avatar_change();
        }
        if ( isset($_GET['code_auth']) ) {
            $this->code_auth();
        }
        if ( isset($_GET['subscribe']) ) {
            $this->subscribe();
        }
        if ( isset($_GET['users2sizes']) ) {
            $this->users2sizes();
        }
        if (isset($_GET['unlink_acc'])) {
          return $this->unlink_acc();
        }
        if ( isset($_GET['set_currency']) ) {
            $this->set_currency();
        }
        if ( $this->settings->theme == 'api' && isset($_GET['save_token']) ) {
            $this->save_app_token();
        }
        if ( $this->settings->theme == 'api' && isset($_GET['get_subscription']) ) {
            $this->get_subscription();
        }
        if ( isset($_GET['generate_pass']) ) {
            $this->generate_pass();
        }
        if ( isset($_GET['update_pass']) ) {
            $this->update_pass();
        }
        if ( $this->config->enviroment == 'development' && isset($_GET['dev_login']) ) {
          $user_id = (int) $_GET['dev_login'];
          $dev_user = new luser();
          $dev_user->login( $user_id );
          header("Location: /");
          die('');
        }
        $this->prepare();
    }

    function set_currency(){
      $user_id = $_SESSION['user']->user_id;
      if($this->settings->theme == 'api')$user_id = $_GET['user_id'];
      if ( !empty($user_id) ) {
        $currency = $_GET['set_currency'];
        $this->db->query("UPDATE users SET currency = '{$currency}' WHERE user_id = '{$user_id}'");
      }
    }

    function generate_pass() {
      ini_set('display_errors', '0');
      $phone = str_replace(array(' ','-',')','(','+'), '', $_GET['phone']);
      $card_number = $_GET['card_number'];
      $output = (isset($_GET['output']) && $_GET['output'] == 'mail') ? false : true;
      if(!empty($phone) && strlen($phone) > 9 && ctype_digit($phone) && !empty($card_number) && strlen($card_number) > 4 && ctype_digit($card_number)){
        $user = $this->db->result("SELECT user_id, email FROM `users` WHERE phone_number LIKE '%{$phone}' AND card_number LIKE '%{$card_number}'");
        if(!empty($user->user_id)){
          if(!$output){
            if(empty($user->email)){
              echo 'no email';
              return false;
            }
          }
          $luser = new luser($user->user_id);

          // Create and output the pass
          $file = $luser->generate_pass($user->user_id, $output);
          if(!$output){
            if($file && $user->email){
              $name = 'pass.pkpass';
              $path = "third_party/PHP_PKPass/tmp/";
              $message = 'this is test message';
              $from = 'test@lsboutique.com';
              $file_path = $path.$name;
              file_put_contents($file_path, $file);
              $this->email_attach($user->email, 'pass test', $message, $from, $path, $name);
              unlink($file_path);
            }
          }
        }
        else{
          echo 'user not found';
        }
      }
      else{
        echo 'invalid data';
      }
      die();
    }

    function update_pass() {
      $serial     = (int)$_GET['serial'];
      $auth_token = $_GET['auth_token'];
      $type       = $_GET['type'];
      $output     = isset($_GET['output']) ? true : false;
      if(!empty($serial)){
        $pass = $this->db->result("SELECT * FROM `apple_pkpass` WHERE pass_id = '{$serial}' AND pass_type = '{$type}'");
        $user = $this->db->result("SELECT user_id, email FROM `users` WHERE user_id = '{$pass->user_id}'");
        if($pass->authentication_token == $auth_token){
          $luser = new luser($user->user_id);
          $file = $luser->generate_pass($user->user_id, $output, $pass);
          if(!$output){
            if($file && $user->email){
              $name = 'pass.pkpass';
              $path = "third_party/PHP_PKPass/tmp/";
              $message = 'this is test message';
              $from = 'test@lsboutique.com';
              $file_path = $path.$name;
              file_put_contents($file_path, $file);
              $this->email_attach($user->email, 'pass test', $message, $from, $path, $name);
              unlink($file_path);
            }
          }
        }
        else{
          echo 'unauthorized';
        }
      }
      else{
        echo 'invalid data';
      }
      die();
    }


    function save_app_token() {
        if ( !empty($_GET['token']) ) {
            $phone_number = isset($_GET['phone']) ? $_GET['phone'] : null;
            $user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;
            $delete = isset($_GET['del']) ? true : false;
            $token = $_GET['token'];
            $firebase_token = isset($_GET['f_token']) ? $_GET['f_token'] : '';
            $platform = $_GET['platform'];
            $user = new luser();
            $return->message = $user->save_app_token( $token, $platform, $user_id, $phone_number, $delete, $firebase_token );
        }
        else{
            $return->message = 'no token';
        }
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
        die('');
    }


    function do_not_disturb_email() {
        if ( !empty($_GET['email']) && !empty($_GET['type']) ) {
            $user = new luser();
            $user->do_not_disturb( $_GET['email'], $_GET['type'] );
        }
        header("Location: /");
        die('');
    }



    function delete_avatar() {
        if ( !empty($_GET['user_id']) ) {
            $user = new luser();
            $user->delete_avatar( $_GET['user_id'] );
        }
        die('');
    }

    function unlink_acc() {
        if ( !empty($_GET['unlink_acc']) ) {
            $user = new luser();
            $user->unlink_acc( $_GET['unlink_acc'] );
        }
        header("Location: {$_SERVER["HTTP_REFERER"]}");
        die('');
    }



    function code_auth() {
        if ( !empty($_POST['code']) && !empty($_POST['phone_number']) && strlen($_POST['code']) > 4 && strlen($_POST['phone_number']) > 9 ) {
            $code         = $this->db->escape(trim($_POST['code']));
            $phone_number = $this->db->escape(substr(trim($_POST['phone_number'], -10)));

            // Так можно авторизовать только обычного пользователя
            $t_user    = $this->db->get_row("SELECT * FROM `users` WHERE phone_number LIKE '%" . $phone_number . "' AND card_number LIKE '%" . $code . "' AND enabled = '1' AND user_id = original_user_id; ");
            if (!empty($t_user)) {
              if ($t_user->group_id > 1) {
                header("Location: /otp_auth/");
                exit();
              }
              else {
                $user = new luser();
                $user->login( $t_user->user_id );
              }
            }
        }
        header("Location: {$_SERVER["HTTP_REFERER"]}");
        die('');
    }



    function avatar_change() {
        // Необходимо контролировать безопасность, чтобы другой пользователь не мог поменять аватар соседу с другим user_id
        $user_id = $_SESSION['user']->user_id;
        if ( !empty($user_id) && !empty($_FILES["avatar"])) {
          if ( $_FILES['avatar']['size'] > 2097152 ) { // Аватарка не может быть больше 2мб
            if($_COOKIE['language'] == 'eng'){$avatar_error='File is too big!';}
            else{$avatar_error='Аватар слишком велик!';}
          }
          $imgW = $imgH = 300;
          $imageinfo = getimagesize($_FILES['avatar']['tmp_name']);
          if($imageinfo[0] > 300 || $imageinfo[1] > 300){
            $jpeg_quality = 100;
            switch(strtolower($imageinfo['mime'])){
              case 'image/png':
                $img_r = imagecreatefrompng($_FILES['avatar']['tmp_name']);
                $source_image = imagecreatefrompng($_FILES['avatar']['tmp_name']);
                $type = '.png';
                break;
              case 'image/jpeg':
                $img_r = imagecreatefromjpeg($_FILES['avatar']['tmp_name']);
                $source_image = imagecreatefromjpeg($_FILES['avatar']['tmp_name']);
                $type = '.jpeg';
                break;
              case 'image/gif':
                $img_r = imagecreatefromgif($_FILES['avatar']['tmp_name']);
                $source_image = imagecreatefromgif($_FILES['avatar']['tmp_name']);
                $type = '.gif';
                break;
              default:
                if($_COOKIE['language'] == 'eng'){$avatar_error='The file has an wrong type!';}
                else{$avatar_error='Файл имеет неразрешенный тип!';}
            }
            $resizedImage = imagecreatetruecolor($imgW, $imgH);
            imagecopyresampled($resizedImage, $source_image, 0, 0, 0, 0, $imgW, $imgH, $imageinfo[0], $imageinfo[1]);
            imagejpeg($resizedImage, $_FILES['avatar']['tmp_name'], $jpeg_quality);
          }
          else{
            $allow_types = array('jpg', 'jpeg', 'gif', 'png');
            $allow_meme_types = array('image/pjpeg', 'image/jpeg', 'image/gif', 'image/png');
            $ext = strtolower(pathinfo($_FILES['avatar']['name'], PATHINFO_EXTENSION));
            if(!in_array($ext, $allow_types) || !in_array($imageinfo['mime'], $allow_meme_types)){
              if($_COOKIE['language'] == 'eng'){$avatar_error='The file has an wrong type!';}
              else{$avatar_error='Файл имеет неразрешенный тип!';}
            }
          }
          if(!$avatar_error){
            $user = new luser();
            $user->change_avatar( $user_id, $_FILES["avatar"] );
          }
          if ($avatar_error) {
            $_SESSION['USER_MESSAGE'] = $avatar_error;
          }
        }
        header("Location: {$_SERVER["HTTP_REFERER"]}");
        die('');
    }



    function update_purchase_sum( $die = true ) {
        $users  = $this->db->results(" SELECT * FROM `users` WHERE card_number <> '' AND name <> '' GROUP BY original_user_id; ");
        $luser  = new luser();
        foreach ( $users as $user ) {
            $purchase_sum = $luser->get_sum_of_buy($user->original_user_id);
            if ( !empty($purchase_sum) ) {
                $last_buy = $luser->get_last_buy($user->original_user_id);
                if ( $last_buy ) {
                    $last_buy = ", purchase_last_what = '{$last_buy->model}', purchase_last_sum = '{$last_buy->price}', purchase_last_date = '{$last_buy->date}' ";
                }
                echo "{$user->original_user_id} {$purchase_sum}<br>";
                $this->db->query(" UPDATE `users` SET purchase_sum_real = '{$purchase_sum}' {$last_buy} WHERE original_user_id = '{$user->original_user_id}'; ");
                usleep(500);
            }
        }
        if ($die) die();
    }



    function do_not_disturb() {
        if ( !empty($_GET['user_id']) && !empty($_GET['type']) ) {
            $user = new luser($_GET['user_id']);
            $user_tmp = $this->db->get_row($sql = "SELECT * FROM `users` WHERE `user_id` = '{$_GET['user_id']}'; ");
            if ($_GET['type'] == 'sms'){
                if ($user_tmp->stop_sms == 0){
                    if ( $user->do_not_disturb( $_GET['user_id'], $_GET['type'] ) ) {
                        $et = new email_template('add_to_stop_list');
                        $et->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                        ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                        ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                        ->assign('UNSUBSCRIBE_LINK',"https://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email=" . $user->get('email') . "&type=email")
                        ->assign('USER_NAME',       $user->get('name'))
                        ->assign('USER_EMAIL',      $user->get('email'))
                        ->assign('USER_PHONE',      $user->get('phone_number'))
                        ->assign('ADMIN_NAME',      $_SESSION['user']->name)
                        ->assign('DATE',            date('d M, H:i'))
                        ->send('mail@lsboutique.ru');
                        if($user_tmp->user_id == $_SESSION['user']->user_id){
                          $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> отписался от смс-рассылок";
                        }else{
                          $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> был добавлен в стоп лист смс-рассылок пользователем {$_SESSION['user']->name}";
                        }
                    }
                }
                elseif ($user_tmp->stop_sms == 1){
                    $user->remove_from_stopList( $_GET['user_id'], $_GET['type'] );
                    if($_GET['user_id'] == $_SESSION['user']->user_id){
                      $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> подписался на смс-рассылки";
                    }else{
                      $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> был удален из стоп листа смс-рассылок пользователем {$_SESSION['user']->name}";
                    }
                }
            }
            elseif ($_GET['type'] == 'email'){
                if ($user_tmp->stop_email == 0){
                    $user->do_not_disturb( $_GET['user_id'], $_GET['type'], $_GET['email'] );
                    if($user_tmp->user_id == $_SESSION['user']->user_id){
                      $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> отписался от email-рассылок";
                    }else{
                      $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> был добавлен в стоп лист email-рассылок пользователем {$_SESSION['user']->name}";
                    }
                }
                elseif ($user_tmp->stop_email == 1){
                    $user->remove_from_stopList( $_GET['user_id'], $_GET['type'], $_GET['email'] );
                    if($_GET['user_id'] == $_SESSION['user']->user_id){
                      $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> подписался на email-рассылки";
                    }else{
                      $message = "<https://lsboutique.ru/admin/index.php?section=User&user_id={$user_tmp->user_id}|{$user_tmp->name}> был удален из стоп листа email-рассылок пользователем {$_SESSION['user']->name}";
                    }
                }
            }
            // Отправляем в слак
            $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "stop_lists_history" );
            Job::push('SlackJob', $args);
        }
        die('');
    }



    function restore_card_number() {
        if ( !empty($_GET['phone']) && strlen($_GET['phone']) > 9 ) {
            $user = luser::restore_card_by_phone($_GET['phone']);
            if ( $user ) {
                $card_number = $user->card_number;
                if ($user->group_id == 1) $card_number = substr($user->card_number, -5);

                $m = "{$card_number} - номер Вашей карты";

                send_sms_to_phone( $user->phone_number, $m, $user->original_user_id );

                die('ok');
            }
        }
        die('fail');
    }



    function client_add() {
        if ( is_array($_POST) && count($_POST) >0 ) {
            $email          = $this->db->escape(trim($_POST['email']));
            $_POST['phone_number'] = str_replace(array(' ','-',')','(','+'), '', $_POST['phone_number']);
            if ( strlen($_POST['phone_number']) == 10 ) {
                $_POST['phone_number'] = '8' . $_POST['phone_number'];
            }
            $phone_number   = $this->db->escape($_POST['phone_number']);
            $name           = $this->db->escape(trim($_POST['name'], " .,;:*!@#$%^&'()"));
            $city_id        = (int)$_POST['city_id'];
            $city           = @$this->db->get_var("SELECT city_name FROM `delivery_cities` WHERE city_id = '{$city_id}' LIMIT 1");
            $adress         = $this->db->escape($_POST['address']);
            $card_number    = $this->db->escape(trim(str_replace(' ', '', $_POST['card_number'])));
            $birthday       = explode('.', $_POST['birthday']);
            $birthday       = is_array($birthday) && count($birthday) > 1 ? $birthday[2] . '-' . $birthday[1] . '-' . $birthday[0] : '';
            $sex            = (int)$_POST['sex'];
            $size_top       = $this->db->escape(trim($_POST['sizetop']));
            $size_bottom    = $this->db->escape(trim($_POST['sizebottom']));
            $size_shoe      = $this->db->escape(trim($_POST['sizeshoe']));
            $p_d            = (int)$_POST['personal_discount'];

            $d2ps = array('0'=>'0', '10'=>'100002', '15'=>'250002', '20'=>'500002', '25'=>'900002', '30'=>'1500002');
            $ps   = isset( $d2ps[$p_d] ) ? $d2ps[$p_d] : '0';

            $user_tmp = false;
            $user_tmp = $this->db->get_row($sql = "SELECT * FROM `users` WHERE `phone_number` LIKE '%" . $this->db->escape($_POST['phone_number']) . "'; ");
            if ( !empty($user_tmp)) {
                if ( !empty($card_number) && strlen($card_number) > 8 ) {
                    $this->db->query("UPDATE `users` SET `card_number` = {$card_number} WHERE `original_user_id` = {$user_tmp->original_user_id}; ");
                    $_SESSION['USER_MESSAGE'] = "Номер карты клиента изменен. Новый номер карты №{$card_number}";
                    if($_COOKIE['language']=='eng') $m = (!empty($user_tmp->name) ? "{$user_tmp->name}, " : '') . "your card number for Luxury Store is №{$card_number}. www.lsboutique.ru 88003332138";
                    else $m = (!empty($user_tmp->name) ? "{$user_tmp->name}, " : '') . "номер Вашей карты в Лакшери Store №{$card_number}. www.lsboutique.ru 88003332138";
                    send_sms_to_phone( $phone_number, $m, $user_tmp->original_user_id);
                }
                else {
                    $_SESSION['USER_MESSAGE'] = "Клиент с таким номером телефона уже существует. Его номер карты №{$user_tmp->card_number}";
                    if($_COOKIE['language']=='eng') $m = (!empty($user_tmp->name) ? "{$user_tmp->name}, " : '') . "your card number for Luxury Store is №{$user_tmp->card_number}. www.lsboutique.ru 88003332138";
                    else $m = (!empty($user_tmp->name) ? "{$user_tmp->name}, " : '') . "номер Вашей карты в Лакшери Store №{$user_tmp->card_number}. www.lsboutique.ru 88003332138";
                    send_sms_to_phone( $phone_number, $m, $user_tmp->original_user_id);
                }
                header("Location: /");
                exit();
            }
            if ( !empty($card_number) && strlen($card_number) > 8 ) {
                $this->db->query("UPDATE `cards` SET assign = '1' WHERE `number` LIKE '%{$card_number}' LIMIT 1; ");
                $user_tmp = $this->db->get_row("SELECT * FROM `users` WHERE `card_number` LIKE '%{$card_number}' LIMIT 1; ");
            }
            if ( empty($card_number) ) {
                $card_number = luser::generate_card_number();
            }

            if ( isset($user_tmp->original_user_id) && !empty( $user_tmp->original_user_id ) ) {
                $user_id = $user_tmp->original_user_id;
                $this->db->query($sql = "UPDATE `users`
                    SET `email`                 =  '{$email}',
                        `need_welcome_email`    = '0',
                        `name`                  = '{$name}',
                        `sex`                   = '{$sex}',
                        `group_id` = '1', `enabled` = '1',
                        `card_registered` = '" . date('Y-m-d') . "',
                        `shoe_size`             = '{$size_shoe}',
                        `phone_number`          = '{$phone_number}',
                        `order_email`           = '{$email}',
                        `city_id`               = '{$city_id}',
                        `city`                  = '{$city}',
                        `adress`                = '{$adress}',
                        `purchase_sum`          = '{$ps}',
                        `birth_date`            = '{$birthday}',
                        " . (!empty($p_d) ? " `personal_discount`   = '{$p_d}', " : '') . "
                        `size_top`              = '{$size_top}',
                        `size_bottom`           = '{$size_bottom}'
                    WHERE original_user_id = '{$user_tmp->original_user_id}';");
                    $this->db->query("INSERT INTO users2sizes (user_id, type_id, size) VALUES ({$user_id}, 1, '{$size_top}')");
                    $this->db->query("INSERT INTO users2sizes (user_id, type_id, size) VALUES ({$user_id}, 2, '{$size_bottom}')");
                    $this->db->query("INSERT INTO users2sizes (user_id, type_id, size) VALUES ({$user_id}, 3, '{$size_shoe}')");
            }
            else {
                $this->db->query("INSERT INTO `users` ( `email` , `need_welcome_email` , `name` , `sex` , `group_id` , `enabled` , `shoe_size`, `card_number` , `phone_number` , `order_email` , `city_id` , `city` , `adress` , `birth_date` , `card_registered`, `shop`, `size_top`, `size_bottom`, `personal_discount`, `purchase_sum`, `password`)
                             VALUES ( '{$email}', '0', '{$name}','{$sex}', '1', '1', '{$size_shoe}', '{$card_number}', '{$phone_number}', '{$email}', '{$city_id}', '{$city}', '{$adress}', '{$birthday}', '" . date('Y-m-d') . "', '{$shop}', '{$size_top}', '{$size_bottom}', '{$p_d}', '{$ps}', md5(rand()));");
                $user_id = $this->db->insert_id();
                $this->db->query("UPDATE `users` SET `original_user_id` = `user_id` WHERE `original_user_id` = '0'; ");
                $this->db->query("INSERT INTO users2sizes (user_id, type_id, size) VALUES ({$user_id}, 1, '{$size_top}')");
                $this->db->query("INSERT INTO users2sizes (user_id, type_id, size) VALUES ({$user_id}, 2, '{$size_bottom}')");
                $this->db->query("INSERT INTO users2sizes (user_id, type_id, size) VALUES ({$user_id}, 3, '{$size_shoe}')");
                if (isset($_GET['spec_assign'])){
                    $this->db->query("UPDATE `special_orders` SET `user_id`='{$user_id}' WHERE `so_id` = {$_GET['spec_assign']}");
                }
            }
            if (!empty($_POST['shop_id'])) { // Магазин пользователя
                $this->db->query("INSERT INTO users2shops (user_id, shop_id) VALUES ({$user_id}, ".(int)$_POST['shop_id'].")");
            }
            else{
              $c_boxes = explode(',',$_SESSION['user']->cashbox_ids);
              foreach($c_boxes as $c){
                $shop = $this->db->result("SELECT shop_id FROM `shop_cashbox` WHERE `id` = '{$c}'; ")->shop_id;
                if(!empty($shop))break;
              }
              $this->db->query("INSERT INTO users2shops (user_id, shop_id) VALUES ({$user_id}, {$shop})");
            }
            if (!empty($_POST['manager_id'])) { // Менеджер пользователя
                $this->db->query("INSERT INTO users_client_managers (user_id, client_manager_id) VALUES ({$user_id}, ".(int)$_POST['manager_id'].")");
            }

            $this->db->query("INSERT INTO sr_manager2users (manager_id, user_id) VALUES ({$_SESSION['user']->user_id}, {$user_id}");


            // Отправляем в слак
            $message = "Был зарегистрирован новый пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user_id}|{$name}>, телефон {$phone_number}, <https://wa.me/{$phone_number}|Whatsapp>!";
            $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "user_registation" );
            Job::push('SlackJob', $args);

            if($_COOKIE['language']=='eng') $m = (!empty($name) ? "{$name}, " : '') . "your card number for Luxury Store is №{$user_tmp->card_number}. www.lsboutique.ru 88003332138";
            else $m = (!empty($name) ? "{$name}, " : '') . "номер Вашей карты в Лакшери Store №{$user_tmp->card_number}. www.lsboutique.ru 88003332138";
            send_sms_to_phone( $phone_number, $m, $user_id );

            if ($email) {
                $et = new email_template('activate_card_number');
                $et->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('UNSUBSCRIBE_LINK',"https://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email={$email}&type=email")
                ->assign('USER_NAME',       $name)
                ->assign('USER_EMAIL',      $email)
                ->assign('USER_PHONE',      $phone_number)
                ->assign('USER_CARD_NUMBER',$card_number)
                ->assign('USER_DISCOUNT',   ($p_d > 0 ? $p_d : '5'))
                ->assign('USER_LOGIN_URL',  $phone_number && $card_number ? "<br>Или войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$phone_number}&card_number={$card_number}\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\" style=\"color:#787878;text-decoration:underline;font-weight:bold\">ссылкой</a><br>" : '')
                ->assign('USER_PHONE_NUMBER', 	$phone_number)
                ->send( $email )->send('mail@lsboutique.ru');
                luser::save_to_crm( $user_id, 'email', $et->getMergedField('subject'), $et->getMergedBodyHtml());
            }

            $et = new email_template('activate_card_number_admin');
            $et->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
            ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
            ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
            ->assign('USER_NAME',       $name)
            ->assign('USER_EMAIL',      $email)
            ->assign('USER_PHONE',      $phone_number)
            ->assign('USER_CARD_NUMBER',$card_number)
            ->assign('USER_BIRTHDAY',   $birthday)
            ->assign('USER_SEX',        ($sex == 1 ? 'Мужской' : 'Женский'))
            ->assign('USER_SHOP',       $shop)
            ->assign('USER_SIZE_TOP',   $size_top)
            ->assign('USER_SIZE_BOTTOM',$size_bottom)
            ->assign('USER_SHOE',       $size_shoe)
            ->assign('USER_DISCOUNT',   ($p_d > 0 ? $p_d : '5'))
            ->assign('MANAGER_NAME',    $_SESSION['user']->name)
            ->assign('DATE',            date('d M, H:i'))
            ->send('mail@lsboutique.ru');

            $_SESSION['USER_MESSAGE'] = 'Вы добавили клиента. <br>Всё получилось. Вы молодец!';
        }
        if (isset($_GET['spec_assign'])){header("Location: {$_SERVER["HTTP_REFERER"]}");}
        else{header("Location: /");}
        exit();
    }



    function self_register() {
        if ($this->settings->theme != 'api' && empty($_POST["g-recaptcha-response"])) {
            if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Data check error.<br>Are you sure you`re not a robot?<br>';}
            else{$_SESSION['USER_MESSAGE'] = 'Ошибка проверки ввода данных.<br>Вы точно не робот?<br>';}
            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }
        if ($this->settings->theme != 'api' && !empty($_POST["g-recaptcha-response"])) {
            $data = array(
                'secret'   => "6LfDlk4UAAAAALuvyk_3zGJjl3nokrx7rK78La34",
                'response' => $_POST["g-recaptcha-response"]
            );

            $verify = curl_init();
            curl_setopt($verify, CURLOPT_URL, "https://www.google.com/recaptcha/api/siteverify");
            curl_setopt($verify, CURLOPT_POST, true);
            curl_setopt($verify, CURLOPT_POSTFIELDS, http_build_query($data));
            curl_setopt($verify, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($verify, CURLOPT_RETURNTRANSFER, true);
            $response = curl_exec($verify);

            if ($response ['success'] != true) {
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Data check error.<br>Are you sure you`re not a robot?<br>';}
                else{$_SESSION['USER_MESSAGE'] = 'Ошибка проверки ввода данных.<br>Вы точно не робот?<br>';}
                header("Location: {$_SERVER["HTTP_REFERER"]}");
                exit();
            }
        }
        if ($this->settings->theme == 'api' && empty($_POST['phone_number']) && !empty($_REQUEST['phone_number'])){
            $_POST = $_REQUEST;
        }
        if (isset($_POST['phone_number'])){
            $_POST['phone_number'] = str_replace(array(' ','-',')','(','+'), '', $_POST['phone_number']);
            if (strlen($_POST['phone_number']) < 10 || strlen($_POST['phone_number']) > 16  || !ctype_digit($_POST['phone_number'])){
              if ($this->settings->theme == 'api') {
                if($_COOKIE['language'] == 'eng'){$m='Data error. Invalid phone number';}
                else{$m = 'Ошибка данных. Неправильный номер телефона';}
                if($this->settings->theme_v == 'v2'){$return->success = false;$return->message = $m;}
                else{$return = $m;}
                $return = json_encode($return);
                header('Content-Type: application/json');
                echo $return;
                exit();
              }
            }
        }
        if ( is_array($_POST) && count($_POST) >0 && strlen($_POST['phone_number']) >= 10) {
            $email          = $this->db->escape(trim($_POST['email']));
            if ( strlen($_POST['phone_number']) == 10 ) {
                $_POST['phone_number'] = '8' . $_POST['phone_number'];
            }
            $phone_number   = $this->db->escape($_POST['phone_number']);
            $name           = $this->db->escape(trim($_POST['name']));
            if ( $_POST['surname'] ) {
                $name = $this->db->escape(trim($_POST['surname'])) . ' ' . $name;
            }
            if ( strpos($name, '@') !== false || strpos($name, '#') !== false || strpos($name, '$') !== false ){$return = 'Ошибка данных';exit();}


            $sex = (int)$_POST['sex'];

            $user_tmp = false;
            $user_tmp = $this->db->get_row($sql = "SELECT * FROM `users` WHERE `phone_number` LIKE '%" . $this->db->escape(substr($_POST['phone_number'], -10)) . "'; ");
            if ( !empty($user_tmp)) {
                $card_number = substr($user_tmp->card_number, -16);
                if($_COOKIE['language'] == 'eng'){$message="{$user_tmp->name}! Your Luxury Store card number №{$card_number}. www.lsboutique.ru 88003332138";}
                else{$message = "{$user_tmp->name}! Номер Вашей карты в Лакшери Store №{$card_number}. www.lsboutique.ru 88003332138";}
                send_sms_to_phone( $user_tmp->phone_number, $message, $user_tmp->original_user_id );
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'A client with this phone number already exists.<br> You have been sent an SMS with your card number.<br>';}
                else{$_SESSION['USER_MESSAGE'] = 'Клиент с таким номером телефона уже существует.<br>Вам было отправлено SMS с вашим номером карты.<br>';}
                if ($this->settings->theme == 'api') {
                    if($this->settings->theme_v == 'v2'){$return->success = false;}
                    if($_COOKIE['language'] == 'eng'){$return->message = 'A client with this phone number already exists. You have been sent an SMS with your card number.';}
                    else{$return->message = 'Клиент с таким номером телефона уже существует. Вам было отправлено SMS с вашим номером карты.';}
                    $return = json_encode($return);
                    header('Content-Type: application/json');
                    echo $return;
                }
                else{
                    header("Location: {$_SERVER["HTTP_REFERER"]}");
                }
                exit();
            }
            else {
                $card_number    = luser::generate_card_number();
                $reg_source     = 0;
                if ($this->settings->theme == 'api') {$reg_source = 1;}
                $this->db->query("INSERT INTO `users` ( `email` , `need_welcome_email` , `name` , `sex` , `group_id` , `enabled` , `shoe_size`, `card_number` , `phone_number` , `order_email` , `birth_date` , `card_registered`, `shop`, `size_top`, `size_bottom`, `personal_discount`, `purchase_sum`, `password`, `reg_source`)
                             VALUES ( '{$email}', '0', '{$name}','{$sex}', '1', '1', '{$size_shoe}', '{$card_number}', '{$phone_number}', '{$email}', '{$birthday}', '" . date('Y-m-d') . "', '{$shop}', '{$size_top}', '{$size_bottom}', '{$p_d}', '{$ps}', md5(rand()), '{$reg_source}');");
                $user_id = $this->db->insert_id();
                $this->db->query("UPDATE `users` SET `original_user_id` = `user_id` WHERE `original_user_id` = '0'; ");
                $this->db->query("INSERT INTO users2shops (user_id, shop_id) VALUES ({$user_id}, 7)");
                $user_obj = new luser(); $user = false;
                $user     = $this->db->get_row($sql = "SELECT * FROM `users` WHERE `phone_number` LIKE '%" . $phone_number . "'; ");

                if ($this->settings->theme == 'api') {
                    if($this->settings->theme_v == 'v2'){$return->success = true;}
                    if($_COOKIE['language'] == 'eng'){$return->message = 'Congratulation! Your registration completed successfully.';}
                    else{$return->message = 'Поздравляем! Регистрация прошла успешно.';}
                    $user = $this->db->get_row("SELECT user_id, original_user_id, email, name, sex, card_number, phone_number FROM `users` WHERE `phone_number` LIKE '%" . $phone_number . "'; ");
                    $this->db->query("UPDATE users SET last_api_login_date = NOW() WHERE original_user_id = '{$user->original_user_id}'");
                    $return->user = $user;
                    if ($_POST['test'] == 1) {
                        $this->db->query("DELETE FROM users WHERE user_id = {$user->user_id}");
                    }
                }
                else{
                    $user_obj->login($user->original_user_id);
                }
            }

            if(!isset($_POST['test'])){
                // Отправляем в слак
                $message = "Зарегистрировался новый пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user->original_user_id}|{$name}>, телефон {$phone_number}, <https://wa.me/{$phone_number}|Whatsapp>!";
                $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "user_self_register" );
                Job::push('SlackJob', $args);

                if($_COOKIE['language'] == 'eng'){$m = "{$name}! Номер Вашей карты в Лакшери Store №{$card_number}. www.lsboutique.ru 88003332138";}
                else{$m = "{$name}! Your card number in Luxury Store №{$card_number}. www.lsboutique.ru 88003332138";};

                if($_COOKIE['language'] == 'eng'){$message = "{$card_number} - Your card number in www.lsboutique.ru";}
                else{$message = "{$card_number} - номер Вашей карты в www.lsboutique.ru";}
                $args = array( 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $phone_number, 'user_id' => (isset($user->original_user_id) ? $user->original_user_id : 0), 'sms_only' => 1 );
                Job::push( 'SmsJob', $args, false, 'critical' );

                $et = new email_template('new_user_registered');
                $et->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('UNSUBSCRIBE_LINK',"https://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email={$email}&type=email")
                ->assign('USER_CARD_NUMBER',$card_number)
                ->assign('USER_DISCOUNT',   ($p_d > 0 ? $p_d : '5'))
                ->assign('USER_NAME',       $name)
                ->assign('USER_PHONE',      $phone_number)
                ->assign('USER_LOGIN_URL',  $phone_number && $card_number ? "<br>Или войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$phone_number}&card_number={$card_number}" . "\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\" style=\"color:#787878;text-decoration:underline;font-weight:bold\">ссылкой</a><br>" : '')
                ->assign('USER_PHONE_NUMBER', 	$phone_number)
                ->send('mail@lsboutique.ru');

                luser::save_to_crm( $user_id, 'email', $et->getMergedField('subject'), $et->getMergedBodyHtml());

                if ( !empty($email)) {
                    $et = new email_template('new_user_welcome');
                    $et->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                    ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                    ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                    ->assign('USER_NAME',       $name)
                    ->assign('USER_EMAIL',      $email)
                    ->assign('USER_CARD_NUMBER',$card_number)
                    ->assign('USER_DISCOUNT',   ($p_d > 0 ? $p_d : '5'))
                    ->assign('MANAGER_NAME',    $_SESSION['user']->name)
                    ->assign('USER_LOGIN_URL',  $phone_number && $card_number ? "<br>Или войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$phone_number}&card_number={$card_number}\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\" style=\"color:#787878;text-decoration:underline;font-weight:bold\">ссылкой</a><br>" : '')
                    ->assign('USER_PHONE_NUMBER', 	$phone_number)
                    ->assign('DATE',            date('d M, H:i'))
                    ->send($email);
                }
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Congratulation! Your registration completed successfully.';}
                else{$_SESSION['USER_MESSAGE'] = 'Поздравляем! Регистрация прошла успешно.';}
            }
        }
        else{
            if ($this->settings->theme == 'api') {
                if($_COOKIE['language'] == 'eng'){$m = 'Data not received';}
                else{$m = 'Данные не получены';}
                if($this->settings->theme_v == 'v2'){$return->success = false;$return->message = $m;}
                else{$return = isset($return) ? $return : $m;}
            }
        }
        if ($this->settings->theme == 'api') {
            if($this->settings->theme_v == 'v2'){
              $r->obj[0] = $return;
              $return = $this->format_api_response($r);
            }
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
        }
        else {
            header("Location: {$_SERVER["HTTP_REFERER"]}");
        }
        exit();
    }



    function deposit() {
        // Если пользователь администратор или менеджер
        if ( is_array($_POST) && count($_POST)>0 && ( luser::is_allowed('admin') || luser::is_allowed('accountant')) ) {
            $user = new luser((int)$_POST['resiever_info']);
            $order_product_id = isset( $_POST['order_product_id'] ) ? (int)$_POST['order_product_id'] : '';
            $user->change_deposit( $_POST['deposit_sum'], $_POST['field_reason'], $_POST['order_id'], $order_product_id);
        }
        if(isset($_GET['ajax'])){
          if(isset( $_POST['order_product_id'] )){
            $product = $this->db->result("SELECT product_name, product_id FROM `orders_products` WHERE id = {$order_product_id}");
            $text = "Пользователем <b>{$_SESSION['user']->name}</b> добавлена стоимость возвращенного товара {$product->product_name} на депозитный счет в сумме {$_POST['deposit_sum']} р";
            $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$_POST['order_id']}, {$_SESSION['user']->user_id}, 'deposit', '{$text}')");
          }
          die("OK");
        }
        else{
            header("Location: {$_SERVER["HTTP_REFERER"]}");
        }
        exit();
    }



    function subscribe() {
        $user_id = $this->settings->theme == 'api' ? (int)$_GET['user_id'] : $_SESSION['user']->user_id;
        if (!empty($user_id) && !empty($_GET['brand_id'])){
            $brand_id = (int)$_GET['brand_id'];
            $subscribtion   = $this->db->result($sql = "SELECT * FROM users2brands WHERE user_id = '{$user_id}' AND brand_id = '{$brand_id}' LIMIT 1;");
            $brand  = $this->db->result($sql = "SELECT * FROM brands WHERE brand_id = '{$brand_id}' LIMIT 1;");
            $user = new luser($user_id);
            if (!empty($subscribtion)){
                if ($subscribtion->status == 1){
                    $user->unsubscribe_from_brand($user->user_id, $brand_id);
                    if($_COOKIE['language'] == 'eng'){$result = "{$brand->name} brand subscription has been deactivated";}
                    else{$result = "Подписка на бренд {$brand->name} отменена";}
                    $active = 0;
                }
                else {
                    $user->subscribe_to_brand($user->user_id, $brand_id);
                    if($_COOKIE['language'] == 'eng'){$result = "{$brand->name} brand subscription has been activated";}
                    else{$result = "Подписка на бренд {$brand->name} активирована";}
                    $active = 1;
                    // Отправляем в слак
                    $user_name   = $this->db->result($sql = "SELECT name FROM users WHERE user_id = '{$user->user_id}' LIMIT 1;")->name;
                    $manager = $this->db->result("SELECT name, slack_name FROM `users` WHERE `user_id` = '{$user->user_id}'");
                    $message = "<@{$manager->slack_name}> Пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user->user_id}|{$user_name}>, подписался на обновления бренда {$brand->name}!";
                    $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "brands_subscribtions" );
                    Job::push('SlackJob', $args);
                }
            }
            else {
                $user->subscribe_to_brand($user->user_id, $brand_id);
                if($_COOKIE['language'] == 'eng'){$result = "{$brand->name} brand subscription has been activated";}
                else{$result = "Подписка на бренд {$brand->name} активирована";}
                $active = 1;
            }
            if ($this->settings->theme == 'api') {
                header('Content-Type: application/json');
                $res->message = $result;
                $res->active = $active;
                $result = json_encode($res);
            }
            echo $result;
        }
        die();
    }


    function get_subscription() {
        $user_id = $this->settings->theme == 'api' ? (int)$_GET['user_id'] : $_SESSION['user']->user_id;
        if (!empty($user_id) && !empty($_GET['brand_id'])){
            $brand_id = (int)$_GET['brand_id'];
            $subscribtion   = $this->db->result($sql = "SELECT * FROM users2brands WHERE user_id = '{$user_id}' AND brand_id = '{$brand_id}' LIMIT 1;");
            if (!empty($subscribtion)){
                $active = (int)$subscribtion->status;
            }
            else {
                $active = 0;
            }
            header('Content-Type: application/json');
            $res->active = $active;
            $result = json_encode($res);
            echo $result;
        }
        if (!empty($user_id) && !isset($_GET['brand_id'])){
            $result   = $this->db->results($sql = "SELECT u2b.brand_id as id, b.name
                                                    FROM users2brands u2b
                                                    LEFT JOIN brands b ON u2b.brand_id = b.brand_id
                                                    WHERE u2b.user_id = '{$user_id}'
                                                    AND u2b.status = 1;");
            header('Content-Type: application/json');
            $res->subscriptions = $result;
            $result = json_encode($res);
            echo $result;
        }
        die();
    }


    function users2sizes() {
        if (!empty($_SESSION['user']->user_id) || ($this->settings->theme == 'api' && !empty($_GET['user_id'])) && !empty($_GET['size']) && !empty($_GET['type_id'])){
            $size   =   mysql_real_escape_string($_GET['size']);
            $type_id = (int)$_GET['type_id'];
            $user_id = isset($_GET['user_id']) ? (int)$_GET['user_id'] : $_SESSION['user']->user_id;
            $user = new luser($user_id);
            $result = $user->user2size( $user_id, $size, $type_id );
            if ($this->settings->theme == 'api') {
                $result = json_encode($result);
                echo $result;
            }
        }
        die();
    }



    function check_novelty( $die = true ) {
        set_time_limit(0);
        // Функция считает неправильно
        // $this->update_purchase_sum(false);
        if ($die) die();
    }



    function check_wishlist($viewed = false) {
        set_time_limit(0);
        $user   = new luser();
        $u2w    = $viewed ? $user->get_viewed_discount() : $user->get_wishlist_discount();

        if ( is_array($u2w) && count($u2w) ) {
            $et     = new email_template('discount_start');

            $sended_emails = $sended_sms = 0;
            foreach ($u2w as $user_id => $products ) {
                $u = new luser($user_id);
                if ($u->group_id != 1) continue; // Если это "наш" пользователь, не посылаем ему смс и письма
                $slack_m = '';
                $sms_m = '';

                echo $u->name . ' ' . $u->phone_number . ' ' . $u->email . '<br>';
                foreach ($products as $v => $price) {
                    $check = false;
                    $product = $this->db->result("SELECT * FROM products WHERE product_id = '{$v}'");
                    $item_sizes = $this->db->results("SELECT items.size_id, items.normal_size FROM items LEFT JOIN warehouses ON items.warehouse_id = warehouses.warehouse_id  WHERE items.product_id = '{$v}' AND warehouses.spam_enabled = 1");
                    $i_sizes = array();$n_sizes = array();
                    foreach($item_sizes as $size){$i_sizes[] = $size->size_id;$n_sizes[] = $size->normal_size;}
                    if(in_array('Р-р не задан',$n_sizes) || in_array('р-р не зад',$n_sizes) || in_array('не задан',$n_sizes)){$check = 1;}
                    if($check === false){
                      $user_sizes = $this->db->results("SELECT size_id FROM users2sizes_n WHERE user_id = '{$user_id}'");
                      $u_sizes = array();
                      foreach($user_sizes as $size){$u_sizes[] = $size->size_id;}
                      $check = array_intersect($u_sizes, $i_sizes);
                    }
                    if ( $u->phone_number && !$u->stop_sms && !empty($product->product_id) && !empty($check) ) {
                        // Это кладем только если из вишлиста
                        if (!$viewed) $this->db->query("INSERT INTO one_click (`date`, `name`, `phone`, `enabled`, `from`, `product_id`) VALUES ( NOW(), '{$u->name}', '{$u->phone_number}', 1, 'wish_list', {$v} )");
                        if ( 100*($price - $product->price)/$price > 10 && $product->price > 0 ) { // Если подешевело больше чем на 10% - кинем СМС
                            //Собираем сообщение для смс
                            $link = "https://{$_SERVER['HTTP_HOST']}/products/{$product->product_id}/";
                            $diff = $price - $product->price;
                            $sms_m .= "{$product->model} на {$diff} рублей {$link}, ";
                        }
                    }
                    if ( (($price - $product->price) > 500 && $product->price > 0) && !empty($product->product_id) && !empty($check)){
                        //Собираем сообщение для слак
                        $diff = $price - $product->price;
                        $slack_m .= " <https://{$_SERVER['HTTP_HOST']}/products/{$product->product_id}/|{$product->model}> с {$price} на {$product->price} разница {$diff} рублей,";

                    }
                }
                if(!empty($sms_m)){
                  // Отправляем смс
                  $name = trim($u->name);
                  $tm = "{$name}, в Лакшери Стор снижена цена на ";
                  $m = $tm . $sms_m;
                  echo $m . '<br>';
                  $args = array( 'sender' => 'lsboutique', 'message_text' => $m, 'phone_number' => $u->phone_number, 'user_id' => (isset($u->original_user_id) ? $u->original_user_id : 0) );
                  Job::push( 'SmsJob', $args );
                  $sended_sms++;
                }
                if(!empty($slack_m)){
                  // Отправляем в слак
                  $manager = $this->db->result("SELECT name, slack_name FROM `users` WHERE `user_id` = '{$u->p_manager_id}'");
                  $tm = "<@{$manager->slack_name}> В вишлисте <https://{$_SERVER['HTTP_HOST']}/admin/index.php?section=User&user_id={$user_id}|{$u->name}>, <https://wa.me/{$u->phone_number}|Whatsapp> была снижена цена на";
                  $m = $tm . $slack_m;
                  echo $m . '<br>';
                  $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "wishlist_price_change" );
                  Job::push('SlackJob', $args);
                }
                //die();

                $order = new stdClass();
                $products        = array_keys($products);
                $order->products = $user->get_products_by_ids($products);
                $this->smarty->assign('order', $order);

                if ( $u->email && !$u->stop_email ) {
                    $this->smarty->assign('utm_source', 'email');
                    $this->smarty->assign('utm_medium', 'email');
                    $this->smarty->assign('utm_campaign', 'email_list-users_w_discount|reason-discount_notice|date-'.date('Y-m-d'));
                    $this->smarty->assign('utm_content', 'product');
                    $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                        ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                        ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                        ->assign('UNSUBSCRIBE_LINK',"https://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email={$u->email}&type=email" . utm('email', 'email', 'email_list-users_w_discount|reason-discount_notice|date-'.date('Y-m-d')))
                        ->assign('USER_NAME',       $u->name)
                        ->assign('USER_EMAIL',      $u->email)
                        ->assign('USER_PHONE',      $u->phone_number)
                        ->assign('USER_PHONE_NUMBER', 	$u->phone_number)
                        ->assign('USER_CARD_NUMBER',$u->card_number)->assign('DESIGNER_NAME', '')
                        ->assign('SITE_DESIGNER_NAME',  '')
                        ->assign('ORDER_PRODUCTS',  $this->smarty->fetch('email_products_low.tpl'))
                        ->assign('USER_LOGIN_URL',  $u->phone_number && $u->card_number ? "<br>Или войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$u->phone_number}&card_number={$u->card_number}" . utm('email', 'email', 'email_list-users_w_discount|reason-discount_notice|date-'.date('Y-m-d')) . "\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\" style=\"color:#787878;text-decoration:underline;font-weight:bold\">ссылкой</a><br>" : '')
                        ->send( $u->email )->send( 'mail@lsboutique.ru' );
                    $sended_emails++;
                }
                luser::save_to_crm( $u->original_user_id, 'email', $et->getMergedField('subject'), $et->getMergedBodyHtml());
            }
            $et = new email_template('report');
            $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('REPORT', "Отправлено имейлов с информацией о скидках в вишлистах: {$sended_emails} <br>Отправлено СМС с информацией о скидках в вишлистах: {$sended_sms}")
                ->send("mail@lsboutique.ru");
            echo "sended_emails: $sended_emails sended_sms: $sended_sms";
        }
        die();
    }



    function fix_users() {
        $users      = $this->db->results("SELECT * FROM  `users` WHERE code = '0' AND user_id = original_user_id ORDER BY user_id;");
        if (is_array($users) && count($users) > 0)
        foreach ( $users as $user ) {
            $users_tmp = $this->db->results("SELECT * FROM `users` WHERE original_user_id = '{$user->original_user_id}' AND code <> '0' ORDER BY code;");
            if ( is_array($users_tmp) && count($users_tmp) ) {
                $this->db->query("UPDATE `users` SET code = {$users_tmp[0]->code} WHERE original_user_id = '{$user->original_user_id}';");
                echo "{$user->user_id}) {$user->name} {$user->code} {$user->original_user_id}<br>";
                foreach ( $users_tmp as $user_tmp ) {
                    echo "{$user_tmp->user_id}) {$user_tmp->name} {$user_tmp->code} {$user_tmp->original_user_id}<br>";
                }
                echo '<br><br>';
            }
        }
        die();
    }



    function spam() {
        $user_obj   = new luser();
        $users      = $this->db->results("
            SELECT u.* , g.discount FROM users AS u
              LEFT JOIN groups AS g ON u.group_id = g.group_id
            WHERE email != '' AND phone_number != '' AND `card_number` = '' AND enabled = '1' AND g.group_id = 1 AND user_id = original_user_id AND LENGTH( phone_number ) > 9
        ");
        $users_with_card = '';
        if (is_array($users) && count($users) > 0)
        foreach ( $users as $user ) {
            $user->card_number = $user_obj->generate_card_number();
            $user_obj->update_user( $user->user_id, array('need_welcome_email' => '1', 'card_number' => $user->card_number, 'card_registered' => date('Y-m-d')));
            $et = new email_template('activate_card_number');
            $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('UNSUBSCRIBE_LINK',"https://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email={$user->email}&type=email")
                ->assign('USER_NAME',       $user->name)
                ->assign('USER_EMAIL',      $user->email)
                ->assign('USER_PHONE',      $user->phone_number)
                ->assign('USER_CARD_NUMBER',$user->card_number)
                ->assign('USER_LOGIN_URL',  $user->phone_number && $user->card_number ? "<br>Или войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$user->phone_number}&card_number={$user->card_number}\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\" style=\"color:#787878;text-decoration:underline;font-weight:bold\">ссылкой</a><br>" : '')
                ->assign('USER_DISCOUNT',   ceil($user->discount))
                ->send( $user->email );
            luser::save_to_crm( $user->original_user_id, 'email', $et->getMergedField('subject'), $et->getMergedBodyHtml());


            if($_COOKIE['language']=='eng') $message = "{USERNAME}! Your card number for Luxury Store is №{$card_number}. www.lsboutique.ru 88003332138";
            else $message = "{USERNAME}! Номер Вашей карты в Лакшери Store №{$card_number}. www.lsboutique.ru 88003332138";

            send_sms_to_phone($user->phone_number, str_replace(array('{USERNAME}', '{CARDNUMBER}'), array($user->name, $user->card_number), $message),
                $user->original_user_id, 'lsboutique', true);

            $users_with_card .= $user->name . ' - ' . $user->phone_number . ' - ' . $user->card_number . '<br>';
        }
        if ( $users_with_card ) {
            $et = new email_template('card_number_generated');
            $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('USERS_CARDS',         $users_with_card)
                ->send('order@lsboutique.ru')->send('mail@lsboutique.ru');
        }
        $this->check_novelty( false );
        $this->check_wishlist();
        die();
    }



    /**
     *
     * Подготовка
     *
     */
    function prepare()
    {
        // Разлогинить если передан соответствующий параметр
        if (isset($_GET['action']) && $_GET['action']=='logout') {
            luser::logout(isset($_GET['force']));
            if ( !isset($_GET['nordr']) ) {
                header("Location: /");
                exit();
            }
        }

        $user_obj = new luser(); $user = false;

        if ($this->settings->theme == 'api' && !isset($_GET['net-work'])) {
            if(!empty($_GET['phone']) && strlen($_GET['phone']) > 9 ) {
                $phone_number = substr(str_replace(array(' ','-',')','(','+'), '', $_GET['phone']), -10);
                $card_number       = isset($_GET['card_number']) ? $_GET['card_number'] : 0;
                if ( !empty($card_number) && strlen($card_number) > 4 ) {
                    $user = $this->db->get_row($sql="SELECT user_id FROM `users` WHERE phone_number LIKE '%" . $phone_number . "' AND card_number LIKE '%" . $card_number . "' AND enabled = '1'; ");
                    if ( $user->user_id ) {
                        $return->user = $user_obj->api_user_data($user->user_id);
                        $past = time() - 3600;
                        foreach ( $_COOKIE as $key => $value )
                        {
                            setcookie( $key, '', $past, '/' );
                        }
                    }
                    else{
                        $user = $this->db->get_row("SELECT * FROM `users` WHERE phone_number LIKE '%" . $phone_number . "' AND enabled = '1'; ");
                        if ( $user ) {
                            if($_COOKIE['language'] == 'eng' || $_GET['lang'] == 'eng'){$return->message = "Wrong card number";}
                            else{$return->message = "Неверный номер карты";}
                        }
                    }
                }
                else {
                    $user = $this->db->result("SELECT user_id, original_user_id, card_number, phone_number FROM `users` WHERE phone_number LIKE '%{$phone_number}' AND enabled = '1'; ");
                    if ( $user ) {
                        if($_COOKIE['language'] == 'eng' || $_GET['lang'] == 'eng'){$return->message = "Your card number was sent to you by SMS";}
                        else{$return->message = "Ваш номер карты был отправлен Вам по смс";}
                        $card_number = substr($user->card_number, -5);
                        if($_COOKIE['language'] == 'eng'){$message = "{$card_number} - Your card number in www.lsboutique.ru 88003332138";}
                        else{$message = "{$card_number} - номер Вашей карты в www.lsboutique.ru 88003332138";}
                        $args = array( 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $user->phone_number, 'user_id' => (isset($user->original_user_id) ? $user->original_user_id : 0), 'sms_only' => 1 );
                        Job::push( 'SmsJob', $args, false, 'critical' );
                    }
                }
                if ( empty($user) ) {
                    if($_COOKIE['language'] == 'eng'){$return->message = "Unfortunately, no such authorization data was found. You can always ask for help using the phone +7 495 374 89 34";}
                    else{$return->message = "К сожалению такие авторизационные данные не найдены. Вы всегда можете попросить помощи, воспользовавшись телефоном +7 495 374 89 34.";}
                }
                $return = json_encode($return);
                header('Content-Type: application/json');
                echo $return;
            }
            die;
        }

        if ( !empty($_GET['card_number']) && !empty($_GET['phone']) && strlen($_GET['card_number']) > 4 && strlen($_GET['phone']) > 9 ) {
            $_GET['phone'] = str_replace(array(' ','-',')','(','+'), '', $_GET['phone']);
            $params = array(    'card_number'       => $_GET['card_number'],
                                'phone_number'      => $_GET['phone'],
                                'original_user_id'  => isset($_SESSION['user']) ? $_SESSION['user']->user_id : 0,);
            $user = $user_obj->found($params, false);
            if ( $user->group_id > 1 && strlen($_GET['card_number']) < 10 ) { // Нельзя авторизовать админа по короткому номеру карты
                $user = false;
            }
            if ( $user->group_id == 2 ) {
              $user = false; // Нельзя логинить админа по прямой статической ссылке
              header("Location: /otp_auth/");
              exit();
            }
            if ( $user ) {
                if ( $user->group_id != 9 ) {
                    setcookie('save_card_number',   $_GET['card_number'], time()+60*60*24*365, '/');
                    setcookie('save_phone_number',  $_GET['phone'],       time()+60*60*24*365, '/');
                    setcookie('save_email',         $user->email,         time()+60*60*24*365, '/');
                }
            }
            else {
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = "Unfortunately, no such authorization data was found.<br> You can always ask for help using the phone on the website.";}
                else{$_SESSION['USER_MESSAGE'] = 'К сожалению такие авторизационные данные не найдены.<br>Вы всегда можете попросить помощи, воспользовавшись телефоном на сайте.';}
            }
        }

        if ( empty($_SESSION['user']->user_id) && empty($user->user_id) && !empty($_COOKIE['user_id']) && !empty($_COOKIE['hashcode']) ) {
            $params = array(    'user_id'       => $_COOKIE['user_id'],
                                'password'      => $_COOKIE['hashcode'],);
            $user_cookie = $user_obj->found($params, false);
            if ( !empty($user_cookie->original_user_id) ) {
                $user_obj->login($user_cookie->original_user_id);
            }
        }

        // Логин через соцсети
        if ( empty($user) && isset($_GET['net-work']) ) {
            $opts = array('http' => array(
                'method'  => 'GET',
                'timeout' => 10
            ) );
            $context = stream_context_create($opts);

            switch($_GET['net-work']){
                case 'mailru':          $data = $this->_login_network_mailru($context); break;
                case 'odnoklassniki':   $data = $this->_login_network_ok($context); break;
                case 'vkontakte':       $data = $this->_login_network_vk($context); break;
                case 'facebook':        $data = $this->_login_network_fb($context); break;
                case 'yandex':          $data = $this->_login_network_yandex(); break;
                case 'google':          $data = $this->_login_network_google(); break;
                case 'ulogin':          $data = $this->_login_ulogin(); $_GET['net-work'] = $data->network; break;
                default: return false; break;
            }
            if ($this->settings->theme == 'api') {
              $message = print_r($data,true);
              $this->email('tirjen@gmail.com', "Soc-auth log", $message);
            }

            if ( is_array($data) && isset($data['identity'])) {
                $params = array(
                    'name'          => $data['first_name'] . ' ' . $data['last_name'],
                    'photo'         => $data['photo_big'],
                    'photo_rec'     => $data['photo'],
                    'identity'      => $data['identity'],
                    'network'       => $_GET['net-work'],
                    'email'         => $data['email'],
                    'sex'           => isset($data['sex']) ? 3 - $data['sex'] : 0,
                    'birth_date'    => isset($data['bdate']) ? implode('-', array_reverse(explode('.', $data['bdate']))) : '',
                    'original_user_id'  => isset($_SESSION['user']) ? $_SESSION['user']->original_user_id : 0,
                    'group_id'          => isset($_SESSION['user']) ? $_SESSION['user']->group_id : 0,
                );
                $user = $user_obj->found($params);
                if ($this->settings->theme == 'api') {
                  $return->user = $user_obj->api_user_data($user->user_id);
                  $return = json_encode($return);
                  header('Content-Type: application/json');
                  echo $return;
                  die;
                }
            }
            else{
              if ($this->settings->theme == 'api') {
                  header('Content-Type: application/json');
                  echo $data;
                  die;
                }
            }
        }

        // Логиним если есть кого и уже не залогинен
        if ( empty($_SESSION['user']->user_id) && !empty($user) && $user->original_user_id ) {
            if ( !empty($user->phone_number) && !$_GET['no_welcome_sms'] ) {
              if($_COOKIE['language'] == 'eng'){$msg = $user->name . ', you have successfully logged in at www.lsboutique.ru.';}
              else{$msg = $user->name . ', вы успешно зашли на сайт www.lsboutique.ru.';}
              $args = array( 'sender' => 'lsboutique', 'message_text' => $msg, 'phone_number' => $user->phone_number, 'user_id' => (isset($user->original_user_id) ? $user->original_user_id : 0) );
              Job::push( 'SmsJob', $args, false, 'critical' );
            }
            $user_obj->login($user->original_user_id);
            if ( $_SESSION['user']->need_welcome_email == 0 && !empty($_SESSION['user']->email) ) {
                $et = new email_template('first_auth');
                $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                    ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                    ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                    ->assign('UNSUBSCRIBE_LINK',"https://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email={$_SESSION['user']->email}&type=email")
                    ->assign('USER_NAME',       $_SESSION['user']->name)
                    ->assign('USER_EMAIL',      $_SESSION['user']->email)
                    ->assign('USER_LOGIN_URL',  !empty($_SESSION['user']->phone_number) && !empty($_SESSION['user']->card_number) ? "<br>Войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$_SESSION['user']->phone_number}&card_number={$_SESSION['user']->card_number}\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\" style=\"color:#787878;text-decoration:underline;font-weight:bold\">ссылкой</a><br>" : '')
                    ->assign('USER_DISCOUNT',   ceil($_SESSION['group']->discount))
                    ->assign('USER_PHONE_NUMBER', 	!empty($_SESSION['user']->phone_number) ? $_SESSION['user']->phone_number : '')
                    ->assign('USER_CARD_NUMBER', 	!empty($_SESSION['user']->card_number) ? $_SESSION['user']->card_number : '')
                    ->send( $_SESSION['user']->email );
                luser::save_to_crm( $user->original_user_id, 'email', $et->getMergedField('subject'), $et->getMergedBodyHtml());

                $_SESSION['user']->need_welcome_email = 1;
                $user_obj->update_user( $_SESSION['user']->user_id, array('need_welcome_email' => '1') );
            }
        }

        if (empty($_SESSION['user']->user_id)) {
            header("Location: /");
        }
        elseif (isset($_SESSION['group']) && $_SESSION['group']->group_id == 4) {
            header("Location: /admin/");
        }
        elseif (isset($_SESSION['group']) && $_SESSION['group']->group_id == 9) {
            header("Location: /index.php?module=OfflineSales");
        }
        elseif (isset($_SESSION['group']) && ($_SESSION['group']->group_id == 13 || $_SESSION['group']->group_id == 14)) {
            header("Location: /index.php?module=OfflineSales&storeroom");
        }
        elseif ($this->settings->theme == 'mobile') {
            header("Location: /");
        }
        else {
            if ( isset($_COOKIE['return_to']) ) {
                header("Location: {$_COOKIE['return_to']}");
            }
            else {
                header("Location: /cart/");
            }
        }
        die();
    }



    //Функции для авторизации черех соц сети
    private function _login_network_google(){

        if(!$_GET['code']) return false;

         $params = array(
            'client_id'     => $this->settings->google_login_client_id,
            'client_secret' => $this->settings->google_login_client_secret,
            'redirect_uri'  => 'https://'.$_SERVER['HTTP_HOST'].'/login?net-work=google',
            'grant_type'    => 'authorization_code',
            'code'          => $_GET['code']
        );
        $url = 'https://accounts.google.com/o/oauth2/token';

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url); // url, куда будет отправлен запрос
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, urldecode(http_build_query($params))); // передаём параметры
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        $result = curl_exec($curl);
        curl_close($curl);

        $tokenInfo = @json_decode($result, true);

        if(empty($tokenInfo['access_token'])) return false;

        $params = array(
            'access_token'  => $tokenInfo['access_token']
        );

        $userInfo = @json_decode(@file_get_contents('https://www.googleapis.com/oauth2/v1/userinfo' . '?' . urldecode(http_build_query($params))), true);

        if(empty($userInfo['id'])) return false;

        return array('identity'=>'https://plus.google.com/u/0/'.$userInfo['id'].'/', 'first_name'=>$userInfo['given_name'], 'last_name'=>$userInfo['family_name'], 'email'=>$userInfo['email'], 'photo_big'=>$userInfo['picture'], 'photo'=>$userInfo['picture']);
    }



    private function _login_network_yandex( ) {

        if(!$_GET['code']) return false;

        $params = array(
            'grant_type'    => 'authorization_code',
            'code'          => $_GET['code'],
            'client_id'     => $this->settings->yandex_login_client_id,
            'client_secret' => $this->settings->yandex_login_client_secret
        );

        $url = 'https://oauth.yandex.ru/token';

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url); // url, куда будет отправлен запрос
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, urldecode(http_build_query($params))); // передаём параметры
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        $result = curl_exec($curl);
        curl_close($curl);

        if ($this->settings->theme == 'api') {
          $message = print_r($result,true);
          $this->email('tirjen@gmail.com', "Soc-auth YA1 log", $message);
          $tokenInfo = @json_decode($result, true);
          if(empty($tokenInfo['access_token'])) return $result;
        }
        $tokenInfo = @json_decode($result, true);

        if(empty($tokenInfo['access_token'])) return false;

        $params = array(
            'format'       => 'json',
            'oauth_token'  => $tokenInfo['access_token']
        );

        $userInfo = @json_decode(@file_get_contents('https://login.yandex.ru/info' . '?' . urldecode(http_build_query($params))), true);

        if ($this->settings->theme == 'api') {
          $message = print_r($userInfo,true);
          $this->email('tirjen@gmail.com', "Soc-auth YA2 log", $message);
        }
        if(empty($userInfo['id'])) return false;

        if($userInfo['sex'] == 'male'){$sex = 2;}
        elseif($userInfo['sex'] == 'female'){$sex = 1;}
        else{$sex = '0';}

        return array('identity'=>'https://openid.yandex.ru/'.$userInfo['login'].'/', 'first_name'=>$userInfo['first_name'], 'last_name'=>$userInfo['last_name'], 'email'=>$userInfo['default_email'], 'sex'=>$sex, 'bdate'=>$userInfo['birthday']);
    }

    private function _login_network_fb(&$context) {

        if(!$_GET['code']) return false;

        $params = array(
            'client_id'     => $this->settings->fb_login_client_id,
            'redirect_uri'  => 'https://'.$_SERVER['HTTP_HOST'].'/login?net-work=facebook',
            'client_secret' => $this->settings->fb_login_client_secret,
            'code'          => $_GET['code']
        );

        $url = 'https://graph.facebook.com/oauth/access_token';
        $tokenInfo = null;
        $data = @file_get_contents($url . '?' . http_build_query($params), false, $context);
        @parse_str($data, $tokenInfo);

        if(!isset($tokenInfo['access_token'])) return false;

        $params = array('access_token' => $tokenInfo['access_token']);

        $userInfo = json_decode(file_get_contents('https://graph.facebook.com/me' . '?' . urldecode(http_build_query($params)), false, $context), true);
        if(!isset($userInfo['id'])) return false;
        return array('identity'=>'https://www.facebook.com/profile.php?id='.$userInfo['id'], 'email'=>$userInfo['email'], 'first_name'=>$userInfo['first_name'], 'last_name'=>$userInfo['last_name'], 'photo_big'=>'https://graph.facebook.com/'.$userInfo['id'].'/picture?type=large', 'photo'=>'https://graph.facebook.com/'.$userInfo['id'].'/picture?type=large', 'birthday'=>$userInfo['birthday']);
    }



    private function _login_network_vk( &$context ) {
        if(!$_GET['code']) return false;

        if ($this->settings->theme == 'api') $r_url = 'lsboutique.ru';
        else $r_url = $_SERVER['HTTP_HOST'];

        $params = array(
            'client_id' => $this->settings->vk_login_client_id,
            'client_secret' => $this->settings->vk_login_client_secret,
            'code' => $_GET['code'],
            'redirect_uri' => 'https://'.$r_url.'/login?net-work=vkontakte',
            'v'            => '5.95'
        );

        if ($this->settings->theme == 'api') {
          $curl = curl_init();
          curl_setopt($curl, CURLOPT_URL, 'https://oauth.vk.com/access_token'); // url, куда будет отправлен запрос
          curl_setopt($curl, CURLOPT_POSTFIELDS, urldecode(http_build_query($params))); // передаём параметры
          curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
          curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
          $token = curl_exec($curl);
          curl_close($curl);
          $token = json_decode($token, true);
        }
        else{
          $token = @json_decode(@file_get_contents('https://oauth.vk.com/access_token' . '?' . urldecode(http_build_query($params)), false, $context), true);
        }

        if ($this->settings->theme == 'api') {
          if(!isset($token['access_token'])) return json_encode($token);
        }
        if(!isset($token['access_token'])) return false;

        $params = array(
            'user_ids'     => $token['user_id'],
            'fields'       => 'uid,first_name,last_name,photo_big,photo_50,bdate,sex',
            'access_token' => $token['access_token'],
            'v'            => '5.95'
        );

        if ($this->settings->theme == 'api') {
          $curl = curl_init();
          curl_setopt($curl, CURLOPT_URL, 'https://api.vk.com/method/users.get'); // url, куда будет отправлен запрос
          curl_setopt($curl, CURLOPT_POSTFIELDS, urldecode(http_build_query($params))); // передаём параметры
          curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
          curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
          $result = curl_exec($curl);
          curl_close($curl);
          $userInfo = json_decode($result, true);
        }
        else{
          $userInfo = @json_decode(@file_get_contents('https://api.vk.com/method/users.get' . '?' . urldecode(http_build_query($params)), false, $context), true);
        }


        if ($this->settings->theme == 'api') {
          $message = print_r($userInfo,true);
          $this->email('tirjen@gmail.com', "Soc-auth VK2.2 log", $message);
        }
        if(empty($userInfo['response'][0]['id'])) return false;

        $userInfo = $userInfo['response'][0];

        return array('identity'=>'https://vk.com/id'.$userInfo['id'], 'first_name'=>$userInfo['first_name'], 'last_name'=>$userInfo['last_name'], 'photo_big'=>$userInfo['photo_big'], 'photo'=>$userInfo['photo_50'], 'bdate'=>$userInfo['bdate'], 'sex'=>$userInfo['sex']);
    }



    private function _login_network_ok( &$context ){

        if(!$_GET['code']) return false;

        $params = array(
            'code' => $_GET['code'],
            'redirect_uri' => 'https://'.$_SERVER['HTTP_HOST'].'/login?net-work=odnoklassniki',
            'grant_type' => 'authorization_code',
            'client_id' => $this->settings->ok_login_client_id,
            'client_secret' => $this->settings->ok_login_client_secret
        );

        $url = 'https://api.odnoklassniki.ru/oauth/token.do';

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url); // url, куда будет отправлен запрос
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, urldecode(http_build_query($params))); // передаём параметры
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        $result = curl_exec($curl);
        curl_close($curl);

        $tokenInfo = @json_decode($result, true);

        if(empty($tokenInfo['access_token'])) return false;

        $sign = md5('application_key='.$this->settings->ok_login_public_key.'format=jsonmethod=users.getCurrentUser'.md5($tokenInfo['access_token'].$this->settings->ok_login_client_secret));

        $params = array(
            'method'          => 'users.getCurrentUser',
            'access_token'    => $tokenInfo['access_token'],
            'application_key' => $this->settings->ok_login_public_key,
            'format'          => 'json',
            'sig'             => $sign
        );

        $userInfo = @json_decode(@file_get_contents('https://api.odnoklassniki.ru/fb.do' . '?' . urldecode(http_build_query($params)), false, $context), true);

        if(empty($userInfo['uid'])) return false;

        return array('identity'=>'https://odnoklassniki.ru/'.$userInfo['uid'], 'first_name'=>$userInfo['first_name'], 'last_name'=>$userInfo['last_name'], 'photo_big'=>$userInfo['pic_2'], 'photo'=>$userInfo['pic_1'], 'bdate'=>$userInfo['birthday']);
    }



    private function _login_network_mailru( &$context ) {

        if ($this->settings->theme != 'api') {
          if(!$_GET['code']) return false;
          $params = array(
              'client_id'     => $this->settings->mail_login_client_id,
              'client_secret' => $this->settings->mail_login_client_secret,
              'grant_type'    => 'authorization_code',
              'code'          => $_GET['code'],
              'redirect_uri'  => 'https://'.$_SERVER['HTTP_HOST'].'/login?net-work=mailru'
          );

          $url = 'https://connect.mail.ru/oauth/token';

          $curl = curl_init();
          curl_setopt($curl, CURLOPT_URL, $url);
          curl_setopt($curl, CURLOPT_POST, 1);
          curl_setopt($curl, CURLOPT_POSTFIELDS, urldecode(http_build_query($params)));
          curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
          curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
          $result = curl_exec($curl);
          curl_close($curl);

          $tokenInfo = json_decode($result, true);

          if(empty($tokenInfo['access_token'])) return false;

          $sign = md5('app_id='.$client_id.'method=users.getInfosecure=1session_key='.$tokenInfo['access_token'].$client_secret);

          $params = array(
              'method'       => 'users.getInfo',
              'secure'       => '1',
              'app_id'       => $client_id,
              'session_key'  => $tokenInfo['access_token'],
              'sig'          => $sign
          );

          $userInfo = @json_decode(@file_get_contents('https://www.appsmail.ru/platform/api' . '?' . urldecode(http_build_query($params)), false, $context), true);

          if(empty($userInfo[0]['link'])) return false;

          $userInfo = $userInfo[0];
        }
        else {
          $userInfo = $_GET['userInfo'];
          $this->email('tirjen@gmail.com', "Soc-auth MR1 log", $userInfo);
        }

        return array('identity'=>$userInfo['link'], 'first_name'=>$userInfo['first_name'], 'last_name'=>$userInfo['last_name'], 'photo_big'=>$userInfo['pic'], 'photo'=>$userInfo['pic_50'], 'bdate'=>$userInfo['birthday'], 'email'=>$userInfo['email'], 'sex'=>$userInfo['sex']);
    }



    private function _login_ulogin( &$context ){
        if(!$_POST['token']) return false;

        $userInfo = json_decode(file_get_contents('https://ulogin.ru/token.php?token=' . $_POST['token'] . '&host=' . $_SERVER['HTTP_HOST'], false, $context), true);
        if(!isset($userInfo['identity'])) return false;

        return array('identity'=> $userInfo['profile'], 'email'=>$userInfo['email'], 'first_name'=>$userInfo['first_name'], 'last_name'=>$userInfo['last_name'], 'photo_big'=>$userInfo['photo_big'], 'photo'=>$userInfo['photo'], 'birthday'=>$userInfo['bdate'], 'sex'=>$userInfo['sex'], 'network'=>$userInfo['network']);
    }
    //Функции для авторизации черех соц сети (The End)



    function fetch() {
        header("Location: /");
        exit();
    }
}
