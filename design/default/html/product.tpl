{if ($oc_ordered || $so_ordered) && $smarty.session.user->group_id < 2 && $config->enviroment == 'live'}
{literal}
    <script>
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'transactionId': '{/literal}{if $oc_ordered}c{$oc_ordered->id}{elseif $so_ordered}s{$so_ordered->so_id}{/if}{literal}', // Required
                'transactionAffiliation': 'Luxury Store',
                'transactionTax': '{/literal}{if $new_user_order}0{else}1{/if}{literal}',
                'transactionTotal': {/literal}{$ordered_product->price}{literal}, // Required
                'transactionShipping': 'undefined',
                'transactionProducts': [
                    {
                        'sku': '{/literal}{$ordered_product->sku}{literal}', // Required
                        'name': '{/literal}{$ordered_product->model}{literal}', // Required
                        'category': '{/literal}{$ordered_product->brand_name}{literal}',
                        'price': {/literal}{$ordered_product->price}{literal}, // Required
                        'quantity': 1 // Required
                    }
                ]
            });
        }
        {/literal}{if $ordered_product->cat_enabled != 0}{literal}
        //Criteo dataLayer
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            var product_list = [];
            product_list.push(
                {
                    'id': '{/literal}{$ordered_product->barcode}{literal}',
                    'price': {/literal}{$ordered_product->price}{literal},
                    'quantity': 1
                }
            );
            dataLayer.push({
                'CriteoEmail': {/literal}'{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}'{literal},
                'PageType': 'TransactionPage',
                'OrderProducts' : product_list,
                'CriteoTransactionId': '{/literal}{if $oc_ordered}c{$oc_ordered->id}{elseif $so_ordered}s{$so_ordered->so_id}{/if}{literal}'
            })
        }
        {/literal}{/if}{literal}
    });
    </script>
{/literal}
{/if}
<script type="text/javascript" src="/jscript/jcarousel.js"></script>
<link media="all" href="/jscript/jcarousel.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/jscript/cloudzoom.js"></script>
<link media="all" href="/jscript/cloudzoom.css" rel="stylesheet" type="text/css" />
	
<script type="text/javascript" src="/jscript/jquery.shorten.1.0.js"></script>
	
<div class="content notPadding" style="width: 100%;">
	<div class="centerContent">
	<div class="ShAA_goldBanner noLinkUnderline">
	</div>
{literal}
<style>
	.cloudzoom-zoom-big {
		border: 1px solid #ccc;
		overflow:hidden;
		width: 436px !important;
		height: 456px !important;
		left: 845px !important;
	}
	.cloudzoom-lens {
		border: 1px solid #888;
		margin:-4px;	/* Set this to minus the border thickness. */
		background-color: #fff;	
		cursor: move;
	}
	.cloudzoom-caption {
		padding: 0;
		display: none !important;
	}
	.cloudzoom-gallery {
		cursor: pointer;
	}
	
</style>
{/literal}

<script type="text/javascript" src="/jscript/timeto/jquery.time-to.js"></script>
<link rel="stylesheet" type="text/css" href="/jscript/timeto/timeto.css" />

<script type="text/javascript"> 
{literal}
	jQuery(document).ready(function() {
		jQuery('#mycarousel').jcarousel();
		jQuery('#mycarousel li').first().addClass("active");
		jQuery('#mycarousel').css( "width", "550px" );
		jQuery('#mycarousel li').mouseup(function() {
			jQuery('#mycarousel li').removeClass("active");
			jQuery(this).addClass("active");
		});
		jQuery('#mycarousel li').hover(function() {
			jQuery(this).find('.shadow').css("display", "none");},
			function() {
			jQuery(this).find('.shadow').css("display", "block");}
		);
	});
{/literal}


{literal}
var $j = jQuery.noConflict();
	
