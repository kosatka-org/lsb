<script>
var payment_form = false;
</script>
<div><span class="titleMain" style="font-size: 18px;"><b>Ваш заказ №{$order->order_id}</b></span></div>
{if $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
{if $order->status == 0 && !$smarty.cookies.stats_send}
{assign var=hidden_brands value=","|explode:$user->show_hidden_brands}
<script>
{literal}
jQuery(document).ready(function() {
    var product_list = [];
    {/literal}{foreach from=$order->products item=product}{literal}
        product_list.push(
            {
                'sku': '{/literal}{$product->sku}{literal}', // Required 
                'name': '{/literal}{$product->product_name}{literal}', // Required 
                'category': '{/literal}{$product->brand_name}{literal}', 
                'price': {/literal}{$product->price}{literal}, // Required 
                'quantity': {/literal}{$product->quantity}{literal} // Required 
            }
        );
    {/literal}{/foreach}{literal}
    dataLayer.push({
        'transactionId': 'o{/literal}{$order->order_id}{literal}', // Required 
        'transactionAffiliation': 'Luxury Store', 
        'transactionTax': {/literal}'{if $new_user_order}0{else}1{/if}'{literal}, 
        'transactionTotal': {/literal}{$order->total_amount}{literal}, // Required
        'transactionShipping': {/literal}{$order->real_delivery_price }{literal},
        'transactionProducts': product_list
    });

    //Criteo dataLayer
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        var product_list = [];
        {/literal}{foreach from=$order->products item=product}
            {if !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}{literal}
                product_list.push(
                {
                    'id': '{/literal}{$product->barcode}{literal}',
                    'price': {/literal}{$product->price}{literal},
                    'quantity': {/literal}{$product->quantity}{literal} 
                }
            );
        {/literal}{/if}{/foreach}{literal}
        dataLayer.push({
            'CriteoEmail': {/literal}'{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}'{literal}, 
            'PageType': 'TransactionPage',
            'OrderProducts' : product_list,
            'CriteoTransactionId': '{/literal}o{$order->order_id}{literal}'
        })
    }
//More dataLayer
    var product_list = [];
    {/literal}{foreach from=$products item=product}
        {if !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}{literal}
            product_list.push({$product->barcode});
            total_price = total_price + {$product->price};
    {/literal}{/if}{/foreach}{literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'ProductPrice' : total_price,
                'productID' : product_list,
                'MT_PageType': 'purchase'
            })
        }
    });
        
    jQuery.cookie("stats_send", 1, {expires: 7, path: window.location.pathname});
});
{/literal}
</script>
{/if}
{/if}

