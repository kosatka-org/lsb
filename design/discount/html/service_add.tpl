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

	jQuery("#service_add").validationEngine();
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
	
	#fancybox-content div {
		overflow: visible !important;
	}
	.ui-menu .ui-menu-item {
		background: #fff;
	}
	.ui-widget-content {
		background: none !important;
	}
</style>
{/literal}
<div class="ShAA_popBackTop"></div>
<div class="ShAA_popBackCenter">
	<div class="ShAA_settingContent">
		<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -10px -43px 0 0;" width="16" /></a>
		<div class="ShAA_settingTabs">
			<div>
				<form autocomplete="off" action="" method="post" name="service_add" id="service_add" enctype="multipart/form-data">
					<div class="ShAA_servAdd">
						<a href="#" onclick="{literal}addClothier();{/literal}" class="ShAA_popButton notUnderline" style="margin:0px;">
							Услуги портных
						</a>
					</div>
					<div class="ShAA_servAdd">
						<a href="#" onclick="{literal}addShoes();{/literal}" class="ShAA_popButton notUnderline" style="margin:0px;">
							Обувная мастерская
						</a>
					</div>
					<div class="ShAA_servAdd" style="margin-right: 0; float: right;">
						<a href="#" onclick="{literal}addCleaning();{/literal}" class="ShAA_popButton notUnderline" style="margin:0px;">
							Хим.чистка
						</a>
					</div>
{literal}
<script>
	function addClothier(){ 
		$('.ShAA_serviceBlock').append('<div class="ShAA_popData ShAA_popDataSett" style="clear: both;"><div class="ShAA_servAddLeft"><div class="ShAA_popTitleInput">Услуги портных</div><div class="ShAA_popInput"><select name="add_clothier">{/literal}{foreach from=$atelier_items item=item key=key name=atelier_items}<option selected value="{$item->id}">{$item->name} - {$item->price}</option>{/foreach}{literal}</select></div></div><div class="ShAA_servAddLeft"><div class="ShAA_popTitleInput">Комментарий</div><textarea></textarea></div><div class="ShAA_popTitleInput"><a onclick="$(this).parent().parent().hide();"><img width="16" style="margin: 32px -43px 0 0;" src="/images/pop_close.png"></a></div></div>');
	}
	function addShoes(){ 
		$('.ShAA_serviceBlock').append('<div class="ShAA_popData ShAA_popDataSett" style="clear: both;"><div class="ShAA_servAddLeft"><div class="ShAA_popTitleInput">Обувная мастерская</div><div class="ShAA_popInput"><select name="add_shoes">{/literal}{foreach from=$shoes_items item=item key=key name=shoes_items}<option selected value="{$item->id}">{$item->name} - {$item->price}</option>{/foreach}{literal}</select></div></div><div class="ShAA_servAddLeft"><div class="ShAA_popTitleInput">Комментарий</div><textarea></textarea></div><div class="ShAA_popTitleInput"><a onclick="$(this).parent().parent().hide();"><img width="16" style="margin: 32px -43px 0 0;" src="/images/pop_close.png"></a></div></div>');
	}
	function addCleaning(){ 
		$('.ShAA_serviceBlock').append('<div class="ShAA_popData ShAA_popDataSett" style="clear: both;"><div class="ShAA_servAddLeft"><div class="ShAA_popTitleInput">Хим.чистка</div><div class="ShAA_popInput"><select name="add_cleaning">{/literal}{foreach from=$clean_items item=item key=key name=clean_items}<option selected value="{$item->id}">{$item->name} - {$item->price}</option>{/foreach}{literal}</select></div></div><div class="ShAA_servAddLeft"><div class="ShAA_popTitleInput">Комментарий</div><textarea></textarea></div><div class="ShAA_popTitleInput"><a onclick="$(this).parent().parent().hide();"><img width="16" style="margin: 32px -43px 0 0;" src="/images/pop_close.png"></a></div></div>');
	}
