{if $only_products}

{else}
{literal}
	<style type="text/css">
		.box {
			width: 17px;
			height: 15px;
			display: inline-block;
			background: url(/sizes/images/checkboxes.png);
			background-position: 0px 0px;
			}
			span.on {
			background-position: 0px -15px;
			}
			span.checklabel {
			margin-left: 18px;
			font-size: 12px;
			font-family: tahoma;
			color: #3C3C3C;
			position: relative;
			top: -3px;
			}
			div.handle {
			margin-bottom: 6px;
			}
			div.handle-enabled {
			cursor: pointer;
			}
			div.handle-disabled {
			opacity: 0.3;
			}
			div#preloader {
			margin:auto;
			margin-top:20px;
			margin-bottom:30px;
			width:180px;
			}
	</style>
{/literal}

	<script type="text/javascript" src="/jscript/timeto/jquery.time-to.js"></script>
	<link rel="stylesheet" type="text/css" href="/jscript/timeto/timeto.css" />

	{literal}
		<style>
			.ShAA_descriptionCatalog span {
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
	{/literal}

<script type="text/javascript">
var $luxury_obj = {ldelim}
    brands: [],
    categories: [],
    sizes: []
    {if $rootcateg}, rootcateg: '{$rootcateg}'{/if}
    {if $rootbrand}, rootbrand: {$rootbrand}{/if}
    {if $rowcount}, rowcount: {$rowcount}{/if}
    {if $special}, special: {$special}{/if},
    offset: 60,
    state: 0
{rdelim};
{literal}
if(!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(needle) {
        for(var i = 0; i < this.length; i++) {
            if(this[i] === needle) {
                return i;
            }
        }
        return -1;
    };
}
jQuery(document).ready(function() {
    jQuery(document).on("click", "div.handle-enabled", function(event) {
        $luxury_obj['state'] = 1;

        var $checkbox = $(this).find(".box").find("input");
        $checktype = $checkbox.attr("data-type");
        if ($checkbox.attr("checked")) {

          $checkbox.attr("checked",false).parent().toggleClass("on");
          if ($luxury_obj[$checktype].length == 0) {
              jQuery("."+$checktype+"-clear-box").addClass("on").find("input").attr("checked",true);
          }
          index = $luxury_obj[$checktype].indexOf($checkbox.attr("name"));
          $luxury_obj[$checktype].splice(index, 1);
          $luxury_obj['offset']= 0;
          jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
            jQuery("#product_container").fadeToggle( function() {
              jQuery(this).html(data).fadeToggle();
              $luxury_obj['offset']= 60;
            });
          });
        }
        else {
          $luxury_obj[$checktype].push($checkbox.attr("name"));
          $checkbox.attr("checked",true).parent().toggleClass("on");
          jQuery("."+$checktype+"-clear-box").removeClass("on").find("input").attr("checked",false);
          $luxury_obj['offset']= 0;
          jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
            jQuery("#product_container").fadeToggle( function() {
              jQuery(this).html(data).fadeToggle();
              $luxury_obj['offset']= 60;
            });
          });
        }
        $luxury_obj['state'] = 0;
    });

    jQuery(document).on("click", "div.handle-clear", function(event) {
        $luxury_obj['state'] = 1;

        var $checkbox = jQuery(this).find(".box").find("input");
        $checktype = $checkbox.attr("data-type");
        $luxury_obj[$checktype] = [];
        $checkbox.attr("checked",true).parent().addClass("on");
        jQuery("span."+$checktype+"-regular-box").each( function(event) {
          jQuery(this).removeClass("on");
          jQuery(this).find('input').attr("checked",false);
        });
        $luxury_obj['offset']= 0;
        jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
          jQuery("#product_container").fadeToggle( function() {
            jQuery(this).html(data).fadeToggle();
            $luxury_obj['offset']= 60;
          });
        });
        $luxury_obj['state'] = 0;
    });

    function isScrolledIntoView(elem) {
        var docViewTop = jQuery(window).scrollTop();
        var docViewBottom = docViewTop + jQuery(window).height();
        var elemTop = jQuery(elem).offset().top-1640;
        return (elemTop <= docViewBottom);
    }

    var floor = jQuery('.footer');
    jQuery(window).scroll(function() {
        if(isScrolledIntoView(floor) && $luxury_obj['state'] == 0 && $luxury_obj['rowcount'] > 60) {
            $luxury_obj['state'] = 1;
            if ($luxury_obj['offset'] < $luxury_obj['rowcount']) {
                jQuery('#product_container').append('<div id="preloader"><img src="/images/preload.gif" alt="" /><div style="width:100%;margin:auto;">Загрузка товаров</div></div>');
                jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
                    jQuery('#preloader').remove();
                    jQuery("#product_container").append(data);
                    $luxury_obj['state'] = 0;
                    $luxury_obj['offset'] = $luxury_obj['offset'] + 30;
                });
            }
        }
    });
	function addEvent(obj, evt, fn) {
		if (obj.addEventListener) {
			obj.addEventListener(evt, fn, false);
		}
		else if (obj.attachEvent) {
			obj.attachEvent("on" + evt, fn);
		}
	}

	addEvent(window,"load",function(e) {
		addEvent(document, "mouseleave", function(e) {
			e = e ? e : window.event;
			var from = e.relatedTarget || e.toElement;
			if ((!from || from.nodeName == "HTML") && jQuery.cookie('LeaveWshown') !== '1') {
				$("#popUp_leaving").show();
				jQuery.cookie('LeaveWshown', 1, {expires: 7, path: "/"});
			}
		});
	});

});
</script>
{/literal}

