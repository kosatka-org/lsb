{include file="offline_js.tpl"}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <!-- Вкладки /-->
{if ($smarty.session.user->group_id == 9 || $smarty.session.user->group_id == 2) && !$confirmation}
        <div class="ShAA_kassirInset">
            {if $smarty.session.user->cashbox_ids != 100}
                <span><a href="index.php?module=OfflineSales">Покупки</a></span>
                <span>&nbsp;/&nbsp;
            {/if}
                <span>Перемещения</span>
                <span>&nbsp;/&nbsp;
            {if $smarty.session.user->cashbox_ids != 100}
                <span><a href="index.php?module=OfflineSales&debts=1">Задолженности</a></span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&returns=1">Возвраты</a></span>
                <span>&nbsp;/&nbsp;
            {/if}
                <span><a href="index.php?module=OfflineSales&calls=1">Клиенты</a></span>
        </div>
{/if}
        <!-- /Вкладки /-->
        {if !$confirmation}
          <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
          <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20"><a href="https://www.youtube.com/embed/eUNIWz4JtUY" target="_blank">Видео инструкция</a></div>
        {/if}
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
      {if $reservation}
        <h2>Отложить товары</h2>
      {else}
        <h2>Перемещение №{$movement->movement_id} из {$movement->wf_name} в {$movement->wt_name}</h2>
      {/if}
    </div>
    <div class="col-md-8" id="left-column" style="padding-left: 0;">

      <h3>Список {if $reservation}откладываемых{elseif $confirmation}{else}перемещаемых{/if} товаров</h3>
      <div class="row ShAA_titleOfTable">
        <div class="col-md-2 mt10"></div>
        <div class="col-md-2 mt10">Наименование</div>
        <div class="col-md-2 mt10">{if $acceptance || $confirmation}Назначение{else}Расположение{/if}</div>
        <div class="col-md-1 mt10">Размер</div>
        <div class="col-md-2 mt10">Количество</div>
        <div class="col-md-1 mt10">Цена</div>
        {if $reservation}<div class="col-md-1 mt10">Скидка</div>{/if}
        <div class="col-md-1 mt10"></div>
      </div>
      <div id="product-list">
        <!--Anchor for product-template-->
      </div>

      <div id="movement-buttons" class="mt20" style="display: none;">
        {if $confirmation}
          <button id="confirm-movement" class="btn btn-warning mt20">Подтвердить</button>
        {elseif $acceptance}
          Откуда: <b>{$movement->wf_name}</b>
          <br>
          Куда: <b>{$movement->wt_name}</b>
          <br>
          {if $movement->accepted}
            Перемещение принято
          {else}
            <button id="accept-all-items" class="btn btn-primary mt20">Отметить все товары как принятые</button>
            <button id="accept-movement" class="btn btn-warning mt20">Сохранить принятие</button>
          {/if}
        {else}
          {if $reservation}
            <div class="form-group">
              <label>Отложить до:</label>
              <input type="text" class="form-control" id="reservation-date" data-provide="datepicker" data-date-format="yyyy-mm-dd" data-date-start-date="1d" data-date-language="ru" value="{if $movement}{$movement->reservation_date}{else}{$smarty.now+604800|date_format:'%Y-%m-%d'}{/if}">
            </div>
            <div class="form-group">
              <label>Ответственный:</label>
              <select class="form-control" id="responsible">
                {foreach from=$responsible_for_reservation item=resp}
                  <option value="{$resp->user_id}" {if $resp->user_id == $movement->responsible}selected="true"{/if}>{$resp->name}</option>
                {/foreach}
              </select>
            </div>
          {/if}
          <a id="get-receipt" class="btn btn-primary mt20 disabled" href="" target="_blank">Распечатать накладную</a>
          <button id="submit-movement" class="btn btn-warning mt20">Сохранить</button>
          <a href="" onclick="return confirm('Вы уверены, что хотите удалить перемещение?')" id="delete-movement" class="btn btn-danger mt20 disabled">Удалить</a>
        {/if}
      </div>

      <div id="found-orders">
      </div>
    </div>

    {if !$confirmation && !$acceptance}
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
                <div class="panel-heading" role="tab" id="heading_warehouses">
                <h4 class="panel-title">
                  <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_warehouses" aria-expanded="false" aria-controls="collapseOnecollapse_warehouses">
                    <b>Откуда &rarr; куда</b>
                  </a>
                </h4>
                </div>
                <div id="collapse_warehouses" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading_warehouses">
                    <div class="panel-body">
                      <label>Склад (исходное месторасположение)</label>
                      <select class="form-control" id="warehouse_from" autocomplete="off" {if $confirmation}disabled{/if}>
                        <option>Выберите склад</option>
                        {foreach from=$warehouses item=wh}
                          <option value="{$wh->warehouse_id}">{$wh->name}</option>
                        {/foreach}
                      </select></br></br>
                      <label>Склад {if $reservation}отложки{else}назначения{/if}</label></br>
                      <select class="form-control" id="warehouse_to" autocomplete="off" {if $confirmation}disabled{/if}>
                        <option>Выберите склад</option>
                        {foreach from=$warehouses_to item=wh}
                          {if $wh->warehouse_id != 11}<option value="{$wh->warehouse_id}">{$wh->name}</option>{/if}
                        {/foreach}
                      </select></br></br>
                      <label>Тип перемещения</label></br>
                      <select class="form-control" id="m_type" autocomplete="off" {if $confirmation}disabled{/if}>
                        <option value="0">Выберите тип</option>
                        {foreach from=$m_types item=t}
                          <option value="{$t->id}">{$t->name}</option>
                        {/foreach}
                      </select>
                    </div>
                </div>
            </div>
            <div class="panel panel-default" {if !$reservation}style="display:none;"{/if}>
              <div class="panel-heading" role="tab" id="heading_users">
                <h4 class="panel-title">
                  <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_users" aria-expanded="false" aria-controls="collapseOnecollapse_users">
                    <b>Поиск клиента</b>
                  </a>
                </h4>
              </div>
              <div id="collapse_users" class="panel-collapse collapse {if $cashbox->name == 'Индивидуальный пошив'} in {/if}" role="tabpanel" aria-labelledby="heading_users">
                <div class="panel-body">
                  <label>Телефон, номер карты или имя</label>
                  <div class="input-group">
                    <span id="user-refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
                    <input id="user-input" type="text" class="form-control" {if $cashbox->name == 'Индивидуальный пошив'} autofocus {/if}>
                  </div>
                  <div id="found-users" class="anchor">
                    <!--Anchor for user-template-->
                  </div>
                </div>
              </div>
            </div>
            <div id="selected-user" class="mt20">
              <!--Anchor for selectedUser-template-->
            </div>
        </div>
    </div>
    {/if}

  </div>
