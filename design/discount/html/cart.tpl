{literal}
<script language="javascript">
	$(document).ready(function(){
		$(".tab").click(function(){
			$(".tab").removeClass("tabact");
			$(this).addClass("tabact");
		});
		$(".titleCatalog").mousedown(function(){
			$(".cash_menu").removeClass("vis");
			$(".cash_menu").removeAttr("style");
			$("div", this).addClass("vis");
		});
		$(".imgCatalog_new").mousedown(function(){
			$(".cash_menu").removeAttr("style");
			$(this).next().children("div").toggle();
			$(".cash_menu").removeClass("vis");
		});
		$(".cash_menu").click(function(){
			$(".cash_menu").removeAttr("style");
			$(".cash_menu").removeClass("vis");
		});
		$('.avatar').mouseenter(function() {
			$('.avatar_change').fadeIn()
		});
		$('.avatar').mouseleave(function() {
			$('.avatar_change').fadeOut()
		});
	});
</script>
<script language="javascript">
	$(document).ready( function () {
        $('#referrer').val(ref);
	
		$('#sneaky_form input[name="coupon_code"]').keyup(function(){
			promo_code = $(this).val();
			
			if(promo_code == ''){				
				$('#sneaky_form .response').html('');
				return;
			}
			
			$.get('/ajax_check_promo.php', {'promo_code':promo_code}, function(data){
				if($.isEmptyObject(data)){
					$('#sneaky_form .response').html('Промо-код некорректный').css({'color':'#C30000'});
				}else{
					
					if(data.type == 'percentage'){
						response_text = 'ваша скидка '+data.value+'%';
					}else{
						response_text = 'ваша скидка '+data.value+'руб.';
					}
					
					$('#sneaky_form .response').html(response_text).css({'color':'#32CD32'});
					
				}
			});
			
		});
	
		$('.ShAA_catalogItem_new').bind('mouseenter', function() {
			id = $(this).eq(0).attr('id');
			$('#img_' + id).removeClass("imgCatalog_new").addClass("imgCatalogHover_new");
			$('#img_' + id + ' img').attr('src', $('#img_' + id + ' img').attr('src_over'));
			$('#title_' + id + ' a').css({borderBottom: "2px solid #777"});
			return false;
		}).bind('mouseleave', function() {
			id = $(this).eq(0).attr('id');
			$('#img_' + id).removeClass("imgCatalogHover_new").addClass("imgCatalog_new");
			$('#img_' + id + ' img').attr('src', $('#img_' + id + ' img').attr('src_out'));
			$('#title_' + id + ' a').css({borderBottom: "none"});
			return false;
		});
{/literal}
		{if $show_wl}
			$('#product_wl').click();
		{/if}
		{if $show_z}
			$('#product_z').click();
		{/if}
{literal}
	});
	
	send_order = 0;
	$(document).on('click', '#submit_target', function(e) {
		if(!send_order){
			e.preventDefault();
			$('#sneaky_form').submit();
			send_order = 1;
		}
		else {
			e.preventDefault();
		}
	});
	
