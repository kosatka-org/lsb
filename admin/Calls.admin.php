<?PHP
require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('../placeholder.php');


class Calls extends Widget
{
    var $pages_navigation;
    var $items_per_page = 40;
    function Calls(&$parent) {
    parent::Widget($parent);
        $this->add_param('page');
        $this->add_param('group');
        $this->add_param('keyword');

        $this->pages_navigation = new PagesNavigation($this);
        $this->prepare();
    }



    function prepare()
    {
        if (isset($_POST['user_count'])) {
            $data = json_decode($_POST['data']);
            $this->user_count($data);
        }

        if ( isset($_GET['call_user']) && isset($_GET['status']) && isset($_GET['phone_number']) && isset($_GET['call_id']) ) {
            luser::save_call_status($_GET['call_user'], $_GET['status'], $_GET['phone_number'], $_GET['call_id']);
            $call_id = (int)$_GET['call_id'];
            if ( $call_id && $_GET['status'] == 'call' ) {
                $this->db->query("UPDATE users_calls SET stat_called = stat_called+1 WHERE id = '{$call_id}';");
            }
            elseif ( $call_id && $_GET['status'] == 'sms' ) {
                $call = $this->db->result("SELECT * FROM users_calls WHERE id = {$call_id}");
                $user_id = (int)$_GET['call_user'];
                $user = $this->db->result("SELECT * FROM users WHERE user_id = {$user_id}");
                $sms_text = str_replace("{USERNAME}", $user->name, $call->sms_template);
                $sms_text = str_replace("{CARDNUMBER}", $user->card_prepeared, $sms_text);
                echo $sms_text;
                send_sms_to_phone($user->phone_number, $call->sms_template);
                $this->db->query("UPDATE users_calls SET stat_sms = stat_sms+1 WHERE id = {$call_id}");
            }
            die('ok');
        }

        if (isset($_GET['delete_call'])) {
            $call = (int) $_GET['delete_call'];
            $this->db->query("DELETE FROM users_calls WHERE id = {$call}");
        }
    }

    function user_count($data) {
        $brands = $data->call_brands;
        $users  = array();
        foreach ($brands as $v) {
            $users_tmp = luser::get_users_for_brand($v);
            if ( is_array($users_tmp) && count($users_tmp) )
            foreach ($users_tmp as $vv) {
                $users[$vv->user_id] = $vv->user_id;
            }
        }
        $users = implode($users, ',');
        $brands = implode($data->call_brands, ',');

        if (count($data->shop) > 1) {
            $shops = "'" . implode("', '", $data->shop) . "'";
        }
        else {
            $shops = "'" . $data->shop[0] . "'";
        }

        $filter = "users.purchase_sum_real >= {$data->sum_min} ";

        if ($data->sex) {
            $filter .= " AND users.sex = {$data->sex} ";
        }

        if (!empty($data->call_brands)) {
            $filter .= " AND (users.original_user_id IN ({$users}) OR users2brands.brand_id IN ({$brands})) ";
        }

        if (!empty($data->shop)) {
            $filter .= " AND users2shops.shop IN ({$shops}) ";
        }

        $query = "SELECT COUNT(DISTINCT original_user_id) AS count FROM users
            LEFT JOIN users2brands ON users.user_id = users2brands.user_id
            LEFT JOIN users2shops ON users.user_id = users2shops.user_id
            WHERE {$filter}";
        $res = $this->db->result($query);
        echo $res->count;
        exit();
    }

