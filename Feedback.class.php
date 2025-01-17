<?PHP
require_once('Widget.class.php');
include_once "models/email_template.php";

class Feedback extends Widget
{
    // Шаблоны для проверки корректности вводимых данных
    var $pattern_number = '/^([0-9]+){1,12}$/iu';
    var $pattern_email = '/^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,6})$/i';

    function Feedback(&$parent) {
        Widget::Widget($parent);
    }



    function fetch() {
        if ( isset($_GET['generate_cards']) ) {
            for ( $i = 0; $i<2000; $i++ ) {
                $number = luser::generate_card_number();
                $this->db->query("INSERT INTO `cards` (`number`, `type`, `date`) VALUES ('{$number}', '3', CURRENT_TIMESTAMP);");
            }
        }

        if ( isset($_GET['employment']) && !isset($_GET['one_click']) ) {
            $this->body = $this->smarty->fetch('employment.tpl');
            echo $this->body;
            exit();
        }

        // Обработка анкеты соискателя рабочего места в ИП Жехарева
        if ( isset($_POST['employment']) && !isset($_GET['one_click']) ) {
            if (empty($_POST["g-recaptcha-response"])) {
                die('Ошибка ввода данных.');
            }
            if (!empty($_POST["g-recaptcha-response"])) {
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
                    die('Ошибка ввода данных.');
                }
            }
            // Парсим форму из json
            $employment = json_decode($_POST['employment'], true);
            unset($employment["g-recaptcha-response"]);
            $keys = implode(',', array_keys($employment));
            $values = array_values($employment);
            foreach ($values as &$v) {
                $v = "'{$v}'";
            }
            unset($v);
            $values = implode(',', $values);
            $query = "INSERT INTO employment ({$keys}) VALUES ({$values})";
            $this->db->query($query);
            $employment_id = $this->db->insert_id();

            // Загрузка фотографии
            if (isset($_FILES['photo']) && !empty($_FILES['photo']['tmp_name'])) {
                $path_parts = pathinfo($_FILES['photo']['name']);
                $path_parts['extension'] = strtolower($path_parts['extension']);
                if ( in_array($path_parts['extension'], array('jpg', 'jpeg', 'png')) ) {
                    $uploadfile = "employment_photo_". time() . "." . $path_parts['extension'];

                    $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/avatars/' . $uploadfile;

                    if (!move_uploaded_file($_FILES['photo']['tmp_name'], $full_path)) {
                        $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
                    }
                    else {
                        @chmod($full_path, 0644);
                        $this->db->query($sql = "UPDATE employment SET photo='{$uploadfile}' WHERE id = '{$employment_id}'");
                    }
                }
            }

            if ( !empty($uploadfile) ) {
                $employment['photo'] = "https://lsboutique.ru/files/avatars/{$uploadfile}";
            }
            else {
                $employment['photo'] = "";
            }

            $email_body = "Анкета соискателя: <br>
Имя: {$employment['name']}<br>
Телефон: {$employment['phone']}<br>
Специальность: {$employment['position']}<br>
Зарплата: {$employment['salary']}<br>
Возраст: {$employment['age']}<br>
Последнее место работы: {$employment['last_job']}<br>
Образование: {$employment['education']}<br>
Желаемый график работы: {$employment['hours']}<br>
Семейное положение: {$employment['family']}<br>
Место постоянного проживания: {$employment['home_city']}<br>
Водительское удостоверение: {$employment['drivers_license']}<br>
Дети: {$employment['children']}<br>
Гражданство: {$employment['citizenship']}<br>
Иностранные языки: {$employment['languages']}<br>
Дополнительные навыки, курсы: {$employment['skills']}<br>
Текст резюме: {$employment['resume']}<br>
Фотография: {$employment['photo']}";
            $this->email('mail@lsboutique.ru, work@lsboutique.ru', "Заполнена анкета на поиск работы", $email_body, 'From: Luxury Store <order@lsboutique.ru>');

            $this->smarty->assign('employment', $employment);
            $this->body = $this->smarty->fetch('employment_complete.tpl');
            echo $this->body;
            exit();
        }