</script>
<link rel="stylesheet" href="/sizes/css/style_h.css" type="text/css" />
{/literal}

	<div class="profile">
		{if $smarty.session.user}
			<div class="avatar">
				{if $big_avatar}
					<!--
						<a href="/cart/personal_data/" rel="facebox" target="_blank" id="edit_link" class="notUnderline" onclick="$('.sett1').hide();$('.sett2').addClass('tab-current');">
							<img src="{$smarty.session.user->photo}">
						</a>
					-->
					<img src="{$big_avatar}">
					<div class="avatar_change">
						<a href="/cart/avatar_change/" id="vk_login_link">Изменить аватар</a>
					</div>
				{else}
					<img src="/images/empty_photo.png" width="200px">
					<div class="avatar_change">
						<a href="/cart/avatar_change/" id="vk_login_link">Изменить аватар</a>
					</div>
				{/if}
			</div>
			<div class="profinfo">
				<span class="Htitle2">{$smarty.session.user->name}</span><br />
				<!--одежда: М, обувь: 42<br />
				карта: 0082 7073 6860 0627<br />-->
				{if $smarty.session.user->city}доставка: {if $x_city}{$x_city}{else}{$smarty.session.user->city}{/if}, <br />{/if}
				{if $smarty.session.user->adress}{$smarty.session.user->adress}<br />{/if}
				{if $smarty.session.user->phone_number}{$smarty.session.user->phone_number}<br />{/if}
				{if $smarty.session.user->email}{$smarty.session.user->email}<br />{/if}
				{if $smarty.session.user->card_number}Номер дисконтной карты:<br />{$smarty.session.user->card_number}<br />{/if}
				{if $smarty.session.user->purchase_sum > 0}сумма покупок на {$smarty.session.user->purchase_sum|string_format:"%.0f"} рублей<br />{/if}
				{if $smarty.session.group->discount}бонус от {$smarty.session.group->discount|string_format:"%.0f"}%<br />{/if}
				{if $n_deposit}Сумма депозита {$n_deposit} рублей<br />{/if}
				<br /><br /><a href="/cart/personal_data/" rel="facebox" target="_blank" id="edit_link" onclick="{literal}rG('EDIT_FROM_CART');{/literal}">Редактировать</a><br /><br />
				<a href="/logout/" class="vk_button_logout" onclick="{literal}rG('PRESS_EXIT');{/literal}">Выйти</a>
			</div>
		{else}
			<div class="avatar">
				<a href="/cart/vk_auth/" id="vk_login_link" class="notUnderline" title="Войдите на сайт используя свой аккаунт в популярных соцсетях и получите скидку">
					<img src="/images/empty_photo.png" width="200px">
				</a>
			</div>
			<div class="profinfo">
				<span class="Htitle2">Незнакомец</span><br />
				<span>Вы совершаете покупки как неизвестный, <a href="/cart/self_register/" class="cart_login_link" id="vk_login_link" onclick="{literal}rG('LOGIN_FROM_CART');return false;{/literal}" 
					title="Зарегистрируйтесь">Получите персональную карту "Лакшери Стор"<!-- и совершайте покупки с 10-ти% скидкой-->.</a></span><br />
			</div>
		{/if}
	</div>
	<div class="cash_field">
		<div class="tab tabact" onclick="$('.cash').hide();$('#c1').show(); ">
			<img src="/sizes/images/cart_mini.png" align="top">
			Корзина{if $cart_products_num}&nbsp;({$cart_products_num}){/if}
		</div>
		{if $smarty.session.user->user_id}
			<div class="tab" id="product_wl" onclick="$('.cash').hide();$('#c2').show();">
				Отложено{if $wl_products_num}&nbsp;({$wl_products_num}){/if}
			</div>
			<div class="tab" id="product_z" onclick="$('.cash').hide();$('#c3').show();">
				Заказы 
			</div>
			<div class="tab" id="product_z" onclick="$('.cash').hide();$('#c4').show();">
				Гардероб 
			</div>
		{/if}
		<div class="cash" id="c1">
			<div class="cash_in">
				{if $products}
					{foreach from=$products item=product}
					
						<div id="{$product->product_id}" class="ShAA_catalogItem_new category_{$product->category_id} brand_{$product->brand_id} week_{$product->week} sex_{$product->sex}">
							<div id="img_{$product->product_id}" class="imgCatalog_new">
								<img alt="{$product->model}" title="{$product->model}" src="/reimg/files/products/184x/{$product->large_image}" src_out="/reimg/files/products/184x/{$product->large_image}" src_over="/reimg/files/products/184x/{$product->small_image}">
							</div>
							<div id="title_{$product->product_id}" class="titleCatalog" onclick="return false;">
								<div class="cash_menu" id="ccm_{$product->product_id}">
									<div class="cash_menu_button" onclick="window.open('/products/{$product->url}/');">
										Посмотреть
									</div>
									<!--<div class="cash_menu_button" onclick="{if $smarty.session.user->user_id}window.location.href='/cart/addtowl/{$product->product_id}';{else}alert('Пожалуйста войдите на сайт через ВКонтакте, чтобы отложить товар');{/if}"  title="Отложить товар">
										Отложить
									</div>-->
									<div id="RemovePurchase" class="cash_menu_button" data-item_id="{$product->product_id}" data-price="{$product->price}" data-is_available="{if $product->size}1{else}0{/if}" data-category="{$product->category_id}" title="Выложить из корзины">
										Выложить
									</div>
								</div>
								<a href="#" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->brand}</a>
							</div>
							<div class="ShAA_descriptionCatalog">
								<span>{$product->category}</span><br>
								{$product->price|string_format:"%.0f"} {$currency->sign|escape}<br>
								{if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}<span>размер: {$product->size}</span>{/if}
							</div>
						</div>
					{/foreach}
				{elseif $new_orders}
					{foreach from=$new_orders item=product}
						<div id="{$product->product_id}" onclick="window.location.href='/products/{$product->url}/';" class="ShAA_catalogItem_new category_{$product->category_id} brand_{$product->brand_id} week_{$product->week} sex_{$product->sex}">
							<div id="img_{$product->product_id}" class="imgCatalog_new">
								<img alt="{$product->model}" title="{$product->model}" src="/reimg/files/products/184x/{$product->large_image}" src_out="/reimg/files/products/184x/{$product->large_image}" src_over="/reimg/files/products/184x/{$product->small_image}">
							</div>
							<div id="title_{$product->product_id}" class="titleCart">
								<img class="cartIcon" src="/images/cart_buy.png"><br>получен магазином
							</div>
							<div class="ShAA_descriptionCatalog">
								<span>{$product->category}</span> <a href="/catalog/?brand={$product->brand_id}&showbrand={$product->brand_id}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->brand}</a><br>
								{if (isset($product->price) && !empty($product->price))}<span>{$product->price} рублей</span><br>{/if}
								{if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}<span>размер: {$product->size}</span>{/if}
							</div>
						</div>
					{/foreach}
				{else}
					<div style="margin: 0 0 0 24px; float: left;">
						<div style="font-size: 21px; margin: 30px 0 18px;">Тут пусто <a href="/catalog/"><div class="ShAA_toCatalog" style="float: right;"></div></a></div>
					</div>
