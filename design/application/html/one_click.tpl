<link rel="stylesheet" href="/design/application/css/validationEngine.jquery.css" type="text/css" />
<script type="text/javascript" src="/design/mobile/js/jquery.validationEngine.js"></script>
<script type="text/javascript" src="/design/mobile/js/jquery.validationEngine-ru.js"></script>
{literal}
<script>
	jQuery(document).ready(function() {
        jQuery('#referrer').val(ref);
		jQuery("#one_click").validationEngine();
	});
</script>
{/literal}
{literal}<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-left {
		display: none !important;
	}
	#fancybox-right {
		display: none !important;
	}
	.fancybox-bg{
		background: none;
	}
	#fancybox-overlay{
		top: -40px;
	}
</style>{/literal}
<div class="form_wrap">
	<div class="form" style="padding-top: 30px;padding-bottom: 10px;">
		<form autocomplete="off" action='/index.php?module=Feedback&one_click' method="post" name="one_click_form" id="one_click" enctype="multipart/form-data">
			<input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
			<div class="form_text">Чтобы оформить заказ введите, пожалуйста, имя и номер телефона:</div>
			<div class="form_line"><div class="form_line_text">Меня зовут:</div><input type="text" style="width: 290px; float: right;" name="name" id="name"  value="{if $smarty.session.user->name}{$smarty.session.user->name}{elseif $smarty.cookies.SAVED_USER_NAME}{$smarty.cookies.SAVED_USER_NAME}{/if}"/></div>
			<div class="form_line">
				<div class="form_line_text">Телефон:&nbsp;&nbsp;+7</div>
				<input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" style="width: 290px; float: right;" {literal}class="validate[required,custom[phone]]"{/literal} value="{if $smarty.cookies.user_phone_number}{$smarty.cookies.user_phone_number}{elseif $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}" onblur="{literal}jQuery('.ShAA_popResult').load('/index.php?module=Cart&phone_check&search='+jQuery('#phone_number').eq(0).val().replace(/ /g, '+'));return false;{/literal}"  maxlength="12" />
<!--
				<input type="text" maxlength="10" pattern="[0-9]+" style="width: 290px; float: right;" name="phone_number" id="phone_number"  value="{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{elseif $smarty.cookies.SAVED_PHONE_NUMBER}{$smarty.cookies.SAVED_PHONE_NUMBER}{/if}"/>
-->
			</div>
			<input type="hidden" name="product_id" value="{$product_id}"/>
			<input type="hidden" name="from_page" value="{$from_page}"/>
			<div class="form_bottom">
				<input type="submit" value="Готово" class="gray_button text" style="float:left;margin: 0;border-radius: 7px;background: #C8C8C8;" />
				<a href="" onclick="$.fancybox.close();" alt="Выйти" title="Выйти" class="form_back"><img src="/design/application/images/exit.png" alt="" title=""/>Выйти</a>
			</div>
		</form>
	</div>
</div>