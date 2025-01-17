<?PHP
require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class Goods extends Widget
{

	function Goods(&$parent)
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
				$query 	= sql_placeholder('UPDATE `goods` SET visible=1 WHERE id=? LIMIT 1', $id);
				$this->db->query($query);
				break;
				
				case 'disable':
				$this->check_token();
				$id = intval($_GET['id']);
				$query 	= sql_placeholder('UPDATE `goods` SET visible=0 WHERE id=? LIMIT 1', $id);
				$this->db->query($query);
				break;
				
				case 'delete':
				$this->check_token();
				$id = intval($_GET['id']);
				$query 	= sql_placeholder('DELETE FROM `goods` WHERE id=? LIMIT 1', $id);
				$this->db->query($query);
				break;
				
				case 'move_up':
				$this->check_token();
				$id = intval($_GET['id']);
				
				$this->db->query("SELECT @id:=s1.id
							  FROM goods s1, goods s2
							  WHERE s1.position<s2.position
							  AND s2.id = ".$id."
							  ORDER BY s1.position DESC
							  LIMIT 1");
				$this->db->query("UPDATE goods s1, goods s2
							  SET s1.position = (@a:=s1.position)*0+s2.position, s2.position = @a
							  WHERE s1.id = ".$id."
							  AND s2.id = @id");
				break;
				
				case 'move_down':
				$this->check_token();
				$id = intval($_GET['id']);
				
				$this->db->query("SELECT @id:=s1.id
							  FROM goods s1, goods s2
							  WHERE s1.position>s2.position
							  AND s2.id = ".$id."
							  ORDER BY s1.position ASC
							  LIMIT 1");
				$this->db->query("UPDATE goods s1, goods s2
							  SET s1.position = (@a:=s1.position)*0+s2.position, s2.position = @a
							  WHERE s1.id = ".$id."
							  AND s2.id = @id");
				break;
			}
			$get = $this->form_get(array());
			header("Location: index.php$get");
		}
		//Обработчики (END)
		
		$query = "SELECT * FROM `goods` ORDER BY `title`";
		$this->db->query($query);
		$goods = $this->db->results();
		foreach($goods as $k=>$good)
		{
			$goods[$k]->edit_get = $this->form_get(array('section'=>'Good','id'=>$good->id, 'token'=>$this->token));
			$goods[$k]->delete_get = $this->form_get(array('action'=>'delete', 'id'=>$good->id, 'token'=>$this->token));
			$goods[$k]->enable_get = $this->form_get(array('action'=>($good->visible == 0 ? 'enable' : 'disable'), 'id' => $good->id));
			$goods[$k]->move_up_get = $this->form_get(array('action'=>'move_up','id'=>$good->id, 'token'=>$this->token));
			$goods[$k]->move_down_get = $this->form_get(array('action'=>'move_down','id'=>$good->id, 'token'=>$this->token));
		}
		
		$this->smarty->assign('goods', $goods);
	
		$this->title = 'Бренд-категория';
		$this->body = $this->smarty->fetch('goods.tpl');
	}

}