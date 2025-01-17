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
  </style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
    </div>
  </div>
  <div class="row">
    <div class="col-md-6" id="right-column" style="padding-left: 0;">
        Поиск по штрихкоду 1С, штрихкоду производителя или артикулу товара.
      <div class="input-group">
        <span class="input-group-addon"><span class="glyphicon glyphicon-barcode"></span> <b>Штрихкод</b></span>
        <input id="barcode-input" type="text" class="form-control" autofocus>
      </div>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      <div id="item">
      </div>
    </div>
    <div class="col-md-4" id="right-column" style="padding-left: 0;">
      <div id="accepted">
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

<script id="data-accepted-today"type="application/json">
  {$accepted_today}
</script>

{literal}
<script id="item-template" type="text/x-handlebars-template">
  <div class="panel panel-default mt10">
    <div class="panel-heading">
      <b>{{info.name}} {{info.sku}}</b>
    </div>
    <div class="panel-body">
      <form id="form_{{info.code}}" >
        <div class="form-group">
          <label>Наименование</label>
          <input type="text" class="form-control item-input" name="name" value="{{info.name}}">
        </div>
        <div class="form-group">
          <label>Цвет</label>
          <input type="text" class="form-control item-input" name="color" value="{{info.color}}">
        </div>
        <div class="form-group">
          <label>Состав</label>
          <input type="text" class="form-control item-input" name="material" value="{{info.material}}">
        </div>
        <div class="form-group">
          <label>Поставщик</label>
          <input type="text" class="form-control item-input" name="supplier" value="{{info.supplier}}">
        </div>
        <label class="radio-inline">
          <input type="radio" name="sex" class="sex-input sex_{{info.code}}" value="муж"> муж
        </label>
        <label class="radio-inline">
          <input type="radio" name="sex" class="sex-input sex_{{info.code}}" value="жен"> жен
        </label>
        <label class="radio-inline">
          <input type="radio" name="sex" class="sex-input sex_{{info.code}}" value="унисекс"> унисекс
        </label>
        <label class="radio-inline">
          <input type="radio" name="sex" class="sex-input sex_{{info.code}}" value="не задан"> не задан
        </label>
        <br><br>
        <div class="form-group form-inline">
          <label>Размеры</label><br>
          {{#each items}}
            <input type="text" class="form-control size_{{../info.code}}" data-barcode="{{this.barcode}}" style="width: 150px;margin-right:50px;" name="size" value="{{this.size}}">
            ({{this.size}}) X <input class="form-control quantity-input" type="number" value="{{this.quantity}}" min="0" max="{{this.quantity}}"> - ш/к <b>{{this.barcode}}</b>
            <br><br>
          {{/each}}
        </div>
        <input type="hidden" class="item-input" name="code" value="{{info.code}}">
        <button type="submit" id="accept" data-code="{{info.code}}" class="btn btn-default">Принять</button>
      </form>
    </div>
  </div>
</script>

<script id="accepted-template" type="text/x-handlebars-template">
  <div class="panel panel-default mt10">
    <div class="panel-heading">
      <b>Принятые за день вещи</b>
    </div>
    <div class="panel-body">
      {{#each gr_items}}
      <div class="panel panel-default">
        <div class="panel-body">
          {{#each this}}
            <a href="#" class="item-link" data-sku="{{sku}}">{{sku}} {{name}}</a>, р. {{size}} <b>X {{quantity_accepted}}</b><br>
          {{/each}}
        </div>
      </div>
      {{/each}}
    </div>
  </div>
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

var intlData = {
    locales: 'ru-RU'
}
var item_query_running = false;
var item_query_queue = [];
var accepted_today = JSON.parse(document.getElementById('data-accepted-today').innerHTML);
var products = {};

render_accepted();

post_item = function(item_query) {
  if (item_query.length < 4) {
    return false;
  }

  item_query = item_query.replace(/\s/g, "");
  if (item_query_running) {
    item_query_queue.push(item_query);
    return false;
  }
  item_query_running = true;
  item_query_queue = [];
  $.get("/index.php?module=Premoderation", {premoderation_item_query: item_query}, function(response) {
    if (!response) {
      $('#item').hide();
    }
    else {
      if ($.isArray(response)) {
        $('#item').empty();
        products = {};
        response.forEach(function(item) {
          if (products[item.code]) {
            products[item.code].items.push({barcode: item.barcode, size: item.size, quantity: (item.quantity-item.quantity_accepted)})
          }
          else {
            products[item.code] = {};
            products[item.code].info = item;
            products[item.code].items = [{barcode: item.barcode, size: item.size, quantity: (item.quantity-item.quantity_accepted)}];
          }
          products[item.code]['items']
        });
        $.each(products, function(code, product) {
          render_item(product);
        });
      }
    }

    item_query_running = false;
    if (item_query_queue.length > 0) {
      post_item(item_query_queue.pop());
    }
  });
}

render_item = function(item) {
  var u = Template.item(item, {data: {intl: intlData}});
  $('#item').append(u);
  $('#item').show();
  $('form#form_'+item.info.code+' .sex-input[value="' + item.info.sex + '"]').attr("checked", true);
}

accept_item = function(code) {
  var data = {};
  $('#form_'+code+' .item-input').each(function(i,e) {
    data[$(e).attr('name')] = $(e).val();
  });
  data.sex = $('.sex_'+code+':checked').val();
  data.items = [];
  $('.size_'+code).each(function(i, el) {
    var quantity = $(el).next('.quantity-input').val();
    data.items.push({size: $(el).val(), barcode: $(el).attr('data-barcode'), quantity: quantity});
  });
  $.post("/index.php?module=Premoderation", {product: JSON.stringify(data)}, function(res) {
    products = {};
    accepted_today = res;
    $('#item').html("<b>Принято</b>");
    $("#barcode-input").val('');
    $("#barcode-input").focus();
    render_accepted();
  });
}

function render_accepted() {
  sort_accepted_items_by_accepted_date(accepted_today);
  var grouped_items = {};
  accepted_today.forEach(function(item) {
    if (grouped_items[item.code]) {
      grouped_items[item.code].push(item);
    }
    else {
      grouped_items[item.code] = [item];
    }
  });
  var u = Template.accepted({gr_items: grouped_items});
  $('#accepted').html(u);
}

function sort_accepted_items_by_name(items) {
  items.sort(function(a, b) {
    var nameA = (a.sku + a.name + a.size).toUpperCase();
    var nameB = (b.sku + b.name + b.size).toUpperCase();
    if (nameA < nameB) {
      return -1;
    }
    if (nameA > nameB) {
      return 1;
    }

    return 0;
  });
}

function sort_accepted_items_by_accepted_date(items) {
  items.sort(function(a, b) {
    var dateA = Date.parse(a.accepted_at);
    var dateB = Date.parse(b.accepted_at);
    if (dateA < dateB) {
      return -1;
    }
    if (dateA > dateB) {
      return 1;
    }
    return 0;
  });
}

$(document).on("input", "#barcode-input", function() {
  post_item($(this).val());
});

$(document).on("click", ".item-link", function(e) {
  e.preventDefault();
  var sku = $(this).attr("data-sku");
  $("#barcode-input").val(sku);
  post_item(sku);
});

$(document).on("click", "#accept", function(e) {
  e.preventDefault();
  var code = $(this).attr("data-code");
  accept_item(code);
});

</script>
{/literal}
