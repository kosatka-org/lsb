<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.6/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script src="/js/are_you_ie.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/moment.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/locale/ru.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment-range/2.2.0/moment-range.min.js"></script>

<script>
{if $Pparam}
    window.period_param = '{$Pparam}';
{/if}
</script>
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
        <!-- Вкладки /-->
{if $smarty.session.user->group_id == 9 || $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 13}
        <div class="ShAA_kassirInset ShAA_mobileDisabled">
                <span>Покупки</span>
                <span>&nbsp;/&nbsp;
                <span><a href="index.php?module=OfflineSales&calls=1">Клиенты</a></span>
        </div>
{/if}
        <!-- /Вкладки /-->
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        <div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20 ShAA_mobileDisabled"><a href="https://www.youtube.com/embed/iT6G2z1HAb0" target="_blank">Видео инструкция</a></div>
        {if $smarty.session.user->group_id == 13}<div style="float: right; margin-right: 12px; padding-top: 4px;" class="mt20 ShAA_mobileDisabled"><a href='/index.php?module=OfflineSales&sale_brands=1' target="_blank">Таблица скидок</a></div>{/if}
    </div>
  </div>
  <div class="row mt20">
    <!--<div class="col-md-4 ShAA_searchBlockOffline" id="right-column">
    <label>Поиск покупки</label>
      <div class="input-group">
        <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
        <input id="order-input" type="text" class="form-control" placeholder="Введите номер покупки" autofocus>
      </div>
    </div>-->
    <div class="col-md-8" id="left-column">
      <!--<div class="row"><div class="col-md-6"><h4>зп</h4></div></div>-->
      <!--<div class="row">
        <div class="col-md-12" onClick="$(this).next().slideToggle();"><h4>Клиенты</h4></div>
        <div class="row" style="display:none;">
          <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
            <div class="col-md-4">Имя</div>
            <div class="col-md-4">Телефон / Карта</div>
            <div class="col-md-4">Cкидка / Бонус</div>
          </div>
          {foreach from=$users item=user}
            <div class="row user-row mt20">
              <div class="col-md-4">{$user->name}</div>
              <div class="col-md-4">{$user->phone_number}<br>{$user->card_number}</div>
              <div class="col-md-4">{$user->personal_discount}%</div>
            </div>
            <hr class="mt40">
          {/foreach}
        </div>
      </div>-->
      <form action="index.php?module=OfflineSales&storeroom{if $smarty.get.underling}&underling={$smarty.get.underling}{/if}" method="post">
        <div class="row">
          <div class="form-group mt20 col-md-4">
            <select class="form-control" name="period" id="month">
            </select>
          </div>
          <div class="form-group mt20 col-md-4">
            <input class="btn btn-primary" type="submit" value="Выбрать" style="padding: 6px 12px;">
          </div>
        </div>
      </form>
      <div class="row">
        <h4>Продажи</h4>
        <div class="col-md-12">
        {if $sales_today}
          <div class="row">
            <div class="col-xs-6 ">За день:</div>
            <div class="col-xs-6" style="text-align:right;">{$sales_today|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></div>
          </div>
        {/if}
        {if $sales_this_month}
          <a href="/index.php?module=OfflineSales&manager_orders=1">
            <div class="row">
              <div class="col-xs-6">С начала месяца:</div>
              <div class="col-xs-6" style="text-align:right;">{$sales_this_month|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></div>
            </div>
          </a>
        {/if}
        {if $debts[0]->debt_total}
          <div class="row" style="cursor:pointer;" onClick="$(this).next().slideToggle();">
            <div class="col-xs-6">Невыплаченные долги по продажам:</div>
            <div class="col-xs-6" style="text-align:right;color:{if $debts[0]->debt_total > $smarty.session.user->debt_limit}red{else}green{/if};">{$debts[0]->debt_total|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></div>
            {if $debts[0]->debt_total > $smarty.session.user->debt_limit}<div class="col-xs-6" style="color:red">Превышен лимит по продажам в долг!</div>{/if}
          </div>
          <div class="row" style="display:none">
            <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
              <div class="col-md-4">Имя</div>
              <div class="col-md-4">Телефон</div>
              <div class="col-md-4" style="text-align:right;">Долг</div>
            </div>
            {foreach from=$debts item=user}
              <div class="row user-row mt20">
                <div class="col-md-4">{$user->name}</div>
                <div class="col-md-4"><a href="tel:{$user->phone_number}">{$user->phone_number}</a></div>
                <div class="col-md-4" style="text-align:right;" >
                <b>{$user->debt_total|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></b><br/>
                {foreach from=$user->debts item=debt}
                  <a href="/index.php?module=OfflineSales&debt={$debt->id}">{$debt->sum|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></a><br/>
                {/foreach}
                </div>
              </div>
              <hr class="mt40">
            {/foreach}
          </div>
          </div>
        {/if}
      </div>
      {if $mtm_today || $mtm_this_month || $debts_mtm[0]->debt_total}
      <div class="row">
        <h4>Индивидуальный пошив</h4>
        <div class="col-md-12">
        {if $mtm_today}
          <div class="row">
            <div class="col-xs-6 ">За день:</div>
            <div class="col-xs-6" style="text-align:right;">{$mtm_today|number_format:0:",":" "}</div>
          </div>
        {/if}
        {if $mtm_this_month}
          <div class="row">
            <div class="col-xs-6">С начала месяца:</div>
            <div class="col-xs-6" style="text-align:right;">{$mtm_this_month|number_format:0:",":" "}</div>
          </div>
        {/if}
        {if $debts_mtm[0]->debt_total}
          <div class="row" style="cursor:pointer;" onClick="$(this).next().slideToggle();">
            <div class="col-xs-6">Невыплаченные долги по пошиву:</div>
            <div class="col-xs-6" style="text-align:right;">{$debts_mtm[0]->debt_total|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></div>
          </div>
          <div class="row" style="display:none">
            <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
              <div class="col-md-4">Имя</div>
              <div class="col-md-4">Телефон</div>
              <div class="col-md-4" style="text-align:right;">Долг</div>
            </div>
            {foreach from=$debts_mtm item=user}
              <div class="row user-row mt20">
                <div class="col-md-4">{$user->name}</div>
                <div class="col-md-4"><a href="tel:{$user->phone_number}">{$user->phone_number}</a></div>
                <div class="col-md-4" style="text-align:right;" >
                <b>{$user->debt_total|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></b><br/>
                {foreach from=$user->debts item=debt}
                  <a href="/index.php?module=OfflineSales&debt={$debt->id}">{$debt->sum|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></a><br/>
                {/foreach}
                </div>
              </div>
              <hr class="mt40">
            {/foreach}
          </div>
        {/if}
        </div>
      </div>
      {/if}
      {if $services_today || $services_this_month}
      <div class="row">
        <h4>Услуги</h4>
        <div class="col-md-12">
        {if $services_today}
          <div class="row">
            <div class="col-xs-6 ">За день:</div>
            <div class="col-xs-6" style="text-align:right;">{$services_today|number_format:0:",":" "}</div>
          </div>
        {/if}
        {if $services_this_month}
          <div class="row">
            <div class="col-xs-6">С начала месяца:</div>
            <div class="col-xs-6" style="text-align:right;">{$services_this_month|number_format:0:",":" "}</div>
          </div>
        {/if}
        <!--{if $debts_serv[0]->debt_total}
          <div class="row" style="cursor:pointer;" onClick="$(this).next().slideToggle();">
            <div class="col-xs-6">Невыплаченные долги по услугам:</div>
            <div class="col-xs-6" style="text-align:right;">{$debts_serv[0]->debt_total|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></div>
          </div>
          <div class="row" style="display:none">
            <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
              <div class="col-md-4">Имя</div>
              <div class="col-md-4">Телефон</div>
              <div class="col-md-4" style="text-align:right;">Долг</div>
            </div>
            {foreach from=$debts_serv item=user}
              <div class="row user-row mt20">
                <div class="col-md-4">{$user->name}</div>
                <div class="col-md-4"><a href="tel:{$user->phone_number}">{$user->phone_number}</a></div>
                <div class="col-md-4" style="text-align:right;" >
                <b>{$user->debt_total|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></b><br/>
                {foreach from=$user->debts item=debt}
                  {if $debt->id}<a href="/index.php?module=OfflineSales&debt={$debt->id}">{$debt->sum|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></a>{else}{$debt->sum|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i>{/if}<br/>
                {/foreach}
                </div>
              </div>
              <hr class="mt40">
            {/foreach}
          </div>
        {/if}-->
        </div>
      </div>
      {/if}
      {if $users->called || $users->bought}
      <div class="row">
        <h4>Клиенты</h4>
        <div class="col-md-12">
          <div class="row" style="cursor:pointer;font-size:18px;" onClick="$(this).next().slideToggle();">
            <div class="col-xs-6">Всего:</div>
            <div class="col-xs-6" style="text-align:right;">{$users->total|number_format:0:",":" "}</div>
          </div>
          <div class="row" style="display:none;">
            <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
              <div class="col-md-6">Имя</div>
              <div class="col-md-6" style="text-align:right;">Телефон</div>
            </div>
            {foreach from=$users_list item=user}
              <div class="row user-row mt20">
                <div class="col-md-6"><a target="_blank" href="/index.php?module=OfflineSales&edit_user_id={$user->user_id}">{$user->name}<br/>Редактировать</a></div>
                <div class="col-md-6" style="text-align:right;"><a href="tel:{$user->phone_number}">{$user->phone_number}</a></div>
              </div>
              <hr class="mt40">
            {/foreach}
          </div>
          {if $users->called}
          <div class="row">
            <div class="col-xs-6 ">Звонили:</div>
            <div class="col-xs-6" style="text-align:right;">{$users->called|number_format:0:",":" "}</div>
          </div>
          {/if}
          {if $users->bought}
          <div class="row" style="cursor:pointer;font-size:18px;" onClick="$(this).next().slideToggle();">
            <div class="col-xs-6 ">Купили:</div>
            <div class="col-xs-6" style="text-align:right;">{$users->bought|number_format:0:",":" "}</div>
          </div>
          <div class="row" style="display:none">
            <div class="row mt20 ShAA_titleOfTable" style="border-bottom: 1px solid #ccc; padding-bottom: 12px;">
              <div class="col-md-4">Имя</div>
              <div class="col-md-4">Телефон</div>
              <div class="col-md-4" style="text-align:right;">Сумма</div>
            </div>
            {foreach from=$purchases item=user}
              <div class="row user-row mt20">
                <div class="col-md-4">{$user->name}</div>
                <div class="col-md-4"><a href="tel:{$user->phone_number}">{$user->phone_number}</a></div>
                <div class="col-md-4" style="text-align:right;" >
                {foreach from=$user->purchases item=purchase}
                  <a href="/index.php?module=OfflineSale&order_id={$purchase->order_id}">{$purchase->sum|number_format:0:",":" "}&nbsp;<i class="icon-rub"></i></a><br/>
                {/foreach}
                </div>
              </div>
              <hr class="mt40">
            {/foreach}
          </div>
          {/if}
        </div>
      </div>
      {/if}
      {if $mc_today->success || $mc_today->sms_app || $mc_today->sms_wal || $mc_month->success || $mc_month->sms_app || $mc_month->sms_wal}
      <div class="row">
        <h4>Звонки</h5>
        <div class="col-md-12">
        {if $mc_today->success}
          <div class="row">
            <div class="col-xs-6 "><h5>Дозвонились/Не дозвонились</h5></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_today->success|number_format:0:",":" "} / {$mc_today->fail|number_format:0:",":" "}</h5></div>
          </div>
          <div class="row">
            <div class="col-xs-6 "><h5>Уникальных</h5></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_today->uniq->success|number_format:0:",":" "} / {$mc_today->uniq->fail|number_format:0:",":" "}</h5></div>
          </div>
        {/if}
        {if $mc_today->sms_app}
          <div class="row">
            <div class="col-xs-6"><h5>СМС на приложение (авторизовано):</h5></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_today->sms_app|number_format:0:",":" "} ({$mc_today->app_install|number_format:0:",":" "})</h5></div>
          </div>
        {/if}
        {if $mc_today->sms_wal}
          <div class="row">
            <div class="col-xs-6"><h5>СМС с wallet-карточкой(загружено):</h5></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_today->sms_wal|number_format:0:",":" "} ({$mc_today->wal_downloads|number_format:0:",":" "})</h5></div>
          </div>
        {/if}
        </div>
      </div>
      {/if}
      {if $mc_month->success || $mc_month->sms_app || $mc_month->sms_wal}
      <div class="row">
        {if $mc_today->success || $mc_today->sms_app || $mc_today->sms_wal}<h5>За месяц</h5>{/if}
        <div class="col-md-12">
        {if $mc_month->success}
          <div class="row">
            <div class="col-xs-6"><h5>Дозвонились/Не дозвонились</h5></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_month->success|number_format:0:",":" "} / {$mc_month->fail|number_format:0:",":" "}</h5></div>
          </div>
          <div class="row">
            <div class="col-xs-6"><h5>Уникальных</h5></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_month->uniq->success|number_format:0:",":" "} / {$mc_month->uniq->fail|number_format:0:",":" "}</h5></div>
          </div>
        {/if}
        {if $mc_month->sms_app}
          <div class="row">
            <div class="col-xs-6"><h5>СМС на приложение (авторизовано):</h5></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_month->sms_app|number_format:0:",":" "} ({$mc_month->app_install|number_format:0:",":" "})</h5></div>
          </div>
        {/if}
        {if $mc_month->sms_wal}
          <div class="row">
            <div class="col-xs-6"><h5>СМС с wallet-карточкой(загружено):</h4></div>
            <div class="col-xs-6" style="text-align:right;"><h5>{$mc_month->sms_wal|number_format:0:",":" "} ({$mc_month->wal_downloads|number_format:0:",":" "})</h5></div>
          </div>
        {/if}
        </div>
      </div>
      {/if}
      {if $underlings}
      <div class="row">
        <h4>Подшефные</h4>
        <div class="col-md-12">
        {foreach from=$underlings item=ud}
          <div class="row">
            <a target='_blank' href="/index.php?module=OfflineSales&storeroom&underling={$ud->manager}">{$ud->name}&nbsp;</a><br/>
          </div>
        {/foreach}
        </div>
      </div>
      {/if}
    </div>
    </div>
    <!--<div class="col-md-8" style="padding-left: 0;">
      <h3 id="found-orders-title" style="display:none;">Список покупок</h3>
      <div id="found-orders">
      </div>
    </div>-->
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="order-template" type="text/x-handlebars-template">
  <button type='button' id="back-to-orders" class='btn btn-default'>Назад к списку покупок</button>
  {{#each orders}}
    <div class="panel panel-default mt10">
      <div class="panel-heading">
       Покупка №<b>{{this.receipt_number}}</b> {{this.cashbox_name}} - {{this.date}} (<a href="/index.php?module=OfflineSale&order_id={{this.order_id}}" target="_blank">Изменить</a>)
<!--    Вот здесь какое-то условие, что это this.cashbox_name == 'услуги'
           <a href="/index.php?module=OfflineSale&act={$order->order_id}" target="_blank" style="float: right;">/ акт</a>
-->
       <a href="/index.php?module=OfflineSale&receipt_for={{this.order_id}}" target="_blank" style="float: right;">чек&nbsp;</a>
      </div>
      {{#if this.user.name}}
      <div class="panel-heading">
          <b>{{this.user.name}}</br> {{this.user.phone_number}}</b> </br>{{#if this.user.personal_discount}}бонус от <b>{{this.user.personal_discount}}%</b>{{/if}}
      </div>
      {{/if}}
      <div class="panel-body">
        {{#each this.products}}
          <div class="row ShAA_salesItemOff">
            <div class="col-md-3 mt10">{{this.product_name}}</div>
            <div class="col-md-2 mt10">{{this.sku}}</div>
            <div class="col-md-2 mt10">{{this.color}}</div>
            <div class="col-md-2 mt10">{{this.size}}</div>
            <div class="col-md-3 mt10" style="text-align: right;">{{this.price}}₽</div>
          </div>
        {{/each}}
        <div class="row">
          <div class="col-md-6 col-md-offset-6 mt10" style="text-align: right;">Всего: <b>{{this.total_sum}}</b>₽</div>
        </div>
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


var order_query_running = false;
var order_query_queue = [];
var $order_list = [];

post_order = function(order_query) {
  if (order_query_running) {
    order_query_queue.push(order_query);
    return false;
  }
  order_query_running = true;
  order_query_queue = [];
  $.get("/index.php?module=OfflineSales", {order_query: order_query}, function(orders) {
    $order_list = orders;
    var u = Template.order({orders: $order_list});
    $('#found-orders').html(u);
    order_query_running = false;
    if (order_query_queue.length > 0) {
      post_order(order_query_queue.pop());
    }
    $('#order-list').hide();
    $('#found-orders').show();
    $('#found-orders-title').show();
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
  post_order($(this).val());
});

$(document).on("click", "#back-to-orders", function() {
  $('#order-list').show();
  $('#found-orders').hide();
  $('#found-orders-title').hide();
  $("#order-input").val('');
});
$(document).on("ready", function() {
  moment.locale('ru');
  var year = new Date(2018, 3);
  var range = moment.range(year, Date.now());
  var cont = $('select#month');
  var now = moment();
  range.by("months", function(period) {
    var html = "<option value='" + period.format("Y-MM") + "'>" + period.format("MMMM Y") + "</option>";
    cont.prepend(html);
  });
  $('option[value="'+window.period_param+'"]').attr("selected",true);
});
</script>
{/literal}
