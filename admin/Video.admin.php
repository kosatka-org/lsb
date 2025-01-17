<?PHP
require_once('Widget.admin.php');

class Video extends Widget
{

	function Video(&$parent)
	{
		Widget::Widget($parent);
    $this->prepare();
	}
  function prepare()
	{
		if(isset($_GET['update_video'])){
      foreach($_POST['video'] as $k=>$v){
        $video = $this->db->result("SELECT * FROM adv_video WHERE id = '{$k}';");
        if(!empty($video)){
          $this->db->query("UPDATE adv_video SET video = '{$v}', date = NOW() WHERE id = '{$k}';");
        }
        else{
          $this->db->query("INSERT INTO adv_video ( id, video, date) VALUES ( '{$k}', '{$v}', NOW());");
        }
      }
      header("Location: {$_SERVER["HTTP_REFERER"]}");
		}
  }
	
	function fetch()
	{
		$videos = $this->db->results("SELECT * FROM `adv_video` ORDER BY `id`");
    foreach($videos as $vid){
      preg_match('%(?:youtube(?:-nocookie)?\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/ ]{11})%i', $vid->video, $match);
      $vid->youtube_id = $match[1];
    }
		$this->smarty->assign('videos', $videos);
	
		$this->title = 'Видео ролики';
		$this->body = $this->smarty->fetch('videos.tpl');
	}

}