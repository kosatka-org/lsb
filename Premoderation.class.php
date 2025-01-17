<?PHP

require_once('Widget.class.php');


class Premoderation extends Widget
{
    function Premoderation(&$parent)
    {
        Widget::Widget($parent);
    }

    function fetch()
    {
        if (!in_array($_SESSION['user']->group_id, [2,6,10,12])) {
            header("Location: /");
            exit();
        }

        if (isset($_GET['premoderation_item_query'])) {
            $q = $this->db->escape(trim($_GET['premoderation_item_query']));
            $item = $this->db->results("SELECT * FROM premoderation_items WHERE (ean = '{$q}' OR barcode = '{$q}') AND quantity_accepted < quantity LIMIT 1");
            header('Content-Type: application/json');
            if ($item) {
              exit(json_encode($item));
            }
            else {
              $items = $this->db->results("SELECT * FROM premoderation_items WHERE sku_search LIKE '%{$q}%' AND quantity_accepted < quantity");
              exit(json_encode($items));
            }
        }

        if (isset($_POST['product'])) {
            $data = json_decode($_POST['product'], true);
            $this->db->query("UPDATE premoderation_items SET name = '{$data['name']}', color = '{$data['color']}', sex = '{$data['sex']}', material = '{$data['material']}', supplier = '{$data['supplier']}' WHERE code={$data['code']}");
            foreach ($data['items'] as $item) {
              if ($item['quantity'] > 0) {
                $this->db->query("UPDATE premoderation_items SET size = '{$item['size']}', accepted_at = NOW(), accepted_user_id = {$_SESSION['user']->user_id}, accepted = 1, quantity_accepted = LEAST((quantity_accepted + {$item['quantity']}), quantity) WHERE barcode={$item['barcode']}");
              }
            }
            header('Content-Type: application/json');
            exit(json_encode($this->db->results("SELECT * FROM premoderation_items WHERE DATE(accepted_at) = CURDATE() AND accepted_user_id = {$_SESSION['user']->user_id} ORDER BY accepted_at")));
        }

      $this->smarty->assign('accepted_today', json_encode($this->db->results("SELECT * FROM premoderation_items WHERE DATE(accepted_at) = CURDATE() AND accepted_user_id = {$_SESSION['user']->user_id} ORDER BY accepted_at")));
      $this->body = $this->smarty->fetch('premoderation.tpl');
      return $this->body;
    }
}
