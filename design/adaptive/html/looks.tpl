{literal}
	<style type="text/css">
		div#preloader {
			margin:auto;
			margin-top:20px;
			margin-bottom:30px;
			width:180px;
		}
        .box {
            display: none !important;
            width: 17px;
            height: 15px;
            display: inline-block;
            background: url(/sizes/images/checkboxes.png);
            background-position: 0px 0px;
        }
	</style>
{/literal}
{literal}
    <style type="text/css">
        .box {
            display: none !important;
            width: 17px;
            height: 15px;
            display: inline-block;
            background: url(/sizes/images/checkboxes.png);
            background-position: 0px 0px;
        }
        span.on {
                background-position: 0px -15px;
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

	<script type="text/javascript">
		var $luxury_obj = {ldelim}
            brands: [],
            categories: [],
            materials: [],
		    offset: 120,
		    state: 0{if $filtersizes.clothes},
            csizes: []{/if}{if $filtersizes.footwear},
            fsizes: []{/if}{if $rootcateg},
            rootcateg: '{$rootcateg}'{/if}{if $rootbrand},
            rootbrand: {$rootbrand}{/if}{if $rowcount},
            rowcount: {$rowcount}{/if}{if $brand->brand_id},
            brand_id: {$brand->brand_id}{/if}{if $special_url},
            special_url: '{$special_url}'{/if}{if $manOrWoman},
            sex: {$manOrWoman}{/if}
		{rdelim};
		{literal}

        var stateObj = {filter: []};
        jQuery(document).on("click", "div.handle-enabled", function(event) {
            $luxury_obj['state'] = 1;

            var $checkbox = $(this).find(".box").find("input");
            var $checklabel = $(this).find(".checklabel");

            var $checktype = $checkbox.attr("data-type");

            if ($checkbox.attr("checked")) {

              $checklabel.parent().toggleClass("onTab");
              $checkbox.attr("checked",false).parent().toggleClass("on");
              jQuery("."+$checktype+"-clear-box").parent().addClass("onTab");
              if ($luxury_obj[$checktype].length == 0) {
                  jQuery("."+$checktype+"-clear-box").addClass("on").find("input").attr("checked",true);
              }
              index = $luxury_obj[$checktype].indexOf($checkbox.attr("name"));
              while (index != -1) {
                $luxury_obj[$checktype].splice(index, 1);
                index = $luxury_obj[$checktype].indexOf($checkbox.attr("name"));
              }
              $luxury_obj['offset']= 0;
              jQuery.post("/looks/", {json: JSON.stringify($luxury_obj)}, function(data) {
                jQuery("#product_container").fadeToggle( function() {
                  jQuery(this).html(data).fadeToggle();
                  $luxury_obj['offset']= 120;
                });
                stateObj['filter'] = $luxury_obj;
                history.replaceState(stateObj, null, this.href);
              });
            }
            else {
              $luxury_obj[$checktype].push($checkbox.attr("name"));
              $checklabel.parent().toggleClass("onTab");
              $checkbox.attr("checked",true).parent().toggleClass("on");
              jQuery("."+$checktype+"-clear-box").removeClass("on").find("input").attr("checked",false);
              jQuery("."+$checktype+"-clear-box").parent().removeClass("onTab");
              $luxury_obj['offset']= 0;
              jQuery.post("/looks/", {json: JSON.stringify($luxury_obj)}, function(data) {
                jQuery("#product_container").fadeToggle( function() {
                  jQuery(this).html(data).fadeToggle();
                  $luxury_obj['offset']= 120;
                });
                stateObj['filter'] = $luxury_obj;
                history.replaceState(stateObj, null, this.href);
              });
            }
            $luxury_obj['state'] = 0;
        });

        jQuery(document).on("click", "div.handle-clear", function(event) {
            $luxury_obj['state'] = 1;

            var $checkbox = jQuery(this).find(".box").find("input");

            $checktype = $checkbox.attr("data-type");
            $luxury_obj[$checktype] = [];

            $(this).addClass("onTab");
            $checkbox.attr("checked",true).parent().addClass("on");
            jQuery("span."+$checktype+"-regular-box").each( function(event) {

              jQuery(this).removeClass("on");
              jQuery(this).parent().removeClass("onTab");
              jQuery(this).find('input').attr("checked",false);
            });
            $luxury_obj['offset']= 0;
            jQuery.post("/looks/", {json: JSON.stringify($luxury_obj)}, function(data) {
              jQuery("#product_container").fadeToggle( function() {
                jQuery(this).html(data).fadeToggle();
                $luxury_obj['offset']= 120;
              });
            });
            $luxury_obj['state'] = 0;

            stateObj['filter'] = $luxury_obj;
            history.replaceState(stateObj, null, this.href);
        });

        function isScrolledIntoView(elem) {
            var docViewTop = jQuery(window).scrollTop();
            var docViewBottom = docViewTop + jQuery(window).height();
            var elemTop = jQuery(elem).offset().top-1640;
            return (elemTop <= docViewBottom);
        }

        if(history.state) {
            if(history.state['page']>0) {
                for(var countLoad = 0; countLoad < history.state['page']; countLoad++) {
                    if ($luxury_obj['offset'] < $luxury_obj['rowcount']) {
                        loadProducts();
                        $luxury_obj['offset'] = $luxury_obj['offset'] + 60;
                    }
                }
                $luxury_obj['offset'] = $luxury_obj['offset'] - history.state['page']*60;
            }

            if(history.state['filter']) {
                $luxury_obj = history.state['filter'];
            }

        }

        var stateObj = {page: 0};
        function loadProducts() {
           jQuery('#product_container').append('<div id="preloader"><img src="/images/preload.gif" alt="" /><div style="width:680px;margin:auto;">Загрузка товаров</div></div>');
           jQuery.post("/looks/", {json: JSON.stringify($luxury_obj)}, function(data) {
                jQuery('#preloader').remove();
                jQuery("#product_container").append(data);
                $luxury_obj['state'] = 0;
                $luxury_obj['offset'] = $luxury_obj['offset'] + 60;
                jQuery(".owl-carousel").owlCarousel({
                    lazyLoad: true,
                    navigation: false,
                    singleItem: true
                });
                stateObj['page']++;
                history.replaceState(stateObj, null, this.href);
            });
        }
		jQuery(document).ready(function() {
		    function isScrolledIntoView(elem) {
		        var docViewTop = jQuery(window).scrollTop();
		        var docViewBottom = docViewTop + jQuery(window).height();
		        var elemTop = jQuery(elem).offset().top-1640;
		        return (elemTop <= docViewBottom);
		    }

		    var floor = jQuery('.footer');
		    jQuery(window).scroll(function() {
		        if(isScrolledIntoView(floor) && $luxury_obj['state'] == 0 && $luxury_obj['rowcount'] > 120) {
		            $luxury_obj['state'] = 1;
		            if ($luxury_obj['offset'] < $luxury_obj['rowcount']) {
		                jQuery('#product_container').append('<div id="preloader"><img src="/images/preload.gif" alt="" /><div style="width:680px;margin:auto;">Загрузка товаров</div></div>');
		                jQuery.post("/looks/", {json: JSON.stringify($luxury_obj)}, function(data) {
		                    jQuery('#preloader').remove();
		                    jQuery("#product_container").append(data);
		                    $luxury_obj['state'] = 0;
		                    $luxury_obj['offset'] = $luxury_obj['offset'] + 60;
		                });
		            }
		        }
		    });

		});
	</script>
{/literal}

    <div style="clear: both; width: 100%; margin: 24px 0 0; float: left; display: none;" id="catalog_left">
        <div class="checks" style="margin: 6px 0px 0 0;">
            {if (($rootcateg != 38) && ($rootcateg != 4))}
                <div class="formtitle" style="display: none;">
                    <a href="#" style="border:none;" onclick="$('#check-sizes').slideToggle(500); $('#tblb').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
                        <span id="tblb" class="slide_button_p" style="float:left;margin:5px 6px 6px 6px;"></span>
                        {if $language=='eng'}Sizes{else}Размеры{/if}
                    </a>
                </div>
                <div id="check-sizes" class="formtitle">
                    {if (empty($filtersizes.clothes) || empty($filtersizes.footwear))}
                        <div class="onTab handle-clear">
                            <span class="box on">
                                <input checked="checked" data-type="brands" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                            </span>
                            <span class="">{if $language=='eng'} - Europe (EU)Sizes{else}Размеры - Europe (EU){/if}</span>
                        </div>
                    {/if}
                    <div class="checkline"></div>
                    <div id="list-csizes" class="list">
                        {if !empty($filtersizes.clothes)}
                            {if !empty($filtersizes.footwear)}
                                <div class="onTab handle-clear">
                                    <span class="box on csizes-clear-box">
                                        <input checked="checked" data-type="csizes" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                                    </span>
                                    <span class="">{if $language == 'eng'}Clothes sizes - Europe (EU){else}Размеры одежды - Европа (EU){/if} </span>
                                </div>
                            {/if}
                            <div class="list">
                                {foreach from=$filtersizes.clothes item=csize}
                                    {if $csize !=''}
                                        <div class="handle handle-enabled">
                                            <span class="box csizes-regular-box">
                                                <input data-type="csizes" type="checkbox" name="{$csize->size_id}" style="display:none;" autocomplete="off" />
                                            </span>
                                            <span class="checklabel">{if ($csize == "Р-р не задан") || ($csize == "Р-р не зад") || ($csize == "р-р не зад")}{if $language == 'eng'}Without size{else}Без размера{/if}{else}{$csize->size}{/if}</span>
                                        </div>
                                    {/if}
                                {/foreach}
                            </div>
                        {/if}
                    </div>
                    <div id="list-fsizes" class="list">
                        {if !empty($filtersizes.footwear)}
                            {if !empty($filtersizes.clothes)}
                                <div class="onTab handle-clear">
                                    <span class="box on fsizes-clear-box">
                                        <input checked="checked" data-type="fsizes" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                                    </span>
                                    <span class="">{if $language == 'eng'}Shoe sizes - Europe (EU){else}Размеры обуви - Европа (EU){/if}</span>
                                </div>
                            {/if}
                            <div class="list">
                                {foreach from=$filtersizes.footwear item=csize}
                                    {if $csize !=''}
                                        <div class="handle handle-enabled">
                                            <span class="box fsizes-regular-box">
                                                <input data-type="fsizes" type="checkbox" name="{$csize->size_id}" style="display:none;" autocomplete="off" />
                                            </span>
                                            <span class="checklabel">{if ($csize == "Р-р не задан") || ($csize == "Р-р не зад") || ($csize == "р-р не зад")}Без размера{else}{$csize->size}{/if}</span>
                                        </div>
                                    {/if}
                                {/foreach}
                            </div>
                        {/if}
                    </div>
                </div>
            {/if}

            <div>
                <div class="formtitle" style="display: none;">
                    <a href="#" style="border:none;" onclick="$('#check-categories').slideToggle(500); $('#tblc').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
                        <span id="tblc" class="{if isset($showbrand)}slide_button_m{else}slide_button_p{/if}" style="float:left;margin:5px 6px 6px 6px;"></span>
                        {if $language == 'eng'}Category{else}Категории{/if}
                    </a>
                </div>
                <div id="check-categories" class="formtitle">
                    <div class="onTab handle-clear">
                        <span class="box on categories-clear-box">
                            <input checked="checked" data-type="categories" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                        </span>
                        {if $language == 'eng'}Category{else}Категории{/if}
                    </div>
                    <div class="checkline"></div>

                    <div id="list-categories" class="list">
                        {foreach from=$filtercategories item=ccateg}
                            {if $ccateg->name != ''}
                                <div class="handle handle-enabled">
                                    <span class="box categories-regular-box">
                                        <input data-type="categories" type="checkbox" name="{$ccateg->id}" style="display:none;" autocomplete="off" />
                                    </span>
                                    <span class="checklabel">{$ccateg->name}</span>
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                </div>
            </div>
            {if !isset($showbrand) && !isset($showgood)}
                <div class="formtitle" style="display: none;">
                    <a href="#" style="border:none;" onclick="$('#check-brands').slideToggle(500); $('#tbla').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
                        <span id="tbla" class="slide_button_m" style="float:left;margin:5px 6px 6px 6px;"></span>
                        {if $language == 'eng'}Brands{else}Бренды{/if}
                    </a>
                </div>
                <div id="check-brands" class="formtitle" style="display:block;">
                    <div class="onTab handle-clear">
                        <span class="box on brands-clear-box">
                            <input checked="checked" data-type="brands" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                        </span>
                        <span class="">{if $language == 'eng'}Brands{else}Бренды{/if}</span>
                    </div>
                    <div class="checkline"></div>
                    <div id="list-brands" class="list">
                        {foreach from=$filterbrands item=cbrand}
                            {if $cbrand->name !=''}
                                <div class="handle handle-enabled">
                                    <span class="box brands-regular-box">
                                        <input data-type="brands" type="checkbox" name="{$cbrand->id}" style="display:none;" autocomplete="off" />
                                    </span>
                                    <span class="checklabel">{$cbrand->name|upper|replace:'&':'&amp;'}</span>
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                </div>
            {/if}
        </div>
    </div>
<div class="centerRightContentCatalog_new ShAA_looksPage">
	<h1>{$header|default:'Образы от стилиста Лакшери Store'}</h1>
    {if $description || $brand}
		<div class="brandDescription mobileBrandDescr">
			<p>
        {if $language != 'eng'}
                {if $description}
                    {$description}
                {elseif $brand->description_looks}
                    {$brand->description_looks}
                {else}
                    {$brand->description}
                {/if}
        {/if}
            </p>
		</div>
	{/if}
	<div id="product_container">
		{foreach from=$looks item=look}
		    <div class="ShAA_catalogItem_new">
				<div class="imgCatalog_new look_image">
					<a href="/look/{$look->id}/" target="_blank" style="border-bottom:none;">
						<img src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/340x/{$look->image}">
					</a>
				</div>

				<div class="ShAA_descriptionCatalog" style="margin-top:5px;height:35px;">
					<a href="/look/{$look->id}/" target="_blank">
						{foreach from=$look->products item=product name=products}
							{$product->model}{if !$smarty.foreach.products.last}, {/if}
						{/foreach}
					</a>
					<br>
				</div>
			</div>
		{/foreach}
	</div>
</div>
