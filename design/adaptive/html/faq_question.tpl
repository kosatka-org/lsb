<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{if $language=='eng'}<script src="/jscript/jquery.validationEngine-en.js" type="text/javascript"></script>
{else}<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>{/if}
<script src="/jscript/jquery.validationEngine.js?v=2"></script>

{literal}
<script>
jQuery(document).ready(function() {
	jQuery("#form_faq").validationEngine();
	jQuery("#field_name").focus();
});
</script>
{/literal}
<div class="fullfield">
	<div class="ShAA_popBackCenter">
		<div class="ShAA_loginBlock">
			<a href="#" onclick="history.back();" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
		<div class="ShAA_pop_title">{if $language=='eng'}Question{else}Вопрос{/if}</div>
		<div class="ShAA_popText">{if $language=='eng'}Please fill out the brief contact information to submit your question.{else}Пожалуйста, заполните краткую контактную информацию, чтобы отправить вопрос.{/if}</div>
		{if $accepted}
			<h2>{if $language=='eng'}Your question is accepted{else}Ваша вопрос принят{/if}</h2>
		{else}	
			<form autocomplete="off" action='/index.php?module=Faq&amp;action=question&amp;clear=true' method="post" id="form_faq" name="form_faq">
				<input name="is_question" type="hidden" value="true" />
				
				<div class="ShAA_popData ShAA_popDataSett" style="margin: 15px 0 0 0;">
					<div class="ShAA_popTitleInput">
						{if $language=='eng'}name{else}Имя{/if}
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
					<div class="ShAA_popInput {if $language != 'eng'} phone{/if}">
						{if $language != 'eng'}<span class="ShAA_prefixForMiniInput">+7</span>{/if}<input placeholder="XXXXXXXXXX" id="field_number" format='number' notice="{if $language=='eng'}Please enter your phone{else}Пожалуйста, введите телефон{/if}" {literal}class="validate[groupRequired[contacts],custom[phone]]"{/literal} value='{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}' name="phone_number" maxlength="{if $language=='eng'}15{else}10{/if}" type="text"/>
					</div>
					<div class="ShAA_popInfoInput">
						{if $language=='eng'}example: +449206003322{else}пример: 9206003322{/if}
					</div>
				</div>
							
				<div class="clear"></div>
				
				<div class="ShAA_popData ShAA_popDataSett" style="margin: 15px 0 0 0;">
					<div class="ShAA_popTitleInput">
						{if $language=='eng'}Your question{else}Ваш вопрос{/if}
					</div>
					<div class="ShAA_popInput">
						<textarea name="question" placeholder="" {literal}class="validate[required]"{/literal} ></textarea>
					</div>
				</div>
				
				<div class="ShAA_popData ShAA_popDataSett" style="margin: 15px 0 0 0; float:right;">
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
				
				<div class="clear"></div>
        <div class="ShAA_popData ShAA_popDataSett">
            <div class="g-recaptcha" data-sitekey="6LfDlk4UAAAAAAwQvfXiSySQrt89R8vDPb4i8qKK"></div>
        </div>
				<div class="clear"></div>
				<div style="margin: 15px 0 0 0;">
					<a href="javascript:void(0);"><input type="submit" value="{if $language=='eng'}Ask{else}Спросить{/if}" class="ShAA_popButton_input"></a>
				</div>
				<div class="clear"></div>
                <div class="ShAA_popMiniInfo" style="margin-top: 12px;">{if $language=='eng'}By clicking on the "Ask" button, you give <a href="/sections/personal_data_eng">consent to the processing of personal data</a>{else}Нажимая на кнопку "Спросить", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a>{/if}</div>
			</form>
		{/if}
		</div>
		<div class="clear"></div>
	</div>
</div>

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