{literal}
<style type="text/css">
  body {
    background: none;
  }
  .mt20 {
    margin-top: 20px;
  }
  .mt10 {
    margin-top: 10px;
  }
</style>
{/literal}

<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='products_menu.tpl' active='shops'}
</div>

<div class="container" style="margin-bottom:50px;margin-top: 40px;">
  <div class="tab-content">
    <div class="tab-pane active" id="active">
      <img src="/admin/images/icon_brands.jpg" alt="" style="margin-right:20px;" class="line"/>
      <h3><a href="/admin/index.php?section=Shops">Магазины</a> / Склады / <a href="/admin/index.php?section=Cashboxes">Кассы</a></h3>
      <div style="clear:both;"></div>

      {foreach from=$warehouses item=item key=key name=items}
      <div class="row mt20" id="warehouse_{$item->warehouse_id}">
        <div class="panel panel-default">
          <div class="panel-body">
            <form role="form" name="warehouse" method="POST" action="/admin/index.php?section=Warehouses#warehouse_{$item->warehouse_id}" enctype='multipart/form-data'>
              <div class="col-md-4" id="left-column">
                <br>
                <b>{$item->name|escape}</b>
              </div>
              <div class="col-md-6">
                <div class="input-group mt10">
                  <span class="input-group-addon">Имя</span>
                  <input type="text" class="form-control" name="name" value="{$item->name}">
                </div>
                <div class="input-group mt10">
                  <span class="input-group-addon">Код 1С</span>
                  <input type="text" class="form-control" name="code" value="{$item->code}">
                </div>
                <div class="input-group mt10">
                  <span class="input-group-addon">Магазин</span>
                  <select name="shop_id" class="form-control">
                    <option value="0">Не выбран</option>
                    {foreach from=$shops item=shop}
                      <option value="{$shop->shop_id}" {if $item->shop_id == $shop->shop_id}selected="true"{/if}>{$shop->name}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="mvmt_enabled" {if $item->movement_enabled}checked="true"{/if}> Доступен для перемещений
                  </label>
                </div>
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="spam_enabled" {if $item->spam_enabled}checked="true"{/if}> Включить рассылки
                  </label>
                </div>
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="im_show" {if $item->im_show}checked="true"{/if}> Показывать товары в Интернет-магазине
                  </label>
                </div>
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="admin_only" {if $item->admin_only}checked="true"{/if}> Только для админов
                  </label>
                </div>
                <input type="hidden" name="warehouse_id" value="{$item->warehouse_id}"/>
                <input class="btn btn-primary mt10" type="submit" value="Сохранить"/>
              </div>
            </form>
          </div>
        </div>
      </div>
      {/foreach}

    </div>
  </div>
</div>
