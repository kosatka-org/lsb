<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/locales/bootstrap-datepicker.ru.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.serializeJSON/2.8.1/jquery.serializejson.min.js"></script>
<script src="/jscript/mask.js"></script>
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

    .user-input {
        float: left;
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
    </div>
  </div>
  <div class="row">
    <div class="col-md-12" id="right-column" style="padding-left: 0;">
      <form id="user-form">
        <div class="form-group ShAA_nameUser">
          <label>ФИО (пример: Иванов Петр Сергеевич)</label>
          <input class="form-control user-input" name="name" value="{$user->name}">
        </div>
        <div class="clear"></div>
        <div class="form-group ShAA_offlineUser">
          <label>Телефон</label>
          <input class="form-control user-input" type="phone" name="phone_number" value="{$user->phone_number}" id="phone" maxlength="15" {if $smarty.session.user->user_id != 127619}disabled{/if} {literal}pattern="[0-9]{10,15}"{/literal}>
        </div>
        <div class="form-group ShAA_offlineUser">
          <label>Email</label>
          <input class="form-control user-input" type="email" name="email" value="{$user->email}" id="email">
        </div>
        <div class="form-group ShAA_offlineUser">
          <label>Дата рождения</label>
          <input class="form-control user-input" type="text" name="birth_date" value="{$user->birth_date}" id="date">
        </div>
        <div class="clear"></div>
        <div class="form-group ShAA_offlineUser">
            <label>Персональная скидка</label>
            <input id="personal_discount" class="form-control user-input" type="number" min="0" max="30" name="personal_discount" value="{$user->personal_discount}">
        </div>
        <div class="clear"></div>
        <div class="form-group">
          <label class="checkbox-inline ShAA_callsCashboxesTitle">
            <input type="checkbox" name="vip" value="1" {if $user->vip}checked{/if}>
            VIP
          </label>
          <label  class="checkbox-inline ShAA_callsCashboxesTitle">
            <input type="checkbox" name="hidden" value="1"  {if $user->hidden}checked{/if}>
            Скрытый клиент
          </label>
          <!--<label  class="checkbox-inline ShAA_callsCashboxesTitle">
            <input type="checkbox" name="stop_sms" value="1"  {if $user->stop_sms}checked{/if}>
            Стоп SMS
          </label>
          <label  class="checkbox-inline ShAA_callsCashboxesTitle">
            <input type="checkbox" name="stop_email" value="1"  {if $user->stop_email}checked{/if}>
            Стоп EMAIL
          </label>-->
        </div>
        <div class="clear"></div>
        <button type="submit" id="save-button" class="btn btn-primary">Сохранить</button>
        <div class="clear"></div>
        <div class="form-group" style="margin-top: 24px;">
          <label>Группы</label>
          <br>
          {foreach from=$client_groups item=cg}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input cg-chk" name="client_groups[]" value="{$cg->id}" {if $cg->checked}checked='true'{/if}>{$cg->name}
            </label>
          {/foreach}
        </div>
        <div class="clear"></div>
        <div class="form-group" style="margin-top: 12px;">
          <label>Мессенджеры</label>
          <br>
          {foreach from=$messengers item=msg}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input msg-chk" name="msg[]" value="{$msg->id}" {if $msg->checked}checked='true'{/if}>{$msg->name}
            </label>
          {/foreach}
        </div>
        <div class="clear"></div>
        <div class="form-group" style="margin-top: 12px;">
          <label>Менеджеры</label>
          <br>
          {foreach from=$managers item=man}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input managers-chk" name="managers[]" value="{$man->user_id}" {if $man->checked}checked='true'{/if}>{$man->name}
            </label>
          {/foreach}
        </div>
        <div class="clear"></div>
        {if $managers_serv}
        <div class="form-group" style="margin-top: 12px;">
          <label>Менеджеры по Услугам</label>
          <br>
          {foreach from=$managers_serv item=man}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input managers-chk" name="managers[]" value="{$man->user_id}" {if $man->checked}checked='true'{/if}>{$man->name}
            </label>
          {/foreach}
        </div>
        <div class="clear"></div>
        {/if}
        <div class="form-group" style="margin-top: 24px;">
          <label>Магазины</label>
          <br>
          {foreach from=$shops item=shop}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input shop-chk" name="shops[]" value="{$shop->shop_id}" {if $shop->checked}checked='true'{/if}>{$shop->name}
            </label>
          {/foreach}
        </div>
        <div class="clear"></div>
        <div class="form-group" style="margin-top: 12px;">
          <label>Бренды</label>
          <br>
          {foreach from=$brands item=brand}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input brand-chk" name="brands[]" value="{$brand->brand_id}" {if $brand->checked}checked='true'{/if}>{$brand->name}
            </label>
          {/foreach}
        </div>
        <div class="clear"></div>
        <div class="form-group" style="margin-top: 12px;">
          <label>Стоп-листы</label>
          <br>
          <label class="checkbox-inline ShAA_callsCashboxesTitle">
            <input type="checkbox" class="user-input" onchange="jQuery.get('/index.php?module=Login&do_not_disturb&type=sms&user_id={$user->original_user_id}');"{if $user->stop_sms == 1}checked{/if}> SMS
          </label>
          <label class="checkbox-inline ShAA_callsCashboxesTitle">
            <input type="checkbox" class="user-input"onchange="jQuery.get('/index.php?module=Login&do_not_disturb&type=email&email={$user->email}&user_id={$user->original_user_id}');" {if $user->stop_email == 1}checked{/if}{if $user->email == ''}checked disabled{/if}> Email
          </label>
        </div>
        <div class="clear"></div>
        <div class="form-group" style="margin-top: 12px;">
          <label>Скрытые бренды</label>
          <br>
          {foreach from=$hidden_brands item=hbrand}
            <label class="checkbox-inline ShAA_callsCashboxesTitle">
              <input type="checkbox" class="user-input hidden-brand-chk" name="hidden_brands[]" value="{$hbrand->brand_id}" {if $hbrand->checked}checked='true'{/if}>{$hbrand->name}
            </label>
          {/foreach}
        </div>
        <div class="clear"></div>
        <button type="submit" id="save-button" class="btn btn-primary">Сохранить</button>
      </form>
    </div>
  </div>
</div>
<!-- Content #End /-->
<script>
var user_id = {$user->user_id};
{literal}
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();

function dismiss_alerts() {
  $('.alert').remove();
}

$(document).on("click", "#save-button", function(e) {
  e.preventDefault();
  if ($("#phone").val().length<10){
    alert("Введите корректный телефон");
  }else{
    var data = $('#user-form').serializeJSON();
    data.msg_str = data.msg && data.msg.join(", ");
    $.post("/index.php?module=OfflineSales", {edit_user_id: user_id, user_data: JSON.stringify(data)}, function(res) {
      $('#user-form').append('<div class="alert alert-success" role="alert">Изменения сохранены</div>');
      window.setTimeout(dismiss_alerts, 5000);
    });
  }
});

$(document).on("input", "#personal_discount", function(e) {
  var t = $(this);
  if (t.val() > 30) {
    t.val(30);
  }
  if (t.val() < 0) {
    t.val(0);
  }
});

$(function($){
   $("#date").mask("9999-99-99",{placeholder:"yyyy-mm-dd"});
});
</script>
{/literal}