$j(document).ready(function() {
	$j('ul.tabs li').css('cursor', 'pointer');
	location.href = "#top";
	var top = 101;
	$j(window).scroll(function () {
		if($j(this).scrollTop() > top) {
			$j(".mainMenu").css({"position": "fixed",
								"top": "0"
								});
		}
		if($j(this).scrollTop() <= top) {
			$j(".mainMenu").css("position", "relative");
		}
	});
	jQuery("#phone_number").blur(function() {
		var phone_number = jQuery(this).val();
		alert(phone_number);
	});
	jQuery("#name").blur(function() {
		var name = jQuery(this).val();
		alert(phone_number);
	});
	$j('ul.tabs.tabs1 li').click(function(){
		var thisClass = this.className.slice(0,2);
		$j('div.t1').hide();
		$j('div.t2').hide();
		$j('div.' + thisClass).show();
		$j('ul.tabs.tabs1 li').removeClass('tab-current');
		$j(this).addClass('tab-current');
	});
	
	$j('.ShAA_sizeNotSelect').click(function(){
		$j('.ShAA_sizeNotSelect').removeClass('userSizeSelect');
		$j(this).addClass('userSizeSelect');
		var thisText = $j(this).text();
		$j('#userCurrentSize').show();
		$j('#userCurrentSize').html(thisText);
	});
	
	$j("#zoomImg").click(function () {
			$j(".Product_centerRightContent").hide();
			//$j(".ShAA_goldBanner").hide();
			imgsrc = $j(this).attr('src');
			imgsrcarray = imgsrc.split('/');
			lastItem = imgsrcarray[imgsrcarray.length-1];
			$j(".ShAA_zoomImg img").attr("src", "/files/products/" + lastItem);
			$j(".ShAA_zoomImg").show();
	});
	
	$j(".ShAA_zoomImg").click(function () {
			$j(".Product_centerRightContent").show();
			//$j(".ShAA_goldBanner").show();
			$j(".ShAA_zoomImg").hide()
	});
	
/*	
	$j(".redactText").shorten({
		"showChars" : 330,
		"moreText"  : "Подробнее",
		"lessText"  : "<br>Скрыть текст",
	});
*/
});
{/literal}
</script>

{literal}
<script type="text/javascript">
	CloudZoom.quickStart();