</div>
<!-- Content #End /-->

<script id="data-movement"type="application/json">
  {$movement_object}
</script>

{literal}
<script id="foundProduct-template" type="text/x-handlebars-template">
  {{#each products}}
    <div class='row mt10 product-template'>
      <div class='col-md-8 mt20'>
        {{this.model}}, арт <span style="color: #ff00ff; cursor: pointer;" onClick="$('#barcode-input').val('{{this.sku}}');$('#refresh').click();">{{this.sku}}</span>{{#if this.size}},
        размер {{this.size}}{{/if}}{{#if this.color_name}}, цвет {{this.color_name}}{{/if}}{{#if this.quantity}}, {{this.quantity}} шт{{/if}} - <b>{{this.shop_name}}</b>
      </div>
      <div class='col-md-4 mt20'>
        <button type='button' product-id='{{this.product_id}}' product-index='{{@index}}' style="float: right;" class='btn btn-default add-btn'>Добавить</button>
      </div>
    </div>
  {{/each}}
</script>

<script id="product-template" type="text/x-handlebars-template">
  <div class="row mt10 ShAA_orderItemsOff">
    <div class="col-md-2 ShAA_mobImgItem">
        {{#if large_image}}<img src="/reimg/files/products/85x/{{this.large_image}}">{{/if}}
    </div>
    {{#if_show_remove}}
      <div class="col-md-1 mt20" style="float: right;">
        <button type="button" class="close remove-product off" aria-hidden="true" data-product-item_id="{{item_id}}">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </div>
    {{/if_show_remove}}
    <div class="col-md-2 mt20">
      <b>{{model}}</b><br>{{sku}}<br>{{color_name}}
      {{#if_acceptance}}
        {{#if accepted}}
          <div><strong>Товар принят</strong></div>
        {{else}}
          <div><button data-item-id="{{item_id}}" class="accept-item btn mt20">Принять товар</button></div>
        {{/if}}
      {{/if_acceptance}}
    </div>
    <div class="col-md-2 mt20">{{shop_name}}</div>
    <div class="col-md-1 mt20">{{size}}</div>
    <div class="col-md-2 mt20">
      {{#if_confirmation}}
        <b>{{quantity}}</b> шт.
      {{else}}
        <input type="number" class="quantity-input" data-product-item_id="{{item_id}}" min="1" max="100" style="width:60%" value="{{quantity}}">
      {{/if_confirmation}}
    </div>
    <div class="col-md-1 mt20 price-input" data-product-item_id="{{item_id}}">{{#if price}}{{price}}{{/if}}{{#unless price}}{{offline_price}}{{/unless}}</div>
    {{#if_reservation}}<div class="col-md-1 mt20"><span style="display:none;">{{offline_price}}</span><input type="number" class="discount-input" data-product-item_id="{{item_id}}" min="1" max="100" style="width:100%" value="{{discount}}"></div>{{/if_reservation}}
  </div>
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

<script id="selectedUser-template" type="text/x-handlebars-template">
  <span class="ShAA_mobileInvisible">Клиент:</br></span>
  <div class="row mt10" style="margin: 15px 0px;">
    <div class="col-md-11" style="padding-left: 0;">
        <div><b>{{name}}</b></span></div>
        <div class="mt20"><b>{{phone_number}}</b></div>
        <div class="mt20">{{#if personal_discount}}Бонус от <b>{{personal_discount}}%</b>{{/if}}</div>
        <div class="mt20"><a href="/index.php?module=OfflineSales&edit_user_id={{user_id}}" target="_blank">редактировать</a></div>
        <div class="mt20"><a href="#" class="btn btn-primary send-app-link" data-user-id="{{user_id}}" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на приложение"><i class="icon-envelope"></i> &#8594; <i class="icon-apple"></i>&nbsp;/&nbsp;<i class="icon-android"></i></a></div>
    </div>
    <div class="col-md-1">
      <button type="button" class="close remove-user off" aria-hidden="true">
        <span class="glyphicon glyphicon-remove"></span>
      </button>
    </div>
  </div>
</script>


<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();
var reservation = !!(new URL(window.location.href)).searchParams.get('reservation');

Handlebars.registerHelper('if_confirmation', function(options) {
  if (movement.confirmation == 1) {
    return options.fn(this);
  }
  else {
    return options.inverse(this);
  }
});

Handlebars.registerHelper('if_acceptance', function(options) {
  if (movement.acceptance == 1) {
    return options.fn(this);
  }
  else {
    return options.inverse(this);
  }
});

Handlebars.registerHelper('if_show_remove', function(options) {
  if (movement.acceptance != 1 && movement.confirmation != 1) {
    return options.fn(this);
  }
  else {
    return options.inverse(this);
  }
});

Handlebars.registerHelper('if_reservation', function(options) {
  if (reservation == 1) {
    return options.fn(this);
  }
  else {
    return options.inverse(this);
  }
});

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var $product_list = [];
var movement = {products: {}, user_id: 0};
var user = [];
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

post_user = function(query) {
  if (query.length > 3) {
    $.get("/index.php?module=OfflineSale", {user_query: query}, function(u_list) {
      $user_list = u_list;
      var u = Template.user({users: $user_list});
      $('#found-users').html(u);
    });
  }
}

render_movement = function(movement) {
  $.each(movement.products, function(index, product) {
    product.accepted = (product.accepted == "1");
    product.offline_price = Math.ceil(product.offline_price);
    product.price = Math.ceil(product.price);
    product.discount = parseInt(Math.ceil(((product.offline_price - product.price)/(product.offline_price/100))), 10);
    html = Template.product(product);
    $('#product-list').append(html);
  });
  if (movement.user) {
    html = Template.selectedUser(movement.user);
    $('#selected-user').html(html);
  }
  $('#warehouse_from').val(movement.warehouse_from);
  $('#warehouse_to').val(movement.warehouse_to);
  $("#movement-buttons").show();
  $("a#get-receipt").prop("href", "/index.php?module=OfflineSale&movement_receipt_for="+movement.movement_id);
  $("a#get-receipt").removeClass("disabled");
  $("a#delete-movement").prop("href", "/index.php?module=OfflineSales&movement_list=1&delete_movement_id="+movement.movement_id);
  $("a#delete-movement").removeClass("disabled");
}

check_reservation = function() {
  return !!(movement.user_id && $("#reservation-date").val() && $("#responsible").val());
}

toggle_accepted = function(el) {
  $(el).toggleClass("accepted").toggleClass("btn-success");
  $(el).html($(this).html() === "Принят" ? "Принять товар" : "Принят");
}

$(document).on("input", "#barcode-input", function() {
  post_product($(this).val());
});


$(document).on("click", "#refresh", function() {
  post_product($('#barcode-input').val());
});

$(document).on("click", ".add-btn", function() {
  t = $(this);
  var product_index = t.attr('product-index');
  var product = $product_list[product_index];
  if (user) {discount = user.personal_discount;}
  else{discount = 0;}
  product.discount = parseInt(discount, 10);
  product.offline_price = Math.ceil(product.offline_price);
  product.price = Math.ceil((product.offline_price * ((100 - product.discount)/100)));
  movement.products[product.item_id] = product;
  var html = Template.product(product);
  $('#product-list').append(html);
  t.parent().parent().remove();
  $("#movement-buttons").show();
  $('#barcode-input').val('');
  $('#barcode-input').focus();
});

$(document).on('click', '.remove-product', function() {
  t = $(this);
  var item_id = $(this).attr("data-product-item_id");
  delete movement.products[item_id];
  t.parent().parent().remove();
});

$(document).on("input", ".quantity-input", function() {
  var item_id = $(this).attr("data-product-item_id");
  var product = movement.products[item_id];
  product.quantity = $(this).val();
});
$(document).on("change", ".discount-input", function() {
  var item_id = $(this).attr("data-product-item_id");
  console.log(movement.products);
  var offline_price = $(this).prev().html();
  discount = parseInt($(this).val(), 10);
  price = Math.ceil((offline_price * ((100 - discount)/100)));
  $('.price-input[data-product-item_id="'+item_id+'"]').html(price);
});

$(document).on("change", "#warehouse_from", function() {
  movement.warehouse_from = $(this).val();
});

$(document).on("change", "#warehouse_to", function() {
  movement.warehouse_to = $(this).val();
});

$(document).on("input", "#user-input", function() {
  post_user($(this).val());
});

$(document).on("click", "#user-refresh", function() {
  post_user($('#user-input').val());
});

$(document).on("click", ".user-select-btn", function() {
  t = $(this);
  var user_index = t.attr('user-index');
  user = $user_list[user_index];
  movement.user_id = user.user_id;
  var html = Template.selectedUser(user);
  $('#selected-user').html(html);
  discount = parseInt(user.personal_discount, 10);
  prd = movement.products;
  console.log(prd);
  if (discount != 0) {
    Object.keys(prd).forEach(function (k) {
      prd[k].price = Math.ceil((prd[k].offline_price * ((100 - discount)/100)));
      $('.price-input[data-product-item_id="'+k+'"]').html(prd[k].price);
      return prd[k];
    });
  }
  $(".discount-input").val(discount);
  var user_rows = $('.user-template');
  user_rows.hide('fast');
  user_rows.remove();
  $user_list = [];
  $('#user-input').val('');
});

$(document).on('click', '.remove-user', function() {
  movement.user_id = 0;
  $("#selected-user").html('');
});

$(document).on('click', '.accept-item', function() {
  toggle_accepted(this)
});

$(document).on('click', '#accept-all-items', function() {
  $('.accept-item').addClass("accepted").addClass("btn-success")
  $('.accept-item').html("Принят")
});

$(document).on('click', '#submit-movement', function() {
  if (typeof(movement.warehouse_from) === "undefined" || typeof(movement.warehouse_to) === "undefined") {
    alert("Выберите склад отправки и назначения");
    return false;
  }
  if ($("#m_type").val() == 0) {
    alert("Выберите тип перемещения");
    return false;
  }
  if (reservation && !check_reservation()) {
    alert("Выберите срок отложки, ответственного и клиента");
    return false;
  }
  if (block) {
    alert("Инструмент перемещений работает с 9:00 до 21:00");
    return false;
  }

  var zero_q = false;
  $.each(movement.products, function(i,p) {
    p.responsible = $("#responsible").val() || 0;
    if (reservation == 1) {p.price = $('.price-input[data-product-item_id="'+p.item_id+'"]').html() || 0;}
    else{p.price = 0;}
    if (p.quantity == 0) {
      alert("Количество перемещаемого товара должно быть больше 0");
      zero_q = true
    }
  })
  if (zero_q) { return false }

  var t = $(this);
  movement.warehouse_from = $("#warehouse_from").val();
  movement.warehouse_to = $("#warehouse_to").val();
  movement.reservation_date = $("#reservation-date").val() || '';
  movement.responsible = $("#responsible").val() || 0;
  movement.type = $("#m_type").val();
  $.post('/index.php?module=OfflineSales', {movement: JSON.stringify(movement) }, function(data) {
    movement.movement_id = data;
    t.removeClass("btn-danger").addClass("btn-success").html("Сохранено");
    $("a#get-receipt").prop("href", "/index.php?module=OfflineSale&movement_receipt_for="+data);
    $("a#get-receipt").removeClass("disabled");
    $("a#delete-movement").prop("href", "/index.php?module=OfflineSales&movement=1&movement_id="+data+"delete_movement_id="+data);
    $("a#delete-movement").removeClass("disabled");
  });
});

$(document).on('click', '#confirm-movement', function() {
  var t = $(this);
  result = window.confirm("Подтвердить перемещение товара?");
  if (!result) { return false; }
  $.get('index.php?module=OfflineSales&movement=1&movement_id='+movement.movement_id+'&confirmation=1&m_token='+movement.token, {confirm_movement_id: movement.movement_id}, function(data) {
    t.replaceWith('<div class="alert alert-success" role="alert">Перемещение подтверждено</div>');
  });
});

$(document).on('click', '#accept-movement', function() {
  var t = $(this);
  result = window.confirm("Подтвердить принятие перемещения?");
  if (!result) { return false; }
  var item_ids = $('.accepted').toArray().map(function(e) {
    return Number($(e).attr("data-item-id"));
  })
  $.post('/rest_api/accept_movement', JSON.stringify({movement_id: movement.movement_id, item_ids: item_ids}), function(data) {
    t.replaceWith('<div class="alert alert-success" role="alert">Перемещение принято</div>');
  });
});

{/literal}
var block = {if $block}{$block}{else}false{/if};
{if $movement_object}
  movement = JSON.parse(document.getElementById('data-movement').innerHTML);
  render_movement(movement);
{/if}
{if $confirmation}
  {literal}jQuery(document).ready(function() {
    $('.adminTabs_container').hide();
    $('.background_header_mobile').hide();
    $('#headBlock_container').hide();
  });{/literal}
{/if}
</script>
