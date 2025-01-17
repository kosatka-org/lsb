{include file="offline_js.tpl"}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-12" id="left-column" style="padding-left: 0;">

      <h3>Последние продажи</h3>
      <div class="input-group">
        <form class="form-inline">
          <div class="form-group ShAA_fromService" style="overflow:hidden;">
            <label for="date_from" style="float:left;margin:6px 5px 0 0;">От </label>
            <input type="text" name="date_from" class="form-control ShAA_inputDate" id="date_from" value="{$date_from}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
          <div class="form-group ShAA_toService" style="overflow:hidden;">
            <label for="date_to" style="float:left;margin:6px 5px 0 0;">До </label>
            <input type="text" name="date_to" class="form-control ShAA_inputDate" id="date_to" value="{$date_to}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
          <div class="form-group">
            <label for="query" style="float:left;margin:6px 5px 0 0;">Имя/Телефон</label>
            <input type="text" class="form-control" id="query" name="query" style="width: 60%;">
          </div>
          <a class="btn btn-primary" id="date_search" href="#" role="button" style="padding: 6px 12px;margin:1px 0 0;">Поиск</a>
        </form>
      </div>
      <div id="order-list">

      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="order-template" type="text/x-handlebars-template">
  <div class="panel panel-default mt10">
    <div class="panel-heading">
      Покупка №<b>{{receipt_number}}</b>: {{name}} - {{phone}} / {{#if cashbox}} {{cashbox.name}} - {{cashbox.shop.name}} {{/if}} - {{formatDate date}}
    </div>
    <div class="panel-body">
      {{#each order_products}}
        <div class="row ShAA_salesItemOff">
          <div class="col-md-3 mt10">{{product_name}}</div>
          <div class="col-md-2 mt10">{{sku}}</div>
          <div class="col-md-2 mt10">{{color}}</div>
          <div class="col-md-2 mt10">{{size}}</div>
          <div class="col-md-3 mt10" style="text-align: right;">{{formatMoney price}}</div>
        </div>
      {{/each}}
      <div class="row">
        <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Всего: <b>{{formatMoney total_sum}}</b></div>
      </div>
      {{#if offline_payments}}
        <b>Оплата</b><br>
        {{#each offline_payments}}
          <div class="row ShAA_salesItemOff">
            <div class="col-md-3 mt10">{{payment_type.name}}</div>
            <div class="col-md-2 mt10">{{formatDate date}}</div>
            <div class="col-md-2 mt10">{{color}}</div>
            <div class="col-md-2 mt10">{{size}}</div>
            <div class="col-md-3 mt10" style="text-align: right;">{{formatMoney money_paid}}</div>
          </div>
        {{/each}}
      {{/if}}
    </div>
  </div>
</script>


<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

$.ajaxSetup({ cache: false });

moment.locale('ru');

Handlebars.registerHelper('formatDate', function(date) {
  return moment(date, "YYYY-MM-DD HH:mm Z").format("Do MMMM YYYY, H:mm");
});

Handlebars.registerHelper('formatMoney', function(n) {
  return new Intl.NumberFormat('ru-RU', { style: 'currency', currency: 'RUB',
   maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(Number(n));
});

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

function getOrders() {
  $.getJSON("/rest_api/offline_orders", {date_from: $('#date_from').val(), date_to: $('#date_to').val(), query: $('#query').val()}, function(orders) {
    $('#order-list').empty();
    orders.forEach(function(order) {
      order.total_sum = order.order_products.map( el => el.price ).reduce( (a,v) => a + v );
      var u = Template.order(order);
      $('#order-list').append(u);
    });
  });
}

$(document).on("click", "#date_search", function(e) {
  e.preventDefault();
  getOrders();
});

getOrders();

</script>
{/literal}
