{assign var=hidden_brands value=","|explode:$user->show_hidden_brands}
<script type="text/javascript">
var reminder = 0;
{if $reminder}var reminder = 1;{/if}
{literal}
	$(document).ready(function(){
		 if( jQuery.cookie('CartNewUser') === null && reminder == 1){
			jQuery.cookie('CartNewUser', 1, {expires: 365, path: "/"});
			$("a#edit_link").click();
		 }
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

        $('ul.tabsSett.tabs1 li').removeClass('tab-current');
        $('ul.tabsSett.tabs1 li.sett0').addClass('tab-current');
        $('div.sett').hide();
        $('div.sett0').show();

        $('ul.tabsSett li').css('cursor', 'pointer');

        $('ul.tabsSett.tabs1 li').click(function(){
            var thisClass = this.className.slice(0,5);
            $('div.sett').hide();
            $('div.' + thisClass).show();
            $('ul.tabsSett.tabs1 li').removeClass('tab-current');
            $(this).addClass('tab-current');
        });

        if ($("body").width() < 701) {
            $("ul.tabsSett ").addClass('ShAA_mobilePersonalMenu');
        }
        else {
            $("ul.tabsSett ").removeClass('ShAA_mobilePersonalMenu');
        }
        $(function() {
            $(window).resize(function() {
                if ($("body").width() < 701) {
                    $("ul.tabsSett ").addClass('ShAA_mobilePersonalMenu');
                }
                else {
                    $("ul.tabsSett ").removeClass('ShAA_mobilePersonalMenu');
                }
            });
        });

        $('ul.ShAA_mobilePersonalMenu li').click(function(){
            $('.ShAA_mobilePersonalMenu').hide();
            $('.ShAA_backLinkMenu').show();
        });

        $('.ShAA_backLinkMenu').click(function(){
            $('.ShAA_backLinkMenu').hide();
            $('.ShAA_mobilePersonalMenu').show();
        });

	});
    {/literal}
</script>
{if $products && $smarty.session.user->group_id < 2 && $config->enviroment == 'live'}
<script>
//Criteo dataLayer
    {literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            var product_list = [];
            {/literal}{foreach from=$products item=product}
                {if in_array($product->product_id, $DL_products) && $product->category_enabled != 0}{literal}
                    product_list.push(
                    {
                        'id': '{/literal}{$product->barcode}{literal}',
                        'price': {/literal}{$product->price}{literal},
                        'quantity': {/literal}{assign var='pid' value=$product->product_id}{$smarty.session.shopping_cart.$pid}{literal}
                    }
                );
            {/literal}{/if}{/foreach}{literal}
            if (product_list != []) {
              dataLayer.push({
                  'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
                  'PageType': 'CartPage',
                  'CartProducts' : product_list
              })
            }
            console.log(dataLayer);
        }
    });
    {/literal}
</script>
<script>
//More dataLayer
    {literal}
    var product_list = [];
    var products = [];
    var total_price = 0;
    {/literal}{foreach from=$products item=product}
        {if !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}{literal}
            product_list.push({/literal}{$product->barcode}{literal});
            total_price = total_price + {/literal}{$product->price}{literal};
            products.push({/literal}{$product->product_id}{literal});
    {/literal}{/if}{/foreach}{literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'ProductPrice' : total_price,
                'productID' : product_list,
                'MT_PageType': 'cart'
            });
            dataLayer.push({
                'ecomm_totalvalue' : total_price,
                'ecomm_prodid' : products.join(','),
                'ecomm_pagetype': 'cart'
            });
        }
    });
    {/literal}
