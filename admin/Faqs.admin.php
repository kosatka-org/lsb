<?PHP

require_once('Widget.admin.php');
require_once('Storefront.admin.php');
require_once('PagesNavigation.admin.php');

class Faqs extends Widget
{

	var $pages_navigation;

	function Faqs(&$parent)
	{
		Widget::Widget($parent);
		$this->add_param('page');
		$this->pages_navigation = new PagesNavigation($this);
	}

	function fetch()
	{
		
		if(isset($_GET['enable']))
		{
			$this->check_token();
			$id = intval($_GET['enable']);
			$query 	= sql_placeholder('UPDATE `faqs` SET visible=1 WHERE id=? LIMIT 1', $id);
			$this->db->query($query);
		}
		if(isset($_GET['disable']))
		{
			$this->check_token();
			$id = intval($_GET['disable']);
			$query 	= sql_placeholder('UPDATE `faqs` SET visible=0 WHERE id=? LIMIT 1', $id);
			$this->db->query($query);
		}
		if(isset($_GET['delete']))
		{
			$this->check_token();
			$id = intval($_GET['delete']);
			$query 	= sql_placeholder('DELETE FROM `faqs` WHERE id=? LIMIT 1', $id);
			$this->db->query($query);
		}
	
		$row_at_page = 25;
		$current_page = (int)$this->param('page');
		$current_page = $current_page;
	
		//$query = $this->db->placehold("SELECT * FROM __faq WHERE 1 ORDER BY (`answer` = '') DESC, `id` DESC ");
		
		$query = sql_placeholder('SELECT count(`id`) as count FROM `faqs`');
		$this->db->query($query);
		$pages_num = $this->db->result(); 
		$pages_num = ceil($pages_num->count/$row_at_page);
		
		if($pages_num > 0){
		
			$start_item = ($current_page)*$row_at_page;
			
			$query = sql_placeholder('SELECT `id`, `question`, `visible`, `dat` FROM `faqs` ORDER BY `id` DESC LIMIT ?, ?', $start_item, $row_at_page);
			$this->db->query($query);
			$questions = $this->db->results();
			
			foreach($questions as $key=>$question){
				$questions[$key]->answer_get	= $this->form_get(array('id' => $question->id, 'section'=>'Faq'));
				$questions[$key]->enable_get = $this->form_get(array(($question->visible == 0 ? 'enable' : 'disable') => $question->id));
				$questions[$key]->delete_get	= $this->form_get(array('delete' => $question->id));
			}
			
			$this->smarty->assign('questions', $questions);
			
			$this->pages_navigation->fetch($pages_num);
			$this->smarty->assign('PagesNavigation', $this->pages_navigation->body);
			
		}
		
		$this->title = "Вопрос-ответ";
		$this->body = $this->smarty->fetch('faqs.tpl');
		
	}

}