<div style="float: left; width: 100%; margin: 24px 0;"><span class="titleMain" style="font-size: 18px;"><b>{if $language=='eng'}Your order{else}Ваш заказ{/if} №{$order->order_id}</b></span></div>
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
                'category': '{/literal}{$product->brand_name|upper}{literal}',
                'price': {/literal}{$product->price}{literal}, // Required
                "priceCurrency": "RUB",  // код валюты ISO-4217 alfa-3 (для Admitad)
                "tariff": "1",           // код тарифа (для Admitad)
                'quantity': {/literal}{$product->quantity}{literal} // Required
            }
        );
    {/literal}{/foreach}{literal}
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      dataLayer.push({
          'transactionId': 'o{/literal}{$order->order_id}{literal}', // Required
          'transactionAffiliation': 'Luxury Store',
          "transactionChannel": "adm", // параметр дедупликации (для Admitad)
          "transactionAction": "1",    // код целевого действия (для Admitad)
          'transactionTax': {/literal}'{if $new_user_order}0{else}1{/if}'{literal},
          'transactionTotal': {/literal}{$order->total_amount}{literal}, // Required
          'transactionShipping': {/literal}{$order->real_delivery_price }{literal},
          'transactionProducts': product_list
      });
    }
    //Criteo dataLayer
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        var product_list = [];
        {/literal}{foreach from=$order->products item=product}
            {if in_array($product->product_id, $DL_products) && $product->category_enabled != 0}{literal}
                product_list.push(
                {
                    'id': '{/literal}{$product->barcode}{literal}',
                    'price': {/literal}{$product->price}{literal},
                    'quantity': {/literal}{$product->quantity}{literal}
                }
            );
        {/literal}{/if}{/foreach}{literal}
        if (product_list != []) {
          dataLayer.push({
              'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
              'PageType': 'TransactionPage',
              'OrderProducts' : product_list,
              'CriteoTransactionId': '{/literal}o{$order->order_id}{literal}'
          })
        }
    }
    //More dataLayer
    var product_list = [];
    var products = [];
    var total_price = 0;
    {/literal}{foreach from=$order->products item=product}
        {if !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}{literal}
            product_list.push({/literal}{$product->barcode}{literal});
            total_price = total_price + {/literal}{$product->order_price}{literal};
            products.push({/literal}{$product->product_id}{literal});
    {/literal}{/if}{/foreach}{literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'ProductPrice' : total_price,
                'productID' : product_list,
                'MT_PageType': 'purchase'
            })
            dataLayer.push({
                'ecomm_totalvalue' : total_price,
                'ecomm_prodid' : products.join(','),
                'ecomm_pagetype': 'purchase'
            })
        }
    });

    var product_list = [];
      {/literal}{foreach from=$order->products item=product}
        {if !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}
            var brand_name = '{$product->brand_name|upper}'.replace(/'/g, "`"),
                name = "{$product->model}".replace(/'/g, "`"),
                price = parseInt("{$product->order_price}");{literal}
        product_list.push(
          {
              'id': '{/literal}{$product->product_id}{literal}',
              'name': name,
              'price': "{/literal}{$product->order_price|number_format:0:'':''}{literal}",
              'brand': brand_name,
              'category': '{/literal}{$product->category_name}{literal}',
              'variant': '{/literal}{$product->sku}{literal}',
              'quantity': 1
          }
        );
      {/literal}{/if}{/foreach}{literal}

  jQuery(document).ready(function() {
    if (typeof(dataLayer) !== 'undefined' && dataLayer && product_list != []) {
      dataLayer.push({
       'ecommerce': {
         'currencyCode': 'RUB',
         'checkout': {
           'actionField': {'step': 3,'option': 'cart'},
           'products': product_list
         }
       },
       'event': 'gtm-ee-event',
       'gtm-ee-event-category': 'Enhanced Ecommerce',
       'gtm-ee-event-action': 'Checkout Step 3',
       'gtm-ee-event-non-interaction': false,
      });
      console.log(dataLayer);
    }
  });

  jQuery(document).ready(function() {
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      dataLayer.push({
         'ecommerce': {
           'currencyCode': 'RUB',
           'purchase': {
             'actionField': {
               'id': 'o{/literal}{$order->order_id}{literal}',
               'affiliation': 'Luxury Store',
               'revenue': total_price+'',
               'tax': '{/literal}{if $new_user_order}0{else}1{/if}{literal}',
               'coupon': '{/literal}{$smarty.session.user->personal_discount}{literal}'
             },
             'products': product_list
           }
         },
       'event': 'gtm-ee-event',
       'gtm-ee-event-category': 'Enhanced Ecommerce',
       'gtm-ee-event-action': 'Purchase',
       'gtm-ee-event-non-interaction': false,
      });
      console.log(dataLayer);
    }
  });
    jQuery.cookie("stats_send", 1, {expires: 7, path: window.location.pathname});
});
{/literal}
</script>
{/if}
{/if}
<div class='order_products tableOrder'>
<table class="order_products" rules="none" cellspacing="0" style="width: auto !important; min-width: 51%; float: left;">
    <tr class="head">
        <td width="200">{if $language=='eng'}Product{else}Товар{/if}</td>
        <td width="80">{if $language=='eng'}Size{else}Размер{/if}</td>
        <td width="75">{if $language=='eng'}Price{else}Цена/Руб.{/if}</td>
        {if !$order->no_payment_discount && $order->with_online_discount}
            <td width="75">-5% при оплате online</td>
        {/if}
    </tr>

    {foreach from=$order->products item=product}
        <tr class="" style="font-size: 12px;">
            <td style="padding-top:8px; padding-bottom:8px;">
                <a href="/products/{$product->url}/" target="_blank">{$product->model|escape}</a>
            </td>
            <td style="padding-top:8px; padding-bottom:8px;">{$product->size|escape}</td>
            <td style="padding-top:8px; padding-bottom:8px; text-align: right;">
            {if ($order->no_payment_discount || !$product->with_online_discount) || !$order_paid}
              <span class="price rub">{$product->order_price|string_format:"%.0f"}&nbsp;<i class="icon-rub"></i></span>
              {foreach from=$cat_currencies item=cur}
                {assign var="c_name" value="order_price_`$cur->code`"}
                <span class="price {$cur->code}" style="display:none;">{$product->c_prices->$c_name|number_format:0:" ":" "}&nbsp;<b>{$cur->sign}</b></span>
              {/foreach}
            {/if}
						</td>
            {if !$order->no_payment_discount && $product->with_online_discount}
                <td style="padding-top:8px; padding-bottom:8px; text-align: right;">
                {if $order_paid}{assign var="c" value=1}{else}{assign var="c" value=0.95}{/if}
                  <b><span class="price rub">{$product->order_price*$c|string_format:"%.0f"}&nbsp;<i class="icon-rub"></i></span></b>
                  {foreach from=$cat_currencies item=cur}
                    {assign var="c_name" value="order_price_`$cur->code`"}
                    <span class="price {$cur->code}" style="display:none;">{$product->c_prices->$c_name*$c|number_format:0:" ":" "}&nbsp;<b>{$cur->sign}</b></span>
                  {/foreach}
                </td>
            {/if}
        </tr>
    {/foreach}
    <tr>
        <td colspan="3" style="padding: 0; margin: 0; border: 0;">
            <table rules="none" cellspacing="0" style="width: auto !important;">
                {if $order->delivery_price}
                <tr class="gray" style="font-size: 12px;">
                    <td class="notBorder" width="160"  style="padding-top:8px; padding-bottom:8px;">{if $language=='eng'}Delivery{else}Доставка{/if}:</td>
                    <td class="notBorder" style="background: #fff; padding-top:8px; padding-bottom:8px;text-align: right;width: 50%;">
                      <span class="price rub"><b>{$order->delivery_price|number_format:0:" ":" "}</b> {$currency->sign|escape}.</span>
                      {foreach from=$cat_currencies item=cur}
                        {assign var="c_name" value="`$cur->code`"}
                        <span class="price {$cur->code}" style="display:none;">{$order->c_delivery_prices->$c_name|number_format:0:" ":" "}&nbsp;<b>{$cur->sign}</b></span>
                      {/foreach}
                    </td>
                </tr>
                {/if}
                {if $order->coupon_code}
                <tr class="gray" style="font-size: 12px;">
                    <td class="notBorder"  style="padding-top:8px;">{if $language=='eng'}Promo code{else}Промо-код{/if}:</td>
                    <td class="notBorder" style="background: #fff; padding-top:8px;">
                      <span class="price rub">{$order->coupon_code}, скидка <b>{$order->coupon_discount}</b>{if $order->coupon_type == "absolute"} {$currency->sign|escape}.{else}%{/if}</span>
                      {foreach from=$cat_currencies item=cur}
                        <span class="price {$cur->code}" style="display:none;">{$order->coupon_code}, скидка <b>{$order->c_coupon_discount->$c_name|number_format:0:" ":" "}</b>{if $order->coupon_type == "absolute"} {$cur->sign|escape}.{else}%{/if}</span>
                      {/foreach}
                    </td>
                </tr>
                {/if}
                {if !$order->no_payment_discount && $order->with_online_discount}
                    <tr class="gray" style="font-size: 12px; color: red!important;">
                        <td class="notBorder"  style="padding-top:8px;">{if $language=='eng'}for payment online{else}при оплате online{/if} (-5%):</td>
                        <td class="notBorder" style="background: #fff; padding-top:8px;text-align: right;">
                        <span class="price rub"><b>{$order->total_amount_online|number_format:0:" ":" "}</b> {$currency->sign|escape}.</span>
                        {foreach from=$cat_currencies item=cur}
                          {assign var="c_name" value="total_amount_online_`$cur->code`"}
                          <span class="price {$cur->code}" style="display:none;">{$order->c_total_amount_online->$c_name|number_format:0:" ":" "}&nbsp;<b>{$cur->sign}</b></span>
                        {/foreach}
                        </td>
                    </tr>
                {/if}
                {if $order->deposit_payment}
                <tr class="gray" style="font-size: 12px;">
                    <td class="notBorder" width="160"  style="padding-top:8px; padding-bottom:8px;">{if $language=='eng'}Deposit{else}Депозит{/if}:</td>
                    <td class="notBorder" style="background: #fff;padding-top:8px; padding-bottom:8px;text-align: right;">
                      <span class="price rub"><b>-{$order->deposit_payment|number_format:0:" ":" "}</b> {$currency->sign|escape}.</span>
                      {foreach from=$cat_currencies item=cur}
                        {assign var="c_name" value="`$cur->code`"}
                        <span class="price {$cur->code}" style="display:none;">{$order->c_deposit_payment->$c_name|number_format:0:" ":" "}&nbsp;<b>{$cur->sign}</b></span>
                      {/foreach}
                    </td>
                </tr>
                {/if}
                {if $order->payment_prepaid && $order->payment_prepaid != '0.00'}
                <tr class="gray" style="font-size: 12px;">
                    <td class="notBorder" width="160"  style="padding-top:8px; padding-bottom:8px;">{if $language=='eng'}Prepaid{else}Предоплата{/if}:</td>
                    <td class="notBorder" style="background: #fff;padding-top:8px; padding-bottom:8px;text-align: right;">
                      <span class="price rub"><b>-{$order->payment_prepaid|number_format:0:" ":" "}</b> {$currency->sign|escape}.</span>
                      {foreach from=$cat_currencies item=cur}
                        {assign var="c_name" value="`$cur->code`"}
                        <span class="price {$cur->code}" style="display:none;">{$order->c_payment_prepaid->$c_name|number_format:0:" ":" "}&nbsp;<b>{$cur->sign}</b></span>
                      {/foreach}
                    </td>
                </tr>
                {/if}
                <tr class="gray" style="font-size: 12px;">
                    <td class="notBorder"  style="padding-top:8px;">{if $language=='eng'}Total{else}Итого{/if}:</td>
                    <td class="notBorder" style="background: #fff; padding-top:8px;text-align: right;">
                      <span class="price rub"><b>{$order->total_amount|number_format:0:" ":" "}</b> {$currency->sign|escape}.</span>
                      {foreach from=$cat_currencies item=cur}
                        {assign var="c_name" value="total_amount_`$cur->code`"}
                        <span class="price {$cur->code}" style="display:none;">{$order->c_total_amount->$c_name|number_format:0:" ":" "}&nbsp;<b>{$cur->sign}</b></span>
                      {/foreach}
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
{if $rfi_comment}
    {foreach from=$rfi_comment item=rfi}
        <div style="float: left; width: 100%; margin: 24px 0 0 0;">{if $language=='eng'}Prepayment via RFI BANK{else}Предоплата через РФИ{/if} {$rfi->datetime|date_format:"%d/%m/%y %H:%M"}<br/> {if $language=='eng'}amount{else}сумма{/if} {$rfi->system_income|string_format:"%.0f"} {if $language=='eng'}rub{else}руб{/if}<br/> {if $language=='eng'}transaction{else}транзакция{/if} {$rfi->tid}</div>
    {/foreach}
{/if}

