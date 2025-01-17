<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');

############################################
# Class DeliveryMethod
############################################
class DeliveryMethod extends Widget
{
  var $item;
  function DeliveryMethod(&$parent)
  {
    Widget::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
    $this->uploaddir = $_SERVER['DOCUMENT_ROOT'] . '/files/deliveries/';
  	$item_id = intval($this->param('item_id'));
  	if(isset($_POST['name']) &&
  	   isset($_POST['price']) &&
  	   isset($_POST['free_from']))
  	{

	$this->check_token();

	$this->item->name 		 = strip_tags($_POST['name']);
	$this->item->description = strip_custom_tags($_POST['description']);
	$this->item->eng_name 		 = strip_tags($_POST['eng_name']);
	$this->item->eng_description = strip_custom_tags($_POST['eng_description']);
	$this->item->price 		 = $_POST['price'];
	$this->item->insurance 		 = $_POST['insurance'];
	$this->item->cash_comission 		 = $_POST['cash_comission'];
	$this->item->free_from 	 = $_POST['free_from'];
	$this->item->enabled 	 = 0;
	if(isset($_POST['enabled'])) {
		$this->item->enabled = 1;
	}
	$this->item->is_local = 0;
	if(isset($_POST['is_local'])) {
		$this->item->is_local = 1;
	}

	if (empty($this->item->name)) {
		$this->error_msg = $this->lang->ENTER_NAME;
	}
	else {
  		if (empty($item_id)) {
  			  $query = sql_placeholder('INSERT INTO delivery_methods (name, description, eng_name, eng_description, price, insurance, cash_comission, free_from, enabled, is_local) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                        $this->item->name,
  			                            $this->item->description,
                                    $this->item->eng_name,
  			                            $this->item->eng_description,
  			                            $this->item->price,
  			                            $this->item->insurance,
  			                            $this->item->cash_comission,
  			                            $this->item->free_from,
  			                            $this->item->enabled,
										$this->item->is_local);

  			  $this->db->query($query);
  			  $item_id = $this->db->insert_id();
		}
		else {
			  $query = sql_placeholder('UPDATE delivery_methods SET name=?, description=?, eng_name=?, eng_description=?, price=?, insurance=?, cash_comission=?, free_from=?, enabled=?, is_local=? WHERE delivery_method_id=?',
									  $this->item->name,
									  $this->item->description,
                    $this->item->eng_name,
                    $this->item->eng_description,
									  $this->item->price,
                    $this->item->insurance,
                    $this->item->cash_comission,
									  $this->item->free_from,
									  $this->item->enabled,
									  $this->item->is_local,
									  $item_id);
			  $this->db->query($query);
		}

		if (!empty($item_id) && isset($_POST['delete_image']) && $_POST['delete_image']==1) {
			$this->db->query("SELECT * FROM delivery_methods WHERE delivery_method_id = '{$item_id}'");
			$category = $this->db->result();
			$file     = $this->uploaddir.$category->image;
			if (is_file($file)) {
			    unlink($file);
			}
			$this->db->query("UPDATE delivery_methods SET image='' WHERE delivery_method_id = '{$item_id}'");
		}

		if (!empty($item_id)) {
			if(isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
				$path_parts = pathinfo($_FILES['image']['name']);
				$uploadfile = $item_id . "." . strtolower($path_parts['extension']);
				if (!move_uploaded_file($_FILES['image']['tmp_name'], $this->uploaddir.$uploadfile)) {
					$this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
				}
				else {
					@chmod($this->uploaddir.$uploadfile, 0644);
					$this->db->query($sql = "UPDATE delivery_methods SET image='$uploadfile' WHERE delivery_method_id = '$item_id'");
				}
			}
			elseif(isset($_POST['image_url'])) {
				$image_url = trim($_POST['image_url']);
				if(preg_match("/^http:\/\/.+(\.jpg|\.jpeg)/i", $image_url)) {
					$image_content = @file_get_contents($image_url);
					if(!empty($image_content)) {
						$image_file = fopen($this->uploaddir.$uploadfile, 'wb');
						fwrite($image_file, $image_content);
						fclose($image_file);
						$this->db->query("UPDATE brands SET image='$uploadfile' WHERE brand_id='$category_id'");
					}
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

		$get = $this->form_get(array('section'=>'DeliveryMethods'));



          if(isset($_GET['from'])) {
            header("Location: ".$_GET['from']);
		  }
          else {
 		    header("Location: index.php$get");
		  }
  		}
  	}

  	elseif (!empty($item_id))
  	{
  	  $query = sql_placeholder('SELECT * FROM delivery_methods WHERE delivery_method_id=? LIMIT 1', $item_id);
  	  $this->db->query($query);
  	  $this->item = $this->db->result();
  	}
  }

  function fetch()
  {
  	  if(empty($this->item->delivery_method_id))
  	    $this->title = 'Новый способ доставки';
  	  else
  	    $this->title = 'Изменение способа доставки';


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
 	  $this->body = $this->smarty->fetch('delivery_method.tpl');
  }
}
