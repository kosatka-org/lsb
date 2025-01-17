<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# Class PaymentMethod
############################################
class PaymentMethod extends Widget
{
  var $item;
  function PaymentMethod(&$parent)
  {
    Widget::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
    $this->uploaddir = $_SERVER['DOCUMENT_ROOT'] . '/files/payments/';
    $item_id = intval($this->param('item_id'));
    if(isset($_POST['name']) &&
       isset($_POST['currency_id']) &&
       isset($_POST['description']))
    {
        $this->check_token();

        $this->item->name            = $_POST['name'];
        $this->item->currency_id     = $_POST['currency_id'];
        $this->item->description     = $_POST['description'];
        $this->item->eng_name        = $_POST['eng_name'];
        $this->item->eng_description = $_POST['eng_description'];
        $this->item->module          = $_POST['module'];
        $this->item->params          = $_POST['params'];
        $this->item->enabled_admin   = isset($_POST['enabled_admin']) ? $_POST['enabled_admin'] : 0;
        $this->item->is_local        = isset($_POST['is_local']) ? $_POST['is_local'] : 0;
        $this->item->enabled         = isset($_POST['enabled']) ? $_POST['enabled'] : 0;

        if(empty($this->item->name))
          $this->error_msg = $this->lang->ENTER_NAME;
        else
        {
            if(empty($item_id))
            {
              $query = sql_placeholder('INSERT INTO payment_methods (name, currency_id, description, eng_name, eng_description, module, enabled, enabled_admin, params, is_local) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                        $this->item->name,
                                        $this->item->currency_id,
                                        $this->item->description,
                                        $this->item->eng_name,
                                        $this->item->eng_description,
                                        $this->item->module,
                                        $this->item->enabled,
                                        $this->item->enabled_admin,
                                        serialize($this->item->params),
                                        $this->item->is_local);

              $this->db->query($query);
              $item_id = $this->db->insert_id();
            }
            else
            {
              $query = sql_placeholder('UPDATE payment_methods SET name=?, currency_id=?, description=?, eng_name=?, eng_description=?, module=?, enabled=?, enabled_admin=?, params=?, is_local=? WHERE payment_method_id=?',
                                      $this->item->name,
                                      $this->item->currency_id,
                                      $this->item->description,
                                      $this->item->eng_name,
                                      $this->item->eng_description,
                                      $this->item->module,
                                      $this->item->enabled,
                                      $this->item->enabled_admin,
                                      serialize($this->item->params),
                                      $this->item->is_local,
                                      $item_id);

              $this->db->query($query);
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
                        $this->db->query($sql = "UPDATE payment_methods SET image='$uploadfile' WHERE payment_method_id = '$item_id'");
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
                            $this->db->query("UPDATE payment_methods SET image='$uploadfile' WHERE payment_method_id='$item_id'");
                        }
                    }
                  }
                }

            // Способы доставки
            $query = sql_placeholder('DELETE FROM delivery_payment WHERE payment_method_id=?', $item_id);
            $this->db->query($query);

            $delivery_methods = $_POST['delivery_methods'];

            if(!empty($delivery_methods))
            foreach($delivery_methods as $k=>$delivery_method)
            {
              $query = sql_placeholder('INSERT INTO delivery_payment (delivery_method_id, payment_method_id) VALUES(?, ?)', $k, $item_id);
              $this->db->query($query);
            }



            $get = $this->form_get(array('section'=>'PaymentMethods'));
          if(isset($_GET['from']))
            header("Location: ".$_GET['from']);
          else
            header("Location: index.php$get");
        }
    }

    elseif (!empty($item_id))
    {
      $query = sql_placeholder('SELECT * FROM payment_methods WHERE payment_method_id=?', $item_id);
      $this->db->query($query);
      $this->item = $this->db->result();
      $this->item->params = unserialize($this->item->params);
    }
  }

  function fetch()
  {
      if(empty($this->item->payment_method_id))
        $this->title = 'Новый способ оплаты';
      else
        $this->title = 'Изменение способа оплаты';

      $query = sql_placeholder('SELECT * FROM currencies');
      $this->db->query($query);
      $currencies = $this->db->results();

      $query = sql_placeholder('SELECT delivery_methods.*, (delivery_payment.payment_method_id IS NOT NULL) as enabled FROM delivery_methods
                                LEFT JOIN delivery_payment
                                ON delivery_methods.delivery_method_id=delivery_payment.delivery_method_id
                                AND delivery_payment.payment_method_id=?', empty($this->item->payment_method_id)?1:$this->item->payment_method_id);
      $this->db->query($query);
      $delivery_methods = $this->db->results();

      if(isset($_POST['delivery_methods']))
      {
        foreach($delivery_methods as $k=>$d_m)
        {
          if(isset($_POST['delivery_methods'][$d_m->delivery_method_id]))
            $delivery_methods[$k]->enabled=1;
          else
            $delivery_methods[$k]->enabled=0;
        }
      }


      $this->smarty->assign('Item', $this->item);
      $this->smarty->assign('Currencies', $currencies);
      $this->smarty->assign('DeliveryMethods', $delivery_methods);
      $this->smarty->assign('ErrorMSG', $this->error_msg);
      $this->smarty->assign('Lang', $this->lang);
      $this->body = $this->smarty->fetch('payment_method.tpl');
  }
}