</script>
{/literal}

				<div class="ShAA_zoomImg" style="display: none;">
					<img src=""/>
				</div>
	        
	        	<div class="Product_centerRightContent" itemscope="" itemtype="http://schema.org/Product">
	        		<div class="Product_leftBlockForProduct">
	        			<div class="Product_productImgBlock">
		        			<div class="Product_productMiddleImg">
								<img class="cloudzoom" id="zoomImg" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$product->large_image}" data-zoom-img = "{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/files/products/{$product->large_image}" 
								data-cloudzoom = "zoomImage: '{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/files/products/{$product->large_image}', zoomOffsetX: 90, zoomOffsetY: 0, zoomClass: 'cloudzoom-zoom-big', lensClass: 'cloudzoom-lens',disableZoom: true" itemprop="image" />
		        			</div>

		        			{if in_array($product->product_id, $cart_products)}
		        				<img class="product_cart_icon" src="/images/cart_buy.png">
	        				{/if}
							

							{if $product->properties}
								{foreach from=$product->properties item=property key=key}
									{if $property->name == 'Предложение'}
										{if $property->value == 'Sale' || ($product->old_price > $product->price && $product->old_price != 0)}
											<div class="ShAA_sale" style="margin-left: 200px;"></div>
										{elseif $property->value == 'Распродано'}
											<div class="ShAA_outOfStock" style="margin-left: 200px;"></div>
										{elseif $property->value == 'Заказ'}
											<div class="ShAA_order" style="margin-left: 200px;"></div>
										{/if}
									{/if}
								{/foreach}
							{/if}
							{if $show_price == 0 && $product->old_price > $product->price}
								<div class="ShAA_sale" style="margin-left: 230px;z-index:10000;opacity:0.5;filter:alpha(opacity=50);"></div>
							{/if}
							<div class="Product_centerLeftContent" style="margin: 0px; width: 550px;">
								<div id="wrap"> 
									{* Сертификаты *}
									{if $product->category_id != 8233}
										<ul id="mycarousel" class="jcarousel jcarousel-skin-tango" style="width: 550px;" {if $product->fotos}{else}style="padding: 20px 10px;"{/if} >
					
										{if $product->large_image }
											<li>
												<div class="shadow"></div>
												<img class="cloudzoom-gallery" alt="{$product->img_desc}" title="{$product->img_desc}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}"
												 data-cloudzoom = "
												 useZoom: '#zoomImg',
												 image:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$product->large_image}',
												 zoomImage:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/files/products/{$product->large_image}'
												 ">
											</li>
										{/if}
										{if $big_size && $product->bsize_small_image}
											<li>
												<div class="shadow"></div>
												<img class="cloudzoom-gallery" alt="{$product->img_desc}" title="{$product->img_desc}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->bsize_small_image}"
												 data-cloudzoom = "
												 useZoom: '#zoomImg',
												 image:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$product->bsize_small_image}',
												 zoomImage:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/files/products/{$product->bsize_small_image}'
												 ">
											</li>
										{elseif $product->small_image}
											<li>
												<div class="shadow"></div>
												<img class="cloudzoom-gallery" alt="{$product->img_desc}" title="{$product->img_desc}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->small_image}"
												 data-cloudzoom = "
												 useZoom: '#zoomImg',
												 image:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$product->small_image}',
												 zoomImage:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/files/products/{$product->small_image}'
												 ">
											</li>
										{/if}
										{if $product->fotos}
											{foreach from=$product->fotos item=foto}
												<li>
													<div class="shadow"></div>
													<img class="cloudzoom-gallery" alt="{$product->img_desc}" title="{$product->img_desc}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$foto->filename}"
													 data-cloudzoom = "
													 useZoom: '#zoomImg',
													 image:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/560x/{$foto->filename}',
													 zoomImage:'{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/files/products/{$foto->filename}'
													 ">
												</li>
											{/foreach}
										{/if}
										</ul>
									{/if}
								</div>
							</div>
	        			</div>
	        		</div>
	        		<div class="Product_rightBlockForProduct" {if $product->category_id == 8233} style="padding-left:  24px;"{/if}>
	        			<div class="productInfo">
	        				<div class="titleMain">
								<a href="/brands/{$brand->url}/"><img width="212" alt="{$brand->name}" title="{$brand->name}" src="/reimg/files/brands/212x/{$brand->image}"></a>
							</div>

	        				<div class="description">
	        					<h1><span itemprop="name">{$group_name|escape}</span>
								<a class="ShAA_productDesigner" href="/brands/{$brand->url}/" rel="nofollow" itemprop="brand">{$brand->name}</a></h1>&nbsp;
								{if $product->properties}{foreach from=$product->properties item=property key=key}{if $property->name == 'Страна происхождения'} made in {$property->value|escape} {/if}{/foreach}{/if}<br>
