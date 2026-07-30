<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{if $language=='eng'}<script src="/jscript/jquery.validationEngine-en.js" type="text/javascript"></script>
{else}<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>{/if}
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
		setTimeout(() => {
			if(jQuery('.ShAA_pop_title').html().indexOf('Регистрация прошла успешно')+1){
				location.href = '/';
			}
		}, 1500);	

		jQuery("#headBlock").remove();		
	});
		function remember_func() {
				if ( !restore_request_send ) {				
					if ( jQuery('#id_phone_remember').eq(0).val() && jQuery('#id_phone_remember').eq(0).val().length > 9) {
						restore_request_send = true;
						jQuery.get('/index.php?module=Login&restore_card_number&phone=' + jQuery('#id_phone_remember').eq(0).val(), function(response) {
							restore_request_send = false;
							if ( response == 'ok' ) {
								jQuery('div.sett2').hide();
								jQuery('div.sett1').show();
								jQuery('#id_phone').eq(0).val(jQuery('#id_phone_remember').eq(0).val());
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
		}
		jQuery('#back_button').click(function(){
			jQuery('div.sett2').hide();
			jQuery('div.sett1').show();
		});
</script>
{/literal}
<div class="fullfield">
	<div class="ShAA_popBackCenter">
		<div class="ShAA_loginBlock">
            <a href="/" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
<form autocomplete="off" action="/index.php?module=Login&self_register" method="post" name="self_register" id="self_register" enctype="multipart/form-data">
			<div class="sett1">
				<div style="text-align: center; width: 100%; margin: 0 0 24px 0; display: none;" class="logoOnline">
					<a href="/"><img width="90%" height="auto" style="max-width: 220px;" alt="Лакшери Стор" src="/images/{if $language=='eng'}eng_{/if}new_logo_x2.png"></a>
				</div>
				<div style="float: left;" class="ShAA_pop_title">{if $language=='eng'}Become the owner of the Luxury Store card{else}Станьте владельцем карты Лакшери Стор{/if}</div>
				<div>
					<input name="module" type="hidden" value="Login"/>
					<div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput" style="display: none;">
								{if $language=='eng'}Name{else}Имя Отчество{/if}
							</div>
							<div class="ShAA_popInput">
								<input placeholder="{if $language=='eng'}Name{else}Имя Отчество{/if}" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value=""/>
							</div>
							<div class="ShAA_popInfoInput" style="display: none;">
								{if $language=='eng'}example: John Doe{else}пример: Петр Сергеевич{/if}
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popInput">
								<input placeholder="{if $language=='eng'}Surname{else}Фамилия{/if}" type="text" name="surname" id="surname" {literal}class="validate[required]"{/literal} value=""/>
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput" style="float: left;">
								{if $language=='eng'}Gender{else}Пол{/if}
							</div>
							<div class="" style="float: left; margin: 0 10px;">
								<span class="ShAA_popSex">{if $language=='eng'}Male{else}М{/if}</span><input class="sex" name="sex" type="radio" value="1" style="float: left;">
								<span class="ShAA_popSex">{if $language=='eng'}Female{else}Ж{/if}</span><input class="sex" name="sex" type="radio" value="2" style="float: left;">
							</div>
						</div>
					
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popInput">
								<input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]],custom[number]"{/literal} value="7" maxlength="15" {literal}pattern="[0-9]{10,15}"{/literal} />
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popInput">
								<input placeholder="{if $language=='eng'}Email{else}Электронная почта{/if}" type="text" name="email" id="email" {literal}class="validate[required,custom[email]]"{/literal} value="">
							</div>
						</div>
                        <div class="ShAA_popData ShAA_popDataSett">
                            <div class="g-recaptcha" data-sitekey="6LfDlk4UAAAAAAwQvfXiSySQrt89R8vDPb4i8qKK"></div>
                        </div>
					</div>
				</div>
				
				<div style="float: left; margin: 0px 0 16px 0; width: 100%;">
					<a href="javascript:void(0);" onclick="jQuery('#form_order').submit();return false;">
					<a href="javascript:void(0);" onclick="jQuery('#self_register').submit();return false;" style="margin: 0 0 12px 0; float: left; width: 100%;">				
						<input type="submit" value="{if $language=='eng'}Register{else}Зарегистрироваться{/if}" class="ShAA_popButton_input">
					</a>
					{include file="networks_auth_buttons.tpl"}
					
					<div style="text-align: center; margin: 10px auto; display: none;">
						<a href="javascript:void(0);" onclick="$('div.sett1').hide();$('div.sett2').show();" style="font-size: 14px; border-bottom: 1px solid #000;">{if $language=='eng'}Restore card number{else}Восстановить номер карты{/if}</a>
					</div>
					<div style="text-align: center; margin: 16px auto;"><a href="http://ru.lsboutique.ru/doctxt/diskont/" style="font-size: 14px; border-bottom: 1px solid #000;" target="_blank">{if $language=='eng'}Details about personal discounts{else}Подробно о персональных скидках{/if}</a></div>
				</div>
                <div class="clear"></div>
                <div class="ShAA_popMiniInfo" style="margin-top: 12px;">{if $language=='eng'}By clicking on the "Register" button, you give <a href="/sections/personal_data_eng">consent to the processing of personal data</a>{else}Нажимая на кнопку "Зарегистрироваться", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a>{/if}</div>
			</div>
			<div class="sett2">
				<div class="ShAA_pop_title">{if $language=='eng'}Restore the card by phone number{else}Восстановите карту по номеру телефона{/if}</div>
				<div class="ShAA_popData">
					<div class="ShAA_popTitleInput">
						{if $language=='eng'}If you are the owner of a personal card "Luxury Store",<br>enter your phone number and we will send your card number in SMS.{else}Если вы являетесь владельцем персональной карты "Лакшери Стор",<br>наберите ваш номер телефона, и мы отправим ваш номер карты в СМС сообщении.{/if}
					</div>
					<div class="ShAA_popInput {if $language != 'eng'} phone{/if}">
						{if $language != 'eng'}<span class="ShAA_prefix">+7</span>{/if}<input style="width: 84%;" placeholder="XXXXXXXXXX" type="text" name="phone_remember" id="id_phone_remember" {literal}class="validate[required,custom[phone]]"{/literal} value="{$save_phone_number}" maxlength="{if $language=='eng'}15{else}10{/if}" />
					</div>
					<div class="ShAA_popInfoInput">
					</div>
				</div>
				
				<div style="float: left; width: 100%;">
					<a href="javascript:void(0);" onclick="remember_func();">		
						<input type="button" value="{if $language=='eng'}Recover{else}Восстановить{/if}" id="remember" class="ShAA_popButton_input" style="float: left;">
					</a>
					<a href="javascript:void(0);" onclick="jQuery('div.sett2').hide();jQuery('div.sett1').show(); return false;" id="back_button" class="ShAA_backLink">
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
	#fancybox-outer {
		background: none;
	}
	#fancybox-title {
		display: none !important;
	}
	.ShAA_popDataSett {
		margin: 12px 0 6px 0;
	}
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
        .logoOnline {
            display: block !important;
        }
    </style>
{/literal}