<!-- Управление статьями /-->

<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='sections_menu.tpl' active='specials'}
  <!-- /Вкладки /-->

</div>

<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">

      <div id="cont_top">
        <!-- Иконка раздела /-->
	    <img src="./images/icon_content.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->

	    <!-- Заголовок раздела /-->
        <h1 id="headline">Подборки</h1>
        <!-- /Заголовок раздела /-->

		<!-- Помощь2 /-->
        <div class="help2">
              <a href="index.php?section=Special&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить подборку</a>
        </div>
        <!-- /Помощь2 /-->

      </div>

      <div id="cont_center">


          {if $Error}
          <!-- Error #Begin /-->
          <div id="error_minh">
            <div id="error">
              <img src="./images/error.jpg" alt=""/><p>{$Error}</p>
            </div>
          </div>
          <!-- Error #End /-->
          {/if}

<!-- 
          {$PagesNavigation}
          <div class="clear">&nbsp;</div>/-->

          {if $Items}

          <!-- Форма товаров #Begin /-->
          <div class=filter>
            <form method=get>
              <label for="seo_words"><input type="checkbox" id="" name="active" value="1" {if $smarty.get.active}checked="checked"{/if}> Только активные</label><br/>
              <input name=section type=hidden value='{$smarty.get.section}'>
              <input name=keyword type=text  class="input3" value='{$smarty.get.keyword|escape}'>
              <input type='submit' value='Найти' class="submit10">
            </form>
          </div>
          <form name='products' method="post">
            <table id="list">

              {* Список разделов *}
              {foreach item=item from=$Items}
              <tr>
                <td>
                  <div class="list_left">
                    <a href="index.php{$item->set_enabled_get}" class="fl"></a><a href="index.php{$item->enable_get}" class="fl"><img src="./images/{if $item->enabled}lamp_on.jpg{else}lamp_off.jpg{/if}"  alt="Активность" title="Активность"/></a>
                    <div class="flxc2">
                      <p>
                        <a href="index.php{$item->edit_get}" class="tovar_on">{$item->name|escape}</a>
                      </p>
                      <p>
                        {if $item->enabled}
                        <a class="tovar_min" href='http://{$root_url}/{if $item->look_special}look_{/if}specials/{$item->url}/'>http://{$root_url}/{if $item->look_special}look_{/if}specials/{$item->url}/</a>
                        {else}
                        <span class="tovar_min">http://{$root_url}/{if $item->look_special}look_{/if}specials/{$item->url}/</span>
                        {/if}
                      </p>
                    </div>
			      </div>
			    <a href="index.php{$item->delete_get}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg" alt="Удалить" title="Удалить"/></a>
                </td>
              </tr>
              {/foreach}
              {* /Список разделов *}
            </table>
            </form>
            <!-- Форма Товаров #End /-->
            {else}
              Список пуст
            {/if}

            {$PagesNavigation}

        </div>
	    <!-- Right side #End/-->

    </div>
  </div>
</div>
<!-- Content #End /-->
