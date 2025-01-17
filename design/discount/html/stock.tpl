<script type="text/javascript" src="/jscript/cloudzoom.js"></script>
<link media="all" href="/jscript/cloudzoom.css" rel="stylesheet" type="text/css" />

{literal}
<style>
	.cloudzoom-zoom-big {
		border: 1px solid #ccc;
		overflow:hidden;
		width: 336px !important;
		height: 356px !important;
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

<script>
	{literal}
	var $j = jQuery.noConflict();
		
	$j(document).ready(function() {
		$j('ul.tabs li').css('cursor', 'pointer');
			
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
		
		CloudZoom.quickStart();
		
	});
	{/literal}
</script> 

<div style="float: left;width: 690px;margin: 0 10px 0 0;">
	{if $product->image == '/images/noimage.png'}
		<img src="{$product->image}" style="float: left;width: 180px;">
	{else}
		<img class="cloudzoom" id="zoom1" src="{$product->image}" data-cloudzoom = "zoomImage: '{$product->image}', zoomOffsetX: 90, zoomOffsetY: 0, zoomClass: 'cloudzoom-zoom-big', lensClass: 'cloudzoom-lens'"  style="float: left;width: 180px;" />
	{/if}
								
	<div style="line-height: 32px;float: left;margin-left:22px;width:395px;">
		<div style="float: left;margin: 25px 0 0 0;width:395px;"></div>
			{if $product->p_date}
				К сожалению, этот товар <h1 style="font-size: 14px;font-weight: normal;margin: 0 5px 0 0;padding: 0;display: inline;font-style: italic;">{$product->category_name} {$product->brand}</h1> был продан.
				Вы можете выбрать из других товаров {if $category}в категории <a href="/categories/{$category->url}/" class="ShAA_productDesigner">{$category->name}</a> {/if}{if $brand}бренда <a href="/brands/{$brand->url}/" class="ShAA_productDesigner">{$brand->name}</a>{/if}.<br>
			{elseif ($product->image && $product->image != '/images/noimage.png')}
				Товар <h1 style="font-size: 14px;font-weight: normal;margin: 0 5px 0 0;padding: 0;display: inline;font-style: italic;">{$product->category_name} {$product->brand}</h1> числится в остатках.<br> Вы можете заказать товар, воспользовавшись функцией 
				<a title="Совершить покупку в один клик" class="ShAA_productDesigner" href="/index.php?module=cart&one_click&clear_template&oneclick_product={$product->product_id}" rel="facebox" target="_blank" id="edit_link" 
					onclick="{literal}rG('BUY_1_CLICK_SITE');{/literal}">заказать в 1 клик</a>.
				<div style="margin: 0 0 13px 0;width:395px;"></div>
				Или выбрать из других товаров {if $category}в категории:<br> <a href="/categories/{$category->url}/" class="ShAA_productDesigner">{$category->name}</a> {/if}{if $brand}бренда <a href="/brands/{$brand->url}/" class="ShAA_productDesigner">{$brand->name}</a>{/if}.<br>
			{else}
				К сожалению для товара <h1 style="font-size: 14px;font-weight: normal;margin: 0 5px 0 0;padding: 0;display: inline;font-style: italic;">{$product->category_name} {$product->brand}</h1>нет изображения, вы можете заказать фотографию товара, воспользовавшись функцией 
				<a title="Совершить покупку в один клик" class="ShAA_productDesigner" href="/index.php?module=cart&one_click&clear_template&oneclick_product={$product->product_id}" rel="facebox" target="_blank" id="edit_link" 
					onclick="{literal}rG('BUY_1_CLICK_SITE');{/literal}">заказать в 1 клик</a>.
				<div style="margin: 0 0 13px 0;width:395px;"></div>
				Или выбрать из других товаров {if $category}в категории:<br> <a href="/categories/{$category->url}/" class="ShAA_productDesigner">{$category->name}</a> {/if}{if $brand}бренда <a href="/brands/{$brand->url}/" class="ShAA_productDesigner">{$brand->name}</a>{/if}.<br>
			{/if}
		<br>
		<br>
	</div>
</div>
<div style="width:230px;float:right;">
	<div class="productInfo">
	{if $brand}
		<div class="titleMain">
			<a href="/brands/{$brand->url}/"><img width="212" alt="{$brand->name}" title="{$brand->name}" src="/reimg/files/brands/212x/{$brand->image}"></a>
		</div>
	{/if}

		<div class="description">
			{if $category}
			<a class="ShAA_productDesigner" href="/categories/{$category->url}/">{$category->name}</a>
			{else}
			<span>{$product->category_name}</span>&nbsp;
			{/if}
			{if $brand}
			<a class="ShAA_productDesigner" href={if $brand}"/brands/{$brand->url}/"{else}"#"{/if}>{$product->brand}</a>
			{else}
			{$product->brand}&nbsp;
			{/if}
			<br>	
			<span>стоимостью {if $product->sum_with_discount}{$product->sum_with_discount}{else}{$product->retail_price}{/if}</span><br>
			{if $product->retail_price >= 10000}Доставка бесплатно{/if}
		</div>
	</div>

	
	<div class="productInfo">
							
		{if $product->size}
			<div class="sizeBlock">
				<div class="sizePages">
					<span>
						<a href="/sizes/wsizeclothes.php?sex=1" target="_blank" onclick="popupWin = window.open(this.href, 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;">Размер</a>
					</span>
			
					<span id="userCurrentSize">0</span>
			
					<span class="sizeImg">
						<a href="/sizes/wsizeclothes.php?sex=1" target="_blank" onclick="popupWin = window.open(this.href, 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;"><img src="/images/size_icon.png"></a>
					</span>
		
				</div>
				<div class="productInfo">
					<ul class="ShAA_sizeUl">
						{foreach from=$product->size_text item=size_t}
							{if $size_t != "Р-рнезадан"}<li class="ShAA_sizeNotSelect">
								<a class="ShAA_sizeLink" title="{$size_t}">{$size_t}</a>
							</li>
							{/if}
						{/foreach}
					</ul>
				</div>
			</div>
		{/if}

		<div class="addToBlock" style="margin: 0px 0 20px 0; width: 330px;">
			<div style="margin-top:7px;">
				{if !$product->p_date}
				<a title="Совершить покупку в один клик" class="ShAA_productDesigner" href="/cart/one_click/" rel="facebox" target="_blank" id="edit_link" style="margin-left:13px;" 
					onclick="{literal}rG('BUY_1_CLICK_SITE');{/literal}">
					Купить в 1 клик
				</a>
				{/if}
			</div>
		</div>

	</div>
	
	<div class="clear"></div>

	<div class="tabBlock">
		<ul class="tabs tabs1">
			<li class="t1 tab-current" style="cursor: pointer;"><a>Подробнее</a></li>
		</ul>
	
		<div class="t1" style="height: auto;">
			{if $product->p_date}
			К сожалению, этот товар уже был продан.
			{else}Cостав: {$product->material}<br>
			{if !($no_size)}В наличии размеры: {foreach from=$product->size_text item=size_t }{$size_t} {/foreach}{/if}<br>
			Цвет: {$product->color}<br>
			Вы можете приобрести эту вещь <br>в нашем <a target="_blank" href="{$location->link}">магазине {$location->name}</a>
			{/if}
		</div>
		<div class="clear"></div>
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
	<div id="product_container" style="float:left;width:100%;">
		{foreach from=$linkproducts item=lproduct}
		<div id="{$lproduct->product_id}" class="ShAA_catalogItem_new" onclick="window.open('/products/{$lproduct->url}/','_blank');">
				
			<div id="img_{$lproduct->product_id}" class="imgCatalog_new">
				<img alt="{$lproduct->model} из Италии и Франции" title="{$lproduct->model} из Италии и Франции" src="/reimg/files/products/184x/{$lproduct->large_image}" src_out="/reimg/files/products/184x/{$lproduct->large_image}" src_over="/reimg/files/products/184x/{$lproduct->small_image}">
			</div>
				
			<div class="ShAA_descriptionCatalog" style="margin-top:5px;height:35px;">
				<h1>{$lproduct->model}</h1>
									    				
				    {$lproduct->price} рублей
						<br>
						<br>
			</div>
		</div>
		{/foreach}
	</div>