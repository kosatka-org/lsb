<script type="text/javascript" src="/jscript/plax.js"></script>
{literal}
	<script type="text/javascript">
  var currencies = [];
  {/literal}{foreach from=$cat_currencies item=currency}{literal}
    currencies.push({'{/literal}{$currency->code}{literal}': {/literal}{$currency->rate_to}{literal}});
  {/literal}{/foreach}{literal}
		var $order = {total_price: 0, products: []};
		function update_total() {
			var total_price = 0;
			var products = [];
			$('.ShAA_sizeNotSelect.on').each( function( index ) {
				total_price += parseFloat( $(this).data('price') );
				products.push( [$(this).data('product-id'), $(this).find('a').attr('title')] );
			});
			$order = {total_price: total_price, products: products};
			$('#total_price').html($order.total_price);
      for(i = 0; i < currencies.length; i++){
        name = Object.keys(currencies[i])[0];
        $('#total_price_'+name).html(parseInt($order.total_price/currencies[i][name]));
      }
			if ($order.products.length === 0) {
				$("#addToCart").hide();
			}
			else {
				$("#addToCart").show();
			}
		}

		$(document).ready(function() {
			update_total();
			$(document).on("click", ".ShAA_sizeNotSelect", function() {
				$(this).toggleClass("on");
				update_total();
			});

			$(document).on("click", "#addToCart", function(e) {
        e.preventDefault();
        add_to_cart();
        var link = "/index.php?module=Cart";
        window.location = link + "&" + $.param( {product_id: $order.products} );
			});

		});

    function add_to_cart(){
      if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        var products = [];
        $('.ShAA_sizeNotSelect.on').each( function( index ) {
          e = $(this).parents('.ShAA_lookItem');
          products.push(
            {
                'id': e.data('product-id'),
                'name': e.data('model'),
                'price': e.data('price'),
                'brand': e.data('brand'),
                'category': e.data('category'),
                'variant': $(this).find('a').attr('title')+'',
                'quantity': 1
            }
          );
        });
        dataLayer.push({
         'ecommerce': {
           'currencyCode': 'RUB',
           'add': {
             'products': products
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

	function startParallax() {
		var width = $(window).width(),
			height = $(window).height();

		$( '.parallax_l' ).width(width);
		$(window).scrollTop(0);
		$( '.parallax_c' ).prepend('<div id="parallax_close"></div>');
		$( '.parallax_l' ).find('img').css({'height':'auto', 'max-height':'2400px', 'width': width + 'px', 'max-width':'1600px'});
		$( '.parallax_c' ).css({'position':'fixed','top':0,'left':0});
		$( '.parallax_c' ).width(width).height(height);
		var range = ($('#PlaxAct').height())*2 - 1000;
		$('#PlaxAct').plaxify({"xRange":0,"yRange":range,"invert":true});
		$.plax.enable({ "activityTarget": jQuery('#PlaxDiv'), "od": true});
		disableScroll();
	}
	function stopParallax() {
		$( '.parallax_l' ).find('img').removeAttr( 'style' );
		$( '#parallax_close' ).remove();
		$( '.parallax_c' ).removeAttr( 'style' );
		$( '.parallax_l' ).removeAttr( 'style' );
		$.plax.disable({'clearLayers':true});
		enableScroll();
	}
	function resizeParallax() {
		var width = $(window).width(),
			height = $(window).height();

		$( '.parallax_l' ).width(width);
		$( '.parallax_c' ).width(width).height(height);
		$( '.parallax_l' ).find('img').css('width', width + 'px');
		if((jQuery(window).width() < 1025) && ($('#PlaxAct').hasClass('ParallaxZoom_work'))){
			stopParallax();
			$("#PlaxAct").removeClass('ParallaxZoom_work');
		}
	}

	$(window).resize(function () {
		if ($('#PlaxAct').hasClass('ParallaxZoom_work')){
			resizeParallax();
		}
	});
	$(document).on("click", '#PlaxAct', function() {
		if($(window).width() < 1025){return false;};
		if ($(this).hasClass('ParallaxZoom_work')){
			stopParallax();
		}
		else{
			startParallax();
		}
		$(this).toggleClass('ParallaxZoom_work');
	});
	$(document).on("click", '#parallax_close', function() {
		stopParallax();
		$("#PlaxAct").removeClass('ParallaxZoom_work');
	});
	</script>
{/literal}
<div class="ShAA_lookMainBlock">
	<div class="ShAA_rightLookBlock">
		<div class="parallax_c" id="PlaxDiv">
			<div class="parallax_l">
				<img id="PlaxAct" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/files/products/{if $set->image}{$set->image}{else}{$products[0]->small_image}{/if}" alt="" />
			</div>
		</div>
	</div>
	<div class="ShAA_leftLookBlock">
		<h1>{if $language=='eng'}Total look from the stylist of Luxury Store{else}Полный образ от стилиста Лакшери Store{/if}</h1>
      <form autocomplete="off" action='' method="post" id="form_look" name="form_look">
			{foreach from=$products item=product key=key name=set_products}
				<div class="ShAA_lookItem" data-product-id="{$product->product_id}" data-price="{$product->price}" data-category="{$product->category_name}" data-brand="{$product->brand_name}" data-model="{$product->model}">
					<div class="ShAA_lookMiniImg">
						<img src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/60x/{$product->large_image}" alt="" />
					</div>
					<div class="ShAA_infoForItemLook">
						<a target="_blank" href="/products/{$product->url}/" class="is-a-link">{$product->model}</a> <br />
						<a target="_blank" href="/products/{$product->url}/" class="is-a-link">
              {if $product->offline_only}
								Товар доступен только в бутиках
              {elseif $product->prices.vip_price.price > 0}
                {assign var="price" value = $product->prices.vip_price.price}
                <span style="color: #C30000;">
                  <span class="price rub"><b itemprop="lowPrice">{$product->prices.vip_price.price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i> </span>
                  {foreach from=$cat_currencies item=currency}
                    {assign var="c_name" value="price_`$currency->code`"}
                    <span class="price {$currency->code}" style="display:none;"><b>{$product->prices.vip_price.$c_name|string_format:"%.0f"}</b>&nbsp;<b>{$currency->sign}</b></span>
                  {/foreach}
                  VIP {if $language=='eng'}sale{else}скидка{/if} {$product->prices.vip_price.value|string_format:"%.0f"}%
                </span><br/>
              {elseif $product->prices.sale_price.price > 0}
                {assign var="price" value = $product->prices.sale_price.price}
                <span style="color: #C30000;">
                  <span class="price rub">{$product->prices.sale_price.price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i> </span>
                  {foreach from=$cat_currencies item=currency}
                    {assign var="c_name" value="price_`$currency->code`"}
                    <span class="price {$currency->code}" style="display:none;"><b style="{if $product->prices.vip_price.price > 0}text-decoration: line-through;{/if}">{$product->prices.sale_price.$c_name|string_format:"%.0f"}</b>&nbsp;<b>{$currency->sign}</b></span>
                  {/foreach}
                  {if $language=='eng'}sale{else}со скидкой{/if} {$product->prices.sale_price.value|string_format:"%.0f"}%
                </span><br/>
              {else}
                {assign var="price" value = $product->prices.price}
                 {if $language=='eng'}price{else}цена{/if}
                <span class="price rub"><span itemprop="highPrice">{$product->prices.price|string_format:"%.0f"}</span>&nbsp;<i class="icon-rub"></i></span>
                {foreach from=$cat_currencies item=currency}
                  {assign var="c_name" value="price_`$currency->code`"}
                  <span class="price {$currency->code}" style="display:none;">{$product->prices.$c_name|string_format:"%.0f"}&nbsp;<b>{$currency->sign}</b></span>
                {/foreach}
                <br/>
							{/if}
						</a>

						{if $product->offline_only}
						{elseif $product->size == "|р-р не зад|" || $product->size == "|Р-р не задан|" || $product->size == "|UNI|"}
							<div class="ShAA_sizeNotSelect"  data-price="{$price}" data-product-id="{$product->product_id}">
								<a class="ShAA_sizeLink" title="undefined">{if $language=='eng'}Select{else}Выбрать{/if}</a>
							</div>
						{elseif $product->size != ""}
							<span style="float: left; line-height: 21px; margin: 4px 12px 0 0;">{if $language=='eng'}Select size{else}Выберите размер{/if}:</span>
							<ul class="ShAA_sizeUl">
								{foreach from=$product->size_text item=size_t}
									<li class="ShAA_sizeNotSelect"  data-price="{$price}" data-product-id="{$product->product_id}">
										<a class="ShAA_sizeLink" title="{if $size_t != 'Р-р не задан' || $size_t != 'UNI'}{$size_t}{else}undefined{/if}">{$size_t}</a>
									</li>
								{/foreach}
							</ul>
						{else}
							Нет в наличии
						{/if}

					</div>
				</div>
			{/foreach}
			<div class="ShAA_lookSum">
        {if $language=='eng'}Total{else}Итого{/if}:
        <span class="price rub"><b><span id="total_price">0</span></b> <i class="icon-rub"></i></span>
        {foreach from=$cat_currencies item=currency}
          {assign var="c_name" value="price_`$currency->code`"}
          <span class="price {$currency->code}" style="display:none;"><b><span id="total_price_{$currency->code}">0</span></b>&nbsp;<b>{$currency->sign}</b></span>
        {/foreach}
      </div>
			<div class="ShAA_lookToCart">
				<a href="#" rel="nofollow" title="{if $language=='eng'}Add to cart{else}Положить в корзину{/if}" id="addToCart">
					<div class="ShAA_oneClickAdd">{if $language=='eng'}To cart{else}В Корзину{/if}</div>
				</a>
			</div>
		</form>
	</div>
<script>
      var list = 'look-{$set->id}';
  {literal}
      var impressions = [];
      {/literal}{foreach from=$products item=product}
              var brand_name = "{$product->brand_name}".replace(/'/g, "`"),
                  name = "{$product->model}".replace(/'/g, "`");{literal}
              impressions.push(
              {
                  'id': '{/literal}{$product->product_id}{literal}',
                  'name': name,
                  'price': '{/literal}{$product->price}{literal}',
                  'brand': brand_name,
                  'category': '{/literal}{$product->category_name}{literal}',
                  'variant': '{/literal}{$product->sku}{literal}',
              }
          );
      {/literal}{/foreach}{literal}
      function view_blocks(){
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
          dataLayer.push({
            'ecommerce': {
             'currencyCode': 'RUB',
             'detail': {
               'actionField': {'list': list}
             },
             'impressions': impressions
            },
            'event': 'gtm-ee-event',
            'gtm-ee-event-category': 'Enhanced Ecommerce',
            'gtm-ee-event-action': 'Product Impressions',
            'gtm-ee-event-non-interaction': true,
          });
          console.log(dataLayer);
        }
      }
      function block_click(e){
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
          var click_product = {
            id: e.data('product-id'),
            name: e.data('model'),
            price: e.data('price'),
            brand: e.data('brand'),
            category: e.data('category'),
            variant: e.find('.ShAA_sizeNotSelect.on').children().html(),
            position: jQuery('.ShAA_lookItem').index(e)+1
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


      jQuery('.ShAA_lookItem a.is-a-link').on('click',function (){
        block_click(jQuery(this));
      });

      jQuery(window).on('load',function (){
        view_blocks();
      });

  </script>
  {/literal}
</div>
