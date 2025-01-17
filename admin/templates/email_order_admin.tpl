<h1 style='font-weight:normal;font-family:arial;'><a href='http://{$root_url}/admin/index.php?section=Order&order_id={$order->order_id}'>Заказ №{$order->order_id}</a> на сумму {$order->total_amount} {$main_currency->sign}</h1>
<table cellpadding=6 cellspacing=0 style='border-collapse: collapse;'>
  {if $order->name}
  <tr>
    <td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Имя, фамилия
    </td>
    <td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $user}
      <a href='http://{$root_url}/admin/index.php?section=Orders&view=search&keyword=user:{$order->user_id}'>{$order->name|escape}</a>
      {else}
      {$order->name|escape}
      {/if}
    </td>
  </tr>
  {/if}
  {if $user->card_number}
  <tr>
    <td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
		Номер карты
    </td>
    <td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
		{$user->card_number}
    </td>
  </tr>
  {/if}
  {if $order->email}
  <tr>
    <td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Email
    </td>
    <td style='padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {$order->email|escape}
    </td>
  </tr>
  {/if}
  {if $order->phone}
  <tr>
    <td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Телефон
    </td>
    <td style='padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {$order->phone|escape}
    </td>
  </tr>
  {/if}
  {if $order->address}
  <tr>
    <td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Адрес доставки
    </td>
    <td style='padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {$order->address|escape}
    </td>
  </tr>
  {/if}
  {if $order->city}
  <tr>
    <td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Город доставки
    </td>
    <td style='padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {$order->city|escape}
    </td>
  </tr>
  {/if}
  <tr>
    <td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Стоимость доставки
    </td>
    <td style='padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {$order->real_delivery_price|escape}
    </td>
  </tr>
  {if $order->comment}
  <tr>
    <td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Комментарий
    </td>
    <td style='padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {$order->comment|escape|nl2br}
    </td>
  </tr>
  {/if}
  <tr>
    <td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Время
    </td>
    <td style='padding:6px; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {$order->date}
    </td>
  </tr>
  <tr>
    <td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Статус
    </td>
    <td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $order->status == 0}
        ждет обработки      
      {elseif $order->status == 1}
        в обработке
      {elseif $order->status == 2}
        выполнен
      {/if}
    </td>
  </tr>
  <tr>
    <td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Оплата
    </td>
    <td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $order->payment_status == 1}
        <font color='green'>оплачен</font>    
      {else}
        не оплачен
      {/if}
    </td>
  </tr>
</table>
<br>
<h1 style='font-weight:normal;font-family:arial;'>Товары:</h1>
<table cellpadding=6 cellspacing=0 style='border-collapse: collapse;'>
  {foreach name=products from=$order->products item=product}
  <tr>
    <td style='padding:6px; width:250; padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      <a href="http://{$root_url}/products/{$product->url}/">
		{if $product->large_image || $product->small_image}<img src="http://{$root_url}/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{else}{$product->small_image}{/if}" alt="{$product->model}">
		{else}{$product->model}{/if}
	  </a>
  	  <br>{$product->sku}
    </td>
    <td align=right style='padding:6px; text-align:right; width:150; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $product->size}Размер: {$product->size},<br>{/if} {$product->price|string_format:"%.2f"}&nbsp;{$currency->sign}
    </td>
    <td align=right style='padding:6px; text-align:right; width:150; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
	  {$product->item_location}
    </td>
  </tr>
  {/foreach}
  {if $order->delivery_method}
  <tr>
    <td  style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Доставка
    </td>
    <td align=right style='padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $order->delivery_price>0}
      {$order->delivery_price*$currency->rate_from/$currency->rate_to|string_format:"%.2f"} {$currency->sign}
      {else}
      бесплатно
      {/if}
    </td>
  </tr>
  {/if}
</table>
<br>
*Цены указаны на момент заказа с учетом скидки пользователя
