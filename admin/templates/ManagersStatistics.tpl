<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
	<li><a href="index.php?section=Storefront" class="off">{$Site_name}</a></li>
	{if in_array('CopywriterTaskManager', $user_allowed)}<li><a href="index.php?section=CopywriterTasksManager" class="off" title="Управление и проверка задач копирайтера">&copy; задачи</a></li>{/if}
	{if $is_copywriter}<li><a href="index.php?section=CopywriterTasks" class="off" title="Задачи на копирайтинг">&copy; задачи</a></li>{/if}
	{if in_array('CopywriterStat', $user_allowed)}<li><a href="index.php?section=CopywriterStat" class="off"  title="Статистика по задачам копирайтера">&copy; статистика</a></li>{/if}
    {if in_array('CityStats', $user_allowed)}<li><a href="index.php?section=CityStats" class="off">Статистика по городам</a></li>{/if}
	<li><a href="index.php?section=ManagersStatistics" class="on">Менеджеры</a></li>
  </ul>
  <!-- /Вкладки /-->

</div>

<!-- Content #Begin /-->
<div id="content" style="position:relative;">
  <div id="cont_border">
    <div id="cont">

      <div id="cont_top">
        <!-- Иконка раздела /-->
	    <img src="./images/icon_users.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->

	    <!-- Заголовок раздела /-->
        <h1 id="headline">Статистика по менеджерам</h1>
        <!-- /Заголовок раздела /-->



      </div>



					<div style="float:left;margin-bottom:20px;margin-top:20px;margin-left: 12px;">
						<form action="index.php?section=ManagersStatistics" method="post">
							<select style="width:108px;" name="period" id="month">
							</select>
							<input style="margin-left:30px;width:80px;" type="submit" value="Выбрать">
						</form>
					</div>
				<div style="clear:both"></div>

      <div id="cont_center" style="margin-top:10px;">

	  {if $Managers}
		{foreach from=$Managers item=manager}
		<div style="float:left;margin-right:20px;">
			<span style="font-size: 14px;"><a style="color: #000;" href="/admin/index.php?section=User&group=5&user_id={$manager->original_user_id}">{$manager->name}</a></span>
				<div class="border">
					<table style="font-size: 14px; font-family: sans-serif;width: 100%;">
						<tbody>
							<tr>
								<td>
									<div class="slide-toggle list_left">Принято</div>
                                    <div class="links fatlist" style="display:none;">
                                        <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                                        {foreach from=$manager->money_received_list item=product}
                                            <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                        {/foreach}
                                    </div>
								</td>
								<td>
									<div class="list_right" style="color: green;">{$manager->manager_money_received|default:'0'|number_format:0:'.':' '}</div>
								</td>
							</tr>
							<tr>
								<td>
									<div class="slide-toggle list_left">Отказ</div>
                                    <div class="links fatlist" style="display:none;">
                                        <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                                        {foreach from=$manager->money_returns_list item=product}
                                            <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                                        {/foreach}
                                    </div>
								</td>
								<td>
									<div class="list_right" style="color: red;">{$manager->manager_money_returns|default:'0'|number_format:0:'.':' '}</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<table style="font-size: 14px; font-family: sans-serif;width: 100%;">
					<tbody>
            <tr>
							<td><div class="list_left">План на месяц (авто):</div></td>
              <td><div class="list_right">{$manager->target|default:'0'|number_format:0:'.':' '}</div></td>
            </tr>
            <tr>
							<td><div class="list_left">План на месяц (руки):</div></td>
              <td><div class="list_right">{$manager->sales_target|default:'0'|number_format:0:'.':' '}</div></td>
            </tr>
						<tr>
							<td>
								<div class="list_left slide-toggle">Обработка</div>
								<div class="links fatlist" style="display:none;">
									<div class="fatlist_title">Товары в обработке<div class="fatlist_close">Закрыть</div></div>
									{if $manager->manager_list_sort_red}
										{foreach from=$manager->manager_list_sort_red item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: red;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_list_sort_blue}
										{foreach from=$manager->manager_list_sort_blue item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: dodgerblue;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_list_sort_D_red}
										{foreach from=$manager->manager_list_sort_D_red item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: #BB0000;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_list_sort_yellow}
										{foreach from=$manager->manager_list_sort_yellow item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: orange;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_list_sort_green}
										{foreach from=$manager->manager_list_sort_green item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: green;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
								</div>
							</td>
							<td>
								<div class="list_right" style="color: green;">{$manager->manager_list_sort|default:'0'|number_format:0:'.':' '}</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="list_left slide-toggle">Примерка</div>
								<div class="links fatlist" style="display:none;">
									<div class="fatlist_title">Товары в примерке<div class="fatlist_close">Закрыть</div></div>
									{if $manager->manager_to_client_list_red}
										{foreach from=$manager->manager_to_client_list_red item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: red;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_to_client_list_blue}
										{foreach from=$manager->manager_to_client_list_blue item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: dodgerblue;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_to_client_list_D_red}
										{foreach from=$manager->manager_to_client_list_D_red item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: #BB0000;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_to_client_list_yellow}
										{foreach from=$manager->manager_to_client_list_yellow item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: orange;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_to_client_list_green}
										{foreach from=$manager->manager_to_client_list_green item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: green;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
								</div>
							</td>
							<td>
								<div class="list_right" style="color: green;">{$manager->manager_orders_to_client|default:'0'|number_format:0:'.':' '}</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="list_left slide-toggle">Возврат</div>
								<div class="links fatlist" style="display:none;">
									<div class="fatlist_title">Возвращенные товары<div class="fatlist_close">Закрыть</div></div>
									{if $manager->manager_to_ls_list_red}
										{foreach from=$manager->manager_to_ls_list_red item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: red;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_to_ls_list_yellow}
										{foreach from=$manager->manager_to_ls_list_yellow item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: orange;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
									{if $manager->manager_to_ls_list_green}
										{foreach from=$manager->manager_to_ls_list_green item=order}
											{assign var="ord_id" value=$order->order_id}
											{if $order->last_update != 0}{$order->last_update} {/if}<a href="/admin/index.php?section=Order&order_id={$order->order_id}" style="color: green;" target="_blank">№{$ord_id}({$orderlist.$ord_id.value}руб)</a> {if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$orderlist.$ord_id.skus}{if $order->delivery_date && $order->delivery_date != 0} <span style="color:grey;">Дата доставки: {$order->delivery_date}</span>{/if}<br />
										{/foreach}
									{/if}
								</div>
							</td>
							<td>
								<div class="list_right" style="color: green;">{$manager->manager_orders_to_ls|default:'0'|number_format:0:'.':' '}</div>
							</td>
						</tr>
            <tr>
                <td>
                    <div class="slide-toggle list_left">Заказов доставлено</div>
                    <div class="links fatlist" style="display:none;">
                        <div class="fatlist_title">Товаров принято<div class="fatlist_close">Закрыть</div></div>
                        {foreach from=$manager->manager_orders_delivered_list item=product}
                            <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                        {/foreach}
                    </div>
                </td>
                <td>
                    <div class="list_right" style="color: green;">{$manager->manager_orders_delivered|default:'0'|number_format:0:'.':' '} р</div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="slide-toggle list_left">Заказов в доставке</div>
                    <div class="links fatlist" style="display:none;">
                        <div class="fatlist_title">Товаров в доставке<div class="fatlist_close">Закрыть</div></div>
                        {foreach from=$manager->manager_orders_delivering_list item=product}
                            <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: green;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                        {/foreach}
                    </div>
                </td>
                <td>
                    <div class="list_right" style="color: green;">{$manager->manager_orders_delivering|default:'0'|number_format:0:'.':' '} р</div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="slide-toggle list_left">Заказов вернули</div>
                    <div class="links fatlist" style="display:none;">
                        <div class="fatlist_title">Товаров вернули<div class="fatlist_close">Закрыть</div></div>
                        {foreach from=$manager->manager_orders_returned_list item=product}
                            <a href="/admin/index.php?section=Order&order_id={$product->order_id}" target="_blank">№{$product->order_id}</a>: <a href="/products/{$product->product_id}" style="color: red;" target="_blank">{$product->product_name}</a> {$product->price}руб</span><br>
                        {/foreach}
                    </div>
                </td>
                <td>
                    <div class="list_right" style="color: red;">{$manager->manager_orders_returned[0]->total|default:'0'|number_format:0:'.':' '} р </div>
                </td>
            </tr>
						<tr>
							<td>
								<div class="list_left">Заказов всего</div>
							</td>
							<td>
								<div class="list_right">{$manager->manager_orders_count}</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="list_left">Клиентов всего</div>
							</td>
							<td>
								<div class="list_right">{$manager->manager_clients_count}</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="list_left slide-toggle">Звонков всего</div>
								<div class="links fatlist" style="display:none;">
									<div class="fatlist_title">Список звонков<div class="fatlist_close">Закрыть</div></div>
									{if $manager->manager_calls}
										{foreach from=$manager->manager_calls item=call}
											{if $call->client_id}<a href="/admin/index.php?section=User&user_id={$call->client_id}" target="_blank">{$call->name}</a>{else}Неизвестный{/if} <span style="color:grey;">Дата звонка: {$call->date}</span><br />
										{/foreach}
									{/if}
								</div>
							</td>
							<td>
								<div class="list_right">{$manager->manager_calls_count}</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			{/foreach}
		{/if}
	  </div>

	 </div>
	</div>
</div>

<script>
    window.period_param = '{$Pparam}';
</script>
{literal}
<script>
  $(document).on("ready", function() {
      moment.locale('ru');
      var range = moment.range(new Date(2012, 8), Date.now());
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
	$(document).on("click touchstart", ".slide-toggle", function() {
		if ($('#cont_border').height() < ($(this).parent().children('.links').height()+240)){
			$('#cont_border').height($(this).parent().children('.links').height() + 240);
		}
		else{}
		$(this).next('.links').slideToggle();
	});
	$(document).on("click touchstart", ".fatlist_close", function() { $(this).parents('.links:first').slideUp(); $('#cont_border').attr('style', ''); });
</script>
{/literal}
