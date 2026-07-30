<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>Скидка выходного дня в Luxury Store</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href='//fonts.googleapis.com/css?family=Open+Sans:400,300,600&subset=latin,cyrillic-ext,cyrillic' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="/css/style_swd.css?v=1.05" type="text/css" />
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>
	<script src="/jscript/jquery.easing-1.3.js"></script>
	<link rel="stylesheet" media="all" href="/jscript/jquery.heroCarousel.css" type="text/css" />
	<script src="/jscript/jquery.heroCarousel-1.3.js"></script>
	
</head>
<body>
{literal}
<script>
	$(document).ready(function(){
		$('.hero-carousel').heroCarousel({
			easing: 'easeOutExpo',
			css3pieFix: true
		});
	});
</script>
{/literal}
	<div class="ShAA_topBlock">
		<a href="/"><div class="ShAA_logo"></div></a>
		<div class="ShAA_hotspot"></div>
		<div class="ShAA_topText">
			<div class="ShAA_swdText">#СВД</div>
			<div class="ShAA_sloganText">#скидка  #выходного  #дня</div>
			<div class="ShAA_dateText"><span>{$item->date}</span></div>
		</div>
	</div>
	<div class="ShAA_middleBlock">
	
		<div class="hero">
			<div class="hero-carousel">
				<article>
					<img src="/files/images/swd/{$item->promo_banner1}" alt="" width="628" height="285" />
				</article>
				<article>
					<img src="/files/images/swd/{$item->promo_banner2}" alt="" width="628" height="285" />
				</article>
				<article>
					<img src="/files/images/swd/{$item->promo_banner3}" alt="" width="628" height="285" />
				</article>
			</div>
		</div>
		<div class="contents">
			<div class="ShAA_info">
				Скидка Выходного Дня в Лакшери Стор<br>
				специальные цены на одежду и обувь {if $item->brands|count gt 3}{$item->brands[0]->name},<br> {$item->brands[1]->name}, {$item->brands[2]->name}, и других брендов.{else}{foreach from=$item->brands name="brands" item="brand"}<a href="/brands/{$brand->url}/" target="_blank">{$brand->name}</a>{if !$smarty.foreach.brands.last && $smarty.foreach.brands.total > 1},{/if}{if $smarty.foreach.brands.first}<br>{/if}{/foreach}{/if}<br>
				Только в эти выходные по специальной цене.<br>
				Следите за нами по хеш тэгу #СВД<br>
				в <a href="http://instagram.com/lsboutique.ru?ref=badge" target="_blank">Instagram</a>, <a href="https://plus.google.com/+LsboutiqueRu/posts" target="_blank">Google+</a>, <a href="https://www.facebook.com/lsboutiq" target="_blank">Facebook</a>, <a href="http://vk.com/lsboutiq" target="_blank">Vkontakte</a>.
				<div class="SWD_shadow"></div>
			</div>
		</div>
	</div>
	<div class="ShAA_bottomBlock">
		<a class="ShAA_intLink" href="/catalog/?category=sale&from=swd"><div class="ShAA_buttonInteresting">ИНТЕРЕСНО</div></a>
		<div class="ShAA_phone">8 831 430-36-30</div>
		<div class="ShAA_address">Нижневолжская набережная 8/7</div>
		<div class="instagram">
			<iframe src="http://www.intagme.com/in/?u=bHNib3V0aXF1ZV9ydXxpbnwxNTB8NHwzfHx5ZXN8NXx1bmRlZmluZWR8bm8=" allowTransparency="true" frameborder="0" scrolling="no" style="border:none; overflow:hidden; width:620px; height: 495px" ></iframe>
		</div>
	</div>
</body>
</html>