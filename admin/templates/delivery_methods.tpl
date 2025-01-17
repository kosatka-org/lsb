<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
      {if in_array('Setup', $user_allowed)}<li><a href="index.php?section=Setup" class="off">параметры</a></li>{/if}
      {if in_array('Currency', $user_allowed)}<li><a href="index.php?section=Currency" class="off">валюты</a></li>{/if}
      <li><a href="index.php?section=DeliveryMethods" class="on">доставка</a></li>
      {if in_array('PaymentMethods', $user_allowed)}<li><a href="index.php?section=PaymentMethods" class="off">оплата</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          Способы доставки</a>
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
	    <img src="./images/icon_truck.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">Способы доставки</h1>
        <!-- /Заголовок раздела /-->
        
        
		<!-- Помощь2 /-->
        <div class="help2">
           <a href="index.php?section=DeliveryMethod&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить способ</a>              
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
          
          <div class="clear">&nbsp;</div>	
          
          {$PagesNavigation}
  
          {if $Items}

          <!-- Форма товаров #Begin /-->
          <form name='products' method="post">
            <table id="list2">
            
              {* Список разделов *}
              {foreach item=item from=$Items}
              <tr>
                <td>
                  <div class="list_left">
                    <a href="index.php?section=DeliveryMethods&enable_id={$item->delivery_method_id}&token={$Token}" class="fl"><img src="./images/{if $item->enabled}lamp_on.jpg{else}lamp_off.jpg{/if}" alt=""/></a>
                    <div class="flxc">
                      <p>
                        <a href="index.php{$item->edit_get}" class="{if $item->enabled}tovar_on{else}tovar_off{/if}">{$item->name|escape}</a>
                      </p>
                      <p class=tovar_min>
                        Стоимость {$item->price|escape} {$MainCurrency->sign}. Бесплатно от {$item->free_from|escape} {$MainCurrency->sign}
                      </p>
                    </div>
			      </div>
                  <a href="index.php?section=DeliveryMethods&act=delete&item_id={$item->delivery_method_id}&token={$Token}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg" alt=""/></a>
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
