<?PHP
require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('../placeholder.php');
require_once('../models/email_template.php');
require_once('../models/order.php');


// -- Class Name : Oneclick
// -- Purpose : Manage users comments to products
class Oneclick extends Widget
{
    function Oneclick(&$parent) {
        parent::Widget($parent);
    }



    function add_to_spamlist($name, $phone, $product_id)
    {
        $user = $this->db->result("SELECT * FROM users WHERE phone_number LIKE \"%{$phone}%\"");
        if ($user) {
            $user_id = $user->user_id;
        }
        else {
            $card_number = luser::generate_card_number();
            $phone_number = "8"+$phone;
            $this->db->query("INSERT INTO `users` ( `name` , `group_id` , `enabled` , `card_number` , `phone_number` , `card_registered`, `password`)
                         VALUES ( '{$name}', '1', '1', '{$card_number}', '{$phone_number}', '" . date('Y-m-d') . "', md5(rand()));");
            $user_id = $this->db->insert_id();
            $this->db->query("UPDATE `users` SET `original_user_id` = `user_id` WHERE `original_user_id` = '0'; ");
        }
        $product = $this->db->result("SELECT * FROM products WHERE product_id = {$product_id}");
        luser::subscribe_to_brand($user_id, $product->brand_id);
    }



    function fetch() {
        if (isset($_POST['test'])) {
            $data     = $_POST['data'];
            $item_id  = $_POST['item_id'];
            $template = $this->db->result('SELECT * FROM emails WHERE id = '.$item_id);
            $subject  = $template->subject;
            $tname    = $template->alias;
            $this->smarty->assign('message', $data);
            $this->smarty->assign('subject', $subject);
            $message = $this->smarty->fetch('email_layout.tpl');
            $email   = $_SESSION['user']->email;
            if (isset($_POST['email']) && !empty($_POST['email'])) {
                $email = $_POST['email'];
            }

            $et	= new email_template($tname);
            $et->assign('SITE', "http://{$_SERVER['HTTP_HOST']}")->assign('YEAR', date('Y'))
            ->assign('CALL_BY_CLICK', $this->config->support_link)->assign('SUPPORT_EMAIL', $this->config->support_email2)
            ->assign('ORDER_MANAGER_PHONE', $this->config->support_phone)->assign('ORDER_MANAGER_EMAIL', $this->config->support_email)->assign('ORDER_MANAGER', $this->config->support_name)
            ->assign('UNSUBSCRIBE_LINK', "http://{$_SERVER['HTTP_HOST']}/index.php?module=Login&do_not_disturb_email&email={$user->email}&type=email")// . utm('email', 'email', "email_{$tname}"))
            ->assign('SUBJECT', 	$subject)
            ->assign('MESSAGE', 	$message)
            ->assign('USER_PHONE_NUMBER', 	$_SESSION['user']->phone_number)
            ->assign('USER_CARD_NUMBER', 	$_SESSION['user']->card_number)
            ->assign('USEREMAIL', 	$message)
            ->send( $email );
            exit();
        }

        if (isset($_GET['email_template']) || isset($_GET['email_message']) || isset($_POST['message'])) {
            if (isset($_GET['email_message'])) {
                $r = $this->db->result("SELECT * FROM emails WHERE id = {$_GET['email_message']}");
                echo $r->message;
                exit();
            }
            if (isset($_POST['message']) && isset($_POST['item_id'])) {
                $r = $this->db->result("SELECT * FROM emails WHERE id = {$_POST['item_id']}");
                $this->smarty->assign('message', $_POST['message']);
                $this->smarty->assign('subject', $r->subject);
                $body_html = $this->smarty->fetch('email_layout.tpl');
                $this->db->query("UPDATE emails SET body_html = '{$body_html}', message = '{$_POST['message']}' WHERE id = {$_POST['item_id']}");
            }
            $this->title = 'Редактирование текстов рассылок';
            $this->smarty->assign('Items',    $this->db->results("SELECT * FROM emails WHERE 1"));
            $this->smarty->assign('Modernjs', 'true');
            $this->smarty->assign('Lang',     $this->lang);
            $js = $this->smarty->fetch('email_template.js.tpl');
            $this->smarty->assign('JavaScript', $js);
            $this->body = $this->smarty->fetch('email_template.tpl');
        }
        else {
            $this->title = 'Заказы в один клик';

            // Data API
            if (isset($_POST['disable'])) {
                $item_id = mysql_real_escape_string($_POST['disable']);

                if ($_POST['item_type'] == 'new_orders') {
                    $order_id = $this->db->result("SELECT * FROM orders_products WHERE id = {$item_id}")->order_id;
                    $result   = $this->db->query("UPDATE orders_products SET new_order = 0 WHERE id = ".$item_id);
                    // Отмена старого "нового" заказа
                    $this->db->query("UPDATE orders o
                        SET o.status = 3
                        WHERE o.order_id = {$order_id}
                        AND NOT
                        EXISTS (
                            SELECT *
                            FROM orders_products
                            WHERE order_id = o.order_id
                            AND new_order = 1
                        )");
                }
                else {
                    $info_obj = json_decode($_POST['info']);
                    // Информация о заказе пригодится для отмены заказа в микс-маркете
                    $oc       = $this->db->result("SELECT one_click.*, products.model FROM one_click LEFT JOIN products ON products.product_id = one_click.product_id WHERE one_click.id = {$item_id}");
                    if ($info_obj->disable_info == "consultation" || $info_obj->disable_info == "out_of_stock") {
                        if ($info_obj->name && $info_obj->phone && $info_obj->product_id) {
                            $this->add_to_spamlist($info_obj->name, $info_obj->phone, $info_obj->product_id);
                        }
                    }
                    if ($info_obj->disable_info == 'unreachable') {

                        if($_COOKIE['language'] == 'eng'){
                          $product = $this->db->result("SELECT c.eng_single_name, b.name FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN brands b ON p.brand_id = b.brand_id WHERE p.product_id = '{$oc->product_id}'");
                          $product_name = $product->eng_single_name . ' ' . $product->name;
                          $message = "Dear {$oc->name}, the store employee was unable to contact you to confirm the order for {$product_name} in the online store Luxury Store. If you are still interested in buying, please re-place your order here https://lsboutique.ru/products/{$oc->product_id}/. ls.net.ru 8-800-333-21-38";
                        }
                        else{$message = "Уважаемый {$oc->name}, сотруднику магазина не удалось связаться с вами, чтобы подтвердить заказ на {$oc->model} в интернет магазине Лакшери Store. Если вы все ещё заинтересованы в покупке, просим вас повторно оформить заказ по ссылке https://lsboutique.ru/products/{$oc->product_id}/. ls.net.ru 8-800-333-21-38";}
                        $args = array( 'user_id' => $oc->user_id, 'sender' => 'lsboutique', 'message_text' => $message, 'phone_number' => $oc->phone );
                        Job::push('SmsJob', $args);
                    }
                    $result = $this->db->query("UPDATE one_click SET
                            enabled = 0,
                            disable_info = '{$info_obj->disable_info}',
                            disable_comment = '{$info_obj->disable_comment}',
                            processed_date = NOW(),
                            manager_id = '{$_SESSION['user']->user_id}'
                        WHERE id = ".$item_id);
                    if ( !empty($oc->from_mixmarket) ) {
                        orders::mixmarket_notify(1000000+$oc->id, 0, 'decline');
                    }
                }
                if ($result) { echo "OK"; } else { echo "FAILED"; }
                exit();
            }

            if (isset($_POST['query'])) {
                $q    = mysql_real_escape_string($_POST['query']);
                $data = $this->db->results("SELECT * FROM users WHERE phone_number LIKE \"%{$q}%\"");
            }

            if (isset($_GET['mcities'])) {
                $data = $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;");
            }

            if (isset($_GET['cities'])) {
                $data = $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' ORDER BY city_name;");
            }

            if (isset($_GET['archive_items'])) {
				$p = (int) $_GET['archive_items'];
				if ($p == 0)
				{$date_range = " AND date > DATE_SUB(CURDATE(), INTERVAL 2 WEEK) ";}
				else{
					$p_end = $p*2;
					$p_start = $p*2 + 2;
					$date_range = " AND (date > DATE_SUB(CURDATE(), INTERVAL {$p_start} WEEK) AND date < DATE_SUB(CURDATE(), INTERVAL {$p_end} WEEK)) ";
				}
				$data = $this->db->results("SELECT oc.*, u.name AS manager_name FROM one_click oc LEFT JOIN users u ON u.user_id = oc.manager_id WHERE oc.enabled=0 {$date_range} ORDER BY id DESC");
            }

            if (isset($data)) {
                header('Content-Type: application/json');
                echo json_encode($data);
                exit();
            }

            // Отображение страницы
            $items = $this->db->results("SELECT one_click.name AS name, one_click.phone AS phone, one_click.id AS id, one_click.date AS date,
                        one_click.product_url AS product_url, one_click.product_id AS product_id, one_click.from AS `from`,
                        one_click.disable_info AS disable_info, one_click.processed_date AS processed_date, products.*
                      FROM one_click
                      LEFT JOIN products ON products.product_id = one_click.product_id
                    WHERE one_click.enabled = 1
                    ORDER BY id DESC");

            $this->smarty->assign('new_orders', false);

            if (isset($_GET['new_orders'])) {
                $this->title = 'Новые заказы';
                $this->smarty->assign('new_orders', true);

                $items = $this->db->results("SELECT orders.name AS name, orders.phone AS phone, op.id AS id, op.size AS selected_size,
                        orders.date AS date, orders.order_id AS order_id, orders.comment AS comment, products.url AS product_url,
                        products.product_id AS product_id, 'new_orders' AS 'from', products.*
                      FROM orders_products op
                      LEFT JOIN orders ON orders.order_id = op.order_id
                      LEFT JOIN products ON products.product_id = op.product_id
                    WHERE op.new_order = 1 AND orders.status = 0;");
            }

            foreach ($items as $key => $item) {
                if (!empty($item->size)) {
                    $sizes_arr = explode("|", trim($item->size, "|"));
                    $items[$key]->sizes = $sizes_arr;
                }
            }

            $this->smarty->assign('Items',    $items);
            $this->smarty->assign('Modernjs', 'true');
            $this->smarty->assign('Lang',     $this->lang);

            $js = $this->smarty->fetch('one_click.js.tpl');
            $this->smarty->assign('JavaScript', $js);

            $this->body = $this->smarty->fetch('one_click_orders.tpl');
        }
    }
}
