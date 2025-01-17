<?PHP

require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class Faq extends Widget
{

	var $pages_navigation;

	function Faq(&$parent)
	{
		Widget::Widget($parent);
	}

	function fetch()
	{
		
		$id = intval($_GET['id']);
		$query 	= sql_placeholder('SELECT * FROM `faqs` WHERE id=? LIMIT 1', $id);
		$this->db->query($query);
		$question = $this->db->result();
		
		if(!$question){
			header('location: ?section=Faqs');
			return;
		}
		
		if(isset($_POST['user_name'])){
		
			 $this->check_token();
			 
			 $question->visible = intval($_POST['visible']);
			 $question->user_name = $_POST['user_name'];
			 $question->user_email = $_POST['user_email'];
			 $question->user_phone = $_POST['user_phone'];
			 $question->user_feature = $_POST['user_feature'];
			 $question->question = $_POST['question'];
			 $question->answer = $_POST['answer'];
			 $question->dat = $_POST['dat'];
			
			$query = sql_placeholder('UPDATE `faqs` SET `visible`=?, `user_name`=?, `user_email`=?, `user_phone`=?, `user_feature`=?, `question`=?, `answer`=?, `dat`=? WHERE `id`=?', $question->visible, $question->user_name, $question->user_email, $question->user_phone, $question->user_feature, $question->question, $question->answer,  $question->dat,  $id);
			$this->db->query($query);
			$this->smarty->assign('action_success', 1);
		
		}
		
		$this->smarty->assign('question', $question);
		
		$this->title = "Вопрос-ответ";
		$this->body = $this->smarty->fetch('faq.tpl');
		
	}

}