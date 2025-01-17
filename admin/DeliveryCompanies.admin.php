<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# Class NewsLine displays news
############################################
class DeliveryCompanies extends Widget
{
  function DeliveryCompanies(&$parent)
  {
    parent::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
    if(isset($_GET['enable_id']))
    {
      $id = $_GET['enable_id'];
      $query = sql_placeholder('UPDATE delivery_companies SET active=1-active WHERE id=?',$id);
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
    $this->title = 'Транспортные компании';

    $this->db->query("SELECT * FROM delivery_companies ORDER BY id");
  	$items = $this->db->results();


    foreach($items as $key=>$item)
    {
       $items[$key]->edit_get = $this->form_get(array('section'=>'DeliveryCompany','item_id'=>$item->id, 'token'=>$this->token));
    }

 	$this->smarty->assign('Items', $items);
  	$this->smarty->assign('Lang', $this->lang);
 	$this->body = $this->smarty->fetch('delivery_companies.tpl');
  }
}
