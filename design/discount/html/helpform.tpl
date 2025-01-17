<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

<!-- Вы можете упростить возвращение -->
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
</style>

<script>
jQuery(document).ready(function() {
	jQuery("#helpform").validationEngine();
	jQuery("#name").focus();
});
</script>
{/literal}

<div class="ShAA_popBackTopMiddle"></div>
<div class="ShAA_popBackCenterMiddle">
	<div class="ShAA_middlePopContent">
		<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -15px -35px 0 0;" width="16"></a>
		<div class="ShAA_pop_title">Скоро Вам позвоним</div>
		<div class="ShAA_popText">Пожалуйста, оставьте Ваш контактный номер телефона. <br>Наши сотрудники обязательно свяжутся с Вами и помогут.</div>
	
		<form autocomplete="off" action='/index.php?module=Feedback&helpform' method="post" name="helpform" id="helpform" enctype="multipart/form-data">
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					Ваше имя
				</div>
				<div class="ShAA_popInput">
					<input placeholder="Имя" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value="{if $smarty.session.user->name}{$smarty.session.user->name}{else}{$name}{/if}" autofocus/>
				</div>
				<div class="ShAA_popInfoInput">
					пример: Василий Петрович
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					Номер телефона
				</div>
				<div class="ShAA_popInput phone">
					<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]]"{/literal} value="{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}" maxlength="10" />
					<input type="hidden" name="product_id" value="{$product_id}"/>
					<input type="hidden" name="from_page" value="{$from_page}"/>
				</div>
				<div class="ShAA_popInfoInput">
					пример: 9206003322
				</div>
			</div>
			<div class="clear"></div>
			<div style="margin: 32px 0 0 0;">
				<a href="javascript:void(0);" onclick="jQuery('#helpform').submit();return false;"><input type="submit" value="Жду звонка" class="ShAA_popButton_input"></a>
			</div>
			<!--<div style="float: right; margin: 16px 0 0 0;" class="ShAA_popMiniInfo">
				<a class="ShAA_productDesigner" href="#" onclick="window.open('http://issa.mangotele.com/widget/MTAzOTY4', 'mangotele_widget', 'width=238,height=215,resizable=no,toolbar=no,menubar=no,location=no,status=no'); return false;" style="margin-left:13px;">
					Позвонить с компьютера
				</a>
			</div>-->
			<div class="clear"></div>
		</form>
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottomMiddle"></div>
<!-- end Вы можете упростить возвращение -->