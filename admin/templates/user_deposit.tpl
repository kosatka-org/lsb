<!-- Управление товарами /-->

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Users{if $smarty.get.group}&group={$smarty.get.group}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}{if $smarty.get.keyword}&keyword={$smarty.get.keyword}{/if}" class="off">покупатели</a></li>
    <li><a href="index.php?section=User&keys=1&user_id={$User->original_user_id}" class="off">ключи</a></li>
    <li><a href="index.php?section=User&similar=1&user_id={$User->original_user_id}" class="off" >похожие клиенты</a></li>
    <li><a href="index.php?section=Groups" class="off">группы</a></li>
    <li><a href="index.php?section=User&deposit=1&user_id={$User->original_user_id}" class="on">депозит</a></li>
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
        <div id="over">
			<div id="over_right" style="float:right;width:445px;padding-right:10px;">
				<table>
					<tr><td colspan="3">
					<h2>История депозита</h2>
					</td></tr>
					{if $deposit_history}
						{foreach item=data from=$deposit_history}
							<tr>
								<td class="m_t" style="width: 150px;">{$data->record_date}</td>
							</tr>
							<tr>
								<td class="m_t"><p><i>Изменение депозита</i></p></td>
								<td class="m_t"><p><i>{if $data->sum > 0}+{$data->sum} рублей{else}{$data->sum} рублей{/if}</i></p></td>
							</tr>
							<tr>
								<td class="m_t"><p><i>Причина</i></p></td>
								<td class="m_t"><p><i>{$data->reason}</i></p></td>
							</tr>
							<tr>
								<td class="m_t"><p><i>Номер заказа</i></p></td>
								<td class="m_t"><p><i>{$data->order_id}</i></p></td>
							</tr>
							<tr>
								<td class="m_t"><p><i>Кто начислил</i></p></td>
								<td class="m_t"><p><i>{$data->admin_id}</i></p></td>
							</tr>
							<tr><td class="m_t">&nbsp;</td></tr>
						{/foreach}
					{/if}
				</table>						
			</div>
			<div id="over_left" style="float:left;">
				<span class="model" style="color:green">Текущая сумма: {$User->deposit}</span>
				<div class="clear">&nbsp;</div>	  
				<form autocomplete="off" action='/index.php?module=Login&deposit' method="post" id="deposit" name="deposit" enctype="multipart/form-data">
					<div style="float: left;">
						Добавить:
						<div class="clear">&nbsp;</div>	  
						<input type="hidden" value="{$User->original_user_id|escape}" id="resiever_info"  name="resiever_info">
						Сумма<br />
						<input id="deposit_sum" notice='Введите сумму' value='' class="input3" style="width:250px;" placeholder="Сумма цифрами" name="deposit_sum" maxlength=100 type="text"/>
						<div class="clear">&nbsp;</div>	  
            Номер заказа<br />
						<input id="order_id" value='' class="input3" style="width:250px;" placeholder="Номер заказа" name="order_id" maxlength=100 type="text"/>
						<div class="clear">&nbsp;</div>	  
						Причина выдачи<br />
						<textarea id="field_reason" class="input3" style="width:250px;height:60px;" name="field_reason" placeholder=""></textarea>
						<div class="clear">&nbsp;</div>	  
						<input type="submit" value="Добавить" class="submit" onclick="jQuery('#deposit').submit();">
					</div>
				</form>
			</div>
		</div>
    </div>
  </div>	    
</div>
<!-- Content #End /--> 
