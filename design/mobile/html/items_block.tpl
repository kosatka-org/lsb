{foreach from=$products item=product}
	<div class="item_container">
		<a href="/products/{$product->url}/" title="{$product->category} {$product->model}" alt="{$product->category} {$product->model}">
			<table class="item_image">
				<tbody><tr>
					<td>
						<img title="{$product->category} {$product->model}" alt="{$product->category} {$product->model}" src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/184x/{$product->large_image}" class="img_normal" style="display: block;">
					</td>
				</tr>
			</tbody></table>
			<div class="item_text">
				<div class="item_text-name">{$product->category}</div>
				<div class="item_text-brand">{$product->brand}</div>
				{if $product->brand_id != 123 && $product->brand_id != 311}
				    {if $product->prop_val == 'Распродано'}
					    <span style="color: #999;">{$product->price|string_format:"%.0f"} {$currency->sign}</span>
				    {elseif $product->old_price != 0 && $product->old_price>$product->price ||  $product->prop_val == 'Sale'}
						<span style="color: #7E7E7E;">{$product->old_price|string_format:"%.0f"} {$currency->sign}</span><br>
					    <span style="color: #C30000;">Со скидкой<br>{$product->price|string_format:"%.0f"} {$currency->sign}</span>
				    {else}
				    	<span>{$product->price|string_format:"%.0f"} {$currency->sign}</span><br>
				    {/if}
					{if $product->price >= $product->old_price && $product->discount_price && $smarty.session.user->group_id >= 1}
						<span style="color: #C30000;">цена для Вас<br>{$product->discount_price|string_format:"%.0f"} {$currency->sign}</span><br>
				    {/if}
				
				{/if}
			</div>
			{if (($product->old_price != 0) && ($product->old_price > $product->price) && (($product->old_price-$product->price)/$product->old_price > 0.1)) }
				{if $product->no_sale }
					<div></div>
				{elseif 'swd'|array_key_exists:$promos && in_array($product->brand_id, explode(",", $promos.swd->brands)) }
					<div style="position: relative; float: right; right: 50%;"><div class="ShAA_swdIcon">скидка выходного дня</div></div>
				{elseif $product->golden_sale }
					<div style="position: relative; float: right; right: 50%;"><div class="ShAA_goldenPriceIcon">выгодное предложение</div></div>
				{else}
					<div style="position: relative; float: right; right: 50%;"><div class="ShAA_saleIcon">скидка</div></div>
				{/if}
			{elseif ( $product->season == "14/2" || $product->season == "15/1" )}
				<div style="position: relative; float: right; right: 50%;"><div class="ShAA_newSeasonIcon">новый сезон</div></div>
			{/if}
		</a>
	</div>
{/foreach}