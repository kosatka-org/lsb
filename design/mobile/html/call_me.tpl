<script type="text/javascript" src="/design/mobile/js/jquery.validate.min.js"></script>
{literal}
<script>
	jQuery(document).ready(function(){
		
		$("#one_click").validate({
			 rules: {
				phone_number: {
				  required: true,
				  digits: true,
				  minlength: 10,
				  maxlength: 10
				}
			  }
		});
		jQuery.extend(jQuery.validator.messages, {
			required: "Необходимо заполнить.",
			digits: "Только цифры.",
			maxlength: jQuery.validator.format("Введите максимум {0} знаков."),
			minlength: jQuery.validator.format("Введите минимум {0} знаков.")
		});
	});
</script>
{/literal}
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
		<input placeholder="8 XXX XXXXXXX" type="text" name="phone_number" id="phone_number" class="text_input" maxlength="10" value="{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{elseif $smarty.cookies.SAVED_PHONE_NUMBER}{$smarty.cookies.SAVED_PHONE_NUMBER}{/if}"/>
		<input type="hidden" name="product_id" value="{$product_id}"/>
		<input type="hidden" name="from_page" value="{$from_page}"/>
	</div>
	<a id="call_me" href="#" title="Жду звонка" alt="Жду звонка" onclick="{literal}rG('CALL_ME');{/literal}">
		<div class="button button560px button_text" style="margin: 40px 0 0 40px;">
			Жду звонка
		</div>
	</a>
</form>