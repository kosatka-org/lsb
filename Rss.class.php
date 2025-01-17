<?PHP
 
require_once('Widget.class.php');


class Rss extends Widget
{
	/**
	 *
	 * Конструктор
	 *
	 */
	function Rss(&$parent)
	{
		Widget::Widget($parent);
	}
	
	/**
	 *
	 * Отображение
	 *
	 */
	function fetch()
	{

		//$this->smarty->assign('items', $this->db->results("SELECT * FROM products WHERE created > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)"));
		
		$sql = "SELECT CONCAT('<![CDATA[', body, ']]>') AS text, date_format(`modified`,'%a, %d %b %Y %T GMT') AS date, header AS title, CONCAT('news/', url) AS url FROM `news` WHERE `enabled`='1'  AND `modified` > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
				UNION ALL 
				SELECT CONCAT('<![CDATA[', description, ']]>') AS text, date_format(`date`,'%a, %d %b %Y %T GMT') AS date, name AS title, CONCAT('specials/', url) AS url FROM `specials` WHERE `enabled`='1' AND `date` > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
				UNION ALL 
				SELECT CONCAT('<![CDATA[', description, ']]>') AS text, date_format(`text_modified`,'%a, %d %b %Y %T GMT') AS date, name AS title, CONCAT('brands/', url) AS url FROM `brands` WHERE `image` != '' AND `description` != '' AND `text_modified` > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
				UNION ALL 
				SELECT CONCAT('<![CDATA[', text, ']]>') AS text, date_format(`text_modified`,'%a, %d %b %Y %T GMT') AS date, title AS title, CONCAT('goods/', url) AS url FROM `goods` WHERE `visible`='1' AND `text` != '' AND `text_modified` > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
				ORDER BY `date` DESC ";
		$news_texts = $this->db->results($sql);
		
		$sql = "SELECT last_price_update AS date, model, url
									FROM products 
									WHERE enabled='1' AND price != 0 AND old_price > price  AND last_price_update > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
									ORDER BY `date` DESC";
		$sale_pr = $this->db->results($sql);
		$sql = "SELECT created AS date, model, url AS url
									FROM products 
									WHERE enabled='1' AND price != 0 AND created > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
									ORDER BY `date` DESC";
		$add_pr = $this->db->results($sql);
		$sql = "SELECT banner_m_modified AS date, banner_m AS banner, meta_title AS title, name, url FROM `brands` WHERE banner_m_modified > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
									UNION ALL 
									SELECT substring(banner_w_modified,1,10) AS date, banner_w AS banner, meta_title AS title, name, url FROM `brands` WHERE banner_w_modified > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
									ORDER BY `date` DESC";
		$B_res = $this->db->results($sql);
		$sql = "SELECT  dat AS date, question, answer, user_name FROM `faqs` WHERE `visible`='1' AND dat > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
									ORDER BY `date` DESC";
		$A_res = $this->db->results($sql);
		$sql = "SELECT lastmod AS date, url, name FROM `cities` WHERE lastmod > DATE_SUB(CURDATE(), INTERVAL 2 WEEK)
									ORDER BY `date` DESC";
		$C_res = $this->db->results($sql);
		$sms_history = $this->db->results("SELECT substring(date,1,10) AS date, post FROM sms_history WHERE `date` >= '{$period_start}' AND `date` <= '{$period_end}' ORDER BY date DESC;");
		
		
		$i = 0;
		$date = 0;
		$news_generating = array();
		foreach ($sms_history as $result) {
			if ($date != $result->date){
				$i++;
				$sms_info = json_decode($result->post, true);
				$date = $result->date;
				$news_generating[$i]->date = $result->date;
				$news_generating[$i]->anons = str_replace(array('www.lsboutique.ru', '{USERNAME}', 'карте', '{CARDNUMBER}'), '', $sms_info['message']);
				$news_generating[$i]->text = '';
			}
		}
		if ($sale_pr){
			foreach ($sale_pr as $result){
				if ($date != substr($result->date,0,10)){
					$y = "Снижение стоимости на ";
					$date = substr($result->date,0,10);
					$i++;
					$news_generating[$i]->date = $result->date;
				}
				$y .= "<a href='https://lsboutique.ru/products/{$result->url}' target='_blank'>{$result->model}</a>, ";
				$news_generating[$i]->text = $y;
				$news_generating[$i]->anons = '';
			}
		}
		if ($add_pr){
			foreach ($add_pr as $result){
				if ($date != substr($result->date,0,10)){
					$y = "На витрину интернет бутика Лакшери Стора добавленно ";
					$date = substr($result->date,0,10);
					$i++;
					$news_generating[$i]->date = $result->date;
				}
				$y .= "<a href='https://lsboutique.ru/products/{$result->url}' target='_blank'>{$result->model}</a>, ";
				$news_generating[$i]->text = $y;
				$news_generating[$i]->anons = '';
			}
		}
		if ($B_res){
			foreach ($B_res as $result){
				$i++;
				$news_generating[$i]->date = $result->date;
				$news_generating[$i]->anons = '';
				$news_generating[$i]->text = "Новая коллекция {$result->name}<br /><a href='https://lsboutique.ru/brands/{$result->url}/' target='_blank'><img src='https://lsboutique.ru/files/brand_banners/{$result->banner}' alt='{$result->title}' title='{$result->name}' /></a> ";
			}
		}
		if ($A_res){
			foreach ($A_res as $result){
				$i++;
				$news_generating[$i]->date = $result->date;
				$news_generating[$i]->anons = '';
				$news_generating[$i]->text = "<a href='https://lsboutique.ru/faq' target='_blank'>Ответ на вопрос {$result->user_name}</a>:{$result->question}.<br />{$result->answer} ";
			}
		}
		if ($C_res){
			foreach ($C_res as $result){
				$i++;
				$news_generating[$i]->date = $result->date;
				$news_generating[$i]->anons = '';
				$news_generating[$i]->text = "<a href='https://lsboutique.ru/city/{$result->url}' target='_blank'>Изменены условия доставки в город {$result->name}</a>. ";
			}
		}
		
		array_multisort($news_generating, SORT_DESC, SORT_REGULAR );
		
		
		$date = 0;
		$i = 0;
		$news_generated = array();
		foreach ($news_generating as $result){
			if ($date != (substr($result->date,0,10))){
				$i++;
				$y = '<![CDATA[';
				$date = substr($result->date,0,10);
				$news_generated[$i]->date = date("r",strtotime($result->date));
				$news_generated[$i]->url = "feed/generate_page/" . substr($result->date,0,10);
				$news_generated[$i]->title = "Обновления на сайте " . substr($result->date,0,10);
			}
			$y .= "<p>{$result->text}</p>";
			$news_generated[$i]->anons .= '<![CDATA[' . $result->anons . '<br />]]>';
			$news_generated[$i]->text = $y . ']]>';
		}
		
		$results = array_merge($news_texts, $news_generated);
		array_multisort($results, SORT_DESC, SORT_REGULAR );
		
		
		
		$this->smarty->assign('news_generated', $results);
		header('Content-type: application/rss+xml; charset=utf-8');
		$this->body = $this->smarty->fetch('rss.tpl');
		echo $this->body;
		exit();
	}
}

?>
