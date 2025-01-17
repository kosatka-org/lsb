
<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='products_menu.tpl' active='collections'}
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
        <h1 id="headline">Новые коллекции</h1>
        <!-- /Заголовок раздела /-->
        
        
		<!-- Помощь2 /
        <div class="help2">
              <a href="index.php?section=Article&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить статью</a>              
        </div>
         /Помощь2 /-->        

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
            <table id="list">
            
              {* Список разделов *}
              {foreach item=item from=$Items}
              <tr>
                <td>
                  <div class="list_left">
                    <div class="flxc2">
                      <p>
                        <span class="tovar_on">Коллекция {$item->brand|escape} от {$item->date}</span> ({$item->p_count} товаров)<br/>
                        Код:{$item->col_code}
                      </p>
                      <p>
                        {$item->l_count} из {$item->s_count} размеров осталось<br/>
                        {foreach item=prod from=$item->products}
                         <a class="tovar_min" href='http://{$root_url}/products/{$prod->url}'>{$prod->model}</a>
                        {/foreach}
                      </p>
                    </div>
			      </div>
                  {if $item->coll_active == 1}
                    <a href="index.php?section=Collections&unset_active={$item->col_code}" class="fl" ><img src="./images/lamp_on.jpg" alt="Деактивировать" title="Деактивировать"/></a>
                  {else}
                    <a href="index.php?section=Collections&set_active={$item->col_code}" class="fl" ><img src="./images/lamp_off.jpg" alt="Активировать" title="Активировать"/></a>
                  {/if}
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