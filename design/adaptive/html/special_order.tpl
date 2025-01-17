<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
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
           'actionField': {'step': 2,'option': 'special_order'},
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
	jQuery("#special_order").validationEngine();
	jQuery("#phone_number").blur(function() {
		jQuery.cookie('user_phone_number', jQuery(this).val(), {expires: 7, path: "/"});
	});
	jQuery("#name").blur(function() {
		jQuery.cookie('user_name', jQuery(this).val(), {expires: 7, path: "/"});
	});
});
</script>
{/literal}
<div class="ShAA_popBackCenter">
	<div class="ShAA_loginBlock">
		<a href="#" onclick="history.back();return false;" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
		<div class="ShAA_pop_title">{if $language=='eng'}Make an order{else}Сделать заказ{/if}</div>	
		<form autocomplete="off" action='/index.php?module=Cart&special_order_save' method="post" name="special_order" id="special_order" enctype="multipart/form-data">
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Your size{else}Ваш размер{/if}
				</div>
				<div class="ShAA_popInput">
					<select name="product_size" style="border-radius: 2px;width: 99%;" id="product_size">
                        <option selected value="">---</option>
                        {if $product->parent == 2 || $product->category_id == 2}
                            {foreach from=$shoesizes item=size}
                                <option value="{$size}" {if $product->product_size == $size}selected{/if}>{$size}</option>
                            {/foreach}
                        {elseif $product->parent == 4 || $product->category_id == 4}
                            <option value="undefined">Нет размера</option>
                        {else}
                            {foreach from=$sizes item=size}
                                <option value="{$size}" {if $product->product_size == $size}selected{/if}>{$size}</option>
                            {/foreach}
                        {/if}
                    </select>
				</div>
			</div>
            <div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Your name{else}Ваше имя{/if}
				</div>
				<div class="ShAA_popInput">
					<input placeholder="{if $language=='eng'}Name{else}Имя{/if}" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value="{if $smarty.cookies.user_name}{$smarty.cookies.user_name}{elseif $smarty.session.user->name}{$smarty.session.user->name}{/if}" autofocus/>
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example: John Doe{else}пример: Василий Петрович{/if}
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 22px 0 0 0;">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Phone number{else}Номер телефона{/if}
				</div>
				<div class="ShAA_popInput {if $language != 'eng'} phone{/if}">
					{if $language != 'eng'}<span class="ShAA_prefixForMiniInput">+7</span>{/if}<input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]]"{/literal} value="{if $smarty.cookies.user_phone_number}{$smarty.cookies.user_phone_number}{elseif $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}" onblur="{literal}jQuery('.ShAA_popResult').load('/index.php?module=Cart&phone_check&search='+jQuery('#phone_number').eq(0).val().replace(/ /g, '+'));return false;{/literal}"  maxlength="{if $language=='eng'}15{else}12{/if}" />
                    <input type="hidden" name="product_id"    value="{$product_id}"/>
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example{else}пример{/if}: 9206003322
				</div>
				
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Email{else}Почта{/if}
				</div>
				<div class="ShAA_popInput">
					<input id="email" {literal}class="validate[custom[email]]"{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="{if $language=='eng'}Email{else}Электронная почта{/if}"  name="email" maxlength=100 type="text"/>
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example{else}пример{/if}: name@gmail.com
				</div>
			</div>
			<div class="clear"></div>
			<div style="margin: 32px 0 0 0;">
				<a href="javascript:void(0);" onclick="jQuery('#special_order').submit();{literal}rG('BUY_SPECIAL_ORDER_FORM');{/literal}return false;"><input type="submit" value="Ок" style="font-size: 16px;" class="ShAA_popButton_input"></a>
			</div>
			<div class="clear"></div>
            <div class="ShAA_popMiniInfo" style="margin-top: 12px;">{if $language=='eng'}Pressing an "ОК" button you agreeing to our <a href="/sections/personal_data_eng">Privacy & Cookies</a> policy{else}Нажимая на кнопку "ОК", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a>{/if}</div>
		</form>
		<div class="ShAA_popResult">
				</div>
	</div>
	<div class="clear"></div>
</div>