<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
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
  <div class="row mt20">
    <div class="col-md-8" id="left-column" style="padding-left: 0;">
      <div class="row">
        <div class="col-md-12">
            Задолженность № <b>{$debt->id}</b> по покупке №<a href="/index.php?module=OfflineSale&order_id={$debt->order_id}"> {$debt->rn}<span style="display: none;">{$debt->id}/{$debt->receipt_number}</span></a>,  {$debt->user->name}, общая сумма долга: <b>{$debt->debt_amount|number_format:0:",":" "}</b>₽ ({$debt->cashbox->name})
        </div>
      </div>
      <div class="row">
        {foreach from=$debt->products item=product}
          <div class="col-md-12">
              {$product->product_name} - {$product->price}
          </div>
        {/foreach}
      </div>

      <h3>Список выплат</h3>
      <div class="row ShAA_titleOfTable">
        <div class="col-md-3 mt10">Способ оплаты</div>
        <div class="col-md-3 mt10">Сумма выплаты</div>
        <div class="col-md-3 mt10">Касса</div>
        <div class="col-md-3 mt10">Дата</div>
      </div>
      <div id="payment-list">
        {foreach from=$debt->payments item=payment}
          <div class="row ShAA_itemDebt">
            <div class="col-md-3 mt10">{$payment->payment_option}</div>
            <div class="col-md-3 mt10 ShAA_rightItem" style="margin-top: 4px;"><input class="form-control payment-input" disabled value="{$payment->money_paid|number_format:0:",":" "}" style="width: 100%; text-align: right; padding-right: 3px;"></div>
            <div class="col-md-3 mt10">{$payment->cashbox_name}</div>
            <div class="col-md-3 mt10 ShAA_rightItem">{$payment->date|date_format:"%Y/%m/%d"}</div>
          </div>
        {/foreach}
        <span id="payment-anchor">
          <!--Anchor for product-template-->
        </span>
      </div>
      <div>
        <div class="row ShAA_moneyBlock" style="font-weight: bold;">
            <div class="col-md-3 mt10">Всего выплачено: </div>
            <div class="col-md-3 mt10" style="text-align: right; padding-right: 18px;"><span id="total-paid-off">{$debt->paid_off_amount|number_format:0:",":" "}</span> </div>
            <div class="col-md-3 mt10">из {$debt->debt_amount|number_format:0:",":" "}₽</div>
        </div>

      <div id="debt-buttons">
        <button id="add-payment" class="btn btn-primary mt20">Добавить выплату</button>
        <button id="submit-debt" class="btn btn-warning mt20">Сохранить</button>
      </div>

    </div>
    <div class="col-md-4" id="right-column">
    </div>

  </div>
</div>
<!-- Content #End /-->

<script id="data-payment-options"type="application/json">
  {$payment_options}
</script>

<script id="data-cashboxes"type="application/json">
  {$cashboxes_json}
</script>

{literal}
<script id="payment-template" type="text/x-handlebars-template">
  {{#each payments}}
  <div class="row mt10">
    <div class="col-md-3 mt20">
      <select class="form-control payment_options" data-payment-id="{{@index}}">
        {{#each ../payment_options}}
          <option value="{{this.id}}">{{this.name}}</option>
        {{/each}}
      </select>
    </div>
    <div class="col-md-3 mt20">
      <select class="form-control payment_cashbox" data-payment-id="{{@index}}">
        {{#each ../cashboxes}}
          <option value="{{this.id}}">{{this.name}}</option>
        {{/each}}
      </select>
    </div>
    <div class="col-md-3 mt20">
      <input class="form-control payment-input" data-payment-id="{{@index}}" style="width: 100%;" type="number" step="100" min="0" value="{{this.money_paid}}">
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

var debt = {payments: []};

update_total = function() {
  debt.total_paid = $('.payment-input').toArray().map(function(e) { return parseInt(e.value); })
  .reduce(function(memo, e) { return memo+e; }, 0);
}

$(document).on("click", "#add-payment", function() {
  t = $(this);
  debt.payments.push( {money_paid: 0, payment_option: debt.payment_options[0].id, cashbox_id: debt.cashboxes[0].id} );
  var html = Template.payment(debt);
  $('#payment-anchor').html(html);
  debt.payments.forEach(function(payment, index) {
    $(".payment_options[data-payment-id='"+index+"'] option[value='"+payment.payment_option+"']").prop("selected", true);
    $(".payment_cashbox[data-payment-id='"+index+"'] option[value='"+payment.cashbox_id+"']").prop("selected", true);
  });
});

$(document).on("input", ".payment-input", function() {
  var index = $(this).attr("data-payment-id");
  var payment = debt.payments[index];
  payment.money_paid = $(this).val();
  update_total();
  $('#total-paid-off').html(debt.total_paid);
});

$(document).on("change", ".payment_options", function() {
  var index = $(this).attr("data-payment-id");
  var payment = debt.payments[index];
  payment.payment_option = $(this).val();
});

$(document).on("change", ".payment_cashbox", function() {
  var index = $(this).attr("data-payment-id");
  var payment = debt.payments[index];
  payment.cashbox_id = $(this).val();
});

$(document).one('click', '#submit-debt', function() {
  if (debt.total_paid > debt.total_debt) {
    alert("Ошибка: сумма выплат превышает сумму долга.");
    return false;
  }
  var t = $(this);
  $.post('/index.php?module=OfflineSales', {debt: JSON.stringify(debt) }, function(data) {
    window.location.reload();
  });
});

{/literal}
{if $payment_options}
  debt.payment_options = JSON.parse(document.getElementById('data-payment-options').innerHTML);
  debt.cashboxes = JSON.parse(document.getElementById('data-cashboxes').innerHTML);
  debt.debt_id = {$debt->id};
  debt.total_debt = {$debt->money_paid};
{/if}
</script>
