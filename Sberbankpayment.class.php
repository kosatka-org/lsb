<?PHP
 
require_once('Widget.class.php');
require_once('Order.class.php');


class Sberbankpayment extends Widget
{
	/* Конструктор */
	function Sberbankpayment(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/* Отображение */
	function fetch()
	{
        if (isset($_GET['confirm'])) {
          if (isset($_GET['orderId'])){
            $payment = $this->db->result("SELECT * FROM sber_transactions WHERE md_order = '{$_GET['orderId']}'");
            if(isset($_GET['check'])){
              if(!empty($payment))die('ok');
              else die('fail');
            }
            $order = $this->db->result("SELECT * FROM orders WHERE sber_order_id = '{$_GET['orderId']}'");

            $this->smarty->assign('order', $order);
            $this->smarty->assign('payment', $payment);
            $this->smarty->assign('title', 'Подтверждение оплаты | бутик Лакшери Стор');
            $this->body = $this->smarty->fetch('payment_confirm.tpl');
            return $this->body;
          }else die('fail');
        }
        if (isset($_GET['order_status'])) {
          if (isset($_GET['orderId'])){
            $sb = new CSberbank();
            $r  = $sb->getOrderStatus($_GET['orderId'], true);
          }else die('fail');
        }
        
        if (isset($_GET['order_id'])) $code = $_GET['order_id'];
        else $error = "Invalid Order ID";
        
        if (isset($_GET['order_total'])) $order_total = $_GET['order_total'];
        else $error = "Incorrect or absent order total";
        
        // Получаем наш заказ из базы
        if (!$error) $order = Order::get_order_by_code($code);
        if (!$order) $error = "Order not Found";
        
        if($error){
          $mess = var_export($_GET, true);
          mail('a.shesternina@gmail.com, tirjen@gmail.com', "Sber server error - " . $error, $mess);
          die('Internal ERROR');
        }
        
        if($order){
          if ($order->sber_order_id != '') {
              header("location: https://securepayments.sberbank.ru/payment/merchants/sbersafe/payment_ru.html?mdOrder=" . $order->sber_order_id);die();
          }
          else {
              $sb = new CSberbank();
              $url = 'https://lsboutique.ru/sberbankpayment/confirm/';
              $order_id = $order->order_id;
              if(isset($_GET['offline']) && !empty($_SERVER["HTTP_REFERER"]))$url = $_SERVER["HTTP_REFERER"];
              if(isset($_GET['delivery']))$order_id = $order->order_id . '_delivery';
              $r  = $sb->registerOrder($order_total, $code, $url, $order_id);
              if ($r['formUrl'] =='' || $r['orderId'] =='') {
                  $mess = var_export($r, true);
                  mail('a.shesternina@gmail.com, tirjen@gmail.com', "Sber error", $mess);
                  die('Internal ERROR');
              }
              $this->db->query("UPDATE orders SET sber_order_id = '{$r['orderId']}' WHERE code = '{$code}'");
              if(isset($_GET['offline'])) $this->db->query("UPDATE online_payments SET paid = 1 WHERE order_id = '{$order->order_id}' AND amount = '{$order_total}'");
              header("location: {$r['formUrl']}");die();
          }
        }
        die();
	}
}


class CSberbank{
    private static $username = "lsboutique-api";
    private static $password = "APIlsboutique921{";
 
 
    function getOrderStatus( $orderId, $return=false ) {
        // https:/server/application_context/rest/getOrderStatus.do? orderId=b8d70aa7-bfb3-4f94-b7bb-aec7273e1fce&language=ru&password=password&userName=userName
        $url = "https://securepayments.sberbank.ru/payment/rest/getOrderStatus.do?orderId=".$orderId."&language=ru&password=".$this::$password."&userName=".$this::$username;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $response = curl_exec($ch);
        curl_close($ch);
 
        if( $response ){
 
            $response = json_decode($response, true);
 
            if( $response['ErrorMessage'] ){
              
                if($return) return $response;
 
                if( $response['OrderStatus'] == 2 ){
                    return "Спасибо, заказ №".$response['OrderNumber']." оплачен.";
                } else {
                    return "Статус заказа: ".$response['ErrorMessage'];
                }
 
            }
 
        }
        return false;
    }
 
    function registerOrder($total, $order, $returnUrl, $order_id){
        $url = "https://securepayments.sberbank.ru/payment/rest/register.do?amount=".intval($total)."00&currency=643&language=ru&orderNumber=".$order_id."&password=".$this::$password."&userName=".$this::$username."&returnUrl=".$returnUrl."&returnUrl=".$returnUrl."&pageView=DESKTOP&sessionTimeoutSecs=3600";
        //$url = "https://3dsec.sberbank.ru/payment/rest/register.do?amount=".intval($total)."00&currency=643&language=ru&orderNumber=".$order."&password=".$this::$password."&userName=".$this::$username."&returnUrl=".$returnUrl."&returnUrl=".$returnUrl."&pageView=DESKTOP&sessionTimeoutSecs=1200";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $response = curl_exec($ch);
        curl_close($ch);
 
        if( $response ){
            return json_decode($response, true);
        }
        return false;
    }
 
}