<div class="userInfo">
    <div>{if $language=='eng'}Customer{else}Покупатель{/if}: <b>{$order->name|escape}</b>, {if $language=='eng'}phone{else}телефон{/if}: <b>{$order->phone|escape}</b></div>
    <div class="ShAA_popTitleInput" style="margin-top:8px;">
      {if $language=='eng'}
        Please, {if $order->email}check{else}fill out{/if} the contact information
      {else}
        Пожалуйста, {if $order->email}проверьте{else}укажите{/if} контактные данные:
      {/if}
    </div>
    <div class="ShAA_popData ShAA_popDataSett" style="margin-top:8px;">
        <div class="ShAA_popInput">
            <input class="user_info" data-order-id="{$order->order_id}" type="text" name="email" value="{$order->email|default:$smarty.session.user->email}" placeholder="{if $language=='eng'}Email, example{else}Электронная почта, пример{/if}: name@gmail.com">
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
          {if $language=='eng'}
            <div class="ShAA_popTitleInput" style="margin-top:8px;">
                Please, enter your city
            </div>
            <div class="ShAA_popInput">
                <input class="user_info" id="city_id" data-order-id="{$order->order_id}" type="text" name="city_id" value="{if $order->city || $smarty.session.user->city}{$order->city|default:$smarty.session.user->city}{else}Нижний Новгород{/if}" placeholder="London">
            </div>
          {else}
            <div class="ShAA_popInput">
              <select name="city_id" id="city_id" data-order-id="{$order->order_id}" class="user_info" style="width: 99%;">
                  <option value="0">{if $language=='eng'}Please, choose your city{else}Пожалуйста, выберите ваш город{/if}</option>
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
          {/if}
    </div>
    <div class="ShAA_popData ShAA_popDataSett" id="dataShow" style="margin-top:8px;{if !$order->city_id} display:none;{/if}">
        <div class="ShAA_popInput">
            <select name="delivery_method_id" id="delivery_method_id" data-order-id="{$order->order_id}" class="user_info" style="width: 99%;">
                <option value="0">{if $language=='eng'}You can choose the shipping method{else}Вы можете выбрать способ доставки{/if}</option>
                {foreach from=$delivery_methods item=tk}
                    <option value="{$tk->delivery_method_id}" {if $delivery_id[0] == $tk->delivery_method_id}selected{/if}>{if $language=='eng'}{$tk->eng_name}{else}{$tk->name}{/if}</option>
                {/foreach}
            </select>
        </div>
    </div>
    <div class="ShAA_popData ShAA_popDataSett" style="margin-top:8px;">
        <div class="ShAA_popInput">
            <input class="user_info" data-order-id="{$order->order_id}" type="text" name="address" value="{$order->address|default:$smarty.session.user->adress|escape}" placeholder="{if $language=='eng'}street, house-apartment, example: Lenin 5-23{else}улица, дом-квартира, пример: Ленина 5-23{/if}">
        </div>
    </div>
    <div class="ShAA_popData ShAA_popDataSett" style="margin-top:8px;">
        <div class="ShAA_popTitleInput" style="margin-top:8px;">
            {if $language=='eng'}Your comment{else}Комментарий к заказу{/if}:
        </div>
        <div class="ShAA_popInput">
            <textarea class="user_info" data-order-id="{$order->order_id}" name="user_comment">{$order->user_comment|default:''|escape}</textarea>
        </div>
    </div>