</script>
{/if}
<script type="text/javascript">
{literal}
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
          if($.cookie('language') == 'eng'){var text = 'Incorrect Promo code';}
          else{var text = 'Промо-код некорректный';}
					$('#sneaky_form .response').html().css({'color':'#C30000'});
				}else{

					if(data.type == 'percentage'){
						response_text = 'ваша скидка '+data.value+'%';
					}else{
						response_text = 'ваша скидка '+data.value+'<i class="icon-rub"></i>';
					}

					$('#sneaky_form .response').html(response_text).css({'color':'#32CD32'});

				}
			});

		});
    /*
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
    */

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

  var product_list = [];
  {/literal}{foreach from=$products item=product}{literal}
    product_list.push(
      {
        'name': '{/literal}{$product->model}{literal}',
        'id': '{/literal}{$product->product_id}{literal}',
        'price': '{/literal}{$product->price}{literal}',
        'brand': '{/literal}{$product->brand|upper}{literal}',
        'category': '{/literal}{$product->category}{literal}',
        'variant': '{/literal}{$product->sku}{literal}',
        'quantity': 1
      }
    );
  {/literal}{/foreach}{literal}
  if (typeof(dataLayer) !== 'undefined' && dataLayer) {
    dataLayer.push({
     'ecommerce': {
       'currencyCode': 'RUB',
       'checkout': {
         'actionField': {'step': 1,'option': 'cart'},
         'products': product_list
       }
     },
     'event': 'gtm-ee-event',
     'gtm-ee-event-category': 'Enhanced Ecommerce',
     'gtm-ee-event-action': 'Checkout Step 1',
     'gtm-ee-event-non-interaction': false,
    });
    console.log(dataLayer);
  }

  $(document).on('click', 'a.to_cart', function(e) {
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      var e = $(this).parent();
      var product = {
        id: e.data('product-id')+'',
        name: e.data('model'),
        price: e.data('price')+'',
        brand: e.data('brand').toUpperCase(),
        category: e.data('category'),
        variant:  e.data('sku'),
        quantity: 1
      };
      dataLayer.push({
       'ecommerce': {
         'currencyCode': 'RUB',
         'add': {
           'products': [product]
         }
       },
       'event': 'gtm-ee-event',
       'gtm-ee-event-category': 'Enhanced Ecommerce',
       'gtm-ee-event-action': 'Adding a Product to a Shopping Cart',
       'gtm-ee-event-non-interaction': false,
      });
      console.log(dataLayer);
    }
  });
  $(document).on('click', 'a.del_from_cart', function(e) {
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      var e = $(this).parent();
      var product = {
        id: e.data('product-id'),
        name: e.data('model'),
        price: e.data('price'),
        brand: e.data('brand'),
        category: e.data('category'),
        variant:  e.data('sku'),
        quantity: 1
      };
      dataLayer.push({
       'ecommerce': {
         'currencyCode': 'RUB',
         'remove': {
           'products': product
         }
       },
       'event': 'gtm-ee-event',
       'gtm-ee-event-category': 'Enhanced Ecommerce',
       'gtm-ee-event-action': 'Removing a Product from a Shopping Cart',
       'gtm-ee-event-non-interaction': false,
      });
      console.log(dataLayer);
    }
  });

</script>

<style media="all" type="text/css" >
	.imgCatalog_new {
		display: block !important;
	}

#personal_cart {
    float: left;
    width: 78%;
}

ul.tabsSett {
    float: left;
    width: 18%;
    margin-right: 16px;
}

ul.tabsSett li {
    float: none;
    /*width: 15%;*/
    padding-bottom: 4px;
}

ul.tabsSett li a {
    padding-top: 4px;
    font-size: 14px;
    text-transform: uppercase;
    color: #807f7d;
}

ul.tabsSett li, ul.tabsSett .tab-current {
    border-bottom: none;
    font-weight: 500;
    padding: 0 6px 12px;
}

.avatar img {
    border-radius: 75px;
    max-width: 150px;
    float: left;
    margin: 48px 24px 36px 0;
}

.ShAA_desctopNone {
    display: none;
}

.ShAA_backLinkMenu {
    font-weight: 500;
    text-transform: uppercase;
    float: left;
    border-bottom: 1px solid #767676;
    padding: 8px 4%;
    width: 110%;
    margin-left: -5%;
    margin-bottom: 24px;
    cursor: pointer;
}
.ShAA_popBackCenter {
    background: none;
    border: none;
    box-shadow: none;
    width: 70%;
    clear: both;
}

.ShAA_popDataSett .ShAA_popInput input {
    padding: 10px 2%;
}

.ShAA_popDataSett .ShAA_popInput select, .ShAA_popBackCenter .ShAA_popButton_input {
    padding: 10px 2%;
    width: 99%;
}


@media (max-width: 1420px) {
    .ShAA_popBackCenter {
        width: 90%;
    }
}
@media (max-width: 1024px) {
    .ShAA_popBackCenter {
        width: 100%;
    }

    ul.tabsSett {
        height: 23px;
    }
}
@media (max-width: 930px) {
	table.service{width:100%;}
    .ShAA_popBackCenter {
        width: 100%;
    }
}

@media (max-width: 830px) {

    ul.tabsSett li {
        width: 28%;
        text-align: left;
    }

    ul.tabsSett {
       border-bottom: none;
    }
}

