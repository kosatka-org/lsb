<link rel="stylesheet" href="../css/preloader_style.css" />
<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Storefront" class="on">{$Site_name}</a></li>
    {if in_array('CopywriterTaskManager', $user_allowed)}<li><a href="index.php?section=CopywriterTasksManager" class="off" title="Управление и проверка задач копирайтера">&copy; задачи</a></li>{/if}
    {if $is_copywriter}<li><a href="index.php?section=CopywriterTasks" class="off" title="Задачи на копирайтинг">&copy; задачи</a></li>{/if}
    {if in_array('CopywriterStat', $user_allowed)}<li><a href="index.php?section=CopywriterStat" class="off"  title="Статистика по задачам копирайтера">&copy; статистика</a></li>{/if}
    {if in_array('CityStats', $user_allowed)}<li><a href="index.php?section=CityStats" class="off">Статистика по городам</a></li>{/if}
    <li><a href="index.php?section=ManagersStatistics" class="off">Менеджеры</a></li>
  </ul>
  <!-- /Вкладки /-->

</div>

{if !$is_copywriter}
<div id="content">
  <div id="cont_border">
    <div id="cont">

      <div id="cont_top">
        <img src="./images/icon_main.jpg" alt="" class="line"/>
        <h1 id="headline">Главная страница</h1>
      </div>

      <div id="cont_center">
        <div class="clear">&nbsp;</div>
            <div id="over">
                <div class="links fatlist " id="outside" style="display:none; z-index: 100;">
                    <div class="fatlist_title">Список пользователей<div class="fatlist_close">Закрыть</div></div>
                    <div id="ajax_result" ></div>
                </div>
                <div id="main_right">
                    <br><br>
                    <span class="model" style='float:left;padding-left:84px;'>Статистика</span>
                    <br><br>
                    <div style="float:right;margin-bottom:40px;">
                        <form action="index.php?section=MainPage{if $exp}&exp{/if}" method="post">
                            <select style="width:108px;" name="period" id="month">
                            </select>
                            <select style="width:128px;margin-left:10px;" name="delivery_company">
                                <option selected value="0">Все</option>
                                <option value="9999">Нет</option>
                                {foreach from=$dcompanies item=item}
                                    <option value="{$item->id}">{$item->name}</option>
                                {/foreach}
                            </select>
                            <input style="margin-left:30px;width:80px;" type="submit" value="Выбрать">
                        </form>
                        <script>
                            jQuery('option[value="{$Results->delagent}"]').attr("selected",true);
                        </script>
                    </div>

                    <div class="clear">&nbsp;</div>
                {if $allowed_manager}
                    <div style="clear:both;font-size:16px;margin-bottom:15px;">План по продажам: {$smarty.session.user->sales_target|default:'0'|number_format:0:'.':' '} &#8381;</div>
                    <div style="float:left;">
                    <span style="font-size: 14px;">Персональная статистика за месяц</span>
                        <div class="border">
                            <table style="font-size: 14px; font-family: sans-serif;width: 100%;">
                                <tbody>
                                    <tr class="slide-toggle">
                                        <td>
                                            <div class="list_left">Принято</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->manager_money_received_list item=product}
                                                    <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                                {/foreach}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="list_right" style="color: green;">{$Results->manager_money_received|default:'0'|number_format:0:'.':' '}</div>
                                        </td>
                                    </tr>
                                    <tr class="slide-toggle">
                                        <td>
                                            <div class="list_left">Отказ</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->manager_money_returns_list item=product}
                                                    <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                                {/foreach}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="list_right" style="color: red;">{$Results->manager_money_returns->total|default:'0'|number_format:0:'.':' '} ({$Results->manager_money_returns->returns_percent|string_format:"%.2f"}%)</div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <table style="font-size: 14px; font-family: sans-serif;width: 100%;">
                            <tbody>
                                <tr data-status="sorted" data-manager="1">
                                    <td>
                                        <div class="list_left ajax_link">Обработка</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товары в обработке<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link" style="color: green;">{$Results->manager_list_sort|default:'0'|number_format:0:'.':' '}</div>
                                    </td>
                                </tr>
                                
                                <tr data-status="to_tk" data-manager="1">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка в ТК</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка в ТК<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->manager_orders_to_tk|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                <tr data-status="to_city" data-manager="1">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка до города</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка до города<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->manager_orders_to_city|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                
                                <tr data-status="to_client" data-manager="1">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка клиенту</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка клиенту<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->manager_orders_to_client|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                
                                <tr data-status="to_ls" data-manager="1">
                                    <td>
                                        <div class="list_left ajax_link">Возврат</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Возвращенные товары<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link" style="color: green;">{$Results->manager_orders_to_ls|default:'0'|number_format:0:'.':' '}</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Доставлено</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->manager_orders_delivered_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;">{$Results->manager_orders_delivered|default:'0'|number_format:0:'.':' '} р</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Вернули</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->manager_orders_returned_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: red;">{$Results->manager_orders_returned[0]->total|default:'0'|number_format:0:'.':' '} р </div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Звонков</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Список звонков<div class="fatlist_close">Закрыть</div></div>
                                            {if $Results->manager_calls}
                                                {foreach from=$Results->manager_calls item=call}
                                                    {if $call->client_id}<a href="/admin/index.php?section=User&user_id={$call->client_id}" target="_blank">{$call->name}</a>{else}Неизвестный{/if} <span style="color:grey;">Дата звонка: {$call->date}</span><br />
                                                {/foreach}
                                            {/if}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->manager_calls_count}</div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div style="float:left;margin-left:50px;">
                    <span style="font-size:14px;">Общая статистика за месяц</span>
                        <div class="border">
                            <table style="font-size: 14px;font-family: sans-serif;width: 100%;">
                                <tbody>
                                    <tr class="slide-toggle">
                                        <td>
                                            <div class="list_left">Принято</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->money_received_list item=product}
                                                    <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                                {/foreach}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="list_right" style="color: green;"><!--{$Results->money_received|default:'0'|number_format:0:'.':' '}--></div>
                                        </td>
                                    </tr>
                                    <tr class="slide-toggle">
                                        <td>
                                            <div class="list_left">Отказ</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->money_returns_list item=product}
                                                    <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                                {/foreach}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="list_right" style="color: red;"><!--{$Results->money_returns|default:'0'|number_format:0:'.':' '}--></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <table style="font-size: 14px;font-family: sans-serif;margin-top:20px;width: 100%;">
                            <tbody>
                                <tr data-status="sorted" data-manager="0">
                                    <td>
                                        <div class="list_left ajax_link">Обработка</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товары в обработке<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link" style="color: green;">{$Results->list_sort|default:'0'|number_format:0:'.':' '}</div>
                                    </td>
                                </tr>
                                <tr data-status="to_tk" data-manager="0">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка в ТК</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка в ТК<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_to_tk|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                <tr data-status="to_city" data-manager="0">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка до города</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка до города<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_to_city|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                <tr data-status="to_client" data-manager="0">
                                    <td>
                                        <div class="list_left ajax_link">
                                            <div class="list_left">Доставка клиенту</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка клиенту<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_to_client|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                <tr data-status="to_ls" data-manager="0">
                                    <td>
                                        <div class="list_left ajax_link">Возврат</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Возвращенные товары<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link" style="color: green;">{$Results->orders_to_ls|default:'0'|number_format:0:'.':' '}</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Курьерами доставлено</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->orders_delivered_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;">{$Results->orders_delivered|default:'0'|number_format:0:'.':' '} р</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Курьерам вернули</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->orders_returned_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: red;">{$Results->orders_returned[0]->total|default:'0'|number_format:0:'.':' '} р <span style='color:red;'>({$Results->orders_returned[0]->returns_percent|string_format:"%.2f"}%)</span></div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Звонков</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Список звонков<div class="fatlist_close">Закрыть</div></div>
                                            {if $Results->manager_calls}
                                                {foreach from=$Results->calls item=call}
                                                    {if $call->client_id}<a href="/admin/index.php?section=User&user_id={$call->client_id}" target="_blank">{$call->name}</a>{else}Неизвестный{/if} <span style="color:grey;">Дата звонка: {$call->date}</span><br />
                                                {/foreach}
                                            {/if}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->calls_count}</div>
                                    </td>
                                </tr>
                                {if $smarty.session.user->subgroup_id == 3}
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Стоимость доставки</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Стоимость доставки<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->delivery_price_list item=order}
                                                <a href="/admin/index.php?section=Order&order_id={$order->order_id}&token={$order->code}" style="color: red;" target="_blank">№{$order->order_id}</a>: {$order->delivery_agent_price}руб <span style='color:grey;'>({$order->delivery_price})</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: blue;">{$Results->delivery_total|default:'0'|number_format:0:'.':' '} р</div>
                                    </td>
                                </tr>
                                {/if}
                                {if $Results->order_count_Instagramm}
                                  <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Заказов из Инстаграмм {$Results->order_count_Instagramm}</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Заказов из Инстаграмм<div class="fatlist_close">Закрыть</div></div>
                                            Принято: {$Results->money_count_Instagramm_1|default:'0'|number_format:0:'.':' '} р Отказ: {$Results->money_count_Instagramm_2|default:'0'|number_format:0:'.':' '} р Примерка: {$Results->money_count_Instagramm_0|default:'0'|number_format:0:'.':' '} р <br />
                                            {foreach from=$Results->Instagramm_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->money_count_Instagramm|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                {/if}
                            </tbody>
                        </table>
                    </div>
                    <div class="clear">&nbsp;</div>
                    <div>
                      {foreach from=$sale_brands item=brand}
                      {if $brand->new_season}
                        <h3>{$brand->name}</h3>
                        <span style="min-width:150px;display:inline-block;"><b>Новый сезон</b> ({$Settings->current_new_season}):</span><span style="min-width:100px;display:inline-block;">скидка {$brand->new_season->sale}%,</span> <span style="min-width:150px;display:inline-block;">максимальная {$brand->new_season->max_sale}%</span><br>
                        <span style="min-width:150px;display:inline-block;"><b>Предыдущий сезон</b> ({$Settings->previous_season}):</span><span style="min-width:100px;display:inline-block;">скидка {$brand->previous_season->sale}%,</span> <span style="min-width:150px;display:inline-block;">максимальная {$brand->previous_season->max_sale}%</span><br>
                        <span style="min-width:150px;display:inline-block;"><b>Прошлые сезоны</b>:</span><span style="min-width:100px;display:inline-block;">скидка {$brand->old_seasons->sale}%,</span> <span style="min-width:150px;display:inline-block;">максимальная {$brand->old_seasons->max_sale}%</span><br>
                        <br>
                      {/if}
                      {/foreach}
                    </div>
                {else}
                    <div style="float:left; width: 31%;">
                        <table style="font-size: 14px;font-family: sans-serif;">
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="list_left">Товаров добавлено</div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;">{$Results->added}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Товаров в продаже</div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;">{$Results->total}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Товаров продано</div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: red;">{$Results->sold}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left"></div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;"></div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Заказов</div>
                                        <div class="links fatlist" id="graphs" style="visibility:hidden;">
                                            <div class="fatlist_title">Заказы по источникам<div class="fatlist_close">Закрыть</div></div>
                                            Подсчитываются все заказы за последний месяц.
                                            <table>
                                                <tr>
                                                    <td>
                                                        <div style="margin-right:20px;">
                                                        Корзина<br><br>
                                                        {if $Results->orders_sourced}
                                                            <table class="bordered">
                                                            <tr>
                                                                <td>Источник</td>
                                                                <td>Число</td>
                                                                <td>Сумма</td>
                                                                <td>Сумма<br>принятого</td>
                                                            </tr>
                                                        {foreach from=$Results->orders_sourced item=order}
                                                            <tr>
                                                                <td>{if $order->ref_source}{$order->ref_source}{else}Не определено{/if}</td>
                                                                <td>{$order->count}</td>
                                                                <td>{$order->total|default:'0'|number_format:0:'.':' '} р</td>
                                                                <td>{$order->acc_total|default:'0'|number_format:0:'.':' '} р</td>
                                                            </tr>
                                                        {/foreach}
                                                            </table>
                                                        {/if}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div>
                                                        Один клик<br><br>
                                                        {if $Results->oneclick_sourced}
                                                            <table class="bordered">
                                                            <tr>
                                                                <td>Источник</td>
                                                                <td>Число</td>
                                                                <td>Сумма</td>
                                                                <td>Сумма<br>принятого</td>
                                                            </tr>
                                                        {foreach from=$Results->oneclick_sourced item=order}
                                                            <tr>
                                                                <td>{if $order->ref_source}{$order->ref_source}{else}Не определено{/if}</td>
                                                                <td>{$order->count}</td>
                                                                <td>{$order->total|default:'0'|number_format:0:'.':' '} р</td>
                                                                <td>{$order->acc_total|default:'0'|number_format:0:'.':' '} р</td>
                                                            <tr>
                                                        {/foreach}
                                                            </table>
                                                        {/if}
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div style="float:left; margin-right:20px;width:350px;margin-top:20px;">
                                                            График по числу заказов<br/>
                                                            <div style="float:left;width:350px;height:200px;margin-bottom:20px;" id="graph11"></div>
                                                            График по сумме стоимости<br/>
                                                            <div style="float:left;width:350px;height:200px;" id="graph12"></div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="float:left; margin-right:20px;width:350px;margin-top:20px;">
                                                            График по числу заказов<br/>
                                                            <div style="float:left;width:350px;height:200px;margin-bottom:20px;" id="graph21"></div>
                                                            График по сумме стоимости<br/>
                                                            <div style="float:left;width:350px;height:200px;" id="graph22"></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div style="clear:both;"></div>
                                            <div style="float:none;margin:20px auto;">
                                            Из приложений<br><br>
                                            iOS заказов {$Results->order_count_iOS|default:'0'} Сумма:{$Results->money_count_iOS|default:'0'|number_format:0:'.':' '} р<br>
                                            Android заказов {$Results->order_count_Android} Сумма:{$Results->money_count_Android|default:'0'|number_format:0:'.':' '} р <br>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;">{$Results->orders}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Фотографий добавлено</div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;">{$Results->photos}</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Баннеров добавлено</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Баннеров добавлено<div class="fatlist_close">Закрыть</div></div>
                                            {if $Results->banners_m_list}
                                            {foreach from=$Results->banners_m_list item=brand}
                                                <a href="/files/brand_banners/{$brand->banner_m}" style="color: red;" target="_blank">{$brand->name}</a>: мужской<br>
                                            {/foreach}
                                            {/if}
                                            {if $Results->banners_w_list}
                                            {foreach from=$Results->banners_w_list item=brand}
                                                <a href="/files/brand_banners/{$brand->banner_w}" style="color: green;" target="_blank">{$brand->name}</a>: женский<br>
                                            {/foreach}
                                            {/if}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->banners}</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Авторизованных в приложении </div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Пользователей авторизованных в приложении<div class="fatlist_close">Закрыть</div></div>
                                            {if $Results->month_push_list}
                                            {foreach from=$Results->app_auth_list item=user}
                                                <a href="/admin/index.php?section=User&user_id={$user->original_user_id}" style="color: blue;" target="_blank">{if $user->name}{$user->name}{else} - {/if}</a><br>
                                            {/foreach}
                                            {/if}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->app_auth_count}</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Установки приложений</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Установки приложений<div class="fatlist_close">Закрыть</div></div>
                                            <div style="float:left;margin-right:40px;">
                                              Всего:{$Results->app_track_count}<br>
                                              {if $Results->app_track_by_shop}
                                              <table>
                                              {foreach from=$Results->app_track_by_shop item=shop}
                                                  <tr>{if $shop->app_count}<td style="width:160px;">{if $shop->name}{$shop->name}{else}Не указан{/if}</td><td style="width:20px;text-align:right;">{$shop->app_count}</td>{/if}</tr>
                                              {/foreach}
                                              </table>
                                              {/if}
                                            </div>
                                            <div style="float:left;margin-right:20px;">
                                              Авторизованных:{$Results->app_track_auth_count}<br>

                                              {if $Results->app_track_auth_by_shop}
                                              <table>
                                              {foreach from=$Results->app_track_auth_by_shop item=shop}
                                                  <tr>{if $shop->app_count}<td style="width:160px;">{if $shop->name}{$shop->name}{else}Не указан{/if}</td><td style="width:20px;text-align:right;">{$shop->app_count}</td>{/if}</tr>
                                              {/foreach}
                                              </table>
                                              {/if}
                                            </div>
                                            <div style="float:left;margin-right:20px;">
                                              План:330<br>

                                              <table>
                                                <tr><td style="width:160px;">Luxury Store (НВН)</td><td style="width:20px;text-align:right;">80</td></tr>
                                                <tr><td style="width:160px;">Ice Iceberg</td><td style="width:20px;text-align:right;">30</td></tr>
                                                <tr><td style="width:160px;">Лакшери Покровка</td><td style="width:20px;text-align:right;">30</td></tr>
                                                <tr><td style="width:160px;">Лакшери Покровка 50	</td><td style="width:20px;text-align:right;">80</td></tr>
                                                <tr><td style="width:160px;">Podium VIP</td><td style="width:20px;text-align:right;">30</td></tr>
                                                <!--<tr><td style="width:160px;">MTM</td><td style="width:20px;text-align:right;"></td></tr>-->
                                                <tr><td style="width:160px;">Интернет-Магазин</td><td style="width:20px;text-align:right;">80</td></tr>
                                              </table>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->app_track_count}</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Cмс с приложениями</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Cмс с приложениями<div class="fatlist_close">Закрыть</div></div>
                                            <div style="float:left;margin-right:40px;">
                                              Отправлено:{$Results->app_sms_count}<br>
                                              {if $Results->app_sms_by_shop}
                                              <table>
                                              {foreach from=$Results->app_sms_by_shop item=shop}
                                                  <tr>{if $shop->app_count}<td style="width:160px;">{if $shop->name}{$shop->name}{else}Не указан{/if}</td><td style="width:20px;text-align:right;">{$shop->app_count}</td>{/if}</tr>
                                              {/foreach}
                                              </table>
                                              {/if}
                                            </div>
                                            <div style="float:left;margin-right:20px;">
                                              Авторизованных:{$Results->app_sms_auth_count}<br>

                                              {if $Results->app_sms_auth_by_shop}
                                              <table>
                                              {foreach from=$Results->app_sms_auth_by_shop item=shop}
                                                  <tr>{if $shop->app_count}<td style="width:160px;">{if $shop->name}{$shop->name}{else}Не указан{/if}</td><td style="width:20px;text-align:right;">{$shop->app_count}</td>{/if}</tr>
                                              {/foreach}
                                              </table>
                                              {/if}
                                            </div>
                                            <div style="float:left;margin-right:20px;">
                                              Зарегистрировавшихся:{$Results->app_sms_reg_count}<br>

                                              {if $Results->app_sms_reg_by_shop}
                                              <table>
                                              {foreach from=$Results->app_sms_reg_by_shop item=shop}
                                                  <tr>{if $shop->app_count}<td style="width:160px;">{if $shop->name}{$shop->name}{else}Не указан{/if}</td><td style="width:20px;text-align:right;">{$shop->app_count}</td>{/if}</tr>
                                              {/foreach}
                                              </table>
                                              {/if}
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->app_sms_count}</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Push-сообщений за месяц</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Push-сообщений за месяц<div class="fatlist_close">Закрыть</div></div>
                                            {if $Results->month_push_list}
                                            {foreach from=$Results->month_push_list item=push}
                                                <a href="/admin/index.php?section=User&user_id={$push->original_user_id}" style="color: blue;" target="_blank">{if $push->name}{$push->name}{else} - {/if}</a>: {$push->SoPro}<br>
                                            {/foreach}
                                            {/if}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->month_push_count}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Звонков за месяц</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->month_calls_count}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Смс за месяц</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->month_sms_count}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Писем за месяц</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->month_emails_count}</div>
                                    </td>
                                </tr>
                                {*<tr>
                                    <td>
                                        <div style="position:relative;bottom:-12px;" class="list_left">Выручка:</div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;"><span style="font-size:24px;">{$Results->profit}</span> руб</div>
                                    </td>
                                </tr>*}
                            </tbody>
                        </table>
                    </div>

                    <div style="float:left;margin-left:3%; width: 30%;">
                        <table style="font-size: 14px; font-family: sans-serif;">
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="list_left" >Товаров за все время</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->alltime}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Товаров в выгрузке</div>
                                    </td>
                                    <td>
                                        <div class="list_right">2631</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left" >Всего заказов</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->alltime_orders}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left" >Всего текстов</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->alltime_descriptions}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left" >Англ. текстов</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->alltime_eng_descriptions}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left" >Всего фотографий</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->alltime_photos}</div>
                                    </td>
                                </tr>
                                <tr data-period="all">
                                    <td>
                                        <div class="list_left ajax_link">Пользователей всего</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Пользователей всего<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">{$Results->users_count}</div>
                                    </td>
                                </tr>
                                <tr data-period="new">
                                    <td>
                                        <div class="list_left ajax_link">Новых пользователей</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Новых пользователей<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">{$Results->new_users_count}</div>
                                    </td>
                                </tr>
                                <tr data-period="month">
                                    <td>
                                        <div class="list_left ajax_link">Активных за месяц</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Активных за месяц<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">{$Results->month_users_count}</div>
                                    </td>
                                </tr>
                                <tr data-period="h_year">
                                    <td>
                                        <div class="list_left ajax_link">Активных за полгода</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Активных за полгода<div class="fatlist_close">Закрыть</div></div>
                                            <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">{$Results->h_year_users_count}</div>
                                    </td>
                                </tr>
                                <tr data-period="year">
                                    <td>
                                        <div class="list_left ajax_link">Активных за год</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Активных за год<div class="fatlist_close">Закрыть</div></div>
                                             <div class="ajax_result" ></div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">{$Results->year_users_count}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="list_left">Пользователей с мерками</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->measured_users}</div>
                                    </td>
                                </tr>
                                {*<tr>
                                    <td>
                                        <div style="position:relative;bottom:-12px;" class="list_left">Всего:</div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;"><span style="font-size:24px;">{$Results->alltime_profit}</span> руб</div>
                                    </td>
                                </tr>*}
                            </tbody>
                        </table>
                    </div>
                    {if in_array('FinanseStat', $user_allowed)}
                    <div style="float:left;margin-left:3%; width: 33%">
                        <div class="border">
                            <table style="font-size: 14px; font-family: sans-serif;width: 100%;">
                                <tbody>
                                    <tr class="slide-toggle">
                                        <td>
                                            <div class="list_left">Принято</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->money_received_list item=product}
                                                    <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                                {/foreach}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="list_right" style="color: green;">{if !$allowed_manager}{$Results->money_received|default:'0'|number_format:0:'.':' '} р{/if}</div>
                                        </td>
                                    </tr>
                                    <tr class="slide-toggle">
                                        <td>
                                            <div class="list_left">Возврат</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->money_returns_list item=product}
                                                    <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                                {/foreach}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="list_right" style="color: red;">{if !$allowed_manager}{$Results->money_returns[0]->total|default:'0'|number_format:0:'.':' '} р <span style='color:red;'>({$Results->money_returns[0]->returns_percent|string_format:"%.2f"}%)</span>{/if}</div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <table style="font-size: 14px; font-family: sans-serif;">
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="list_left">Из приложений:</div>
                                    </td>
                                    <td>

                                    </td>
                                </tr>
                                {if $Results->order_count_iOS}
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">iOS заказов {$Results->order_count_iOS|default:'0'}</div>
                                        {if $exp}<br/>Принято{/if}
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Заказов из приложения iOS<div class="fatlist_close">Закрыть</div></div>
                                            Принято: {$Results->money_count_iOS_1|default:'0'|number_format:0:'.':' '} р Отказ: {$Results->money_count_iOS_2|default:'0'|number_format:0:'.':' '} р Примерка: {$Results->money_count_iOS_0|default:'0'|number_format:0:'.':' '} р <br />
                                            {foreach from=$Results->iOS_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->money_count_iOS|default:'0'|number_format:0:'.':' '} р
                                          {if $exp}<br/>{$Results->money_count_iOS_acc|default:'0'|number_format:0:'.':' '} р{/if}
                                        </div>
                                    </td>
                                </tr>
                                {/if}
                                {if $Results->order_count_Android}
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Android заказов {$Results->order_count_Android}</div>
                                        {if $exp}<br/>Принято{/if}
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Заказов из приложения Android<div class="fatlist_close">Закрыть</div></div>
                                            Принято: {$Results->money_count_Android_1|default:'0'|number_format:0:'.':' '} р Отказ: {$Results->money_count_Android_2|default:'0'|number_format:0:'.':' '} р Примерка: {$Results->money_count_Android_0|default:'0'|number_format:0:'.':' '} р <br />
                                            {foreach from=$Results->Android_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->money_count_Android|default:'0'|number_format:0:'.':' '} р
                                          {if $exp}<br/>{$Results->money_count_Android_acc|default:'0'|number_format:0:'.':' '} р{/if}
                                        </div>
                                    </td>
                                </tr>
                                {/if}
                                {if $Results->order_count_Instagramm}
                                  <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Заказов из Инстаграмм {$Results->order_count_Instagramm}</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Заказов из Инстаграмм<div class="fatlist_close">Закрыть</div></div>
                                            Принято: {$Results->money_count_Instagramm_1|default:'0'|number_format:0:'.':' '} р Отказ: {$Results->money_count_Instagramm_2|default:'0'|number_format:0:'.':' '} р Примерка: {$Results->money_count_Instagramm_0|default:'0'|number_format:0:'.':' '} р <br />
                                            {foreach from=$Results->Instagramm_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->money_count_Instagramm|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                {/if}
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Курьерами доставлено</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->orders_delivered_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: green;">{$Results->orders_delivered|default:'0'|number_format:0:'.':' '} р</div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Курьерам вернули</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->orders_returned_list item=product}
                                                <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: red;">{$Results->orders_returned[0]->total|default:'0'|number_format:0:'.':' '} р <span style='color:red;'>({$Results->orders_returned[0]->returns_percent|string_format:"%.2f"}%)</span></div>
                                    </td>
                                </tr>
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">Стоимость доставки</div>
                                        <div class="links fatlist" style="display:none;">
                                            <div class="fatlist_title">Стоимость доставки<div class="fatlist_close">Закрыть</div></div>
                                            {foreach from=$Results->delivery_price_list item=order}
                                                <a href="/admin/index.php?section=Order&order_id={$order->order_id}&token={$order->code}" style="color: red;" target="_blank">№{$order->order_id}</a>: {$order->delivery_agent_price}руб <span style='color:grey;'>(для клиента:{$order->delivery_price})</span>{if $order->delivery_return_price != 0}<span style='color:#5a04cc;'>(Возврат:{$order->delivery_return_price})</span>{/if}{if $order->delivery_agent_fee != 0} <span style='color:#5a04cc;'>(Агентское вознаграждение:{$order->delivery_agent_fee})</span>{/if}<br>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right" style="color: blue;">{$Results->delivery_total[0]->total|default:'0'|number_format:0:'.':' '} р <span style='color:blue;'>({$Results->delivery_total[0]->delivery_percent|string_format:"%.2f"}%)</span></div>
                                    </td>
                                </tr>

                                <tr data-status="new">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Новых заказов</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Новых заказов<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_NEW|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>

                                <tr data-status="sorted">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Товаров в обработке</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров в обработке<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_Sorted|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                
                                <tr data-status="sorted" data-substatus="packed">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Товаров в обработке(отправка)</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров в обработке(отправляем)<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_Sorted_packed|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                
                                <tr data-status="sorted" data-substatus="delayed">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Товаров в обработке(отложено)</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Товаров в обработке(отложено)<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_Sorted_delayed|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>

                                <tr data-status="to_tk">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка в ТК</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка в ТК<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_to_tk|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                <tr data-status="to_city">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка до города</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка до города<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_to_city|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                                
                                <tr data-status="to_client">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">Доставка клиенту</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Доставка клиенту<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_to_client|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>

                                <tr data-status="to_ls">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left ajax_link">В возврате до ЛС</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">В возврате до ЛС<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right ajax_link">
                                            {$Results->orders_to_ls|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
<!--
                                <tr data-status="agent" class="ajax_link">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_right">Деньги у ТК</div>
                                            <div class="links fatlist" style="display:none;">
												<div class="fatlist_title">Деньги у ТК<div class="fatlist_close">Закрыть</div></div>
                                                <div class="ajax_result" ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">
                                            {$Results->money_at_agent|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <div class="list_left">Приемка денег</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->money_confirm|default:'0'|number_format:0:'.':' '} р</div>
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <div class="list_left">Приемка товаров</div>
                                    </td>
                                    <td>
                                        <div class="list_right">{$Results->products_confirm|default:'0'|number_format:0:'.':' '} р</div>
                                    </td>
                                </tr>
-->
                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left">Депозит</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Депозит<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->deposits_list item=user}
                                                    <a href="/admin/index.php?section=User&user_id={$user->user_id}" style="color: blue;" target="_blank">№{$user->user_id}:{$user->name}</a> - ({$user->deposit}руб)<br />
                                                {/foreach}
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">
                                            {$Results->total_deposit|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>

                                <tr class="slide-toggle">
                                    <td>
                                        <div class="list_left">
                                            <div class="list_left">Предоплата</div>
                                            <div class="links fatlist" style="display:none;">
                                                <div class="fatlist_title">Предоплата<div class="fatlist_close">Закрыть</div></div>
                                                {foreach from=$Results->prepaid_list item=order}
                                                    <a href="/admin/index.php?section=Order&order_id={$order->order_id}&token={$order->code}" style="color: red;" target="_blank">№{$order->order_id}</a>: {$order->payment_prepaid}руб<br>
                                                {/foreach}
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="list_right">
                                            {$Results->prepaid_total|default:'0'|number_format:0:'.':' '} р
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>



                  {*<tr>
                    <td>
                      <div style="position:relative;bottom:-12px;" class="list_left">Всего:</div>
                    </td>
                    <td>
                      <div class="list_right" style="color: green;"><span style="font-size:24px;">{$Results->alltime_profit|number_format:0:'.':' '}</span> руб</div>
                    </td>
                  </tr>*}
                            </tbody>
                          </table>
                        </div>
                            {/if}
                        {/if}
                    </div>
                </div>
            </div>

      </div>
    </div>
  </div>
</div>
{else}
<div id="content">
  <div id="cont_border">
    <div id="cont">
    <div style="float:left;">
        <table style="font-size: 14px;font-family: sans-serif;"><tbody>
            <tr>
                <td>
                    <div class="list_left">Товаров добавлено</div>
                </td>
                <td>
                    <div class="list_right" style="color: green;">{$Results->added}</div>
                </td>
            </tr>
        </tbody></table>
    </div>
    <br><br>
    </div>
  </div>
</div>
{/if}
<script>
    window.period_param = '{$Pparam}';
</script>
{if !$allowed_manager}
{literal}
<script language="javascript" type="text/javascript" src="../js/flot/jquery.canvaswrapper.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.colorhelpers.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.saturated.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.browser.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.drawSeries.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.uiConstants.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.time.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.tooltip.min.js"></script>
<script>
     d1 = [];
     d2 = [];
    {/literal}{foreach from=$Results->orders_sourced key=key item=order}
        {literal}
            d1.push(
            {
                label:{/literal}'{if $order->ref_source}{$order->ref_source}{else}undefined{/if}'{literal},
                count:{/literal}{if $order->count}{$order->count}{else}0{/if}{literal},
                total:{/literal}{if $order->total}{$order->total}{else}0{/if}{literal}
            }
        );
    {/literal}{/foreach}{literal}
    {/literal}{foreach from=$Results->oneclick_sourced key=key item=order}
        {literal}
            d2.push(
            {
                label:{/literal}'{if $order->ref_source}{$order->ref_source}{else}undefined{/if}'{literal},
                count:{/literal}{if $order->count}{$order->count}{else}0{/if}{literal},
                total:{/literal}{if $order->total}{$order->total}{else}0{/if}{literal}
            }
        );
    {/literal}{/foreach}{literal}


    var d11 = [];
    for (index = 0, len = d1.length; index < len; ++index) {
        d11.push([index, d1[index]['count']]);
    }
    var d12 = [];
    for (index = 0, len = d1.length; index < len; ++index) {
        d12.push([index, d1[index]['total']]);
    }
    var d21 = [];
    for (index = 0, len = d2.length; index < len; ++index) {
        d21.push([index, d2[index]['count']]);
    }
    var d22 = [];
    for (index = 0, len = d2.length; index < len; ++index) {
        d22.push([index, d2[index]['total']]);
    }

	$.plot('#graph11', [{data:d11, bars: { show: true }}], {
        grid: {hoverable: true},
        tooltip: {
            show: true,
            content: function(label, xval, yval, flotItem){
                content = d1[parseInt(xval,10)]['label']+", кол-во: "+yval;
                return content;
            }
        }
      });
	$.plot('#graph12', [{data:d12, bars: { show: true }}], {
        grid: {hoverable: true},
        tooltip: {
            show: true,
            content: function(label, xval, yval, flotItem){
                content = d1[parseInt(xval,10)]['label']+", сумма: "+yval;
                return content;
            }
        }
      });
      $.plot('#graph21', [{data:d21, bars: { show: true }}], {
        grid: {hoverable: true},
        tooltip: {
            show: true,
            content: function(label, xval, yval, flotItem){
                content = d2[parseInt(xval,10)]['label']+", кол-во: "+yval;
                return content;
            }
        }
      });
	$.plot('#graph22', [{data:d22, bars: { show: true }}], {
        grid: {hoverable: true},
        tooltip: {
            show: true,
            content: function(label, xval, yval, flotItem){
                content = d2[parseInt(xval,10)]['label']+", сумма: "+yval;
                return content;
            }
        }
      });

  $("#graphs").attr('style','display:none;');
</script>
{/literal}
{/if}
<div style="display:none;">
  <div class="preloader" id='preloader'>
      <div class="item-1"></div>
      <div class="item-2"></div>
      <div class="item-3"></div>
      <div class="item-4"></div>
      <div class="item-5"></div>
  </div>
</div>
<script>
var year = {if $allowed_admin}new Date(2012, 8){else}0{/if};
var preloader = $('#preloader');
{literal}
	function get_res (link, Cresults, container) {
    container.slideDown('100', function(){
      container.find('.ajax_result').html(preloader);
      jQuery.ajax({
			url:link,
			dataType: "html",
			success: function(data) {
				Cresults.html(data);
				if ($('#over').height() < (container.height()+120)){
          $('#over').height(container.height() + 120);
        }
			}
		})
    });
		
	}



	$(document).on("ready", function() {

        moment.locale('ru');
        if(year == 0){year = moment().subtract(14, 'months').startOf('year');}
        var range = moment.range(year, Date.now());
        var cont = $('select#month');
        var now = moment();
        range.by("months", function(period) {
            var html = "<option value='" + period.format("Y-MM") + "'>" + period.format("MMMM Y") + "</option>";
            if ( period.format("Y M") === now.format("Y M") ) {
                html = "<option value='current'>" + period.format("MMMM Y") + "</option>";
            }
            cont.prepend(html);
        });
        $('option[value="'+window.period_param+'"]').attr("selected",true);
    });
    $(document).on("click touchstart", ".slide-toggle", function(e) {
        if ($('#over').height() < ($(this).find('.links').height()+240)){
            $('#over').height($(this).find('.links').height() + 240);
        }
        else{}
        $(this).find('.links').slideDown();
        e.stopPropagation();
    });
    $(document).on("click touchstart", ".ajax_link", function(e) {
      var el = $(this).closest('tr'),
      period = el.attr('data-period'),
      shop = el.attr('data-shop'),
      delagent = $('select[name="delivery_company"]').val(),
      status = el.attr('data-status'),
      substatus = el.attr('data-substatus'),
      manager = el.attr('data-manager');
      if(shop){
        var container = $('#outside'),
        link = '/admin/index.php?section=MainPage&get_users&period='+period+'&shop='+shop+'',
        Cresults = $('#ajax_result');
      }
      if (status){
        var container = el.find('.fatlist'),
        link = '/admin/index.php?section=MainPage&ajax_get_orders&status='+status+'&delagent='+delagent+'',
        Cresults = el.find('.ajax_result');
        if(substatus != undefined){
          var link = link+'&substatus='+substatus;
        }console.log(link);
      }
      if (period != undefined && shop == undefined){
        var container = el.find('.fatlist'),
        link = '/admin/index.php?section=MainPage&get_users_count&period='+period+'',
        Cresults = el.find('.ajax_result');
      }
      if (manager){
        var container = el.find('.fatlist'),
        period = $('select[name="period"]').val(),
        link = '/admin/index.php?section=MainPage&ajax_get_orders&status='+status+'&delagent='+delagent+'&manager='+manager+'&period='+period+'',
        Cresults = el.find('.ajax_result');
        if(manager == 0){
          var link = '/admin/index.php?section=MainPage&ajax_get_orders&status='+status+'&delagent='+delagent+'&period='+period+'';
        }
      }
      get_res(link, Cresults, container);
      e.stopPropagation();
    });
    $(document).on("click touchstart", ".fatlist_close", function(e) { $(this).parents('.links:first').slideUp(); $('#over').attr('style', ''); e.stopPropagation(); });
</script>
{/literal}
