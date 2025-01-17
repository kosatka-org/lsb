<?PHP
require_once('Widget.admin.php');
require_once('../models/copywriters.php');
require_once('Storefront.admin.php');

class CopywriterStat extends copywriters
{

	function CopywriterStat(&$parent)
	{
		Widget::Widget($parent);
		$this->add_param('status');
	}



	function fetch() {	
	
		$filter['status'] = 'accepted';

		if (!luser::is_allowed_section('CopywriterTaskManager')) { // Если не модератор - то показываем только собственную статистику
			$filter['copywriter_id'] = $_SESSION['user']->user_id;
		}

		$filter['date_start']	= !empty($_POST['date_start'])	? $_POST['date_start']	: date('Y-m-01'); // ПО умолчанию - первый день месяца
		$filter['date_finish']	= !empty($_POST['date_finish']) ? $_POST['date_finish'] : date('Y-m-d'); 
		
		$copywriters = array();
		foreach ($this->get_copywriter_tasks($filter) as $task) {
			if (!isset($copywriters[$task->copywriter_id])) {
				$copywriters[$task->copywriter_id]->text_cont 	= 0;
				$copywriters[$task->copywriter_id]->text_len 	= 0;
			}
			$copywriters[$task->copywriter_id]->text_cont++;
			$text = str_replace(array(' ', '%', ';', ':', '&', '[', ']', '>', '<', ',', '.', '+', '-', '(', ')', '"', "'"), '', strip_tags($task->text));
			$copywriters[$task->copywriter_id]->text_len += mb_strlen($text, 'UTF-8');
		}
		if (!empty($copywriters)) {
			$copywriter_ids = array_keys($copywriters);
			foreach($this->get_copywriters(array('id'=>$copywriter_ids)) as $copywriter){
				if ( $copywriters[$task->copywriter_id]->text_cont > 0 ) {
					$copywriters[$copywriter->user_id]->text_avg = ceil($copywriters[$copywriter->user_id]->text_len / $copywriters[$copywriter->user_id]->text_cont);
				}
				$copywriters[$copywriter->user_id]->copywriter_id 	= $copywriter->user_id;
				$copywriters[$copywriter->user_id]->copywriter_name = $copywriter->name;
				$copywriters[$copywriter->user_id]->amount = ($copywriter->type == 'per_text' ? $copywriters[$copywriter->user_id]->text_cont : ceil($copywriters[$copywriter->user_id]->text_len/1000)) * $copywriter->rate;
				
				$copywriters[$copywriter->user_id]->texts = $this->db->results("SELECT copywriters_tasks.*, products.model AS name FROM copywriters_tasks 
							LEFT JOIN products ON copywriters_tasks.doc_id = products.product_id 
							WHERE copywriter_id = {$copywriter->user_id} AND status='accepted' AND date_write >= '{$filter['date_start']}' AND `date_write` <= '{$filter['date_finish']}'  
							ORDER BY copywriters_tasks.date_write DESC");
				foreach($copywriters[$copywriter->user_id]->texts as $text){
					switch($text->doc_type){
						case 'product':
							$text->link = "section=Product&item_id={$text->doc_id}";
						break;
						case 'category':
							$text->link = "section=Category&item_id={$text->doc_id}";
							$text->name = $this->db->result("SELECT name FROM `categories` WHERE category_id = {$text->doc_id} LIMIT 1;")->name;
						break;
						case 'city':
							$text->link = "section=City&id={$text->doc_id}";
							$text->name = $this->db->result("SELECT name FROM `cities` WHERE id = {$text->doc_id} LIMIT 1;")->name;
						break;
						case 'special':
							$text->link = "section=Special&item_id={$text->doc_id}";
							$text->name = $this->db->result("SELECT name FROM `specials` WHERE special_id = {$text->doc_id} LIMIT 1;")->name;
						break;
						case 'brand':
							$text->link = "section=Brand&item_id={$text->doc_id}";
							$text->name = $this->db->result("SELECT name FROM `brands` WHERE brand_id = {$text->doc_id} LIMIT 1;")->name;
						break;
						case 'brand-category':
							$text->link = "section=Good&id={$text->doc_id}";
							$text->name = $this->db->result("SELECT title FROM `goods` WHERE id = {$text->doc_id} LIMIT 1;")->title;
						break;
					}
				}
			}
			$this->smarty->assign('copywriters', $copywriters);
		}
    $eng_t = $this->db->result("SELECT COUNT(*) AS cont FROM `eng_text_upload` WHERE date BETWEEN '{$filter['date_start']}' AND '{$filter['date_finish']} 23:59:59' ;")->cont;

		$this->smarty->assign('filter', (object)$filter);
		$this->smarty->assign('eng_t', $eng_t);
		
		$this->title = "Кабинет копирайтера: статистика";
		$this->body = $this->smarty->fetch('CopywriterStat.tpl');
		return true;
	}
}