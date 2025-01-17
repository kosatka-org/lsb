<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
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

  .checkbox-inline, .radio-inline {
    margin-right: 10px;
    margin-bottom: 10px;
  }

  .checkbox-inline+.checkbox-inline, .radio-inline+.radio-inline {
    margin-left: 0;
  }

  .ShAA_miniStatusMob {
    font-weight: normal;
  }

@media (max-width: 770px) {
  .ShAA_ipadLowerCase {
    font-weight: 500;
    text-transform: lowercase;
  }
  .panel-body, .panel-heading span {
    display: none;
  }

}
@media (max-width: 767px) {
  .ShAA_fromService {
    float: left;
    width: 46%;
    margin-right: 8%;
  }

  .ShAA_toService {
    float: left;
    width: 46%;
  }
  .ShAA_serviceDate, .ShAA_miniStatusMob {
    display: none;
  }

  .ShAA_inputDate {
    float: right;
    margin-top: -6px;
    width: 80%;
  }
}
  </style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -32px;">
        <div class="col-md-8" style="float: left; width: 60%; text-align: right;">
          <h3>Заказы на услуги</h3>
        </div>
        <div class="col-md-4">
            <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        </div>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column">
      <div class="order-button-group mt20">
        <div>
            <a href="/index.php?module=Service" target="_blank" class="btn btn-primary">Новый заказ на услуги</a>
        </div>
      </div>
      <br>

      <div>
      <div class="form-group" style="width: 60%;float:left;">
        <label>Поиск заказов на услуги</label>
        <input id="order-input" type="text" class="form-control" placeholder="Введите данные" autofocus>
      </div>
      <div class="form-group" style="width: 35%; margin-left:5%;float:left;">
        <label for="cashbox-select">Магазин</label>
        <select class="form-control cashbox-id" id="shop_id">
          {foreach from=$shops item=s}<option value="{$s->shop_id}">{$s->name}</option>{/foreach}
        </select>
      </div>
      </div>
      <br>
      <label class="ShAA_serviceDate">Поиск заказов на услуги за время</label>
      <form class="form-inline">
        <div class="form-group ShAA_fromService">
          <label for="date_start">От </label>
          <input type="text" name="date_start" class="form-control ShAA_inputDate" id="date_start" value="{$date_start}" placeholder="ГГГГ-ММ-ДД">
        </div>
        <div class="form-group ShAA_toService">
          <label for="date_end">До </label>
          <input type="text" name="date_end" class="form-control ShAA_inputDate" id="date_end" value="{$date_end}" placeholder="ГГГГ-ММ-ДД">
        </div>
        <a class="btn btn-primary" id="date_search" href="#" role="button" style="padding: 6px 12px;margin-bottom: 0;">Поиск</a>
      </form>
      <br>
      <label class="ShAA_serviceDate">Статус</label>
      <br>
      {foreach from=$status_options item=st}
        <label class="checkbox-inline ShAA_callsCashboxesTitle">
          <input type="checkbox" class="service-input status-chk" value="{$st}">{$st}
        </label>
      {/foreach}
      <div class="clear"></div>
      <br>

      <label class="ShAA_serviceDate">Тип заказа</label>
      <br>
      {foreach from=$order_types item=ot_name key=ot_key}
        <label class="checkbox-inline ShAA_callsCashboxesTitle">
          <input type="checkbox" class="service-input type-chk" value="{$ot_key}">{$ot_name}
        </label>
      {/foreach}
      <div class="clear"></div>
      <br>

      <div id="order-list">
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

<script id="data-services" type="application/json">
  {$services}
</script>

{literal}
<script id="orders-template" type="text/x-handlebars-template">
  {{#each orders}}
    <div class="panel panel-default">
      <div class="panel-heading" onClick="if ($('body').width() < 769) {$(this).next('div').toggle();$(this).find('span').toggle();}">
        Заказ №<b> {{this.id}}</b>
        <span>&nbsp;&nbsp;&nbsp;(<a href="/index.php?module=Service&service_order_id={{this.id}}" target="_blank">Изменить</a> / <a href="/index.php?module=OfflineSale&order_id={{this.real_order_id}}" target="_blank">Оплата</a>{{#if this.redactable}} / <a href="/index.php?module=Service&service_list=1&delete_service_order_id={{this.id}}" onclick="return confirm('Вы уверены, что хотите удалить заказ?')">Удалить</a>{{/if}})</span>
        <br/>
        <b>{{this.user.name}}</b>
        <span> <b><a href="tel:{{this.user.phone_number}}">{{this.user.phone_number}}</a></b>
          <a href="/index.php?module=OfflineSale&act={{this.real_order_id}}" target="_blank" style="float: right;">/ акт</a>
          <a href="/index.php?module=OfflineSale&receipt_for={{this.real_order_id}}" target="_blank" style="float: right;">чек&nbsp;</a>
        </span>
        <br>
        {{this.w_date}}{{#if this.manager_id}}, менеджер <b>{{this.manager}}</b>{{/if}}
      </div>
      <div class="panel-body">
        {{#each this.items}}
          <div class="row">
            <div class="col-md-6 col-sm-4 mt10" style="float: left;">
              {{#if this.product_name}}
                <b>Товар</b>:{{this.product_name}}<br>
              {{/if}}
              {{#if this.product_name}}
                <b>Дефект</b>:{{this.defect_description}}<br>
              {{/if}}
              {{this.name}}
            </div>
            <div class="col-md-3 col-sm-4 mt10" style="float: left;">{{#if this.status}} {{this.status}}{{/if}}</div>
            <div class="col-md-3 col-sm-4 mt10" style="text-align: right;color:{{#if this.payment_id}}green{{else}}{{#if this.price}}red{{/if}}{{/if}};">{{this.price}} ₽</div>
          </div>
        {{/each}}
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

var orders = JSON.parse(document.getElementById('data-services').innerHTML);
render_orders(orders);
var order_query_running = false;
var order_query_queue = [];

function render_orders(orders) {
  var html = Template.orders({orders: orders});
  $('#order-list').html(html);
}

post_order = function() {
  var order_query = $("#order-input").val();
  if (order_query_running) {
    order_query_queue.push(order_query);
    return false;
  }
  order_query_running = true;
  order_query_queue = [];
  var order_filter = {};
  order_filter.status = $('.status-chk:checked').toArray().map(function(e){ return e.value; });
  order_filter.type = $('.type-chk:checked').toArray().map(function(e){ return e.value; });
  var date_start = $("#date_start").val();
  var date_end = $("#date_end").val();
  var shop_id = $("#shop_id").val();
  $.get("/index.php?module=Service", {service_list: 1, order_query: order_query, order_filter: JSON.stringify(order_filter), date_start: date_start, date_end: date_end, shop_id: shop_id}, function(orders) {
    render_orders(orders);
    console.log(orders);
    order_query_running = false;
    if (order_query_queue.length > 0) {
      post_order(order_query_queue.pop());
    }
  });
}


$(document).on("input", "#order-input", function() {
  var q = $(this).val();
  if (q.length > 2) {
    post_order();
  }
  else {
    services = JSON.parse(document.getElementById('data-services').innerHTML);
    render_orders(services);
  }
});

$(document).on("change", ".service-input", function() {
  post_order();
});
$(document).on("click", "#date_search", function(e) {
  e.preventDefault();
  post_order();
});

</script>

{/literal}