<div class='order_products tableOrder' style="margin: 16px 0 0 0;">
<table class="order_products" rules="none" cellspacing="0" style="width: auto !important;">
	<tr class="head">
		<td width="200">Товар</td>
		<td width="80">Размер</td>
		<td width="75">Цена/Руб.</td>
	</tr>
	
	{foreach from=$order->products item=product}
		<tr class="" style="font-size: 12px;">
			<td style="padding-top:8px; padding-bottom:8px;">
				<a href="/products/{$product->url}/" target="_blank"><b>{$product->model|escape}</b></a>
			</td>			
			<td style="padding-top:8px; padding-bottom:8px;">{$product->size|escape}</td>
			<td style="padding-top:8px; padding-bottom:8px;">{$product->price|string_format:"%.2f"}</td>
		</tr>
	{/foreach}
	<tr>
		<td colspan="3" style="padding: 0; margin: 0; border: 0;">
			<table rules="none" cellspacing="0">
				{if $order->delivery_price}
				<tr class="gray" style="font-size: 12px;">
					<td class="notBorder" width="100"  style="padding-top:8px; padding-bottom:8px;">Доставка:</td>
					<td class="notBorder" style="background: #fff; padding-top:8px; padding-bottom:8px;"><b>{$order->delivery_price|string_format:"%.2f"}</b> {$currency->sign|escape}.</td>
				</tr>
				{/if}
				{if $order->deposit_payment}
				<tr class="gray" style="font-size: 12px;">
					<td class="notBorder" width="100"  style="padding-top:8px; padding-bottom:8px;">Депозит:</td>
					<td class="notBorder" style="background: #fff;padding-top:8px; padding-bottom:8px;"><b>-{$order->deposit_payment|string_format:"%.2f"}</b> {$currency->sign|escape}.</td>
				</tr>
				{/if}
				{if $order->coupon_code}
				<tr class="gray" style="font-size: 12px;">
					<td class="notBorder"  style="padding-top:8px;">Промо-код:</td>
					<td class="notBorder" style="background: #fff; padding-top:8px;">{$order->coupon_code}, скидка <b>{$order->coupon_discount}</b>{if $order->coupon_type == "absolute"} {$currency->sign|escape}.{else}%{/if}</td>
				</tr>
				{/if}
				<tr class="gray" style="font-size: 12px;">
					<td class="notBorder"  style="padding-top:8px;">Итого:</td>
					<td class="notBorder" style="background: #fff; padding-top:8px;"><b>{$order->total_amount|string_format:"%.2f"}</b> {$currency->sign|escape}.</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<div class="userInfo">
	<div>Покупатель: <b>{$order->name|escape}</b>, телефон: <b>{$order->phone|escape}</b></div>	
	<div class="ShAA_popTitleInput" style="margin-top:8px;">
		Пожалуйста, {if $order->email}проверьте{else}укажите{/if} контактные данные:
	</div>
	<div class="ShAA_popData ShAA_popDataSett" style="margin-top:8px;">
		<div class="ShAA_popInputOrder">
			<input class="user_info" data-order-id="{$order->order_id}" type="text" name="email" value="{$order->email|default:$smarty.session.user->email}" placeholder="Электронная почта, пример: name@gmail.com">
		</div>
	</div>
	{if $order->city_id}
		{assign var="city_id" value=$order->city_id}
	{elseif $smarty.session.user->city_id}
		{assign var="city_id" value=$smarty.session.user->city_id}
	{else}
		{assign var="city_id" value=0}
	{/if}
	<div class="ShAA_popData ShAA_popDataSett" style="margin-top:8px;">
		<div class="ShAA_popInputOrder">
			<select name="city_id" id="city_id" data-order-id="{$order->order_id}" class="user_info">
				<option value="0">Пожалуйста, выберите ваш город</option>
				<option value="0"> </option>
				{foreach from=$delivery_cities_main item=dcity}
					<option value="{$dcity->city_id}" {if $city_id == $dcity->city_id}selected{/if}><b>{$dcity->city_name}</b></option>
				{/foreach}
				<option value="0"> </option>
				{foreach from=$delivery_cities item=dcity}
					<option value="{$dcity->city_id}" {if $city_id == $dcity->city_id}selected{/if}>{$dcity->city_name}</option>
				{/foreach}
			</select>
		</div>
	</div>
	<div class="ShAA_popData ShAA_popDataSett" style="margin-top:8px;">
		<div class="ShAA_popInputOrder">
			<input class="user_info" data-order-id="{$order->order_id}" type="text" name="address" value="{$order->address|default:$smarty.session.user->adress|escape}" placeholder="улица, дом-квартира, пример: Ленина 5-23">
		</div>
	</div>
	<div class="ShAA_popData ShAA_popDataSett" style="margin-top:8px;">
		<div class="ShAA_popTitleInput" style="margin-top:8px;">
			Комментарий к заказу:
		</div>
		<div class="ShAA_popInputOrder">
			<textarea class="user_info" data-order-id="{$order->order_id}" name="user_comment">{$order->user_comment|default:''|escape}</textarea>
		</div>
	</div>
</div>
<div class="clear"><!-- /--></div>
{if $PaymentMethods && $order->payment_status != 1 && $status_order != success}
<div><span class="titleMain" style="font-size: 14px;"><b>Выберите способ оплаты:</b></span></div>
<div class="ShAA_paymentSystem"  style="width:800px;">
		{foreach name=payment from=$PaymentMethods item=payment_method}
		{if $payment_method->payment_method_id > 12 && $order->total_amount < 10000 && $order->city_id == 0}
			{php}continue;{/php}
		{/if}
		{if $payment_method->module != 'ya_money' || $order->total_amount < 15000}
		{if $payment_method->is_local && $config->homeRegion || !$payment_method->is_local}
			<div class="namePayment">
				<div class="textPayment" style="width:650px;">
					<div class="radioButton">
						<input type="radio" name="payment_method_id" class="user_info" id="radio_{$payment_method->payment_method_id}" value="{$payment_method->payment_method_id}" data-order-id="{$order->order_id}" 
						 onclick="{if $payment_method->payment_button}payment_form = jQuery('form', jQuery(this).parent().parent().parent());jQuery('#payment_button').show();jQuery('#complete_button').hide();{else}payment_form = false;jQuery('#payment_button').hide();jQuery('#complete_button').show();{/if}"/>
					</div>
					<label for="radio_{$payment_method->payment_method_id}">
					<div class="ShAA_paymentName" style="width:600px;">
						{$payment_method->name}
					</div>
					</label>
					<div class="ShAA_paymentDescription">
						{$payment_method->description}
					</div>
				</div>
				{if $payment_method->image}
					<div class="imagePayment" style="float:right;"><img src="/images/{$payment_method->image}" /></div>
				{/if}
				{if $payment_method->payment_button}
					{$payment_method->payment_button}
				{/if}
			</div>
			<script>jQuery('#radio_12').attr("checked","true");</script>
			<div class="clear"></div>
		{/if}{/if}
		{/foreach}