<div  itemprop="offers" itemscope itemtype="http://schema.org/AggregateOffer">
								{if ($product->size != '<option selected="selected"></option>')}
								{foreach from=$product->properties item=property key=key}
									{if $property->name == 'Предложение'}
										{if $property->value == 'Распродано'}
											<span style="color: #999;"><span itemprop="lowPrice">{$product->price|string_format:"%.0f"}</span> {$currency->sign|escape}</span>
										{elseif $property->value == 'Sale' }
											<span class="sale_red"><span itemprop="lowPrice">{$product->price|string_format:"%.0f"}</span> {$currency->sign|escape}</span><br>
											{if $product->price >= $config->max_price_delivery}
												Доставка бесплатно
											{else}
												При покупке ещё на {$config->max_price_delivery-$product->price} {$currency->sign|escape} доставим бесплатно
											{/if}
										{else}
											{if $product->discount_price}
												стоимостью <span itemprop="highPrice">{$product->price|string_format:"%.0f"}</span> <br>
												<span class="ShAA_gold">с вашей скидкой {$product->discount_value|string_format:"%.0f"}% <span itemprop="lowPrice">{$product->discount_price|string_format:"%.0f"}</span> {$currency->sign|escape}</span><br>
												{if $product->discount_price >= $config->max_price_delivery}
													Доставка бесплатно
												{else}
													При покупке ещё на {$config->max_price_delivery-$product->discount_price} {$currency->sign|escape} доставим бесплатно
												{/if}
											{else}
												{$currency->sign|escape} <span itemprop="lowPrice">{$product->price|string_format:"%.0f"}</span><br>
												{if $product->price >= $config->max_price_delivery}
													доставка бесплатно
												{else}
													при покупке ещё на {$config->max_price_delivery-$product->price} {$currency->sign|escape} доставим бесплатно
												{/if}
											{/if}
										{/if}
									{/if}
								{/foreach}
								<span style="display: none;" itemprop="priceCurrency">RUB</span>
								{if $can_buy_from_site && $show_price == 0}
									{if $product->old_price > $product->price}
										{* Нулевая скидка *}
										{if ($podium && ($product->old_price / $product->price == 2 )) || ($brand->no_sale == 1)}
											<span>стоимость <span itemprop="lowPrice">{$product->price|string_format:"%.0f"}</span> {$currency->sign|escape}</span> <br>
											{if $can_buy_from_site}
												{if $product->price >= $config->max_price_delivery}
													доставка бесплатно
												{else}
													при покупке ещё на {$config->max_price_delivery-$product->price} {$currency->sign|escape} доставим бесплатно
												{/if}
											{/if}
										{else}
											{*  | Долго искал :)
											    |
											    |
											   \|/
											    v 	*}
											{literal}
												<script>
													jQuery(".ShAA_goldBanner").show();
												</script>
											{/literal}
											<span class="sale_red">цена со скидкой <b itemprop="lowPrice">{$product->price|string_format:"%.0f"}</b> {$currency->sign|escape}</span><br>
											<span>старая цена <span itemprop="highPrice">{$product->old_price|string_format:"%.0f"}</span> {$currency->sign|escape}</span><br>
											{if $can_buy_from_site}
												{if $product->price >= $config->max_price_delivery}
													доставка бесплатно
												{else}
													при покупке ещё на {$config->max_price_delivery-$product->price} {$currency->sign|escape} доставим бесплатно
												{/if}
											{/if}
										{/if}
									{* Сертификаты *}
									{elseif $product->category_id == 8233}
										на <b>{$product->price}</b> {$currency->sign|escape}
									{else}
										{if $brand->no_sale}
											<span>стоимость <span itemprop="lowPrice">{$product->price|string_format:"%.0f"}</span> {$currency->sign|escape}</span> <br>
											{if $can_buy_from_site}
												{if $product->price >= $config->max_price_delivery}
													доставка бесплатно
												{else}
													при покупке ещё на {$config->max_price_delivery-$product->price} {$currency->sign|escape} доставим бесплатно
												{/if}
											{/if}
										{elseif $product->discount_price }
											<span class="sale_red">стоимостью <b itemprop="lowPrice">{$product->discount_price|string_format:"%.0f"}</b> {$currency->sign|escape} с вашей скидкой {$product->discount_value|string_format:"%.0f"}%</span><br>
											<span>обычная цена <span itemprop="highPrice">{$product->price|string_format:"%.0f"}</span> {$currency->sign|escape}</span><br>
											{if $can_buy_from_site}
												{if $product->discount_price >= $config->max_price_delivery}
													доставка бесплатно
												{else}
													при покупке ещё на {$config->max_price_delivery-$product->discount_price} {$currency->sign|escape} доставим бесплатно
												{/if}
											{/if}
										{else}
											<span>цена <span itemprop="lowPrice">{$product->price|string_format:"%.0f"}</span> {$currency->sign|escape}</span> <br>
											{if $can_buy_from_site}
												{if $product->price >= $config->max_price_delivery}
													доставка бесплатно
												{else}
													при покупке ещё на {$config->max_price_delivery-$product->price} {$currency->sign|escape} доставим бесплатно
												{/if}
											{/if}
										{/if}
									{/if}
								{/if}
					{/if}
