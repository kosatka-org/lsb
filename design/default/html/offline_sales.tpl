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
                <span>Покупки</span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&movement=1">Перемещения</a></span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&debts=1">Задолженности</a></span>
        </div>
{/if}
        <!-- /Вкладки /-->
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20"><a href="https://www.youtube.com/embed/iT6G2z1HAb0" target="_blank">Видео инструкция</a></div>
    </div>
  </div>
  <div class="row">
    <h3>Новая покупка - выберите кассу</h3>
    {foreach from=$cashboxes_select item=cbox}
      <a class="btn btn-primary btn-lg" style="margin:5px 0;" href="/index.php?module=OfflineSale&cashbox_id={$cbox->id}" target="_blank">{$cbox->name}</a>
    {/foreach}
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      <h3>Список покупок</h3>
      <div id="order-list">
        {foreach from=$orders item=order}
          <div class="panel panel-default">
            <div class="panel-heading">
             Покупка №<b> {$order->receipt_number}</b> ({$order->cashbox_name})&nbsp;&nbsp;-&nbsp;&nbsp;{$order->date|date_format:"%Y/%m/%d, %H:%M"} (<a href="/index.php?module=OfflineSale&order_id={$order->order_id}" target="_blank">Изменить</a> / <a href="/index.php?module=OfflineSales&delete_order_id={$order->order_id}" onclick="return confirm('Вы уверены, что хотите удалить покупку?')">Удалить</a>)
             <a href="/index.php?module=OfflineSale&receipt_for={$order->order_id}" target="_blank" style="float: right;">Распечатать товарный чек</a>
            </div>
            {if $order->user}
                <div class="panel-heading">
                    <b>{$order->user->name}</br> {$order->user->phone_number}</b> </br>{if $order->user->personal_discount} бонус от <b>{$order->user->personal_discount}%{/if}</b>
                </div>
            {/if}
            <div class="panel-body">
              {foreach from=$order->products item=product}
                <div class="row">
                  <div class="col-md-3 mt10"><b>{$product->product_name}</b></div>
                  <div class="col-md-2 mt10">{$product->sku}</div>
                  <div class="col-md-2 mt10">{$product->color}</div>
                  <div class="col-md-2 mt10">{$product->size}</div>
                  <div class="col-md-3 mt10" style="text-align: right;">{$product->price|number_format:0:",":" "}₽</div>
                </div>
              {/foreach}
              <div class="row">
                <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Всего: <b>{$order->total_sum|number_format:0:",":" "}</b>₽</div>
                {if $order->total_unpaid > 0}
                  <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Не расписано: <span style="color: red;">{$order->total_unpaid|number_format:0:",":" "}₽</span></div>
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
      <label>Поиск покупки</label>
      <div class="input-group">
        <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
        <input id="order-input" type="text" class="form-control" placeholder="Введите номер покупки" autofocus>
      </div>

      <h3>Отчет за день</h3>
      <div>
        <div class="row">
          <div class="col-md-6"><b>Общая стоимость товаров</b>:</div>
          <div class="col-md-6" style="text-align: right;">{$price_sum|number_format:0:",":" "}</div>
        </div>
        {if $uncommitted > 0}
        <div class="row">
          <div class="col-md-6"><b>Не расписанная стоимость</b>:</div>
          <div class="col-md-6" style="text-align: right;color: red;">{$uncommitted|number_format:0:",":" "}</div>
        </div>
        {/if}
        <div class="row">
          <div class="col-md-6"><b>Итого по всем формам оплаты</b>:</div>
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
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="order-template" type="text/x-handlebars-template">
  <h2>Результаты поиска</h2>
  <button type='button' id="back-to-orders" class='btn btn-default'>Назад к списку покупок</button>
  {{#each orders}}
    <div class="panel panel-default mt10">
      <div class="panel-heading">
       Покупка №<b>{{this.order_id}}</b> {{this.cashbox_name}} - {{this.date}} (<a href="/index.php?module=OfflineSale&order_id={{this.order_id}}" target="_blank">Изменить</a>)
       <a href="/index.php?module=OfflineSale&receipt_for={{this.order_id}}" target="_blank" style="float: right;">Распечатать товарный чек</a>
      </div>
      {{#if this.user.name}}
      <div class="panel-heading">
          <b>{{this.user.name}}</br> {{this.user.phone_number}}</b> </br>{{#if this.user.personal_discount}}бонус от <b>{{this.user.personal_discount}}%</b>{{/if}}
      </div>
      {{/if}}
      <div class="panel-body">
        {{#each this.products}}
          <div class="row">
            <div class="col-md-3 mt10">{{this.product_name}}</div>
            <div class="col-md-2 mt10">{{this.sku}}</div>
            <div class="col-md-2 mt10">{{this.color}}</div>
            <div class="col-md-2 mt10">{{this.size}}</div>
            <div class="col-md-3 mt10" style="text-align: right;">{{this.price}}₽</div>
          </div>
        {{/each}}
        <div class="row">
          <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Всего: <b>{{this.total_sum}}</b>₽</div>
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
  $.get("/index.php?module=OfflineSales", {order_query: order_query}, function(orders) {
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


$(document).on("input", "#order-input", function() {
  post_order($(this).val());
});

$(document).on("click", "#back-to-orders", function() {
  $('#order-list').show();
  $('#found-orders').hide();
  $("#order-input").val('');
});

</script>
{/literal}
