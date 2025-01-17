<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

<!-- Укажите почту -->
{literal}
<script>
$(document).ready(function() {
	$("#form_mail").validationEngine();
});
</script>
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
<div class="ShAA_popBackCenterMini">
	<div class="ShAA_miniPopContent">
		<a onclick="{literal}$.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -15px -35px 0 0;" width="16"></a>
		<div class="ShAA_pop_title">Укажите вашу почту</div>
		<form id="form_mail" name="form_mail" method="post" action="/cart/save_user/" autocomplete="off">
			<div class="ShAA_popData">
				<div class="ShAA_popTitleInput">
					Куда Вам писать
				</div>
				<div class="ShAA_popInput">
					<input placeholder="Электронная почта" type="text" name="email" id="email" {literal}class="validate[required,custom[email]]"{/literal} value="">
				</div>
				<div class="ShAA_popInfoInput">
					пример: name@mail.ru
				</div>
			</div>
			
			<div style="float: left; margin: 0 0 32px 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">Подробно о персональных скидках</a></div>
			<a href="javascript:void(0);" onclick="$('#form_mail').submit();return false;"><input type="submit" value="Сообщить" class="ShAA_popButton_input"></a>
		</form>
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottomMini"></div>
<!-- end Укажите почту -->