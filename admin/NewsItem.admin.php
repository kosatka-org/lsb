<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# Class NewsItem - edit the news item
############################################
class NewsItem extends Widget
{
  var $uploaddir = '../files/news/';
  var $item;
  function NewsItem(&$parent)
  {
    Widget::Widget($parent);
    $this->add_param('page');
    $this->prepare();
  }

  function prepare(){
  
   	$item_id = intval($this->param('item_id'));
  	if(isset($_POST['date']))
  	{
  		$this->item->url = $_POST['url'];
  		$this->item->date = $_POST['date'];
  		$this->item->header = $_POST['header'];
  		$this->item->meta_title = $_POST['meta_title'];
  		$this->item->meta_keywords = $_POST['meta_keywords'];
  		$this->item->meta_description = $_POST['meta_description'];
  		$this->item->body = $_POST['body'];
		$this->item->video = $_POST['video'];
  		$this->item->enabled = $_POST['enabled']==1?1:0; 		

        $this->check_token();

        ## Не допустить одинаковые URL новостей.
    	$query = sql_placeholder('select count(*) as count from news where url=? and news_id!=?',
                $this->item->url,
                $item_id);
        $this->db->query($query);
        $res = $this->db->result();


  		if(empty($this->item->header))
  		  $this->error_msg = $this->lang->ENTER_TITLE;
  		elseif($res->count>0)
  		  $this->error_msg = 'Новость с таким URL уже существует. Выберите другой URL.';
        else
  		{
  			if(empty($item_id))
  			$query = sql_placeholder('INSERT INTO news(header, url, date, meta_title, meta_keywords, meta_description, body, video, enabled, editor_id, created, modified) VALUES(?, ?, STR_TO_DATE(?, "%d.%m.%Y"), ?, ?, ?, ?, ?, ?, ?, now(), now())',
                                      $this->item->header,
                                      $this->item->url,
  			                          $this->item->date,
  			                          $this->item->meta_title,
  			                          $this->item->meta_keywords,
  			                          $this->item->meta_description,
  			                          $this->item->body,
									  $this->item->video,
  			                          $this->item->enabled,
  			                          intval($_SESSION['user']->user_id)
  			                          );
  			else
  			$query = sql_placeholder('UPDATE news SET header=?, url=?, date=STR_TO_DATE(?, "%d.%m.%Y"), meta_title=?, meta_keywords=?, meta_description=?, body=?, video=?, enabled=?, modified=now() WHERE news_id=?',
                                      $this->item->header,
                                      $this->item->url,
  			                          $this->item->date,
  			                          $this->item->meta_title,
  			                          $this->item->meta_keywords,
  			                          $this->item->meta_description,
  			                          $this->item->body,
  			                          $this->item->video,
  			                          $this->item->enabled,
  			                          $item_id);
  			$this->db->query($query);
			
			if(empty($item_id))
				$item_id = $this->db->insert_id();
			
			if (!empty($item_id) && isset($_POST['delete_image']) && $_POST['delete_image']==1) {
				$item 	= $this->db->result("SELECT * FROM news WHERE news_id = '{$item_id}'");
				$file 		= $this->uploaddir.$category->image;
				if (is_file($file)) unlink($file);
				$this->db->query("UPDATE news SET image='' WHERE news_id=$item_id");
			}

			if(!empty($item_id)) {
				$uploadfile = $item_id.".jpg";
				if(isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
					if (!move_uploaded_file($_FILES['image']['tmp_name'], $this->uploaddir.$uploadfile)) {
						$this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
					}
					else {
						@chmod($this->uploaddir.$uploadfile, 0644); 
						$this->db->query("UPDATE news SET image='{$uploadfile}' WHERE news_id='{$item_id}'");  	       
					}
				}
				elseif (isset($_POST['image_url'])) {
					$image_url = trim($_POST['image_url']);
					if(preg_match("/^http:\/\/.+(\.jpg|\.jpeg)/i", $image_url)) {
						$image_content = @file_get_contents($image_url);
						if (!empty($image_content)) {
							$image_file = fopen($this->uploaddir.$uploadfile, 'wb');
							fwrite($image_file, $image_content);
							fclose($image_file);  
							$this->db->query("UPDATE news SET image='{$uploadfile}' WHERE news_id='{$item_id}'");	         
						}
					}  	  
				}
			}

 		$get = $this->form_get(array('section'=>'NewsLine'));
		if(isset($_GET['from']))
            header("Location: ".$_GET['from']);
		else
 		    header("Location: index.php$get");
  		}
  	}
  	elseif (!empty($item_id))
  	{
  	  $query = sql_placeholder('SELECT *, DATE_FORMAT(date, "%d.%m.%Y") as date FROM news WHERE news_id=?', $item_id);
  	  $this->db->query($query);
  	  $this->item = $this->db->result();
  	}
  }

  function fetch()
  {
  	  if(empty($this->item->news_id))
  	    $this->title = $this->lang->NEW_NEWS_ITEM;
  	  else
  	    $this->title = $this->lang->EDIT_NEWS_ITEM;


 	  $this->smarty->assign('Item', $this->item);
 	  $this->smarty->assign('Error', $this->error_msg);
      $this->smarty->assign('Lang', $this->lang);
 	  $this->body = $this->smarty->fetch('news_item.tpl');
  }
}