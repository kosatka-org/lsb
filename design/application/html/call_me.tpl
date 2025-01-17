<!--<link rel="stylesheet" href="/design/mobile/css/validationEngine.jquery.css" type="text/css" />
<script type="text/javascript" src="/design/mobile/js/jquery.validationEngine.js"></script>
<script type="text/javascript" src="/design/mobile/js/jquery.validationEngine-ru.js"></script>
{literal}
<script>
	$(document).ready(function(){
		$("#one_click").validationEngine("attach");
	});
</script>
{/literal}-->
<div class="centered_text alert_text">
	Мы скоро вам позвоним
</div>
<div class="left_text2 descr_text" style="margin: 30px 0 30px 80px;">
	Пожалуйста, заполните краткую контактную информацию. Наши сотрудники свяжутся с Вами и ответят на все вопросы.
</div>
<form autocomplete="off" action='/index.php?module=Feedback&helpform' method="post" name="one_click_form" id="one_click" enctype="multipart/form-data">
	<div class="centered_text text_input-hint item_text2">
		Ваше имя
	</div>
	<div class="input_wrap">
		<input placeholder="Имя" type="text" name="name" id="name" class="text_input" value="{if $smarty.session.user->name}{$smarty.session.user->name}{elseif $smarty.cookies.SAVED_USER_NAME}{$smarty.cookies.SAVED_USER_NAME}{/if}"/>
	</div>
	<div class="centered_text text_input-hint item_text2">
		Номер телефона
	</div>
	<div class="input_wrap">
		<input placeholder="8 XXX XXXXXXX" type="text" name="phone_number" id="phone_number" class="text_input" value="{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{elseif $smarty.cookies.SAVED_PHONE_NUMBER}{$smarty.cookies.SAVED_PHONE_NUMBER}{/if}"/>
		<input type="hidden" name="product_id" value="{$product_id}"/>
		<input type="hidden" name="from_page" value="{$from_page}"/>
	</div>
	<a id="call_me" href="#" title="Жду звонка" alt="Жду звонка">
		<div class="button button160px button_text" style="margin: 40px 0 0 240px;">
			Жду звонка
		</div>
	</a>
</form>