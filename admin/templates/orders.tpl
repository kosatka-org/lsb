<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
  {if !$DeliveryAgent}
    <!-- <li><a href="/admin/index.php?section=Oneclick&new_orders=1" class="off">предобработка</a></li> -->
    {if $allowed_admin || ($smarty.session.user->group_id == 5 && $smarty.session.user->subgroup_id == 3)}<li><a href="index.php?section=Delivery_to_TK" class="{if $View=='to_tk'}on{else}off{/if}">доставка в тк</a></li>{/if}
    <li><a href="index.php?section=Orders" class="{if $View=='new'}on{else}off{/if}">новые</a></li>
    <li><a href="index.php?section=Orders&view=process" class="{if $View=='process'}on{else}off{/if}">обработка</a></li>
    <li><a href="index.php?section=Orders&view=delivery" class="{if $View=='delivery'}on{else}off{/if}">доставка</a></li>
    <li><a href="index.php?section=Orders&view=done" class="{if $View=='done'}on{else}off{/if}">выполнены</a></li>
    <li><a href="index.php?section=Orders&view=pickup" class="{if $View=='pickup'}on{else}off{/if}">самовывоз</a></li>
    <li><a href="index.php?section=Special_orders" class="{if $View=='Special_orders'}on{else}off{/if}">спец.заказы</a></li>
    </ul>
   <ul style="float:right; padding: 4px 0 5px 0;">
    <li style="display: inline;"><a href="index.php?section=Orders&view=filter" class="{if $View=='filter'}on{else}off{/if}">фильтр</a></li>
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
<div id="content" style="position: relative;">
  <div id="cont_border">
  <div id="cont">

    {if !$DeliveryAgent}
    <div id="cont_top" style="display: none;">
    <!-- Иконка раздела /-->
    {if $View == 'search'}
    <img src="./images/icon_search.jpg" alt="" class="line"/>
    {else}
    <img src="./images/icon_orders.jpg" alt="" class="line"/>
    {/if}
    <!-- /Иконка раздела /-->

    <p></p>

    <!-- Заголовок раздела /-->
    <h1 id="headline">
      {if $View=='new'}Новые заказы{/if}
      {if $View=='process'}Заказы в обработке{/if}
      {if $View=='delivery'}Доставляется{/if}
      {if $View=='done'}Выполненные заказы{/if}
      {if $View=='cancel'}Отмененные заказы{/if}
      {if $View=='search'}Поиск заказа{/if}
      {if $View=='pickup'}Самовывоз{/if}
    </h1>
    <!-- /Заголовок раздела /-->


    </div>
    {/if}

      {if $View=='process'}
    <ul id="inserts">
      <li><a href="index.php?section=Orders&view=process" class="{if isset($delayed) || isset($packed)}off{else}on{/if}">актуальные</a></li>
      <li><a href="index.php?section=Orders&view=process&delayed=1" class="{if isset($delayed)}on{else}off{/if}">отложенные</a></li>
      <li><a href="index.php?section=Orders&view=process&packed=1" class="{if isset($packed)}on{else}off{/if}">отправляем</a></li>
      </ul>
    <div class="clear">&nbsp;</div>
    {/if}

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

      {if $View == 'search'}
      <div class=filter style="width:750px;">
      Ищем по номеру заказа, имени, адресу, телефону, артикулу товара, штрихкоду товара, бренду, категории и номеру накладной
      <form method=get>
        <input name=section type=hidden value='{$smarty.get.section}'>
        <input name=view type=hidden value='{$smarty.get.view}'>
        <input name=brand type=hidden value='{$smarty.get.brand}'>
        <input name=keyword type=text  class="input3" value='{$smarty.get.keyword|escape}' style="width:600px;">
        <input type='submit' value='Найти' class="submit10">
      </form>
      </div>
     <span style="font-size: 22px;"> <span class="online" style="cursor:pointer;">Онлайн{if $finds_num}({$finds_num}){/if}</span> \ <span class="offline" style="cursor:pointer;">Оффлайн{if $off_finds_num}({$off_finds_num}){/if}</span></span>
      {literal}
      <script>
      $(document).ready(function(){
        $(".online").click(function(){
          $('#offline').hide();
          $('#online').show();
        });
        $(".offline").click(function(){
          $('#online').hide();
          $('#offline').show();
        });
      });
    </script>
    {/literal}
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



      {*
      <div id="excel">
      <a href="#">Загрузить в Excel</a>
      </div>
      *}

      <div class="clear">&nbsp;</div>

      <!-- Форма товаров #Begin /-->
      <div id="offline" style="display:none;">
        <form name='products' method="post">

          {* Список покупок *}
          {if $prodazhi}

          {$off_PagesNavigation}
            {foreach item=product from=$prodazhi}

            <img src="./images/line.jpg" alt=""/>

            <!-- Block #Begin /-->
            <div class="info">
              <table>
                <tr>
                  <td>
                    <div class="info_left">
                      <a href='/products/{$product->url}' class='order_number'>{$product->p_model}</a>
                      <br>

                      <div class="contact">
                        <p class="contact_on">Дата продажи: {$product->date}</p>
                        {if $product->user_id}
                          <p class="contact_on">
                            {if !$DeliveryAgent}
                              <a href='/admin/index.php?section=User&user_id={$product->user_id}' style='color:black;font-size:14px;' target="_blank">{$product->user_name|escape}</a>
                                    (<a href='index.php?section=Orders&view=search&keyword=user:{$product->user_id}' style='color:green;' target="_blank">все заказы клиента</a>)
                            {else}
                              {$product->user_name|escape}
                            {/if}
                          </p>
                        {else}
                          {if $order->name}<p class="contact_on">{$order->name|escape}</p>{/if}
                        {/if}
                        {if $order->code && !$DeliveryAgent}<p><a class="tovar_min" href="/index.php?module=Order&order_code={$order->code}">/index.php?module=Order&order_code={$order->code}</a></p>{/if}
                        {if $product->phone_number}<p class="contact_on"><b style="font-size:14px;">{$product->phone_number|escape}</b></p>{/if}
                        {if $product->p_location}<p class="contact_on"><b style="font-size:14px;">{$product->p_location|escape}</b></p>{/if}
                        {if $product->user_city}<p class="contact_on">{$product->user_city|escape}</p>{/if}
                        {if $product->user_adress}<p class="contact_on">{$product->user_adress|escape}</p>{/if}
                        {if $product->user_email}<p class="contact_on"><a href="mailto:{$order->email|escape}" style='color:black;'>{$product->user_email|escape}</a></p>{/if}

                      </div>
                    </div>
                  </td>
                  <td valign="bottom">
                    <div class="info_right">
                      <div class="info_rl">
                        <table id="table2">
                          {if !$DeliveryAgent}
                            <tr>
                              <td class="td1"><a href="/products/{$product->url}/" target="_blank" class="link">{$product->p_model}</a> <br />
                                {if $product->sku}{$product->sku} /{/if} {$product->location}
                              </td>
                              <td class="td2">{$product->quantity}&nbsp;шт. &times; {$product->price}<br />
                                {if $product->size}размер: <b>{$product->size}</b>{/if}
                              </td>
                            </tr>
                          {/if}

                          {if $order->coupon_code}
                            <tr class="gray" style="font-size: 12px;">
                              <td class="td1"><p class="cur2">Купон <b></b>{$order->coupon_code}</p></td>
                              <td class="td2"><p class="pay">{$order->coupon_discount}{if $order->coupon_type == "absolute"} руб.{else}%{/if}</p></td>
                            </tr>
                          {/if}

                        </table>
                      </div>
                    </div>
                  </td>
                </tr>
              </table>
              <div class="clear">&nbsp;</div>
            </div>
            <!-- Block #End /-->


            {/foreach}
          {elseif !$prodazhi}
            <div class="emptylist">Нет покупок</div>
          {/if}
          {* /Список покупок *}

        </form>

          {$off_PagesNavigation}
          <div class="clear">&nbsp;</div>
      </div>
      {if $Orders}
      <div id="online">
        <form name='products' method="post">

          {* Список заказов *}
          {$PagesNavigation}

          {foreach item=order from=$Orders}

          <img src="./images/line.jpg" alt=""/>

          <!-- Block #Begin /-->
          <div class="info" {if $order->manager_id == $smarty.session.user->user_id}style="background:#fffeec;"{/if}>

                  <div class="info_left">
                    <a href='/admin/index.php?section=Order&order_id={$order->order_id}' class='order_number'>№{$order->order_id}{if $order->order_source == 4} (iOS){elseif $order->order_source == 5} (Android){/if}{if $order->language == 'eng'} (ENG){/if}{if $View=='search'}{if $order->status == 0}(новый){elseif $order->status == 1}(в обработке){elseif $order->status == 2}(выполнен){elseif $order->status == 3}(отменён){/if}{/if}</a>{if $order->so_id}<a href='/admin/index.php?section=Special_orders&s_order={$order->so_id}'>Спец.заказ №{$order->so_id}</a>{/if}{if $order->packed} - <b>Отправляем</b>{/if}
                    {if $order->receipt_number > 0} - товарный чек № {$order->receipt_number}{/if}
                    <br>
                    {if $order->manager_name}<p style="font-size: 16px;">{$order->manager_name}</p>{/if}
                    <br>
                    {if $order->delivery_company_id == 0 && $packed}<p style="font-size: 18px;color: blue;">Транспортная компания не указана</p><br>{/if}
                    {if $order->invoice_number}<p style="font-size: 16px;">Накладная№ {$order->invoice_number}</p>{/if}
                    <div class="contact">
                      <p class="contact_on">{if ($smarty.now|date_format:"%Y%m%d")==($order->date|date_format:"%Y%m%d")}{$order->date|date_format:"%H:%M"}{elseif ($smarty.now|date_format:"%Y")==($order->date|date_format:"%Y")}{$order->date|date_format:"%m-%d %H:%M"}{else}{$order->date|date_format:"%Y-%m-%d"}{/if}</p>
                      {if $order->last_update != "0000-00-00 00:00:00"}<p class="contact_on">Дата последнего обновления: {$order->last_update|date_format:"%Y-%m-%d"}</p>{/if}
                      {if $order->ga_client_id && ($smarty.session.user->user_id == 16114 || $smarty.session.user->user_id == 135405)}<p class="contact_on">Google Analitycs ClientID: {$order->ga_client_id}</p>{/if}
                      {if $order->user_id}
                        <p class="contact_on">
                          {if !$DeliveryAgent}
                            {if $order->total_purchase_sum > 1500000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $order->total_purchase_sum > 900000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $order->total_purchase_sum > 300000}<img src="./images/star_on.jpg">{/if}<br />
                            <a href='/admin/index.php?section=User&user_id={$order->user_id}' style='color:black;font-size:14px;' target="_blank">{if $order->name}{$order->name}{else}{$order->user_name}{/if}</a> ({if $order->user_status}{$order->user_status}{else}New{/if})
                                  (<a href='index.php?section=Orders&view=search&keyword=user:{$order->user_id}' style='color:green;' target="_blank">все заказы клиента</a>)<br />
                            {if $order->users_p_manager && $order->status == 0}Персональный менеджер: <b>{$order->users_p_manager}</b><br />{/if}
                            {if $order->user_age}Пользователь зарегистрировался {$order->user_age} месяцев назад{/if}
                            {if !$order->user_status || !$order->user_email || !$order->pref_messenger || !$order->pref_delivery_methods || !$order->user_adress || !$order->user_sex || !$order->birth_date || $order->last_login_date=='0000-00-00 00:00:00' || $User->last_api_login_date=='0000-00-00 00:00:00'}
                              <p class="contact_on" style='color:red;'>
                              Заполнить:</br>
                              {if !$order->user_status}Статус, {/if}
                              {if !$order->user_email}Email, {/if}
                              {if !$order->pref_messenger}Мессенджеры, {/if}
                              {if !$order->pref_delivery_methods}Транспортные компании, {/if}
                              {if !$order->user_sex}Пол, {/if}
                              {if !$order->birth_date}День рождения, {/if}
                              {if $order->last_login_date=='0000-00-00 00:00:00'}Не пользуется аккаунтом! {/if}
                              {if $order->last_api_login_date=='0000-00-00 00:00:00'}Не пользуется приложением!{/if}
                              </p>
                            {/if}
                            {if $order->user_comments}
								<p class="contact_on">Комментарии к клиенту</p>
								<div style="max-height: 200px; overflow: auto; width: 100%; padding: 6px 0;">
									{foreach from=$order->user_comments item=comment}
										<p class="contact_on">
											{if (($smarty.now|date_format:"%Y")==($comment->date|date_format:"%Y")) && ($smarty.now|date_format:"%m")-($comment->date|date_format:"%m")<2}{$comment->date|date_format:"%Y-%m-%d %H:%M"}{else}{$comment->date|date_format:"%Y-%m-%d"}{/if}</br>
											<b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}:</b> {$comment->text|escape|nl2br}
										</p>
									{/foreach}
								</div>
                            {/if}
                          {else}
                            {if $order->total_purchase_sum > 1500000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $order->total_purchase_sum > 900000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $order->total_purchase_sum > 300000}<img src="./images/star_on.jpg">{/if}<br />
                            {$order->name|escape} ({if $order->user_status}{$order->user_status}{else}New{/if})<br />
                            {if $order->users_p_manager && $order->status == 0}Персональный менеджер: <b>{$order->users_p_manager}</b><br />{/if}
                            {if $order->user_age}Пользователь зарегистрировался {$order->user_age} месяцев назад{/if}
                          {/if}
                        </p>
                      {else}
                        {if $order->total_purchase_sum > 1500000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $order->total_purchase_sum > 900000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $order->total_purchase_sum > 300000}<img src="./images/star_on.jpg">{/if}<br />
                        {if $order->name}{$order->name|escape}{/if} ({if $order->user_status}{$order->user_status}{else}New{/if})<br />
                        {if $order->users_p_manager && $order->status == 0}Персональный менеджер: <b>{$order->users_p_manager}</b><br />{/if}
                        {if $order->user_age}Пользователь зарегистрировался {$order->user_age} месяцев назад{/if}
                      {/if}
                      {if $order->code && !$DeliveryAgent}
                        <p class="contact_on"><a href="/index.php?module=Order&order_code={$order->code}">Ссылка на оплату</a><i style="margin: 10px; cursor: pointer" class="icon-copy copy_payment_link"></i></p>
                      {/if}
                      {if $order->phone}<p class="contact_on"><b style="font-size:14px;">{$order->phone|escape}</b></p>{/if}
                      {if $order->city || $order->address}<p class="contact_on"><b style="font-size:14px;">{$order->city|escape}</b>{if $order->address} {$order->address|escape}{/if}</p>{/if}{if !$order->city}<p class="contact_on" style='color:red;'><b style="font-size:14px;">Заполнить город!</b></p>{/if}
                      {if $order->city_comments}
                       <p class="contact_on">Комментарии к городу</p>
                       {foreach from=$order->city_comments item=comment}
                        <p class="contact_on">{$comment->date|date_format:"%Y-%m-%d %H:%M"}</br><b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}:</b> {$comment->text|escape|nl2br}</p>
                       {/foreach}
                      {/if}
                      {if $order->email}<p class="contact_on"><a href="mailto:{$order->email|escape}" style='color:black;'>{$order->email|escape}</a></p>{/if}
                      {if $order->delivery_company}<p class="contact_on">TK: {$order->delivery_company|escape}</p>{/if}
                      {if $order->comments}
                       {foreach from=$order->comments item=comment}
                        <p class="contact_on">{if ($smarty.now|date_format:"%Y%m%d")==($comment->date|date_format:"%Y%m%d")}{$comment->date|date_format:"%H:%M"}{elseif ($smarty.now|date_format:"%Y")==($comment->date|date_format:"%Y")}{$comment->date|date_format:"%m-%d %H:%M"}{else}{$comment->date|date_format:"%Y-%m-%d"}{/if}
                        <b>{if $comment->user_id != 0}{$comment->name}{else}Система{/if}:</b> {$comment->text|escape|nl2br}</p>
                       {/foreach}
                      {/if}
                      {if $order->user_comment}<p class="contact_on"><b>Комментарий клиента:</b> {$order->user_comment|escape|nl2br}</p>{/if}
                      {assign var=ds value=$order->delivery_status}
                      <p><b>{$DeliveryStats.$ds}</b></p>
                      {assign var=ms value=$order->money_status}
                      <p><b>{$MoneyStats.$ms}</b></p>
                      {if ($order->status == 6 || $order->status == 2 || $View=='search') && $order->delivery_code}<p class="contact_on">Статус доставки:<br><iframe src="/delivery_status.php?InvoiceNumber={$order->delivery_code}" style="width:500px;height:60px;border:0;"></iframe></p>{/if}
                      {if $order->status == 1 && !$DeliveryAgent}
                        <p class="contact_on"><a class="pack_order" data-order-id='{$order->order_id}' href="#">{if $order->packed}<b>Отправляем</b>{else}Отправляем{/if}</a> / <a class="unpack_order" data-order-id='{$order->order_id}' href="#">{if !$order->packed}<b>Не отправляем</b>{else}Не отправляем{/if}</a></p>
                      {/if}
                    </div>
                  </div>
               
                  <div class="info_right">
                    <div class="info_rl">
                      <table id="table2">
                        {foreach item=product from=$order->products}
                          {if !($DeliveryAgent && in_array($product->status,array(1,3)))}
                            <tr>
								<td class="td1">
									<a href="/products/{$product->url}/" target="_blank"><img src="https://lsboutique.ru/reimg/files/products/85x/{$product->image}"></a>
								</td>
								<td class="td2">
									<a href="/products/{$product->url}/" target="_blank" class="link">{$product->product_name}</a><br>
									<div>{$product->season}:{$product->season_type}</div>
									<div>
										<div class="ShAA_priceDivAdminName">Начальная цена: </div>
										<div class="ShAA_priceDivAdmin" {if $product->offline_price_conv && ($product->offline_price_conv<>$product->offline_price)}style="margin-right:10%;"{/if}>{if $product->offline_price != 0}{$product->offline_price|number_format:0:'':' '} {if $product->offline_price_conv && ($product->offline_price_conv<>$product->offline_price)}({$product->offline_price_conv|number_format:0:'':' '}{$product->currency_sign}){/if}{else}{$product->price|number_format:0:'':' '} {if $product->price_conv}({$product->price_conv|number_format:0:'':' '}{$product->currency_sign}){/if}{/if}</div>
									</div>
									{if $product->offline_price != 0}
										<div>
											<div class="ShAA_priceDivAdminName">Цена со скидкой: </div>
											<div class="ShAA_priceDivAdmin" {if $product->price_conv && ($product->price_conv<>$product->price)}style="margin-right:10%;"{/if}>{$product->price|number_format:0:'':' '} {if $product->price_conv && ($product->price_conv<>$product->price)}({$product->price_conv|number_format:0:'':' '}{$product->currency_sign}){/if}</div>
										</div>
									{/if}
									<div>
										<div class="ShAA_priceDivAdminName">Цена продажи: </div>
										<div class="ShAA_priceDivAdmin" {if $product->sale_price_conv && ($product->sale_price_conv<>$product->sale_price)}style="margin-right: 4%;"{elseif $smarty.session.user->group_id == 2 || ($smarty.session.user->group_id == 5 && in_array($order->status,array(1,0)))}style="margin-right: 23%;"{/if}>
											<span data-order-product-id="{$product->id}" class="product-price">{$product->sale_price|number_format:0:'':' '}</span> {if $product->sale_price_conv && ($product->sale_price_conv<>$product->sale_price)}({$product->sale_price_conv|number_format:0:'':' '}{$product->currency_sign}){/if}
                      {if $smarty.session.user->group_id == 2 || ($smarty.session.user->group_id == 5 && in_array($order->status,array(1,0)))}<span style="font-size: 14px; cursor: pointer; margin: 0" class="edit_price_ico">&#9998;</span>
											<span class="product-price-input" data-order-product-id="{$product->id}" style="display:none;">
											  <input value="{$product->sale_price}" style="width:72px;"><br>
											  <a href="#" class="update-product-price">Применить</a>
											  <a href="#" class="cancel-product-price">Отмена</a>
											  <br>
											</span>
                      {/if}
										</div>
									</div>
									<div>{if $product->sale != 0}Итоговая скидка: {$product->sale}%{/if}</div>
                  {if $product->size}размер: <b>{$product->size}</b>{/if}
                  {if $product->warning}<br/><span style="color:red;">{$product->warning}</span>{/if}
									{if $product->u_sizes == 1}{elseif $product->u_sizes}
									  <br/><span style="color:{if $product->u_sizes|strstr:$product->size}green{else}red{/if};">Размеры пользователя<br/> {$product->u_sizes}</span>
									{else}
									  <br/><span style="color:red;">Заполнить размеры<br/> пользователя!</span>
									{/if}
                  {if $product->measurings}
                    <div style="position:relative;">
                      <a class="measurings">посмотреть замеры</a>
                      <div class="links fatlist measurings_field" style="display:none;top:-170px;left:-10px;width:250px;">
                        <div class="fatlist_title">Мерки<div class="fatlist_close">Закрыть</div></div>
                        <div class="fatlist_col" style='width:290px'>
                          <table class="measurings_form" Style='width:100%'>
                            <tr>
                              <td class="model" style="font-size: 12px;">Размер</td>
                              <td class="m_t"><p>{$product->size}</p></td>
                            </tr>
                            <tr>
                            {if $product->measurings->fitting}
                              <tr>
                                <td class="model" style="font-size: 12px;">Посадка</td>
                                <td class="m_t"><p>{$product->measurings->fitting}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->material_stretch}
                              <tr>
                                <td class="model" style="font-size: 12px;">Материал</td>
                                <td class="m_t"><p>{$product->measurings->material_stretch}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->waist}
                              <tr>
                                <td class="model" style="font-size: 12px;">замер по талии</td>
                                <td class="m_t"><p>{$product->measurings->waist}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->hips}
                              <tr>
                                <td class="model" style="font-size: 12px;">замер по бедрам</td>
                                <td class="m_t"><p>{$product->measurings->hips}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->thigh}
                              <tr>
                                <td class="model" style="font-size: 12px;">замер по ширине ляжки</td>
                                <td class="m_t"><p>{$product->measurings->thigh}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->waist_height}
                              <tr>
                                <td class="model" style="font-size: 12px;">высота посадки</td>
                                <td class="m_t"><p>{$product->measurings->waist_height}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->bottom_width}
                              <tr>
                                <td class="model" style="font-size: 12px;">замер низа брючины</td>
                                <td class="m_t"><p>{$product->measurings->bottom_width}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->knee_width}
                              <tr>
                                <td class="model" style="font-size: 12px;">замер колена (для спорт.)</td>
                                <td class="m_t"><p>{$product->measurings->knee_width}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->leg_lenght}
                              <tr>
                                <td class="model" style="font-size: 12px;">замер длины брючины</td>
                                <td class="m_t"><p>{$product->measurings->leg_lenght}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->shoulders}
                              <tr>
                                <td class="model" style="font-size: 12px;">Замер по плечам</td>
                                <td class="m_t"><p>{$product->measurings->shoulders}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->chest}
                              <tr>
                                <td class="model" style="font-size: 12px;">Замер объема груди</td>
                                <td class="m_t"><p>{$product->measurings->chest}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->lenght_on_back}
                              <tr>
                                <td class="model" style="font-size: 12px;">Длина изделия по спине</td>
                                <td class="m_t"><p>{$product->measurings->lenght_on_back}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->sleeve}
                              <tr>
                                <td class="model" style="font-size: 12px;">Замер длины рукава изделия</td>
                                <td class="m_t"><p>{$product->measurings->sleeve}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->bottom_band}
                              <tr>
                                <td class="model" style="font-size: 12px;">Замер резинки внизу изделия</td>
                                <td class="m_t"><p>{$product->measurings->bottom_band}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->insole_width}
                              <tr>
                                <td class="model" style="font-size: 12px;">Замер ширины стельки</td>
                                <td class="m_t"><p>{$product->measurings->insole_width}</p></td>
                              </tr>
                            {/if}
                            {if $product->measurings->insole_length}
                              <tr>
                                <td class="model" style="font-size: 12px;">Замер длины стельки</td>
                                <td class="m_t"><p>{$product->measurings->insole_length}</p></td>
                              </tr>
                            {/if}
                          </table>
                        </div>
                      </div>
                    </div>
                  {/if}
								</td>
								<td class="td3">
									<div style="text-align: left;">
										{if $product->status}<b>({$product->status}{if $product->status_date != '0000-00-00'}, {$product->status_date}{/if})</b><br>{/if} {if $product->sku}{$product->sku} /{/if} {$product->item_location}
										{if $product->process_status}<br>Статус обработки: {$product->process_status}<br>{/if}
									</div>
									{if $order->status == 1}
										<div>
											<a href="index.php?section=Orders&view=process&duplicate_order_product_id={$product->id}" style="float: left;">Копировать</a>
											<a href="index.php?section=Orders&view=process&delete_order_product_id={$product->id}"  style="float: right;" onclick="return confirm('Вы уверены, что хотите удалить товар?');">Удалить</a>
										</div>
									{/if}
								</td>
                            </tr>
