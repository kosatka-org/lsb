<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');
require_once('PagesNavigation.admin.php');


############################################
# Class NewsLine displays news
############################################
class Collections extends Widget
{
  function Collections(&$parent)
  {
    parent::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
    # Сделать статью видимой
    if(isset($_GET['set_active']))
    {
      $id = $_GET['set_active'];
      $query = sql_placeholder('UPDATE products SET coll_active=1 WHERE col_code=?',$id);
      $this->db->query($query );
      
      header("Location: {$_SERVER["HTTP_REFERER"]}");
    }
    if(isset($_GET['unset_active']))
    {
      $id = $_GET['unset_active'];
      $query = sql_placeholder('UPDATE products SET coll_active=0 WHERE col_code=?',$id);
      $this->db->query($query );
      
      header("Location: {$_SERVER["HTTP_REFERER"]}");
    }

  }

  function fetch()
  {
    $this->title = 'Коллекции';
    $this->db->query("SELECT col_code, brand_id, SUM(sizes_max_count) AS s_count, COUNT(product_id) AS p_count, coll_active
    				  FROM products 
                      WHERE col_code != 0
                      AND col_code != '' 
                      GROUP BY col_code 
    				  ORDER BY created DESC");
  	$items = $this->db->results();

    foreach($items as $key=>$item)
    {
      $item->l_count = 0;
      $item->date = substr($item->col_code,0,2) .'.'. substr($item->col_code,2,2) .'.'. substr($item->col_code,6,2);
      $item->brand = $this->db->result("SELECT name FROM brands WHERE brand_id = {$item->brand_id}")->name;
      $item->products = $this->db->results("SELECT * FROM products WHERE col_code = '{$item->col_code}'");
        foreach($item->products as $prod){
          $items[$key]->l_count += $this->db->result("SELECT COUNT(item_id) AS s_count FROM items WHERE product_id = {$prod->product_id}")->s_count;
        }
    }

 	$this->smarty->assign('Items', $items);
  	$this->smarty->assign('Lang', $this->lang);
 	$this->body = $this->smarty->fetch('collections.tpl');
  }
}
