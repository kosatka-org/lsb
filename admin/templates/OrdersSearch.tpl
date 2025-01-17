<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
	{if !$DeliveryAgent}
	  <li><a href="index.php?section=Orders" class="{if $View=='new'}on{else}off{/if}">новые</a></li>
	  <li><a href="index.php?section=Orders&view=process" class="{if $View=='process'}on{else}off{/if}">обработка</a></li>
	  <li><a href="index.php?section=Orders&view=delivery" class="{if $View=='delivery'}on{else}off{/if}">доставка</a></li>
	  <li><a href="index.php?section=Orders&view=done" class="{if $View=='done'}on{else}off{/if}">выполнены</a></li>
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

</div>
 
<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
	<div id="cont">
	 
	 
	  <div id="cont_top">
		<!-- Иконка раздела /--> 
		<img src="./images/icon_search.jpg" alt="" class="line"/>
		<!-- /Иконка раздела /-->

	 <p><a href="?section=OrdersSearch&keyword={$keyword}">Онлайн</a> / <a href="?section=OrdersSearch&type=offline&keyword={$keyword}">Оффлайн</a></p>
		
		<!-- Заголовок раздела /-->
		<h1 id="headline">Поиск заказа {if $type == 'offline'}оффлайн{else}онлайн{/if}</h1>
		<!-- /Заголовок раздела /-->
		
	   
	  </div>

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
		  
		  {if $DeliveryAgent}
			{if $DelView=='0'}
			  <p>Доставка в ТК - Товар, который необходимо забрать в стационарных точках розничной сети Лакшери Стор</p>
			{/if}
			{if $DelView=='1'}
			  <p>Доставка до города - Товар, доставляемый до города заказчика</p>
			{/if}
			{if $DelView=='3'}
			  <p>Товар доставлен - Товары, принятые заказчиком, оплата за которые подтверждается бухгалтерией Лакшери Стор. (Юля должна нажать кнопку "деньги получены")</p>
			{/if}
			{if $DelView=='5'}
			  <p>Возврат в ТК - Товар, доставляемый в Нижний Новгород, в офис ООО "Центр Доставки"</p>
			{/if}
			{if $DelView=='6'}
			  <p> Возврат в ЛС - Товар, находящийся в офисе ООО "Центр Доставки" в Нижнем Новгороде (Юля должна нажать кнопку "товар получен")</p>
			{/if}
			{if $DelView=='7'}
			  <p>Выполнен, ждет оплаты - Заказы, по которым и деньги, и товары приняты бухгалтерией Лакшери Стор (Юля должна нажать кнопку "доставка олачена")</p>
			{/if}
			{if $DelView=='8'}
			  <p>Оплачен - Архив товаров, по которым нет претензий ни с одной из сторон.</p>
			{/if}

		  {/if} 

		  
		  <div class="clear">&nbsp;</div>	


		  {$PagesNavigation}

		{if $Orders && $type == 'offline'}

			<!-- Block #Begin /-->
				<div class="info">
					<table style="font-size:14px;">
						<tr>
							<th style="padding:0 10px;">Сумма</th>
							<th style="padding:0 10px;">Дата покупки</th>
							<th style="padding:0 10px;">Артикул</th>
							<th style="padding:0 10px;">Модель</th>
							<th style="padding:0 10px;">Клиент</th>
						</tr>
						
						{foreach item=order from=$Orders}
						  
							<tr>
								<td style="padding:0 10px; text-align:center;">{$order->p_sum_with_discount}</td>
								<td style="padding:0 10px; text-align:center;">{$order->p_date|date_format:"%Y-%m-%d"}</td>
								<td style="padding:0 10px; text-align:center;">{$order->sku}</td>
								<td style="padding:0 10px; text-align:center;">{$order->model}</td>
								<td style="padding:0 10px; text-align:center;">{$order->client}</td>
							</tr>
							
						{/foreach}
			
				</table>
			</div>
				
		
		{elseif $Orders}
			{*
		  <div id="excel">
			<a href="#">Загрузить в Excel</a>
		  </div>
		  *}
		  
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
						<a href='index.php{$order->edit_url}' class='order_number'>№{$order->order_id}{if $order->status == 0}(новый){elseif $order->status == 1}(в обработке){elseif $order->status == 2}(выполнен){/if}</a>
						<br>						

						<div class="contact">
							<p class="contact_on">{$order->date}</p>
				{if $order->last_update != "0000-00-00 00:00:00"}<p class="contact_on">Дата последнего обновления: {$order->last_update}</p>{/if}
							{if $order->user_id}
								<p class="contact_on">
				  {if !$DeliveryAgent}
				  <a href='/admin/index.php?section=User&user_id={$order->user_id}' style='color:black;font-size:14px;' target="_blank">{$order->name|escape}</a>
								(<a href='index.php?section=Orders&view=search&keyword=user:{$order->user_id}' style='color:green;' target="_blank">все заказы клиента</a>)
				  {else}
				  {$order->name|escape}
				  {/if}
				</p>
				{else}
				  {if $order->name}<p class="contact_on">{$order->name|escape}</p>{/if}
				{/if}
				{if $order->code && !$DeliveryAgent}<p><a class="tovar_min" href="/index.php?module=Order&order_code={$order->code}">https://lsboutique.ru/index.php?module=Order&order_code={$order->code}</a></p>{/if}
				{if $order->phone}<p class="contact_on"><b style="font-size:14px;">{$order->phone|escape}</b></p>{/if}
				{if $order->city}<p class="contact_on"><b style="font-size:14px;">{$order->city|escape}</b></p>{/if}
				{if $order->address}<p class="contact_on">{$order->address|escape}</p>{/if}
				{if $order->email}<p class="contact_on"><a href="mailto:{$order->email|escape}" style='color:black;'>{$order->email|escape}</a></p>{/if}
				{if $order->delivery_company && !DeliveryAgent}<p class="contact_on">TK: {$order->delivery_company|escape}</p>{/if}
				{if $order->comment}<p class="contact_on"><b>{$order->comment|escape|nl2br}</b></p>{/if}
				{assign var=ds value=$order->delivery_status}
				<p><b>{$DeliveryStats.$ds}</b></p>
				{assign var=ms value=$order->money_status}
				<p><b>{$MoneyStats.$ms}</b></p>
							{if ($order->status == 6 || $order->status == 2 || $View=='search') && $order->delivery_code}<p class="contact_on">Статус доставки:<br><iframe src="/delivery_status.php?InvoiceNumber={$order->delivery_code}" style="width:500px;height:60px;border:0;"></iframe></p>{/if}
						</div>
					</div>
					</td><td valign="bottom">
					<div class="info_right">
						<div class="info_rl">
							<table id="table2">
							
							
			   {foreach item=product from=$order->products}
			   {if !($DeliveryAgent && in_array($product->status,array(1,3)))}
					<tr>
						<td class="td1"><a href="/products/{$product->url}/" target="_blank" class="link">{$product->product_name}</a> 
							{if $product->status}<b>({$product->status}{if $product->status_date != '0000-00-00'}, {$product->status_date}{/if})</b>{/if}<br> {if $product->sku}{$product->sku} /{/if} {$product->item_location}</td>
						<td class="td2">{$product->quantity}&nbsp;шт. &times; {$product->price}<br />
							{if $product->size}размер: <b>{$product->size}</b>{/if}
						</td>
					</tr>
				{/if}
				{/foreach}

				<tr>
				{if !$DeliveryAgent}
					<td class="td1"><p class="cur">Доставка {if $order->real_delivery_price != '0.00'}<b>({$order->real_delivery_price})</b>{/if}</p></td>
									<td class="td2"><p class="cur">{$order->delivery_price}</p></td>
				{else}
					<td class="td1"><p class="cur">Доставка {if $order->delivery_agent_price != '0.00'}<b>({$order->delivery_agent_price})</b>{else} - не заполнена{/if}</p></td>
					<td class="td2"></td>
				{/if}
				</tr>

				{if $order->coupon_code}
				<tr class="gray" style="font-size: 12px;">
					<td class="td1"><p class="cur2">Купон <b></b>{$order->coupon_code}</p></td>
					<td class="td2"><p class="pay">{$order->coupon_discount}{if $order->coupon_type == "absolute"} руб.{else}%{/if}</p></td>
				</tr>
				{/if}

				<tr>
				{if !$DeliveryAgent && $order->delivery_status < 3}
								<td class="td1"><p class="cur2">Сумма </p></td>
								<td class="td2"><p class="pay">{$order->total_amount}</p></td>
				{else}
					{if !empty($order->money_sum->total)}
						<td class="td1"><p class="cur2">Стоимость принятых клиентом товаров </p></td>
						<td class="td2"><p class="pay">{$order->money_sum->total}</p></td>
						</tr><tr>
					{/if}
					{if !empty($order->return_sum->total)}
						<td class="td1"><p class="cur2">Стоимость возвращаемых товаров </p></td>
						<td class="td2"><p class="pay">{$order->return_sum->total}</p></td>
					{/if}
				{/if}
				</tr>

				{if !$DeliveryAgent && ($order->status==0 || $order->status==1)}
					<tr>
						<td class="td1"><p class="cur2" {if $order->user_return_rate > 50}style="color:red;">Внимание! {else}>{/if}Процент возвратов клиентом: </p></td>
						<td class="td2"><p class="pay">{$order->user_return_rate|round:"1"}%</p></td>
					</tr>
				{/if}

			</table>
		</div>
	</div>

	
		<div class="desc">
			{if $order->status==0 || $order->status==3} 
				<a href="index.php{$order->set_to_process_url}" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch"/>В обработку</a>
			{/if}
			{if $order->status==0 || $order->status==1}
				<a href="index.php{$order->set_to_fail_url}" class="fl"><img src="./images/cancel.jpg" alt="" class="fl_ch"/>Отмена заказа</a>
			{/if}
		</div>
			</td></tr></table>
					<div class="clear">&nbsp;</div>
				</div>	
				<!-- Block #End /-->
				
			  
			  {/foreach}
			  {* /Список заказов *}
	
			</form>
			<!-- Форма Товаров #End /-->
			{elseif !$Results}
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
