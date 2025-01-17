<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');

class Statistics extends Widget
{
  var $error_msg;
  var $table    = 'colors';
  
  function Statistics(&$parent)
  {
    Widget::Widget($parent);
    
  }
  function fetch()
  {
    $date_from = $_POST['period'] ? $_POST['period'].'-01' : date('Y-m').'-01';
    $date_to   = $_POST['period'] ? $_POST['period'].'-31' : date('Y-m-d');
    $date_fragment = "BETWEEN '{$date_from}' AND '{$date_to} 23:59:59'";
    if($_GET['brands']){
      if($_GET['brand']){
        $brand_id = isset($_GET['brand']) ? $_GET['brand'] : '461,123';
        $totals = $this->db->result($sql="SELECT COUNT(DISTINCT op.order_id) AS o_count, SUM(op.price) AS o_sum
                  FROM `orders_products` op 
                  LEFT JOIN products p ON op.product_id = p.product_id
                  LEFT JOIN orders o ON op.order_id = o.order_id
                  WHERE p.brand_id IN ({$brand_id}) AND o.date {$date_fragment} AND op.status=5;");
        $orders = $this->db->results($sql="SELECT o.*
                  FROM `orders_products` op 
                  LEFT JOIN products p ON op.product_id = p.product_id
                  LEFT JOIN orders o ON op.order_id = o.order_id
                  WHERE p.brand_id IN ({$brand_id}) AND o.date {$date_fragment} AND op.status=5
                  GROUP BY o.order_id
                  ORDER BY o.date DESC;");
        foreach($orders as $order){
          $order->products = $this->db->results($sql="SELECT op.*
                  FROM `orders_products` op 
                  LEFT JOIN products p ON op.product_id = p.product_id
                  LEFT JOIN orders o ON op.order_id = o.order_id
                  WHERE p.brand_id IN ({$brand_id}) AND op.status=5 AND o.order_id = {$order->order_id};");
        }
        $this->smarty->assign('totals', $totals);
        
        $graph1 = $graph2 = array();
        $dl = $_POST['period'] ? date("t", strtotime($_POST['period'])) : date('d');
        $month = $_POST['period'] ? date("m", strtotime($_POST['period'])) : date('m');
        $year = $_POST['period'] ? date("Y", strtotime($_POST['period'])) : date('Y');
        $date_   = $_POST['period'] ? $_POST['period'] : date('Y-m');
        for ($i = 1; $i <= $dl; $i++) {
          if($i < 10) $d = '-0' . $i;
          else $d = '-' . $i;
          $date = $date_ . $d;
          $totals = $this->db->result($sql="SELECT COUNT(DISTINCT op.order_id) AS o_count, COALESCE(SUM(op.price),0) AS o_sum
                  FROM `orders_products` op 
                  LEFT JOIN products p ON op.product_id = p.product_id
                  LEFT JOIN orders o ON op.order_id = o.order_id
                  WHERE p.brand_id IN ({$brand_id}) AND o.date BETWEEN '{$date}' AND '{$date} 23:59:59' AND op.status=5;");
          $ts = mktime(0, 0, 0, $month, $i, $year);
          $graph1[] = array($ts,(int)$totals->o_count);
          $graph2[] = array($ts,(int)$totals->o_sum);
        }
        
        $this->smarty->assign('graph1', json_encode($graph1));
        $this->smarty->assign('graph2', json_encode($graph2));
        $this->smarty->assign('orders', $orders);
        $this->smarty->assign('CurrentBrand', $brand_id);
      }
      $this->smarty->assign('date_from', isset($_POST['period']) ? $_POST['period'] : date('Y-m'));
      $this->smarty->assign('brands', $this->db->results("SELECT * FROM `brands` WHERE brand_id IN (461,123);")); 
      $this->body = $this->smarty->fetch('stats_brands.tpl');
    }
    if($_GET['orders']){
      $totals = $this->db->result($sql="SELECT COUNT(DISTINCT so.so_id) AS o_count, SUM(op.price) AS o_sum
                FROM `special_orders` so
                LEFT JOIN orders o ON so.user_phone = o.phone AND o.date > so.create_date
                LEFT JOIN orders_products op ON op.order_id = o.order_id
                LEFT JOIN products p ON op.product_id = p.product_id
                WHERE o.date {$date_fragment} AND op.status=5 AND so.product_id = op.product_id;");
      $orders = $this->db->results($sql="SELECT  so.*, o.*
                FROM `special_orders` so
                LEFT JOIN orders o ON so.user_phone = o.phone AND o.date > so.create_date
                LEFT JOIN orders_products op ON op.order_id = o.order_id
                LEFT JOIN products p ON op.product_id = p.product_id
                WHERE o.date {$date_fragment} AND op.status=5 AND so.product_id = op.product_id
                GROUP BY o.order_id
                ORDER BY o.date DESC;");
                file_put_contents('qwertyu.txt',$sql);
      foreach($orders as $order){
        $order->products = $this->db->results($sql="SELECT op.*
                FROM `orders_products` op 
                LEFT JOIN products p ON op.product_id = p.product_id
                LEFT JOIN orders o ON op.order_id = o.order_id
                WHERE op.status=5 AND o.order_id = {$order->order_id};");
      }
      $this->smarty->assign('totals', $totals);
      $this->smarty->assign('orders', $orders);
      $this->smarty->assign('date_from', isset($_POST['period']) ? $_POST['period'] : date('Y-m'));
      $this->body = $this->smarty->fetch('stats_orders.tpl');
    }
  }
}

