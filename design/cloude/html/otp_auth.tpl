<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{literal}
<style>
    .headBlock, .footer {
        display: none;
    }
    .fullfield, .ShAA_popBackCenter {
        box-shadow: none !important;
        border: none !important;
        margin: 0 auto;
    }
</style>
{/literal}
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>

<div class="fullfield">
	<div class="ShAA_popBackCenter">
		<div class="ShAA_loginBlock">
			<a href="/" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
			<form autocomplete="off" action="/" method="get" name="form_discount1" id="form_discount1" enctype="multipart/form-data">
				<div class="sett1">
					<div style="text-align: center; width: 100%; margin: 0 0 24px 0;" class="logoOnline">
						<a href="/"><img width="90%" height="auto" style="max-width: 220px;" alt="Лакшери Стор" src="/images/new_logo.png"></a>
					</div>
					<div>
						<input name="module" type="hidden" value="Login"/>
						<div class="ShAA_popData">
              <div class="ShAA_popInput phone">
								<label>Если вы уже зарегистрированы, введите свой номер телефона</label>
								<span class="ShAA_prefix ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" type="text" name="phone" id="id_phone" {literal}class="validate[required,custom[phone]]"{/literal} value="{$save_phone_number}" maxlength="11" />
							</div>
						</div>
						<div class="ShAA_popData" id="otp_block" style="display:none; float: right; margin-left: 40px;">
							<label>На ваш номер отправлен 6-значный пароль для входа на сайт.</label>
							<div class="ShAA_popInput">
								<input placeholder="Пароль из SMS" type="text" id="otp" maxlength="6" {literal}class="validate[required],custom[onlyNumberSp]"{/literal}/>
							</div>
						</div>
					</div>
					<div style="float: left; width: 100%;">
						<input id="enter" type="submit" value="Войти" class="ShAA_popButton" style="float: none; width: 100%; padding: 12px 4%; margin: 12px auto;">
						<input id="resend_otp" type="submit" value="Отправить повторную СМС" class="ShAA_popButton" style="display: none; float: none; width: 100%; padding: 12px 4%; margin: 12px auto;">
					</div>
					{include file="networks_auth_buttons.tpl"}

					<div style="text-align: center; margin: 10px auto;">
						<a href="/reg/" class="cart_login_link" style="font-size: 14px;" onclick="{literal}rG('LOGIN_FROM_CART');{/literal}" title="Зарегистрируйтесь">Регистрация</a>
					</div>
					<div style="text-align: center; margin: 16px auto;">
						<a href="http://ru.lsboutique.ru/doctxt/diskont/" style="font-size: 14px; border-bottom: 1px solid #000;" target="_blank">Подробно о персональных скидках</a>
					</div>
				</div>
			</form>
		</div>
		<div class="clear"></div>
	</div>
</div>

{literal}
<script>

var phone = '';
var time = 0;
var otp = '';

$(document).on("click", "input#enter", function(e){
	e.preventDefault();
	if ($('#otp_block').is(':visible')) {
		verify_otp();
	}
	else {
		request_otp();
	}
});

$(document).on("click", "input#resend_otp", function(e){
	e.preventDefault();
	request_otp();
});

$(document).on("input", "input#otp", function(e){
	if ($(this).val().length === 6) {
		verify_otp();
	}
});

function request_otp () {
	phone = $('#id_phone').val();
  $.get("/rest_api/request_otp/"+phone, function(data) {
		phone = data.phone;
		time = data.time;
		$('#otp_block').show();
		$('#resend_otp').show();
	});
}

function verify_otp () {
	otp = $('#otp').val();
  $.post("/rest_api/verify_otp", JSON.stringify({phone: phone, time: time, otp: otp}), function(data) {
		if (data === "OK") {
			window.location.replace('/cart/');
		}
	});
}

</script>
{/literal}
