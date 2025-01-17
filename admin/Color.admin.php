<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# EditBrand
############################################
class Color extends Widget
{
  var $brand;
  var $uploaddir = '';

  function Color(&$parent)
  {
    Widget::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
    if($this->param('item_id'))
      $this->brand->brand_id = $this->param('item_id');
    else
      $this->brand->brand_id = '';

    if(isset($_POST['name']))
    {
        $this->check_token();

  	    $this->brand->name = $_POST['name'];

  		if(empty($this->brand->name))
  		  $this->error_msg = $this->lang->ENTER_NAME;
        else
        {
  	  	  if(!empty($this->brand->brand_id))
          {
            $brand_id = $this->brand->brand_id;
            if(empty($this->brand->url))
            $this->brand->url = $brand_id;
	        $query = sql_placeholder('UPDATE colors
  	                    		  SET name=?
  	                    		  WHERE color_id=?',
  	                    		  $this->brand->name,
  	                    		  $this->brand->brand_id);
  	        $this->db->query($query);
          }
          else
          {
  			$query = sql_placeholder('INSERT INTO colors (name) VALUES(?)', $this->brand->name );
  			$this->db->query($query);
  			$brand_id = $last_insert_id = $this->db->insert_id();
            if(empty($this->brand->url))
              $this->brand->url = $brand_id;
  		  }
		  

	  
     	  $get = $this->form_get(array('section'=>'Colors'));
           if(isset($_GET['from']))
				header("Location: ".$_GET['from']);
  	       else     	  
				header("Location: index.php$get");
        }

  	}
    else
  	{
      $query = sql_placeholder('SELECT *
	                    		FROM colors
	                    		WHERE color_id=?',
            		            $this->brand->brand_id);
 	  $this->db->query($query);
  	  $this->brand = $this->db->result();
  	}
  }

  function fetch()
  {
      if(!empty($this->brand->brand_id))
    	  $this->title = 'Редактирование &laquo;'.$this->brand->name.'&raquo;';
      else
    	  $this->title = 'Новый цвет';

 	  $this->smarty->assign('Item', $this->brand);
 	  $this->smarty->assign('Error', $this->error_msg);
      $this->smarty->assign('Lang', $this->lang);
 	  $this->body = $this->smarty->fetch('color.tpl');
  }
}