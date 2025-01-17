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
                <span>Перемещения</span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&debts=1">Задолженности</a></span>
        </div>
{/if}
        <!-- /Вкладки /-->
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column" style="padding-left: 0;">

      <h3>Список перемещаемых товаров</h3>
      <div class="row">
        <div class="col-md-2 mt10"></div>
        <div class="col-md-3 mt10">Наименование</div>
        <div class="col-md-2 mt10">Расположение</div>
        <div class="col-md-1 mt10">Размер</div>
        <div class="col-md-2 mt10">Количество</div>
        <div class="col-md-1 mt10">Цена</div>
        <div class="col-md-1 mt10"></div>
      </div>
      <div id="product-list">
        <!--Anchor for product-template-->
      </div>

      <div id="movement-buttons" style="display: none;">
        <a id="get-receipt" class="btn btn-primary mt20 disabled" href="" target="_blank">Распечатать накладную</a>
        <button id="submit-movement" class="btn btn-warning mt20">Сохранить</button>
        <a href="" onclick="return confirm('Вы уверены, что хотите удалить перемещение?')" id="delete-movement" class="btn btn-danger mt20 disabled">Удалить</a>
      </div>

      <div id="found-orders">
      </div>
    </div>
    <div class="col-md-4" id="right-column">
        <div class="panel-group mt20" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="heading_products">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_products" aria-expanded="true" aria-controls="collapseOnecollapse_products">
                            <b>Поиск товара</b>
                        </a>
                    </h4>
                </div>
                <div id="collapse_products" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading_products">
                    <div class="panel-body">
                        <label>Штрихкод или артикул</label>
                        <div class="input-group">
                            <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
                            <input id="barcode-input" type="text" class="form-control" placeholder="Введите штрихкод или артикул" autofocus>
                        </div>
                        <div id="found-products" class="anchor">
                            <!--Anchor for user-template-->
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="heading_users">
                <h4 class="panel-title">
                  <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_users" aria-expanded="false" aria-controls="collapseOnecollapse_users">
                    <b>Откуда &rarr; куда</b>
                  </a>
                </h4>
                </div>
                <div id="collapse_users" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading_users">
                    <div class="panel-body">
                      <label>Склад (исходное месторасположение)</label>
                      <select id="shop_from">
                        <option>Выберите склад</option>
                        {foreach from=$warehouses_from item=wh}
                          <option value="{$wh->warehouse_id}">{$wh->name}</option>
                        {/foreach}
                      </select></br></br>
                      <label>Склад назначения</label></br>
                      <select id="shop_to">
                        <option>Выберите склад</option>
                        {foreach from=$warehouses_to item=wh}
                          <option value="{$wh->warehouse_id}">{$wh->name}</option>
                        {/foreach}
                      </select>
                    </div>
                </div>
            </div>
        </div>
    </div>

  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="foundProduct-template" type="text/x-handlebars-template">
  {{#each products}}
    <div class='row mt10 product-template'>
      <div class='col-md-8 mt20'>
        {{this.model}}, арт {{this.sku}}, размер {{this.size}}, цвет {{this.color_name}} - <b>{{this.shop_name}}</b>
      </div>
      <div class='col-md-4 mt20'>
        <button type='button' product-id='{{this.product_id}}' product-index='{{@index}}' style="float: right;" class='btn btn-default add-btn'>Добавить</button>
      </div>
    </div>
  {{/each}}
</script>

<script id="product-template" type="text/x-handlebars-template">
  <div class="row mt10">
    <div class="col-md-2">
        {{#if large_image}}<img src="/reimg/files/products/85x/{{this.large_image}}">{{/if}}
    </div>
    <div class="col-md-3 mt20"><b>{{model}}</b><br>артикул: {{sku}}<br>цвет: {{color_name}}</div>
    <div class="col-md-2 mt20">{{shop_name}}</div>
    <div class="col-md-1 mt20">{{size}}</div>
    <div class="col-md-2 mt20"><input type="number" class="quantity-input" data-product-barcode="{{barcode}}" min="1" max="100" style="width:60%" value="{{quantity}}"></div>
    <div class="col-md-1 mt20">{{offline_price}}</div>
    <div class="col-md-1 mt20">
      <button type="button" class="close remove-product off" aria-hidden="true" data-product-barcode="{{barcode}}">
        <span class="glyphicon glyphicon-remove"></span>
      </button>
    </div>
  </div>
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

var $product_list = [];
var movement = {products: {}};
var product_query_running = false;
var product_query_queue = [];


post_product = function(product_query) {
  if (product_query.length > 3) {
    if (product_query_running) {
      product_query_queue.push(product_query);
      return false;
    }
    product_query_running = true;
    product_query_queue = [];
    $.get("/index.php?module=OfflineSale", {product_query: product_query, movement: 1}, function(p_list) {
      $product_list = p_list;
      var u = Template.foundProduct({products: $product_list});
      $('#found-products').html(u);
      product_query_running = false;
      if (product_query_queue.length > 0) {
        post_product(product_query_queue.pop());
      }
      $('#found-products').show();
    });
  }
}

render_movement = function(movement) {
  $.each(movement.products, function(index, product) {
    html = Template.product(product);
    $('#product-list').append(html);
  });
  $('#shop_from').val(movement.shop_from);
  $('#shop_to').val(movement.shop_to);
  $("#movement-buttons").show();
  $("a#get-receipt").prop("href", "/index.php?module=OfflineSale&movement_receipt_for="+movement.movement_id);
  $("a#get-receipt").removeClass("disabled");
  $("a#delete-movement").prop("href", "/index.php?module=OfflineSales&movement_list=1&delete_movement_id="+movement.movement_id);
  $("a#delete-movement").removeClass("disabled");
}

$(document).on("input", "#barcode-input", function() {
  post_product($(this).val());
});

$(document).on("click", ".add-btn", function() {
  t = $(this);
  var product_index = t.attr('product-index');
  var product = $product_list[product_index];
  movement.products[product.barcode] = product;
  var html = Template.product(product);
  $('#product-list').append(html);
  t.parent().parent().remove();
  $("#movement-buttons").show();
  $('#barcode-input').val('');
  $('#barcode-input').focus();
});

$(document).on('click', '.remove-product', function() {
  t = $(this);
  var barcode = $(this).attr("data-product-barcode");
  delete movement.products[barcode];
  t.parent().parent().remove();
});

$(document).on("input", ".quantity-input", function() {
  var barcode = $(this).attr("data-product-barcode");
  var product = movement.products[barcode];
  product.quantity = $(this).val();
});

$(document).on("change", "#shop_from", function() {
  movement.shop_from = $(this).val();
});

$(document).on("change", "#shop_to", function() {
  movement.shop_to = $(this).val();
});

$(document).on('click', '#submit-movement', function() {
  if (typeof(movement.shop_from) === "undefined" || typeof(movement.shop_to) === "undefined") {
    alert("Выберите склад отправки и назначения");
    return false;
  }
  var t = $(this);
  movement.shop_from = $("#shop_from").val();
  movement.shop_to = $("#shop_to").val();
  $.post('/index.php?module=OfflineSales', {movement: JSON.stringify(movement) }, function(data) {
    movement.movement_id = data;
    t.removeClass("btn-danger").addClass("btn-success").html("Сохранено");
    $("a#get-receipt").prop("href", "/index.php?module=OfflineSale&movement_receipt_for="+data);
    $("a#get-receipt").removeClass("disabled");
    $("a#delete-movement").prop("href", "/index.php?module=OfflineSales&movement=1&movement_id="+data+"delete_movement_id="+data);
    $("a#delete-movement").removeClass("disabled");
  });
});

{/literal}
{if $movement_object}
  movement = JSON.parse('{$movement_object}');
  render_movement(movement);
{/if}
</script>