        // Обработка selfie
        if ( false ) {
            $selfie = $_POST;
            // Загрузка фотографии
            if (isset($_FILES['select_file']) && !empty($_FILES['select_file']['tmp_name'])) {
                $path_parts = pathinfo($_FILES['select_file']['name']);
                $path_parts['extension'] = strtolower($path_parts['extension']);
                if ( in_array($path_parts['extension'], array('jpg', 'jpeg', 'png')) ) {
                    $uploadfile = "selfie_photo_". time() . "." . $path_parts['extension'];

                    $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/avatars/' . $uploadfile;

                    if (!move_uploaded_file($_FILES['select_file']['tmp_name'], $full_path)) {
                        $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
                    }
                    else {
                        @chmod($full_path, 0644);
                    }
                }
            }

            $email_body = "Анкета selfie: <br>
Имя: {$selfie['name']}<br>
Фамилия: {$selfie['surname']}<br>
Телефон: {$selfie['phone_number']}<br>
Email: {$selfie['email']}<br>
Фотография: https://lsboutique.ru/files/avatars/{$uploadfile}";
            $this->email('mail@lsboutique.ru', "Заполнена анкета selfie", $email_body, 'From: Luxury Store <order@lsboutique.ru>');

            header("Location: http://lselfie.ru/completed.html");
            die();
        }

