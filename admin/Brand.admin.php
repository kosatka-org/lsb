<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# EditBrand
############################################
class Brand extends Widget {
  var $brand;
  var $uploaddir = '';
  var $copywriter_fields = array('title_descr', 'video', 'description', 'description_m', 'description_w', 'description_looks', 'text1', 'text2', 'text4', 'text38', 'text1_1', 'text2_1', 'text4_1', 'text38_1', 'text1_2', 'text2_2', 'text4_2', 'text38_2');



  function Brand(&$parent) {
    Widget::Widget($parent);
    $this->prepare();
  }



  function prepare() {
    $this->copywriters = new copywriters();
    $is_copywriter = $this->copywriters->get_copywriter($_SESSION['user']->user_id) ? true : false;
    $this->smarty->assign('is_copywriter', $is_copywriter);

    $this->uploaddir 		= $_SERVER['DOCUMENT_ROOT'] . '/files/brands/';
    $this->brand->brand_id 	= $this->param('item_id') ? $this->param('item_id') : '';

    if ( !empty($this->brand->brand_id) && $is_copywriter ) {
      $this->prepare_copywriter_tasks( 'brand', $this->brand->brand_id );
    }

    if (isset($_POST['name'])) {
      $this->check_token();

      $this->brand->name                  = strip_tags($_POST['name']);
      $this->brand->url                   = strip_tags($_POST['url']);
      $this->brand->gender                = isset($_POST['sex']) ? (int)$_POST['sex'] : 0;
      $this->brand->low_discount          = isset($_POST['low_discount']) ? 1 : 0;
      $this->brand->meta_title            = strip_tags($_POST['meta_title']);
      $this->brand->meta_keywords         = strip_tags($_POST['meta_keywords']);
      $this->brand->meta_description      = strip_tags($_POST['meta_description']);
      $this->brand->title_descr           = strip_tags($_POST['title_descr']);
      $this->brand->video                 = strip_tags($_POST['video']);
      $this->brand->description           = strip_custom_tags($_POST['description']);
      $this->brand->eng_description       = strip_custom_tags($_POST['eng_description']);
      $this->brand->description_m         = strip_custom_tags($_POST['description_m']);
      $this->brand->eng_description_m     = strip_custom_tags($_POST['eng_description_m']);
      $this->brand->description_w         = strip_custom_tags($_POST['description_w']);
      $this->brand->eng_description_w     = strip_custom_tags($_POST['eng_description_w']);
      $this->brand->description_looks     = strip_custom_tags($_POST['description_looks']);
      $this->brand->eng_description_looks = strip_custom_tags($_POST['eng_description_looks']);
      $this->brand->text1		              = strip_custom_tags($_POST['text1']);
      $this->brand->text2		              = strip_custom_tags($_POST['text2']);
      $this->brand->text4		              = strip_custom_tags($_POST['text4']);
      $this->brand->text38		            = strip_custom_tags($_POST['text38']);
      $this->brand->eng_text1		          = strip_custom_tags($_POST['eng_text1']);
      $this->brand->eng_text2		          = strip_custom_tags($_POST['eng_text2']);
      $this->brand->eng_text4		          = strip_custom_tags($_POST['eng_text4']);
      $this->brand->eng_text38		        = strip_custom_tags($_POST['eng_text38']);
      $this->brand->text1_1	              = strip_custom_tags($_POST['text1_1']);
      $this->brand->text2_1		            = strip_custom_tags($_POST['text2_1']);
      $this->brand->text4_1		            = strip_custom_tags($_POST['text4_1']);
      $this->brand->text38_1		          = strip_custom_tags($_POST['text38_1']);
      $this->brand->eng_text1_1	          = strip_custom_tags($_POST['eng_text1_1']);
      $this->brand->eng_text2_1		        = strip_custom_tags($_POST['eng_text2_1']);
      $this->brand->eng_text4_1		        = strip_custom_tags($_POST['eng_text4_1']);
      $this->brand->eng_text38_1		      = strip_custom_tags($_POST['eng_text38_1']);
      $this->brand->text1_2		            = strip_custom_tags($_POST['text1_2']);
      $this->brand->text2_2		            = strip_custom_tags($_POST['text2_2']);
      $this->brand->text4_2		            = strip_custom_tags($_POST['text4_2']);
      $this->brand->text38_2		          = strip_custom_tags($_POST['text38_2']);
      $this->brand->eng_text1_2		        = strip_custom_tags($_POST['eng_text1_2']);
      $this->brand->eng_text2_2		        = strip_custom_tags($_POST['eng_text2_2']);
      $this->brand->eng_text4_2		        = strip_custom_tags($_POST['eng_text4_2']);
      $this->brand->eng_text38_2		      = strip_custom_tags($_POST['eng_text38_2']);

      $ch_b = $this->db->result("SELECT * FROM brands WHERE brand_id = {$this->brand->brand_id}");
      if (($_POST['eng_description'] && empty($ch_b->eng_description)) || ($_POST['eng_description_m'] && empty($ch_b->eng_description_m)) || ($_POST['eng_description_w'] && empty($ch_b->eng_description_w)) || ($_POST['eng_description_looks'] && empty($ch_b->eng_description_looks)) ||
          ($_POST['eng_text1'] && empty($ch_b->eng_text1)) || ($_POST['eng_text2'] && empty($ch_b->eng_text2)) || ($_POST['eng_text4'] && empty($ch_b->eng_text4)) || ($_POST['eng_text38'] && empty($ch_b->eng_text38)) ||
          ($_POST['eng_text1_1'] && empty($ch_b->eng_text1_1)) || ($_POST['eng_text2_1'] && empty($ch_b->eng_text2_1)) || ($_POST['eng_text4_1'] && empty($ch_b->eng_text4_1)) || ($_POST['eng_text38_1'] && empty($ch_b->eng_text38_1)) ||
          ($_POST['eng_text1_2'] && empty($ch_b->eng_text1_2)) || ($_POST['eng_text2_2'] && empty($ch_b->eng_text2_2)) || ($_POST['eng_text4_2'] && empty($ch_b->eng_text4_2)) || ($_POST['eng_text38_2'] && empty($ch_b->eng_text38_2))
      ) {
        if ($_POST['eng_description'] && empty($ch_b->eng_description)) $types[] = 'eng_description';
        if ($_POST['eng_body'] && empty($ch_b->eng_body)) $types[] = 'eng_body';
        if ($_POST['eng_text_sizes'] && empty($ch_b->eng_text_sizes)) $types[] = 'eng_text_sizes';
        if ($_POST['eng_uhod'] && empty($ch_b->eng_uhod)) $types[] = 'eng_uhod';
        if ($_POST['eng_text1'] && empty($ch_b->eng_text1)) $types[] = 'eng_text1';
        if ($_POST['eng_text2'] && empty($ch_b->eng_text2)) $types[] = 'eng_text2';
        if ($_POST['eng_text4'] && empty($ch_b->eng_text4)) $types[] = 'eng_text4';
        if ($_POST['eng_text38'] && empty($ch_b->eng_text38)) $types[] = 'eng_text38';
        if ($_POST['eng_text1_1'] && empty($ch_b->eng_text1_1)) $types[] = 'eng_text1_1';
        if ($_POST['eng_text2_1'] && empty($ch_b->eng_text2_1)) $types[] = 'eng_text2_1';
        if ($_POST['eng_text4_1'] && empty($ch_b->eng_text4_1)) $types[] = 'eng_text4_1';
        if ($_POST['eng_text38_1'] && empty($ch_b->eng_text38_1)) $types[] = 'eng_text38_1';
        if ($_POST['eng_text1_2'] && empty($ch_b->eng_text1_2)) $types[] = 'eng_text1_2';
        if ($_POST['eng_text2_2'] && empty($ch_b->eng_text2_2)) $types[] = 'eng_text2_2';
        if ($_POST['eng_text4_2'] && empty($ch_b->eng_text4_2)) $types[] = 'eng_text4_2';
        if ($_POST['eng_text38_2'] && empty($ch_b->eng_text38_2)) $types[] = 'eng_text38_2';
        foreach($types as $type){
          $check = $this->db->result("SELECT * FROM eng_text_upload WHERE brand_id = {$this->brand->brand_id} AND type = '{$type}' AND `group` = 'brand'");
          if(empty($check)) $this->db->query("INSERT INTO eng_text_upload(`brand_id`,`type`,`group`,`date`) VALUES({$this->brand->brand_id},'{$type}','brand',NOW())");
        }
      }

      ## Не допустить одинаковые URL брендов.
      $res = $this->db->result(sql_placeholder('select count(*) as count from brands where url=? and brand_id!=?', $this->brand->url, $this->brand->brand_id));

      if (empty($this->brand->name)) {
        $this->error_msg = $this->lang->ENTER_NAME;
      }
      elseif ($res->count>0) {
        $this->error_msg = 'Бренд с таким URL уже существует. Выберите другой URL.';
      }
      else {
        if (!empty($this->brand->brand_id)) {
          $brand_id = $this->brand->brand_id;
          if (empty($this->brand->url)) {
            $this->brand->url = $brand_id;
          }

          //Копирайтер
          if ($is_copywriter == true) {
            $brand_old = $this->db->result(sql_placeholder('SELECT * FROM brands WHERE brand_id=?', $this->brand->brand_id));
            $this->process_copywriter_tasks( 'brand', $this->brand->brand_id, $this->brand, $brand_old );
          }
          //Копирайтер (The End)

          $query = sql_placeholder('UPDATE brands
                                SET name=?, url=?, gender=?, low_discount=?, meta_title=?, meta_keywords=?, meta_description=?, title_descr=?, video=?, description=?, eng_description=?, description_m=?, eng_description_m=?, description_w=?, eng_description_w=?, description_looks=?, eng_description_looks=?, text1=?, text2=?, text4=?, text38=?, eng_text1=?, eng_text2=?, eng_text4=?, eng_text38=?, text1_1=?, text2_1=?, text4_1=?, text38_1=?, eng_text1_1=?, eng_text2_1=?, eng_text4_1=?, eng_text38_1=?, text1_2=?, text2_2=?, text4_2=?, text38_2=?, eng_text1_2=?, eng_text2_2=?, eng_text4_2=?, eng_text38_2=?, text_modified=NOW()
                                WHERE brand_id=?',
                                $this->brand->name,
                                $this->brand->url,
                                $this->brand->gender,
                                $this->brand->low_discount,
                                $this->brand->meta_title,
                                $this->brand->meta_keywords,
                                $this->brand->meta_description,
                                $this->brand->title_descr,
                                $this->brand->video,
                                $this->brand->description,
                                $this->brand->eng_description,
                                $this->brand->description_m,
                                $this->brand->eng_description_m,
                                $this->brand->description_w,
                                $this->brand->eng_description_w,
                                $this->brand->description_looks,
                                $this->brand->eng_description_looks,
                                $this->brand->text1,
                                $this->brand->text2,
                                $this->brand->text4,
                                $this->brand->text38,
                                $this->brand->eng_text1,
                                $this->brand->eng_text2,
                                $this->brand->eng_text4,
                                $this->brand->eng_text38,
                                $this->brand->text1_1,
                                $this->brand->text2_1,
                                $this->brand->text4_1,
                                $this->brand->text38_1,
                                $this->brand->eng_text1_1,
                                $this->brand->eng_text2_1,
                                $this->brand->eng_text4_1,
                                $this->brand->eng_text38_1,
                                $this->brand->text1_2,
                                $this->brand->text2_2,
                                $this->brand->text4_2,
                                $this->brand->text38_2,
                                $this->brand->eng_text1_2,
                                $this->brand->eng_text2_2,
                                $this->brand->eng_text4_2,
                                $this->brand->eng_text38_2,
                                $this->brand->brand_id);
          $this->db->query($query);
        }
        else {
          $query = sql_placeholder('INSERT INTO brands (name, url, gender, meta_title, meta_keywords, meta_description, title_descr, video, description, eng_description) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                    $this->brand->name,
                                    $this->brand->url,
                                    $this->brand->gender,
                                    $this->brand->meta_title,
                                    $this->brand->meta_keywords,
                                    $this->brand->meta_description,
                                    $this->brand->title_descr,
                                    $this->brand->video,
                                    $this->brand->description,
                                    $this->brand->eng_description
                                 );
          $this->db->query($query);
          $brand_id = $last_insert_id = $this->db->insert_id();
          if (empty($this->brand->url)) $this->brand->url = $brand_id;
        }
        $brand = $this->db->result("SELECT * FROM brands WHERE brand_id = '{$brand_id}'");

        $this->ping('/brands/' . $this->brand->url . '/');

        if (!empty($brand_id) && isset($_POST['delete_image']) && $_POST['delete_image']==1) {
            $file = $this->uploaddir.$brand->image;
          if (is_file($file)) {
            unlink($file);
            }
            $this->db->query("UPDATE brands SET image='' WHERE brand_id = '{$brand_id}'");
        }

        if (!empty($brand_id) && isset($_POST['delete_api_image']) && $_POST['delete_api_image']==1) {
          $file = $this->db->result("SELECT app_image FROM brands WHERE brand_id={$brand_id}");
          if (!empty($file->app_image)){
            $file = '../images/loggoss/'.$file->app_image;
            if (is_file($file)) {unlink($file);}
          }
        }

        if (!empty($brand_id) && isset($_POST['delete_banner_m']) && $_POST['delete_banner_m']==1) {
            $this->db->query("UPDATE brands SET banner_m='' WHERE brand_id = '{$brand_id}'");
        }
        if (!empty($brand_id) && isset($_POST['delete_banner_w']) && $_POST['delete_banner_w']==1) {
            $this->db->query("UPDATE brands SET banner_w='' WHERE brand_id = '{$brand_id}'");
        }
        if (!empty($brand_id) && isset($_POST['delete_banner_m_eng']) && $_POST['delete_banner_m_eng']==1) {
            $this->db->query("UPDATE brands SET banner_m_eng='' WHERE brand_id = '{$brand_id}'");
        }
        if (!empty($brand_id) && isset($_POST['delete_banner_w_eng']) && $_POST['delete_banner_w_eng']==1) {
            $this->db->query("UPDATE brands SET banner_w_eng='' WHERE brand_id = '{$brand_id}'");
        }
        if (!empty($brand_id) && isset($_POST['delete_banner_m_r']) && $_POST['delete_banner_m_r']==1) {
            $this->db->query("UPDATE brands SET banner_m_r='' WHERE brand_id = '{$brand_id}'");
        }
        if (!empty($brand_id) && isset($_POST['delete_banner_w_r']) && $_POST['delete_banner_w_r']==1) {
            $this->db->query("UPDATE brands SET banner_w_r='' WHERE brand_id = '{$brand_id}'");
        }
        if (!empty($brand_id) && isset($_POST['delete_banner_m_eng_r']) && $_POST['delete_banner_m_eng_r']==1) {
            $this->db->query("UPDATE brands SET banner_m_eng_r='' WHERE brand_id = '{$brand_id}'");
        }
        if (!empty($brand_id) && isset($_POST['delete_banner_w_eng_r']) && $_POST['delete_banner_w_eng_r']==1) {
            $this->db->query("UPDATE brands SET banner_w_eng_r='' WHERE brand_id = '{$brand_id}'");
        }

        if (!empty($brand_id)) {
          $uploadfile = $brand_id.".jpg";
          // Баннер мужской
          if (isset($_FILES['banner_m']) && !empty($_FILES['banner_m']['tmp_name'])) {
            $path_parts = pathinfo($_FILES['banner_m']['name']);
            $uploadfile = $brand->url . "_banner_m_". time() . "." . strtolower($path_parts['extension']);

            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_m']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_m='{$uploadfile}', banner_m_modified = NOW() WHERE brand_id='{$brand_id}'");
            }
          }

          // Баннер женский
          if (isset($_FILES['banner_w']) && !empty($_FILES['banner_w']['tmp_name'])) {

            $path_parts = pathinfo($_FILES['banner_w']['name']);
            $uploadfile = $brand->url . "_banner_w_". time() . "." . strtolower($path_parts['extension']);
            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_w']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_w='$uploadfile', banner_w_modified = NOW() WHERE brand_id='$brand_id'");
            }
          }

          // Баннер мужской англ
          if (isset($_FILES['banner_m_eng']) && !empty($_FILES['banner_m_eng']['tmp_name'])) {
            $path_parts = pathinfo($_FILES['banner_m_eng']['name']);
            $uploadfile = $brand->url . "_banner_m_eng_". time() . "." . strtolower($path_parts['extension']);

            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_m_eng']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_m_eng='{$uploadfile}' WHERE brand_id='{$brand_id}'");
            }
          }

          // Баннер женский англ
          if (isset($_FILES['banner_w_eng']) && !empty($_FILES['banner_w_eng']['tmp_name'])) {

            $path_parts = pathinfo($_FILES['banner_w_eng']['name']);
            $uploadfile = $brand->url . "_banner_w_eng_". time() . "." . strtolower($path_parts['extension']);
            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_w_eng']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_w_eng='{$uploadfile}' WHERE brand_id='{$brand_id}'");
            }
          }

