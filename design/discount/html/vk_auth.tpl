<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
{literal}
<script>
	var restore_request_send = false;
	jQuery(document).ready( function() {
		jQuery(".formError").remove();
		jQuery("#form_discount1").validationEngine();
		jQuery("#id_phone").trigger( "focus" );
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
			return false;
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
<form autocomplete="on" action="/" method="get" name="form_discount1" id="form_discount1" enctype="multipart/form-data">
			<div class="sett1">
				<div class="ShAA_pop_title" style="margin-bottom: 32px;">Скидка 10% знакомым</div>
				{include file="networks_auth_buttons.tpl"}
				<div style="margin: 48px 0 0 0; float: left;" class="ShAA_pop_title">Бонус владельцам карты Лакшери Стор</div>
				<div class="ShAA_popMiniInfo" style="display: none;">первый раз используете карту, ее нужно <a href="#">активировать</a></div>
				<div>
					<input name="module" type="hidden" value="Login"/>
					<div class="ShAA_popData">
						<div class="ShAA_popTitleInput">
							Номер телефона
						</div>
						<div class="ShAA_popInput">
							<span class="ShAA_prefix">+7</span><input placeholder="XXXXXXXXXX" type="text" name="phone" id="id_phone" {literal}class="validate[required,custom[phone]]"{/literal} value="{$save_phone_number}" maxlength="10" autofocus/>
						</div>
						<div class="ShAA_popInfoInput" style="display: none;">
							пример: 9202558888
						</div>
					</div>
					<div class="ShAA_popData" style="float: right; margin-left: 40px;">
						<div class="ShAA_popTitleInput">
							Персональная карта
						</div>
						<div class="ShAA_popInput">
							<input placeholder="Номер дисконтной карты" type="text" name="card_number" id="id_card_number" {literal}class="validate[required],custom[onlyNumberSp]"{/literal} value="{$save_card_number}"/>
						</div>
						<div class="ShAA_popInfoInput">
							<ul class="tabsSett tabs1" style="float: left; height: auto; width: 200px;">
								<li class="sett1 tab-current" style="display: none;"><a style="width: 170px;">Создать нового клиента</a></li>
								<li class="sett2"><a style="text-decoration: underline; width: 200px;" onclick="rG('REESTABLISH_CARD_NUMBER');">Восстановить номер карты</a></li>
							</ul>
						</div>
					</div>
				</div>
				
				<div style="float: left; margin: 0 0 16px 0; width: 100%;">
					<a href="javascript:void(0);" onclick="jQuery('#form_order').submit();return false;">
					<a href="javascript:void(0);" onclick="jQuery('#form_discount1').submit();return false;">				
						<input type="submit" value="Войти" class="ShAA_popButtonIn" style="float: left;">
					</a>
					<div class="ShAA_popMiniInfo" style="float: left; margin: 16px 0 0 16px;"><a href="http://ru.lsboutique.ru/doctxt/diskont/" target="_blank">Подробно о персональных скидках</a></div>
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
						<input type="button" value="Восстановить" id="remember" class="ShAA_popButton_input" style="float: left;">
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