<div style="float: left; margin: 24px 0 0 0;" id="catalog_left">
	<div class="checks" style="margin: 6px 0px 0 0;">
	{if $is_admin}<div style="margin-bottom:20px;">Создать подборку из выбранных товаров<form action="/admin/index.php?section=Special" method="POST" name="article">
        <input id="sp_params" type="hidden" name="params" value="" />
        <input id="sp_sex" type="hidden" name="gender" value="0" />
        <input id="sp_name" type="hidden" name="name" value="Новая подборка" />
        <input id="sp_desc" type="hidden" name="description" value="" />
        <input id="sp_mdesc" type="hidden" name="meta_description" value="" />
        <input id="sp_mtitle" type="hidden" name="meta_title" value="" />
        <input id="sp_kwrds" type="hidden" name="meta_keywords" value="" />
        <input type="submit" value="Создать" /></form></div>
    {/if}

		<div class="formtitle" style="margin-top: 0px;">
			<a href="#" style="border:none;" onclick="$('#check-categories').slideToggle(500); $('#tblc').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
				<span id="tblc" class="{if isset($showbrand)}slide_button_m{else}slide_button_p{/if}" style="float:left;margin:5px 6px 6px 6px;"></span>
				Категории
			</a>
		</div>
		<div id="check-categories" style="{if isset($showbrand)}display:block;{else}display:none;{/if}">
			<div class="handle-clear">
				<span class="box on categories-clear-box">
					<input checked="checked" data-type="categories" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
				</span>
				<span class="checklabel">Все</span>
			</div>
			<div class="checkline"></div>

			<div id="list-categories">
				{foreach from=$filtercategories item=ccateg}
					<div class="handle handle-enabled">
						<span class="box categories-regular-box">
							<input data-type="categories" type="checkbox" name="{$ccateg->id}" style="display:none;" autocomplete="off" />
						</span>
						<span class="checklabel">{$ccateg->name}</span>
					</div>
				{/foreach}
			</div>
		</div>

	    {if !isset($showbrand) && !isset($showgood)}
            <div class="formtitle">
                <a href="#" style="border:none;" onclick="$('#check-brands').slideToggle(500); $('#tbla').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
                    <span id="tbla" class="slide_button_m" style="float:left;margin:5px 6px 6px 6px;"></span>
                    Дизайнеры
                </a>
            </div>
            <div id="check-brands" style="display:block;">
                <div class="handle-clear">
                    <span class="box on brands-clear-box">
                        <input checked="checked" data-type="brands" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                    </span>
                    <span class="checklabel">Все</span>
                </div>
                <div class="checkline"></div>
                <div id="list-brands">
	                {foreach from=$filterbrands item=cbrand}
                        <div class="handle handle-enabled">
                            <span class="box brands-regular-box">
                                <input data-type="brands" type="checkbox" name="{$cbrand->id}" style="display:none;" autocomplete="off" />
                            </span>
                            <span class="checklabel">{$cbrand->name|upper}</span>
                        </div>
	                {/foreach}
                </div>
            </div>
	    {/if}

	    {if (($rootcateg != 38) && ($rootcateg != 4))}
	        <div class="formtitle">
                <a href="#" style="border:none;" onclick="$('#check-sizes').slideToggle(500); $('#tblb').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
                    <span id="tblb" class="slide_button_p" style="float:left;margin:5px 6px 6px 6px;"></span>
                    Размеры
                </a>
            </div>
	        <div id="check-sizes" {if !$showgood}style="display:none;"{/if}>
                <div class="handle-clear">
                    <span class="box on sizes-clear-box">
                        <input checked="checked" data-type="sizes" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                    </span>
                    <span class="checklabel">Все</span>
                </div>
                <div class="checkline"></div>
                <div id="list-sizes">
                    {if !empty($filtersizes.clothes)}
                        {if !empty($filtersizes.footwear)}<p><b>Одежда</b><p>{/if}
                        {foreach from=$filtersizes.clothes item=csize}
                            <div class="handle handle-enabled">
                                <span class="box sizes-regular-box">
                                    <input data-type="sizes" type="checkbox" name="{$csize}" style="display:none;" autocomplete="off" />
                                </span>
                                <span class="checklabel">{if ($csize == "Р-р не задан")}Без размера{else}{$csize}{/if}</span>
                            </div>
                        {/foreach}
                    {/if}
                    {if !empty($filtersizes.footwear)}
                        {if !empty($filtersizes.clothes)}<p><b>Обувь</b><p>{/if}
                        {foreach from=$filtersizes.footwear item=csize}
                            <div class="handle handle-enabled">
                                <span class="box sizes-regular-box">
                                    <input data-type="sizes" type="checkbox" name="{$csize}" style="display:none;" autocomplete="off" />
                                </span>
                                <span class="checklabel">{if ($csize == "Р-р не задан")}Без размера{else}{$csize}{/if}</span>
                            </div>
                        {/foreach}
                    {/if}

                </div>
            </div>
       {/if}


    </div>
