<div id="inserts_all">
  <!-- Вкладки /-->
 {include file='users_menu.tpl' active='calls'} 
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          Обзвоны
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
      <img src="./images/icon_users.jpg" alt="" class="line"/>
      <!-- /Иконка раздела /-->
      
      <!-- Заголовок раздела /-->
        <h1 id="headline">Обзвон {$call->name}</h1>
        <!-- /Заголовок раздела /-->
        
      </div>

      <div id="cont_center">
      <div id="cont_left"></div>
      <!-- Right Side #Begin/-->
        <div id="cont_right">
        
          {if $Error}
          <!-- Error #Begin /-->
          <div id="error_minh">
            <div id="error">
              <img src="./images/error.jpg" alt=""/><p>{$Error}</p>					
            </div>
          </div>
          <!-- Error #End /-->
          {/if}
          
          <div>
            Пол: {if $call->sex==1}Мужской{elseif $call->sex==2}Женский{else}Не определен{/if}<br>
            Бренды: 
            {foreach from=$call->brands item=brand}
              {$brand->name}
            {/foreach}
            Магазин: {$call->shop}<br>
            Сумма покупок: от {$call->sum_min} до {$call->sum_max}
          </div>

          <div class="clear">&nbsp;</div>
  
          {if $Users}
            <table id="list">
            
              {foreach item=item from=$Users}
              <tr>
                <td valign="top">
                  <div class="list_left" style="width:150px;">
                    <div class="flxc">
                      <p>
                        {$item->name|escape}
                      </p>
                      <h2>{$item->phone_number|escape}</h2>
					  <span>Карта: {$item->card_number|escape}</span>
                    </div>
			      </div>
                </td>
                <td valign="top">
					<img src="/images/Ls_icons_SMS_32x32_v01_RINGIN.png" style="cursor:pointer;" title="Дозвонились" 	onclick="if (!confirm('Вы уверены, что дозвонились?')) return false; $(this).parent().parent().hide();$.get('/admin/index.php?section=Users&call_user={$item->original_user_id}&status=call&phone_number={$item->phone_number}');">
					<img src="/images/Ls_icons_SMS_32x32_v01_RINGOUT.png" style="cursor:pointer;" title="Не дозвонились"	onclick="if (!confirm('Вы уверены, что дозвонились?')) return false; $(this).parent().parent().hide();$.get('/admin/index.php?section=Users&call_user={$item->original_user_id}&status=call&phone_number={$item->phone_number}');"
                <td valign="top">
					<div style="width:150px;">
						{if $item->last_phone_call_status == 0} Не звонили {/if}
						{if $item->last_phone_call_status == 1} Не дозвонились {/if}
						{if $item->last_phone_call_status == 2} Дозвонились {/if}
						<br>
						{if $item->last_phone_call != '0000-00-00 00:00:00'}Последний звонок:<br>{$item->last_phone_call}{/if}
					</div>
                </td>
                <td valign="top">
					<p>
						{if $item->shop}Магазин: {$item->shop}<br>{/if}
						{if $item->size_top}Размеры (верх): {$item->size_top}<br>{/if}
						{if $item->size_bottom}Размеры (низ): {$item->size_bottom}<br>{/if}
						{if $item->shoe_size}Размеры (обувь): {$item->shoe_size}<br>{/if}
						{if $item->clothing_size}Информация:<br>{$item->clothing_size}{/if}
					</p>
                </td>
                <td valign="top">
                  <div class="list_right">
					{if $item->stop_sms != 1}
						<img src="/images/stop_sms.png" style="cursor:pointer;" title="Добавить в смс СТОП-лист" onclick="if ( !confirm('Вы уверены, что нужно добавить в СТОП-лист?') ) return false; $.get('/index.php?module=Login&do_not_disturb&type=sms&user_id={$item->original_user_id}');$(this).hide();">
					{/if}
                  </div>
                </td>
              </tr>
              {/foreach}
            </table>
            {else}
              <div class="emptylist">Нет покупателей</div>
            {/if}

            {$PagesNavigation}
            <div class="clear">&nbsp;</div>
			</form>
        </div>
	    <!-- Right side #End/-->
	  </div>  
    </div>
  </div>	    
</div>
<!-- Content #End /--> 