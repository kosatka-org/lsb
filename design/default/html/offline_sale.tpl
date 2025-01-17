<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/accounting.js/0.4.1/accounting.min.js"></script>

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

  .img-thumbnail {
    min-width: 60px;
    min-height: 60px;
  }
  </style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <div class="col-md-8">
          {if $order_id}
            <h2>Покупка №{$order_data->receipt_number}</h2>
          {/if}
          <h3>{$cashbox->name}</h3>
          <p>{$cashbox->description}</p>
        </div>
        <div class="col-md-4">
            <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        </div>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column">
      <div id="create-form" class="anchor mt20" style="display:none;">
        <!--Anchor for form-template-->
      </div>

      <h3>Товары</h3>
      <div class="row">
        <div class="col-md-2 mt10"></div>
        <div class="col-md-3 mt10">Наименование</div>
        <div class="col-md-2 mt10">Размер</div>
        <div class="col-md-2 mt10">Цена</div>
        <div class="col-md-2 mt10">Скидка(%)</div>
        <div class="col-md-1 mt10"></div>
      </div>
      <div id="product-list">
        <!--Anchor for orderProduct-template-->
      </div>
      <div class="total-order-info" style="margin-top: 25px; border-top: 1px solid #000; padding-top: 12px; text-align: right; font-size: 20px;">
        Всего: <span id="total-sum" style="font-weight: 700">0</span>₽
      </div>
      <div class="order-button-group mt20">
        <div style="float: left; margin-right: 24px;">
            <button id="order-button" type="button" class="btn btn-primary" disabled="disabled">Оформить покупку</button>
        </div>
        <div style="margin-top: 1px;">
            <b style="font-size: 22px;">{$cashbox->name}</b>
        </div>
      </div>

      <div id="payment-options" class="mt20">
      </div>

      <div id="payment-buttons" style="display: none;">
        <div style="width: 100%; float: left; clear: both;">
            <div style="float: left;">
                <button id="add-payment" class="btn btn-primary mt20">Добавить способ оплаты</button>
            </div>
            <div class="total-payment-info" style="text-align: right; float: right; margin-top: 25px;">
                Оплачено: <span id="total-paid" style="font-weight: 700"></span>₽ <span style="font-weight: 700; display: none;" id="total-sum2"></span>
            <br>
                К оплате: <span id="remaining" style="font-weight: 700"></span>₽
            </div>
        </div>
        <a id="get-receipt" class="btn btn-primary mt20" href="" target="_blank">Распечатать товарный чек</a>
        <button id="submit-payment" class="btn btn-danger mt20">Сохранить</button>
        <b class="mt20" style="font-size: 22px; display: inline-block; vertical-align: middle;">{$cashbox->name}</b>
      </div>
    </div>
    <div class="col-md-4" id="right-column">
      <div class="panel-group mt20" id="accordion" role="tablist" aria-multiselectable="true">

        {if $cashbox->name == "Индивидуальный пошив"}
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
        {/if}

        <div class="panel panel-default">
          <div class="panel-heading" role="tab" id="heading_users">
            <h4 class="panel-title">
              <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_users" aria-expanded="false" aria-controls="collapseOnecollapse_users">
                <b>Поиск клиента</b>
              </a>
            </h4>
          </div>
          <div id="collapse_users" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading_users">
            <div class="panel-body">
              <label>Телефон, номер карты или имя</label>
              <div class="input-group">
                <span id="user-refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
                <input id="user-input" type="text" class="form-control">
              </div>
              <div id="found-users" class="anchor">
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
<!-- Templates -->
<script id="product-template" type="text/x-handlebars-template">
  {{#each products}}
    <div class='row mt10 product-template'>
      <div class='col-md-8 mt20'>
        {{this.model}}, {{this.sku}}{{#if this.size}}, размер {{this.size}}{{/if}}{{#if this.color_name}}, {{this.color_name}}{{/if}}
      </div>
      <div class='col-md-4 mt20'>
        <button type='button' product-id='{{this.product_id}}' product-index='{{@index}}' style="float: right;" class='btn btn-default add-btn'>Добавить</button>
      </div>
    </div>
  {{/each}}
</script>

<script id="user-template" type="text/x-handlebars-template">
  {{#each users}}
    <div class='row mt10 user-template'>
      <div class='col-md-8 mt20'>{{this.name}}</div>
      <div class='col-md-4 mt10'>
        <button type='button' user-id='{{this.user_id}}' user-index='{{@index}}' class='btn btn-default user-select-btn' style="float: right;">Выбрать</button>
      </div>
    </div>
  {{/each}}
</script>

<script id="orderProduct-template" type="text/x-handlebars-template">
  <div class="row mt10">
    <div class="col-md-2">{{#if large_image}}<img class="img-thumbnail" src="/reimg/files/products/85x/{{large_image}}">{{/if}}</div>
    <div class="col-md-3 mt20"><b>{{model}}</b><br>артикул: {{sku}}</div>
    <div class="col-md-2 mt20"><input class="size" style="width: 100%;" data-product-barcode="{{barcode}}" type="text" value="{{size}}"></div>
    <div class="col-md-2 mt20">
      <input class="price-input" style="width: 100%;" data-product-barcode="{{barcode}}" type="number" step="100" value="{{price}}">
      <br>
      {{offline_price}}
    </div>
    <div class="col-md-2 mt20">
      <input class="discount-input" style="width: 100%;" data-product-barcode="{{barcode}}" type="number" step="10" min="0" max="100" value="{{discount}}">
    </div>
    {{#if_editable}}
      <div class="col-md-1 mt20">
        <button type="button" class="close remove-product off" aria-hidden="true" data-product-barcode="{{barcode}}">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </div>
    {{/if_editable}}
  </div>
</script>

<script id="orderMtm-template" type="text/x-handlebars-template">
  <div class="row mt10 mtm-item">
    <div class="col-md-5 mt20"><input class="name" style="width: 100%;" type="text"></div>
    <div class="col-md-2 mt20">
      <input class="price-input" style="width: 100%;" type="number" step="100" value="0">
    </div>
    {{#if_editable}}
      <div class="col-md-1 mt20">
        <button type="button" class="close remove-mtm off" aria-hidden="true">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </div>
    {{/if_editable}}
  </div>
</script>

<script id="selectedUser-template" type="text/x-handlebars-template">
  Покупатель:</br>
  <div class="row mt10" style="margin: 15px 0px;">
    <div class="col-md-11" style="padding-left: 0;">
        <div><b>{{name}}</b></div>
        <div class="mt20"><b>{{phone_number}}</b></div>
        <div class="mt20">{{#if personal_discount}}Бонус от <b>{{personal_discount}}%</b>{{/if}}</div>
    </div>
    {{#if_editable}}
      <div class="col-md-1">
        <button type="button" class="close remove-user off" aria-hidden="true">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </div>
    {{/if_editable}}
  </div>
</script>

<script id="payment-template" type="text/x-handlebars-template">
  <div class="form-inline payment-option mt20">
    <div class="form-group">
      <label for="payment-select">Способ оплаты</label>
      <select id="payment-select" class="form-control" onchange="payment_additional_input(this);">
        {{#each payment_options}}
          <option value="{{this.id}}" {{#if this.selected}}selected{{/if}}>{{this.name}}</option>
        {{/each}}
      </select>
    </div>
    <div class="form-group">
      <label for="payment-amount">Сумма</label>
      <input type="number" min="0" class="form-control payment-amount" value="{{#if payment}}{{payment.money_paid}}{{else}}{{remaining}}{{/if}}">
      <select class="form-control debt-responsible-user disabled" style="display: none;">
        {{#each responsible_users}}
          <option value="{{this.id}}" {{#if this.selected}}selected{{/if}}>{{this.name}}</option>
        {{/each}}
      </select>
      </span>
    </div>
    {{#if_editable}}
      <div class="form-group">
        <button type="button" class="close remove-payment off" aria-hidden="true">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </div>
    {{/if_editable}}
  </div>
</script>

<!-- /Templates -->

<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

Handlebars.registerHelper('if_editable', function(options) {
  if (editable()) {
    return options.fn(this);
  }
});

Handlebars.registerHelper('if_mtm', function(options) {
  if (order.cashbox_name == 'Индивидуальный пошив') {
    return options.fn(this);
  }
});

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var order = {products: {}};

{/literal}
var payment_options = JSON.parse('{$payment_options}');
var responsible_users = JSON.parse('{$cashbox->debt_users}');
order.cashbox_id = {$cashbox->id};
order.cashbox_name = {$cashbox->name};
{literal}
payment_options.forEach( function(e, i) {
  if (e.name === 'Долг') {
    payment_options[i].debt = true;
  }
});
var $product_list = [];
var $user_list = [];
var payment = {paid: 0, remaining: 0};
var product_query_running = false;
var product_query_queue = [];



editable = function() {
  if (typeof(order.date) === "undefined") {
    return true;
  }
  var orderDate = new Date(order.date);
  var todaysDate = new Date();
  return orderDate.setHours(0,0,0,0) == todaysDate.setHours(0,0,0,0);
};

mtm = function() {
  if (typeof(order.date) === "undefined") {
    return true;
  }
  var orderDate = new Date(order.date);
  var todaysDate = new Date();
  return orderDate.setHours(0,0,0,0) == todaysDate.setHours(0,0,0,0);
};

post_product = function(product_query) {
  if (product_query.length > 3) {
    if (product_query_running) {
      product_query_queue.push(product_query);
      return false;
    }
    product_query_running = true;
    product_query_queue = [];
    $.get("/index.php?module=OfflineSale", {product_query: product_query}, function(p_list) {
      $product_list = p_list;
      var u = Template.product({products: $product_list});
      $('#found-products').html(u);
      product_query_running = false;
      if (product_query_queue.length > 0) {
        post_product(product_query_queue.pop());
      }
      $('#found-products').show();
    });
  }
}

post_user = function(query) {
  if (query.length > 3) {
    $.get("/index.php?module=OfflineSale", {user_query: query}, function(u_list) {
      $user_list = u_list;
      var u = Template.user({users: $user_list});
      $('#found-users').html(u);
    });
  }
}

update_total = function(with_personal_discount) {
  prd = order.products;
  if (with_personal_discount) {
    discount = parseInt(order.user.personal_discount, 10);
    $(".discount-input").val(discount);
    Object.keys(prd).forEach(function (k) {
      prd[k].price = Math.ceil((prd[k].offline_price * ((100 - discount)/100)));
      $('.price-input[data-product-barcode="'+prd[k].barcode+'"]').val(prd[k].price);
      return prd[k];
    });
  }
  var total = Object.keys(prd)
    .map(function (k) {
      return parseInt(prd[k].price, 10);
    })
    .reduce( function(a,b) { return a + b; }, 0);
    total = accounting.formatNumber(total, 0, " ", " ");
  $('#total-sum, #total-sum2').html(total);
  $('#remaining').html(remaining());
}

display_payment = function(no_new_payments) {
  if (!no_new_payments) {
    var html = Template.payment({payment_options: payment_options, responsible_users: responsible_users, remaining: remaining()});
    $("#payment-options").html(html);
  }
  $("a#get-receipt").prop("href", "/index.php?module=OfflineSale&receipt_for="+order.order_id);
  $("#payment-buttons").show();
  update_payment();

}

update_payment = function() {
  total_paid = total_payment();
  $("#total-paid").html(accounting.formatNumber(total_paid, 0, " ", " "));
  $("#remaining").html(accounting.formatNumber(total_sum() - total_paid, 0, " ", " "));
}

update_discount = function() {
  $('.price-input').toArray().forEach(function(e) {
    var barcode = e.getAttribute("data-product-barcode");
    var product = order.products[barcode];
    var discount = Math.ceil((1 - (product.price/product.offline_price))*100);
    $('.discount-input[data-product-barcode="'+barcode+'"]').val(discount);
  });
}

total_payment = function() {
  return $(".payment-amount").toArray()
    .map(function(v) {
      return parseInt(v.value, 10);
    })
    .reduce(function(a,b) {
      return a + b;
     }, 0);
}

total_sum = function() {
  prd = order.products
  if (prd.length == 0) {
    return 0;
  }
  else if (prd[0] && prd[0].barcode == "") {
    return $(".price-input").toArray().map(function(el) {
      return parseInt(el.value, 10);
    }).reduce(function(a,b) {
      return a + b;
    }, 0);
  }
  else {
    return Object.keys(prd).map(function(k) {
        return parseInt(prd[k].price, 10);
      })
      .reduce(function(a,b) {
        return a + b;
       }, 0);
  }
}

remaining = function() {
  return total_sum()-total_payment();
}

// True if no products selected
btn_disabled = function() {
  return $.isEmptyObject(order.products);
}

render_existing_order = function(order) {
  var prd = {};
  order.products.forEach(function(product) {
    html = Template.orderProduct(product);
    $('#product-list').append(html);
    prd[product.barcode] = product;
    update_total();
  });
  order.products = prd;
  update_discount();
  if (order.user) {
    html = Template.selectedUser(order.user);
    $('#selected-user').html(html);
  }
  if (order.payments.length > 0) {
    order.payments.forEach(function(payment) {
      p_o = payment_options.map(function(e) {
        var a = {};
        if (e.id == payment.payment_id) {
          a.selected = true;
        }
        $.extend(a, e);
        return a;
      });
      html = Template.payment({payment_options: p_o, responsible_users: responsible_users, payment:payment});
      $("#payment-options").append(html);
    });
  }
  display_payment(true);
  $(".order-button-group").remove();
}

payment_additional_input = function(t) {
  var select = $(t).parents('.payment-option').find('.debt-responsible-user');
  if ( $(t).find('option:selected').html() === 'Долг' ) {
    select.show().removeClass('disabled');
  }
  else {
    select.hide().addClass('disabled');
  }
}

$(document).on("input", "#barcode-input", function() {
  post_product($(this).val());
});

$(document).on("click", "#refresh", function() {
  post_product($('#barcode-input').val());
});

$(document).on("input", "#user-input", function() {
  post_user($(this).val());
});

$(document).on("click", "#user-refresh", function() {
  post_user($('#user-input').val());
});

$(document).on("input", ".price-input", function() {
  var price = $(this).val();
  var barcode = $(this).attr("data-product-barcode");
  var product = order.products[barcode];
  var discount = ((product.offline_price - price) / product.offline_price)*100;
  product.price = price;
  update_total();
  update_discount();
});

$(document).on("input", ".discount-input", function() {
  var discount = $(this).val();
  var barcode = $(this).attr("data-product-barcode");
  var product = order.products[barcode];
  product.price = Math.ceil((product.offline_price * (100-discount)) / 100);
  update_total();
  $('.price-input[data-product-barcode="'+barcode+'"]').val(product.price);
});

$(document).on("input", ".payment-amount", function() {
  update_payment();
});

$(document).on('show.bs.collapse', '.collapse', function () {
  t = $(this);
  $current_set = {id: t.attr('item-id')};
})

$(document).on("click", ".add-btn", function() {
  t = $(this);
  var product_index = t.attr('product-index');
  var product = $product_list[product_index];
  if (order.user && order.user.personal_discount > 0) {
    product.discount = order.user.personal_discount;
    product.price = product.price * ((100 - order.user.personal_discount)/100);
  }
  else {
    product.discount = 0;
  }
  order.products[product.barcode] = product;
  var html = Template.orderProduct(product);
  $('#product-list').append(html);
  update_total();
  var product_rows = $('.product-template');
  product_rows.hide('fast');
  product_rows.remove();
  $product_list= [];
  $('#barcode-input').val('');
  $('#barcode-input').focus();
});

$(document).on("click", ".user-select-btn", function() {
  t = $(this);
  var user_index = t.attr('user-index');
  var user = $user_list[user_index];
  order.user = user;
  var html = Template.selectedUser(user);
  $('#selected-user').html(html);
  var user_rows = $('.user-template');
  user_rows.hide('fast');
  user_rows.remove();
  $user_list = [];
  update_total(true);
  $('#user-input').val('');
});

$(document).on('click', '.remove-product', function() {
  t = $(this);
  var barcode = $(this).attr("data-product-barcode");
  delete order.products[barcode];
  t.parent().parent().remove();
  update_total();
});

$(document).on('click', '.remove-user', function() {
  delete order.user;
  $("#selected-user").html('');
});


$(document).on("click", "#order-button", function(e) {
  var t = $(this);
  e.preventDefault();
  $.post('/index.php?module=OfflineSale', {order: JSON.stringify(order) }, function(data) {
    order.order_id = data;
    window.history.pushState("orderEditable", "Editable order page", "index.php?module=OfflineSale&order_id="+order.order_id);
    t.parent().remove();
    display_payment();
    // $("#product-list input").prop("disabled", true);
    // $("#right-column").hide('fast');
    // $(".remove-user, .remove-product").remove();
  });
});

$(document).on('click', '#add-payment', function() {
  var html = Template.payment({payment_options: payment_options, responsible_users: responsible_users, remaining: remaining()});
  $("#payment-options").append(html);
  update_payment();
});

$(document).on('click', '.remove-payment', function() {
  $(this).parents("div.payment-option").remove();
  update_payment();
});

$(document).on('click', '#submit-payment', function() {
  var t = $(this);
  if ($('option:selected').toArray().map(function(e) { return e.innerHTML; }).indexOf("Долг") !== -1 && order.user === undefined) {
    alert("Укажите клиента, берущего в долг.");
    return false;
  }
  if (remaining() < 0) {
    alert("Сумма оплаты не должна превышать стоимость товаров.");
    return false;
  }
  order.payments = $('.payment-option').toArray().map(function(e) {
    var id = $(e).find("option:selected").val();
    var money_paid = $(e).find(".payment-amount").val();
    var select = $(e).find(".debt-responsible-user");
    if ( select.hasClass('disabled') ) {
      var responsible_user_id = 0;
    }
    else {
      var responsible_user_id = select.val();
    }
    var money_paid = $(e).find(".payment-amount").val();

    return {payment_id: id, money_paid: money_paid, responsible_user_id: responsible_user_id, cashbox_id: order.cashbox_id};
  });
  console.log(payment);
  $.post('/index.php?module=OfflineSale', {order: JSON.stringify(order) }, function(data) {
    t.removeClass("btn-danger").addClass("btn-success").html("Сохранено");
  });
});

$(document).on("click", ".btn, button", function() {
  $("#order-button").prop("disabled", btn_disabled());
});

{/literal}

{if $order}
  var order = JSON.parse('{$order}');
  order.cashbox_id = {$cashbox->id};
  render_existing_order(order);
{/if}

{literal}

if (!editable()) {
  $('#add-payment').addClass("disabled");
  $('#submit-payment').addClass("disabled");
}
{/literal}
</script>
