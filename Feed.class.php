<?php
require_once('Widget.class.php');

class Feed extends Widget
{
	function fetch(){
        
		if (isset($_GET['update_generated_news'])) {
			return $this->update_generated_news();
		}
		if (isset($_GET['update_text_news'])) {
			return $this->update_text_news();
		}
		if (isset($_GET['generate_page'])) {
			$this->body = $this->generate_page($_GET['generate_page']);
			return $this->body;
		}
    if ($this->settings->theme == 'api' && isset($_GET['newsline'])) {
      $this->get_api_news($_GET['type']);
    }
		else {
			$this->body = $this->get_feed();
			return $this->body;
		}	
	}
    
    private function get_api_news($type){
      if (isset($_GET['page'])){
        $p_end = (int)$_GET['page'] * 2;
        $p_start = $p_end - 2;
  
        $period_end = date('Y-m-d', strtotime("-$p_start week")) . ' 23:59:59';
        $period_start = date('Y-m-d', strtotime("-$p_end week")) . ' 00:00:00';
      }else{
        $period_end = date('Y-m-d') . ' 23:59:59'; 
        $period_start = date('Y-m-d', strtotime("-2 week")) . ' 00:00:00';
      }
      if($type == 'text'){
        $news = $this->get_text_news($period_start, $period_end);
        if(!isset($this->settings->theme_v)){$return->news_texts = $news;}
      }
      elseif($type == 'generated'){
        $news = $this->generate_news($period_start, $period_end);
        if(!isset($this->settings->theme_v)){$return->news_generated = $news;}
      }
      if($this->settings->theme_v == 'v2'){
        $return->obj = $news;
        $return = $this->format_api_response($return);
      }
      $return = json_encode($return);
      header('Content-Type: application/json');
      echo $return;
      die();
    }
	
	private function get_feed(){
		$period_end = date('Y-m') . '-31  23:59:59'; 
		$period_start = date('Y-m', strtotime("-2 month")) . '-01 00:00:00';
        
    $news_texts = $this->get_text_news($period_start, $period_end);
    $news_generated = $this->generate_news($period_start, $period_end);

    $this->smarty->assign('news_texts', $news_texts);
    $this->smarty->assign('news_generated', $news_generated);
    $this->smarty->assign('title',	'Новости и статьи');
    $body = $this->smarty->fetch('feed.tpl');
    return $body;
		die();
	}
	
	private function update_generated_news(){
		if($_GET['period'] > 0){
			$period_end = (int)$_GET['period'];
			$period_start = $period_end + 1;
			
			$period_end = date('Y-m', strtotime("-$period_end month")) . '-31 23:59:59';
			$period_start = date('Y-m', strtotime("-$period_start month")) . '-01 00:00:00';
			
			$news_generated = $this->generate_news($period_start, $period_end);
			
			$this->smarty->assign('news_generated', $news_generated);
			$body = $this->smarty->fetch('news_g_item.tpl');
			
			echo $body;
			die();
		}
	}
	
	private function update_text_news(){
		if($_GET['period'] > 0){
			$period_end = (int)$_GET['period'];
			$period_start = $period_end + 1;
			
			$period_end = date('Y-m', strtotime("-$period_end month")) . '-31 23:59:59';
			$period_start = date('Y-m', strtotime("-$period_start month")) . '-01 00:00:00';
			
			$news_texts = $this->get_text_news($period_start, $period_end);
			
			$this->smarty->assign('news_texts', $news_texts);
			$body = $this->smarty->fetch('news_t_item.tpl');
			
			echo $body;
			die();
		}
	}
	
