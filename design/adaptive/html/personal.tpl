{if !$user}<div class="titleMain" style="text-align:left;"><a href="/cart/vk_auth/" id="vk_login_link" onclick="rG('USER_WANNA_LOGIN');return false;" title="Войдите на сайт, используя свой аккаунт в популярных соцсетях, и получите скидку">Получить скидку 10%</a></div>{/if}

{literal}
<script>
	jQuery(document).ready(function() {
		get_recomendations('#interesting_recomendations', 		'interesting', 		undefined, {limit:12});
		get_recomendations('#popular_recomendations', 			'popular', 			undefined, {limit:8});
		get_recomendations('#recently_viewed_recomendations', 	'recently_viewed', 	undefined, {limit:8});
	});
</script>
{/literal}

<div id="interesting_recomendations" style="display:none;">
	<div style="font-weight: normal; margin: 26px 0;">Вам это понравится</div>
	<div class="products"></div>
</div>

<div id="popular_recomendations" style="display:none;">
	<div style="font-weight: normal; margin: 26px 0;">Популярные товары</div>
	<div class="products"></div>
</div>

<div id="recently_viewed_recomendations" style="display:none;">
	<div style="font-weight: normal; margin: 26px 0;">Вы недавно смотрели</div>
	<div class="products"></div>
</div>