</div>
<div class="centerRightContentCatalog_new" style="margin: 20px 0px 0 0;">
{/if}<!-- end if only_products -->

{if isset($showbrand) }
	<div class="centerRightContent" style="width:680px;">
		<div class="brandImage" style="float: left; width: 212px; margin: 0;">
		    <img width="212" alt="{$showbrand->name}" title="{$showbrand->name}" src="/reimg/files/brands/212x/{$showbrand->image}" />
	    </div>
		<a style="float:right;height:20px;" href="/index.php?module=Feedback&brand_id={$showbrand->brand_id}&clear" id="feedbackbox"  onclick="{literal}rG('BRAND_SUBSCRIBE');return false;{/literal}">
			<div class="buttonNew"><span>Подписаться на обновления</span></div></a>
		<div class="brandDescription">
			{if $manOrWoman == '1' && !empty($showbrand->description_m)}{$showbrand->description_m}
				{elseif $manOrWoman == '2' && !empty($showbrand->description_w)}{$showbrand->description_w}
				{else}{$showbrand->description}
			{/if}
		</div>
	</div>
{/if}

{if isset($special) }
    <div class="centerRightContent" style="width:680px;">
		<div class="titleMain" style="text-align: center;"><b>{$special_fields->name}</b></div>
		<div class="brandDescription" style="text-align: center;">
			{$special_fields->description}
		</div>
    </div>
{/if}

{literal}
<script type="text/javascript" language="javascript">
	jQuery(document).on("mouseenter", ".ShAA_catalogItem_new", function(event) {
        s = jQuery(this).find(".imgCatalog_new").find("img");
        over = s.attr("src_over");
        s.attr("src",over);
    });
    jQuery(document).on("mouseleave", ".ShAA_catalogItem_new", function(event) {
        s = jQuery(this).find(".imgCatalog_new").find("img");
        out = s.attr("src_out");
        s.attr("src",out);
    });
</script>
{/literal}

