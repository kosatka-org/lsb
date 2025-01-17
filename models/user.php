<?php
require_once "database_helper.php";
require_once 'email_template.php';

class luser extends database_helper {
    protected $_product_locations = false;
    protected $_sum_of_buy = 0;

    static protected $_sum_of_buy_cache;

    public function __construct($id = 0, $data = NULL) {
        database_helper::database_helper(NULL, 'users', false);
        $this->id_name  = 'user_id';
        $this->table    = 'users';
        if (!empty($data)) {
            $this->data = $data;
        }
        elseif ( !empty($id) ) {
            $this->load_data($id);
        }
    }


    public function change_avatar( $user_id, $avatar ) {
        $user_id = (int)$user_id;
        if ( empty($user_id) || empty($avatar)) return false;
        foreach (glob("files/avatars/" . $user_id . ".*") as $filename) {
            unlink($filename); // Аватарка может быть только одна
        }
        foreach (glob("reimg/files/avatars/*/" . $user_id . ".*") as $filename) {
            unlink($filename); // Аватарка может быть только одна
        }
        $avatar_name = $user_id;

        // добавляем расширение к файлу
        switch($avatar['type']) {
            case 'image/pjpeg': $avatar_name.=".jpg"; break;
            case 'image/jpeg': $avatar_name.=".jpg"; break;
            case 'image/gif': $avatar_name.=".gif"; break;
            case 'image/png': $avatar_name.=".png"; break;
        }
        $avatar_way = "files/avatars/".$avatar_name; // путь к файлу
        $avatar_way_re_small = "reimg/files/avatars/25px/".$avatar_name; // reimg для шапки
        $avatar_way_re_big = "reimg/files/avatars/200px/".$avatar_name; // reimg для корзины
        copy($avatar['tmp_name'], $avatar_way); // сохраним файл на сервер

        $this->db->query(" UPDATE `users` SET photo = '/{$avatar_way_re_big}', photo_rec = '/{$avatar_way_re_small}' WHERE original_user_id = '{$user_id}'; ");
        return true;
    }



    public function delete_avatar( $user_id ) {
        $user_id = (int)$user_id;
        if ( empty($user_id) ) return false;
        foreach (glob("files/avatars/" . $user_id . ".*") as $filename) {
            unlink($filename); // Аватарка может быть только одна
        }
        foreach (glob("reimg/files/avatars/*/" . $user_id . ".*") as $filename) {
            unlink($filename); // Аватарка может быть только одна
        }
        $this->db->query(" UPDATE users SET photo = '', photo_rec = '' WHERE original_user_id = '{$user_id}'; ");
        return true;
    }



