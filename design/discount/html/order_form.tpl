<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

{literal}
<script>
	send_order = 0;
	function clearText(thefield){
		if (thefield.defaultValue==thefield.value)
		thefield.value = "";
	}
	$(document).ready( function() {
    $('#referrer').val(ref);
	
		promo_code = $('#sneaky_form input[name="coupon_code"]').val();
		if (promo_code)	$('#form_order input[name="coupon_code"]').val(promo_code);
	
		$(".formError").remove();
		$("#form_order").validationEngine();
		
		var a = $('#city').autocomplete({
			serviceUrl:'/cities.php',
			minChars: 2,
			maxHeight:400,
			width:300,
			zIndex: 19999,
			deferRequestBy: 300,
			noCache: false,
			onSelect: function(value, data) { $('#city_id').val(data); }
		});		
		$('input').keydown(function(e) {
			if (e.keyCode == 13) {
				$('#form_order').submit();
			}
		});
	});
</script>

<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-left {
		display: none !important;
	}
	#fancybox-right {
		display: none !important;
	}
</style>

{/literal}

<div class="ShAA_popBackTop" style="background: none; width: 621px;"><img src="/images/pop_back_top.png" style="width: 621px; height: 100%;"></div>
<div class="ShAA_popBackCenter" style="width: 620px;">
	<div class="ShAA_popContent" style="width: 500px;">
		<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -15px -35px 0 0;" width="16"></a>
		{if $group_id == 2 || $group_id == 3 }
			<div class="info" style="color: red;">Внимание, вы оформляете заказ, как модератор или администратор</div>
		{/if}
		<div class="ShAA_pop_title">Пожалуйста, заполните контактную информацию</div>
		<form autocomplete="off" action="/cart/" method="post" name="form_order" id="form_order" onsubmit="{literal}if ( typeof(order_send) == 'undefined' ) { order_send = 1; } <!--if (!send_order)  send_order=1; return false;-->{/literal}">
			<input name="coupon_code" type="hidden" value="{$coupon_code|escape}" />
			<input type="hidden" value="1" name="submit_order"/>
            <input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Обращение
				</div>
				<div class="ShAA_popInputOrder">
					<input name="name" id="name" type="text" {literal}class="validate[required]"{/literal} value="{if $smarty.session.user}{$smarty.session.user->name}{else}{/if}" placeholder="Имя Отчество Фамилия, пример: Петр Сергеевич Иванов" onclick="if (send_order) send_order=0;" autofocus/>
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Телефон
				</div>
				<div class="ShAA_popInputOrder phone">
					<span class="ShAA_prefixForMiniInput">+7</span><input placeholder="XXXXXXXXXX" name="phone" id="order_phone" type="text" {literal}class="validate[required,custom[phone]]"{/literal} value='{if $smarty.session.user->phone_number}{php} echo substr($_SESSION['user']->phone_number, -10);{/php}{/if}' maxlength="10" type="text" onclick="if (send_order)send_order=0;" />
				</div>
			</div>
			<!--
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Промо-код
				</div>
				<div class="ShAA_popInputOrder phone">
					<input name="coupon_code" type="text" value="{$coupon_code|escape}" />
				</div>
			</div>-->


			{if $smarty.session.user}
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Почта
				</div>
				<div class="ShAA_popInputOrder">
					<input name="email" id="email" type="text" {literal}class=""{/literal} value='{if $smarty.session.user->email}{$smarty.session.user->email}{/if}' placeholder="Электронная почта, пример: name@gmail.com" maxlength=100 type="text" onclick="if (send_order) send_order=0;" />
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Город
				</div>
				<div class="ShAA_popInputOrder">
					<select name="city_id" id="city_id" class="" {if $total < 10000}onchange="$('#delivery_area').html($('#delivery_area_holder').html());$('#delivery_area').load('/delivery_price.php?city_id=' + $('#city_id').eq(0).val() + '&total={$total}&weight={$weight}');"{/if}>
						<option value="0">Пожалуйста, выберите ваш город</option>
						<option value="0"> </option>
						{foreach from=$delivery_cities_main item=delivery_city}
							<option value="{$delivery_city->city_id}" {if $smarty.session.user->city_id == $delivery_city->city_id}selected{/if}><b>{$delivery_city->city_name}</b></option>
						{/foreach}
						<option value="0"> </option>
						{foreach from=$delivery_cities item=delivery_city}
							<option value="{$delivery_city->city_id}" {if $smarty.session.user->city_id == $delivery_city->city_id}selected{/if}>{$delivery_city->city_name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Адрес
				</div>
				<div class="ShAA_popInputOrder">
					<input name="address" id="address" type="text" value="{if $smarty.session.user->adress}{$smarty.session.user->adress}{else}{/if}{literal}" placeholder="улица, дом-квартира, пример: Ленина 5-23" class=""{/literal} onclick="if (send_order) send_order=0;" />
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<div class="ShAA_popTitleInput">
					Ваш комментарий
				</div>
				<div class="ShAA_popInputOrder">
					<textarea name="comment" id="comment" placeholder=""></textarea>
				</div>
			</div>
			<div class="ShAA_popData ShAA_popDataSett">
				<span id="delivery_area_holder" style="display:none;">
					<div class="info">Уточняем стоимость доставки...</div>
				</span>
				<span id="delivery_area">
					{if $total >= 10000}
						<div class="ShAA_orderField">
							<div class="title">Доставка бесплатно</div>
						</div>
					{elseif $smarty.session.user->city_id}
						<div class="info">Уточняем стоимость доставки...</div>
					{literal}
						<script>
							$(document).ready( function() {
								$('#delivery_area').load('/delivery_price.php?city_id={/literal}{$smarty.session.user->city_id}&total={$total}&weight={$weight}{literal}');
							});
						</script>
					{/literal}
					{else}
						<div class="info">Стоимость доставки будет расчитана, после выбора города</div>
					{/if}
				</span>
			</div>
			{/if}
			

			<div class="ShAA_orderButtonBlock">
				<div class="rightText"></div>
				<div style="float: left; width: 220px; margin: -5px 0 0 0;">
					<a href="javascript:void(0);" onclick="{literal} if (!send_order) $('#form_order').submit(); send_order=1; return false;{/literal}">
						<input type="submit" value="Заказать" class="ShAA_orderButtonClear">
					</a>
				</div>
			</div>
		</form>
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottom" style="background: none; width: 621px;"><img src="/images/pop_back_bottom.png" style="width: 621px;"></div>