<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# Class EditServiceSection - edit the static section
############################################
class Special extends Widget
{
  var $item;
  function Special(&$parent)
  {
    Widget::Widget($parent);
    $this->add_param('page');
    $this->prepare();
  }

  function prepare()
  {
  	$item_id = intval($this->param('item_id'));
  	if (
  	   isset($_POST['name']) &&
  	   isset($_POST['description']) &&
  	   isset($_POST['gender']) &&
  	   isset($_POST['params']))
  	{

      if ($_POST['name'] == 'Новая подборка') {
        $_POST['name'] = $_POST['name'] . ' ' . time();
      }
  		$this->item->name = $_POST['name'];
  		$this->item->eng_name = isset($_POST['eng_name']) ? $_POST['eng_name'] : '';
      $this->item->url = $_POST['url'];
  		$this->item->description = $_POST['description'];
  		$this->item->meta_description = $_POST['meta_description'];
  		$this->item->meta_keywords = $_POST['meta_keywords'];
  		$this->item->meta_title = $_POST['meta_title'];
      $this->item->params = $_POST['params'];
  		$this->item->urls = $_POST['urls'];
  		$this->item->gender = $_POST['gender'];
      $this->item->look_special = ($_POST['look_special']) ? 1 : 0;
      $this->item->sale = ($_POST['sp_sale']) ? 1 : 0;
      $enc_urls = '';
      if ( !empty($this->item->urls) ) {
        if ($this->item->look_special) {
          $enc_urls = str_replace("https://lsboutique.ru/look/","",$this->item->urls);
        }
        else {
          $enc_urls = str_replace("https://lsboutique.ru/products/","",$this->item->urls);
        }
        $enc_urls = str_replace(" ","",$enc_urls);
        $enc_urls = str_replace("/","",$enc_urls);
        if (!empty($enc_urls)) {
          $enc_urls = "'" . str_replace(array("\r\n", "\n", "\r"),"','",$enc_urls) . "'";
        }
      }

      if(isset($_POST['enabled']) && $_POST['enabled']==1)
        $this->item->enabled = 1;
      else
        $this->item->enabled = 0;


        ## Не допустить одинаковые URL новостей.
    	$query = sql_placeholder('select count(*) as count from specials where name=? and special_id!=?',
                $this->item->name,
                $item_id);
        $this->db->query($query);
        $res = $this->db->result();

  		if(empty($this->item->name))
  		  $this->error_msg = $this->lang->ENTER_TITLE;
  		elseif($res->count>0)
  		  $this->error_msg = 'Подборка с таким названием уже существует. Выберите другое название.';
      else
  		{

  			if (empty($item_id))
            {
  				$query = sql_placeholder('INSERT INTO specials(special_id, name, eng_name, description, meta_title, meta_keywords, meta_description, gender, query_params, urls, sale) VALUES(NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
              	                  $this->item->name,
              	                  $this->item->eng_name,
              	                  $this->item->description,
              	                  $this->item->meta_title,
              	                  $this->item->meta_keywords,
              	                  $this->item->meta_description,
  			                          $this->item->gender,
                                  $this->item->params,
                                  $enc_urls,
                                  $this->item->sale);
          $this->db->query($query);
	  			$inserted_id = $this->db->insert_id();
          // Resque::enqueue('default', 'UrlUpdateJob', array('fast' => true));

            }
  			else
            {
  				$query = sql_placeholder('UPDATE specials SET name=?, eng_name=?, url=?, description=?, meta_title=?, meta_keywords=?, meta_description=?, urls=?, gender=?, query_params=?, enabled=?, look_special=?, sale=? WHERE special_id=?',
                                  $this->item->name,
                                  $this->item->eng_name,
                                  $this->item->url,
              	                  $this->item->description,
              	                  $this->item->meta_title,
              	                  $this->item->meta_keywords,
                                  $this->item->meta_description,
              	                  $enc_urls,
  			                          $this->item->gender,
                                  $this->item->params,
                                  $this->item->enabled,
  			                          $this->item->look_special,
			                            $this->item->sale,
  			                          $item_id);
                $this->db->query($query);
                // Resque::enqueue('default', 'UrlUpdateJob', array('fast' => true));
            }

        if (isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
  		      $this->uploaddir = $_SERVER['DOCUMENT_ROOT'] . '/files/images/';
				    $path_parts = pathinfo($_FILES['image']['name']);
				    $uploadfile = $item_id . "." . strtolower($path_parts['extension']);
				    if (!move_uploaded_file($_FILES['image']['tmp_name'], $this->uploaddir.$uploadfile)) {
					    $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
				    }
				    else {
					    @chmod($this->uploaddir.$uploadfile, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/images/'.$uploadfile, 'local_path' => $this->uploaddir.$uploadfile]);
					    $this->db->query($sql = "UPDATE specials SET picture='$uploadfile' WHERE special_id = '$item_id'");
				    }
		    }
		    elseif (isset($_POST['delete_large_image']) && $_POST['delete_large_image'] == 1) {
		      $this->db->query($sql = "UPDATE specials SET picture='' WHERE special_id = '$item_id'");
	      }

		    if (isset($_FILES['small_image']) && !empty($_FILES['small_image']['tmp_name'])) {
  		      $this->uploaddir = $_SERVER['DOCUMENT_ROOT'] . '/files/images/';
				    $path_parts = pathinfo($_FILES['small_image']['name']);
				    $uploadfile = $item_id . "_small." . strtolower($path_parts['extension']);
				    if (!move_uploaded_file($_FILES['small_image']['tmp_name'], $this->uploaddir.$uploadfile)) {
					    $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
				    }
				    else {
					    @chmod($this->uploaddir.$uploadfile, 0644);
					    $this->db->query($sql = "UPDATE specials SET small_picture='$uploadfile' WHERE special_id = '$item_id'");
				    }
		    }
		    elseif (isset($_POST['delete_small_image']) && $_POST['delete_small_image'] == 1) {
		      $this->db->query($sql = "UPDATE specials SET small_picture='' WHERE special_id = '$item_id'");
	      }


 			$get = $this->form_get(array('section'=>'Specials'));
        if(isset($_GET['from']))
          header("Location: ".$_GET['from']);
        else
 		  header("Location: index.php$get");
  		}
  	}

  	elseif (!empty($item_id))
  	{
  	  $query = sql_placeholder('SELECT * FROM specials WHERE special_id=?', $item_id);
  	  $this->db->query($query);
  	  $this->item = $this->db->result();
  	  $urls = $this->item->urls;
  	  $urls = str_replace("'","",$urls);
      if (empty($urls)) {
      }
      elseif ($this->item->look_special) {
        $urls = "https://lsboutique.ru/look/" . str_replace(",","\nhttps://lsboutique.ru/look/",$urls);
      }
      else {
        $urls = "https://lsboutique.ru/products/" . str_replace(",","\nhttps://lsboutique.ru/products/",$urls);
      }
  	  $this->smarty->assign('Urls', $urls);
  	}
  }

  function fetch()
  {
  	  if(empty($this->item->special_id))
  	    $this->title = $this->lang->NEW_Special;
  	  else
  	    $this->title = $this->lang->EDIT_Special;

 	  $this->smarty->assign('Item', $this->item);
 	  $this->smarty->assign('Error', $this->error_msg);
    $this->smarty->assign('Lang', $this->lang);
 	  $this->body = $this->smarty->fetch('special.tpl');
  }
}