        if ( isset( $_GET['one_click'] ) && (strlen($_POST['phone_number']) > 8 || ($this->settings->theme == 'api' && strlen($_GET['phone']) > 8 )) ) {
            if (isset($_GET['phone'])){$_GET['phone'] = str_replace(array(' ','-',')','(','+'), '', $_GET['phone']);}
            $phone_number = $_POST['phone_number'] ? $_POST['phone_number'] : $_GET['phone'];
            $name =         $_POST['name']         ? $_POST['name']         : $_GET['name'];
            $from =         $_POST['from_page']    ? $_POST['from_page']    : "api";
            $product_id =   $_POST['product_id']   ? $_POST['product_id']   : $_GET['product'];

            if ( $_POST['phone_number'] && strlen($_POST['phone_number']) < 11 ) {
                $phone_number = '8' . $_POST['phone_number'];
            }
            if ( $_GET['phone'] && strlen($_GET['phone']) < 11 ) {
                $phone_number = '8' . $_GET['phone'];
            }
            $user = new stdClass();
            if ( strlen($phone_number) > 10 ) {
                $user = $this->db->get_row($sql = "SELECT * FROM `users` WHERE `phone_number` LIKE '%" . $this->db->escape(substr($phone_number, -10)) . "'; ");
            }

            $plink = $_SERVER['HTTP_REFERER'];
            if ( $product_id ) {
                $query      = sql_placeholder("SELECT * FROM products WHERE product_id = ?", $product_id);
                $product    = $this->db->result($query);
                $plink      = "https://{$_SERVER['HTTP_HOST']}/products/{$product->url}/";
                $pimg       = "https://{$_SERVER['HTTP_HOST']}/reimg/files/products/85x/{$product->large_image}";
                if (strpos($_POST['from_page'],'mobile') !== false) {
                    $type = "Заявка на покупку в 1 клик с мобильной версии сайта";
                }
                if (strpos($_POST['from_page'],'application') !== false) {
                    $type = "Заявка на покупку в 1 клик из приложения";
                }
                if ($this->settings->theme == 'api') {
                    $type = "Заявка на покупку в 1 клик из нового api";
                }
                else {
                    $type = "Заявка на покупку в 1 клик с полной версии сайта";
                }
            }
            else {
                $type = "Заявка на консультацию по сайту";
            }

            $email = '';
            if ($_POST['field_email']) {
                $email = $_POST['field_email'];
            }
            $ga_client_id = '';
            $manager = 0;
            if ( !empty($_SESSION['user']) && $_SESSION['user']->group_id == 5 ) {//если заказ делает менеджер за клиента
                $manager = $_SESSION['user']->original_user_id;
            }
            if ( $manager == 0 ) {$ga_client_id = $this->gaParseCookie();}
            $query = sql_placeholder("INSERT INTO `one_click` (name, phone, product_id, email, enabled, date, `from`, cr_manager, ga_client_id)
                                        VALUES (?, ?, ?, ?, 1, now(), ?, ?, ?)", $name, $phone_number, $product_id, $email, $from, $manager, $ga_client_id);
            $this->db->query($query);
            $order_id = $this->db->insert_id();

            if ( $order_id && empty($_SESSION['user']->group_id) || $_SESSION['user']->group_id == 1 ) {
                $purchase_data = array(
                    'item_id'       => $product->product_id,
                    'price'         => $product->price,
                    'is_available'  => ($product->size ? 1 : 0),
                    'category'      => $product->category_id,
                );
                $purchase_data['model']     = $product->model;
                $purchase_data['order_id']  = 1000000+$order_id;
                $_SESSION['1click_purchase_data'] = $purchase_data; // Для отслеживания в метрике и GA
            }
            if ( $order_id && !$admin && orders::mixmarket_enabled($this->config) ) { // Фиксируем что заказ из миксмаркета
                $this->db->query(sql_placeholder("UPDATE `one_click` SET from_mixmarket=1 WHERE id=?", $order_id));
            }
            if ( $order_id ) { // Проверяем откуда заказ
                if ($this->settings->theme == 'api') {
                    $platform = "iOS";
                    if (isset($_GET['platform']) && !empty($_GET['platform'])) {
                        $platform = $_GET['platform'];
                    }
                    if (isset($_GET['token']) && !empty($_GET['token'])) {
                        $token = $this->db->get_row("SELECT * FROM `app_sessions` WHERE push_token = '{$_GET['token']}'; ");
                        $platform = $token->platform;
                    }
                }
                $order_source = 1;
                if ( $manager != 0 ) {
                    $order_source = 2;
                }
                elseif ( $platform == "Android" ) {
                    $order_source = 3;
                }
                elseif ( $platform == "iOS" ) {
                    $order_source = 4;
                }
                $this->db->query(sql_placeholder("UPDATE `one_click` SET order_source=? WHERE id=?", $order_source,$order_id));

                $ref_source  = $_POST['referrer'];
                if(!empty($ref_source)){
                    $this->db->query("UPDATE one_click SET ref_source = '{$ref_source}' WHERE id = '{$order_id}'");
                }
            }

            $manager = '.';
            if(!empty($user)){
                $manager = $this->db->result("SELECT name, slack_name FROM `users` WHERE `user_id` = '{$user->p_manager_id}'");
                $manager = !empty($manager) ? ", персональный менеджер {$manager->name} <@{$manager->slack_name}>" :  ", нет персонального менеджера";
            }

            if (empty($user) || $user->group_id == 1) {
              // Отправляем в слак
              $message = "Заказ в один клик, пользователь {$name}, телефон {$phone_number}, товар <{$plink}|{$product->model}>{$manager}";
              $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "one_click_orders" );
              Job::push('SlackJob', $args);

              $message = "Заказ в один клик! Оставлена заявка #{$order_id} на товар #<{$plink}|{$product->model}> пользователем {$name}, телефон {$phone_number}";
              $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "all_orders" );
              Job::push('SlackJob', $args);


              $msg = (!empty($name) ? "{$name}, " : "") . ' вы заказали '.$product->model.' ваш заказ получен и очень важен для нас. Перезвоним в ближайшее время. Ваш www.lsboutique.ru.';
              $args = array( 'sender' => 'lsboutique', 'message_text' => $msg, 'phone_number' => $phone_number, 'user_id' => (isset($user->original_user_id) ? $user->original_user_id : 0) );
              Job::push( 'SmsJob', $args, false, 'critical' );
            }

