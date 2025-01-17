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
          <a href="index.php?section=Delivery_to_TK">Доставка в ТК</a> →
          <a href="index.php?section=Delivery_to_TK&get_delivery={$item->id}">Посылка №{$item->id}</a>
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
        <!-- /Помощь2 /-->

      </div>

      <div id="cont_center">
        <div class="clear">&nbsp;</div>	
        <form action="index.php?section=Delivery_to_TK&edit&update_deivery"  method="post">
          <table id="list2" class="sep_tab">
            <tr data-id="{$item->id}" class="sep_tab">
              <td>
                <div class="info_left" style="margin-right:35px;">
                  <span class='order_number'>№{$item->id}</span><br>
                  <input type="hidden" name="delivery_id" value="{$item->id}">
                  <table>
                    {if $allowed_admin}
                      <tr>
                          <td class="model">Менеджер заказа</td>
                          <td class="m_t">
                              <p>
                                  <select name="manager_id" class="select2" style="width:335px;">
                                    <OPTION VALUE='' {if !$item->manager_id}SELECTED{/if}>Нет</OPTION>
                                   {foreach key=key item=manager from=$Managers}
                                      {if $manager->user_id == $item->manager_id}
                                        <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                                      {else}
                                        <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                                      {/if}
                                    {/foreach}
                                  </select>
                              </p>
                          </td>
                      </tr>
                    {else}
                    <tr>
                      <td class="model">Менеджер заказа</td>
                      <td class="model"><p>{$item->manager_name|escape}<input type="hidden" name="manager_id" value="{$item->manager_id}"></p></td>
                    </tr>
                    {/if}
                    <tr>
                      <td class="model">Стоимость доставки:</td>
                      <td class="m_t"><p><input name="delivery_price" type="text" class="input3" value='{$item->price}' {if $DeliveryAgent || (($smarty.session.user->group_id != 5 || $smarty.session.user->subgroup_id != 3) && !$allowed_admin)}disabled{/if}/></p></td>
                    </tr>
                    {if $item->comments}
                      <tr><td colspan=2><h2>Комментарии к доставке</h2></td></tr>
                        {foreach from=$item->comments item=comment}
                          <tr>
                            <td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
                              {if $comment->commenter_id == $smarty.session.user->user_id}
                                <a href="/admin/index.php?section=Delivery_to_TK&amp;edit&amp;delete_comment_id={$comment->id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
                              {/if}
                              {$comment->date}<br>
                              <b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}</b>: {$comment->text|escape|nl2br}<br>
                            </td>
                          </tr>
                        {/foreach}
                    {/if}
                    <tr>
                        <td class="model">Комментарий менеджера</td>
                        <td class="m_t"><p><textarea id="comment" name="comment" class='textarea2'></textarea></p></td>
                    </tr>
                  </table>
                  <input type="submit" value="Сохранить">
                  <div class="desc">
                    {if $item->active == 1}<a href="index.php?section=Delivery_to_TK&amp;edit&amp;deactivate={$item->id}" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch">В неактивные</a>
                    {else}<a href="index.php?section=Delivery_to_TK&amp;edit&amp;activate={$item->id}" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch">В активные</a>{/if}
                  </div>
                </div>
              </td>
              <td>
                <div class="info_right" style="margin-top:0;">
                  <div style="float:left; width:100%; margin-bottom:20px;">
                        {foreach from=$item->orders item=order}
                          <input type="hidden" name="orders[]" class="o{$order->order_id}" value="{$order->order_id}">
                          <div style="float:left; width:100%;margin-top:35px;" class="o{$order->order_id}" >
                            <img src="./images/cancel.jpg" align="top" alt="" class="order_del" data-id="o{$order->order_id}" class="fl_ch"> № <a style="font-size: 14px;" href='/admin/index.php?section=Order&order_id={$order->order_id}' target="_blank">{$order->order_id}</a><br>
                            {foreach from=$order->products item=product}
                              <div style="float:left; margin-right:15px;">
                                <a href="//lsboutique.ru/products/{$product->url}/" target="_blank"><img src="//lsboutique.ru/reimg/files/products/85x/{$product->large_image}"></a><br>
                                {$product->product_name}
                              </div>
                            {/foreach}
                          </div>
                        {/foreach}
                      </div>
                      <div class="orders_group">
                        <p style="font-size: 14px;">Добавить заказ:</p>
                        <select name="orders[]" class="order_id" style="margin-right:5px;">
                          <option value=""></option>
                          {foreach from=$orders item=order}
                            <option value="{$order->order_id}">{$order->order_id}</option>
                          {/foreach}
                        </select></div>
                      <p style="font-size: 14px;margin:10px 0;">
                        <a href='' class='add_order'><img src="./images/add.jpg" align="top" alt=""/> Еще</a>
                      </p>
                </div>
              </td>
            </tr>
          </table>
        </form>
        
      </div>  
    </div>
  </div>	    
</div>

{literal}
<script>
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
</script>
{/literal}
<!-- Content #End /--> 

