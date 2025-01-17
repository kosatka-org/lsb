<?PHP
require_once('Widget.admin.php');
require_once('../models/copywriters.php');
require_once('Storefront.admin.php');


class CopywriterTasksManager extends copywriters {

    function CopywriterTasksManager(&$parent) {
        Widget::Widget($parent);
        $this->add_param('status');
    }

    function fetch() {
        if (isset($_GET['action'])) {
            switch($_GET['action']) {
                case 'delete':
                    $this->check_token();
                    $id = intval($_GET['id']);
                    $this->delete_copywriter_task($id);
                break;

            }
        }

        if (isset($_POST['task_id'])) {
            $task_id    = intval($_POST['task_id']);
            $task       = $this->get_copywriter_task($task_id);

            if ($task->status == 'need_check') {
                $_task->moderator_id    = $_SESSION['user']->user_id;
                $_task->data_check      = date('Y-m-d H:i:s');
                if (isset($_POST['declined'])) {
                    $_task->status          = 'declined';
                    $_task->decline_reason  = $_POST['decline_reason'];
                }
                elseif (isset($_POST['accepted']) || isset($_POST["save_accepted"])) {
                    $_task->status = 'accepted';
                    $_task->decline_reason = NULL;
                    $task->text = $_task->text = $_POST["edit_reason"];

                    $query = NULL;
                    switch($task->doc_type){
                        case 'product':
                            $query  = sql_placeholder('UPDATE `products` SET `'.$task->field.'` = ? WHERE `product_id` = ?', $task->text, $task->doc_id);
                            $link = "section=Product&item_id={$task->doc_id}";
                        break;
                        case 'category':
                            $query  = sql_placeholder('UPDATE `categories` SET `'.$task->field.'` = ? WHERE `category_id` = ?', $task->text, $task->doc_id);
                            $link = "section=Category&item_id={$task->doc_id}";
                        break;
                        case 'city':
                            $query  = sql_placeholder('UPDATE `cities` SET `'.$task->field.'` = ? WHERE `id` = ?', $task->text, $task->doc_id);
                            $link = "section=City&id={$task->doc_id}";
                        break;
                        case 'special':
                            $query  = sql_placeholder('UPDATE `specials` SET `'.$task->field.'` = ? WHERE `special_id` = ?', $task->text, $task->doc_id);
                            $link = "section=Special&item_id={$task->doc_id}";
                        break;
                        case 'brand':
                            $query  = sql_placeholder('UPDATE `brands` SET `'.$task->field.'` = ? WHERE `brand_id` = ?', $task->text, $task->doc_id);
                            $link = "section=Brand&item_id={$task->doc_id}";
                        break;
                        case 'brand-category':
                            $query  = sql_placeholder('UPDATE `goods` SET `'.$task->field.'` = ? WHERE `id` = ?', $task->text, $task->doc_id);
                            $link = "section=Good&id={$task->doc_id}";
                        break;
                    }
                    if ( !empty($query) ) {
                        $this->db->query($query);
                        // Отправляем в слак
                        $message = "Одобрен текст для <https://lsboutique.ru/admin/index.php?{$link}|ID#{$task->doc_id}> администратором {$_SESSION['user']->name}";
                        $args = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "texts_progress" );
                        Job::push('SlackJob', $args);
                        //дублируем в другую команду
                        $channel = "texts_progress";
                        $url = "https://hooks.slack.com/services/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";
                        send_to_slack($message, $channel, $url);
                    }
                }
                $this->update_copywriter_task($task_id, $_task);

            }
            if(isset($_GET['ajax_form'])){
                die();
            }
        }

        $status = $this->param('status');
        $this->smarty->assign('status', $status);

        $filter = array();

        switch ($status) {
            case 'finished':
                $filter['status'] = 'accepted';
            break;
            case 'failed':
                $filter['status'] = 'declined';
            break;
            case 'need_check':
                $filter['status'] = 'need_check';
            break;
            case 'new':
                $filter['status'] = 'new';
            break;
            default:
                $filter['status'] = 'need_check';
            break;
        }

        $filter['date_start']   = !empty($_POST['date_start'])  ? $_POST['date_start']  : date('Y-m-d', time() - 60*60*24*31);
        $filter['date_finish']  = !empty($_POST['date_finish']) ? $_POST['date_finish'] : date('Y-m-d');
        if (!empty($_POST['copywriter_id'])) {
            $filter['copywriter_id'] = (int)$_POST['copywriter_id'];
        }
        $filter['limit'] = 30;

        $tasks  = $this->get_copywriter_tasks($filter);
        $fields = array();
        foreach($tasks as &$task) {
            if ($task->status == 'new') {
                $task->delete_get = $this->form_get(array('action'=>'delete', 'id'=>$task->id));
            }
            if ( empty($fields[$task->doc_type]) ) {
                $form_data = $this->get_copywriter_task_form($task->doc_type, false);
                $fields[$task->doc_type] = $form_data['fields'];
            }
            $task->check2write = date( 'd', time() - strtotime($task->date_write));
            $task->data_check  = date( 'd M', strtotime($task->data_check));
            $task->field       = $fields[$task->doc_type][$task->field];


/*            if ($task->doc_type == 'product') {
                if(!empty($task->doc_id)){
                    $task->prod_pic = $this->db->result("SELECT large_image FROM `products` WHERE product_id = {$task->doc_id}")->large_image;
                }
            }*/
        }
        $this->smarty->assign('tasks', $tasks);

        #Счетчики
        $task_counters->new         = $this->count_copywriter_tasks(array('status'=>'new'));
        $task_counters->need_check  = $this->count_copywriter_tasks(array('status'=>'need_check'));
        $task_counters->failed      = $this->count_copywriter_tasks(array('status'=>'declined'));
        $task_counters->finished    = $this->count_copywriter_tasks(array('status'=>'accepted'));
        $this->smarty->assign('task_counters', $task_counters);

        #Копирайтеры
        $copywriters = $this->get_copywriters();
        $this->smarty->assign('copywriters', $copywriters);

        #Фильтр
        $this->smarty->assign('filter', (object)$filter);

        $this->title = "Интерфейс модератора";
        $this->body = $this->smarty->fetch('CopywriterTasksManager.tpl');
        return true;
    }
}