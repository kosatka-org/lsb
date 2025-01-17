<i>Искомый запрос нигде не встречается, пожалуйста, воспользуйтесь рубрикатором.</i><br />
<i style="font-size: 20px; float: left; margin: 24px 0 0 0; width: 100%;">
    Задайте свой вопрос, мы перезвоним в ближайшее время
</i><br />
<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
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
	<div class="ShAA_popBackCenter" style="margin: 0;">
		<div class="ShAA_loginBlock" style="padding: 24px 0;">
		{if $accepted}
			<h2>Ваша вопрос принят</h2>
		{else}
			<form autocomplete="off" action='/index.php?module=Faq&amp;action=question&amp;clear=true' method="post" id="form_faq" name="form_faq">
				<input name="is_question" type="hidden" value="true" />

				<div class="ShAA_popData ShAA_popDataSett" style="margin: 15px 0 0 0;">
					<div class="ShAA_popTitleInput">
						Имя
					</div>
					<div class="ShAA_popInput">
						<input id="field_name" notice='Пожалуйста назовитесь' value='{if $smarty.session.user}{$smarty.session.user->name}{/if}' placeholder="Имя Отчество Фамилия" name="name" maxlength=100 type="text" autofocus/>
					</div>
					<div class="ShAA_popInfoInput">
						пример: Петр Сергеевич Иванов
					</div>
				</div>
				<div class="ShAA_popData ShAA_popDataSett">
					<div class="ShAA_popTitleInput">
						Номер телефона
					</div>
					<div class="ShAA_popInput phone">
						<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" id="field_number" format='number' notice='Пожалуйста, введите телефон' {literal}class="validate[groupRequired[contacts],custom[phone]]"{/literal} value='{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}' name="phone_number" maxlength="10" type="text"/>
					</div>
					<div class="ShAA_popInfoInput">
						пример: 9206003322
					</div>
				</div>
				<div class="clear"></div>
				<div class="ShAA_popData ShAA_popDataSett" style="margin: 15px 0 0 0;">
					<div class="ShAA_popTitleInput">
						Ваш вопрос
					</div>
					<div class="ShAA_popInput">
						<textarea name="question" placeholder="" {literal}class="validate[required]"{/literal} ></textarea>
					</div>
				</div>
				<div class="ShAA_popData ShAA_popDataSett" style="margin: 15px 0 0 0; float:right;">
					<div class="ShAA_popTitleInput">
						Почта
					</div>
					<div class="ShAA_popInput">
						<input id="field_email"  format='email' notice='Пожалуйста, введите e-mail' {literal}class="validate[groupRequired[contacts],custom[email]]"{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="Электронная почта"  name="email" maxlength=100 type="text"/>
					</div>
					<div class="ShAA_popInfoInput">
						пример: name@gmail.com
					</div>
				</div>
				<div class="clear"></div>
				<div style="margin: 15px 0 0 0;">
					<a href="javascript:void(0);"><input type="submit" value="Спросить" class="ShAA_popButton_input"></a>
				</div>
				<div class="clear"></div>
                <div class="ShAA_popMiniInfo" style="margin-top: 12px;">Нажимая на кнопку "Спросить", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a></div>
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
    .fullfield, .ShAA_popBackCenter {
        box-shadow: none !important;
        border: none !important;
        margin: 0 auto;
    }
</style>
{/literal}

<div class="content ShAA_failpage" style="padding:0;">
	<div class="centerContent">
		<div class="checks" style="margin: 20px 0px 0 0;">
			<b>Бренды</b>
			<!--<div class="checkline"></div>-->
		</div>
		<div class="centerRightContent">
			<div class="topContent" style="height:0px;margin: 10px 0 18px;">
			</div>
			<div class="clear"></div>
{foreach from=$brands_full item=brand}
			<div class="abcColumn" style="height:30px;">
				<div class="abcNames"><h1><a href="/brands/{$brand->url}/">{$brand->name}</a></h1></div>
			</div>
{/foreach}
		</div>
	</div>

{foreach from=$categories_full item=category1}
	<div class="centerContent">
		<div class="checks" style="margin: 20px 0px 0 0;">
			<b>{$category1->name}</b>
			<!--<div class="checkline"></div>-->
		</div>
		<div class="centerRightContent">
			<div class="topContent" style="height:0px;margin: 10px 0 18px;">
			</div>
			<div class="clear"></div>
{foreach from=$category1->subcategories item=subcategory}
			<div class="abcColumn" style="height:30px;">
				<div class="abcNames"><h1><a href="/catalog/?category={$subcategory->category_id}">{$subcategory->name}</a></h1></div>
			</div>
{/foreach}
		</div>
	</div>
{/foreach}
</div>
