{literal}
<style type="text/css" >
	.owl-carousel .item img{
	  display: inline;
	  width: 90%;
	  height: auto;
	}
</style>
<script type="text/javascript">
	jQuery(document).ready(function() {
      if(jQuery(window).width() > 1000){ jQuery('#video_zoom').detach();}
      jQuery(".owl-carousel").owlCarousel({
      lazyLoad: true,
      navigation: true,
      navigationText: ['&#8249;','&#8250;'],
      singleItem: true
    });
    if( jQuery.cookie('currency') ){
      var currency = jQuery.cookie('currency');
      set_currency(currency);
    }
    $('.owl-buttons').hide();
    $('#owl-demo').find('.owl-buttons').show();
    $(window).resize(function(){
        if($(window).width() < 990){
            $('.owl-buttons').hide();
            $('#owl-demo').find('.owl-buttons').show();
        }else{
            $('.owl-buttons').show();
        }
    });
  });
</script>
{/literal}

<script type="text/javascript">
{literal}
if (typeof $luxury_obj !== 'undefined'){
{/literal}
$luxury_obj['rowcount']={if $rowcount}{$rowcount}{else}0{/if};
{literal}
}
function limitChecks(type, elements) {
    if(jQuery(window).width() > 1000){ jQuery('#video_zoom').detach();}
	jQuery(".owl-carousel").owlCarousel({
						lazyLoad: true,
						navigation: true,
                        navigationText: ['&#8249;','&#8250;'],
						singleItem: true
					});
    if (elements) {
        jQuery("div#list-"+type).find(".handle").each( function() {
            var ch = jQuery(this);
            if (elements.indexOf(ch.find(".box").find("input").attr("name")) > -1) {
                ch.removeClass("handle-disabled").addClass("handle-enabled");
            }
            else {
                if(!ch.hasClass('onTab')){
                  ch.removeClass("handle-enabled").addClass("handle-disabled");
                }
            }
        });
    }
    else {
        jQuery("div#list-"+type).find(".handle").each( function() {
            jQuery(this).removeClass("handle-disabled").addClass("handle-enabled");
        });
    }
}
{/literal}
limitChecks("categories", {if $listcateg}{$listcateg}{else}null{/if});
limitChecks("brands", {if $listbrands}{$listbrands}{else}null{/if});
limitChecks("csizes", {if $listsizes}{$listsizes}{else}null{/if});
limitChecks("fsizes", {if $listsizes}{$listsizes}{else}null{/if});
limitChecks("materials", {if $listmater}{$listmater}{else}null{/if});
</script>
{foreach from=$wallproducts item=product}
    <div itemprop="itemListElement" itemscope="" itemtype="http://schema.org/Product" id="main_{$product->product_id}" class="ShAA_catalogItem_new" data-sku="{$product->sku}" {*onclick="window.location = '/products/{$product->url}/';"*}>
        <div id="img_main_{$product->product_id}" class="imgCatalog_new load_block" {if ($is_iphone || $is_ipod || $is_ipad)}style="display: block !important;"{/if}>
			<a target="blank" name="{$product->product_id}" href="/products/{$product->url}/" title="{if $language=='eng'}{$product->group_name} {$product->brand}{else}{$product->model} из Италии и Франции{/if}" style="border-bottom:none;">
                {if ($product->large_image == '') && ($product->second_image == '')}
                    <img alt="{if $product->category}{$product->category} {/if}{$product->model}{if $product->brand} {$product->brand}{/if}" src="/images/noimg.png" src_out="/images/noimg.png" itemprop="image" />
                {else}
                    <img alt="{if $product->category}{$product->category} {/if}{$product->model}{if $product->brand} {$product->brand}{/if}" src="/files/products/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{/if}{/if}" {if (!$is_iphone & !$is_ipod & !$is_ipad)} src_out="/files/products/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{/if}{/if}" src_over="/files/products/{if $product->second_image}{$product->second_image}{else}{if $product->large_image}{$product->large_image}{/if}{/if}" {/if} itemprop="image" />
                {/if}
			</a>
	    </div>
{if (!$is_iphone & !$is_ipod & !$is_ipad)}
		<div id="owl-demo_main_{$product->product_id}" class="owl-carousel">
			<div class="item">
				<a target="blank" href="/products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" title="{if $language=='eng'}{$product->group_name} {$product->brand}{else}{$product->model} из Италии и Франции{/if}" style="border-bottom:none;">
					<img class="lazyOwl not_replace" src="" data-src="/files/products/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{else}{$product->small_image}{/if}{/if}" alt="{$product->img_desc}" />
				</a>
			</div>
			<div class="item">
				<a target="blank" href="/products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" title="{if $language=='eng'}{$product->group_name} {$product->brand}{else}{$product->model} из Италии и Франции{/if}" style="border-bottom:none;">
					<img class="lazyOwl not_replace2" src="" data-src="/files/products/{if $product->second_image}{$product->second_image}{else}{if $product->large_image}{$product->large_image}{/if}{/if}" alt="" />
				</a>
			</div>
		</div>
{/if}
	    <div class="ShAA_descriptionCatalog" itemprop="description" style="margin-top:5px;">
            <div style="float: left; width: 100%;">
                <a target="blank" style="float: left;margin-right:1em;" href="/products/{$product->url}/" target="_blank"><span itemprop="name" class="prod_name">{$product->group_name}</span>&nbsp;<span  itemprop="brand" class="prod_brand">{$product->brand}</span>{if $product->model_full}</br><span>{$product->model_full}</span>{/if}</a>
            </div>
        <span class="prod_categ" data-categ="{$product->category}"></span>
		    <a itemprop="offers" itemscope itemtype="http://schema.org/AggregateOffer" href="/products/{$product->url}/" target="_blank">
				{if $product->can_buy_from_site}

					<span style="font-size:12px;">
						{if $product->prices.first_price}
							{if $product->show_delta}
								<span class="price rub" style="position: relative; width: auto; line-height: 1em !important;display: inline-block;"><span itemprop="highPrice" class="prod_price">{$product->prices.first_price|string_format:"%.0f"}</span><span class="ShAA_lineThrough"></span>&nbsp;<i class="icon-rub"></i></span>
	              {foreach from=$cat_currencies item=currency}
	                {assign var="c_name" value="first_price_`$currency->code`"}
	                <span class="price {$currency->code}" style="display:none; position: relative; width: auto; line-height: 1em !important;"><span>{$product->prices.$c_name|string_format:"%.0f"}</span><span class="ShAA_lineThrough"></span>&nbsp;<b>{$currency->sign}</b></span>
	              {/foreach}
							{/if}
						{else}
							<span class="price rub"><span itemprop="highPrice" class="prod_price">{$product->prices.price|string_format:"%.0f"}</span>&nbsp;<i class="icon-rub"></i></span>
              {foreach from=$cat_currencies item=currency}
                {assign var="c_name" value="price_`$currency->code`"}
                <span class="price {$currency->code}" style="display:none;">{$product->prices.$c_name|string_format:"%.0f"}&nbsp;<b>{$currency->sign}</b></span>
              {/foreach}
						{/if}
					</span><br/>

					{if $product->prices.sale_price.price > 0 }
						<span style="font-size:12px;">
							<span class="price rub"><b style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}" itemprop="lowPrice">{$product->prices.sale_price.price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i></span>
              {foreach from=$cat_currencies item=currency}
                {assign var="c_name" value="price_`$currency->code`"}
                <span class="price {$currency->code}" style="display:none;"><span style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}"><b>{$product->prices.sale_price.$c_name|string_format:"%.0f"}</b></span>&nbsp;<b>{$currency->sign}</b></span>
              {/foreach}
              {* {if $language=='eng'}Price with discount{else}Цена со скидкой{/if} *}
						</span><br/>
					{/if}

					{if $product->prices.vip_price.price > 0}
						<span style="font-size:12px;">
              <span class="price rub"><b itemprop="lowPrice">{$product->prices.vip_price.price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i></span>
              {foreach from=$cat_currencies item=currency}
                {assign var="c_name" value="price_`$currency->code`"}
                <span class="price {$currency->code}" style="display:none;"><b>{$product->prices.vip_price.$c_name|string_format:"%.0f"}</b>&nbsp;<b>{$currency->sign}</b></span>
              {/foreach}
              {* {if $language=='eng'}<b>VIP discount</b>{else}<b>VIP скидка</b>{/if} *}
            </span><br/>
					{/if}

				{/if}

		    {if $product->size != 'Р-р не задан' && $product->size != 'р-р не зад' && $product->size != 'не задан' && !$product->hide_sizes}
				<span style="clear: both;"><span class="prod_sizes">{if $language=='eng'}Sizes{else}Размеры{/if}:</span> <span class="prod_sizes">{$product->size|replace:'|':' '}</span></span>
			{/if}
			</a>
			{if $smarty.session.user->group_id > 1 && $product->tsum_price}
				<br>Цена в ЦУМе
				{if $product->tsum_price > 0}выше на <span style="color:green;">{$product->tsum_price} р</span>
				{else} ниже на <span style="color:red;">{$product->tsum_price|abs} р</span>
				{/if}
			{/if}
			{if $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 5}
				<br>Всего просмотров: {$product->product_views->count|default:"0"}
				<br>Зарегистрированных: {$product->product_views->count_logged_in|default:"0"}
			{/if}
	    </div>
	    {if (($product->old_price != 0) && ($product->old_price > $product->price) && (($product->old_price-$product->price)/$product->old_price > 0.1)) }
			{if ($product->no_sale || $furs) }
				<div></div>
			{elseif 'swd'|array_key_exists:$promos && in_array($product->brand_id, explode(",", $promos.swd->brands)) }
				<div class="ShAA_swdIcon">скидка выходного дня</div>
			{elseif $product->golden_sale }
				<div class="ShAA_goldenPriceIcon">выгодное предложение</div>
			{/if}
        {/if}
        {if $product->season}
            <div class="ShAA_newSeasonIcon" {if ($language != 'eng')} title="сезон" {else} title="season" {/if} style="cursor: help;">{$product->season}</div>
        {/if}
				{if $product->season_type == 'new_season' || $product->season_type == 'next_season'}
						<div class="ShAA_newSeasonIcon" style="color: white; background: black;">{if $language=='eng'}New season{else}Новый сезон{/if}</div>
				{/if}
        {if ($product->old_price != 0 && $product->old_price>$product->price && ($furs || $product->super_price) ) }
        	<div class="ShAA_newSeasonIcon" style="color: rgb(216, 0, 104); border: 1px solid rgb(216, 0, 104);">{if $language=='eng'}Super price{else}Супер-цена{/if}</div>
        {/if}
		{if !empty( $product->s_material )}
			{foreach from=$product->s_material item=material}
				{if !empty( $material->name )}
					<div class="ShAA_newSeasonIcon" {if ( $material->description && $language != 'eng' )} data-tooltip="{$material->description}" style="cursor: help;" {/if}>{$material->name}</div>
				{/if}
			{/foreach}
        {/if}
		{if ( $product->vimeo )}
			<div class="ShAA_newSeasonIcon">&nbsp;360&deg;</div>
		{/if}
        {if ( $product->video )}
            <a class="ShAA_iframeYoutubeLink" href="{$product->video|replace:'watch?v=':'embed/'}?rel=0&autoplay=1" target="_blank">
                <div class="ShAA_newSeasonIcon ShAA_videoIcon"><i class="icon-play"></i>&nbsp;Video</div>
            </a>
        {/if}

        {if ($product->category_id == 8346 || $product->category_id == 8341 || $product->category_id == 8342) && $product->old_price > $product->price}
        {/if}
        {if ($product->old_price != 0 && $product->old_price>$product->price && ($furs || $product->super_price) ) }
		 <div class="ShAA_descriptionCatalog" style="margin:5px  0 0 0;min-height:35px; display: none;">
			<div style="clear: both;">{if $language=='eng'}Time left{else}Осталось{/if}: <span class="ShAA_timeClass"></span></div>
		</div>
		{/if}
    </div>
{/foreach}
{literal}
<script type="text/javascript">
	if (typeof $luxury_obj !== 'undefined'){jQuery('#sp_params').val(JSON.stringify({brands: $luxury_obj.brands, categories: $luxury_obj.categories}))};
</script>
{/literal}


{literal}
<script>
		jQuery('.ShAA_timeClass').timeTo({
            timeTo: new Date('Feb 01 2018 00:00:00'),
            displayCaptions: false,
            fontSize: 13,
			gap: 8,
			width: 8,
			displayDays: 2,
			fontFamily: '"Roboto", sans-serif'
        });

        jQuery("[data-tooltip]").mousemove(function (eventObject) {
        $data_tooltip = jQuery(this).attr("data-tooltip");
        jQuery("#tooltip").text($data_tooltip)
                     .css({
                        "top" : eventObject.pageY + 25,
                        "left" : eventObject.pageX + 5,
                        "paddingLeft" : 8,
                        "paddingRight" : 8
                     })
                     .show();
        }).mouseout(function () {
            jQuery("#tooltip").hide().text("").css({"top" : 0,"left" : 0});
        });

        jQuery(document).ready(function() {
            var txt =  jQuery("#change_view").text();
            if (txt == "вид") {
                jQuery(".load_block").find("img").each(function(i,elem) {
                    s = jQuery(elem);
                    over = s.attr("src_over");
                    out = s.attr("src_out");
                    s.attr("src",over);
                    s.attr("src_over",out);
                    s.attr("src_out",over);
                });
            }
        });
</script>
{/literal}
