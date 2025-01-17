<!-- Управление товарами /-->

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Users{if $smarty.get.group}&group={$smarty.get.group}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}{if $smarty.get.keyword}&keyword={$smarty.get.keyword}{/if}" class="off">покупатели</a></li>
    <li><a href="index.php?section=User&keys=1&user_id={$User->original_user_id}" class="off">ключи</a></li>
    <li><a href="index.php?section=User&similar=1&user_id={$User->original_user_id}" class="off" >похожие клиенты</a></li>
    <li><a href="index.php?section=Groups" class="off">группы</a></li>
    <li><a href="index.php?section=User&deposit=1&user_id={$User->original_user_id}" class="off">депозит</a></li>
    <li><a href="index.php?section=User&measuring=1&user_id={$User->original_user_id}" class="on">мерки</a></li>
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
        <h1 id="headline">Мерки пользователя</h1>
        <!-- /Заголовок раздела /-->
        
      </div>

      <div id="cont_center">
        <div class="clear">&nbsp;</div>	  
        <div id="over">
          <!--<div id="over_right" style="float:right;width:445px;padding-right:10px;">
            <table>
              <tr><td colspan="3">
              <h2>История принятия</h2>
              </td></tr>
              {if $accept_history}
                {foreach item=data from=$accept_history}
                  <tr>
                    <td class="m_t" style="width: 150px;">{$data->status_date}</td>
                  </tr>
                  <tr>
                    <td class="m_t"><p><i>Изменение депозита</i></p></td>
                    <td class="m_t"><p><i>{if $data->sum > 0}+{$data->sum} рублей{else}{$data->sum} рублей{/if}</i></p></td>
                  </tr>
                  <tr><td class="m_t">&nbsp;</td></tr>
                {/foreach}
              {/if}
            </table>						
          </div>-->
          <div class="clear">&nbsp;</div>	  
          {foreach from=$user_measurments item=item key=key}
            <div class="fatlist_col">
              <table class="measurings_form" Style='width:100%'>
                <tr>
                  <td class="model">Категория</td>
                  <td class="m_t model"><p>{$item->category_name}</p></td>
                </tr>
                {if $item->fitting}
                  <tr>
                    <td class="model" style="font-size: 12px;">Посадка</td>
                    <td class="m_t"><p>{$item->fitting}</p></td>
                  </tr>
                {/if}
                {if $item->material_stretch}
                  <tr>
                    <td class="model" style="font-size: 12px;">Материал</td>
                    <td class="m_t"><p>{$item->material_stretch}</p></td>
                  </tr>
                {/if}
                {if $item->waist}
                  <tr>
                    <td class="model" style="font-size: 12px;">замер по талии</td>
                    <td class="m_t"><p>{$item->waist}</p></td>
                  </tr>
                {/if}
                {if $item->hips}
                  <tr>
                    <td class="model" style="font-size: 12px;">замер по бедрам</td>
                    <td class="m_t"><p>{$item->hips}</p></td>
                  </tr>
                {/if}
                {if $item->thigh}
                  <tr>
                    <td class="model" style="font-size: 12px;">замер по ширине ляжки</td>
                    <td class="m_t"><p>{$item->thigh}</p></td>
                  </tr>
                {/if}
                {if $item->waist_height}
                  <tr>
                    <td class="model" style="font-size: 12px;">высота посадки</td>
                    <td class="m_t"><p>{$item->waist_height}</p></td>
                  </tr>
                {/if}
                {if $item->bottom_width}
                  <tr>
                    <td class="model" style="font-size: 12px;">замер низа брючины</td>
                    <td class="m_t"><p>{$item->bottom_width}</p></td>
                  </tr>
                {/if}
                {if $item->knee_width}
                  <tr>
                    <td class="model" style="font-size: 12px;">замер колена (для спорт.)</td>
                    <td class="m_t"><p>{$item->knee_width}</p></td>
                  </tr>
                {/if}
                {if $item->leg_lenght}
                  <tr>
                    <td class="model" style="font-size: 12px;">замер длины брючины</td>
                    <td class="m_t"><p>{$item->leg_lenght}</p></td>
                  </tr>
                {/if}
                {if $item->shoulders}
                  <tr>
                    <td class="model" style="font-size: 12px;">Замер по плечам</td>
                    <td class="m_t"><p>{$item->shoulders}</p></td>
                  </tr>
                {/if}
                {if $item->chest}
                  <tr>
                    <td class="model" style="font-size: 12px;">Замер объема груди</td>
                    <td class="m_t"><p>{$item->chest}</p></td>
                  </tr>
                {/if}
                {if $item->lenght_on_back}
                  <tr>
                    <td class="model" style="font-size: 12px;">Длина изделия по спине</td>
                    <td class="m_t"><p>{$item->lenght_on_back}</p></td>
                  </tr>
                {/if}
                {if $item->sleeve}
                  <tr>
                    <td class="model" style="font-size: 12px;">Замер длины рукава изделия</td>
                    <td class="m_t"><p>{$item->sleeve}</p></td>
                  </tr>
                {/if}
                {if $item->bottom_band}
                  <tr>
                    <td class="model" style="font-size: 12px;">Замер резинки внизу изделия</td>
                    <td class="m_t"><p>{$item->bottom_band}</p></td>
                  </tr>
                {/if}
              </table>
            </div>
            {if ($key+1)%3 == 0}<img src="./images/line.jpg" alt="" class="clear">{/if}
          {/foreach}
        </div>
      </div>
    </div>	    
  </div>
</div>
<!-- Content #End /--> 
