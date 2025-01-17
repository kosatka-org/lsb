<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocompleteNew.js"></script>
<link media="all" href="/jscript/jquery.autocompleteNew.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/javascript">
function clearText(thefield){
		if (thefield.defaultValue==thefield.value)
		thefield.value = "";
	}
	
jQuery(document).ready(function() {
	if ( jQuery("#id_card_number").autocomplete ) { 
		jQuery("#id_card_number").autocomplete({
			 source: '/index.php?module=Cart&card_select', 
			 minLength:3,
			 appendTo: '.ShAA_personCard'
		});
		
		jQuery("#client_info").autocomplete({
			 source: '/index.php?module=Cart&person_select', 
			 minLength:3,
			 appendTo: '.ShAA_person'
		});
	}
	jQuery(".imit_select").click(function() {
		jQuery(this).next(".drop_wrap").slideToggle();
	});
});

</script>
{/literal}

{literal}
<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-left {
		display: none !important;
	}
	#fancybox-right {
		display: none !important;
	}
	
	#fancybox-content {
		margin-left: 110px;
	}
	
	#fancybox-content div {
		overflow: visible !important;
	}
	
	#fancybox-wrap {
		top: 75px !important;
	}
	#fancybox-overlay {
		opacity: 0 !important;
	}
	
	.ShAA_popBackCenter {
		background: none repeat scroll 0 0 #fff;
		border: 1px solid #ccc;
		border-radius: 10px;
		padding: 20px;
		padding: 20px 0;
		color: #787878 !important;
	}
	
	.ui-widget-content {
		background: #fff !important;
		height: auto !important;
		width: auto !important;
	}
	
	.ShAA_person ul {
		box-shadow: 0 0px, 0 0px, 0 7px 6px 0 #787878, 0 0px, 0 0;
		margin: -50px 0 0 -9px;
		padding-bottom: 12px;
		border-radius: 0 0 3px 3px;
	}
	
	.ui-menu-item a:hover {
		background: #787878 !important;
		padding: 2px;
	}
	
	.ShAA_pop_title {
		font-weight: bold;
		color: #787878;
	}
	
	.cities input {
		colot: #787878;
		height: 28px;
		border-radius: 3px;
		border: 1px solid #ccc;
		padding: 6px 12px;
		width: 430px;
		box-shadow: 0 6px 14px -10px #787878 inset;
	}
	
	.ShAA_popTitleInput {
		font-size: 14px !important;
	}
	.ShAA_popTitleInput a {
		font-size: 14px !important;
	}
	
	.ShAA_settingContent {
		float: left;
		margin: 9px 0 9px 30px;
		width: 656px;
	}
	
	.ShAA_popDataSett {
		width: 100%;
	}
</style>
{/literal}

<div class="ShAA_popBackCenter">
	<div class="ShAA_settingContent">
		<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -10px 12px 0 0;" width="16" /></a>
		<div class="ShAA_settingTabs">
			<form autocomplete="off" action="/index.php?module=Cart&client_find&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'))" method="post" name="client_add" id="client_add" enctype="multipart/form-data">
				<div class="ShAA_pop_title">ВЫБЕРИТЕ ВАШ ГОРОД</div>
				<div class="ShAA_popData ShAA_popDataSett">
					<div class="ShAA_popTitleInput">
						Это позволит получать точную информацию о <a href="/sections/shipping" target="_blank">доставке товаров</a>
					</div>		
<!--					
					<div class="ShAA_person cities" style="float: left; margin-right: 10px; margin-top: 24px;">
						<input type="text" name="client_info" id="client_info" value="" />
					</div>
					<div style="float: right; margin: 36px 0 0 0;">
						<a href="#" style="color: #787878; border-bottom: 2px solid #787878; font-weight: bold;">
							Это мой город
						</a>
					</div>
					<div class="clear"></div>
-->
				</div>
<!--
				<div class="clear"></div>
				<div class="ShAA_popResult">
				</div>
-->
				<div class="ShAA_popData ShAA_popDataSett">
					<div class="imit_select_wrap" >
						<div class="imit_select" >
							Выберите город <div class="arr"></div>
						</div>
						<div class="drop_wrap" style="overflow-x:hidden!important;overflow-y:auto!important;">
							{foreach from=$delivery_cities item=city}
								<div class="drop"><a href="/?REGION={$city->region_id},209,{$city->city_id}">{$city->name}</a></div>
							{/foreach}
						</div>
					</div>
				</div>
				<div class="ShAA_cityNamesBlock">
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">В</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=64,209,1633">Владикавказ</a></div>
							<div><a href="/?REGION=12,209,286">Волгоград</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">Е</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=73,209,1587">Екатеринбург</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">К</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=65,209,1726">Казань</a></div>
							<div><a href="/?REGION=27,209,642" style="color: #444; font-size: 18px;">Киров</a></div>
							<div><a href="/?REGION=30,209,735">Краснодар</a></div>
							<div><a href="/?REGION=31,209,785">Красноярск</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">М</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=57,209,398">Махачкала</a></div>
							<div><a href="/?REGION=40,209,992" style="color: #444; font-size: 18px;">Москва</a></div>
						</div>
					</div>
					<div class="clear"></div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">Н</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=43,209,1054" style="color: #444; font-size: 18px;">Нижний Новгород</a></div>
							<div><a href="/?REGION=45,209,1145">Новосибирск</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">О</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=46,209,1176">Омск</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">Р</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=68,209,1387">Ростов-на-Дону</a></div>
							<div><a href="/?REGION=69,209,1448">Рязань</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">С</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=70,209,1472">Самара</a></div>
							<div><a href="/?REGION=35,209,893" style="color: #444; font-size: 18px;">Санкт-Петербург</a></div>
							<div><a href="/?REGION=75,209,1674">Ставрополь</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">Т</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=79,209,1781">Тверь</a></div>
							<div><a href="/?REGION=83,209,1907">Тюмень</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">Ч</div>
						<div class="ShAA_cityName">
							<div><a href="/?REGION=91,209,2011">Челябинск</a></div>
							<div><a href="/?REGION=24,209,591">Черкесск</a></div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="clear"></div>
</div>

<!-- end Настройки - Ключи - Инфо -->

