<?php
require_once('Widget.class.php');
include_once "models/email_template.php";

class Faq extends Widget
{

    function fetch()
    {
    
        $action = $this->param('action');
        
        switch($action){
            case '': $this->body = $this->faqs_get(); break;
            case 'question': $this->body = $this->question_add(); break;
        }
        
        if($this->param('clear')){
            echo $this->body; die();	
        }else{
            return $this->body;
        }
        
    }



    private function question_add() {
        if ($this->settings->theme == 'api' && empty($_POST['question']) && !empty($_REQUEST['question'])){
            $_POST = $_REQUEST;
        }
        if (isset($_POST['question'])) {
            if ($this->settings->theme != 'api' && empty($_POST["g-recaptcha-response"])) {
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Data check error.<br>Are you sure you`re not a robot?<br>';}
                else{$_SESSION['USER_MESSAGE'] = 'Ошибка проверки ввода данных.<br>Вы точно не робот?<br>';}
                header("Location: {$_SERVER["HTTP_REFERER"]}");
                exit();
            }
            if ($this->settings->theme != 'api' && !empty($_POST["g-recaptcha-response"])) {
                $data = array(
                    'secret'   => "6LfDlk4UAAAAALuvyk_3zGJjl3nokrx7rK78La34",
                    'response' => $_POST["g-recaptcha-response"]
                );

                $verify = curl_init();
                curl_setopt($verify, CURLOPT_URL, "https://www.google.com/recaptcha/api/siteverify");
                curl_setopt($verify, CURLOPT_POST, true);
                curl_setopt($verify, CURLOPT_POSTFIELDS, http_build_query($data));
                curl_setopt($verify, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($verify, CURLOPT_RETURNTRANSFER, true);
                $response = curl_exec($verify);

                if ($response ['success'] != true) {
                    if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Data check error.<br>Are you sure you`re not a robot?<br>';}
                    else{$_SESSION['USER_MESSAGE'] = 'Ошибка проверки ввода данных.<br>Вы точно не робот?<br>';}
                    header("Location: {$_SERVER["HTTP_REFERER"]}");
                    exit();
                }
            }
        
            $number 	= $_POST['phone_number'];
            $email  	= $_POST['email'];
            $name  		= $_POST['name']; empty($name) ? 'господин' : $name;
            $question 	= trim($_POST['question']);
            
            if(isset($_POST['contact'])){
                if(ctype_digit($_POST['contact'])){
                    $number = $_POST['contact'];
                    $email  = '';
                }
                else{
                    $email = $_POST['contact'];
                    $number  = '';
                }
                $name = 'господин';
            }
            
            // Проверка возможных ошибок
            $error = null;
            
            // Проверка на правильность заполнения формы
            if(empty($question)){
                $error = "Пожалуйста, введите вопрос";
                if ($this->settings->theme == 'api') {
                    if($this->settings->theme_v == 'v2'){$return->success = false;}
                    $return->message = $error;
                }
            }
            elseif(!preg_match('/^9([0-9]+){9}$/iu', $number) and !preg_match('/^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,6})$/i', $email)){
                $error = "Пожалуйста, введите ваши данные";
                if ($this->settings->theme == 'api') {
                    if($this->settings->theme_v == 'v2'){$return->success = false;}
                    $return->message = $error;
                }
            }
            if(empty($error)){
                $query = sql_placeholder('INSERT INTO `faqs` (`question`, `user_name`, `user_email`, `user_phone`, `dat`) VALUES (?, ?, ?, ?, now())', $question, $name, $email, $number);
                $id = $this->db->insert_id();
                $this->db->query($query);
                
                if(!isset($_POST['test'])){
                    $email_body = "
                        Вопрос: {$question}<br>
                        Телефон: {$number}<br>
                        Почта: {$email}<br>";
                    $this->email('mail@lsboutique.ru', 'Новый вопрос в Faq', $email_body, 'From: Luxury Store <order@lsboutique.ru>');
                }
                if(isset($_POST['test'])){
                    $this->db->query("DELETE FROM `faqs` WHERE question = 'test_question?' AND user_name = 'tester tets';");
                }
                $this->smarty->assign('accepted', true);
                
                if($_COOKIE['language'] == 'eng'){$_SESSION['USER_MESSAGE'] = 'Your question has been received.<br>You will be contacted soon.';}
                else{$_SESSION['USER_MESSAGE'] = 'Ваш вопрос получен.<br>Вам ответят в ближайшее время.';}
                if ($this->settings->theme == 'api') {
                    if($this->settings->theme_v == 'v2'){$return->success = true;}
                    if($_COOKIE['language'] == 'eng'){$return->message = 'Your question has been received. You will be contacted soon.';}
                    else{$return->message = 'Ваш вопрос получен. Вам ответят в ближайшее время.';}
                }
                
            } else {
                $_SESSION['USER_MESSAGE'] = $error;
            }
            if ($this->settings->theme == 'api') {
                if($this->settings->theme_v == 'v2'){
                  $r->obj[0] = $return;
                  $return = $this->format_api_response($r);
                }
                $return = json_encode($return);
                header('Content-Type: application/json');
                echo $return;
                die();
            }
            if ($this->settings->theme == 'mobile') {
                header("Location: /faq");
                die();
            }
            if (!empty($_SERVER["HTTP_REFERER"])) {
                if ( strpos($_SERVER["HTTP_REFERER"], 'ru.lsboutique.ru')) {
                    $_SERVER["HTTP_REFERER"] .= '?sended';
                }
                header("Location: /faq");
                die();
            }
        }
        
        $body = $this->smarty->fetch('faq_question.tpl');
        return $body;
    }



    private function faqs_get(){
    
        $row_at_page 	= 25;
        $current_page 	= max(1, (int)$this->param('page'));
        
        $pages_num = $this->db->result("SELECT count(`id`) as c FROM `faqs` WHERE `visible` = 1 AND `answer` <> '' ")->c;
        $pages_num = ceil($pages_num/$row_at_page);
        
        if ($pages_num > 0) {
            $start_item = ($current_page-1)*$row_at_page;
            //$start_item = min($pages_num-1, $start_item);
            $questions = $this->db->results("SELECT * FROM `faqs` WHERE `visible`=1 AND `answer` <> '' ORDER BY `id` DESC LIMIT {$start_item}, {$row_at_page}");
            
            $this->smarty->assign('questions', $questions);
            $this->smarty->assign('current_page_num', $current_page);
            $this->smarty->assign('total_pages_num', $pages_num);
        }
        
        if ($this->settings->theme == 'api') {
            foreach($questions as $question){
                $question->answer = strip_tags(str_replace('</p>', '\n ', $question->answer));
                unset($question->visible);
            }
            $return->questions = $questions;
            $return->current_page = $current_page;
            $return->pages_num = $pages_num;
            if($this->settings->theme_v == 'v2'){
              $return = $this->format_api_response($return);
            }
            $return = json_encode($return);
            header('Content-Type: application/json');
            echo $return;
        }
        
        if($_COOKIE['language'] == 'eng'){$title = 'Answered questions';}
        else{$title = 'Вопрос-ответ';}
        $this->smarty->assign('title',	$title);
        return $this->smarty->fetch('faq.tpl');
    }
}