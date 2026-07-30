<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>

{literal}
<script>
jQuery(document).ready(function() {
	jQuery("#form_feedback").validationEngine();
	jQuery("#field_name").focus();
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


<div class="ShAA_popBackTopMini"></div>
<div class="ShAA_popBackCenterMini">
	<div class="ShAA_miniPopContent">
		<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -15px -35px 0 0;" width="16"></a>
		<div class="ShAA_pop_title">Вопрос</div>
		<div class="ShAA_popText">Пожалуйста, заполните краткую контактную информацию, чтобы отправить вопрос.</div>
		{if $accepted}
			<h2>Ваша вопрос принят</h2>
		{else}	
			<form autocomplete="off" action='/index.php?module=Feedback' method="post" id="form_feedback" name="form_feedback" enctype="multipart/form-data">
				<input name="is_question" type="hidden" value="true" />
				<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
					<div class="ShAA_popTitleInput">
						Ваш вопрос
					</div>
					<div class="ShAA_popInput">
						<textarea name="question" placeholder="" {literal}class="validate[required]"{/literal} ></textarea>
					</div>
				</div>
				
				<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
					<div class="ShAA_popTitleInput">
						Обращение
					</div>
					<div class="ShAA_popInput">
						<input id="field_name" notice='Пожалуйста назовитесь' value='{if $smarty.session.user}{$smarty.session.user->name}{/if}' placeholder="Имя Отчество Фамилия" name="name" maxlength=100 type="text" autofocus/>
					</div>
					<div class="ShAA_popInfoInput">
						пример: Петр Сергеевич Иванов
					</div>
				</div>
				<div class="ShAA_popData ShAA_popDataSett">
					<div class="ShAA_popTitleInput">
						Почта
					</div>
					<div class="ShAA_popInput">
						<input id="field_email"  format='email' notice='Пожалуйста, введите e-mail' {literal}class="validate[groupRequired[contacts],custom[email]]"{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="Электронная почта"  name="email" maxlength=100 type="text"/>
					</div>
					<div class="ShAA_popInfoInput">
						пример: name@gmail.com
					</div>
				</div>
				<div class="ShAA_popData ShAA_popDataSett">
					<div class="ShAA_popTitleInput">
						Номер телефона
					</div>
					<div class="ShAA_popInput phone">
						<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" id="field_number" format='number' notice='Пожалуйста, введите телефон' {literal}class="validate[groupRequired[contacts],custom[phone]]"{/literal} value='{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}' name="phone_number" maxlength="10" type="text"/>
					</div>
					<div class="ShAA_popInfoInput">
						пример: 9206003322
					</div>
				</div>
				<div class="clear"></div>
				<div style="margin: 32px 0 0 0;">
					<a href="javascript:void(0);" onclick="jQuery('#form_feedback').submit();return false;"><input type="submit" value="Спросить" class="ShAA_popButton_input"></a>
					<div style="display: none; float: right; margin: 16px 4px 0 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">Подробно о персональных скидках</a></div>
				</div>
				<div class="clear"></div>
			</form>
		{/if}
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottomMini"></div>