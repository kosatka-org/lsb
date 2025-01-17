{literal}
<style type="text/css">
body {
	background: none;
}
.mt20 {
	margin-top: 20px;
}
</style>
{/literal}

<div id="inserts_all">
  <!-- Вкладки /-->
	{include file='message_menu.tpl' active='email'}
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

		<h1 id="headline">Email-рассылка клиентам Лакшери Стор</h1>


	  </div>

	  <div id="cont_center">


		<!-- Right Side #Begin/-->
		<div id="cont_right">

		  {if $sended}
		  <div id="error_minh">
			<div id="error">
			  <img src="./images/error.jpg" alt=""/><p>Отправляется {$sended} сообщений</p>
			</div>
		  </div>
		  {/if}

		  <div class="filter" style="width:926px;">
			<div class="clear">&nbsp;</div>
			<form method="post" action="/admin/index.php?section=Users{if $email}&email{else}&sms{/if}" id="form" name="form">
			{if $email}
				<div class="form-group row">
			    <label for="date_time_picker" class="col-sm-2 control-label">Дата:</label>
			    <div class="col-sm-10">
						<input class="form-control" name="date_time" type="text" id="date_time_picker">
			    </div>
			  </div>
				<div class="form-group row">
			    <label for="sender_name" class="col-sm-2 control-label">Имя отправителя:</label>
			    <div class="col-sm-10">
						<input class="form-control" name="sender_name" value="Luxury Store" type="text" id="sender_name">
			    </div>
			  </div>
				<div class="form-group row">
			    <label for="sender_email" class="col-sm-2 control-label">Адрес отправителя:</label>
			    <div class="col-sm-10">
						<input class="form-control" name="sender_email" value="mail@lstore.moscow" type="text" id="sender_email">
			    </div>
			  </div>
			{else}
				<p>Не учитывать ограничение на отправку СМС <input type="checkbox"o nclick="calculate_destination();" name="no_limit" style="margin-left: 10px;vertical-align: middle;"></p>
				<br>
				Отправитель:
				<input name="sender" value="lsboutique" checked="checked" type="radio" id="lsboutique"><label for="lsboutique">lsboutique</label>&nbsp;
				<input name="sender" value="LuxuryStore" type="radio" id="LuxuryStore"><label for="LuxuryStore">LuxuryStore</label>&nbsp;
				<input name="sender" value="Podium Vip" type="radio" id="PodiumVip"><label for="PodiumVip">Podium Vip</label>&nbsp;
				<input name="sender" value="Ramsey" type="radio" id="Ramsey"><label for="Ramsey">Ramsey</label>&nbsp;
				<input name="sender" value="ICEBERG" type="radio" id="ICEBERG"><label for="ICEBERG">ICEBERG</label>&nbsp;
				<input name="sender" value="PODIUM" type="radio" id="PODIUM"><label for="PODIUM">PODIUM</label>&nbsp;
				<div class="clear">&nbsp;</div>
			{/if}
				<label class="radio-inline">
					<input name="sex" value="0" id="sex_all" checked="checked" type="radio" onclick="calculate_destination();"> Все
				</label>
				<label class="radio-inline">
					<input name="sex" value="1" id="sex_man" type="radio" onclick="calculate_destination();"> Мужчины
				</label>
				<label class="radio-inline">
					<input name="sex" value="2" id="sex_woman" type="radio" onclick="calculate_destination();"> Женщины
				</label>
				<div class="clear">&nbsp;</div>

				<label>Сумма покупок от</label>
		        <select class="form-control" name="sum_min" onchange="calculate_destination();">
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

				<label>Магазин (оставьте пустым, чтобы выбрать все):</label><br>
				{foreach item=item from=$shops}
					<label class="checkbox-inline" for="shop_{$item->shop_id}"><input name="shop[{$item->shop_id}]" value="1" onclick="calculate_destination();" id="shop_{$item->shop_id}" type="checkbox">{$item->name}</label>
				{/foreach}
				<br><br>
				<label>Город (оставьте пустым, чтобы выбрать все):</label><br>
				{foreach item=item from=$cities}
					{if $item->city != ''}
					<label class="checkbox-inline" for="city_{$item->city_id}"><input name="city[{$item->city_id}]" value="1" onclick="calculate_destination();" id="city_{$item->city_id}" type="checkbox">{$item->city}</label>
					{/if}
				{/foreach}
				<br><br>
				<label>Бренд (оставьте пустым, чтобы выбрать все):</label><br>
				{foreach item=item from=$brands}
					<label class="checkbox-inline" for="brand_{$item->brand_id}"><input name="brand[{$item->brand_id}]" value="1" onclick="calculate_destination();" id="brand_{$item->brand_id}" type="checkbox">{$item->name}</label>
				{/foreach}<br>
				{if $email}
				<div class="clear"></div><br>
				<label>Выбрать бренд для новых поступлений</label>
				<select id="brand-new" class="form-control">
				  <option value="0" selected="true">Не выбран</option>
				  <option value="Меха">Меха</option>
					{foreach from=$brands_new item=brand}
						<option value="{$brand->name}">{$brand->name}</option>
						<option value="{$brand->name}" data-sex="1">{$brand->name} Мужское</option>
						<option value="{$brand->name}" data-sex="2">{$brand->name} Женское</option>
					{/foreach}
				</select>
				<br>
				<div class="clear"></div><br>
				<label>Выбрать подборку</label>
				<select id="special" class="form-control">
				  <option value="0" selected="true">Не выбрана</option>
					{foreach from=$specials item=special}
						<option value="{$special->special_id}">{$special->name}</option>
					{/foreach}
				</select>
				<br>
				{literal}
				<div class="form-group">
			    <label>Тема:</label>
			    <input type="text" class="form-control" name="subject" id="subject" value="" placeholder="{USERNAME}, ура, супер скидки!">
			  </div>
				{/literal}{/if}
				<div class="clear">&nbsp;</div>
				<textarea id="textbox" name="message" cols="54" rows="8"></textarea><br>
				<input type='submit' value='Отправить' class="submit10 btn btn-primary" onclick="return confirm('Вы уверены?');"><span style="float:right;">Аудитория: <b><span id="people">0</span></b>&nbsp;&nbsp;Символов: <b><span id="symbols">0</span></b></span>
			</form>
		  </div>
			<div id="test_email" class="mt20">
				<label style="margin-right: 12px;"><input id="email" name="email" style="margin-right: 4px;">Ваш имейл</label>
				<button id="test_button" type="submit" class="btn testbtn btn-primary">Отправить тестовое письмо</button>
				<span style="margin-left: 20px;" id='test_success'></span>
			</div>

		  <div class="clear">&nbsp;</div>


		</div>
		<!-- Right side #End/-->
	  </div>
	</div>
  </div>
</div>
<!-- Content #End /-->
