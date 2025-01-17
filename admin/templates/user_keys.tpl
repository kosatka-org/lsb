<!-- Управление товарами /-->

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Users{if $smarty.get.group}&group={$smarty.get.group}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}{if $smarty.get.keyword}&keyword={$smarty.get.keyword}{/if}" class="off">покупатели</a></li>
    <li><a href="index.php?section=User&keys=1&user_id={$User->original_user_id}" class="on">ключи</a></li>
    <li><a href="index.php?section=User&similar=1&user_id={$User->original_user_id}" class="off" >похожие клиенты</a></li>
    <li><a href="index.php?section=Groups" class="off">группы</a></li>
    <li><a href="index.php?section=User&deposit=1&user_id={$User->original_user_id}" class="off">депозит</a></li>
    <li><a href="index.php?section=User&measuring=1&user_id={$User->original_user_id}" class="off">мерки</a></li>
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href='index.php?section=Users'>Покупатели</a> →
          {if $User->user_id}{$User->name}{else}Новый покупатель{/if}
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
		{if $User->photo}
			<img src="{$User->photo}" width="83" class="line">
		{else}
			<img src="../images/empty_photo.png" width="83" class="line">
		{/if}
		
	    <!--<img src="./images/icon_content.jpg" alt="" class="line"/>-->
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">{if $User->user_id}{$User->name}{else}Новый покупатель{/if}</h1>
        <!-- /Заголовок раздела /-->
        
       
      </div>

      <div id="cont_center">

     
        <div class="clear">&nbsp;</div>	  
          


          {if $Users}



            <table id="list">
            
              {foreach item=item from=$Users}
              <tr>
                <td valign="top">
                    <img src="./images/{if $item->enabled}lamp_on.jpg{else}lamp_off.jpg{/if}" alt="" style="float:left;"/>
                  <div class="list_left" style="width:250px;">
                    <div class="flxc">
                      <p>
                        <a href="/admin/index.php?section=User&user_id={$item->user_id}" class="{if $item->enabled}tovar_on{else}tovar_off{/if}">{$item->name|escape}</a> 
						(<span title="original_user_id">{$item->original_user_id|escape}</span>&nbsp;/&nbsp;<span title="код 1C">{$item->code|escape}</span>)
                      </p>
                      <p>
                        <span class="tovar_min">{$item->email|escape}</span>
                      </p>
                    </div>
			      </div>
                </td>
                <td valign="top">
                  <div class="list_left">
                      <p>
                      </p>
			      </div>
                </td>
                <td valign="top">
				  {if $item->user_id != $item->original_user_id}
                  <div class="list_right">
                    <a href="/admin/index.php?section=User&keys=1&user_id={$User->user_id}&unlink={$item->user_id}" class="fl" onclick='return confirm("Вы уверены, что хотите отсоединить аккаунт?");'><img src="./images/delete.jpg" title="Отсоединить аккаунт"/></a>
                  </div>
				  {/if}
                </td>
              </tr>
              {/foreach}
            </table>
            <input type=submit value='Сохранить изменения' style='display:none;'>


            {else}
              <div class="emptylist">Нет объединенных аккаунтов</div>
            {/if}

			
	 
    </div>
  </div>	    
</div>
<!-- Content #End /--> 
