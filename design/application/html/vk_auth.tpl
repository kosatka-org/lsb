<!--<link rel="stylesheet" href="/design/mobile/css/validationEngine.jquery.css" type="text/css" />
<script type="text/javascript" src="/design/mobile/js/jquery.validationEngine.js"></script>
<script type="text/javascript" src="/design/mobile/js/jquery.validationEngine-ru.js"></script>
{literal}
<script>
	$(document).ready(function(){
		$("#form_discount1").validationEngine("attach");
		$("#card_form").validationEngine("attach");
	});
</script>
{/literal}-->
{literal}
<script>
	$(document).ready(function(){
		$('.back_button').click(function(){
			$('.forms').toggle();
		});
	});
</script>
{/literal}
<form autocomplete="off" action="/" method="get" name="form_discount1" id="form_discount1" enctype="multipart/form-data">
	<div class="forms">
		<input name="module" type="hidden" value="Login"/>
		<div class="centered_text normal_text">
			Номер телефона владельца карты
		</div>
		{literal}
			<script>
				var restore_request_send = false;
				$(document).ready(function(){
					$("#id_phone, #id_phone_remember").focus(function(){
						var save_phone_numberjs = $("#id_phone").val();
						if(jQuery.isNumeric(save_phone_numberjs))
							{$(this).val(save_phone_numberjs)} 
						else
							{$(this).val('+7')}
					});
					$("#id_phone, #id_phone_remember").blur(function(){
						var save_phone_numberjs = $(this).val();
						if(save_phone_numberjs == '+7')
							{$(this).val('')}
						else if (jQuery.isNumeric(save_phone_numberjs))
							{$("#id_phone_remember").val(save_phone_numberjs);} 
					});
					jQuery('#remember').click(function() {
						if ( !restore_request_send ) {				
							if ( jQuery('#id_phone_remember').eq(0).val() && jQuery('#id_phone_remember').eq(0).val().length > 9) {
								restore_request_send = true;
								jQuery.get('/index.php?module=Login&restore_card_number&phone=' + jQuery('#id_phone_remember').eq(0).val(), function(response) {
									restore_request_send = false;
									if ( response == 'ok' ) {
										jQuery('.forms').toggle();
										jQuery('#id_phone').eq(0).val(jQuery('#id_phone_remember').eq(0).val());
										alert('Пожалуйста, проверьте ваши СМС сообщения');
									}
									else {
										alert('Извините, такой номер телефона не найден');
									}
								});
							}
							else {
								alert('Пожалуйста, введите номер телефона полностью');
							}
						}
					});
				});
			</script>
		{/literal}
		<div class="input_wrap"><input type="text" {literal}class="text_input validate[required,custom[phone]]"{/literal} placeholder="+7  . . .  . . .  . .  . ." name="phone" id="id_phone" value="{$save_phone_number}"/></div>
		<div class="centered_text normal_text">
			Номер карты — 16 цифр
		</div>
		<div class="input_wrap"><input type="text" {literal}class="text_input validate[required,custom[onlyNumberSp]]"{/literal} placeholder=". . . .  . . . .  . . . .  . . . ." name="card_number" id="id_card_number" value="{$save_card_number}"/></div>
		<div class="button_wrap" style="margin: 0 0 0 40px;">
		{literal}
			<script>
				$(document).ready(function(){
					$(".button").mousedown(function(){
						$(this).addClass("mousedown");
					});
					$(".button").mouseup(function(){
						$(this).removeClass("mousedown");
					});
					$(".button").mouseleave(function(){
						$(this).removeClass("mousedown");
					});
				});
			</script>
		{/literal}
			<a href="javascript:void(0);" onclick="jQuery('#form_discount1').submit();return false;" title="Войти на сайт" alt="">
				<div class="button button240px button_text" style="margin: 20px 83px 20px 0;">
					<table>
						<tr>
							<td>
								Войти
							</td>
						</tr>
					</table>
				</div>
			</a>
			<a href="javascript:void(0);" title="" alt="">
				<div class="button button240px button_text back_button" style="margin: 20px 0 20px 0;">
					<table>
						<tr>
							<td>
								Забыл номер
							</td>
						</tr>
					</table>
				</div>
			</a>
		</div>
	</div>
	<div class="forms" style="display:none;">
		<div class="input_wrap"><input type="text" placeholder="+7  . . .  . . .  . .  . ." {literal}class="text_input validate[required,custom[phone]]"{/literal} name="phone_remember" id="id_phone_remember"  value="{$save_phone_number}"/></div>
		<div class="button_wrap" style="margin: 20px 0 20px 40px;">
			<a href="javascript:void(0);" title="" alt="">
				<div class="button button240px button_text" id="remember" style="margin: 0 83px 0 0;">
					<table>
						<tr>
							<td>
								Прислать номер
							</td>
						</tr>
					</table>
				</div>
			</a>
			<a href="javascript:void(0);" title="" alt="">
				<div class="button button240px button_text back_button">
					<table>
						<tr>
							<td>
								Назад
							</td>
						</tr>
					</table>
				</div>
			</a>
		</div>
	</div>
</form>