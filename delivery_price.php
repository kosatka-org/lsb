<?php

// Вычислим стоимость доставки
$delivery_price = 1000;
$total_agent 	= 0;
$agent = array();
$agent[0] 		= 7.32;
$agent[1000] 	= 4.9;
$agent[3000] 	= 3.78;
$agent[5000] 	= 2.83;
$agent[8000] 	= 2.12;
$agent[15000] 	= 1.77;
$agent[25000] 	= 1.53;
foreach ($agent as $sum=>$percent) {
  if ( $sum <= $_GET['total']) {
	  $total_agent = floor($_GET['total'] * $percent / 100 + 0.5);
  }
}

@$res = simplexml_load_file($request = "http://www.cpcr.ru/cgi-bin/postxml.pl?TARIFFCOMPUTE_2&ToCity={$_GET['city_id']}|0&FromCity=1054|0&Weight={$_GET['weight']}&Amount={$_GET['total']}&Nature=2&BeforeSignal=1&PlatType=2&DuesOrder=0");
if ( !empty($res->Tariff) ) {
  foreach ($res->Tariff as $tariff) {
	  $delivery_price = $tariff->Total_Dost + $tariff->Insurance + $total_agent + 82 /*Фиксированный сбор за наложенный платеж*/;
	  if ($tariff->TariffType == '"ГЕПАРД-ЭКСПРЕСС"') {
		  break;
	  }			  
  }
}

$delivery_price = ceil($delivery_price / 10) * 10;

?>
<div class="ShAA_orderField">
	<div class="title">Доставка <?php echo $delivery_price;?> рублей</div>
</div>
