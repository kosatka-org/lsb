{include file="offline_js.tpl"}

{if $config->enviroment == 'live'}
  <script src="//d2wy8f7a9ursnm.cloudfront.net/v4/bugsnag.min.js"></script>
  <script>window.bugsnagClient = bugsnag('0e17cb08065a63f14237abf91499cea3')</script>
{/if}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <div class="col-md-4" style="float: right;">
            <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
        </div>
        <div class="col-md-8" style="margin-top: 24px; float: left;">
          {if $cashbox->name == "Услуги"}
            <h2>Заказ на услуги №{$order_data->receipt_number} от {$order_data->w_date}</h2>
          {else}
            {if $order_id}
              <h2>Покупка №{$order_data->receipt_number}{if $return} - Оформление возврата{/if}</h2>
            {/if}
            <h3 class="ShAA_mobileInvisible">{$cashbox->name}</h3>
            <p class="ShAA_mobileInvisible">{$cashbox->description}</p>
          {/if}
          {if $order_data->status == 3}<h2 style="color:red;">Отменено</h2>{/if}
        </div>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-8" id="left-column">
      <div id="create-form" class="anchor mt20" style="display:none;">
        <!--Anchor for form-template-->
      </div>

      {if $cashbox->name == "Индивидуальный пошив"}
        <h3>Индивидуальный пошив</h3>
      {else}
        <h3 class="ShAA_mobileInvisible">Товары</h3>
        {if $cashbox->name != "Услуги"}
        <div class="row">
          <div class="form-group mt20 col-md-4">
            <label>Продавец для всего заказа</label>
            <select id="manager-all" class="form-control" onchange="set_default_manager(this);"{if !$editable} disabled{/if}>
              <option value="0">Не выбран</option>
              {foreach from=$off_managers item=mm}
                <option value="{$mm->manager_id}">{$mm->manager_name}</option>
              {/foreach}
            </select>
          </div>
        </div>
        {/if}
      {/if}
      <div class="row ShAA_titleOfTable">
        <div class="col-md-2 mt10"></div>
        <div class="col-md-3 mt10">Наименование</div>
        <div class="col-md-2 mt10">Размер</div>
        <div class="col-md-2 mt10">Цена</div>
        {if $cashbox->name != "Индивидуальный пошив"}
          <div class="col-md-2 mt10">Скидка(%)</div>
        {else}
          <div class="col-md-2 mt10">Статус</div>
        {/if}
        <div class="col-md-1 mt10"></div>
      </div>
      <div id="product-list">
        <!--Anchor for orderProduct-template-->
      </div>

      {if $cashbox->name == "Индивидуальный пошив"}
        <div class="row">
          <div class="form-group mt20 col-md-4">
            <label>Бренд</label>
            <select id="mtm-brand-id" class="form-control">
              <option value="0">Не выбран</option>
              {foreach from=$brands item=bb}
                <option value="{$bb->brand_id}">{$bb->name}</option>
              {/foreach}
            </select>
          </div>
        </div>
      {/if}

      <div class="total-order-info" style="margin-top: 25px; border-top: 1px solid #000; padding-top: 12px; text-align: right; font-size: 20px;">
        {if !$return}
          Всего: <span id="total-sum" style="font-weight: 700">0</span>₽
        {else}
          Возврат: <span id="total-return" style="font-weight: 700">0</span>₽
        {/if}
      </div>
      <div class="order-button-group mt20">
        {if $cashbox->name == "Индивидуальный пошив"}
          <div style="float: left; margin: 0 24px 20px 0;">
            <button id="add-mtm-button" type="button" class="btn btn-primary">Добавить пошив</button>
          </div>
          <div class="clearfix"></div>
        {/if}
        <div style="float: left; margin: 4px 24px 0 0">
            <button id="order-button" type="button" class="btn btn-primary" disabled="disabled">Оформить покупку</button>
        </div>
        <div style="margin-top: 1px;">
            <b style="font-size: 22px;">{$cashbox->name}</b>
        </div>
      </div>

      <div id="payment-options" class="mt20">
      </div>

      <div id="payment-buttons" style="display: none;">
        {if !$return}
        <div style="width: 100%; float: left;">
            <div style="float: left;">
                <button id="add-payment" class="btn btn-primary mt20">Добавить способ оплаты</button>
            </div>
            <div class="total-payment-info" style="text-align: right; float: right; margin-top: 25px;">
                Оплачено: <span id="total-paid" style="font-weight: 700"></span>₽ <span style="font-weight: 700; display: none;" id="total-sum2"></span>
            <br>
                <span id="remaining_cont">К оплате: <span id="remaining" style="font-weight: 700"></span>₽</span>
            </div>
        </div>
        <div style="clear:both;"></div>
        <div id="comment_block" class="mt20">
          <div class="form-group">
            <label>Комментарий</label>
            <textarea id="comment" class="form-control" rows="3"></textarea>
          </div>
        </div>
        <div>
          <a id="get-receipt" class="btn btn-primary mt20 pull-right" href="" target="_blank">Распечатать товарный чек</a>
          <button id="submit-payment" class="btn btn-danger mt20">Сохранить</button>
          <button id="submit-comment" class="btn btn-success mt20 hidden">Сохранить комментарий</button>
        </div>
        {if $cashbox->device_uuid != ""}
          <button id="submit-online-cashbox" class="btn btn-success mt20">Отправить чек в онлайн-кассу</button>
        {/if}
        <b class="mt20 ShAA_mobileInvisible" style="font-size: 22px; display: inline-block; vertical-align: middle;">{$cashbox->name}</b>
        {else}
          <h4>Возврат</h4>
          <div class="form-inline">
            <select id="return_cashbox" class="form-control">
              {foreach from=$cashboxes item=cb}
                <option value="{$cb->id}">{$cb->name}</option>
              {/foreach}
            </select>

            <select id="return_method" class="form-control">
              {foreach from=$return_options item=ro}
                <option value="{$ro->id}">{$ro->name}</option>
              {/foreach}
            </select>
            <button id="submit-return" class="btn btn-danger">Оформить возврат</button>
          </div>
        {/if}
      </div>

      <div id="managers">
      </div>
    </div>


      <div class="col-md-4" id="right-column">

        {if !$return}
        <div class="panel-group mt20" id="accordion" role="tablist" aria-multiselectable="true">
          {if $cashbox->name != "Индивидуальный пошив"}
          <div class="panel panel-default">
            <div class="panel-heading" role="tab" id="heading_products">
              <h4 class="panel-title">
                <a role="button" data-toggle="collapse" data-parent="#accordion"{if $editable} href="#collapse_products"{/if} aria-expanded="true" aria-controls="collapseOnecollapse_products">
                  <b>Поиск товара</b>
                </a>
              </h4>
            </div>
            <div id="collapse_products" class="panel-collapse collapse{if $editable} in{/if}" role="tabpanel" aria-labelledby="heading_products"{if !$editable} style='height:0;'{/if}>
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
                <a role="button" data-toggle="collapse" data-parent="#accordion"{if $editable} href="#collapse_users"{/if} aria-expanded="false" aria-controls="collapseOnecollapse_users">
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
        </div>
        {/if}

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
        {{this.model}}, <span style="color: #ff00ff; cursor: pointer;" onClick="$('#barcode-input').val('{{this.sku}}');$('#refresh').click();">{{this.sku}}</span>{{#if this.size}},
        размер {{this.size}}{{/if}}{{#if this.color_name}}, цвет {{this.color_name}}{{/if}}{{#if this.quantity}}, {{this.quantity}} шт в {{this.shop_name}}{{/if}}
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
  <div class="row mt10 ShAA_orderItemsOff">
    <div class="col-md-2 ShAA_mobImgItem">{{#if large_image}}<img class="img-thumbnail" src="/reimg/files/products/85x/{{large_image}}">{{/if}}</div>
    {{#if_editable}}
      <div class="col-md-1 mt20" style="float: right;">
        <button type="button" class="close remove-product off" aria-hidden="true" data-unique-id="{{unique_id}}">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </div>
    {{/if_editable}}

    <div class="col-md-3 mt20"><b>{{#if product_name}}{{product_name}}{{else}}{{model}}{{/if}}</b>{{#if sku}}<br>артикул: {{sku}}{{/if}}</div>
    <div class="col-md-2 mt20">{{#if_editable}}<input class="size" style="width: 100%;" data-unique-id="{{unique_id}}" type="text" value="{{size}}">{{else}}{{size}}{{/if_editable}}</div>

    <div class="col-md-2 mt20">
      {{#if_editable}}
        <input class="price-input" style="width: 100%;" data-unique-id="{{unique_id}}" type="number" step="100" value="{{price}}">
      {{else}}
        <b>{{formatNumber price}}</b>
      {{/if_editable}}
      <br>
      {{#if last_price}}
        <span style="color: red; cursor: help;" title="последняя цена">{{formatNumber last_price}}</span>
      {{/if}}
    </div>

    {{#if returned}}
      <div class="col-md-2 mt20">
        <b>Оформлен возврат</b><br/>{{formatDate_с status_date}}
      </div>
    {{else}}
      {{#if_return}}
        <div class="col-md-2 mt20">
          <label><input class="return_chk" type="checkbox" data-unique-id="{{unique_id}}"> Возврат</label>
        </div>
      {{else}}
        <div class="col-md-2 mt20">
          {{#if_editable}}
            <input class="discount-input" style="width: 100%;" data-unique-id="{{unique_id}}" type="number" step="10" min="0" max="100" value="{{discount}}">
          {{else}}
            {{#if discount}}{{discount}}{{else}}0{{/if}}%
          {{/if_editable}}
        </div>
      {{/if_return}}
    {{/if}}
  </div>

  {{#unless_service}}
  <div class="row" id="manager_{{unique_id}}">
    <div class="form-group mt20 col-md-4">
      <label>Продавец</label>
      <select class="form-control select-manager" {{#unless_editable}}disabled{{/unless_editable}} data-unique-id="{{unique_id}}" onchange="update_managers();">
        <option value="0">Не выбран</option>
        {{#each managers}}
          <option value="{{this.manager_id}}">{{this.manager_name}}</option>
        {{/each}}
      </select>
    </div>
  </div>
  {{/unless_service}}
  <hr>
</script>

<script id="orderMtm-template" type="text/x-handlebars-template">
  <div class="row mt10 mtm-item">
    <div class="col-md-4 mt20">
      <select id="name_{{product.id}}" class="name form-control" style="width: 100%;">
        {{#each mtm_name_list}}
          <option value="{{this}}">{{this}}</option>
        {{/each}}
      </select>
    </div>
    <div class="col-md-2 mt20">
      <input class="size form-control" style="width: 100%;" type="text" value="{{product.size}}">
    </div>
    <div class="col-md-2 mt20">
      <input class="price-input form-control" style="width: 100%;" type="number" step="100" value="{{#if product.price}}{{product.price}}{{else}}0{{/if}}">
    </div>
    <div class="col-md-3 mt20">
      <select class='status-input form-control' id="status_{{product.id}}" style="width: 100%;">
        {{#each mtm_status_list}}
          <option value="{{this.name}}">{{this.name}}</option>
        {{/each}}
      </select>
    </div>
    <div class="form-group mt20 col-md-4">
      <label>Продавец</label>
      <select class="form-control mtm-manager" id="mtm_manager_{{product.id}}">
        <option value="0">Не выбран</option>
        {{#each manager_list}}
        <option value="{{this.manager_id}}">{{this.manager_name}}</option>
        {{/each}}
      </select>
    </div>
  </div>
  <hr>
</script>


<script id="selectedUser-template" type="text/x-handlebars-template">
  <span class="ShAA_mobileInvisible">Покупатель:</br></span>
  <div class="row mt10" style="margin: 15px 0px;">
    <div class="col-md-11" style="padding-left: 0;">
        <div><b>{{name}}</b></span></div>
        <div class="mt20"><b>{{phone_number}}</b></div>
        <div class="mt20">{{#if personal_discount}}Бонус от <b>{{personal_discount}}%</b>{{/if}}</div>
        <div class="mt20">{{#if deposit_value}}Баланс депозита: <b>{{deposit_value}}</b>{{/if}}</div>
        <div class="mt20"><a href="/index.php?module=OfflineSales&edit_user_id={{user_id}}" target="_blank">редактировать</a></div>
        <div class="mt20"><a href="#" class="btn btn-primary send-app-link" data-user-id="{{user_id}}" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на приложение"><i class="icon-envelope"></i> &#8594; <i class="icon-apple"></i>&nbsp;/&nbsp;<i class="icon-android"></i></a></div>
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
  <div class="form-inline payment-option mt20" {{#if payment.id}}data-payment-id="{{payment.id}}"{{/if}}>
    {{#if editable}}
      <div class="form-group" style="float: right;">
        <button type="button" class="close remove-payment off" data-payment-id="{{payment.id}}" aria-hidden="true">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </div>
    {{/if}}
    <div class="form-group">
      <label>Способ</label>
      <select class="form-control payment-select" {{#unless editable}}disabled{{/unless}} onchange="payment_additional_input(this); check_evotor();">
        {{#each payment_options}}
          <option value="{{this.id}}" data-evotor="{{this.evotor}}" {{#if this.selected}}selected{{/if}}>{{this.name}}</option>
        {{/each}}
        {{#each return_options}}
          <option value="{{this.id}}" {{#if this.selected}}selected{{/if}}>{{this.name}}</option>
        {{/each}}
      </select>
    </div>
    <div class="form-group">
      <label for="payment-amount">Сумма</label>
      <input type="number" min="0" class="form-control payment-amount" {{#unless editable}}disabled{{/unless}} style="max-width: 120px; margin-right: 6px;" value="{{#if payment}}{{payment.money_paid}}{{else}}{{remaining}}{{/if}}">
      <select class="form-control debt-responsible-user" {{#unless editable}}disabled{{/unless}} style="display: none;">
        {{#each responsible_users}}
          <option value="{{this.id}}" {{#if this.selected}}selected{{/if}}>{{this.name}}</option>
        {{/each}}
      </select>
    </div>
    <div class="form-group debt-input" {{#unless payment.is_debt}}style="display: none;"{{/unless}}>
      <label>Вернуть до:</label>
      <input type="text" class="form-control debt-by-date" {{#unless editable}}disabled{{/unless}} data-provide="datepicker" data-date-format="yyyy-mm-dd" data-date-start-date="1d" data-date-language="ru" value="{{payment.debt_by_date}}">
    </div>
    {{#if payment.paid}}
      <div class="form-group">
        <label for="cashbox-select">Оплачено</label>
      </div>
    {{/if}}
    {{#if payment.unpaid}}
      <div class="form-group">
        <label for="cashbox-select">
          <button class="btn btn-clipboard" style="margin:0;" data-clipboard-text="/spay/{{payment.hash}}/">
            <i class="icon-copy"></i>
          </button>
        </label>
      </div>
    {{/if}}
    {{#if_service}}
      <div class="form-group">
        <label for="cashbox-select">Касса</label>
        <select class="form-control cashbox-id">
          {{#select payment.cashbox_id}}
            {{#each cashboxes}}
              <option value="{{this.id}}">{{this.name}}</option>
            {{/each}}
          {{/select}}
        </select>
      </div>
    {{/if_service}}
  </div>
  {{#if payment.is_debt}}
    <div class="form-inline payment-option mt20">
      {{#if payment.debt_payments}}
        <div class="form-inline payment-option mt20">
        Выплаты долга:
        {{#each payment.debt_payments}}
          <div class="row"><div class="col-md-3">{{this.name}}</div><div class="col-md-2">{{this.money_paid}}</div><div class="col-md-3">{{this.date}}</div></div>
        {{/each}}
        </div>
      {{/if}}
      <div class="form-inline payment-option mt20">
        Оплачено: {{payment.total_debt_paid}}₽
        {{#if payment.show_debt_link}}<a href="/index.php?module=OfflineSales&debt={{payment.id}}" target="_blank" style="float:right;" title="Перейти на страницу долга">Перейти на страницу долга</a>{{/if}}
      </div>
    </div>
  {{/if}}
</script>

<!-- /Templates -->
{/literal}

<script id="data-order" type="application/json">
  {$order}
</script>

<script id="data-managers" type="application/json">
  {$managers_json}
</script>

<script id="data-payment-options" type="application/json">
{$payment_options}
</script>

<script id="data-return-options" type="application/json">
{$return_options_json}
</script>

<script id="data-responsible-users" type="application/json">
  {$cashbox->debt_users}
</script>

<script id="data-cashboxes" type="application/json">
{$cashboxes_json}
</script>

<script>
{literal}
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

// dec2hex :: Integer -> String
function dec2hex (dec) {
  return ('0' + dec.toString(16)).substr(-2)
}

// generateId :: Integer -> String
function generateId (len) {
  var arr = new Uint8Array((len || 40) / 2)
  window.crypto.getRandomValues(arr)
  return Array.from(arr, dec2hex).join('')
}

Handlebars.registerHelper('select', function(value, options) {
  var $elem = $('<select />').html( options.fn(this) );
  $elem.find('[value="' + value + '"]').attr({'selected':'selected'});
  return $elem.html();
})

Handlebars.registerHelper('formatDate_с', function(date) {
  var moment_obj = moment(date)
  if (moment_obj._isValid) {
    if (moment_obj.format("YY") == moment().format("YY")){
      return moment_obj.format("DD.MM");
    }
    else{
      return moment_obj.format("DD.MM.YYYY");
    }
  }
  else {
    return false;
  }
});

Handlebars.registerHelper('if_editable', function(options) {
  if (editable()) {
    return options.fn(this);
  }
  else {
    return options.inverse(this);
  }
});

Handlebars.registerHelper('unless_editable', function(options) {
  if (editable()) {
    return options.inverse(this);
  }
  else {
    return options.fn(this);
  }
});

Handlebars.registerHelper('if_service', function(options) {
  if (is_service()) {
    return options.fn(this);
  }
  else {
    return options.inverse(this);
  }
});

Handlebars.registerHelper('unless_service', function(options) {
  if (is_service()) {
    return options.inverse(this);
  }
  else {
    return options.fn(this);
  }
});

Handlebars.registerHelper('if_return', function(options) {
  if (order.returns) {
    return options.fn(this);
  }
  else {
    return options.inverse(this);
  }
});

HandlebarsIntl.registerWith(Handlebars);
var intlData = {
    locales: 'ru-RU'
}

var Template = {};
$('script[type="text/x-handlebars-partial"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Handlebars.registerPartial(name, $(this).html());
  Template[name] = Handlebars.compile($(this).html());
});

$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var order = {products: {}};

{/literal}
var payment_options = JSON.parse($('#data-payment-options').html());
var return_options = JSON.parse($('#data-return-options').html());
payment_options = payment_options.concat(return_options);
var responsible_users = JSON.parse($('#data-responsible-users').html());
var cashboxes = JSON.parse($('#data-cashboxes').html());
var show_debts = '{$show_debts}';
order.cashbox_id = (new URLSearchParams(window.location.href)).get('cashbox_id') || '{$cashbox->id}';
order.cashbox_name = '{$cashbox->name}';
order.default_manager_id = $('#manager-all').val();
{literal}
payment_options.forEach( function(e, i) {
  if (e.name === 'Долг') {
    payment_options[i].debt = true;
  }
  if (e.name === 'Оплата депозитом') {
    payment_options[i].deposit = true;
  }
});
var $product_list = [];
var $user_list = [];
var payment = {paid: 0, remaining: 0};
var removed_payments = [];
var product_query_running = false;
var product_query_queue = [];
var mtm_status_list = [{name: "Принято"},
  {name: "В работе"},
  {name: "В бутике, ждет клиента"},
  {name: "Выдано клиенту"},
  {name: "Отказ"}];
var mtm_name_list = [
  "Рубашка",
  "Пальто",
  "Костюм",
  "Пиджак",
  "Брюки",
  "Жилет",
  "Ботинки",
  "Сникерсы",
  "Поло",
  "Свитер",
  "Куртка",
  "Кардиган",
  "Пуловер",
  "Ремень",
  "Галстук",
  "Кепка",
  "Шапка",
  "Футболка",
  "Обувь",
  "Трикотаж"
]
var mtm_brand_id;
var manager_list = JSON.parse($('#data-managers').html());



editable = function() {
  if (typeof(order.date) === "undefined" || is_service() || is_mtm()) {
    return true;
  }
  return !!order.editable;
};

is_mtm = function() {
  return order.cashbox_name === 'Индивидуальный пошив';
};

is_service = function() {
  return order.cashbox_name === 'Услуги';
};

post_product = function(product_query) {
  if (product_query.length > 3) {
    if (product_query_running) {
      product_query_queue.push(product_query);
      return false;
    }
    product_query_running = true;
    product_query_queue = [];
    $.get("/index.php?module=OfflineSale", {product_query: product_query, no_reserved: true, cashbox_id: order.cashbox_id}, function(p_list) {
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
      $('.price-input[data-unique-id="'+k+'"]').val(prd[k].price);
      return prd[k];
    });
  }
  var total = Object.keys(prd)
    .map(function (k) {
      if (prd[k].status != 4) {
        return parseInt(prd[k].price, 10);
      }
      else {
        return 0;
      }
    })
    .reduce( function(a,b) { return a + b; }, 0);
    total = accounting.formatNumber(total, 0, " ", " ");
  if (is_mtm()) { total = total_sum(); }
  $('#total-sum, #total-sum2').html(total);
  if(remaining() != 0){
    $('#remaining_cont').show();
    $('#remaining').html(remaining());
  }
  else{
    $('#remaining_cont').hide();
  }
}

display_payment = function(no_new_payments) {
  if (!no_new_payments) {
    add_payment();
  }
  $("a#get-receipt").prop("href", "/index.php?module=OfflineSale&receipt_for="+order.order_id);
  $("#payment-buttons").show();
  update_payment();
}

add_payment = function() {
  var p_opts = (is_mtm() ? payment_options.filter(function(e) { return e.return == 0 }) : payment_options);
  var html = Template.payment({payment_options: p_opts, cashboxes: cashboxes, responsible_users: responsible_users, remaining: remaining(), editable: editable()});
  $("#payment-options").append(html);
  update_payment();
}

add_manager = function() {
  var html = Template.manager({manager_list: manager_list});
  $("#managers-list").append(html);
}

update_payment = function() {
  total_paid = total_payment();
  $("#total-paid").html(accounting.formatNumber(total_paid, 0, " ", " "));
  if((total_sum() - total_paid) != 0){
    $('#remaining_cont').show();
    $("#remaining").html(accounting.formatNumber(total_sum() - total_paid, 0, " ", " "));
  }
  else{
    $('#remaining_cont').hide();
  }
  check_evotor();
}

update_discount = function() {
  $('.price-input').toArray().forEach(function(e) {
    var unique_id = $(e).data().uniqueId;
    var product = order.products[unique_id];
    var discount = Math.floor((1 - (product.price/product.offline_price))*100);
    $('.discount-input[data-unique-id="'+unique_id+'"]').val(discount);
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
  if (prd.length == 0 && !is_mtm()) {
    return 0;
  }
  else if ((prd[0] && prd[0].barcode == "") || is_mtm()) {
    return $(".price-input").toArray().map(function(el) {
      if (is_mtm() && $(el).closest('.mtm-item').find('.status-input').val() == "Отказ") {
        return 0;
      }
      else {
        return parseInt(el.value, 10);
      }
    }).reduce(function(a,b) {
      return a + b;
    }, 0);
  }
  else {
    return Object.keys(prd).map(function(k) {
        if (prd[k].status != 4) {
          return parseInt(prd[k].price, 10);
        }
        else {
          return 0;
        }
      })
      .reduce(function(a,b) {
        return a + b;
       }, 0);
  }
}

remaining = function() {
  return total_sum()-total_payment();
}

mtm_items = function() {
  return $(".mtm-item").toArray().map(function(el) {
    var data = {
      name: $(el).find('.name').val(),
      size: $(el).find('.size').val(),
      price: $(el).find('.price-input').val(),
      manager_id: $(el).find('.mtm-manager').val(),
      mtm_status: $(el).find('.status-input').val()
    };
    mtm_brand_id = +($("#mtm-brand-id").val()) || 0;
    return data;
  });
}

function payment_sum_for_method(name) {
  return $(".payment-option:visible").toArray().map(function(e) {
    if (e.dataset.paymentId || $(e).find('#payment-select option:selected:visible').text() != name) {
      return 0;
    }
    return Number($(e).find('.payment-amount').val());
  }).reduce((a,v) => a+v, 0);
}

// True if no products selected
btn_disabled = function() {
  return (($.isEmptyObject(order.products) && mtm_items().length == 0) || !!order.update_in_progress);
}

check_evotor = function() {
  var payments = $(".payment-select option:selected").toArray()
  var evotorAllowed = payments.every(function(e) {
    return e.dataset.evotor == "1"
  });
  if (evotorAllowed && payments.length > 0) {
    $('#submit-online-cashbox').removeClass('hidden');
  }
  else {
    $('#submit-online-cashbox').addClass('hidden');
  }
}

render_managers = function() {
  $('.select-manager').each(function() {
    var uniq_id = $(this).data('uniqueId');
    $(this).val(order.products[uniq_id].offline_manager_id);
  });
}

update_managers = function() {
  $('.select-manager').each(function() {
    var uniq_id = $(this).data('uniqueId');
    order.products[uniq_id].offline_manager_id = $(this).val();
  });
}

set_default_manager = function(el) {
  var m_id = $(el).val();
  $('.select-manager').each(function() {
    var uniq_id = $(this).data('uniqueId');
    $(this).val(m_id);
    order.products[uniq_id].offline_manager_id = m_id;
    order.default_manager_id = m_id;
  });
}

render_existing_order = function(order) {
  if (is_mtm()) {
    order.products.forEach(function(product) {
      html = Template.orderMtm({product: product, mtm_status_list: mtm_status_list, mtm_name_list: mtm_name_list, manager_list: manager_list});
      $('#product-list').append(html);
      $('#status_'+product.id).find("option[value='"+ product.mtm_status +"']").prop("selected", true);
      $('#name_'+product.id).find("option[value='"+ product.product_name +"']").prop("selected", true);
      $('#mtm_manager_'+product.id).find("option[value='"+ product.offline_manager_id +"']").prop("selected", true);
      update_total();
    });
    $('#mtm-brand-id').find("option[value='"+order.mtm_brand_id+"']").prop("selected", true);
    order.products = [];
  }
  else {
    var prd = {};
    order.products.forEach(function(product) {
      if (product.status == 4) {
        product.returned = true;
      }
      if (product.unique_id.length == 0) {
        product.unique_id = generateId();
      }
      product.managers = JSON.parse($('#data-managers').html());
      html = Template.orderProduct(product, {data: {intl: intlData}});
      $('#product-list').append(html);
      prd[product.unique_id] = product;
      update_total();
    });
    order.products = prd;
    update_discount();
  }
  if (order.user) {
    html = Template.selectedUser(order.user);
    $('#selected-user').html(html);
  }
  if (order.payments.length > 0 && !order.returns) {
    var is_editable = editable();
    order.payments.forEach(function(payment) {
      p_o = payment_options.map(function(e) {
        var a = {};
        if (e.id == payment.payment_id) {
          a.selected = true;
        }
        $.extend(a, e);
        return a;
      });
      if((payment.paid != 4 && payment.paid != 2) && payment.payment_id == 21){payment.unpaid = true;}
      else{payment.unpaid = false;}
      if(payment.paid == 4 || payment.paid == 2){payment.paid = true;}
      else{payment.paid = false;}
      var is_debt = payment.name === 'Долг'
      if (is_debt) {
        payment.is_debt = true;
        if (payment.total_debt_paid < parseInt(payment.money_paid)) {
          payment.show_debt_link = true;
        }
        var r_users = JSON.parse(JSON.stringify(responsible_users));
        r_users.forEach(function(r_user, index) {
          if (r_user.id === payment.responsible_person_id) {
            r_users[index].selected = true;
          }
        });
      }
      else {
        var r_users = responsible_users;
      }
      html = Template.payment({payment_options: p_o, cashboxes: cashboxes, responsible_users: r_users, payment:payment, editable: is_editable});
      $("#payment-options").append(html);
    });
  }
  $("#comment").val(order.comment);
  display_payment(true);
  render_managers();
  if (!is_mtm()) {
    $(".order-button-group").remove();
  }
}

payment_additional_input = function(t) {
  var select = $(t).parents('.payment-option').find('.debt-input');
  if ( $(t).find('option:selected').html() === 'Долг' ) {
    select.show();
    if (editable()) {
      select.removeClass('disabled');
    }
  }
  else {
    select.hide().addClass('disabled');
  }

  if ( $(t).find('option:selected').html() === 'Оплата депозитом') {
    $(t).parents('.payment-option').find('.payment-amount').val(order.user.deposit_value);
  }
}

render_save_result = function(payment_data) {
  if (payment_data) {
    payments = JSON.parse(payment_data)
    $('.payment-option').each(function(i,e) {
      e.dataset.paymentId = payments[i].id
    })
  }
  order.update_in_progress = false;
  $('#order-button, #submit-payment').removeAttr("disabled");
  $('#order-button').parent().remove();
  var no_new_payments = !!$("#payment-options").html().trim();
  display_payment(no_new_payments);
  render_managers();
}

check_debt_date = function() {
  return $(".debt-by-date:visible").toArray().some(function(e) {
    return (e.value.length == 0 || e.value == '0000-00-00 00:00:00')
  })
}

check_deposit_balance = function() {
  if (order.user) {
    return (payment_sum_for_method("Оплата депозитом") > order.user.deposit_value);
  }
  else {
    return false;
  }
}

check_debt_limit = function() {
  var debt_payment = payment_sum_for_method("Долг")
  if (debt_payment == 0) {
    return false
  }
  var man_ids = $(".select-manager").toArray().map(function(e) { return e.value })
  return man_ids.find(function(m_id) {
    var debt_limit = manager_list.find(m => m.manager_id == m_id).debt_limit
    return (debt_payment > Number(debt_limit));
  })
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
  var unique_id = $(this).data().uniqueId;
  var product = order.products[unique_id];
  if (product) {
    var discount = ((product.offline_price - price) / product.offline_price)*100;
    product.price = price;
    update_total();
    update_discount();
  }
  else {
    $('#total-sum, #total-sum2').html(total_sum());
    $('#remaining_cont').show();
    $('#remaining').html(remaining());
  }
});

$(document).on("blur", ".price-input", function() {
  var price = $(this).val();
  var unique_id = $(this).data().uniqueId;
  var product = order.products[unique_id];
  if (product) {
    var discount = ((product.offline_price - price) / product.offline_price)*100;
    var max_sale = Number(product.offline_max_sale);
    if (max_sale && discount > max_sale) {
      alert("Внимание! Размер скидки больше максимально допустимого для бренда "+product.brand_name+": "+product.offline_max_sale);
    }
  }
});

$(document).on("input", ".discount-input", function() {
  var discount = $(this).val();
  var unique_id = $(this).data().uniqueId;
  var product = order.products[unique_id];
  product.price = Math.ceil((product.offline_price * (100-discount)) / 100);
  update_total();
  $('.price-input[data-unique-id="'+unique_id+'"]').val(product.price);
});

$(document).on("blur", ".discount-input", function() {
  var discount = $(this).val();
  var unique_id = $(this).data().uniqueId;
  var product = order.products[unique_id];
  var max_sale = Number(product.offline_max_sale);
  if (max_sale && Number(discount) > max_sale) {
    alert("Внимание! Размер скидки больше максимально допустимого для бренда "+product.brand_name+": "+product.offline_max_sale);
  }
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
  product.unique_id = generateId();
  order.products[product.unique_id] = product;
  product.managers = JSON.parse($('#data-managers').html());
  var html = Template.orderProduct(product, {data: {intl: intlData}});
  $('#product-list').append(html);
  if (order.default_manager_id) {
    $('.select-manager[data-unique-id="'+product.unique_id+'"]').val(order.default_manager_id);
    order.products[product.unique_id].offline_manager_id = order.default_manager_id;
  }
  update_total();
  var product_rows = $('.product-template');
  product_rows.hide('fast');
  product_rows.remove();
  $product_list= [];
  $('#barcode-input').val('');
  $('#barcode-input').focus();
});

$(document).on("click", "#add-mtm-button", function() {
  t = $(this);
  var html = Template.orderMtm({mtm_status_list: mtm_status_list, mtm_name_list: mtm_name_list, manager_list: manager_list});
  $('#product-list').append(html);
  update_total();
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
  var unique_id = $(this).data().uniqueId;
  delete order.products[unique_id];
  t.parent().parent().remove();
  $('#manager_'+unique_id).remove();
  update_total();
});

$(document).on('click', '.remove-mtm', function() {
  t = $(this);
  t.parent().parent().remove();
  update_total();
});

$(document).on('change', '.status-input', function() {
  update_total();
});

$(document).on('click', '.remove-user', function() {
  delete order.user;
  $("#selected-user").html('');
});


$(document).on("click", "#order-button", function(e) {
  var t = $(this);
  e.preventDefault();
  if (is_mtm() && order.user === undefined) {
    alert("Укажите клиента, заказывающего пошив");
    return false;
  }
  order.mtm_items = mtm_items();
  order.mtm_brand_id = +($("#mtm-brand-id").val()) || 0;
  order.update_in_progress = true;
  t.attr("disabled", "disabled");
  $.post('/index.php?module=OfflineSale', {order: JSON.stringify(order) }, function(data) {
    order.order_id = data;
    window.history.pushState("orderEditable", "Editable order page", "index.php?module=OfflineSale&order_id="+order.order_id);
    if (order.mtm_items && is_mtm()) {
      render_save_result();
    }
    else {
      var user_id = (order.user ? order.user.user_id : 0)
      $.post('/rest_api/offline_order', JSON.stringify({order_id: order.order_id, user_id: user_id, products: order.products}), function(response) {
        if (response == "OK") {
          render_save_result();
        }
      });
    }
  });
});

$(document).on('click', '#add-payment', function() {
  add_payment();
});

$(document).on('click', '.remove-payment', function() {
  var p_id = $(this).data('paymentId');
  if (p_id) {
    removed_payments.push(p_id);
  }
  $(this).parents("div.payment-option").remove();
  update_payment();
});


$(document).on('click', '#save-manager', function() {
  update_managers();
  $.post("/index.php?module=OfflineSale", {save_managers: JSON.stringify(order.products)}, function(r) {
    alert("Данные о продавцах сохранены");
  });
});

$(document).on("click", ".send-app-link", function(e) {
  e.preventDefault();
  var t = $(this);
  result = window.confirm("Отправить этому клиенту СМС со ссылкой на приложение?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {send_app_link_to_user: user_id}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div class="alert alert-success" role="alert" style="margin-top: 6px;">Клиенту отправлен СМС со ссылкой</div>');
      }
    });
  }
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

  if (check_debt_date()) {
    alert("Укажите срок возврата долга.");
    return false;
  }

  if(check_deposit_balance()) {
    alert("Оплата депозитом не может быть больше суммы депозита у клиента.");
    return false;
  }

  var debt_limit_manager = check_debt_limit();
  if(debt_limit_manager) {
    var man = manager_list.find(m => m.manager_id == debt_limit_manager)
    alert("Превышен лимит на выдачу товара в долг менеджером "+man.manager_name+": "+man.debt_limit);
    return false;
  }

  order.update_in_progress = true;
  t.attr("disabled", "disabled");
  if (is_mtm()) {
    order.mtm_items = mtm_items();
    order.mtm_brand_id = +($("#mtm-brand-id").val()) || 0;
  }
  order.payments = $('.payment-option').toArray().map(function(e) {
    var id = e.dataset.paymentId;
    var payment_id = $(e).find("option:selected").val();
    var is_deposit = $(e).find("option:selected:visible").text() == 'Оплата депозитом';
    var money_paid = $(e).find(".payment-amount").val();
    var select = $(e).find(".debt-responsible-user");
    if ( select.hasClass('disabled') ) {
      var responsible_user_id = 0;
    }
    else {
      var responsible_user_id = select.val();
    }
    var debt_by_date = $(e).find(".debt-by-date").val();
    var money_paid = $(e).find(".payment-amount").val();
    var cashbox_id = $(e).find(".cashbox-id").val() || order.cashbox_id;

    return {id: id,
      payment_id: payment_id,
      money_paid: money_paid,
      responsible_user_id: responsible_user_id,
      cashbox_id: cashbox_id,
      debt_by_date: debt_by_date,
      is_deposit: is_deposit
    };
  });
  order.removed_payments = removed_payments;
  order.comment = $('#comment').val();
  $.post('/index.php?module=OfflineSale', {order: JSON.stringify(order), return_payment_ids: true}, function(data) {
    if (is_service() || is_mtm()) {
      render_save_result(data);
    }
    else {
      var user_id = (order.user ? order.user.user_id : 0);
      $.post('/rest_api/offline_order', JSON.stringify({order_id: order.order_id, user_id: user_id, products: order.products}), function(response) {
        if (response == "OK") {
          render_save_result(data);
        }
      });
    }
  });
});

$(document).on('change', '.return_chk', function(e) {
  var total_ret = $( ".return_chk:checked" ).toArray().map(function(e) {
    var unique_id = $(e).data().uniqueId;
    return Number(order.products[unique_id].price);
  }).reduce( function(a,b) { return a + b; }, 0);
  $('#total-return').html(total_ret);
});

$(document).on('click', '#submit-return', function(e) {
  e.preventDefault();
  var t = $(this);
  t.prop('disabled', true);
  var r_obj = {cashbox_id: $('#return_cashbox').val(), method_id: $('#return_method').val()};

  r_obj.returns = $( ".return_chk:checked" ).toArray().map(function(e) {
    var unique_id = $(e).data().uniqueId;
    return order.products[unique_id];
  });

  if (r_obj.returns.length < 1) {
    alert("Выберите товар для возврата");
    t.prop('disabled', false);
    return false;
  }

  $.post('/index.php?module=OfflineSale', {return_obj: JSON.stringify(r_obj), o_obj: JSON.stringify(order)}, function(data) {
    if (data === "OK") {
      t.removeClass("btn-danger").addClass("btn-success").html("Сохранено");
    }
    else {
      t.prop('disabled', false);
    }
  });
});

$(document).on('click', '#submit-online-cashbox', function(e) {
  e.preventDefault();
  var t = $(this);
  t.prop('disabled', true);

  $.get('/rest_api/online_receipt/'+order.order_id, function(data) {
    if (data === "OK") {
      t.removeClass("btn-danger").addClass("btn-success").html("Отправлено");
    }
    else {
      t.prop('disabled', false);
    }
  });
});

$(document).on("click", ".btn, button", function() {
  $("#order-button").prop("disabled", btn_disabled());
});

{/literal}

{if $order}
  var order = JSON.parse(document.getElementById('data-order').innerHTML);
  order.cashbox_id = '{$cashbox->id}';
  order.cashbox_name = '{$cashbox->name}';
  order.returns = {$return|default:'0'};
  render_existing_order(order);
{/if}

{literal}

if(is_mtm() && mtm_items().length == 0) {
  var html = Template.orderMtm({mtm_status_list: mtm_status_list, mtm_name_list: mtm_name_list, manager_list: manager_list});
  $('#product-list').append(html);
}

if (!editable()) {
  $('#add-payment').addClass("disabled");
  $('#submit-payment').hide();
  $('#submit-comment').removeClass('hidden');
}
new ClipboardJS('.btn-clipboard');
{/literal}
</script>
