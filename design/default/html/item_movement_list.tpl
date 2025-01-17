<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
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
    <div class="order-button-group mt20">
        <div style="margin-right: 24px;">
            <a href="/index.php?module=OfflineSales&movement=1" target="_blank" class="btn btn-primary">Новое перемещение</a>
        </div>
      </div>
      
      <h3>Последние перемещения</h3>
      <div id="order-list">
        {foreach from=$movements item=movement}
          <div class="panel panel-default">
            <div class="panel-heading">
             Перемещение №<b> {$movement->movement_id}</b> из <b>{$movement->shop_from_name}</b> в <b>{$movement->shop_to_name}</b> &nbsp;&nbsp;-&nbsp;&nbsp;{$movement->date|date_format:"%Y/%m/%d, %H:%M"} (<a href="/index.php?module=OfflineSales&movement=1&movement_id={$movement->movement_id}" target="_blank">Изменить</a> / <a href="/index.php?module=OfflineSales&movement_list=1&delete_movement_id={$movement->movement_id}" onclick="return confirm('Вы уверены, что хотите удалить перемещение?')">Удалить</a>)
             <a href="/index.php?module=OfflineSale&movement_receipt_for={$movement->movement_id}" target="_blank" style="float: right;">Распечатать накладную</a>
            </div>
            <div class="panel-body">
              {foreach from=$movement->items item=product}
                <div class="row">
                  <div class="col-md-3 mt10"><b>{$product->model}</b></div>
                  <div class="col-md-2 mt10">{$product->sku}</div>
                  <div class="col-md-2 mt10">{$product->color}</div>
                  <div class="col-md-2 mt10">{$product->size}</div>
                  <div class="col-md-3 mt10" style="text-align: right;">{$product->offline_price|number_format:0:",":" "}₽</div>
                </div>
              {/foreach}
            </div>
          </div>
        {/foreach}
      </div>
    </div>
  </div>
</div>
<!-- Content #End /-->


<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();
</script>
