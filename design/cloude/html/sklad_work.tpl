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
    <label>Поиск продукта</label>
      <div class="input-group">
        <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
        <input id="product-input" type="text" class="form-control" placeholder="Введите ID, Артикул, или название" autofocus>
      </div>
    </div>
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      <div id="found-orders">
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="order-template" type="text/x-handlebars-template">
  {{#each orders}}
    <div class="panel panel-default mt10">
      <div class="panel-heading">
       Товар ID <b>{{this.product_id}}</b>
       <a href="/products/{{this.url}}/" target="_blank" style="float: right;">страница</a>
      </div>
      <div class="panel-heading" style="overflow:hidden;">
          {{#if this.image}}<img src="/reimg/files/products/120x/{{this.large_image}}" style="float:left; margin-right:10px;">{{/if}}
          <div class="ShAA_salesItemOff">
            <div style="float: left;margin-right: 20px;">
              <b>{{this.model}}</br>
              {{this.model_full}}</b> </br>
              Артикул {{this.sku}}</br>
              Сезон: {{this.season}}</b></br>
            </div>
            <div style="float: left; margin-top:40px;">
              Категория: {{this.category_name}}</b></br>
              Бренд: {{this.brand_name}}</b>
            </div>
          </div>
      </div>
      <div class="panel-body">
        {{#if this.items}}
          <div class="row ShAA_salesItemOff">
            <div class="col-md-2 mt10">Штрихкод</div>
            <div class="col-md-2 mt10">Размер/Система</div>
            <div class="col-md-2 mt10">Кол-во</div>
            <div class="col-md-3 mt10">Склад</div>
            <div class="col-md-3 mt10">Магазин</div>
          </div>
          {{#each this.items}}
            <div class="row ShAA_salesItemOff">
              <div class="col-md-2 mt10">{{this.barcode}}</div>
              <div class="col-md-2 mt10">{{this.size}} / {{this.size_system}}</div>
              <div class="col-md-2 mt10">{{this.quantity}}</div>
              <div class="col-md-3 mt10">{{this.warehouse_name}}</div>
              <div class="col-md-3 mt10">{{this.shop_name}}</div>
            </div>
            {{#if this.movements}}
              <a href="#" class='movement_toggle'><span>показать</span><span style='display:none;'>спрятать</span> перемещения</a>
              <div class="ShAA_salesItemOff" style='display:none; border:1px solid #ccc; padding: 10px;'>
                <div class="row ShAA_salesItemOff">
                  <div class="col-md-1 mt10">Номер</div>
                  <div class="col-md-2 mt10">Дата</div>
                  <div class="col-md-3 mt10">Со склада</div>
                  <div class="col-md-3 mt10">На склад</div>
                  <div class="col-md-2 mt10">Ответственный</div>
                </div>
                {{#each this.movements}}
                  <div class="row ShAA_salesItemOff">
                    <div class="col-md-1 mt10">{{this.movement_id}}</div>
                    <div class="col-md-2 mt10">{{this.date}}</div>
                    <div class="col-md-3 mt10">{{this.warehouse_from_name}}</div>
                    <div class="col-md-3 mt10">{{this.warehouse_to_name}}</div>
                    <div class="col-md-2 mt10">{{this.resp_name}}</div>
                  </div>
                {{/each}}
               </div>
            {{/if}}
          {{/each}}
        {{/if}}
      </div>
      {{#if this.sales}}
        <div class="panel-footer">
          <div class="row ShAA_salesItemOff">
              <div class="col-md-1 mt10">Заказ</div>
              <div class="col-md-2 mt10">Штрихкод</div>
              <div class="col-md-2 mt10">Размер/Система</div>
              <div class="col-md-2 mt10">Дата</div>
              <div class="col-md-2 mt10">Касса</div>
              <div class="col-md-3 mt10">Магазин</div>
            </div>
          {{#each this.sales}}
            <div class="row ShAA_salesItemOff">
              <div class="col-md-1 mt10">{{this.order_id}}</div>
              <div class="col-md-2 mt10">{{this.barcode}}</div>
              <div class="col-md-2 mt10">{{this.i_size}} / {{this.size_system}}</div>
              <div class="col-md-2 mt10">{{this.date}}</div>
              <div class="col-md-2 mt10"><nobr>{{this.cashbox_name}}</nobr></div>
              <div class="col-md-3 mt10">{{#if this.shop_name}}{{this.shop_name}}{{else}}Интернет-магазин{{/if}}</div>
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

post_order = function(product_query) {
  if (order_query_running) {
    order_query_queue.push(product_query);
    return false;
  }
  order_query_running = true;
  order_query_queue = [];
  $.get("/index.php?module=OfflineSales&sklad=1", {product_query: product_query}, function(orders) {
    $order_list = orders;
    console.log($order_list);
    var u = Template.order({orders: $order_list});
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


$(document).on("input", "#product-input", function() {
  if ($(this).val().length > 5){
    post_order($(this).val());
  }
});
$(document).on("click", ".movement_toggle", function(e) {
  e.preventDefault();
  $(this).find('span').toggle();
  $(this).next().slideToggle();
});

</script>
{/literal}