	private function get_text_news($period_start, $period_end){
		$sql = "SELECT body AS text, video AS video, CASE WHEN image != '' THEN CONCAT('news/', image) ELSE '' END AS image, substring(created,1,10) AS date, header AS title, CONCAT('/news/', url) AS url FROM `news` WHERE `enabled`='1'  AND `created` >= '{$period_start}' AND `created` <= '{$period_end}'
				ORDER BY `date` DESC ";
		$_news_texts = $this->db->results($sql);
		$sql = "SELECT description AS text, CASE WHEN image != '' THEN CONCAT('specials/', image) ELSE '' END AS image, substring(date,1,10) AS date, name AS title, CONCAT('/specials/', url) AS url FROM `specials` WHERE `enabled`='1' AND `date` >= '{$period_start}' AND `date` <= '{$period_end}'
				UNION ALL 
				SELECT description AS text, CASE WHEN image != '' THEN CONCAT('brands/', image) ELSE '' END AS image, substring(text_modified,1,10) AS date, name AS title, CONCAT('/brands/', url) AS url FROM `brands` WHERE `image` != '' AND `description` != '' AND `text_modified` >= '{$period_start}' AND `text_modified` <= '{$period_end}'
				UNION ALL 
				SELECT text AS text, CASE WHEN image != '' THEN CONCAT('goods/', image) ELSE '' END image, substring(text_modified,1,10) AS date, title AS title, CONCAT('/goods/', url) AS url FROM `goods` WHERE `visible`='1' AND `text` != '' AND `text_modified` >= '{$period_start}' AND `text_modified` <= '{$period_end}'
				ORDER BY `date` DESC ";
		$_rest_texts = $this->db->results($sql);
		
		$i = 0;
		$rest_texts = array();
		foreach ($_rest_texts as $result){
			$rest_texts[$i]->text = $result->text;
			$rest_texts[$i]->video = '';
			$rest_texts[$i]->image = $result->image;
			$rest_texts[$i]->date = $result->date;
			$rest_texts[$i]->title = $result->title;
			$rest_texts[$i]->url = $result->url;
			$i++;
		}
		$results = array_merge($_news_texts, $rest_texts);
		array_multisort($date, SORT_DESC, SORT_REGULAR, $results);
		
		$date = 0;
		$i = 0;
		$news_texts = array();
		foreach ($results as $result){
			if ((substr($date,5,2)) != (substr($result->date,5,2))){
				$news_texts[$i]->new = $result->date;
				$date = $result->date;
			}
      if ($this->settings->theme == 'api') {
        $result->image = !empty($result->image) ? 'https://lsboutique.ru/files/'. $result->image : '';
        $search = array("</p>", "\n", "\r");
        $replace = array('\n ', ' ', '');
        $result->text = strip_tags(str_replace($search, $replace, $result->text));	
        if(strpos($result->url, 'brands') !== false){
          $cq = trim(substr($result->url, strpos($result->url, 'brands')+7),'/');
          $result->url = '';
          $result->brand_id = $this->db->result("SELECT brand_id FROM brands WHERE url = '{$cq}'")->brand_id;
        }
        elseif(strpos($result->url, 'goods') !== false){
          $cq = trim(substr($result->url, strpos($result->url, 'goods')+6),'/');
          $result->url = '';
          $result->category_id = $this->db->result("SELECT category_id FROM goods WHERE url = '{$cq}'")->category_id;
          $result->brand_id = $this->db->result("SELECT brand_id FROM goods WHERE url = '{$cq}'")->brand_id;
        }
        elseif(strpos($result->url, 'specials') !== false){
          $cq = trim(substr($result->url, strpos($result->url, 'specials')+9),'/');
          $result->url = '';
          $result->special_id = $this->db->result("SELECT special_id FROM specials WHERE url = '{$cq}'")->special_id;
        }
        elseif(strpos($result->url, 'news') !== false){
          $cq = trim(substr($result->url, strpos($result->url, 'news')+5),'/');
          $result->url = '';
          $result->news_id = $this->db->result("SELECT news_id FROM news WHERE url = '{$cq}'")->news_id;
        }
      }
			$news_texts[$i]->text = $result->text;
			$news_texts[$i]->video = $result->video;
			$news_texts[$i]->image = $result->image;
			$news_texts[$i]->date = $result->date;
			$news_texts[$i]->title = $result->title;
      if ($this->settings->theme == 'api') {
        $news_texts[$i]->url = (strpos($result->url, 'lsboutique.ru') === false) ? $result->url : null;
        $news_texts[$i]->special_id = $result->special_id;
        $news_texts[$i]->category_id = $result->category_id;
        $news_texts[$i]->brand_id = $result->brand_id;
        $news_texts[$i]->news_id = $result->news_id;
      }
      else{$news_texts[$i]->url = $result->url;}
      $i++;
		}
		return $news_texts;
	}
	
