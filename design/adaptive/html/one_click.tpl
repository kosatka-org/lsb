<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{if $language=='eng'}<script src="/jscript/jquery.validationEngine-en.js" type="text/javascript"></script>
{else}<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>{/if}
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>
<script src="/jscript/jquery.autocompleteNew.js"></script>
<link media="all" href="/jscript/jquery.autocompleteNew.css" rel="stylesheet" type="text/css" />

<!-- Вы можете упростить возвращение -->
{literal}
<script>
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      dataLayer.push({
       'ecommerce': {
         'currencyCode': 'RUB',
         'checkout': {
           'actionField': {'step': 2,'option': 'one_click'},
           'products': [{
              'name': '{/literal}{$product->model}{literal}',
              'id': '{/literal}{$product->product_id}{literal}',
              'price': '{/literal}{$product->price}{literal}',
              'brand': '{/literal}{$product->brand|upper}{literal}',
              'category': '{/literal}{$product->category}{literal}',
              'variant': '{/literal}{$product->sku}{literal}',
              'quantity': 1
            }]
         }
       },
       'event': 'gtm-ee-event',
       'gtm-ee-event-category': 'Enhanced Ecommerce',
       'gtm-ee-event-action': 'Checkout Step 2',
       'gtm-ee-event-non-interaction': false,
      });
      console.log(dataLayer);
    }
</script>
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

<script>
jQuery(document).ready(function() {
	jQuery("#one_click").validationEngine();
	jQuery("#phone_number").blur(function() {
		jQuery.cookie('user_phone_number', jQuery(this).val(), {expires: 7, path: "/"});
	});
	jQuery("#name").blur(function() {
		jQuery.cookie('user_name', jQuery(this).val(), {expires: 7, path: "/"});
	});
    $('#referrer').val(ref);
});
</script>
{/literal}
<div class="ShAA_popBackCenter">
	<div style="position: relative" class="ShAA_loginBlock">
		<a href="#" onclick="history.back();return false;" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
		<div class="ShAA_pop_title">{if $language=='eng'}Make an order{else}Сделать заказ{/if}</div>
		<div class="ShAA_popText">
      {if $language=='eng'}
        We use the minimum order form. There are only two required fields - name and phone number. Online-manager will tell you the details.
      {else}
        Мы используем минимальную форму заказа. Всего два обязательных поля - имя и номер телефона. <br>
        Применение персональной скидки и оформление заказа завершит сотрудник интернет-магазина и сообщит вам детали.
      {/if}
		</div>
	
		<form autocomplete="off" action='/index.php?module=Feedback&one_click' method="post" name="one_click" id="one_click" enctype="multipart/form-data">
			<input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Your name{else}Ваше имя{/if}
				</div>
				<div class="ShAA_popInput">
					<input placeholder="{if $language=='eng'}Name{else}Имя{/if}" type="text" name="name" id="name" class="validate[required]" value="{if $smarty.cookies.user_name}{$smarty.cookies.user_name}{elseif $smarty.session.user->name}{$smarty.session.user->name}{/if}" autofocus/>
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example: John Doe{else}пример: Василий Петрович{/if}
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 22px 0 0 0;">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Phone number{else}Номер телефона{/if}
				</div>
				<div class="ShAA_popInput{if $language != 'eng'} phone{/if}">
					{if $language != 'eng'}<span class="ShAA_prefixForMiniInput">+7</span>{/if}<input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]]"{/literal} value="{if $smarty.cookies.user_phone_number}{$smarty.cookies.user_phone_number}{elseif $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}" onblur="{literal}jQuery('.ShAA_popResult').load('/index.php?module=Cart&phone_check&search='+jQuery('#phone_number').eq(0).val().replace(/ /g, '+'));return false;{/literal}"  maxlength="{if $language=='eng'}15{else}12{/if}" />
					<input type="hidden" name="product_id"    value="{$product_id}"/>
					<input type="hidden" name="from_page" value="{$from_page}"/>
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
					<input id="field_email" {literal}class="validate[custom[email]]"{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="{if $language=='eng'}Email{else}Электронная почта{/if}"  name="field_email" maxlength=100 type="text"/>
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example{else}пример{/if}: name@gmail.com
				</div>
			</div>
			<div class="clear"></div>
			<div style="margin: 32px 0 0 0;">
				<a href="javascript:void(0);" onclick="jQuery('#one_click').submit();{literal}rG('BUY_ONE_CLICK_ORDER_FORM');{/literal}return false;"><input type="submit" value="Ок" style="font-size: 16px;" class="ShAA_popButton_input"></a>
			</div>
			<!--<div style="float: right; margin: 16px 0 0 0;" class="ShAA_popMiniInfo">
				<a class="ShAA_productDesigner" href="#" onclick="window.open('http://issa.mangotele.com/widget/MTAzOTY4', 'mangotele_widget', 'width=238,height=215,resizable=no,toolbar=no,menubar=no,location=no,status=no'); return false;" style="margin-left:13px;">
					Позвонить с компьютера
				</a>
			</div>-->
			<div class="clear"></div>
            <div class="ShAA_popMiniInfo" style="margin-top: 12px;">{if $language=='eng'}Pressing an "ОК" button you agreeing to our <a href="/sections/personal_data_eng">Privacy & Cookies</a> policy{else}Нажимая на кнопку "ОК", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a>{/if}</div>
		</form>
		<div class="ShAA_popResult">
				</div>
	</div>
	<div class="clear"></div>
</div>
<!-- end Вы можете упростить возвращение -->