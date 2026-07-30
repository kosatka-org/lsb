{include file="offline_js.tpl"}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="row">
    <div class="col-md-12" style="text-align: center; margin-top: -50px;">
        <button class="btn btn-danger mt20" style="float: right;" onClick="location.href = '/logoutforce/';">ВЫХОД</button>
    </div>
  </div>
  <div class="row mt20">
    <div class="col-md-12" id="left-column" style="padding-left: 0;">

      <h3>Начисление депозита</h3>
      <div class="input-group">
        <form class="form-inline">
          <div class="form-group">
            <label for="query" style="float:left;margin:6px 5px 0 0;">Имя/Телефон клиента</label>
            <input type="text" class="form-control" id="query" name="query" style="width: 60%;">
          </div>
          <a class="btn btn-primary" id="search" href="#" role="button" style="padding: 6px 12px;margin:1px 0 0;">Поиск</a>
        </form>
      </div>
      <div id="user-list">

      </div>

      <div id="payment-options">

      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script id="user-template" type="text/x-handlebars-template">
  {{#each users}}
    <div class='row mt10 user-template' data-user-id={{this.user_id}}>
      <div class='col-md-2 mt20'>{{this.name}}</div>
      <div class='col-md-4 mt10'>
        <button type='button' data-user-id='{{this.user_id}}' user-index='{{@index}}' class='btn btn-default user-select-btn'>Выбрать</button>
      </div>
    </div>
  {{/each}}
</script>

<script id="payment-template" type="text/x-handlebars-template">
  <div class="form-inline payment-option mt20">
    <div class="form-group" style="float: right;">
      <button type="button" class="close remove-payment off" data-payment-id="{{payment.id}}" aria-hidden="true">
        <span class="glyphicon glyphicon-remove"></span>
      </button>
    </div>
    <div class="form-group">
      <label for="payment-select">Способ</label>
      <select id="payment-select" class="form-control">
        {{#each payment_options}}
          <option value="{{this.id}}" {{#if this.selected}}selected{{/if}}>{{this.name}}</option>
        {{/each}}
      </select>
    </div>
    <div class="form-group">
      <label for="payment-amount">Сумма</label>
      <input type="number" min="0" class="form-control payment-amount" style="max-width: 120px; margin-right: 6px;" value="{{#if payment}}{{payment.money_paid}}{{/if}}">
    </div>
    <button id="confirm" type='button' class='btn btn-danger'>Начислить</button>
  </div>
</script>
{/literal}

<script id="data-payment-options" type="application/json">
{$payment_options}
</script>

{literal}
<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

$.ajaxSetup({ cache: false });

moment.locale('ru');

Handlebars.registerHelper('formatDate', function(date) {
  return moment(date, "YYYY-MM-DD HH:mm Z").format("Do MMMM YYYY, H:mm");
});

Handlebars.registerHelper('formatMoney', function(n) {
  return new Intl.NumberFormat('ru-RU', { style: 'currency', currency: 'RUB',
   maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(Number(n));
});

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var payment_options = JSON.parse($('#data-payment-options').html());

function getUsers() {
  $.getJSON("/rest_api/users", {query: $('#query').val()}, function(data) {
    $('#user-list').empty();
    console.log(data.users);
    var u = Template.user({users: data.users});
    $('#user-list').html(u);
  });
}

function add_payment() {
  var html = Template.payment({payment_options: payment_options});
  $("#payment-options").append(html);
}

$(document).on("click", "#search", function(e) {
  e.preventDefault();
  getUsers();
});

$(document).on("click", ".user-select-btn", function(e) {
  $(this).hide();
  $(this).parent().parent().siblings().hide();
  add_payment()
});

$(document).on("click", "#confirm", function(e) {
  var data = {
    user_id: $('.user-template:visible').data('userId'),
    payment_id: $('#payment-select').val(),
    sum: $('.payment-amount').val()
  }
  if (!data.sum) {
    alert('Введите сумму начисления')
    return false
  }
  if (data.sum < 0) {
    alert('Сумма начисления не может быть меньше ноля')
    return false
  }
  var t = $(this)
  $.post('/rest_api/deposit', JSON.stringify(data), function(r) {
    t.prop('disabled', true);
    if (r.transaction) {
      t.removeClass("btn-danger").addClass("btn-success").html("Сохранено");
    }
    else {
      t.prop('disabled', false);
    }
  });
});

</script>
{/literal}
