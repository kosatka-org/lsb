{foreach from=$products item=product}
	<div class="product_block">
		<a href="/products/{$product->url}/" class="transition" title="{$product->category} {$product->model}" alt="{$product->category} {$product->model}">
			<div class="product_image">
				<table>
					<tbody><tr>
						<td>
							<img title="{$product->category} {$product->model}" alt="{$product->category} {$product->model}" src="/reimg/files/products/307x/{$product->large_image}" class="img_normal" style="display: block;">
						</td>
					</tr>
				</tbody></table>
				{if (($product->old_price != 0) && ($product->old_price > $product->price) && (($product->old_price-$product->price)/$product->old_price > 0.1)) }
					{if ($product->brand) == 'ARTIOLI' || ($product->brand) == 'ZILLI' || ($product->brand) == 'RINDI' || ($product->brand) == 'SIMONETTA RAVIZZA' || ($product->brand) == 'LORO PIANA' || ($product->brand) == 'BOTTEGA VENETA'}
						<div></div>
					{elseif 'swd'|array_key_exists:$promos && in_array($product->brand_id, explode(",", $promos.swd->brands)) }
						<div style="position: absolute;top: 357px;left: 0; height: 111px;"><img src="/files/images/swd/{$promos.swd->catalog_icon}" alt="Скидка выходного дня" style="position: absolute;top: 0;left: 0;" /></div>
					{elseif ($product->brand) == 'KITON' || ($product->brand) == 'FENDI' || ($product->brand) == 'TOM FORD' || ($product->brand) == 'VERSACE' || ($product->brand) == 'ALEXANDER MCQUEEN' || ($product->brand) == 'STELLA MCCARTNEY'}
						<div style="position: absolute;top: 357px;left: 0; height: 111px;"><img src="/images/LS_golden_sale.png"></div>
					{else}
						<div style="position: absolute;top: 365px;left: 0; height: 100px;"><div class="ShAA_sale_{$product->price*100/$product->old_price}"></div></div>
					{/if}
				{/if}
			</div>
			<div class="item_text">
				<div class="product_brand">{$product->brand}</div>
				<div class="product_model">{$product->category}</div>
				{if $product->brand_id != 123 && $product->brand_id != 311}
					<div class="product_price">
						{if $product->prop_val == 'Распродано'}
							<span class="bold" style="color: #999;">{$product->price|string_format:"%.0f"}</span> <span style="color: #999;">{$currency->sign}</span>
						{elseif $product->old_price != 0 && $product->old_price>$product->price ||  $product->prop_val == 'Sale'}
							<span class="bold">{$product->old_price|string_format:"%.0f"}</span> {$currency->sign}</span><br>
							<span style="color: #C30000;">Со скидкой</span><br><span class="bold" style="color: #C30000;">{$product->price|string_format:"%.0f"}</span> <span style="color: #C30000;">{$currency->sign}</span>
						{else}
							<span class="bold">{$product->price|string_format:"%.0f"}</span> {$currency->sign}</span><br>
						{/if}
						{if $product->price >= $product->old_price && $product->discount_price && $smarty.session.user->group_id >= 1}
							<span class="bold" style="color: #C30000;">цена для Вас<br>{$product->discount_price|string_format:"%.0f"}</span> <span style="color: #C30000;">{$currency->sign}</span><br>
						{/if}
					</div>
				{/if}
			</div>
			
		</a>
	</div>
{/foreach}