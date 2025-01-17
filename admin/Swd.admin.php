<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


class Swd extends Widget
{
	var $item;
	function Swd(&$parent)
	{
		Widget::Widget($parent);
		$this->prepare();
	}

	function prepare()
	{

		if (!empty($_POST) || !empty($_FILES)) {
			foreach ($_FILES as $key => $file) {
				if (!empty($file['tmp_name'])) {
					$this->uploaddir = $_SERVER['DOCUMENT_ROOT'] . '/files/images/swd/';
					$path_parts = pathinfo($file['name']);
					$uploadfile = $key . time() . "." . strtolower($path_parts['extension']);
					if (!move_uploaded_file($file['tmp_name'], $this->uploaddir.$uploadfile)) {
						$this->error_msg = $this->lang->FILE_UPLOAD_ERROR; 
					}
					else {
						@chmod($this->uploaddir.$uploadfile, 0644); 
						$this->db->query($sql = "UPDATE promo SET $key='$uploadfile' WHERE name = 'swd'");
					}
				}
			}

			if (isset($_POST['date'])) {
				$d = $_POST['date'];
				$this->db->query("UPDATE promo SET date='{$d}' WHERE name = 'swd'");
			}

			if (isset($_POST['enabled'])) {
				$this->db->query("UPDATE promo SET enabled=1 WHERE name = 'swd'");
			}
			else {
				$this->db->query("UPDATE promo SET enabled=0 WHERE name = 'swd'");
			}

			if (is_array($_POST['brands']) && count($_POST['brands'])>0) {
				$brands_str = implode(",", $_POST['brands']);
				$this->db->query("UPDATE promo SET brands='{$brands_str}' WHERE name = 'swd'");
			}
		}
			
		$this->item = $this->db->result("SELECT * FROM promo WHERE name='swd'");

		$this->smarty->assign("brands", $this->db->results("SELECT * FROM brands WHERE 1"));
	}

	function fetch() {
		$this->title = "Скидка Выходного Дня";

		$this->smarty->assign('Item', $this->item);
		$this->smarty->assign('Error', $this->error_msg);
		$this->smarty->assign('Lang', $this->lang);
		$this->body = $this->smarty->fetch('swd.tpl');
	}
}
