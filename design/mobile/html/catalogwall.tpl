{if $form_search}
<form name="search" method="get" action="/catalog/">
	<div class="input_wrap" style="margin: 10px 40px 20px;"><input name="search" type="text" class="text_input" value="{$form_search}"
		onfocus="{literal}if (document.getElementById('textsearch').value=='{/literal}{if $form_search}{$form_search}{else}Ищем по сайту{/if}{literal}') {document.getElementById('textsearch').value='';}" onblur="if (document.getElementById('textsearch').value=='') {document.getElementById('textsearch').value='{/literal}{if $form_search}{$form_search}{else}Поиск по названию, бренду или артикулу{/if}{literal}';}"/>{/literal}</div>
</form>
{/if}
<div class="centered_text">
	<a href="" title="" alt="" class="item_link">{if $fcat}{$fcat->name}:{elseif $fbrand}{$fbrand->name}:{/if} {$rowcount} предложений</a>
</div>
<div class="item_wrap" style="margin: -20px 0 0;">
	<script>
		var $luxury_obj = {ldelim}
		    brands: [],
		    categories: [],
		    sizes: []
		    {if $rootcateg}, rootcateg: '{$rootcateg}'{/if}
		    {if $rootbrand}, rootbrand: {$rootbrand}{/if}
		    {if $rowcount}, rowcount: {$rowcount}{/if}
		    {if $special}, special: {$special}{/if},
		    offset: 60,
		    state: 0,
		    sp_urls: "eof"
		{rdelim};

	{literal}

		$(document).on('click', 'a#show_more', function(event) {
			event.preventDefault();
			if ($luxury_obj.offset < $luxury_obj.rowcount) {
				$.post("/catalog/", {json: JSON.stringify($luxury_obj), mobile: 1}, function(data) {
					$("#product_container").append(data);
					$luxury_obj.offset += 30;
					if ($luxury_obj.offset >= $luxury_obj.rowcount) {
						$('a#show_more').hide();
					}
				});
			}
		});

	</script>
	{/literal}

	{* Блок товаров *}
	<div id="product_container">
		{include file='items_block.tpl' products=$wallproducts}
	</div>

	{if $rowcount > 60}
		<div style="clear:both;"></div>
		<a id="show_more" href="" title="" alt="" onclick="rG('SHOW_MORE');">
			<div class="button button560px button_text" style="margin: 10px 0;">
				Показать еще
			</div>
		</a>
	{/if}

</div>
{if $parent_name}
<a href="/catalog/?category_url={$parent_name}" title="" alt="">
	<div class="button button560px button_text">
		Вернуться к категориям
	</div>
</a>
{/if}
{if $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
<script>
//Criteo dataLayer
    {literal}
        jQuery(document).ready(function() {
            if (typeof(dataLayer) !== 'undefined' && dataLayer) {
                dataLayer.push({
                    'CriteoEmail': {/literal}'{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}'{literal}, 
                    'PageType': 'CatalogPage',
                    'ProductIDList' : [{/literal}{$criteo_p_list}{literal}]
                })
            }
        });
    {/literal}
</script>
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
<a href="/brandwall/" title="" alt="">
	<div class="button button560px button_text">
		Вернуться к брендам
	</div>
</a>