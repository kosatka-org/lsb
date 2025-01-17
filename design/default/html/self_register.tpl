<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
{literal}
<script>
	var restore_request_send = false;
	jQuery(document).ready( function() {
		jQuery(".formError").remove();
		jQuery("#self_register").validationEngine();
		
		jQuery('ul.tabsSett.tabs1 li').click(function(){
			var thisClass = this.className.slice(0,5);
			jQuery('div.sett1').hide();
			jQuery('div.sett2').hide();
			jQuery('div.' + thisClass).show();
			jQuery('ul.tabsSett.tabs1 li').removeClass('tab-current');
			jQuery(this).addClass('tab-current');
		});
		
		jQuery('#remember').click(function() {
			if ( !restore_request_send ) {				
				if ( jQuery('#id_phone_remember').eq(0).val() && jQuery('#id_phone_remember').eq(0).val().length > 9) {
					restore_request_send = true;
					jQuery.get('/index.php?module=Login&restore_card_number&phone=' + jQuery('#id_phone_remember').eq(0).val(), function(response) {
						restore_request_send = false;
						if ( response == 'ok' ) {
							jQuery('div.sett2').hide();
							jQuery('div.sett1').show();
							jQuery('#id_phone').eq(0).val(jQuery('#id_phone_remember').eq(0).val());
							alert('Пожалуйста, проверьте ваши СМС сообщения');
						}
						else {
							alert('Извините, такой номер телефона не найден');
						}
					});
				}
				else {
					alert('Пожалуйста, введите номер телефона полностью');
				}
			}
		});
		jQuery('#back_button').click(function(){
			jQuery('div.sett2').hide();
			jQuery('div.sett1').show();
		});
		
	});
</script>
{/literal}
<div class="fullfield">
	<div class="ShAA_popBackTop"></div>
	<div class="ShAA_popBackCenter">
		<div class="ShAA_loginBlock">
			<a onclick="jQuery.fancybox.close();"><img width="16" style="float: right; margin: -15px -35px 0 0;" src="/images/pop_close.png"></a>
<form autocomplete="off" action="/index.php?module=Login&self_register" method="post" name="self_register" id="self_register" enctype="multipart/form-data">
			<div class="sett1">
				<div class="ShAA_pop_title" style="margin-bottom: 32px;">Скидка 10% знакомым</div>
				{include file="networks_auth_buttons.tpl"}
				<hr color="#dcdcdc" size="1" />
				<div style="margin: 48px 0 0 0; float: left;" class="ShAA_pop_title">Станьте владельцем карты Лакшери Стор</div>
				<div>
					<input name="module" type="hidden" value="Login"/>
					<div class="ShAA_settingLeftBlock">
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								Имя Отчество
							</div>
							<div class="ShAA_popInput">
								<input placeholder="Имя Отчество" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value=""/>
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
								<input placeholder="Фамилия" type="text" name="surname" id="surname" {literal}class="validate[required]"{/literal} value=""/>
							</div>
							<div class="ShAA_popInfoInput">
								пример: Иванов
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput" style="float: left;">
								Пол
							</div>
							<div class="" style="float: left; margin: 0 10px;">
								<span class="ShAA_popSex">М</span><input class="sex" name="sex" type="radio" value="1" style="float: left;">
								<span class="ShAA_popSex">Ж</span><input class="sex" name="sex" type="radio" value="2" style="float: left;">
							</div>
						</div>
					</div>
					<div class="ShAA_settingRightBlock">
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
								<input placeholder="Электронная почта" type="text" name="email" id="email" {literal}class="validate[required,custom[email]]"{/literal} value="">
							</div>
							<div class="ShAA_popInfoInput">
								пример: name@gmail.com
							</div>
						</div>
					</div>
				</div>
				
				<div style="float: left; margin: 20px 0 16px 0; width: 100%;">
					<a href="javascript:void(0);" onclick="jQuery('#form_order').submit();return false;">
					<a href="javascript:void(0);" onclick="jQuery('#self_register').submit();return false;">				
						<input type="submit" value="Зарегистрироваться" class="ShAA_popButton_input">
					</a>
					<ul class="tabsSett tabs1" style="float: left; height: auto; margin: 10px 10px 0 20px; width: 180px;">
						<li class="sett1 tab-current" style="display: none;"><a style="width: 170px;">Создать нового клиента</a></li>
						<li class="sett2"><a style="text-decoration: underline; width: 200px;">Восстановить номер карты</a></li>
					</ul>
					<div class="ShAA_popMiniInfo" style="float: right; margin: 16px 0 0 0;"><a href="http://ru.lsboutique.ru/doctxt/diskont/" target="_blank">Подробно о персональных скидках</a></div>
				</div>
			</div>
			<div class="sett2">
				<div class="ShAA_pop_title">Восстановите карту по номеру телефона</div>
				<div class="ShAA_popData">
					<div class="ShAA_popTitleInput">
						Если вы являетесь владельцем персональной карты "Лакшери Стор",<br>наберите ваш номер телефона и мы отправим ваш номер карты в СМС сообщении.
					</div>
					<div class="ShAA_popInput">
						<span class="ShAA_prefix">+7</span><input placeholder="XXXXXXXXXX" type="text" name="phone_remember" id="id_phone_remember" {literal}class="validate[required,custom[phone]]"{/literal} value="{$save_phone_number}" maxlength="10" />
					</div>
					<div class="ShAA_popInfoInput">
					</div>
				</div>
				
				<div style="float: left; margin: 0 0 16px 0; width: 100%;">
					<a href="javascript:void(0);" onclick="">				
						<div class="ShAA_popButton" id="remember" style="float: left;">Восстановить</div>
					</a>
					<a href="javascript:void(0);" onclick="">				
						<div class="ShAA_popButton" id="back_button" style="float: left;">Вернуться</div>
					</a>
				</div>
			</div>
</form>
		</div>
		<div class="clear"></div>
	</div>
	<div class="ShAA_popBackBottom"></div>
</div>

{literal}
<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-title {
		display: none !important;
	}
</style>
{/literal}