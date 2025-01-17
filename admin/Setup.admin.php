<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');


############################################
# Class Setup displays news
############################################
class Setup extends Widget
{
  function Setup(&$parent)
  {
    parent::Widget($parent);
    $this->prepare();
  }

  function prepare()
  {
    if (isset($_POST['code_deploy']) && $_SESSION['user']->group_id == 2) {
      Job::push( 'CodeDeployJob', array() );
      exit("OK");
    }

  	if(isset($_POST['main_section']))
  	{

        if( $_SESSION['user']->original_user_id == 12625)
  	    {
  	      header('Location: http://'.$this->root_url.'/admin/index.php?section=PaymentMethods');
  	      exit();
  	    }
  	    if($_SESSION['user']->group_id != 2 && ($_SESSION['user']->original_user_id != 4877 || $_SESSION['user']->original_user_id != 1330))
  	    {
  	      header('Location: http://'.$this->root_url.'/admin/');
  	      exit();
  	    } 

        ## Site name
  		$site_name = $_POST['site_name'];
  		$query = "update settings set value='$site_name' where name='site_name'";
  		$this->db->query($query);

        ## Company name
  		$company_name = $_POST['company_name'];
  		$query = "update settings set value='$company_name' where name='company_name'";
  		$this->db->query($query);

        ## Admin email
  		$admin_email = $_POST['admin_email'];
  		$query = "update settings set value='$admin_email' where name='admin_email'";
  		$this->db->query($query);

        ## Notify from email
  		$notify_from_email = $_POST['notify_from_email'];
  		$query = "update settings set value='$notify_from_email' where name='notify_from_email'";
  		$this->db->query($query);

  		## Main section
  		$main_section = $_POST['main_section'];
  		$query = "update settings set value='$main_section' where name='main_section'";
  		$this->db->query($query);

  		## Main mobile section
  		$main_mobile_section = $_POST['main_mobile_section'];
  		$query = "update settings set value='$main_mobile_section' where name='main_mobile_section'";
  		$this->db->query($query);

        ## Счетчики
  		$counters = mysql_real_escape_string($_POST['counters']);
  		$query = "update settings set value='$counters' where name='counters'";
  		$this->db->query($query);

        ## Product thumbnail width
   		$product_thumbnail_width = mysql_real_escape_string($_POST['product_thumbnail_width']);
  		$query = "update settings set value='$product_thumbnail_width' where name='product_thumbnail_width'";
  		$this->db->query($query);

        ## Product thumbnail height
   		$product_thumbnail_height = mysql_real_escape_string($_POST['product_thumbnail_height']);
  		$query = "update settings set value='$product_thumbnail_height' where name='product_thumbnail_height'";
  		$this->db->query($query);

        ## Product image width
   		$product_image_width = mysql_real_escape_string($_POST['product_image_width']);
  		$query = "update settings set value='$product_image_width' where name='product_image_width'";
  		$this->db->query($query);

        ## Product image height
   		$product_image_height = mysql_real_escape_string($_POST['product_image_height']);
  		$query = "update settings set value='$product_image_height' where name='product_image_height'";
  		$this->db->query($query);

        ## Product adimage width
   		$product_adimage_width = mysql_real_escape_string($_POST['product_adimage_width']);
  		$query = "update settings set value='$product_adimage_width' where name='product_adimage_width'";
  		$this->db->query($query);

        ## Product adimage height
   		$product_adimage_height = mysql_real_escape_string($_POST['product_adimage_height']);
  		$query = "update settings set value='$product_adimage_height' where name='product_adimage_height'";
  		$this->db->query($query);

        ## Image quality
   		$image_quality = mysql_real_escape_string($_POST['image_quality']);
  		$query = "update settings set value='$image_quality' where name='image_quality'";
  		$this->db->query($query);

        ## Products count per page
   		$products_num = mysql_real_escape_string($_POST['products_num']);
  		$query = "update settings set value='$products_num' where name='products_num'";
  		$this->db->query($query);


        ## Products count per page in admin panel
   		$products_num_admin = mysql_real_escape_string($_POST['products_num_admin']);
  		$query = "update settings set value='$products_num_admin' where name='products_num_admin'";
  		$this->db->query($query);

        ## Products count per page in admin panel
   		if(isset($_POST['meta_autofill']) && $_POST['meta_autofill'] == 1)
   			$meta_autofill = 1;
   		else
   			$meta_autofill = 0;
  		$query = "update settings set value=$meta_autofill where name='meta_autofill'";
  		$this->db->query($query);

        ## Текущий "новый" сезон
      $current_new_season = mysql_real_escape_string($_POST['current_new_season']);
      $query = "update settings set value='$current_new_season' where name='current_new_season'";
      $this->db->query($query);

        ## Предыдущий сезон
      $previous_season = mysql_real_escape_string($_POST['previous_season']);
      $query = "update settings set value='$previous_season' where name='previous_season'";
      $this->db->query($query);
      
        ## Admin
        if(isset($_POST['change_admin_password']) && $_POST['change_admin_password'])
        {
          $login = $_POST['admin_login'];
          $pass = $_POST['admin_password'];
          $cpass = $this->crypt_apr1_md5($pass);
          $passfile = @fopen('./.passwd', 'w');

          if($passfile)
          {
            fwrite($passfile, "$login:$cpass");
            fclose($passfile);
          }
          else
          {
            $this->error_msg = 'Не могу изменть файл <code>admin/.passwd</code>.<br>Проверьте права доступа к этому файлу';
          }
        }

		// Соц сети
		##Google
		$google_login_client_id = mysql_real_escape_string($_POST['google_login_client_id']);
  		$query = "update settings set value='$google_login_client_id' where name='google_login_client_id'";
  		$this->db->query($query);
		$google_login_client_secret = mysql_real_escape_string($_POST['google_login_client_secret']);
  		$query = "update settings set value='$google_login_client_secret' where name='google_login_client_secret'";
  		$this->db->query($query);
		##Yandex
		$yandex_login_client_id = mysql_real_escape_string($_POST['yandex_login_client_id']);
  		$query = "update settings set value='$yandex_login_client_id' where name='yandex_login_client_id'";
  		$this->db->query($query);
		$yandex_login_client_secret = mysql_real_escape_string($_POST['yandex_login_client_secret']);
  		$query = "update settings set value='$yandex_login_client_secret' where name='yandex_login_client_secret'";
  		$this->db->query($query);
		##FB
		$fb_login_client_id = mysql_real_escape_string($_POST['fb_login_client_id']);
  		$query = "update settings set value='$fb_login_client_id' where name='fb_login_client_id'";
  		$this->db->query($query);
		$fb_login_client_secret = mysql_real_escape_string($_POST['fb_login_client_secret']);
  		$query = "update settings set value='$fb_login_client_secret' where name='fb_login_client_secret'";
  		$this->db->query($query);
		##VK
		$vk_login_client_id = mysql_real_escape_string($_POST['vk_login_client_id']);
  		$query = "update settings set value='$vk_login_client_id' where name='vk_login_client_id'";
  		$this->db->query($query);
		$vk_login_client_secret = mysql_real_escape_string($_POST['vk_login_client_secret']);
  		$query = "update settings set value='$vk_login_client_secret' where name='vk_login_client_secret'";
  		$this->db->query($query);
		## ОК
   		$ok_login_client_id = mysql_real_escape_string($_POST['ok_login_client_id']);
  		$query = "update settings set value='$ok_login_client_id' where name='ok_login_client_id'";
  		$this->db->query($query);
		$ok_login_public_key = mysql_real_escape_string($_POST['ok_login_public_key']);
  		$query = "update settings set value='$ok_login_public_key' where name='ok_login_public_key'";
  		$this->db->query($query);
		$ok_login_client_secret = mysql_real_escape_string($_POST['ok_login_client_secret']);
  		$query = "update settings set value='$ok_login_client_secret' where name='ok_login_client_secret'";
  		$this->db->query($query);
		## Mail
   		$mail_login_client_id = mysql_real_escape_string($_POST['mail_login_client_id']);
  		$query = "update settings set value='$mail_login_client_id' where name='mail_login_client_id'";
  		$this->db->query($query);
		$mail_login_private_key = mysql_real_escape_string($_POST['mail_login_private_key']);
  		$query = "update settings set value='$mail_login_private_key' where name='mail_login_private_key'";
  		$this->db->query($query);
		$mail_login_client_secret = mysql_real_escape_string($_POST['mail_login_client_secret']);
  		$query = "update settings set value='$mail_login_client_secret' where name='mail_login_client_secret'";
  		$this->db->query($query);
		## RFI
		$rfi_login_id = mysql_real_escape_string($_POST['rfi_login_id']);
  		$query = "update settings set value='$rfi_login_id' where name='rfi_active'";
  		$this->db->query($query);

  		if(empty($this->error_msg))
  		{
 		  header("Location: index.php?section=Setup");
 		}
 	}

  }

