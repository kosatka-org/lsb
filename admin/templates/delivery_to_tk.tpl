<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
	{if !$DeliveryAgent}
    <li><a href="index.php?section=Delivery_to_TK" class="{if $View=='to_tk'}on{else}off{/if}">доставка в тк</a></li>
    <li><a href="index.php?section=Orders" class="{if $View=='new'}on{else}off{/if}">новые</a></li>
    <li><a href="index.php?section=Orders&view=process" class="{if $View=='process'}on{else}off{/if}">обработка</a></li>
    <li><a href="index.php?section=Orders&view=delivery" class="{if $View=='delivery'}on{else}off{/if}">доставка</a></li>
    <li><a href="index.php?section=Orders&view=done" class="{if $View=='done'}on{else}off{/if}">выполнены</a></li>
    <li><a href="/admin/index.php?section=Special_orders" class="{if $View=='spec'}on{else}off{/if}">спец.заказы</a></li>
    </ul>
   <ul style="float:right; padding: 4px 0 5px 0;">
    <li style="display: inline;"><a href="index.php?section=Orders&view=cancel" class="{if $View=='cancel'}on{else}off{/if}">отменённые</a></li>
    <li style="display: inline;"><a href="index.php?section=Orders&view=search" class="{if $View=='search'}on{else}off{/if}">поиск</a></li>
  {else}
    <li><a href="index.php?section=Orders&delivery=stats" class="{if $DelView && $DelView=='stats'}on{else}off{/if}">статистика</a></li>
    {foreach from=$DeliveryStats item=stat key=statkey}
    <li><a href="index.php?section=Orders&delivery={$statkey}" class="{if $DelView==$statkey}on{else}off{/if}">{$stat}</a></li>
    {/foreach}
  {/if}
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          <a href="index.php?section=Delivery_to_TK">Доставка в ТК</a>
        </p>
      </td>
    </tr>
  </table>
  <!-- /Путь /-->
</div>	


<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">
     
      <div id="cont_top">
        <!-- Иконка раздела /-->
        <!-- /Иконка раздела /-->
	    
        <!-- Заголовок раздела /-->
        <h1 id="headline">Доставка в ТК</h1>
        <!-- /Заголовок раздела /-->
        
        
        <!-- Помощь2 /-->
        <div class="help2">
            <a href="" id="add-delivery" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить посылку</a>
        </div>
        <!-- /Помощь2 /-->

      </div>

      <div id="cont_center">
        <div class="clear">&nbsp;</div>	
        <p style="font-size: 16px;"><a href="index.php?section=Delivery_to_TK&active" style="color:#000;">Активные</a>/<a href="index.php?section=Delivery_to_TK&inactive" style="color:#000;">Неактивные</a></p>
        <div class="clear">&nbsp;</div>	
        <div id="res_form"></div>	
        {if $Items}
		
        <!-- Форма товаров #Begin /-->
        <table id="list2" class="sep_tab">
        {foreach item=item from=$Items}
          <tr data-id="{$item->id}" class="sep_tab">
            <td class="bordertd">
              <div class="info_left">
                <a href="index.php?section=Delivery_to_TK&get_delivery={$item->id}" class='order_number'>№{$item->id}</a><br>
                {if $item->manager_name}<p style="font-size: 16px;">{$item->manager_name}</p>{/if}
                <p style="font-size: 14px;">Стоимость доставки:
                  <span data-delivery-id="{$item->id}" class="delivery-price">{$item->price}<br /></span>
                  <span class="delivery-price-input" data-delivery-id="{$item->id}" style="display:none;">
                    <input value="{$item->price}" style="width:72px;"><br>
                    <a href="#" class="update-delivery-price">Применить</a>
                    <a href="#" class="cancel-delivery-price">Отмена</a>
                    <br>
                  </span>
                </p>
                <table style="width:100%;">
                  <tr><td colspan=2><h2>Комментарии к доставке</h2></td></tr>
                  {if $item->comments}
                    {foreach from=$item->comments item=comment}
                      <tr>
                        <td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
                          {if $comment->commenter_id == $smarty.session.user->user_id}
                            <a href="index.php?section=Delivery_to_TK&amp;edit&amp;delete_comment_id={$comment->id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
                          {/if}
                          {$comment->date}<br>
                          <b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}</b>: {$comment->text|escape|nl2br}<br>
                        </td>
                      </tr>
                    {/foreach}
                  {/if}
                </table>
              </div>
            </td>
            <td class="bordertd">
              <div class="info_right" style="margin-top:0;">
                <div style="float:left; width:100%; margin-bottom:20px;">
                  {foreach from=$item->orders item=order}
                    <div style="float:left; width:100%;margin-bottom:35px;" class="o{$order->order_id}" >
                      № <a style="font-size: 14px;" href='index.php?section=Order&order_id={$order->order_id}' target="_blank">{$order->order_id}</a><br>
                      {foreach from=$order->products item=product}
                        <div style="float:left; margin-right:15px;">
                          <a href="//lsboutique.ru/products/{$product->url}/" target="_blank"><img src="//lsboutique.ru/reimg/files/products/85x/{$product->large_image}"></a><br>
                          {$product->product_name}
                        </div>
                      {/foreach}
                    </div>
                  {/foreach}
                </div>
              </div>
              <div class="desc">
                {if $item->active == 1}<a href="index.php?section=Delivery_to_TK&amp;edit&amp;deactivate={$item->id}" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch">В неактивные</a>
                {else}<a href="index.php?section=Delivery_to_TK&amp;edit&amp;activate={$item->id}" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch">В активные</a>{/if}
              </div>
            </td>
          </tr>					
        {/foreach}
        </table>
        <!-- Форма Товаров #End /-->
        {else}
          <div class="emptylist">Нет записей</div>
        {/if}
      </div>  
    </div>
  </div>	    
</div>

{literal}
<script>
  $(document).on("click", "#add-delivery", function(e) {
    e.preventDefault();
    $.get("index.php?section=Delivery_to_TK&add_delivery=1", function(data) {
      {$('#res_form').html(data);}
    });
  });
  $(document).on("click", ".add_order", function(e) {
    e.preventDefault();
    var data = $('.order_id').first().clone();
    $(".orders_group").append(data);
  });
  $(document).on("click", ".order_del", function(e) {
    e.preventDefault();
    var op_id = $(this).data("id");
    $("."+op_id).remove();
  });
  $(document).on("dblclick", "span.delivery-price", function(e) {
    $(this).siblings("span.delivery-price-input").show();
    $(this).hide();
  });
  $(document).on("click", "a.update-delivery-price", function(e) {
    e.preventDefault();
    var op_id = $(this).parent().data("delivery-id");
    var price = $(this).siblings("input").val();
    window.location = "index.php?section=Delivery_to_TK&edit&change_delivery_price="+op_id+"&price="+price;
  });
  $(document).on("click", "a.cancel-delivery-price", function(e) {
    e.preventDefault();
    $(this).parent().siblings("span.delivery-price").show();
    $(this).parent().hide();
  });
</script>
{/literal}
<!-- Content #End /--> 

