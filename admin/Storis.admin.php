<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');

class Storis extends Widget
{
  var $error_msg;
  var $table    = 'colors';
  
  function Stories(&$parent)
  {
    Widget::Widget($parent);
    
  }
  function fetch()
  {
    $this->uploaddir = $_SERVER['DOCUMENT_ROOT'] . '/files/stories/';
    $this->smarty->assign('Modernjs', 'true');
    if (isset($_GET['create_new'])) {
        return $this->show_story();
    }
    if (isset($_GET['save_story'])) {
        return $this->save_story();
    }
    if (isset($_GET['del_story'])) {
        return $this->del_story();
    }
    if (isset($_GET['quick_save'])) {
        return $this->quick_save();
    }
    if (isset($_GET['story']) && isset($_GET['del_pic'])) {
        return $this->del_pic();
    }
    if (isset($_GET['story']) && isset($_GET['del_vid'])) {
        return $this->del_vid();
    }
    if (isset($_GET['story']) && !empty($_GET['story'])) {
        return $this->show_story($_GET['story']);
    }
    $storis = $this->db->results("SELECT * FROM stories WHERE 1 ORDER BY id DESC");
    $this->smarty->assign('Storis', $storis);
    $this->body = $this->smarty->fetch('stories.tpl');
  }
  
  function quick_save() {
    if(empty($_GET['quick_save'])) return false;
    $story_id = $_GET['quick_save'];
    $position = $_GET['position'];
    $enabled = $_GET['enabled'];
    
    $this->db->query("UPDATE stories SET position={$position}, enabled={$enabled} WHERE id = '{$story_id}'");
    die('ok');
  }
  
  function del_story() {
    $story_id = $_GET['del_story'];
    $this->db->query("DELETE FROM stories WHERE id = {$story_id}");
    header('Location: /admin/index.php?section=Storis');
  }
  
  function del_pic() {
    if(empty($_GET['story']) || empty($_GET['del_pic'])) return false;
    $field = $_GET['del_pic'];
    $story_id = $_GET['story'];
    
    $f_name = $this->db->result("SELECT {$field} FROM stories WHERE id = '{$story_id}'")->$field;
    $file = $this->uploaddir.$f_name;
    if (is_file($file)) unlink($file);
    $this->db->query("UPDATE stories SET {$field}='' WHERE id = '{$story_id}'");
    die('ok');
  }
  
  function del_vid() {
    if(empty($_GET['story']) || empty($_GET['del_vid'])) return false;
    $field = $_GET['del_vid'];
    $story_id = $_GET['story'];
    
    $this->db->query("UPDATE stories SET {$field} = '' WHERE id = {$story_id}");
    die('ok');
  }
  
  function show_story($story_id = null) {
    $blocks = array(1=>'',2=>'',3=>'',4=>'',5=>'',6=>'',7=>'',8=>'',9=>'',10=>'');
    if($story_id){
      $story = $this->db->result("SELECT * FROM stories WHERE id = {$story_id}");
      foreach($blocks as $k=>&$b){
        $block = "block_$k";
        if(strpos($story->$block,'_image_') !== false) $b = 'img';
        if(strpos($story->$block,'vimeo') !== false) $b = 'vimeo';
        if(strpos($story->$block,'youtu.be') !== false || strpos($story->$block,'youtube') !== false) $b = 'youtube';
      }
      $this->smarty->assign('story', $story);
    }
    
    $this->smarty->assign('blocks', $blocks);
    $this->smarty->assign('end_date', date('Y-m-d', strtotime("+1 day")));
    $this->title = isset($story->title) ? 'Стори ' . $story->title : 'Новая стори';
    $this->body = $this->smarty->fetch('story_item.tpl');
  }
  
  function save_story() {
    $story_id         = $_POST['story_id'];
    $story->title     = $_POST['title'];
    $story->eng_title = $_POST['eng_title'];
    $story->url       = $_POST['url'];
    $story->position  = $_POST['position'];
    $story->end_date  = $_POST['end_date'];
    $story->enabled   = isset($_POST['enabled']) ? 1 : 0;
    
    if(!empty($story_id)){
      $this->db->query($sql="UPDATE stories SET 
      title     = '{$story->title}',
      eng_title = '{$story->eng_title}',
      url       = '{$story->url}',
      position  = {$story->position},
      enabled   = {$story->enabled},
      end_date  = '{$story->end_date}'
      WHERE id  = {$story_id}");
    }
    else{
      $this->db->query("INSERT INTO stories (title,eng_title,url,position,enabled,create_date) VALUES ('{$story->title}', '{$story->eng_title}', '{$story->url}', {$story->position}, {$story->enabled}, NOW())");
      $story_id = $this->db->insert_id();
    }
    
    foreach($_POST['blocks'] as $k=>$block){
      if(!empty($_FILES["blocks"]['tmp_name'][$k])){
        if (isset($_FILES["blocks"]) && !empty($_FILES["blocks"]['tmp_name'][$k])) {
          $path_parts = pathinfo($_FILES["blocks"]['name'][$k]);
          $uploadfile = $story_id . $k . "_image_". time() . "." . strtolower($path_parts['extension']);

          $full_path = $this->uploaddir . $uploadfile;

          if (!move_uploaded_file($_FILES["blocks"]['tmp_name'][$k], $full_path)) {
            $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
          }
          else {
            @chmod($full_path, 0644);
            //Job::push('S3UploadJob', ['remote_path' => 'files/stories/'.$uploadfile, 'local_path' => $full_path]);
            $this->db->query("UPDATE stories SET block_{$k} = '{$uploadfile}' WHERE id = {$story_id}");
          }
        }
      }
      elseif(!empty($block)){$this->db->query("UPDATE stories SET block_{$k} = '{$block}' WHERE id = {$story_id}");}
    }
    
    
    if (isset($_FILES['banner']) && !empty($_FILES['banner']['tmp_name'])) {
      $path_parts = pathinfo($_FILES['banner']['name']);
      $uploadfile = $story_id . "_banner_image_". time() . "." . strtolower($path_parts['extension']);

      $full_path = $this->uploaddir . $uploadfile;

      if (!move_uploaded_file($_FILES['banner']['tmp_name'], $full_path)) {
        $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
      }
      else {
        @chmod($full_path, 0644);
        //Job::push('S3UploadJob', ['remote_path' => 'files/stories/'.$uploadfile, 'local_path' => $full_path]);
        $this->db->query("UPDATE stories SET banner = '{$uploadfile}' WHERE id = {$story_id}");
      }
    }

    if (isset($_FILES['eng_banner']) && !empty($_FILES['eng_banner']['tmp_name'])) {
      $path_parts = pathinfo($_FILES['eng_banner']['name']);
      $uploadfile = $story_id . "_eng_banner_image_". time() . "." . strtolower($path_parts['extension']);

      $full_path = $this->uploaddir . $uploadfile;
      if (!move_uploaded_file($_FILES['eng_banner']['tmp_name'], $full_path)) {
        $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
      }
      else {
        @chmod($full_path, 0644);
        //Job::push('S3UploadJob', ['remote_path' => 'files/stories/'.$uploadfile, 'local_path' => $full_path]);
        $this->db->query("UPDATE stories SET eng_banner = '{$uploadfile}' WHERE id = {$story_id}");
      }
    }
    header('Location: /admin/index.php?section=Storis&story=' . $story_id);
  }
}

