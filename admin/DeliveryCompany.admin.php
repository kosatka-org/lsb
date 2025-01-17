<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');

############################################
# Class DeliveryCompany
############################################
class DeliveryCompany extends Widget
{
  var $item;
  function DeliveryCompany(&$parent)
  {
    Widget::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
    $this->uploaddir = $_SERVER['DOCUMENT_ROOT'] . '/files/deliveries/';
  	$item_id = intval($this->param('item_id'));
  	if(isset($_POST['name']))
  	{

	$this->item->name 		 = $_POST['name'];
	$this->item->address = $_POST['address'];
	$this->item->dogovor_number = $_POST['dogovor_number'];
	$this->item->email = $_POST['email'];
	$this->item->phone = $_POST['phone'];
	$this->item->calendar_id = $_POST['calendar_id'];
	$this->item->user_id = $_POST['user_id'];
	$this->item->active 	 = 0;
	if(isset($_POST['active'])) {
		$this->item->active = 1;
	}

  $query = sql_placeholder('UPDATE delivery_companies SET name=?, address=?, dogovor_number=?, email=?, phone=?, calendar_id=?, user_id=?, active=? WHERE id=?',
						  $this->item->name,
						  $this->item->address,
              $this->item->dogovor_number,
              $this->item->email,
              $this->item->phone,
              $this->item->calendar_id,
              $this->item->user_id,
						  $this->item->active,
						  $item_id);
  $this->db->query($query);

		if (!empty($item_id) && isset($_POST['delete_image']) && $_POST['delete_image']==1) {
			$dc = $this->db->result("SELECT * FROM delivery_companies WHERE id = '{$item_id}'");
			$file     = $this->uploaddir.$dc->logo;
			if (is_file($file)) {
			    unlink($file);
			}
			$this->db->query("UPDATE delivery_companies SET logo='' WHERE id = '{$item_id}'");
		}

		if (!empty($item_id)) {
			if(isset($_FILES['logo']) && !empty($_FILES['logo']['tmp_name'])) {
				$path_parts = pathinfo($_FILES['logo']['name']);
				$uploadfile = $item_id . "." . strtolower($path_parts['extension']);
				if (!move_uploaded_file($_FILES['logo']['tmp_name'], $this->uploaddir.$uploadfile)) {
					$this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
				}
				else {
					@chmod($this->uploaddir.$uploadfile, 0644);
					$this->db->query($sql = "UPDATE delivery_methods SET logo='$uploadfile' WHERE id = '$item_id'");
				}
			}
		}

		// Способы доставки
		$query = sql_placeholder('DELETE FROM delivery_payment WHERE delivery_method_id=?', $item_id);
		$this->db->query($query);

		$payment_methods = array();
		if(isset($_POST['payment_methods']))
		  $payment_methods = $_POST['payment_methods'];

		if(!empty($payment_methods))
		foreach($payment_methods as $k=>$payment_method)
		{
		  $query = sql_placeholder('INSERT INTO delivery_payment (delivery_method_id, payment_method_id) VALUES(?, ?)', $item_id, $k);
		  $this->db->query($query);
		}

		$get = $this->form_get(array('section'=>'DeliveryCompanies'));



          if(isset($_GET['from'])) {
            header("Location: ".$_GET['from']);
		  }
          else {
 		    header("Location: index.php$get");
		  }
  	}

  	elseif (!empty($item_id))
  	{
  	  $query = sql_placeholder('SELECT * FROM delivery_companies WHERE id=? LIMIT 1', $item_id);
  	  $this->db->query($query);
  	  $this->item = $this->db->result();
  	}
  }

  function fetch()
  {
	    $this->title = 'Редактирование {$this->item->name}';
  	  $query = sql_placeholder('SELECT payment_methods.*, (delivery_payment.delivery_method_id IS NOT NULL) as enabled FROM payment_methods
  	                            LEFT JOIN delivery_payment
  	                            ON payment_methods.payment_method_id=delivery_payment.payment_method_id
  	                            AND delivery_payment.delivery_method_id=?', empty($this->item->delivery_method_id)?0:$this->item->delivery_method_id);
  	  $this->db->query($query);
  	  $payment_methods = $this->db->results();
  	  if(isset($_POST['payment_methods']))
  	  {
        foreach($payment_methods as $k=>$p_m)
        {
          if(isset($_POST['payment_methods'][$p_m->payment_method_id]))
            $payment_methods[$k]->enabled=1;
          else
          	$payment_methods[$k]->enabled=0;
        }
  	  }


 	  $this->smarty->assign('Item', $this->item);
      $this->smarty->assign('PaymentMethods', $payment_methods);
 	  $this->smarty->assign('ErrorMSG', $this->error_msg);
      $this->smarty->assign('Lang', $this->lang);
 	  $this->body = $this->smarty->fetch('delivery_company.tpl');
  }
}
