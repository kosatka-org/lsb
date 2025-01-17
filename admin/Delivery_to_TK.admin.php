<?PHP
require_once('Widget.admin.php');
require_once('../placeholder.php');
require_once('../models/order.php');


class Delivery_to_tk extends Widget
{
    function Delivery_to_tk(&$parent) {
        parent::Widget($parent);
    }

    function fetch() {
        if (isset($_GET['edit'])) {
          if(!empty($_GET['deactivate'])){
            $this->db->query("UPDATE delivery_to_tk SET active = 0 WHERE id = {$_GET['deactivate']};");
          }
          if(!empty($_GET['activate'])){
            $this->db->query("UPDATE delivery_to_tk SET active = 1 WHERE id = {$_GET['activate']};");
          }
          if (isset($_GET['delete_comment_id'])) {
            $delete_comment_id  = (int) $_GET['delete_comment_id'];
            $this->db->query("DELETE FROM delivery_comments WHERE id = {$delete_comment_id}");
          }
          if(isset($_GET['update_deivery'])){
            $delivery_id = (int) $_POST['delivery_id'];
            $manager_id  = (int) $_POST['manager_id'];
            $price       = floatval($_POST['delivery_price']);
            $orders      = array_filter($_POST['orders']);
            $old_orders  =  explode('|',$this->db->result("SELECT order_ids FROM delivery_to_tk WHERE id = {$delivery_id}")->order_ids);
            
            if ($orders != $old_orders){
              $order_ids   = implode(',',$old_orders);
              $this->db->query("UPDATE orders SET `delivery_to_tk_id` = 0 WHERE order_id IN ({$order_ids})");
              $order_ids   = implode(',',$orders);
              $this->db->query("UPDATE orders SET `delivery_to_tk_id` = {$delivery_id} WHERE order_id IN ({$order_ids})");
            }
            $order_ids   = implode('|',$orders);
            $this->db->query("UPDATE delivery_to_tk SET order_ids = '{$order_ids}', manager_id = '{$manager_id}', price = '{$price}' WHERE id = {$delivery_id};");
            if (!empty($_POST['comment'])){
              $this->db->query("INSERT INTO delivery_comments (delivery_id, commenter_id, text, date) VALUES ({$delivery_id}, {$_SESSION['user']->user_id}, '{$_POST['comment']}', NOW())");
            }
          }
          if(isset($_POST['new_delivery'])){
            $price = $_POST['del_price'];
            $order_ids = implode('|',array_filter($_POST['orders']));
            $this->db->query("INSERT INTO delivery_to_tk (`order_ids`,`price`,`manager_id`,`date`,`active`) VALUES ('{$order_ids}','{$price}','{$_SESSION['user']->user_id}',NOW(),1); ");
            $did = $this->db->insert_id();
            foreach($_POST['orders'] as $order_id){
              $this->db->query("UPDATE orders SET `delivery_to_tk_id` = {$did} WHERE order_id = {$order_id}");
            }
          }
          if ( isset($_GET['change_delivery_price']) ) {
            $delivery_id = intval($_GET['change_delivery_price']);
            $price = floatval($_GET['price']);
            if ($delivery_id && $price) {
              $this->db->query("UPDATE delivery_to_tk SET price = {$price} WHERE id = {$delivery_id};");
            }
          }
          header("Location: {$_SERVER["HTTP_REFERER"]}");
          exit();
        }
        if(isset($_GET['add_delivery'])){
          $this->smarty->assign('orders', $this->db->results("SELECT order_id FROM orders WHERE status IN (0,1) ORDER BY order_id DESC"));
          $body = $this->smarty->fetch('delivery_to_tk_add.tpl');
          echo $body;
          die();
        }
        if(isset($_GET['get_delivery'])){
            $this->body = $this->get_delivery();
            $this->title = "Доставка в ТК";
            return $this->body;
        }
        else {
            $this->body = $this->get_deliveries();
            $this->title = "Доставка в ТК";
            return $this->body;
        }
    }
    
    private function get_delivery() {
      $item_id = $_GET['get_delivery'];
      $item = $this->db->result($sql = "SELECT * FROM delivery_to_tk WHERE id = {$item_id};");
      $orders = explode('|',$item->order_ids);
      foreach($orders as $order_id){
        $item->orders[$order_id]->order_id = $order_id;
        $item->orders[$order_id]->products = $this->db->results("SELECT op.product_name, p.large_image, p.url  
                  FROM orders_products op 
                  LEFT JOIN products p ON op.product_id = p.product_id 
                  WHERE op.order_id = '{$order_id}'");
      }
      if($item->manager_id){
        $item->manager_name = $this->db->result("SELECT name FROM `users` WHERE user_id = '{$item->manager_id}'")->name;
      }
      $item->comments = $this->db->results("SELECT delivery_comments.*, users.name
                  FROM delivery_comments
                  LEFT JOIN users ON delivery_comments.commenter_id = users.user_id
                  WHERE delivery_comments.delivery_id = {$item->id}");
      
      $this->smarty->assign('Managers', $this->db->results("SELECT original_user_id AS user_id, name FROM users WHERE group_id = 5 ORDER BY name;"));
      $this->smarty->assign('orders', $this->db->results("SELECT order_id FROM orders WHERE status IN (0,1) ORDER BY order_id DESC"));
      $this->smarty->assign('item',$item);
      $this->smarty->assign('View','to_tk');
      $this->smarty->assign('title',"Доставка в ТК");
      $body = $this->smarty->fetch('delivery_to_tk_item.tpl');
      return $body;
    }
    
    private function get_deliveries() {
      $active = "active = '1'";
      if(isset($_GET['inactive'])){$active = "active = '0'";}
      $items = $this->db->results($sql = "SELECT * FROM delivery_to_tk WHERE {$active} ORDER BY id DESC;");
      foreach($items as $item){
        $orders = explode('|',$item->order_ids);
        foreach($orders as $order_id){
          $item->orders[$order_id]->order_id = $order_id;
          $item->orders[$order_id]->products = $this->db->results("SELECT op.product_name, p.large_image, p.url  
                    FROM orders_products op 
                    LEFT JOIN products p ON op.product_id = p.product_id 
                    WHERE op.order_id = '{$order_id}'");
        }
        if($item->manager_id){
          $item->manager_name = $this->db->result("SELECT name FROM `users` WHERE user_id = '{$item->manager_id}'")->name;
        }
        $item->comments = $this->db->results("SELECT delivery_comments.*, users.name
                    FROM delivery_comments
                    LEFT JOIN users ON delivery_comments.commenter_id = users.user_id
                    WHERE delivery_comments.delivery_id = {$item->id}");
      }
      
      $this->smarty->assign('orders', $this->db->results("SELECT order_id FROM orders WHERE status IN (0,1) ORDER BY order_id DESC"));
      $this->smarty->assign('Items',$items);
      $this->smarty->assign('View','to_tk');
      $this->smarty->assign('title',"Доставка в ТК");
      $body = $this->smarty->fetch('delivery_to_tk.tpl');
      return $body;
    }
}