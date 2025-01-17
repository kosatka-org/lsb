<!-- Управление товарами /-->

<div id="inserts_all">
  <!-- Вкладки /-->
{if $email}
	{include file='message_menu.tpl' active='email'}
{else}
	{include file='message_menu.tpl' active='sms'}
{/if}
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

	  <div id="cont_top">
		<!-- Иконка раздела /-->
		<img src="./images/icon_users.jpg" alt="" class="line"/>
		<!-- /Иконка раздела /-->

{if $email}
		<h1 id="headline">Email-рассылка клиентам Лакшери Стор</h1>
{else}
		<h1 id="headline">СМС-рассылка клиентам Лакшери Стор</h1>
{/if}


	  </div>

	  <div id="cont_center">

		<!-- Левое меню /-->
		<div id="cont_left">


		</div>
		<!-- /Левое меню /-->

		<!-- Right Side #Begin/-->
		<div id="cont_right">

		  {if $sended}
		  <div id="error_minh">
			<div id="error">
			  <img src="./images/error.jpg" alt=""/><p>Отправляется {$sended} сообщений</p>
			</div>
		  </div>
		  {/if}
{literal}
<script>
	function calculate_destination() {
		$('#people').html('уточняю...');
		$.ajax({
			url: $('#form').attr('action') + '&only_people',
			dataType: 'html',
			type: 'POST',
			async: false,
			data: $('#form').serialize(),
			success: function(resp){
				$('#people').html(resp);
			}
		});
	}
	$(document).ready(function() {
		calculate_destination();
	});