</script>
{/literal}
					<div class="ShAA_serviceBlock"></div>
					
					<div id="client_search_add">
						<div class="ShAA_pop_title" style="clear: both; margin-top: 30px; float: left;">Укажите известную Вам информацию о клиенте</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								Телефон, почта или Имя владельца карты
							</div>
							
							<div class="ShAA_popInput ShAA_person phone" style="float: left; margin-right: 8px;">
								<input type="text" name="client_info" id="client_info" value="" />
							</div>
							<div style="float: left;">
								<a href="#" onclick="{literal}jQuery('.ShAA_popResult').load('/index.php?module=Cart&client_find&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'));return false;{/literal}" class="notUnderline">
									<input class="ShAA_popButton_input" value="Найти" />
								</a>
								<a href="#" onclick="{literal}jQuery('#client_add_div').show();jQuery('#client_search_add').hide();{/literal}" class="ShAA_popButton notUnderline" style="margin:0px;">
									Добавить клиента
								</a>
							</div>
							<div class="clear"></div>
							<div class="ShAA_popInfoInput">
								пример: 9206003322, name@mail.com или Иванов Петр Сергеевич
							</div>
						</div>
						<div class="clear"></div>
						<div class="ShAA_popResult"></div>
					</div>
					
					<div id="client_add_div" style="display: none; clear: both; margin-top: 30px; float: left;">
						<div class="ShAA_pop_title">Укажите информацию о новом клиенте</div>
						<div class="ShAA_settingLeftBlock">
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Имя Отчество
								</div>
								<div class="ShAA_popInput">
									<input placeholder="Имя Отчество" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value="" />
								</div>
								<div class="ShAA_popInfoInput">
									пример: Петр Сергеевич
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Фамилия
								</div>
								<div class="ShAA_popInput">
									<input placeholder="Фамилия" type="text" name="surname" id="surname" {literal}class="validate[required]"{/literal} value="" />
								</div>
								<div class="ShAA_popInfoInput">
									пример: Иванов
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Телефон
								</div>
								<div class="ShAA_popInput phone">
									<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]],custom[number]"{/literal} value="" maxlength="10" />
								</div>
								<div class="ShAA_popInfoInput">
									пример: 9206003322
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Почта
								</div>
								<div class="ShAA_popInput">
									<input placeholder="Электронная почта" type="text" name="email" id="email" {literal}class="validate[custom[email]]"{/literal} value="" />
								</div>
								<div class="ShAA_popInfoInput">
									пример: name@gmail.com
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Дата рождения
								</div>
								<div class="ShAA_popInput">
									<input placeholder="дд.мм.гггг" type="text" name="birthday" id="birthday" value="" />
								</div>
								<div class="ShAA_popInfoInput">
									пример: 10.05.1979
								</div>
							</div>
							<!--<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Комментарий (по желанию)
								</div>
								<div class="ShAA_popInput">
									<input placeholder="Произвольно" type="text" name="comment" id="comment" value="">
								</div>
							</div>-->
						</div>
						
						<div class="ShAA_settingRightBlock">
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Персональная карта
								</div>
								<div class="ShAA_popInput ShAA_personCard">
									<input placeholder="Номер дисконтной карты" type="text" name="card_number" id="id_card_number" value="" />
								</div>
								<div class="ShAA_popInfoInput">
									Номер карты 16 &ndash; 22 цифры
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Бонус
								</div>
								<div class="ShAA_popInput">
									<select name="personal_discount">
										<option selected value="0">Нет необходимости</option>
										<option value="10">10</option>
										<option value="15">15</option>
										<option value="20">20</option>
										<option value="25">25</option>
										<option value="30">30</option>
									</select>
								</div>
								<div class="ShAA_popInfoInput">
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput" style="float: left;">
									Пол
								</div>
								<div class="" style="float: left; margin: 0 10px;">
									<span class="ShAA_popSex">М</span><input class="sex" name="sex" type="radio" value="1" checked style="float: left;">
									<span class="ShAA_popSex">Ж</span><input class="sex" name="sex" type="radio" value="2" style="float: left;">
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Магазин
								</div>
								<div class="ShAA_popInput">
									<select name="shop">
										<option value="">Не выбран</option>
										{foreach from=$shops item=shop}
											<option value="{$shop->name}" {if $default_store == $shop->name}selected{/if}>{$shop->name}</option>
										{/foreach}
									</select>
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Размеры
								</div>
								<div class="ShAA_popInfoInput popSize" style="margin-left: 0;">
									верх
								</div>
								<div class="ShAA_popInputMini">
									<select name="sizetop">
										<option selected value="">---</option>
										{foreach from=$sizes item=size}
											<option value="{$size->size}">{$size->size}</option>
										{/foreach}
									</select>
								</div>
								<div class="ShAA_popInfoInput popSize">
									низ
								</div>
								<div class="ShAA_popInputMini">
									<select name="sizebottom">
										<option selected value="">---</option>
										{foreach from=$sizes item=size}
											<option value="{$size->size}">{$size->size}</option>
										{/foreach}
									</select>
								</div>
								<div class="ShAA_popInfoInput popSize">
									обувь
								</div>
								<div class="ShAA_popInputMini">
									<select name="sizeshoe">
										<option selected value="">---</option>
										{foreach from=$shoesizes item=size}
											<option value="{$size->size}">{$size->size}</option>
										{/foreach}
									</select>
								</div>
							</div>
						</div>
						<div class="clear"></div>
						<div style="margin: 32px 0 0 0;">
							<input id="save_client" type="submit" value="Сохранить" class="ShAA_popButton_input">
							<a class="ShAA_popButton notUnderline" onclick="{literal}jQuery('#client_add_div').hide();jQuery('#client_search_add').show();{/literal}">Отменить</a>
						</div>
					</div>

					<div class="ShAA_popData ShAA_popDataSett">
						<div class="ShAA_popTitleInput">
							Продавец: {$smarty.session.user->name}
							<input name="shop_assistant" type="hidden" value="{$smarty.session.user->name}">
						</div>
					</div>
					<div style="margin: 32px 0 0 0; clear: both; float: left;">
						<input type="submit" value="Заказать услугу" class="ShAA_popButton_input" onclick="jQuery('#service_add').submit();return false;">
						<a onclick="{literal}jQuery.fancybox.close();{/literal}" class="ShAA_popButton notUnderline" style="margin:0px;">Отменить</a>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottom"></div>

<!-- end Настройки - Ключи - Инфо -->

{literal}
<script>
</script>
{/literal}