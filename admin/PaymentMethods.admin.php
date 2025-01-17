<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# Class PaymentMethods
############################################
class PaymentMethods extends Widget
{
  function PaymentMethods(&$parent)
  {
    parent::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
  	if((isset($_POST['act']) && $_POST['act']=='delete' || isset($_GET['act']) && $_GET['act']=='delete') && (isset($_POST['items']) || isset($_GET['item_id']) ))
  	{
  	    $this->check_token();
  	    
        if(isset($_GET['item_id']) && !empty($_GET['item_id']))
          $item_id = intval($_GET['item_id']);  		

  		$query = sql_placeholder("DELETE FROM payment_methods
 		          WHERE payment_methods.payment_method_id = ?", $item_id);
  		$this->db->query($query);
  		$get = $this->form_get(array());
      header("Location: index.php$get");
    }
    if(isset($_GET['enable_id'])){
        $this->check_token();
      
        $id = $_GET['enable_id'];
        $query = sql_placeholder('UPDATE payment_methods SET enabled=1-enabled WHERE payment_method_id=?',$id);
        $this->db->query($query );
        
        $get = $this->form_get(array());
        if(isset($_GET['from']))
          header("Location: ".$_GET['from']);
        else
      header("Location: index.php$get");
    }
    if(isset($_GET['enable_sber'])){
      $this->check_token();
    
      $e = (int)$_GET['enable_sber'];
      $this->db->query("UPDATE payment_methods SET enabled={$e}, block_date = NOW() WHERE payment_method_id IN (15)" );
      $this->db->query("UPDATE app_payments SET ad_enabled={$e}, ios_enabled={$e}, block_date = NOW() WHERE id = 1" );
      $this->db->query("UPDATE app_payments SET ios_enabled={$e}, block_date = NOW() WHERE id = 3" );
      $this->db->query("UPDATE app_payments SET ad_enabled={$e}, block_date = NOW() WHERE id = 4" );
  	  
      header("Location: index.php?section=PaymentMethods");
    }
    if(isset($_GET['enable_rfi'])){
      $this->check_token();
    
      $e = (int)$_GET['enable_rfi'];
      $this->db->query("UPDATE payment_methods SET enabled={$e}, block_date = NOW() WHERE payment_method_id IN (18)" );
      $this->db->query("UPDATE app_payments SET ad_enabled={$e}, ios_enabled={$e}, block_date = NOW() WHERE id = 2" );
  	  
      header("Location: index.php?section=PaymentMethods");
    }
  }

  function fetch()
  {
    $this->title = $this->lang->PAYMENT_METHODS;
    
    $sber_on = $this->db->result("SELECT COUNT(enabled) AS t FROM payment_methods WHERE payment_method_id = 15 AND (enabled = 1 OR (enabled = 0 AND block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND block_date != 0))" )->t;
    if($sber_on){
      $this->db->query("UPDATE payment_methods SET enabled=1, block_date = 0 WHERE payment_method_id = 15" );
      $this->db->query("UPDATE app_payments SET ad_enabled=1, ios_enabled=1, block_date = 0 WHERE id = 1" );
      $this->db->query("UPDATE app_payments SET ios_enabled=1, block_date = 0 WHERE id = 3" );
      $this->db->query("UPDATE app_payments SET ad_enabled=1, block_date = 0 WHERE id = 4" );
    }
    $this->smarty->assign('sber_on', $sber_on);
    
    $rfi_on = $this->db->result("SELECT COUNT(enabled) AS t FROM payment_methods WHERE payment_method_id = 18 AND (enabled = 1 OR (enabled = 0 AND block_date < DATE_SUB(NOW(), INTERVAL 3 HOUR) AND block_date != 0))" )->t;
    if($rfi_on){
      $this->db->query("UPDATE payment_methods SET enabled=1, block_date = 0 WHERE payment_method_id = 18" );
      $this->db->query("UPDATE app_payments SET ad_enabled=1, ios_ena, block_date = 0led=1 WHERE id = 2" );
    }
    $this->smarty->assign('rfi_on', $rfi_on);

    $this->db->query("SELECT payment_methods.*, currencies.name as currency, currencies.rate_from as rate_from, currencies.rate_to as rate_to, currencies.sign as sign
                      FROM payment_methods LEFT JOIN currencies ON payment_methods.currency_id = currencies.currency_id
    				  ORDER BY payment_methods.payment_method_id");
  	$items = $this->db->results();


    foreach($items as $key=>$item)
    {
       $this->db->query("SELECT * FROM delivery_methods, delivery_payment
                         WHERE delivery_methods.delivery_method_id = delivery_payment.delivery_method_id
                         AND delivery_payment.payment_method_id = ".$item->payment_method_id."
    				     ORDER BY delivery_methods.delivery_method_id");
       $delivery_methods = $this->db->results();
       $items[$key]->delivery_methods = $delivery_methods;
       $items[$key]->edit_get = $this->form_get(array('section'=>'PaymentMethod','item_id'=>$item->payment_method_id, 'token'=>$this->token));
    }

    $this->smarty->assign('Items', $items);
  	$this->smarty->assign('Lang', $this->lang);
    $this->body = $this->smarty->fetch('payment_methods.tpl');
  }
}