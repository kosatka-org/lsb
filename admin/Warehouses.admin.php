<?PHP

require_once('Widget.admin.php');

class Warehouses extends Widget
{

    function Warehouses(&$parent)
    {
        Widget::Widget($parent);
    }

    function fetch()
    {
        if ($_POST['warehouse_id']) {
            $warehouse = $this->db->result("SELECT * FROM warehouses WHERE warehouse_id = {$_POST['warehouse_id']}");

            $name = isset($_POST['name']) ? $_POST['name'] : $warehouse->name;
            $shop_id = isset($_POST['shop_id']) ? $_POST['shop_id'] : $warehouse->shop_id;
            $code = isset($_POST['code']) ? $_POST['code'] : $warehouse->code;
            $mvmt_enabled = isset($_POST['mvmt_enabled']) ? $_POST['mvmt_enabled'] : 0;
            $spam_enabled = isset($_POST['spam_enabled']) ? $_POST['spam_enabled'] : 0;
            $im_show      = isset($_POST['im_show']) ? $_POST['im_show'] : 0;
            $admin_only   = isset($_POST['admin_only']) ? $_POST['admin_only'] : 0;

            $this->db->query("UPDATE warehouses SET
                name = '{$name}',
                shop_id = {$shop_id},
                code = {$code},
                movement_enabled = {$mvmt_enabled},
                spam_enabled = {$spam_enabled},
                im_show = {$im_show},
                admin_only = {$admin_only}
                WHERE warehouse_id = {$warehouse->warehouse_id}");
        }

        $this->smarty->assign('warehouses', $this->db->results("SELECT * FROM warehouses WHERE 1"));
        $this->smarty->assign('shops', $this->db->results("SELECT * FROM shops WHERE 1"));
        $this->smarty->assign('Modernjs', 'true');
        $this->smarty->assign('Lang', $this->lang);
        $this->body = $this->smarty->fetch("warehouses.tpl");
    }
}
