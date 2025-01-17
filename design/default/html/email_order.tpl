<h1 style='font-weight:normal;font-family:arial;'><a href='http://{$root_url}/{$order->code}'>Заказ №{$order->order_id}</a> на сумму {$order->total_amount} {$main_currency->sign}</h1>
<table cellpadding=6 cellspacing=0 style='border-collapse: collapse;'>
  <tr>
    <td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Статус
    </td>
    <td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'><b>
      {if $order->status == 0}
        ждет обработки      
      {elseif $order->status == 1}
        в обработке
      {elseif $order->status == 2}
        выполнен
      {elseif $order->status == 4}
        нет на складе
      {elseif $order->status == 5}
        самовывезен
      {/if}
    </b></td>
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
  {if $order->name}
  <tr>
    <td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      Имя, фамилия
    </td>
    <td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $user}
      <a href='http://{$root_url}/admin/index.php?section=Orders&user_id={$user->user_id}'>{$order->name|escape}</a>
      {else}
      {$order->name|escape}
      {/if}
    </td>
  </tr>
  {/if}
  {if $smarty.session.user->card_number}
  <tr>
    <td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
		Номер карты
    </td>
    <td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
		{$smarty.session.user->card_number}
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
</table>
<br>
<h1 style='font-weight:normal;font-family:arial;'>Вы заказали:</h1>
<table cellpadding=6 cellspacing=0 style='border-collapse: collapse;'>
  {foreach name=products from=$order->products item=product}
  {if $product->download != ''}{assign var=digital_products value=1}{/if}
  <tr>
    <td style='padding:6px; width:250; padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
      <a href="http://{$root_url}/products/{$product->url}/">
		{if $product->large_image || $product->small_image}<img src="http://{$root_url}/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{else}{$product->small_image}{/if}" alt="{$product->model}">
		{else}{$product->model}{/if}
	</a><br>
	{$product->model}
    </td>
    <td align=right style='padding:6px; text-align:right; width:150; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $product->size}Размер {$product->size}, {/if}{$product->price|string_format:"%.0f"}&nbsp;{$main_currency->sign}
    </td>
  </tr>
  {/foreach}
  <tr>
    <td  style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
<!--      {$order->delivery_method}-->
	  Доставка
    </td>
    <td align=right style='padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
      {if $order->delivery_price>0}
      {$order->delivery_price*$main_currency->rate_from/$main_currency->rate_to|string_format:"%.0f"} {$main_currency->sign}
      {else}
      бесплатно
      {/if}
    </td>
  </tr>
</table>



<br />
Вы всегда можете проверить состояние заказа по ссылке:<br />
<a href='http://{$root_url}/order/{$order->code}'>http://{$root_url}/order/{$order->code}</a>
<br />
Менеджер вашего заказа №{$order->order_id}<br />
Усачев Владимир +79524442636<br />
<a href='http://{$root_url}'>{$settings->site_name}</a>
