<a name="top"></a>
<div class="centered_text normal_text">
	{$group_name|escape} <a href="/brands/{$brand->url}/" title="{$brand->name}" alt="{$brand->name}" class="normal_text_underline">{$brand->name}</a>
	{if $product->properties}
		{foreach from=$product->properties item=property key=key}
			{if $property->name == 'Страна происхождения'} made in {$property->value|escape} {/if}
		{/foreach}
	{/if}
</div>
<div class="centered_text item_text2">
	{if $product->old_price != 0 && $product->old_price>$product->price ||  $product->prop_val == 'Sale'}
		{$product->old_price|string_format:"%.0f"} {$currency->sign}<br>
		<span style="margin-top:7px;color: #C30000;">Со скидкой {$product->price|string_format:"%.0f"} {$currency->sign}</span><br>
	{else}
		{$product->price|string_format:"%.0f"} {$currency->sign}<br>
	{/if}
	{if $product->size_text && $product->size_text[0] != 'Р-р не задан' && $product->size_text && $product->size_text[0] != 'р-р не зад'}
		Доступные размеры:
		{foreach from=$product->size_text item=size_t}
			{$size_t}
		{/foreach}
	{/if}
</div>
<div class="item_big_image">
	<script type="text/javascript" src="/design/mobile/js/owl.carousel.min.js"></script>
	<link rel="stylesheet" href="/design/mobile/css/owl.carousel.min.css">
	<link rel="stylesheet" href="/design/mobile/css/owl.theme.css">
	{literal}
		<script>
			$(document).ready(function(){
                $('#referrer').val(ref);
				location.href = "#top";
				$("#slideshow").owlCarousel({
					loop: true,
					items: 1,
					singleItem: true
				});

				/*$(document).on('click', 'a.add_to_cart', function(event) {
					event.preventDefault();
					$size = $('#sizes').val();
					$.get('/index.php?module=Cart&product_id={/literal}{$product->product_id}{literal}&size='+$size, function(data) {
						alert('Товар добавлен в корзину');
					});
				});*/
			});
		</script>
	{/literal}
	<div class="item_arrows">
		<div class="item_arr_left"></div>
		<!--<div class="item_arr_center"></div>-->
		<div class="item_arr_right"></div>
	</div>
	<div id="slideshow">
		<div class="image_div">
			<table>
				<tr>
					<td>
						<img src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$product->large_image}" title="{$product->img_desc}" alt="{$product->img_desc}">
					</td>
				</tr>
			</table>
		</div>
		<div class="image_div">
			<table>
				<tr>
					<td>
						<img src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$product->small_image}" title="{$product->img_desc}" alt="{$product->img_desc}">
					</td>
				</tr>
			</table>
		</div>
		{if $product->fotos}
			{foreach from=$product->fotos item=foto}
				<div class="image_div">
					<table>
						<tr>
							<td>
								<img src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$foto->filename}" title="{$product->img_desc}" alt="{$product->img_desc}">
							</td>
						</tr>
					</table>
				</div>
			{/foreach}
		{/if}
	</div>
</div>
<div class="centered_text item_text2 size">
	{if $product->discount_price}<br>
		<span style="color: #C30000;">с вашей скидкой {$product->discount_value|string_format:"%.0f"}% {$product->discount_price|string_format:"%.0f"} {$currency->sign}</span>
	{/if} 
</div>

<div class="button_wrap" style="margin: 40px 0 40px 60px;">
	<a class="add_to_cart" {if $smarty.session.user->phone_number}id="call_me"{/if} style="margin-right:40px;" 
		href="{if $smarty.session.user->phone_number}#{else}/index.php?module=Cart&one_click&oneclick_product={$product->product_id}{/if}"
		onclick="{literal}rG('BUY_1_CLICK_MOBILE');{/literal}" title="Купить" alt="Купить">
		<div class="button button240px button_text" style="margin-right:40px;">
			{if $smarty.session.user}
				<form autocomplete="off" action='/index.php?module=Feedback&one_click' method="post" name="one_click_form" id="one_click" enctype="multipart/form-data">
					<input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
					<input type="hidden" name="name" value="{$smarty.session.user->name}"/>
					<input type="hidden" name="phone_number" value="{$smarty.session.user->phone_number}"/>
					<input type="hidden" name="product_id" value="{$product->product_id}"/>
					<input type="hidden" name="from_page" value="one_click_mobile"/>
				</form>
			{/if}
			<table>
				<tr>
					<td>
						Купить
					</td>
				</tr>
			</table>
		</div>
	</a>
	<a href="/index.php?module=Cart&call_me&oneclick_product={$product->product_id}" title="Перезвоните мне" onclick="{literal}rG('REQUEST_CALL_MOBILE');{/literal}" alt="Перезвоните мне">
		<div class="button button240px button_text">
			<table>
				<tr>
					<td>
						Перезвоните мне
					</td>
				</tr>
			</table>
		</div>
	</a>
