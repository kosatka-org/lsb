{if $oc_ordered && $smarty.session.user->group_id < 2 && $config->enviroment == 'live'}
{literal}
    <script>
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'transactionId': 'c{/literal}{$oc_ordered->id}{literal}', // Required
                'transactionAffiliation': 'Luxury Store',
                "transactionChannel": "adm", // параметр дедупликации (для Admitad)
                "transactionAction": "1",    // код целевого действия (для Admitad)
                'transactionTax': '{/literal}{if $new_user_order}0{else}1{/if}{literal}',
                'transactionTotal': {/literal}{$oc_ordered_product->price}{literal}, // Required
                'transactionShipping': 'undefined',
                'transactionProducts': [
                    {
                        'sku': '{/literal}{$oc_ordered_product->sku}{literal}', // Required
                        'name': '{/literal}{$oc_ordered_product->model}{literal}', // Required
                        'category': '{/literal}{$oc_ordered_product->brand_name}{literal}',
                        'price': {/literal}{$oc_ordered_product->price}{literal}, // Required
                        "priceCurrency": "RUB",  // код валюты ISO-4217 alfa-3 (для Admitad)
                        "tariff": "1",           // код тарифа (для Admitad)
                        'quantity': 1 // Required
                    }
                ]
            });
        }
        {/literal}{if $oc_ordered_product->cat_enabled != 0}{literal}
        //Criteo dataLayer
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            var product_list = [];
            product_list.push(
                {
                    'id': '{/literal}{$oc_ordered_product->barcode}{literal}',
                    'price': {/literal}{$oc_ordered_product->price}{literal},
                    'quantity': 1
                }
            );
            dataLayer.push({
                'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
                'PageType': 'TransactionPage',
                'OrderProducts' : product_list,
                'CriteoTransactionId': '{/literal}c{$oc_ordered->id}{literal}'
            })
        }
        {/literal}{/if}{literal}

        {/literal}var brand_name = "{$oc_ordered_product->brand_name}".replace(/'/g, "`"),
                name = '{$oc_ordered_product->model}'.replace(/'/g, "`");{literal}
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
          dataLayer.push({
             'ecommerce': {
               'currencyCode': 'RUB',
               'purchase': {
                 'actionField': {
                   'id': 'c{/literal}{$oc_ordered->id}{literal}',
                   'affiliation': 'Luxury Store',
                   'revenue': "{/literal}{$oc_ordered_product->price|number_format:0:'':''}{literal}",
                   'tax': '{/literal}{if $new_user_order}0{else}1{/if}{literal}',
                   'coupon': '{/literal}{$smarty.session.user->personal_discount}{literal}',
                   'option': 'special_order'
                 },
                 'products': [{
                    "id":       "{/literal}{$oc_ordered_product->product_id}{literal}",
                    "name":     name,
                    "price":    "{/literal}{$oc_ordered_product->price|number_format:0:'':''}{literal}",
                    "brand":    brand_name.toUpperCase(),
                    "category": "{/literal}{$oc_ordered_product->category}{literal}",
                    "variant":  "{/literal}{$oc_ordered_product->sku}{literal}",
                    "quantity": 1
                 }]
               }
             },
           'event': 'gtm-ee-event',
           'gtm-ee-event-category': 'Enhanced Ecommerce',
           'gtm-ee-event-action': 'Purchase',
           'gtm-ee-event-non-interaction': false,
          });
          dataLayer.push({
           'ecommerce': {
             'currencyCode': 'RUB',
             'checkout': {
               'actionField': {'step': 3,'option': 'one_click'},
               'products': [{
                  "id":       "{/literal}{$oc_ordered_product->product_id}{literal}",
                  "name":     name,
                  "price":    "{/literal}{$oc_ordered_product->price|number_format:0:'':''}{literal}",
                  "brand":    brand_name.toUpperCase(),
                  "category": "{/literal}{$oc_ordered_product->category}{literal}",
                  "variant":  "{/literal}{$oc_ordered_product->sku}{literal}",
                  "quantity": 1
                }]
             }
           },
           'event': 'gtm-ee-event',
           'gtm-ee-event-category': 'Enhanced Ecommerce',
           'gtm-ee-event-action': 'Checkout Step 2',
           'gtm-ee-event-non-interaction': false,
          });
          console.log(dataLayer);
        }
    });
    </script>
{/literal}
{/if}

