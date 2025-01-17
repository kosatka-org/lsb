<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');
require_once('../models/user.php');


class User extends Widget {

    var $user;
    function User(&$parent) {
        Widget::Widget($parent);
        $this->add_param('page');
        $this->add_param('group_id');
        $this->prepare();
    }

    function prepare() {
        $user_id = $this->param('user_id');
        $user_data = $this->db->get_row("SELECT * FROM `users` WHERE user_id = '{$user_id}'");
        if (isset($_GET['get_calls']) && !empty($_GET['get_calls'])) {
            $limit = ((int) $_GET['get_calls'])*5;
            $calls = $this->db->results("SELECT * FROM calls WHERE client_id IN (SELECT user_id FROM users WHERE original_user_id = {$user_id}) ORDER BY `date` DESC LIMIT {$limit},5;");
            $return = "";
            foreach($calls as $call){
                $dir = ($call->direction == 'out') ? "звонок менеджера клиенту с номера" : "звонок клиента менеджеру на номер";
                $return .= "<div style='margin-top:12px;font-size:14px;'>
                            {$call->date} - {$dir} {$call->sip_id} -- <a href='/cron/sip_calls/{$call->filename}' download>Скачать</a><br>
                            <audio src='/cron/sip_calls/{$call->filename}' preload='auto' />
                        </div>";
            }
            echo $return;
            die();
        }
        if ( isset($_POST['name']) ) {
            if($_POST['alt_phone']){
              foreach($_POST['alt_phone'] as $k=>$ap){
                if ( strlen($ap) == 10 ) $_POST['alt_phone'][$k] = '7' . $ap;
              }
            }
            if ( strlen($_POST['phone_number']) == 10 ) $_POST['phone_number'] = '7' . $_POST['phone_number'];
            if($_SESSION['user']->group_id != 2)$superuser = $user_data->superuser;
            else $superuser = isset($_POST['superuser'])      ? $_POST['superuser'] : 0;
            $enabled        = isset($_POST['enabled'])        ? $_POST['enabled']    : 0;
            $sex            = isset($_POST['sex'])            ? $_POST['sex']        : 1;
            $has_purchase   = isset($_POST['has_purchase'])   ? $_POST['has_purchase'] : 0;
            $intagramm_user = isset($_POST['intagramm_user']) ? $_POST['intagramm_user'] : '';
            $debt_limit     = isset($_POST['debt_limit'])     ? $_POST['debt_limit'] : $user_data->debt_limit;
            $slack_name     = !empty($user_data->slack_name)  ? $user_data->slack_name : '';
            $slack_name     = isset($_POST['slack_name'])     ? $_POST['slack_name'] : $slack_name;
            $hidden_brands  = isset($_POST['hidden_brands'])  ? implode(",", $_POST['hidden_brands'])  : '';
            $cashboxes      = isset($_POST['cashboxes'])      ? implode(",", $_POST['cashboxes'])  : '';
            $bookmarks      = isset($_POST['bookmarks'])      ? implode(",", $_POST['bookmarks'])  : '';
            $pref_delivery  = isset($_POST['pref_delivery'])  ? implode(', ',$_POST['pref_delivery'])  : '';
            $pref_messenger = isset($_POST['pref_messenger']) ? implode(', ',$_POST['pref_messenger']) : '';
            $warehouses     = isset($_POST['warehouses'])     ? implode(', ',$_POST['warehouses']) : '';
            $m_types        = isset($_POST['m_types'])        ? implode(', ',$_POST['m_types']) : '';
            $alt_phones     = isset($_POST['alt_phone'])      ? implode('|',array_filter($_POST['alt_phone'])) : '';
            $alt_addresses  = isset($_POST['alt_address'])    ? implode('|',array_filter($_POST['alt_address'])) : '';


            if ($_POST['comment']) {
                $comment = $_POST['comment'];
                $this->db->query("INSERT INTO user_comments (user_id, commenter_id, text, date) VALUES ({$user_id}, {$_SESSION['user']->user_id}, '{$comment}', NOW())");
            }
            if ($_POST['sen_manager']) {
                $sen_manager = $_POST['sen_manager'];
                $this->db->query("DELETE FROM sen_manager2manager WHERE manager =".$user_id);
                $this->db->query("INSERT INTO sen_manager2manager (sen_manager, manager) VALUES ({$sen_manager}, {$user_id})");
            }
            $p_manager_id = "";
            if ($_POST['p_manager_id']) {
                $p_manager_id = $_POST['p_manager_id'];
            }
            if ($_POST['sip']) {
                $sip = $_POST['sip'];
                $check = $this->db->result("SELECT * FROM users2sips WHERE user_id = {$user_id} AND sip_id = '{$sip}' LIMIT 1;");
                if (!$check){
                    $this->db->query("INSERT INTO users2sips (user_id, sip_id) VALUES ({$user_id}, '{$sip}')");
                }
            }
            if ($_POST['sales_target']) {
              $this->db->query("UPDATE users SET sales_target = {$_POST['sales_target']} WHERE user_id = {$user_id}");
            }
            if ($_POST['decline_rate']) {
              $this->db->query("UPDATE users SET decline_rate = {$_POST['decline_rate']} WHERE user_id = {$user_id}");
            }
            $city = '';
            if ($_POST['city_id']) {
                $city = $this->db->result("SELECT city_name FROM delivery_cities WHERE city_id = {$_POST['city_id']} LIMIT 1;")->city_name;
            }
            if (isset($_POST['workcity_id'])) {
                $workcity_id = $_POST['workcity_id'];
                $this->db->query($sql = "UPDATE users SET workcity_id = {$workcity_id} WHERE user_id = '{$user_id}'");
            }

            if($_POST['phone_number'] != $user_data->phone_number || $_POST['name'] != $user_data->name || $user_data->personal_discount != $_POST['personal_discount']){
              $this->db->query($sql = "UPDATE apple_pkpass SET upd = 1 WHERE user_id = '{$user_id}';");
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

            $card_number = $this->db->escape($_POST['card_number']);
            $this->db->query($sql = "UPDATE users SET password = MD5(RAND()) WHERE user_id = '{$user_id}' AND card_number <> '{$card_number}' LIMIT 1");

            $this->db->query($sql=sql_placeholder('
                UPDATE users SET name=?, email=?, sex=?, group_id=?, subgroup_id=?, user_status=?, enabled=?, phone_number=?, alt_phones=?, card_number=?, city=?, city_id=?, adress=?, alt_addresses=?, home_phone=?, birth_date=?, show_hidden_brands=?, cashbox_ids=?, p_manager_id=?, comment=?, pref_delivery=?, pref_messenger=?, has_purchase=?, debt_limit=?, slack_name=?, intagramm_user=?, superuser=?, bookmarks=?, warehouses=?, m_types=? WHERE user_id=? LIMIT 1',
                        $_POST['name'], $_POST['email'], $sex, $_POST['group_id'], $_POST['subgroup_id'], $_POST['user_status'], $enabled, $_POST['phone_number'], $alt_phones, $_POST['card_number'], $city, $_POST['city_id'], $_POST['adress'], $alt_addresses, $_POST['home_phone'], $_POST['birth_date'], $hidden_brands, $cashboxes, $p_manager_id, $_POST['comment'], $pref_delivery, $pref_messenger, $has_purchase, $debt_limit, $slack_name, $intagramm_user, $superuser, $bookmarks, $warehouses, $m_types, $user_id));

            Job::push('UpdatePurchaseSumJob', [$user_id]);

            $this->db->query("DELETE FROM users2shops WHERE user_id =".$user_id);
            foreach ($_POST['shop'] as $key => $sh) {
                $this->db->query("INSERT INTO users2shops (user_id, shop_id) VALUES (".$user_id.", ".(int)$sh.")");
            }

            $this->db->query("DELETE FROM sr_manager2users WHERE user_id =".$user_id);
            $sr_manager_id = array_filter($_POST['sr_manager_id']);
            foreach ($sr_manager_id as $key => $sh) {
                $this->db->query("INSERT INTO sr_manager2users (manager_id, user_id) VALUES (".(int)$sh.", ".$user_id.")");
            }

            $this->db->query("DELETE FROM users2brands WHERE user_id =".$user_id);
            foreach ($_POST['brand'] as $key => $sh) {
                $this->db->query("INSERT INTO users2brands (user_id, brand_id) VALUES (".$user_id.", ".(int)$sh.")");
            }

            $this->db->query("DELETE FROM users_offline_brands WHERE user_id =".$user_id);
            foreach ($_POST['offline_brands'] as $key => $br) {
                $this->db->query("INSERT INTO users_offline_brands (user_id, brand_id) VALUES ($user_id, $br)");
            }

            // Сохранение персональной скидки
            if ( isset($_POST['personal_discount']) ) {
                $user = new luser($user_id);
                if ( $user->get('personal_discount') != $_POST['personal_discount'] && $user->save_personal_discount( $user_id, $_POST['personal_discount'], $_SESSION['user']->user_id ) ) {
                  if($_COOKIE['language'] == 'eng'){$message = "Your personal card №{$_POST['card_number']} was assigned with {$_POST['personal_discount']}% discount. Yours www.lsboutique.ru";}
                  else{$message = "По вашей карте №{$_POST['card_number']} назначена персональная скидка {$_POST['personal_discount']}%. Ваш www.lsboutique.ru";}
                  $args = array( 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $_POST['phone_number'], $user_id );
                  Job::push( 'SmsJob', $args, false, 'critical' );
                }
            }
        }

        if (isset($_GET['delete_comment_id']) && isset($_GET['user_id'])) {
            $user_id = (int) $_GET['user_id'];
            $delete_comment_id  = (int) $_GET['delete_comment_id'];
            $this->db->query("DELETE FROM user_comments WHERE id = {$delete_comment_id} AND user_id = {$user_id}");

            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }

        if (isset($_GET['delete_sip_id'])) {
            $sip_id = (int) $_GET['delete_sip_id'];
            $this->db->query("DELETE FROM users2sips WHERE id = {$sip_id}");

            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }

        $this->db->query(sql_placeholder("SELECT *, PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'),DATE_FORMAT(users.card_registered,'%Y%m')) AS user_age FROM users WHERE user_id=? LIMIT 1", $user_id));
        $this->user = $this->db->result();
    }

    function fetch() {
        $this->title = $this->lang->EDIT_USER;
        if(empty($this->user)){
            header("Location: index.php?section=Users");
            exit();
        }

        $groups = $this->db->results("SELECT * FROM groups ORDER BY discount;");

        $managers = $this->db->results("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 5 ORDER BY name;");
        $sr_managers = $this->db->results("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 13 ORDER BY name;");

        $sr_managers_act = $this->db->results("SELECT srm.manager_id, u.name FROM sr_manager2users srm LEFT JOIN users u ON srm.manager_id = u.user_id WHERE srm.user_id = '{$this->user->user_id}';");
        if(empty($sr_managers_act)){$sr_managers_act = array(0);}

        $comments = $this->db->results("SELECT user_comments.*, users.name
            FROM user_comments
            LEFT JOIN users ON user_comments.commenter_id = users.user_id
            WHERE user_comments.user_id = {$this->user->user_id}");

        $this->user->name  = mb_convert_case($this->user->name, MB_CASE_TITLE, "UTF-8");
        $shops             = $this->db->results("SELECT shop_id FROM users2shops WHERE user_id = ".$this->user->user_id);
        $this->user->shops = array();
        foreach ($shops as $k => $sh) {
            $this->user->shops[$k] = $sh->shop_id;
        }
        $this->user->shops[] = $this->user->shop;

        // определить менеджера
        if ($this->user->p_manager_id){
            $this->user->p_manager_name = $this->db->result("SELECT name FROM `users` WHERE user_id = {$this->user->p_manager_id} LIMIT 1;")->name;
        }

        // Sip пользователя если есть
        $sips = $this->db->results("SELECT * FROM users2sips WHERE user_id IN (SELECT user_id FROM users WHERE original_user_id = {$this->user->original_user_id}) ORDER BY `id` DESC;");
        $this->smarty->assign("sips", $sips);

        // процент возвратов
        $this->user->user_return_rate = luser::get_return_rate($this->user->user_id);
        
        // определить старшего менеджера
        if ($this->user->group_id > 8 && $this->user->subgroup_id != 4){
            $this->user->sen_manager = $this->db->result("SELECT sen_manager FROM sen_manager2manager WHERE manager = {$this->user->user_id} LIMIT 1;")->sen_manager;
        }
        $this->user->alt_phones = explode('|',$this->user->alt_phones);
        $this->user->alt_addresses = explode('|',$this->user->alt_addresses);

        $messengers = $this->db->results("SELECT * FROM messengers WHERE name != ''");

        $statuses = array('VIP','хороший','Shopper','low cost','мутный','вредитель');

        $this->user->stop_list_history = $this->db->results("SELECT sth.*, u.name AS m_name FROM `stop_list_history` sth LEFT JOIN users u ON u.user_id = sth.manager_id WHERE sth.user_id = {$this->user->user_id} ORDER BY date DESC;");

        $this->smarty->assign('workcities', $this->db->results("SELECT city_id, city_name FROM delivery_cities WHERE city_id IN (992,1054);"));
        $this->smarty->assign('delivery_cities_main', $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;"));
        $this->smarty->assign('delivery_cities',      $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '0' ORDER BY city_name;"));
        $this->smarty->assign('dcompanies', $this->db->results("SELECT * FROM delivery_companies WHERE active =1"));
        $this->smarty->assign('Managers', $managers);
        $this->smarty->assign('sr_Managers', $sr_managers);
        $this->smarty->assign('sr_Managers_act', $sr_managers_act);
        $this->smarty->assign('Statuses', $statuses);
        $this->smarty->assign('Messengers', $messengers);
        $this->smarty->assign('comments', $comments);
        $this->smarty->assign('SubGroups',  $this->db->results("SELECT * FROM subgroups WHERE group_id = {$this->user->group_id} ORDER BY name;"));
        $this->smarty->assign('sen_managers',  $this->db->results("SELECT * FROM users WHERE group_id = 13 AND subgroup_id = 4 ORDER BY name;"));
        $this->smarty->assign('Groups',   $groups);
        $this->smarty->assign('User',     $this->user);
        $this->smarty->assign('Error',    $this->error_msg);
        $this->smarty->assign('Lang',     $this->lang);

        // определить магазины
        $this->smarty->assign('shops', $this->db->results("SELECT s.shop_id, s.name FROM shops s WHERE s.shop_id NOT IN(1048,1049,1050)"));

        // определить бренды
        $subscriptions = $this->db->results($sql = "SELECT * FROM users2brands WHERE user_id = '{$this->user->user_id}' AND status = '1';");

        // определить ТК
        $this->smarty->assign('U_companies', explode(', ',$this->user->pref_delivery));

        // определить месcеджеры
        $this->smarty->assign('U_Messengers', explode(', ',$this->user->pref_messenger));

        $subscribed_brands[] = array();
        foreach ($subscriptions as $sub) {
            $subscribed_brands[] = $sub->brand_id;
        }

        $this->smarty->assign('all_hidden_brands', $this->db->results("SELECT * FROM brands WHERE visibility = 4"));
        $this->smarty->assign('all_cashboxes', $this->db->results("SELECT * FROM shop_cashbox WHERE enabled = 1"));
        $this->smarty->assign('all_bookmarks', $this->db->results("SELECT * FROM bookmarks"));
        $this->smarty->assign('all_warehouses', $this->db->results("SELECT * FROM warehouses"));
        $this->smarty->assign('all_m_types', $this->db->results("SELECT * FROM movement_types"));
        $this->smarty->assign('active_cashboxes', explode(",", $this->user->cashbox_ids));
        $this->smarty->assign('active_bookmarks', explode(",", $this->user->bookmarks));
        $this->smarty->assign('active_warehouses', explode(",", $this->user->warehouses));
        $this->smarty->assign('active_m_types', explode(",", $this->user->m_types));
        $this->smarty->assign('brands', $this->db->results("SELECT * FROM `brands` ORDER BY name;"));
        $this->smarty->assign('offline_brands', $this->db->results("SELECT b.*, uob.user_id AS active FROM brands b LEFT JOIN users_offline_brands uob ON uob.brand_id = b.brand_id AND uob.user_id = {$this->user->user_id} WHERE b.offline_only=1 ORDER BY b.name;"));
        $this->smarty->assign('subscribed_brands', $subscribed_brands);
        $this->smarty->assign('show_hidden_brands', explode(",", $this->user->show_hidden_brands));

        // определить размеры
        $size_types = $this->db->results($sql = "SELECT * FROM size_types
                                    LEFT JOIN sizes ON sizes.size_type = size_types.type_id
                                    WHERE 1;");
        foreach($size_types as $size){
            $i=0;
            $all_sizes[$size->type_id]->name = $size->type_name;

            $all_sizes[$size->type_id]->sizes[$size->size_id]->id = $size->size_id;
/*
            if (!empty($size->ru_size)){
                if (!in_array('Россия (RU)',$all_sizes[$size->type_id]->sizes[0]->values)){
                    $all_sizes[$size->type_id]->sizes[0]->values[$i] = 'Россия (RU)';
                }
                $all_sizes[$size->type_id]->sizes[$size->size_id]->values[$i] = $size->ru_size;
                $i++;
            }
*/
            if (!empty($size->int_size)){
                if (!in_array('Международный (INT)',$all_sizes[$size->type_id]->sizes[0]->values)){
                    $all_sizes[$size->type_id]->sizes[0]->values[$i] = 'Международный (INT)';
                }
                $all_sizes[$size->type_id]->sizes[$size->size_id]->values[$i] = $size->int_size;
                $i++;
            }
            $sizes_add = $this->db->results($sql = "SELECT * FROM size_names WHERE size_id = {$size->size_id};");
            foreach($sizes_add as $sa){
                if (!in_array($sa->size_m_s,$all_sizes[$size->type_id]->sizes[0]->values)){
                    $all_sizes[$size->type_id]->sizes[0]->values[$i] = $sa->size_m_s;
                }
                $all_sizes[$size->type_id]->sizes[$size->size_id]->values[$i] = $sa->size;
                $i++;
            }
            asort($all_sizes[$size->type_id]->sizes);
        }
        $this->smarty->assign('sizes',  $all_sizes );

        // определить размеры пользователя
        $user_sizes = $this->db->results($sql = "SELECT * FROM users2sizes_n WHERE `user_id` = '{$this->user->user_id}';");
        $user_sizes_res[] = array();
        foreach ($user_sizes as $size) {
            $user_sizes_res[] = $size->size_id;
        }
        $this->smarty->assign('user_sizes', $user_sizes_res);

        // определить покупки
        $users = $this->db->results("SELECT user_id FROM users WHERE original_user_id = '{$this->user->original_user_id}' ");
        $user_keys = array();
        foreach ($users as $key) {
            $user_keys[] = $key->user_id;
        }
        $user_keys = implode(',', $user_keys);

        $query = "SELECT op.product_name, op.status, op.price as real_price, op.status_date as date, op.size, o.order_id, p.large_image as image, p.url as product_url, p.old_price as price, ROUND((p.old_price-op.price)/p.old_price*100) as sale
                    FROM orders_products op
                    LEFT JOIN orders   o ON op.order_id = o.order_id
                    LEFT JOIN products p ON op.product_id = p.product_id
                  WHERE o.cashbox_id = 0 AND o.user_id IN ({$user_keys}) AND o.status != 3 
                  ORDER BY op.status_date DESC";
        $this->smarty->assign('purchases_on',   $this->db->results($query) );

        $query = "SELECT op.product_name, op.status, op.price as real_price, o.date as date, op.size, o.order_id, p.large_image as image, p.url as product_url, p.old_price as price, ROUND((p.old_price-op.price)/p.old_price*100) as sale, o.receipt_number
                    FROM orders_products op
                    LEFT JOIN orders   o ON op.order_id = o.order_id
                    LEFT JOIN products p ON op.product_id = p.product_id
                  WHERE o.cashbox_id > 0 AND o.user_id IN ({$user_keys})
                  ORDER BY o.date DESC";
        $this->smarty->assign('purchases_off',  $this->db->results($query));

        // Звонки клиента
        $calls = $this->db->results("SELECT * FROM calls WHERE client_id IN (SELECT user_id FROM users WHERE original_user_id = {$this->user->original_user_id}) ORDER BY `date` DESC LIMIT 5;");
        $this->smarty->assign("calls", $calls);

        // сумма покупок в интернет-магазине
        $this->user->online_sum = $this->db->result("SELECT SUM(price) AS sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.user_id IN ({$user_keys}) AND op.status = 5 AND receipt_number = 0")->sum;


        $this->user->offline_sum = $this->db->result($sql = "SELECT SUM(price) AS sum FROM orders_products op LEFT JOIN orders o ON o.order_id = op.order_id WHERE o.user_id IN ({$user_keys}) AND receipt_number != 0")->sum;
        $debts = $this->db->results($sql = "SELECT * FROM orders_payments WHERE payment_id = 4 AND user_id IN ({$user_keys})");
        foreach($debts as $debt){
          $this->user->debt_total += $debt->money_paid;
          $this->user->debt_payments += $this->db->result($sql = "SELECT SUM(money_paid) AS total FROM orders_payments WHERE debt_id = {$debt->id}")->total;
        }
        $this->user->debt_unpaid = $this->user->debt_total - $this->user->debt_payments;

        // последние просмотренные товары
        $query = "SELECT pv.date AS view_date, pv.price_at_the_time AS view_price, pv.app_view, p.* FROM product_views pv LEFT JOIN products p ON p.product_id = pv.product_id WHERE pv.user_id = {$this->user->user_id} ORDER BY pv.date DESC LIMIT 300";
        $this->smarty->assign('viewed_products',    $this->db->results($query) );

        if ( $this->param('keys') ) {
            if ( $this->param('unlink') ) {
                $this->db->query("UPDATE users SET original_user_id = user_id WHERE user_id = '" . $this->param('unlink') . "' LIMIT 1;");
            }
            $users = $this->db->results("SELECT * FROM users WHERE original_user_id = '{$this->user->original_user_id}' ");
            $this->smarty->assign('Users',  $users);

            $this->body = $this->smarty->fetch('user_keys.tpl');
        }
        else if ( $this->param('similar') ) {
        if ( $this->param('link_id') ) {
            $this->db->query("UPDATE users SET original_user_id = '" . $this->param('original_user_id') . "' WHERE user_id = '" . $this->param('link_id') . "' AND group_id = 1 LIMIT 1;");
        }

        if ( !empty($this->user->original_user_id) ) {
            $sql = "SELECT * FROM users WHERE original_user_id <> '{$this->user->original_user_id}' AND group_id = 1 AND ( 0 "
                        . ( strlen($this->user->name)         > 0 ? " OR name  LIKE '%" . str_replace(' ', '%', $this->user->name) . "%' " : '')
                        . ( strlen($this->user->email)        > 0 ? " OR email = '" . $this->user->email . "' " : '')
                        . ( strlen($this->user->phone_number) > 9 ? " OR phone_number LIKE '%" . substr( $this->user->phone_number, -10) . "' " : '');
            $sql .= ')';
            $users = $this->db->results($sql);
            $this->smarty->assign('Users',  $users);
        }

        $this->body = $this->smarty->fetch('user_similar.tpl');
        }
        else if ( $this->param('deposit') ) {
            $luser           = new luser($this->user->user_id);
            $deposit_history = $luser->get_deposit_history ($this->user->original_user_id);
            $this->smarty->assign('deposit_history',    $deposit_history);
            $this->body      = $this->smarty->fetch('user_deposit.tpl');
        }
        else if ( $this->param('measuring') ) {
          /*$accept_history = $this->db->results($sql="SELECT im*, c.name AS category_name, op.status_date, f.name AS fitting, ms.name AS material_stretch 
              FROM `orders_products` op 
              LEFT JOIN products p ON p.product_id = op.product_id 
              LEFT JOIN categories c ON p.category_id = c.category_id 
              LEFT JOIN items i ON i.product_id = op.product_id AND i.size = op.size
              LEFT JOIN items_measuring im ON i.item_id = im.item_id 
              LEFT JOIN fitting f ON f.id = p.fitting 
              LEFT JOIN materials_stretch ms ON ms.id = p.stretch 
              WHERE op.status = 5 AND user_id ={$this->user->user_id} AND im.id IS NOT NULL
              ORDER BY op.status_date DESC");*/
          $user_measurments = $this->db->results($sql="SELECT um.*, c.name AS category_name, f.name AS fitting, ms.name AS material_stretch 
              FROM `users_measuring` um 
              LEFT JOIN categories c ON um.category_id = c.category_id 
              LEFT JOIN fitting f ON f.id = um.fitting 
              LEFT JOIN materials_stretch ms ON ms.id = um.stretch 
              WHERE um.user_id ={$this->user->user_id}");
          //$this->smarty->assign('accept_history',    $accept_history);
          $this->smarty->assign('user_measurments',  $user_measurments);
          $this->body      = $this->smarty->fetch('user_measuring.tpl');
        }
        else {
            $crm_data = luser::get_from_crm( array('user_id'=>$this->user->original_user_id, 'alt_user_id'=>$this->user->user_id, 'limit'=>100) );
            $this->smarty->assign('crm_data', $crm_data);
            $offline_sum = 0;
            $code = '';
            if ($this->user->code) {
                $code = str_pad($this->user->code, 9, "0", STR_PAD_LEFT);
            }
            $this->user->offline_sum += $this->db->result($sql="SELECT SUM(sum_with_discount) as sum FROM prodazhi WHERE user_id IN ({$user_keys})")->sum;

            $full_sum = $this->user->offline_sum + $this->user->online_sum;
            if($this->user->purchase_sum_real > $full_sum){
                $full_sum = $this->user->purchase_sum_real;
            }
            $this->smarty->assign('full_sum', $full_sum);

            $this->body = $this->smarty->fetch('user.tpl');
        }
    }
}