</div>
<div class="centered_text alert_text">
	Подробнее о вещи
</div>
<div class="left_text descr_text no_br" style="margin: 30px 0 30px 40px;">
	{if $product->description}
		{$product->description}
	{else}
		{$product_brand_text}
	{/if}
</div>
<div class="centered_text alert_text">
	Детали
</div>
<div class="left_text descr_text" style="margin: 30px 0 30px 40px;">
	{foreach from=$product->properties item=property key=key}
		{if preg_match('/Материал/',$property->name)}Cостав: {$property->value}{/if}
	{/foreach}
	{if !($no_size)}
		<br />
		В наличии размеры: 
		{foreach from=$product->size_text item=size_t }
			{$size_t} 
		{/foreach}
	{/if}
	<br />
	Цвет: {$color_name->name}<br />
	Коллекция сезона: {$product->season}<br />
</div>
<div class="centered_text alert_text">
	Доставка и оплата
</div>
<div class="left_text descr_text" style="margin: 30px 0 30px 40px;">
	Доставка бесплатно{if $product->price < 10000} при заказе от 10000 рублей{/if}! Курьером до двери. Оплата наличными курьеру по факту получения заказа или банковской картой через RBK money.
</div>

<div class="button_wrap" style="margin: 40px 0 40px 60px;">
	<a class="add_to_cart" {if $smarty.session.user->phone_number}id="call_me"{/if} style="margin-right:40px;" 
		href="{if $smarty.session.user->phone_number}#{else}/index.php?module=Cart&one_click&oneclick_product={$product->product_id}{/if}"
		onclick="{literal}rG('BUY_1_CLICK_MOBILE');{/literal}" title="Купить" alt="Купить">
		<div class="button button240px button_text" style="margin-right:40px;">
			{if $smarty.session.user}
				<form autocomplete="off" action='/index.php?module=Feedback&one_click' method="post" name="one_click_form" id="one_click" enctype="multipart/form-data">
					<input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
					<input type="hidden" name="name" value="{$smarty.session.user->name}"/>
					<input type="hidden" name="phone_number" value="{$smarty.session.user->phone_number}"/>
					<input type="hidden" name="product_id" value="{$product->product_id}"/>
					<input type="hidden" name="from_page" value="one_click_mobile"/>
				</form>
			{/if}
			<table>
				<tr>
					<td>
						Купить
					</td>
				</tr>
			</table>
		</div>
	</a>
	<a href="/index.php?module=Cart&call_me&oneclick_product={$product->product_id}" title="Перезвоните мне" onclick="{literal}rG('REQUEST_CALL_MOBILE');{/literal}" alt="Перезвоните мне">
		<div class="button button240px button_text">
			<table>
				<tr>
					<td>
						Перезвоните мне
					</td>
				</tr>
			</table>
		</div>
	</a>
</div>
{if $product->related_products}
	<div class="centered_text item_txt">
		Еще вещи от <a href="/brands/{$brand->url}/" title="{$brand->name}" alt="{$brand->name}" class="item_link">{$brand->name}</a>
	</div>
	<div class="item_wrap" style="margin: -20px 0 0;">
		{include file='items_block.tpl' products=$product->related_products}
	</div>
{/if}
{assign var=hidden_brands value=","|explode:$user->show_hidden_brands} 
{if $smarty.session.user->group_id < 2 && $config->enviroment == 'live' && !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}
<script>
//Criteo dataLayer
    {literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}{literal}', 
                'PageType': 'ProductPage',
                'ProductID' : {/literal}'{$product->barcode}'{literal}
            })
        }
    });
    {/literal}
</script>
<script>
//More dataLayer
    {literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'ProductPrice' : {/literal}'{$product->price}'{literal},
                'MT_PageType': 'product'
            })
        }
    });
    {/literal}
</script>
{/if}