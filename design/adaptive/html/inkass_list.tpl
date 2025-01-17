<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
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
  <div class="row mt20">
    <div class="col-md-12" id="left-column" style="padding-left: 0;">
    {if $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 6 || $smarty.session.user->user_id == 139026}
      <div class="input-group">
        <form class="form-inline">
          <div class="form-group ShAA_fromService" style="overflow:hidden;">
            <label for="date_start" style="float:left;margin:6px 5px 0 0;">От </label>
            <input type="text" name="date_start" class="form-control ShAA_inputDate" id="date_start" value="{$date_start}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
          <div class="form-group ShAA_toService" style="overflow:hidden;">
            <label for="date_end" style="float:left;margin:6px 5px 0 0;">До </label>
            <input type="text" name="date_end" class="form-control ShAA_inputDate" id="date_end" value="{$date_end}" style="width: 85%;" placeholder="ГГГГ-ММ-ДД">
          </div>
          <div class="form-group ShAA_toService" >
            <label for="shop" style="float:left;margin:6px 5px 0 0;">Магазин: </label>
            <select name="shop" class="form-control" id="shop_id" style="width: 64%;">
              <option value="0">Все магазины</option>
              {foreach item=shop from=$shops}
                  <option value="{$shop->shop_id}" {if $shop_id == $shop->shop_id }selected{/if}>{$shop->name}</option>
              {/foreach}
            </select>
          </div>
          <a class="btn btn-primary" id="date_search" href="#" role="button" style="padding: 6px 12px;margin:1px 0 0;">Поиск</a>
        </form>
      </div>
    {/if}
    <div class="order-button-group mt20">
        <div style="margin-right: 24px;">
            <a href="/index.php?module=OfflineSales&inkass=1" target="_blank" class="btn btn-primary">Новая инкассация</a>
        </div>
      </div>

      <h3>Инкассация</h3>
      <div id="order-list">
        {foreach from=$inkass item=inkass}
          <div class="panel panel-default">
            <div class="panel-heading">
              Инкассация{if $inkass->im_agent_fee} (Агентское вознаграждение ИМ){/if}{if $inkass->im_sber_ai} (Платеж ИМ карта Сбербанк (А.И.)){/if}{if $inkass->im_sber_is} (Платеж ИМ карта Сбербанк (И.Ш.)){/if}{if $inkass->im_inkass} (Инкассация ИМ){/if} №<b>{$inkass->id}</b> {if $inkass->confirmed || $inkass->rejected}&nbsp;-&nbsp;<nobr><b>{if $inkass->confirmed}Подтверждено{/if}{if $inkass->rejected}Отклонено{/if}</b> {$inkass->confirm_date|date_format:"%d.%m %H:%M"}</nobr>{else} (<a href="/index.php?module=OfflineSales&inkass=1&inkass_id={$inkass->id}" target="_blank">Изменить</a> / <a href="/index.php?module=OfflineSales&inkass_list=1&delete_inkass_id={$inkass->id}" onclick="return confirm('Вы уверены, что хотите удалить инкассацию?')">Удалить</a>){/if}
            </div>
            <div class="panel-body">
                <div class="row">
                  <div class="col-md-2 mt10"><b>{$inkass->shop_name}</b></div>
                  <div class="col-md-2 mt10"><b>{$inkass->date|date_format:"%d.%m %H:%M"}</b></div>
                  <div class="col-md-2 mt10">{$inkass->name}</div>
                  <div class="col-md-3 mt10">{$inkass->comment}</div>
                  <div class="col-md-3 mt10" style="text-align: right;">{$inkass->sum|number_format:0:",":" "}₽</div>
                </div>
            </div>
          </div>
        {/foreach}
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();
$(document).on("click", "#date_search", function(e) {
  e.preventDefault();
  var date_start = $("#date_start").val();
  var date_end = $("#date_end").val();
  var shop_id = $("#shop_id").val();
  window.location = "/index.php?module=OfflineSales&inkass_list=1&date_start="+date_start+"&date_end="+date_end+"&shop_id="+shop_id;
});
</script>
{/literal}