<!--
                            <tr>
                              <td class="td1"><a href="/products/{$product->url}/" target="_blank" class="link">{$product->product_name}</a>
                                {if $product->status}<b>({$product->status}{if $product->status_date != '0000-00-00'}, {$product->status_date}{/if})</b>{/if}<br> {if $product->sku}{$product->sku} /{/if} {$product->item_location}
                                {if $product->process_status}<br>Статус обработки: {$product->process_status}<br>{/if}
                              </td>
                              <td class="td2">
                                {if $order->status == 1}
                                  <span style="float:left;">
                                    <a href="index.php?section=Orders&view=process&duplicate_order_product_id={$product->id}">Копировать</a><br>
                                    <a href="index.php?section=Orders&view=process&delete_order_product_id={$product->id}" onclick="return confirm('Вы уверены, что хотите удалить товар?');">Удалить</a>
                                  </span>

                                  <span data-order-product-id="{$product->id}" class="product-price">{$product->sale_price|number_format:0:'':' '}<br /></span>
                                  <span class="product-price-input" data-order-product-id="{$product->id}" style="display:none;">
                                    <input value="{$product->sale_price}" style="width:72px;"><br>
                                    <a href="#" class="update-product-price">Применить</a>
                                    <a href="#" class="cancel-product-price">Отмена</a>
                                    <br>
                                  </span>
                                {/if}
                                {if $product->warning}<span style="color:red;">{$product->warning}</span>{/if}
                                {if $product->size}размер: <b>{$product->size}</b>{/if}
                                {if $product->u_sizes == 1}{elseif $product->u_sizes}
                                  <br/><span style="color:{if $product->u_sizes|strstr:$product->size}green{else}red{/if};">Размеры пользователя<br/> {$product->u_sizes}</span>
                                {else}
                                  <br/><span style="color:red;">Заполнить размеры<br/> пользователя!</span>
                                {/if}
                              </td>
                            </tr>
