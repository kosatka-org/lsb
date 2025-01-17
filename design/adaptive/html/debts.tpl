<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/locale/ru.js"></script>
<script src="/js/are_you_ie.js"></script>

<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.2">

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
  .linkShow {
      display: none;
  }
  .label {
    padding: 0.3em 0.6em !important;
  }
  </style>

  <style media="print" type="text/css" >
    #right-column,
    #ShAA_tabstabs,
    #slaask-button,
    .ShAA_linkChange,
    #ShAA_pageName,
    .ShAA_adminTabs,
    .panel-body {
        display: none;
    }
    .linkShow {
        display: inline;
    }
    #left-column {
        width: 100%;
    }

    .label, .panel-default > .panel-heading {
        background: #fff !important;
        color: #000 !important;
    }

    .h3, h3 {
        font-size: 18px;
        margin-top: 30px;
    }
  </style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
    <div class="row" id="ShAA_tabstabs">
        <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <!-- Вкладки /-->
        {if $smarty.session.user->group_id == 9 || $smarty.session.user->group_id == 2}
            <div class="ShAA_kassirInset">
                <span><a href="index.php?module=OfflineSales">Покупки</a></span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&movement=1">Перемещения</a></span>
                <span>&nbsp;/&nbsp;
                <span>Задолженности</span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&returns=1">Возвраты</a></span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&calls=1">Клиенты</a></span>
            </div>
        {/if}
            <!-- /Вкладки /-->
            <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        </div>
    </div>
  <div class="row mt20">
    <div class="col-md-4 ShAA_searchBlockOffline" id="right-column" style="margin-top: 36px;">
      <div class="panel-group mt20" id="accordion" role="tablist" aria-multiselectable="true">
        <div class="panel panel-default">
          <div class="panel-heading" role="tab" id="heading_products">
            <h4 class="panel-title">
              <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_products" aria-expanded="true" aria-controls="collapseOnecollapse_products">
                <b>Поиск</b>
              </a>
            </h4>
          </div>
          <div id="collapse_products" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading_products">
            <div class="panel-body">
              <label>Штрихкод, артикул, имя или телефон покупателя</label>
              <div class="input-group">
                <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
                <input id="order-input" type="text" class="form-control" placeholder="Введите штрихкод или артикул" value="{$smarty.get.search}" autofocus>
              </div>
              <div id="found-products" class="anchor">
                <!--Anchor for user-template-->
              </div>
            </div>
          </div>
        </div>
      </div>
      <!--<div class="panel-group mt20" id="accordion2" role="tablist" aria-multiselectable="true">
        <div class="panel panel-default">
          <div class="panel-heading" role="tab" id="heading_products">
            <h4 class="panel-title">
              <a role="button" data-toggle="collapse" data-parent="#accordion2" href="#collapse_products2" aria-expanded="true" aria-controls="collapseOnecollapse_products">
                <b>Сгенерированный URL</b>
              </a>
            </h4>
          </div>
          <div id="collapse_products2" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading_products2">
            <div class="panel-body">
              <label>Адрес для копирования</label>
                <input id="set_url" type="text" class="form-control">
            </div>
          </div>
        </div>
      </div>-->

      <div id="selected-user" class="mt20">
        <!--Anchor for selectedUser-template-->
      </div>
    </div>
    <div class="col-md-8 ShAA_leftBlockOfflineDesctop" id="left-column">
      <div id="ShAA_pageName" style="float: left; width: 100%;">
          <div class="ShAA_nameTitle"><h3>Задолженности (<a href="/index.php?module=OfflineSales&debts=1&all_time=1">все</a>)</h3></div>
          <div style="float: left;margin-top:20px;margin-right:20px;">
            <select name="shop_id" id="shop_id">
              <option value="0">Все магазины</option>
              {foreach item=shop from=$shops}
                  <option value="{$shop->shop_id}" {if $smarty.get.shop_id == $shop->shop_id }selected{/if}>{$shop->name}</option>
              {/foreach}
            </select>
          </div>
          <div style="float: left;margin-top:20px;margin-right:20px;">
            <select name="cashbox_id" id="cashbox_id">
              <option value="0">Все кассы</option>
              {foreach item=cashbox from=$cashboxes}
                  <option value="{$cashbox->id}" {if $smarty.get.cashbox == $cashbox->id }selected{/if}>{$cashbox->name}</option>
              {/foreach}
            </select>
          </div>
          <div style="float: left;margin-top:20px;">
            <select name="offline_manager_id" id="offline_manager_id">
              <option value="0">Все Продавцы</option>
                {foreach item=user from=$offline_managers}
                <option value="{$user->user_id}" {if $smarty.get.manager_id == $user->user_id }selected{/if}>{$user->name}</option>
                {/foreach}
            </select>
          </div>
          <input type="submit" style="margin:16px 0 0 20px;" class="btn btn-primary" id="shop_filter" value="Фильтр">
          <div class="ShAA_buttonPrint">
            <a class="btn btn-primary mt20" href="" onClick="window.print();">Распечатать</a>
          </div>
      </div>
      <div id="order-list">
        <div style="margin-bottom:20px;font-size:16px;clear:both;">
        {if $debts_total}
          <h3 class="ShAA_nameTitle">Долг по продавцу</h3>
          {foreach item=debt from=$debts_total}
            <div style="margin-top:10px;">
            <h3 class="ShAA_nameTitle"><a onClick="return false;" href="#">{$debt->rp_name}</a> <div style="float: right;text-align:right;"><b>{$debt->debt_amount|number_format:0:",":" "}</b></div></h3>
            </div>
          {/foreach}
        {/if}
        </div>
        {foreach from=$grouped_debts item=g_debts key=name}
          <div style="clear:both;">
          <h3 class="ShAA_nameTitle"><a style="float:none;" class="select-user" href="#">{$name}</a> <a style="font-size: 14px; margin: 0px 0px 0px 6px;" class="ShAA_mobNone" href="/index.php?module=OfflineSales&personal_debt={$g_debts.user_id}" target="_blank"> распечатать</a> <div style="float: right;text-align:right;"><b>{$g_debts.debt|number_format:0:",":" "}</b></div></h3>
          <div style="clear:both;"></div>
          {foreach from=$g_debts.debts item=debt}
          <div class="panel panel-default" style="overflow:hidden;">
            <div class="panel-heading" style="overflow:hidden;">
             Задолженность №<b> {$debt->id}</b>, по покупке №<a class="ShAA_linkChange" href="/index.php?module=OfflineSale&order_id={$debt->order_id}">{$debt->receipt_number}</a><span class="linkShow">{$debt->receipt_number}</span> ID {$debt->order_id}
             <span style="float: right;"><a class="ShAA_linkChange" href="/index.php?module=OfflineSales&debt={$debt->id}" target="_blank">Изменить</a></span>
             </br><span style="float: left;">{if $debt->resp}Продавец: {$debt->resp},{/if} {if $debt->cashbox_name}{$debt->cashbox_name}, {/if}{if $debt->shop}{$debt->shop} {/if}</span></br>
             <div style="float: left;overflow:hidden; max-width:90%;">
               {foreach from=$debt->products item=prod}{$prod->product_name} <span style="float:right;display:inline-block;margin-left:25px;">{$prod->price|number_format:0:",":" "}</span><br>{/foreach}
               <hr style="border-color:black;margin-top: 10px;margin-bottom: 10px;"></hr>
               {if $debt->remain != 0 && $debt->paid_off_amount != 0}сумма: <span style="float:right;display:inline-block;margin-left:25px;"><b>{$debt->debt_amount|number_format:0:",":" "}</b></span>{/if}
               {if $debt->paid_off_amount != 0}</br>выплачено: <span style="float:right;display:inline-block;margin-left:25px;"><b>{$debt->paid_off_amount|number_format:0:",":" "}</b></span></br>{/if}
               долг: <span style="float:right;display:inline-block;margin-left:25px;"><b>{$debt->remain|number_format:0:",":" "}</b></span>
             </div>
             <div style="clear:both;"></div>
              {if $debt->days}
                <span style="float: right;margin-top:-18px;" class="label label-{if $debt->days > 14}danger{elseif $debt->days > 7}warning{else}primary{/if}">{$debt->days} дней</span>
              {/if}
            </div>
            {if $debt->payments}
              <div class="panel-body">
              {foreach from=$debt->payments item=payment}
                <div class="row ShAA_itemDebt">
                  <div class="col-md-4 mt10"><b>{$payment->payment_option}</b></div>
                  <div class="col-md-3 mt10" style="text-align: right;">{$payment->money_paid|number_format:0:",":" "}</div>
                  <div class="col-md-3 mt10" style="text-align: right;">{$payment->cashbox_name}</div>
                  <div class="col-md-2 mt10" style="text-align: right;">{$payment->date|date_format:"%Y/%m/%d"}</div>
                </div>
              {/foreach}
              </div>
            {/if}
          </div>
          {/foreach}
          </div>
        {/foreach}
      </div>
      <div id="found-orders">
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="debts-template" type="text/x-handlebars-template">
  <button type='button' id="back-to-debts" class='btn btn-default'>Назад к списку долгов</button>
  {{#each orders}}
    <h3 class="ShAA_searchResTitle">{{#if this.debt_total}}Общий долг: <span style="float:right;display:inline-block;margin-left:25px;color:{{#if this.debt_overflow}}red{{/if}}{{#unless this.debt_overflow}}green{{/unless}}">{{formatMoney this.debt_total}}</span>{{/if}}
    {{#if this.debt_total_month}}</br>Долг за 45 дней: <span style="float:right;display:inline-block;margin-left:25px;">{{formatMoney this.debt_total_month}}</span>{{/if}}
    {{#if this.debt_total_mtm}}</br>Долг по пошиву: <span style="float:right;display:inline-block;margin-left:25px;">{{formatMoney this.debt_total_mtm}}</span>{{/if}}</h3>
    {{#unless this.debt_total}}
    <div class="panel panel-default" style="overflow:hidden;">
      <div class="panel-heading" style="overflow:hidden;">
       <span class="ShAA_mobileInvisible">Задолженность </span>№<b> {{this.debt.id}}</b> по покупке №<a class="ShAA_linkChange" href="/index.php?module=OfflineSale&order_id={{this.debt.order_id}}">{{this.receipt_number}}</a><span class="linkShow">{{this.receipt_number}}</span> ID {{this.debt.order_id}}  <span style="float: right;"><a class="ShAA_linkChange" href="/index.php?module=OfflineSales&debt={{this.debt.id}}" target="_blank">Оплата</a></span><br>
       </br><span>{{#if this.debt.resp}}Продавец: {{this.debt.resp}},{{/if}} {{#if this.debt.cashbox_name}}{{this.debt.cashbox_name}}, {{/if}}{{#if this.debt.shop}}{{this.debt.shop}}{{/if}}</span>
       <b>{{this.user.name}}</b>, <a href="tel:{{this.user.phone_number}}">{{this.user.phone_number}}</a>
      <div style="clear:both;"></div>
       <div style="float: left;overflow:hidden; max-width:90%;">
         {{#each this.products}}{{product_name}} <span style="float:right;display:inline-block;margin-left:25px;">{{formatMoney price}}</span><br>{{/each}}
         <hr style="border-color:black;margin-top: 10px;margin-bottom: 10px;"></hr>
         {{#if this.paid_off_amount}}<span>сумма: <span style="float:right;display:inline-block;margin-left:25px;"><b>{{this.debt.debt_amount}}</b></span>{{/if}}
         {{#if this.paid_off_amount}}</br>выплачено: <span style="float:right;display:inline-block;margin-left:25px;"><b>{{this.paid_off_amount}}</b></span></br>{{/if}}
         долг: <span style="float:right;display:inline-block;margin-left:25px;"><b>{{this.remain}}</b></span>
       </div>
      <div style="clear:both;"></div>
       <span class="ShAA_dateOffline" style="float: right;">{{this.debt.date}}</span>
      </div>
      {{#if this.debt.payments}}
        <div class="panel-body">
        {{#each this.debt.payments}}
          <div class="row">
            <div class="col-md-5 mt10" style="float: left;"><b>{{this.payment_option}}</b></div>
            <div class="col-md-3 mt10" style="text-align: right;">{{formatMoney this.money_paid}}</div>
            <div class="col-md-4 mt10" style="text-align: right;">{{formatDate this.date}}</div>
          </div>
        {{/each}}
      </div>
      {{/if}}
    </div>
    {{/unless}}
  {{/each}}

</script>

<script>

moment.locale('ru');

Handlebars.registerHelper('formatDate', function(date) {
  var moment_obj = moment(date)
  if (moment_obj._isValid) {
    return moment_obj.format("Do MMMM YYYY, H:mm");
  }
  else {
    return false;
  }
});

Handlebars.registerHelper('formatMoney', function(n) {
  return new Intl.NumberFormat('ru-RU', { style: 'currency', currency: 'RUB',
   maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(Number(n));
});

$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var order_query_running = false;
var order_query_queue = [];
var $order_list = [];

post_order = function(order_query, shop, offline_manager_id) {
  if (order_query_running) {
    order_query_queue.push(order_query);
    return false;
  }
  order_query_running = true;
  order_query_queue = [];
  var shop = $("#shop_id").val();
  var cashbox = $("#cashbox_id").val();
  var offline_manager_id = $("#offline_manager_id").val();
  var all_time = !!(new URL(window.location.href)).searchParams.get('all_time');
  $.get("/index.php?module=OfflineSales", {order_query: order_query, shop_id: shop, cashbox: cashbox, offline_manager_id: offline_manager_id, debt_query: 1, all_cashboxes: 1, all_time: all_time}, function(orders) {
    $order_list = orders;
    console.log(orders);
    var u = Template.debts({orders: $order_list});
    $('#found-orders').html(u);
    order_query_running = false;
    if (order_query_queue.length > 0) {
      post_order(order_query_queue.pop());
    }
    $('#order-list').hide();
    $('#found-orders').show();
    $('#set_url').val("https://lsboutique.ru/index.php?module=OfflineSales&debts=1&cashbox="+cashbox+"&shop_id="+shop+"&offline_manager_id="+offline_manager_id+"&search="+order_query);
  });
}


$(document).on("input", "#order-input", function() {
  post_order($(this).val(), $("#shop_id").val(), $("#offline_manager_id").val());
});

$(document).on("click", "#back-to-debts", function() {
  $('#order-list').show();
  $('#found-orders').hide();
  $("#order-input").val('');
  $("#shop_id").val(0);
});

$(document).on("click", ".select-user", function(e) {
  e.preventDefault();
  var name = $(this).html().split(",")[0];
  $("#order-input").val(name);
  post_order(name, $("#shop_id").val(), $("#offline_manager_id").val());
});

$(document).on("click", "#shop_filter", function(e) {
  e.preventDefault();
  post_order($("#order-input").val(), $("#shop_id").val(), $("#offline_manager_id").val());
});
$(document).on("change", "#offline_manager_id", function(e) {
  e.preventDefault();
  post_order($("#order-input").val(), $("#shop_id").val(), $("#offline_manager_id").val());
});
</script>
{/literal}
