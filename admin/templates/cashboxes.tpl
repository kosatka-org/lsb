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
      <h3><a href="/admin/index.php?section=Shops">Магазины</a> / <a href="/admin/index.php?section=Warehouses">Склады</a> / Кассы</h3>
      <div style="clear:both;"></div>

      {foreach from=$cashboxes item=item key=key name=items}
      <div class="row mt20" id="cashbox_{$item->id}">
        <div class="panel panel-default">
          <div class="panel-body">
            <form role="form" name="cashbox" method="POST" action="/admin/index.php?section=Cashboxes#cashbox_{$item->id}" enctype='multipart/form-data'>
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
                  <span class="input-group-addon">Адрес</span>
                  <input type="text" class="form-control" name="address" value="{$item->address}">
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
                <div class="input-group mt10">
                  <span class="input-group-addon">Юр. лицо</span>
                  <select name="entity_id" class="form-control">
                    <option value="0">Не выбрано</option>
                    {foreach from=$entities item=entity}
                      <option value="{$entity->id}" {if $item->entity_id == $entity->id}selected="true"{/if}>{$entity->name}</option>
                    {/foreach}
                  </select>
                </div>
                <div class="input-group mt10">
                  <span class="input-group-addon">ИНН</span>
                  <input type="text" class="form-control" name="inn" value="{$item->inn}">
                </div>
                <div class="input-group mt10">
                  <span class="input-group-addon">Номер регистрации в 1С</span>
                  <input type="text" class="form-control" name="code_1s" value="{$item->code_1s}">
                </div>
                <div class="input-group mt10">
                  <span class="input-group-addon">IMEI терминала</span>
                  <input type="text" class="form-control" name="imei" value="{$item->imei}">
                </div>
                <div class="input-group mt10">
                  <span class="input-group-addon">Ключ терминала</span>
                  <input type="text" class="form-control" name="device_uuid" value="{$item->device_uuid}">
                </div>
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="enabled" {if $item->enabled}checked="true"{/if}> Активна
                  </label>
                </div>
                <div class="panel-group" id="accordion-{$key}">
                  <div class="panel panel-default">
                    <div class="panel-heading">
                      <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion-{$key}" href="#collapse{$key}">
                          Редактировать бренды
                        </a>
                      </h4>
                    </div>
                    <div id="collapse{$key}" class="panel-collapse collapse">
                      <div class="panel-body">
                        {foreach from=$brands item=brand}
                          <div class="checkbox">
                            <label>
                              <input type="checkbox" value="{$brand->brand_id}" name="brands[]" {if in_array($brand->brand_id,$item->brands)}checked="true"{/if}> {$brand->name}
                            </label>
                          </div>
                        {/foreach}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="panel-group" id="accordion2-{$key}">
                  <div class="panel panel-default">
                    <div class="panel-heading">
                      <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion2-{$key}" href="#collapse2{$key}">
                          Редактировать способы оплаты
                        </a>
                      </h4>
                    </div>
                    <div id="collapse2{$key}" class="panel-collapse collapse">
                      <div class="panel-body">
                        {foreach from=$payment_options item=po}
                          <div class="checkbox">
                            <label>
                              <input type="checkbox" value="{$po->id}" name="payment_options[]" {if in_array($po->id, $item->payment_options)}checked="true"{/if}> {$po->name}
                            </label>
                          </div>
                        {/foreach}
                      </div>
                    </div>
                  </div>
                </div>

                <input type="hidden" name="cashbox_id" value="{$item->id}"/>
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
