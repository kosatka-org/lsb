<table width="100%" style="padding: 0 0 16px 0; font-size: 11px; font-family: Tahoma, Helvetica;">
	{foreach key=key from=$order->products item=product}
		{if $key%4 == 0}<tr>{/if}
		<td width="25%" align="center" valign="top">
			<a href="https://{if $order_link}{$order_link}{else}{$root_url}{/if}/products/{$product->url}/{if $utm_source}?utm_source={$utm_source}&utm_medium={$utm_medium}&utm_campaign={$utm_campaign}{/if}"  style="text-decoration: none;">
				<img src="https://{if $order_link}{$order_link}{else}{$root_url}{/if}/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{else}{$product->small_image}{/if}" alt="{$product->model}" style="border: 0;">
			</a>
			<div>
				<a href="https://{if $order_link}{$order_link}{else}{$root_url}{/if}/products/{$product->url}/{if $utm_source}?utm_source={$utm_source}&utm_medium={$utm_medium}&utm_campaign={$utm_campaign}{/if}" style="color: #585858;font-family: georgia,serif;font-size: 12px;line-height: 19px;text-decoration: none;">
					{$product->model}<br> {if $product->size} Размер {$product->size},{/if} {$product->price|string_format:"%.0f"}&nbsp;руб.
				</a>
			</div>
		</td>
	{/foreach}
	{if $key%4 != 3}</tr>{/if}
</table>