	private function generate_news($period_start, $period_end){
    set_time_limit ( 180 );
		$sql = "SELECT substring(products.last_price_update,1,10) AS date, products.model, products.product_id, products.url AS p_url, brands.url AS b_url, brands.brand_id, categories.url AS c_url, brands.name AS b_name, categories.name AS c_name, categories.category_id
									FROM products 
									LEFT JOIN brands ON products.brand_id = brands.brand_id
									LEFT JOIN categories ON products.category_id = categories.category_id
									WHERE products.enabled='1' AND products.price != 0 AND products.old_price > products.price  AND products.last_price_update >= '{$period_start}' AND products.last_price_update <= '{$period_end}'
									ORDER BY `date` DESC";
		$sale_pr = $this->db->results($sql);
		$sql = "SELECT substring(products.created,1,10) AS date, products.model, products.product_id, products.url AS p_url, brands.url AS b_url, brands.brand_id, categories.url AS c_url, brands.name AS b_name, categories.name AS c_name, categories.category_id
									FROM products 
									LEFT JOIN brands ON products.brand_id = brands.brand_id
									LEFT JOIN categories ON products.category_id = categories.category_id
									WHERE products.enabled='1' AND products.price != 0 AND products.created >= '{$period_start}' AND products.created <= '{$period_end}'
									ORDER BY `date` DESC";
		$add_pr = $this->db->results($sql);
		$sql = "SELECT substring(video_added,1,10) AS date, model, video, product_id, url AS url 
                  FROM products 
									WHERE enabled='1' AND price != 0 AND video_added >= '{$period_start}' AND video_added <= '{$period_end}'
									ORDER BY `date` DESC";
		$vid_pr = $this->db->results($sql);
		$sql = "SELECT substring(banner_m_modified,1,10) AS date, banner_m AS banner, meta_title AS title, name, brand_id, url FROM `brands` WHERE banner_m_modified >= '{$period_start}' AND `banner_m_modified` <= '{$period_end}'
									UNION ALL 
									SELECT substring(banner_w_modified,1,10) AS date, banner_w AS banner, meta_title AS title, name, brand_id, url FROM `brands` WHERE banner_w_modified >= '{$period_start}' AND `banner_w_modified` <= '{$period_end}'
									ORDER BY `date` DESC";
		$B_res = $this->db->results($sql);
		$sql = "SELECT substring(dat,1,10) AS date, question, answer, user_name FROM `faqs` WHERE `visible`='1' AND dat >= '{$period_start}' AND `dat` <= '{$period_end}'
									ORDER BY `date` DESC";
		$A_res = $this->db->results($sql);
		$sql = "SELECT substring(lastmod,1,10) AS date, url, city_id, name FROM `cities` WHERE lastmod >= '{$period_start}' AND `lastmod` <= '{$period_end}'
									ORDER BY `date` DESC";
		$C_res = $this->db->results($sql);
		$sms_history = $this->db->results("SELECT substring(date,1,10) AS date, post FROM sms_history WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' ORDER BY date DESC;");
		$i = 0;
		$date = 0;
		$news_generating = array();
		foreach ($sms_history as $result) {
      if (!empty($result->date)){
        if ($date != $result->date){
          $sms_info = json_decode($result->post, true);
          $date = $result->date;
          $news_generating[$i]->date = $result->date;
          $news_generating[$i]->anons = str_replace(array('www.lsboutique.ru', '{USERNAME}', 'карте', '{CARDNUMBER}'), '', $sms_info['message']);
          if ($this->settings->theme == 'api') {
            $news_generating[$i]->info = '';
          }
          else{
            $news_generating[$i]->text = '';
          }
          $i++;
        }
      }
		}
		
		$date = 0;
		if ($vid_pr){
			foreach ($vid_pr as $result){
        if (!empty($result->date)){
          if ($date != $result->date){
            $x = 0;
            $i++;
            if ($this->settings->theme == 'api') {
                $news_generating[$i]->info->vid_pr->text = 'Добавлены видео для ';
            }
            else{
                $str_prods = "Добавлены видео для ";
            }
            $brands = array();
            $categories = array();
            $products = array();
            $date = $result->date;
            $news_generating[$i]->date = $result->date;
          }
          if ($this->settings->theme == 'api') {
            $products[$x]->name = $result->model;
            $products[$x]->id = $result->product_id;
            $products[$x]->video = $result->video;
            if ($result->date != next($vid_pr->date)) {
              $news_generating[$i]->info->vid_pr->products = $products;
            }
          }
          else{
            if($x == 0){
              $video = substr($result->video,-11);
              $str_prods .= "<a href='/products/{$result->url}' target='_blank'>{$result->model}</a><br /><iframe width='560' height='315' src='https://www.youtube.com/embed/{$video}' frameborder='0' allowfullscreen></iframe><br />";
            }
            elseif($x == 1){$str_prods .= " а также для <a href='/products/{$result->p_url}' target='_blank'>{$result->model}</a>, ";}
            else{$str_prods .= "<a href='/products/{$result->p_url}' target='_blank'>{$result->model}</a>, ";}
            if ($result->date != next($vid_pr->date)) {
              $news_generating[$i]->text = $str_prods;
              $news_generating[$i]->anons = '';
            }
          }
          $x++;
        }
      }
		}
		if ($sale_pr){
			foreach ($sale_pr as $result){
        if (!empty($result->date)){
          if ($date != $result->date){
            if ($this->settings->theme == 'api') {
                $news_generating[$i]->info->sale_pr->text = 'Снижение стоимости на ';
            }
            else{
                $y = "<div>Снижение стоимости на <div class='h_products'><div>";
            }
            
            if ($this->settings->theme == 'api') {
              $news_generating[$i]->info->sale_pr->brands = array_values($brands);
              $news_generating[$i]->info->sale_pr->categories = array_values($categories);
              $news_generating[$i]->info->sale_pr->products = $products;
            }
            else{
              $str_brands = implode(', ', $brands);
              $str_categories = implode(', ', $categories);
              $xs = "<span class='show_pr'>" . $x . " товаров</span>";
              $z = "</div></div>" . $xs . " от " . $str_brands . " со скидками продаются " . $str_categories . "</div>";
              $news_generating[$i]->text = $y . $z;
              $news_generating[$i]->anons = '';
            }
            $i++;

            $x = 0;
            $brands = array();
            $categories = array();
            $products = array();
            $date = $result->date;
            $news_generating[$i]->date = $result->date;
          }
          if ($this->settings->theme == 'api') {
            $brands[$result->brand_id]->name = $result->b_name;
            $brands[$result->brand_id]->id = $result->brand_id;
            $categories[$result->category_id]->name = $result->c_name;
            $categories[$result->category_id]->id = $result->category_id;
            $products[$x]->name = $result->model;
            $products[$x]->id = $result->product_id;
          }
          else{
            $brands[$result->brand_id] = "<a href='/brands/{$result->b_url}' target='_blank'>{$result->b_name}</a>";
            $categories[$result->category_id] = "<a href='/categories/{$result->c_url}' target='_blank'>{$result->c_name}</a>";
            $y .= "<a href='/products/{$result->p_url}' target='_blank'>{$result->model}</a>, ";
          }
          $x++;
        }
      }
		}
		if ($add_pr){
			foreach ($add_pr as $result){
        if (!empty($result->date)){
          if ($date != $result->date){
            if ($this->settings->theme == 'api') {
              $news_generating[$i]->info->add_pr->brands = array_values($brands);
              $news_generating[$i]->info->add_pr->categories = array_values($categories);
              $news_generating[$i]->info->add_pr->products = $products;
            }
            else{
              $xs = "<span class='show_pr'>" . $x . " товаров</span>";
              $str_brands = implode(', ', $brands);
              $str_categories = implode(', ', $categories);
              $z = "</div></div>" . $xs . " в категории " . $str_categories . " от " . $str_brands . " </div>";
              $news_generating[$i]->text = $y . $z;
              $news_generating[$i]->anons = '';
            }
            $i++;
            if ($this->settings->theme == 'api') {
                $news_generating[$i]->info->add_pr->text = 'На витрину интернет бутика Лакшери Стора добавлено ';
            }
            else{
                $y = "<div>На витрину интернет бутика Лакшери Стора добавлено <div class='h_products'><div>";
            }
            $x = 0;
            $brands = array();
            $categories = array();
            $products = array();
            $date = $result->date;
            $news_generating[$i]->date = $result->date;
          }
          if ($this->settings->theme == 'api') {
            $brands[$result->brand_id]->name = $result->b_name;
            $brands[$result->brand_id]->id = $result->brand_id;
            $categories[$result->category_id]->name = $result->c_name;
            $categories[$result->category_id]->id = $result->category_id;
            $products[$x]->name = $result->model;
            $products[$x]->id = $result->product_id;
          }
          else{
            $brands[$result->brand_id] = "<a href='/brands/{$result->b_url}' target='_blank'>{$result->b_name}</a>";
            $categories[$result->category_id] = "<a href='/categories/{$result->c_url}' target='_blank'>{$result->c_name}</a>";
            $y .= "<a href='/products/{$result->p_url}' target='_blank'>{$result->model}</a>, ";
          }
          $x++;
        }
      }
		}
		if ($B_res){
      foreach ($B_res as $result){
        if (!empty($result->date)){
          if ($date != $result->date){
            $date = $result->date;
            $x = 0;
            $i++;
            $news_generating[$i]->date = $result->date;
            $news_generating[$i]->anons = '';
          }
          if ($this->settings->theme == 'api') {
            $news_generating[$i]->info->banner[$x]->banner_name = $result->name;
            $news_generating[$i]->info->banner[$x]->brand_id = $result->brand_id;
            $news_generating[$i]->info->banner[$x]->banner_image = !empty($result->banner) ? "https://lsboutique.ru/files/brand_banners/{$result->banner}" : '';
            $x++;
          }
          else{
            $news_generating[$i]->text .= "Новая коллекция {$result->name}<br /><a href='/brands/{$result->url}/' target='_blank'><img src='/files/brand_banners/{$result->banner}' alt='{$result->title}' title='{$result->name}'></a><br /> ";
          }
        }
      }
		}
		if ($A_res){
			foreach ($A_res as $result){
        if (!empty($result->date)){
          if ($date != $result->date){
            $date = $result->date;
            $x = 0;
            $i++;
            $news_generating[$i]->date = $result->date;
            $news_generating[$i]->anons = '';
          }
          if ($this->settings->theme == 'api') {
            $news_generating[$i]->info->faq[$x]->question = $result->question;
            $news_generating[$i]->info->faq[$x]->user_name = $result->user_name;
            $news_generating[$i]->info->faq[$x]->answer = strip_tags($result->answer);
            $x++;
          }
          else{
            $news_generating[$i]->text = "<a href='/faq' target='_blank'>Ответ на вопрос</a>:{$result->question}.<br />{$result->user_name}<br />{$result->answer} ";
          }
          $i++;
        }
      }
		}
		if ($C_res){
			foreach ($C_res as $result){
        if (!empty($result->date)){
          if ($date != $result->date){
            $date = $result->date;
            $x = 0;
            $i++;
            $news_generating[$i]->date = $result->date;
            $news_generating[$i]->anons = '';
          }
          if ($this->settings->theme == 'api') {
            $news_generating[$i]->info->cities[$x]->text = "Изменены условия доставки в город ";
            $news_generating[$i]->info->cities[$x]->city_id = $result->city_id;
            $news_generating[$i]->info->cities[$x]->city_name = $result->name;
            $x++;
          }
          else{
            $news_generating[$i]->text = "<a href='/city/{$result->url}' target='_blank'>Изменены условия доставки в город {$result->name}</a>. ";
          }
        }
      }
		}
    $dates=array();
    foreach($news_generating as $key=>$arr){
      $dates[$key]=$arr->date;
    }
		array_multisort($dates, SORT_DESC, $news_generating, SORT_REGULAR);
		
		$date = 0;
		$i = -1;
		$news_generated = array();
		foreach ($news_generating as $result){
      if (!empty($result->date)){
        if ($date != $result->date){
          $i++;
          if ((substr($date,5,2)) != (substr($result->date,5,2))){
            $news_generated[$i]->new = $result->date;
          }
          $news_generated[$i]->date = $date = $result->date;
          if ($this->settings->theme != 'api') {
            $news_generated[$i]->url = "/feed/generate_page/{$result->date}";
            $y = '';
          }
        }
        $news_generated[$i]->anons .= $result->anons;
        if ($this->settings->theme == 'api') {
          $news_generated[$i]->info = '';
          foreach($result->info as $k=>$v){
            $news_generated[$i]->info->$k = $v;
          }
        }
        else{
          $y .= "<p>{$result->text}</p>";
          $news_generated[$i]->text = $y;
        }
      }
    }
		return $news_generated;
	}
	
