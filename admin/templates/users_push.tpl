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
	{include file='message_menu.tpl' active='push'}
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
			<h1 id="headline">Push-рассылка клиентам Лакшери Стор</h1>
	  </div>

	  <div id="cont_center">


		<!-- Right Side #Begin/-->
		<div id="cont_right">
		  <div class="filter" style="width:926px;">
			<div class="clear">&nbsp;</div>
			<form method="post" id="form" name="form">
				<div class="form-group row">
			    <label for="date_time_picker" class="col-sm-2 control-label">Дата:</label>
			    <div class="col-sm-10">
						<input class="form-control" name="date_time" type="text" id="date_time_picker">
			    </div>
			  </div>

				<label class="radio-inline">
					<input class="sex-input filter-input" name="sex" value="0" id="sex_all" checked="checked" type="radio"> Все
				</label>
				<label class="radio-inline">
					<input class="sex-input filter-input" name="sex" value="1" id="sex_man" type="radio"> Мужчины
				</label>
				<label class="radio-inline">
					<input class="sex-input filter-input" name="sex" value="2" id="sex_woman" type="radio"> Женщины
				</label>
				<div class="clear">&nbsp;</div>

				<label>Сумма покупок от</label>
		        <select class="form-control sum-input filter-input" name="sum_min">
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
					<label class="checkbox-inline">
						<input class="shop-input filter-input" value="{$item->shop_id}" type="checkbox">{$item->name}
					</label>
				{/foreach}
				<br><br>

				<label>Город (оставьте пустым, чтобы выбрать все):</label><br>
				{foreach item=item from=$cities}
					{if $item->city != ''}
						<label class="checkbox-inline">
							<input class="city-input filter-input" value="{$item->city_id}" type="checkbox">{$item->city}
						</label>
					{/if}
				{/foreach}
				<br><br>

				<label>Бренд (оставьте пустым, чтобы выбрать все):</label><br>
				{foreach item=item from=$brands}
					<label class="checkbox-inline">
						<input class="brand-input filter-input" value="{$item->brand_id}" type="checkbox">{$item->name}
					</label>
				{/foreach}<br>
				<div class="clear"></div><br>
				<br>

				{literal}
				<div class="form-group">
			    <label>Тема:</label>
			    <input type="text" class="form-control" name="subject" id="subject" value="" placeholder="{USERNAME}, ура, супер скидки!">
			  </div>
				{/literal}

				<div class="clear">&nbsp;</div>
				<textarea id="textbox" name="message" cols="54" rows="8"></textarea><br>
				<button id="send_button" type='submit' class="submit10 btn btn-primary">Отправить</button><span style="float:right;">Аудитория: <b><span id="people">0</span></b>&nbsp;&nbsp;Символов: <b><span id="symbols">0</span></b></span>
			</form>
		  </div>
			<div id="test_email" class="mt20">
				<button id="test_button" type="submit" class="btn testbtn btn-primary">Отправить тестовое сообщение</button>
				<span style="margin-left: 20px;" id='send_success'></span>
			</div>
		  <div class="clear">&nbsp;</div>
		</div>
		<!-- Right side #End/-->
	  </div>
	</div>
  </div>
</div>
<!-- Content #End /-->
