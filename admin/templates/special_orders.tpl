<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
	{if !$DeliveryAgent}
    <li><a href="/admin/index.php?section=Oneclick&new_orders=1" class="off">предобработка</a></li>
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
          <a href="index.php?section=Special_orders">Специальные заказы</a>
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
        <h1 id="headline">Специальные заказы</h1>
        <!-- /Заголовок раздела /-->
        
        
		 <!-- Помощь2 /-->
        <div class="help2">
            
        </div>
        <!-- /Помощь2 /-->

      </div>

      <div id="cont_center">
     
        <form autocomplete="off" action="/admin/index.php?section=Special_orders&export_orders=1" method="post" name="export_form" enctype="multipart/form-data">
          <table>
            <tr>
                <td style="vertical-align: middle;"><p style="margin:0 0 1px 0;font-size:14px;">Экспорт&nbsp;&nbsp;</p></td>
                <td style="vertical-align: middle;"><p style="margin-top:0;font-size:14px;">От&nbsp;&nbsp;<input name="date_start" class="date_time_picker" type="text" style="width:200px; margin-right:30px;" value="{$export_start}"/></p></td>
                <td style="vertical-align: middle;"><p style="margin-top:0;font-size:14px;">До&nbsp;&nbsp;<input name="date_end" class="date_time_picker" type="text" style="width:200px;" value="{$export_end}"/></p></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td><input type="submit" style="margin-top:10px;float:right;" value='Загрузить'></td>
            </tr>

          </table>
        </form>
          
        <div class="clear">&nbsp;</div>	  
          
     
  
        {if $Items}
		
        <!-- Форма товаров #Begin /-->
          <table id="list2" class="sep_tab">
            {foreach item=item from=$Items}
              <tr data-id="{$item->so_id}" class="sep_tab">
                <td class="bordertd">
                <div class="info_left">
                  <a href='index.php?section=Special_orders&s_order={$item->so_id}' target="_blank" class='order_number'>№{$item->so_id}</a><br>
                  <a href='/products/{$item->url}' target="_blank">{$item->p_model}</a><br>
                  <p class="contact_on">Менеджер заявки: {if $item->manager_id}{$item->manager_name}{/if}</p>
                  <a href="/products/{$item->url}" target="_blank"><img src="/reimg/files/products/85x/{$item->large_image}" style="float:left;" /></a>
                  <div class="contact" style="float:left;">
                    <p class="contact_on">Дата заявки: {$item->create_date}</p>
                    <p class="contact_on">Дата окончания заявки: {$item->end_date}</p>
                  </div>
                  <div class="contact" style="float:left;">
                    <p class="contact_on">Имя пользователя: {if $item->user_id}<a href='/admin/index.php?section=User&user_id={$item->user_id}' target="_blank" style="font-size:14px;">{$item->user_name}</a>{else}{$item->user_name}{/if}</p>
                    <p class="contact_on">Телефон: {$item->user_phone}</p>
                    {if $item->user_email}<p class="contact_on">Email: {$item->user_email}</p>{/if}
                  </div><br>
                  </div>
                </td>
                <td class="bordertd">
                  <div class="info_right" style="margin-top:35px;">
                    <table style="width:100%;min-height:120px">
                      {if $item->comments}
                        <tr><td colspan=2><h2>Комментарии к заказу</h2></td></tr>
                        {foreach from=$item->comments item=comment}
                          <tr>
                            <td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
                              {if $comment->commenter_id == $smarty.session.user->user_id}
                                <a href="/admin/index.php?section=Special_orders&amp;update_order={$item->so_id}&amp;delete_comment_id={$comment->id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
                              {/if}
                              {$comment->date}<br>
                              <b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}</b>: {$comment->text|escape|nl2br}<br>
                            </td>
                          </tr>
                        {/foreach}
                      {/if}
                    </table>
                    <div class="desc">
                      {if $allowed_admin}
                        <a href="/admin/index.php?section=Special_orders&amp;update_order={$item->so_id}&amp;delete_order=1" onclick="return confirm('Вы уверены, что хотите отменить заказ?');" class="fl"><img src="./images/cancel.jpg" alt="" class="fl_ch"/>Отмена заказа</a>
                      {/if}
                    </div>
                  </div>
                </td>
              </tr>					
            {/foreach}
          </table>
          {$PagesNavigation}
          <!-- Форма Товаров #End /-->
          {else}
            <div class="emptylist">Нет записей</div>
          {/if}
        {literal}      
          <script>
            $(document).ready(function() {
                $.datepicker.regional['ru'] = {
                    closeText: 'Закрыть',
                    prevText: '<Пред',
                    nextText: 'След>',
                    currentText: 'Сегодня',
                    monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
                    'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
                    monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
                    'Июл','Авг','Сен','Окт','Ноя','Дек'],
                    dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
                    dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
                    dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
                    weekHeader: 'Не',
                    firstDay: 1,
                    isRTL: false,
                    showMonthAfterYear: false,
                    yearSuffix: ''
                };
                $.datepicker.setDefaults($.datepicker.regional['ru']);
                $('.date_time_picker').datetimepicker({
                    minDate: new Date(2000, 1 - 1, 1),
                    changeMonth: true,
                    timeFormat: '',
                    dateFormat: 'yy-mm-dd'
                });
            });
          </script>
        {/literal}
      </div>  
    </div>
  </div>	    
</div>
<!-- Content #End /--> 

