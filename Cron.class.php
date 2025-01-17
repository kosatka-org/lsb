<?PHP
require_once('Widget.class.php');
require_once('Order.class.php');
require_once('models/order.php');
require_once('models/email_template.php');

require_once('models/copywriters.php');


class Cron extends Widget
{
    var $title = 'Крон-задачи';

    public function __construct(&$parent) {
        Widget::Widget($parent);
    }



    // Роутинг крона
    public function fetch() {
        if (isset($_GET['commit'])) {
            return $this->commit();
        }
        if (isset($_GET['test_email'])) {
            return $this->test_email();
        }
        if (isset($_GET['daily_email'])) {
            return $this->daily_email();
        }
        if (isset($_GET['copywriter_tasks'])) {
            return $this->copywriter_tasks();
        }
        if (isset($_GET['rfi_payment_confirm'])) {
            return $this->rfi_payment_confirm();
        }
        if (isset($_GET['sber_payment_confirm'])) {
            return $this->sber_payment_confirm();
        }
        if (isset($_GET['api_tests'])) {
            return $this->api_tests();
        }
        if (isset($_GET['daily_report'])) {
            return $this->daily_report();
        }
        if (isset($_GET['new_collection'])) {
            return $this->new_collection();
        }
        if (isset($_GET['daily_rep_analitics'])) {
            return $this->daily_rep_analitics();
        }
        if (isset($_GET['new_supply_spam'])) {
            return $this->new_supply_spam();
        }
        if (isset($_GET['services_check'])) {
            return $this->services_check();
        }
        if (isset($_GET['managers_check'])) {
            return $this->managers_check();
        }
        if (isset($_GET['brand_report'])) {
            return $this->brand_report();
        }
        if (isset($_GET['confirm_report'])) {
            return $this->confirm_report();
        }
        if (isset($_GET['exchange_rates_update'])) {
            return $this->exchange_rates_update();
        }
        if (isset($_GET['cities_tolal'])) {
            return $this->cities_tolal();
        }
        if (isset($_GET['mass_logout'])) {
            return $this->mass_logout();
        }
        if (isset($_GET['cleanup'])) {
            return $this->cleanup();
        }
        if (isset($_GET['sales_check'])) {
            return $this->sales_check();
        }
        if (isset($_GET['check_movements'])) {
            return $this->check_movements();
        }
        if (isset($_GET['m4u'])) {
            return $this->measuring4users();
        }
        if (isset($_GET['google_ad_stream'])) {
            return $this->google_ad_stream();
        }
    }



    // Скрипт создающий задачи копирайтерам по сущностям с пустыми описаниями
    public function commit() {
        $json            = file_get_contents('php://input');
        $data            = json_decode($json);
        $result          = "Comment: {$data->message}\n";
        $result .= "Author: {$data->author}, Revision: {$data->revision}\n";
        $result .= "Review: {$data->revision_web}\n";
        if (is_array($data->added) && count($data->added)) {
            $result .= "Added: " . var_export($data->added, true) . "\n";
        }
        if (is_array($data->removed) && count($data->removed)) {
            $result .= "Removed: " . var_export($data->removed, true) . "\n";
        }
        if (is_array($data->replaced) && count($data->replaced)) {
            $result .= "Replaced: " . var_export($data->replaced, true) . "\n";
        }
        $result = str_replace(array('array', ')', '('), '', $result);

        if ( $data->author != 'shesternin' ) {
            mail('shesternin@gmail.com', "SVN Co #{$data->revision} - {$data->author}", $result);
        }
        die('ok');
    }



    // Скрипт создающий задачи копирайтерам по сущностям с пустыми описаниями
    public function copywriter_tasks( $die = true ) {
        $copywriter = new copywriters();
        // Создание новых задач
        $types = array('city' => 3, 'special' => 0, 'brand-category' => 2);
        foreach ($types as $type => $priority) {
            echo '<br><br>' . $type . '<br><br>';
            $entities = $copywriter->get_copywriter_task_form($type, true, true);
            foreach ( $entities['docs'] as $entity ) {
                foreach ( $entities['fields'] as $field => $name ) {
                    if ( empty($entity->$field) ) {
                        $copywriter->add_copywriter_task(array('doc_type'=>$type, 'doc_id'=>$entity->id, 'field'=>$field, 'task_comment'=>'Автоматически созданная задача ' . date('Y-m-d'), 'copywriter_id'=>0, 'priority'=>$priority));
                    }
                }
            }
        }

        // Оповещения о новых задачах
        $new_tasks = $copywriter->count_copywriter_tasks(array('status' => 'new'));
        echo 'Новых задач: ' . $new_tasks . '<br>';

        $need_check_tasks = $copywriter->count_copywriter_tasks(array('status' => 'need_check'));
        echo 'Требуют проверки: ' . $need_check_tasks . '<br>';
        // Оповещение о задачах на проверку

        $date_check = date('Y-m-d', time()-60*60*24);
        $accepted_tasks = $copywriter->count_copywriter_tasks(array('status' => 'accepted', 'date_check' => $date_check));
        echo "Проверено за {$date_check}: {$accepted_tasks}.<br>";
        // Оповещения о принятых задачах

        if ( $new_tasks>0 ) { // Предупредим копирайтеров
            $users = $this->db->results("SELECT * FROM users WHERE email != '' AND enabled = '1' AND group_id = 7"); // Возьмем всех копирайтеров
            foreach ( $users as $user ) {
                $et = new email_template('report');
                $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                    ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                    ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                    ->assign('USER_NAME', $user->name)
                    ->assign('REPORT', "Новых задач на копирайтинг: <b>{$new_tasks}</b>. Пожалуйста, обратите внимание.")
                    ->send($user->email);
            }
        }

        if ( $need_check_tasks > 0 || $accepted_tasks > 0 ) {
            $et = new email_template('report');
            $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                ->assign('REPORT', "Новых задач на копирайтинг: <b>{$new_tasks}</b>.<br>Требуют проверки: <b>{$need_check_tasks}</b>.<br>Принято за {$date_check}: <b>{$accepted_tasks}</b>.<br>")
                ->send("mail@lsboutique.ru")->send("oveissa@mail.ru")->send("shesternin@gmail.com");
        }
        if ($die) die();
    }



    protected function _products_content( $products, &$tp, $utm = 'utm_source=email&utm_medium=email&utm_campaign=email_main&utm_content=link' ) {
        $product_template = '<table>
                <tr><td align="center" valign="top"><a href="{PRODUCT_LINK}" style="text-decoration: none;">
                            <img src="https://lsboutique.ru/reimg/files/products/184x/{PRODUCT_PIC}" alt="{PRODUCT_NAME}" style="border: 0;" />
                </a></td></tr>
                <tr>
                    <td align="center"><a href="{PRODUCT_LINK}" style="color: #585858;font-family: georgia,serif;font-size: 12px;line-height: 19px;text-decoration: none;">{PRODUCT_NAME}</a></div></td>
                </tr></table>';

        $content = '';
        if ( is_array($products) && count($products) )
        foreach ( $products as $product ) {
            $content .= '<td width="25%" align="center" valign="top">';
            $content .= str_replace(array('{PRODUCT_LINK}', '{DESIGNER_NAME}', '{PRODUCT_NAME}', '{PRODUCT_PIC}'),
                                    array("https://{$_SERVER['HTTP_HOST']}/products/{$product->url}/" . (!empty($utm) ? "?{$utm}" : ''), $product->model, $product->model, $product->large_image), $product_template);
            $content .= '</td>';
            $tp++;
            if ( $tp % 4 == 0 ) $content .= '</tr><tr>';
        }
        return $content;
    }



