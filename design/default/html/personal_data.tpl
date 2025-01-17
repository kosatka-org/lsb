<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

<!-- Настройки - Ключи - Инфо -->
{literal}
<script>
function clearText(thefield){
		if (thefield.defaultValue==thefield.value)
		thefield.value = "";
	}
	
$(document).ready(function() {
	$("#personal_data").validationEngine();
	
	$('ul.tabsSett li').css('cursor', 'pointer');
		
	$('ul.tabsSett.tabs1 li').click(function(){
		var thisClass = this.className.slice(0,5);
		$('div.sett1').hide();
		$('div.sett2').hide();
		$('div.sett3').hide();
		$('div.sett4').hide();
		$('div.sett5').hide();
		$('div.' + thisClass).show();
		$('ul.tabsSett.tabs1 li').removeClass('tab-current');
		$(this).addClass('tab-current');
	});
	
	if ($("#stop").prop( 'checked' )){
		$('#subscriptions input').prop({'disabled': true});
	}
	$("#stop").change(function(){
		if ($(this).prop( 'checked' ) == true){
			$('#subscriptions input').prop({'disabled': true});
		}
		else {
			$('#subscriptions input').prop( "disabled", false );
		}
	});
	
	$("#name").focus();
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
	
	.sett3 {
		display: none;
	}
</style>
{/literal}
<div class="ShAA_popBackTop"></div>
<div class="ShAA_popBackCenter">
	<div class="ShAA_settingContent">
		<a onclick="{literal}$.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -10px -43px 0 0;" width="16"></a>
		<div class="ShAA_settingTabs">
			<div>
				<ul class="tabsSett tabs1">
					<li class="sett1 tab-current"><a>Настройки</a></li>
					<li class="sett2"><a>Ключи</a></li>
					<li class="sett3"><a>Инфо</a></li>
					<li class="sett4"><a onclick="{literal}rG('SUBSCRIBE_PERSONAL');return false;{/literal}">Подписки</a></li>
					<li class="sett5"><a>Размеры</a></li>
				</ul>
				<hr size="1" color="#dcdcdc">
				
				<form autocomplete="off" action="/cart/save_user/" method="post" name="personal_data" id="personal_data" enctype="multipart/form-data">
				<div class="sett1">
					<div class="ShAA_pop_title">Укажите актуальную информацию о себе</div>
					<div class="ShAA_settingLeftBlock">
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								Обращение
							</div>
							<div class="ShAA_popInput">
								<input placeholder="Ф.И.О." type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value="{$smarty.session.user->name}" autofocus/>
							</div>
							<div class="ShAA_popInfoInput">
								пример: Иванов Петр Сергеевич
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								Номер телефона
							</div>
							<div class="ShAA_popInput phone">
								<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]],custom[number]"{/literal} value="{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}" maxlength="10" />
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
								<input placeholder="Электронная почта" type="text" name="email" id="email" {literal}class="validate[custom[email]]"{/literal} value="{if $smarty.session.user->email}{$smarty.session.user->email}{else}{/if}">
							</div>
							<div class="ShAA_popInfoInput">
								пример: name@mail.com
							</div>
						</div>
					</div>
					
					<div class="ShAA_settingRightBlock">
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								Город
							</div>
							<div class="ShAA_popInput">
								<select name="city_id" id="city_id" class="validate[required]" {if $total < 10000}onchange="$('#delivery_area').html($('#delivery_area_holder').html());$('#delivery_area').load('/delivery_price.php?city_id=' + $('#city_id').eq(0).val() + '&total={$total}&weight={$weight}');"{/if}>
									<option value="0">Пожалуйста, выберите ваш город</option>
									<option value="0"> </option>
									{foreach from=$delivery_cities_main item=delivery_city}
										<option value="{$delivery_city->city_id}" {if $smarty.session.user->city_id == $delivery_city->city_id}selected{/if}><b>{$delivery_city->city_name}</b></option>
									{/foreach}
									<option value="0"> </option>
									{foreach from=$delivery_cities item=delivery_city}
										<option value="{$delivery_city->city_id}" {if $smarty.session.user->city_id == $delivery_city->city_id}selected{/if}>{$delivery_city->city_name}</option>
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
								<input placeholder="Ваш адрес" type="text" name="address" id="address" value="{if $smarty.session.user->adress}{$smarty.session.user->adress}{else}{/if}">
							</div>
							<div class="ShAA_popInfoInput">
								пример: Ленина 10-22
							</div>
						</div>
					</div>
					<div class="clear"></div>
					<div style="margin: 32px 0 0 0;">
						<a href="javascript:void(0);" onclick="$('#personal_data').submit();return false;"><input type="submit" value="Сохранить" class="ShAA_popButton_input"></a>
						<div style="float: right; margin: 16px 4px 0 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">Подробно о персональных скидках</a></div>
					</div>
				</div>
			
				<div class="sett2">
					<div class="ShAA_pop_title">Объедините свои данные, чтобы входить на сайт как удобно</div>
					<div class="ShAA_popText">
						{$social}
					</div>
					<div class="ShAA_popText">
						предлагаем Вам присоединить учетные записи с других сайтов
					</div>
					<br />
					{include file="networks_auth_buttons.tpl"}
					<div style="float: right; margin: 16px 4px 0 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">Подробно о персональных скидках</a></div>
				</div>
				<div class="sett3">
					<div class="ShAA_pop_title">Профиль</div>
					<div class="ShAA_popText">
						Бонус 30%<br>
						Адрес доставки	 Москва, Ходынский бульвар, 9, кв. 178<br>
						Cумма покупок 	 262.000<br>
						Заказов 	26<br>
						пол мужской, возраст<br>
						Размеры : Олимпийка M, Брюки M, Шорты 48, Ремень 85, <br>
						Рубашка 40, Польто 48, Обувь 40,5 <br>
						бренды: Belliner, zilli, kiton <br>
						последни раз был на сайте: 03.02.2012<br>
						последний раз был в магазине: 16.01.2012
					</div>
					<div style="margin: 32px 0 0 0;">
						<a href="#"><div class="ShAA_popButton">Отменить</div></a>
						<a href="#"><input type="submit" value="Сохранить" class="ShAA_popButton_input"></a>
						<div style="float: right; margin: 16px 4px 0 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">Подробно о персональных скидках</a></div>
					</div>
				</div>
				<div class="sett4" style="display:none;">
					<div class="ShAA_pop_title">Отметьте бренды, новые поступления которых вам интересны</div>
					<div style="margin: 20px 0 0 0;">
						<input type="checkbox" id="stop" onchange="jQuery.get('/index.php?module=Login&do_not_disturb&type=sms&user_id={$user->original_user_id}');" {if $stop_sms == 1}checked{/if} autocomplete="off" />
						Не получать новости от lsboutique.ru
					</div>
					<div class="ShAA_popText">
						<div id="subscriptions">
							{foreach from=$brands item=brand}
								<div style="width:190px;float:left;">
									<label>
										<input type="checkbox" value="{$brand->brand_id}"  onchange="{literal}jQuery('#subscribe_result').load('/index.php?module=Login&subscribe&brand_id={/literal}{$brand->brand_id}');" {if in_array($brand->brand_id, $subscribed_brands)}checked{/if} autocomplete="off" /> {$brand->name}
									</label>
								</div>
							{/foreach}
						</div>
					</div>
					<div id="subscribe_result" style="width:100%;float:left;margin-top: 20px;"></div>
				</div>
				<div class="sett5" style="display:none;">
					<div class="ShAA_pop_title">Отметьте Ваши размеры</div>
					<div class="ShAA_popText">
						<div id="sizes">
							<div style="width:170px;float:left;margin-right:20px;">
							<div style="margin-bottom:20px;" class="ShAA_pop_title">Верх</div>
								{foreach from=$sizes item=size}
									<div style="width:80px;">
										<label>
											<input type="checkbox" value="{$size->size}"  onchange="{literal}jQuery('#subscribe_result').load('/index.php?module=Login&users2sizes&type_id=1&size={/literal}{$size->size}');" {if in_array($size->size, $user_sizes_top)}checked{/if} autocomplete="off" /> {$size->size}
										</label>
									</div>
								{/foreach}
							</div>
							<div style="width:170px;float:left;margin-right:20px;">
								<div style="margin-bottom:20px;" class="ShAA_pop_title">Низ</div>
								{foreach from=$sizes item=size}
									<div style="width:80px;">
										<label>
											<input type="checkbox" value="{$size->size}"  onchange="{literal}jQuery('#subscribe_result').load('/index.php?module=Login&users2sizes&type_id=2&size={/literal}{$size->size}');" {if in_array($size->size, $user_sizes_bottom)}checked{/if} autocomplete="off" /> {$size->size}
										</label>
									</div>
								{/foreach}
							</div>
							<div style="width:170px;float:left;">
							<div style="margin-bottom:20px;" class="ShAA_pop_title">Обувь</div>
								{foreach from=$shoesizes item=size}
									<div style="width:80px;float:left;">
										<label>
											<input type="checkbox" value="{$size->size}"  onchange="{literal}jQuery('#subscribe_result').load('/index.php?module=Login&users2sizes&type_id=3&size={/literal}{$size->size}');" {if in_array($size->size, $user_sizes_shoes)}checked{/if} autocomplete="off" /> {$size->size}
										</label>
									</div>
								{/foreach}
							</div>
						</div>
					</div>
					<div id="subscribe_result" style="width:100%;float:left;margin-top: 20px;"></div>
				</div>
</form>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottom"></div>

<!-- end Настройки - Ключи - Инфо -->