</div>
<div class="clear"></div>
{if ($order->status < 2 || $order->status == 6) && !$order_paid}
    {if $PaymentMethods && $order->payment_status != 1 && $status_order != success}
    <div><span class="titleMain" style="font-size: 14px;"><b>{if $language=='eng'}Choose your payment method{else}Выберите способ оплаты{/if}:</b></span></div>
    <div class="ShAA_paymentSystem"  style="width:100%;">
            {foreach name=payment from=$PaymentMethods item=payment_method}
              
                  <div class="namePayment"{if $payment_method->payment_method_id == 15 || $payment_method->payment_method_id == 18}  style="display:none;"{/if}>
                      <div class="textPayment">
                          <div class="radioButton">
                              <input type="radio" name="payment_method_id" class="user_info" id="radio_{$payment_method->payment_method_id}" value="{$payment_method->payment_method_id}" data-order-id="{$order->order_id}"
                               onclick="{if $payment_method->payment_button}payment_form = jQuery('#rfi_payment');jQuery('#payment_button').show();jQuery('#payment_button_sber').show();jQuery('#complete_button').hide();{else}payment_form = false;jQuery('#payment_button').hide();jQuery('#payment_button_sber').hide();jQuery('#complete_button').show();{/if}"/>
                          </div>
                          <label for="radio_{$payment_method->payment_method_id}">
                          <div class="ShAA_paymentName">
                              {if $language=='eng'}{$payment_method->eng_name}{else}{$payment_method->name}{/if}
                          </div>
                          </label>
                          <div class="ShAA_paymentDescription">
                              {if $language=='eng'}{$payment_method->eng_description}{else}{$payment_method->description}{/if}
                          </div>
                      </div>
                      {if $payment_method->image}
                          <div class="imagePayment"><img src="/images/{$payment_method->image}" /></div>
                      {/if}
                      {if $payment_method->payment_button}
                          {$payment_method->payment_button}
                      {/if}
                  </div>
               
               <div class="clear"></div>
            {/foreach}
            <script>
                jQuery('#radio_13').attr("checked","true");
                var payment_form = jQuery('#rfi_payment');
            </script>
    </div>
    <div class="clear"></div>
    {/if}

    <div style="margin: 24px 0 0 0; float: left; width: 100%;">
        {if $sber_on}
        <span id="payment_button_sber">
            <a href="/sberbankpayment/?order_id={$order->code}&amp;order_total={if !$order->no_payment_discount}{$order->total_amount_online}{else}{$order->total_amount}{/if}" onclick="{literal}rG('PICK_SBER');{/literal}">
                <input type="submit" value="{if $language=='eng'}Pay{else}Оплатить заказ через Сбербанк{/if}" class="ShAA_popButton_input">
            </a>
        </span>
        {/if}
        <span id="complete_button" style="display: none;">
            <a {if $smarty.session.user}href="/cart/show_z/"{else}href="/"{/if}><input type="submit" value="{if $language=='eng'}Complete{else}Завершить{/if}" class="ShAA_popButton_input"></a>
        </span>
        <span class="noprint" style="display: none;">
            <div style="margin-bottom: 50px;">
                <a href='javascript:window.print(); void 0;'><input type="submit" value="{if $language=='eng'}Check print{else}Печать чека{/if}" class="ShAA_popButton_input ShAA_buttonInvert"></a>
            </div>
        </span>
        {if $rfi_on}
        <span id="payment_button">
          <a onclick="{literal}rG('PICK_RFI');{/literal} if (payment_form) payment_form.submit(); else alert('{if $language=='eng'}Please, choose a payment method{else}Пожалуйста, выберите способ оплаты{/if}');">
            <input type="submit" value="{if $language=='eng'}Pay{else}Оплатить заказ через РФИ{/if}" class="ShAA_popButton_input ShAA_buttonInvert">
          </a>
        </span>
        {/if}
        {*<span class="noprint">
            <div style="margin-bottom: 50px;">
                <form method='POST' id='prepaid_form' name='prepaid_form' accept-charset='UTF-8' action='https://partner.rficb.ru/alba/input/'>
                    <input type='hidden' name='key' value='{$rfi_open_key}' />
                    <input type='hidden' name='cost' value='2500' />
                    <input type='hidden' name='type' value='spg' />
                    <input type='hidden' name='name' value='Предоплата за доставку заказа №{$order->order_id}' />
                    <input type='hidden' name='default_email' value='mail@lsboutique.ru' />
                    <input type='hidden' name='order_id' value='{php}echo rand(10, 99);{/php}00{$order->order_id}' />
                </form>
                <a href="#" onclick="jQuery('#prepaid_form').submit(); return false;">
                    <input type="submit" value="{if $language=='eng'}Prepayment for delivery{else}Предоплата за доставку{/if}" class="ShAA_popButton_input ShAA_buttonInvert"></a>
            </div>
        </span>*}
        {if $sber_on}
        <span>
            <a href="/sberbankpayment/?order_id={$order->code}&order_total=2500&delivery">
                <input type="submit" value="{if $language=='eng'}Prepayment for delivery{else}Предоплата за доставку{/if}" class="ShAA_popButton_input ShAA_buttonInvert">
            </a>
        </span>
        {/if}
    </div>
{else}
<div class="clear"></div>

