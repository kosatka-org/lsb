<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');

class Banners extends Widget
{

  function Banners(&$parent)
  {
    Widget::Widget($parent);
  }

  function fetch()
  {
    if ($_GET['create_new']) {
      $this->db->query("INSERT INTO banners VALUES ()");
    }

    if ($_GET['delete']) {
      $banner_id = (int) $_GET['delete'];
      $this->db->query("DELETE FROM banners WHERE id = {$banner_id}");
    }

    if ($_POST['banner_id']) {
      $banner = $this->db->result("SELECT * FROM banners WHERE id = {$_POST['banner_id']}");

      $enabled = isset($_POST['enabled']) ? 1 : 0;
      $url = isset($_POST['url']) ? $_POST['url'] : '';
      $title = isset($_POST['title']) ? $_POST['title'] : '';
      $eng_title = isset($_POST['eng_title']) ? $_POST['eng_title'] : '';
      $sex = $_POST['sex'];
      $user_level = isset($_POST['user_level']) ? $_POST['user_level'] : 1;

      if (isset($_POST['position'])) {
        // exit("UPDATE banners SET
        //   position = {$_POST['position']},
        //   enabled = {$enabled},
        //   url = '{$url}',
        //   title = '{$title}',
        //   eng_title = '{$eng_title}',
        //   sex = {$sex},
        //   user_level = {$user_level}
        //   WHERE id = {$banner->id}");
        $this->db->query("UPDATE banners SET
          position = {$_POST['position']},
          enabled = {$enabled},
          url = '{$url}',
          title = '{$title}',
          eng_title = '{$eng_title}',
          sex = {$sex},
          user_level = {$user_level}
          WHERE id = {$banner->id}");
          
        if($banner->title == '' && !empty($title)){
          $t = !empty($url) ? "<{$url}|{$title}>" : $title;
          $m = "Добавлен новый баннер {$t}";
          $channel = "banners_main_page";
          $url = "https://hooks.slack.com/services/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";
          send_to_slack($m, $channel, $url);
        }
      }

      if (isset($_POST['brand_id']) && $_POST['brand_id'] != 0) {
        $this->db->query("UPDATE banners SET brand_id = {$_POST['brand_id']} WHERE id = {$banner->id}");
      }

      if (isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
        $path_parts = pathinfo($_FILES['image']['name']);
        $uploadfile = $banner->id . "_banner_". time() . "." . strtolower($path_parts['extension']);

        $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/banners/' . $uploadfile;

        if (!move_uploaded_file($_FILES['image']['tmp_name'], $full_path)) {
          $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
        }
        else {
          @chmod($full_path, 0644);
          Job::push('S3UploadJob', ['remote_path' => 'files/banners/'.$uploadfile, 'local_path' => $full_path]);
          $this->db->query("UPDATE banners SET image = '{$uploadfile}' WHERE id = {$banner->id}");
        }
      }

      if (isset($_FILES['eng_image']) && !empty($_FILES['eng_image']['tmp_name'])) {
        $path_parts = pathinfo($_FILES['eng_image']['name']);
        $uploadfile = $banner->id . "_eng_banner_". time() . "." . strtolower($path_parts['extension']);

        $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/banners/' . $uploadfile;
        if (!move_uploaded_file($_FILES['eng_image']['tmp_name'], $full_path)) {
          $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
        }
        else {
          @chmod($full_path, 0644);
          Job::push('S3UploadJob', ['remote_path' => 'files/banners/'.$uploadfile, 'local_path' => $full_path]);
          $this->db->query("UPDATE banners SET eng_image = '{$uploadfile}' WHERE id = {$banner->id}");
        }
      }
    }
    $brands = $this->db->results("SELECT * FROM brands ORDER BY name ASC");
    $banners = $this->db->results("SELECT * FROM banners ORDER BY position");

    $this->smarty->assign('Banners', $banners);
 	  $this->smarty->assign('brands', $brands);
    $this->smarty->assign('Modernjs', 'true');
    $this->smarty->assign('Lang', $this->lang);
    $js = $this->smarty->fetch('banners.js.tpl');
    $this->smarty->assign('JavaScript', $js);
 	  $this->body = $this->smarty->fetch("banners.tpl");
  }
}