</div>
{if $smarty.session.user->purchase_sum_real > 0 && $new_season && $show_presale == 1}
{literal}
	<style>
		.productInfo .description span {
			float: none !important;
			margin: 0;
		}
		
		.timeTo div, .timeTo div.first {
			border: none;
		}
		.timeTo.timeTo-white div {
			background: none;
			color: #C30000;
			width: 8px !important;
		}
		.timeTo span {
			color: #C30000;
		}
		.timeTo ul li {
			padding-top: 1px;
		}
		.timeTo span {
			vertical-align: text-top;
		}
		.timeTo {
			font-weight: normal;
		}
	</style>
	<script>
		jQuery(document).ready(function() {
			jQuery('.ShAA_timeClassProd').timeTo({
				timeTo: new Date('May 01 2016 15:00:00'),
				displayCaptions: false,
				fontSize: 13,
				gap: 8,
				width: 8,
				displayDays: 2,
				fontFamily: '"Roboto", sans-serif'
			});
		});
	</script>
{/literal}
 <div style="margin: 5px 0 0 0;">
	<div style="clear: both;">Осталось: <span class="ShAA_timeClassProd"></span></div>
</div>
{/if}
	        				</div>
	        			</div>
						
{if ($product->size != '<option selected="selected"></option>')}						
						<div class="productInfo">
						{if ($product->size == '<option selected="selected"></option>')}--{$product->size}--{/if}

	        				<div class="addToBlock" style="margin: 0px 0 20px 0; width: 330px;">
	{if $can_buy_from_site}
	        					<a id="addToCart" title="Положить в корзину" rel="nofollow" href="/index.php?module=Cart&product_id={$product->product_id}">
		        					<div class="addToCart"></div>
	        					</a>
								{if $smarty.session.user}
									{* Сертификаты *}
									{if $product->category_id != 8233}
										<a title="Ждать скидку" href="/index.php?module=Cart&add_to_wishlist&product_id={$product->product_id}" onclick="{literal}if (jQuery('#userCurrentSize').eq(0).text() == '0') { alert('Пожалуйста, выберите подходящий размер'); return false;} this.href += ('&size='+jQuery('#userCurrentSize').eq(0).text()); document.cookie='from='+location.href+';path=/'; rG('ADD_TO_WISHLIST');{/literal}">
											<div class="addToWishList">Ждать скидку</div>
										</a>
									{/if}
									<div style="margin-top:7px;">
										<a class="ShAA_productDesigner" title="Попросить менеджера помочь с покупкой" href="/index.php?module=cart&helpform&clear_template&oneclick_product={$product->product_id}" rel="facebox" target="_blank" style="margin-left:13px;" onclick="{literal}rG('REQUEST_CALL_SITE');{/literal}">
											Помощь
										</a>
									</div>
									<div style="margin-top:25px;">
										<a title="Совершить покупку в один клик" class="ShAA_productDesigner" href="/index.php?module=cart&one_click&clear_template&oneclick_product={$product->product_id}" rel="facebox" target="_blank" id="edit_link" onclick="{literal}rG('BUY_1_CLICK_SITE');{/literal}">
											Купить в 1 клик
										</a>
									</div>
								{else}
									<div style="margin-top:7px;">
										<a title="Совершить покупку в один клик" class="ShAA_productDesigner" href="/index.php?module=cart&one_click&clear_template&oneclick_product={$product->product_id}" rel="facebox" target="_blank" id="edit_link" style="margin-left:13px;" onclick="{literal}rG('BUY_1_CLICK_SITE');{/literal}">
											Купить в 1 клик
										</a>
									</div>
								{/if}
	{else}
								<p>
									<a title="Попросить менеджера помочь с покупкой" class="ShAA_productDesigner ShAA_sizeLink" style="width: 45px;" href="/index.php?module=cart&helpform&clear_template&oneclick_product={$product->product_id}" rel="facebox" target="_blank" onclick="{literal}rG('REQUEST_CALL_SITE');{/literal}">
										Помощь
									</a>
								</p>
								<p style="width:260px;">Вы можете приобрести эту вещь в нашем <a href="{if $product->item_location_link}{$product->item_location_link}{else}http://ru.lsboutique.ru/db/shops/{/if}" style="text-decoration:underline;" target="_blank" rel="nofollow">магазине {$product->item_location_name}</a> в Нижнем Новгороде.</p>
	{/if}
	        				</div>
	{if !($no_size)}
					
	        				<div class="sizeBlock">
		{if $product->sizes_url}
								<div class="sizePages">
									<span class="sizeImg">
	        							Доступные размеры
	        						</span>
									<span id="userCurrentSize">0</span>
								</div>
		{/if}
								<div class="productInfo">
									<ul class="ShAA_sizeUl">
										{foreach from=$product->tmp_size_text item=size_t}
											<li class="ShAA_sizeNotSelect" size="{$size_t->nsize}">
												<a class="ShAA_sizeLink" title="{$size_t->size}">{$size_t->size}</a>
											</li>
										{/foreach}						
									</ul>
								</div>
		{if $product->sizes_url}
								<div class="clear"></div>
								<div class="sizePages">
									<span class="sizeImg" style="cursor:pointer;width:150px;" title="Открыть таблицу размеров" onClick="popupWin = window.open('{$product->sizes_url}', 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;">
										Таблица&nbsp;размеров&nbsp;<a href="{$product->sizes_url}" target="_blank" onClick="popupWin = window.open(this.href, 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;"><img src="/images/size_icon.png" /></a>
	        						</span>
								</div>
		{/if}
	        				</div>
	{/if}
	</div>
{else}
	<div style="float: left; padding: 0 0 16px 0; font-size: 12px;">товара нет в наличии</div>
{/if}						
						<div class="clear"></div>
	        			<div class="tabBlock">
	        				{* Сертификаты *}
							{if $product->category_id != 8233}
		        				<ul class="tabs tabs1">
									<li class="t1 {if !($product->description)} tab-current{/if}"><a>Подробнее</a></li>
									<li class="t2 {if $product->description} tab-current{/if}"><a>От редактора</a></li>
								</ul>
							{/if}
						
							<div class="t1" style="{if $product->description}display: none;{/if}">
								{foreach from=$product->properties item=property key=key}{if preg_match('/Материал/',$property->name)}Cостав: {$property->value}{/if}{/foreach}
								{if !($no_size)}<br />В наличии размеры: {foreach from=$product->size_text item=size_t }{$size_t} {/foreach}{/if}<br />
								Цвет: {$color_name->name}<br />
								{* Подиумы *}
								{if !$podium}
									Коллекция сезона: {$product->season}<br />
								{/if}
								{if $smarty.session.user->group_id && $smarty.session.user->group_id != 1}Артикул: {$product->sku}<br />{/if}
                ID: {$product->product_id}<br />
								{if $product->item_location_link}
								Вы можете приобрести эту вещь <br>в нашем <a target="_blank" href="{$product->item_location_link}">магазине {$product->item_location_name}</a>
								{/if}
							</div>
						
							<div class="t2 redactText" style="{if $product->description}display: block;{/if}" itemprop="description">
								{if $description}
									{$description}
								{else}
									{$product_brand_text}
								{/if}
							</div>
							<div class="clear"></div>
	        			</div>
	        		</div>
	        	</div>
					

	        </div>

	{literal}
	<script language="javascript">
		$j(document).on("mouseenter", ".ShAA_catalogItem_new", function(event) {
		s = $j(this).find(".imgCatalog_new").find("img");
		over = s.attr("src_over");
		s.attr("src",over);
	});
	$j(document).on("mouseleave", ".ShAA_catalogItem_new", function(event) {
		s = $j(this).find(".imgCatalog_new").find("img");
		out = s.attr("src_out");
		s.attr("src",out);
	});
	</script>
{/literal}
	
	<div id="product_container" style="float: left;">
		<div id="similar_recomendations" style="display:none;">
			<div style="font-weight: normal; margin: 26px 0;">Похожие товары</div>
			<div class="products"></div>
		</div>
{if $product->product_id}
		<script>
			var item = {$product->product_id};
			var cart =  new Array();
			{foreach from=$smarty.session.shopping_cart item=item key=key}
				cart[{$key}] = {$key};
			{/foreach}
		</script>
{/if}		
		<div id="also_bought_recomendations" style="display:none;">
			<div style="font-weight: normal; margin: 26px 0;">С этим товаром покупают</div>
			<div class="products"></div>
		</div>
		
		<div id="recently_viewed_recomendations" style="display:none;">
			<div style="font-weight: normal; margin: 26px 0;">Вы недавно смотрели</div>
			<div class="products"></div>
		</div>
		
		<div id="interesting_recomendations" style="display:none;">
			<div style="font-weight: normal; margin: 26px 0;">Возможно, вам это понравится</div>
			<div class="products"></div>
		</div>
	</div>
	</div>