<div>
    {if $language=='eng'}For refund, please call{else}По вопросам возврата звоните{/if} <a href="/admin/tel:88003332138">8 800 333 21 38</a><br>
    {if $language=='eng'}
      Or fill in the <a style="border-bottom: 1px solid #000;" href="/return.doc">return form</a> and send it to e-mail <a href="mailto:vozvrat@lsboutique.ru">vozvrat@lsboutique.ru</a>
    {else}
      Или заполните <a style="border-bottom: 1px solid #000;" href="/return.doc">заявление на возврат</a> и отправьте на почту <a href="mailto:vozvrat@lsboutique.ru">vozvrat@lsboutique.ru</a>
    {/if}
</div>
{/if}

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
        <div class="title">{if $language=='eng'}Your order has been paid!{else}Ваш заказ оплачен!{/if} </div>
        <a onclick="{literal}$.fancybox.close();{/literal}"><img src="/images/close_manorwoman.png" style="float: right; margin: 8px 0 0 0;" width="62"></a>
        <div class="line"></div>
        <div class="text">
            {if $language=='eng'}Up to new meetings!{else}Ждём Вас снова{/if}
        </div>
        <div class="clear"></div>
    {/if}
    {if $status_order == fail}
        <div class="title">{if $language=='eng'}Payment is not made!{else}Оплата не произведена!{/if} </div>
        <a onclick="{literal}$.fancybox.close();{/literal}"><img src="../images/close_manorwoman.png" style="float: right; margin: 8px 0 0 0;" width="62"></a>
        <div class="line"></div>
        <div class="text">
            {if $language=='eng'}Try again{else}Попробуйте ещё раз{/if}
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
{literal}
<script type="text/javascript">
$(document).on("blur", ".user_info", function(e) {
    var order_id      = $(this).data('order-id');
    var name          = $(this).attr('name');
    var update_object = {order_id: order_id, data: {}};
    update_object.data[name] = $(this).val();
    console.log(update_object);
    $.post('/order/', {update_object: JSON.stringify(update_object)}, function( data ) {
        if (data != 'ok' && data != ''){
            $('#delivery_method_id').html(data);
            $('#dataShow').slideDown();
        }
        if(data == ''){$('#dataShow').slideUp();}
    });
});
</script>
{/literal}
</div>
