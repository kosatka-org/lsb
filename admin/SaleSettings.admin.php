<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


class SaleSettings extends Widget
{
	var $item;
	function SaleSettings(&$parent)
	{
		Widget::Widget($parent);
		$this->prepare();
	}

	function prepare()
	{

		if ($_POST['data']) {
			$data = json_decode($_POST['data'], true);
			$brand_id = $data['brand_id'];
			foreach ($data['settings'] as $season => $season_data) {
				$r = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand_id} AND season = '{$season}'");
				if ($r) {
					$this->db->query("UPDATE sale_settings SET sale = {$season_data['sale']}, max_sale = {$season_data['max_sale']}, everyone = {$season_data['everyone']}, registered = {$season_data['registered']}, has_purchase = {$season_data['has_purchase']} WHERE id = {$r->id}");
				}
				else {
					$this->db->query("INSERT INTO sale_settings(brand_id, season, sale, max_sale, everyone, registered, has_purchase) VALUES ({$brand_id}, '{$season}', {$season_data['sale']}, {$season_data['max_sale']}, {$season_data['everyone']}, {$season_data['registered']}, {$season_data['has_purchase']})");
				}
			}
			exit('OK');
		}

		if ($_POST['update_prices']) {
			Job::push('RunScriptJob', array( 'script' => 'importlive' ));
			$this->smarty->assign('price_update', "Цены будут обновлены в течение минуты.");
		}

		$brands = $this->db->results("SELECT * FROM brands WHERE 1 ORDER BY name");
		foreach ($brands as $i => $brand) {
			$brand->next_season = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'next_season'");
			$brand->new_season = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'new_season'");
			$brand->previous_season = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'previous_season'");
			$brand->old_seasons = $this->db->result("SELECT * FROM sale_settings WHERE brand_id = {$brand->brand_id} AND season = 'old_seasons'");
		}
		$this->smarty->assign("brands", $brands);
	}

	function fetch() {
		$this->title = "Настройки отображения скидок";

		$this->smarty->assign('Error', $this->error_msg);
		$this->smarty->assign('Lang', $this->lang);
		$this->smarty->assign('Modernjs', 'true');
		$js = $this->smarty->fetch('sale_settings.js.tpl');
		$this->smarty->assign('JavaScript', $js);
		$this->body = $this->smarty->fetch('sale_settings.tpl');
	}
}