{if $showgood}
	<h1>{$showgood->title}</h1>
	<div id="category_description" style="margin-left: 34px;font-size: 11px;color: #787878;">{$showgood->text}</div>
{elseif $categ_desc}
	<h1>{$categ_name}</h1>
	<div id="category_description" style="margin-left: 34px;font-size: 11px;color: #787878;">{$categ_desc}</div>
{/if}
<div id="product_container" itemscope="" itemtype="http://schema.org/ItemList">
{foreach from=$wallproducts item=product}
	{assign var="tmp_cat_id" value=$product->category_id}
	{assign var="tmp" value="category_$tmp_cat_id"}
		<div itemprop="itemListElement" itemscope="" itemtype="http://schema.org/Product" id="{$product->product_id}" checkBrands="{$product->brand_id}" checkCategories="{$product->category_id}" class="ShAA_catalogItem_new category_{$product->category_id} brand_{$product->brand_id} week_{$product->week} sex_{$product->sex}" {if $product->hidden}style="display:none"{/if}>

			<div id="img_{$product->product_id}" class="imgCatalog_new">
				<a href="/products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" target="_blank" title="{$product->model} из Италии и Франции" style="border-bottom:none;">
					<img alt="{$product->model} из Италии и Франции" title="{$product->model} из Италии и Франции" src="/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{/if}{/if}" src_out="/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{/if}{/if}" src_over="/reimg/files/products/184x/{if $product->second_image}{$product->second_image}{else}{if $product->large_image}{$product->large_image}{/if}{/if}" itemprop="image" />
				</a>
			</div>


			{if $product->prop_val == 'Sale' || $product->old_price>$product->price}
				<span class="ShAA_sale"><img src="/design/default/images/sale.png" alt="Скидка" width="90" height="96" /></span>
			{/if}

			<div class="ShAA_descriptionCatalog" itemprop="description" style="margin-top:5px;">
                {if in_array($product->product_id, $cart_products)}
                    <img class="catalog_cart_icon" src="/images/cart_buy.png">
                {/if}
                <div style="float: left; width: 100%;">
                    <a href="/products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" target="_blank" itemprop="name"><span>{$product->category}</span><span itemprop="brand">&nbsp;{$product->brand}</span></a>
                </div>
                <a itemprop="offers" itemscope itemtype="http://schema.org/AggregateOffer" href="/products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" target="_blank">
                    <span style="text-decoration: line-through;" itemprop="highPrice">{$product->old_price|string_format:"%.0f"}</span>&nbsp;<i class="icon-rub"></i><br/>
                    <span style="color: #C30000;"><b itemprop="lowPrice">{$product->price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i> со скидкой {$product->sale_value|string_format:"%.0f"}% <br/></span>
                    {if $product->size != 'Р-р не задан' && $product->size != 'р-р не зад'}<span style="clear: both;">Размеры: {$product->size}</span>{/if}
                </a>
                <br/>
            </div>
            <div style="margin-left: 35px;">
                {if (($product->old_price != 0) && ($product->old_price > $product->price) && (($product->old_price-$product->price)/$product->old_price > 0.1)) }
                    {if $product->no_sale }
                        <div></div>
                    {elseif 'swd'|array_key_exists:$promos && in_array($product->brand_id, explode(",", $promos.swd->brands)) }
                        <div class="ShAA_swdIcon" style="clear: none; margin: 2px 3px 0 0;">скидка выходного дня</div>
                    {elseif $product->golden_sale }
                        <div class="ShAA_goldenPriceIcon" style="clear: none; margin: 2px 3px 0 0;">выгодное предложение</div>
                    {else}
                        <div class="ShAA_saleIcon" style="clear: none; margin: 2px 3px 0 0;">скидка</div>
                    {/if}
                {elseif ( $product->season == "14/2" || $product->season == "15/1" )}
                    <div class="ShAA_newSeasonIcon">новый сезон</div>
                {/if}

                {if ( $product->s_material )}
                    {foreach from=$product->s_material item=material}
                        <div class="ShAA_newSeasonIcon" style="clear: none; margin: 2px 3px 0 0;">{$material->name}</div>
                    {/foreach}
                {/if}
            </div>
        </div>
{/foreach}
</div>


<div id="end_anchor" class="clear"></div>
{if isset($showbrand) }
    <a href="/index.php?module=Feedback&brand_id={$showbrand->brand_id}&clear" id="feedbackbox"  onclick="{literal}rG('BRAND_SUBSCRIBE');return false;{/literal}">
        <div class="buttonNew"><span>Подписаться на обновления</span></div>
    </a>
{/if}


{literal}
<script>
    jQuery(document).ready(function() {
        jQuery('.ShAA_timeClass').timeTo({
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
