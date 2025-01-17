<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css">

<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/locales/bootstrap-datepicker.ru.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/accounting.js/0.4.1/accounting.min.js"></script>
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
  .mt50 {
    margin-top: 50px;
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
  .form-inline .form-group {
    margin-right: 6px;
  }
  .debt-by-date {
    max-width: 120px;
  }
  </style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row" style="margin-bottom: 24px;">
    <div class="col-md-12" style="text-align: center; margin-top: -32px;">
        <div class="col-md-8" style="float: left; width: 60%; text-align: right;">
          <h3>Услуги</h3>
        </div>
        <div class="col-md-4">
            <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        </div>
    </div>
  </div>
  <div class="col-md-10">
  <div class="row">
    <div class="col-md-12">
      <div class="panel panel-default">
        <div class="panel-heading">
          <h4 class="panel-title">
            <b>Поиск клиента</b>
          </h4>
        </div>
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
  </div>

  <div class="row">
    <div class="col-md-12">
      <div id="selected-user" class="mt20">
        <!--Anchor for selectedUser-template-->
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-12">
      <div class="form-group">
        <label>Магазин</label>
        <select id="shop" class="form-control">
          {foreach from=$shops item=shop}
            <option value="{$shop->shop_id}" >{$shop->name}</option>
          {/foreach}
        </select>
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-12">
      <div class="form-group order-type-select">
        <label>Тип заказа</label>
        {foreach from=$order_types item=name key=type}
          <label class="radio-inline">
            <input type="radio" class="order-type" name="order_type" value="{$type}" {if $type == 'default'}checked{/if}> {$name}
          </label>
        {/foreach}
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-12">
      <button id="add-service" class="btn btn-primary"><i class="fa fa-plus-circle"></i> Добавить услугу</button>
      <div id="service-list">
        <!--Anchor for service-template-->
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-12">
      <div class="total-order-info" style="margin-top: 25px; border-top: 1px solid #000; padding-top: 12px; text-align: right; font-size: 20px;">
        Всего: <span id="total-sum" style="font-weight: 700">0</span>₽
      </div>
      <div class="order-button-group mt20">
        <div style="float: left; margin: 4px 24px 0 0">
            <button id="order-button" type="button" class="btn btn-primary">Сохранить</button>
        </div>
      </div>
    </div>
  </div>
  </div>

</div>
<!-- Content #End /-->

{literal}
<script id="user-template" type="text/x-handlebars-template">
  {{#each users}}
    <div class='row mt10 user-template'>
      <div class='col-md-8 mt20' style='float: left;'>{{this.name}}</div>
      <div class='col-md-4 mt10'>
        <button type='button' user-id='{{this.user_id}}' user-index='{{@index}}' class='btn btn-default user-select-btn' style="float: right;">Выбрать</button>
      </div>
    </div>
  {{/each}}
</script>

<script id="selectedUser-template" type="text/x-handlebars-template">
  <div class="row mt10" style="margin: 15px 0px;">
    <div class="col-md-11" style="padding-left: 0; float: left;">
      Клиент: <a href="/index.php?module=Service&service_list=1&order_query={{card_number}}&show_page=1" target="_blank">{{name}}</a>{{#if phone_number}}, <b>{{phone_number}}</b>{{/if}}
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

<script id="service-template" type="text/x-handlebars-template">
  <div class='row well mt20 col-md-12 service-template'>
    <div class="form-inline service-form" data-order-item-id="{{item.id}}">
      <div class="form-group">
        <label>Название вещи</label>
        <input type="text" class="form-control product-name" value="{{item.product_name}}">
      </div>
      <div class="form-group">
        <label>Описание дефекта</label>
        <input type="text" class="form-control defect-description" value="{{item.defect_description}}">
      </div>
      <br>
      <br>
      <select class="service-items form-control" onchange="update_service(this);" style="width: 80%">
          <option value="default">Выбрать из списка</option>
        {{#each service_items}}
          <option value="{{@index}}" data-name="{{name}}" data-price="{{price}}" data-type="{{type}}">{{name}} - {{price}}</option>
        {{/each}}
      </select>
      <br><br>
      <select class="service-type form-control">
        {{#each service_types}}
          <option {{#if selected}}selected{{/if}} value="{{id}}" data-name="{{name}}">{{name}}</option>
        {{/each}}
      </select>
      <label>&nbsp;&nbsp;&nbsp;Цена:</label>
      <input class="service-price form-control" value="{{item.price}}" style="width: 80px; text-align: right;">
      <label>&nbsp;&nbsp;&nbsp;Статус:</label>
      <select class="service-status form-control">
        {{#each status_list}}
          <option {{#if selected}}selected{{/if}} value="{{name}}">{{name}}</option>
        {{/each}}
      </select>
      <button type="button" class="close remove-service off" aria-hidden="true">
        <span class="glyphicon glyphicon-remove"></span>
      </button>
    </div>
    {{#if item.changes}}
      <div class="mt20">
        {{#each item.changes}}
          {{date}} <i class="fa fa-arrow-right" aria-hidden="true"></i> <b>{{status}}</b> ({{name}})<br>
        {{/each}}
      </div>
    {{/if}}
  </div>
</script>

{/literal}
<script id="data-service-types" type="application/json">
  {$service_types}
</script>

<script id="data-service-items" type="application/json">
  {$service_items}
</script>

<script id="data-cashbox-id" type="application/json">
  {$cashbox_id}
</script>

<script id="data-order" type="application/json">
  {$order}
</script>
{literal}
<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

Handlebars.registerHelper('if_editable', function(options) {
  if (editable()) {
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

var order = {items: {}};
var service_types = JSON.parse(document.getElementById('data-service-types').innerHTML);
var service_items = JSON.parse(document.getElementById('data-service-items').innerHTML);
var order_json = $.trim(document.getElementById('data-order').innerHTML);
if (order_json) {
  var order = JSON.parse(order_json);
}
order.cashbox_id = JSON.parse(document.getElementById('data-cashbox-id').innerHTML);

editable = function() {
  if (typeof(order.date) === "undefined") {
    return true;
  }
  var orderDate = new Date(order.date);
  var todaysDate = new Date();
  return orderDate.setHours(0,0,0,0) == todaysDate.setHours(0,0,0,0);
};

post_user = function(query) {
  if (query.length > 3) {
    $.get("/index.php?module=OfflineSale", {user_query: query}, function(u_list) {
      $user_list = u_list;
      var u = Template.user({users: $user_list});
      $('#found-users').html(u);
    });
  }
}

add_service = function(item) {
  var t_services = JSON.parse(JSON.stringify(service_types));
  var status_list = [{name: "Принято"},
    {name: "В работе"},
    {name: "В бутике, ждет клиента"},
    {name: "Выдано клиенту"}]
  if (item) {
    t_services.forEach( function(service, index) {
      if (item.service_type_id == service.id) {
        t_services[index].selected = true;
      }
    })
    status_list.forEach( function(status, index) {
      if (item.status == status.name) {
        status_list[index].selected = true;
      }
    })
    var html = Template.service({service_types: t_services, service_items: service_items, status_list: status_list, item: item});
  }
  else {
    var html = Template.service({service_types: t_services, service_items: service_items, status_list: status_list});
  }
  $('#service-list').append(html);
}

function select_user(user) {
  order.user = user;
  var html = Template.selectedUser(user);
  $('#selected-user').html(html);
  var user_rows = $('.user-template');
  user_rows.hide('fast');
  user_rows.remove();
  $user_list = [];
  update_total(true);
  $('#user-input').val('');
}

function render_existing_order(order) {
  select_user(order.user);
  $('#shop').val(order.shop_id);
  $('.order-type-select input[value="'+order.order_type+'"]').prop("checked", true);
  order.items.forEach(add_service);
  update_total();
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
  return $('.service-price').toArray().map(function(el) {
    return (parseInt($(el).val()) || 0); }).reduce(function(a,b) {
      return a + b;
    }, 0);
}

remaining = function() {
  return total_sum()-total_payment();
}

update_total = function(with_personal_discount) {
  var total = total_sum();
  total = accounting.formatNumber(total, 0, " ", " ");
  $('#total-sum, #total-sum2').html(total);
  $('#remaining').html(remaining());
}

$(document).on("input", "#user-input", function() {
  post_user($(this).val());
});

$(document).on("click", "#user-refresh", function() {
  post_user($('#user-input').val());
});

$(document).on("click", "#add-service", function() {
  add_service();
  update_total()
});

$(document).on('click', '.remove-service', function() {
  $(this).parents(".service-template").remove();
  update_total();
})

$(document).on("input", ".service-price", function() {
  update_total()
});

$(document).on("click", ".user-select-btn", function() {
  t = $(this);
  var user_index = t.attr('user-index');
  var user = $user_list[user_index];
  select_user(user);
});

$(document).on("click", "#order-button", function(e) {
  var t = $(this);
  e.preventDefault();
  if (order.user === undefined) {
    alert("Укажите клиента, заказывающего услугу");
    return false;
  }
  order.items = $('.service-form').toArray().map(function(el) {
    var service_type = $(el).find(".service-type option:selected");
    return {
      service_type_id: service_type.val(),
      name: service_type.data().name,
      product_name: $(el).find('.product-name').val(),
      defect_description: $(el).find('.defect-description').val(),
      price: ($(el).find('.service-price').val() || 0),
      status: $(el).find('.service-status').val(),
      id: $(el).data().orderItemId
    }
  });
  order.item_name = $('#product-name').val();
  order.defect_description = $('#defect-description').val();
  order.shop_id = $('#shop').val();
  order.order_type = $('.order-type-select input:checked').val();
  $.post('/index.php?module=Service', {service_order: JSON.stringify(order) }, function(data) {
    order.id = data.order_id;
    $('.service-form').each(function(i) {
      $(this).data().orderItemId = data.item_ids[i]
    });
    window.history.pushState("orderEditable", "Editable order page", "index.php?module=Service&service_order_id="+order.id);
  });
});

update_service =  function(el) {
  var t = $(el);
  if (t.value === 'default') {
    return false;
  }
  var form = t.parent();
  var data = t.find('option:selected').data();
  form.find('.service-type').val(data.type);
  form.find('.service-price').val(data.price);
  update_total();
};


if (order_json) {
  render_existing_order(order);
}

</script>
{/literal}
