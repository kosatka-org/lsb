<!-- Управление товарами /-->

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Users{if $smarty.get.group}&group={$smarty.get.group}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}{if $smarty.get.keyword}&keyword={$smarty.get.keyword}{/if}" class="off">покупатели</a></li>
    <li><a href="index.php?section=User&keys=1&user_id={$User->original_user_id}" class="off">ключи</a></li>
    <li><a href="index.php?section=User&similar=1&user_id={$User->original_user_id}" class="on" >похожие клиенты</a></li>
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
        <h1 id="headline" data-oid="{$User->original_user_id}" data-user_id="{$User->user_id}">{if $User->user_id}{$User->name}{else}Новый покупатель{/if}</h1>
        <!-- /Заголовок раздела /-->
        
      </div>

      <div id="cont_center">

     
        <div class="clear">&nbsp;</div>	  
          


          {if $Users}



            <table id="list" style="width:50%;float: left;"> 
            
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
                        <span class="tovar_min">{$item->email|escape}</span>&nbsp;<span class="tovar_min">{$item->phone_number|escape}</span>
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
                  <div class="list_right">
                    <a href="/admin/index.php?section=User&similar=1&user_id={$User->user_id}&original_user_id={$User->original_user_id}&link_id={$item->user_id}" class="fl" onclick='return confirm("Вы уверены, что хотите присоединить аккаунт?");'><img src="/admin/images/add.jpg" title="Объединить аккаунты"/></a>
                  </div>
                </td>
              </tr>
              {/foreach}
            </table>
            <input type=submit value='Сохранить изменения' style='display:none;'>


            {else}
              <div class="emptylist">Нет похожих аккаунтов</div>
            {/if}

            <div style="width:45%;float: left; padding-bottom:20px;">
            <form autocomplete="off" action="/index.php?module=Cart&client_find&spec&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'))" method="post" name="find_user" enctype="multipart/form-data">
                <div>
                    <div>
                        Телефон, почта или Имя
                    </div>
                    <div style="float: left; margin: 10px 10px 10px 0; width: 100%;">
                        <input type="text" name="client_info" class="simple_big" id="client_info" value="">
                        <div class="person"></div>
                    </div>
                    <div style="float: left; width: 100%;">
                        <a href="#" onclick="jQuery('.popResult').load('/index.php?module=Cart&amp;client_find&amp;add&amp;search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'));return false;" style="border-width:0px;">
                            <input type="submit" id="client_info" value="Найти">
                        </a>
                    </div>
                    <div class="clear"></div>
                    <div class="popResult"></div>
                </div>
            </form>
			</div>
	 
    </div>
  </div>	    
</div>

{literal}      
	<script>
    $(document).on("click touchstart", "a.assign_user", function(e) {
      e.preventDefault();
      var orig_id = $('#headline').attr("data-oid");
      var user_id = $('#headline').attr("data-user_id");
      var link_id = $(this).attr("data-uid");
      window.location = "/admin/index.php?section=User&similar=1&user_id="+user_id+"&original_user_id="+orig_id+"&link_id="+link_id;
      
    });
	</script>
{/literal}
<!-- Content #End /--> 
