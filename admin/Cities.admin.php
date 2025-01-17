<?PHP
require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class Cities extends Widget
{

	function Cities(&$parent)
	{
		Widget::Widget($parent);
	}
	
	function fetch()
	{
	
		//Обработчики
		if(isset($_GET['action'])){
			switch($_GET['action'])
			{
				case 'enable':
				$this->check_token();
				$id = intval($_GET['id']);
				$query 	= sql_placeholder('UPDATE `cities` SET visible=1 WHERE id=? LIMIT 1', $id);
				$this->db->query($query);
				break;
				
				case 'disable':
				$this->check_token();
				$id = intval($_GET['id']);
				$query 	= sql_placeholder('UPDATE `cities` SET visible=0 WHERE id=? LIMIT 1', $id);
				$this->db->query($query);
				break;
				
				case 'delete':
				$this->check_token();
				$id = intval($_GET['id']);
				$query 	= sql_placeholder('DELETE FROM `cities` WHERE id=? LIMIT 1', $id);
				$this->db->query($query);
				break;
				
				case 'move_up':
				$this->check_token();
				$id = intval($_GET['id']);
				
				$this->db->query("SELECT @id:=s1.id
							  FROM cities s1, cities s2
							  WHERE s1.position<s2.position
							  AND s2.id = ".$id."
							  ORDER BY s1.position DESC
							  LIMIT 1");
				$this->db->query("UPDATE cities s1, cities s2
							  SET s1.position = (@a:=s1.position)*0+s2.position, s2.position = @a
							  WHERE s1.id = ".$id."
							  AND s2.id = @id");
				break;
				
				case 'move_down':
				$this->check_token();
				$id = intval($_GET['id']);
				
				$this->db->query("SELECT @id:=s1.id
							  FROM cities s1, cities s2
							  WHERE s1.position>s2.position
							  AND s2.id = ".$id."
							  ORDER BY s1.position ASC
							  LIMIT 1");
				$this->db->query("UPDATE cities s1, cities s2
							  SET s1.position = (@a:=s1.position)*0+s2.position, s2.position = @a
							  WHERE s1.id = ".$id."
							  AND s2.id = @id");
				break;
			}
			$get = $this->form_get(array());
			header("Location: index.php$get");
		}
		//Обработчики (END)
		
		$query = "SELECT * FROM `cities` ORDER BY `position`";
		$this->db->query($query);
		$cities = $this->db->results();
		foreach($cities as $k=>$city)
		{
			$cities[$k]->edit_get = $this->form_get(array('section'=>'City','id'=>$city->id, 'token'=>$this->token));
			$cities[$k]->delete_get = $this->form_get(array('action'=>'delete', 'id'=>$city->id, 'token'=>$this->token));
			$cities[$k]->enable_get = $this->form_get(array('action'=>($city->visible == 0 ? 'enable' : 'disable'), 'id' => $city->id));
			$cities[$k]->move_up_get = $this->form_get(array('action'=>'move_up','id'=>$city->id, 'token'=>$this->token));
			$cities[$k]->move_down_get = $this->form_get(array('action'=>'move_down','id'=>$city->id, 'token'=>$this->token));
		}
		
		$this->smarty->assign('cities', $cities);
	
		$this->title = 'Города';
		$this->body = $this->smarty->fetch('cities.tpl');
	}

}