    function calls_action() {
        if (!empty($_POST['call_name'])) {
            if (is_array($_POST['call_brands']) && count($_POST['call_brands'])>0) {
                $call_brands = implode(",",$_POST['call_brands']);
            }
            else {
                $call_brands = '';
            }

            if (is_array($_POST['shop']) && count($_POST['shop'])>0) {
                $shop = implode(",",$_POST['shop']);
            }
            else {
                $shop = '';
            }
            $query = sql_placeholder("INSERT INTO users_calls (user_id,name,date,sex,moderator_id,shop,brands,sms_template,sum_min,sum_max)
                VALUES (?,?,NOW(),?,?,?,?,?,?,?)",
                $_SESSION['user']->user_id,
                $_POST['call_name'],
                $_POST['sex'],
                $_POST['moderator'],
                $shop,
                $call_brands,
                $_POST['sms_template'],
                $_POST['sum_min'],
                0);
            $this->db->query($query);
        }


        $filter = " users.name <> '' ";

        $group_id = 1;
        $this->smarty->assign('shops', $this->db->results("SELECT * FROM shops;") );
        $this->smarty->assign('brands', $this->db->results("SELECT * FROM brands ORDER BY name ASC"));
        $ucalls = $this->db->results("SELECT uc. * , u.name AS moderator_name FROM users_calls uc LEFT JOIN users u ON uc.moderator_id = u.user_id WHERE 1 ");
        foreach ($ucalls as $k=>$v) {
            $ucalls[$k]->brands_list = $this->db->results("SELECT * FROM brands WHERE brand_id IN ({$v->brands})");
            $ucalls[$k]->stat_total_percent = round($ucalls[$k]->stat_total == 0 ? 0 : ($ucalls[$k]->stat_called)*100 / $ucalls[$k]->stat_total);
            $ucalls[$k]->stat_total_waiting = $ucalls[$k]->stat_total - $ucalls[$k]->stat_called - $ucalls[$k]->stat_missing;
        }
        $this->smarty->assign('users_calls', $ucalls);
        $this->smarty->assign('moderators', $this->db->results("SELECT * FROM users WHERE group_id IN (2,3,5)"));
        $filter .= " AND users.enabled = '1' AND users.new_user_database = '1' AND users.user_id = users.original_user_id AND ( users.phone_number <> '' AND LENGTH( users.phone_number ) < 12 ) ";
        $order  = "ORDER BY last_phone_call_status, last_phone_call, users.name ";
        $this->add_param('calls');
        $this->add_param('sex');
        $this->add_param('shop');
        $this->add_param('brand');

        if ( isset($_GET['archive']) ) {
            $this->body = $this->smarty->fetch('users_calls_archive.tpl');
        } else {
            $this->body = $this->smarty->fetch('users_calls.tpl');
        }
    }