{if $purchase_data}
{literal}
<script type="text/javascript">
jQuery(document).ready(function() {
    if ( window._gaq !== undefined ) {
        _gaq.push(['_addTrans',
            '{/literal}{$purchase_data.order_id}{literal}',           // order ID - required
            'Luxury Store',  // affiliation or store name
            '{/literal}{$purchase_data.price|string_format:"%.2f"}{literal}',          // total - required
            '0', // tax
            '0', // shipping
            'Russia', // city
            'Russia', // state or province
            'Russia'  // country
        ]);
        _gaq.push(['_addItem',
            '{/literal}{$purchase_data.order_id}{literal}',           // order ID - required
            '{/literal}{$purchase_data.item_id|escape}{literal}',           // SKU/code - required
            '{/literal}{$purchase_data.model|escape}{literal}',        // product name
            '{/literal}{$purchase_data.price|string_format:"%.2f"}{literal}',          // unit price - required
            '1']);
        _gaq.push(['_trackTrans']); //submits transaction to the Analytics servers
    }

    if (typeof(dataLayer) !== 'undefined' && dataLayer) { // Коллектор данных для ecommerse
        product = {
            id:    "P{/literal}{$purchase_data.item_id|escape}{literal}",
            name:  "{/literal}{$purchase_data.model|escape}{literal}",
            price:  {/literal}{$purchase_data.price|string_format:"%.2f"}{literal}
        };
        ecommerce = {};
        ecommerce["currencyCode"] = "RUB";
        ecommerce['purchase']     = {"actionField": { "id"      : "D{/literal}{$purchase_data.order_id}{literal}",
                                                      "goal_id" : "10066135"}, 
                                     "products": [product]};
        dataLayer.push({"ecommerce" : ecommerce});
    }
});
</script>
{/literal}
{/if}
{assign var=hidden_brands value=","|explode:$user->show_hidden_brands} 
{if !$oc_ordered && !$so_ordered &&  $smarty.session.user->group_id < 2 && $config->enviroment == 'live' && !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}
<script>
//Criteo dataLayer
    {literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'CriteoEmail': {/literal}'{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}'{literal}, 
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
