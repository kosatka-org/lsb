<?PHP
require_once('Widget.admin.php');
require_once('../models/copywriters.php');
require_once('Storefront.admin.php');

class CopywriterTasks extends copywriters {
	function CopywriterTasks(&$parent) {
		Widget::Widget($parent);
		$this->add_param('status');
	}
	
	function fetch() {
	
		$status = $this->param('status');
		$this->smarty->assign('status', $status);
		
		$filter = array();
		
		switch($status){
		
			case 'finished':
				$filter['copywriter_id'] = $_SESSION['user']->user_id;
				$filter['status'] = 'accepted';
			break;
			case 'failed':
				$filter['copywriter_id'] = $_SESSION['user']->user_id;
				$filter['status'] = 'declined';
			break;
			case 'need_check':
				$filter['copywriter_id'] = $_SESSION['user']->user_id;
				$filter['status'] = 'need_check';
			break;
			default:
				$filter['copywriter_id'] = array($_SESSION['user']->user_id, 0);
				$filter['status'] = 'new';
			break;
		
		}
		
		$filter['date_start']	= !empty($_POST['date_start'])  ? $_POST['date_start']  : date('Y-m-d', time() - 60*60*24*31);
		$filter['date_finish']	= !empty($_POST['date_finish']) ? $_POST['date_finish'] : date('Y-m-d');
		
		#Задания
		$tasks = $this->get_copywriter_tasks($filter);		
		$fields = array();
		foreach($tasks as &$task) {
			if ($task->status == 'new') {
				$task->delete_get = $this->form_get(array('action'=>'delete', 'id'=>$task->id));
			}
			if ( empty($fields[$task->doc_type]) ) {
				$form_data = $this->get_copywriter_task_form($task->doc_type, false);
				$fields[$task->doc_type] = $form_data['fields'];
			}
			$task->data_check = date( 'd M', strtotime($task->data_check));
			$task->date_write = date( 'd M', strtotime($task->date_write));
			$task->field	  = $fields[$task->doc_type][$task->field];
		}
		$this->smarty->assign('tasks', $tasks);

		#Счетчики
		$task_counters->new 		= $this->count_copywriter_tasks(array('copywriter_id'=>array($_SESSION['user']->user_id, 0), 'status'=>'new'));
		$task_counters->need_check 	= $this->count_copywriter_tasks(array('copywriter_id'=>$_SESSION['user']->user_id, 'status'=>'need_check'));
		$task_counters->failed 		= $this->count_copywriter_tasks(array('copywriter_id'=>$_SESSION['user']->user_id, 'status'=>'declined'));
		$task_counters->finished 	= $this->count_copywriter_tasks(array('copywriter_id'=>$_SESSION['user']->user_id, 'status'=>'accepted'));
		$this->smarty->assign('task_counters', $task_counters);
		
		#Фильтр
		$this->smarty->assign('filter', (object)$filter);

	
		$this->title = "Кабинет копирайтера: задачи";
		$this->body = $this->smarty->fetch('CopywriterTasks.tpl');
		return true;
	}	
	
}