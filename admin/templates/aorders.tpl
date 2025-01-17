<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
      <li><a href="index.php?section=Aorders" class="{if $View=='money'}on{else}off{/if}">Деньги</a></li>
      <li><a href="index.php?section=Aorders&view=return" class="{if $View=='return'}on{else}off{/if}">Возврат товаров</a></li>
      <li><a href="index.php?section=Aorders&view=delivery_pay" class="{if $View=='delivery_pay'}on{else}off{/if}">Оплата доставки</a></li>
      <li><a href="index.php?section=Aorders&view=done" class="{if $View=='done'}on{else}off{/if}">Выполнены</a></li>
    </ul>
    <ul style="float:right; padding: 4px 0 5px 0;">
      <li style="display: inline;"><a href="index.php?section=Aorders&view=delivery" class="{if $View=='delivery'}on{else}off{/if}">доставляются</a></li>
      <li style="display: inline;"><a href="index.php?section=Aorders&view=search" class="{if $View=='search'}on{else}off{/if}">поиск</a></li>
  </ul>
  <!-- /Вкладки /-->

</div>

<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">
      <div id="cont_center">
          {if $Error}
          <!-- Error #Begin /-->
          <div id="error_minh">
            <div id="error">
              <img src="./images/error.jpg" alt=""/><p>{$Error}</p>
            </div>
          </div>
          <!-- Error #End /-->
          {/if}

          {if $View == 'search'}
          <div class="clear">&nbsp;</div>
          <div class=filter>
            <form method=get>
              <input name=section type=hidden value='{$smarty.get.section}'>
              <input name=view type=hidden value='{$smarty.get.view}'>
              <input name=brand type=hidden value='{$smarty.get.brand}'>
              <input name=keyword type=text  class="input3" value='{$smarty.get.keyword|escape}'>
              <input type='submit' value='Найти' class="submit10">
            </form>
          </div>
          {/if}
          <div class="clear">&nbsp;</div>

          {if $DeliveryAgent}
          <form method="get">
              <input name="section" value="Orders" type="hidden">
              <input name="delivery" type=hidden value='search'>
              <input name="delivery_keyword" class="input3" value="" type="text">
              <input value="Найти" class="submit10" type="submit">
          </form>
          <div class="clear">&nbsp;</div>
          {/if}

          {$PagesNavigation}

          {if $Orders}

          <div class="clear">&nbsp;</div>

          <!-- Форма товаров #Begin /-->
          <form name='products' method="post">


              {* Список заказов *}
              {foreach item=order from=$Orders}

                <img src="./images/line.jpg" alt=""/>

                <!-- Block #Begin /-->
                <div class="info">
                    <table><tr><td>
                    <div class="info_left">
                    <div style="width: 45px;display: inline-block;"></div>
                        <a href='index.php{$order->edit_url}' class='order_number'>№{$order->order_id}{if $View=='search'}{if $order->status == 0}(новый){elseif $order->status == 1}(в обработке){elseif $order->status == 2}(выполнен){/if}{/if}</a>
                        {if $order->receipt_number > 0} - товарный чек № {$order->receipt_number}{/if}
                        <br>
                        {if $order->manager_name}<p style="font-size: 16px;">{$order->manager_name}</p>{/if}
                        <br>

                        <div class="contact">
                            <p class="contact_on">{$order->date}</p>
                          {if $order->name}<p class="contact_on">{$order->name|escape}</p>{/if}
                            {if $order->address}<p class="contact_on">{$order->address|escape}</p>{/if}
              {if $order->delivery_company}<p class="contact_on">TK: {$order->delivery_company|escape}</p>{/if}
                            {if $order->delivery_code}<p class="contact_on">Номер накладной: {$order->delivery_code|escape}</p>{/if}
                            
              {assign var=ds value=$order->delivery_status}
                            <p><b>{$DeliveryStats.$ds}</b></p>
              {assign var=ms value=$order->money_status}
              <p><b>{$MoneyStats.$ms}</b></p>
                      {if $order->comments}
                       <p class="contact_on">Комментарии к заказу</p>
                       {foreach from=$order->comments item=comment}
                        <p class="contact_on">{$comment->date}</br><b>{if $comment->user_id != 0}{$comment->name}{else}Система{/if}:</b> {$comment->text|escape|nl2br}</p>
                       {/foreach}
                      {/if}
                        </div>
                    </div>
                    </td><td valign="bottom">
                    <div class="info_right">
                        <div class="info_rl">
                            <table id="table2">


                               {foreach item=product from=$order->products}
                                <tr>
                                    <td><a href="/products/{$product->url}/" target="_blank"><img src="/reimg/files/products/85x/{$product->image}"></a></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td class="td1"><a href="/products/{$product->url}/" target="_blank" class="link">{$product->product_name}</a>
                                    {if $product->status}<b>({$product->status}{if $product->status_date != '0000-00-00'}, {$product->status_date}{/if})</b>{/if}<br> {if $product->sku}{$product->sku} /{/if} {$product->item_location}</td>
                                    <td class="td2">{$product->quantity}&nbsp;шт. &times; <input class="hotinput product-price" order-id="{$product->order_id}" product-id="{$product->id}" value="{$product->price}"><br />
                                      {if $product->size}размер: <b>{$product->size}</b>{/if}
                                    </td>
                                </tr>
                {if $product->status == "отказ и возврат" && ($View=="return" || $View=="search")}
                  <tr>
                    <td>
                     <a href="index.php{$product->set_prodreceived_url}" onclick="if(!confirm('Этот товар возвращен?')) return false;" class="fl"><img src="./images/ok.jpg" alt="" class="fl_ch"/>Товар получен</a>
                    </td>
                  </tr>
                {/if}

                                {/foreach}

                {if $View!="return"}
                                <tr>
                  <td class="td1"><p class="cur">Стоимость доставки для клиента:</p></td>
                                    <td class="td2"><p class="cur"><input class="hotinput delivery-price" order-id="{$order->order_id}" value="{$order->delivery_price}"></p></td>
                                </tr>
                <tr>
                  <td class="td1"><p class="cur">Стоимость услуг Транспортной Компании:</p></td>
                  <td class="td2"><p class="cur">{if $order->delivery_agent_price=='0.00'}Не заполнена{else}{$order->delivery_agent_price}{/if}</p></td>
                </tr>
                                <tr>
                                    <td class="td1"><p class="cur2">Стоимость</p></td>
                  {if $View=="delivery_pay"}
                    <td class="td2"><p class="pay">{$order->delivery_agent_price}</p></td>
                  {else}
                                      <td class="td2"><p class="pay hotprice" order-id="{$order->order_id}">{$order->total_amount}</p></td>
                  {/if}
                                </tr>
                {/if}

                            </table>
                        </div>
                    </div>
                    {if !$DeliveryAgent}
          <div class="desc">
                        {if $order->money_received==0 && ($View=="money" || $View=="search")}
                          <a href="index.php{$order->set_moneyreceived_url}" onclick="if(!confirm('Деньги по этому заказу получены?')) return false;" order-id="{$order->order_id}" class="fl green_button"><img src="./images/ok.jpg" alt="" class="fl_ch"/>Деньги получены</a>
            {elseif $order->delivery_paid==0 && ($View=="delivery_pay" || $View=="search")}
              <a href="index.php{$order->set_delpaymentreceived_url}" onclick="if(!confirm('Услуги ТК по этому заказу оплачены?')) return false;" class="fl"><img src="./images/ok.jpg" alt="" class="fl_ch"/>Доставка оплачена</a>
                        {/if}
                    </div>
          {/if}
                    </td></tr></table>
                    <div class="clear">&nbsp;</div>
                </div>
                <!-- Block #End /-->


              {/foreach}
              {* /Список заказов *}

            </form>
            <!-- Форма Товаров #End /-->
            {if $View=='money'}
              <div style="float: right;font-size: 20px;margin-right: 40px;">Всего: <b style="color:red;">{$Total_money}</b> рублей</div>
            {/if}
            {else}
              <div class="emptylist">Нет заказов</div>
            {/if}

            {$PagesNavigation}
            <div class="clear">&nbsp;</div>

        </div>
        <!-- Right side #End/-->

    </div>
  </div>
</div>
<!-- Content #End /-->
<script>
{if $View!="money"}
{literal}
jQuery(function($){
  $(".hotinput").replaceWith( function() { return $(this).attr("value"); });
});
{/literal}
{/if}

{literal}
$(document).on("input", ".hotinput", function() {
    $order_id=$(this).attr("order-id");
    $sum = 0;
    $json = {};
    $(".hotinput[order-id="+$order_id+"]").each( function() {
        $sum = $sum+Number($(this).val());
        if ($(this).attr("product-id")) {
            $p_id = $(this).attr("product-id");
            $json[$p_id] = $(this).val();
        }
    });
    $param = encodeURIComponent(JSON.stringify($json));
    $green_button = $(".green_button[order-id="+$order_id+"]");
    $href = $green_button.attr("href").split("&json")[0];
    $green_button.attr("href", $href+"&json="+$param);
    $(".hotprice[order-id="+$order_id+"]").html($sum);
});
</script>
{/literal}
