<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{if $language=='eng'}<script src="/jscript/jquery.validationEngine-en.js" type="text/javascript"></script>
{else}<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>{/if}
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

<!-- Вы можете упростить возвращение -->
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

<script>
jQuery(document).ready(function() {
	jQuery("#helpform").validationEngine();
});
</script>
{/literal}

<div class="ShAA_popBackCenter">
	<div class="ShAA_loginBlock">
        <a href="#" onclick="history.back();return false;" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
		<div class="ShAA_pop_title">{if $language=='eng'}We'll call you soon{else}Скоро Вам позвоним{/if}</div>
		<div class="ShAA_popText">{if $language=='eng'}Please leave your contact phone number. <br />Our staff will contact you and help you.{else}Пожалуйста, оставьте Ваш контактный номер телефона. <br>Наши сотрудники обязательно свяжутся с Вами и помогут.{/if}</div>
	
		<form autocomplete="off" action='/index.php?module=Feedback&helpform' method="post" name="helpform" id="helpform" enctype="multipart/form-data">
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Your name{else}Ваше имя{/if}
				</div>
				<div class="ShAA_popInput">
					<input placeholder="{if $language=='eng'}Name{else}Имя{/if}" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value="{if $smarty.session.user->name}{$smarty.session.user->name}{else}{$name}{/if}" autofocus/>
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example: John Doe{else}пример: Василий Петрович{/if}
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Phone number{else}Номер телефона{/if}
				</div>
				<div class="ShAA_popInput {if $language != 'eng'} phone{/if}">
					{if $language != 'eng'}<span class="ShAA_prefixForMiniInput">+7</span>{/if}<input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]]"{/literal} value="{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}" maxlength="{if $language=='eng'}15{else}10{/if}" />
					<input type="hidden" name="product_id" value="{$product_id}"/>
					<input type="hidden" name="from_page" value="{$from_page}"/>
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example: +449206003322{else}пример: 9206003322{/if}
				</div>
			</div>
			<div class="clear"></div>
			<div style="margin: 32px 0 0 0;">
				<a href="javascript:void(0);" onclick="jQuery('#helpform').submit();return false;"><input type="submit" value="{if $language=='eng'}I am waiting for a call{else}Жду звонка{/if}" class="ShAA_popButton_input"></a>
			</div>
			<div class="clear"></div>
		</form>
	</div>
	<div class="clear"></div>
</div>
<!-- end Вы можете упростить возвращение -->