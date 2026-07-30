<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/locale/ru.js"></script>
<script src="/js/are_you_ie.js"></script>

<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.3">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/themes/black/pace-theme-flash.css" />

{if $config->enviroment == 'live'}
  <script src="//d2wy8f7a9ursnm.cloudfront.net/v4/bugsnag.min.js"></script>
  <script>window.bugsnagClient = bugsnag('0e17cb08065a63f14237abf91499cea3')</script>
{/if}

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
  .mt40 {
    margin-top: 40px;
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

  .ShAA_toggleBrandsForCalls {
    display: none;
  }

  #ShAA_brandsCallsTitle, #ShAA_GroupsTitle {
    cursor: pointer;
  }

  #ShAA_brandsCallsTitle span, #ShAA_GroupsTitle span {
    float: left;
  }

  #ShAA_brandsCallsTitle i, #ShAA_GroupsTitle i {
    float: left;
    margin: 4px 0 0 6px;
  }
  
  .half_form{
    width: 50%!important;
  }
  .icon-minus-square-o {
    display: inline !important;
  }
  .pagination {
    margin-bottom: 0 !important;
  }
  @media (max-width: 770px) {
    .half_form{
      width: 100%!important;
    }
  }
  </style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20"><a href="https://youtu.be/CCV0mxOxJTk" target="_blank">Установка приложения</a></div>
    </div>
  </div>
  <div class="row">
    <div class="col-md-12" id="right-column" style="padding-left: 0;">
      <label>Кассы</label>
      <br>
      <select name="pay_cashbox" id="pay_cashbox" class="form-control" style="float:left; margin-right:40px;margin-bottom:20px;width:350px;">
        <option value="0">Все кассы</option>
        {foreach item=cashbox from=$cashboxes}
            <option value="{$cashbox->id}" {if $cashbox_id == $cashbox->id }selected{/if}>{$cashbox->name}</option>
        {/foreach}
      </select>
      <div class="input-group half_form">
        <form class="form-inline">
          <div class="form-group ShAA_fromService" style="overflow:hidden;">
            <label for="date_start" style="float:left;margin:6px 5px 0 0;">От </label>
            <input type="text" name="date_start" class="form-control ShAA_inputDate" id="date_start" value="{$date_start}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
          <div class="form-group ShAA_toService" style="overflow:hidden;">
            <label for="date_end" style="float:left;margin:6px 5px 0 0;">До </label>
            <input type="text" name="date_end" class="form-control ShAA_inputDate" id="date_end" value="{$date_end}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
          <a class="btn btn-primary" id="pay_search" href="#" role="button" style="padding: 6px 12px;margin:1px 0 0;">Поиск</a>
        </form>
      </div>
      <div class="clear"></div>
      <label>Способы оплаты</label>
      <br>
      <select name="payment_method" id="payment_method" class="form-control" style="float:left; margin-right:40px;margin-bottom:20px;width:350px;">
        <option value="0">Все способы</option>
        {foreach item=method from=$payment_methods}
            <option value="{$method->id}" {if $method_id == $method->id }selected{/if}>{$method->name}</option>
        {/foreach}
      </select>
      <div class="clear"></div>
    </div>
  </div>
  <div class="pagination">
  </div>
  <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
    <div class="col-md-1"><b>Оплата</b></div>
    <div class="col-md-1"><b>Продажа / Долг</b></div>
    <div class="col-md-1"><b>Сумма</b></div>
    <div class="col-md-2"><b>Дата</b></div>
    <div class="col-md-2"><b>Способ</b></div>
    <div class="col-md-2"><b>Ответственный</b></div>
    <div class="col-md-3"><b>Касса</b></div>
  </div>
  <div id="order-list">
    {foreach from=$payments item=payment }
      <div class="row user-row mt20">
        <div class="col-md-1">{$payment->id}</div>
        <div class="col-md-1">{if $payment->order_id}{if $payment->order_cashbox == 13}МТМ{elseif $payment->order_cashbox == 15}Услуга{else}Продажа{/if}: <a href="/index.php?module=OfflineSale&order_id={$payment->order_id}" target="_blank">{$payment->order_id}</a>{/if}{if $payment->debt_id}Долг: <a href="/index.php?module=OfflineSales&debt={$payment->debt_id}" target="_blank">{$payment->debt_id}</a>{/if}</div>
        <div class="col-md-1" style="text-align:right;">{$payment->money_paid|number_format:0:",":" "}</div>
        <div class="col-md-2">{$payment->date}</div>
        <div class="col-md-2">{$payment->payment_method}</div>
        <div class="col-md-2">{$payment->resp}</div>
        <div class="col-md-3">{$payment->cashbox_name}({$payment->shop_name})</div>
      </div>
      <hr class="mt40">
    {/foreach}
  </div>
  <div id="found-orders">
  </div>
  <div class="pagination">
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="payment-template" type="text/x-handlebars-template">
{{#each payments}}
  <div class="row user-row mt20">
    <div class="col-md-1">{{this.id}}</div>
    <div class="col-md-1">{{#if this.sh_order_id}}{{this.order_type}}: <a href="/index.php?module=OfflineSale&order_id={{this.order_id}}" target="_blank">{{this.order_id}}</a>{{/if}}{{#if this.sh_debt_id}}Долг: <a href="/index.php?module=OfflineSale&debt={{this.debt_id}}" target="_blank">{{this.debt_id}}</a>{{/if}}</div>
    <div class="col-md-1" style="text-align:right;">{{formatMoney this.money_paid}}</div>
    <div class="col-md-2">{{this.date}}</div>
    <div class="col-md-2">{{this.payment_method}}</div>
    <div class="col-md-2">{{this.resp}}</div>
    <div class="col-md-3">{{this.cashbox_name}}({{this.shop_name}})</div>
  </div>
  <hr class="mt40">
{{/each}}
</script>


<script src="https://cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/pace.min.js"></script>

<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

moment.locale('ru');

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

Handlebars.registerHelper('formatMoney', function(n) {
  return new Intl.NumberFormat('ru-RU', { 
   maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(Number(n));
});

Handlebars.registerHelper('FDwoY', function(date) {
  var moment_obj = moment(date)
  if (moment_obj._isValid) {
    if (moment_obj.format("YY") == moment().format("YY")){
      return moment_obj.format("MM-DD H:mm");
    }
    else{
      return moment_obj.format("YY-MM-DD H:mm");
    }
  }
  else {
    return false;
  }
});

var order_query_running = false;
var order_query_queue = [];
var $order_list = [];

post_order = function(cashbox, payment_method, date_start, date_end) {
  if (order_query_running) {
    order_query_queue.push(product_query);
    return false;
  }
  order_query_running = true;
  order_query_queue = [];
  $.get("/index.php?module=OfflineSales&payments=1", {pay_cashbox: cashbox, payment_method: payment_method, date_from: date_start, date_to: date_end}, function(payments) {
    $payments = payments;
    console.log($payments);
    var u = Template.payment({payments: $payments});
    console.log(u);
    $('#found-orders').html(u);
    order_query_running = false;
    if (order_query_queue.length > 0) {
      post_order(order_query_queue.pop());
    }
    $('#order-list').hide();
    $('#found-orders').show();
  });
}


$(document).on("click", "#pay_search", function(e) {
  e.preventDefault();
  post_order($('#pay_cashbox').val(),$('#payment_method').val(),$('#date_start').val(),$('#date_end').val());
});

</script>
{/literal}
