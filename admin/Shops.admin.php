<?PHP

require_once('Widget.admin.php');
require_once('PagesNavigation.admin.php');

class Shops extends Widget
{

    function Shops(&$parent)
    {
        Widget::Widget($parent);
    }

    function fetch()
    {
        if ($_POST['shop_id']) {
            $shop = $this->db->result("SELECT * FROM shops WHERE shop_id = {$_POST['shop_id']}");

            $url = isset($_POST['url']) ? $_POST['url'] : $shop->url;
            $name = isset($_POST['name']) ? $_POST['name'] : $shop->name;
            $address = isset($_POST['address']) ? $_POST['address'] : $shop->address;
            $enabled = isset($_POST['enabled']) ? $_POST['enabled'] : 0;

            $this->db->query("UPDATE shops SET
                url = '{$url}',
                address = '{$address}',
                name = '{$name}',
                enabled = {$enabled}
                WHERE shop_id = {$shop->shop_id}");
        }
        $shops = $this->db->results("SELECT * FROM shops WHERE 1");

        $this->smarty->assign('Shops', $shops);
        $this->smarty->assign('Modernjs', 'true');
        $this->smarty->assign('Lang', $this->lang);
        $this->body = $this->smarty->fetch("shops.tpl");
    }
}

