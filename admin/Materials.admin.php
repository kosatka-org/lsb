<?PHP
require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class Materials extends Widget
{

	function Materials(&$parent)
	{
		Widget::Widget($parent);
	}
	
	function fetch()
	{
	
		//Обработчики
		if(isset($_GET['action'])){
			$this->check_token();
			$id = intval($_GET['id']);
			$query 	= sql_placeholder('DELETE FROM `s_materials` WHERE material_id=? LIMIT 1', $id);
			$this->db->query($query);
			$get = $this->form_get(array());
			header("Location: index.php$get");
		}
		//Обработчики (END)
		
		$query = "SELECT * FROM `s_materials` ORDER BY `name`";
		$this->db->query($query);
		$materials = $this->db->results();
		foreach($materials as $k=>$material)
		{
			$materials[$k]->edit_get = $this->form_get(array('section'=>'Material','id'=>$material->material_id, 'token'=>$this->token));
			$materials[$k]->delete_get = $this->form_get(array('action'=>'delete', 'id'=>$material->material_id, 'token'=>$this->token));
		}
		
		$this->smarty->assign('materials', $materials);
	
		$this->title = 'Эксклюзивные материалы';
		$this->body = $this->smarty->fetch('materials.tpl');
	}

}