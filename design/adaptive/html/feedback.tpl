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
	#fancybox-title {
		display: none !important;
	}
	.ShAA_popDataSett {
		margin: 12px 0 6px 0;
	}
    
    .headBlock, .footer {
        display: none;
    }
    .fullfield, .ShAA_popBackCenter {
        box-shadow: none !important;
        border: none !important;
        margin: 0 auto;
    }
    .logoOnline {
        display: block !important;
    }
</style>
{/literal}

<div class="ShAA_popBackCenter">
	<div class="ShAA_loginBlock">
		<a href="#" onclick="history.back();return false;" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
		{if $accepted}
		<h2>{if $language=='eng'}Your application is accepted{else}Ваша заявка принята{/if}</h2>
		{else}
			<form autocomplete="off" method='post' action='/index.php?module=Feedback' id="form_feedback" name="form_feedback" enctype="multipart/form-data">
				<input format='.+' notice='name' value='{$brand_id}' name='brand_id' maxlength=100 type="text" style="display:none;"/>
				<div>
					<div class="ShAA_pop_title">{if $language=='eng'}Application{else}Заявка{/if}</div>
					<div class="ShAA_popText">{if $language=='eng'}Fill out the form to receive the newsletter about new arrivals.{else}Заполните форму, чтобы получать рассылку о новых поступлениях.{/if}</div>
					<div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Name{else}Обращение{/if}
							</div>
							<div class="ShAA_popInput">
								<input id="field_name" notice="{if $language=='eng'}Please identify youself{else}Пожалуйста назовитесь{/if}" value='{if $smarty.session.user}{$smarty.session.user->name}{/if}' placeholder="{if $language=='eng'}Name Surname{else}Имя Отчество Фамилия{/if}" name="name" maxlength=100 type="text" autofocus/>
							</div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example: John Doe{else}пример: Петр Сергеевич Иванов{/if}
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Phone number{else}Номер телефона{/if}
							</div>
							<div class="ShAA_popInput phone">
								<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" id="field_number" format='number' "{if $language=='eng'}Please enter your phone{else}Пожалуйста, введите телефон{/if}" {literal}class="validate[groupRequired[contacts],custom[phone]]"{/literal} value='{if $smarty.session.user->phone_number}{$smarty.session.user->phone_number}{/if}' name="phone_number" maxlength="{if $language=='eng'}15{else}10{/if}" type="text"/>
							</div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example: +449206003322{else}пример: 9206003322{/if}
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Email{else}Почта{/if}
							</div>
							<div class="ShAA_popInput">
								<input id="field_email"  format='email' notice="{if $language=='eng'}Please, enter{else}Пожалуйста, введите{/if} e-mail" {literal}class="validate[groupRequired[contacts],custom[email]]"{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="{if $language=='eng'}Email{else}Электронная почта{/if}"  name="email" maxlength=100 type="text"/>
							</div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example{else}пример{/if}: name@gmail.com
							</div>
						</div>
					</div>
					<div class="clear"></div>
					<div style="margin: 32px 0 18px 0; float: left; width: 100%;">
						<a href="javascript:void(0);" onclick="jQuery('#form_feedback').submit();return false;"><input type="submit" value="{if $language=='eng'}Subscribe{else}Подписаться{/if}" class="ShAA_popButton_input"></a>
					</div>
                    <div class="clear"></div>
                    <div class="ShAA_popMiniInfo" style="margin-top: 12px;">{if $language=='eng'}Back{else}Вернуться{/if}Нажимая на кнопку "Подписаться", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a></div>
				</div>
			</form>
		{/if}
	</div>
	<div class="clear"></div>
</div>