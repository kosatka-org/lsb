<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

{literal}
<script>
jQuery(document).ready(function() {
	jQuery("#form_feedback").validationEngine();
	jQuery("#field_name").focus();
	var a = $('#city').autocomplete({
		serviceUrl:'/cities.php',
		minChars: 2,
		maxHeight:400,
		width:300,
		zIndex: 19999,
		deferRequestBy: 300,
		noCache: false,
		onSelect: function(value, data) { $('#city_id').val(data); }
	});
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
</style>
{/literal}

<div class="ShAA_popBackTopMini"></div>
<div class="ShAA_popBackCenterMiddle" style="width: 376px;">
	<div class="ShAA_miniPopContent">
		<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -10px -43px 0 0;" width="16"></a>
		<div class="ShAA_settingTabs">
			<div>
				{if $accepted}
				<h2>Ваша заявка принята</h2>
				{else}
					<form autocomplete="off" method='post' action='/index.php?module=Feedback' id="form_feedback" name="form_feedback" enctype="multipart/form-data">
						<input format='.+' notice='name' value='{$brand_id}' name='brand_id' maxlength=100 type="text" style="display:none;"/>
						<div>
							<div class="ShAA_pop_title">Заявка</div>
							<div class="ShAA_popText">Заполните форму, чтобы получать рассылку о новых поступлениях.</div>
							<div>
								<div class="ShAA_popData ShAA_popDataSett">
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
										Номер телефона
									</div>
									<div class="ShAA_popInput phone">
										<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" id="field_number" format='number' notice='Пожалуйста, введите телефон' {literal}class="validate[groupRequired[contacts],custom[phone]]"{/literal} value='{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}' name="phone_number" maxlength="10" type="text"/>
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
										<input id="field_email"  format='email' notice='Пожалуйста, введите e-mail' {literal}class="validate[groupRequired[contacts],custom[email]]"{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="Электронная почта"  name="email" maxlength=100 type="text"/>
									</div>
									<div class="ShAA_popInfoInput">
										пример: name@gmail.com
									</div>
								</div>
							</div>
							<div class="clear"></div>
							<div style="margin: 32px 0 18px 0; float: left;">
								<a href="javascript:void(0);" onclick="jQuery('#form_feedback').submit();return false;"><input type="submit" value="Подписаться" class="ShAA_popButton_input"></a>
							</div>
						</div>
					</form>
				{/if}
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottomMini"></div>

