<?PHP

/**
 * Simpla CMS
 *
 * @copyright 	2009 Denis Pikusov
 * @link 		http://simp.la
 * @author 		Denis Pikusov
 *
 * Отображение новостей на сайте
 * Использует шаблон news.tpl для ленты новостей, и news_item.tpl для вывода одной новости
 *
 */
 
require_once('Widget.class.php');

class NewsLine extends Widget
{

	/**
	 *
	 * Конструктор
	 *
	 */
	function NewsLine(&$parent)
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
		// Какую новость нужно вывести?
		$news_url = $this->url_filtered_param('news_url');
		
		if (!empty($news_url))
		{
			if($this->settings->theme == 'api' || ctype_digit($news_url)){
				$news_url = $this->db->result("SELECT url FROM news WHERE news_id = '{$news_url}'")->url;
			}
			// Если передан url новости, выводим ее
			return $this->fetch_item($news_url);
		}
		else
		{
			// Если нет, выводим список всех новостей
			return $this->fetch_list();
		}
	}
	
	/**
	 *
	 * Отображение списка новостей
	 *
	 */	
	function fetch_list()
	{
        $period = "AND date < NOW()";
        if ($this->settings->theme == 'api') {
            if (isset($_GET['offset']) && $_GET['offset'] > 0){
                $period = (int)$_GET['offset'] + 1;
                $period_start = $period_end + 1;
                
                $period_end = date('Y-m', strtotime("-$period month")) . '-31 23:59:59';
                $period_start = date('Y-m', strtotime("-$period month")) . '-01 00:00:00';
            }else{
                $period_end = date('Y-m') . '-31  23:59:59'; 
                $period_start = date('Y-m', strtotime("-1 month")) . '-01 00:00:00';
            }
            $period = "AND `created` >= '{$period_start}' AND `created` <= '{$period_end}'";
        }
        
        // Выбираем новости из базы
        $this->db->query("SELECT *, DATE_FORMAT(created, '%d.%m.%Y') as Fdate FROM news WHERE enabled=1 {$period} ORDER BY created DESC");
		$news = $this->db->results();
		
		if ($this->settings->theme == 'api') {
			foreach($news as $item){
				unset($item->url,$item->date,$item->enabled,$item->meta_title,$item->meta_keywords,$item->meta_description,$item->editor_id,$item->created,$item->modified);
				$search = array("</p>", "\n", "\r");
        $replace = array('\n ', ' ', '');
        $item->body = strip_tags(str_replace($search, $replace, $item->body));	
				$item->image = !empty($item->image) ? 'https://lsboutique.ru/files/news/'.$item->image : '';
			}
			
			$return->news = $news;
			$return = json_encode($return);
			header('Content-Type: application/json');
			echo $return;
			die();
		}
		
		// Передаем в шаблон
		$this->smarty->assign('news', $news);
		$this->body = $this->smarty->fetch('news.tpl');
		
		// Устанавливаем метатеги для ленты новостей (если она вызвана как голый модуль)
		$this->smarty->assign('title', 'Новости');
		
		return $this->body;
	}
	
	/**
	 *
	 * Отображение отдельной новости
	 *
	 */	
	function fetch_item($url)
	{
		// Выбираем новость из базы
		$query = sql_placeholder('SELECT *, DATE_FORMAT(date, \'%d.%m.%Y\') as Fdate FROM news WHERE url = ? AND enabled=1 AND date <= now() LIMIT 1', $url);
		$this->db->query($query);
		
		// Если не существует такая новость - ошибка 404
		if ($this->db->num_rows() == 0)
		{
			return false;
		}
		
		$item = $this->db->result();
		
		if ($this->settings->theme == 'api') {
			unset($item->url,$item->enabled,$item->meta_title,$item->meta_keywords,$item->meta_description,$item->editor_id,$item->created,$item->modified);
			$search = array("</p>", "\n", "\r");
      $replace = array('\n ', ' ', '');
      $item->body = strip_tags(str_replace($search, $replace, $item->body));	
      $item->image = 'https://lsboutique.ru/files/news/'.$item->image;            
			
      if($this->settings->theme_v == 'v2'){$return->obj[0] = $item;}
      else{$return->item = $item;}
			
      if($this->settings->theme_v == 'v2'){
        $return = $this->format_api_response($return);
      }
			$return = json_encode($return);
			header('Content-Type: application/json');
			echo $return;
			die();
		}
		
        if (isset($item->image)&&($item->image !='')) {
            $item->image = 'https://lsboutique.ru/files/news/'.$item->image;
        }
        
		$this->smarty->assign('title', $item->meta_title);
		$this->smarty->assign('meta_keywords', $item->meta_keywords);
		$this->smarty->assign('meta_description', $item->meta_description);
		
		// Передаем в шаблон
		$this->smarty->assign('news_item', $item);
		$this->body = $this->smarty->fetch('news_item.tpl');
		return $this->body;
	}
}

