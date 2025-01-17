<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');
require_once('PagesNavigation.admin.php');


############################################
# Class NewsLine displays news
############################################
class Specials extends Widget
{
  var $pages_navigation;
  var $items_per_page = 20;
  function Specials(&$parent)
  {
    parent::Widget($parent);
    $this->add_param('page');
    $this->add_param('section');
    $this->add_param('keyword');
    $this->add_param('active');
    $this->pages_navigation = new PagesNavigation($this);
    $this->prepare();
  }

  function prepare()
  {
  	if((isset($_POST['act']) && $_POST['act']=='delete' || isset($_GET['act']) && $_GET['act']=='delete') && (isset($_POST['items']) || isset($_GET['item_id']) ))
  	{
      $this->check_token();

      if(isset($_GET['item_id']) && !empty($_GET['item_id']))
        $items = array($_GET['item_id']);

  		if(is_array($items))
  		  $items_sql = implode("', '", $items);
  		else
  		  $items_sql = $items;
  		$query = "DELETE FROM specials
 		          WHERE specials.special_id IN ('$items_sql')";
  		$this->db->query($query);
  		$get = $this->form_get(array());
      header("Location: index.php$get");
    }
    # Сделать статью видимой
    if(isset($_GET['set_enabled']))
    {
      $this->check_token();

      $id = $_GET['set_enabled'];
      $query = sql_placeholder('UPDATE specials SET enabled=1-enabled WHERE special_id=?',$id);
      $this->db->query($query );

  	  $get = $this->form_get(array());
      if(isset($_GET['from']))
        header("Location: ".$_GET['from']);
      else
      header("Location: index.php$get");
    }


  }

  function fetch()
  {
    $this->title = 'Подборки';
  	$current_page = $this->param('page');
  	$keyword = $this->param('keyword');
  	$active = $this->param('active');
  	$start_item = $current_page*$this->items_per_page;
    $filter = '';
    
    if(!empty($keyword)){
      $filter = " AND (name LIKE '%{$keyword}%' OR eng_name LIKE '%{$keyword}%' OR special_id LIKE '%{$keyword}%') ";
    }
    if($active)$filter .= " AND enabled != 0"; 
    
    $this->db->query($sql = "SELECT SQL_CALC_FOUND_ROWS *
    				  FROM specials
              WHERE 1 {$filter}
              ORDER BY special_id DESC
    				  LIMIT $start_item ,$this->items_per_page");
  	$items = $this->db->results();

    $this->db->query("SELECT FOUND_ROWS() as count");
    $pages_num = $this->db->result();
    $pages_num = $pages_num->count/$this->items_per_page;

    foreach($items as $key=>$item)
    {
       $items[$key]->edit_get = $this->form_get(array('section'=>'Special','item_id'=>$item->special_id, 'token'=>$this->token));
       $items[$key]->delete_get = $this->form_get(array('act'=>'delete','item_id'=>$item->special_id, 'token'=>$this->token));
       $items[$key]->enable_get = $this->form_get(array('set_enabled'=>$item->special_id, 'token'=>$this->token));
    }

  	$this->db->query("SELECT * FROM menu WHERE menu_id>0 ORDER BY menu_id DESC");
  	$menus = $this->db->results();
 	$this->smarty->assign('Menus', $menus);

  	$this->pages_navigation->fetch($pages_num);
 	$this->smarty->assign('Items', $items);
  	$this->smarty->assign('PagesNavigation', $this->pages_navigation->body);
  	$this->smarty->assign('Lang', $this->lang);
 	$this->body = $this->smarty->fetch('specials.tpl');
  }
}
