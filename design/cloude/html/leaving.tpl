<script type="text/javascript" src="/jscript/owl.carousel.js"></script>
<link media="all" href="/jscript/owl.carousel.css" rel="stylesheet" type="text/css" />
<link media="all" href="/jscript/owl.theme.css" rel="stylesheet" type="text/css" />
<div class="fullfield">
	<div class="ShAA_popBackCenter">
		
			<link href='//fonts.googleapis.com/css?family=Roboto:400,500&subset=cyrillic' rel='stylesheet' type='text/css'>
			
			{if $set}
			<div id="set_products"style="padding:4%;width: 92%;">
				<div style="font-weight: normal; margin: 26px 0; text-align: center; text-transform: uppercase;">
					<div class="ShAA_styleManPhoto">
						<img src="/design/adaptive/images/style_man.jpg" title="Стилист Лакшери Store" alt="Стилист Лакшери Store" />
					</div>
					<!--<b>Игорь Франц</b>--><br />Стилист Лакшери Store<br /> рекомендует Вам
				</div>
				<a title="Посмотреть полный образ" href="/look/{$set[0]->set_id}">
					<div class="ShAA_oneClickAddOld" style="float: none; margin: 0 auto 12px;">Полный образ</div>
				</a>
				<div class="products">
					{include file="items_json.tpl" wallproducts=$set}
				</div>
			</div>
			{/if}
		
		<div class="clear"></div>
	</div>
</div>

{literal}
<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-title {
		display: none !important;
	}
	#fancybox-wrap{
		min-width: 352px!important;
		width: 80%!important;
		max-width: 652px!important;
	}
	#fancybox-content{
		min-width: 352px!important;
		width: 100%!important;
		max-width: 652px!important;
	}
	.ShAA_popBackCenter{
		min-width: 350px!important;
		width: 99.5%!important;
		max-width: 650px!important;
	}
	#fancybox-close {background:url(/jscript/fancybox/image/fancy_close.png);background-size:cover;}
	.ShAA_popDataSett {
		margin: 12px 0 6px 0;
	}
	.ShAA_catalogItem_new{min-height: 400px;width: 33%;}
</style>
{/literal}