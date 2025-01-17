<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{if $language=='eng'}<script src="/jscript/jquery.validationEngine-en.js" type="text/javascript"></script>
{else}<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>{/if}

<script src="/jscript/jquery.validationEngine.js?v=2"></script>
{literal}
<script>
	var restore_request_send = false;
	jQuery(document).ready( function() {
		jQuery(".formError").remove();
		jQuery("#form_discount1").validationEngine();
		//jQuery("#id_phone").trigger( "focus" );
		jQuery('ul.tabsSett.tabs1 li').click(function(){
			var thisClass = this.className.slice(0,5);
			jQuery('div.sett1').hide();
			jQuery('div.sett2').hide();
			jQuery('div.' + thisClass).show();
			jQuery('ul.tabsSett.tabs1 li').removeClass('tab-current');
			jQuery(this).addClass('tab-current');
		});
		
		jQuery('#remember_button').click(function() {
			if ( !restore_request_send ) {				
				if ( jQuery('#id_phone').eq(0).val() && jQuery('#id_phone').eq(0).val().length > 9) {
					restore_request_send = true;
					jQuery.get('/index.php?module=Login&restore_card_number&phone=' + jQuery('#id_phone').eq(0).val(), function(response) {
						restore_request_send = false;
						if ( response == 'ok' ) {
//							jQuery('div.sett2').hide();
//							jQuery('div.sett1').show();
//							jQuery('#id_phone').eq(0).val(jQuery('#id_phone_remember').eq(0).val());
              if($.cookie('language') == 'eng'){var text = 'Please check your SMS messages';}
              else{var text = 'Пожалуйста, проверьте ваши СМС сообщения';}
							alert(text);
						}
						else {
              if($.cookie('language') == 'eng'){var text = 'Sorry, this phone number is not found';}
              else{var text = 'Извините, такой номер телефона не найден';}
							alert(text);
						}
					});
				}
				else {
          if($.cookie('language') == 'eng'){var text = 'Please enter the full phone number';}
          else{var text = 'Пожалуйста, введите номер телефона полностью';}
					alert(text);
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
	<div class="ShAA_popBackCenter">
		<div class="ShAA_loginBlock">
			<a href="/" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
<form autocomplete="off" action="/" method="get" name="form_discount1" id="form_discount1" enctype="multipart/form-data">
			<div class="sett1">
				<div style="text-align: center; width: 100%; margin: 0 0 24px 0;" class="logoOnline">
					<a href="/"><img width="90%" height="auto" style="max-width: 220px;" alt="Лакшери Стор" src="/images/{if $language=='eng'}eng_{/if}new_logo_x2.png"></a>
				</div>
				<div>
					<input name="module" type="hidden" value="Login"/>
					<div class="ShAA_popData">
            <div class="ShAA_popInput">
							<input placeholder="XXXXXXXXXX" type="text" name="phone" id="id_phone" {literal}class="validate[required,custom[phone]]"{/literal} value="{if $save_phone_number}{$save_phone_number}{else}7{/if}" maxlength="15" />
						</div>
					</div>
					<div class="ShAA_popData" style="float: right; margin-left: 40px;">
						<div class="ShAA_popInput">
							<input placeholder="{if $language=='eng'}Discount card number{else}Номер дисконтной карты{/if}" type="text" name="card_number" id="id_card_number" {literal}class="validate[required],custom[onlyNumberSp]"{/literal} value="{$save_card_number}"/>
						</div>
					</div>
				</div>
				<div style="float: left; width: 100%;">
					<a href="javascript:void(0);" onclick="jQuery('#form_order').submit();return false;">
					<a href="javascript:void(0);" onclick="jQuery('#form_discount1').submit();return false;">
                        <span class="ShAA_oneClickAdd" style="float: none; width: 99%; padding: 12px 0; margin: 12px auto;">{if $language=='eng'}Login{else}Войти{/if}</span> 
<!--                        
						<input type="submit" value="{if $language=='eng'}Login{else}Войти{/if}" class="ShAA_popButton" style="float: none; width: 100%; padding: 12px 4%; margin: 12px auto;">
-->
					</a>
				</div>	
				{include file="networks_auth_buttons.tpl"}
				
				<div style="font-size: 14px; text-align: center; margin: 12px 0 0 0;">
					<a style="margin: 6px 0; border-bottom: 1px solid #000;" id="remember_button" onclick="rG('REESTABLISH_CARD_NUMBER');" title="{if $language=='eng'}enter your phone number to recover your card number by SMS{else}введите номер телефона, чтобы восстановить номер вашей карты по СМС{/if}">{if $language=='eng'}Forgot card number{else}Забыли номер карты{/if}?</a>
				</div>
				<div style="text-align: center; margin: 10px auto;">
					<a href="/reg/" class="cart_login_link" style="font-size: 14px;" onclick="{literal}rG('LOGIN_FROM_CART');{/literal}" title="{if $language=='eng'}Sign up{else}Зарегистрируйтесь{/if}">{if $language=='eng'}Registration{else}Регистрация{/if}</a>
				</div>
				<div style="text-align: center; margin: 16px auto;">
					<a href="http://ru.lsboutique.ru/doctxt/diskont/" style="font-size: 14px; border-bottom: 1px solid #000;" target="_blank">{if $language=='eng'}Details about personal discounts{else}Подробно о персональных скидках{/if}</a>
				</div>
			</div>
			<div class="sett2">
				<div class="ShAA_pop_title">{if $language=='eng'}Restore the card by phone number{else}Восстановите карту по номеру телефона{/if}</div>
				<div class="ShAA_popData">
					<div class="ShAA_popTitleInput">
						{if $language=='eng'}If you are the owner of a personal card "Luxury Store", enter your phone number and we will send your card number in SMS.{else}Если вы являетесь владельцем персональной карты "Лакшери Стор", наберите ваш номер телефона, и мы отправим ваш номер карты в СМС сообщении.{/if}
					</div>
					<div class="ShAA_popInput {if $language != 'eng'} phone{/if}">
						{if $language != 'eng'}<span class="ShAA_prefix">+7</span>{/if}<input style="width: 84%;" placeholder="XXXXXXXXXX" type="text" name="phone_remember" id="id_phone_remember" {literal}class="validate[required,custom[phone]]"{/literal} value="{$save_phone_number}" maxlength="{if $language=='eng'}15{else}10{/if}" />
					</div>
					<div class="ShAA_popInfoInput">
					</div>
				</div>
				
				<div style="float: left; width: 100%;">
					<a href="javascript:void(0);" onclick="">
						<input type="button" value="{if $language=='eng'}Recover{else}Восстановить{/if}" id="remember" class="ShAA_popButton_input" style="float: left;">
					</a>
					<a href="javascript:void(0);" onclick="" id="back_button" class="ShAA_backLink">
						{if $language=='eng'}Back{else}Вернуться{/if}
					</a>
				</div>
			</div>
</form>
		</div>
		<div class="clear"></div>
	</div>
</div>

{literal}
<style>
	
</style>
{/literal}

{literal}
    <style>
        .headBlock, .footer {
            display: none;
        }
        .fullfield, .ShAA_popBackCenter {
            box-shadow: none !important;
            border: none !important;
            margin: 0 auto;
        }
    </style>
{/literal}