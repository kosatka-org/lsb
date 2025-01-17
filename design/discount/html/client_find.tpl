{foreach from=$users item=user}
<div class="ShAA_popResultClient">
	<div class="ShAA_pop_title">{$user->name} (<span title="original_user_id">code: {$user->original_user_id|escape}</span>&nbsp;/&nbsp;<span title="код 1C">код 1С: {$user->code|escape}</span>)</div>
	<div class="ShAA_popData ShAA_popDataSett">
		<div class="ShAA_popTitleInput">
			{if $user->phone_number}Телефон: {$user->phone_number}{/if}{if $user->email}, Почта: {$user->email} {/if}<br>
			{if $user->card_number}Номер карты №{$user->card_number} &nbsp;&nbsp;&nbsp;&nbsp; <!--<a href="#">Отправить SMS</a> &nbsp;&nbsp; <a href="#">Отправить письмо</a>--><br>{/if}
			<!--Персональная скидка [%USER_DISCOUNT%] <br>-->
			{if $user->last_login_date != '0000-00-00 00:00:00'}
			Последний визит на сайте: {$user->last_login_date}
			{/if}
		</div>
	</div>
	{if $user->stop_sms != 1 && $user->phone_length > 9 && $user->phone_length < 13}
		<!--<img class="controls_{$user->user_id}" src="/images/stop_sms.png" style="float:right;cursor:pointer;" title="Добавить в смс СТОП-лист" onclick="if ( !confirm('Вы уверены, что хотите добавить клиента с СМС СТОП-лист?') ) return false; jQuery('.controls_{$user->user_id}').hide(); jQuery.get('/index.php?module=Login&do_not_disturb&type=sms&user_id={$user->original_user_id}');">-->
		<img class="controls_{$user->user_id}" src="/images/send_sms.png" style="float:right;cursor:pointer;" title="Отправить страницу в СМС" onclick="if ( !confirm('Вы уверены, что хотите хотите отправить клиенту страницу в СМС?') ) return false; jQuery(this).hide(); jQuery.get('/index.php?module=Cart&send_sms&client_find&user_id={$user->original_user_id}');">
	{/if}
</div>
{/foreach}