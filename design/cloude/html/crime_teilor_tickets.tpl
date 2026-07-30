{literal}
<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>

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
</style>
{/literal}
<div class="ShAA_popBackCenter">
	<div class="ShAA_loginBlock">
		<a onclick="jQuery.fancybox.close();"><img src="/images/pop_close.png" style="float: right;" width="16"></a>
		<div class="ShAA_pop_title">Купить билеты</div>
		<div class="ShAA_popText"></div>
	
		<form autocomplete="off" action='/index.php?module=Feedback&crime_teilor_tickets' method="post" name="crime_teilor_tickets" id="crime_teilor_tickets" enctype="multipart/form-data">
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					Ваше имя
				</div>
				<div class="ShAA_popInput">
					<input placeholder="Имя" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value="{if $smarty.cookies.user_name}{$smarty.cookies.user_name}{elseif $smarty.session.user->name}{$smarty.session.user->name}{/if}" autofocus/>
				</div>
				<div class="ShAA_popInfoInput">
					пример: Василий Петрович
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					Количество билетов
				</div>
				<div class="ShAA_popInput">
					<input placeholder="Количество билетов" type="text" name="qnt_tickets" id="qnt_tickets" {literal}class="validate[required]"{/literal} value="1" />
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 22px 0 0 0;">
				<div class="ShAA_popTitleInput">
					Номер телефона
				</div>
				<div class="ShAA_popInput phone">
					<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]]"{/literal} value="{if $smarty.cookies.user_phone_number}{$smarty.cookies.user_phone_number}{elseif $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}" onblur="{literal}jQuery('.ShAA_popResult').load('/index.php?module=Cart&phone_check&search='+jQuery('#phone_number').eq(0).val().replace(/ /g, '+'));return false;{/literal}"  maxlength="12" />
				</div>
				<div class="ShAA_popInfoInput">
					пример: 9206003322
				</div>
				
			</div>
			<div class="clear"></div>
			<div style="margin: 32px 0 0 0;">
				<a href="javascript:void(0);" onclick="jQuery('#crime_teilor_tickets').submit();return false;">
					<input type="submit" value="Ок" style="font-size: 16px;" class="ShAA_popButton_input">
				</a>
			</div>
			<div class="clear"></div>
		</form>
		<div class="ShAA_popResult">
				</div>
	</div>
	<div class="clear"></div>
</div>

{literal}
<script>
    jQuery(document).ready(function() {
		jQuery("#crime_teilor_tickets").validationEngine();
		jQuery("#name").focus();
		jQuery("#phone_number").blur(function() {
			jQuery.cookie('user_phone_number', jQuery(this).val(), {expires: 7, path: "/"});
		});
		jQuery("#name").blur(function() {
			jQuery.cookie('user_name', jQuery(this).val(), {expires: 7, path: "/"});
		});
		
		if (jQuery("body").width() < 481) {
			jQuery("#fancybox-wrap").css('padding','0px !important');	
			jQuery(".ShAA_popBackCenter").width(jQuery("body").width()-100);
			jQuery(".ShAA_popInput input").css('width','83%');
			jQuery(".ShAA_popInput textarea").css('width','83%');
			jQuery(".phone input").css('width','75%');
		}
	});
</script>
{/literal}