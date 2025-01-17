<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/locale/ru.js"></script>
<script src="/js/are_you_ie.js"></script>

<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.3">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/themes/black/pace-theme-flash.css" />

{if $config->enviroment == 'live'}
  <script src="//d2wy8f7a9ursnm.cloudfront.net/v4/bugsnag.min.js"></script>
  <script>window.bugsnagClient = bugsnag('0e17cb08065a63f14237abf91499cea3')</script>
{/if}

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
  .mt40 {
    margin-top: 40px;
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

  .ShAA_toggleBrandsForCalls {
    display: none;
  }

  #ShAA_brandsCallsTitle, #ShAA_GroupsTitle {
    cursor: pointer;
  }

  #ShAA_brandsCallsTitle span, #ShAA_GroupsTitle span {
    float: left;
  }

  #ShAA_brandsCallsTitle i, #ShAA_GroupsTitle i {
    float: left;
    margin: 4px 0 0 6px;
  }
  
  .half_form{
    width: 50%!important;
  }
  .icon-minus-square-o {
    display: inline !important;
  }
  .pagination {
    margin-bottom: 0 !important;
  }
  @media (max-width: 770px) {
    .half_form{
      width: 100%!important;
    }
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
            {if $smarty.session.user->cashbox_ids != 100}
                <span><a href="index.php?module=OfflineSales">Покупки</a></span>
                <span>&nbsp;/&nbsp;
            {/if}
                <span><a href="index.php?module=OfflineSales&movement=1">Перемещения</a></span>
                <span>&nbsp;/&nbsp;
            {if $smarty.session.user->cashbox_ids != 100}
                <span><a href="index.php?module=OfflineSales&debts=1">Задолженности</a></span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&returns=1">Возвраты</a></span>
                <span>&nbsp;/&nbsp;
            {/if}
                <span>Клиенты</span>
        </div>
{/if}
        <!-- /Вкладки /-->
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20"><a href="https://youtu.be/CCV0mxOxJTk" target="_blank">Установка приложения</a></div>
    </div>
  </div>
  <div class="row">
    <div class="col-md-12" id="right-column" style="padding-left: 0;">
      <label>Магазины</label>
      <br>
      {foreach from=$shops_select item=shop}
        <label class="checkbox-inline ShAA_callsCashboxesTitle">
          <input type="checkbox" class="user-input shop-chk" value="{$shop->shop_id}">{$shop->name}
        </label>
      {/foreach}
      <div class="clear"></div>
      {if $cities_select}
        <br>
        <label>Города</label>
        <br>
        {foreach from=$cities_select item=city}
          <label class="checkbox-inline ShAA_callsCashboxesTitle">
            <input type="checkbox" class="user-input city-chk" value="{$city->city_id}">{$city->name}
          </label>
        {/foreach}
        <div class="clear"></div>
      {/if}
      </br>
      <label id="ShAA_brandsCallsTitle"><span>Бренды</span> <i class="icon-plus-square-o"></i></label>
      <br>
      <div class="ShAA_toggleBrandsForCalls" id="ShAA_brandsCalls">
      </div>
      <div class="clear"></div>
      <label id="ShAA_GroupsTitle"><span>Группы</span> <i class="icon-plus-square-o"></i></label>
      <div class="ShAA_toggleBrandsForCalls" id="ShAA_Groups">
      {foreach from=$client_groups item=cg}
        <label class="checkbox-inline ShAA_callsCashboxesTitle">
          <input type="checkbox" class="user-input client_group-chk" value="{$cg->id}">{$cg->name}
        </label>
      {/foreach}
      </div>
      <div class="clear"></div>
      <label class="checkbox-inline ShAA_callsCashboxesTitle">
        <input id="stars-chk" type="checkbox" class="user-input" value="1">Со звёздами
      </label>
      <label class="checkbox-inline ShAA_callsCashboxesTitle">
        <input id="call_date_asc" type="checkbox" class="user-input" value="1">Давно не звонили
      </label>
      <!--<label>Менеджеры</label>
      <br>
      {foreach from=$managers item=man}
        <label class="checkbox-inline ShAA_callsCashboxesTitle">
          <input type="checkbox" class="user-input client_manager-chk" value="{$man->id}">{$man->name}
        </label>
      {/foreach}
      <div class="clear"></div>-->
      <div style="width: 100%;overflow:hidden;">
      <label class="checkbox-inline ShAA_callsCashboxesTitle">
        <input id="birthday-chk" type="checkbox" class="user-input" value="1">Сегодня день рождения
      </label>
      <label class="checkbox-inline ShAA_callsCashboxesTitle">
        <input id="vip-chk" type="checkbox" class="user-input" value="1">VIP
      </label>
      <label class="checkbox-inline ShAA_callsCashboxesTitle">
        <input id="sort-by-product-view-date-chk" type="checkbox" class="user-input" value="1">Последние просмотры товаров
      </label>
      {if $smarty.session.user->group_id == 13}
      <label class="checkbox-inline ShAA_callsCashboxesTitle">
        <input id="my-clients-chk" type="checkbox" class="user-input" value="1">Мои клиенты
      </label>
      {/if}
      </div>
      <!--<div class="input-group">
      Дата регистрации клиента
        <form class="form-inline">
          <div class="form-group ShAA_fromService" style="overflow:hidden;">
            <label for="date_start" style="float:left;margin:6px 5px 0 0;">От </label>
            <input type="text" name="date_start" class="form-control ShAA_inputDate user-input" id="date_start" value="{$date_start}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
          <div class="form-group ShAA_toService" style="overflow:hidden;">
            <label for="date_end" style="float:left;margin:6px 5px 0 0;">До </label>
            <input type="text" name="date_end" class="form-control ShAA_inputDate user-input" id="date_end" value="{$date_end}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
        </form>
      </div>-->
      <div class="input-group" style="width: 100%;overflow:hidden;">
        <div class="form-group ShAA_toService" style="float:left;">
          <label for="date_end" style="float:left;margin:6px 5px 0 0;">Дата последнего звонка: </label>
          <input type="text" name="call_date_end" class="form-control ShAA_inputDate user-input half_form" id="call_date_end" value="{$call_date_end}" placeholder="ГГГГ-ММ-ДД">
        </div>
        <div class="input-group checkbox-inline half_form" style="margin: 0 0 16px -20px;">
          <span class="input-group-addon">Поиск</span>
          <input id="user-search" type="text" class="user-input form-control" autocomplete="off">
        </div>
      </div>
      <div class="clear"></div>
    </div>
  </div>
  <div class="pagination">
  </div>
  <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
    <div class="col-md-2"><b>Имя</b></div>
    <div class="col-md-2"><b>Телефон / Карта</b></div>
    <div class="col-md-2"><b>Последняя покупка / просмотр</b></div>
    <div class="col-md-2"><b>Персональные менеджеры</b></div>
    <div class="col-md-4" style="text-align:center"><b>Статус</b></div>
  </div>
  <div id="found-users">
  </div>
  <div class="pagination">
  </div>
</div>
<!-- Content #End /-->

<script id="data-all-brands"type="application/json">
  {$brands_select}
</script>

<script id="data-messengers"type="application/json">
  {$messengers}
</script>

<script id="data-managers"type="application/json">
  {$managers}
</script>

{literal}
<script id="user-template" type="text/x-handlebars-template">
  <div class="row user-row mt20">
     <div class="ShAA_leftCallsBlock">
        <div class="col-md-2 ShAA_mobInfoLine">
          <a class="user-link" href="#" data-user-id="{{user_id}}"><b>{{name}}</b></a>
          <br>
          <a href="/index.php?module=OfflineSales&edit_user_id={{user_id}}" target="_blank">Редактировать</a>
          {{#if show_bin_button}}
          <br>
          <a href="#" class="move-to-bin" data-user-id="{{user_id}}">В корзину</a>
          {{/if}}
          <br>
          Персональная скидка {{personal_discount}}%<br/>
          <nobr>{{{stars}}}</nobr>
        </div>
        <div class="col-md-2 ShAA_mobInfoLine">
          <a href="tel:{{phone_number}}">{{phone_number}}</a>
          <br>
          {{#if city}}{{city}}{{/if}}
          <br>
          {{card_number}}
          {{#if birth_date}}<br>День рождения: {{FDBD birth_date}}{{/if}}
          <br>
          {{#each messengers}}
            <img src="/admin/images/icons/{{icon}}" style="width:25px;">
            {{name}}
          {{/each}}
        </div>
        <div class="col-md-2 ShAA_mobInfoLine">{{#if last_purchase_date}}Покупка: {{FDwoTY last_purchase_date}}{{/if}}{{#if last_seen_date}}<br>Просмотр: {{formatDate last_seen_date}}{{/if}}</div>
        <div class="col-md-2 ShAA_mobInfoLine">
          {{#if online_manager}} Онлайн: {{online_manager}} {{/if}}
          {{#if offline_managers}}<br> Оффлайн: {{#each offline_managers}}{{name}}<br>{{/each}}{{/if}}
        </div>
    </div>
    <div class="ShAA_callsButtonsBlock ShAA_mobInfoLine" style="text-align:center;">
      {{#if recent_calls}}<div class="last-call" data-user-id="{{user_id}}" style="margin: 0 8px 8px;">Звонок: {{FDwoY recent_calls.[0].date}}<br>{{recent_calls.[0].manager_name}}</div>{{/if}}
      <button class="status-control btn btn-success" data-user-id="{{user_id}}" value="1">Дозвонились</button>
      <button class="status-control btn btn-danger" data-user-id="{{user_id}}" value="2">Не дозвонились</button>
      {{#unless track_id}}
      <a href="#" class="btn btn-primary app-installed" data-user-id="{{user_id}}" style="background-color: #337ab7;" title="Приложение установлено">
        приложение <i class="icon-check"></i>
      </a>
      {{/unless}}<br>
      <a href="#" class="btn btn-primary send-app-link" data-user-id="{{user_id}}" data-platform="apple" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на Apple приложение">
        <i class="icon-envelope"></i> &#8594; <i class="icon-apple"></i>
      </a>&nbsp;&nbsp;&nbsp;
      <a href="#" class="btn btn-primary send-app-link" data-user-id="{{user_id}}" data-platform="android" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на Android приложение">
        <i class="icon-envelope"></i> &#8594; <i class="icon-android"></i>
      </a>&nbsp;&nbsp;&nbsp;
      <a href="#" class="btn btn-primary send-wallet-link" data-user-id="{{user_id}}" style="background-color: #337ab7;" title="отправить карту Wallet">
        карта Wallet
      </a><br/>
    </div>
    <div class="clear"></div>
    <div class="additional-info hidden" data-user-id="{{user_id}}">
      <div class="col-md-4">
        {{#if recent_items}}
            <h3>Покупки</h3>
            {{#each recent_items}}
              <div>
                <span>{{formatDate date}}</span>:
                {{#if receipt_number}}
                  <a href="/index.php?module=OfflineSale&order_id={{order_id}}" target="_blank"> {{product_name}}</a>
                {{else}}
                  {{product_name}}
                {{/if}}
                {{#if size}}
                 - {{size}}
                {{/if}}
              </div>
            {{/each}}
        {{/if}}
      </div>
      <div class="col-md-4">
        {{#if seen_items}}
            <h3>Просмотренные товары</h3>
            {{#each seen_items}}
              <div>
                <span>{{#if app_view}}<i class="icon-mobile" style="font-size: 1.4em; margin: 0 3px;"></i>{{else}}<i class="icon icon-desktop"></i>{{/if}}</span>
                <span>{{formatDate date}}</span>:
                <a href="/products/{{product_id}}/" target="_blank"> {{model}}</a>
              </div>
            {{/each}}
        {{/if}}
      </div>
      <div class="col-md-4">
        {{#if recent_calls}}
            <div>
              <h3>Звонки</h3>
              {{#each recent_calls}}
                <div>
                  <b>{{manager_name}}</b><br><span>{{formatDate date}}</span>: {{status_name}}
                </div>
              {{/each}}
            </div>
        {{/if}}
        <div>
            {{#if comments}}<br><b>Комментарии:</b>{{/if}}
            <div class="comment-list">
              {{#each comments}}
                <div><b>{{manager_name}}</b><br><span>{{formatDate date}}</span>: {{text}}</div>
              {{/each}}
            </div>
            <br>
            <textarea class="comment-text form-control" rows="12" data-user-id="{{user_id}}"></textarea>
            <button class="comment-submit btn-primary mt10" data-user-id="{{user_id}}">Оставить комментарий</button>
        </div>
      </div>

    </div>
  </div>
  <hr class="mt40">
</script>

<script id="pagination-template" type="text/x-handlebars-template">
  <nav aria-label="Page navigation">
    <ul class="pagination">
      {{#if first}}
        <li class="disabled">
          <span><span aria-hidden="true">&laquo;</span></span>
        </li>
      {{else}}
        <li>
          <a href="#" class="page-move" data-change="-1" aria-label="Previous">
            <span aria-hidden="true">&laquo;</span>
          </a>
        </li>
      {{/if}}
      {{#each pages}}
        {{#if active}}
          <li class="active"><span>{{page}} <span class="sr-only">(current)</span></span></li>
        {{else}}
          <li><a class="page" data-page="{{page}}" href="#">{{page}}</a></li>
        {{/if}}
      {{/each}}
      {{#if last}}
        <li class="disabled">
          <span><span aria-hidden="true">&raquo;</span></span>
        </li>
      {{else}}
        <li>
          <a href="#" class="page-move" data-change="1" aria-label="Next">
            <span aria-hidden="true">&raquo;</span>
          </a>
        </li>
      {{/if}}
    </ul>
  </nav>
</script>

<script id="brands-template" type="text/x-handlebars-template">
  {{#each brands}}
    <label class="checkbox-inline ShAA_callsBrandsTitle">
      <input type="checkbox" class="user-input brand-chk" value="{{brand_id}}">{{name}}
    </label>
  {{/each}}
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/pace.min.js"></script>

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

Handlebars.registerHelper('FDwoTY', function(date) {
  var moment_obj = moment(date)
  if (moment_obj._isValid) {
    return moment_obj.format("Do MMMM");
  }
  else {
    return false;
  }
});

Handlebars.registerHelper('FDwoY', function(date) {
  var moment_obj = moment(date)
  if (moment_obj._isValid) {
    if (moment_obj.format("YY") == moment().format("YY")){
      return moment_obj.format("Do MMMM, H:mm");
    }
    else{
      return moment_obj.format("Do MMMM YY, H:mm");
    }
  }
  else {
    return false;
  }
});
Handlebars.registerHelper('FDBD', function(date) {
  var moment_obj = moment(date)
  if (moment_obj._isValid) {
    return moment_obj.format("Do MMMM YY");
  }
  else {
    return false;
  }
});


Handlebars.registerHelper('formatMoney', function(n) {
  return new Intl.NumberFormat('ru-RU', { style: 'currency', currency: 'RUB',
   maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(Number(n));
});

jQuery("#ShAA_brandsCallsTitle").click(function () {
    if(jQuery('#ShAA_brandsCalls').hasClass('ShAA_toggleBrandsForCalls')){
        jQuery("#ShAA_brandsCallsTitle > i").removeClass('icon-plus-square-o');
        jQuery("#ShAA_brandsCallsTitle > i").addClass('icon-minus-square-o');
        $('#ShAA_brandsCalls').toggleClass('ShAA_toggleBrandsForCalls');
    } else {
        jQuery("#ShAA_brandsCallsTitle > i").removeClass('icon-minus-square-o');
        jQuery("#ShAA_brandsCallsTitle > i").addClass('icon-plus-square-o');
        $('#ShAA_brandsCalls').toggleClass('ShAA_toggleBrandsForCalls');
    }
    return false;
});

jQuery("#ShAA_GroupsTitle").click(function () {
    if(jQuery('#ShAA_Groups').hasClass('ShAA_toggleBrandsForCalls')){
        jQuery("#ShAA_GroupsTitle > i").removeClass('icon-plus-square-o');
        jQuery("#ShAA_GroupsTitle > i").addClass('icon-minus-square-o');
        $('#ShAA_Groups').toggleClass('ShAA_toggleBrandsForCalls');
    } else {
        jQuery("#ShAA_GroupsTitle > i").removeClass('icon-minus-square-o');
        jQuery("#ShAA_GroupsTitle > i").addClass('icon-plus-square-o');
        $('#ShAA_Groups').toggleClass('ShAA_toggleBrandsForCalls');
    }
    return false;
});

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var $user_list = [];
var status_names = {'1': 'Дозвонились', '2': 'Не дозвонились'};
var pagination = {page: 1, per_page: 100, rowcount: 0};
var all_brands = JSON.parse(document.getElementById('data-all-brands').innerHTML);
var messengers = JSON.parse(document.getElementById('data-messengers').innerHTML);
var filtered_brands = [];
var parsedUrl = new URL(window.location.href);
var params = parsedUrl.searchParams;

render_brands(all_brands);
restore_from_params();

function post_user(user_data) {
  if (typeof(user_data) === 'undefined') {
    user_data = get_user_data();
    update_params(user_data);
  }
  Pace.track(function(){
    $.post("/index.php?module=OfflineSale", {user_data: JSON.stringify(user_data)}, function(res) {
      if (!res) {
        $('#found-users').empty();
        $('div.pagination').empty();
        render_brands(all_brands);
        return false;
      }
      var users = res.users;
      pagination = res.pagination || pagination;
      $user_list = users;
      render_pagination();
      render_brands(res.brands);
      update_checkbox(user_data);
      render_users();
    });
  });
}

function get_user_data() {
  var user_data = {page: pagination.page, per_page: pagination.per_page};
  user_data.shop_ids = $('.shop-chk:checked').toArray().map(function(e) {
    return Number(e.value);
  }).join();
  user_data.city_ids = $('.city-chk:checked').toArray().map(function(e) {
    return Number(e.value);
  }).join();
  user_data.brand_ids = $('.brand-chk:checked').toArray().map(function(e) {
    return Number(e.value);
  }).join();
  user_data.client_group_ids = $('.client_group-chk:checked').toArray().map(function(e) {
    return Number(e.value);
  }).join();
  user_data.client_manager_ids = $('.client_manager-chk:checked').toArray().map(function(e) {
    return Number(e.value);
  }).join();
  user_data.birthday = $('#birthday-chk').prop("checked") | 0;
  user_data.vip = $('#vip-chk').prop("checked") | 0;
  user_data.sort_by_product_view_date = $('#sort-by-product-view-date-chk').prop("checked") | 0;
  user_data.my_clients = $('#my-clients-chk').prop("checked") | 0;
  user_data.stars = $('#stars-chk').prop("checked") | 0;
  user_data.f_date_start = $("#date_start").val();
  user_data.f_date_end = $("#date_end").val();
  user_data.c_date_end = $("#call_date_end").val();
  user_data.call_date_asc = $('#call_date_asc').prop("checked") | 0;
  var search = $('#user-search').val();
  if (search.length > 3) {
    user_data.search = search;
  }
  else {
    user_data.search = '';
  }
  return user_data;
}

function render_pagination() {
  var pagination_obj = {};
  var last_page = Math.ceil(pagination.rowcount / pagination.per_page);
  if (pagination.page == 1) { pagination_obj.first = true; }
  if (pagination.page == last_page) { pagination_obj.last = true; }
  pagination_obj.pages = Array.apply(null, {length: last_page}).map(function(_,i) {
    return {page: i+1, active: (pagination.page == i+1)};
  });
  var html = Template.pagination(pagination_obj);
  $('div.pagination').html(html);
}

function render_users() {
  $('#found-users').empty();
  var users = $user_list;
  if (!users) { return false; }
  users.forEach(function(user) {
    if (user.birth_date === '0000-00-00') { delete user.birth_date }
    if (user.pref_messenger) {
      var msg_ids = user.pref_messenger.split(", ");
      user.messengers = messengers.filter(function(m) {
        return msg_ids.indexOf(m.id) > -1;
      });
    }
    if (user.total_sum) {
      if (user.total_sum > 300000) {user.stars = '<img src="/images/star_on.jpg" width=23>';}
      if (user.total_sum > 900000) {user.stars += '<img src="/images/star_on.jpg" width=23>';}
      if (user.total_sum > 1500000) {user.stars += '<img src="/images/star_on.jpg" width=23>';}
    }
    user.recent_calls.forEach(function(call) { call.status_name = status_names[call.status]; });
    var u = Template.user(user);
    $('#found-users').append(u);
  });
}

function render_brands(res_brands) {
  var brands = res_brands ? res_brands : all_brands;
  if (brands.length == filtered_brands.length) {  return false; }
  filtered_brands = brands;
  var html = Template.brands({brands: filtered_brands});
  $('#ShAA_brandsCalls').html(html);
}

function update_params(query_data) {
  for (var q in query_data) { params.set(q, query_data[q]); }
  history.pushState({}, '', parsedUrl.pathname + '?' + params.toString());
}

function update_checkbox(user_data) {
  var id_params = ['brand', 'shop', 'city', 'client_group', 'client_manager'];
  id_params.forEach(function(pa) {
    if (user_data[pa+'_ids']) {
      user_data[pa+'_ids'].split(",").forEach(function(id) {
        $('.'+pa+'-chk[value="'+id+'"]').prop('checked', true);
      });
    }
  });
  $('#birthday-chk').prop("checked", !!(user_data.birthday > 0));
  $('#vip-chk').prop("checked", !!(user_data.vip > 0));
  $('#sort-by-product-view-date-chk').prop("checked", !!(user_data.sort_by_product_view_date > 0));
  $('#my-clients-chk').prop("checked", !!(user_data.my_clients > 0));
  $('#stars-chk').prop("checked", !!(user_data.stars > 0));
  $('#date_start').val(user_data.f_date_start);
  $('#date_end').val(user_data.f_date_end);
}

function restore_from_params() {
  var parsedUrl = new URL(window.location.href);
  var params = parsedUrl.searchParams;
  var user_data = {};
  for (var pair of params.entries()) { user_data[pair[0]] = pair[1]; }
  post_user(user_data);
}

$(document).on("change", ".user-input", function() {
  pagination.page = 1;
  post_user();
});

$(document).on("input", "#user-search", function() {
  pagination.page = 1;
  post_user();
});

$(document).on("click", ".page", function(e) {
  e.preventDefault();
  pagination.page = $(this).data().page;
  post_user();
});

$(document).on("click", ".page-move", function(e) {
  e.preventDefault();
  pagination.page += $(this).data().change;
  post_user();
});

$(document).on("click", ".status-control", function() {
  var t = $(this);
  call_data = {user_id: t.data().userId, status: t.val()};
  $.post("/index.php?module=OfflineSale", {call_data: JSON.stringify(call_data)}, function(r) {
    t.parent().html("<div style='margin: 8px;'>Последний звонок: только что</div>");
  });
});

$(document).on("click", ".comment-submit", function() {
  var btn = $(this);
  var ta = btn.siblings('textarea.comment-text');
  comment_data = {user_id: btn.data().userId, text: ta.val()};
  $.post("/index.php?module=OfflineSale", {comment_data: JSON.stringify(comment_data)}, function(r) {
    ta.val('');
    ta.siblings('.comment-list').append("<div>" + comment_data.text+ "</div>");
  });
});

$(document).on("click", ".user-link", function(e) {
  e.preventDefault();
  var user_id = $(this).data().userId;
  $('.additional-info[data-user-id="'+user_id+'"]').toggleClass('hidden');
});
$(document).on("focus", "#call_date_end", function(e) {
  if($(this).val() == ''){
    $(this).val(moment().subtract(14, 'days').format("YYYY-MM-DD"));
  }
});

$(document).on("click", ".move-to-bin", function(e) {
  e.preventDefault();
  var t = $(this);
  result = window.confirm("Переместить пользователя в корзину?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {move_user_id_to_bin: user_id}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div class="alert alert-success" role="alert" style="margin-top: 6px;">Пользователь отправлен в корзину</div>');
      }
    });
  }
});

$(document).on("click", ".send-app-link", function(e) {
  e.preventDefault();
  var t = $(this);
  var platform = t.data().platform;
  result = window.confirm("Отправить клиенту СМС со ссылкой на приложение " + platform.charAt(0).toUpperCase() + platform.slice(1) + "?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {send_app_link_to_user: user_id, platform: platform}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div class="alert alert-success" role="alert">Клиенту отправлен СМС со ссылкой</div>');
      }
    });
  }
});

$(document).on("click", ".send-wallet-link", function(e) {
  e.preventDefault();
  var t = $(this);
  var platform = t.data().platform;
  result = window.confirm("Отправить клиенту СМС со ссылкой на карту Wallet?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {send_wallet_link_to_user: user_id}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div class="alert alert-success" role="alert">Клиенту отправлен СМС со ссылкой</div>');
      }
    });
  }
});


$(document).on("click", ".app-installed", function(e) {
  e.preventDefault();
  var t = $(this);
  result = window.confirm("Приложение установлено?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {app_installed: user_id}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div style="color:#3c763d;">Готово</div>');
      }
    });
  }
});

</script>
{/literal}
