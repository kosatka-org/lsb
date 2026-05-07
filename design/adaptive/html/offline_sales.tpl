<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.6/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script src="/js/are_you_ie.js"></script>

<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.1">

{literal}
  <style type="text/css">
  body {
    background: none;
    height: initial;
    margin-top: 60px;
  }
  label {
    vertical-align: middle;
  }
  #page {
    width: 100%;
  }
  .mt-6 {
    margin-top: -6px;
  }
  .mt10 {
    margin-top: 10px;
  }
  .mt20 {
    margin-top: 20px;
  }
  .ml6 {
    margin-left: 6px;
  }
  #headBlock, #headBlock-hidden, .footer {
    display: none;
  }
  a:hover {
    border-bottom: none;
  }
  </style>
{/literal}
<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <!-- Вкладки /-->
{if $smarty.session.user->group_id == 9 || $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 13}
        <div class="ShAA_kassirInset ShAA_mobileInvisible">
                <span>Покупки</span>
                {if $smarty.session.user->group_id == 9 || $smarty.session.user->group_id == 2}
                  <span>&nbsp;/&nbsp;</span>
                  <span><a href="index.php?module=OfflineSales&movement=1">Перемещения</a></span>
                {/if}
                <span>&nbsp;/&nbsp;</span>
                <span><a href="index.php?module=OfflineSales&debts=1">Задолженности</a></span>
                {if $smarty.session.user->group_id == 9 || $smarty.session.user->group_id == 2}
                  <span>&nbsp;/&nbsp;</span>
                  <span><a href="index.php?module=OfflineSales&returns=1">Возвраты</a></span>
                {/if}
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&calls=1">Клиенты</a></span>
        </div>
{/if}
        <!-- /Вкладки /-->
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20 ShAA_mobileInvisible"><a href="https://www.youtube.com/embed/iT6G2z1HAb0" target="_blank">Видео инструкция</a></div>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20 ShAA_mobileInvisible"><a href='/index.php?module=OfflineSales&sale_brands=1' target="_blank">Таблица скидок</a></div>
    </div>
  </div>
{if $smarty.session.user->group_id != 12}
  <div class="row">
    <h3 class="ShAA_mobileInvisible">Новая покупка - выберите кассу</h3>
    {foreach from=$cashboxes_select item=cbox}
      <a class="btn btn-primary btn-lg" style="margin:5px 0;{if $cbox->name == 'Индивидуальный пошив' || $cbox->name == 'Услуги' || $cbox->name == 'Интернет-магазин' || $cbox->id == 21}display:none;{/if}" href="/index.php?module=OfflineSale&cashbox_id={$cbox->id}" target="_blank">{$cbox->name}</a>
    {/foreach}
    <a class="btn btn-warning btn-lg" style="margin:5px 0;" href="/index.php?module=OfflineSales&expenses_list=1" target="_blank">Расходы</a>
    <a class="btn btn-warning btn-lg" style="margin:5px 0;" href="/index.php?module=OfflineSales&inkass_list=1" target="_blank">Инкассация</a>
  </div>
{/if}
  <div class="row mt20">
    <div class="col-md-4 ShAA_searchBlockOffline" id="right-column">
    <label>Поиск покупки</label>
      <div class="input-group">
        <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
        <input id="order-input" type="text" class="form-control" placeholder="Введите номер покупки" autofocus>
      </div>
    </div>
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      {if $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 6}
        <div class="input-group">
          <form class="form-inline">
            <div class="form-group ShAA_fromService" style="overflow:hidden;">
              <label for="date_start" style="float:left;margin:6px 5px 0 0;">От </label>
              <input type="text" name="date_start" class="form-control ShAA_inputDate" id="date_start" value="{$date_start}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
            </div>
            <div class="form-group ShAA_toService" style="overflow:hidden;">
              <label for="date_end" style="float:left;margin:6px 5px 0 0;">До </label>
              <input type="text" name="date_end" class="form-control ShAA_inputDate" id="date_end" value="{$date_end}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
            </div>
            <a class="btn btn-primary" id="date_search" href="#" role="button" style="padding: 6px 12px;margin:1px 0 0;">Поиск</a>
          </form>
        </div>
      {/if}
      <h3>Список покупок{if $date_start && $smarty.session.user->group_id != 2 && $smarty.session.user->group_id != 6} за {$date_start}{if $date_end && $date_start != $date_end} - {$date_end}{/if}{/if}</h3>
      <div id="order-list">
        {foreach from=$orders item=order}
          <div class="panel panel-default" id="order_{$order->order_id}" {if $order->cashbox_name == 'Индивидуальный пошив'} style="display:none;" {/if}>
            <div class="panel-heading">
             Покупка №<b> {$order->receipt_number}</b> ({$order->cashbox_name})&nbsp;&nbsp;-&nbsp;&nbsp;{$order->date|date_format:"%Y/%m/%d, %H:%M"} {if $smarty.session.user->group_id != 12 && $order->editable == true}(<a href="/index.php?module=OfflineSale&order_id={$order->order_id}" target="_blank">Изменить</a>{if $order->cashbox_name != 'Услуги'} {if $order->cancellable == true}/ <a href="#" onclick="delete_order({$order->order_id});">Отменить</a>{/if}{/if}){/if}
             {if $order->cashbox_name == 'Услуги'}
                <a href="/index.php?module=OfflineSale&act={$order->order_id}" target="_blank" style="float: right;">/ акт</a>
             {/if}
             {if $smarty.session.user->group_id != 12}
                <a href="/index.php?module=OfflineSale&receipt_for={$order->order_id}" target="_blank" style="float: right;">чек&nbsp;</a>
             {/if}
            </div>
            {if $smarty.session.user->group_id != 12}
                {if $order->user}
                    <div class="panel-heading">
                        <b>{$order->user->name}</br> {$order->user->phone_number}</b> </br>{if $order->user->personal_discount} бонус от <b>{$order->user->personal_discount}%{/if}</b>
                    </div>
                {/if}
            {/if}
            <div class="panel-body">
              {foreach from=$order->products item=product}
                <div class="row ShAA_salesItemOff">
                  {if $product->image}<div class="col-md-2 mt10"><img src="/reimg/files/products/60x/{$product->image}" alt="{$product->product_name}" /></div>{/if}
                  <div class="col-md-3 mt10"><b>{$product->product_name}</b></div>
                  <div class="col-md-2 mt10">{$product->sku}</div>
                  <div class="col-md-2 mt10">{$product->color}</div>
                  <div class="{if $product->image}col-md-1{else}col-md-2{/if} mt10">{$product->size}</div>
                  <div class="{if $product->image}col-md-2{else}col-md-3{/if} mt10" style="text-align: right;">{$product->price|number_format:0:",":" "}₽</div>
                </div>
              {/foreach}
              {if $smarty.session.user->group_id != 12}
                  <div class="row">
                    <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Всего: <b>{$order->total_sum|number_format:0:",":" "}</b>₽</div>
                    {foreach from=$order->payments item=payment}
                      {if $order->total_debt_paid >= $order->total_debt || $payment->payment_id != 4}<div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">{$payment->name}: <b>{$payment->money_paid|number_format:0:",":" "}</b>₽</div>{/if}
                    {/foreach}
                    {if $order->total_unpaid > 0}
                      <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Не расписано: <span style="color: red;">{$order->total_unpaid|number_format:0:",":" "}₽</span></div>
                    {/if}
                    {if $order->total_debt_paid < $order->total_debt}
                      <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Долг: <span style="color: red;">{$order->total_debt|number_format:0:",":" "}₽</span></div>
                      <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Выплачено: <span style="color: {if $order->total_debt_paid == $order->total_debt}green{else}red{/if};">{$order->total_debt_paid|number_format:0:",":" "}₽</span></div>
                      <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;"><a href="/index.php?module=OfflineSales&debt={$order->debt_id}" target="_blank" title="Добавить оплату">Добавить оплату</a></div>
                    {/if}
                  </div>
              {/if}
            </div>
          </div>
        {/foreach}
      </div>
      <div id="found-orders">
      </div>
    </div>
{if $smarty.session.user->group_id != 12}
    <div class="col-md-4" id="right-column">
      <div id="default_report">
        <h3>Отчет за {$smarty.now|date_format:"%d.%m"}</h3>
        <div>
          <div class="row">
            <div class="col-md-6"><b><nobr>Общая стоимость товаров</nobr></b>:</div>
            <div class="col-md-6" style="text-align: right;">{$price_sum|number_format:0:",":" "}</div>
          </div>
          {if $uncommitted > 0}
          <div class="row">
            <div class="col-md-6"><b>Не расписанная стоимость</b>:</div>
            <div class="col-md-6" style="text-align: right;color: red;">{$uncommitted|number_format:0:",":" "}</div>
          </div>
          {/if}
          <div class="row">
            <div class="col-md-6"><b>Всего товаров</b>:</div>
            <div class="col-md-6" style="text-align: right;">{$products_count}</div>
          </div>
          <div class="row">
            <div class="col-md-6"><b>Долгов вернули</b>:</div>
            <div class="col-md-6" style="text-align: right;">{$total_total_return|number_format:0:",":" "}</div>
          </div>
          {foreach from=$total_debt_returns item=tp}
            <div class="row">
              <div class="col-md-6"><span style="margin-left: 10px;">{$tp->name}</span>:</div>
              <div class="col-md-6" style="text-align: right;">{$tp->sum|number_format:0:",":" "}</div>
            </div>
          {/foreach}
          <div class="row">
            <div class="col-md-6"><b>Итого</b>:</div>
            <div class="col-md-6" style="text-align: right;">{$total_total|number_format:0:",":" "}</div>
          </div>
          {foreach from=$total_payments item=tp}
            <div class="row">
              <div class="col-md-6"><span style="margin-left: 10px;">{$tp->name}</span>:</div>
              <div class="col-md-6" style="text-align: right;">{$tp->sum|number_format:0:",":" "}</div>
            </div>
          {/foreach}
          {foreach from=$cashboxes item=cbox}
            <div class="row mt10">
              <div class="col-md-6"><b>{$cbox->name}</b>:</div>
              <div class="col-md-6" style="text-align: right;">{$cbox->total|number_format:0:",":" "}</div>
            </div>
            {foreach from=$cbox->payment_methods item=pm}
              <div class="row">
                <div class="col-md-6"><span style="margin-left: 10px;">{$pm->name}</span>:</div>
                <div class="col-md-6" style="text-align: right;">{$pm->sum|number_format:0:",":" "}</div>
              </div>
            {/foreach}
          {/foreach}
          <br>
          {if $expenses}
            <h4>Расходы</h4>
            {foreach from=$expenses item=e}
              <div class="row">
                <div class="col-md-6"><span style="color: red; margin-left: 10px;">{$e->shop_name}</span>:</div>
                <div class="col-md-6" style="color: red; text-align: right;">{$e->sum|number_format:0:",":" "}</div>
              </div>
            {/foreach}
          {/if}
          {if $inkass_total}
            <h4>Инкассация<div style="float: right;">{$inkass_total|number_format:0:",":" "}</div></h4>
            {foreach from=$inkass item=i}
              <div class="row">
                <div class="col-md-6"><span style="color: red; margin-left: 10px;">{$i->shop_name}</span>:</div>
                <div class="col-md-6" style="color: red; text-align: right;">{$i->sum|number_format:0:",":" "}</div>
              </div>
            {/foreach}
            {if $im_fee->confirmed}
              <div class="row">
                <div class="col-md-6"><span style="color: red; margin-left: 10px;">Агентское вознаграждение ИМ</span>:</div>
                <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->confirmed|number_format:0:",":" "}</div>
              </div>
            {/if}
            {if $im_fee->ai_confirmed}
              <div class="row">
                <div class="col-md-6"><span style="color: red; margin-left: 10px;">Платежи ИМ карта Сбербанк (А.И.)</span>:</div>
                <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->ai_confirmed|number_format:0:",":" "}</div>
              </div>
            {/if}
            {if $im_fee->is_confirmed}
              <div class="row">
                <div class="col-md-6"><span style="color: red; margin-left: 10px;">Платежи ИМ карта Сбербанк (И.Ш.)</span>:</div>
                <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->is_confirmed|number_format:0:",":" "}</div>
              </div>
            {/if}
            {if $im_fee->im_confirmed}
              <div class="row">
                <div class="col-md-6"><span style="color: red; margin-left: 10px;">Инкассация ИМ</span>:</div>
                <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->im_confirmed|number_format:0:",":" "}</div>
              </div>
            {/if}
          {/if}
          {if $im_fee->unconfirmed}
            <div class="row">
              <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные вознаграждения ИМ</nobr></span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->unconfirmed|number_format:0:",":" "}</div>
            </div>
          {/if}
          {if $im_fee->ai_unconfirmed}
            <div class="row">
              <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные платежи ИМ карта (А.И.)</nobr></span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->ai_unconfirmed|number_format:0:",":" "}</div>
            </div>
          {/if}
          {if $im_fee->is_unconfirmed}
            <div class="row">
              <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные платежи ИМ карта (И.Ш.)</nobr></span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->is_unconfirmed|number_format:0:",":" "}</div>
            </div>
          {/if}
          {if $im_fee->im_unconfirmed}
            <div class="row">
              <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные инкассации ИМ</nobr></span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{$im_fee->im_unconfirmed|number_format:0:",":" "}</div>
            </div>
          {/if}
        </div>
      </div>
      <div id="filter_report">
      </div>
    </div>
{/if}
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="report-template" type="text/x-handlebars-template">
      <h3>Отчет за {{results.dates}}</h3>
      <div>
        <div class="row">
          <div class="col-md-6"><b><nobr>Общая стоимость товаров</nobr></b>:</div>
          <div class="col-md-6" style="text-align: right;">{{formatMoney results.price_sum}}</div>
        </div>
        {{#if results.uncommitted}}
        <div class="row">
          <div class="col-md-6"><b>Не расписанная стоимость</b>:</div>
          <div class="col-md-6" style="text-align: right;color: red;">{{formatMoney results.uncommitted}}</div>
        </div>
        {{/if}}
        <div class="row">
          <div class="col-md-6"><b>Всего товаров</b>:</div>
          <div class="col-md-6" style="text-align: right;">{{results.products_count}}</div>
        </div>
        <div class="row">
          <div class="col-md-6"><b>Долгов вернули</b>:</div>
          <div class="col-md-6" style="text-align: right;">{{formatMoney results.total_total_return}}</div>
        </div>
        {{#each results.total_debt_returns}}
          <div class="row">
            <div class="col-md-6"><span style="margin-left: 10px;">{{this.name}}</span>:</div>
            <div class="col-md-6" style="text-align: right;">{{formatMoney this.sum}}</div>
          </div>
        {{/each}}
        <div class="row">
          <div class="col-md-6"><b>Итого</b>:</div>
          <div class="col-md-6" style="text-align: right;">{{formatMoney results.total_total}}</div>
        </div>
        {{#each results.total_payments}}
          <div class="row">
            <div class="col-md-6"><span style="margin-left: 10px;">{{this.name}}</span>:</div>
            <div class="col-md-6" style="text-align: right;">{{formatMoney this.sum}}</div>
          </div>
        {{/each}}
        {{#each results.cashboxes}}
          <div class="row mt10">
            <div class="col-md-6"><b>{{this.name}}</b>:</div>
            <div class="col-md-6" style="text-align: right;">{{formatMoney this.total}}</div>
          </div>
          {{#each this.payment_methods}}
            <div class="row">
              <div class="col-md-6"><span style="margin-left: 10px;">{{this.name}}</span>:</div>
              <div class="col-md-6" style="text-align: right;">{{formatMoney this.sum}}</div>
            </div>
          {{/each}}
        {{/each}}
        <br>
        {{#if results.expenses}}
          <h4>Расходы</h4>
          {{#each results.expenses}}
            <div class="row">
              <div class="col-md-6"><span style="color: red; margin-left: 10px;">{{this.shop_name}}</span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney this.sum}}</div>
            </div>
          {{/each}}
        {{/if}}
        {{#if results.inkass_total}}
          <h4>Инкассация<div style="float: right;">{{formatMoney results.inkass_total}}</div></h4>
          {{#each results.inkass}}
            <div class="row">
              <div class="col-md-6"><span style="color: red; margin-left: 10px;">{{this.shop_name}}</span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney this.sum}}</div>
            </div>
          {{/each}}
          {{#if results.im_fee.confirmed}}
            <div class="row">
              <div class="col-md-6"><span style="color: red; margin-left: 10px;">Агентское вознаграждение ИМ</span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.confirmed}}</div>
            </div>
          {{/if}}
          {{#if results.im_fee.ai_confirmed}}
            <div class="row">
              <div class="col-md-6"><span style="color: red; margin-left: 10px;">Платежи ИМ карта Сбербанк (А.И.)</span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.ai_confirmed}}</div>
            </div>
          {{/if}}
          {{#if results.im_fee.is_confirmed}}
            <div class="row">
              <div class="col-md-6"><span style="color: red; margin-left: 10px;">Платежи ИМ карта Сбербанк (И.Ш.)</span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.is_confirmed}}</div>
            </div>
          {{/if}}
          {{#if results.im_fee.im_confirmed}}
            <div class="row">
              <div class="col-md-6"><span style="color: red; margin-left: 10px;">Инкассация ИМ</span>:</div>
              <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.im_confirmed}}</div>
            </div>
          {{/if}}
        {{/if}}
        {{#if results.im_fee.unconfirmed}}
          <div class="row">
            <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные вознаграждения ИМ</nobr></span>:</div>
            <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.unconfirmed}}</div>
          </div>
        {{/if}}
        {{#if results.im_fee.ai_unconfirmed}}
          <div class="row">
            <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные платежи ИМ карта (А.И.)</nobr></span>:</div>
            <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.ai_unconfirmed}}</div>
          </div>
        {{/if}}
        {{#if results.im_fee.is_unconfirmed}}
          <div class="row">
            <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные платежи ИМ карта (И.Ш.)</nobr></span>:</div>
            <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.is_unconfirmed}}</div>
          </div>
        {{/if}}
        {{#if results.im_fee.im_unconfirmed}}
          <div class="row">
            <div class="col-md-6"><span style="color: red;"><nobr>Неподтвежденные инкассации ИМ</nobr></span>:</div>
            <div class="col-md-6" style="color: red; text-align: right;">{{formatMoney results.im_fee.im_unconfirmed}}</div>
          </div>
        {{/if}}
      </div>
</script>

<script id="order-template" type="text/x-handlebars-template">
  <button type='button' id="back-to-orders" class='btn btn-default'>Назад к списку покупок</button>
  {{#each orders}}
    <div class="panel panel-default mt10">
      <div class="panel-heading">
       Покупка №<b>{{this.receipt_number}}</b> {{this.cashbox_name}} - {{this.date}} ({{#if this.editable}}<a href="/index.php?module=OfflineSale&order_id={{this.order_id}}" target="_blank">Изменить</a>{{/if}}{{#if this.readonly}}<a href="/index.php?module=OfflineSale&order_id={{this.order_id}}" target="_blank">Просмотреть</a>{{/if}}{{#if this.cancellable}} / <a href="#" onclick="delete_order({{this.order_id}});">Отменить</a>{{/if}})
<!--    Вот здесь какое-то условие, что это this.cashbox_name == 'услуги'
           <a href="/index.php?module=OfflineSale&act={$order->order_id}" target="_blank" style="float: right;">/ акт</a>
-->
       <a href="/index.php?module=OfflineSale&receipt_for={{this.order_id}}" target="_blank" style="float: right;">чек&nbsp;</a>
      </div>
      {{#if this.user.name}}
      <div class="panel-heading">
          <b>{{this.user.name}}</br> {{this.user.phone_number}}</b> </br>{{#if this.user.personal_discount}}бонус от <b>{{this.user.personal_discount}}%</b>{{/if}}
      </div>
      {{/if}}
      <div class="panel-body">
        {{#each this.products}}
          <div class="row ShAA_salesItemOff">
            {{#if this.image}}<div class="col-md-2 mt10"><img src="/reimg/files/products/60x/{{this.image}}" alt="{{this.product_name}}" /></div>{{/if}}
            <div class="col-md-3 mt10">{{this.product_name}}</div>
            <div class="col-md-2 mt10">{{this.sku}}</div>
            <div class="col-md-2 mt10">{{this.color}}</div>
            <div class="{{#if this.image}}col-md-1{{/if}}{{#unless this.image}}col-md-2{{/unless}} mt10">{{this.size}}</div>
            <div class="{{#if this.image}}col-md-2{{/if}}{{#unless this.image}}col-md-3{{/unless}} mt10" style="text-align: right;">{{this.price}}₽</div>
          </div>
        {{/each}}
        <div class="row">
          <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Всего: <b>{{this.total_sum}}</b>₽</div>
          {{#each this.payments}}
            {{#unless this.is_debt}}<div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">{{this.name}}: <b>{{this.money_paid}}</b>₽</div>{{/unless}}
          {{/each}}
          {{#if this.total_unpaid}}
            <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Не расписано: <span style="color: red;">{{this.total_unpaid}}₽</span></div>
          {{/if}}
          {{#if this.debts_show}}
            <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Долг: <span style="color: red;">{{this.total_debt}}₽</span></div>
            <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Выплачено: <span style="color: {{#if this.debt_paid}}green{{/if}}{{#unless this.debt_paid}}red{{/unless}};">{{this.total_debt_paid}}₽</span></div>
            <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;"><a href="/index.php?module=OfflineSales&debt={{this.debt_id}}" target="_blank" title="Добавить оплату">Добавить оплату</a></div>
          {{/if}}
        </div>
      </div>
    </div>
  {{/each}}
</script>

<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

Handlebars.registerHelper('formatMoney', function(n) {
  return new Intl.NumberFormat('ru-RU', {
   maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(Number(n));
});


var order_query_running = false;
var order_query_queue = [];
var $order_list = [];

post_order = function(order_query) {
  if (order_query_running) {
    order_query_queue.push(order_query);
    return false;
  }
  order_query_running = true;
  order_query_queue = [];
  var date_start = $("#date_start").val();
  var date_end = $("#date_end").val();
  $.get("/index.php?module=OfflineSales", {order_query: order_query, date_start: date_start, date_end: date_end}, function(orders) {
    $order_list = orders;
    console.log($order_list);
    var u = Template.order({orders: $order_list});
    $('#found-orders').html(u);
    order_query_running = false;
    if (order_query_queue.length > 0) {
      post_order(order_query_queue.pop());
    }
    $('#order-list').hide();
    $('#found-orders').show();
  });
}

var report_query_running = false;
var report_query_queue = [];
var $results = [];
post_report = function(report_query) {
  if (report_query_running) {
    report_query_queue.push(report_query);
    return false;
  }
  report_query_running = true;
  report_query_queue = [];
  var date_start = $("#date_start").val();
  var date_end = $("#date_end").val();
  $.get("/index.php?module=OfflineSales&report_query=1", {date_start: date_start, date_end: date_end}, function(results) {
    $results = results;
    console.log($results);
    var u = Template.report({results: $results});
    $('#filter_report').html(u);
    report_query_running = false;
    if (report_query_queue.length > 0) {
      post_report(report_query_queue.pop());
    }
    $('#default_report').hide();
    $('#filter_report').show();
  });
}

delete_order = function(order_id) {
  if (!confirm('Вы уверены, что хотите отменить покупку?')) {
    return false;
  }
  $.get("/index.php?module=OfflineSales&delete_order_id="+order_id, function(res) {
    if (res == "OK") {
      $('div#order_'+order_id).hide();
    }
  });
}


$(document).on("input", "#order-input", function() {
  post_order($(this).val());
});

$(document).on("click", "#back-to-orders", function() {
  $('#order-list').show();
  $('#found-orders').hide();
  $("#order-input").val('');
});
$(document).on("click", "#date_search", function(e) {
  e.preventDefault();
  post_order();
  post_report();
});

</script>
{/literal}