</div>
<div class="clear"><!-- /--></div>
<div class="clear"></div>
{/if}
<span id="payment_button" style="display: none;">
	<div class="ShAA_paymentOrderButton" onclick="if (payment_form) payment_form.submit(); else alert('Пожалуйста, выберите способ оплаты');" style="margin-right: 24px;"></div>
</span>
<span id="complete_button">
	<a {if $smarty.session.user}href="/cart/show_z/"{else}href="/"{/if}><div class="ShAA_completeButton" style="margin: -1px 25px 0 4px;"></div></a>
</span>
<span class="noprint">
	<div class="ShAA_printOrder" style="margin-bottom: 50px;">
		<a href='javascript:window.print(); void 0;'><img src="/images/icon_print.png" > Печать чека</a>
	</div>
</span>


<div class="clear"><!-- /--></div>


{if $need_social_account}
{literal}
<a href="/cart/soc_add/" rel="facebox" id="soc_add_link"></a>
<script language="javascript">
    $(document).ready(function(){
        $('#soc_add_link').click();
    });
</script>
{/literal}
{/if}

{if $status_order == fail || $status_order == success}
<div class="ShAA_manOrWoman" id="ShAA_statusOrder">
{if $status_order == success}
    <div class="title">Ваш заказ оплачен! </div>
    <a onclick="{literal}$.fancybox.close();{/literal}"><img src="/images/close_manorwoman.png" style="float: right; margin: 8px 0 0 0;" width="62"></a>
    <div class="line"></div>
    <div class="text">
        Ждём Вас снова
    </div>
    <div class="clear"></div>
{/if}
{if $status_order == fail}
    <div class="title">Оплата не произведена! </div>
    <a onclick="{literal}$.fancybox.close();{/literal}"><img src="../images/close_manorwoman.png" style="float: right; margin: 8px 0 0 0;" width="62"></a>
    <div class="line"></div>
    <div class="text">
        Попробуйте ещё раз
    </div>
    <div class="clear"></div>
{/if}
</div>
{literal}
<a href="#ShAA_statusOrder" rel="facebox" id="id_status_order"></a>
<script type="text/javascript">
	jQuery(document).ready(function() {
		jQuery("#id_status_order").trigger("click");
	});
</script>
<style>
	#fancybox-bg-w, #fancybox-bg-e, #fancybox-bg-n, #fancybox-bg-s, #fancybox-bg-sw, #fancybox-bg-se, #fancybox-bg-nw, #fancybox-bg-ne {
		background: none;
	}
	#fancybox-outer {
		background: none;
	}
</style>
{/literal}
{/if}
{if $add_to_ecommerce}
{literal}
<script type="text/javascript">
	jQuery(document).ready(function() {
		if ( window._gaq !== undefined ) {
			_gaq.push(['_addTrans',
				'{/literal}{$order->order_id}{literal}',           // order ID - required
				'Luxury Store',  // affiliation or store name
				'{/literal}{$order->total_amount|string_format:"%.2f"}{literal}',          // total - required
				'0',	           // tax
				'0',              // shipping
				'{/literal}{$order->address}{literal}',       // city
				'Russia',     	// state or province
				'Russia'          // country
			]);
			{/literal}{foreach from=$order->products item=product}
			{literal}
				_gaq.push(['_addItem',
				'{/literal}{$order->order_id}{literal}',           // order ID - required
				'{/literal}{$product->sku|escape}{literal}',           // SKU/code - required
				'{/literal}{$product->model|escape}{literal}',        // product name
				'{/literal}{$product->category_name|escape}{literal}',   // category or variation
				'{/literal}{$product->price|string_format:"%.2f"}{literal}',          // unit price - required
				'1'               // quantity - required
				]);
			{/literal}{/foreach}{literal}
			_gaq.push(['_trackTrans']); //submits transaction to the Analytics servers
		}

        if (typeof(dataLayer) !== 'undefined' && dataLayer) { // Коллектор данных для ecommerse
            ecommerce = {};
            ecommerce["currencyCode"] = "RUB";
            ecommerce['purchase']     = {"actionField": { "id"      : "D{/literal}{$order->order_id}{literal}",
                                                          "goal_id" : "10066135"}, 
                                         "products": [
            {/literal}{foreach from=$order->products item=product}{literal}
                {  id: "{/literal}{$product->sku|escape}{literal}",
                 name: "{/literal}{$product->model|escape}{literal}",
                price: {/literal}{$product->price|string_format:"%.2f"}{literal},
                quantity: 1},
            {/literal}{/foreach}{literal}{}]};
            dataLayer.push({"ecommerce" : ecommerce});
        }
    });
</script>
{/literal}
{/if}

{literal}
<script type="text/javascript">
$(document).on("blur", ".user_info", function(e) {
    var order_id = $(this).data('order-id');
    var name = $(this).attr('name');
    var update_object = {order_id: order_id, data: {}};
    update_object.data[name] = $(this).val();
    $.post('/order/', {update_object: JSON.stringify(update_object)});
});
</script>
{/literal}


 