  function fetch()
  {
    $this->title = $this->lang->SETTINGS;
    $query = 'SELECT * FROM sections WHERE menu_id is not null ORDER BY name';
    $this->db->query($query);
    $sections = $this->db->results();

	$rfi_ids = $this->db->results("SELECT value, SUBSTRING(name, -1) AS login_id FROM settings WHERE name LIKE 'rfi_ip_%' ORDER BY login_id");
	$rfi_active = $this->db->result("SELECT value FROM settings WHERE name = 'rfi_active'")->value;

  	$this->smarty->assign('Settings', $this->settings);
  	$this->smarty->assign('Sections', $sections);
	$this->smarty->assign('rfi_ids', $rfi_ids);
	$this->smarty->assign('rfi_active', $rfi_active);
  	$this->smarty->assign('Lang', $this->lang);
  	$this->smarty->assign('Error', $this->error_msg);
 	$this->body = $this->smarty->fetch('setup.tpl');
  }

  function upload_file($file, $name)
  {
  	if (!move_uploaded_file($file['tmp_name'], $name))
		$this->error_msg = $this->lang->UPLOAD_FILE_ERROR;
  }

  function crypt_apr1_md5($plainpasswd) {
    $salt = substr(str_shuffle("abcdefghijklmnopqrstuvwxyz0123456789"), 0, 8);
    $len = strlen($plainpasswd);
    $text = $plainpasswd.'$apr1$'.$salt;
    $bin = pack("H32", md5($plainpasswd.$salt.$plainpasswd));
    for($i = $len; $i > 0; $i -= 16) { $text .= substr($bin, 0, min(16, $i)); }
    for($i = $len; $i > 0; $i >>= 1) { $text .= ($i & 1) ? chr(0) : $plainpasswd{0}; }
    $bin = pack("H32", md5($text));
    for($i = 0; $i < 1000; $i++) {
        $new = ($i & 1) ? $plainpasswd : $bin;
        if ($i % 3) $new .= $salt;
        if ($i % 7) $new .= $plainpasswd;
        $new .= ($i & 1) ? $bin : $plainpasswd;
        $bin = pack("H32", md5($new));
    }
    for ($i = 0; $i < 5; $i++) {
        $k = $i + 6;
        $j = $i + 12;
        if ($j == 16) $j = 5;
        $tmp = $bin[$i].$bin[$k].$bin[$j].$tmp;
    }
    $tmp = chr(0).chr(0).$bin[11].$tmp;
    $tmp = strtr(strrev(substr(base64_encode($tmp), 2)),
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
    "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
    return "$"."apr1"."$".$salt."$".$tmp;
  }

}
