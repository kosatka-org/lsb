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
{include file='products_menu.tpl' active='banners'}
</div>

<div class="container" style="margin-bottom:50px;margin-top: 40px;">
  <i class="fa fa-picture-o fa-3x" style="margin-right:20px;"></i>
  <h3>Баннеры</h3>
  <div style="clear:both;"></div>
  <br>
  <a class="btn btn-default" href="/admin/index.php?section=Banners&create_new=1" role="button">Создать новый баннер</a>
  <br>
  <br>

  {foreach from=$Banners item=item key=key name=items}
    <div class="row mt20" id="banner_{$item->id}">
      <div class="panel panel-default">
        <div class="panel-body">
          <form role="form" name="banner" method="POST" action="/admin/index.php?section=Banners#banner_{$item->id}" enctype='multipart/form-data'>
            <input type="hidden" name="banner_id" value="{$item->id}"/>
            <div class = "form-group">
              <span class="lim_tip" style="color:red; display: none;">* Длина описания не должна превышать 15 символов.</span>
              <div class="input-group">
                <span class="input-group-addon" id="basic-addon1_{$item->id}">Описание (title)</span>
                <input type="text" class="form-control" name="title" id="title_{$item->id}" value="{$item->title}" aria-describedby="basic-addon1_{$item->id}">
              </div>
              <div class="input-group">
                <span class="input-group-addon" id="basic-addon1_{$item->id}">Англ. Описание (eng_title)</span>
                <input type="text" class="form-control" name="eng_title" id="title_{$item->id}" value="{$item->eng_title}" aria-describedby="basic-addon1_{$item->id}">
              </div>
              <br>
              <div class="input-group">
                <span class="input-group-addon" id="basic-addon2_{$item->id}">URL</span>
                <input type="text" class="form-control" name="url" id="title_{$item->id}" value="{$item->url}" aria-describedby="basic-addon2_{$item->id}">
              </div>
              <br>
              <select class="form-control" name="brand_id" style="width: 25%;">
                <option value="0">Бренд не выбран</option>
                {foreach from=$brands item=brand key=key name=brands}
                  <option value="{$brand->brand_id}" {if $item->brand_id == $brand->brand_id}selected{/if}>{$brand->name}</option>
                {/foreach}
              </select>
              <br>
              <select class="form-control" name="user_level" style="width: 25%;">
                <option value="1" {if $item->user_level == 1}selected{/if}>Виден всем</option>
                <option value="2" {if $item->user_level == 2}selected{/if}>Виден только зарегистрированным клиентам</option>
                <option value="3" {if $item->user_level == 3}selected{/if}>Виден только клиентам с оплаченными покупками</option>
              </select>
            </div>
            <div class="form-group">
              <label for="image_{$item->id}">Картинка баннера</label>
              <input type="file" name="image" id="image_{$item->id}">
              {if $item->image}
                <img style="padding: 12px;" src="/files/banners/{$item->image}" width=212>
              {else}
                <p class="help-block">Баннер не загружен</p>
              {/if}
            </div>
            <div class="form-group">
              <label for="eng_image_{$item->id}">Картинка англоязычного баннера</label>
              <input type="file" name="eng_image" id="eng_image_{$item->id}">
              {if $item->eng_image}
                <img style="padding: 12px;" src="/files/banners/{$item->eng_image}" width=212>
              {else}
                <p class="help-block">Баннер не загружен</p>
              {/if}
            </div>
            <div class="form-inline">
              <div class="checkbox" style="padding-right:12px;">
                <label>
                  <input type="checkbox" name="enabled" {if $item->enabled == 1}checked="true"{/if}> Активен
                </label>
              </div>
              <div class="form-group" style="padding-right:12px;">
                <label for="position_{$item->id}">Позиция:</label>
                <input id="position_{$item->id}" name="position" style="width: 42px;margin-left: 10px;" value="{$item->position}"/>
              </div>
              <div class="form-group" style="padding-right:12px;">
                <b>Пол: </b>
                <label class="radio-inline">
                  <input type="radio" name="sex" value="1" {if $item->sex == 1}checked="true"{/if}> Мужской
                </label>
                <label class="radio-inline">
                  <input type="radio" name="sex" value="2" {if $item->sex == 2}checked="true"{/if}> Женский
                </label>
                <label class="radio-inline">
                  <input type="radio" name="sex" value="0" {if $item->sex == 0}checked="true"{/if}> Всем
                </label>
                <label class="radio-inline">
                  <input type="radio" name="sex" value="3" {if $item->sex == 3}checked="true"{/if}> Только если пол не выбран
                </label>
              </div>
              <button type="submit" class="btn btn-primary" style="padding-right:12px;">Сохранить</button>
              <a tabindex="0" role="button" bannerid='{$item->id}' data-html="true" class="btn btn-danger" data-toggle="popover">Удалить</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  {/foreach}
</div>
