<?PHP

require_once('Widget.admin.php');

class Cashboxes extends Widget
{

    function Cashboxes(&$parent)
    {
        Widget::Widget($parent);
    }

    function fetch()
    {
        if ($_POST['cashbox_id']) {
            $cashbox = $this->db->result("SELECT * FROM shop_cashbox WHERE id = {$_POST['cashbox_id']}");

            $name = isset($_POST['name']) ? $_POST['name'] : $cashbox->name;
            $shop_id = isset($_POST['shop_id']) ? $_POST['shop_id'] : $cashbox->shop_id;
            $entity_id = isset($_POST['entity_id']) ? $_POST['entity_id'] : $cashbox->entity_id;
            $address = isset($_POST['address']) ? $_POST['address'] : $cashbox->address;
            $inn = isset($_POST['inn']) ? $_POST['inn'] : $cashbox->inn;
            $enabled = isset($_POST['enabled']) ? $_POST['enabled'] : 0;
            $brands = isset($_POST['brands']) ? implode(', ',$_POST['brands']) : '';
            $cb_payment_options = isset($_POST['payment_options']) ? implode(',',$_POST['payment_options']) : '';
            $device_uuid = isset($_POST['device_uuid']) ? $_POST['device_uuid'] : $cashbox->device_uuid;
            $code_1s = isset($_POST['code_1s']) ? $_POST['code_1s'] : $cashbox->code_1s;
            $imei = isset($_POST['imei']) ? $_POST['imei'] : $cashbox->imei;

            $this->db->query("UPDATE shop_cashbox SET
                name = '{$name}',
                shop_id = {$shop_id},
                entity_id = '{$entity_id}',
                address = '{$address}',
                inn = '{$inn}',
                device_uuid = '{$device_uuid}',
                imei = '{$imei}',
                code_1s = '{$code_1s}',
                enabled = {$enabled},
                brands = '{$brands}',
                payments_ids = '{$cb_payment_options}'
                WHERE id = {$cashbox->id}");
        }


        $cashboxes = $this->db->results("SELECT * FROM shop_cashbox WHERE 1");
        foreach ($cashboxes as $cashbox) {
            $cashbox->brands = explode(', ',$cashbox->brands);
            $cashbox->payment_options = explode(',',$cashbox->payments_ids);
        }
        $this->smarty->assign('brands', $this->db->results("SELECT * FROM `brands` ORDER BY name;"));
        $this->smarty->assign('payment_options', $this->db->results("SELECT * FROM `payment_offline`;"));
        $this->smarty->assign('cashboxes', $cashboxes);
        $this->smarty->assign('shops', $this->db->results("SELECT * FROM shops WHERE 1"));
        $this->smarty->assign('entities', $this->db->results("SELECT * FROM entities WHERE 1"));
        $this->smarty->assign('Modernjs', 'true');
        $this->smarty->assign('Lang', $this->lang);
        $this->body = $this->smarty->fetch("cashboxes.tpl");
    }
}