            if (isset($_POST['phone_number'])){
                setcookie('SAVED_PHONE_NUMBER', $_POST['phone_number'], time()+60*60*24*365, '/');
                setcookie('SAVED_USER_NAME', $_POST['name'], time()+60*60*24*365, '/');
                setcookie('SAVED_USER_EMAIL', $_POST['field_email'], time()+60*60*24*365, '/');
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = ($_POST['name'] ? $_POST['name'] .', ' : '') . 'your order has been received.<br>Our manager will contact you shortly.';}
                else{$_SESSION['USER_MESSAGE'] = ($_POST['name'] ? $_POST['name'] .', ' : '') . 'ваш заказ получен.<br>Наш менеджер свяжется с вами в ближайшее время.';}
            }

            if ( !empty($_SESSION['1click_purchase_data']) ) {
                $this->smarty->assign('purchase_data', $_SESSION['1click_purchase_data']);
            }

            if ($this->settings->theme == "mobile") {
                $this->smarty->assign('ordering', true);
                $oc_ordered = $this->db->get_row($sql = "SELECT * FROM `one_click` WHERE `id` = {$order_id}; ");
                $oc_ordered_product = $this->db->get_row($sql = "SELECT products.*, items.barcode, brands.name as brand_name, categories.enabled as cat_enabled
                                                                        FROM products
                                                                        LEFT JOIN brands ON products.brand_id = brands.brand_id
                                                                        LEFT JOIN categories ON products.category_id = categories.category_id
                                                                        LEFT JOIN items ON products.product_id = items.product_id
                                                                        WHERE products.product_id = {$oc_ordered->product_id}
                                                                        GROUP BY products.product_id; ");
                $this->smarty->assign('oc_ordered', $oc_ordered);
                $this->smarty->assign('oc_ordered_product', $oc_ordered_product);
                $this->body = $this->smarty->fetch('accepted.tpl');
                unset($_SESSION['1click_purchase_data']);
                return $this->body;
            }
            if ($this->settings->theme == "application") {
                $this->smarty->assign('back', $_SERVER["HTTP_REFERER"]);
                $this->body = $this->smarty->fetch('accepted.tpl');
                unset($_SESSION['1click_purchase_data']);
                return $this->body;
            }

            $back_url = '/products/'.$product_id.'/';

            $location = !empty($_SESSION['LAST_CATALOG_URL']) ? $_SESSION['LAST_CATALOG_URL'] : $back_url;
            if ($this->settings->theme == 'api') {
                $order = $this->db->get_row($sql = "SELECT * FROM `one_click` WHERE `id` = {$order_id}; ");
                header('Content-Type: application/json');
                if (!empty($order)){
                    echo json_encode('ok');
                }
                else{
                    echo json_encode('fail');
                }
                die();
            }
            $user_filter = !empty($user->original_user_id) ? "OR user_id = '{$user->original_user_id}'" : "";
            $us = $this->db->result("SELECT order_id FROM `orders` WHERE `phone` LIKE '%" . $this->db->escape(substr($phone_number, -10)) . "' {$user_filter} LIMIT 1")->order_id;
            if(empty($us)){$_SESSION['NEW_USER_ORDER'] = true;}
            $_SESSION['one_click_ordered'] = $order_id;
            header("Location: {$location}");
            die();
        }



        if ( isset( $_GET['helpform'] ) && (strlen($_POST['phone_number']) > 8  || ($this->settings->theme == 'api' && strlen($_GET['phone']) > 8 ))) {
            if (isset($_GET['phone'])){$_GET['phone'] = str_replace(array(' ','-',')','(','+'), '', $_GET['phone']);}
            $phone_number = $_POST['phone_number'] ? $_POST['phone_number'] : $_GET['phone'];
            $name =         $_POST['name']         ? $_POST['name']         : $_GET['name'];
            $from =         $_POST['from_page']    ? $_POST['from_page']    : "help_from_api";
            $product_id =   $_POST['product_id']   ? $_POST['product_id']   : $_GET['product_id'];

            if ( strlen($phone_number) < 11 ) {
                $phone_number = '8' . $phone_number;
            }
            $user = new stdClass();
            if ( strlen($phone_number) > 10 ) {
                $user = $this->db->get_row($sql = "SELECT * FROM `users` WHERE `phone_number` LIKE '%" . $this->db->escape(substr($_POST['phone_number'], -10)) . "'; ");
            }

            $plink = $_SERVER['HTTP_REFERER'];
            if($this->settings->theme == 'api'){
                $plink = "https://lsboutique.ru/products/{$product_id}/";
            }
            if ( $product_id ) {
                $query = sql_placeholder("SELECT * FROM products WHERE product_id = ?", $product_id);
                $product = $this->db->result($query);
                $plink = "https://{$_SERVER['HTTP_HOST']}/products/{$product->url}/";
                if (strpos($_POST['from_page'],'mobile') !== false) {
                    $type = "Заявка на помощь с мобильной версии сайта";
                }
                elseif ($_GET['product_id']) {
                    $type = "Заявка на помощь с мобильного приложения";
                }
                else {
                    $type = "Заявка на помощь с полной версии сайта";
                }
            }
            else {
                $type = "Заявка на консультацию по сайту";
            }

            $query = sql_placeholder("INSERT INTO `one_click` (name, phone, product_id, enabled, date, `from`)
                                    values(?, ?, ?, 1, now(), ?)",
                                    $name, $phone_number, $product_id, $from);
            $this->db->query($query);
            $order_id = $this->db->insert_id();

            // Отправляем в слак
            $message = "Заявка на помощь, пользователь {$name}, телефон {$phone_number}, товар <{$plink}|{$product->model}>";
            $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "one_click_orders" );
            Job::push('SlackJob', $args);

            if($_COOKIE['language'] == 'eng'){$m = ($name) . ' your request has been received. Will call you back shortly. Your www.lsboutique.ru.';}
            else{$m = ($name) . ' ваша заявка получена. Вам перезвонят в ближайшее время. Ваш www.lsboutique.ru.';}
            send_sms_to_phone( $phone_number, $m, (isset($user->original_user_id) ? $user->original_user_id : 0) );

            $et = new email_template('helpform');
            $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('PRODUCT_LINK',    $plink)
                ->assign('TYPE',    $type)
                ->assign('USER_NAME',       $name)
                ->assign('USER_PHONE',      $phone_number)
                ->send('mail@lsboutique.ru');

            if($this->settings->theme != 'api'){
                setcookie('SAVED_PHONE_NUMBER', $_POST['phone_number'], time()+60*60*24*365, '/');
                setcookie('SAVED_USER_NAME',    $_POST['name'], time()+60*60*24*365, '/');
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Your request has been received.<br> We will call you back and be sure to help.';}
                else{$_SESSION['USER_MESSAGE'] = 'Ваша просьба уже получена.<br>Мы вам перезвоним и обязательно поможем.';}

                if ($this->settings->theme == "mobile") {
                    $this->body = $this->smarty->fetch('accepted.tpl');
                    return $this->body;
                }

                $back_url = '/products/'.$_POST['product_id'];
                header("Location: {$back_url}");
            }
            else{
                $order = $this->db->get_row($sql = "SELECT * FROM `one_click` WHERE `id` = {$order_id}; ");
                header('Content-Type: application/json');
                if (!empty($order)){
                    if($_COOKIE['language'] == 'eng'){$return->message = 'Your request has been received. We will call you back and be sure to help.';}
                    else{$return->message = 'Ваша просьба уже получена. Мы вам перезвоним и обязательно поможем.';}
                }
                else{
                    if($_COOKIE['language'] == 'eng'){$return->message = 'Something went wrong. Please try again';}
                    else{$return->message = 'Что-то пошло не так. Пожалуйста, попробуйте еще раз';}
                }

                echo json_encode($return);
            }

            die();
        }



        if ( isset($_POST['brand_id']) && !empty($_POST['brand_id']) ) {
            $params = array(
                'name'              => empty($_POST['name']) ? 'господин' : @$_POST['name'],
                'phone_number'      => @$_POST['phone_number'],
                'email'             => @$_POST['email'],
                'original_user_id'  => isset($_SESSION['user']) ? $_SESSION['user']->user_id : 0,
            );
            $user_obj = new luser();
            $user = $user_obj->found($params);
            $manager = $this->db->result("SELECT slack_name FROM users WHERE user_id = {$user->user_id}")->slack_name;
            $manager_m = !empty($manager) ? "<@{$manager_m}>" : '';
//подписка на шубизм
            if ($_POST['brand_id'] == 'fur_subscribe') {
                $shop_id = 3;
                $user_obj->subscribe_to_shop($user->user_id, $shop_id);

                // Отправляем в слак
                $message = "{$manager_m} Пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user->user_id}|{$user->name}>, подписался на обновления от podiumVIP!";
                $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "brands_subscribtions" );
                Job::push('SlackJob', $args);

                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Your subscription request has already been received.<br> You will be the first to receive updates.';}
                else{$_SESSION['USER_MESSAGE'] = 'Ваша заявка на подписку уже получена.<br>Вы первыми будете получать информацию об обновлениях.';}

                header("Location: /");
                die('');
            }