    public function fetch()
    {
        $this->title    = $this->lang->USERS;
        $current_page   = $this->param('page');
        $start_item     = $current_page*$this->items_per_page;
        $keyword        = mysql_real_escape_string($this->param('keyword'));
        $group_id       = $this->param('group');

        if ( isset($_GET['calls']) ) {
            $this->calls_action();
        }
        else {
            $where_calls = " uc.status = '1' ";
            if ( !empty($_SESSION['user']->shop) && !luser::is_allowed('admin') ) {
                $shop = $this->db->escape($_SESSION['user']->shop);
                if ( !empty($_SESSION['user']->group_id) && $_SESSION['user']->group_id != 2 ) {
                    $where_calls .= " AND uc.moderator_id = {$_SESSION['user']->user_id} ";
                }
            }

            $calls = $this->db->results($sql = "SELECT uc . * , u.name AS moderator_name
                FROM users_calls uc
                LEFT JOIN users u ON uc.moderator_id = u.user_id
                WHERE {$where_calls}"
            );

            $call = false;
            if ( isset($_GET['call_id']) ) {
                $call_id = (int)$_GET['call_id'];
                $call = $this->db->result("SELECT uc . * , u.name AS moderator_name
                    FROM users_calls uc
                    LEFT JOIN users u ON uc.moderator_id = u.user_id
                    WHERE {$where_calls} AND uc.id = '{$call_id}';"
                );
            }
            elseif ( !empty($calls[0]) ) {
                $call = $calls[0];
            }

            if ( !empty($call) ) {
                $filter = "";
                if (!empty($call->sex)) {
                    $filter .= " AND u.sex = '{$call->sex}' ";
                }
                if (!empty($call->shop)) {
                    $shops = explode(",", $call->shop);
                    if (is_array($shops) && count($shops)>1) {
                        $shops = "'".implode("','", $shops)."'";
                    }
                    else {
                        $shops = "'".$call->shop."'";
                    }
                    $filter .= " AND u2s.shop IN ({$shops}) ";
                }
                if (!empty($call->sum_min) && !empty($call->sum_max)) {
                    $filter .= " AND u.purchase_sum_real BETWEEN '{$call->sum_min}' AND '{$call->sum_max}' ";
                }
                elseif (!empty($call->sum_min) && empty($call->sum_max)) {
                    $filter .= " AND u.purchase_sum_real > '{$call->sum_min}' ";
                }
                elseif (empty($call->sum_min) && !empty($call->sum_max)) {
                    $filter .= " AND u.purchase_sum_real < '{$call->sum_max}' ";
                }
                if ( !empty($call->brands) ) {
                    $brands = explode(',', str_replace(' ', '', $call->brands));
                    $users  = array();
                    if ( is_array($brands) && count($brands) )
                    foreach ($brands as $v) {
                        $users_tmp = luser::get_users_for_brand($v);
                        if ( is_array($users_tmp) && count($users_tmp) )
                        foreach ($users_tmp as $vv) {
                            $users[$vv->user_id] = $vv->user_id;
                        }
                    }
                    $users = implode($users, ',');
                    $filter .= " AND (u.original_user_id IN ({$users}) OR u2b.brand_id IN ({$call->brands})) ";
                }


                $query = "SELECT SQL_CALC_FOUND_ROWS u.*, IFNULL(l.status, 0) AS last_phone_call_status, IFNULL(l.date_created, '0000-00-00 00:00:00') AS last_phone_call FROM users u
                            LEFT JOIN `users_calls_log` l ON (call_id = '{$call->id}' AND u.original_user_id = l.user_id)
                            LEFT JOIN `users2shops` u2s ON u.user_id = u2s.user_id
                            LEFT JOIN `users2brands` u2b ON u.user_id = u2b.user_id
                          WHERE u.enabled = '1' AND u.new_user_database = '1' {$filter} AND LENGTH( u.phone_number ) > 9 AND ( u.group_id = '1' )
                          GROUP BY u.original_user_id
                          ORDER BY last_phone_call_status, last_phone_call, u.name";
                $users = $this->db->results($query);

                foreach($users as $user){
                    if($user->last_phone_call_status == 2){
                        $call_date = substr($user->last_phone_call, 0, 10);
                        $phone = substr($user->phone_number, -10);
                        $user->calls = $this->db->results("SELECT * FROM calls WHERE `date` >= '{$call_date} 00:00:00' AND `date` <= '{$call_date} 23:59:59' AND (client_id = {$user->original_user_id} OR phone_number LIKE '%{$phone}');");
                    }
                }
                $this->smarty->assign('Users', $users);

                $total = $this->db->result("SELECT FOUND_ROWS() as count;");
                $call->stat_total = $total->count;
                $this->db->query("UPDATE users_calls SET stat_total = '{$total->count}' WHERE id = '{$call->id}';");

                $call->stat_total_percent = round($call->stat_total == 0 ? 0 : ($call->stat_called*100 / $call->stat_total));
                $call->stat_total_wating  = $call->stat_total - $call->stat_called - $call->stat_missing;
                $this->smarty->assign('call', $call);

                if (isset($_GET['stat'])) {
                    header('Content-Type: application/json');
                    echo json_encode($call);
                    exit();
                }
            }

            $this->smarty->assign('calls',    $calls);
            $this->smarty->assign('Modernjs', true);
            $js = $this->smarty->fetch('calls.js.tpl');
            $this->smarty->assign('JavaScript', $js);

            $this->body = $this->smarty->fetch('users_callid.tpl');
        }
    }
}