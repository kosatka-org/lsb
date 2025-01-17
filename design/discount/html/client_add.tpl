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



	jQuery('#promo_search').submit(function(e){

		e.preventDefault();

		promo_code = jQuery('#promo_code').val();

		if(promo_code == ''){
			jQuery('div.sett3 .response').html('');
				return;
			}

			jQuery.get('/ajax_check_promo.php', {'promo_code':promo_code, 'moder':1}, function(data){
				if(jQuery.isEmptyObject(data)){
					jQuery('div.sett3 .response').html('Промокод введен некорректно').css({'color':'#C30000'});
				}
				else {
					response_text = '';
					if(data.text != null) {
						response_text += data.text + '<br />';
					}
					if (data.type == 'percentage') {
						response_text += 'cкидка <b>'+data.value+'%</b>';
					}
					else {
						response_text += 'cкидка <b>'+data.value+' руб</b>';
					}

					//response_text += '<br />Начало - Конец: ' + data.date_start + ' ' + data.date_finish;
					response_text += '<br />действует до <b>' + data.date_finish + '</b>';
					if (data.card_number != null) {
						response_text += '<br />Карта: <b>' + data.card_number + '</b>';
					}
					//response_text += '<br />Использований: ' + data.num_uses;

					jQuery('div.sett3 .response').html(response_text).css({'color':'#000'});

				}
			});


		});

	jQuery("#client_add").validationEngine();
	jQuery("#form_deposit").validationEngine();

	jQuery('ul.tabsSett li').css('cursor', 'pointer');

	jQuery('ul.tabsSett.tabs1 li').click(function(){
		var thisClass = this.className.slice(0,5);
		jQuery('div.sett1').hide();
		jQuery('div.sett2').hide();
		jQuery('div.sett3').hide();
		jQuery('div.sett4').hide();
		jQuery('div.' + thisClass).show();
		jQuery('ul.tabsSett.tabs1 li').removeClass('tab-current');
		jQuery(this).addClass('tab-current');
	});

	if (jQuery("body").width() < 481) {
		jQuery("#fancybox-wrap").css('padding','0px !important');
		jQuery(".ShAA_popBackCenter").width(jQuery("body").width()-100);
		jQuery(".ShAA_popInput input").css('width','83%');
		jQuery(".ShAA_popInput textarea").css('width','83%');
		jQuery(".phone input").css('width','75%');
		jQuery("ul.tabsSett").css({'height':'auto', 'float':'left', 'width':'100%', 'marginBottom':'12px'});
	}
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
<div class="ShAA_popBackCenter">
	<div class="ShAA_loginBlock">
		<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right;" width="16" /></a>
		<div class="ShAA_settingTabs">
			<div>
				<ul class="tabsSett tabs1">
					<li class="sett1 tab-current" style="width: auto;"><a>Создать нового клиента</a></li>
					<li class="sett2" style="width: auto;"><a><nobr>Поиск клиента и отправка СМС</nobr></a></li>
					<li class="sett3" style="width: auto;"><a>Промокоды</a></li>
				</ul>
				<hr size="1" color="#dcdcdc">

				<form autocomplete="off" action="/index.php?module=Login&client_add" method="post" name="client_add" id="client_add" enctype="multipart/form-data">
					<div class="sett1">
						<div class="ShAA_pop_title">Укажите информацию о новом клиенте</div>
						<div>
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
									<input placeholder="Фамилия" type="text" name="surname" id="surname" value="" />
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
									Город
								</div>
								<div class="ShAA_popInput">
									<select name="city_id" id="city_id" class="validate[required]" {if $total < 10000}onchange="$('#delivery_area').html($('#delivery_area_holder').html());$('#delivery_area').load('/delivery_price.php?city_id=' + $('#city_id').eq(0).val() + '&total={$total}&weight={$weight}');"{/if}>
										<option value="0">Пожалуйста, выберите город</option>
										<option value="0"> </option>
										{foreach from=$delivery_cities_main item=delivery_city}
											<option value="{$delivery_city->city_id}" ><b>{$delivery_city->city_name}</b></option>
										{/foreach}
										<option value="0"> </option>
										{foreach from=$delivery_cities item=delivery_city}
											<option value="{$delivery_city->city_id}" >{$delivery_city->city_name}</option>
										{/foreach}
									</select>
								</div>
								<div class="ShAA_popInfoInput">
									&nbsp;
								</div>
							</div>
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popTitleInput">
									Адрес
								</div>
								<div class="ShAA_popInput">
									<input placeholder="Адрес" type="text" name="address" id="address" value="" />
								</div>
								<div class="ShAA_popInfoInput">
									пример: Ленина 10-22
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
									<select name="shop_id">
										<option value="">Не выбран</option>
										{foreach from=$shops item=shop}
											<option value="{$shop->shop_id}" {if $default_store == $shop->name}selected{/if}>{$shop->name}</option>
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
							<input type="submit" value="Сохранить" class="ShAA_popButton_input" onclick="jQuery('#client_add').submit();return false;">
							<a style="float: left; margin: 12px 0 24px 0;" onclick="{literal}jQuery.fancybox.close();{/literal}">Отменить</a>
							<div style="float: right; margin: 16px 4px 0 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">Подробно о персональных скидках</a></div>
						</div>
					</div>
				</form>
				<form autocomplete="off" action="/index.php?module=Cart&client_find&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'))" method="post" name="client_add" id="client_add" enctype="multipart/form-data">
					<div class="sett2">
						<div class="ShAA_pop_title">Укажите известную Вам информацию о клиенте</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								Телефон, почта или Имя владельца карты
							</div>

							<div class="ShAA_popInput ShAA_person phone" style="float: left; margin-right: 10px; width: 100%;">
								<input type="text" name="client_info" id="client_info" value="" />
							</div>
							<div class="ShAA_popInfoInput">
								пример: 9206003322, name@mail.com или Иванов Петр Сергеевич
							</div>
							<div style="float: left; width: 100%;">
								<a href="#" onclick="{literal}jQuery('.ShAA_popResult').load('/index.php?module=Cart&client_find&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'));return false;{/literal}" class="notUnderline" style="border-width:0px;">
									<input type="submit" id="client_info" class="ShAA_popButton_input" value="Найти" />
								</a>
								<a onclick="{literal}jQuery.fancybox.close();{/literal}" style="margin: 24px 0 0 0px; float: left;">
									Отменить
								</a>
							</div>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>
						<div class="ShAA_popResult">
						</div>
					</div>
				</form>
				<div class="sett3">
				<form id="promo_search" action="#">
					<div class="ShAA_pop_title">Поиск промокода</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popInput ShAA_person phone" style="float: left; margin-right: 10px; width: 100%;">
								<input type="text" id="promo_code" value="" placeholder="введите промокод для проверки"/>
							</div>
							<div style="float: left; width: 100%;">
								<input type="submit" class="ShAA_popButton_input" value="Найти" />
								<a onclick="{literal}jQuery.fancybox.close();{/literal}" style="margin: 24px 0 0 0px; float: left;">
									Отменить
								</a>
							</div>
							<div class="clear"></div>
							<div class="ShAA_popInfoInput">
							</div>
						</div>
						<div class="clear"></div>
						<div class="ShAA_popResult">
							<span class="response"></span>
						</div>
				</form>
				</div>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>