    public function do_not_disturb( $user_id, $type = 'sms', $email = '' ) {
        $user_id = mysql_real_escape_string($user_id);
        if ( empty($user_id) ) return false;
        $equery = "";
        if (!empty($email)){$equery = " OR email = '{$email}'";}
        $this->db->query($sql = " UPDATE users SET " .($type == 'sms' ? 'stop_sms' : 'stop_email'). " = '1' WHERE original_user_id = '{$user_id}'{$equery}");
        $type = ($type == 'sms') ? 0 : 1;
        $this->db->query("INSERT INTO stop_list_history (`user_id`, `manager_id`, `type`, `del`)
                            VALUES ('{$user_id}', '{$_SESSION['user']->original_user_id}', '{$type}', 0); ");
        return true;
    }



    public function remove_from_stopList( $user_id, $type = 'sms', $email = '' ) {
        $user_id = mysql_real_escape_string($user_id);
        if ( empty($user_id) ) return false;
        $equery = "";
        if (!empty($email)){$equery = " OR email = '{$email}'";}
        $this->db->query($sql = " UPDATE users SET " .($type == 'sms' ? 'stop_sms' : 'stop_email'). " = '0' WHERE original_user_id = '{$user_id}'{$equery}");
        $type = ($type == 'sms') ? 0 : 1;
        $this->db->query("INSERT INTO stop_list_history (`user_id`, `manager_id`, `type`, `del`)
                              VALUES ('{$user_id}', '{$_SESSION['user']->original_user_id}', '{$type}', 1); ");
        return true;
    }



    public function save_call_status( $user_id, $status = 'call', $phone_number = '', $call_id ) {
        $user_id = (int)$user_id;
        if ( empty($user_id) ) return false;

        $call_id    = (int)$call_id;
        echo $call_id . "\n";
        $caller_id  = !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0;

        global $database_object;
        $database_object->query($sql = " INSERT INTO `users_calls_log` (`user_id`, `call_id`, `status`, `date_created`, `caller_id`) VALUES ('{$user_id}', '{$call_id}', '" .($status == 'call' ? '2' : '1'). "', NOW(), '{$caller_id}') ON DUPLICATE KEY UPDATE status='" .($status == 'call' ? '2' : '1'). "', date_created=NOW(), caller_id='{$caller_id}'; ");

//      $database_object->query(" UPDATE users SET last_phone_call = NOW(), last_phone_call_status = " .($status == 'call' ? '2' : '1'). " WHERE original_user_id = '{$user_id}'");
        // Сохраняем в CRM:
        if ( $status == 'call' ) {
            self::save_to_crm($user_id, 'call', "Cовершил звонок клиенту по номеру: {$phone_number}" );
        }
        else {
            self::save_to_crm($user_id, 'call_failed', "Не дозвонился до клиента по номеру: {$phone_number}" );
        }
        return true;
    }



    public function generate_card_number() {
        return rand(1001, 9999) . '00' . rand(11, 99) . rand(1001, 9999) . rand(101, 999) . '0';
    }



    public function get_from_crm( $params = array() ) {

        $where = ' 1 ';
        if ( !empty($params['user_id']) ) {
            $where .= " AND (";
            $params['user_id'] = (int)$params['user_id'];
            $where .= " u_c.user_id = '{$params['user_id']}' ";
            if ( !empty($params['alt_user_id']) ) {
                $params['alt_user_id'] = (int)$params['alt_user_id'];
                $where .= " OR u_c.user_id = '{$params['alt_user_id']}' ";
            }
            $where .= ") ";
        }
        if ( !empty($params['date_start']) ) {
            $where .= " AND u_c.date >= '{$params['date_start']}' ";
        }
        if ( !empty($params['date_finish']) ) {
            $where .= " AND u_c.date <= '{$params['date_finish']}' ";
        }

        global $database_object;
        return $database_object->get_results("
            SELECT u_c.*, a.name as admin_name, a.group_id as admin_group
              FROM users_crm u_c
              LEFT JOIN users a ON u_c.admin_id = a.user_id
            WHERE {$where}
            ORDER BY u_c.date DESC" .
            ( !empty($params['limit']) ? " LIMIT {$params['limit']} " : '' ) );
    }



    public function save_to_crm( $user_id, $type = '', $subject = '', $text = '' ) {
        global $database_object;
        $user_id    = (int)$user_id;
        if ( empty($user_id) ) return false;

        $type       = mysql_real_escape_string($type);
        $subject    = mysql_real_escape_string($subject);
        $text       = mysql_real_escape_string($text);
        $admin_id   = !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0;

        return $database_object->query("INSERT INTO `users_crm` (`user_id`,    `type`,   `subject`,   `text`,    `admin_id`)
                                                        VALUES ('{$user_id}', '{$type}','{$subject}', '{$text}', '{$admin_id}');");
    }



    public function can_buy_from_site($brand_id = 0, $user_id = 0) {
        if (!$user_id) {
          $user_id = $_SESSION['user']->user_id ? $_SESSION['user']->user_id : $this->get('user_id');
        }
        $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id}");
        $offline_brands = $this->get_offline_brands($user->user_id);
        $is_offline_only = $this->db->result("SELECT * FROM brands WHERE brand_id = {$brand_id}")->offline_only;
        if ($is_offline_only && !in_array($brand_id, $offline_brands)) {
          return false;
        }
        else {
          return true;
        }
    }


    public function get_users_for_brand( $brand_id = 0, $filter_sms_spam = false ) {
        $brand_id = (int)$brand_id;
        if ( empty($brand_id) ) return false;
        $res = $this->db->get_results(
            "SELECT u.* FROM users2brands u2b
            LEFT JOIN users u ON u2b.user_id = u.user_id
            WHERE u2b.brand_id = '{$brand_id}'
              AND u2b.status = 1
              AND u.user_id IS NOT NULL AND u.group_id > 1
            GROUP BY u.original_user_id"
        );
        return $res;
    }



    public function mark_products_as_old_stuff( $brand_id = 0 ) {
        $brand_id = (int)$brand_id;
        if ( empty($brand_id) ) return false;
        return $this->db->query("UPDATE `products` SET new_stuff = '1' WHERE brand_id = '{$brand_id}'");
    }



    public function get_products_for_brand( $brand_id = 0 ) {
        $brand_id = (int)$brand_id;
        if ( empty($brand_id) ) return false;
        return $this->db->get_results( $sql = "
            SELECT *, '' AS `size` FROM `products` p
            WHERE p.`created` > '" . date('Y-m-d', time() - 60*60*24*8*2) . "' AND p.new_stuff = '0' AND ( p.large_image <> '' OR p.small_image <> '' ) AND brand_id = '{$brand_id}'
            ORDER BY p.`created` DESC
        ");
    }



    public function get_products_by_ids( $ids = array() ) {
        if ( !is_array($ids) || count($ids) == 0 ) return false;
        $ids = trim(str_replace(',,', ',', implode($ids, ',')), ',');

        return $this->db->get_results($sql = "SELECT *, '' AS `size` FROM `products` p WHERE product_id IN ({$ids}) ");
    }



    public function get_brands_with_updates() {
        return $this->db->get_results( $sql = "
            SELECT b . * , count( * ) AS count
              FROM `products` p
              LEFT JOIN brands b ON b.brand_id = p.brand_id
            WHERE p.`created` > '" . date('Y-m-d', time() - 60*60*24*8*2) . "' AND p.new_stuff = '0' AND ( p.large_image <> '' OR p.small_image <> '' )
            GROUP BY `brand_id` HAVING count > 5
        ");
    }



    public function get_wishlist_discount() {
        $tmp = $this->db->get_results("
            SELECT u2w. * , p.price AS new_price, op.id
              FROM `users2wishlist` AS u2w
              LEFT JOIN products AS p ON u2w.product_id = p.product_id
              LEFT JOIN orders_products AS op ON u2w.product_id = op.product_id AND u2w.user_id = op.user_id
            WHERE 100 * ( u2w.price - p.price ) / u2w.price > 10
              AND p.size != ''
              AND p.price > 0
              AND op.id IS NULL
            GROUP BY u2w.product_id, u2w.user_id
        ");
        $res = array();
        if ( is_array($tmp) && count($tmp) ) {
            foreach ( $tmp as $u2w ) {
                $res[$u2w->user_id][$u2w->product_id] = $u2w->price;
            }
        }
        $this->db->get_results("UPDATE `users2wishlist` u2w SET u2w.price = (SELECT price FROM products p WHERE p.product_id = u2w.product_id) WHERE 1;");
        return $res;
    }



    public function get_viewed_discount() {
        $tmp = $this->db->get_results("
            SELECT pv.*, p.price AS new_price
              FROM `product_views` AS pv
              LEFT JOIN products AS p ON pv.product_id = p.product_id
              LEFT JOIN orders_products AS op ON pv.product_id = op.product_id AND pv.user_id = op.user_id
            WHERE pv.product_id IS NOT NULL
              AND pv.user_id IS NOT NULL
              AND 100 * ( pv.price - p.price ) / pv.price > 10
              AND p.size != ''
              AND p.price > 0
              AND op.id IS NULL
            GROUP BY pv.product_id, pv.user_id
        ");
        $res = array();
        if ( is_array($tmp) && count($tmp) ) {
            foreach ( $tmp as $u2w ) {
                $res[$u2w->user_id][$u2w->product_id] = $u2w->price;
            }
        }
        $this->db->get_results("UPDATE `product_views` u2w SET u2w.price = (SELECT price FROM products p WHERE p.product_id = u2w.product_id) WHERE 1;");
        return $res;
    }



    public function get_last_buy( $user_id = 0 ) {
        $user_id = !empty($user_id) ? (int)$user_id : $this->get('original_user_id');
        if ( empty($user_id) ) return 0;

        $purchase = $this->db->results( $sql = "
            SELECT * FROM (
                (SELECT sum_with_discount as price, p_date as date, model FROM `prodazhi` WHERE user_id = '{$user_id}') UNION
                (SELECT op.price as price, o.date as date, product_name AS model FROM `orders` o LEFT JOIN `orders_products` op ON op.order_id = o.order_id WHERE `user_id` = '{$user_id}' AND op.status = '0' )) as t
            ORDER BY date DESC
        ");
        return $purchase ? $purchase[0] : false;
    }



    public function get_sum_of_buy( $user_id = 0 ) {
        $user_id = !empty($user_id) ? (int)$user_id : (int)$this->get('original_user_id');
        if ( empty($user_id) ) return 0;

        if ( isset(self::$_sum_of_buy_cache[$user_id]) ) return self::$_sum_of_buy_cache[$user_id];
        if ( $this->get('original_user_id') && !empty($this->_sum_of_buy) ) return $this->_sum_of_buy;

        $purchase_sum = (int)$this->db->get_var("
            SELECT SUM( sum_with_discount ) FROM `prodazhi` WHERE user_id = '{$user_id}' LIMIT 1;
        ");
        $purchase_sum_online = (int)$this->db->get_var("
            SELECT SUM( op.price ) FROM `orders` o LEFT JOIN `orders_products` op ON op.order_id = o.order_id   WHERE `user_id` = '{$user_id}' AND op.status = '5'
        ");

        $this->_sum_of_buy = max($purchase_sum, $purchase_sum_online);
        self::$_sum_of_buy_cache[$user_id] = $this->_sum_of_buy;
        return $this->_sum_of_buy;
    }



    public function restore_card_by_phone($phone) {
        $phone = substr($phone, -10); // Берем только последние 10 цифр
        if ( strlen($phone) < 10 ) return false;
        $user  = $this->db->get_row("SELECT * FROM `users` WHERE phone_number LIKE '%{$phone}';");
        return $user ? $user : false;
    }



    public function get_personal_discount( $product, $total_sum = 0, $is_logged_in = 0, $user_id = 0, $admin = false ) {
        return 0;
        if ($product->season == '16/1') {
            if($_SESSION['user']->purchase_sum_real > 0) {
                if ($product->sex == 1) { return 15; }
                else { return 10; }
            }
            else { return 5; }
        }

        // Если товар из ассортимента "Podium VIP"(Лакшери Плаза) или 'Лакшери Этажи'
        $podium = (strpos($product->item_location, 'Podium VIP') !== FALSE || strpos($product->item_location, 'Лакшери Этажи') !== FALSE) ? true : false;
        if ($this->db->result("SELECT COUNT( * ) AS rows FROM brands WHERE low_discount=1 AND brand_id ={$product->brand_id}")->rows) {
            $podium = true;
        }

        // Если пользователь не залогинен
        if ( !$is_logged_in ) return 0;

        // Если на товар не распространяются персональные скидки
        if ( $product->no_discount ) return 0;

        // Если на на товары этого бренда не предусмотрены скидки
        if ($this->db->result("SELECT * FROM brands WHERE brand_id = {$product->brand_id} LIMIT 1")->no_sale) return 0;

        // Стандартная скидка для группы пользователей
        $group_discount = $_SESSION['group']->discount;

        // Персональная скидка пользователя
        $personal_discount = isset($_SESSION['user']->personal_discount) ? (int)$_SESSION['user']->personal_discount : 0;

        if ($admin) {
            $group_discount = 0;
            if ($user_id) {
                $personal_discount = $this->db->result("SELECT personal_discount AS pd FROM users WHERE user_id ={$user_id}")->pd;
            }
            else {
                $personal_discount = 0;
            }
        }

        // Спецскидка 50% для зарегистрированных клиентов
        if ($product->special_sale) {
            $personal_discount = 45;
        }

        // Определение накопительной скидки на товар
        // !Нужно перенести матрицу скидок в базу данных!
        $discount = 0;
        if ( $product ) {
            // Пониженная скидка для "Подиумов"
            if ($podium) {
                $discount_array = array( 100000 => 5,  250000 => 7,  500000 => 10, 900000 => 12, 1500000 => 15 );
                if ( $group_discount > 5 ) {
                    $group_discount = 5;
                }
            }
            else {
                $discount_array = array( 100000 => 10, 250000 => 15, 500000 => 20, 900000 => 25, 1500000 => 30 );
            }

            foreach ( $discount_array as $sum => $d) {
                if ($total_sum > $sum) {
                    $discount = $d;
                }
            }
        }

        return max($group_discount, $personal_discount, $discount);
    }



    public function save_personal_discount( $user_id, $personal_discount = 0, $admin_id = 0 ) {
        $personal_discount = (int)$personal_discount; $user_id = (int)$user_id;
        if ( $personal_discount < 0 || $personal_discount >= 100 ) return false;

        $this->db->query("UPDATE `users` SET personal_discount = '{$personal_discount}' WHERE user_id = '{$user_id}';");

        $user = $this->db->get_row("SELECT * FROM `users` WHERE user_id = '{$user_id}';");
        $admin_name = ($admin_id) ? $this->db->result("SELECT * FROM users WHERE user_id = {$admin_id}")->name : "Неизвестный пользователь";

        $et = new email_template('personal_discount_granted');
        $et ->assign('SITE', "https://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
            ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
            ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
            ->assign('USER_NAME',       $user->name)
            ->assign('MANAGER_NAME',    $admin_name)
            ->assign('USER_CARD',       $user->card_number)
            ->assign('USER_EMAIL',      $user->email)
            ->assign('USER_DISCOUNT',   $user->personal_discount)
            ->send('mail@lsboutique.ru');
        return true;
    }



    // приведение базы к общему знаменателю
    public function serve() {
        $this->db->query("UPDATE `users` SET `phone_number` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`phone_number`, '(', ''), ')', ''), '-', ''), ' ', ''), '+', '');");
        $this->db->query("UPDATE `users` SET password = md5(rand()) WHERE password = '';");
        $this->db->query("UPDATE `users` SET original_user_id = user_id WHERE original_user_id = '0'");
    }



    public function found( $params = array(), $insert = true ) {
        if ( !is_array($params) || count($params) == 0 ) return false;
        // На всякий случай
        $this->db->query("UPDATE users SET original_user_id = user_id WHERE original_user_id = '0'");

        if ( isset($params['phone_number']) ) {
            $params['phone_number'] = str_replace(array('(', ')', '+', ' ', '-'), '', trim($params['phone_number']));
            if($_COOKIE['language'] != 'eng'){$params['phone_number'] = substr(trim($params['phone_number']), -10);}
        }

        // Поищем того же
        $where = '';
        if ( isset($params['card_number']) && isset($params['phone_number']) && strlen($params['card_number']) > 4 && strlen($params['phone_number']) > 9 ) {
            $where .= " OR phone_number LIKE '%" . $this->db->escape($params['phone_number']) . "'
                        AND card_number LIKE '%" . $this->db->escape(trim($params['card_number'])) . "' ";
        }
        elseif ( isset($params['phone_number']) && strlen($params['phone_number']) > 6 && $insert) {
            $where .= " OR (phone_number LIKE '%" . $this->db->escape($params['phone_number']) . "'
                        AND user_id = original_user_id) ";
        }

        if ( isset($params['email']) && isset($params['phone_number']) && strlen($params['email']) > 6 && strlen($params['phone_number']) > 9 ) {
            $where .= " OR phone_number LIKE '%" . $this->db->escape($params['phone_number']) . "'
                              AND email = '" . $this->db->escape(trim($params['email'])) . "' ";
        }
        if ( isset($params['identity']) && isset($params['network']) ) {
            $where .= " OR identity = '" . $this->db->escape(trim($params['identity'])) . "'
                        AND network = '" . $this->db->escape(trim($params['network'])) . "' ";
        }
        if ( isset($params['password']) && !empty($params['password']) && isset($params['user_id']) ) {
            $user_id = (int)$params['user_id'];
            $where .= " OR ( user_id = '{$user_id}' OR original_user_id = '{$user_id}' )
                        AND password = '" . $this->db->escape(trim($params['password'])) . "' ";
        }

        $users = $this->db->get_results($sql = "SELECT * FROM users WHERE 0 {$where}");

        if ( is_array($users) && count($users) > 0 ) {
            $original_user_id = !empty($params['original_user_id']) ? $params['original_user_id']   : $users[0]->original_user_id;
            $group_id         = !empty($params['group_id'])         ? $params['group_id']           : $users[0]->group_id;

            // Склейка аккаунтов, склеиваем только из одинаковых социальных групп
            if ( $original_user_id != $users[0]->original_user_id && $group_id == $users[0]->group_id && $group_id == 1 ) {
                $this->update(array('original_user_id' => $original_user_id), $users[0]->original_user_id);
            }

            if ( $group_id == $users[0]->group_id && $group_id == 1 ) {
                // Обновляем сборный аккаунт, если обычный пользователь
                $this->update_user($original_user_id, $params);
            }
            return $this->data = $this->db->result("SELECT * FROM users WHERE user_id = '{$original_user_id}'");
        }
        else {
            if ($insert) {
                // Вставляем
                $params['enabled']  = '1';
                if ( !empty($params['group_id']) && $params['group_id'] != 1 ) {
                    unset($params['original_user_id']);
                    $this->logout();
                }
                $params['group_id'] = '1'; // По умолчанию обычный пользователь
                $params['password'] = md5(rand(100000, 999999) . 'luxury');
                $user_id = $this->insert($params);
                $card_number = $this->generate_card_number();
                $this->db->query("UPDATE users SET card_number = {$card_number} WHERE user_id = {$user_id}");
                $this->db->query("UPDATE users SET original_user_id = user_id WHERE original_user_id = '0'");
                return $this->data = $this->db->result("SELECT * FROM users WHERE user_id = '{$user_id}'");
            }
        }
        return false;
    }



    public function check_user( $params = array() ) {
        if ( !is_array($params) || count($params) == 0 ) return false;

        // Поищем того же
        $user_id = (int)$params['user_id'];
        $where   = "phone_number LIKE '%" . $this->db->escape(substr(trim($params['phone_number']), -10)) . "'
                AND card_number LIKE '%" . $this->db->escape(trim($params['card_number'])) . "'
                AND ( user_id = '{$user_id}' OR original_user_id = '{$user_id}' )
                AND password = '" . $this->db->escape(trim($params['password'])) . "' ";

        $users = $this->db->get_results("SELECT * FROM users WHERE {$where}");

        return is_array($users) && count($users) > 0;
    }



    public function generate_card_number_old() {
        return '2086' . rand(1000, 9999) . rand(1000, 9999) .rand(1000, 9999) .rand(1000, 9999) . rand(10, 99);
    }



    public function clear_wishlist( $user_id = 0 ) {
        $user_id = (int)$user_id ? (int)$user_id : $this->get('user_id');
        if ( empty($user_id) ) return false;

        $this->db->query(" DELETE FROM users2wishlist WHERE user_id = '{$user_id}'; ");
        return true;
    }



    public function subscribe_to_brand( $user_id, $brand_id ) {
        $user_id  = (int)$user_id ? (int)$user_id : $this->get('user_id');
        $brand_id = (int)$brand_id;
        if ( empty($user_id) || empty($brand_id) ) return false;
        $subscribtion   = $this->db->result($sql = "SELECT * FROM users2brands WHERE user_id = '{$user_id}' AND brand_id = '{$brand_id}' LIMIT 1;");
        if(!empty($subscribtion) && ($subscribtion->status == 1)){return true;}
        if(empty($subscribtion)){
            $this->db->query($sql = "INSERT INTO users2brands (`user_id`,    `brand_id`,   `status`)
                                                        VALUES ('{$user_id}', '{$brand_id}', '1'); ");
        }
        else{
            $this->db->query($sql = "UPDATE users2brands SET status = 1 WHERE user_id = '{$user_id}' AND brand_id = '{$brand_id}'; ");
        }
        return true;
    }

    public function unsubscribe_from_brand( $user_id, $brand_id ) {
        $user_id  = (int)$user_id ? (int)$user_id : $this->get('user_id');
        $brand_id = (int)$brand_id;
        if ( empty($user_id) || empty($brand_id) ) return false;
        $subscribtion   = $this->db->result($sql = "SELECT * FROM users2brands WHERE user_id = '{$user_id}' AND brand_id = '{$brand_id}' LIMIT 1;");
        $this->db->query($sql = "UPDATE users2brands SET status = 0 WHERE user_id = '{$user_id}' AND brand_id = '{$brand_id}'; ");

        // Отправляем в слак
        $user   = $this->db->result($sql = "SELECT name FROM users WHERE user_id = '{$user_id}' LIMIT 1;")->name;
        $brand   = $this->db->result($sql = "SELECT name FROM brands WHERE brand_id = '{$brand_id}' LIMIT 1;")->name;
        $message = "Пользователь <https://lsboutique.ru/admin/index.php?section=User&user_id={$user_id}|{$user}>, отказался от обновлений бренда {$brand}!";
        $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "brands_subscribtions" );
        Job::push('SlackJob', $args);
        return true;
    }


     public function subscribe_to_shop( $user_id, $shop_id ) {
        $user_id  = (int)$user_id ? (int)$user_id : $this->get('user_id');
        $shop_id = (int)$shop_id;
        if ( empty($user_id) || empty($shop_id) ) return false;
        $subscribtion   = $this->db->result($sql = "SELECT * FROM users2shops WHERE user_id = '{$user_id}' AND shop_id = '{$shop_id}' LIMIT 1;");
        if(!empty($subscribtion)){return true;}
        if(empty($subscribtion)){
            $this->db->query($sql = "INSERT INTO users2shops (`user_id`,    `shop_id`)
                                                        VALUES ('{$user_id}', '{$shop_id}'); ");
        }
        return true;
    }

    public function user2size( $user_id, $size, $type_id ) {
        $user_id    = (int)$user_id ? (int)$user_id : $this->get('user_id');
        $size       = mysql_real_escape_string($size);
        $type_id    = (int)$type_id;
        $m_id       = $_SESSION['user']->original_user_id;
        $is_size    = $this->db->result($sql = "SELECT * FROM users2sizes_n WHERE user_id = '{$user_id}' AND size_id = '{$size}' AND type_id = '{$type_id}' LIMIT 1;");
        if (!empty($is_size)) {
            $this->db->query($sql = "DELETE FROM users2sizes_n WHERE user_id = '{$user_id}' AND size_id = '{$size}' AND type_id = '{$type_id}'; ");
            $result = "unset";
        }
        else {
            $this->db->query($sql = "INSERT INTO users2sizes_n (`user_id`, `type_id`, `size_id`, `manager_id`, `date`) VALUES ('{$user_id}', '{$type_id}', '{$size}', '{$m_id}', NOW()); ");
            $result = "set";
        }
        return $result;
    }



    public function user2sizes( $type_id, $user_id = 0 ) {
        $user_id = (int)$user_id ? (int)$user_id : $this->get('user_id');
        $type_id = (int)$type_id;
        $tmp     = $this->db->results($sql = "SELECT * FROM users2sizes WHERE user_id = '{$user_id}' AND type_id = '{$type_id}';");
        $sizes   = array();
        if ( is_array($tmp) && count($tmp) > 0 )
        foreach ($tmp as $tmp_size) {
            $sizes[] = $tmp_size->size;
        }
        return $sizes;
    }



    public function save_wishlist( $user_id, $wish_list ) {
        $user_id = (int)$user_id ? (int)$user_id : $this->get('user_id');
        if ( empty($user_id) ) return false;
        $this->clear_wishlist($user_id);
        if ( is_array($wish_list) && count($wish_list) ) {
            foreach ( $wish_list as $product_id => $wish ) if ( is_array($wish) && count($wish) ) {
                foreach ( $wish as $size => $price ) {
                    $this->db->query("INSERT INTO users2wishlist (`user_id`,   `product_id`,   `size`, `count`, `price`) VALUES ('{$user_id}', '{$product_id}', '{$size}', '1', '{$price}'); ");
                }
            }
        }
        return true;
    }



    public function get_wishlist( $user_id ) {
        $this->db->query("DELETE FROM `users2wishlist` WHERE product_id IN (SELECT p.product_id FROM products p LEFT JOIN items i ON p.product_id = i.product_id WHERE i.barcode IS NULL)");
        $user_id = (int)$user_id ? (int)$user_id : $this->get('user_id');
        if ( empty($user_id) ) return false;
        $wish_list = array();

        $list = $this->db->results("SELECT * FROM users2wishlist WHERE user_id = '{$user_id}'");
        if ( is_array($list) && count($list) ) {
            foreach ( $list as $wish ) {
                $wish_list[$wish->product_id][$wish->size] = $wish->price;
            }
        }
        return $wish_list;
    }



    public function get_keys( $original_user_id = 0 ) {
        return $this->db->get_results($sql = " SELECT * FROM users WHERE original_user_id = '{$original_user_id}' ");
    }



    public function has_social_account( $original_user_id = 0 ) {
        return $this->db->get_var(" SELECT user_id FROM users WHERE original_user_id = '{$original_user_id}' AND network <> '' LIMIT 1; ");
    }



    public function update_user( $user_id, $params, $force = false ) {
        $user_id = (int)$user_id;
        if ( empty($user_id) ) return false;

        $user   = $this->db->get_row(" SELECT * FROM users WHERE user_id = '{$user_id}' ");
        $update = array();
        foreach ($params as $k=>$v) if ( !in_array($k, array('user_id', 'enabled')) ) {
            if ( !empty($v) && ( empty($user->$k) || $force || in_array($k, array('photo', 'photo_rec')) ) ) {
                $update[$k] = $v;
            }
        }
        if($update['phone_number'] != $user->phone_number || $update['name'] != $user->name){
          $this->db->query($sql = "UPDATE apple_pkpass SET upd = 1 WHERE user_id = '{$user->user_id}';");
          $devices = $this->db->results($sql = "SELECT ad.* FROM apple_devices ad
                LEFT JOIN apple_devices2pkpasses ad2p ON ad.device_l_id = ad2p.device_l_id
                LEFT JOIN apple_pkpass ap ON ad2p.pass_id = ap.pass_id
                WHERE ad2p.pass_id IN (SELECT pass_id FROM apple_pkpass WHERE upd = 1 AND user_id = '{$user_id}')
                AND ad.push_token !='';");
          if(!empty($devices)){
            $m = '';
            foreach($devices as $device){
              $args = array('message' => $m, 'platform' => 'iOS', 'token' => $device->push_token);
              Job::push( 'PushJob', $args );
            }
          }
        }

        if ( is_array($update) && count($update) > 0 ) {
            $this->update($update, $user_id);
        }
    }



    public function login( $user_id ) {
        $user_id = (int)$user_id;
        $user    = $this->db->result("SELECT * FROM users WHERE user_id = '{$user_id}' AND enabled = '1'");
        if ( empty($user) ) return false;
        $ip = isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : $_SERVER['REMOTE_ADDR'];
        $ua = $this->db->escape($_SERVER['HTTP_USER_AGENT']);
        $lang = $_COOKIE['language'];
        $this->db->query("UPDATE users SET last_login_date = NOW(), last_ip = '{$ip}', last_user_agent = '{$ua}', language = '{$lang}' WHERE original_user_id = '{$user_id}'");

        if (!isset($_COOKIE['session_id']) || empty($_COOKIE['session_id'])){
            $session_id = $this->set_session_id();
            $this->db->query("UPDATE web_sessions SET updated = NOW(), user_id = '{$user_id}' WHERE phpsessid = '{$session_id}'");
        }
        else{
            $session_id = $_COOKIE['session_id'];
            $check_session = $this->db->result("SELECT * FROM web_sessions WHERE phpsessid = '{$session_id}'");
            if (empty($check_session)) {
              $session_id = $this->set_session_id();
            }
            if (empty($check_session) || empty($check_session->user_id)) {
              $this->db->query("UPDATE web_sessions SET updated = NOW(), user_id = '{$user_id}' WHERE phpsessid = '{$session_id}'");
            }
        }

        $group = $this->db->result("SELECT * FROM groups WHERE group_id = '{$user->group_id}';");
        if ( $user->group_id == 4 ) { // Если пользователь - транспортная компания
            $delivery_agent = $this->db->result("SELECT * FROM  `delivery_companies` WHERE user_id ='{$user_id}'");
            if ( !empty($delivery_agent) && $delivery_agent->active == 1) {
                $_SESSION['delivery_agent'] = $delivery_agent->id;
            }
        }
        $user->offline_brands = $this->get_offline_brands($user_id);

        $_SESSION['user']   = $user;
        $_SESSION['group']  = $group;

        $personal_discount  = $this->get_personal_discount(0, $this->get_sum_of_buy( !empty($_SESSION['user']->original_user_id) ? $_SESSION['user']->original_user_id : 0 ), true);
        if ( $personal_discount ) {
            $_SESSION['group']->discount = $personal_discount;
        }

        if ($user->sex) {
            setcookie('sex', $user->sex, time()+60*60*24*365, '/');
            $_COOKIE['sex'] = $user->sex;
        }

        $this->remember_user( $user->original_user_id, $user->password );

        // Тащим вишлист
        $_SESSION['wish_list'] = $this->get_wishlist( $user->original_user_id );
        return true;
    }



    public function remember_user( $user_id, $password ) {
        if ( !empty($user_id) && !empty($password) ) {
            setcookie('hashcode', $password, time()+60*60*24*90, '/');
            setcookie('user_id',  $user_id,  time()+60*60*24*90, '/');
        }
    }



    public function is_allowed($resourse = '') {
        if ( empty($resourse) || empty($_SESSION['group']) ) return false;
        if ( $resourse == 'admin'       && $_SESSION['group']->group_id == 2 ) return true;
        if ( $resourse == 'moderator'   && ( $_SESSION['group']->group_id == 3 || $_SESSION['group']->group_id == 2 ) ) return true;
        if ( $resourse == 'transport'   && $_SESSION['group']->group_id == 4 ) return true;
        if ( $resourse == 'manager'     && $_SESSION['group']->group_id == 5 ) return true;
        if ( $resourse == 'accountant'  && $_SESSION['group']->group_id == 6 ) return true;
        if ( $resourse == 'something'   && $_SESSION['group']->group_id > 1 && $_SESSION['group']->group_id != 10)  return true;
        if ( $resourse == 'copywriter'  && ($_SESSION['group']->group_id == 7 || $_SESSION['group']->group_id == 8) )  return true;
        if ( $resourse == 'kassir'      && $_SESSION['group']->group_id == 9 )  return true;
        if ( $resourse == 'sklad'      && $_SESSION['group']->group_id == 12 )  return true;
        if ( $resourse == 'indposhiv'   && strpos($_SESSION['user']->cashbox_ids,',13') !== false ) return true;
        if ( $resourse == 'offline_manager' && $_SESSION['user']->cashbox_ids == 100 ) return true;
        if ( $resourse == 'service'     && strpos($_SESSION['user']->cashbox_ids,'15') !== false ) return true;
        if ( $resourse == 'sr_manager'  && $_SESSION['group']->group_id == 13 ) return true;
        if ( $resourse == 'hostess'  && $_SESSION['group']->group_id == 14 ) return true;
        if ( $resourse == 'sklad_lite'  && $_SESSION['group']->group_id == 15 ) return true;
        return false;
    }


    public function is_allowed_bookmark($bookmark) {
        if ( empty($bookmark)) return false;
        if ($_SESSION['user']->group_id == 2 && $bookmark != 22) return true;
        $bookmarks = explode(',',$_SESSION['user']->bookmarks);
        if(in_array($bookmark,$bookmarks)) return true;
        return false;
    }



    public function logout($force = 0) {
        setcookie('hashcode', '', time()-60*60*24*30, '/');
        setcookie('user_id',  '', time()-60*60*24*30, '/');
        if ( $force ) {
            setcookie('save_card_number',   '', time()-60*60*24*365, '/');
            setcookie('save_phone_number',  '', time()-60*60*24*365, '/');
            setcookie('save_email',         '', time()-60*60*24*365, '/');
        }
        unset($_COOKIE['hashcode']);
        unset($_COOKIE['user_id']);
        unset($_SESSION['delivery_agent']);
        unset($_SESSION['user']);
        unset($_SESSION['wish_list']);
        unset($_SESSION['group']);
    }



    public function vk_auth() {
        // VK auth
        $params = explode('?', $_SERVER['REQUEST_URI']);
        if ( !empty( $params[1] ) ) {
            parse_str($params[1], $params);
            if ( !empty($params['uid']) && !empty($params['hash']) ) {
                $user = $this->db->query("SELECT * FROM `users` WHERE uid = '{$params['uid']}' LIMIT 1");
                $user = $this->db->result();
                if ( isset($user->user_id) ) {
                    $query = sql_placeholder("UPDATE `users` SET `name` = ?, `photo` = ?, `photo_rec` = ? WHERE user_id = ?",
                        $params['first_name'] . ' ' . $params['last_name'], $params['photo'], $params['photo_rec'], $user->user_id);
                }
                else {
                    $query = sql_placeholder("INSERT INTO `users` (`email`, `password`, `name`, `uid`, `photo`, `photo_rec`, `group_id`, `enabled`) VALUES (?, ?, ?, ?, ?, ?, '1', '1')",
                        $params['uid'] . '@vk.com', md5('luxury' . $params['uid'].$this->salt), $params['first_name'] . ' ' . $params['last_name'], $params['uid'], $params['photo'], $params['photo_rec']);
                }
                $this->db->query($query);
                $_POST['email']    = $params['uid'];
                $_POST['password'] = 'luxury' . $params['uid'];
            }
        }
    }

    // Функция смены значения поля депозит у пользователя
    public function change_deposit( $change_sum, $reason, $order_id, $order_product_id = 0 ) {
        $change_sum = (int)$change_sum;
        $user_id    = $this->get('original_user_id');
        // Знаем у кого изменять и есть что изменять
        if ( !empty($user_id) && $change_sum != 0 ) {
            $this->db->query(" UPDATE users SET deposit = deposit + {$change_sum} WHERE original_user_id = '{$user_id}'; ");

            // Данные экранируем уже в модели
            $admin_id           = (int)$_SESSION['user']->original_user_id;
            $order_id           = (int)$order_id;
            $order_product_id   = (int)$order_product_id;
            $reason     = $this->db->escape($reason);
            $this->db->query($sql = " INSERT INTO `deposit_history` ( `admin_id`, `user_id`, `sum`, `reason`, `order_id`, `order_product_id`)
                                                    VALUES ( '{$admin_id}', '{$user_id}', '{$change_sum}', '{$reason}', '{$order_id}', '{$order_product_id}');");
        }
        return false;
    }

     public function unlink_acc( $user_id ) {
        $user_id = (int) $user_id;
        if ( !empty($user_id) ) {
            $this->db->query(" UPDATE users SET original_user_id = user_id WHERE user_id = '{$user_id}'; ");
        }
        return false;
    }

    public function get_deposit_history ($user_id) {
        $user_id = (int)$user_id;
        if ( !empty($user_id) ) {
            $user_ids = $this->db->result("SELECT GROUP_CONCAT(user_id) AS user_ids FROM users WHERE original_user_id = '{$user_id}';")->user_ids;
            $deposit_history = $this->db->results("SELECT * FROM deposit_history WHERE user_id IN ({$user_ids}) ORDER BY record_date DESC LIMIT 100;");
            foreach ($deposit_history as $data) {
                $data->admin_id = ($data->admin_id == 0) ? "Система" : $this->db->get_var("SELECT `name` FROM `users` WHERE user_id = {$data->admin_id};");
            }
            return $deposit_history;
        }
        return false;
    }


    // Процент отказов от товара при получении для заданного пользователя
    public function get_return_rate ($user_id) {
        $user_id = (int)$user_id;
        $user_ids = luser::find_connected_users($user_id);

        if ( !empty($user_ids) ) {
            $uids = implode(",", $user_ids);
            $returned = (int)$this->db->result("SELECT SUM(price) as sum FROM orders_products op LEFT JOIN orders o ON op.order_id = o.order_id WHERE o.user_id IN ({$uids}) AND op.status = 4")->sum;
            $complete = (int)$this->db->result("SELECT SUM(price) as sum FROM orders_products op LEFT JOIN orders o ON op.order_id = o.order_id WHERE o.user_id IN ({$uids}) AND op.status = 5")->sum;
            if ($returned) {
                return $rate = 100 * $returned / ($complete + $returned);
            }
        }
        return 0;
    }


    // Возвращает массив всех user_id, связанных с аккаунтом данного user_id
    public function find_connected_users ($user_id) {
        $user_id = (int)$user_id;

        if ( !empty($user_id) ) {
            $user_ids = array();
            $r = $this->db->results("SELECT user_id FROM users WHERE original_user_id = (SELECT original_user_id FROM users WHERE user_id = {$user_id})");
            foreach ($r as $key => $value) {
                $user_ids[] =$value->user_id;
            }
            if (!empty($user_ids)) {
                return $user_ids;
            }
        }
        return false;
    }


    //Проверка прав на определенную секцию
    public function is_allowed_section($section){

        // Надо проверить что секция не пустая
        if(empty($section)) return false;
        // Если в группе нет секций - значит все доступно
        if (empty($_SESSION['group']->sections)) return true;

        $user_sections = explode(',', $_SESSION['group']->sections);
        if($_SESSION['user']->user_id == 12625){
          array_push($user_sections,'Analytics','PaymentMethods');
        }
        if($_SESSION['user']->user_id == 16211){
          array_push($user_sections,'Banners');
        }
        if($_SESSION['user']->user_id == 13556){
          array_push($user_sections,'PaymentMethods');
        }
        if (in_array($section, $user_sections)) return true;
        return false;
    }


    // Список доступных пользователю брендов
    public function visible_brands($user_id = 0) {
        if ($user_id) {
            $t_user = $this->db->result("SELECT purchase_sum_real,show_hidden_brands,group_id FROM users WHERE user_id = {$user_id}");
            if ($t_user->purchase_sum_real > 0) {
                $visibility = 3;
            }
            else {
                $visibility = 2;
            }
            $show_hidden_brands = $t_user->show_hidden_brands ? $t_user->show_hidden_brands : 0;
            $vbrands_query = "visibility <= {$visibility} OR (visibility = 4 AND brand_id IN ({$show_hidden_brands}))";
            if ($t_user->group_id > 1 || $user_id == 16211) {
                $vbrands_query = "1";
            }
        }
        else {
            $visibility = 1;
            $vbrands_query = "visibility <= {$visibility}";
        }
        $brands_uuu = $this->db->results("SELECT brand_id FROM brands WHERE {$vbrands_query}");
        $brands     = array();
        foreach ($brands_uuu as $k => $v) {
            $brands[] = $v->brand_id;
        }
        global $filter_brands; // Это супер-фильтр по брендам, для демонстрации luxurystore.pro лоропьяне
        if (!empty($filter_brands) && is_array($filter_brands) && count($filter_brands) > 0) {
            $brands = $filter_brands;
        }
        return $brands;
    }

    public function sale_visible_brands($user_id = 0) {
      if ($user_id) {
        $user = new luser($user_id);
        $level = $user->purchase_sum_real ? 'has_purchase' : 'registered';
      }
      else {
        $level = 'everyone';
      }
      $brands = $this->db->results("SELECT season,
        GROUP_CONCAT(brand_id SEPARATOR ',') AS brand_ids
        FROM `sale_settings`
        WHERE `${level}` = 1
        GROUP BY season");
      return $brands;
    }

    // Возвращает массив всех user_id, связанных с аккаунтом данного user_id
    public function find_products($params = array()) {
        $where = ' 1 ';
        if ( isset($params['type_id']) && (int)$params['type_id'] ) {
            $params['type_id'] = (int)$params['type_id'];
            $where .= " AND c.type_id = '{$params['type_id']}' ";
        }
        if ( isset($params['sizes']) && is_array($params['sizes']) && count($params['sizes']) > 0 ) {
            $sizes  = implode("','", $params['sizes']);
            $where .= " AND p2s.normal_size IN ('{$sizes}') ";
        }
        if ( isset($params['brand_ids']) && is_array($params['brand_ids']) && count($params['brand_ids']) > 0 ) {
            $brands = implode(", ", $params['brand_ids']);
            $where .= " AND p.brand_id IN ({$brands}) ";
        }
        if ( isset($params['sex']) && (int)$params['sex'] ) {
            $where .= " AND p.sex IN ('0', '" . (int)$params['sex'] . "') ";
        }
        if ( isset($params['created']) && (int)$params['created'] ) {
            $params['created'] = $this->db->escape($params['created']);
            $where .= " AND p.created >= '{$params['created']}' ";
        }
        if ( isset($params['created_foto']) && (int)$params['created_foto'] ) {
            $params['created_foto'] = $this->db->escape($params['created_foto']);
            $where .= " AND pf.created >= '{$params['created_foto']}' ";
        }
        if ( isset($params['large_image']) ) {
            $where .= " AND p.large_image <> '' ";
        }

        $limit = isset($params['limit']) && (int)$params['limit'] ? (int)$params['limit'] : 8;
        $sql = "SELECT p.* FROM `items` i
            LEFT JOIN `products` p ON p.product_id = i.product_id
            LEFT JOIN `products_fotos` pf ON p.product_id = pf.product_id
            LEFT JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN brands b ON p.brand_id = b.brand_id
            WHERE {$where} AND b.hidden = 0
            GROUP BY product_id
            ORDER BY created DESC
            LIMIT {$limit}";
        return $this->db->results($sql);
    }



    //Просмотр товара
    public function view_product($product_id){
        $user_id = $_SESSION['user']->original_user_id;

        if(empty($user_id) OR empty($product_id)) return false;

        $query = sql_placeholder('INSERT INTO users2products SET ?%', array('product_id'=>$product_id, 'user_id'=>$user_id));
        return $this->db->query($query);
    }

    //Отображаемая персонализированная цена товара
    public function product_prices($product){
        $purchase_sum = $this->get('purchase_sum_real');
        $personal_discount = $this->get('personal_discount');

        $prices = array();
        $sale_value = $product->old_price ? (($product->old_price - $product->price)/$product->old_price)*100 : 0;
        $sale_settings = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$product->brand_id} AND season = '{$product->season_type}'");
        $curs_tmp = $this->db->results('SELECT LOWER(code) AS code, rate_to FROM currencies WHERE def = 0');
        foreach($curs_tmp as $c){
          $code = $c->code;
          $curs->$code = $c->rate_to;
        }
        $show_sale = true;
        if (!$this->user_id && $sale_settings && $sale_settings->everyone == 0) {
          $show_sale = false;
        }
        elseif ($this->user_id && $sale_settings && $purchase_sum == 0 && $personal_discount < 5 && $sale_settings->registered == 0) {
          $show_sale = false;
        }
        elseif ($this->user_id && $sale_settings && ($purchase_sum > 0 || $personal_discount > 5) && $sale_settings->has_purchase == 0) {
          $show_sale = false;
        }

        $total_discount = $sale_value + $personal_discount;

        // Если скидка на товар не предоставляется
        if ($product->no_discount) {
          $show_sale = false;
        }

        if ($show_sale && $product->old_price > 0) {
          $prices['first_price'] = $product->old_price;
          foreach($curs as $n=>$c)$prices["first_price_$n"] = round($prices['first_price']/$c, 2);

          if ($product->super_price) {
            $prices['sale_price'] = $prices['final_price'] = array('price' => $product->price, 'value' => (1 - ($product->price / $product->old_price))*100);
            foreach($curs as $n=>$c)$prices['sale_price']["price_$n"] = round($prices['sale_price']['price']/$c, 2);
            if ($personal_discount > 0) {
              $prices['vip_price'] = $prices['sale_price'];
              unset($prices['sale_price']);
            }
          }
          elseif ($total_discount >= $sale_settings->max_sale && $sale_settings->max_sale != 0) {
            $prices['sale_price'] = array('price' => ($product->old_price*(100-$sale_settings->max_sale)/100), 'value' => $sale_settings->max_sale);
            foreach($curs as $n=>$c)$prices['sale_price']["price_$n"] = round($prices['sale_price']['price']/$c, 2);
            $prices['final_price'] = $prices['sale_price'];
            if ($personal_discount > 0) {
              $prices['vip_price'] = $prices['sale_price'];
              unset($prices['sale_price']);
            }
          }
          else {
            if ($product->old_price) {
              $prices['sale_price'] = array('price' => $product->price, 'value' => $sale_value);
              foreach($curs as $n=>$c)$prices['sale_price']["price_$n"] = round($prices['sale_price']['price']/$c, 2);
            }
            if ($personal_discount) {
              $prices['vip_price'] = array('price' => ($product->old_price*(100-$total_discount)/100), 'value' => $total_discount);
              foreach($curs as $n=>$c)$prices['vip_price']["price_$n"] = round($prices['vip_price']['price']/$c, 2);
            }
          }
        }
        elseif ($show_sale && $product->old_price == 0 && $personal_discount > 0) {
          $prices['first_price'] = $product->price;
          foreach($curs as $n=>$c)$prices["first_price_$n"] = round($prices['first_price']/$c, 2);
          $final_discount = ($personal_discount >= $sale_settings->max_sale) ? $sale_settings->max_sale : $personal_discount;
          $prices['vip_price'] = array('price' => ($product->price*(100-$final_discount)/100), 'value' => $final_discount);
          foreach($curs as $n=>$c)$prices['vip_price']["price_$n"] = round($prices['vip_price']['price']/$c, 2);
        }
        else {
          // No Personal discount if sale prices are hidden
          $prices['price'] = $product->price;
          foreach($curs as $n=>$c)$prices["price_$n"] = round($prices['price']/$c, 2);
        }


        $price_array = array($prices['price'], $prices['sale_price']['price'], $prices['vip_price']['price']);
        $prices['personal_price'] = min( array_filter($price_array, function($v) { return $v; }) );

        return $prices;
    }

    public function personal_product_price($product) {
        return $this->product_prices($product)['personal_price'];
    }

    public function product_prices_for_api($product, $currency = 'rub', $can_buy_from_site = true) {
        if (!$can_buy_from_site) {
          $price_by_demand = ($_COOKIE['language'] == 'eng') ? 'Inquire for price' : 'Цена по запросу';
          return ['price' => ['price' => $price_by_demand]];
        }
        $prices_tmp = $this->product_prices($product);
        $c_check = $this->db->result("SELECT rate_to FROM currencies WHERE code = '{$currency}'")->rate_to;
        $brand = $this->db->result("SELECT * FROM brands WHERE brand_id = '{$product->brand_id}'");
        if (empty($c_check)) $currency = 'rub';
        else $currency = strtolower($currency);
        if ($prices_tmp['first_price']){
          if($brand->show_delta === '0' && strpos($_SERVER['HTTP_USER_AGENT'],'iOS') !== false){
            $prices['price']['price'] = '';
            $prices['price']['text'] = '';
          }
          else{
            if($currency == 'rub' || $product->sku == "testproduct") $prices['price']['price'] = strpos($prices_tmp['first_price'],'.') !=false ? $prices_tmp['first_price'] .'' : $prices_tmp['first_price'] . '.00';
            else $prices['price']['price'] = strpos($prices_tmp["first_price_$currency"],'.') !=false ? $prices_tmp["first_price_$currency"] .'' : $prices_tmp["first_price_$currency"] . '.00';
            $prices['price']['text'] = ($_COOKIE['language'] == 'eng') ? ' first price' : ' первая цена';
          }
        }
        else{
            if($currency == 'rub' || $product->sku == "testproduct") $prices['price']['price'] = strpos($prices_tmp['price'],'.') !=false ? $prices_tmp['price'] .'' : $prices_tmp['price'] . '.00';
            else $prices['price']['price'] = strpos($prices_tmp["price_$currency"],'.') !=false ? $prices_tmp["price_$currency"] .'' : $prices_tmp["price_$currency"] . '.00';
        }
        if ($prices_tmp['vip_price']){
            if($currency == 'rub' || $product->sku == "testproduct") $prices['vip_price']['price'] = strpos($prices_tmp['vip_price']['price'],'.') !=false ? $prices_tmp['vip_price']['price'] .'' : $prices_tmp['vip_price']['price'] . '.00';
            else $prices['vip_price']['price'] = strpos($prices_tmp['vip_price']["price_$currency"],'.') !=false ? $prices_tmp['vip_price']["price_$currency"] .'' : $prices_tmp['vip_price']["price_$currency"] . '.00';
            $prices['vip_price']['text'] = ($_COOKIE['language'] == 'eng') ? ' VIP PRICE' : ' VIP ЦЕНА';;
        }
        if ($prices_tmp['sale_price']){
            if($currency == 'rub' || $product->sku == "testproduct") $prices['sale_price']['price'] = strpos($prices_tmp['sale_price']['price'],'.') !=false ? $prices_tmp['sale_price']['price'] .'' : $prices_tmp['sale_price']['price'] . '.00';
            else $prices['sale_price']['price'] = strpos($prices_tmp['sale_price']["price_$currency"],'.') !=false ? $prices_tmp['sale_price']["price_$currency"] .'' : $prices_tmp['sale_price']["price_$currency"] . '.00';
            $prices['sale_price']['text'] = ' - '.round($prices_tmp['sale_price']['value'], 0).'%';
        }
        return $prices;
    }

    public function get_offline_brands($user_id = 0) {
      if (!$user_id) {
        return [];
      }
      $offline_brands = [];
      $of_brands = $this->db->results("SELECT * FROM users_offline_brands WHERE user_id = {$user_id}");
      foreach ($of_brands as $of_brand) {
        $offline_brands[] = $of_brand->brand_id;
      }
      return $offline_brands;
    }

    public function log_action() {
        $ip  = $this->db->escape(isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : $_SERVER['REMOTE_ADDR']);
        $ua  = $this->db->escape($_SERVER['HTTP_USER_AGENT']);
        $url = $this->db->escape($_SERVER['REQUEST_URI']);
        $uid = (int)$_SESSION['user']->original_user_id;
        $this->db->query("INSERT INTO `users_actions` (`user_id`, `ip`, `url`, `ua`) VALUES ('{$uid}', '{$ip}', '{$url}', '{$ua}');");
    }

    public function set_session_id() {
        $ip = isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : $_SERVER['REMOTE_ADDR'];
        $ua = $this->db->escape($_SERVER['HTTP_USER_AGENT']);
        set_include_path(get_include_path() . PATH_SEPARATOR . $_SERVER['DOCUMENT_ROOT'] . '/third_party/RandomLib/');
        require_once 'autoload.php';
        $string = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $factory = new RandomLib\Factory;
        $generator = $factory->getMediumStrengthGenerator();
        $session_id = $generator->generateString(32, $string);
        $check_id = $this->db->result("SELECT phpsessid FROM web_sessions WHERE phpsessid = '{$session_id}'")->phpsessid;
        while (!empty($check_id)){
            $session_id = $generator->generateString(32, $string);
            $check_id = $this->db->result("SELECT phpsessid FROM web_sessions WHERE phpsessid = '{$session_id}'")->phpsessid;
        }
        $this->db->query("INSERT INTO web_sessions (phpsessid, user_agent, ip, created) VALUES ('{$session_id}', '{$ua}', '{$ip}', NOW())");
        setcookie('session_id', $session_id, time()+60*60*24*365, '/');
        return $session_id;
    }

    public function check_robots() {
        $ip  = $this->db->escape(isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : $_SERVER['REMOTE_ADDR']);
        $ua  = $this->db->escape($_SERVER['HTTP_USER_AGENT']);
        $old_session = $this->db->result("SELECT * FROM ip_check WHERE ip = '{$ip}'");
        if (empty($old_session->cookie)){
            $field = rand(100000,999999);
            $this->db->query("INSERT INTO `ip_check` (`ip`,`ua`,`cookie`,`date`,`visits`) VALUES ('{$ip}', '{$ua}', '{$field}', NOW(), '1');");
            setcookie('field', $field, time()+60*60*24*365, '/');
        }
        if (!empty($old_session->cookie) && http_response_code() == 200){
            $cookie = isset($_COOKIE['field']) ? $_COOKIE['field'] : null;
            if($old_session->cookie != $cookie){
                $this->db->query("UPDATE ip_check SET `check` = '1', `visits` = `visits`+ 1, `date` = NOW() WHERE ip = '{$old_session->ip}'");
            }
        }
    }

    public function api_login($user_id, $currency) {
      if(!empty($currency)){
        $c_check = $this->db->result("SELECT rate_to FROM currencies WHERE code = {$currency}")->rate_to;
        if (empty($c_check)) $currency = 'rub';
        $c_query = ", currency = '{$currency}'";
      }
      if(isset($_COOKIE['language']) && !empty($_COOKIE['language'])){
        $language = $this->db->escape($_COOKIE['language']);
        $l_query = ", language = '{$language}'";
      }
      $this->db->query("UPDATE users SET last_api_login_date = NOW(){$c_query}{$l_query}  WHERE original_user_id = '{$user_id}'");
    }

    public function api_user_data($user_id) {
      if (!empty($user_id)){
        $user = $this->db->get_row("SELECT user_id, original_user_id, email, name, deposit, photo, photo_rec, sex, card_number, phone_number, city, city_id, adress, birth_date, personal_discount, show_hidden_brands, language, currency, p_manager_id FROM `users` WHERE user_id = '{$user_id}' AND enabled = '1'; ");
        if(strpos($user->photo, 'http') === false){
            $user->photo = 'https://lsboutique.ru' . ($user->photo ? $user->photo : '/images/empty_photo.png');
            $user->photo_rec = 'https://lsboutique.ru' . ($user->photo_rec ? $user->photo_rec : '/images/empty_photo.png');
        }
        $user->manager = $this->db->result("SELECT original_user_id, email, name, photo, phone_number, pref_messenger as messengers, wh.start as wh_start, wh.end as wh_end FROM users u LEFT JOIN work_hours wh ON wh.user_id = u.user_id AND wh.date = DATE(NOW()) WHERE u.user_id = '{$user->p_manager_id}';");
        if ( $user->manager ) {
          if ($user->manager->messengers) {
            $user->manager->messengers = $this->db->results("SELECT * FROM messengers WHERE `id` IN ({$user->manager->messengers});");
            foreach($user->manager->messengers as $m)$m->icon = 'https://lsboutique.ru/admin/images/icons/' . $m->icon;
          }
          else $user->manager->messengers = null;
          if(strpos($user->manager->photo, 'http') === false) $user->manager->photo = 'https://lsboutique.ru/' . ($user->manager->photo ? $user->manager->photo : '/images/empty_photo.png');
        }
        else {$user->manager = null;}

        $this->db->query("UPDATE users SET last_api_login_date = NOW() WHERE original_user_id = '{$user->user_id}'");
        $user_sizes_top = $this->db->results("SELECT size FROM users2sizes WHERE `user_id` = '{$user->user_id}' AND `type_id` = '1';");
        foreach ($user_sizes_top as $size) {
            $user_sizes_top_res[] = $size->size;
        }
        $user->sizes_top = $user_sizes_top_res;
        $user_sizes_bottom = $this->db->results("SELECT size FROM users2sizes WHERE `user_id` = '{$user->user_id}' AND `type_id` = '2';");
        foreach ($user_sizes_bottom as $size) {
            $user_sizes_bottom_res[] = $size->size;
        }
        $user->sizes_bottom = $user_sizes_bottom_res;
        $user_sizes_shoes = $this->db->results("SELECT size FROM users2sizes WHERE `user_id` = '{$user->user_id}' AND `type_id` = '3';");
        foreach ($user_sizes_shoes as $size) {
            $user_sizes_shoes_res[] = $size->size;
        }
        $user->sizes_shoes = $user_sizes_shoes_res;
        $subs   = $this->db->results($sql = "SELECT brand_id FROM users2brands WHERE user_id = '{$user->user_id}' AND status = 1;");
        foreach($subs as $sub){$user->subscriptions[] = $sub->brand_id;}
        $pass_upd = $this->db->results("SELECT pass_id FROM `apple_pkpass` WHERE user_id = '{$user->user_id}' AND upd = 1 ");
        foreach($pass_upd as $pass){$user->pass_upd[] = $pass->pass_id;}
      }
      return $user;
    }

    public function save_app_token( $token, $platform, $user_id, $phone_number, $delete, $firebase_token ) {
        // Сохранять всё, что происходит с токенами
        // $m = "App token update request: \ntoken: {$token}, platform: {$platform}, user_id: {$user_id}, phone: {$phone_number}, delete: {$delete}, fcm_token: {$firebase_token}";
        // Job::push( 'RemoteLoggerJob', $m );
        if ( !empty($phone_number) ){
            $phone_number = str_replace(array(' ','-',')','(','+'), '', $phone_number);
            //$phone_number      = substr($phone_number, -10);
            if ( empty($user_id) ){
                $user = $this->db->get_row("SELECT original_user_id, card_number, phone_number FROM `users` WHERE phone_number LIKE '%{$phone_number}' AND enabled = '1'; ");
                $user_id = $user->original_user_id;
            }
        }
        $lang = ($_COOKIE['language'] == 'eng') ? 'eng' : 'ru';
        $token_row = $this->db->result("SELECT * FROM `app_sessions` WHERE push_token = '{$token}' OR (firebase_token = '{$firebase_token}' AND firebase_token != ''); ");
        if($delete === true){
            if(!empty($token_row->id)){
                $this->db->query("DELETE FROM `app_sessions` WHERE id = '{$token_row->id}'; ");
                $message = 'token deleted';
            }
            else{$message = 'no such token exists';}
        }
        else{
            if (!empty($user_id)){
                $user_id = $this->db->result("SELECT original_user_id FROM `users` WHERE user_id = {$user_id} AND enabled = '1'; ")->original_user_id;
            }
            if(!empty($token_row->id) && (empty($token_row->user_id) || empty($token_row->firebase_token))){
              if(empty($token_row->user_id)){
                $this->db->query("UPDATE `app_sessions` SET user_id = '{$user_id}', date = NOW() WHERE id = '{$token_row->id}'; ");
                $message = 'saved user id';
              }
              if(empty($token_row->firebase_token)){
                $this->db->query("UPDATE `app_sessions` SET firebase_token = '{$firebase_token}', date = NOW() WHERE id = '{$token_row->id}'; ");
                $message = 'saved firebase token';
              }
            }
            elseif(empty($token_row->id)){
                $this->db->query("INSERT INTO app_sessions (push_token, platform, user_id, date, firebase_token, language) VALUES ('{$token}', '{$platform}', '{$user_id}', NOW(), '{$firebase_token}', '{$lang}')");
                $message = 'data saved';
            }
            else{
                $message = 'token already exists';
            }
            return $message;
        }
    }

    public function clear_cart( $user_id = 0 ) {
        $user_id = (int)$user_id ? (int)$user_id : $this->get('user_id');
        if ( empty($user_id) ) return false;
        $this->db->query("DELETE FROM users2carts WHERE user_id = '{$user_id}'; ");
        return true;
    }

    public function save_cart( $user_id, $cart ) {
        $user_id = (int)$user_id ? (int)$user_id : $this->get('user_id');
        if ( empty($user_id) ) return false;
        $this->clear_cart($user_id);
        if ( is_array($cart) && count($cart) ) {
            foreach ( $cart as $product_id => $size ) {
                $product = $this->db->get_row("SELECT * FROM products WHERE product_id='{$product_id}'");
                $price = $this->personal_product_price($product);
                foreach ( $size as $s=>$q ) {
                    $this->db->query("INSERT INTO users2carts (`user_id`,`product_id`,`size`,`count`,`price`) VALUES ('{$user_id}','{$product_id}','{$s}','{$q}','{$price}'); ");
                }
            }
        }
        return true;
    }

    public function load_cart( $user_id, $platform='site' ) {
        $user_id = (int)$user_id ? (int)$user_id : $this->get('user_id');
        if ( empty($user_id) ) return false;
        $user_cart = $this->db->results("SELECT * FROM `users2carts` WHERE user_id = {$user_id}");
        if($platform == 'site'){
            unset($_SESSION['shopping_cart'],$_SESSION['shopping_cart_sizes']);
            foreach($user_cart as $product){
                if ( !isset($_SESSION['shopping_cart'][$product->product_id]) ) {
                    $_SESSION['shopping_cart'][$product->product_id] = 0;
                    $_SESSION['shopping_cart_sizes'][$product->product_id] = array();
                }
                $_SESSION['shopping_cart_sizes'][$product->product_id][$product->size] = true;
            }
            foreach($_SESSION['shopping_cart'] as $id=>$product){
                $_SESSION['shopping_cart'][$id] = count($_SESSION['shopping_cart_sizes'][$id]);
            }
            $this->save_cart($user_id, $_SESSION['shopping_cart_sizes']);
            return true;
        }
        else{
            return $user_cart;
        }
    }

    public function debts4manager( $manager_id,  $sum = true, $cashboxes = " NOT IN (13,15)", $date_limit='CURRENT_DATE() - INTERVAL 6 MONTH' ) {
      $manager_id = (int)$manager_id ? (int)$manager_id : $this->get('manager_id');
      if (empty($cashboxes))$cashboxes = " NOT IN (13,15)";
      $fin_filter = "";
      if ($cashboxes == ' = 13' ) $fin_filter = "AND prod.mtm_status = 'Выдано клиенту'";
      if ($cashboxes == ' = 15' ) $users_tmp = $this->db->results($sql="SELECT SUM(op.price) as money_paid, sp.id, op.user_id, u.name, u.phone_number FROM orders_products op LEFT JOIN users u ON u.user_id = op.user_id LEFT JOIN orders o ON o.order_id = op.order_id LEFT JOIN orders_payments sp ON o.order_id = sp.order_id WHERE op.user_id IN (SELECT user_id FROM sr_manager2users WHERE manager_id = {$manager_id}) AND (sp.payment_id IS NULL OR sp.payment_id = 4) AND o.cashbox_id = 15 AND o.date > CURRENT_DATE() - INTERVAL 6 MONTH AND op.price != 0 GROUP BY op.id ORDER BY op.user_id");
      else $users_tmp  = $this->db->results($sql = "SELECT pay.money_paid, pay.id, pay.user_id, users.name, users.phone_number FROM orders_payments pay LEFT JOIN orders_products prod ON prod.order_id = pay.order_id LEFT JOIN orders o ON prod.order_id = o.order_id LEFT JOIN users ON users.user_id = pay.user_id WHERE prod.offline_manager_id = {$manager_id} {$fin_filter} AND pay.payment_id = 4 AND pay.date > {$date_limit} AND o.cashbox_id{$cashboxes} GROUP BY pay.id ORDER BY users.name");
      $debt_total=0;
      $k=0;$users_debts = Array();
      foreach($users_tmp as $user){
        if($id != $user->user_id ){
          $k++;$i=0;$id = $user->user_id;
          $users_debts[$k] = $user;
        }
        if($user->id === null) $users_debts[$k]->debts[$i]->sum = $user->money_paid;
        else{
          $debtpaid   = $this->db->result($sql = "SELECT SUM(money_paid) AS total FROM orders_payments WHERE debt_id = {$user->id}")->total;
          $users_debts[$k]->debts[$i]->sum = $user->money_paid - $debtpaid;
          $users_debts[$k]->debts[$i]->id = $user->id;
        }
        if ($users_debts[$k]->debts[$i]->sum < 501) unset($users_debts[$k]->debts[$i]);
        $debt_total += $users_debts[$k]->debts[$i]->sum;
        $users_debts[$k]->debt_total += $users_debts[$k]->debts[$i]->sum;
        unset($users_debts[$k]->money_paid, $users_debts[$k]->id);
        $i++;
      }
      foreach($users_debts as $k=>$debt){if (empty($debt->debts)) unset($users_debts[$k]);}
      if($sum) return $debt_total;
      else $users_debts[0]->debt_total = $debt_total; return $users_debts;
    }

    public function check_measurments( $user_measurments, $product ) {
      $dd[0] = -1;$dd[1] = 1;
      $measurements = $this->db->result($sql="SELECT im.*, f.id AS fitting, ms.id AS stretch, ms.stretch AS koef
            FROM `items_measuring` im
            LEFT JOIN products p ON im.product_id = p.product_id
            LEFT JOIN items i ON im.item_id = i.item_id
            LEFT JOIN fitting f ON f.id = p.fitting
            LEFT JOIN materials_stretch ms ON ms.id = p.stretch
            WHERE im.product_id ={$product->product_id} AND i.size = '{$product->size}'");
      $umesures = $user_measurments[$product->category_id];
      $pmesures = $measurements;
      $koef = explode(' ',$pmesures->koef);
      $koef[0] = $koef[0]/100;
      $koef[1] = $koef[1]/100;
      $me_error = "";
      if($umesures->shoulders != $pmesures->shoulders && $pmesures->shoulders != 0) {
        $d = $umesures->shoulders - $pmesures->shoulders;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Замер по плечам {$w} допустимого на {$d} <br/>";
      }
      if($umesures->lenght_on_back != $pmesures->lenght_on_back && $pmesures->lenght_on_back != 0) {
        $d = $umesures->lenght_on_back - $pmesures->lenght_on_back;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Длина изделия по спине {$w} допустимой на {$d} <br/>";
      }
      if($umesures->sleeve != $pmesures->sleeve && $pmesures->sleeve != 0) {
        $d = $umesures->sleeve - $pmesures->sleeve;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Длина рукава изделия {$w} допустимой на {$d} <br/>";
      }
      if($umesures->bottom_band != $pmesures->bottom_band && $pmesures->bottom_band != 0) {
        $d = $umesures->bottom_band - $pmesures->bottom_band;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Резинка внизу изделия {$w} допустимой на {$d} <br/>";
      }
      if($umesures->waist_height != $pmesures->waist_height && $pmesures->waist_height != 0) {
        $d = $umesures->waist_height - $pmesures->waist_height;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Высота посадки {$w} допустимой на {$d} <br/>";
      }
      if($umesures->bottom_width != $pmesures->bottom_width && $pmesures->bottom_width != 0) {
        $d = $umesures->bottom_width - $pmesures->bottom_width;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Замер низа брючины {$w} допустимого на {$d} <br/>";
      }
      if($umesures->knee_width != $pmesures->knee_width && $pmesures->knee_width != 0) {
        $d = $umesures->knee_width - $pmesures->knee_width;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Замер колена {$w} допустимого на {$d} <br/>";
      }
      if($umesures->leg_lenght != $pmesures->leg_lenght && $pmesures->leg_lenght != 0) {
        $d = $umesures->leg_lenght - $pmesures->leg_lenght;
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($d>$dd[1] || $d<$dd[0])$me_error .= "Длина брючины {$w} допустимой на {$d} <br/>";
      }
      if($umesures->chest != $pmesures->chest && $pmesures->chest != 0) {
        $d = $umesures->chest - $pmesures->chest;
        $dd[0] = ($koef[0] != 0) ? round($pmesures->chest*$koef[0]) : $dd[0];
        $dd[1] = ($koef[1] != 0) ? round($pmesures->chest*$koef[1]) : $dd[1];
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($w && $d)$me_error .= "Замер объема груди {$w} допустимого на {$d} <br/>";
        unset($w,$d);
      }
      if($umesures->waist != $pmesures->waist && $pmesures->waist != 0) {
        $d = $umesures->waist - $pmesures->waist;
        $dd[0] = ($koef[0] != 0) ? round($pmesures->waist*$koef[0]) : $dd[0];
        $dd[1] = ($koef[1] != 0) ? round($pmesures->waist*$koef[1]) : $dd[1];
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($w && $d)$me_error .= "Замер по талии {$w} допустимого на {$d} <br/>";
        unset($w,$d);
      }
      if($umesures->hips != $pmesures->hips && $pmesures->hips != 0) {
        $d = $umesures->hips - $pmesures->hips;
        $dd[0] = ($koef[0] != 0) ? round($pmesures->hips*$koef[0]) : $dd[0];
        $dd[1] = ($koef[1] != 0) ? round($pmesures->hips*$koef[1]) : $dd[1];
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($w && $d)$me_error .= "Замер по бедрам {$w} допустимого на {$d} <br/>";
        unset($w,$d);
      }
      if($umesures->thigh != $pmesures->thigh && $pmesures->thigh != 0) {
        $d = $umesures->thigh - $pmesures->thigh;
        $dd[0] = ($koef[0] != 0) ? round($pmesures->thigh*$koef[0]) : $dd[0];
        $dd[1] = ($koef[1] != 0) ? round($pmesures->thigh*$koef[1]) : $dd[1];
        if($d>$dd[1]) {$w = "меньше";$d=$d - $dd[1];}
        elseif($d<$dd[0]) {$w = "больше";$d=$d*-1 - $dd[0]*-1;}
        if($w && $d)$me_error .= "Замер по ширине ляжки {$w} допустимого на {$d} <br/>";
        unset($w,$d);
      }
      if(!in_array($pmesures->fitting,$umesures->fitting)){
        $r_fitting = $this->db->result($sql="SELECT GROUP_CONCAT(name) AS name FROM fitting WHERE id IN (".implode(',',$umesures->fitting).")")->name;
        $me_error .= "Пользователь носит вещи {$r_fitting} <br/>";
      }
      return $me_error;
    }

    public function generate_pass( $user_id, $output=false, $pass_data=false ) {
      $user = $this->db->get_row("SELECT * FROM `users` WHERE user_id = '{$user_id}'");
      if($user->card_number){
        set_include_path(get_include_path() . PATH_SEPARATOR . $_SERVER['DOCUMENT_ROOT'] . '/third_party/PHP_PKPass/');
        require_once 'PKPass.php';

        $pass = new PKPass\PKPass();
        $pass->setCertificate($_SERVER['DOCUMENT_ROOT'] . '/third_party/PHP_PKPass/Certificate/wallet.p12');  // 2. Set the path to your Pass Certificate (.p12 file)
        $pass->setCertificatePassword('Thtdfycrfz16');     // 2. Set password for certificate
        $pass->setWWDRcertPath($_SERVER['DOCUMENT_ROOT'] . '/third_party/PHP_PKPass/Certificate/AppleWWDRCA.pem'); // 3. Set the path to your WWDR Intermediate certificate (.pem file)

        if($pass){
          if(!$pass_data){
            $update = false;
            set_include_path(get_include_path() . PATH_SEPARATOR . $_SERVER['DOCUMENT_ROOT'] . '/third_party/RandomLib/');
            require_once 'autoload.php';
            $string = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            $factory = new RandomLib\Factory;
            $generator = $factory->getMediumStrengthGenerator();
            $pass_data->authentication_token = $generator->generateString(32, $string);
            $pass_data->pass_type = 'pass.globus.LuxuryStore';
            $pass_data->pass_id = $this->db->result("SELECT IFNULL(MAX(pass_id), 0)+1 as id FROM apple_pkpass WHERE pass_type = '{$pass_data->pass_type}';")->id;
          }
          else{$update = true;}

          $personal_discount = $this->get('personal_discount');
          if($personal_discount == 0){$sale = "до 5%";}
          else{$sale = "от $personal_discount%";}
          if($user->user_status == 'VIP'){
            $status->level = 'GOLD';
            $status->color = 'rgb(171, 153, 49)';
            $status->sale = $sale;
            $path = 'images/pass_images/gold/';
          }
          else{
            $status->level = 'LUXURY';
            $status->color = 'rgb(77, 170, 233)';
            $status->sale = $sale;
            $path = 'images/pass_images/luxury/';
          }

          $data = file_get_contents('third_party/PHP_PKPass/pass_general.json');
          if(isset($_GET['event'])){$data = file_get_contents('third_party/PHP_PKPass/pass_event.json');}
          if(isset($_GET['coupon'])){$data = file_get_contents('third_party/PHP_PKPass/pass_coupon.json');}

          $cardnumber = substr($user->card_number, -16);
          if(isset($_COOKIE['language']) == 'eng') {
            $phonenumber = $user->phone_number;
            $description = "Client card";
            $CardNumberLabel = "Card Number";
            $StatusLevelLabel = "Status";
            $StatusSaleLabel = "Sale";
            $UserPhoneLabel = "Client phone number";
            $UserPhoneValue = "or";
            $site = "Shop website";
            $help_phone = "Help Phone";
            $infoLabel = "By using the card you confirm that:";
            $infoValue = "You agree with the conditions of participation in the loyalty Program Luxury Store";
          }
          else {
            $phonenumber = '+7' . substr($user->phone_number, -10);
            $description = "Карта клиента";
            $CardNumberLabel = "Номер Карты";
            $StatusLevelLabel = "Статус";
            $StatusSaleLabel = "Скидка";
            $UserPhoneLabel = "Номер телефона клиента";
            $UserPhoneValue = "или";
            $site = "Сайт магазина";
            $help_phone = "Единая справочная служба";
            $infoLabel = "Используя карту вы подтверждаете, что:";
            $infoValue = "Согласны с условиями участия в Программе поощрения клиентов Лакшери Стор";
          }
          $search = array('{passTypeIdentifier}','{serialNumber}','{authenticationToken}','{CardNumber}','{backgroundColor}','{UserName}','{StatusLevel}','{StatusSale}','{UserPhone}','{description}','{CardNumberLabel}','{StatusLevelLabel}','{StatusSaleLabel}','{UserPhoneLabel}','{UserPhoneValue}','{site}','{help_phone}','{infoLabel}','{infoValue}');
          $replace = array($pass_data->pass_type,$pass_data->pass_id,$pass_data->authentication_token,$cardnumber,$status->color,$user->name,$status->level,$status->sale,$phonenumber,$description,$CardNumberLabel,$StatusLevelLabel,$StatusSaleLabel,$UserPhoneLabel,$UserPhoneValue,$site,$help_phone,$infoLabel,$infoValue);
          $data = str_replace($search,$replace, $data);
          $pass->setData($data);
                //mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . '- pass - log:', $data);

          // Add images to the pass
          $pass->addFile('images/pass_images/icon.png');
          $pass->addFile('images/pass_images/icon@2x.png');
          $pass->addFile('images/pass_images/logo.png');
          $pass->addFile('images/pass_images/logo@2x.png');
          $pass->addFile('images/pass_images/thumbnail.png');
          $pass->addFile('images/pass_images/thumbnail@2x.png');
          if(isset($_GET['event'])){
            $pass->addFile($path.'background.png');
            $pass->addFile($path.'background@2x.png');
            $pass->addFile($path.'background@3x.png');
          }
          elseif(isset($_GET['coupon'])){
            $pass->addFile($path.'strip.png');
            $pass->addFile($path.'strip@2x.png');
            $pass->addFile($path.'strip@3x.png');
          }

          // Create and output the pass
          $file = $pass->create($output);
          if($file == false){
            echo 'Error: ' . $pass->getError();
            $data = 'Error: ' . $pass->getError();
            mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - Error:', $data);
            return false;
          }else{
            if($update){
              $this->db->query($sql = "UPDATE apple_pkpass SET upd_date = NOW(), upd = 0 WHERE pass_id = '{$pass_data->pass_id}' AND pass_type = '{$pass_data->pass_type}';");
            }
            else{
              $this->db->query($sql = "INSERT INTO apple_pkpass (pass_id,authentication_token,pass_type,upd_date,user_id) VALUES ('{$pass_data->pass_id}','{$pass_data->authentication_token}','{$pass_data->pass_type}', NOW(),'{$user->user_id}')");
            }
            if($output == false){
              return $file;
            }else{
              return true;
            }
          }
        }
      }
    }
}
