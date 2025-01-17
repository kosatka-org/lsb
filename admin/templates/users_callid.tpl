{literal}
<style>
.call_main_field {
	padding:0px;
}
</style>
{/literal}
<script src="https://cdnjs.cloudflare.com/ajax/libs/audiojs/1.0.1/audio.min.js"></script>
{literal}
<script>
$(document).ready(function() {
	audiojs.events.ready(function() {
		var as = audiojs.createAll();
	});
});
</script>
{/literal}


<div id="inserts_all">
  <!-- Вкладки /-->
 {include file='users_menu.tpl' active='call'} 
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr><td><p><a href="./">Luxury Store</a> → Звонки</p></td></tr>
  </table>
  <!-- /Путь /-->
</div>  
 
<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">

<div class="call_main_field_wrap" style="border:0px;">
	<div class="call_main_field" style="border:0px;">
{if $calls}
		<div class="call_half_col">
			Обзвон: <select onchange="window.location = '/admin/index.php?section=Calls&call_id=' + $(this).val();" style="width:300px;">
			{foreach item=ucall from=$calls}
				<option value="{$ucall->id}" {if $call->id == $ucall->id}selected{/if}>{$ucall->name}</option>
			{/foreach}
			</select>
		</div>
{/if}
{if $call}
		<div class="call_list_info">
			от {$call->date}, {if $ucall->sex==1}Мужчины{elseif $ucall->sex==2}Женщины{else}Пол не указан{/if}<br>
<!--			Zilli, Billi, с покупками выше 100.000 рублей<br>-->
            {if $call->sum_min}Сумма покупок: от {$call->sum_min}{/if}
			{if $call->shop}Магазины: {$call->shop}<br>{/if}
			<p>Шаблон СМС сообщения: {$call->sms_template} </p>
		</div>
		<div class="call_list_stat">
			<table class="call_gray_table">
				<tr class="call_gray_table_title">
					<td>
						Статистика
					</td>
				</tr>
				<tr>
					<td id="stat_container">
						<span class="big_blue_text">{$call->stat_total_percent}% </span><br>
						из {$call->stat_total}<br>
						{$call->stat_called} дозвонились<br>
						{$call->stat_total_wating} ждут звонка
					</td>
				</tr>
			</table>
		</div>
		{foreach item=item from=$Users}{if $item->name}
		<div class="call_info">
			<div class="call_info1col">
				{if $item->last_phone_call_status == 0} Не звонили {/if}
				{if $item->last_phone_call_status == 1} Не дозвонились: {/if}
				{if $item->last_phone_call_status == 2} Дозвонились: {/if}
				<br>
				{if $item->calls}
					Всего звонков - {$item->calls|@count}
					<br>
					{foreach item=call from=$item->calls}
						<div style="margin-top:12px;font-size:14px;">
							{$call->date} - {$call->sip_id} -- <a href="/cron/sip_calls/{$call->filename}" download>Скачать</a><br>
							<audio src="/cron/sip_calls/{$call->filename}" preload="auto" />
							<br>
						</div>
					{/foreach}
					<br>
				{/if}
				{if $item->last_phone_call != '0000-00-00 00:00:00'}{$item->last_phone_call}{/if}
				<br>
				{if $item->last_phone_call_status == 0} <span class="light_green_text"> {/if}
				{if $item->last_phone_call_status == 1} <span class="brown_text"> {/if}
				{if $item->last_phone_call_status == 2} <span class="light_gray_text"> {/if}
				<a href="/admin/index.php?section=User&user_id={$item->original_user_id}" download>{$item->name|escape}</a><br>
				{$item->phone_number|escape}</span>
			</div>
			<div class="call_info2col">
				{if $item->card_prepeared}
				Карта: {$item->card_prepeared|escape}<br>
				{/if}
				{if $item->purchase_last_what}
				<a target="_blank" href="/admin/index.php?section=Orders&view=search&keyword=user:{$item->original_user_id}">Покупка</a>: <b>{$item->purchase_last_what|escape}, {$item->purchase_last_date|escape}</b> <br>
				{/if}
				{if $item->shop}Магазин: {$item->shop}<br>{/if}
				{if $item->purchase_sum_real}
				Сумма покупок: <b>{$item->purchase_sum_real|escape}</b> рублей<br>
				{/if}
				{if $item->size_top}Размеры верх {$item->size_top},{/if}
				{if $item->size_bottom}низ {$item->size_bottom},{/if}
				{if $item->shoe_size}обувь {$item->shoe_size}{/if}
				<br>
				<!--покупал Zili, Billi, Isaia-->
			</div>
			<div class="call_info_button_row" data-user-id="{$item->original_user_id}" data-phone="{$item->phone_number}" data-call-id="{$call->id}">
				{if $item->last_phone_call_status != 2}<input id="" type="button" class="cbtn call_button200px" value="Дозвонились" data-confirm="Вы уверены, что дозвонились?" data-status="call">
				<input id="" type="button" class="cbtn call_button200px" value="Не дозвонились" data-status="callfail" data-confirm="Вы уверены, что не дозвонились?">
					{if $call->sms_template}
					<input id="" type="button" class="cbtn call_button200px" value="Отправить СМС" data-confirm="Вы уверены, что хотите отправить клиенту СМС?" data-status="sms">
					{/if}
				{/if}
			</div>
		</div>
		{/if}{/foreach}
{else}
	Активных списков звонков не найдено
{/if}
	</div>
</div>

    </div>
  </div>
</div>