<!--					<div class="ShAA_emptyCartLeft" style="float:right;">
						<div class="ShAA_emptyCartRight" >
						</div>
					</div>-->
				{/if}
			</div> 
			{if $products}
				<form id="sneaky_form" action="/cart/" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="submit_order" value="1">
                    <input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
					<input type="text" name="coupon_code" placeholder="Промо-код" value="{$coupon_code|escape}" /><span class="response" style="margin-left:15px;"></span><br /><br />
				</form>
				<div class="clear"></div>
				<a href="/cart/form/{$products_price}/{$products_weight}"
					{if $smarty.session.user}
						id="submit_target"
					{else}
					 	rel="facebox"
					{/if}
					target="_blank">
					<div class="ShAA_orderButton" style="margin-right: 30px;"></div>
				</a>
				<a href="/catalog/" title="Перейти в каталог"><div style="margin: 0; float: left;" class="ShAA_toCatalogMini"></div></a>
			{/if}
			
			{if !$products}
				<div style="clear:both;"></div><br />
				<div id="recently_viewed_recomendations" style="display:none;">
					<div style="font-weight: normal; margin: 26px 0;">Вы недавно смотрели</div>
					<div class="products"></div>
				</div>
				<div id="interesting_recomendations" style="display:none;">
					<div style="font-weight: normal; margin: 26px 0;">Возможно, вам это понравится</div>
					<div class="products"></div>
				</div>
			{/if}
			
		</div>
		<!-- вторая вкладка -->
		<div class="cash invis" id="c2">
			<div class="cash_in">
				{if $products_wl}
					{foreach from=$products_wl item=product}
						<div id="{$product->product_id}" class="ShAA_catalogItem_new category_{$product->category_id} brand_{$product->brand_id} week_{$product->week} sex_{$product->sex}">
							<div id="img_{$product->product_id}" class="imgCatalog_new">
								<img alt="{$product->model}" title="{$product->model}" src="/reimg/files/products/184x/{$product->large_image}" src_out="/reimg/files/products/184x/{$product->large_image}" src_over="/reimg/files/products/184x/{$product->small_image}">
							</div>
							<div id="title_{$product->product_id}" class="titleCatalog" onclick="return false;">
								<div class="cash_menu" id="ccm_{$product->product_id}">
									<div class="cash_menu_button" onclick="window.open('/products/{$product->url}/');">
										Посмотреть
									</div>
									<div class="cash_menu_button" onclick="window.location='/cart/movefromwl/{$product->product_id}';">
										В корзину
									</div>
									<div class="cash_menu_button" onclick="window.location='/cart/deletewl/{$product->product_id}';">
										Выложить
									</div>
								</div>
								<a href="#" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->brand}</a>
							</div>
							<div class="ShAA_descriptionCatalog">
								{if $product->can_buy_from_site}
									{if $product->prop_val == 'Распродано'}
										<span style="color: #999;">{$product->price|string_format:"%.0f"} {$currency->sign|escape}</span>
									{elseif $product->old_price != 0 && $product->old_price>$product->price ||  $product->prop_val == 'Sale'}
										<span style="color: #C30000;">{if ($product->price/$product->old_price) < 0.5}последняя цена {/if}<b>{$product->price|string_format:"%.0f"}</b> {$currency->sign|escape}</span>
										<span>вместо {$product->old_price|string_format:"%.0f"} {$currency->sign|escape} </span><br/>
									{elseif $product->prop_val == 'Заказ'}
										{if $product->discount_price}
											<span>стоимостью {$product->discount_price|string_format:"%.0f"} {$currency->sign|escape}</span><br/>
										{else}
											{$product->price|string_format:"%.0f"} {$currency->sign|escape}<br/>
										{/if}
									{/if}
									{if $product->show_price && $product->price >= $product->old_price}
										{if $product->discount_price}
											<span>цена {$product->discount_price|string_format:"%.0f"}</b> {$currency->sign|escape} </span><br/>
										{else}
											{$product->price|string_format:"%.0f"} {$currency->sign|escape}<br/>
										{/if}
									{/if}
								{/if}<br>
								<span>{$product->category}</span><br>
								{if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}<span>размер: {$product->size}</span>{/if}
							</div>
							{if (($product->old_price != 0) && ($product->old_price > $product->price) && (($product->old_price-$product->price)/$product->old_price > 0.1)) }
								{if $product->no_sale }
									<div></div>
								{elseif 'swd'|array_key_exists:$promos && in_array($product->brand_id, explode(",", $promos.swd->brands)) }
									<div class="ShAA_swdIcon">скидка выходного дня</div>
								{elseif $product->golden_sale }
									<div class="ShAA_goldenPriceIcon">выгодное предложение</div>
								{else}
									<div class="ShAA_saleIcon">скидка</div>
								{/if}
							{elseif ( $product->season == "14/2" || $product->season == "15/1" )}
								<div class="ShAA_newSeasonIcon">новый сезон</div>
							{/if}
						</div>
					{/foreach}
				{else}
					<div class="ShAA_emptyCartLeft" style="float:left;">
						<div class="ShAA_emptyCartRight" >
						</div>
						<div style="margin: 0 0 0 24px; float: left;">
							<div style="font-size: 11px; margin: 30px 0 18px;">У вас еще ничего не отложено</div>
							<a href="/catalog/"><div class="ShAA_toCatalog" style="margin: 0;"></div></a>
						</div>
					</div>
					<div id="recently_viewed_recomendations2" style="display:none;">
						<div style="font-weight: normal; margin: 26px 0;">Вы недавно смотрели</div>
						<div class="products"></div>
					</div>
					{literal}<script>
					jQuery(document).ready(function() {
						//get_recomendations('#recently_viewed_recomendations2', 'recently_viewed', undefined, {limit:3});
					});
					</script>{/literal}
				{/if}
			</div>
		</div>
		<div class="cash invis" id="c3">
			{if $products_g}
				<div class="cash_in">
					{foreach from=$products_g item=product}
						<div id="{$product->product_id}" onclick="window.location.href='/products/{$product->url}/';" class="ShAA_catalogItem_new category_{$product->category_id} brand_{$product->brand_id} week_{$product->week} sex_{$product->sex}">
							<div id="img_{$product->product_id}" class="imgCatalog_new">
								<img alt="{$product->model}" title="{$product->model}" src="/reimg/files/products/184x/{$product->large_image}" src_out="/reimg/files/products/184x/{$product->large_image}" src_over="/reimg/files/products/184x/{$product->small_image}">
							</div>
							<div id="title_{$product->product_id}" class="titleCart">
								Заказ №{$product->order_id}
								{if $product->order_status==0}
									<img class="cartIcon" src="/images/cart_buy.png"><br>получен магазином{/if}
								{if $product->order_status==1}<img class="cartIcon" src="/images/cart_buy.png"><br>обрабатывается{/if}
								{if $product->order_status==6}
									{if $product->product_status == 0}<img class="cartIcon" src="/images/cart_truck.png"><br>доставляется{/if}
									{if $product->product_status == 5}<img class="cartIcon" src="/images/cart_bag.png"><br>доставлен{/if}
								{/if}
								
							</div>
							<div class="ShAA_descriptionCatalog">
								<span>{$product->category}</span> <a href="/catalog/?brand={$product->brand_id}&showbrand={$product->brand_id}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->brand}</a><br>
								{if (isset($product->price) && !empty($product->price))}<span>{$product->price} рублей</span><br>{/if}
								{if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}<span>размер: {$product->size}</span>{/if}
							</div>
						</div>
					{/foreach}
				</div>
			{else}
				<div class="nope">
					<span class="notxt">Ваш гардероб пуст: <br>
					- тут будут доступны все совершенные вами покупки</span>
					<img src="/sizes/images/garpic.png">
				</div>
			{/if}			
		</div>
		<div class="cash invis" id="c4">
			{if $products_off}
				<div class="cash_in">
					{foreach from=$products_off item=product}
						<div id="{$product->product_id}" onclick="window.location.href='/products/{$product->url}/';" class="ShAA_catalogItem_new category_{$product->category_id} brand_{$product->brand_id} week_{$product->week} sex_{$product->sex}">
							<div id="img_{$product->product_id}" class="imgCatalog_new">
								<img alt="{$product->model}" title="{$product->model}" src="/reimg/files/products/184x/{$product->large_image}" src_out="/reimg/files/products/184x/{$product->large_image}" src_over="/reimg/files/products/184x/{$product->small_image}">
							</div>
							<div id="title_{$product->product_id}" class="titleCart">
								<a href="/catalog/?brand={$product->brand_id}&showbrand={$product->brand_id}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->brand}</a>
							</div>
							<div class="ShAA_descriptionCatalog">
								<span>{$product->category}</span> <br>
								{if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}<span>размер: {$product->size}</span>{/if}
							</div>
						</div>
					{/foreach}
				</div>
			{else}
				<div class="nope">
					<span class="notxt">Ваш гардероб пуст: <br>
					- тут будут доступны все совершенные вами покупки</span>
					<img src="/sizes/images/garpic.png">
				</div>
			{/if}			
		</div>
		
	</div>