</script>
{/literal}
		  <div class=filter>
			<p>
			Инструкция: <br>
			{if $email}
			{literal}<b>{USERNAME}</b> - автоматически заменяется на имя клиента <br>
			<b>{USERPHONE}</b> - автоматически заменяется на номер телефона клиента <br>
			<b>{CARDNUMBER}</b> - автоматически заменяется на номер карты клиента <br>
			<b>{LOGINURL}</b> - автоматически заменяется на быструю ссылку для логина{/literal}
			{else}
			{literal}<b>{USERNAME}</b> - автоматически заменяется на имя клиента <br>
			<b>{CARDNUMBER}</b> - автоматически заменяется на номер карты клиента <br>
            <b>{ENTER}</b> - автоматически заменяется на быструю ссылку для логина <br>
			<b>www.lsboutique.ru</b> - сайт нужно указывать с www, иначе телефон клиента не видит ссылку{/literal}
			{/if}
			</p>
			<div class="clear">&nbsp;</div>
			<form method="post" action="/admin/index.php?section=Users{if $email}&email{else}&sms{/if}" id="form" name="form">
{if $email}
{else}			<p>Дата: <input type="text" name='date_time' id="date_time_picker"></p><br><br>
				<p>Не учитывать ограничение на отправку СМС <input type="checkbox" onclick="calculate_destination();" name="no_limit" style="
					margin-left: 10px;
					vertical-align: middle;"
				></p>
                <p>Не учитывать параметр stop_sms <input type="checkbox" onclick="calculate_destination();" name="ignore_stop_sms" style="
                    margin-left: 10px;
                    vertical-align: middle;"
                ></p>
				<br>
				Отправитель:
                {assign var='senders' value='|'|explode:"Lsboutique|LuxuryStore|PodiumVIP|Ramsey|ICEBERG|VIPSALE|ARTIOLI|BERLUTI|BILLIONAIRE|CELINE|CHLOE|FENDI|ISAIA|KITON|LOROPIANA|TOMFORD|VIPSALE|ZILLI"}
                {foreach item=sender from=$senders}
                    <input name="sender" value="{$sender}" {if $sender=="Lsboutique"}checked="checked"{/if} type="radio" id="{$sender}"><label for="{$sender}">{$sender}</label>&nbsp;
                {/foreach}
				<div class="clear">&nbsp;</div>
{/if}
				<input name="sex" value="0" id="sex_all" checked="checked" type="radio" onclick="calculate_destination();"><label for="sex_all">Все</label>&nbsp;
				<input name="sex" value="1" id="sex_man" type="radio" onclick="calculate_destination();"><label for="sex_man">Мужчины</label>&nbsp;
				<input name="sex" value="2" id="sex_woman" type="radio" onclick="calculate_destination();"><label for="sex_woman">Женщины</label>&nbsp;
				<div class="clear">&nbsp;</div>
				<label>Сумма покупок от</label>
		        <select name="sum_min" onchange="calculate_destination();">
		          <option value="0">0</option>
		          <option value="1">1</option>
		          <option value="100000">100 000</option>
		          <option value="200000">200 000</option>
		          <option value="500000">500 000</option>
		          <option value="1000000">1000 000</option>
		          <option value="1500000">1500 000</option>
		          <option value="2000000">2000 000</option>
		          <option value="3000000">3000 000</option>
		        </select>
		        <div class="clear">&nbsp;</div>
				Магазин (оставьте пустым, чтобы выбрать все):<br>
				{foreach item=item from=$shops}
					<nobr><label for="shop_{$item->shop_id}"><input name="shop[{$item->shop_id}]" value="1" onclick="calculate_destination();" id="shop_{$item->shop_id}" type="checkbox">&nbsp;{$item->name}</label></nobr>&nbsp;&nbsp;
				{/foreach}
				<br><br>
				Город (оставьте пустым, чтобы выбрать все):<br>
				{foreach item=item from=$cities}
					<nobr><label for="city_{$item->city_id}"><input name="city[{$item->city_id}]" value="1" onclick="calculate_destination();" id="city_{$item->city_id}" type="checkbox">&nbsp;{$item->city}</label></nobr>&nbsp;&nbsp;
				{/foreach}
				<br><br>
				Бренд (оставьте пустым, чтобы выбрать все):<br>
				{foreach item=item from=$brands}
					<nobr><label for="brand_{$item->brand_id}"><input name="brand[{$item->brand_id}]" value="1" onclick="calculate_destination();" id="brand_{$item->brand_id}" type="checkbox">&nbsp;{$item->name}</label></nobr>&nbsp;&nbsp;
				{/foreach}<br>
				{if $email}{literal}
				<div class="clear">&nbsp;</div>
				Тема: <input name="subject" value="" placeholder="{USERNAME}, ура, супер скидки!" style="width:410px;">
				{/literal}{/if}
				<div class="clear">&nbsp;</div>
				<textarea onkeyup="$('#symbols').html($(this).val().length);" id="message" name="message" cols="54" rows="8" placeholder="{literal}{USERNAME}, 60% СКИДКИ НА ВСЕ!!! Versace, Kiton, Loro Piana, Fendi, Iceberg. Не пропустите распродажу в Лакшери Стор, Нижне-Волжская наб. 8/7, 430-36-30 или www.lsboutique.ru{/literal}"></textarea><br>
				<input type='submit' value='Отправить' class="submit10" onclick="return confirm('Вы уверены?');">
				<br>
				<label>Отправить тестовую смс на номер: </label>
				<input id='test_phone' value="{$smarty.session.user->phone_number|substr:1}" style="width:210px;margin-left:20px;">
				<input type="submit" id='test_sms' value="Отправить тестовую смс">
				<span style="float:right;">Аудитория: <b><span id="people">0</span></b>&nbsp;&nbsp;Символов: <b><span id="symbols">0</span></b></span>
			</form>
		  </div>

		  <div class="clear">&nbsp;</div>


		</div>
		<!-- Right side #End/-->
	  </div>
	</div>
	<div style="margin-left: 226px;">
	<h2>История СМС рассылок</h2>
	{foreach from=$sms_history item=sms}
		<div style="font-size: 14px;margin-bottom: 26px;width: 600px;">{$sms->date}
		<br>
		Отправитель: {$sms->sender}
		<br>
		Администратор: {$sms->admin}
		<br>
		Пол: {if $sms->sex == 0}Все{elseif $sms->sex == 1}Мужчины{else}Женщины{/if}
		<br>
		Магазин: {$sms->shop}
		<br>
		Город: {$sms->city}
		<br>
		Бренд: {$sms->brand}
		<br>
		Аудитория: {if $sms->clients_count == 0}Нет информации{else}{$sms->clients_processed} из {$sms->clients_count}{/if}
		<br>
		Сообщение: {$sms->message}
		<br>
		<a href="/admin/index.php?section=Users&sms&repeat={$sms->id}" onclick="return confirm('Вы уверены, что хотите повторить рассылку?');">Повторить</a>
		</div>
	{/foreach}
	</div>
  </div>
</div>
<!-- Content #End /-->

{literal}
<script>
$(function() {
	$.datepicker.regional['ru'] = {
		closeText: 'Закрыть',
		prevText: '<Пред',
		nextText: 'След>',
		currentText: 'Сегодня',
		monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
		'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
		monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
		'Июл','Авг','Сен','Окт','Ноя','Дек'],
		dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
		dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
		dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
		weekHeader: 'Не',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''
	};
	$.datepicker.setDefaults($.datepicker.regional['ru']);

	$('#date_time_picker').datetimepicker({
		minDate: new Date(),
		timeFormat: 'HH:mm',
		dateFormat: 'dd-mm-yy'
	});

	$('#test_sms').on('click', function(e){
		e.preventDefault();
		var phone = $('#test_phone').val();
		var message = $('#message').val();
		$.post('/admin/index.php?section=Users&sms', {test_phone: phone, message: message}, function (data) {
				if (data == 'OK') {
					alert("Тестовое сообщение на номер "+phone+" отправлено.");
				}
			}
		);
	});

});
</script>
{/literal}
