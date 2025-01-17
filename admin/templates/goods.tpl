<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
	{if in_array('Storefront', $user_allowed)}<li><a href="index.php?section=Storefront&category={$Category->category_id}{if $smarty.get.brand_id}&brand_id={$smarty.get.brand_id}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}" class="off">товары</a></li>{/if}
    {if in_array('Categories', $user_allowed)}<li><a href="index.php?section=Categories" class="off">категории</a></li>{/if}
    {if in_array('Brands', $user_allowed)}<li><a href="index.php?section=Brands" class="off">бренды</a></li>{/if}
    <li><a href="index.php?section=Goods" class="on">бренд-категория</a></li>
	{if in_array('Materials', $user_allowed)}<li><a href="index.php?section=Materials" class="off">материалы</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          <a href="index.php?section=Goods">Бренд-категория</a>
        </p>
      </td>
    </tr>
  </table>
  <!-- /Путь /-->
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
        <h1 id="headline">Бренд-категория</h1>
        <!-- /Заголовок раздела /-->
        
        
		 <!-- Помощь2 /-->
        <div class="help2">
            <a href="index.php?section=Good&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить</a>
        </div>
        <!-- /Помощь2 /-->

      </div>

      <div id="cont_center">
     
          
        <div class="clear">&nbsp;</div>	  
          
     
  
        {if $goods}

        <!-- Форма товаров #Begin /-->
        <form name='products' method="post">
          <table id="list2">
            
            {foreach item=good from=$goods}
				<tr>
				  <td>
					<div class="list_left">
					  <a href="{$good->move_up_get}" class="fl"><img src="./images/up.jpg" alt="Поднять" title="Поднять"/></a><a href="{$good->move_down_get}" class="fl"><img src="./images/down.jpg" alt="Опустить" title="Опустить"/></a>
					  
						{if $good->visible == 1}
							<a href="{$good->enable_get}" class="fl"><img src="./images/lamp_on.jpg" alt=""/></a>
						{else}
							<a href="{$good->enable_get}" class="fl"><img src="./images/lamp_off.jpg" alt=""/></a>
						{/if}
					  
					  <div class="padding">
						<div>
						  <p><a href="{$good->edit_get}" class="{if $good->visible == 1}tovar_on{else}tovar_off{/if}">{$good->title|escape}</a></p>
						  
						  {if $good->visible == 1}
						  <a href="http://{$root_url}/goods/{$good->url}/" class="tovar_min">http://{$root_url}/goods/{$good->url}/</a>
						  {else}
						  <span class="tovar_min">http://{$root_url}/goods/{$good->url}/</span>          
						  {/if}
						</div>
					  </div>
					  <a href="{$good->delete_get}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg" alt="Удалить" title="Удалить"/></a>
					</div>
				  </td>
				</tr>
				{include file=cat.tpl Categories=$category->subcategories level=$level+1}					
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

