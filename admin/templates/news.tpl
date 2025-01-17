
<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='sections_menu.tpl' active='news'}
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
        <h1 id="headline">Новости</h1>
        <!-- /Заголовок раздела /-->
        
        

		 <!-- Помощь2 /-->
        <div class="help2">
              <a href="index.php?section=NewsItem&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить новость</a>              
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
                    
          {$PagesNavigation}
          <div class="clear">&nbsp;</div>	

          {if $Items}

          <!-- Форма товаров #Begin /-->
          <form name='products' method="post">
            <table id="list2">
            
              {* Список новостей *}
              {foreach item=item from=$Items}
              <tr>
                <td>
                  <div class="list_left">
                    <a href="index.php{$item->enable_get}" class="fl"><img src="./images/{if $item->enabled}lamp_on.jpg{else}lamp_off.jpg{/if}" alt="Активность" title="Активность"/></a>
                    <div class="flxc2">
                      <p>
                        <a href="index.php{$item->edit_get}" class="tovar_on">{$item->header|escape}</a>
                      </p>
                      <p>
						<b>{$item->name}</b><br>
                        {$item->add_date|escape}
                      </p>
                      <p>
                        {if $item->enabled}
                        <a class="tovar_min" href='http://{$root_url}/news/{$item->url}'>http://{$root_url}/news/{$item->url}</a>
                        {else}
                        <span class="tovar_min">http://{$root_url}/news/{$item->url}</span>
                        {/if}
                      </p>
                    </div>
			      </div>
                  <a href="index.php{$item->delete_get}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg"  alt="Удалить" title="Удалить"/></a>
                </td>
              </tr>
              {/foreach}
              {* /Список новостей *}
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
