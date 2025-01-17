{literal}
<style type="text/css">
  body {
    background: none;
  }
  .mt20 {
    margin-top: 20px;
  }
</style>
{/literal}

<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='products_menu.tpl' active='brands'}
</div>

<div class="container" style="margin-bottom:50px;margin-top: 40px;">
  <div class="tab-content">
    <div class="tab-pane active" id="active">
      <img src="/admin/images/icon_brands.jpg" alt="" style="margin-right:20px;" class="line"/>
      <h3>Бренды</h3>
      <div style="clear:both;"></div>

      {foreach from=$Brands item=item key=key name=items}
      <div class="row mt20" id="brand_{$item->brand_id}">
        <div class="panel panel-default">
          <div class="panel-body">
            <form role="form" name="brand" method="POST" action="/admin/index.php?section=Brands#brand_{$item->brand_id}" enctype='multipart/form-data'>
              <div class="row">
                <div class="col-md-2" id="left-column">
                  <br>
                  <a href="/admin/index.php?section=Brand&item_id={$item->brand_id}" target="_blank">{$item->name|escape}</a>
                </div>
                <div class="col-md-2">
                  {if $item->image}
                  <img class="logo_preview" src="/files/brands/{$item->image}" width=212>
                  {else}
                  <br>
                  Логотип не загружен
                  {/if}
                </div>
                <div class="col-md-3 form-group">
                  <br>
                  <label for="image_{$item->brand_id}">Загрузить лого:</label>
                  <input id="image_{$item->brand_id}" type="file" name="image"/>
                </div>
                <div class="col-md-4 form-group">
                  <br>
                  <label for="position_{$item->brand_id}">Позиция:</label>
                  <input id="position_{$item->brand_id}" name="position" style="width: 42px;margin-left: 10px;" value="{$item->position}"/>
                  <br>
                  <label for="position_{$item->brand_id}">Максимальная оффлайн скидка:</label>
                  <input id="position_{$item->brand_id}" name="offline_max_sale" style="width: 42px;margin-left: 10px;" value="{$item->offline_max_sale}"/>
                  <br>
                  <label for="check_{$item->brand_id}">На главной:</label>
                  <input id="check_{$item->brand_id}" type="checkbox" name="show_on_main" value="1" {if $item->show_on_main}checked{/if}>
                  <br>
                  <label for="brandwall_{$item->brand_id}">На brandwall:</label>
                  <input id="brandwall_{$item->brand_id}" type="checkbox" name="brandwall" value="1" {if $item->show_on_brandwall}checked{/if}>
                  <br>
                  <label for="bigsize_{$item->brand_id}">Выделить на BW:</label>
                  <input id="bigsize_{$item->brand_id}" type="checkbox" name="bigsize" value="1" {if $item->bigsize_on_brandwall}checked{/if}>
                  <br>
                  <label for="offline_only_{$item->brand_id}">Только в магазинах:</label>
                  <input id="offline_only_{$item->brand_id}" type="checkbox" name="offline_only" value="1" {if $item->offline_only}checked{/if}/>
                  <br>
                  <label for="hide_sizes_{$item->brand_id}">Скрыть размеры:</label>
                  <input id="hide_sizes_{$item->brand_id}" type="checkbox" name="hide_sizes" value="1" {if $item->hide_sizes}checked{/if}/>
                  <br>
                  <label for="show_delta_{$item->brand_id}">Показывать разницу скидки:</label>
                  <input id="show_delta_{$item->brand_id}" type="checkbox" name="show_delta" value="1" {if $item->show_delta}checked{/if}/>
                  <br>
                  <label for="show_sale_external_{$item->brand_id}">Отображать скидку во внешних выгрузках:</label>
                  <input id="show_sale_external_{$item->brand_id}" type="checkbox" name="show_sale_external" value="1" {if $item->show_sale_external}checked{/if}/>
                  <br>
                  <label for="fur_brand_{$item->brand_id}">Меховой бренд:</label>
                  <input id="fur_brand_{$item->brand_id}" type="checkbox" name="fur_brand" value="1" {if $item->fur_brand}checked{/if}/>
                </div>
              </div>
              <div class="row mt20">
                <div class="col-md-4">
                  <label for="visibility_{$item->brand_id}">Доступно:</label>
                  <select name="visibility" id="visibility_{$item->brand_id}">
                    <option value="1" {if $item->visibility == 1}selected{/if}>Всем</option>
                    <option value="2" {if $item->visibility == 2}selected{/if}>Зарегистрированным</option>
                    <option value="3" {if $item->visibility == 3}selected{/if}>Больше 1 покупки</option>
                    <option value="4" {if $item->visibility == 4}selected{/if}>Скрыт</option>
                    <option value="5" {if $item->visibility == 5}selected{/if}>Отключен</option>
                  </select>
                </div>
                <div class="col-md-6 form-group">
                  <label for="title_{$item->brand_id}">Title:</label><br>
                  <textarea id="title_{$item->brand_id}" name="title" style="width: 100%; height: 82px;" autocomplete="off">{$item->meta_title}</textarea>
                </div>
                <div class="col-md-2 form-group">
                  <br>
                  <input type="hidden" name="brand_id" value="{$item->brand_id}"/>
                  <input class="btn btn-success" type="submit" style="margin-top: -4px;" value="Сохранить"/>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
      {/foreach}

    </div>
  </div>
</div>
