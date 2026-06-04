{if ($oc_ordered || $so_ordered) && $smarty.session.user->group_id < 2 && $config->enviroment == 'live'}
{literal}
    <script>
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'transactionId': '{/literal}{if $oc_ordered}c{$oc_ordered->id}{elseif $so_ordered}s{$so_ordered->so_id}{/if}{literal}', // Required
                'transactionAffiliation': 'Luxury Store',
                "transactionChannel": "adm", // параметр дедупликации (для Admitad)
                "transactionAction": "1",    // код целевого действия (для Admitad)
                'transactionTax': '{/literal}{if $new_user_order}0{else}1{/if}{literal}',
                'transactionTotal': {/literal}{$ordered_product->price}{literal}, // Required
                'transactionShipping': 'undefined',
                'transactionProducts': [
                    {
                        'sku': '{/literal}{$ordered_product->sku}{literal}', // Required
                        'name': '{/literal}{$ordered_product->model}{literal}', // Required
                        'category': '{/literal}{$ordered_product->brand_name}{literal}',
                        'price': {/literal}{$ordered_product->price}{literal}, // Required
                        "priceCurrency": "RUB",  // код валюты ISO-4217 alfa-3 (для Admitad)
                        "tariff": "1",           // код тарифа (для Admitad)
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
                'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
                'PageType': 'TransactionPage',
                'OrderProducts' : product_list,
                'CriteoTransactionId': '{/literal}{if $oc_ordered}c{$oc_ordered->id}{elseif $so_ordered}s{$so_ordered->so_id}{/if}{literal}'
            })
        }
        {/literal}{/if}{literal}

        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
          {/literal}var brand_name = "{$ordered_product->brand_name}".replace(/'/g, "`"),
                name = "{$ordered_product->model}".replace(/'/g, "`");{literal}
          dataLayer.push({
             'ecommerce': {
               'currencyCode': 'RUB',
               'purchase': {
                 'actionField': {
                   'id': '{/literal}{if $oc_ordered}c{$oc_ordered->id}{elseif $so_ordered}s{$so_ordered->so_id}{/if}{literal}',
                   'affiliation': 'Luxury Store',
                   'revenue': "{/literal}{$ordered_product->price|number_format:0:'':''}{literal}",
                   'tax': '{/literal}{if $new_user_order}0{else}1{/if}{literal}',
                   'coupon': '{/literal}{$smarty.session.user->personal_discount}{literal}',
                   'option': '{/literal}{if $oc_ordered}one_click{elseif $so_ordered}special_order{/if}{literal}'
                 },
                 'products': [{
                    "id":       "{/literal}{$ordered_product->product_id}{literal}",
                    "name":     name,
                    "price":    "{/literal}{$ordered_product->price|number_format:0:'':''}{literal}",
                    "brand":    brand_name.toUpperCase(),
                    "category": "{/literal}{$ordered_product->category}{literal}",
                    "variant":  "{/literal}{if $ordered_product}{$ordered_product->sku}{elseif $so_ordered}{$so_ordered->sku}{/if}{literal}",
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
               'actionField': {'step': 3,'option': '{/literal}{if $oc_ordered}one_click{elseif $so_ordered}special_order{/if}{literal}'},
               'products': [{
                  "id":       "{/literal}{$ordered_product->product_id}{literal}",
                  "name":     name,
                  "price":    "{/literal}{$ordered_product->price|number_format:0:'':''}{literal}",
                  "brand":    brand_name.toUpperCase(),
                  "category": "{/literal}{$ordered_product->category}{literal}",
                  "variant":  "{/literal}{$ordered_product->sku}{literal}",
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

<script type="text/javascript" src="/jscript/jcarousel.js"></script>
<link media="all" href="/jscript/jcarousel.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/jscript/jquery.shorten.1.0.js"></script>
<script type="text/javascript" src="/jscript/plax.js"></script>
<script type="text/javascript" src="/jscript/owl.carousel.js"></script>
<link media="all" href="/jscript/owl.carousel.css?v=0.2" rel="stylesheet" type="text/css" />
<link media="all" href="/jscript/owl.theme.css?v=0.2" rel="stylesheet" type="text/css" />

<div class="content notPadding" style="width: 100%;">
	<div class="centerContent">
	<div class="ShAA_goldBanner noLinkUnderline">
	{* {if 'swd'|array_key_exists:$promos && in_array($brand->brand_id, explode(",", $promos.swd->brands)) }
		<div class="ShAA_goldBanner noLinkUnderline" style="display:none;">
			<a href="/swd/" title="{if $language=='eng'}Weekend discount on clothes and shoes{else}Скидка Выходного Дня на одежду и обувь{/if}" target="_blank">
				<img src="/files/images/swd/{$promos.swd->product_banner}" width="927" height="129" alt="" />
			</a>
	{else}
		<div class="ShAA_goldBanner">
			<img src="/images/sale-new.png" width="927" height="129"  alt="" />
	{/if} *}
	{if $smarty.session.user && $product->special_sale}
		<div class="ShAA_goldBanner noLinkUnderline">
			<img src="/images/urozhai_product.png" width="927" height="129" alt="" />
		</div>
	{/if}
	{* <a href="/sale" target="_blank">
	<video width="928" height="120" loop autoplay>
		<source src="/images/sale2.mp4" type="video/mp4">
		<source src="/images/sale2.webm" type="video/webm">
		<img src="/images/sale_static.png" width="928" height="128" alt="" />
	</video>
	</a> *}
	</div>
  {*{if $smarty.session.user->group_id < 2 && count($set_products) != 0}
    {literal}
    <script type="text/javascript">
        jQuery(document).ready(function() {
            var ShowTab = 1;
            var offset = jQuery("#set_products").offset().top;
            jQuery(window).scroll(function () {
                if(jQuery(this).scrollTop() > offset) {
                    ShowTab = 1;
                }
            });
            jQuery('body').on('mouseleave', function() {
                if(ShowTab != 0){
                    jQuery("#popUp_leaving").click();
                    ShowTab = 0;
                }
            });
        });
    </script>
    {/literal}
{/if}*}
{literal}
<style media="all" type="text/css" >
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
   @media (max-width: 990px) {
        .owl-demo-hide{
        display: block !important;
        }
    }
  .owl-demo-hide{
  display: none ;
  }
  .owl-demo-show{
      display: block !important;
      z-index: 999;
      position: fixed;
      right: calc(50% - 450px);
      top: 50px;
      max-width: 900px;
      max-height: 100vh;
  }
  .ShAA_fixedMenuZoom{
      z-index: 1 !important;
  }
	#owl-demo .item img{
	  display: inline;
	  width: auto;
    max-width: 90%;
	  height: auto;
    max-height: 90vh;
	}
	#owl-demo .item iframe {
		max-height: 90vh;
	}
	.ShAA_filterBig, .ShAA_mobileFilters {
		//display: none !important;
	}
    .owl-buttons div {
        color: #000 !important;
        background: none !important;
        font-size: 30px !important;
        font-family: none !important;
    }
</style>
<script type="text/javascript" src="/jscript/timeto/jquery.time-to.js"></script>
<link rel="stylesheet" type="text/css" href="/jscript/timeto/timeto.css" />
{/literal}

<script type="text/javascript">
{literal}
  var product = {
      id:       "{/literal}{$product->product_id}{literal}",
      name:     "{/literal}{$group_name|escape} {$brand->name}{literal}",
      price:    "{/literal}{$product->price}{literal}",
      brand:    "{/literal}{$brand->name|upper}{literal}",
      category: "{/literal}{$product->category_name|escape}{literal}",
      variant:  "{/literal}{$product->sku}{literal}"
  };


  {/literal}{assign var=hidden_brands value=","|explode:$user->show_hidden_brands}{literal}
  var viewed_impressions = [],
      viewed_send = false,
      set_send = false;
  {/literal}var list = "{$ecommerce_list}";{literal}
  {/literal}{if $viewed_products}{foreach from=$viewed_products item=prod}
      {if !in_array($prod->brand_id, $hidden_brands) && $prod->category_enabled != 0}
          var brand_name = "{$prod->brand}".replace(/'/g, "`"),
              name = "{$prod->model}".replace(/'/g, "`");{literal}
          viewed_impressions.push(
            {
              'id': "{/literal}{$prod->product_id}{literal}",
              'name': name,
              'price': "{/literal}{$prod->price}{literal}",
              'brand': brand_name,
              'category': "{/literal}{$prod->category_name}{literal}",
              'variant': "{/literal}{$prod->sku}{literal}",
            }
          );
  {/literal}{/if}{/foreach}{/if}{literal}
  var set_impressions = [];
  {/literal}{if $set_products}{foreach from=$set_products item=prod}
      {if !in_array($prod->brand_id, $hidden_brands) && $prod->category_enabled != 0}
          var brand_name = "{$prod->brand}".replace(/'/g, "`"),
              name = "{$prod->model}".replace(/'/g, "`");{literal}
          set_impressions.push(
          {
              'id': "{/literal}{$prod->product_id}{literal}",
              'name': name,
              'price': "{/literal}{$prod->price}{literal}",
              'brand': brand_name,
              'category': "{/literal}{$prod->category_name}{literal}",
              'variant': "{/literal}{$prod->sku}{literal}",
          }
      );
  {/literal}{/if}{/foreach}{/if}{literal}

    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      dataLayer.push({
        'ecommerce': {
         'currencyCode': 'RUB',
         'detail': {
           'actionField': {'list': list},
           'products': [product]
         }
        },
        'event': 'gtm-ee-event',
        'gtm-ee-event-category': 'Enhanced Ecommerce',
        'gtm-ee-event-action': 'Product Details',
        'gtm-ee-event-non-interaction': true,
      });
      console.log(dataLayer);
    }

  jQuery(window).on('scroll',function() {
    if(jQuery('#viewed_products').visible(true) && viewed_send === false){
      if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        dataLayer.push({
          'ecommerce': {
           'currencyCode': 'RUB',
           'detail': {
             'actionField': {'list': list}
           },
           'impressions': viewed_impressions
          },
          'event': 'gtm-ee-event',
          'gtm-ee-event-category': 'Enhanced Ecommerce',
          'gtm-ee-event-action': 'Product Details',
          'gtm-ee-event-non-interaction': true,
        });
        console.log(dataLayer);
        viewed_send = true;
      }
    }
    if(jQuery('#set_products').visible(true) && set_send === false){
      if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        dataLayer.push({
          'ecommerce': {
           'currencyCode': 'RUB',
           'detail': {
             'actionField': {'list': list}
           },
           'impressions': set_impressions
          },
          'event': 'gtm-ee-event',
          'gtm-ee-event-category': 'Enhanced Ecommerce',
          'gtm-ee-event-action': 'Product Details',
          'gtm-ee-event-non-interaction': true,
        });
        console.log(dataLayer);
        set_send = true;
      }
    }
  });

  function add_to_cart(){
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
      product["quantity"] = 1;
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
  }
	jQuery(document).ready(function() {
        if($('#size_system').html()){
			var size_system = String($('#size_system').html());
			var start_cut = String($('#size_system').html()).indexOf("(");
			if(start_cut !=-1) {
				size_system = size_system.substr(start_cut);
				$('.size_system_type').text($('.size_system_type').text().replace(size_system, ''));
				$('.size_system_type_mob').text($('.size_system_type').text().replace(size_system, ''));
				if (size_system != '(Обхват шеи)' && size_system != '(INT)' && size_system != 'undefined'){
					$('.ShAA_sizeLink').append('&nbsp;' + size_system);
				}
			}
        }
		jQuery('#mycarousel').jcarousel();
		jQuery('#mycarousel li').first().addClass("active");
		jQuery('#mycarousel').css( "width", "100%" );
		jQuery('#mycarousel li').mouseup(function() {
			jQuery('#mycarousel li').removeClass("active");
			jQuery(this).addClass("active");
		});
		jQuery('#mycarousel li').hover(function() {
			jQuery(this).find('.shadow').css("display", "none");},
			function() {
			jQuery(this).find('.shadow').css("display", "block");}
		);

        // img_size_width = ((jQuery('.lazyOwl').parent().parent().width())*0.9).toFixed().toString();
        // src_img = jQuery('.lazyOwl').attr('src').replace('560', img_size_width);
        // jQuery('.lazyOwl').not('#mobiframe').not('.not_replace').attr('src', src_img);
	});

    function addvideo() {
        var video_link = "{/literal}{$product->video|replace:'watch?v=':'embed/'}?rel=0&amp;showinfo=0{literal}";
        jQuery('#PlaxDivVideo').html("<div class='ShAA_videoLink'><iframe class='lazyOwl' width='100%' height='100%' src="+video_link+" frameborder='0' allowfullscreen></iframe></div>");
    }

var $j = jQuery.noConflict();
jQuery(document).ready(function() {
    if(jQuery(window).width() > 1000){ jQuery('#video_zoom').detach();}
    var owl = jQuery(".owl-carousel");
    owl.owlCarousel({
        lazyLoad:   true,
        navigation: true,
        navigationText: ['&#8249;','&#8250;'],
        singleItem: true,
        items: 1
    });
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
  var list_class = $(".zoomImg");
  var list_id = [];
  for(var i=0;i<list_class.length;i++){list_id.push(list_class[i])};

  var list_id= list_id;//.reverse();
  for(i=0;i<list_id.length;i++){
      jQuery( '#big_carousel' ).append(list_id[i]);
      var list_id= list_id;//.reverse();
      list_id[i].setAttribute('id', i)
      var list_id= list_id;//.reverse();
  }

  jQuery( '#big_carousel' ).addClass('parallax_c');
  jQuery('#PlaxDiv').css({'position' : 'absolute'} );
  jQuery('#big_carousel').children().css({'width' : '33%', 'float' : 'left', 'margin':'0'} );

    jQuery('#PlaxDivVideo').css('cursor','pointer');
    jQuery('#PlaxDivVideo a').css('cursor','pointer');

    jQuery('#PlaxDivVideo a').eq(0).click();

	jQuery('ul.tabs li').css('cursor', 'pointer');
	var top = 101;
	jQuery(window).scroll(function () {
		if(jQuery(this).scrollTop() > top) {
			jQuery(".mainMenu").css({"position": "fixed",
								"top": "0"
								});
		}
		if(jQuery(this).scrollTop() <= top) {
			jQuery(".mainMenu").css("position", "relative");
		}
	});

	jQuery("#phone_number").blur(function() {
		var phone_number = jQuery(this).val();
	});
	jQuery("#name").blur(function() {
		var name = jQuery(this).val();
	});
	jQuery('ul.tabs.tabs1 li').click(function(){
		var thisClass = this.className.slice(0,2);
		jQuery('div.t1').hide();
		jQuery('div.t2').hide();
		jQuery('div.' + thisClass).show();
		jQuery('ul.tabs.tabs1 li').removeClass('tab-current');
		jQuery(this).addClass('tab-current');
	});

	jQuery('.ShAA_sizeNotSelect').click(function(){
		jQuery('.ShAA_sizeNotSelect').removeClass('on');
		jQuery(this).addClass('on');
		var thisText = jQuery(this).text();
		jQuery('#userCurrentSize').show();
		jQuery('#userCurrentSize').html(thisText);
	});

	jQuery(document).on("click", '#addToCart', function(e) {
		e.preventDefault();
    add_to_cart();
		var size = jQuery('.ShAA_sizeNotSelect.on > a').data('size');
    var href_tmp = jQuery(this).attr('href');
    window.location = href_tmp + "&size=" + size;
    if( jQuery.cookie('language') === 'eng'){var t = 'Make an order';}
    else{var t = 'Оформить заказ';}
    jQuery('.ShAA_oneClickAdd', this).html();
    jQuery(this).attr('href', '/cart/');
	});
    jQuery(document).on("click", '#addToWishList', function(e) {
		e.preventDefault();
		var size = jQuery('.ShAA_sizeNotSelect.on > a').data('size');
        var href_tmp = jQuery(this).attr('href');
		window.location = href_tmp + "&size=" + size;
	});
    jQuery(document).on("click", '.ShAA_sizeLink', function(e) {
        if (!jQuery(".ShAA_oneClickAdd :contains('Заказать звонок')") || !jQuery(".ShAA_oneClickAdd :contains('Request a call')")) {
            var tocart = jQuery( ".addToBlock a:first-child" );
            tocart.attr('title', 'Положить в корзину');
            tocart.attr('id', 'addToCart');
            tocart.attr('href', '/index.php?module=Cart&product_id={/literal}{$product->product_id}{literal}');
            tocart.find('span').html('В корзину');


        }

        let sizePrice = jQuery(this).data('price');

        if (sizePrice) {
            jQuery('span[itemprop = highPrice]').text(sizePrice);
            jQuery('b[itemprop = lowPrice]').text(sizePrice);
        }
	});
	function startParallax(width, pos, id, clickId) {
        var height = jQuery(window).height();
        jQuery( '.parallax_l' ).width(width);
        jQuery(window).scrollTop(0);
        jQuery( '#headBlock' ).addClass('ShAA_fixedMenuZoom');
        jQuery( '.parallax_c' ).css({'position':'fixed','top':0,'left':0,'z-index':8});
        jQuery( '.parallax_c' ).width(width).height(height);
        jQuery( '#'+id ).parent().removeAttr( 'style' );
        jQuery( '#owl-demo' ).addClass('owl-demo-show');
        jQuery( '#owl-demo' ).removeClass('owl-demo-hide');
        jQuery( '.owl-demo-show' ).prepend('<div style="position: absolute; right: -33px; top: -18px;" id="parallax_close"></div>');
        jQuery( '.zoomImg' ).parent().hide();
        jQuery( '#'+id ).parent().css({'display':'block', 'margin':'0 auto'});
        jQuery( '#'+id ).parent().parent().css({'width':'100%'});
        // jQuery('.parallax_l').removeClass('ShAA_maxWidthBlock');
        var range = (jQuery('#'+id).height()/2 - 202);
        jQuery('.parallax_l').plaxify({"xRange":0,"yRange":range,"invert":true});
        jQuery.plax.enable({ "activityTarget": jQuery('#PlaxDiv')});
        jQuery('#footer, #header').addClass('invisible');
    }
	function stopParallax(id) {
        //jQuery( '#'+id ).removeAttr( 'style' );
        jQuery( '#parallax_close' ).remove();
        jQuery( '.parallax_c' ).removeAttr( 'style' );
        jQuery('#PlaxDiv').css({'position' : 'absolute'} );
        jQuery( '.parallax_l' ).removeAttr( 'style' );
        jQuery( '.zoomImg' ).parent().show();
        //jQuery('.parallax_l').addClass('ShAA_maxWidthBlock');
        jQuery( '#owl-demo' ).addClass('owl-demo-hide');
        jQuery( '#owl-demo' ).removeClass('owl-demo-show');
        jQuery.plax.disable({'clearLayers':true});
        jQuery('#footer, #header').removeClass('invisible');
        jQuery( '#headBlock' ).removeClass('ShAA_fixedMenuZoom');
        enableScroll();
    }
	function resizeParallax(width) {
        if (jQuery("#owl-demo").hasClass('owl-demo-show')){
            var height = jQuery(window).height(),
                width  = jQuery(window).width();
            jQuery( '.parallax_l' ).width(width);
            jQuery( '.parallax_c' ).width(width).height(height);
            jQuery('.ShAA_zoomImageForProduct').css({'width': (width) + 'px'});
            if(jQuery(window).width() < 1000){enableScroll(); stopParallax('owl-demo')}
            if(jQuery(window).width() > 1000){disableScroll();}
        }
    }

    jQuery(window).resize(function () {
        resizeParallax();
		if($('.vimeoblock')) {
			var hvimeo = $('.zoomImg').last().height() - 2;
			$('.vimeoblock').height(hvimeo);
		}
    });
    var j=0;
	jQuery(document).on("click", '.zoomImg', function () {
        var src = '';
        src = jQuery(this).attr('src').replace('340x/', '750x/');
        jQuery(this).attr('src', src);
        if(jQuery(window).width() < 1000){return false;}
        var width = jQuery(window).width();
        var clickId = jQuery(this).attr('id');
        $(".owl-carousel").owlCarousel();
        var owl = $(".owl-carousel").data('owlCarousel');
        owl.goTo(clickId);
        owl.prev();
        owl.next();
        //owl.trigger('goTo.owl.carousel', [4, 300, true]);
        var styleSpan = "float: left; width: 33%;";
        // if (jQuery('.lazyOwl').hasClass('ShAA_zoomImageForProduct')){
        //      jQuery('.lazyOwl').parent().attr('style', styleSpan);
        //      stopParallax(clickId);
        // }
        // else{
        startParallax(width, "-25%", 'owl-demo', clickId );
        // }
        //jQuery(".lazyOwl").toggleClass('ShAA_zoomImageForProduct');
    });

    jQuery(document).on("click", '#parallax_close', function() {
        var showImgId = jQuery('.ShAA_zoomImageForProduct').attr('id');
        var styleSpan = "float: left; width: 33%;";
        jQuery('#'+showImgId).parent().attr('style', styleSpan);
        stopParallax(showImgId);
        jQuery(".lazyOwl").removeClass('ShAA_zoomImageForProduct');
    });

	{/literal}
	var brand_name = "{$brand->name}".replace(/'/g, "`");
	{literal}
	jQuery('.logoOnline').html(
	'<a href="/brands/{/literal}{$brand->url}{literal}/"><img style="margin: 0;" alt="' + brand_name + '" title="' + brand_name + '" src="/files/brands/{/literal}{$brand->image}{literal}" /></a>'
	);

	jQuery(".ShAA_textDescrProd > a").click(function () {
		if(!jQuery(this).hasClass('active')){
			jQuery("div.ShAA_textDescrProd > a").removeClass('active');
			jQuery("div.ShAA_textDescrProd a > i").removeClass('icon-minus-square-o');
			jQuery("div.ShAA_textDescrProd a > i").addClass('icon-plus-square-o');
			jQuery('.ShAA_prodField').slideUp();
			jQuery(this).addClass('active');
			jQuery(this).find("i").removeClass('icon-plus-square-o');
			jQuery(this).find("i").addClass('icon-minus-square-o');
			jQuery(this).next('.ShAA_prodField').slideDown();
		} else {
			jQuery(this).removeClass('active');
			jQuery(this).find("i").removeClass('icon-minus-square-o');
			jQuery(this).find("i").addClass('icon-plus-square-o');
			jQuery(this).next('.ShAA_prodField').slideUp();
		}
		return false;
	});

    var heightblock = (((jQuery('.item:first').width()*8)/17)).toFixed();
    jQuery('#mobiframe').css('height', heightblock);
    jQuery(window).resize(function(){
        var heightblock = ((jQuery('.item:first').width()*8)/17).toFixed();
        jQuery('#mobiframe').css('height', heightblock);
    });
});
{/literal}
</script>

{literal}
<script type="text/javascript">
	//CloudZoom.quickStart();
</script>
{/literal}
<div class="Product_centerRightContent" itemscope itemtype="http://schema.org/Product">
    <div class="Product_leftBlockForProduct" {if $product->category_id == 8233} style="padding-left:  24px;"{/if}>
        <div class="productInfo">
            <div style="display: none">
                <input id="this_product_id" value="{$product->product_id}"/>
                <input id="this_category_id" value="{$product->category_id}"/>
            </div>
            <div class="description">
                <div title="{if $language=='eng'}Tell this number to the store employee to accurately indicate the product you are interested in.{else}Сообщите этот номер сотруднику магазина, чтобы точно указать интересующий вас товар{/if}" style="margin: 0 0 6px 0;">
                    ID: {$product->product_id}
                </div>
                <h1>
                    <span itemprop="name">
                    {if $smarty.session.user->group_id && $smarty.session.user->group_id != 1}
                        <a href="/admin/index.php?section=Product&item_id={$product->product_id}" target="_blank">
                            {$group_name|escape}
                        </a>
                    {else}
                        {$group_name|escape}
                    {/if}
                    </span>
                    <a class="ShAA_productDesigner" href="/brands/{$brand->url}/" rel="nofollow" itemprop="brand">{$brand->name}</a>
                </h1>&nbsp;
                <!--{if $product->properties}{foreach from=$product->properties item=property key=key}{if $property->name == 'Страна происхождения'} {$property->value|escape} {/if}{/foreach}{/if}--><br />
                {if $product->model_full}{$product->model_full}</br>{/if}
                <div  itemprop="offers" itemscope itemtype="http://schema.org/AggregateOffer">
                  {if ($can_buy_from_site || $product->show_out_of_stock)}
                    {if $product->prices.first_price}
                      {if $brand->show_delta}
                        <span class="price rub" style="position: relative; width: auto; line-height: 1em !important;display: inline-block;"><span itemprop="highPrice">{$product->prices.first_price|string_format:"%.0f"}</span><span class="ShAA_lineThrough"></span>&nbsp;<i class="icon-rub"></i></span>
                        {foreach from=$cat_currencies item=currency}
                          {assign var="c_name" value="first_price_`$currency->code`"}
                          <span class="price {$currency->code}" style="display:none; position: relative; width: auto; line-height: 1em !important;"><span>{$product->prices.$c_name|string_format:"%.0f"}</span><span class="ShAA_lineThrough"></span>&nbsp;<b>{$currency->sign}</b></span>
                        {/foreach}
                      {/if}
                    {else}
                      <span class="price rub">
                          <span itemprop="highPrice">
                        {if $product->sizes[0]->price}
                            {$product->sizes[0]->price|string_format:"%.0f"}
                        {else}
                            {$product->prices.price|string_format:"%.0f"}
                        {/if}
                          </span>&nbsp;
                          <i class="icon-rub"></i>
                      </span>
                      {foreach from=$cat_currencies item=currency}
                        {assign var="c_name" value="price_`$currency->code`"}
                        <span class="price {$currency->code}" style="display:none;">{$product->prices.$c_name|string_format:"%.0f"}&nbsp;<b>{$currency->sign}</b></span>
                      {/foreach}
                    {/if}
                    <br/>

                    {if $product->prices.sale_price.price > 0}
                      <span class="price rub"><b style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}" itemprop="lowPrice">{$product->prices.sale_price.price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i> </span>
                      {foreach from=$cat_currencies item=currency}
                        {assign var="c_name" value="price_`$currency->code`"}
                        <span class="price {$currency->code}" style="display:none;"><span style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}"><b>{$product->prices.sale_price.$c_name|string_format:"%.0f"}</b></span>&nbsp;<b>{$currency->sign}</b></span>
                      {/foreach}
                      {if $language=='eng'}Sale price{else}Цена со скидкой{/if}
                      <br/>
                    {/if}

                    {if $product->prices.vip_price.price > 0}
                      <span class="price rub"><b itemprop="lowPrice">{$product->prices.vip_price.price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i></span>
                      {foreach from=$cat_currencies item=currency}
                        {assign var="c_name" value="price_`$currency->code`"}
                        <span class="price {$currency->code}" style="display:none;"><b>{$product->prices.vip_price.$c_name|string_format:"%.0f"}</b>&nbsp;<b>{$currency->sign}</b></span>
                      {/foreach}
                      {if $language=='eng'}With your <b>VIP discount</b>{else}С ВАШЕЙ <b>VIP СКИДКОЙ</b>{/if}
                      <br/>
                    {/if}
                    {if $product->price >= $config->max_price_delivery}
                        {if $language=='eng'}Free delivery{else}Доставка бесплатно{/if}
                    {else}
                        {assign var="diff" value=$config->max_price_delivery-$product->price}
                        {if $language=='eng'}If you order extra-goods for {else}При покупке ещё на {/if}<span class="price rub">{$diff}&nbsp;<i class="icon-rub"></i></span><span class="price usd" style="display:none;">{$diff/$settings->dollar_price|string_format:"%.0f"}&nbsp;<i class="icon-usd"></i></span><span class="price eur" style="display:none;">{$diff/$settings->euro_price|string_format:"%.0f"}&nbsp;<i class="icon-eur"></i></span><span class="price gbp" style="display:none;">{$diff/$settings->pound_price|string_format:"%.0f"}&nbsp;<i class="icon-gbp"></i></span>{if $language=='eng'}. we will deliver your order for free {else}доставим бесплатно{/if}
                    {/if}
                    {/if}
                </div>
{if ($product->category_id == 8346 || $product->category_id == 8341 || $product->category_id == 8342) && $product->old_price > $product->price}
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
        timeTo: new Date('July 16 2017 00:00:00'),
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
 <div style="margin: 5px 0 0 0; display: none;">
	<div style="clear: both;">Осталось: <span class="ShAA_timeClassProd"></span></div>
</div>
{/if}

		{if $smarty.session.user->group_id == 2 && $product->tsum_price}
		    <br>
		    Цена в ЦУМе: <a href="{$product->tsum_price->url}">{$product->tsum_price->price}</a>
		{/if}
		{if $smarty.session.user->group_id > 1}
		    <!--<br>Магазины: {$product->item_location}-->
		{/if}
		{if $brand->offline_only && !$can_buy_from_site}
      <br>{if $language=='eng'}This item is available only in stores.{else}Товар доступен только в бутиках.{/if}
		{/if}
		{if $product->unreturnable}
      <br><span style="color:red;">{if $language=='eng'}*Attention! Underclothes are non-refundable.{else}*Внимание! Бельё возврату не подлежит.{/if}</span>
		{/if}
        </div>
    </div>
{if ($product->size != '<option selected="selected"></option>') || $product->sku == 'testproduct'}
        <div class="productInfo ShAA_maxSizeWindow">
        {if ($product->size == '<option selected="selected"></option>')}--{$product->size}--{/if}

            <div class="addToBlock" style="margin: 0px 0 20px 0; width: 100%;">
{if $can_buy_from_site || $product->show_out_of_stock || $product->brand_id == 461}
              {if $can_buy_from_site}
                {if $change_title}
                    <a title="{if $language=='eng'}Make an order{else}Оформить заказ{/if}" rel="nofollow" href="/cart/">
                        <span class="ShAA_oneClickAdd">{$change_title}{if $cart_products_num}&nbsp;({$cart_products_num}){/if}</span>
                    </a>
                {else}
                    <div style="float: left; width: 100%;">
                        <a id="addToCart" {if $smarty.session.user && $product->category_id != 8233} class="ShAA_withWishlist" {/if} title="{if $language=='eng'}Add to cart{else}Положить в корзину{/if}" rel="nofollow" href="/index.php?module=Cart&amp;product_id={$product->product_id}">
                            <span class="ShAA_oneClickAdd">{if $language=='eng'}Add to cart{else}В Корзину{/if}</span>
                        </a>
                        {if $smarty.session.user}
                            {* Сертификаты *}
                            {if $product->category_id != 8233}
                                {if $product_from_wl}
                                    <a style="float: left; margin: 12px 0 0 12px;" title="{if $language=='eng'}Remove{else}Убрать из избранного{/if}" id="removeFromWishList" href="/index.php?module=Cart&amp;remove_from_wishlist&amp;product_id={$product->product_id}&amp;size=all" >
                                        <span class="addToWishList" style="color: #000;">
                                            <i class="icon-heart" style="color: #C30000;"></i>
                                        </span>
                                    </a>
                                {else}
                                    <a style="float: left; margin: 12px 0 0 12px;" title="{if $language=='eng'}to Wishlist{else}В избранное{/if}" id="addToWishList" href="/index.php?module=Cart&amp;add_to_wishlist&amp;product_id={$product->product_id}" onclick="{literal}if (jQuery('#userCurrentSize').eq(0).text() == '0') { alert('Пожалуйста, выберите подходящий размер'); return false;} this.href += ('&amp;size='+jQuery('#userCurrentSize').eq(0).text()); document.cookie='from='+location.href+';path=/'; rG('ADD_TO_WISHLIST');{/literal}">
                                        <span class="addToWishList" style="color: #000;">
                                            <i class="icon-heart-o"></i>
                                        </span>
                                    </a>
                                {/if}
                            {/if}
                        {/if}
                    </div>
                {/if}
                <a title="{if $language=='eng'}Buy in 1 click{else}Совершить покупку в один клик{/if}" href="/oneclick/{$product->product_id}/" id="edit_link" onclick="{literal}rG('BUY_1_CLICK_SITE');{/literal}">
                    <span class="ShAA_oneClickAdd">{if $language=='eng'}Buy in 1 click{else}Купить в 1 клик{/if}</span>
                </a>
              {/if}
{/if}
{if $can_buy_from_site || $product->show_out_of_stock}
{else}
                <p>
                    <a title="{if $language=='eng'}Request a call{else}Заказать звонок{/if}" style="width: 45px;" href="/helpform/{$product->product_id}/" onclick="{literal}rG('REQUEST_CALL_SITE');{/literal}">
                        <span class="ShAA_oneClickAdd">{if $language=='eng'}Request a call{else}Заказать звонок{/if}</span>
                    </a>
                </p>
{/if}
            </div>
{if !$no_size && !$brand->hide_sizes}

            <div class="sizeBlock">
                <div class="productInfo">
                    {if $product->sizes_url}
                        <span class="size_system_type" style="float: left; line-height: 21px; margin: 4px 12px 6px 0;"> {if $language=='eng'}Sizes{else}Размеры{/if} {if $product->size_system}- <span id="size_system">{$product->size_system}</span>{/if}</span>
                        <div style="clear:both;"></div>
                    {/if}
                    <ul class="ShAA_sizeUl">
                        {foreach from=$product->sizes key=k item=size_t}
                            <li class="ShAA_sizeNotSelect {if $product->admin_details->sizes_allowed[$size_t]} red_mark{/if} {if $k == 0} on{/if} ">
                                <a class="size-select-btn ShAA_sizeLink"
                                   data-barcode="{$size_t->barcode}"
                                   data-remote-warehouse="{$size_t->remote_warehouse}"
                                   data-size="{$size_t->size}"
                                   data-price="{$size_t->price}"
                                   title="{$size_t->size}">
                                    {$size_t->size}{if $size_t->remote_warehouse}<i style="margin-top:2px;font-size:16px" class="pull-right icon-info-circle"></i>{/if}
                                </a>
                            </li>
                        {/foreach}
                    </ul>
                    <div style="clear:both;"></div>
                    <div id="info-chance" class="wh-info" style="display:none;margin:5px 0 5px 0;"><i style="margin-top:-2px;" class="icon-large icon-info-circle"></i> Есть шанс приобрести</div>
                    <div id="info-return" class="wh-info" style="display:none;margin:5px 0 5px 0;"><i style="margin-top:-2px;" class="icon-large icon-info-circle"></i> На складе в Италии</div>
                </div>
                <a title="{if $language=='eng'}Special order{else}Спец. заказ{/if}" href="/specialorder/{$product->product_id}/" onclick="{literal}rG('BUY_SPECIAL_ORDER_SITE');{/literal}">
                    <span style="margin-top:5px;" class="addToWishList ShAA_oneClickAddOld">{if $language=='eng'}Another size{else}Другой размер{/if}</span>
                </a>
{if $product->sizes_url}
                <div class="clear"></div>
                <div class="sizePages">
                    <span class="sizeImg" style="cursor:pointer;width:150px;" title="{if $language=='eng'}Open size table{else}Открыть таблицу размеров{/if}" onclick="popupWin = window.open('{$product->sizes_url}', 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;">
                        {if $language=='eng'}Size&nbsp;table&nbsp;{else}Таблица&nbsp;размеров&nbsp;{/if}<a href="{$product->sizes_url}" target="_blank" onclick="popupWin = window.open(this.href, 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;"><img src="/images/size_icon.png" alt="" /></a>
                    </span>
                </div>
{/if}
            </div>
{/if}
    {assign var='allowed_groups' value=','|explode:"2,3,5,6,7,9"}
    {if $smarty.session.user->group_id|in_array:$allowed_groups}
      <!--<br>
      <a id="mark-not-available" href="#">
        <span style="margin-top:5px;" class="addToWishList ShAA_oneClickAddOld">Товара нет в наличии</span>
      </a>
      <br>-->
    {/if}
    <div style="clear: both;">
    {if $product->season}
        <div class="ShAA_newSeasonIcon ShAA_lableForProductPage" {if ($language != 'eng')} title="сезон" {else} title="season" {/if} style="cursor: help;">{$product->season}</div>
    {/if}
    {foreach from=$product->materials item=material key=key}
        <div class="ShAA_newSeasonIcon ShAA_lableForProductPage" {if ( $material->description && $language != 'eng')} title="{$material->description}" style="cursor: help;" {/if}>{$material->name}</div>
    {/foreach}
    </div>
</div>
{else}
	<div style="float: left; padding: 0 0 16px 0; font-size: 12px;">{if $language=='eng'}This product is currently out of stock, <br/> but we can bring it to you on order.{else}Этого товара сейчас нет в наличии,<br/> но мы можем привезти его вам под заказ.{/if}</div>
    <a title="{if $language=='eng'}Special order{else}Спец. заказ{/if}" href="/specialorder/{$product->product_id}/">
        <span class="addToWishList ShAA_oneClickAddOld">{if $language=='eng'}Special order{else}Спец. заказ{/if}</span>
    </a>

{/if}
    <div class="clear"></div>
    <div class="ShAA_descBlockForProduct" itemprop="description">
    {if $product->admin_details}
        <div class="ShAA_textDescrProd">
            <a href="" class="active">
                <span class="ShAA_titleDescForProduct">детали для сотрудника</span>
                <i class="icon-minus-square-o"></i>
            </a>
            <div class="ShAA_prodField" style="display: block;">
              {if $product->super_price}К товару применена супер цена! Скидка {$product->admin_details->super_sale}&nbsp;%<br />{/if}
              Скидка на сезон "{$product->season}": {$product->admin_details->sales->sale}&nbsp;%<br />
              Максимальная скидка: {$product->admin_details->sales->max_sale}&nbsp;%<br />
              Начальная цена: {$product->admin_details->offline_price}&nbsp;<i class="icon-rub"></i><br />
              {foreach from=$product->admin_details->wares item=w}
                <span{if in_array($w->shop_id,$hid_shops) || !$w->shop_id} style="color:red;"{/if}>{$w->barcode}, {if $product->category_parent == 2}(RU){$w->ru_size}{else}(INT){$w->int_size}{/if}, {$w->i_size}: {$w->warehouse_name}</span><br />
              {/foreach}
              {if $product->admin_details->history}
                История просмотров товара:
                <span class="filter_on">Показать</span><span class="filter_on" style="display:none;">Спрятать</span>
                <div class="prod_views" style="display: none;">
                  {foreach from=$product->admin_details->history item=pv}
                    <p>{$pv->date}: <a href="/admin/index.php?section=User&user_id={$pv->user_id}">{$pv->name}</a>, <a href="https://wa.me/{$pv->phone_number}">{$pv->phone_number}</a>, цена: {$pv->price_at_the_time}</p>
                  {/foreach}
                </div>
              {/if}
            </div>
        </div>
      {/if}
      {if $language != 'eng'}
        <div class="ShAA_textDescrProd">
            <a href="">
                <span class="ShAA_titleDescForProduct">Описание</span>
                <i class="icon-plus-square-o"></i>
            </a>
            <div class="ShAA_prodField">
                <!--{foreach from=$product->properties item=property key=key}{if preg_match('/Материал/',$property->name)}Cостав: {$property->value}{/if}{/foreach}
                Цвет: {$color_name->name}<br />-->
                {* Подиумы *}
                {if !$podium}
                    Коллекция сезона: {$product->season}<br />
                {/if}
                {if $smarty.session.user->group_id && $smarty.session.user->group_id != 1}Артикул: <noindex>{$product->sku}</noindex><br />{/if}
                {if $product->item_location_link}
                <!--Вы можете приобрести эту вещь <br />в нашем <a target="_blank" href="{$product->item_location_link}">магазине {$product->item_location_name}</a>-->
                {/if}
            </div>
        </div>
      {/if}
        <div class="redactText">
            {if $description || ($product_brand_text && $language!='eng')}
                <div class="ShAA_textDescrProd">
                    <a href="">
                        <span class="ShAA_titleDescForProduct">{if $language=='eng'}Description{else}От редактора{/if}</span>
                        <i class="icon-plus-square-o"></i>
                    </a>
                    <div class="ShAA_prodField">
                        {if $description}
                            {$description}
                        {else}
                            {$product_brand_text}
                        {/if}
                    </div>
                </div>
            {/if}
            {if $product->body}
                <div class="ShAA_textDescrProd">
                    <a href="" class="active">
                        <span class="ShAA_titleDescForProduct">{if $language=='eng'}Details{else}Детали{/if}</span>
                        <i class="icon-minus-square-o"></i>
                    </a>
                    <div class="ShAA_prodField" style="display: block;">
                        {$product->body}
                    </div>
                </div>
            {/if}
            {if $product->text_sizes}
                <div class="ShAA_textDescrProd">
                    <a href="">
                        <span class="ShAA_titleDescForProduct">{if $language=='eng'}Fabric{else}Состав{/if}</span>
                        <i class="icon-plus-square-o"></i>
                    </a>
                    <div class="ShAA_prodField">
                        {$product->text_sizes}
                    </div>
                </div>
            {/if}
            {if $product->uhod}
                <div class="ShAA_textDescrProd">
                    <a href="">
                        <span class="ShAA_titleDescForProduct">{if $language=='eng'}Care{else}Уход{/if}</span>
                        <i class="icon-plus-square-o"></i>
                    </a>
                    <div class="ShAA_prodField">
                        {$product->uhod}
                    </div>
                </div>
            {/if}
        </div>
        <div class="clear"></div>
    </div>
</div>
<div class="Product_rightBlockForProduct">
    <div class="Product_productImgBlock">
        <div class="Product_productMiddleImg">
            <div id="owl-demo" class="owl-carousel owl-demo-hide">
				{if $product->vimeo}
					<div class="item" style="width: 80%; margin: 0 auto; background: url('/jscript/AjaxLoader.gif') no-repeat; background-position: center;">
						<div class="product-image main-image ShAA_vimeoVideo">
							<iframe src="{$product->vimeo}?autoplay=1&autopause=0&background=1&muted=1&loop=1" width="320" height="480"  frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="float: left;"></iframe>
						</div>
					</div>
				{/if}
                {if $empty_foto}
                    <div class="item">
                        <img class="lazyOwl" src="" data-src="/images/noimg.png" alt="фото товара" />
                    </div>
                {else}
                    {if $product->large_image }
                        <div class="item">
                            <img class="lazyOwl" src="" data-src="/reimg/files/products/750x/{$product->large_image}" alt="{$product->img_desc}" />
                        </div>
                    {/if}
                    {if $big_size && $product->bsize_small_image}
                        <div class="item">
                            <img class="lazyOwl" src="" data-src="/reimg/files/products/750x/{$product->bsize_small_image}" alt="{$product->img_desc}" />
                        </div>
                    {elseif $product->small_image}
                        <div class="item">
                            <img class="lazyOwl" src="" data-src="/reimg/files/products/750x/{$product->small_image}" alt="{$product->img_desc}" />
                        </div>
                    {/if}
                    {if $product->promo_image}
                        <div class="item">
                            <img class="lazyOwl" src="" data-src="/reimg/files/products/750x/{$product->promo_image}" alt="{$product->img_desc}" />
                        </div>
                    {/if}
                    {if $product->fotos}
                        {foreach from=$product->fotos item=foto}
                            <div class="item">
                                <img class="lazyOwl" src="" data-src="/reimg/files/products/750x/{$foto->filename}" alt="{$product->img_desc}" />
                            </div>
                        {/foreach}
                    {/if}
                    {if $product->video}
                        <div id="video_zoom" class="item">
                            <iframe id="mobiframe" class="lazyOwl" style="width: 80%;" src="{$product->video|replace:'watch?v=':'embed/'}?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
                        </div>
                    {/if}
                {/if}
            </div>
            {if $product->video}
                <div id="PlaxDivVideo">
                    <a href="#" onClick="addvideo(); return false;" id="{$product->large_image}"></a>
                </div>
            {/if}
            {if $product->category_id != 8233}
              <div class=" pr_parallax" id="big_carousel">
				{if $product->vimeo}
					<div style="float: left; background: url('/jscript/AjaxLoader.gif') no-repeat; background-position: center;">
						<div id="_vimeoVideo" class="product-image main-image ShAA_vimeoVideo">
							<iframe src="{$product->vimeo}?autoplay=1&autopause=0&background=1&muted=1&loop=1" width="320" height="480"  frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="float: left;"></iframe>
							<img style="background: #333; position: absolute; top: 0; left: 0; height:auto; opacity: 0; z-index: 999; background: #ccc;" class="cloudzoom zoomImg vimeoblock" src="{$product->vimeo}?autoplay=1&autopause=0&background=1&muted=1&loop=1" data-cloudzoom="disableZoom: true" itemprop="image" />
						</div>
					</div>
				{/if}
			  </div>
                <div class="parallax_c pr_parallax" id="PlaxDiv">

                    <div class="parallax_l ShAA_maxWidthBlock">
                        {if $empty_foto}
                            <div style="float: left;">
                                <div style="width: 33%; margin: 0 auto;" class="product-image main-image">
                                    <img class="cloudzoom zoomImg" alt="фото товара" title="фото товара" id="no_image" src="/images/noimg.png" data-cloudzoom="disableZoom: true" itemprop="image" />
                                </div>
                            </div>
                        {else}
                            <div style="float: left; width: 100%;">

                            {if $product->large_image }

                                <span style="width: 33%; float: left;" class="product-image main-image">
                                    <img class="cloudzoom zoomImg" alt="{$product->img_desc}" title="{$product->img_desc}" id="large_image" src="/files/products/{$product->large_image}" data-cloudzoom="disableZoom: true" itemprop="image" />
                                </span>
                            {/if}
                            {if $big_size && $product->bsize_small_image}
                                <span style="width: 33%; float: left;" class="product-image main-image">
                                    <img class="cloudzoom zoomImg" alt="{$product->img_desc}" title="{$product->img_desc}" id="bsize_small_image" src="/files/products/{$product->bsize_small_image}" data-cloudzoom="disableZoom: true" itemprop="image" />
                                </span>
                            {elseif $product->small_image}
                                <span style="width: 33%; float: left;" class="product-image main-image">
                                    <img class="cloudzoom zoomImg" alt="{$product->img_desc}" title="{$product->img_desc}" id="small_image" src="/files/products/{$product->small_image}" data-cloudzoom="disableZoom: true" itemprop="image" />
                                </span>
                            {/if}
                            {if $product->promo_image}
                                <span style="width: 33%; float: left;" class="product-image main-image">
                                    <img class="cloudzoom zoomImg" alt="{$product->img_desc}" title="{$product->img_desc}" id="promo_image" src="/files/products/{$product->promo_image}" data-cloudzoom="disableZoom: true" itemprop="image" />
                                </span>
                            {/if}
                            {if $product->fotos}
                                {foreach from=$product->fotos item=foto key=k}
                                    {if ($k==1 && !$product->promo_image) || ($k==0 && $product->promo_image)}</div><div style="float: left; width: 100%;">{/if}
                                    <span style="width: 33%; float: left;" class="product-image main-image">
                                        <img class="cloudzoom zoomImg" alt="{$product->img_desc}" title="{$product->img_desc}" id="{$k}" src="/files/products/{$foto->filename}" data-cloudzoom="disableZoom: true" itemprop="image" />
                                    </span>
                                    {if $k+1 is div by 3}
                                        </div><div style="float: left; width: 100%;">
                                    {/if}
                                {/foreach}
                            {/if}
                            </div>
                        {/if}
                    </div>

                </div>
            {/if}
        </div>
    </div>
</div>
<!-- для меньшего размера экрана -->
{if ($product->size != '<option selected="selected"></option>') || $product->sku == 'testproduct'}
<div class="productInfo ShAA_miniSizeWindow">
{if ($product->size == '<option selected="selected"></option>')}--{$product->size}--{/if}

    <div class="addToBlock" style="margin: 0px 0 20px 0; width: 100%;">
{if $can_buy_from_site || $product->show_out_of_stock}
        {if $change_title}
            <a title="{if $language=='eng'}Make an order{else}Оформить заказ{/if}" rel="nofollow" href="/cart/">
                <span class="ShAA_oneClickAdd">{$change_title}{if $cart_products_num}&nbsp;({$cart_products_num}){/if}</span>
            </a>
        {else}
            <div style="float: left; width: 100%;">
<!--
                        <a id="addToCart" {if $smarty.session.user && $product->category_id != 8233} class="ShAA_withWishlist" {/if} title="{if $language=='eng'}Add to cart{else}Положить в корзину{/if}" rel="nofollow" href="/index.php?module=Cart&amp;product_id={$product->product_id}">
                            <span class="ShAA_oneClickAdd">{if $language=='eng'}Add to cart{else}В Корзину{/if}</span>
                        </a>
-->
            <a id="addToCart" title="{if $language=='eng'}Add to cart{else}Положить в корзину{/if}" {if $smarty.session.user && $product->category_id != 8233} class="ShAA_withWishlist" {/if} rel="nofollow" href="/index.php?module=Cart&amp;product_id={$product->product_id}" onclick="{literal}rG('BUY_CART_SITE');{/literal}">
                <span class="ShAA_oneClickAdd">{if $language=='eng'}Add to cart{else}В Корзину{/if}</span>
            </a>

            {if $smarty.session.user}
                {* Сертификаты *}
                {if $product->category_id != 8233}
                    {if $product_from_wl}
                        <a style="float: left; margin: 2px 0 0 12px;" title="{if $language=='eng'}Remove{else}Убрать из избранного{/if}" href="/index.php?module=Cart&amp;remove_from_wishlist&amp;product_id={$product->product_id}&amp;size=all" >
                            <span class="addToWishList" style="color: #000;">
                                <i class="icon-heart icon-2x" style="color: #C30000;"></i>
                            </span>
                        </a>
                    {else}
                        <a style="float: left; margin: 2px 0 0 12px;" title="{if $language=='eng'}to Wishlist{else}В избранное{/if}" id="addToWishList" href="/index.php?module=Cart&amp;add_to_wishlist&amp;product_id={$product->product_id}" onclick="{literal}if (jQuery('#userCurrentSize').eq(0).text() == '0') { alert('Пожалуйста, выберите подходящий размер'); return false;} this.href += ('&amp;size='+jQuery('#userCurrentSize').eq(0).text()); document.cookie='from='+location.href+';path=/'; rG('ADD_TO_WISHLIST');{/literal}">
                            <span class="addToWishList" style="color: #000;">
                                <i class="icon-heart-o icon-2x"></i>
                            </span>
                        </a>
                    {/if}
                {/if}
            {/if}
            </div>
        {/if}
        <a title="{if $language=='eng'}Buy in 1 click{else}Совершить покупку в один клик{/if}" href="/oneclick/{$product->product_id}/" id="edit_link" onclick="{literal}rG('BUY_1_CLICK_SITE');{/literal}">
            <span class="ShAA_oneClickAdd">{if $language=='eng'}Buy in 1 click{else}Купить в 1 клик{/if}</span>
        </a>
{else}
        <p>
            <a title="{if $language=='eng'}Request a call{else}Заказать звонок{/if}" style="width: 45px;" href="/helpform/{$product->product_id}/" onclick="{literal}rG('REQUEST_CALL_SITE');{/literal}">
                <span class="ShAA_oneClickAdd">{if $language=='eng'}Request a call{else}Заказать звонок{/if}</span>
            </a>
        </p>
{/if}
    </div>
{if !$no_size && $can_buy_from_site}

    <div class="sizeBlock">
        <div class="productInfo">
            {if $product->sizes_url}
                <span class="size_system_type_mob" style="float: left; line-height: 21px; margin: 4px 12px 6px 0;"> {if $language=='eng'}Sizes{else}Размеры{/if} {if $product->size_system}- {$product->size_system}{/if}:</span>
                <div style="clear:both;"></div>
            {/if}
            <ul class="ShAA_sizeUl">
                {foreach from=$product->sizes item=size_t}
                    <li class="ShAA_sizeNotSelect">
                        <a class="size-select-btn ShAA_sizeLink" data-barcode="{$size_t->barcode}" data-remote-warehouse="{$size_t->remote_warehouse}" title="{$size_t->size}" data-size="{$size_t->size}">{$size_t->size}{if $size_t->remote_warehouse}<i style="margin-top:2px;font-size:16px" class="pull-right icon-info-circle"></i>{/if}</a>
                    </li>
                {/foreach}
            </ul>
            <div style="clear:both;"></div>
            <div id="info-chance" class="wh-info" style="display:none;margin:5px 0 5px 0;"><i style="margin-top:-2px;" class="icon-large icon-info-circle"></i> Есть шанс приобрести</div>
            <div id="info-return" class="wh-info" style="display:none;margin:5px 0 5px 0;"><i style="margin-top:-2px;" class="icon-large icon-info-circle"></i> На складе в Италии</div>
        </div>
        <a title="{if $language=='eng'}Special order{else}Спец. заказ{/if}" href="/specialorder/{$product->product_id}/" onclick="{literal}rG('BUY_SPECIAL_ORDER_SITE');{/literal}">
            <span style="margin-top:5px;" class="addToWishList ShAA_oneClickAddOld">{if $language=='eng'}Another size{else}Другой размер{/if}</span>
        </a>
{if $product->sizes_url}
        <div class="clear"></div>
        <div class="sizePages">
            <span class="sizeImg" style="cursor:pointer;width:150px;" title="{if $language=='eng'}Open size table{else}Открыть таблицу размеров{/if}" onclick="popupWin = window.open('{$product->sizes_url}', 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;">
                {if $language=='eng'}Size&nbsp;table&nbsp;{else}Таблица&nbsp;размеров&nbsp;{/if}<a href="{$product->sizes_url}" target="_blank" onclick="popupWin = window.open(this.href, 'contacts', 'location,width=785,height=770,top=0'); popupWin.focus(); return false;"><img src="/images/size_icon.png" alt="" /></a>
            </span>
        </div>
{/if}
    </div>
{/if}
</div>
{else}
	<div style="display: none; float: left; padding: 0 0 16px 0; font-size: 12px;">{if $language=='eng'}This product is currently out of stock, <br/> but we can bring it to you on order.{else}Этого товара сейчас нет в наличии,<br/> но мы можем привезти его вам под заказ.{/if}</div>
    <a style="display: none;" title="{if $language=='eng'}Special order{else}Спец. заказ{/if}" href="/specialorder/{$product->product_id}/">
        <span style="display: none;" class="addToWishList ShAA_oneClickAddOld">{if $language=='eng'}Special order{else}Спец. заказ{/if}</span>
    </a>
{/if}
        {if $product->season}
            <div class="ShAA_miniSizeWindow ShAA_newSeasonIcon ShAA_lableForProductPage">{$product->season}</div>
            <div class="clear"></div>
        {/if}
		<div class="ShAA_miniSizeWindow ShAA_descBlockForProduct">
			<div style="clear: both;">
			{foreach from=$product->materials item=material key=key}
				{if ( $material->description )}
					<div class="ShAA_textDescrProd">
						<a href="">
							<span class="ShAA_titleDescForProduct">{$material->name}</span>
							<i class="icon-plus-square-o"></i>
						</a>
            {if $language != 'eng'}
              <div class="ShAA_prodField">
                {$material->description}
              </div>
            {/if}
					</div>
				{/if}
			{/foreach}
			</div>
      {if $product->admin_details}
        <div class="ShAA_textDescrProd">
            <a href="" class="active">
                <span class="ShAA_titleDescForProduct">детали для сотрудника</span>
                <i class="icon-minus-square-o"></i>
            </a>
            <div class="ShAA_prodField" style="display: block;">
              {if $product->super_price}К товару применена супер цена! Скидка {$product->admin_details->super_sale}&nbsp;%<br />{/if}
              Скидка на сезон "{$product->season}": {$product->admin_details->sales->sale}&nbsp;%<br />
              Максимальная скидка: {$product->admin_details->sales->max_sale}&nbsp;%<br />
              Начальная цена: {$product->admin_details->offline_price}&nbsp;<i class="icon-rub"></i><br />
              {foreach from=$product->admin_details->wares item=w}
                <span{if in_array($w->shop_id,$hid_shops) || !$w->shop_id} style="color:red;"{/if}>{$w->barcode}, {if $product->category_parent == 2}(RU){else}(INT){/if}{$w->normal_size}, {$w->i_size}: {$w->warehouse_name}</span><br />
              {/foreach}
              {if $product->admin_details->history}
                История просмотров товара:
                <span class="filter_on">Показать</span><span class="filter_on" style="display:none;">Спрятать</span>
                <div class="prod_views" style="display: none;">
                  {foreach from=$product->admin_details->history item=pv}
                    <p>{$pv->date}: <a href="/admin/index.php?section=User&user_id={$pv->user_id}">{$pv->name}</a>, <a href="https://wa.me/{$pv->phone_number}">{$pv->phone_number}</a>, цена: {$pv->price_at_the_time}</p>
                  {/foreach}
                </div>
              {/if}
              <br>
            </div>
        </div>
      {/if}
      {if $language != 'eng'}
			<div class="ShAA_textDescrProd">
				<a href="">
					<span class="ShAA_titleDescForProduct">Описание</span>
					<i class="icon-plus-square-o"></i>
				</a>
				<div class="ShAA_prodField">
                    <!--{foreach from=$product->properties item=property key=key}{if preg_match('/Материал/',$property->name)}Cостав: {$property->value}{/if}{/foreach}-->
					<!--Цвет: {$color_name->name}<br />-->
					{* Подиумы *}
					{if !$podium}
						Коллекция сезона: {$product->season}<br />
					{/if}
					{if $smarty.session.user->group_id && $smarty.session.user->group_id != 1}Артикул: <noindex>{$product->sku}</noindex><br />{/if}
					{if $product->item_location_link}
					<!--Вы можете приобрести эту вещь <br />в нашем <a target="_blank" href="{$product->item_location_link}">магазине {$product->item_location_name}</a>-->
					{/if}
				</div>
			</div>
      {/if}
			<div class="redactText">
				{if $description || ($product_brand_text && $language!='eng')}
					<div class="ShAA_textDescrProd">
						<a href="">
							<span class="ShAA_titleDescForProduct">{if $language=='eng'}Description{else}От редактора{/if}</span>
							<i class="icon-plus-square-o"></i>
						</a>
						<div class="ShAA_prodField">
							{if $description}
								{$description}
							{else}
								{$product_brand_text}
							{/if}
						</div>
					</div>
				{/if}
				{if $product->body}
					<div class="ShAA_textDescrProd">
						<a href="" class="active">
							<span class="ShAA_titleDescForProduct">{if $language=='eng'}Details{else}Детали{/if}</span>
							<i class="icon-minus-square-o"></i>
						</a>
						<div class="ShAA_prodField" style="display: block;">
							{$product->body}
						</div>
					</div>
				{/if}
				{if $product->text_sizes}
					<div class="ShAA_textDescrProd">
						<a href="">
							<span class="ShAA_titleDescForProduct">{if $language=='eng'}Fabric{else}Состав{/if}</span>
							<i class="icon-plus-square-o"></i>
						</a>
						<div class="ShAA_prodField">
							{$product->text_sizes}
						</div>
					</div>
				{/if}
				{if $product->uhod}
					<div class="ShAA_textDescrProd">
						<a href="">
							<span class="ShAA_titleDescForProduct">{if $language=='eng'}Care{else}Уход{/if}</span>
							<i class="icon-plus-square-o"></i>
						</a>
						<div class="ShAA_prodField">
							{$product->uhod}
						</div>
					</div>
				{/if}
			</div>
			<div class="clear"></div>
		</div>
<!-- END для меньшего размера экрана -->
	        	</div>
	        </div>
	{literal}
	<script type="text/javascript">
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

  jQuery(document).on("click touchstart", ".filter_on", function(e) {
    jQuery('.filter_on').toggle();
    jQuery('.prod_views').slideToggle();
  });
	</script>
{/literal}
	<div id="product_container">
		{if $set_products}
		<div id="set_products" style="position: relative; z-index: 1;">
			<div style="font-weight: normal; margin: 26px 0; text-align: center; text-transform: uppercase;">
				<div class="ShAA_styleManPhoto">
					<img src="/design/adaptive/images/style_man.jpg" title="{if $language=='eng'}Stylist of Luxury Store{else}Стилист Лакшери Store{/if}" alt="{if $language=='eng'}Stylist of Luxury Store{else}Стилист Лакшери Store{/if}" />
				</div>
        {if $language=='eng'}
          Tips from stylist of Luxury Store
        {else}
         <!--<b>Игорь Франц</b>--><br />Стилист Лакшери Store<br /> рекомендует к этому товару
        {/if}
			</div>
			<a title="{if $language=='eng'}See total look{else}Посмотреть полный образ{/if}" href="/look/{$set_id}/">
				<div class="ShAA_oneClickAddOld" style="float: none; margin: 0 auto 12px;">{if $language=='eng'}Total look{else}Полный образ{/if}</div>
			</a>
			<div class="products">
				{include file="items_json.tpl" wallproducts=$set_products}
			</div>
		</div>
		{/if}
		{if $viewed_products}
		<div style="clear:both;"></div>
		<div id="viewed_products" class="mobileViewWathed">
			<div style="font-weight: normal; margin: 26px 0; text-align: center; text-transform: uppercase;">{if $language=='eng'}Recently viewed{else}Вы смотрели{/if}</div>
			<div class="products">
				{include file="items_json.tpl" wallproducts=$viewed_products}
			</div>
		</div>
		{/if}
		<div id="similar_recomendations" style="display:none;">
			<div style="font-weight: normal; margin: 26px 0;">{if $language=='eng'}Similar goods{else}Похожие товары{/if}</div>
			<div class="products"></div>
		</div>
{if $product->product_id}
		<script type="text/javascript">
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
{assign var=hidden_brands value=","|explode:$user->show_hidden_brands}
{if !$oc_ordered && !$so_ordered && $smarty.session.user->group_id < 2 && $config->enviroment == 'live' && !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}
<script>
//Criteo dataLayer
    {literal}
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
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
            });
            dataLayer.push({
                'ecomm_totalvalue' : {/literal}'{$product->price}'{literal},
                'ecomm_prodid' : {/literal}'{$product->product_id}'{literal},
                'ecomm_pagetype': 'product'
            });
        }
    });
    {/literal}
</script>
{/if}
{literal}
<script>
    $ = jQuery;
jQuery(document).ready(function() {
  var product_id = {/literal}{if $product->product_id}{$product->product_id}{else}0{/if}{literal};
  var url = $('#error_message').attr('href') + '?p_id=' + product_id;
  $('#error_message').attr('href', url);
  if($('.vimeoblock')) {
		var hvimeo = $('.zoomImg').last().height() - 2;
		$('.vimeoblock').height(hvimeo);
	}
});

    $(document).on('click', "#mark-not-available", function(e) {
      e.preventDefault();
      var t = $(this)
      var data = {
        error_mess: 'Товара нет в наличии',
        error_page: window.location.href,
        product_id: {/literal}{if $product->product_id}{$product->product_id}{else}0{/if}{literal},
        size: $('.ShAA_sizeNotSelect.on a').data('size')
      };
      if (!data.size && $('.ShAA_sizeNotSelect').length > 0) {
        alert("Выберите размер, которого нет в наличии.")
        return false
      }
      $.post('/cart/error_message/', data, function (response) {
        t.parent().append("Сообщение отправлено")
    	});
    });

    $(document).on("click", ".size-select-btn", function(e) {
      var r = this.dataset.remoteWarehouse
      $("div.wh-info").hide()
      if (r == 0) {
        return false
      }
      else {
        $('div#info-'+r).show()
      }
    });

</script>
{/literal}
