<?PHP
require_once('Widget.admin.php');
require_once('../models/copywriters.php');
require_once('Storefront.admin.php');

class CopywriterTaskManager extends copywriters
{

	function CopywriterTaskManager(&$parent) {
		Widget::Widget($parent);
	}
	
	function fetch() {
		$task = new stdClass();
	
		if (!empty($_GET['id'])) $id = $_GET['id'];
		if(!empty($_POST['id'])) $id = $_POST['id'];
		$id = intval($id);	
			
		if (!empty($id)) {
			$task = $this->get_copywriter_task($id);
		}
	
		if(!empty($_POST['doc_type'])){
		
			$this->error_msg = NULL;
			$task->doc_type 		= $_POST['doc_type'];
			$task->doc_id 			= $_POST['doc_id'];
			$task->field 			= $_POST['field'];
			$task->task_comment 	= $_POST['task_comment'];
			$task->copywriter_id 	= $_POST['copywriter_id'];
			$task->priority 		= intval($_POST['priority']);	
			
			if (isset($_POST['button'])) {
				if (empty($task->doc_type)) {
					$this->error_msg .= '<li>Выберите тип документа</li>';
				}
				else {
					if (!empty($id)) {
						//Обновляем
						if(!$this->update_copywriter_task($id, array('doc_type'=>$task->doc_type, 'doc_id'=>$task->doc_id, 'field'=>$task->field, 'task_comment'=>$task->task_comment, 'copywriter_id'=>$task->copywriter_id, 'priority'=>$task->priority))){ $this->error_msg .= '<li>Неизвесная ошибка</li>'; }
					}
					else {
						//добавляем нрвое задание
						if(!$id = $this->add_copywriter_task(array('doc_type'=>$task->doc_type, 'doc_id'=>$task->doc_id, 'field'=>$task->field, 'task_comment'=>$task->task_comment, 'copywriter_id'=>$task->copywriter_id, 'priority'=>$task->priority))) { $this->error_msg .= '<li>Неизвесная ошибка</li>'; }
					}
					$task = $this->get_copywriter_task($id);
					
					if(empty($this->error_msg)){
						$get = $this->form_get(array('section'=>'CopywriterTasksManager'));
						header("Location: index.php$get");
					}
				}
			}
			if (!empty($this->error_msg)) $this->smarty->assign('Error', $this->error_msg);
		}

		if ($task->doc_type) {
			$form_data = $this->get_copywriter_task_form($task->doc_type);
			if ($form_data) {
				$this->smarty->assign('docs', 	$form_data['docs']);
				$this->smarty->assign('fields', $form_data['fields']);
			}		
		}

		$copywriters = $this->get_copywriters();
		$this->smarty->assign('copywriters', $copywriters);
		$this->smarty->assign('task', $task);
	
		$this->title = "Интерфейс модератора";
		$this->body = $this->smarty->fetch('CopywriterTaskManager.tpl');
		return true;
	}
}