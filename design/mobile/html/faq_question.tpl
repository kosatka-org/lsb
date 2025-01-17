<script type="text/javascript" src="/design/mobile/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/design/mobile/js/additional-methods.min.js"></script>
{literal}
<script>
jQuery(document).ready(function() {
	jQuery("#field_name").focus();
	$("#form_faq").validate({
		 rules: {
			question: {
			  required: true
			},
			phone_number: {
			  require_from_group: [1, ".contacts"],
			  digits: true,
			  minlength: 10,
			  maxlength: 11
			},
			email: {
			  require_from_group: [1, ".contacts"]
			}
		  }
	});
	jQuery.extend(jQuery.validator.messages, {
		required: "Необходимо заполнить.",
		require_from_group: "Заполните хотя бы одно из этих полей",
		digits: "Только цифры.",
		maxlength: jQuery.validator.format("Введите максимум {0} знаков."),
		minlength: jQuery.validator.format("Введите минимум {0} знаков.")
	});
});
</script>
{/literal}
<div class="fullfield">
	<div class="ShAA_popBackTop"></div>
	<div class="ShAA_popBackCenter">
		{if $accepted}
			<h2>Ваш вопрос принят</h2>
		{else}	
		<div class="centered_text alert_text">Вопрос</div>
		<div class="left_text2 descr_text" style="margin: 30px 0 30px 80px;">Пожалуйста, заполните краткую контактную информацию, чтобы отправить вопрос.</div>
			<form autocomplete="off" action='/index.php?module=Faq&amp;action=question&amp;clear=true' method="post" id="form_faq" name="form_faq">
				<input name="is_question" type="hidden" value="true" />
				
				<div class="centered_text item_text2">
					Имя
				</div>
				<div class="input_wrap">
					<input class="text_input" id="field_name" notice='Пожалуйста назовитесь' value='{if $smarty.session.user}{$smarty.session.user->name}{/if}' placeholder="Имя Отчество Фамилия" name="name" maxlength=100 type="text" autofocus />
				</div>
				<div class="centered_text item_text2">
					Номер телефона
				</div>
				<div class="input_wrap phone">
					<input placeholder="XXXXXXXXXX" class="text_input contacts" id="field_number" format='number' notice='Пожалуйста, введите телефон' name="phone_number" maxlength="10" type="text" value='{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}' />
				</div>
						
				<div class="clear"></div>
			
				<div class="centered_text item_text2">
					Ваш вопрос
				</div>
				<div class="input_wrap">
					<textarea name="question" class="text_input textarea_input" placeholder="" ></textarea>
				</div>
				<div class="centered_text item_text2">
					Почта
				</div>
				<div class="input_wrap">
					<input id="field_email" class="text_input contacts" format='email' notice='Пожалуйста, введите e-mail' value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="Электронная почта"  name="email" maxlength=100 type="text"/>
				</div>
				
				<div class="clear"></div>
				<div style="margin: 15px 0 0 0;">
					<a href="javascript:void(0);"><input type="submit" value="Спросить" style="height:80px;padding:0;" class="button button560px button_text"></a>
				</div>
				<div class="clear"></div>
			</form>
		<div class="clear"></div>
		{/if}
	</div>
	<div class="ShAA_popBackBottom"></div>
</div>