    public function daily_email( $die = true ) {
        set_time_limit(0);
        $sended_emails = 0;

        $user = new luser();
        $user->serve();


        $users = $this->db->results("SELECT * FROM users WHERE email != '' AND enabled = '1' AND group_id = 1 AND user_id = original_user_id GROUP BY email ORDER BY email");
        if ( is_array($users) && count($users) )
        foreach ($users as $u) if ( empty($u->stop_email) ) {
            echo $u->name . ' - ' . $u->email . ' ';
            echo '<br>';

            $content = '';
            // Смотрим персонализированные размеры одежды
            $sizes_top            = $user->user2sizes( 1, $u->user_id );
            $products_top         = $user->find_products(array('sex' => $u->sex, 'type_id' => 1, 'sizes' => $sizes_top, 'created_foto' => date('Y-m-d', time() - 60*60*24*16), 'large_image' => true));
            $sizes_bottom         = $user->user2sizes( 2, $u->user_id );
            $products_bottom      = $user->find_products(array('sex' => $u->sex, 'type_id' => 2, 'sizes' => $sizes_bottom, 'created_foto' => date('Y-m-d', time() - 60*60*24*16), 'large_image' => true));
            $sizes_shoes          = $user->user2sizes( 3, $u->user_id );
            $products_shoes       = $user->find_products(array('sex' => $u->sex, 'type_id' => 3, 'sizes' => $sizes_shoes, 'created_foto' => date('Y-m-d', time() - 60*60*24*16), 'large_image' => true));
            $products_assesories  = $user->find_products(array('sex' => $u->sex, 'type_id' => 4, 'created_foto' => date('Y-m-d', time() - 60*60*24*16), 'large_image' => true));
            $p_count = count($products_top) + count($products_bottom) + count($products_shoes) + count($products_assesories);
            if($p_count > 4){
              if ( is_array($products_top) && count($products_top) || is_array($products_bottom) && count($products_bottom) ) {
                  $content .= '<tr><td bgcolor="#cccccc" style="height: 1px; width: 100%;"></td></tr><tr><td align="center" style="font-family:Georgia,serif;color:#2b2b2b;font-size:22px;line-height:22px;letter-spacing:1px;padding: 20px 0;text-transform: uppercase;">Одежда</td></tr><tr><td>
                      <table cellspacing="0" cellpadding="0" border="0" align="left" width="100%" style="padding: 0 0 40px 0;"><tr>';
                  $tp = 0;
                  $content .= $this->_products_content($products_top, $tp, "utm_source=email&utm_medium=email&utm_campaign=email_list-all_users|reason-weekly_novelty|date-".date('Y-m-d')."&utm_content=products_top");
                  $content .= $this->_products_content($products_bottom, $tp, "utm_source=email&utm_medium=email&utm_campaign=email_list-all_users|reason-weekly_novelty|date-".date('Y-m-d')."&utm_content=products_bottom");
                  $content .= '</tr></table></td></tr>';
              }

              // Обувь и аксессуары
              if ( is_array($products_shoes) && count($products_shoes) ) {
                  $content .= '<tr><td bgcolor="#cccccc" style="height: 1px; width: 100%;"></td></tr><tr><td align="center" style="font-family:Georgia,serif;color:#2b2b2b;font-size:22px;line-height:22px;letter-spacing:1px;padding: 20px 0;text-transform: uppercase;">Обувь</td></tr><tr><td>
                      <table cellspacing="0" cellpadding="0" border="0" align="left" width="100%" style="padding: 0 0 40px 0;"><tr>';
                  $tp = 0;
                  $content .= $this->_products_content($products_shoes, $tp, "utm_source=email&utm_medium=email&utm_campaign=email_list-all_users|reason-weekly_novelty|date-".date('Y-m-d')."&utm_content=products_shoes");
                  $content .= '</tr></table></td></tr>';
              }
              if ( is_array($products_assesories) && count($products_assesories) ) {
                  $content .= '<tr><td bgcolor="#cccccc" style="height: 1px; width: 100%;"></td></tr><tr><td align="center" style="font-family:Georgia,serif;color:#2b2b2b;font-size:22px;line-height:22px;letter-spacing:1px;padding: 20px 0;text-transform: uppercase;">Аксессуары</td></tr><tr><td>
                      <table cellspacing="0" cellpadding="0" border="0" align="left" width="100%" style="padding: 0 0 40px 0;"><tr>';
                  $tp = 0;
                  $content .= $this->_products_content($products_assesories, $tp, "utm_source=email&utm_medium=email&utm_campaign=email_list-all_users|reason-weekly_novelty|date-".date('Y-m-d')."&utm_content=products_assesories");
                  $content .= '</tr></table></td></tr>';
              }
              echo $content;
              if ( $content ) {
                  $et = new email_template('weekly_email');
                  $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                      ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                      ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                      ->assign('UNSUBSCRIBE_LINK',"https://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email={$u->email}&type=email" . utm('email', 'email', 'email_list-all_users|reason-weekly_novelty|date-'.date('Y-m-d')))
                      ->assign('USER_NAME',       trim($u->name))
                      ->assign('USER_EMAIL',      $u->email)
                      ->assign('USER_PHONE',      $u->phone_number)
                      ->assign('USER_PHONE_NUMBER', 	$u->phone_number)
                      ->assign('USER_CARD_NUMBER',$u->card_number)
                      ->assign('CONTENT',         $content)
                      ->assign('DATE',            date('Y-m-d'))
                      ->assign('USER_LOGIN_URL',  $u->phone_number && $u->card_number ? "<br>Или войдите в личный кабинет, воспользовавшись <a href=\"https://{$_SERVER['HTTP_HOST']}/?module=Login&phone={$u->phone_number}&card_number={$u->card_number}"  . utm('email', 'email', 'email_list-all_users|reason-weekly_novelty|date-'.date('Y-m-d')) . "\" title=\"Быстрый вход в личный кабинет {$_SERVER['HTTP_HOST']}\" style=\"color:#787878;text-decoration:underline;font-weight:bold\">ссылкой</a><br>" : '')
                      ->send( $u->email );
                      usleep(10);
                  $sended_emails++;
                  unset($et);
              }
              echo '<br>';
            }
        }

        $et = new email_template('report');
        $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
            ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
            ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
            ->assign('REPORT', "Отправлено персонализированых недельных имейлов с информацией о новых поступлениях: {$sended_emails}")
            ->send("mail@lsboutique.ru");
        if ($die) die();
    }



    public function rfi_payment_confirm( $test = true ) {
        $order = new orders();
        if ( $order->rfi_payment_confirm($_POST, $this->settings->rfi_key, isset($_POST['test'])) ) {
            die('ok');
        }
        die('fail');
    }

    public function sber_payment_confirm() {
        $order = new orders();
        if ( $order->sber_payment_confirm($_GET) ) {
            die('ok');
        }
        die('<br>fail');
    }

