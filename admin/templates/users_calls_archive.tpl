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
          Покупатели
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

	<div class="call_main_field_wrap" style="border:0px;">
		<div class="call_main_field" style="border:0px;">
			<div class="call_title">Подробнее по обзвонам</div>
			<table class="call_gray_table" style="margin: 20px 0 0 ;">
				<tr class="call_gray_table_title">
					<td style="width: 160px;">
						Звонки
					</td>
					<td style="width: 290px;">
						Описанрие
					</td>
					<td style="width: 120px;">
						Статистика
					</td>
					<td style="text-align: center;">
						Действие
					</td>
				</tr>
          {foreach item=ucall from=$users_calls}{if $ucall->name}
				<tr>
					<td>
						<span class="big_blue_text">{$ucall->stat_total_percent}%</span><br>
						{if $ucall->stat_total}из {$ucall->stat_total}<br>{/if}
<!--						36 звонков сделали пользователи<br>
						0% Имя пользователя<br>
						0% Имя <br>
						0% Имя-->
					</td>
					<td>
						<span class="call_name_text">{$ucall->name}</span><br>
						  создан {$ucall->date}<br>
						  {if $ucall->sex==1}Мужчины{elseif $ucall->sex==2}Женщины{else}Пол не указан{/if}<br>
						  {if $ucall->brands_list}<ul>Бренды:
							{foreach from=$ucall->brands_list item=brand}<li>&nbsp;{$brand->name}</li>{/foreach}
						  </ul><br>{/if}
						  {if $ucall->shop}Магазин: {$ucall->shop}<br>{/if}
						  {if $ucall->sum_min}Сумма покупок: от {$ucall->sum_min}{/if}
					</td>
					<td>
					  {$ucall->stat_called} разговоров<br>
					  {if $ucall->stat_missing} {$ucall->stat_missing} перезвонить<br>{/if}
					  <!--9 Поучили СМС<br>-->
					  {if $ucall->stat_total_waiting}{$ucall->stat_total_waiting} ждут звонка<br>{/if}
					</td>
					<td>
<!--						<input type="button" class="call_button126px" value="Завершить">-->
						<input type="button" class="call_button126px" value="Удалить" style="margin: 20px 0 0 15px;" onclick="if ( confirm(&quot;Пожалуйста, подтвердите удаление&quot;) ) window.location='index.php?section=Calls&calls&archive&delete_call={$ucall->id}'; ">
					</td>
				</tr>
          {/if}{/foreach}
			</table>
		</div>
	</div>

    </div>
  </div>	    
</div>
<!-- Content #End /-->  