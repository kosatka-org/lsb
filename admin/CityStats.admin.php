<?PHP

require_once('Widget.admin.php');
require_once('../placeholder.php');


############################################
# Class EditServiceSection - edit the static section
############################################
class CityStats extends Widget
{
	var $item;
	function CityStats(&$parent)
	{
		Widget::Widget($parent);
	}

	function get_city_total($city_id, $product_status = 'accepted', $daterange = '') {
		if ($product_status == 'accepted') {
			$p_st = 5;
		}
		elseif ($product_status == 'rejected') {
			$p_st = 4;
		}
		return $this->db->result("SELECT SUM( price ) AS sum
			FROM  `orders_products` op
			INNER JOIN  `orders` o ON o.order_id = op.order_id
			WHERE o.city_id = {$city_id} {$daterange}
			AND op.status = {$p_st}")->sum;
	}

	function fetch()
	{

		exit();

		/*
		if ( isset($_POST['date_range']) ) {
			$date = explode(" - ", $_POST['date_range']);
			$daterange = " AND o.date > '{$date[0]}' AND o.date < '{$date[1]}' ";
		}
		else {
			$daterange = '';
		}

		$cities = $this->db->results("SELECT o.city_id, SUM( price ) AS sum, o.city AS name,
			COUNT( DISTINCT o.order_id ) AS total_orders, COUNT( * ) AS total_order_products
			FROM  `orders_products` op
			INNER JOIN  `orders` o ON o.order_id = op.order_id
			WHERE o.city_id !=0 AND op.status IN (4,5) {$daterange}
			GROUP BY o.city_id
			ORDER BY o.city ASC");

		foreach ($cities as $i => $city) {
			$cities[$i]->accepted = $this->get_city_total($city->city_id, 'accepted', $daterange);
			$cities[$i]->rejected = $this->get_city_total($city->city_id, 'rejected', $daterange);
			$cities[$i]->rejected_percent = $cities[$i]->rejected * 100 / $cities[$i]->sum;
		}

		$js = "<script>
			$(document).ready(function() {
			  $('input[name=\"date_range\"]').daterangepicker({format: 'YYYY-MM-DD'});
			});
			</script>";
		$this->smarty->assign('Modernjs', 'true');
		$this->smarty->assign('JavaScript', $js);
		$this->smarty->assign('cities', $cities);
		$this->smarty->assign('daterange', $daterange);
		$this->body = $this->smarty->fetch('citystats.tpl');
		*/
	}
}
