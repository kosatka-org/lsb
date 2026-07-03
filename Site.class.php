<?PHP

/**
 *
 * Этот класс использует шаблон index.tpl,
 * который содержит всю страницу кроме центрального блока
 * По get-параметру section мы определяем что сожержится в центральном блоке
 *
 */

// Как и все классы, наследуется от класса widget
require_once('Widget.class.php');

// Storefront нам понадобится для некоторых методов, связанных с товарами
require_once('Storefront.class.php');

class Site extends Widget
{
	var $main; // Центральный блок (класс). В данном случае он может быть разных классов, в зависимости от раздела
	var $categories; // Категории товаров
	var $articles_count = 5; // Количество свежих статей
	var $news_count = 5; // Количество свежих новостей
	var $section; // текущий раздел

	/**
	 *
	 * Конструктор
	 *
	 */
	function Site(&$parent)
	{
		Widget::Widget($parent);

		// Пока не знаем какого класса центральный блок, он будет базового класса
		$this->main = new Widget($this);

        // Категории товаров
		$this->categories = Storefront::get_categories();
		$this->smarty->assign('categories', $this->categories);

		// Разделы меню
		if($this->mobile_user)
			$this->db->query("SELECT * FROM sections WHERE enabled=1 AND menu_id=3 ORDER BY order_num");
		else
			$this->db->query("SELECT * FROM sections WHERE enabled=1 AND menu_id=2 ORDER BY order_num");

		$sections = $this->db->results();
		$this->smarty->assign('sections', $sections);

		// Бренды
		$query = sql_placeholder("SELECT brands.*, 1 as products_num FROM brands ORDER BY brands.name");
		$this->db->query($query);
		$allbrands = $this->db->results();
		$this->smarty->assign('all_brands', $allbrands);

		// Состояние корзины
		$this->cart_products_num = 0;
		$this->cart_total_price = 0;

		if (!empty($_SESSION['shopping_cart'])) {
			$products = Storefront::get_products(array_keys($_SESSION['shopping_cart']));
			if (is_array($products)) {
				foreach ($products as $k=>$product) {
					$products[$k]->amount = $_SESSION['shopping_cart'][$product->product_id] = min($_SESSION['shopping_cart'][$product->product_id], $product->quantity);
					// Добавим стоимость к общей сумме
					$this->cart_total_price += $product->discount_price*$products[$k]->amount;
					$this->cart_products_num += $products[$k]->amount;
				}
			}
		}
		$this->smarty->assign('cart_total_price',  $this->cart_total_price);
		$this->smarty->assign('cart_products_num', isset($_SESSION['shopping_cart']) && is_array($_SESSION['shopping_cart']) ? count($_SESSION['shopping_cart']) : 0);
		$this->smarty->assign('wl_products_num',   isset($_SESSION['wish_list']) && is_array($_SESSION['wish_list']) ? count($_SESSION['wish_list']) : 0);
        if ( isset($_SESSION['user']->original_user_id) ) {
            $this->smarty->assign('n_deposit',    $this->db->get_var(" SELECT deposit   FROM users WHERE user_id = '{$_SESSION['user']->original_user_id}' "));
            $this->smarty->assign('big_avatar',   $this->db->get_var(" SELECT photo     FROM users WHERE user_id = '{$_SESSION['user']->original_user_id}' "));
            $this->smarty->assign('small_avatar', $this->db->get_var(" SELECT photo_rec FROM users WHERE user_id = '{$_SESSION['user']->original_user_id}' "));
        }
		// Необходимо определить что выводить в центральном блоке.
		// Это может быть указано в качестве конкретного раздела сайта (section)
		// или в качестве указания модуля, который следует вывести
		// В первом случае мы узнаем из базы какого модуля нужный раздел
		// и создаем соотвествующий класс (например статическая страница или лента новостей)
		// а во втором - и узнавать ничего не надо, модуль по сути и есть класс
		// (ну почти, нужно только глянуть в таблице modules название класса для данного модуля, обычно оно совпадает)

		// итак, url текущего раздела (может быть не задан)
		$section_url = $this->url_filtered_param('section');

		// модуль (тоже может быть не задан)
		$module = $this->url_filtered_param('module');

		// если ничего не задано, текущим разделом будет раздел, заданный в настройках как главная страница
		if (empty($section_url) && empty($module)) {
			if ($this->settings->theme == "mobile") {
				if ($_SERVER['REQUEST_URI']=='/') {
					header("Location: /catalog/");
					die('ok');
				}
				else {
					$section_url = $this->settings->main_section;
				}
			}
			if ($this->settings->theme == "application") {
				if ($_SERVER['REQUEST_URI']=='/') {
					header("Location: /catalog/");
					die('ok');
				}
				else {
					$section_url = $this->settings->main_section;
				}
			}
			else {
				$section_url = $this->settings->main_section;
			}
		}

		// если url раздела задан,
		if (!empty($section_url))
		{
		    // выбираем из базы этот раздел
			$query = sql_placeholder("SELECT sections.section_id as section_id, modules.module_id, modules.class, sections.url, sections.body, sections.header, sections.module_id, sections.meta_title, sections.meta_description, sections.meta_keywords  FROM sections LEFT JOIN modules ON sections.module_id=modules.module_id WHERE sections.url=? limit 1", $section_url);
			$this->db->query($query);
			$this->section = $this->db->result();
			$this->smarty->assign('section', $this->section);

			//  Устанавливаем мета-теги, указанные в главном блоке
            $title = 'Ювелирные изделия - Svetlov Jewelry';

			$this->title =       isset($this->section->meta_title)      ? $this->section->meta_title       : $this->main->title;
			$this->keywords =    isset($this->section->meta_keywords)   ? $this->section->meta_keywords    : $this->main->keywords;
			$this->description = isset($this->section->meta_description)? $this->section->meta_description : $this->main->description;
			$this->smarty->assign('title',       $title);
			$this->smarty->assign('keywords',    "бутик, интернет магазин, фирменная одежда из Италии, фирменная одежда из Франции, бутик, Лакшери стор");
			$this->smarty->assign('description', "бутик, интернет магазин фирменной одежды из Италии и Франции - Лакшери стор");
		}

		if ($this->section->class == 'StaticPage') {
			list($sect) = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
			if ($sect == 'brandwall') {
				$this->section->class = 'Brandwall';
				$this->section->url   = 'brandwall';
			}
			if ( in_array($sect, array('catalog','categories','brands','specials', 'goods')) ) {
				$this->section->class = 'Catalog';
				$this->section->url   = 'catalog';
			}
		}

		// Если раздел с таким url действительно существует,
		if (!empty($this->section)) {

			if ($this->section->class == 'StaticPage' && $this->section->url == '404') { // Поищем такой url
				$url 		= trim(urldecode($_SERVER['REQUEST_URI']), '/');
				$product	= $this->db->result(sql_placeholder("SELECT * FROM products WHERE url=? LIMIT 1", $url));
				if ( !empty($product->product_id) ) { // Значит это левый 404
					header("Location: /products/{$product->url}/", true, 301);die();
				}
			}

		    // создадим класс этого раздела
			$class = $this->section->class;
			include_once("$class.class.php");
			if (class_exists($class)) {
				$_GET['section'] = $this->section->url;
				$this->main = new $class($this);
			}
			// возвращение false приводит к отображению 404 ошибки. Кстати это работает в любом модуле
			else return false;
		}
		// Если задан модуль, аналогично создаем нужный класс
		elseif(!empty($module)) {
			$query = sql_placeholder("SELECT class FROM modules WHERE modules.class=? LIMIT 1", $module);
			$this->db->query($query);
			$module = $this->db->result();

			if (!empty($module->class)) {
				$class = $module->class;
				include_once("$class.class.php");
				if (class_exists($class)) {
					$this->main = new $class($this);
				} else return false;
			} else return false;
		} else {
			return false;
		}
	}



	function fetch() {
		//если нажали 'все' в переключателе пола
		if(isset($_GET['allsex'])) {
			setcookie('sex', '0', time()+60*60*24*365, '/');
			$_COOKIE['sex'] = 0;
		}

		// Создаем основной блок страницы
		if (!$this->main->fetch()) {
			return false;
		}
		// Если у main установлен флаг single, значит страница состоит только из main, не обромляем ее ничем больше
		if (isset($this->main->single) && $this->main->single)
		{
			$this->body = $this->main->body;
			return $this->body;
		}
		else
		{
			$content = $this->main->body;


		}
		$this->smarty->assign('content', $content);

		// Создаем текущую страницу сайта
		$this->body = $this->smarty->fetch('index.tpl');
		return $this->body;
	}
}
