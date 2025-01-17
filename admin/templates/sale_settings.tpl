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
	{include file='sections_menu.tpl' active='sale_settings'}
</div>

<div class="container" style="margin-bottom:50px;margin-top: 40px;">
  <img src="/admin/images/icon_brands.jpg" alt="" style="margin-right:20px;" class="line"/>
  <h2>Настройки скидки</h3>
  <div>{$price_update}</div>
  <div>
    <form id="price_update" method="POST" action="/admin/index.php?section=SaleSettings">
      <input type="hidden" name="update_prices" value="1">
      <input class="btn btn-primary" type="submit" value="Обновить цены">
    </form>
  </div>
  <div style="clear:both;"></div>
  {foreach from=$brands item=brand}
    <div class="panel panel-default">
      <div class="panel-body" id="{$brand->brand_id}">
        <h3>{$brand->name}</h3>
        <div class="row">
          <div class="col-md-2"><b>Скидка на сайте</b></div>
          <div class="col-md-2"><b>Максимальная скидка</b></div>
          <div class="col-md-2" style="text-align:center;"><b>Показывать всем</b></div>
          <div class="col-md-2" style="text-align:center;"><b>Зарегистрированным</b></div>
          <div class="col-md-2" style="text-align:center;"><b>С покупками</b></div>
        </div>
        <h4>Следующий сезон</h4>
        <div class="row ">
          <div class="col-md-2">
            <input type="number" class="form-control sale-value" data-setting-id="{$brand->next_season->id}" data-brand-id="{$brand->brand_id}" data-season="next_season" value="{$brand->next_season->sale|default:'0'}" max='100'>
          </div>
          <div class="col-md-2">
            <input type="number" class="form-control max-sale-value" data-setting-id="{$brand->next_season->id}" data-brand-id="{$brand->brand_id}" data-season="next_season" value="{$brand->next_season->max_sale|default:'50'}" max='100'>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" data-season="next_season" value="1" data-user="everyone" {if $brand->next_season->everyone !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" data-season="next_season" value="1" data-user="registered" {if $brand->next_season->registered !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" data-season="next_season" value="1" data-user="has_purchase" {if $brand->next_season->has_purchase !== '0'}checked{/if}>
          </div>
        </div
        <h4>Новый сезон ({$Settings->current_new_season})</h4>
        <div class="row ">
          <div class="col-md-2">
            <input type="number" class="form-control sale-value" data-setting-id="{$brand->new_season->id}" data-brand-id="{$brand->brand_id}" data-season="new_season" value="{$brand->new_season->sale|default:'0'}" max='100'>
          </div>
          <div class="col-md-2">
            <input type="number" class="form-control max-sale-value" data-setting-id="{$brand->new_season->id}" data-brand-id="{$brand->brand_id}" data-season="new_season" value="{$brand->new_season->max_sale|default:'50'}" max='100'>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" data-season="new_season" value="1" data-user="everyone" {if $brand->new_season->everyone !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" data-season="new_season" value="1" data-user="registered" {if $brand->new_season->registered !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" data-season="new_season" value="1" data-user="has_purchase" {if $brand->new_season->has_purchase !== '0'}checked{/if}>
          </div>
        </div>
        <h4>Предыдущий сезон ({$Settings->previous_season})</h4>
        <div class="row">
          <div class="col-md-2">
            <input type="number" class="form-control sale-value" data-setting-id="{$brand->previous_season->id}" data-brand-id="{$brand->brand_id}" data-season="previous_season" value="{$brand->previous_season->sale|default:'0'}" max='100'>
          </div>
          <div class="col-md-2">
            <input type="number" class="form-control max-sale-value" data-setting-id="{$brand->previous_season->id}" data-brand-id="{$brand->brand_id}" data-season="previous_season" value="{$brand->previous_season->max_sale|default:'50'}" max='100'>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" value="1" data-season="previous_season" data-user="everyone" {if $brand->previous_season->everyone !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" value="1" data-season="previous_season" data-user="registered" {if $brand->previous_season->registered !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" value="1" data-season="previous_season" data-user="has_purchase" {if $brand->previous_season->has_purchase !== '0'}checked{/if}>
          </div>
        </div>
        <h4>Прошлые сезоны</h4>
        <div class="row">
          <div class="col-md-2">
            <input type="number" class="form-control sale-value" data-setting-id="{$brand->old_seasons->id}" data-brand-id="{$brand->brand_id}" data-season="old_seasons" value="{$brand->old_seasons->sale|default:'0'}" max='100'>
          </div>
          <div class="col-md-2">
            <input type="number" class="form-control max-sale-value" data-setting-id="{$brand->old_seasons->id}" data-brand-id="{$brand->brand_id}" data-season="old_seasons" value="{$brand->old_seasons->max_sale|default:'50'}" max='100'>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" value="1" data-season="old_seasons" data-user="everyone" {if $brand->old_seasons->everyone !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" value="1" data-season="old_seasons" data-user="registered" {if $brand->old_seasons->registered !== '0'}checked{/if}>
          </div>
          <div class="col-md-2" style="text-align:center;">
            <input type="checkbox" class="sale-show" data-brand-id="{$brand->brand_id}" value="1" data-season="old_seasons" data-user="has_purchase" {if $brand->old_seasons->has_purchase !== '0'}checked{/if}>
          </div>
        </div>
        <div class="row mt20">
          <div class="col-md-2">
            <button class="btn btn-primary save-data" data-brand-id="{$brand->brand_id}">Сохранить</button>
          </div>
        </div>
      </div>
      <div class="clear">&nbsp;</div>
    </div>
  {/foreach}
</div>
