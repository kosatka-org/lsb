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
						<p>Вы перешли по ссылке для входа на сайт</p>
					</div>
					<div style="float: left; width: 100%;">
						<input id="enter" type="submit" value="Войти" class="ShAA_popButton" style="float: none; width: 100%; padding: 12px 4%; margin: 12px auto;">
					</div>

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

<script>
var token = window.location.href.match(/otll_auth\/([0-9a-f]+)/i)[1];
var path = "/rest_api/otll/";

{literal}
$(document).on("click", "input#enter", function(e){
	e.preventDefault();
  window.location = path+token;
});
</script>
{/literal}
