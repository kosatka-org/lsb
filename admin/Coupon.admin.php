<?PHP

require_once('Widget.admin.php');
require_once('Storefront.admin.php');

class Coupon extends Widget
{

	function Coupon(&$parent)
	{
		Widget::Widget($parent);
	}

	var $chars = '0123456789';
	var $chars_card = '0123456789';
	
	function fetch()
	{
		
		if(isset($_POST['coupon_add'])){
		
			$num_char = intval($_POST['num_char']);
			$coupon->date_start = $_POST['date_start'];
			$coupon->date_finish = $_POST['date_finish'];
			$coupon->value = round($_POST['value'], 2);
			$coupon->type = $_POST['type'];
			$coupon->text = $_POST['text'];
			
			$this->smarty->assign('coupon', $coupon);
			
			if ($num_char <= 0) {
				$Error = 'Введите кол-во символов';
			}
			else
			if ($coupon->value <= 0) {
				$Error = 'Введите скидку';
			}
			else {
				do {
					$coupon->code = NULL;
					$numChars = strlen($this->chars);
					for ($i = 1; $i <= $num_char; $i++) {
						$coupon->code .= substr($this->chars, rand(1, $numChars) - 1, 1);
					}
					$this->db->query(sql_placeholder("SELECT COUNT(id) as count FROM coupons WHERE code=?", $coupon->code));
				} while($this->db->result('count') > 0);

				
				$user->name = 'Промокод: ' . $coupon->text;
				$user->enabled  = 1;
				if ($coupon->type == 'percentage') { 
					$user->personal_discount = $coupon->value;
				}
				else{
					$user->deposit = $coupon->value;
				}
				$user->shop = 'Internet';
				$user->store = 'Internet';
				do {
					$user->card_number = NULL;
					$numChars = strlen($this->chars_card);
					for ($i = 1; $i <= 16; $i++) {
						$user->card_number .= substr($this->chars_card, rand(1, $numChars) - 1, 1);
					}
					$this->db->query(sql_placeholder("SELECT COUNT(id) as count FROM users WHERE card_number=?", $user->card_number));
				} while($this->db->result('count') > 0);
				
				$user = (array)$user;
				$query = sql_placeholder("INSERT INTO users SET ?%", $user); 
				$this->db->query($query);
				$user_id = $this->db->insert_id();
				$query = sql_placeholder("UPDATE users SET original_user_id = user_id WHERE user_id =?", $user_id); 
				$this->db->query($query);
				
				$coupon->user_id = $user_id;
				$coupon = (array)$coupon;
				$query = sql_placeholder("INSERT INTO coupons SET ?%", $coupon); 
				$this->db->query($query);
				
				header('location: ?section=Coupons');
				die();
			}

			if (isset($Error)) {
				$this->smarty->assign('Error', $Error);
			}
			
			$this->smarty->assign('num_char', $num_char);
		}
		
		$this->title = "Новый купон";
		$this->body = $this->smarty->fetch('coupon.tpl');
	}
}