{if $only_products}

{else}
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
<script type="text/javascript" src="/jscript/owl.carousel.js"></script>
<link media="all" href="/jscript/owl.carousel.css" rel="stylesheet" type="text/css" />
<link media="all" href="/jscript/owl.theme.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
var $luxury_obj = {ldelim}
    brands: [],
    categories: [],
    materials: []
    {if $filtersizes.clothes}, csizes: []{/if}
    {if $filtersizes.footwear}, fsizes: []{/if}
    {if $rootcateg}, rootcateg: '{$rootcateg}'{/if}
    {if $rootbrand}, rootbrand: {$rootbrand}{/if}
    {if $rowcount}, rowcount: {$rowcount}{/if}
    {if $manOrWoman}, sex: {$manOrWoman}{/if}
    {if $special}, special: {$special}{/if}
    {if $form_search}, form_search: '{$form_search}'{/if},
    offset: 30,
    state: 0
{rdelim};

var limit_ovr = {if $limit_ovr == 1}1{else}0{/if}
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
    var top = 101;
    jQuery(window).scroll(function () {
        if( jQuery(this).scrollTop() > top) {
            jQuery(".mainMenu").css({"position": "fixed", "top": "0" });
        }
        if( jQuery(this).scrollTop() <= top) {
            jQuery(".mainMenu").css("position", "relative");
        }
    });

    var stateObj = {filter: []};
    jQuery(document).on("click", "div.handle-enabled", function(event) {
        setTimeout(() => {//смена картинки для тестового товара
            $('.ShAA_catalogItem_new').find('img').error(function(){
                $(this).attr('src', '/images/noimg.png');
            });
        }, 1000);
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
          $luxury_obj[$checktype].splice(index, 1);
          $luxury_obj['offset']= 0;
          jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
            jQuery("#product_container").fadeToggle( function() {
              jQuery(this).html(data).fadeToggle();
              $luxury_obj['offset']= 30;
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
          jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
            jQuery("#product_container").fadeToggle( function() {
              jQuery(this).html(data).fadeToggle();
              $luxury_obj['offset']= 30;
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
        jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
          jQuery("#product_container").fadeToggle( function() {
            jQuery(this).html(data).fadeToggle();
            $luxury_obj['offset']= 30;
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
//  закоментировал Паша 10.06.19 чтобы не передавать данные фильтров при перезагрузке
//     if(history.state) {
//         if(history.state['page']>0) {
//             for(var countLoad = 0; countLoad < history.state['page']; countLoad++) {
//                 if ($luxury_obj['offset'] < $luxury_obj['rowcount']) {
//                     loadProducts();
//                     $luxury_obj['offset'] = $luxury_obj['offset'] + 30;
//                 }
//             }
//             $luxury_obj['offset'] = $luxury_obj['offset'] - history.state['page']*30;
//         }

//         if(history.state['filter']) {
//             $luxury_obj = history.state['filter'];
//             console.log('!!!!!!' ,history.state['filter'])

// /*
//             jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
//                 jQuery("#product_container").fadeToggle( function() {
//                   jQuery(this).html(data).fadeToggle();
//                   $luxury_obj['offset']= 60;
//                 });
//             });

//             $.each($luxury_obj, function(index, value){
//                 console.log("INDEX: " + index + " VALUE: " + value);
//             });
// */
//         }

//     }

    var stateObj = {page: 0};
    function loadProducts() {
       jQuery('#product_container').append('<div id="preloader"><img src="/images/preload.gif" alt="" /><div style="width:100%;margin:auto;">Загрузка товаров</div></div>');
       jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function(data) {
            jQuery('#preloader').remove();
            jQuery("#product_container").append(data);
            $luxury_obj['state'] = 0;
            $luxury_obj['offset'] = $luxury_obj['offset'] + 30;
            jQuery(".owl-carousel").owlCarousel({
                lazyLoad: true,
                navigation: false,
                singleItem: true
            });
            stateObj['page']++;
            history.replaceState(stateObj, null, this.href);
        });
    }
    var floor = jQuery('.footer');
    jQuery(window).scroll(function() {
        if(isScrolledIntoView(floor) && $luxury_obj['state'] == 0 && $luxury_obj['rowcount'] > 30 && limit_ovr == 0) {
            $luxury_obj['state'] = 1;
            if ($luxury_obj['offset'] < $luxury_obj['rowcount']) {
                loadProducts();
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
    jQuery(".owl-carousel").owlCarousel({
        lazyLoad: true,
        navigation: false,
        singleItem: true
    });
    $('.ShAA_catalogItem_new').find('img').error(function(){
        $(this).attr('src', '/images/noimg.png');
    });

});
</script>
<style type="text/css" >
    .owl-carousel .item img{
      display: inline;
      width: 90%;
      height: auto;
    }
</style>
{/literal}
<div style="clear: both; width: 100%; margin: 24px 0 0; float: left; display: none;" id="catalog_left">
    <div class="checks" style="margin: 6px 0px 0 0;">
    {if $is_admin}<div style="margin-bottom:20px;">Создать подборку из выбранных товаров<form action="/admin/index.php?section=Special" method="POST" name="article" />
        <label>Только со скидкой</label>
        <input id="sp_sale" type="checkbox" name="sp_sale" value="1" />
        <input id="sp_params" type="hidden" name="params" value="" />
        <input id="sp_sex" type="hidden" name="gender" value="0" />
        <input id="sp_name" type="hidden" name="name" value="Новая подборка" />
        <input id="sp_desc" type="hidden" name="description" value="" />
        <input id="sp_mdesc" type="hidden" name="meta_description" value="" />
        <input id="sp_mtitle" type="hidden" name="meta_title" value="" />
        <input id="sp_kwrds" type="hidden" name="meta_keywords" value="" />
        <input type="submit" value="Создать" /></form></div>
    {/if}

        {if (($rootcateg != 38) && ($rootcateg != 4))}
            <div class="formtitle" style="display: none;">
                <a href="#" style="border:none;" onclick="$('#check-sizes').slideToggle(500); $('#tblb').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
                    <span id="tblb" class="slide_button_p" style="float:left;margin:5px 6px 6px 6px;"></span>
                    {if $language == 'eng'}Sizes{else}Размеры{/if}
                </a>
            </div>
            <div id="check-sizes" class="formtitle">
                {if (empty($filtersizes.clothes) || empty($filtersizes.footwear))}
                    <div class="onTab handle-clear">
                        <span class="box on">
                            <input checked="checked" data-type="brands" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                        </span>
                        <span class="">{if $language == 'eng'}Sizes{else}Размеры{/if}</span>
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
                                <span class="">{if $language == 'eng'}Clothes sizes{else}Размеры одежды{/if} </span>
                            </div>
                        {/if}
                        <div class="list">
                            {foreach from=$filtersizes.clothes item=csize}
                                {if $csize !=''}
                                    <div class="handle handle-enabled">
                                        <span class="box csizes-regular-box">
                                            <input data-type="csizes" type="checkbox" name="{$csize}" style="display:none;" autocomplete="off" />
                                        </span>
                                        <span class="checklabel">{if ($csize == "Р-р не задан") || ($csize == "Р-р не зад") || ($csize == "р-р не зад") || ($csize == "не задан")}{if $language == 'eng'}Without size{else}Без размера{/if}{else}{$csize}{/if}</span>
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
                                <span class="">{if $language == 'eng'}Shoe sizes{else}Размеры обуви{/if}</span>
                            </div>
                        {/if}
                        <div class="list">
                            {foreach from=$filtersizes.footwear item=csize}
                                {if $csize !=''}
                                    <div class="handle handle-enabled">
                                        <span class="box fsizes-regular-box">
                                            <input data-type="fsizes" type="checkbox" name="{$csize}" style="display:none;" autocomplete="off" />
                                        </span>
                                        <span class="checklabel">{if ($csize == "Р-р не задан") || ($csize == "Р-р не зад") || ($csize == "р-р не зад")}{if $language == 'eng'}Without size{else}Без размера{/if}{else}{$csize}{/if}</span>
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

        {if $furs}
            <div class="formtitle" style="display: none;">
                <a href="#" style="border:none;" onclick="$('#check-materials').slideToggle(500); $('#tblc').toggleClass('slide_button_m').toggleClass('slide_button_p'); return false;">
                    <span id="tblc" class="{if isset($showbrand)}slide_button_m{else}slide_button_p{/if}" style="float:left;margin:5px 6px 6px 6px;"></span>
                    {if $language == 'eng'}Materials{else}Материалы{/if}
                </a>
            </div>
            <div id="check-materials" class="formtitle">
                <div class="onTab handle-clear">
                    <span class="box on materials-clear-box">
                        <input checked="checked" data-type="materials" type="checkbox" name="clear" style="display:none;" autocomplete="off" />
                    </span>
                    {if $language == 'eng'}Materials{else}Материалы{/if}
                </div>
                <div class="checkline"></div>

                <div id="list-materials" class="list">
                    {foreach from=$filtermaterials item=cmat}
                        {if $cmat->name != ''}
                            <div class="handle handle-enabled">
                                <span class="box materials-regular-box">
                                    <input data-type="materials" type="checkbox" name="{$cmat->material_id}" style="display:none;" autocomplete="off" />
                                </span>
                                <span class="checklabel">{$cmat->name}</span>
                            </div>
                        {/if}
                    {/foreach}
                </div>
            </div>
        {/if}

    </div>
</div>
<div class="centerRightContentCatalog_new">
{/if}<!-- end if only_products -->
<div class="caption_container">
{if isset($showbrand) }
    {literal}
        <script type="text/javascript">
            jQuery('.logoOnline').html('<a href="/"><img style="margin: 0;" alt="{/literal}{$showbrand->name|escape}{literal}" title="{/literal}{$showbrand->name|escape}{literal}" src="//lsboutique.ru/files/brands/{/literal}{$showbrand->image}{literal}" /></a>');
        </script>
    {/literal}
    <div class="centerRightContent" style="width:100%;">
        <div class="brandDescription mobileBrandDescr">
            {if $showbrand->video}
                <div style=" margin: 0 13% 12px 13%; width: 74%;">
                    <iframe frameborder="0" height="259" style="width: 100%" src="{$showbrand->video|replace:'watch?v=':'embed/'}?rel=0&amp;controls=1"></iframe>
                </div>
            {/if}
            <div>
                <div>
                    {if $showbrand->name}
                        <h2 style="margin-top: -4px; text-transform: uppercase;">{$showbrand->name}</h2>
                    {elseif $showbrand->title_descr}
						<h2 style="margin-top: -4px; text-transform: uppercase;">{$showbrand->title_descr}</h2>
					{/if}
                </div>
                {if $language != 'eng'}
                  {if $manOrWoman == '1' && !empty($showbrand->description_m)}
                      {$showbrand->description_m}
                  {elseif $manOrWoman == '2' && !empty($showbrand->description_w)}
                      {$showbrand->description_w}
                  {else}
                      {$showbrand->description}
                  {/if}
                {/if}
                {if $showbrand->video}
                    <a href="/subscription/{$showbrand->brand_id}/" id="feedbackbox"  onclick="{literal}rG('BRAND_SUBSCRIBE');{/literal}">
                        <div class="buttonNew" style="width: 30%; clear: none;"><span>{if $language=='eng'}Subscribe to updates{else}Подписаться на обновления{/if}</span></div>
                    </a>
                {/if}
            </div>
        </div>
    </div>
{/if}

{if isset($special) }
    <div class="centerRightContent">
        <h1>{if $language == 'eng'}{$special_fields->eng_name}{else}{$special_fields->name}{/if}</b></h1>
<!-- Breadcumbs для подборок -->
{if $special_fields}
		<div itemscope="" itemtype="http://schema.org/BreadcrumbList" id="breadcrumbs" class="breadCrumbs">
			<span itemscope="" itemprop="itemListElement" itemtype="http://schema.org/ListItem">
				<a rel="nofollow" itemprop="item" title="Главная страница" href="/">
					<span itemprop="name">Главная страница</span>
					<meta itemprop="position" content="1">
				</a>
			</span>
			{if $special_fields->gender != '0'}
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="{if $special_fields->gender == '1'}Для него {else}Для неё{/if}" href="/?sex={$special_fields->gender}">
					<span itemprop="name">{if $special_fields->gender == '1'}Для него {else}Для неё{/if}</span>
					<meta itemprop="position" content="2">
				</a>
			{/if}
			{if $brand_for_special}
				{literal}
					<script type="text/javascript">
						jQuery('.logoOnline').html('<a href="/brands/{/literal}{$brand_for_special->url}{literal}/?sex={/literal}{$special_fields->gender}{literal}"><img style="margin: 0;" alt="{/literal}{$brand_for_special->name|escape}{literal}" title="{/literal}{$brand_for_special->name|escape}{literal}" src="//lsboutique.ru/files/brands/{/literal}{$brand_for_special->image}{literal}" /></a>');
					</script>
				{/literal}
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="{$brand_for_special->name}" href="/brands/{$brand_for_special->url}/?sex={$special_fields->gender}">
					<span itemprop="name">{$brand_for_special->name}</span>
					<meta itemprop="position" content="3">
				</a>
			{/if}
			<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
			<a itemprop="item" title="{$special_fields->name}" href="/specials/{$special_fields->url}/">
				<span itemprop="name">{$special_fields->name}</span>
				<meta itemprop="position" content="4">
			</a>
		</div>
{/if}
<!-- END Breadcumbs для подборок -->
        <div class="brandDescription mobileBrandDescr">
            {if $special_fields->description && $language != 'eng'}{$special_fields->description}{/if}
        </div>
    </div>
{/if}
{if !$oc_ordered && $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
{if $criteo_p_list }
<script>
//Criteo dataLayer
    {literal}
        jQuery(document).ready(function() {
            if (typeof(dataLayer) !== 'undefined' && dataLayer) {
                dataLayer.push({
                    'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
                    'PageType': 'CatalogPage',
                    'ProductIDList' : [{/literal}{$criteo_p_list}{literal}]
                })
            }
        });
    {/literal}
</script>
{/if}
<script>
//More dataLayer
    {literal}
    var product_list = [];
    {/literal}{foreach from=$products item=product}
        {if !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}{literal}
            product_list.push({$product->barcode});
    {/literal}{/if}{/foreach}{literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'ProductPrice' : '',
                'productID' : product_list,
                'MT_PageType': 'category'
            })
        }
    });
    {/literal}
</script>
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

    jQuery(document).on("click", "#change_view", function(event) {
        var txt =  jQuery("#change_view").text();
        if(jQuery.cookie('language') === 'eng'){
          jQuery("#change_view").html(txt == "Total look" ? "View" : "Total look");
        }else{
          jQuery("#change_view").html(txt == "образ" ? "вид" :  "образ");
        }
        jQuery(".imgCatalog_new").find("img").each(function(i,elem) {
            s = jQuery(elem);
            over = s.attr("src_over");
            out = s.attr("src_out");
            s.attr("src",over);
            s.attr("src_over",out);
            s.attr("src_out",over);
        });
    });
</script>
{/literal}

{if $showgood}
    <h1>{$showgood->title}</h1>
    <div id="category_description" style="font-size: 14px;color: #000;" class="mobileBrandDescr">{if $showgood->text && $language != 'eng'}{$showgood->text}{/if}</div>
{elseif $categ_desc}
    <div style="width: 100%;">
        <h1 {if (!$is_iphone & !$is_ipod & !$is_ipad)} class="ShAA_catNameStyles" {/if}>{$categ_name}</h1>
        {if (!$is_iphone & !$is_ipod & !$is_ipad)}
            <a id="change_view" class="ShAA_changeViewButton" onclick="{literal}rG('LOOK_VIEW');{/literal}">{if $language=='eng'}Total look{else}образ{/if}</a>
        {/if}
    </div>
    <div id="category_description" style="font-size: 14px;color: #000; display: none;" class="mobileBrandDescr">{if $categ_desc && $language != 'eng'}{$categ_desc}{/if}</div>
{else}
    {if (!$is_iphone & !$is_ipod & !$is_ipad)}
        <div style="width: 100%;">
            <a id="change_view" class="ShAA_changeViewButton" onclick="{literal}rG('LOOK_VIEW');{/literal}">{if $language=='eng'}look{else}образ{/if}</a>
        </div>
    {/if}
{/if}
</div>
<div id="product_container" itemscope="" itemtype="http://schema.org/ItemList">
{foreach from=$wallproducts item=product}
    {assign var="tmp_cat_id" value=$product->category_id}
    {assign var="tmp" value="category_$tmp_cat_id"}
        <div itemprop="itemListElement" itemscope="" itemtype="http://schema.org/Product" id="main_{$product->product_id}" checkBrands="{$product->brand_id}" checkCategories="{$product->category_id}" class="ShAA_catalogItem_new category_{$product->category_id} brand_{$product->brand_id} week_{$product->week} sex_{$product->sex}" data-sku="{$product->sku}" {if $product->hidden}style="display:none"{/if}>

            <div id="img_main_{$product->product_id}" class="imgCatalog_new" {if ($is_iphone || $is_ipod || $is_ipad)}style="display: block !important;"{/if}>
                <a target="blank" name="{$product->product_id}" href="/{if $big_size}b{/if}products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" title="{if $language=='eng'}{$product->group_name} {$product->brand}{else}{$product->model} из Италии и Франции{/if}" style="border-bottom:none;">
                    <img onError="this.onerror=null;this.src='/images/noimg.png';" alt="{$product->model} из Италии и Франции" title="{if $language=='eng'}{$product->group_name} {$product->brand}{else}{$product->model} из Италии и Франции{/if}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/340x/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{/if}{/if}" {if (!$is_iphone & !$is_ipod & !$is_ipad)} src_out="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/340x/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{/if}{/if}" src_over="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/340x/{if $product->second_image}{$product->second_image}{else}{if $product->large_image}{$product->large_image}{/if}{/if}"{/if} itemprop="image" />
                </a>
            </div>
{if (!$is_iphone & !$is_ipod & !$is_ipad)}
            <div id="owl-demo_main_{$product->product_id}" class="owl-carousel">
                <div class="item">
                    <a target="blank" href="/{if $big_size}b{/if}products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" title="{if $language=='eng'}{$product->group_name} {$product->brand}{else}{$product->model} из Италии и Франции{/if}" style="border-bottom:none;">
                        <img class="lazyOwl" src="" data-src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/340x/{if $product->large_image}{$product->large_image}{else}{if $product->second_image}{$product->second_image}{/if}{/if}" alt="{$product->img_desc}" />
                    </a>
                </div>
                <div class="item">
                    <a target="blank" href="/{if $big_size}b{/if}products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" title="{if $language=='eng'}{$product->group_name} {$product->brand}{else}{$product->model} из Италии и Франции{/if}" style="border-bottom:none;">
                        <img class="lazyOwl" src="" data-src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/340x/{if $product->second_image}{$product->second_image}{else}{if $product->large_image}{$product->large_image}{/if}{/if}" alt="" />
                    </a>
                </div>
            </div>
{/if}

            <div class="ShAA_descriptionCatalog" itemprop="description" style="margin-top:5px;min-height:35px;">
                {if in_array($product->product_id, $cart_products)}
                    <img class="catalog_cart_icon" src="/images/cart_buy.png" alt="" />
                {/if}
                <div style="float: left; width: 100%;">
                    <a target="blank" href="/{if $big_size}b{/if}products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" target="_blank"><span itemprop="name" class="prod_name">{$product->group_name}</span>&nbsp;<span  itemprop="brand" class="prod_brand">{$product->brand}</span>{if $product->model_full}</br><span>{$product->model_full}</span>{/if}</a>
                </div>
                <span class="prod_categ" data-categ="{$product->category}"></span>
                <a target="blank" itemprop="offers" itemscope itemtype="http://schema.org/AggregateOffer" href="/{if $big_size}b{/if}products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}" target="_blank">
                    {if $product->can_buy_from_site}

                      <span style="font-size:12px;">
                        {if $product->prices.first_price}
                          {if $product->show_delta}
                          <span class="price rub" style="position: relative; width: auto; line-height: 1em !important; display: inline-block;">
							<span itemprop="highPrice" class="prod_price">{$product->prices.first_price|string_format:"%.0f"}</span><span class="ShAA_lineThrough"></span>&nbsp;<i class="icon-rub"></i> </span>

                          {foreach from=$cat_currencies item=currency}
                            {assign var="c_name" value="first_price_`$currency->code`"}
                            <span class="price {$currency->code}" style="display:none; position: relative; width: auto; line-height: 1em !important;"><span>{$product->prices.$c_name|string_format:"%.0f"}</span><span class="ShAA_lineThrough"></span>&nbsp;<b>{$currency->sign}</b></span>
                          {/foreach}
                          {/if}
                        {else}
                          <span class="price rub"><span itemprop="highPrice" class="prod_price client_price">{$product->prices.price|string_format:"%.0f"}</span>&nbsp;<i class="icon-rub"></i></span>
                          {foreach from=$cat_currencies item=currency}
                            {assign var="c_name" value="price_`$currency->code`"}
                            <span class="price {$currency->code}" style="display:none;">{$product->prices.$c_name|string_format:"%.0f"}&nbsp;<b>{$currency->sign}</b></span>
                          {/foreach}
                        {/if}
                      </span><br/>

                      {if $product->prices.sale_price.price > 0 }
                        <span style="font-size:12px;">
                          <span class="price rub"><b style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}" itemprop="lowPrice"><span class="client_price">{$product->prices.sale_price.price|string_format:"%.0f"}</span></b>&nbsp;<i class="icon-rub"></i></span>
                          {foreach from=$cat_currencies item=currency}
                            {assign var="c_name" value="price_`$currency->code`"}
                            <span class="price {$currency->code}" style="display:none;"><span style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}"><b>{$product->prices.sale_price.$c_name|string_format:"%.0f"}</b></span>&nbsp;<b>{$currency->sign}</b></span>
                          {/foreach}
                          {* {if $language=='eng'}Price with discount{else}Цена со скидкой{/if} *}
                        </span><br/>
                      {/if}

                      {if $product->prices.vip_price.price > 0}
                        <span style="font-size:12px;">
                          <span class="price rub"><b itemprop="lowPrice"><span class="client_price">{$product->prices.vip_price.price|string_format:"%.0f"}</span></b>&nbsp;<i class="icon-rub"></i> </span>
                          {foreach from=$cat_currencies item=currency}
                            {assign var="c_name" value="price_`$currency->code`"}
                            <span class="price {$currency->code}" style="display:none;"><b>{$product->prices.vip_price.$c_name|string_format:"%.0f"}</b>&nbsp;<b>{$currency->sign}</b></span>
                          {/foreach}
                          {* {if $language=='eng'}<b>VIP discount</b>{else}<b>VIP скидка</b>{/if} *}
                        </span><br/>
                      {/if}

                    {/if}
                    {if $product->size && $product->size != 'Р-р не задан' && $product->size != 'р-р не зад' && $product->size != 'не задан' && !$product->hide_sizes}<span style="clear: both;">{if $language=='eng'}Sizes{else}Размеры{/if}: <span class="prod_sizes">{$product->size}</span></span>{/if}
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
                    <div class="ShAA_swdIcon">{if $language=='eng'}weekend discount{else}скидка выходного дня{/if}</div>
                {elseif $product->golden_sale }
                    <div class="ShAA_goldenPriceIcon">{if $language=='eng'}golden sale{else}выгодное предложение{/if}</div>
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
{if ( $product->s_material )}
    {foreach from=$product->s_material item=material}
        <div class="ShAA_newSeasonIcon" {if ( $material->description && $language != 'eng' )} data-tooltip="{$material->description}" style="cursor: help;" {/if}>{$material->name}</div>
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
 <div class="ShAA_descriptionCatalog" style="margin: 5px 0 0 0; display: none;">
    <div style="clear: both;">{if $language=='eng'}Time left{else}Осталось{/if}: <span class="ShAA_timeClass"></span></div>
</div>
{/if}
        </div>
{/foreach}
</div>
<div id="end_anchor" class="clear"></div>
<noscript>
<!-- Постраничная навигация для отключенного js/-->
	{if $pages_num>1}
	<div style="clear:both;"></div>
	<script type="text/javascript" src="js/ctrlnavigate.js"></script>
	<div id="paging">

	  {if $current_page>1}
	  <a id="PrevLink" href="?page={$current_page-1}" class="back">←&nbsp;{if $language=='eng'}back{else}назад{/if}</a>
	  {/if}

	  {section name=pages loop=$pages_num}
	  <a {if $smarty.section.pages.index==($current_page-1)}class="current_page" {/if}href="?page={$smarty.section.pages.index+1}">{$smarty.section.pages.index+1}</a>
	  {/section}

	  {if $current_page<$pages_num}
	  <a id="NextLink" href="?page={$current_page+1}" class="next">{if $language=='eng'}forth{else}вперед{/if}&nbsp;→</a>
	  {/if}

	</div>
	{/if}
	<!-- Постраничная навигация #End /-->
</noscript>
{if isset($showbrand) }
    <a href="/subscription/{$showbrand->brand_id}/" id="feedbackbox"  onclick="{literal}rG('BRAND_SUBSCRIBE');{/literal}">
        <div class="buttonNew"><span>{if $language=='eng'}Subscribe to updates{else}Подписаться на обновления{/if}</span></div>
    </a>
{/if}
</div>
<script>
    var list = "{$ecommerce_list}";
{literal}
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
</script>
{/literal}
<script>

    var list = "{$ecommerce_list}";
{literal}
    var send_products = [];
    var impressions = [];
    var size = 0;
    function get_data(){
      var data = {
          block_height: jQuery('.ShAA_catalogItem_new').first().height(),
          block_width: jQuery('.ShAA_catalogItem_new').first().width(),
          cont_height: jQuery(window).height(),
          cont_width: jQuery('.centerRightContentCatalog_new').width(),
          scroll: jQuery(window).scrollTop() - jQuery('#main_top').offset().top
      }
      data['blocks_in_row'] = parseInt(data['cont_width'] / data['block_width']);
      data['rows'] = parseInt(data['scroll'] / data['block_height']);
      data['blocks'] = data['rows'] * data['blocks_in_row'];
      return data;
    }
    function process_blocks(){
      if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        var prods = jQuery('.ShAA_catalogItem_new'),
            data = get_data();
        for(i = data['blocks']; i < prods.length; i++){
          var e = jQuery('.ShAA_catalogItem_new').eq(i);
          if (e.visible(true)){
            var id = e.find('a').first().attr('name');
            var price = e.find('.prod_price').html() == undefined ? e.find('.client_price').html() : e.find('.prod_price').html();
            var price = price == undefined ? 0 : price;
            if(typeof(send_products[id]) === "undefined"){
              impressions[i] = {
                id: id,
                name: e.find('.prod_name').html() + ' ' + e.find('.prod_brand').html(),
                price: price,
                brand: e.find('.prod_brand').html(),
                category: e.find('.prod_categ').data('categ'),
                variant: e.data('sku'),
                list: list,
                position: i+1
              };
              size++;
              send_products[id] = id;
            }
          }
          else{break;}
        }
        if(size >= data['blocks_in_row']){
          dataLayer.push({
            'ecommerce': {
             'currencyCode': 'RUB',
             'impressions': impressions
            },
            'event': 'gtm-ee-event',
            'gtm-ee-event-category': 'Enhanced Ecommerce',
            'gtm-ee-event-action': 'Product Impressions',
            'gtm-ee-event-non-interaction': true,
          });
          //impressions = [];
          size = 0;
          console.log(dataLayer);
        }
      }
    }
    function block_click(e){
      if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        jQuery.cookie('ecommerce_list', list, {expires: 1, path: "/"});
        var click_product = {
          id: e.find('a').first().attr('name'),
          name: e.find('.prod_name').html(),
          price: e.find('.prod_price').html(),
          brand: e.find('.prod_brand').html(),
          category: e.find('.prod_categ').data('categ'),
          variant: e.data('sku'),
          position: jQuery('.ShAA_catalogItem_new').index(e)+1
        };

        dataLayer.push({
         'ecommerce': {
           'currencyCode': 'RUB',
           'click': {
             'actionField': {'list': list},
             'products': [click_product]
           }
         },
         'event': 'gtm-ee-event',
         'gtm-ee-event-category': 'Enhanced Ecommerce',
         'gtm-ee-event-action': 'Product Clicks',
         'gtm-ee-event-non-interaction': false,
        });
        console.log(dataLayer);
      }
    }
    process_blocks();

    jQuery('.ShAA_catalogItem_new a').on('mousedown touchstart',function (){
      block_click(jQuery(this).parents('.ShAA_catalogItem_new'));
    });

    jQuery(window).on('resize',function (){
      process_blocks();
    });

    jQuery(window).on('scroll',function (){
      process_blocks();
    });
</script>
{/literal}