@media (max-width: 700px) {
    .ShAA_popBackCenter {
        width: 100%;
    }

    ul.tabsSett {
       float: left;
       width: 105%;
       height: auto !important;
       margin-left: -5%;
    }

    ul.tabsSett li {
        width: 104%;
        float: left;
        border-bottom: 1px solid #767676 !important;
        padding-left: 4% !important;
    }

    ul.tabsSett li a {
        color: #000 !important;
    }

    ul.tabsSett .sett0 {
        padding-top: 8px !important;
        border-top: 1px solid #767676;
    }

    .ShAA_popDataSett .phone input {
        width: 89%;
    }
    .ShAA_sizeCols {
        width: 25%;
    }
    .profinfo {
        margin-top: 48px;
    }
    .avatar_change {
        margin-top: 64px;
    }
    #personal_cart {
        width: 100%;
    }
    .ShAA_popDataSett .ShAA_popInput input {
        width: 93%;
    }
    .ShAA_popDataSett .phone input {
        width: 88% !important;
    }
    .ShAA_buttonInProfile {
     margin: 12px 0 0 0;
     width: 100%;
    }

    .ShAA_desctopNone {
        display: block;
    }
}
</style>
{/literal}
	<div class="ShAA_popBackCenter">
        <div class="ShAA_desctopNone">
            <div class="ShAA_backLinkMenu" style="display: none;">
                <i class="icon-angle-up icon-2x" style="font-weight:bold;margin:-8px 9px 0 0;float:left;"></i> назад к меню
            </div>
        </div>
        <div>
            <ul class="tabsSett tabs1">
                <li class="sett0">
                    <a onclick="$('.cash').hide();$('#c1').show(); " {if !$smarty.session.user->user_id} style="float: none;" {/if}>
                        <img src="/sizes/images/cart_mini.png" align="top" alt="" />&nbsp;&nbsp;{if $language=='eng'}Cart{else}Корзина{/if}
                    </a>
                </li>
                {if $smarty.session.user->user_id}
                    <li class="sett1">
                        <a id="product_wl" onclick="$('.cash').hide();$('#c2').show();">
                            {if $language=='eng'}Wishlist{else}Избранное{/if}
                        </a>
                    </li>
                    <li class="sett2">
                        <a id="product_z" onclick="$('.cash').hide();$('#c3').show();">
                            {if $language=='eng'}Orders{else}Заказы{/if} {if $count_orders}({$count_orders}){/if}
                        </a>
                    </li>
                    <li class="sett3">
                        <a id="product_z" onclick="$('.cash').hide();$('#c4').show();">
                            {if $language=='eng'}Wardrobe{else}Гардероб{/if}
                        </a>
                    </li>
                {/if}
            </ul>
            <div id="personal_cart">
<!--
                <div class="tab tabact" onclick="$('.cash').hide();$('#c1').show(); " {if !$smarty.session.user->user_id} style="float: none;" {/if}>
                    <img src="/sizes/images/cart_mini.png" align="top" alt="" />
                    {if $language=='eng'}Cart{else}Корзина{/if}

                    //{if $cart_products_num}&nbsp;({$cart_products_num}){/if}
                </div>
                {if $smarty.session.user->user_id}
                    <div class="tab" id="product_wl" onclick="$('.cash').hide();$('#c2').show();">
                        {if $language=='eng'}Wishlist{else}Отложено{/if}

                        //{if $wl_products_num}&nbsp;({$wl_products_num}{/if}
                    </div>
                    <div class="tab" id="product_z" onclick="$('.cash').hide();$('#c3').show();">
                        {if $language=='eng'}Orders{else}Заказы{/if} {if $count_orders}({$count_orders}){/if}
                    </div>
                    <div class="tab" id="product_z" onclick="$('.cash').hide();$('#c4').show();">
                        {if $language=='eng'}Wardrobe{else}Гардероб{/if}
                    </div>
                {/if}
