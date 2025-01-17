<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');

class Brands extends Widget
{

  function Brands(&$parent)
  {
    Widget::Widget($parent);
  }

  function fetch()
  {
    if ($_POST['brand_id']) {
      $brand = $this->db->result("SELECT * FROM brands WHERE brand_id = {$_POST['brand_id']}");

      $show_on_main = isset($_POST['show_on_main']) ? $_POST['show_on_main'] : 0;
      $visibility = isset($_POST['visibility']) ? $_POST['visibility'] : 1;
      $brandwall = isset($_POST['brandwall']) ? $_POST['brandwall'] : 0;
      $bigsize = isset($_POST['bigsize']) ? $_POST['bigsize'] : 0;
      $offline_only = isset($_POST['offline_only']) ? $_POST['offline_only'] : 0;
      $hide_sizes = isset($_POST['hide_sizes']) ? $_POST['hide_sizes'] : 0;
      $show_delta = isset($_POST['show_delta']) ? $_POST['show_delta'] : 0;
      $show_sale_external = isset($_POST['show_sale_external']) ? $_POST['show_sale_external'] : 0;
      $fur_brand = isset($_POST['fur_brand']) ? $_POST['fur_brand'] : 0;
      $title = isset($_POST['title']) ? $_POST['title'] : '';

      if (isset($_POST['position'])) {
        $this->db->query("UPDATE brands SET
          position = '{$_POST['position']}',
          offline_max_sale = {$_POST['offline_max_sale']},
          show_on_main = {$show_on_main},
          visibility = {$visibility},
          show_on_brandwall = {$brandwall},
          bigsize_on_brandwall = {$bigsize},
          offline_only = {$offline_only},
          hide_sizes = {$hide_sizes},
          show_delta = {$show_delta},
          show_sale_external = {$show_sale_external},
          fur_brand = {$fur_brand},
          meta_title = '{$title}'
          WHERE brand_id = {$brand->brand_id}");
      }

      if (isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
        $path_parts = pathinfo($_FILES['image']['name']);
        $uploadfile = $brand->url . "_logo_". time() . "." . strtolower($path_parts['extension']);

        $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brands/' . $uploadfile;

        if (!move_uploaded_file($_FILES['image']['tmp_name'], $full_path)) {
          $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
        }
        else {
          @chmod($full_path, 0644);
          Job::push('S3UploadJob', ['remote_path' => 'files/brands/'.$uploadfile, 'local_path' => $full_path]);
          $this->db->query("UPDATE brands SET image = '{$uploadfile}' WHERE brand_id = {$brand->brand_id}");
        }
      }
    }
    $brands = $this->db->results("SELECT * FROM brands ORDER BY name");

 	  $this->smarty->assign('Brands', $brands);
    $this->smarty->assign('Modernjs', 'true');
    $this->smarty->assign('Lang', $this->lang);
 	  $this->body = $this->smarty->fetch("brands.tpl");
  }
}
