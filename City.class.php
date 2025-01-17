<?php
require_once('Widget.class.php');

class City extends Widget {

	function fetch() {
        $tmp_url = parse_url($_SERVER['REQUEST_URI']);
        parse_str( !empty($tmp_url['query']) ? $tmp_url['query'] : '', $tmp_get);
        if($_GET['REGION']){$tmp_get['REGION'] = $_GET['REGION'];}
        $region_on_city_page = !empty($tmp_get['REGION']) ? $tmp_get['REGION'] : '';
        
        if ( isset($region_on_city_page) ) {
            $region = explode(',', $region_on_city_page);
            if ( isset($region[1]) && $region[1] == '209' ) {
                if ( $region[2] ) {
                    $city = $this->db->result("SELECT url, image, image_right FROM cities WHERE city_id = {$region[2]} LIMIT 1");
                }
                $redirect_city_url = ($city->url) ? '/city/'.$city->url : '/sections/shipping';
                header("HTTP/1.1 301 Moved Permanently");
                header("Location: {$redirect_city_url}/");
                die('ok');
            }
        }
        
		if(!empty($_GET['city_url'])){
			if ($this->settings->theme == 'api') {
				$city = $this->db->result("SELECT * FROM `cities` WHERE `visible` =1 AND `city_id` ={$_GET['city_url']};");
			}
			else{
				$city = $this->db->result("SELECT * FROM `cities` WHERE `visible` =1 AND `url` ='{$_GET['city_url']}';");
			}

			if($city == false) {
				if ($this->settings->theme == 'api') {
					$return->message = 'Страниы для этого города не существует.';
				}
				else{return false;}
			}

			if(!empty($city->delivery_methods)){
				$query = sql_placeholder('SELECT `name`, `description`, `image` FROM `delivery_methods` WHERE `enabled` =? AND `delivery_method_id` in ('.$city->delivery_methods.') ', 1);
				$this->db->query($query);
				$delivery_methods = $this->db->results();
			}
			if(!empty($city->payment_methods)){
				$query = sql_placeholder('SELECT `name`, `description`, `image` FROM `payment_methods` WHERE `enabled` =? AND `payment_method_id` in ('.$city->payment_methods.') ', 1);
				$this->db->query($query);
				$payment_methods = $this->db->results();
			}


			if ($this->settings->theme == 'api' && $city != false) {
				foreach($payment_methods as $method){$method->description = strip_tags(str_replace('</p>', '\n ', $method->description));}
				$city->payment_methods = $payment_methods;
				foreach($delivery_methods as $method){$method->description = strip_tags(str_replace('</p>', '\n ', $method->description));}
				$city->delivery_methods = $delivery_methods;
				$city->image = $city->image ? '/files/cities/'.$city->image : '';
				$city->image_right = $city->image ? '/files/cities/'.$city->image_right : '';
				$city->text = strip_tags(str_replace('</p>', '\n ', $city->text));
				$city->text2 = strip_tags(str_replace('</p>', '\n ', $city->text2));
				unset($city->id,$city->editor_id,$city->visible,$city->position,$city->url,$city->lastmod,$city->meta_title,$city->meta_description,$city->meta_keywords,$city->delivery_ids,$city->payment_ids);
				$return->city = $city;
			}
			else{
				$this->smarty->assign('city', $city);
				if(!empty($delivery_methods)){
					$this->smarty->assign('delivery_methods', $delivery_methods);
				}
				if(!empty($payment_methods)){
					$this->smarty->assign('payment_methods', $payment_methods);
				}
				if(!empty($city->meta_title))       {$this->smarty->assign('title', $city->meta_title);}
				if(!empty($city->meta_description)) {$this->smarty->assign('description', $city->meta_description);}
				if(!empty($city->meta_keywords))    {$this->smarty->assign('keywords', $city->meta_keywords);}
			}

		} else {

			$query = sql_placeholder('SELECT * FROM `cities` WHERE `visible` =? ORDER BY `position`', 1);
			$this->db->query($query);
			$cities = $this->db->results();
			if(!empty($cities)){
				if ($this->settings->theme == 'api') {
					$return->cities = $cities;
				}
				else{
					$this->smarty->assign('cities', $cities);
				}
			}
		}
		if ($this->settings->theme == 'api') {
			$return = json_encode($return);
			header('Content-Type: application/json');
			echo $return;
			die();
		}

		$this->body = $this->smarty->fetch('city.tpl');
		return true;
	}
}