-->
                <div class="cash" id="c1">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Cart{else}Корзина{/if}</div>
                    <div class="cash_in">
                        {if $products}
                  <table width="100%" class="ShAA_cartOrderTable" cellspacing="0" cellpadding="0" border="0" >
                                {foreach from=$products item=product}
                                    <tr id="{$product->product_id}">
                                        <td class="ShAA_cartOrderTableTd">
                                            <a href="/products/{$product->url}/" target="_blank" title="{$product->model}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">
                                                <div id="img_{$product->product_id}">
                                                    <img alt="{$product->model}" title="{$product->model}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_out="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_over="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->small_image}" />
                                                </div>
                                            </a>
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_mobileDisabled">
                                            <a href="/products/{$product->url}/" target="_blank" title="{$product->model}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">
                                                {if $language=='eng'}{$product->eng_single_name}{else}{$product->category}{/if} {$product->brand}
                            {if $product->unreturnable}
                              <br><span style="color:red;font-size:12px;">{if $language=='eng'}*Attention! Underclothes are non-refundable.{else}*Внимание! Бельё возврату не подлежит.{/if}</span>
                            {/if}
                                            </a>
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_mobileSize">
                                            {if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}({$product->size}){/if}
                                        </td>
                                        <td class="ShAA_cartOrderTableTd">
                                            <span class="price rub">
                                                {if $product->size_data->price}
                                                    {$product->size_data->price|string_format:"%.0f"}
                                                {else}
                                                    {$product->price|string_format:"%.0f"}&nbsp;
                                                {/if}
                                                <i class="icon-rub"></i>
                                            </span>
                          {foreach from=$cat_currencies item=currency}
                            {assign var="c_name" value="price_`$currency->code`"}
                            <span class="price {$currency->code}" style="display:none;">{$product->c_prices->$c_name|string_format:"%.0f"}&nbsp;<b>{$currency->sign}</b></span>
                          {/foreach}
                                        </td>
                        <td class="ShAA_cartOrderTableTd" style="color: red;">
                                            {if $product->with_online_discount}
                            <span class="price rub">{$product->price*0.95|string_format:"%.0f"}&nbsp;<i class="icon-rub"></i></span>
                            {foreach from=$cat_currencies item=currency}
                              {assign var="c_name" value="price_`$currency->code`"}
                              <span class="price {$currency->code}" style="display:none;">{$product->c_prices->$c_name*0.95|string_format:"%.0f"}&nbsp;<b>{$currency->sign}</b></span>
                            {/foreach}
                                                </br>
                              <span style="font-size: 12px;">-5% {if $language=='eng'}for payment on the website{else}за оплату на сайте{/if}</span>
                                            {/if}
                                        </td>
                                        <td class="ShAA_cartOrderTableTd" style="text-align: right;" data-size="{if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}{$product->size}{/if}" data-model="{$product->model}" data-product-id="{$product->product_id}" data-brand="{$product->brand}" data-category="{$product->category}" data-price="{$product->price}">
                                            <a onclick="window.location='/cart/delete/{$product->product_id}/{if $product->size}?size={$product->size}{/if}';return false;" href="#" class="del_from_cart" title="выложить" alt="выложить">
                                                <i class="icon-close ShAA_deleteIconFromCart"></i>
                                            </a>
        <!--
                                            <a id="RemovePurchase" data-item_id="{$product->product_id}" data-price="{$product->price}" data-is_available="{if $product->size}1{else}0{/if}" data-category="{$product->category_id}" title="Выложить из корзины" href="#">
                                                выложить
                                            </a>
        -->
                                        </td>
                                    </tr>
                                {/foreach}
                            </table>
                        {else}
                            <div>
                                <div class="ShAA_popText"><span style="float: left;">{if $language=='eng'}Cart is empty{else}Тут пусто{/if}</span> <br /><a href="/catalog/" class="ShAA_oneClickAddOld ShAA_continueInCart" style="margin: 30px 0;">{if $language=='eng'}Return to catalog{else}Продолжить выбор{/if}</a></div>
                            </div>
                        {/if}
                    {if $products}
                        <form id="sneaky_form" action="/cart/" method="POST" enctype="multipart/form-data" style="display: none; float: left; width: 100%;">
                            <input type="hidden" name="submit_order" value="1" style="clear: both;">
                            <input type="hidden" name="referrer" id="referrer" value="" style="clear: both;">
                            <input type="text" name="coupon_code" placeholder="{if $language=='eng'}Promo code{else}Промо-код{/if}" value="{$coupon_code|escape}" /><span class="response" style="margin-left:15px;"></span><br /><br />
                        </form>
                        <div class="clear"></div>
                        <a href="/orderform/{$products_price}/{$products_weight}" onclick="{literal}rG('BUY_ISSUE_SITE');{/literal}"
                            {if $smarty.session.user && $smarty.session.user->group_id == 1}
                                id="submit_target"
                            {/if}
                            class="ShAA_oneClickAdd" style="font-size: 16px; margin-right: 12px;">
                                {if $language=='eng'}Order{else}Оформить заказ{/if}
                        </a>
                        <a href="/catalog/" title="{if $language=='eng'}Return to catalog{else}Перейти в каталог{/if}" style="margin: 0; float: left;" class="ShAA_oneClickAddOld ShAA_continueInCart"><span>{if $language=='eng'}Return to catalog{else}Продолжить выбор{/if}</span></a>
                    {/if}

                    {if !$products}
                        <div style="clear:both;"></div><br />
                        <div id="recently_viewed_recomendations" style="display:none;">
                            <div style="font-weight: normal; margin: 26px 0;">{if $language=='eng'}Recently viewed{else}Вы недавно смотрели{/if}</div>
                            <div class="products"></div>
                        </div>
                        <div id="interesting_recomendations" style="display:none;">
                            <div style="font-weight: normal; margin: 26px 0;">{if $language=='eng'}Recommendations{else}Возможно, вам это понравится{/if}</div>
                            <div class="products"></div>
                        </div>
                    {/if}
                    </div>
                </div>
                <!-- вторая вкладка -->
                <div class="cash invis" id="c2">
                    <div class="ShAA_titleForTab"><i class="icon-heart" style="color: #C30000;"></i>&nbsp;&nbsp;{if $language=='eng'}Wishlist{else}Избранное{/if}</div>
                    <div class="cash_in">
                        {if $products_wl}
                  <table width="100%" class="ShAA_cartOrderTable" cellspacing="0" cellpadding="0" border="0" >
                                {foreach from=$products_wl item=product}
                                    <tr>
                                        <td class="ShAA_cartOrderTableTd">
                                            <a href="/products/{$product->url}/" target="_blank" title="{$product->model}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">
                                                <img alt="{$product->model}" title="{$product->model}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_out="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_over="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->small_image}" />
                                            </a>
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_mobileDisabled">
                                            <a href="/products/{$product->url}/" target="_blank" title="{$product->model}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">
                                                {if $language=='eng'}{$product->eng_single_name}{else}{$product->category}{/if} {$product->brand}
                                            </a>
                                            <div>
                                                {if $product->season == $settings->current_new_season }
                                                    <div class="ShAA_newSeasonIcon">{if $language=='eng'}new season{else}новый сезон{/if}</div>
                                                {/if}
                                            </div>
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_mobileSize">
                                            {if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}({$product->size}){/if}
                                        </td>
                                        <td class="ShAA_cartOrderTableTd">
                                            {if $product->can_buy_from_site}
                                                <span style="font-size:12px;">
                                                    {if $product->prices.first_price}
                                                        <span class="price rub"><span style="text-decoration: line-through;" itemprop="highPrice">{$product->prices.first_price|string_format:"%.0f"}</span>&nbsp;<i class="icon-rub"></i> </span>
                                {foreach from=$cat_currencies item=currency}
                                  {assign var="c_name" value="first_price_`$currency->code`"}
                                  <span class="price {$currency->code}" style="display:none;"><span style="text-decoration: line-through;">{$product->prices.$c_name|string_format:"%.0f"}</span>&nbsp;<b>{$currency->sign}</b></span>
                                {/foreach}
                                {if $language=='eng'}first price{else}первая цена{/if}
                                                    {else}
                                                        <span class="price rub"><span itemprop="highPrice">{$product->prices.price|string_format:"%.0f"}</span>&nbsp;<i class="icon-rub"></i></span>
                                {foreach from=$cat_currencies item=currency}
                                  {assign var="c_name" value="price_`$currency->code`"}
                                  <span class="price {$currency->code}" style="display:none;">{$product->prices.$c_name|string_format:"%.0f"}&nbsp;<b>{$currency->sign}</b></span>
                                {/foreach}
                                                    {/if}
                                                </span><br/>

                                                {if $product->prices.sale_price.price > 0}
                                                    <span style="color: #C30000;font-size:12px;">
                                                        <span class="price rub"><b style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}" itemprop="lowPrice">{$product->price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i> </span>
                                {foreach from=$cat_currencies item=currency}
                                  {assign var="c_name" value="price_`$currency->code`"}
                                  <span class="price {$currency->code}" style="display:none;"><b style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}">{$product->prices.sale_price.$c_name|string_format:"%.0f"}</b>&nbsp;<b>{$currency->sign}</b></span>
                                {/foreach}
                                {if $language=='eng'}sale{else}со скидкой{/if} {$product->sale_value|string_format:"%.0f"}%
                                                    </span><br/>
                                                {/if}

                                                {if $product->prices.vip_price.price > 0}
                                                    <span style="color: #C30000;font-size:12px;">
                                <span class="price rub"><b itemprop="lowPrice">{$product->prices.vip_price.price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i> </span>
                                {foreach from=$cat_currencies item=currency}
                                  {assign var="c_name" value="price_`$currency->code`"}
                                  <span class="price {$currency->code}" style="display:none;"><b>{$product->prices.vip_price.$c_name|string_format:"%.0f"}</b>&nbsp;<b>{$currency->sign}</b></span>
                                {/foreach}
                                VIP {if $language=='eng'}sale{else}скидка{/if} {$product->prices.vip_price.value|string_format:"%.0f"}%
                              </span><br/>
                                                {/if}
                                            {/if}
                                        </td>
                                        <td class="ShAA_cartOrderTableTd" style="text-align: right;" data-size="{if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}{$product->size}{/if}" data-model="{$product->model}" data-product-id="{$product->product_id}" data-brand="{$product->brand}" data-category="{$product->category}" data-price="{if $product->prices.vip_price.price > 0}{$product->prices.vip_price.price}{elseif $product->prices.sale_price.price > 0}{$product->prices.sale_price.price}{else}{$product->prices.price}{/if}">
                                            <a onclick="window.location='/cart/movefromwl/{$product->product_id}/{if $product->size}?size={$product->size}{/if}';" href="#" style="line-height: 44px;" class="to_cart" title="{if $language=='eng'}to cart{else}в корзину{/if}" alt="{if $language=='eng'}to cart{else}в корзину{/if}">
                                                <i class="icon-shopping-bag ShAA_deleteIconFromCart"></i>
                                            </a>
                                            <a class="event_remove_item" onclick="window.location='/cart/deletewl/{$product->product_id}/{if $product->size}?size={$product->size}{/if}';" href="#" title="{if $language=='eng'}remove{else}выложить{/if}" alt="{if $language=='eng'}remove{else}выложить{/if}">
                                                <i class="icon-close ShAA_deleteIconFromCart"></i>
                                            </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </table>
                            <a href="/catalog/" title="{if $language=='eng'}Return to catalog{else}Перейти в каталог{/if}" style="margin: 0; float: left;" class="ShAA_oneClickAddOld ShAA_continueInCart"><span>{if $language=='eng'}Return to catalog{else}Продолжить выбор{/if}</span></a>
                        {else}
                            <div>
                                <div class="ShAA_popText">
                                    <span style="float: left;">{if $language=='eng'}Your wishlist is empty{else}У вас еще ничего не выбрано{/if}</span> <br />
                                    <a href="/catalog/" class="ShAA_oneClickAddOld ShAA_continueInCart" style="margin: 30px 0;">{if $language=='eng'}Return to catalog{else}Продолжить выбор{/if}</a>
                                </div>
                            </div>
                            <div id="recently_viewed_recomendations2" style="display:none;">
                                <div style="font-weight: normal; margin: 26px 0;">{if $language=='eng'}Recently viewed{else}Вы недавно смотрели{/if}</div>
                                <div class="products"></div>
                            </div>
                        {/if}
                    </div>
                </div>
                <div class="cash invis" id="c3">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Orders{else}Заказы{/if}</div>
                    {if $new_orders || $orders}
                        <div class="cash_in" style="width: 100%;">
                            {if $new_orders}
                                <div style="width: 100%;" class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">{if $language=='eng'}One click orders{else}Заказы в 1 клик{/if}</div>
                                {foreach from=$new_orders item=product}
                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                        <tr>
                                            <td class="ShAA_cartOrderTableTd">
                                                <a href="/products/{$product->url}/" target="_blank" title="{$product->model}">
                                                    <img alt="{$product->model}" title="{$product->model}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_out="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_over="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->small_image}" style="margin: 6px 0;" />
                                                </a>
                                            </td>
                                            <td class="ShAA_cartOrderTableTd ShAA_mobileDisabled">
                                                <a href="/products/{$product->url}/" target="_blank" title="{$product->model}">
                                                    {if $language=='eng'}{$product->eng_single_name} {$product->brand_name}{else}{$product->model}{/if}{$product->model}
                                                </a>
                                            </td>
                                            <td class="ShAA_cartOrderTableTd ShAA_mobileSize">
                                                {$product->size}
                                            </td>
                                            <td class="ShAA_cartOrderTableTd">
                                                {$product->price|string_format:"%.0f"}&nbsp;<i class="icon-rub"></i>
                                            </td>
                                            <td class="ShAA_cartOrderTableTd">
                                                {if $language=='eng'}Processed{else}примерка{/if}примерка
                                            </td>
                                        </tr>
                                    </table>
                                {/foreach}
                            {/if}

                            {foreach from=$orders key=k item=order_details}
                            <div style="border-bottom: 1px solid #ccc; margin-bottom: 60px; float: left; width: 100%;">
                                <div style="font-weight: bold; font-size: 24px; margin-bottom: 18px;">
                                    <a href="/order/{$order_details.order->code}" title="{if $language=='eng'}Order page{else}Страница заказа{/if} №{$k}">{if $language=='eng'}Order{else}Заказ{/if} №{$k}</a>
                                </div>
                                <div style="margin-bottom: 12px;">
                                    {if $order_details.order->invoice_number}<div>Накладная №<b>{$order_details.order->invoice_number}</b></div>{/if}
                                    {if $order_details.order->delivery_status}<div>Статус доставки: <b>{$order_details.order->delivery_status}</b></div>{/if}
                                    {if $order_details.order->delivery_company}<div>Транспортная компания: <b>{$order_details.order->delivery_company->name}</b> (телефон горячей линии: <b>{$order_details.order->delivery_company->phone}</b>)</div>{/if}
                                    {if $order_details.order->invoice_number && $order_details.order->delivery_company->track_link}<a target="_blank" style="padding: 3px 11px;margin: 7px 0 12px;" class="ShAA_oneClickAddOld" href='{$order_details.order->delivery_company->track_link}{$order_details.order->invoice_number}' id=''>Отследить на сайте компании</a>{/if}
                                   <!-- {if $order_delivery_address}<div>Адрес пункта выдачи: </div>{/if}-->
                                </div>
                                <table width="100%" class="ShAA_cartOrderTable" cellspacing="0" cellpadding="0" border="0" style="margin-bottom: 6px;">
                                    <!--
                                    <tr>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold"><div><a href="/order/{$order_details.order->code}" title="{if $language=='eng'}Order page{else}Страница заказа{/if} №{$k}">{if $language=='eng'}Order{else}Заказ{/if} №{$k}</a></div></td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold ShAA_mobileDisabled"><div>{if $language=='eng'}Total goods{else}Всего товаров{/if} {$order_details.count_prod}</div></td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold ShAA_mobileSize"><div>&nbsp;</div></td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold"><div>{$order_details.total|string_format:"%.0f"}&nbsp;<i class="icon-rub"></i></div></td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                            <div>
                                                <a href="/order/{$order_details.order->code}" title="{if $language=='eng'}Delivery and payment for order{else}доставка и оплата заказа{/if} №{$k}">{if $language=='eng'}Delivery and payment{else}доставка и оплата{/if}</a>
                                            </div>
                                        </td>
                                    </tr>
-->
                                    <tr>
                                        <td colspan="5" style="border-bottom: 1px solid #ccc;"></td>
                                    </tr>
                                    {foreach from=$order_details.products item=product}
                                        <tr>
                                            {if $product->order_status != 2}
                                                <td class="ShAA_cartOrderTableTd">
                                                    <a href="/products/{$product->url}" target="_blank" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; "><img alt="{$product->model}" title="{$product->model}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_out="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_over="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->small_image}" style="margin: 6px 0;" /></a>
                                                </td>
                                                <td class="ShAA_cartOrderTableTd ShAA_mobileDisabled">
                                                    <a href="/products/{$product->url}" target="_blank" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->product_name} </a>
                                                </td>
                                                <td class="ShAA_cartOrderTableTd ShAA_mobileSize">
                                                    {$product->size}
                                                </td>
                                                <td class="ShAA_cartOrderTableTd">
                                                    {$product->order_price|string_format:"%.0f"}&nbsp;<i class="icon-rub"></i>
                                                </td>
                                                <td class="ShAA_cartOrderTableTd">
                                                    {$product->status_name}
                                                </td>
                                            {/if}
                                        </tr>
                                    {/foreach}
                                    <tr>
                                        <td colspan="5" style="border-bottom: 1px solid #ccc;"></td>
                                    </tr>
                                </table>
                                <div class="ShAA_managerInfoFromOrder ShAA_cartTotalSum">
                                    <b>{if $language=='eng'}Total summ{else}Итого{/if}({$order_details.count_prod}): {$order_details.total|string_format:"%.0f"}&nbsp;<i class="icon-rub"></i></b>
