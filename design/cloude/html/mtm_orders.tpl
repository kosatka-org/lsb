<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.4">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.6/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.serializeJSON/2.8.1/jquery.serializejson.min.js"></script>
<script src="/js/are_you_ie.js"></script>
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
  .ShAA_mobVisible {
    display: none;
  }
@media (max-width: 770px) {
    .ShAA_mobVisible {
        display: block;
    }
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
                <span>&nbsp;/&nbsp;</span>
                <span><a href="index.php?module=OfflineSales&movement=1">Перемещения</a></span>
                <span>&nbsp;/&nbsp;</span>
                <span><a href="index.php?module=OfflineSales&debts=1">Задолженности</a></span>
                <span>&nbsp;/&nbsp;</span>
                <span><a href="index.php?module=OfflineSales&returns=1">Возвраты</a></span>
                <span>&nbsp;/&nbsp;</span>
                <span>Индивидуальный пошив</span>
        </div>
{/if}
        <!-- /Вкладки /-->
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20"><a href="https://www.youtube.com/embed/iT6G2z1HAb0" target="_blank">Видео инструкция</a></div>
    </div>
  </div>
  <div class="row">
    {foreach from=$cashboxes_select item=cbox}
      {if $cbox->name == 'Индивидуальный пошив'}
        <a class="btn btn-primary btn-lg" style="margin:5px 0;" href="/index.php?module=OfflineSale&cashbox_id={$cbox->id}" target="_blank">Новый заказ на пошив</a>
      {/if}
    {/foreach}
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      <form id="search-form">
        <label class="ShAA_mobileInvisible">Поиск заказов на пошив</label>
        <input id="order-input" type="text" name="client" class="form-control" placeholder="Введите данные клиента" autofocus>
        <select class="status-input form-control" id="mtm_year" name="year" style="margin-top:10px;">
          <option value="">По году</option>
          {foreach from=$years item=year}
            <option value="{$year->year}">{$year->year}</option>
          {/foreach}
        </select>
        <div class="mt20">
          По брендам:<br>
          <div class="form-group" style="margin-top: 12px;">
          {foreach from=$brands item=brand}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input cg-chk" name="brands[]" value="{$brand->brand_id}">{$brand->name}
            </label>
          {/foreach}
          </div>
        </div>
        <div class="clear"></div>
        <button type="submit" id="send-button" class="btn btn-primary">Поиск</button>
      </form>
      <div class="clear"></div>
      <br>
      <br>
      <div id="order-list">
        {foreach from=$orders item=order}
          <div class="panel panel-default" id="order_{$order->order_id}">
            <div class="panel-heading">
             <span class="ShAA_mobileInvisible">Заказ </span>№<b> {$order->receipt_number}</b> ({$order->cashbox_name})&nbsp;&nbsp;-&nbsp;&nbsp;{$order->date|date_format:"%Y/%m/%d, %H:%M"}&nbsp;&nbsp;-&nbsp;&nbsp;<b>{$order->brand_name}</b> <br class="ShAA_mobVisible">(<a href="/index.php?module=OfflineSale&order_id={$order->order_id}" target="_blank">Изменить</a>)
             <a href="/index.php?module=OfflineSale&receipt_for={$order->order_id}" target="_blank" style="float: right;">Распечатать тов.чек</a>
            </div>
            {if $order->user}
                <div class="panel-heading">
                    <b>{$order->user->name}</br> {$order->user->phone_number}</b> </br>{if $order->user->personal_discount} бонус от <b>{$order->user->personal_discount}%{/if}</b>
                </div>
            {/if}
            <div class="panel-body">
              {foreach from=$order->products item=product}
                <div class="row">
                  <div class="col-md-3 mt10" style="float: left;"><b>{$product->product_name}</b></div>
                  <div class="col-md-2 mt10" style="float: left;">{$product->sku}</div>
                  <div class="col-md-2 mt10" style="float: left;">{$product->color}</div>
                  <div class="col-md-2 mt10" style="float: left;">{$product->size}</div>
                  <div class="col-md-3 mt10" style="text-align: right;float: right;">{$product->price|number_format:0:",":" "}₽</div>
                </div>
              {/foreach}
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
            </div>
          </div>
        {/foreach}
      </div>
      <div id="found-orders">
      </div>
    </div>

    <div class="col-md-4" id="right-column">
      {* <label>Поиск заказа</label>
      <div class="input-group">
        <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
        <input id="order-input" type="text" class="form-control" placeholder="Введите номер покупки" autofocus>
      </div> *}

      <h3>Отчет по индивидуальному пошиву</h3>
      <div>
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
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="order-template" type="text/x-handlebars-template">
  <button type='button' id="back-to-orders" class='btn btn-default'>Назад к списку покупок</button>
  {{#each orders}}
    <div class="panel panel-default mt10">
      <div class="panel-heading">
       <span class="ShAA_mobileInvisible">Заказ </span>№ <b>{{this.receipt_number}}</b> {{this.cashbox_name}} - {{formatDate this.date minute="numeric" hour="numeric" day="numeric" month="numeric" year="numeric"}} &nbsp;&nbsp;-&nbsp;&nbsp;<b>{{this.brand_name}}</b> <br class="ShAA_mobVisible">(<a href="/index.php?module=OfflineSale&order_id={{this.order_id}}" target="_blank">Изменить</a>)
       <a href="/index.php?module=OfflineSale&receipt_for={{this.order_id}}" target="_blank" style="float: right;">Распечатать тов.чек</a>
      </div>
      {{#if this.user.name}}
      <div class="panel-heading">
          <b>{{this.user.name}}</br> {{this.user.phone_number}}</b> </br>{{#if this.user.personal_discount}}бонус от <b>{{this.user.personal_discount}}%</b>{{/if}}
      </div>
      {{/if}}
      <div class="panel-body">
        {{#each this.products}}
          <div class="row">
            <div class="col-md-3 mt10" style="float: left;">{{this.product_name}}</div>
            <div class="col-md-2 mt10" style="float: left;">{{this.sku}}</div>
            <div class="col-md-2 mt10" style="float: left;">{{this.color}}</div>
            <div class="col-md-2 mt10" style="float: left;">{{this.size}}</div>
            <div class="col-md-3 mt10" style="text-align: right; float: right;">{{this.price}}₽</div>
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

HandlebarsIntl.registerWith(Handlebars);
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
  $.get("/index.php?module=OfflineSales", {order_query: order_query, mtm: 1}, function(orders) {
    $order_list = orders;
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

delete_order = function(order_id) {
  if (!confirm('Вы уверены, что хотите удалить покупку?')) {
    return false;
  }
  $.get("/index.php?module=OfflineSales&delete_order_id="+order_id, function(res) {
    if (res == "OK") {
      $('div#order_'+order_id).hide();
    }
  });
}


$(document).on("click", "#send-button", function(e) {
  e.preventDefault();
  var data = $('#search-form').serializeJSON();
  post_order(data);
});

$(document).on("click", "#back-to-orders", function() {
  $('#order-list').show();
  $('#found-orders').hide();
  $("#order-input").val('');
});

</script>
{/literal}
