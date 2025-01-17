<a onclick="{literal}jQuery('#code_input').toggle(); if ( typeof(order_send) == 'undefined' ) {jQuery.post('/index.php?module=Cart&phone_check&send=1&search='+jQuery('#phone_number').eq(0).val().replace(/ /g, '+')); order_send = 1;} return false;{/literal}">Получить код и авторизоваться</a>
<div class="ShAA_popData ShAA_popDataSett" id="code_input" style="margin: 10px 0 0 0;display: none;">
	<form autocomplete="off" action='/index.php?module=Login&code_auth' method="post" name="code_auth" id="code_auth" enctype="multipart/form-data">
		<div class="ShAA_popTitleInput">
			Через несколько секунд Вам придет СМС с кодом
		</div>
		<div class="ShAA_popInput">
			<input placeholder="XXXXX" type="text" name="code" id="code" {literal}class="validate[required]"{/literal} value="" />
			<input type="hidden" name="phone_number" value="{if $smarty.cookies.user_phone_number}{$smarty.cookies.user_phone_number}{elseif $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}"/>
		</div>
		<div class="ShAA_popInfoInput">
			Введите присланный Вам по СМС код
		</div>
		<div style="margin: 32px 0 0 0;">
			<a href="" onclick="jQuery('#code_auth').submit();return false;"><input type="submit" value="Войти" class="ShAA_popButton_input"></a>
		</div>
	</form>
</div>