<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='analytics_menu.tpl' active='cash'}
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Лакшери стор</a> → Аналитика продаж
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
        <img src="./images/icon_secure.jpg" alt="" class="line"/>
        <!-- /Иконка раздела /-->

        <!-- Заголовок раздела /-->
        <h1 id="headline">Отчет по кассовым операциям</h1>
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
          {if $Message}
          <!-- Error #Begin /-->
          <div id="message_minh">
            <div id="message">
              <img src="./images/info.png" alt=""/><p>{$Message}</p>
            </div>
          </div>
          <!-- Error #End /-->
          {/if}




<form method=get>
<div class="clear">&nbsp;</div>
<div class=filter style="width:880px;" action="/admin/index.php">
      <input name="section" type=hidden  value="Analytics">
      <input name="cash_report" type=hidden  value="true">
      <input name="group_by" type=hidden  value="{$group_by_old}">
      Дата от: <input name="date_from" id="date_from" type=text  value='{$date_from|escape}'>
      до: <input name="date_to" id="date_to" type=text           value='{$date_to|escape}'>
      <br>Магазин: <select name="shop">
        <option value="0">Все магазины</option>
        {foreach item=shop from=$shops}
            <option value="{$shop->shop_id}" {if $smarty.get.shop == $shop->shop_id }selected{/if}>{$shop->name}</option>
        {/foreach}
      </select>
      <input type='submit' value='Отфильтровать'>
