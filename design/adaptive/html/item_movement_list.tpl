<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/js/are_you_ie.js"></script>

<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.3">

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
  #query {
    width: 90%;
  }
  @media (max-width: 770px) {
    #query {
      width: 80%;
    }
  }
  @media (max-width: 400px) {
    #query {
      width: 70%;
    }
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
  {if $block}
    <h3>Инструмент перемещений работает с 9:00 до 21:00</h3>
  {else}
  <div class="row mt20">
    <div class="col-md-12" id="left-column" style="padding-left: 0;">
    <div class="order-button-group mt20">
        <div style="margin-right: 24px;">
          {if $reservation}
            {if $allow_to_reserve}<a href="/index.php?module=OfflineSales&movement=1&reservation=1" target="_blank" class="btn btn-primary">Отложить товары</a>{/if}
          {else}
            <a href="/index.php?module=OfflineSales&movement=1" target="_blank" class="btn btn-primary">Новое перемещение</a>
            <a href="/index.php?module=OfflineSales&movement_list=1&acceptance=1" target="_blank" class="btn btn-primary">Приёмка перемещений</a>
          {/if}
        </div>
      </div>
      {if $reservation}
      <div style="margin:10px 0 15px 0;">
        <label>Поиск</label>
        <form method="get">
          <div class="input-group" style="width:100%;">
            <input name="module" type=hidden  value="OfflineSales">
            <input name="movement_list" type=hidden  value="1">
            <input name="reservation" type=hidden  value="1">
            <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
            <input id="query" name="query" type="text" class="form-control" placeholder="Введите Телефон, Имя, артикул или штрихкод" value="{$query}" autofocus>
            <button type="submit" style="float:right;padding: 6px 12px;margin-bottom: 0;" class="btn btn-primary">Поиск</button>
          </div>
        </form>
      </div>
      {/if}

      {if $reservation}
        <h3>Отложенные товары</h3>
      {elseif $acceptance}
        <h3>Приёмка перемещений</h3>
      {else}
        <h3>Последние перемещения</h3>
      {/if}
      <div id="order-list">
        {foreach from=$movements item=movement}
          <div class="panel panel-default">
            <div class="panel-heading">
              {if $reservation}Отложено {else}Перемещение №<b> {$movement->movement_id}</b> {/if}из <b>{$movement->shop_from_name}</b> в <b>{$movement->shop_to_name}</b> {if $movement->type_name}({$movement->type_name}){/if} &nbsp;&nbsp;-&nbsp;&nbsp;{$movement->date|date_format:"%Y/%m/%d, %H:%M"}
              {if $reservation && $movement->reservation_date && $movement->responsible_name}до <b>{$movement->reservation_date}</b> (отв. {$movement->responsible_name})
              {else}<br>Сдал/Принял: {if $movement->created_user_id == $movement->accepted_user_id}<b>{$movement->created_user}</b>{else}{if $movement->created_user}<b>{$movement->created_user}</b>{else}---{/if}/{if $movement->accepted_user}<b>{$movement->accepted_user}</b>{else}---{/if}{/if}{/if}
              {if $movement->editable && !$acceptance}(<a href="/index.php?module=OfflineSales&movement=1&movement_id={$movement->movement_id}{if $reservation}&reservation=1{/if}" target="_blank">Изменить</a> / <a href="/index.php?module=OfflineSales&movement_list=1&delete_movement_id={$movement->movement_id}" onclick="return confirm('Вы уверены, что хотите удалить перемещение?')">Удалить</a>){/if}
              {if $reservation && $allow_from_reserve}<a href="/index.php?module=OfflineSales&movement_list=1&reservation=1&return_reservation_id={$movement->movement_id}" onclick="return confirm('Вы уверены, что хотите вернуть отложку?')"> Вернуть</a>{/if}
              {if $acceptance}<a href="/index.php?module=OfflineSales&movement=1&movement_id={$movement->movement_id}&acceptance=1" target="_blank"> Открыть принятие</a>{/if}
              {if $movement->user}<br>клиент: <b>{$movement->user->name}</b>{/if}
              <a class="ShAA_buttonPrint" href="/index.php?module=OfflineSale&movement_receipt_for={$movement->movement_id}" target="_blank" style="float: right;">Распечатать накладную</a>
            </div>
            <div class="panel-body">
              {foreach from=$movement->items item=product}
                <div class="row ShAA_salesItemOff">
                  <div class="col-md-3 mt10"><b>{$product->model}{if !$product->item_accepted} - <span style="color:red;">Не принято</span>{/if}</b></div>
                  <div class="col-md-2 mt10">{$product->sku}</div>
                  <div class="col-md-2 mt10">{$product->color}</div>
                  <div class="col-md-2 mt10">{$product->size}</div>
                  <div class="col-md-3 mt10" style="text-align: right;">{if $product->res_price != 0}{$product->res_price|number_format:0:",":" "}{else}{$product->offline_price|number_format:0:",":" "}{/if}₽</div>
                </div>
              {/foreach}
            </div>
          </div>
        {/foreach}
      </div>
    </div>
  </div>
  {/if}
</div>
<!-- Content #End /-->


<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();
</script>