          // Баннер мужской(текст справа)
          if (isset($_FILES['banner_m_r']) && !empty($_FILES['banner_m_r']['tmp_name'])) {
            $path_parts = pathinfo($_FILES['banner_m_r']['name']);
            $uploadfile = $brand->url . "_banner_m_r_". time() . "." . strtolower($path_parts['extension']);

            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_m_r']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_m_r='{$uploadfile}', banner_m_modified = NOW() WHERE brand_id='{$brand_id}'");
            }
          }

          // Баннер женский(текст справа)
          if (isset($_FILES['banner_w_r']) && !empty($_FILES['banner_w_r']['tmp_name'])) {

            $path_parts = pathinfo($_FILES['banner_w_r']['name']);
            $uploadfile = $brand->url . "_banner_w_r_". time() . "." . strtolower($path_parts['extension']);
            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_w_r']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_w_r='$uploadfile', banner_w_modified = NOW() WHERE brand_id='$brand_id'");
            }
          }

          // Баннер мужской англ(текст справа)
          if (isset($_FILES['banner_m_eng_r']) && !empty($_FILES['banner_m_eng_r']['tmp_name'])) {
            $path_parts = pathinfo($_FILES['banner_m_eng_r']['name']);
            $uploadfile = $brand->url . "_banner_m_eng_r_". time() . "." . strtolower($path_parts['extension']);

            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_m_eng_r']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_m_eng_r='{$uploadfile}' WHERE brand_id='{$brand_id}'");
            }
          }

          // Баннер женский англ(текст справа)
          if (isset($_FILES['banner_w_eng_r']) && !empty($_FILES['banner_w_eng_r']['tmp_name'])) {

            $path_parts = pathinfo($_FILES['banner_w_eng_r']['name']);
            $uploadfile = $brand->url . "_banner_w_eng_r_". time() . "." . strtolower($path_parts['extension']);
            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brand_banners/' . $uploadfile;

            if (!move_uploaded_file($_FILES['banner_w_eng_r']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brand_banners/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET banner_w_eng_r='{$uploadfile}' WHERE brand_id='{$brand_id}'");
            }
          }

          if (isset($_FILES['api_image']) && !empty($_FILES['api_image']['tmp_name'])) {
            $path_parts = pathinfo($_FILES['api_image']['name']);
            $uploadfile = 'app_' . $brand_id . '_' . time() . '.' . strtolower($path_parts['extension']);
            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/images/loggoss/' . $uploadfile;
            $file = $this->db->result("SELECT app_image FROM brands WHERE brand_id={$brand_id}");
            if (!empty($file->app_image)){
              $file = '../images/loggoss/'.$file->app_image;
              if (is_file($file)) {unlink($file);}
            }
            if (!move_uploaded_file($_FILES['api_image']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/loggoss/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET app_image='$uploadfile' WHERE brand_id='$brand_id';");
            }
          }

          if (isset($_FILES['image']) && !empty($_FILES['image']['tmp_name'])) {
            $path_parts = pathinfo($_FILES['image']['name']);
            $uploadfile = $brand_id . '_' . time() . "." . strtolower($path_parts['extension']);
            $full_path = $_SERVER['DOCUMENT_ROOT'] . '/files/brands/' . $uploadfile;
            if (!move_uploaded_file($_FILES['image']['tmp_name'], $full_path)) {
              $this->error_msg = $this->lang->FILE_UPLOAD_ERROR;
            }
            else {
              @chmod($full_path, 0644);
              Job::push('S3UploadJob', ['remote_path' => 'files/brands/'.$uploadfile, 'local_path' => $full_path]);
              $this->db->query($sql = "UPDATE brands SET image='$uploadfile' WHERE brand_id='$brand_id'");
            }
          }
          elseif (isset($_POST['image_url'])) {
            $image_url = trim($_POST['image_url']);
            if (preg_match("/^http:\/\/.+(\.jpg|\.jpeg)/i", $image_url)) {
              $image_content = @file_get_contents($image_url);
              if(!empty($image_content)) {
                $image_file = fopen($this->uploaddir.$uploadfile, 'wb');
                fwrite($image_file, $image_content);
                fclose($image_file);
                $this->db->query("UPDATE brands SET image='$uploadfile' WHERE brand_id='$brand_id'");
              }
            }
          }
        }

        $get = $this->form_get(array('section'=>'Brands'));
        if (isset($_GET['from'])) {
          header("Location: ".$_GET['from']);
        }
        else {
          header("Location: index.php$get");
        }
      }
      $this->db->query("UPDATE brands SET url=brand_id WHERE url=''");
    }
    else {
      $this->brand = $this->db->result(sql_placeholder('SELECT * FROM brands WHERE brand_id=?', $this->brand->brand_id));
    }
  }

	function fetch()
	{
		if (!empty($this->brand->brand_id)) {
			$this->title = 'Редактирование &laquo;'.$this->brand->name.'&raquo;';
		}
		else {
			$this->title = 'Новый бренд';
		}

		$this->smarty->assign('api_image', 	(!empty($this->brand->app_image) && file_exists('../images/loggoss/'.$this->brand->app_image)) ? '../images/loggoss/'.$this->brand->app_image : false);

		$this->smarty->assign('Item', 	$this->brand);
		$this->smarty->assign('Error', 	$this->error_msg);
		$this->smarty->assign('Lang',	$this->lang);
		$this->body = $this->smarty->fetch('brand.tpl');
	}
}
