<div class="product_page_text title">
	{$group_name|escape} <a href="/brands/{$brand->url}/" title="{$brand->name}" alt="{$brand->name}" class="normal_text_underline">{$brand->name}</a>
	{if $product->properties}
		{foreach from=$product->properties item=property key=key}
			{if $property->name == 'Страна происхождения'} made in {$property->value|escape} {/if}
		{/foreach}
	{/if}
</div>
{if $product->old_price != 0 && $product->old_price>$product->price ||  $product->prop_val == 'Sale'}
	<div class="product_page_text title" style="margin-top:7px;"><span class="bold">{$product->old_price|string_format:"%.0f"}</span> {$currency->sign}</div>
	<div class="product_page_text title" style="margin-top:7px;color: #C30000;"><span class="bold">Со скидкой {$product->price|string_format:"%.0f"}</span> {$currency->sign}</div>
{else}
	<div class="product_page_text title" style="margin-top:7px;"><span class="bold">{$product->price|string_format:"%.0f"}</span> {$currency->sign}</div>
{/if}
<div class="item_big_image" style="height: 815px;">
	<script type="text/javascript" src="/design/application/js/owl.carousel.min.js"></script>
	<link rel="stylesheet" href="/design/application/css/owl.carousel.css">
	<link rel="stylesheet" href="/design/application/css/owl.theme.default.css">
	{literal}
		<script>
			$(document).ready(function(){
				$("#slideshow").owlCarousel({
					loop: true,
					items: 1,
					nav:true,
					dots:true,
					singleItem: true
				});
				$("a#buy").fancybox({
					'padding'			: 0,
					'titlePosition'		: 'inside',
					'autoScale'			: 'true',
					'opacity'           : 'false',
					'scrolling'			: 'no',
					'overlayColor'      : '#000',
					'topRatio'			: 0,		//добавленная опция модифиацией скрипта, число от 0 до 1
													//0 - окно наверху, 1 - окно внизу (по дефолту 0.5)
					'leftRatio'			: 0.5		//тоже самое, но по горизонтали (по дефолту 0.5, тут просто для примера)
				});
				$("a#add_to_wishlist").fancybox({
					'padding'			: 0,
					'titlePosition'		: 'inside',
					'autoScale'			: 'true',
					'opacity'           : 'false',
					'scrolling'			: 'no',
					'overlayColor'      : '#000',
					'topRatio'			: 0
				});
			});
		</script>
	{/literal}
	<div id="slideshow">
		<div class="image_div" style="width: 640px;">
			<table style="width: 640px;">
				<tr>
					<td>
						<img src="/reimg/files/products/560x/{$product->large_image}" title="{$product->img_desc}" alt="{$product->img_desc}">
					</td>
				</tr>
			</table>
		</div>
		<div class="image_div" style="width: 640px;">
			<table style="width: 640px;">
				<tr>
					<td>
						<img src="/reimg/files/products/560x/{$product->small_image}" title="{$product->img_desc}" alt="{$product->img_desc}">
					</td>
				</tr>
			</table>
		</div>
		{if $product->fotos}
			{foreach from=$product->fotos item=foto}
				<div class="image_div" style="width: 640px;">
					<table style="width: 640px;">
						<tr>
							<td>
								<img src="/reimg/files/products/560x/{$foto->filename}" title="{$product->img_desc}" alt="{$product->img_desc}">
							</td>
						</tr>
					</table>
				</div>
			{/foreach}
		{/if}
	</div>
</div>
{literal}
<script type="text/javascript"> 
	$(document).ready(function() {
		var top1 = $("#black_field").offset().top;
		$('#black_field').hide();
		jQuery(window).bind('scrollstart', function()
		{
	//		$('#black_field').hide();
		});
		jQuery(window).on('touchmove', function()
		{
	//		$('#black_field').hide();
		});
		jQuery(window).bind('scrollend', function()
		{
			var offset = $(this).scrollTop() + $(window).height();
			
			if( offset > top1) {
				$("#black_field").css({"position": "fixed",
									"bottom": "0",
									"left": "0",
									"margin": "0"
									});
				$('#black_field').slideDown(200);
			}
		/*	if( offset <= top1) {
				$("#black_field").css({"position": "relative",
										"margin": "15px 0"
				});
				$('#black_field').slideDown(200);
				$('#black_field').hide();
			}*/
		});
	});
</script> 
{/literal}
<div class="product_page_text title" style="margin-top: 60px;">
	{if !($no_size)}
		<br />
		Размеры: 
		{foreach from=$product->size_text item=size_t }
			{$size_t} 
		{/foreach}
	{/if}
</div>

<div class="product_page_text title">
	Подробнее о вещи
</div>
<div class="black_field" id="black_field" style="height: 148px;">
	<div class="black_field_in">
		<a href="/index.php?module=Cart&one_click&clear_template&oneclick_product={$product->product_id}" id="buy" alt="Купить">
			<div class="white_button" style="margin: 0 150px;">
				<table>
					<tr>
						<td>
							Купить
						</td>
					</tr>
				</table>
			</div>
		</a>
		<!--<a href="/index.php?module=Cart&add_to_wishlist&product_id={$product->product_id}" id="add_to_wishlist" onclick="{literal}if (jQuery('#userCurrentSize').eq(0).text() == '0') { alert('Пожалуйста, выберите подходящий размер'); return false;} this.href += ('&size='+jQuery('#userCurrentSize').eq(0).text()); document.cookie='from='+location.href+';path=/';{/literal}" alt="Ждать скидку">
			<div class="white_button">
				<table>
					<tr>
						<td>
							Ждать<br />скидок
						</td>
					</tr>
				</table>
			</div>
		</a>-->
	</div>
</div>
<div class="app_divider"></div>
<div class="product_page_text text">
	{if $product->description}
		{$product->description}
	{else}
		{$product_brand_text}
	{/if}
</div>
<div class="product_page_text title">
	Детали
</div>
<div class="app_divider"></div>
<div class="product_page_text text">
	{foreach from=$product->properties item=property key=key}
		{if preg_match('/Материал/',$property->name)}Cостав: {$property->value}{/if}
	{/foreach}
	<br />
	Цвет: {$color_name->name}<br />
	Коллекция сезона: {$product->season}<br />
	Артикул: {$product->sku}<br />
</div>
<div class="product_page_text title">
	Доставка и оплата
</div>
<div class="app_divider"></div>
<div class="left_text text" style="margin: 0 0 30px 13px;">
	Доставка бесплатно{if $product->price < 10000} при заказе от 10000 рублей{/if}! Курьером до двери. Оплата наличными курьеру по факту получения заказа или банковской картой через RBK money.
</div>
{if $product->related_products}
	<div class="product_page_text text">
		Еще вещи от <a href="/brands/{$brand->url}/" title="{$brand->name}" alt="{$brand->name}" class="item_link">{$brand->name}</a>
	</div>
	<div class="app_divider"></div>
	<div class="products" style="margin: -20px 13px 0;">
		{include file='items_block.tpl' products=$product->related_products}
	</div>
{/if}