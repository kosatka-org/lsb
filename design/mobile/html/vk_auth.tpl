<script type="text/javascript" src="/design/mobile/js/jquery.validate.min.js"></script>
{literal}
<script>
	$(document).ready(function(){
		$("#form_discount1").validate({
			 rules: {
				phone: {
				  required: true,
				  digits: true,
				  minlength: 10,
				  maxlength: 10
				},
				card_number: {
				  required: true,
				  digits: true,
				  minlength: 5,
				  maxlength: 5
				}
			  }
		});
		jQuery.extend(jQuery.validator.messages, {
			required: "Необходимо заполнить.",
			digits: "Только цифры.",
			maxlength: jQuery.validator.format("Введите максимум {0} знаков."),
			minlength: jQuery.validator.format("Введите минимум {0} знаков.")
		});
		$("#card_form").validate();
	});
</script>
{/literal}
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
	<div class="centered_text" style="width:100%; margin-bottom:20px;">
		<div class="centered_text normal_text">
			Войти используя учетную<br>
			запись социальной сети
		</div>
		{if $settings->vk_login_client_id}<a href="http://oauth.vk.com/authorize?client_id={$settings->vk_login_client_id}&redirect_uri=http://{$server_name}/login?net-work=vkontakte&response_type=code"><div class="socnet vk"></div></a>{/if}
		{if $settings->ok_login_client_id}<a href="http://www.odnoklassniki.ru/oauth/authorize?client_id={$settings->ok_login_client_id}&response_type=code&redirect_uri=http://{$server_name}/login?net-work=odnoklassniki"><div class="socnet class"></div></a>{/if}
		{if $settings->mail_login_client_id}<a href="https://connect.mail.ru/oauth/authorize?client_id={$settings->mail_login_client_id}&response_type=code&redirect_uri=http://{$server_name}/login?net-work=mailru"><div class="socnet mail"></div></a>{/if}
		{if $settings->fb_login_client_id}<a href="https://www.facebook.com/dialog/oauth?client_id={$settings->fb_login_client_id}&redirect_uri=http://{$server_name}/login?net-work=facebook&response_type=code&scope=email"><div class="socnet facebook"></div></a>{/if}
	</div>
	<div class="divider" style="margin: 0;"></div>
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
							{$(this).val('')}
					});
					$("#id_phone, #id_phone_remember").blur(function(){
						var save_phone_numberjs = $(this).val();
						if(save_phone_numberjs == '')
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
		<div class="input_wrap"><span>+7 </span><input type="text" {literal}class="text_input text_input_override"{/literal} placeholder=". . .  . . .  . .  . ." name="phone" id="id_phone" value="{$save_phone_number}" maxlength="10"/></div>
		<div class="centered_text normal_text">
			Последние 5 цифр карты
		</div>
		<div class="input_wrap"><input type="text" {literal}class="text_input"{/literal} placeholder=". . . . ." name="card_number" id="id_card_number" value="{$save_card_number}" maxlength="5"/></div>
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
		<div class="input_wrap"><input type="text" placeholder="+7  . . .  . . .  . .  . ." {literal}class="text_input validate[required,custom[phone]]"{/literal} name="phone_remember" id="id_phone_remember" value="{$save_phone_number}" maxlength="10" /></div>
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