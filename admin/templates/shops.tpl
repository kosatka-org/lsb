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
      <h3>Магазины / <a href="/admin/index.php?section=Warehouses">Склады</a> / <a href="/admin/index.php?section=Cashboxes">Кассы</a></h3>
      <div style="clear:both;"></div>

      {foreach from=$Shops item=item key=key name=items}
      <div class="row mt20" id="shop_{$item->shop_id}">
        <div class="panel panel-default">
          <div class="panel-body">
            <form role="form" name="shop" method="POST" action="/admin/index.php?section=Shops#shop_{$item->shop_id}" enctype='multipart/form-data'>
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
                  <span class="input-group-addon">URL</span>
                  <input type="text" class="form-control" name="url" value="{$item->url}">
                </div>
                <div class="input-group mt10">
                  <span class="input-group-addon">Адрес</span>
                  <input type="text" class="form-control" name="address" value="{$item->address}">
                </div>
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="enabled" {if $item->enabled}checked="true"{/if}> Включен
                  </label>
                </div>
                <input type="hidden" name="shop_id" value="{$item->shop_id}"/>
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
