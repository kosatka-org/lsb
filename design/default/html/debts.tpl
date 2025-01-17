<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
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
        {if $smarty.session.user->group_id == 9 || $smarty.session.user->group_id == 2}
            <div class="ShAA_kassirInset">
                <span><a href="index.php?module=OfflineSales">Покупки</a></span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&movement=1">Перемещения</a></span>
                <span>&nbsp;/&nbsp;
                <span>Задолженности</span>
            </div>
        {/if}
            <!-- /Вкладки /-->
            <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        </div>
    </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      <h3>Задолженности</h3>
      <div id="order-list">
        {foreach from=$grouped_debts item=g_debts key=name}
          <h3>{$name}:</h3>
          {foreach from=$g_debts.debts item=debt}
          <div class="panel panel-default">
            <div class="panel-heading">
             Задолженность №<b> {$debt->id}</b>,  {$debt->user->name},  {$debt->user->phone_number}, сумма долга: <b>{$debt->debt_amount|number_format:0:",":" "}</b>{if $debt->paid_off_amount != 0}, выплачено: <b>{$debt->paid_off_amount|number_format:0:",":" "}</b>{/if} - <a href="/index.php?module=OfflineSales&debt={$debt->id}" target="_blank">Изменить</a> <span style="float: right;">{$debt->date|date_format:"%Y/%m/%d"} ({$debt->cashbox_name})</span>
             <br/>
             Ответственное лицо: {$debt->resp->name}
             <br/>
             <span class="label label-{if $debt->days > 14}danger{elseif $debt->days > 7}warning{else}primary{/if}">{$debt->days} дней</span>
            </div>
            {if $debt->payments}
              <div class="panel-body">
              <p>Выплаты:</p>
              {foreach from=$debt->payments item=payment}
                <div class="row">
                  <div class="col-md-4 mt10"><b>{$payment->payment_option}</b></div>
                  <div class="col-md-3 mt10" style="text-align: right;">{$payment->money_paid|number_format:0:",":" "}</div>
                  <div class="col-md-3 mt10" style="text-align: right;">{$payment->cashbox_name}</div>
                  <div class="col-md-2 mt10" style="text-align: right;">{$payment->date|date_format:"%Y/%m/%d, %H:%M"}</div>
                </div>
              {/foreach}
            </div>
            {/if}
          </div>
          {/foreach}
        {/foreach}
      </div>
      <div id="found-orders">
      </div>
    </div>

    <div class="col-md-4" id="right-column" style="margin-top: 36px;">
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
                <input id="order-input" type="text" class="form-control" placeholder="Введите штрихкод или артикул" autofocus>
              </div>
              <div id="found-products" class="anchor">
                <!--Anchor for user-template-->
              </div>
            </div>
          </div>
        </div>

      </div>

      <div id="selected-user" class="mt20">
        <!--Anchor for selectedUser-template-->
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="debts-template" type="text/x-handlebars-template">
  <h2>Результаты поиска</h2>
  <button type='button' id="back-to-debts" class='btn btn-default'>Назад к списку долгов</button>

  {{#each orders}}
    <div class="panel panel-default">
      <div class="panel-heading">
       Задолженность №<b> {{this.debt.id}}</b>,  {{this.user.name}}, {{this.user.phone_number}}, сумма долга: <b>{{this.debt.debt_amount}}</b>{{#if this.paid_off_amount}}, выплачено: <b>{{this.paid_off_amount}}</b>{{/if}} - <a href="/index.php?module=OfflineSales&debt={{this.debt.id}}" target="_blank">Изменить</a>  <span style="float: right;">{{this.debt.date}}</span>
      </div>
      {{#if this.debt.payments}}
        <div class="panel-body">
        <p>Выплаты:</p>
        {{#each this.debt.payments}}
          <div class="row">
            <div class="col-md-5 mt10"><b>{{this.payment_option}}</b></div>
            <div class="col-md-3 mt10" style="text-align: right;">{{this.money_paid}}</div>
            <div class="col-md-4 mt10" style="text-align: right;">{{this.date}}</div>
          </div>
        {{/each}}
      </div>
      {{/if}}
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
  $.get("/index.php?module=OfflineSales", {order_query: order_query, debt_query: 1}, function(orders) {
    $order_list = orders;
    var u = Template.debts({orders: $order_list});
    $('#found-orders').html(u);
    order_query_running = false;
    if (order_query_queue.length > 0) {
      post_order(order_query_queue.pop());
    }
    $('#order-list').hide();
    $('#found-orders').show();
  });
}


$(document).on("input", "#order-input", function() {
  post_order($(this).val());
});

$(document).on("click", "#back-to-debts", function() {
  $('#order-list').show();
  $('#found-orders').hide();
  $("#order-input").val('');
});

</script>
{/literal}
