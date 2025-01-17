<?PHP
require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('../placeholder.php');

ini_set('memory_limit','256M');
ini_set('max_execution_time', 120);


############################################
# Class Users displays users
############################################
class Users extends Widget
{
  var $pages_navigation;
  var $items_per_page = 40;
  function Users(&$parent)
  {
    parent::Widget($parent);
    $this->add_param('page');
    $this->add_param('group');
    $this->add_param('keyword');
    $this->add_param('with_out_sex');
    $this->add_param('with_out_shop');
    $this->add_param('with_out_phone');
    $this->add_param('info_1c');
    $this->add_param('stars');
    $this->add_param('sex');
    $this->add_param('p_manager');
    $this->add_param('user_status');
    $this->add_param('brand');
    $this->add_param('city');
    $this->add_param('shop');
    $this->add_param('big_size');
    $this->add_param('last_purchase');
    $this->add_param('have_orders');
    $this->add_param('have_calls');
    $this->add_param('logined');

    $this->pages_navigation = new PagesNavigation($this);
    $this->prepare();
  }


  function toggle_user($user_id){
    $card_number = luser::generate_card_number();
    $this->db->query("UPDATE users SET enabled=1-enabled, password=md5(rand()), card_number='{$card_number}'  WHERE user_id={$user_id} LIMIT 1");
    $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id} AND enabled = 1  LIMIT 1");
    if($user->phone_number){
      $message = "Ваши данные для входа {$user->phone_number} / {$user->card_number} не забудьте удалить смс";
      $args = array( 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $user->phone_number, 'user_id' => (isset($user->original_user_id) ? $user->original_user_id : 0), 'sms_only' => 1 );
      Job::push( 'SmsJob', $args, false, 'critical' );
    }
  }



  function prepare()
  {
    if(isset($_GET['enable']))
    {
        $this->check_token();
        $user_id    = intval($_GET['enable']);
        $this->toggle_user($user_id);
    }

    if(isset($_GET['mass_enable']))
    {
        $this->check_token();
        $user_ids    = explode(',',$_GET['mass_enable']);
        foreach($user_ids as $user_id){
          $this->toggle_user($user_id);
        }
    }

    if(isset($_GET['sex']) && !empty($_GET['user_id'])) {
        $this->db->query(sql_placeholder("UPDATE users SET sex = ? WHERE user_id = '?';", intval($_GET['sex']), intval($_GET['user_id'])));
    }

    if ( isset($_GET['call_user']) && isset($_GET['status']) && isset($_GET['phone_number']) ) {
        luser::save_call_status($_GET['call_user'], $_GET['status'], $_GET['phone_number']);
        die('ok');
    }

    if( isset($_GET['delete_user']) ) {
        $user_id = intval($_GET['delete_user']);
        $user_orders_num = $this->db->result(sql_placeholder("SELECT count(*) as count FROM orders WHERE user_id = ? AND status = 2  LIMIT 1", $user_id));
        if ($user_orders_num->count) {
          $this->error_msg = 'Нельзя удалить пользователя, имеющего выполненные заказы';
        }
        else {
          $this->db->query(sql_placeholder("DELETE FROM users WHERE user_id =?", $user_id));
          $get = $this->form_get(array());
          header("Location: index.php$get");
          die();
        }
    }
  }



    protected function _get_where( $params, $type = 'sms' ) {
        $where = " u.name <> '' " . ( $type == 'sms' ? " AND u.phone_number NOT LIKE '%,%' AND LENGTH( u.phone_number ) > 6 " : " AND u.email <> '' " );

        if ( $type == 'sms' ) {
            $where .= " AND u.stop_sms = '0' ";
        }
        else {
            $where .= " AND u.stop_email = '0' ";
        }

        if ( !empty($params['sex']) ) {
            $params['sex'] = (int)$params['sex'];
            $where .= " AND u.sex IN ('{$params['sex']}','0') ";
        }
        if ( isset($params['shop']) && is_array($params['shop']) ) {
            $shops = array();
            foreach ( $params['shop'] as $shop=>$v) {
                $shops[] = mysql_real_escape_string($shop);
            }
            $shop_ids = "'" . implode("', '", $shops) . "'";
            if ( !empty($shop_ids) ) {
                $where .= " AND u2s.shop_id IN ({$shop_ids}) ";
            }
        }
        $city_ids = array();
        if ( isset($params['city']) && is_array($params['city']) ) {
            $city_ids = array();
            foreach ( $params['city'] as $city_id=>$v) {
                $city_ids[] = (int)$city_id;
            }
            $city_ids = implode(',', $city_ids);
            if ( !empty($city_ids) ) {
                $where .= " AND city_id IN ({$city_ids}) ";
            }
        }
        if ( isset($params['brand']) && is_array($params['brand']) ) {
            $users_ids = array();
            foreach ( $params['brand'] as $brand_id=>$v) {
                $user = new luser();
                $users = $user->get_users_for_brand( $brand_id );
                if ( is_array($users) && count($users) ) foreach ($users as $user) {
                    $users_ids[$user->user_id] = true;
                }
            }
            $users_ids = implode(',', array_keys($users_ids));
            if ( !empty($users_ids) ) {
                $where .= " AND original_user_id IN ({$users_ids}) ";
            }
        }
        if ( isset($params['sum_min']) && $params['sum_min'] > 0 ) {
            $where .= " AND u.purchase_sum_real >= {$params['sum_min']} ";
        }
        return $where;
    }



  public function fetch()
  {
    if ( luser::is_allowed_section('Users') || luser::is_allowed('accountant') || luser::is_allowed('admin') || isset($_GET['calls']) && luser::is_allowed('moderator') ) { /* Доступ разрешен */}
    else { header('Location: /'); exit(); }

    $this->smarty->assign("shops", $this->db->results("SELECT s.shop_id, s.name FROM shops s WHERE EXISTS (SELECT * FROM users2shops u2s WHERE u2s.shop_id = s.shop_id)"));
    if ( isset($_GET['sms']) || isset($_GET['email']) || isset($_GET['push']) ) {
      // Список городов
      $l_cities = $this->db->results("SELECT DISTINCT city_id, city FROM users WHERE 1 ORDER BY city;");
      $city_keys = array();
      foreach ($l_cities as $k => $v) {
        $city_keys[$v->city_id] = $v->city;
      }
      $this->smarty->assign('cities', $l_cities);

      // Список брендов
      $l_brands = $this->db->results("SELECT * FROM brands ORDER BY name");
      $brand_keys = array();
      foreach ($l_brands as $k => $v) {
        $brand_keys[$v->brand_id] = $v->name;
      }
      $this->smarty->assign('brands', $l_brands);
    }


    if ( isset($_GET['sms']) || isset($_GET['email']) ) {
        set_time_limit(0);

        // История рассылок
        $sms_history = $this->db->results("SELECT * FROM sms_history WHERE 1 ORDER BY date DESC;");
        foreach ($sms_history as $k => $v) {
            $sms_info = json_decode($v->post, true);
            $sms_history[$k]->sender    = $sms_info['sender'];
            $sms_history[$k]->sex       = $sms_info['sex'];
            $sms_history[$k]->sum_min   = $sms_info['sum_min'];
            $sms_history[$k]->shop      = implode(", ", array_keys($sms_info['shop']));
            $sms_info['city'] = array_keys($sms_info['city']);
            foreach ($sms_info['city'] as $key => $value) {
                $sms_info['city'][$key] = $city_keys[$value];
            }
            $sms_history[$k]->city = implode(", ", $sms_info['city']);
            $sms_info['brand'] = array_keys($sms_info['brand']);
            foreach ($sms_info['brand'] as $key => $value) {
                $sms_info['brand'][$key] = $brand_keys[$value];
            }
            $sms_history[$k]->brand     = implode(", ", $sms_info['brand']);
            $sms_history[$k]->message   = $sms_info['message'];
            $admin = $this->db->result("SELECT * FROM users WHERE user_id = {$v->admin_id} LIMIT 1");
            $sms_history[$k]->admin     = $admin->name;
        }
        $this->smarty->assign('sms_history', $sms_history);

        if ( ( isset($_POST['message']) && !empty($_POST['message']) || isset($_GET['only_people']) ) || isset($_GET['repeat']) ) {
            $post = $_POST;
            if (isset($_GET['repeat'])) {
                $post = json_decode($this->db->result("SELECT post FROM sms_history WHERE id = ".$_GET['repeat']));
            }
            $where = $this->_get_where( $post, isset($_GET['email']) ? 'email' : 'sms' );

            if ( isset($_POST['no_limit']) || isset($_GET['no_limit']) ) {
                $sms_limit = '';
            }
            else {
                $sms_limit = ' AND u.last_sms_send < DATE_SUB(NOW(), INTERVAL 1 DAY) ';
            }

            if ( isset($_GET['only_people']) ) {
                $tmp = $this->db->result(" SELECT count(DISTINCT u.original_user_id) as count FROM `users` u LEFT JOIN users2shops u2s ON u.user_id = u2s.user_id WHERE {$where} {$sms_limit} ORDER BY u.user_id ASC; ");
                die('' . $tmp->count);
            }
            $users = $this->db->results(" SELECT * FROM `users` u LEFT JOIN users2shops u2s ON u.user_id = u2s.user_id WHERE {$where} {$sms_limit} GROUP BY u.original_user_id ORDER BY u.user_id ASC; ");
            if (is_array($users) && count($users) > 0) {
                $message = $post['message'];
                setcookie('LAST_SPAM_SEND', time(), time()+60*60*24*365, '/');

                if ( isset($_GET['sms']) ) {
                    if ($_POST['test_phone']) {
                        $args = array( 'phone_number' => $_POST['test_phone'], 'sender' => 'lsboutique', 'message_text' => $message, 'sms_id' => null, 'sms_only' => 1 );
                        if ($post['ignore_stop_sms']) {
                            $args['ignore_stop_sms'] = 1;
                        }
                        Job::push( 'SmsJob', $args );
                        die('OK');
                    }
                    elseif (isset($_GET['repeat'])) {
                        $sms_id = (int)$_GET['repeat'];
                    }
                    elseif ($_POST['date_time']) {
                        unset($post['date_time']);
                        $this->db->query("INSERT INTO sms_history (post, admin_id, clients_count, `date`) VALUES ('".addslashes(json_encode($post))."', ".$_SESSION['user']->user_id.", ".count($users).", '".$_POST['date_time']."')");
                        $sms_id = $this->db->insert_id();
                    }
                    else {
                        $this->db->query("INSERT INTO sms_history (post, admin_id, clients_count) VALUES ('".addslashes(json_encode($post))."', ".$_SESSION['user']->user_id.", ".count($users).")");
                        $sms_id = $this->db->insert_id();
                    }
                }

                if (isset($_POST['test'])) {
                     $users = $this->db->results(" SELECT * FROM `users` u LEFT JOIN users2shops u2s ON u.user_id = u2s.user_id WHERE u.user_id= {$_SESSION['user']->user_id} GROUP BY u.original_user_id ORDER BY u.user_id ASC; ");
                     if ( !empty($_POST['admin_email']) ) {
                       $users[0]->email = $_POST['admin_email'];
                     }
                 }

                foreach ( $users as $user ) {
                    $name = explode(' ', $user->name);
                    $phone = substr($user->phone_number, -10);
                    $short_cardnumber = substr($user->card_number, -5);
                    $LogLink = "www.lsboutique.ru/slog/{$phone}/{$short_cardnumber}";

                    $message_text = str_replace(array(' , '), '', str_replace(array('{USERNAME}', '{CARDNUMBER}', '{ENTER}'), array($name[0], $short_cardnumber, $LogLink), $message));
                    if ( !empty($post['subject']) ) {
                        $s = str_replace(array('{USERNAME}', '{USEREMAIL}', '{USERPHONE}', '{CARDNUMBER}'),'', $post['subject']);
                        $s = trim(preg_replace("/\s+/", ' ', $s)); // убираем лишние пробелы
                        $s = function_exists('mb_strtolower') ? mb_strtolower($s) : strtolower($s); // переводим в нижний регистр
                        $s = strtr($s, array('а'=>'a','б'=>'b','в'=>'v','г'=>'g','д'=>'d','е'=>'e','ё'=>'e','ж'=>'j','з'=>'z','и'=>'i','й'=>'y','к'=>'k','л'=>'l','м'=>'m','н'=>'n','о'=>'o','п'=>'p','р'=>'r','с'=>'s','т'=>'t','у'=>'u','ф'=>'f','х'=>'h','ц'=>'c','ч'=>'ch','ш'=>'sh','щ'=>'shch','ы'=>'y','э'=>'e','ю'=>'yu','я'=>'ya','ъ'=>'','ь'=>''));
                        $s = str_replace(" ", "-", preg_replace("/[^0-9a-z-_ ]/i", "", $s)); // заменяем неправильные символы
                    }
                    $utms = "utm_source=email&utm_medium=email&utm_campaign=email_list-hand-picked|reason-{$s}|date-".date('Y-m-d')."&utm_content=intext-link";
                    $pattern = '/(href=\"([^\"]*)\")/isU';
                    $message_text = preg_replace_callback ($pattern,
                        function ($matches) use ($utms){
                            return 'href="'.$matches[2].((strpos($matches[2], '?') !== false) ? '&' : '?').$utms.'"';
                        }, $message_text);

                    if ( isset($_GET['sms']) ) {
                        $sender = isset($post['sender']) ? $post['sender'] : 'lsboutique';
                        $args   = array( 'user_id' => $user->user_id, 'sender' => $sender, 'message_text' => $message_text, 'sms_id' => $sms_id );
                        if ($post['ignore_stop_sms']) {
                            $args['ignore_stop_sms'] = 1;
                        }
                        if ($_POST['date_time']) {
                            $time = strtotime($_POST['date_time']);
                            Job::push( 'SmsJob', $args, $time );
                        }
                        else {
                            Job::push( 'SmsJob', $args );
                        }
                    }
                    if ( isset($_GET['email']) && !empty($post['subject']) ) {
                        $subject = str_replace(array('{USERNAME}', '{USEREMAIL}', '{USERPHONE}', '{CARDNUMBER}'),
                            array($name[0], $user->email, $user->phone_number, $user->card_number ), $post['subject']);

                        $args = array(
                            'user_id'               => $user->user_id,
                            'email'                 => $user->email,
                            'subject'               => $subject,
                            'from'                  => $this->config->support_email,
                            'message_text'          => $message_text,
                            'site'                  => "https://{$_SERVER['HTTP_HOST']}",
                            'order_manager'         => $this->config->support_name,
                            'order_manager_email'   => $this->config->support_email,
                            'content'               => $message_text,
                            'subject'               => $subject,
                            'utms'                  => $utms,
                            'user_phone'            => $user->phone_number,
                            'user_phone_number'     => $user->phone_number,
                            'user_card_number'      => $user->card_number
                        );

                        if ($_POST['sender_email']) {
                            if ( !empty($_POST['sender_name']) ) {
                              $args['from'] = $_POST['sender_name'] . " <{$_POST['sender_email']}>";
                            }
                            else {
                              $args['from'] = "Luxury Store <{$_POST['sender_email']}>";
                            }
                        }

                        if ($_POST['date_time']) {
                          $time = strtotime($_POST['date_time']);
                          Job::push( 'EmailNewsletterJob', $args, $time );
                        }
                        else {
                            Job::push( 'EmailNewsletterJob', $args );
                        }
                    }
                }
            }

            // Проверка доставки СМС админу
            if ( isset($_GET['sms']) ) {
                $admin_args = array( 'user_id' => 1334, 'sender' => $sender, 'message_text' => "Рассылка: {$message}", 'sms_id' => $sms_id );
                if ($_POST['date_time']) {
                    $datetime = new DateTime($_POST['date_time']);
                    Job::push( 'SmsJob', $args, $datetime );
                }
                else {
                    Job::push( 'SmsJob', $admin_args );
                }
            }


            echo "<script> window.location.href='/admin/index.php?section=Users&" . (isset($_GET['sms']) ? "sms" : "email") . "&sended=" . count($users) . "'</script>";die();
            die();
        }
        if ( isset($_GET['sended']) ) {
            $this->smarty->assign('sended', $_GET['sended']);
        }
        if ( isset($_GET['email']) ) {
            $this->smarty->assign('email', true);
            $this->smarty->assign('Modernjs', 'true');

            $brands_new = $this->db->results("SELECT b.brand_id, b.name FROM products p LEFT JOIN brands b ON b.brand_id = p.brand_id WHERE p.photo_added >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) GROUP BY b.brand_id");
            $this->smarty->assign('brands_new', $brands_new);
            $new_items = [];
            foreach ($brands_new as $b) {
              $new_items[$b->name] = $this->db->results("SELECT model, large_image, url, sex FROM products WHERE brand_id = {$b->brand_id} AND large_image != '' AND photo_added >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)");
            }
            $new_items['Меха'] = $this->db->results("SELECT p.model, p.large_image, p.url, p.sex FROM products p LEFT JOIN brands b ON b.brand_id = p.brand_id WHERE b.fur_brand = 1 ORDER BY p.photo_added DESC LIMIT 60");
            $this->smarty->assign('new_items', json_encode($new_items));

            $specials = $this->db->results("SELECT * FROM specials WHERE enabled = 1 AND urls != '' ORDER BY special_id DESC");
            $this->smarty->assign('specials', $specials);
            $special_items = [];
            foreach ($specials as $sp) {
              if ($sp->look_special) {
                $special_items[$sp->special_id] = $this->db->results("SELECT p.model, s.image as large_image, s.id as url, p.sex FROM sets s LEFT JOIN products p ON p.product_id = s.main_product_id WHERE s.id IN ({$sp->urls})");
              }
              else {
                $urls = explode(",", $sp->urls);
                $p_ids = [];
                foreach ($urls as $url) {
                  preg_match("/'(\d+).*/", $url, $m);
                  $p_ids[] = $m[1];
                }
                $p_id_str = trim(implode(",", $p_ids), ",");
                $special_items[$sp->special_id] = $this->db->results("SELECT model, large_image, url, sex FROM products WHERE product_id IN ({$p_id_str})");
                // $special_items[$sp->special_id] = $p_id_str;
              }
            }
            $this->smarty->assign('special_items', json_encode($special_items));

            $js = $this->smarty->fetch('users_emails.js.tpl');
            $this->smarty->assign('JavaScript', $js);
            $this->body = $this->smarty->fetch('users_emails.tpl');
        }
        else {
            $this->body = $this->smarty->fetch('users_sms.tpl');
        }

    }
    elseif ( isset($_GET['push']) ) {
        if (isset($_POST['message'])) {
            $sessions = $this->db->results("SELECT * FROM app_sessions WHERE 1;");
            if (isset($_POST['admin_only'])) {
                $sessions = $this->db->results("SELECT a_s.* FROM app_sessions a_s LEFT JOIN users u ON a_s.user_id = u.user_id WHERE u.group_id = 2;");
            }
            foreach ($sessions as $session) {
                $args = array('message' => $_POST['message'], 'platform' => $session->platform, 'token' => $session->push_token);
                if ($_POST['date_time']) {
                    $datetime = strtotime($_POST['date_time']);
                    Job::push( 'PushJob', $args, $datetime );
                }
                else {
                    Job::push( 'PushJob', $args );
                }
            }
            $this->smarty->assign('sended', count($sessions));
        }
        $this->smarty->assign('Modernjs', 'true');
        $js = $this->smarty->fetch('users_push.js.tpl');
        $this->smarty->assign('JavaScript', $js);
        $this->body = $this->smarty->fetch('users_push.tpl');
    }
    else {
        $this->title    = $this->lang->USERS;
        $current_page   = $this->param('page');
        $start_item     = $current_page*$this->items_per_page;
        $keyword        = mysql_real_escape_string($this->param('keyword'));
        $group_id       = $this->param('group');
        if ( !luser::is_allowed('admin') ) {
            $group_id = 1;
        }

        if (isset($_POST['call_name'])) {
            if (is_array($_POST['call_brands']) && count($_POST['call_brands'])>0) {
                $call_brands = implode(",",$_POST['call_brands']);
            }
            else {
                $call_brands = '';
            }
            $query = sql_placeholder("INSERT INTO users_calls (user_id,name,date,sex,shop,brands,sum_min)
                VALUES (?,?,NOW(),?,?,?,?,?)",
                $_SESSION['user']->user_id,
                $_POST['call_name'],
                $_POST['sex'],
                $_POST['shop'],
                $call_brands,
                $_POST['sum_min']);
            $this->db->query($query);
        }

        $order  = "ORDER BY last_active_date DESC";
        $filter = " users.name <> '' ";

        if ( isset($_GET['calls']) ) {
            $group_id = 1;
            $ucalls = $this->db->results("SELECT * FROM users_calls WHERE 1");
            foreach ($ucalls as $k=>$v) {
                $ucalls[$k]->brands = $this->db->results("SELECT * FROM brands WHERE brand_id IN ({$v->brands})");
            }
            $this->smarty->assign('users_calls', $ucalls);
            $filter .= " AND users.enabled = '1' AND users.new_user_database = '1' AND users.user_id = users.original_user_id AND ( users.phone_number <> '' AND LENGTH( users.phone_number ) < 12 ) ";
            $order  = "ORDER BY last_phone_call_status, last_phone_call, users.name ";
            $this->add_param('calls');
            $this->add_param('sex');
            $this->add_param('shop');
            $this->add_param('brand');
        }

        if ( isset($_GET['call_id']) ) {
            $call_id = (int) $_GET['call_id'];
            $call = $this->db->result("SELECT * FROM users_calls WHERE id = {$call_id}");
            $this->smarty->assign('call', $call);
            $order  = "ORDER BY last_phone_call_status, last_phone_call, users.name ";
            $filter .= " AND users.enabled = '1'
                AND users.new_user_database = '1'
                AND users.group_id = '1'
                AND users.user_id = users.original_user_id
                AND ( users.phone_number <> '' AND LENGTH( users.phone_number ) < 12 ) ";
            if(!empty($call->sex))
                $filter .= " AND users.sex = '{$call->sex}' ";
            if(!empty($call->shop))
                $filter .= " AND users.shop = '{$call->shop}' ";
            if (!empty($call->sum_min) && !empty($call->sum_max)) {
                $filter .= " AND users.purchase_sum BETWEEN '{$call->sum_min}' AND '{$call->sum_max}' ";
            }
            elseif (!empty($call->sum_min) && empty($call->sum_max)) {
                $filter .= " AND users.purchase_sum > '{$call->sum_min}' ";
            }
            elseif (empty($call->sum_min) && !empty($call->sum_max)) {
                $filter .= " AND users.purchase_sum < '{$call->sum_max}' ";
            }
        }

        if ( !empty($group_id) ) {
            $filter .= " AND ( users.group_id = '{$group_id}' ) ";
        }
        if (!empty($keyword)) {
            $keywords = explode(' ', str_replace(array('-',')','(','+','?'), '', trim($keyword)));
            foreach($keywords as $keyword){
              $f[] = " (  users.name LIKE '%$keyword%' OR users.email LIKE '%$keyword%' OR
                                users.city LIKE '%$keyword%' OR users.adress LIKE '%$keyword%' OR
                                users.card_number LIKE '%$keyword%' OR users.phone_number LIKE '%$keyword%' ) ";
            }
            
            $filter .= " AND (" . implode(' OR ', $f) . ")";
        }

        $join = '';
        if ( $this->param('with_out_shop') || $this->param('shop') ) {
            if ( $this->param('shop') ) {
                $shop        = mysql_real_escape_string( $this->param('shop') );
                $filter     .= " AND ( users2shops.shop_id = '{$shop}' ) ";
                $this->smarty->assign('sshop', $shop);
            }
            if ( $this->param('with_out_shop') ) {
                $filter .= " AND ( users2shops.shop_id IS NULL ) ";
                $this->smarty->assign('with_out_shop', 'checked="checked"');
            }
            $join .= ' LEFT JOIN users2shops  ON users2shops.user_id = users.user_id ';
        }
        if ( $this->param('city') ) {
            $city        = (int)$this->param('city');
            $filter     .= " AND ( users.city_id = '{$city}' ) ";
            $this->smarty->assign('city', $city);
        }
        if ( $this->param('sex') ) {
            $sex = (int)$this->param('sex');
            $filter .= " AND ( users.sex = '{$sex}' ) ";
            $this->smarty->assign('sex', $sex);
        }
        if ( $this->param('with_out_sex') ) {
            $filter .= " AND ( users.sex = '0' ) ";
            $this->smarty->assign('with_out_sex', 'checked="checked"');
        }

        if ( $this->param('with_out_phone') ) {
            $filter .= " AND ( LENGTH( users.phone_number ) > 12 ) ";
            $this->smarty->assign('with_out_phone', 'checked="checked"');
        }
        if ( $this->param('info_1c') ) {
            $filter .= " AND ( clothing_size <> '' ) ";
            $this->smarty->assign('info_1c', 'checked="checked"');
        }
        if ( $this->param('last_purchase') ) {
            $p = (int)$this->param('last_purchase');
            $date = date('Y-m-d', strtotime("-{$p} days")) . ' 00:00:00';
            $filter .= " AND ( orders.status = 5 ) ";
            $hav_filter = " HAVING (MAX(orders.date)<'{$date}' OR MAX(orders.last_update)<'{$date}')";
            $this->smarty->assign('last_purchase', $p);
        }
        if ( $this->param('have_orders') ) {
            $filter .= " AND ( orders.status != 3 ) ";
            $this->smarty->assign('have_orders', 'checked="checked"');
        }
        if ( $this->param('have_calls') ) {
            $hav_filter .= (!isset($hav_filter) || empty($hav_filter)) ? " HAVING" : " AND";
            $p = (int)$this->param('have_calls');
            $date = date('Y-m-d', strtotime("-{$p} days")) . ' 00:00:00';
            $filter .= " AND ( calls_log.status = 1 ) ";
            $join .= ' LEFT JOIN calls_log ON calls_log.user_id = users.user_id ';
            $hav_filter .= " MAX(calls_log.date)<'{$date}'";
            $this->smarty->assign('have_calls', $p);
        }
        if ( $this->param('logined') ) {
            $p = (int)$this->param('logined');
            $date = date('Y-m-d', strtotime("-{$p} days")) . ' 00:00:00';
            $filter .= " AND ( users.last_login_date <'{$date}' AND users.last_api_login_date <'{$date}' ) ";
            $this->smarty->assign('logined', $p);
        }


        if ( $this->param('brand') ) {
            $brand_id = (int)$this->param('brand');
            $filter .= " AND ( users2brands.brand_id = '{$brand_id}' ) ";
            $this->smarty->assign('brand_id', $brand_id);
            $join .= ' LEFT JOIN users2brands ON users2brands.user_id = users.user_id ';
        }
        if ( $this->param('stars') ) {
            $stars = (int)$this->param('stars');
            if ($stars == 3){$p_sum = 1500000;}
            elseif ($stars == 2){$p_sum = 900000;$p_sum_max = 1500000;}
            elseif ($stars == 1){$p_sum = 300000;$p_sum_max = 900000;}
            if($p_sum_max){
                $filter .= " AND ( users.purchase_sum_real > '{$p_sum}') AND ( users.purchase_sum_real < {$p_sum_max} ) ";
            }
            else{
                $filter .= " AND ( users.purchase_sum_real > '{$p_sum}' ) ";
            }
            $this->smarty->assign('stars', $stars);
        }
        if ( $this->param('p_manager') ) {
            $p_manager = $this->param('p_manager') != 'none' ? (int)$this->param('p_manager') : 0;
            $filter .= " AND ( users.p_manager_id = '{$p_manager}' ) ";
            $this->smarty->assign('p_manager_id', $this->param('p_manager'));
        }
        if ( $this->param('user_status') ) {
            $status = mysql_real_escape_string($this->param('user_status'));
            $filter .= " AND ( users.user_status = '{$status}' ) ";
            $this->smarty->assign('U_Status', $status);

        }

        if ( $this->param('big_size') ) {
            $filter .= " AND EXISTS (SELECT 1 FROM orders_products WHERE status = 5 AND users.user_id = user_id AND size IN ('54', '56', '58', '60', '62', 'XXXL', '3XL', '4XL', '5XL')) ";
            $this->smarty->assign('big_size', 'checked="checked"');
        }

        if ( $_SESSION['user']->group_id != 2 ) {
          $filter .= " AND users.group_id = 1 ";
        }

        $query = "SELECT SQL_CALC_FOUND_ROWS GREATEST(users.last_login_date,orders.date, users.last_api_login_date) AS last_active_date, users.*, groups.name as group_name, COUNT(orders.order_id) as orders_num, PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'),DATE_FORMAT(users.card_registered,'%Y%m')) AS user_age, app_tracking.id AS track_id
                    FROM users LEFT JOIN groups ON groups.group_id = users.group_id
                    LEFT JOIN orders ON orders.user_id = users.user_id
                    LEFT JOIN app_tracking ON app_tracking.user_id = users.user_id
                    {$join}
                  WHERE {$filter}
                  GROUP BY users.original_user_id {$hav_filter}
                  {$order}
                  LIMIT {$start_item} ,{$this->items_per_page} ";
        $users = $this->db->results($query);
        $pages_num = $this->db->result("SELECT FOUND_ROWS() as count;");
        $pages_num = $pages_num->count/$this->items_per_page;
        $enabled_users = array();
        $disabled_users = array();

        foreach ($users as $key=>$user) {
           $users[$key]->edit_get   = $this->form_get(array('user_id'       => $user->user_id, 'section'=>'User'));
           $users[$key]->enable_get = $this->form_get(array('enable'        => $user->user_id));
           $users[$key]->delete_get = $this->form_get(array('delete_user'   => $user->user_id));
           if(substr($user->last_login_date, 0, 4) != '0000') $users[$key]->last_login_date = (substr($user->last_login_date, 0, 4) == date("Y")) ? $this->rus_date("j F H:i", strtotime($user->last_login_date)) : $this->rus_date("j F Y H:i", strtotime($user->last_login_date));
           else $users[$key]->last_login_date = 0;
           if(substr($user->last_api_login_date, 0, 4) != '0000') $users[$key]->last_api_login_date = (substr($user->last_api_login_date, 0, 4) == date("Y")) ? $this->rus_date("j F H:i", strtotime($user->last_api_login_date)) : $this->rus_date("j F Y H:i", strtotime($user->last_api_login_date));
           else $users[$key]->last_api_login_date = 0;


           $purchase_sum_off = (int)$this->db->result("SELECT SUM(sum_with_discount) as sum FROM prodazhi WHERE user_id = '{$user->user_id}'")->sum;
           $purchase_sum_online = (int)$this->db->result(sql_placeholder("SELECT SUM(price) AS sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.user_id = ? AND op.status = 5 AND receipt_number = 0", $user->original_user_id))->sum;
           $purchase_sum_off += (int)$this->db->result(sql_placeholder("SELECT SUM(price) AS sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.user_id = ? AND receipt_number != 0", $user->original_user_id))->sum;
           $users[$key]->total_purchase_sum = $purchase_sum_off + $purchase_sum_online;
           if($user->purchase_sum_real > $users[$key]->total_purchase_sum){
                $users[$key]->total_purchase_sum = $user->purchase_sum_real;
            }
            $users[$key]->messengers = explode(', ',$user->pref_messenger);
            $users[$key]->clothing_size = str_replace('#', '<br>', $users[$key]->clothing_size);

            if($user->superuser == 0 && $user->group_id != 1 && isset($_GET['group'])){
              if ($user->enabled == 1) $enabled_users[]=$user->user_id;
              if ($user->enabled == 0) $disabled_users[]=$user->user_id;
            }
        }
        $enabled_users = !empty($enabled_users) ? $this->form_get(array('mass_enable' => implode(',',$enabled_users))) : 0;
        $disabled_users = !empty($disabled_users) ? $this->form_get(array('mass_enable' => implode(',',$disabled_users))) : 0;

        $this->db->query("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 5 ORDER BY name;");
        $managers = $this->db->results();

        $statuses = array('VIP','хороший','Shopper','low cost','мутный','вредитель');

        $this->smarty->assign('delivery_cities_main', $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY CASE WHEN city_name = 'Нижний Новгород' THEN 1 ELSE 2 END, city_name;"));
        //$this->smarty->assign('delivery_cities',      $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '0' ORDER BY city_name;"));
        $this->smarty->assign('Messengers', $this->db->results("SELECT * FROM messengers WHERE name != ''"));
        $this->smarty->assign('shops',    $this->db->results("SELECT * FROM shops s WHERE EXISTS (SELECT * FROM users2shops u2s WHERE u2s.shop_id = s.shop_id)"));
        $this->smarty->assign('Managers', $managers);
        $this->smarty->assign('Statuses', $statuses);
        $this->smarty->assign('Users', $users);
        $this->smarty->assign('enabled_users', $enabled_users);
        $this->smarty->assign('disabled_users', $disabled_users);
        $this->smarty->assign('brands', $this->db->results("SELECT * FROM `brands` ORDER BY name;"));
        $this->smarty->assign('Groups', $this->db->results('SELECT * FROM groups'));
        $this->pages_navigation->fetch($pages_num);
        $this->smarty->assign('PagesNavigation', $this->pages_navigation->body);

        if (isset($_GET['calls'])) {
            $this->body = $this->smarty->fetch('users_calls.tpl');
        }
        elseif (isset($_GET['call_id'])) {
            $this->body = $this->smarty->fetch('users_call_id.tpl');
        }
        elseif (isset($_GET['new_call'])) {
            $this->body = $this->smarty->fetch('users_new_call.tpl');
        }
        else {
            if (luser::is_allowed('copywriter')){ header('Location: /admin/index.php?section=Users&email'); exit(); }
            $this->body = $this->smarty->fetch('users.tpl');
        }
    }
  }
}