<!--
									{if !$order_details.no_payment_discount && $order_details.with_online_discount}</br>
										<span style="font-size: 0.8em;">{if $language=='eng'}for payment online{else}при оплате </br>online (-5%):{/if}</span>
										<span>{$order_details.total_amount_online|string_format:"%.0f"}&nbsp&nbsp;<i class="icon-rub"></i></span>
									{/if}
-->
                                    <div class="clear"></div>
									{if $sber_on}
										<div id="payment_button_sber" style="width: 68%; float: left;">
											<a href="/sberbankpayment/?order_id={$order_details.order->code}&amp;order_total={$order_details.total_amount_online}">
												<input type="submit" value="{if $language=='eng'}Pay{else}Оплатить{/if}" class="ShAA_popButton_input">
											</a>
										</div>
									{/if}
                                </div>
                                {if $order_details.order->manager}
                                    <div class="ShAA_managerInfoFromOrder">
                                        {foreach from=$order_details.order->manager item=manager}
                                            <div>{if $language=='eng'}Manager{else}Менеджер заказа{/if}: {$manager->name}</div>
																						{if $manager->start && $manager->end}
																							{if $language=='eng'}
                                            		<div style="color:grey;">Today's working hours: {$manager->start} - {$manager->end} MSK</div>
																							{else}
                                            		<div style="color:grey;">Сегодня работает с {$manager->start} до {$manager->end} по московскому времени</div>
																							{/if}
																						{/if}
                                            <div>{if $language=='eng'}Contact phone{else}Контактный телефон{/if}: {$manager->phone_number}</div>
                                            <div>Email: {$manager->email}</div>
                                        {/foreach}
                                        <div>Доступные мессенджеры:</div>
                                        <div>
                                            <i class="icon-telegram"></i> Telegram &nbsp;&nbsp;&nbsp;&nbsp;
                                            <!--<i class="icon-viber"></i> Viber -->
                                            <a target="_blank" href="https://api.whatsapp.com/send?phone={$manager->phone_number}"><i class="icon-whatsapp"></i> WhatsApp</a>
                                        </div>
                                        <div style="margin-top: 24px; display: none;">
                                            <a href="javascript:void(0);" onclick="$('#personal_data').submit();return false;">
                                                <input type="submit" style="font-size: 14px;" value="{if $language=='eng'}Call back{else}Заказать звонок{/if}" class="ShAA_popButton_input">
                                            </a>
                                        </div>
                                    </div>
                                {/if}
                            </div>
                            {/foreach}

                        </div>
                    {else}
                        <div style="float: left; margin-bottom: 100px;">
                            <div class="ShAA_popText">
                                {if $language=='eng'}You do not have incomplete orders{else}У вас нет выполняющихся заказов{/if}.<br/>
                                {if $language=='eng'}All your ordered products will be available here {else}Здесь будут доступны все заказанные вами товары{/if}
                            </div>
                        </div>
                    {/if}
                </div>
                <div class="cash invis" id="c4">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Wardrobe{else}Гардероб{/if}</div>
                    {if $products_g || $products_off}
                        <div class="cash_in">
                            <table width="100%" class="ShAA_cartOrderTable" cellspacing="0" cellpadding="0" border="0" >
                                {if $products_g}
                                    <tr style="width: 100%;" class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                            <div>{if $language=='eng'}Purchases OnLine{else}Покупки OnLine{/if}</div>
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold ShAA_mobileDisabled">
                                            &nbsp;
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    {foreach from=$products_g item=product}
                                        <tr>
                                            <td class="ShAA_cartOrderTableTd">
                                                <img alt="{$product->model}" title="{$product->model}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_out="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_over="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->small_image}" />
                                            </td>
                                            <td class="ShAA_cartOrderTableTd ShAA_mobileDisabled">
                                                <span>{$product->category}</span> <a href="/catalog/?brand={$product->brand_id}&showbrand={$product->brand_id}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->brand}</a>
                                            </td>
                                            <td class="ShAA_cartOrderTableTd">
                                                {if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}{$product->size}{/if}
                                            </td>
                                        </tr>
                                    {/foreach}
                                {/if}
                                {if $products_off}
                                    <tr style="width: 100%;" class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                            <div>{if $language=='eng'}Purchases OffLine{else}Покупки OffLine{/if}</div>
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                            &nbsp;
                                        </td>
                                        <td class="ShAA_cartOrderTableTd ShAA_cartOrderTableTdBold">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    {foreach from=$products_off item=product}
                                        <tr>
                                            <td class="ShAA_cartOrderTableTd">
                                                <img alt="{$product->model}" title="{$product->model}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_out="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->large_image}" src_over="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/85x/{$product->small_image}" />
                                            </td>
                                            <td class="ShAA_cartOrderTableTd ShAA_mobileDisabled">
                                                <span>{$product->category}</span> <a href="/catalog/?brand={$product->brand_id}&showbrand={$product->brand_id}" style="border-bottom-style: none; border-bottom-width: initial; border-bottom-color: initial; ">{$product->brand}</a>
                                            </td>
                                            <td class="ShAA_cartOrderTableTd">
                                                {if (isset($product->size) && !empty($product->size) && ($product->size !='undefined'))}{$product->size}{/if}
                                            </td>
                                        </tr>
                                    {/foreach}
                                {/if}
                            </table>
                        </div>
                    {else}
                        <div style="float: left; margin-bottom: 100px;">
                            <div class="ShAA_popText">
                                {if $language=='eng'}Your wardrobe is empty. All your purchases will be available here {else}Ваш гардероб пуст. Тут будут доступны все совершенные вами покупки{/if}
                            </div>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
	</div>
