<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');

// Этот класс выбирает модуль в зависимости от параметра Section и выводит его на экран
class Page extends Widget
{
    // Модуль (пока неизвестно какой)
    var $module;
    var $allowed_modules = array("MainPage", "Sections", "Section", "Analytics", "ManagersStatistics",
                                 "NewsLine", "NewsItem", "Cities", "City", "CityStats", "Articles", "Article", "Specials", "Special", "Swd", "SaleSettings", "Sets", "Video",
                                 "Storefront", "Product", "Categories", "Category", "Brands", "Banners", "Brand", "Colors", "Color", "Shops", "Warehouses", "Cashboxes", "Collections", "Storis",
                                 "Oneclick", "Feedback",
                                 "Orders", "Aorders", "Order", "Users", "User", "Groups", "Group", "Special_orders",
                                 "Import", "Export", "Calls",
                                 "Themes", "Templates", "Styles", "Images",
                                 "Backup", "Setup", "Currency", "DeliveryMethods", "DeliveryMethod", "DeliveryCompanies", "DeliveryCompany", "PaymentMethods", "PaymentMethod", "Delivery_to_TK",
                                 "Properties", "Property", "Faqs", "Faq", "Goods", "Good", "Materials", "Material", "Coupons", "Coupon", "OrdersSearch", "FinanseStat", "CopywriterTasksManager", "CopywriterTaskManager", "CopywriterStat", "CopywriterTasks");

    // Конструктор
    function Page(&$parent)
    {
        // Вызываем конструктор базового класса
        parent::Widget($parent);

        $this->add_param('section');

        // Берем название модуля из get-запроса
        $section = $this->param('section');

        $user_obj = new luser();
        if ( empty($_SESSION['user']->user_id) && !empty($_COOKIE['user_id']) && !empty($_COOKIE['hashcode']) ) {
            $params = array(    'user_id'       => $_COOKIE['user_id'],
                                'password'      => $_COOKIE['hashcode'] );
            $user_cookie = $user_obj->found($params, false);
            if ( !empty($user_cookie->original_user_id) ) {
                $user_obj->login($user_cookie->original_user_id);
            }
        }
        if( isset($_SESSION['user']) ) {
            if ( !$user_obj->check_user(array(
                'phone_number' => $_SESSION['user']->phone_number,
                'card_number'  => $_SESSION['user']->card_number,
                'user_id'      => $_SESSION['user']->user_id,
                'password'     => $_SESSION['user']->password)) ) {
                $user_obj->logout();
                header("Location: /");
                die();
            }
        }

        $sections = array(
            'Orders'    => array('transport', 'manager', 'admin', 'moderator'),
            'Order'     => array('transport', 'manager', 'admin', 'accountant'),
            'default'   => array('admin', 'moderator', 'copywriter', 'manager', 'accountant')
        );


        $allow = false;
        if ( isset($sections[$section]) ) {
            foreach ( $sections[$section] as $resource ) if ( luser::is_allowed($resource) ) {
                $allow = true;
            }
        }
        else {
            foreach ( $sections['default'] as $resource ) if ( luser::is_allowed($resource) ) {
                $allow = true;
            }
        }

        if ( !$allow ) {
            header('Location: /');
            die();
        }

        $user_obj->log_action();

        if(in_array($_SESSION['user']->user_id,array(4877,16114,14))){
          array_push($this->allowed_modules, 'Statistics');
        }
        // Если запросили недопустимый модуль - используем модуль MainPage
        if (empty($section) || !in_array($section, $this->allowed_modules) || !luser::is_allowed_section($section)) {
            if (isset($_SESSION['delivery_agent']) ) {
                $section = "Orders";
            }
            elseif ($_SESSION['group']->group_id == 6) {
                $section = "Aorders";
            }
            else {
                $section = 'MainPage';
            }
        }

        // Подключаем файл с необходимым модулем
        require_once($section.'.admin.php');

        // Создаем соответствующий модуль
        if (class_exists($section)) {
            $this->module = new $section($this);
        }
        $this->smarty->assign("Site_name", 'lsboutique.ru');

        if(empty($_SESSION['group']->sections)){
            $user_allowed = $this->allowed_modules;
        }else{
            $user_allowed = explode(',', $_SESSION['group']->sections);
            if($_SESSION['user']->user_id == 12625){
              array_push($user_allowed,'Analytics','PaymentMethods');
            }
            if($_SESSION['user']->user_id == 16211){
              array_push($user_allowed,'Banners');
            }
            if($_SESSION['user']->user_id == 13556){
              array_push($user_allowed,'PaymentMethods');
            }
        }

        $this->smarty->assign("user_allowed", $user_allowed);

        $copywriters = new copywriters();
        $is_copywriter = $copywriters->get_copywriter($_SESSION['user']->user_id) ? true : false;
        $this->smarty->assign('is_copywriter', $is_copywriter);
    }

    function fetch()
    {
        $this->module->fetch();
        $this->smarty->assign("Title",          $this->module->title);
        $this->smarty->assign("Keywords",       $this->module->keywords);
        $this->smarty->assign("Description",    $this->module->description);
        $this->smarty->assign("Body", $this->module->body);
        if (isset($_SESSION['delivery_agent'])) {
            $this->smarty->assign("DeliveryAgent", $_SESSION['delivery_agent']);
        }

        $this->body = $this->smarty->fetch('index.tpl');
    }
}
