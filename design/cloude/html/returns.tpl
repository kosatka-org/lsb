<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/locale/ru.js"></script>
<script src="/js/are_you_ie.js"></script>

<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.4">

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
                <span><a href="index.php?module=OfflineSales&debts=1">Задолженности</a></span>
                <span>&nbsp;/&nbsp;
                <span>Возвраты</span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&calls=1">Клиенты</a></span>
        </div>
{/if}
        <!-- /Вкладки /-->
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
    </div>
  </div>
  <div class="row">
    <h3></h3>
  </div>
  <div class="row">
    <div class="col-md-6" id="right-column" style="padding-left: 0;">
      <label>Поиск покупки <span style="font-weight: normal">(номер покупки, номер чека, фамилия или телефон клиента)</span></label>
      <div class="input-group" style="margin:0 0 15px 0;">
        <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
        <input id="order-input" type="text" class="form-control" placeholder="Введите номер покупки" autofocus>
      </div>
      <div class="form-group">
        <label for="date_start">Дата </label>
        <input type="text" name="date" class="form-control ShAA_inputDate user-input" id="date" value="{$date}" style="width: 50%;display: inline-block;" placeholder="ГГГГ-ММ-ДД">
      </div>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      <div id="found-orders">
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="order-template" type="text/x-handlebars-template">
  <h2>Результаты поиска</h2>
  <button type='button' id="back-to-orders" class='btn btn-default' style="display: none;">Назад к списку покупок</button>
  {{#each orders}}
    <div class="panel panel-default mt10">
      <div class="panel-heading">
       Покупка №<b>{{this.receipt_number}}</b> {{this.cashbox_name}} - {{formatDate this.date}}
       <a href="/index.php?module=OfflineSale&order_id={{this.order_id}}&return=1" target="_blank" style="float: right;">Оформить возврат</a>
      </div>
      {{#if this.user.name}}
      <div class="panel-heading">
          <b>{{this.user.name}}</br> {{this.user.phone_number}}</b> </br>{{#if this.user.personal_discount}}бонус от <b>{{this.user.personal_discount}}%</b>{{/if}}
      </div>
      {{/if}}
      <div class="panel-body">
        {{#each this.products}}
          <div class="row ShAA_orderItemsOff">
            <div class="col-md-3 mt10">{{this.product_name}}</div>
            <div class="col-md-2 mt10">{{this.sku}}</div>
            <div class="col-md-2 mt10">{{this.color}}</div>
            <div class="col-md-2 mt10">{{this.size}}</div>
            <div class="col-md-3 mt10" style="text-align: right;">{{formatMoney this.price}}₽</div>
          </div>
        {{/each}}
        <div class="row">
          <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Всего: <b>{{formatMoney this.total_sum}}</b>₽</div>
        </div>
      </div>
    </div>
  {{/each}}
</script>

<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

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

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var order_query_running = false;
var order_query_queue = [];
var $order_list = [];

post_order = function(order_query, date) {
  if (order_query_running) {
    order_query_queue.push(order_query);
    return false;
  }
  order_query_running = true;
  order_query_queue = [];
  $.get("/index.php?module=OfflineSales", {order_query: order_query, date: date, all_cashboxes: 1}, function(orders) {
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


$(document).on("input", "#order-input", function() {
  post_order($(this).val(),$('#date').val());
});
$(document).on("input", "#date", function() {
  post_order($("#order-input").val(),$(this).val());
});

$(document).on("click", "#back-to-orders", function() {
  $('#order-list').show();
  $('#found-orders').hide();
  $("#order-input").val('');
  $('#date').val('');
});

</script>
{/literal}