</div>
<div class="clear">&nbsp;</div>
</form>
<div style="width:450px; font-size: 16px;">
{if $price_sum > 0}
    <div style="width: 100%; float: left; margin: 3px 0;">
        <div style="float:left;">Оборот:</div>
        <div style="float: right;">{$price_sum|number_format:0:",":" "}</div>
    </div>
    {if $uncommitted > 0}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;font-weight: 800;">Не расписанная стоимость:</div>
            <div style="float: right;color: red;">{$uncommitted|number_format:0:",":" "}</div>
        </div>
    {/if}
{/if}
    <div style="clear: both;"></div>
{if $total_total}
    <div style="padding: 40px 0 20px 0; width: 100%; float: left;">
        <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
            <div style="float:left;font-weight: 800;">Итого в кассе:</div>
            <div style="float: right;font-weight: 800;">{$total_total|number_format:0:",":" "}</div>
        </div>
        <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
            <div style="float:left;font-weight: 800;">Деньги с продаж:</div>
            <div style="float: right;font-weight: 800;">{$pure_money|number_format:0:",":" "}</div>
        </div>
        {foreach from=$total_payments item=tp}
            <div style="width: 100%; float: left; margin: 3px 0;">
                {if $tp->sum < 0}
                <a href="/index.php?module=OfflineSales&returns_date_from={$date_from|escape}&returns_date_to={$date_to|escape}"><div style="margin-left: 20px; float:left;">{$tp->name}:</div></a>
                {else}
                <div style="margin-left: 20px; float:left;">{$tp->name}:</div>
                {/if}
                <div style="float: right;{if $tp->name == 'Долг'}color: gray;{/if}">{$tp->sum|number_format:0:",":" "}</div>
            </div>
        {/foreach}
        {if $debt_payment}
          <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; border-top: 1px solid #ccc; padding-bottom: 3px;">
            <div style="float:left;font-weight: 800;">Выплаты долгов:</div>
            <div style="float: right;font-weight: 800;">{$debt_payment|number_format:0:",":" "}</div>
          </div>
          {foreach from=$debt_payment_methods item=pm}
              <div style="width: 100%; float: left; margin: 3px 0;">
                  <div style="margin-left: 20px; float:left;">{$pm->name}:</div>
                  <div style="float: right;">{$pm->sum|number_format:0:",":" "}</div>
              </div>
          {/foreach}
        {/if}
    </div>
{/if}
    {foreach item=item from=$cash}
        <div style="padding: 20px 0 40px 0; width: 100%; float: left;">
            <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
                <div style="float:left;font-weight: 800;"><a href="/index.php?module=OfflineSales&cashbox_id={$item->id}">{$item->name}</a> - {$item->shop_name}</div>
                <div style="float: right;font-weight: 800;">{$item->itogo|number_format:0:",":" "}</div>
            </div>
            <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
                <div style="float:left;font-weight: 800;">Деньги в кассе:</div>
                <div style="float: right;font-weight: 800;">{$item->pure_money|number_format:0:",":" "}</div>
            </div>
            {if $item->uncommitted > 0}
                <div style="width: 100%; float: left; margin: 3px 0;">
                    <div style="margin-left: 20px; float:left;">{if $item->id == 15}<a target="_blank" href="/index.php?module=OfflineSales&debts=1&cashbox={$item->id}">{/if}Не расписано{if $item->id == 15}</a>{/if}:</div>
                    <div style="float: right; color: red;">{$item->uncommitted|number_format:0:",":" "}</div>
                </div>
            {/if}
            {if $item->id != 15 && $item->id != 13}
              {foreach from=$item->uncommitted_orders item=order}
                  <div style="width: 100%; float: left; margin: 3px 0;">
                      <div style="margin-left: 20px; float:left;"><a href="/index.php?module=OfflineSale&order_id={$order->order_id}" target="_blank">Заказ №{$order->order_id}</a></div>
                      <div style="float: right; color: red;">Не расписано {$order->unc_sum|number_format:0:",":" "}</div>
                  </div>
              {/foreach}
            {/if}
            {if ($item->id == 15 || $item->id == 13) && $item->c_boxes}
            <div style="width: 100%; float: left; margin: 3px 0;">
              По кассам:
              {foreach from=$item->c_boxes item=c}
                  <div style="width: 100%; float: left; margin: 3px 0;">
                    <div style="margin-left: 20px; float:left;">{if $c->shop_name}{$c->shop_name}, {/if}{$c->name}:</div>
                    <div style="float: right;{if $pm->name == 'Долг'}color: gray;{/if}">{$c->total|number_format:0:",":" "}</div>
                  </div>
              {/foreach}
            </div>
            {/if}
            <div style="width: 100%; float: left; margin: 3px 0;">
              {if $item->c_boxes}По методу:{/if}
              {foreach from=$item->payment_methods item=pm}
                <div style="width: 100%; float: left; margin: 3px 0;">
                    {if $pm->name == 'Долг' && $item->id == 15}<a target="_blank" href="/index.php?module=OfflineSales&debts=1&cashbox={$item->id}">{/if}<div style="margin-left: 20px; float:left;">{$pm->name}:</div>{if $pm->name == 'Долг' && $item->id == 15}</a>{/if}
                    <div style="float: right;{if $pm->name == 'Долг'}color: gray;{/if}">{$pm->sum|number_format:0:",":" "}</div>
                </div>
              {/foreach}
            </div>
            {if $item->debt_payment_methods}
              <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
                <div style="float:left;font-weight: 800;">Выплаты долгов:</div>
                <div style="float: right;font-weight: 800;">{$item->debt_sum|number_format:0:",":" "}</div>
              </div>
              {foreach from=$item->debt_payment_methods item=pm}
                  <div style="width: 100%; float: left; margin: 3px 0;">
                      <div style="margin-left: 20px; float:left;">{$pm->name}:</div>
                      <div style="float: right;">{$pm->sum|number_format:0:",":" "}</div>
                  </div>
              {/foreach}
            {/if}
        </div>
    {/foreach}
    {if $expenses}
      <h3><a href="/index.php?module=OfflineSales&expenses_list=1&date_start={$date_from|escape}&date_end={$date_to|escape}&no_json=1" target="_blank">Расходы</a></h3>
      <div style="padding: 20px 0 40px 0; width: 100%; float: left;">
        {foreach from=$expenses item=e}
          <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
              <div style="float:left;font-weight: 800;">{$e->shop_name}</div>
              <div style="float: right;font-weight: 800;"><a href="/index.php?module=OfflineSales&expenses_list=1&date_start={$date_from|escape}&date_end={$date_to|escape}&shop_id={$e->shop_id}" target="_blank">{$e->sum|number_format:0:",":" "}</a></div>
          </div>
        {/foreach}
      </div>
    {/if}
    {if $inkass_total}
      <h3>Инкассация<div style="float: right;">{$inkass_total|number_format:0:",":" "}</div></h3>
      <div style="padding: 20px 0 40px 0; width: 100%; float: left;">
        {foreach from=$inkass item=i}
          <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
              <div style="float:left;font-weight: 800;">{$i->shop_name}</div>
              <div style="float: right;font-weight: 800;"><a href="/index.php?module=OfflineSales&inkass_list=1&date_start={$date_from|escape}&date_end={$date_to|escape}&shop_id={$i->shop_id}" target="_blank">{$i->sum|number_format:0:",":" "}</a></div>
          </div>
        {/foreach}
        {if $im_fee->confirmed}
          <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
              <div style="float:left;font-weight: 800;">Агентское вознаграждение ИМ</div>
              <div style="float: right;font-weight: 800;">{$im_fee->confirmed|number_format:0:",":" "}</div>
          </div>
        {/if}
        {if $im_fee->ai_confirmed}
          <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
              <div style="float:left;font-weight: 800;">Платежи ИМ карта Сбербанк (А.И.)</div>
              <div style="float: right;font-weight: 800;">{$im_fee->ai_confirmed|number_format:0:",":" "}</div>
          </div>
        {/if}
        {if $im_fee->is_confirmed}
          <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
              <div style="float:left;font-weight: 800;">Платежи ИМ карта Сбербанк (И.Ш.)</div>
              <div style="float: right;font-weight: 800;">{$im_fee->is_confirmed|number_format:0:",":" "}</div>
          </div>
        {/if}
        {if $im_fee->im_confirmed}
          <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
              <div style="float:left;font-weight: 800;">Инкассация ИМ</div>
              <div style="float: right;font-weight: 800;">{$im_fee->im_confirmed|number_format:0:",":" "}</div>
          </div>
        {/if}
      </div>
    {/if}
    {if $im_fee->unconfirmed}
      <h4 style="width: 100%; float: left; color:red; border-bottom: 1px solid #ccc; padding-bottom: 3px;">Неподтвежденные вознаграждения ИМ<div style="float: right;">{$im_fee->unconfirmed|number_format:0:",":" "}</div></h4>
    {/if}
    {if $im_fee->ai_unconfirmed}
      <h4 style="width: 100%; float: left; color:red; border-bottom: 1px solid #ccc; padding-bottom: 3px;">Неподтвежденные платежи ИМ карта (А.И.)<div style="float: right;">{$im_fee->ai_unconfirmed|number_format:0:",":" "}</div></h4>
    {/if}
    {if $im_fee->is_unconfirmed}
      <h4 style="width: 100%; float: left; color:red; border-bottom: 1px solid #ccc; padding-bottom: 3px;">Неподтвежденные платежи ИМ карта (И.Ш.)<div style="float: right;">{$im_fee->is_unconfirmed|number_format:0:",":" "}</div></h4>
    {/if}
    {if $im_fee->im_unconfirmed}
      <h4 style="width: 100%; float: left; color:red; border-bottom: 1px solid #ccc; padding-bottom: 3px;">Неподтвежденные инкассации ИМ<div style="float: right;">{$im_fee->im_unconfirmed|number_format:0:",":" "}</div></h4>
    {/if}
    <div style="padding: 20px 0 40px 0; width: 100%; float: left;">
        <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
            <div style="float:left;font-weight: 800;">Интернет-магазин</div>
            <!--<div style="float: right;font-weight: 800;">{$online_total_income|number_format:0:",":" "}</div>-->
        </div>
        <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
            <div style="float:left;font-weight: 800;">Онлайн-платежи:</div>
            <div style="float: right;font-weight: 800;">{$online_rfi_income|number_format:0:",":" "}</div>
        </div>
        <div style="width: 100%; float: left; border-bottom: 1px solid #ccc; padding-bottom: 3px;">
            <div style="float:left;font-weight: 800;">Сумма принятых товаров:</div>
            <div style="float: right;font-weight: 800;">{$online_tk_income|number_format:0:",":" "}</div>
        </div>
    </div>
</div></div></div></div>
