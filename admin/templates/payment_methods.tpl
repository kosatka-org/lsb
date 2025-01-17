<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
      {if in_array('Setup', $user_allowed)}<li><a href="index.php?section=Setup" class="off">параметры</a></li>{/if}
      {if in_array('Currency', $user_allowed)}<li><a href="index.php?section=Currency" class="off">валюты</a></li>{/if}
      {if in_array('DeliveryMethods', $user_allowed)}<li><a href="index.php?section=DeliveryMethods" class="off">доставка</a></li>{/if}
      <li><a href="index.php?section=PaymentMethods" class="on">оплата</a></li>
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          Формы оплаты</a>
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
	    <img src="./images/icon_card.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">Формы оплаты</h1>
        <!-- /Заголовок раздела /-->
        
        
		 <!-- Помощь2 /-->
        <div class="help2">
              <a href="index.php?section=PaymentMethod&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить форму</a>              
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
          
          {if $allowed_admin || $smarty.session.user->user_id == 12625 || $smarty.session.user->user_id == 13556}
            {if !$sber_on}<a href="index.php?section=PaymentMethods&enable_sber=1" onclick="return confirm('Вы точно хотите включить все варианты оплаты через Сбербанк?') ? true : false;" class="btn btn-primary btn-confirm" style="background-color: #337ab7;" title="Включить всех пользователей">Включить Сбер</a>{/if}
            {if $sber_on}<a href="index.php?section=PaymentMethods&enable_sber=0"onclick="return confirm('Вы точно хотите выключить все варианты оплаты через Сбербанк?') ? true : false;" class="btn btn-primary" style="background-color: #337ab7;" title="Выключить всех пользователей">Выключить Сбер</a>{/if}
            {if !$rfi_on}<a href="index.php?section=PaymentMethods&enable_rfi=1" onclick="return confirm('Вы точно хотите включить все варианты оплаты через РФИ?') ? true : false;" class="btn btn-primary btn-confirm" style="background-color: #337ab7;" title="Включить всех пользователей">Включить РФИ</a>{/if}
            {if $rfi_on}<a href="index.php?section=PaymentMethods&enable_rfi=0"onclick="return confirm('Вы точно хотите выключить все варианты оплаты через РФИ?') ? true : false;" class="btn btn-primary" style="background-color: #337ab7;" title="Выключить всех пользователей">Выключить РФИ</a>{/if}
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
                    <a href="index.php?section=PaymentMethods&enable_id={$item->payment_method_id}&token={$Token}" class="fl"><img src="./images/{if $item->enabled}lamp_on.jpg{else}lamp_off.jpg{/if}" alt=""/></a>
                    <div class="flxc">
                      <p>
                        <a href="index.php{$item->edit_get}" class="{if $item->enabled}tovar_on{else}tovar_off{/if}">{$item->name|escape}</a>
                      </p>
                      <p class=tovar_min>
                        Валюта: {$item->currency|escape} ({$item->rate_from*1} {$item->sign} = {$item->rate_to*1} {$MainCurrency->sign})
                      </p>
                    </div>
			      </div>
                  <a href="index.php?section=PaymentMethods&act=delete&item_id={$item->payment_method_id}&token={$Token}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg" alt=""/></a>
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
