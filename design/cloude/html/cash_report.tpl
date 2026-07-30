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
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20 ShAA_mobileInvisible"><a href="https://www.youtube.com/embed/iT6G2z1HAb0" target="_blank">Видео инструкция</a></div>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20 ShAA_mobileInvisible"><a href='/index.php?module=OfflineSales&sale_brands=1' target="_blank">Таблица скидок</a></div>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-4 ShAA_searchBlockOffline" id="right-column">
      <form action="/index.php?module=OfflineSales&cash_report=1" method='post'>
        <div class="form-group ShAA_fromService" style="overflow:hidden;">
          <label for="date_from" style="float:left;margin:6px 5px 0 0;">От </label>
          <input type="text" name="date_from" class="form-control ShAA_inputDate" id="date_from" value="{$date_from}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
        </div>
        <div class="form-group ShAA_toService" style="overflow:hidden;">
          <label for="date_to" style="float:left;margin:6px 5px 0 0;">До </label>
          <input type="text" name="date_to" class="form-control ShAA_inputDate" id="date_to" value="{$date_to}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
        </div>
        <div class="form-group ShAA_toService" >
          <label for="shop" style="float:left;margin:6px 5px 0 0;">Магазин: </label>
          <select name="shop" class="form-control" style="width: 74%;">
            <option value="0">Все магазины</option>
            {foreach item=shop from=$shops}
                <option value="{$shop->shop_id}" {if $shop_id == $shop->shop_id }selected{/if}>{$shop->name}</option>
            {/foreach}
          </select>
        </div>
        <input type="submit" style="padding: 6px 12px;margin:1px 0 0;" class="btn btn-primary" id="shop_filter" value="Фильтр">
      </form>
    </div>
    <div class="col-md-8" id="left-column" style="padding-left: 0;font-size: 16px;">
    <div style="clear: both;"></div>
      <div class="mt20">
      {if $price_sum > 0}
          <div class="mt20" style="border-bottom: 1px solid #ccc;">
              Оборот:
              <div style="float: right;">{$price_sum|number_format:0:",":" "}</div>
          </div>
          {if $uncommitted > 0}
              <div class="mt20" style="border-bottom: 1px solid #ccc;">
                  <span style="font-weight: 800;">Не расписанная стоимость:</span>
                  <div style="float: right;color: red;">{$uncommitted|number_format:0:",":" "}</div>
              </div>
          {/if}
      {/if}
          <div style="clear: both;"></div>
      {if $total_total}
          <div class="mt20" style="padding-bottom: 12px;">
              <div class="cr_bold_title">
                  Итого в кассе:
                  <div style="float: right;">{$total_total|number_format:0:",":" "}</div>
              </div>
              <div class="cr_bold_title">
                  Деньги с продаж:
                  <div style="float: right;">{$pure_money|number_format:0:",":" "}</div>
              </div>
              {foreach from=$total_payments item=tp}
                  <div class="cr_list">
                      {if $tp->sum < 0}
                      <a target="_blank" href="/index.php?module=OfflineSales&returns_date_from={$date_from|escape}&returns_date_to={$date_to|escape}" style="margin-left: 20px;">{$tp->name}:</a>
                      {else}
                      <span style="margin-left: 20px;">{$tp->name}:</span>
                      {/if}
                      <div style="float: right;{if $tp->name == 'Долг'}color: gray;{/if}">{$tp->sum|number_format:0:",":" "}</div>
                  </div>
              {/foreach}
              {if $debt_payment}
                <div class="cr_bold_title" style="border-top: 1px solid #ccc;">
                  Выплаты долгов:
                  <div style="float: right;">{$debt_payment|number_format:0:",":" "}</div>
                </div>
                {foreach from=$debt_payment_methods item=pm}
                    <div style="width: 100%;margin: 3px 0;">
                        <span style="margin-left: 20px;">{$pm->name}:</span>
                        <div style="float: right;">{$pm->sum|number_format:0:",":" "}</div>
                    </div>
                {/foreach}
              {/if}
          </div>
      {/if}
          {foreach item=item from=$cash}
              <div class="mt20" style="padding-bottom: 12px;">
                  <div class="cr_bold_title">
                      <a target="_blank" href="/index.php?module=OfflineSales&cashbox_id={$item->id}&date_start={$date_from|escape}&date_end={$date_to|escape}&no_json=1">{$item->name}</a> - {$item->shop_name}
                      <div style="float: right;">{$item->itogo|number_format:0:",":" "}</div>
                  </div>
                  <div class="cr_bold_title">
                      Деньги в кассе:
                      <div style="float: right;">{$item->pure_money|number_format:0:",":" "}</div>
                  </div>
                  {if $item->uncommitted > 0}
                      <div class="cr_list">
                          <span style="margin-left: 20px;">{if $item->id == 15}<a target="_blank" href="/index.php?module=OfflineSales&debts=1&cashbox={$item->id}">{/if}Не расписано{if $item->id == 15}</a>{/if}:</span>
                          <div style="float: right; color: red;">{$item->uncommitted|number_format:0:",":" "}</div>
                      </div>
                  {/if}
                  {if $item->id != 15 && $item->id != 13}
                    {foreach from=$item->uncommitted_orders item=order}
                        <div class="cr_list">
                            <span style="margin-left: 20px;"><a href="/index.php?module=OfflineSale&order_id={$order->order_id}" target="_blank">Заказ №{$order->order_id}</a></span>
                            <div style="float: right; color: red;">Не расписано {$order->unc_sum|number_format:0:",":" "}</div>
                        </div>
                    {/foreach}
                  {/if}
                  {if ($item->id == 15 || $item->id == 13) && $item->c_boxes}
                  <div class="cr_list">
                    По кассам:
                    {foreach from=$item->c_boxes item=c}
                        <div class="cr_list">
                          <span style="margin-left: 20px;">{if $c->shop_name}{$c->shop_name}, {/if}{$c->name}:</span>
                          <div style="float: right;{if $pm->name == 'Долг'}color: gray;{/if}">{$c->total|number_format:0:",":" "}</div>
                        </div>
                    {/foreach}
                  </div>
                  {/if}
                  <div class="cr_list">
                    {if $item->c_boxes}По методу:{/if}
                    {foreach from=$item->payment_methods item=pm}
                      <div class="cr_list">
                          {if $pm->name == 'Долг' && $item->id == 15}<a target="_blank" href="/index.php?module=OfflineSales&debts=1&cashbox={$item->id}">{/if}<span style="margin-left: 20px;">{$pm->name}:</span>{if $pm->name == 'Долг' && $item->id == 15}</a>{/if}
                          <div style="float: right;{if $pm->name == 'Долг'}color: gray;{/if}">{$pm->sum|number_format:0:",":" "}</div>
                      </div>
                    {/foreach}
                  </div>
                  {if $item->debt_payment_methods}
                    <div class="cr_bold_title">
                      Выплаты долгов:
                      <div style="float: right;">{$item->debt_sum|number_format:0:",":" "}</div>
                    </div>
                    <a href="#" class="toggler">Список</a>
                    <div style="display:none;">
                    {foreach from=$item->debt_payments item=pm}
                        <div class="cr_list">
                            <span style="margin-left: 20px;"><a href="/index.php?module=OfflineSale&order_id={$pm->order_id}" target="_blank">Заказ №{$pm->order_id}</a>:</span>
                            <div style="float: right;">{$pm->sum|number_format:0:",":" "}</div>
                        </div>
                    {/foreach}
                    </div>
                    {foreach from=$item->debt_payment_methods item=pm}
                        <div class="cr_list">
                            {if $pm->name == 'Долг' && $item->id == 15}<a href="/index.php?module=OfflineSale&debts=1&cashbox={$item->id}">{/if}<span style="margin-left: 20px;">{$pm->name}:</span>{if $pm->name == 'Долг' && $item->id == 15}</a>{/if}
                            <div style="float: right;">{$pm->sum|number_format:0:",":" "}</div>
                        </div>
                    {/foreach}
                  {/if}
              </div>
          {/foreach}
          {if $expenses}
          <div style="clear: both;"></div>
            <h4><a href="/index.php?module=OfflineSales&expenses_list=1&date_start={$date_from|escape}&date_end={$date_to|escape}&no_json=1" target="_blank">Расходы</a></h4>
            <div class="mt20" style="padding-bottom: 12px;">
              {foreach from=$expenses item=e}
                <div class="cr_bold_title">
                    {$e->shop_name}
                    <div style="float: right;"><a href="/index.php?module=OfflineSales&expenses_list=1&date_start={$date_from|escape}&date_end={$date_to|escape}&shop_id={$e->shop_id}" target="_blank">{$e->sum|number_format:0:",":" "}</a></div>
                </div>
              {/foreach}
            </div>
          {/if}
          {if $inkass_total}
          <div style="clear: both;"></div>
            <h4>Инкассация<div style="float: right;">{$inkass_total|number_format:0:",":" "}</div></h4>
            <div class="mt20" style="padding-bottom: 12px;">
              {foreach from=$inkass item=i}
                <div class="cr_bold_title">
                  {$i->shop_name}
                  <div style="float: right;"><a href="/index.php?module=OfflineSales&inkass_list=1&date_start={$date_from|escape}&date_end={$date_to|escape}&shop_id={$i->shop_id}" target="_blank">{$i->sum|number_format:0:",":" "}</a></div>
                </div>
              {/foreach}
              {if $im_fee->confirmed}
                <div class="cr_bold_title" style="border-bottom: 1px solid #ccc;">
                  Агентское вознаграждение ИМ
                  <div style="float: right;">{$im_fee->confirmed|number_format:0:",":" "}</div>
                </div>
              {/if}
              {if $im_fee->ai_confirmed}
                <div class="cr_bold_title" style="border-bottom: 1px solid #ccc;">
                  Платежи ИМ карта Сбербанк (А.И.)
                  <div style="float: right;">{$im_fee->ai_confirmed|number_format:0:",":" "}</div>
                </div>
              {/if}
              {if $im_fee->is_confirmed}
                <div class="cr_bold_title" style="border-bottom: 1px solid #ccc;">
                  Платежи ИМ карта Сбербанк (И.Ш.)
                  <div style="float: right;">{$im_fee->is_confirmed|number_format:0:",":" "}</div>
                </div>
              {/if}
              {if $im_fee->im_confirmed}
                <div class="cr_bold_title" style="border-bottom: 1px solid #ccc;">
                  Инкассация ИМ
                  <div style="float: right;">{$im_fee->im_confirmed|number_format:0:",":" "}</div>
                </div>
              {/if}
            </div>
          {/if}
          {if $im_fee->unconfirmed}
            <div style="clear: both;"></div>
            <h4 class="cr_bold_title" style="border-bottom: 1px solid #ccc; color:red;">Неподтвежденные вознаграждения ИМ<div style="float: right;">{$im_fee->unconfirmed|number_format:0:",":" "}</div></h4>
          {/if}
          {if $im_fee->ai_unconfirmed}
            <div style="clear: both;"></div>
            <h4 class="cr_bold_title" style="border-bottom: 1px solid #ccc; color:red;">Неподтвежденные платежи ИМ карта (А.И.)<div style="float: right;">{$im_fee->ai_unconfirmed|number_format:0:",":" "}</div></h4>
          {/if}
          {if $im_fee->is_unconfirmed}
            <div style="clear: both;"></div>
            <h4 class="cr_bold_title" style="border-bottom: 1px solid #ccc; color:red;">Неподтвежденные платежи ИМ карта (И.Ш.)<div style="float: right;">{$im_fee->is_unconfirmed|number_format:0:",":" "}</div></h4>
          {/if}
          {if $im_fee->im_unconfirmed}
            <div style="clear: both;"></div>
            <h4 class="cr_bold_title" style="border-bottom: 1px solid #ccc; color:red;">Неподтвежденные инкассации ИМ<div style="float: right;">{$im_fee->im_unconfirmed|number_format:0:",":" "}</div></h4>
          {/if}
          <div class="mt20" style="padding-bottom: 12px;padding-top: 12px;">
              <div class="cr_bold_title">
                  Интернет-магазин
                  <!--<div style="float: right;">{$online_total_income|number_format:0:",":" "}</div>-->
              </div>
              <div class="cr_bold_title">
                  Онлайн-платежи:
                  <div style="float: right;">{$online_rfi_income|number_format:0:",":" "}</div>
              </div>
              <!--<div class="cr_bold_title">
                  Сумма принятых товаров:
                  <div style="float: right;">{$online_tk_income|number_format:0:",":" "}</div>
              </div>-->
          </div>
      </div>
      <div id="found-orders">
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->
{literal}
<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});


$(document).on("input", "#product-input", function() {
  if ($(this).val().length > 3){
    post_order($(this).val());
  }
});
$(document).on("click", ".movement_toggle", function(e) {
  e.preventDefault();
  $(this).find('span').toggle();
  $(this).next().slideToggle();
});
$(document).on("click", ".toggler", function(e) {
  e.preventDefault();
  $(this).next().slideToggle();
});

</script>
{/literal}
