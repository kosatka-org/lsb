<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='sections_menu.tpl' active='cities'}
  <!-- /Вкладки /-->

</div>	


<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">
     
      <div id="cont_top">
        <!-- Иконка раздела /--> 
	    <img src="./images/icon_categories.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">Города</h1>
        <!-- /Заголовок раздела /-->
        
        
		 <!-- Помощь2 /-->
        <div class="help2">
            <a href="index.php?section=City&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить</a>
        </div>
        <!-- /Помощь2 /-->

      </div>

      <div id="cont_center">
     
          
        <div class="clear">&nbsp;</div>	  
          
     
  
        {if $cities}

        <!-- Форма товаров #Begin /-->
        <form name='products' method="post">
          <table id="list2">
            
            {foreach item=city from=$cities}
				<tr>
				  <td>
					<div class="list_left">
					  <a href="{$city->move_up_get}" class="fl"><img src="./images/up.jpg" alt="Поднять" title="Поднять"/></a><a href="{$city->move_down_get}" class="fl"><img src="./images/down.jpg" alt="Опустить" title="Опустить"/></a>
					  
						{if $city->visible == 1}
							<a href="{$city->enable_get}" class="fl"><img src="./images/lamp_on.jpg" alt=""/></a>
						{else}
							<a href="{$city->enable_get}" class="fl"><img src="./images/lamp_off.jpg" alt=""/></a>
						{/if}
					  
					  <div class="padding">
						<div>
						  <p><a href="{$city->edit_get}" class="{if $city->visible == 1}tovar_on{else}tovar_off{/if}">{$city->name|escape}</a></p>
						  
						  {if $city->visible == 1}
						  <a href="http://{$root_url}/city/{$city->url}" class="tovar_min" target="_blank">http://{$root_url}/city/{$city->url}/</a>
						  {else}
						  <span class="tovar_min">http://{$root_url}/city/{$city->url}</span>          
						  {/if}
						</div>
					  </div>
					  <a href="{$city->delete_get}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg" alt="Удалить" title="Удалить"/></a>
					</div>
				  </td>
				</tr>				
				{/foreach}
			
          </table>
          </form>
          <!-- Форма Товаров #End /-->
          {else}
            <div class="emptylist">Нет записей</div>
          {/if}

          
         

	  </div>  
    </div>
  </div>	    
</div>
<!-- Content #End /--> 