//или подписка на бренд
            else {
                $user_obj->subscribe_to_brand($user->user_id, $_POST['brand_id']);
                $brand = $this->db->result("SELECT * FROM brands WHERE brand_id = '" . (int)$_POST['brand_id'] . "'");

                // Отправляем в слак
                $message = "{$manager_m} Пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user->user_id}|{$user->name}>, подписался на обновления бренда {$brand->name}!";
                $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "brands_subscribtions" );
                Job::push('SlackJob', $args);

                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Your request for a brand subscription has been received.<br>You will be the first to receive information about updates.';}
                else{$_SESSION['USER_MESSAGE'] = 'Ваша заявка на подписку о бренде уже получена.<br>Вы первыми будете получать информацию об обновлениях.';}

                $back_url = '/brands/'.$brand->url;

                header("Location: {$back_url}");
                die('');
            }
        }


        if ( isset( $_GET['crime_teilor_tickets'] )) {
            $email  = $_POST['email'];

            // Отправляем в слак
            $message = "Пользователь с емайлом {$email} подписался на фильм 'Преступление портного'";
            $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "general" );
            Job::push('SlackJob', $args);
            die('');
        }

        if(isset($_POST['email']) || isset($_POST['number']) || isset($POST['phone_number'])) {
            // Сюда идёт POST со страницы http://ru.lsboutique.ru/doctxt/atele/
            if (isset($POST['phone_number'])) {
                $number     = $_POST['phone_number'];
            }
            else {
                $number     = $_POST['number'];
            }
            $email      = $_POST['email'];
            $name       = empty($_POST['name']) ? 'господин' : $_POST['name'];
            $question   = $_POST['question'];

            // Проверка возможных ошибок
            $error = null;


            // Проверка на правильность заполнения формы
            // if(!preg_match($this->pattern_number, $number) && !preg_match($this->pattern_email, $email))
            //  $error = "Пожалуйста, введите ваши данные";

            // Приберем сохраненную капчу, иначе можно отключить загрузку рисунков и постить старую
            //unset($_SESSION["captcha_code"]);

            // Возврящаем в шаблон введенные данные
            $this->smarty->assign('error',   $error);
            $this->smarty->assign('number',  $number);
            $this->smarty->assign('email',   $email);
            $this->smarty->assign('name',    $name);
            $this->smarty->assign('message', $message);
            $this->smarty->assign('ip', $_SERVER['REMOTE_ADDR']);

            if (!empty($error)) {
                // Если возникла ошибка, выводим заново форму регистрации
                $this->smarty->assign('error', $error);
                if ($_POST['is_question'] == 'true') {
                  $this->body = $this->smarty->fetch('feedback_question.tpl');
                }
                else {
                  $this->body = $this->smarty->fetch('feedback.tpl');
                }
            }
            else {
                //Если все хорошо, добавляем вопрос в базу
                if ($_POST['is_question'] == 'true') {
                  $query = sql_placeholder("INSERT INTO feedback
                                    (name, ip, email, message, date)
                                    values(?, ?, ?, ?, now())",
                                    $name, $number, $email, $question);
        }
                else {
                  $query = sql_placeholder("INSERT INTO feedback
                                    (email, name, message, ip, date)
                                    values(?, ?, ?, ?, now())",
                                    $email, $number, $name, $_SERVER['REMOTE_ADDR']);
        }
                $this->db->query($query);

                $this->smarty->assign('accepted', true);

                // Письмо администратору
                $message = $this->smarty->fetch('../../../admin/templates/email_feedback.tpl');
                if ($_POST['is_question'] == 'true') {
                  $this->email('mail@lsboutique.ru', 'Вопрос от посетителя', 'Вопрос: '.$question.'    Номер: '.$number.'    E-mail: '.$email);
                  if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Your question received.<br> You will be answered soon.';}
                  else{$_SESSION['USER_MESSAGE'] = 'Ваш вопрос получен.<br>Вам ответят в ближайшее время.';}
                }
                if ($name == 'Su misura order (zakaz poshiva)') {
                    $s = 'Заявка на индивидуальный пошив';
                    $m = 'Посетитель сайта с номером телефона '.$number.' оставил заявку на индивидуальный пошив одежды.';
                    $this->email('mail@lsboutique.ru', $s, $m);
                    $this->email('zhekharev@lsboutique.ru', $s, $m);
                    $this->email('volper@lsboutique.ru', $s, $m);
                    if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Your request for a brand subscription has been received.<br>You will be the first to receive information about updates.';}
                    else{$_SESSION['USER_MESSAGE'] = 'Ваша заявка на подписку о бренде уже получена.<br>Вы первыми будете получать информацию об обновлениях.';}
                }
            }
            if ( !empty($_SERVER["HTTP_REFERER"]) ) {
                if ( strpos($_SERVER["HTTP_REFERER"], 'ru.lsboutique.ru') ) {
                    $_SERVER["HTTP_REFERER"] .= '?sended';
                }
                header("Location: {$_SERVER["HTTP_REFERER"]}");
                die();
            }
        }
        else {
          if(isset($this->user))
          {
            $this->smarty->assign('name', isset($this->user->name)?$this->user->name:'');
            $this->smarty->assign('number', isset($this->user->number)?$this->user->number:'');
            $this->smarty->assign('email', isset($this->user->email)?$this->user->email:'');
          }

        }

        // Если ничего не постили, просто выводим форму регистрации
        $this->smarty->assign('name',     @$_GET['name']);
        $this->smarty->assign('brand_id', @$_GET['brand_id']);
        if ($_GET['name'] == 'orderForm') {
            $this->body = $this->smarty->fetch('order_form.tpl');
        }
        elseif ($_GET['name'] == 'question') {
          $this->body = $this->smarty->fetch('feedback_question.tpl');
        }
        else {
            $query = "SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;";
            $this->db->query($query);
            $delivery_cities_main = $this->db->results();
            $this->smarty->assign('delivery_cities_main', $delivery_cities_main);

            $query = "SELECT * FROM delivery_cities WHERE city_owner_id = '0' ORDER BY city_name;";
            $this->db->query($query);
            $delivery_cities = $this->db->results();
            $this->smarty->assign('delivery_cities', $delivery_cities);
            $this->body = $this->smarty->fetch('feedback.tpl');
        }
        if (isset($_GET['clear'])) {
            echo $this->body;die();
        }

        return $this->body;
     }

}
