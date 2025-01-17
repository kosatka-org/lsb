<?PHP
require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');
require_once('../placeholder.php');
require_once('../models/email_template.php');
require_once('../models/order.php');


// -- Class Name : Special_orders
// -- Purpose : Manage users comments to products
class Special_orders extends Widget
{
    var $items_per_page = 20;
    var $pages_navigation;
    function Special_orders(&$parent) {
        parent::Widget($parent);
    }

    function fetch() {
        if(!empty($_GET['update_order'])){
            $so_id = $_GET['update_order'];
            if(!empty($_GET['delete_comment_id'])){
                $delete_comment_id  = (int) $_GET['delete_comment_id'];
                $this->db->query("DELETE FROM special_orders_comments WHERE id = {$delete_comment_id} AND so_id = {$so_id}");
            }
            if(!empty($_GET['client_assign'])){
                $user_id = $_GET['client_assign'];
                $this->db->query("UPDATE `special_orders` SET `user_id`='{$user_id}' WHERE `so_id` = {$so_id}");
            }
            if(isset($_GET['delete_order'])){
                $this->db->query("UPDATE `special_orders` SET `enabled`=0 WHERE `so_id` = {$so_id}");
            }
            else{
                $end_date = $_POST['end_date'];
                $manager_id = $_POST['manager_id'];
                $product_size = $_POST['product_size'];
                if(!empty($_POST['comment'])){
                    $comment = $_POST['comment'];
                    $this->db->query("INSERT INTO special_orders_comments (so_id, commenter_id, text, date) VALUES ('{$so_id}', '{$_SESSION['user']->user_id}', '{$comment}', NOW())");
                }
                $this->db->query("UPDATE `special_orders` SET `end_date`='{$end_date}',`manager_id`='{$manager_id}',`product_size`='{$product_size}' WHERE `so_id` = {$so_id}");
            }
            header("Location: {$_SERVER["HTTP_REFERER"]}");
            exit();
        }
        
        if (isset($_GET['s_order'])) {
            $this->body = $this->get_order($_GET['s_order']);
            $this->title = "Специальный заказ №{$_GET['s_order']}";
            return $this->body;
        }
        elseif (isset($_GET['export_orders'])) {
            $this->export_orders($_POST['date_start'],$_POST['date_end']);
            exit();
        }
        else {
            $this->smarty->assign('export_start', date('Y-m-d', strtotime('-1 year')));
            $this->smarty->assign('export_end', date('Y-m-d'));
            $this->body = $this->get_orders();
            $this->title = "Специальные заказы";
            return $this->body;
        }
    }
    
    private function get_order($so_id) {
        $item = $this->db->result($sql = "SELECT special_orders.*, users.*, products.url, products.large_image, products.model AS p_model, categories.parent, categories.category_id  
                FROM special_orders 
                LEFT JOIN users ON special_orders.user_id = users.user_id 
                LEFT JOIN products ON special_orders.product_id = products.product_id 
                                LEFT JOIN categories ON products.category_id = categories.category_id 
                WHERE special_orders.so_id = {$so_id};");
        
        $item->manager_name = $this->db->result("SELECT name FROM `users` WHERE user_id = '{$item->manager_id}'")->name;
        $item->comments = $this->db->results("SELECT special_orders_comments.*, users.name
            FROM special_orders_comments
            LEFT JOIN users ON special_orders_comments.commenter_id = users.user_id
            WHERE special_orders_comments.so_id = {$so_id}");
        $managers = $this->db->results("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 5 ORDER BY name;");
        
        $this->smarty->assign('sizes',  array('XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL+') );
        $this->smarty->assign('shoesizes',  array('35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46') );
        $this->smarty->assign('delivery_cities_main', $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '1' ORDER BY city_name;"));
        $this->smarty->assign('delivery_cities',      $this->db->results("SELECT * FROM delivery_cities WHERE city_owner_id = '0' AND city_is_main = '0' ORDER BY city_name;"));
        $this->smarty->assign('shops', $this->db->results("SELECT * FROM shops;"));
        $this->smarty->assign('managers', $managers);
        $this->smarty->assign('item',     $item);
        
        $body = $this->smarty->fetch('special_order.tpl');
        return $body;
    }
    
    private function get_orders() {
        $current_page = intval($this->param('page'));
        $start_item = $current_page*$this->items_per_page;
        $items = $this->db->results($sql = "SELECT SQL_CALC_FOUND_ROWS special_orders.*, products.url, products.large_image, products.model AS p_model 
                FROM special_orders 
                LEFT JOIN users ON special_orders.user_id = users.user_id 
                LEFT JOIN products ON special_orders.product_id = products.product_id 
                WHERE special_orders.enabled = '1' ORDER BY so_id DESC
                LIMIT {$start_item}, {$this->items_per_page};");
        
        $finds_num = $this->db->result("SELECT FOUND_ROWS() as count;");
        $pages_num = $finds_num->count/$this->items_per_page;
                                
        foreach($items as $item){
            if($item->manager_id){
                $item->manager_name = $this->db->result("SELECT name FROM `users` WHERE user_id = '{$item->manager_id}'")->name;
            }
            $item->comments = $this->db->results("SELECT special_orders_comments.*, users.name
            FROM special_orders_comments
            LEFT JOIN users ON special_orders_comments.commenter_id = users.user_id
            WHERE special_orders_comments.so_id = {$item->so_id}");
        }
        
        $this->pages_navigation = new PagesNavigation($this);
        $this->pages_navigation->fetch($pages_num);
        $this->smarty->assign('Items',$items);
        $this->smarty->assign('finds_num',     $finds_num->count);
        $this->smarty->assign('PagesNavigation',     $this->pages_navigation->body);
        $this->smarty->assign('title',"Специальные заказы");
        $body = $this->smarty->fetch('special_orders.tpl');
        return $body;
    }
    
    private function export_orders($date_start, $date_end) {
      header('Content-Type: text/csv;charset=cp1251');
      header('Content-Disposition: attachment; filename=export.csv');
      
      $output = '';

      $rows = mysql_query("SELECT b.name, CONCAT('=ГИПЕРССЫЛКА(\"https://lsboutique.ru/products/', p.product_id, '\")'), p.model,  CASE WHEN p.large_image != '' THEN CONCAT('=ГИПЕРССЫЛКА(\"https://lsboutique.ru/reimg/files/products/85x/', p.large_image, '\")') ELSE CONCAT('=ГИПЕРССЫЛКА(\"https://lsboutique.ru/reimg/files/products/85x/', p.small_image, '\")') END AS p_image, p.sku, so.product_size, p.product_id, so.so_id, so.create_date 
              FROM special_orders so 
              LEFT JOIN products p ON so.product_id = p.product_id
              LEFT JOIN brands b ON p.brand_id = b.brand_id 
              WHERE so.enabled=1 AND so.create_date BETWEEN '{$date_start}' AND '{$date_end} 23:59:59'
              ORDER BY b.name, p.model, so.create_date ASC");

      $output .= implode(';',array('бренд', 'ссылка на товар на сайте', 'номенклатура', 'фото товара', 'артикул', 'размеры', 'ID', '№ заказа', 'дата заказа'));
      $output .= '
';
      while ($row = mysql_fetch_assoc($rows)){
        $output .= implode(';',$row);
        $output .= '
';
      }
      $output = mb_convert_encoding($output, "CP1251", "UTF-8");
      echo($output);
    }
}