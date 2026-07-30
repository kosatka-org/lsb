<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{if $language=='eng'}<script src="/jscript/jquery.validationEngine-en.js" type="text/javascript"></script>
{else}<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>{/if}
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

{literal}
<script>
	send_order = 0;
	function clearText(thefield){
		if (thefield.defaultValue==thefield.value)
		thefield.value = "";
	}
	$(document).ready( function() {
    $('#referrer').val(ref);
	
		promo_code = $('#sneaky_form input[name="coupon_code"]').val();
		if (promo_code)	$('#form_order input[name="coupon_code"]').val(promo_code);
    
    var product_list = [];
    {/literal}{foreach from=$products item=product}{literal}
      product_list.push(
        {
          'name': '{/literal}{$product->model}{literal}',
          'id': '{/literal}{$product->product_id}{literal}',
          'price': '{/literal}{$product->price}{literal}',
          'brand': '{/literal}{$product->brand|upper}{literal}',
          'category': '{/literal}{$product->category}{literal}',
          'variant': '{/literal}{$product->sku}{literal}',
          'quantity': 1
        }
      );
    {/literal}{/foreach}{literal}
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      dataLayer.push({
       'ecommerce': {
         'currencyCode': 'RUB',
         'checkout': {
           'actionField': {'step': 2,'option': 'cart'},
           'products': product_list
         }
       },
       'event': 'gtm-ee-event',
       'gtm-ee-event-category': 'Enhanced Ecommerce',
       'gtm-ee-event-action': 'Checkout Step 2',
       'gtm-ee-event-non-interaction': false,
      });
      console.log(dataLayer);
    }
		$(".formError").remove();
		$("#form_order").validationEngine();
		
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
		$('input').keydown(function(e) {
			if (e.keyCode == 13) {
				$('#form_order').submit();
			}
		});
	});
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

{/literal}


<div class="ShAA_popBackCenter">
	<div class="ShAA_loginBlock">
		<a href="#" onclick="history.back();return false;" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
		{if $group_id == 2 || $group_id == 3 }
			<div class="info" style="color: red;">Внимание, вы оформляете заказ, как модератор или администратор</div>
		{/if}
		<div class="ShAA_pop_title">{if $language=='eng'}Please, fill out the contact information{else}Пожалуйста, заполните контактную информацию{/if}</div>
		
		<form autocomplete="off" action="/cart/" method="post" name="form_order" id="form_order" onsubmit="{literal}if ( typeof(order_send) == 'undefined' ) { order_send = 1; }{/literal}">
		
			<input name="coupon_code" type="hidden" value="{$coupon_code|escape}" />
			<input type="hidden" value="1" name="submit_order"/>
            <input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
			
			<div class="ShAA_popData ShAA_popDataSett" style="margin: 32px 0 0 0;">
				<div class="ShAA_popTitleInput">
					{if $language=='eng'}Your name{else}Ваше имя{/if}
				</div>
				<div class="ShAA_popInput">
					<input name="name" id="name" type="text" {literal}class="validate[required]"{/literal} value="{if $smarty.session.user}{$smarty.session.user->name}{else}{/if}" placeholder="{if $language=='eng'}Name{else}Имя{/if}" onclick="if (send_order) send_order=0;" autofocus/>
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
					{if $language != 'eng'}<span class="ShAA_prefixForMiniInput">+7</span>{/if}
					<input placeholder="XXXXXXXXXX" name="phone" id="order_phone" type="text" {literal}class="validate[required,custom[phone]]" pattern="[0-9]{10,15}"{/literal} value='{if $smarty.session.user->phone_number}{$smarty.session.user->phone_number}{/if}' maxlength="{if $language=='eng'}15{else}10{/if}" type="text" onclick="if (send_order)send_order=0;" />
<!--
					<input type="hidden" name="product_id" value="{$product_id}"/>
					<input type="hidden" name="from_page" value="{$from_page}"/>
-->
				</div>
				<div class="ShAA_popInfoInput">
					{if $language=='eng'}example: +449206003322{else}пример: 9206003322{/if}
				</div>
			</div>
			
			
			{if $smarty.session.user}
<!--
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Почта
				</div>
				<div class="ShAA_popInput">
					<input name="email" id="email" type="text" {literal}class=""{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="Электронная почта, пример: name@gmail.com" maxlength=100 type="text" onclick="if (send_order) send_order=0;" />
				</div>
				<div class="ShAA_popInfoInput">
					пример: name@gmail.com
				</div>				
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Город
				</div>
				<div class="ShAA_popInputOrder">
					<select name="city_id" id="city_id" class="" {if $total < 10000}onchange="$('#delivery_area').html($('#delivery_area_holder').html());$('#delivery_area').load('/delivery_price.php?city_id=' + $('#city_id').eq(0).val() + '&total={$total}&weight={$weight}');"{/if}>
						<option value="0">Пожалуйста, выберите ваш город</option>
						<option value="0"> </option>
						{foreach from=$delivery_cities_main item=delivery_city}
							<option value="{$delivery_city->city_id}" {if $smarty.session.user->city_id == $delivery_city->city_id}selected{/if}><b>{$delivery_city->city_name}</b></option>
						{/foreach}
						<option value="0"> </option>
						{foreach from=$delivery_cities item=delivery_city}
							<option value="{$delivery_city->city_id}" {if $smarty.session.user->city_id == $delivery_city->city_id}selected{/if}>{$delivery_city->city_name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Адрес
				</div>
				<div class="ShAA_popInputOrder">
					<input name="address" id="address" type="text" value="{if $smarty.session.user->adress}{$smarty.session.user->adress}{else}{/if}{literal}" placeholder="улица, дом-квартира, пример: Ленина 5-23" class=""{/literal} onclick="if (send_order) send_order=0;" />
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Ваш комментарий
				</div>
				<div class="ShAA_popInputOrder">
					<textarea name="comment" id="comment" placeholder=""></textarea>
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<span id="delivery_area_holder" style="display:none;">
					<div class="info">Уточняем стоимость доставки...</div>
				</span>
				<span id="delivery_area">
					{if $total >= 10000}
						<div class="ShAA_orderField">
							<div class="title">Доставка бесплатно</div>
						</div>
					{elseif $smarty.session.user->city_id}
						<div class="info">Уточняем стоимость доставки...</div>
					{literal}
						<script>
							$(document).ready( function() {
								$('#delivery_area').load('/delivery_price.php?city_id={/literal}{$smarty.session.user->city_id}&total={$total}&weight={$weight}{literal}');
							});
						</script>
					{/literal}
					{else}
						<div class="info">Стоимость доставки будет расчитана, после выбора города</div>
					{/if}
				</span>
			</div>
-->
			{/if}
			
			<div class="clear"></div>
			<div style="margin: 32px 0 0 0;">
				<a href="javascript:void(0);" onclick="{literal} if (!send_order) $('#form_order').submit(); send_order=1; rG('BUY_CART_ORDER_FORM'); return false;{/literal}">
					<input type="submit" value="{if $language=='eng'}Order{else}Заказать{/if}" class="ShAA_popButton_input">
				</a>
			</div>
			<div class="clear"></div>
            <div class="ShAA_popMiniInfo" style="margin-top: 12px;">{if $language=='eng'}Pressing an "Order" button you agreeing to our <a href="/sections/personal_data_eng">Privacy & Cookies</a> policy{else}Нажимая на кнопку "Заказать", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a>{/if}</div>
		</form>
	</div>
	<div class="clear"></div>
</div>