	private function generate_page($date){
	
		$period_end = date($date) . ' 23:59:59';
		$period_start = date($date) . ' 00:00:00';
			
		$sql = "SELECT model, url, product_id FROM products WHERE enabled='1' AND price != 0 AND old_price > price  AND last_price_update >= '{$period_start}' AND last_price_update <= '{$period_end}'";
		$sale_pr = $this->db->results($sql);
		$sql = "SELECT model, url, product_id FROM products WHERE enabled='1' AND price != 0 AND created >= '{$period_start}' AND created <= '{$period_end}'";
		$add_pr = $this->db->results($sql);
    $sql = "SELECT model, video, product_id, url FROM products WHERE enabled='1' AND price != 0 AND video_added >= '{$period_start}' AND video_added <= '{$period_end}'";
		$vid_pr = $this->db->results($sql);
		$sql = "SELECT banner_m AS banner, meta_title AS title, name, url, brand_id FROM `brands` WHERE banner_m_modified >= '{$period_start}' AND `banner_m_modified` <= '{$period_end}'
				UNION ALL 
				SELECT banner_w AS banner, meta_title AS title, name, url, brand_id FROM `brands` WHERE banner_w_modified >= '{$period_start}' AND `banner_w_modified` <= '{$period_end}'";
		$B_res = $this->db->results($sql);
		$sql = "SELECT question, answer, user_name FROM `faqs` WHERE `visible`='1' AND dat >= '{$period_start}' AND `dat` <= '{$period_end}'";
		$A_res = $this->db->results($sql);
		$sql = "SELECT url, name, city_id FROM `cities` WHERE lastmod >= '{$period_start}' AND `lastmod` <= '{$period_end}'";
		$C_res = $this->db->results($sql);
		$sms_anons = $this->db->result("SELECT post FROM sms_history WHERE date >= '{$period_start}' AND `date` <= '{$period_end}' LIMIT 1;");
		
		$i = 0;
		$news_generating = array();
		if ($sms_anons) {
			$i++;
			$sms_info = json_decode($sms_anons->post, true);
			$news_generating[$i]->text = str_replace(array('www.lsboutique.ru', '{USERNAME}', 'карте', '{CARDNUMBER}'), '', $sms_info['message']);
      if ($this->settings->theme == 'api') {$news_generating[$i]->info->lead = $news_generating[$i]->text;}
		}
		if ($sale_pr){
			$y = "Снижение стоимости на ";
			$i++;
      $x=0;
      $products = array();
			foreach ($sale_pr as $result){
        if ($this->settings->theme == 'api') {
          $products[$x]->name = $result->model;
          $products[$x]->id = $result->product_id;
          $x++;
        }
        else{
          $y .= "<a href='/products/{$result->url}' target='_blank'>{$result->model}</a>, ";
        }
			}
      if ($this->settings->theme == 'api') {
        $news_generating[$i]->info->sale_pr->text = $y;
        $news_generating[$i]->info->sale_pr->products = $products;
      }
      else{$news_generating[$i]->text = $y;}
		}
		if ($add_pr){
			$y = "На витрину интернет бутика Лакшери Стора добавлены ";
			$i++;
      $x=0;
      $products = array();
			foreach ($add_pr as $result){
        if ($this->settings->theme == 'api') {
          $products[$x]->name = $result->model;
          $products[$x]->id = $result->product_id;
          $x++;
        }
        else{
          $y .= "<a href='/products/{$result->url}' target='_blank'>{$result->model}</a>, ";
        }
			}
      if ($this->settings->theme == 'api') {
        $news_generating[$i]->info->add_pr->text = $y;
        $news_generating[$i]->info->add_pr->products = $products;
      }
			else{$news_generating[$i]->text = $y;}
		}
		if ($B_res){
      $x=0;
      $i++; 
			foreach ($B_res as $result){
        if ($this->settings->theme == 'api') {
          $banners[$x]->banner_name = $result->name;
          $banners[$x]->brand_id = $result->brand_id;
          $banners[$x]->banner_image = !empty($result->banner) ? "https://lsboutique.ru/files/brand_banners/{$result->banner}" : '';
          $x++;
        }
        else{
          $news_generating[$i]->text .= "Новая коллекция {$result->name}<br /><a href='/brands/{$result->url}/' target='_blank'><img src='/files/brand_banners/{$result->banner}' alt='{$result->title}' title='{$result->name}'></a><br /><br /> ";
        }
			}
      if ($this->settings->theme == 'api') {
        $news_generating[$i]->info->banners->banners = $banners;
      }
		}
		if ($A_res){
			foreach ($A_res as $result){
        $x=0;
				$i++;
        if ($this->settings->theme == 'api') {
          $news_generating[$i]->info->faq[$x]->question = $result->question;
          $news_generating[$i]->info->faq[$x]->user_name = $result->user_name;
          $news_generating[$i]->info->faq[$x]->answer = strip_tags($result->answer);
          $x++;
        }
        else{
          $news_generating[$i]->text = "<a href='/faq' target='_blank'>Ответ на вопрос</a>:{$result->question}.<br /> {$result->user_name}<br /> {$result->answer} ";
        }
			}
		}
		if ($C_res){
      $x=0;
			foreach ($C_res as $result){
				$i++;
        if ($this->settings->theme == 'api') {
          $cities[$x]->text = 'Изменены условия доставки в город ';
          $cities[$x]->city_id = $result->city_id;
          $cities[$x]->city_name = $result->name;
          $x++;
        }
        else{
          $news_generating[$i]->text = "<a href='/city/{$result->url}' target='_blank'>Изменены условия доставки в город {$result->name}</a>. ";
        }
			}
      if ($this->settings->theme == 'api') {
        $news_generating[$i]->info->cities = $cities;
      }
		}
    if ($vid_pr){
			$i++;
      $x=0;
			$y = "Новое видео для ";
      $products = array();
			foreach ($vid_pr as $result){
				if ($this->settings->theme == 'api') {
          $products[$x]->name = $result->model;
          $products[$x]->id = $result->product_id;
          $products[$x]->video = $result->video;
          $x++;
        }
        else{
          $video = substr($result->video,-11);
          $y .= "<a href='/products/{$result->url}' target='_blank'>{$result->model}</a><br /><iframe width='560' height='315' src='https://www.youtube.com/embed/{$video}' frameborder='0' allowfullscreen></iframe><br />";
        }
			}
      if ($this->settings->theme == 'api') {
        $news_generating[$i]->info->vid_pr->text = $y;
        $news_generating[$i]->info->vid_pr->products = $products;
      }
      else{$news_generating[$i]->text = $y;}
		}
		
		$news_item->date = $date;
		$news_item->header = "Обновления на сайте " . $date;
		$y = '';
		foreach ($news_generating as $result){
      if ($this->settings->theme == 'api') {
        $i = 0;
        $news_generated[$i]->info = '';
        foreach($result->info as $k=>$v){
          $news_item->info[$i]->$k = $v;
          $i++;
        }
      }
      else{
        $y .= "<p>{$result->text}</p>";
      }
		}
    if ($this->settings->theme == 'api') {
      if($this->settings->theme_v == 'v2'){$return->obj[0] = $news_item;}
      else{$return->page = $news_item;}
    }
    else{
      $news_item->body = $y;
    } 
    if ($this->settings->theme == 'api') {
      if($this->settings->theme_v == 'v2'){
        $return = $this->format_api_response($return);
      }
      $return = json_encode($return);
      header('Content-Type: application/json');
      echo $return;
		}
    else{
      $this->smarty->assign('news_item', $news_item);
      $this->smarty->assign('title',	$news_item->header);
      $body = $this->smarty->fetch('news_item.tpl');
      return $body;
    }
    die();
	}
}