-->
                          {/if}
                        {/foreach}
                        <tr>
                            <td class="td3" colspan=3>
							{if !$DeliveryAgent}
								<span class="cur">
									Доставка: {if $order->real_delivery_price != '0.00'}<b>({$order->real_delivery_price|number_format:0:'':' '})</b>{/if}
									{$order->delivery_price|number_format:0:'':' '}</span>
							{else}
								<span class="cur">Доставка {if $order->delivery_agent_price != '0.00'}<b>({$order->delivery_agent_price|number_format:0:'':' '})</b>{else} - не заполнена{/if}</span>
							{/if}
							</td>
                        </tr>

                        {if $order->coupon_code}
                          <tr class="gray" style="font-size: 12px;">
                            <td class="td3" colspan=3>
								<span class="cur2">Купон {$order->coupon_code}</span>
								<span class="pay">{$order->coupon_discount}{if $order->coupon_type == "absolute"} руб.{else}%{/if}</span>
							</td>
                          </tr>
                        {/if}

                        <tr>
                          {if !$DeliveryAgent && $order->delivery_status < 3}
                            <td class="td3" colspan=3>
								<span class="cur2">Сумма: </span><span class="pay">{$order->total_amount|number_format:0:'':' '} {if $order->total_amount_conv}({$order->total_amount_conv|number_format:0:'':' '}{$order->currency_sign}){/if}</span>
							</td>
                          {else}
                            {if !empty($order->money_sum->total)}
                              <td class="td3" colspan=3>
								<span class="cur2">Стоимость принятых клиентом товаров: </span>
								<span class="pay">{$order->money_sum->total|number_format:0:'':' '}</span>
							  </td>
                        </tr><tr>
                            {/if}
                            {if !empty($order->return_sum->total)}
                              <td class="td3" colspan=3>
								<span class="cur2">Стоимость возвращаемых товаров: </span>
								<span class="pay">{$order->return_sum->total|number_format:0:'':' '}</span>
							  </td>
                            {/if}
                          {/if}
                        </tr>

                        {if !$DeliveryAgent && ($order->status==0 || $order->status==1)}
                          <tr>
                            <td class="td3" colspan=3>
								<span class="cur2">Скидка (% от первоначальной цены)</span>
								<input data-initial="1" data-order-id="{$order->order_id}" type="number" class="pay" style="width: 60px; margin: 0 6px;"><a class="apply_discount" href="#">Применить</a>
							</td>
                          </tr>
                          <tr>
                            <td class="td3" colspan=3>
								<span class="cur2">Скидка (% от текущей цены)</span>
								<input data-order-id="{$order->order_id}" type="number" class="pay" style="width: 60px; margin: 0 6px;"><a class="apply_discount" href="#">Применить</a>
							</td>
                          </tr>
                          <tr>
                            <td class="td3" colspan=3>
								<span class="cur2">Переместить товары в другой заказ</span>
								Заказ №
								<select id="{$order->order_id}" data-order-id="{$order->order_id}">
									{foreach item=ord from=$Orders}
									  {if $ord->order_id != $order->order_id}
										<option value="{$ord->order_id}">{$ord->order_id}</option>
									  {/if}
									{/foreach}
								</select>
								<a href="#" class="move_products" data-order-id="{$order->order_id}" style="margin-left:15px;">Переместить</a>
                            </td>
                          </tr>
						  {if $order->user_return_rate > 0}
                          <tr>
							<td class="td3" colspan=3>
								<span class="cur2" {if $order->user_return_rate > 50}style="color:red;">Внимание! {else}>{/if}Процент возвратов клиентом: </span>
								<span class="pay">{$order->user_return_rate|round:"1"}%</span>
							</td>
                          </tr>
						  {/if}
							{if $order->city}
								{if $order->city_accepted < 100000000}
								  <tr>
									<td class="td3" colspan=3>
										<span class="cur2">Сумма принятых заказов для города: </span>
										<span class="pay">{$order->city_accepted|default:"0"|round:"1"|number_format:0:'':' '}</span>
									</td>
								  </tr>
							    {/if}
								{if $order->city_rejected < 100000000}
								  <tr>
									<td class="td3" colspan=3>
										<span class="cur2">Сумма отклоненных заказов для города: </span>
										<span class="pay">{$order->city_rejected|default:"0"|round:"1"|number_format:0:'':' '}</span>
									</td>
								  </tr>
								{/if}
							{/if}
                        {/if}

                      </table>
                    </div>
                  </div>

                  {if !$DeliveryAgent}
                    <div class="desc ShAA_desc">
                      {if ($order->status==0 || $order->status==3 || ($order->status==6 && $allowed_admin)) && $order->can_process && $order->city}
                        {if $cur_hour>9 && $cur_hour<21}<a href="index.php{$order->set_to_process_url}" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch"/>В обработку</a>{/if}
                      {/if}
                      {if !$order->can_process}
                        <span style="color:red;">Процент отказов больше {$smarty.session.user->decline_rate}%</span>
                      {/if}
                      {if !$order->city}
                        <span style="color:red;" class="fl">Заполнить город доставки</span>
                      {/if}
                      {if $order->status==1 && $order->delayed==0}
                        <a href="index.php?section=Order&delayed=1&order_id={$order->order_id}" onclick="return confirm('Вы уверены, что хотите отложить заказ?');" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch"/>Отложить</a>
                      {/if}
                      {if $order->status==1 && $order->delayed==1}
                        <a href="index.php?section=Order&delayed=0&order_id={$order->order_id}" class="fl"><img src="./images/next.jpg" alt="" class="fl_ch"/>Вернуть</a>
                      {/if}
                      {if ($order->status==0 || $order->status==1) && ($order->manager_id == $smarty.session.user->user_id || $allowed_admin)}
                        <a href="index.php{$order->set_to_fail_url}" class="fl cancel_order"><img src="./images/cancel.jpg" alt="" class="fl_ch"/>Отмена заказа</a>
                        <div id="fault_reason_container" {if $Order->status!=3}style="display:none;"{/if}>
                          <div style="float:right;">
                          <span style="color:red;" class="fl">Выберите причину отмены товара</span><br/>
                          <select name=fault_reason class="select2 fault_reason">
                            <option value="" {if !$order->fault_reason}selected{/if}>Выбрать</option>
                            <option value="out_of_stock" {if $Order->fault_reason=='out_of_stock'}selected{/if}>Нужного размера нет в наличии</option>
                            <option value="offline_shop" {if $Order->fault_reason=='offline_shop'}selected{/if}>Самовывоз из магазина</option>
                            <option value="consultation" {if $Order->fault_reason=='consultation'}selected{/if}>Оказана консультация</option>
                            <option value="unreachable" {if $Order->fault_reason=='unreachable'}selected{/if}>Не удалось связаться</option>
                            <option value="duplicate" {if $Order->fault_reason=='duplicate'}selected{/if}>Дубль</option>
                            <option value="other" {if $Order->fault_reason=='other'}selected{/if}>Другое</option>
                          </select>
                          </div>
                        </div>
                      {/if}
                    </div>
                  {/if}
                
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

      {* Статистика *}
      {if $Results}
        <div style="margin-left:50px;">
        <table style="font-size: 14px; font-family: sans-serif;">
          <tbody>


          <tr>
            <td>
            <div class="list_left">{$Results->orders_to_client} р</div>
            </td>
            <td>
            <div class="slide-toggle list_right">Товаров в примерке
            </div>
            <div class="links fatlist" style="display:none;">
            <div class="fatlist_title">Товаров в примерке<div class="fatlist_close">Закрыть</div></div>
              {foreach from=$Results->to_client_list_red item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: red;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value})</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->to_client_list_blue item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: dodgerblue;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value})</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->to_client_list_D_red item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: #BB0000;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value})</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->to_client_list_yellow item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: orange;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value})</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->to_client_list_green item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: green;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value})</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
            </div>
            </td>
          </tr>

          <tr>
            <td>
            <div class="list_left">{$Results->orders_to_ls} р</div>
            </td>
            <td>
            <div class="slide-toggle list_right">В возврате до ЛС
            </div>
            <div class="links fatlist" style="display:none;">
            <div class="fatlist_title">В возврате до ЛС<div class="fatlist_close">Закрыть</div></div>
              {foreach from=$Results->to_ls_list_red item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: red;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->to_ls_list_yellow item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: orange;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->to_ls_list_green item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: green;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
            </div>
            </td>
          </tr>

          <tr>
            <td>
            <div class="list_left">{$Results->money_at_partners} р</div>
            </td>
            <td>
            <div class="slide-toggle list_right">Деньги у партнеров
            </div>
            <div class="links fatlist" style="display:none;">
            <div class="fatlist_title">Деньги у партнеров<div class="fatlist_close">Закрыть</div></div>
              {foreach from=$Results->partners_list_red item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: red;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a>{if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->partners_list_yellow item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: orange;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a> {if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
              {foreach from=$Results->partners_list_green item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: green;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a> {if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}{if $order->agreed_delivery_date && $order->agreed_delivery_date != 0} <span style="color:grey;">Согласованная дата доставки: {$order->agreed_delivery_date}</span>{/if}{if $order->delivery_date && $order->delivery_date != 0} / <span style="color:grey;">{$order->delivery_date}</span>{/if}<br>
              {/foreach}
            </div>
            </td>
          </tr>

          <tr>
            <td>
            <div class="list_left">{$Results->money_at_agent} р</div>
            </td>
            <td>
            <div class="slide-toggle list_right">Деньги у ТК
            </div>
            <div class="links fatlist" style="display:none;">
            <div class="fatlist_title">Деньги у ТК<div class="fatlist_close">Закрыть</div></div>
              {foreach from=$Results->agent_list_red item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: red;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a> {if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}<br>
              {/foreach}
              {foreach from=$Results->agent_list_yellow item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: orange;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a> {if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}<br>
              {/foreach}
              {foreach from=$Results->agent_list_green item=order}
              {assign var="ord_id" value=$order->order_id}
              <a href="/admin/index.php?section=Orders&delivery=search&delivery_keyword=order:{$order->order_id}" style="color: green;" target="_blank">№{$ord_id}({$Results->orderlist.$ord_id.value}руб)</a> {if $order->manager_name} <span style="color:black;">{$order->manager_name}</span>{/if}{if $order->invoice_number} <span style="color:grey;">Накладная№{$order->invoice_number}</span>{/if}: {$Results->orderlist.$ord_id.skus}<br>
              {/foreach}
            </div>
            </td>
          </tr>

          </tbody>
        </table>
        </div>
        {literal}
        <script>
            $(document).on("click touchstart", ".slide-toggle", function() {
                var linksh = $(this).parent().children('.links').height()+140
                if ($('#cont').height() < linksh){
                    $('#cont').height(linksh);
                }
                else{}
                $(this).parent().children('.links').slideDown();
            });
        </script>
        {/literal}
      {/if}

      {$PagesNavigation}
      <div class="clear">&nbsp;</div>
      <!-- Right side #End/-->
      </div>

    </div>


  </div>
  </div>
</div>
<!-- Content #End /-->
{literal}
  <script>
    $(document).on("click", "a.apply_discount", function(e) {
      e.preventDefault();
      var input_box = $(this).prev();
      var loc = "/admin/index.php?section=Orders&view=process&apply_discount="+input_box.val()+"&discount_order="+input_box.data('order-id');
      if (input_box.data('initial') === 1) {
        loc = loc + "initial=1";
      }
      window.location = loc;
    });

    $(document).on("click", "a.move_products", function(e) {
      e.preventDefault();
      var order_id = $(this).data('order-id');
      var destination_order_id = $("select#"+order_id).val();
      var r = confirm("Перенести товары из заказа №"+order_id+" в заказ №"+destination_order_id);
      if (r == true) {
        window.location = "/admin/index.php?section=Orders&view=process&move_products_order="+order_id+"&destination_order_id="+destination_order_id;
      }
    });
    $('.edit_price_ico').click(function(){
      $(this).siblings("span.product-price-input").show();
      $(this).parent().find('.product-price').hide();
      $(this).hide();
    });
    $(document).on("dblclick", "span.product-price", function(e) {
      $(this).siblings("span.product-price-input").show();
      $(this).hide();
      $(this).parent().find('.edit_price_ico').hide();
    });

    $(document).on("click", "a.update-product-price", function(e) {
      e.preventDefault();
      var op_id = $(this).parent().data("order-product-id");
      var price = $(this).siblings("input").val();
      window.location = "/admin/index.php?section=Orders&view=process&change_price_product="+op_id+"&price="+price;
      $(this).parent().parent().find('.edit_price_ico').show();
    });

    $(document).on("click", "a.cancel-product-price", function(e) {
      e.preventDefault();
      $(this).parent().siblings("span.product-price").show();
      $(this).parent().hide();
      $(this).parent().parent().find('.edit_price_ico').show();
    });
    $(document).on("click", "a.pack_order", function(e) {
      e.preventDefault();
      var order = $(this).data('order-id');
      var link = $(this);
      console.log(order);
      $.get("/admin/index.php?section=Orders&pack_order="+order, function(r) {
        if(r=='ok'){
          link.closest('.info').prev('img').remove();
          link.closest('.info').remove();
        }
      });
    });
    $(document).on("click", "a.unpack_order", function(e) {
      e.preventDefault();
      var order = $(this).data('order-id');
      var link = $(this);
      console.log(order);
      $.get("/admin/index.php?section=Orders&unpack_order="+order, function(r) {
        if(r=='ok'){
          link.closest('.info').prev().remove();
          link.closest('.info').remove();
        }
      });
    });
    $('.copy_payment_link').click(function(){
      var copy_text = 'https://lsboutique.ru' + $(this).parent().find('a').attr('href');
      alert(copy_text);
      let tmp   = document.createElement('INPUT');
      focus = document.activeElement;
      tmp.value = copy_text;
      document.body.appendChild(tmp);
      tmp.select();
      document.execCommand('copy');
      document.body.removeChild(tmp);
      focus.focus();
    });
    $(document).on("click touchstart", ".measurings", function(e) {
        e.preventDefault();
        $(this).next().slideToggle();
    });
    $(document).on("click touchstart", ".fatlist_close", function() {
        $(this).parents('.links:first').slideUp(); $('#cont').attr('style', '');
    });
    $(document).on("click", ".cancel_order", function(e) {
      var faultReason = $(this).next().find(".fault_reason").val();
      if (faultReason == '') {
        $(this).next('#fault_reason_container').show();
        return false;
      }
      else{
        var link = $(this).attr('href') + '&fault_reason=' + faultReason;
        $(this).attr('href',link);
        return confirm('Вы уверены, что хотите отменить заказ?');
      }
    });
  </script>
{/literal}