    public function new_supply_spam() {
        $big_period_start = date('Y-m-d', strtotime('-1 month')) . ' 21:00:01';
        $period_start = date('Y-m-d', strtotime('-1 day')) . ' 21:00:01';
        $period_end = date("Y-m-d") . ' 21:00:00';
        $brands = $this->db->results("SELECT brand_id FROM products WHERE `photo_added` >= '{$period_start}' AND `photo_added` <= '{$period_end}' AND `created` >= '{$big_period_start}' AND enabled = 1 AND large_image != '' GROUP BY brand_id");
        foreach ($brands as $brand) $brand_arr[] = $brand->brand_id;
        $brand_arr = implode(',',$brand_arr);
        set_time_limit(300);

        if (!empty($brands)){
            $users = $this->db->results("SELECT u2b.*, b.name as brand_name, b.url as brand_url, u.name, u.phone_number, u.card_number, u.email, u.stop_sms, u.stop_email FROM users2brands u2b
                                LEFT JOIN users u ON u2b.user_id = u.user_id
                                LEFT JOIN brands b ON u2b.brand_id = b.brand_id
                                WHERE u2b.brand_id IN ({$brand_arr})
                                AND u2b.status = 1
                                AND ( u.stop_sms = 0 OR u.stop_email = 0 )
                                ORDER BY u2b.user_id");

            if (!empty($users)){
                $user_id = 0;
                foreach($users as $user){
                    if($user->user_id != $user_id){
                        $user_id = $user->user_id;
                    }
                    $usr[$user->user_id]->brands[$user->brand_id]->brand_name = $user->brand_name;
                    $usr[$user->user_id]->brands[$user->brand_id]->brand_url = $user->brand_url;
                    $usr[$user->user_id]->name = trim($user->name);
                    $usr[$user->user_id]->phone_number = $user->phone_number;
                    $usr[$user->user_id]->card_number = $user->card_number;
                    $usr[$user->user_id]->email = $user->email;
                    $usr[$user->user_id]->stop_sms = (int)$user->stop_sms;
                    $usr[$user->user_id]->stop_email = (int)$user->stop_email;
                }
                $sms_count = 0;
                $email_count = 0;
                $user_count = 0;
                foreach($usr as $user_id => $user){
                    if ($user->stop_sms === 0){
                        $text = '';
                        $brand_names='';
                        if (count($user->brands) > 1){
                            foreach($user->brands as $brand){$brand_names .= $brand->brand_name . ', ';}
                            $text = "брендов ".$brand_names;
                        }
                        else{$text = "бренда ".reset($user->brands)->brand_name;}
                        $message = "Уважаемый {$user->name}, новинки  {$text} сегодня добавлены на сайт и в приложение www.lsboutique.ru";
                        $args = array( 'user_id' => $user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $user->phone_number );
                        Job::push('SmsJob', $args);
                        $sms_count++;
                    }
                    if ($user->stop_email === 0){
                        $content = '';$p = 0;
                        foreach($user->brands as $bid => $brand){
                            $prods = $this->db->results("SELECT * FROM products WHERE `photo_added` >= '{$period_start}' AND `photo_added` <= '{$period_end}' AND `created` >= '{$big_period_start}' AND enabled = 1 AND large_image != '' AND brand_id = {$bid}");
                            if ( is_array($prods) && count($prods) ) {
                                $p_count += count($prods);
                                $content .= '<table style="width: 100%;"><tr><td bgcolor="#cccccc" style="height: 1px; width: 100%;"></td></tr><tr><td align="center" style="font-family:Georgia,serif;color:#2b2b2b;font-size:22px;line-height:22px;letter-spacing:1px;padding: 20px 0;text-transform: uppercase;"><a target="_blank" style="font-family:Georgia,serif;color:#2b2b2b;font-size:16px;line-height:22px;text-decoration:underline;" href="https://lsboutique.ru/brands/'. $brand->brand_url .'/?utm_source=email&utm_medium=email&utm_campaign=email_list-subcribed_users|reason-new_supply|date-'.date('Y-m-d').'&utm_content=brand-'.$brand->brand_name.'">'. $brand->brand_name .'</a></td></tr><tr><td>
                                    <table cellspacing="0" cellpadding="0" border="0" align="left" width="100%" style="padding: 0 0 40px 0;"><tr>';
                                $tp = 0;
                                $content .= $this->_products_content($prods, $tp, "utm_source=email&utm_medium=email&utm_campaign=email_list-subcribed_users|reason-new_supply|date-".date('Y-m-d')."&utm_content=product-{$brand->brand_name}");
                                $content .= '</tr></table></td></tr></table>';
                            }
                        }
                        if($p_count > 4){
                          $et = new email_template('new_supply');
                          $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
                              ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
                              ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
                              ->assign('USER_NAME',      $user->name)
                              ->assign('USER_EMAIL',      $user->email)
                              ->assign('DATE',            date('Y-m-d'))
                              ->assign('NEW_BRANDS',      $content)
                              ->assign('USER_EMAIL',      $user->email)
                              ->assign('USER_PHONE_NUMBER', 	$user->phone_number)
                              ->assign('USER_CARD_NUMBER', 	$user->card_number)
                              ->send( $user->email, $user->name );
                          $email_count++;
                        }
                    }
                    $user_count++;
                }
                $m = "Авторассылка отправила {$sms_count} СМСок и {$email_count} email-ов {$user_count} пользователям";
                $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
                Job::push('SlackJob', $args);
            }
        }
        die();
    }

    public function api_tests( $test = true ) {
        $x = $_SERVER['DOCUMENT_ROOT'] . '/third_party/PHPUnit/';
        set_include_path(get_include_path() . PATH_SEPARATOR . $x);
        set_time_limit(300);
        require_once 'Autoload.php';
        require_once($_SERVER['DOCUMENT_ROOT'] . '/tests/errListener.php');
        require_once($_SERVER['DOCUMENT_ROOT'] . '/tests/common_tests.php');

        $suite = new PHPUnit_Framework_TestSuite();
        $mLis = new myListener();
        $result = new PHPUnit_Framework_TestResult();
        $suite->addTestSuite("CommonTests");
        $result->addListener($mLis);
        $suite->run($result);
        die();
    }

    public function daily_report() {
        require_once 'googleworks.php';
        $g = new GoogleWorks;
        $period_start = date('Y-m-d', strtotime('-1 day')) . ' 20:30:01';
        $period_end = date("Y-m-d") . ' 20:30:00';
        $date = date("d.m.Y");
        set_time_limit(400);

        $general->date = date_format(date_create($date), "d.m.Y");
        $general->neworderscount = (int)$this->db->result("SELECT COUNT(*) AS o_count FROM orders WHERE ((`last_update` >= '{$period_start}' AND `last_update` <= '{$period_end}') OR (`last_update` = '0000-00-00 00:00:00' AND `date` >= '{$period_start}' AND `date` <= '{$period_end}')) AND status IN (0,1) AND receipt_number = 0")->o_count;
        $general->neworderssum = (int)$this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE ((`last_update` >= '{$period_start}' AND `last_update` <= '{$period_end}') OR (`last_update` = '0000-00-00 00:00:00' AND `date` >= '{$period_start}' AND `date` <= '{$period_end}')) AND receipt_number = 0 AND status IN (0,1))")->total;

        $res->neworders_cart = $this->db->get_row("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id WHERE ((o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}') OR (o.last_update = '0000-00-00 00:00:00' AND o.date >= '{$period_start}' AND o.date <= '{$period_end}')) AND o.receipt_number = 0 AND o.status IN (0,1) AND o.order_source IN (0,1)");
        $res->neworders_oc = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id  WHERE ((o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}') OR (o.last_update = '0000-00-00 00:00:00' AND o.date >= '{$period_start}' AND o.date <= '{$period_end}')) AND o.receipt_number = 0 AND o.status IN (0,1) AND o.order_source = 2");
        $res->neworders_spec = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id  WHERE ((o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}') OR (o.last_update = '0000-00-00 00:00:00' AND o.date >= '{$period_start}' AND o.date <= '{$period_end}')) AND o.receipt_number = 0 AND o.status IN (0,1) AND o.order_source = 3");
        $res->neworders_iOS = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id  WHERE ((o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}') OR (o.last_update = '0000-00-00 00:00:00' AND o.date >= '{$period_start}' AND o.date <= '{$period_end}')) AND o.receipt_number = 0 AND o.status IN (0,1) AND o.order_source = 4");
        $res->neworders_android = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id  WHERE ((o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}') OR (o.last_update = '0000-00-00 00:00:00' AND o.date >= '{$period_start}' AND o.date <= '{$period_end}')) AND o.receipt_number = 0 AND o.status IN (0,1) AND o.order_source = 5");
        $res->neworders_manager = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id  WHERE ((o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}') OR (o.last_update = '0000-00-00 00:00:00' AND o.date >= '{$period_start}' AND o.date <= '{$period_end}')) AND o.receipt_number = 0 AND o.status IN (0,1) AND o.order_source = 6");

        $general->delorderscount = (int)$this->db->result("SELECT COUNT(*) AS o_count FROM orders WHERE `last_update` >= '{$period_start}' AND `last_update` <= '{$period_end}' AND status = 6 AND delivery_status IN (0,1,2) AND receipt_number = 0")->o_count;
        $general->delorderssum = (int)$this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE `date_to_delivery` >= '{$period_start}' AND `date_to_delivery` <= '{$period_end}' AND status = 6 AND delivery_status IN (0,1,2))")->total;

        $res->delorders_cart = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id WHERE o.date_to_delivery >= '{$period_start}' AND o.date_to_delivery <= '{$period_end}' AND o.status = 6 AND o.delivery_status IN (0,1,2) AND o.receipt_number = 0 AND o.order_source IN (0,1)");
        $res->delorders_oc = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id WHERE o.date_to_delivery >= '{$period_start}' AND o.date_to_delivery <= '{$period_end}' AND o.status = 6 AND o.delivery_status IN (0,1,2) AND o.receipt_number = 0 AND o.order_source = 2");
        $res->delorders_spec = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id WHERE o.date_to_delivery >= '{$period_start}' AND o.date_to_delivery <= '{$period_end}' AND o.status = 6 AND o.delivery_status IN (0,1,2) AND o.receipt_number = 0 AND o.order_source = 3");
        $res->delorders_iOS = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id WHERE o.date_to_delivery >= '{$period_start}' AND o.date_to_delivery <= '{$period_end}' AND o.status = 6 AND o.delivery_status IN (0,1,2) AND o.receipt_number = 0 AND o.order_source = 4");
        $res->delorders_android = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id WHERE o.date_to_delivery >= '{$period_start}' AND o.date_to_delivery <= '{$period_end}' AND o.status = 6 AND o.delivery_status IN (0,1,2) AND o.receipt_number = 0 AND o.order_source = 5");
        $res->delorders_manager = $this->db->result("SELECT COUNT(DISTINCT(o.order_id)) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o LEFT JOIN orders_products op ON o.order_id = op.order_id WHERE o.date_to_delivery >= '{$period_start}' AND o.date_to_delivery <= '{$period_end}' AND o.status = 6 AND o.delivery_status IN (0,1,2) AND o.receipt_number = 0 AND o.order_source = 6");

        $res->mfuorderscount_oc = (int)$this->db->result("SELECT COUNT(*) AS o_count FROM one_click WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' AND cr_manager !=0")->o_count;
        $res->mfuorderscount_s = (int)$this->db->result("SELECT COUNT(*) AS o_count FROM orders WHERE `last_update` >= '{$period_start}' AND `last_update` <= '{$period_end}' AND cr_manager !=0")->o_count;
        $res->mfuorderscount_o = (int)$this->db->result("SELECT COUNT(*) AS o_count FROM special_orders WHERE `create_date` >= '{$period_start}' AND `create_date` <= '{$period_end}' AND cr_manager !=0")->o_count;
        $ids = $this->db->results("SELECT product_id FROM one_click WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' AND cr_manager !=0");
        foreach ($ids as $id) {$id_arr[] = $id->product_id;}
            $ids = implode(',',$id_arr);
        $res->mfuorderssum_oc = (int)$this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `products` WHERE product_id IN ({$ids}) ")->total;
        $res->mfuorderssum_o = (int)$this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' AND cr_manager !=0)")->total;
        $res->mfuorderssum_s = (int)$this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `products` WHERE product_id IN (SELECT product_id FROM special_orders WHERE `create_date` >= '{$period_start}' AND `create_date` <= '{$period_end}' AND cr_manager !=0) ")->total;

        $res->mfuorderscount = $res->mfuorderscount_oc + $res->mfuorderscount_s + $res->mfuorderscount_o;
        $res->mfuorderssum = $res->mfuorderssum_oc + $res->mfuorderssum_s + $res->mfuorderssum_o;

        $res->accepted_c_all = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0 AND courier_id != 0");
        $res->return_c_all = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 4 AND o.cashbox_id = 0 AND courier_id != 0");
        $res->accepted_sort_C = $this->db->results($sql="SELECT COALESCE(SUM(op.price),0) AS total, pm.name FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0 AND courier_id != 0 GROUP BY o.payment_method_id");
        $res->orders_c->count = $res->accepted_c_all->count + $res->return_c_all->count;
        $res->orders_c->total = $res->accepted_c_all->total + $res->return_c_all->total;

        $general->acceptedcount = (int)$this->db->result("SELECT COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0")->count;
        $general->acceptedsum = (int)$this->db->result("SELECT COALESCE(SUM(op.price),0) AS total FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0")->total;
        $res->accepted_sort = $this->db->results($sql="SELECT COALESCE(SUM(op.price),0) AS total, pm.name FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN payment_methods pm ON o.payment_method_id = pm.payment_method_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0 GROUP BY o.payment_method_id");
        $res->accepted_list = $this->db->results($sql="SELECT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0 GROUP BY o.order_id");

        $measured_items = $this->db->result($sql="SELECT COUNT(DISTINCT i.barcode) AS items_count, 
                                                    COUNT(DISTINCT im.barcode) AS measured_count, 
                                                    GROUP_CONCAT(CASE WHEN im.barcode IS NULL THEN p.product_id END) AS prods 
                                                  FROM products p 
                                                    LEFT JOIN items i ON i.product_id = p.product_id 
                                                    LEFT JOIN items_measuring im ON im.barcode = i.barcode 
                                                  WHERE p.photo_added >= '{$period_start}' 
                                                    AND p.photo_added <= '{$period_end}' 
                                                    AND i.quantity != 0");
        if($measured_items->items_count != 0){
          $m = "Из {$measured_items->items_count} размеров для товаров с добавленными за {$date} фото, мерки заполнены для {$measured_items->measured_count}.";
          if($measured_items->items_count != $measured_items->measured_count){
            $m .= " Не промеряны - " . ($measured_items->items_count - $measured_items->measured_count) . "!";
            $products = explode(',',$measured_items->prods);
            $products = array_unique(array_filter($products));
            foreach($products as &$p){
              $p = "<https://lsboutique.ru/admin/index.php?section=Product&item_id={$p}|{$p}>";//"<a href='https://lsboutique.ru/admin/index.php?section=Product&item_id={$p}'>{$p}</a>";
            }
            $m .= " Список: " . implode(', ',$products);
          }
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }
        
        $measured_items = $this->db->result($sql="SELECT COUNT(DISTINCT op.barcode) AS items_count, 
                                                  COUNT(DISTINCT im.barcode) AS measured_count, 
                                                  GROUP_CONCAT(CASE WHEN im.barcode IS NULL THEN op.product_id END) AS prods 
                                                    FROM orders_products op 
                                                    LEFT JOIN orders o ON o.order_id = op.order_id 
                                                    LEFT JOIN items_measuring im ON im.barcode = op.barcode 
                                                  WHERE o.date_to_delivery >= '{$period_start}' 
                                                    AND o.date_to_delivery <= '{$period_end}' 
                                                    AND o.status = 6");
        if($measured_items->items_count != 0){
          $m = "Из {$measured_items->items_count} товаров с переведенных в доставку за {$date}, мерки заполнены для {$measured_items->measured_count}.";
          if($measured_items->items_count != $measured_items->measured_count){
            $m .= " Не промеряны - " . ($measured_items->items_count - $measured_items->measured_count) . "!";
            $products = explode(',',$measured_items->prods);
            $products = array_unique(array_filter($products));
            foreach($products as &$p){
              $p = "<https://lsboutique.ru/admin/index.php?section=Product&item_id={$p}|{$p}>";//"<a href='https://lsboutique.ru/admin/index.php?section=Product&item_id={$p}'>{$p}</a>";
            }
            $m .= " Список: " . implode(', ',$products);
          }
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }

        $general->returncount = (int)$this->db->result("SELECT COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 4 AND o.cashbox_id = 0")->count;
        $general->returnsum = (int)$this->db->result("SELECT COALESCE(SUM(op.price),0) AS total FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 4 AND o.cashbox_id = 0")->total;

        $general->g_flag = 1;

        $g->update($general);

        $m = "Товаров доставлено за {$date} {$res->orders_c->count} на сумму {$res->orders_c->total} из них приняли {$res->accepted_c_all->count} на общую сумму {$res->accepted_c_all->total}, вернули {$res->return_c_all->count} на общую сумму {$res->return_c_all->total}. Из них: ";
        foreach($res->accepted_sort_C as $method) $m .= $method->name . ':' . $method->total . ', ';
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_stat" );
        Job::push('SlackJob', $args);

        $m = ":bar_chart: Заказов оформлено за пользователей за {$date} - {$res->mfuorderscount} на общую сумму {$res->mfuorderssum}.";
        if($res->mfuorderscount_o !=0 || $res->mfuorderscount_oc !=0 || $res->mfuorderscount_s !=0)$m .= " Из них:";
        if($res->mfuorderscount_o !=0)$m .= " из корзины - {$res->mfuorderscount_o} на общую сумму {$res->mfuorderssum_o}";
        if($res->mfuorderscount_oc !=0)$m .= ", из заказов в один клик - {$res->mfuorderscount_oc} на общую сумму {$res->mfuorderssum_oc}";
        if($res->mfuorderscount_s !=0)$m .= ", из спецзаказов - {$res->mfuorderscount_s} на общую сумму {$res->mfuorderssum_s}";
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_stat" );
        Job::push('SlackJob', $args);

        $m = ":bar_chart: Новых заказов за {$date} {$general->neworderscount} на общую сумму {$general->neworderssum}.";
        if($res->neworders_cart->o_count !=0 || $res->neworders_oc->o_count !=0 || $res->neworders_spec->o_count !=0|| $res->neworders_manager->o_count !=0|| $res->neworders_iOS->o_count !=0|| $res->neworders_android->o_count !=0)$m .= " Из них:";
        if($res->neworders_cart->o_count !=0)$m .= " из корзины - {$res->neworders_cart->o_count} на общую сумму {$res->neworders_cart->total}";
        if($res->neworders_oc->o_count !=0)$m .= ", из заказов в один клик - {$res->neworders_oc->o_count} на общую сумму {$res->neworders_oc->total}";
        if($res->neworders_spec->o_count !=0)$m .= ", из спецзаказов - {$res->neworders_spec->o_count} на общую сумму {$res->neworders_spec->total}";
        if($res->neworders_manager->o_count !=0)$m .= ", менеджерами - {$res->neworders_manager->o_count} на общую сумму {$res->neworders_manager->total}";
        if($res->neworders_iOS->o_count !=0)$m .= ", из приложения iOS - {$res->neworders_iOS->o_count} на общую сумму {$res->neworders_iOS->total}";
        if($res->neworders_android->o_count !=0)$m .= ", из приложения Android - {$res->neworders_android->o_count} на общую сумму {$res->neworders_android->total}";
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_stat" );
        Job::push('SlackJob', $args);

        $m = "Заказов отправлено за {$date} {$general->delorderscount} на общую сумму {$general->delorderssum}.";
        if($res->delorders_cart->o_count !=0 || $res->delorders_oc->o_count !=0 || $res->delorders_spec->o_count !=0 || $res->delorders_manager->o_count !=0 || $res->delorders_iOS->o_count !=0 || $res->delorders_android->o_count !=0)$m .= " Из них:";
        if($res->delorders_cart->o_count !=0)$m .= " из корзины - {$res->delorders_cart->o_count} на общую сумму {$res->delorders_cart->total}";
        if($res->delorders_oc->o_count !=0)$m .= ", из заказов в один клик - {$res->delorders_oc->o_count} на общую сумму {$res->delorders_oc->total}";
        if($res->delorders_spec->o_count !=0)$m .= ", из спецзаказов - {$res->delorders_spec->o_count} на общую сумму {$res->delorders_spec->total}";
        if($res->delorders_manager->o_count !=0)$m .= ", менеджерами - {$res->delorders_manager->o_count} на общую сумму {$res->delorders_manager->total}";
        if($res->delorders_iOS->o_count !=0)$m .= ", из приложения iOS - {$res->delorders_iOS->o_count} на общую сумму {$res->neworders_iOS->total}";
        if($res->delorders_android->o_count !=0)$m .= ", из приложения Android - {$res->delorders_android->o_count} на общую сумму {$res->delorders_android->total}";
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_stat" );
        Job::push('SlackJob', $args);

        $ol=array();
        foreach($res->accepted_list as $o) $ol[] = "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>";
        $m = "Товаров приняли за {$date} {$general->acceptedcount} на общую сумму {$general->acceptedsum}. Список заказов: ". implode(', ',$ol) ." По формам оплаты: ";
        foreach($res->accepted_sort as $method) $m .= $method->name . ':' . $method->total . ', ';
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_stat" );
        Job::push('SlackJob', $args);

        $m = "Товаров вернули за {$date} {$general->returncount} на общую сумму {$general->returnsum}";
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_stat" );
        Job::push('SlackJob', $args);
        
        $long_delivery = $this->db->results("SELECT DISTINCT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE  o.last_update <= DATE_SUB(NOW(), INTERVAL 10 DAY) AND op.status = 0 AND o.delivery_company_id != 2 AND o.status = 6 AND o.delivery_status NOT IN (5,6) AND o.cashbox_id = 0");
        $long_return = $this->db->results("SELECT DISTINCT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE  o.last_update <= DATE_SUB(NOW(), INTERVAL 10 DAY) AND op.status = 4 AND o.delivery_company_id != 2 AND o.status = 6 AND o.delivery_status = 5 AND o.cashbox_id = 0");
        $long_process = $this->db->results("SELECT o.order_id FROM orders o LEFT JOIN order_comments oc ON o.order_id = oc.order_id WHERE o.delayed = 0 AND o.status = 1 AND o.cashbox_id = 0 GROUP BY o.order_id HAVING MAX(oc.date) < DATE_SUB(NOW(), INTERVAL 1 DAY)");
        if(!empty($long_delivery)){
          $m = "Заказы в доставке более 10 дней: ";
          foreach($long_delivery as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";//"<a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}'>{$o->order_id}</a>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }if(!empty($long_return)){
          $m = "Заказы в возврате более 10 дней: ";
          foreach($long_return as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";//"<a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}'>{$o->order_id}</a>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }if(!empty($long_process)){
          $m = "Заказы в обработке без комментария за последние сутки: ";
          foreach($long_process as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";//"<a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}'>{$o->order_id}</a>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }
        
        $long_msk = $this->db->results("SELECT DISTINCT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE  o.last_update <= DATE_SUB(NOW(), INTERVAL 15 DAY) AND op.status = 0 AND o.delivery_company_id = 2 AND o.status = 6 AND o.delivery_status NOT IN (5,6) AND o.cashbox_id = 0");
        if(!empty($long_msk)){
          $m = "Заказы на складе мск более 15 дней: ";
          foreach($long_msk as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";//"<a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}'>{$o->order_id}</a>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }$long_msk = $this->db->results("SELECT DISTINCT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE  op.status_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) AND op.status_date <= DATE_SUB(NOW(), INTERVAL 1 DAY) AND op.status = 4 AND o.delivery_company_id = 2 AND o.status = 6 AND o.delivery_status NOT IN (5,6) AND o.cashbox_id = 0");
        if(!empty($long_msk)){
          $m = "Заказы с отказом на складе мск более 1 дня: ";
          foreach($long_msk as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";//"<a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}'>{$o->order_id}</a>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }
        
        
        $overdue = $this->db->results("SELECT DISTINCT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.agreed_delivery_date < NOW() AND op.status = 0 AND o.status = 6 AND o.cashbox_id = 0");
        if(!empty($overdue)){
          $m = "Заказы с просроченной датой доставки: ";
          foreach($overdue as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }
        $overdue_o = $this->db->results("SELECT DISTINCT o.order_id FROM orders o LEFT JOIN orders_events oe ON o.order_id = oe.order_id AND oe.type = 'delivery_status' WHERE oe.date <= '{$period_start}' AND o.delivery_status = 2 AND o.cashbox_id = 0 AND courier_id != 0");
        $packed_o = $this->db->results("SELECT DISTINCT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}' AND o.status = 6 AND o.cashbox_id = 0 AND packer_id = 0");
        $returned_o = $this->db->results("SELECT DISTINCT o.order_id FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}' AND op.status = 4 AND o.delivery_status = 6 AND o.cashbox_id = 0 AND return_manager_id = 0");
        if(!empty($packed_o)){
          $m = "Отправленные заказы без упаковщика: ";
          foreach($packed_o as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }
        if(!empty($returned_o)){
          $m = "Принятые возвращенные заказы без менеджера: ";
          foreach($returned_o as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }
        if(!empty($overdue_o)){
          $m = "Заказы на доставке больше суток: ";
          foreach($overdue_o as $o) $m .= "№<https://lsboutique.ru/admin/index.php?section=Order&order_id={$o->order_id}|{$o->order_id}>, ";
          $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
          Job::push('SlackJob', $args);
        }

        $managers = $this->db->results("SELECT * FROM users WHERE group_id = 5 AND subgroup_id != 2 ORDER BY name DESC");
        foreach($managers as $manager){
            $manager_id = "AND manager_id = {$manager->original_user_id}";

            $new_orders_count = $this->db->result("SELECT COUNT(*) AS o_count FROM orders WHERE `last_update` >= '{$period_start}' AND `last_update` <= '{$period_end}' AND status IN (0,1) {$manager_id}")->o_count;
            $new_orders_sum = $this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE last_update >= '{$period_start}' AND `last_update` <= '{$period_end}' AND status IN (0,1) {$manager_id})")->total;
            $del_orders_count = $this->db->result("SELECT COUNT(*) AS o_count FROM orders WHERE `last_update` >= '{$period_start}' AND `last_update` <= '{$period_end}' AND status = 6 AND delivery_status IN (0,1,2) {$manager_id}")->o_count;
            $del_orders_sum = $this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE last_update >= '{$period_start}' AND `last_update` <= '{$period_end}' AND status = 6 AND delivery_status IN (0,1,2) {$manager_id})")->total;

            $accepted_c = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0 AND courier_id = {$manager->original_user_id}");
            $return_c = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 4 AND o.cashbox_id = 0 AND courier_id = {$manager->original_user_id}");
            $del_count = $this->db->get_row("SELECT COUNT(DISTINCT o.order_id) AS count, GROUP_CONCAT(DISTINCT o.order_id) AS list  FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND o.cashbox_id = 0 AND courier_id = {$manager->original_user_id}");

            $accepted_m = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0 {$manager_id}");
            $return_m = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 4 AND o.cashbox_id = 0 {$manager_id}");
            $accepted_m_с = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 5 AND o.cashbox_id = 0 {$manager_id} AND courier_id != 0");
            $return_m_с = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 4 AND o.cashbox_id = 0 {$manager_id} AND courier_id != 0");

            $sizes = $this->db->get_row("SELECT COUNT(*) AS total, COUNT(DISTINCT user_id) AS u_count FROM users2sizes_n WHERE date >= '{$period_start}' AND date <= '{$period_end}' AND manager_id = {$manager->original_user_id}");
            $comments_o = $this->db->get_row("SELECT COUNT(*) AS total, COUNT(DISTINCT order_id) AS o_count FROM order_comments WHERE date >= '{$period_start}' AND date <= '{$period_end}' AND user_id = {$manager->original_user_id}");
            $comments_u = $this->db->get_row("SELECT COUNT(*) AS total, COUNT(DISTINCT user_id) AS u_count FROM user_comments WHERE date >= '{$period_start}' AND date <= '{$period_end}' AND commenter_id = {$manager->original_user_id}");

            $packed_o = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.last_update >= '{$period_start}' AND o.last_update <= '{$period_end}' AND o.status = 6 AND o.cashbox_id = 0 AND packer_id = {$manager->original_user_id}");
            $returned_o = $this->db->get_row("SELECT COALESCE(SUM(op.price),0) AS total, COUNT(*) AS count FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.status_date >= '{$period_start}' AND op.status_date <= '{$period_end}' AND op.status = 4 AND o.cashbox_id = 0 AND return_manager_id = {$manager->original_user_id}");

            $sips = $this->db->results("SELECT sip_id FROM `users2sips` WHERE user_id = {$manager->original_user_id}");
            $sip_arr = array();
            foreach ($sips as $sip) {$sip_arr[] = "'sip:".strtolower($sip->sip_id)."'";}
            $sips = implode(',',$sip_arr);
            $manager_calls_count = $this->db->result("SELECT COUNT(*) AS total FROM `calls` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND sip_id IN ({$sips})")->total;
            
            $measurings = $this->db->result("SELECT COUNT(DISTINCT barcode) AS total FROM `items_measuring` WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' AND user_id = {$manager->original_user_id}")->total;

            $manager_wd = $this->db->result("SELECT id FROM `work_hours` WHERE date = '".date("Y-m-d")."' AND user_id = {$manager->original_user_id}")->id;
            
            $m = "Менеджер {$manager->name} <@{$manager->slack_name}> за {$date}";
            if(!$manager_wd)$m .= ' (Выходной) ';
            if($rmanager_calls_count==0 && $new_orders_count==0 && $del_orders_count==0 && $accepted_c->count==0 && $return_c->count==0 && $accepted_m->count==0 && $return_m->count==0 && $sizes->total!=0 && $comments_o->total!=0 && $comments_u->total!=0)$m .= " был неактивен";
            if($manager_calls_count !=0)$m .= " совершил {$manager_calls_count} звонков";
            if($new_orders_count !=0)$m .= ", обработал {$new_orders_count} новых заказов на сумму {$new_orders_sum}";
            if($del_orders_count !=0)$m .= ", перевел в доставку {$del_orders_count} заказов на сумму {$del_orders_sum}";
            if($accepted_m->count !=0)$m .= " Товаров приняли {$accepted_m->count} на сумму {$accepted_m->total}.";
            if($return_m->count !=0)$m .= " Товаров вернули {$return_m->count} на сумму {$return_m->total}.";
            if($del_count->count !=0){
              $m .= " Заказов доставлено {$del_count->count}.";
              $list = explode(',',$del_count->list);
              foreach($list as &$l)$l = "<https://lsboutique.ru/admin/index.php?section=Order&order_id={$l}|{$l}>";//"<a href='https://lsboutique.ru/admin/index.php?section=Order&order_id={$l}'>{$l}</a>";
              $m .= " Список: " . implode(', ',$list);
            }
            if($measurings !=0)$m .= " Товаров обмерил {$measurings} .";
            if($accepted_c->count !=0)$m .= " Товаров доставлено принятых {$accepted_c->count} на сумму {$accepted_c->total}.";
            if($return_c->count !=0)$m .= " Товаров доставлено возвращенных {$return_c->count} на сумму {$return_c->total}.";
            if($accepted_m_c->count !=0)$m .= " Товаров доставлено курьерами принятых {$accepted_m_c->count} на сумму {$accepted_m_c->total}.";
            if($return_m_c->count !=0)$m .= " Товаров доставлено курьерами возвращенных {$return_m_c->count} на сумму {$return_m_c->total}.";
            if($sizes->total !=0)$m .= " Заполнено размеров {$sizes->total} для {$sizes->u_count} пользователей.";
            if($comments_o->total !=0)$m .= " Оставлено комментариев {$comments_o->total} для {$comments_o->o_count} заказов.";
            if($comments_u->total !=0)$m .= " Оставлено комментариев {$comments_u->total} для {$comments_u->u_count} пользователей.";
            if($packed_o->total !=0)$m .= " Упаковано {$packed_o->count} товаров на сумму {$packed_o->total}.";
            if($returned_o->total !=0)$m .= " Принято {$returned_o->count} возвращенных товаров на сумму {$returned_o->total}.";
            $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "daily_report" );
            Job::push('SlackJob', $args);

            $data["$manager->name"]->title = $manager->name;
            $data["$manager->name"]->date = date_format(date_create($date), "d.m.Y");
            $data["$manager->name"]->neworderscount = (int)$new_orders_count;
            $data["$manager->name"]->neworderssum = (int)$new_orders_sum;
            $data["$manager->name"]->delorderscount = (int)$del_orders_count;
            $data["$manager->name"]->delorderssum = (int)$del_orders_sum;
            $data["$manager->name"]->callscount = (int)$calls_count;
		}
        //$g->update($data);
        die();
	}

    public function daily_rep_analitics() {
        $period_start = date('Y-m-d', strtotime('-12 hour')) . ' 00:00:00';
        $period_end = date('Y-m-d', strtotime('-12 hour')) . ' 23:59:59';
        $date = date("d.m.Y", strtotime('-12 hour'));

        $allorderscount = (int)$this->db->result("SELECT COUNT(DISTINCT(order_id)) AS o_count FROM orders
                                                            WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}'
                                                            AND order_source NOT IN (4,5)
                                                            AND receipt_number = 0")->o_count;
        $allorderssum = (int)$this->db->result("SELECT COALESCE(SUM(price),0) AS total FROM `orders_products` WHERE order_id IN (SELECT order_id FROM orders WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' AND order_source NOT IN (4,5) AND receipt_number = 0)")->total;
        $allorders_m = $this->db->results("SELECT COALESCE(COUNT(DISTINCT(o.order_id)),0) AS o_count, COALESCE(SUM(op.price),0) AS total
                                                            FROM orders o
                                                            LEFT JOIN orders_products op ON op.order_id = o.order_id
                                                            LEFT JOIN one_click oc ON op.one_click_id = oc.id
                                                            WHERE o.date >= '{$period_start}' AND o.date <= '{$period_end}'
                                                            AND o.receipt_number = 0
                                                            AND ((oc.id IS NULL AND o.order_source = 6 ) OR (oc.id IS NOT NULL AND oc.order_source = 2));");
        $allorders_u = $this->db->results("SELECT COALESCE(COUNT(DISTINCT(o.order_id)),0) AS o_count, COALESCE(SUM(op.price)) AS total
                                                            FROM orders o
                                                            LEFT JOIN orders_products op ON op.order_id = o.order_id
                                                            LEFT JOIN one_click oc ON op.one_click_id = oc.id
                                                            WHERE o.date >= '{$period_start}' AND o.date <= '{$period_end}'
                                                            AND o.receipt_number = 0
                                                            AND ((o.order_source IN (0,1) AND o.cr_manager = 0) OR (oc.id IS NOT NULL AND oc.order_source = 1))");
        $allorders_u_oc = $this->db->results("SELECT COALESCE(COUNT(DISTINCT(o.order_id)),0) AS o_count, COALESCE(SUM(op.price)) AS total
                                                            FROM orders o
                                                            LEFT JOIN orders_products op ON op.order_id = o.order_id
                                                            LEFT JOIN one_click oc ON op.one_click_id = oc.id
                                                            WHERE o.date >= '{$period_start}' AND o.date <= '{$period_end}'
                                                            AND o.receipt_number = 0
                                                            AND (oc.id IS NOT NULL AND oc.order_source = 1)");
        $allorders_u_o = $this->db->results("SELECT COALESCE(COUNT(DISTINCT(o.order_id)),0) AS o_count, COALESCE(SUM(op.price)) AS total
                                                            FROM orders o
                                                            LEFT JOIN orders_products op ON op.order_id = o.order_id
                                                            LEFT JOIN one_click oc ON op.one_click_id = oc.id
                                                            WHERE o.date >= '{$period_start}' AND o.date <= '{$period_end}'
                                                            AND o.receipt_number = 0
                                                            AND (o.order_source = 1 AND o.cr_manager = 0) AND oc.id IS NULL");
        $apporders_ios = $this->db->results("SELECT COALESCE(COUNT(DISTINCT(o.order_id)),0) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o
                                                            LEFT JOIN orders_products op ON op.order_id = o.order_id
                                                            WHERE o.date >= '{$period_start}' AND o.date <= '{$period_end}'
                                                            AND o.order_source = 4
                                                            AND o.status != 3
                                                            AND o.receipt_number = 0");
        $apporders_and = $this->db->results("SELECT COALESCE(COUNT(DISTINCT(o.order_id)),0) AS o_count, COALESCE(SUM(op.price),0) AS total FROM orders o
                                                            LEFT JOIN orders_products op ON op.order_id = o.order_id
                                                            WHERE o.date >= '{$period_start}' AND o.date <= '{$period_end}'
                                                            AND o.order_source = 5
                                                            AND o.status != 3
                                                            AND o.receipt_number = 0");

        $m = ":bar_chart: Заказов создано за {$date} - {$allorderscount} на общую сумму ".number_format($allorderssum, 0, '', ' ').". Из них: пользователями - {$allorders_u[0]->o_count} на общую сумму ".number_format($allorders_u[0]->total, 0, '', ' ').": из заказов в один клик - {$allorders_u_oc[0]->o_count} на общую сумму ".number_format($allorders_u_oc[0]->total, 0, '', ' ').", из корзины - {$allorders_u_o[0]->o_count} на общую сумму ".number_format($allorders_u_o[0]->total, 0, '', ' ').". Менеджерами - {$allorders_m[0]->o_count} на общую сумму ".number_format($allorders_m[0]->total, 0, '', ' ');
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "price_change_log" );
        Job::push('SlackJob', $args);

        $m = ":bar_chart: Заказов создано из приложения iOS за {$date} - ".$apporders_ios[0]->o_count ." на общую сумму ".number_format($apporders_ios[0]->total, 0, '', ' ');
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "price_change_log" );
        Job::push('SlackJob', $args);

        $m = ":bar_chart: Заказов создано из приложения Android за {$date} - ".$apporders_and[0]->o_count ." на общую сумму ".number_format($apporders_and[0]->total, 0, '', ' ');
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "price_change_log" );
        Job::push('SlackJob', $args);

        die();
	}

    public function new_collection() {
        set_time_limit(300);

        $date = date('Y-m-d');
        $period_start = $date . ' 00:00:01';
        $period_end = $date . ' 23:59:59';

        $prods = $this->db->results("SELECT product_id, created, brand_id, sizes_max_count, col_code FROM products WHERE `created` >= '{$period_start}' AND `created` <= '{$period_end}' AND brand_id IN (SELECT brand_id FROM products WHERE `created` >= '{$period_start}' AND `created` <= '{$period_end}' GROUP BY brand_id HAVING COUNT(DISTINCT(product_id)) > 9) ORDER BY brand_id, created");
        if (!empty($prods)){
            $i=1;$c=0;$k=0;$brand=$prods[0]->brand_id;
            $c_date = date('dmY');
            $date = date('d.m.y');
            foreach($prods as $prod){
                $sizes = $this->db->result("SELECT COUNT(item_id) AS s_count FROM items WHERE product_id = {$prod->product_id}")->s_count;
                if(empty($prod->col_code)){
                    $c++;
                    $this->db->query("UPDATE products SET col_code = '{$c_date}_{$i}' WHERE product_id = {$prod->product_id}");
                }
                if($prod->sizes_max_count < $sizes){
                    $this->db->query("UPDATE products SET sizes_max_count = {$sizes} WHERE product_id = {$prod->product_id}");
                }
                $k++;
                if($brand != $prods[$k]->brand_id){
                    $brand_name = $this->db->result("SELECT name FROM brands WHERE brand_id = {$prod->brand_id}")->name;
                    if(empty($prod->col_code)){
                        $m = "Получена новая коллекция {$brand_name}, код: {$c_date}_{$i}, дата:{$date} количество товаров {$c}.";
                        $channel = "new_collection";
                        $url = "https://hooks.slack.com/services/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";
                        send_to_slack($m, $channel, $url);
                        $args = array( 'user' => 'ls_offline_admin', 'message' => $m, 'channel' => "new_collection" );
                        Job::push('SlackJob', $args);
                        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "new_collection" );
                        Job::push('SlackJob', $args);
                    }
                    $i++;
                    $brand = $prods[$k]->brand_id;
                    $c=0;
                }
            }
        }

        $collections = $this->db->results("SELECT DISTINCT(col_code) FROM products WHERE col_code != 0 GROUP BY col_code");
        if (!empty($collections)){
            foreach($collections as $collection){
                $date = substr($collection->col_code,0,2) .'.'. substr($collection->col_code,2,2) .'.'. substr($collection->col_code,6,2);
                $prods = $this->db->results("SELECT product_id, created, brand_id, sizes_max_count, col_code FROM products WHERE col_code = '{$collection->col_code}'");
                $brand_name = $this->db->result("SELECT name FROM brands WHERE brand_id = {$prods[0]->brand_id}")->name;
                if (!empty($prods)){
                    $k=0;
                    foreach($prods as $prod){
                        $sizes = $this->db->result("SELECT COUNT(item_id) AS s_count FROM items WHERE product_id = {$prod->product_id}")->s_count;
                        if($prod->sizes_max_count < $sizes){
                            $this->db->query("UPDATE products SET sizes_max_count = {$sizes} WHERE product_id = {$prod->product_id}");
                        }
                        elseif($prod->sizes_max_count/2 >= $sizes){$k++;}
                    }
                    $photos = $this->db->result("SELECT COUNT(product_id) AS p_count FROM products WHERE col_code = '{$collection->col_code}' AND `photo_added` >= '{$period_start}' AND `photo_added` <= '{$period_end}'")->p_count;
                    if($photos > 1){
                        $m = "У коллекции {$brand_name} {$collection->col_code}, код:{$collection->col_code}, дата:{$date} на сайт выложено {$photos} новых фото.";
                        $channel = "new_collection";
                        $url = "https://hooks.slack.com/services/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";
                        send_to_slack($m, $channel, $url);
                        $args = array( 'user' => 'ls_offline_admin', 'message' => $m, 'channel' => "new_collection" );
                        Job::push('SlackJob', $args);
                        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "new_collection" );
                        Job::push('SlackJob', $args);
                    }
                    if(count($prods)/2 < $k){
                        $m = "Более половины товаров коллекции бренда {$brand_name}, код:{$collection->col_code}, дата:{$date} распродано.";
                        $channel = "new_collection";
                        $url = "https://hooks.slack.com/services/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";
                        send_to_slack($m, $channel, $url);
                        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "new_collection" );
                        Job::push('SlackJob', $args);
                        $args = array( 'user' => 'ls_offline_admin', 'message' => $m, 'channel' => "new_collection" );
                        Job::push('SlackJob', $args);
                        $this->db->query("UPDATE products SET col_code = '0', coll_active = '0' WHERE col_code = '{$collection->col_code}'");
                    }
                }
            }
        }
        die();
    }

    public function services_check() {
        $date_check = date('Y-m-d', strtotime('-4 day')) . ' 00:00:00';
        $date_check_lim = date('Y-m-d', strtotime('-3 month')) . ' 00:00:00';
        $text = "Услуги в работе более 5-им дней: <br/>";
        $services = $this->db->results($sql = "SELECT soi.id AS item_id, so.id AS order_id, so.item_name, so.defect_description, soi.status, sol.date, so.date as cdate
                            FROM services_orders so
                            LEFT JOIN orders o ON o.order_id = so.real_order_id
                            LEFT JOIN services_orders_items soi ON soi.order_id = so.id
                            LEFT JOIN service_order_log sol ON soi.id = sol.service_order_item_id
                            WHERE (soi.status LIKE 'в работе' OR soi.status LIKE 'Принято') AND so.date < '{$date_check}' AND so.date > '{$date_check_lim}' GROUP BY so.id ORDER BY so.date DESC");
        //var_dump($sql);
        foreach($services as $serv){
            if (empty($serv->defect_description)){$serv->defect_description = "Нет";}
            $date = !empty($serv->date) ? $this->rus_date("j F Y", strtotime($serv->date)) : $this->rus_date("j F Y", strtotime($serv->cdate));
            $text .= "<a href='//lsboutique.ru/index.php?module=Service&service_order_id={$serv->order_id}'>{$serv->item_name}</a> (с {$date}) {$serv->defect_description}. <br/>";
        }
        $headers  = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
        $headers .= 'Content-Transfer-Encoding: 8bit' . "\r\n";
        //var_dump($text);
        mail('service@ls.net.ru', 'Обратите внимание на услуги в работе', $text, $headers);
        die();
    }

    public function managers_check() {
        $date_check = "BETWEEN '".date('Y-m-d')." 00:00:00' AND '".date('Y-m-d')." 23:59:59'";
        $managers = $this->db->results("SELECT * FROM users WHERE group_id IN (13,14)");
        $title = 'Продажи за ' . date('d.m.Y');
        $text_f = $title . ':<br><br>';
        foreach($managers as $m){
          $uid = $m->user_id;
          $text = $text_a = '';

          $sales_today = $this->db->result("SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id = {$uid} AND o.date {$date_check}")->st;
          if(!empty($sales_today)) $text .= '<br>Продажи за день: ' . number_format($sales_today, 0, '', ' ');
          $mtm_today = $this->db->result("SELECT SUM(op.price) as st FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE op.offline_manager_id = {$uid} AND o.date {$date_check} AND o.cashbox_id = (SELECT id FROM shop_cashbox WHERE name = 'Индивидуальный пошив')")->st;
          if(!empty($mtm_today)) $text .= '<br>Индивидуальный пошив за день: ' . number_format($mtm_today, 0, '', ' ');

          $mc_today = $this->db->result("SELECT cl.manager_id, SUM(cl.status IN (1,2)) AS total, SUM(cl.status=1) AS success, SUM(cl.status=2) AS fail, SUM(cl.status=3) AS sms_app, SUM(cl.status=4) AS sms_wal FROM calls_log cl WHERE (cl.date {$date_check}) AND cl.manager_id = {$uid} GROUP BY cl.manager_id");
          if(!empty($mc_today->total)) $text .= '<br>Дозвонились/Не дозвонились: ' . $mc_today->success . '/' . $mc_today->fail;
          $mc_today->app_install = $this->db->result("SELECT COUNT(*) AS total FROM `app_tracking` WHERE (date {$date_check}) AND user_id IN (SELECT user_id FROM calls_log WHERE manager_id = {$uid} AND status=3)")->total;
          if(!empty($mc_today->sms_app)) $text .= '<br>СМС на приложение (авторизовано): ' . $mc_today->sms_app . '(' . $mc_today->app_install.')';
          $mc_today->wal_downloads = $this->db->result("SELECT COUNT(*) AS total FROM `apple_pkpass` WHERE (upd_date {$date_check}) AND user_id IN (SELECT user_id FROM calls_log WHERE manager_id = {$uid} AND status=4)")->total;
          if(!empty($mc_today->sms_wal)) $text .= '<br>СМС с wallet-карточкой(загружено): ' . $mc_today->sms_wal . '(' . $mc_today->wal_downloads.')';
          if(!empty($text)) $text = $m->name .':'. $text . $text_a .'<br><br>'; $text_f .= $text;
        }
        echo $text_f;
        $headers  = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
        $headers .= 'Content-Transfer-Encoding: 8bit' . "\r\n";
        mail('zheharev@lsboutique.ru', $title, $text_f, $headers);
        die();
    }

    public function brand_report() {
        $date_start = date('Y-m-d', strtotime('-1 day')) . ' 00:00:00';
        $date_end = date('Y-m-d', strtotime('-1 day')) . ' 23:59:59';
        $date = date('d.m.Y', strtotime('-1 day'));
        $brands = $_GET['brands'];
        $brands_arr = explode(',',$_GET['brands']);
        $data_gen = $this->db->results($sql = "SELECT t.brand_id, t.name, t.turnover, t.articles, t.clients
                  FROM ((SELECT b.brand_id, b.name, COALESCE(ROUND(SUM(op.price)/71),0) AS turnover, COALESCE(COUNT(op.id),0) AS articles, COALESCE(COUNT(DISTINCT(op.user_id)),0) AS clients
                      FROM orders_products op
                      LEFT JOIN orders o ON o.order_id = op.order_id
                      LEFT JOIN products p ON op.product_id = p.product_id
                      LEFT JOIN brands b ON b.brand_id = p.brand_id
                      WHERE b.brand_id IN ({$brands}) AND o.date < '{$date_end}' AND o.date > '{$date_start}'
                      GROUP BY b.brand_id)
                  UNION ALL
                    (SELECT b.brand_id, b.name, 0,0,0
                      FROM brands b
                      WHERE b.brand_id IN ({$brands}))) t
                  GROUP BY t.brand_id");
        $data_spec1 = $this->db->results($sql = "SELECT t.brand_id, t.name, t.c_parent, t.turnover, t.articles, t.clients
                  FROM ((SELECT b.brand_id, b.name, (case when c.parent = 2 then 2 else 1 end) AS c_parent,
                    COALESCE(ROUND(SUM(op.price)/71),0) AS turnover, COALESCE(COUNT(op.id),0) AS articles, COALESCE(COUNT(DISTINCT(op.user_id)),0) AS clients
                      FROM orders_products op
                      LEFT JOIN products p ON op.product_id = p.product_id
                      LEFT JOIN orders o ON o.order_id = op.order_id
                      LEFT JOIN categories c ON p.category_id = c.category_id
                      LEFT JOIN brands b ON b.brand_id = p.brand_id
                      WHERE p.brand_id IN ({$brands}) AND o.date < '{$date_end}' AND o.date > '{$date_start}'
                       GROUP BY b.brand_id, c_parent
                       ORDER BY b.brand_id, c_parent)
                  UNION ALL
                    (SELECT b.brand_id, b.name,1, 0,0,0 FROM brands b WHERE b.brand_id IN ({$brands}))
                  UNION ALL
                    (SELECT b.brand_id, b.name,2, 0,0,0 FROM brands b WHERE b.brand_id IN ({$brands}))) t
                  GROUP BY t.brand_id, t.c_parent");
        $data_spec2 = $this->db->results($sql = "SELECT t.brand_id, t.name, t.c_parent, t.sex, t.turnover, t.articles, t.clients
                  FROM ((SELECT b.brand_id, b.name, (case when c.parent = 2 then 2 else 1 end) AS c_parent, p.sex,
                    COALESCE(ROUND(SUM(op.price)/71),0) AS turnover, COALESCE(COUNT(op.id),0) AS articles, COALESCE(COUNT(DISTINCT(op.user_id)),0) AS clients
                      FROM orders_products op
                      LEFT JOIN products p ON op.product_id = p.product_id
                      LEFT JOIN orders o ON o.order_id = op.order_id
                      LEFT JOIN categories c ON p.category_id = c.category_id
                      LEFT JOIN brands b ON b.brand_id = p.brand_id
                      WHERE b.brand_id IN ({$brands}) AND o.date < '{$date_end}' AND o.date > '{$date_start}'
                       GROUP BY p.brand_id, c_parent, p.sex
                       ORDER BY p.brand_id, c_parent, p.sex)
                UNION ALL
                  (SELECT b.brand_id, b.name,1,1, 0,0,0 FROM brands b WHERE b.brand_id IN ({$brands}))
                UNION ALL
                  (SELECT b.brand_id, b.name,1,2, 0,0,0 FROM brands b WHERE b.brand_id IN ({$brands}))
                UNION ALL
                  (SELECT b.brand_id, b.name,2,1, 0,0,0 FROM brands b WHERE b.brand_id IN ({$brands}))
                UNION ALL
                  (SELECT b.brand_id, b.name,2,2, 0,0,0 FROM brands b WHERE b.brand_id IN ({$brands}))) t
                GROUP BY t.brand_id, t.c_parent, t.sex");
        foreach($data_gen as $data){
          $b_id = (int)$data->brand_id;
          $brands_str .= strtoupper($data->name).", ";
          $text[$b_id][0] = strtoupper($data->name)." ".$date."<br><br>TOTAL<br>TURNOVER - {$data->turnover} EUR<br>ARTICLES - {$data->articles}<br>CLIENTS - {$data->clients}<br>";
        }
        foreach($data_spec1 as $data){
          $b_id = (int)$data->brand_id;
          if($data->c_parent == 1){$what = "<br>CLOTHES<br>";}
          if($data->c_parent == 2){$what = "<br>SHOES<br>";}
          $text[$b_id][$data->c_parent] = "{$what}TURNOVER - {$data->turnover} EUR <br>ARTICLES - {$data->articles}<br>CLIENTS - {$data->clients}<br>";
        }
        foreach($data_spec2 as $data){
          $b_id = (int)$data->brand_id;
          if($data->sex == 1){$what = "<br>MALE ";}
          if($data->sex == 2){$what = "<br>FEMALE ";}
          if($data->c_parent == 1){
            $text[$b_id][1] .= "{$what}TURNOVER - {$data->turnover} EUR<br>ARTICLES - {$data->articles}<br>CLIENTS - {$data->clients}. <br>";
          }
          if($data->c_parent == 2){
            $text[$b_id][2] .= "{$what}TURNOVER - {$data->turnover} EUR<br>ARTICLES - {$data->articles}<br>CLIENTS - {$data->clients}. <br>";
          }
        }
        foreach($text as $k=>$t){
          $text[$k] = implode('<br>',$t);
        }
        $message = implode('<br><br>',$text);
        var_dump($message);
        $headers  = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
        $headers .= 'Content-Transfer-Encoding: 8bit' . "\r\n";
        mail('ivan@lsboutique.ru, ksenia@lsboutique.ru, ibuh@luxurystore.pro', 'BRAND REPORT '.$brands_str . $date, $message, $headers);
        die();
    }

    public function exchange_rates_update() {
      $currencies = $this->db->results('SELECT name, code FROM currencies WHERE def = 0');
      $rates = json_decode(file_get_contents('https://www.cbr-xml-daily.ru/daily_json.js'));
      if(empty($rates)){
        $args = array( 'user' => 'ls_admin', 'message' => "Error! Exchange rates export file empty!", 'channel' => "exchange_rates_update" );
        Job::push('SlackJob', $args);
        die();
      }
      foreach($currencies as $c){
        $code = $c->code;
        if(!isset($rates->Valute->$code)){$error = "Error! No data for {$c->name}!";}
        else{
          $rate_to = round(($rates->Valute->$code->Value/$rates->Valute->$code->Nominal)*0.97, 3);
          if($rate_to != 0){
            $this->db->query("UPDATE currencies SET rate_to = {$rate_to} WHERE code = '{$code}'");
            $names[] = $c->name;
            echo "{$rate_to} {$code}<br>";
          }
          else{$error = "Error! Zero value for {$c->name}!";}
        }
        if(isset($error)){
          $args = array( 'user' => 'ls_admin', 'message' => $error, 'channel' => "exchange_rates_update" );
          Job::push('SlackJob', $args);
        }
      }
      if(!empty($names)){
        $m = "Курс варют успешно обновлён для: " . implode(', ',$names);
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "exchange_rates_update" );
        Job::push('SlackJob', $args);
      }
      die();
    }

    public function cities_tolal() {
        set_time_limit(0);
        $statuses = array(4,5);
        foreach($statuses as $status){
          $totals = $this->db->results("SELECT SUM( price ) AS sum, o.city_id, op.status
              FROM  `orders_products` op
              INNER JOIN `orders` o ON o.order_id = op.order_id
              WHERE op.status = {$status} AND o.city_id != 0
              GROUP BY o.city_id");
          foreach($totals as $total){
            if(!empty($total->sum)){
              $this->db->query("DELETE FROM cities_totals WHERE city_id = {$total->city_id} AND status = {$total->status}");
              $this->db->query("INSERT INTO cities_totals (city_id,status,total) VALUES ({$total->city_id},{$total->status},{$total->sum})");
            }
            else{
              $data = print_r($total,true);
              mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - Error ctTotalUpd:', $data);
            }
          }
        }
        die();
    }

    public function confirm_report() {
        set_time_limit(0);
        $inkass = $this->db->results("SELECT i.*, s.name AS shop_name FROM inkass i LEFT JOIN shops s ON i.shop_id = s.shop_id WHERE i.confirmed = 0 AND i.rejected = 0 AND i.date >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)");
        $movements = $this->db->results("SELECT * FROM movements WHERE need_confirmation = 1 AND date >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)");
        if(!empty($inkass) || !empty($movements)){
          if(!empty($inkass)){
            $text_i = "Неподтвержденных инкассаций за последние сутки: <br/><br/>";
            foreach($inkass as $i){
              $text_i .= "№ <b>{$i->id}</b> из магазина {$i->shop_name}, ссылка: https://{$_SERVER['HTTP_HOST']}/i/c/{$i->hash}/ <br/>";
            }
          }
          if(!empty($movements)){
            foreach($movements as $m){
              $whto = $this->db->result("SELECT * FROM warehouses WHERE warehouse_id = {$m->warehouse_to}");
              if($whto->user_id && $whto->confirm){
                $user = $this->db->result("SELECT * FROM users WHERE user_id = {$whto->user_id}");
                $m_token = substr(hash('sha256', $movement_id.$user->password."movementconfirm"), 0, 8);
                $text_m .= "№ <b>{$m->movement_id}</b> на склад {$whto->name}, ссылка: https://{$_SERVER['SERVER_NAME']}/m_confirm/{$m->movement_id}/{$m_token} <br/>";
              }
            }
            if(!empty($text_m))$text_m = "Неподтвержденных перемещений за последние сутки: <br/><br/>".$text_m;
          }
          echo($text_i);
          echo($text_m);
          $headers  = 'MIME-Version: 1.0' . "\r\n";
          $headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
          $headers .= 'Content-Transfer-Encoding: 8bit' . "\r\n";
          if(!empty($text_i)){
            mail('zhekhareva.e@mail.ru, nkassa@luxurystore.pro, kbuh@luxurystore.pro', 'Напоминание о подтверждении', $text_i, $headers);
          }
          if(!empty($text_m)){
            mail('zhekhareva.e@mail.ru, gbuh@luxurystore.pro, kbuh@luxurystore.pro', 'Напоминание о подтверждении', $text_m, $headers);
          }
        }
        die();
    }
    
    public function check_movements() {
        set_time_limit(0);
        $movements = $this->db->results("SELECT m.*, w1.name AS name_from, w2.name AS name_to, u.name FROM movements m
                  LEFT JOIN warehouses w1 ON w1.warehouse_id = m.warehouse_from
                  LEFT JOIN warehouses w2 ON w2.warehouse_id = m.warehouse_to
                  LEFT JOIN users u ON u.user_id = m.created_user_id
                  WHERE m.accepted_user_id = 0 AND w1.reservation = 0 AND w2.reservation = 0 AND m.date >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)");
        if(!empty($movements)){
          if(!empty($movements)){
            foreach($movements as $m){
              $user = !empty($m->name) ? " Сдал {$m->name}." : '';
              $text_m .= "№ <b><a href='https://{$_SERVER['SERVER_NAME']}/index.php?module=OfflineSales&movement=1&movement_id={$m->movement_id}' target='_blank'>{$m->movement_id}</a></b> со склада {$m->name_from} на склад {$m->name_to}.{$user} <a href='https://{$_SERVER['SERVER_NAME']}/index.php?module=OfflineSales&movement=1&movement_id={$m->movement_id}&acceptance=1' target='_blank'>Открыть принятие</a> <br/>";
            }
            if(!empty($text_m))$text_m = "Неппринятые перемещения за последние сутки: <br/><br/>".$text_m;
          }
          //echo($text_m);
          $headers  = 'MIME-Version: 1.0' . "\r\n";
          $headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
          $headers .= 'Content-Transfer-Encoding: 8bit' . "\r\n";
          if(!empty($text_m)){
            //mail('tirjen@gmail.com, shesternin@gmail.com ', 'Напоминание о перемещениях', $text_m, $headers);
            mail('gbuh@luxurystore.pro, kbuh@luxurystore.pro', 'Напоминание о перемещениях', $text_m, $headers);
          }
        }
        die('ok');
    }
    
    public function sales_check() {
        $date_check = date('Y-m-d', strtotime('-1 day')) . ' 00:08:00';
        $date_check_lim = date('Y-m-d') . ' 00:08:00';
        if($_GET['shop_id']) $shop_f = " AND w.shop_id = " . (int) $_GET['shop_id'];
        else  $shop_f = " AND w.shop_id != 0";
        $products = $this->db->results($sql = "SELECT p.model, p.product_id, p.large_image, GROUP_CONCAT(DISTINCT i.size ORDER BY FIELD(i.size, 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL', '5XL+', '6XL', '7XL'), i.size + 0, i.size ASC SEPARATOR ', ') AS sizes, pc.new_price, pc.old_price, pc.price_delta
                            FROM products p
                            LEFT JOIN items i ON i.product_id = p.product_id
                            LEFT JOIN warehouses w ON i.warehouse_id = w.warehouse_id
                            LEFT JOIN (SELECT product_id, new_price, old_price, (old_price - new_price) AS price_delta, date 
                              FROM price_changes 
                              WHERE old_price != 0
                              GROUP BY product_id ORDER BY date DESC) pc ON p.product_id = pc.product_id
                            WHERE pc.date > '{$date_check}' AND pc.date < '{$date_check_lim}' {$shop_f} 
                            AND i.quantity !=0 
                            AND w.reservation = 0 
                            AND w.warehouse_id NOT IN (90,91) 
                            GROUP BY p.product_id 
                              HAVING price_delta>500 
                            ORDER BY pc.date");
        //var_dump($sql);
        foreach($products as $p){
          $m = "<https://{$_SERVER['HTTP_HOST']}/products/{$p->product_id}/|{$p->model}> - стоимостью {$p->old_price}р стал на {$p->price_delta}р дешевле и стоит {$p->new_price}р. Остались в размерах: {$p->sizes}";
          $args = array( 'user' => 'ls_offline_admin', 'message' => $m, 'channel' => "luxury-sales" );
          if ($p->large_image) $args = array_merge($args, array('image_url'=>"https://{$_SERVER['HTTP_HOST']}/reimg/files/products/60x/{$p->large_image}"));
          Job::push('SlackJob', $args);
        }
        die();
    }
    
    public function mass_logout() {
        set_time_limit(0);
        $group_id = explode(',',$_GET['group']);
        foreach($group_id as $group){
          $group = (int)$group;
          $users = $this->db->results("SELECT * FROM `users` WHERE group_id = {$group} AND enabled != 0 AND superuser = 0");
          foreach($users as $user){
            $this->db->query("UPDATE users SET password = md5(rand()) WHERE user_id = '{$user->user_id}'");
          }
        }
        die();
    }
    
    public function cleanup() {
        set_time_limit(0);
        $date3m = date('Y-m-d', strtotime('-3 month')) . ' 00:00:00';
        if($_GET['t']) $tables = explode(',',$_GET['t']);
        else $tables = array('web_sessions','ip_check','orders_events','product_views','users2products','price_changes','users_crm');
        foreach($tables as $table){
          if($table == 'web_sessions') $this->db->query("DELETE FROM web_sessions WHERE created < '{$date3m}'");
          if($table == 'ip_check') $this->db->query("DELETE FROM ip_check WHERE date < '{$date3m}'");
          //if($table == 'orders_events') $this->db->query("DELETE FROM orders_events WHERE date < '{$date3m}'");
          if($table == 'product_views') $this->db->query("DELETE FROM product_views WHERE date < '{$date3m}' OR NOT EXISTS (SELECT * FROM items WHERE items.product_id = product_views.product_id)");
          if($table == 'users2products') $this->db->query($sql="DELETE FROM users2products WHERE NOT EXISTS (SELECT * FROM items WHERE items.product_id = users2products.product_id)");
          if($table == 'price_changes') $this->db->query($sql="DELETE FROM price_changes WHERE NOT EXISTS (SELECT * FROM items WHERE items.product_id = price_changes.product_id)");
          if($table == 'users_crm') $this->db->query("DELETE FROM users_crm WHERE date < '{$date3m}'");
        }
        die();
    }
    
    public function measuring4users() {
      $date = " AND op.status_date >= '".date("Y-m-d")." 00:00:00'";
      if($_GET['all'])$date = '';
        $products = $this->db->results($sql="SELECT ROUND(AVG(im.shoulders)) AS shoulders, ROUND(AVG(im.chest)) AS chest, ROUND(AVG(im.lenght_on_back)) AS lenght_on_back, ROUND(AVG(im.sleeve)) AS sleeve, ROUND(AVG(im.bottom_band)) AS bottom_band, ROUND(AVG(im.waist)) AS waist, ROUND(AVG(im.hips)) AS hips, ROUND(AVG(im.thigh)) AS thigh, ROUND(AVG(im.waist_height)) AS waist_height, ROUND(AVG(im.bottom_width)) AS bottom_width, ROUND(AVG(im.knee_width)) AS knee_width, ROUND(AVG(im.leg_lenght)) AS leg_lenght, p.category_id, op.user_id, GROUP_CONCAT(DISTINCT f.id) AS fitting, GROUP_CONCAT(DISTINCT ms.id) AS material_stretch 
              FROM `orders_products` op 
              LEFT JOIN products p ON p.product_id = op.product_id 
              LEFT JOIN items i ON i.product_id = op.product_id AND i.size = op.size
              LEFT JOIN items_measuring im ON i.item_id = im.item_id 
              LEFT JOIN fitting f ON f.id = p.fitting 
              LEFT JOIN materials_stretch ms ON ms.id = p.stretch 
              WHERE op.status = 5 {$date} AND user_id !=0 AND im.id IS NOT NULL
              GROUP BY op.user_id, p.category_id 
              ORDER BY op.user_id");
        foreach($products as $product){
          $check = $this->db->results("SELECT * FROM `users_measuring` WHERE user_id = {$product->user_id} AND category_id = {$product->category_id}");
          if(empty($check)) $this->db->query($sql="INSERT INTO users_measuring (user_id,category_id,fitting,stretch,shoulders,chest,lenght_on_back,sleeve,bottom_band,waist,hips,thigh,waist_height,bottom_width,knee_width,leg_lenght)
                              VALUES ({$product->user_id},{$product->category_id},'{$product->fitting}','{$product->stretch}',{$product->shoulders},{$product->chest},{$product->lenght_on_back},{$product->sleeve},{$product->bottom_band},{$product->waist},{$product->hips},{$product->thigh},{$product->waist_height},{$product->bottom_width},{$product->knee_width},{$product->leg_lenght})");
          else $this->db->query("UPDATE users_measuring SET fitting = {$product->fitting}, stretch = '{$product->stretch}', shoulders = {$product->shoulders}, chest = {$product->chest}, lenght_on_back = {$product->lenght_on_back}, sleeve = {$product->sleeve}, bottom_band = {$product->bottom_band}, waist = {$product->waist}, hips = {$product->hips}, thigh = {$product->thigh}, waist_height = {$product->waist_height}, bottom_width = {$product->bottom_width}, knee_width = {$product->knee_width}, leg_lenght = '{$product->leg_lenght}' WHERE  user_id = {$product->user_id} AND category_id = {$product->category_id}");
        }
        die('ok');
    }
    
    public function google_ad_stream() {
        set_time_limit(400);
        $products_tmp = $this->db->results("SELECT p.product_id, p.sku, p.model, CONCAT('https://lsboutique.ru/products/', p.url) as url, CONCAT('https://lsboutique.ru/reimg/files/products/340x/', p.large_image) as image, p.model_full, p.description, c.name as cat_name, p.price, p.meta_keywords
                FROM products p
                LEFT JOIN categories c ON c.category_id = p.category_id
                LEFT JOIN brands b    ON b.brand_id = p.brand_id
              WHERE  b.visibility <= 1 AND b.offline_only = 0 AND c.enabled = 1 AND p.size <> '' AND p.enabled=1 AND p.large_image <> ''
              AND (EXISTS (SELECT 1 FROM items i WHERE i.product_id = p.product_id AND i.quantity != 0  AND i.warehouse_id IN (SELECT warehouse_id FROM warehouses WHERE im_show=1)) OR p.show_out_of_stock = 1) 
              ORDER BY p.product_id");

        $products = $products_kzt = array();    
        $pattern = '/[\x00-\x1F\x7F]/u';
        $kzt_rate = $this->db->result("SELECT rate_to FROM currencies WHERE code = 'KZT'")->rate_to;

        foreach($products_tmp as $k=>$product){
          $product->description = preg_replace($pattern, '', $product->description);
          $price_kzt = round($product->price/$kzt_rate) . ' KZT';
          $products[$k] = $products_kzt[$k] = array();
          foreach($product as $kk=>$p){
            if($kk == 'price'){
              $products_kzt[$k][] = $price_kzt;
              $products[$k][] = (int)$p . ' RUB';
            }
            else{
              $products_kzt[$k][] = $p;
              $products[$k][] = $p;
            }
          }
        }
        $fl = array("ID","ID2","Item title","Final URL","Image URL","Item subtitle","Item description","Item category","Price","Contextual keywords");
        array_unshift($products,$fl);
        array_unshift($products_kzt,$fl);
        
        $fp = fopen('shoplists/google_ad_shop.csv', 'w');
        foreach ($products as $fields) {
          fputcsv($fp, $fields);
        }
        fclose($fp);
        
        $fp_kzt = fopen('shoplists/google_ad_shop_kzt.csv', 'w');
        foreach ($products_kzt as $fields) {
          fputcsv($fp_kzt, $fields);
        }
        fclose($fp_kzt);
        die('ok');
    }

    public function test_email( $die = true ) {
        set_time_limit(0);
        $et = new email_template('report');
        $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
            ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
            ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
            ->assign('REPORT', "Отправлено персонализированых недельных имейлов с информацией о новых поступлениях")
            ->send("shesternin@gmail.com");
        if ($die) die();
    }
}
