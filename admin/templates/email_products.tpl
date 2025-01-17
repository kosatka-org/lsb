<table width="100%" style="padding: 0 0 16px 0; font-size: 11px; font-family: Tahoma, Helvetica;">
	{foreach key=key from=$order->products item=product}
		{if $key%3 == 0}<tr>{/if}
		<td width="33%">
			<a href="http://{$root_url}/products/{$product->url}/" style="color: #787878; text-decoration: none; font-weight: bold;">
				<img src="http://{$root_url}/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{else}{$product->small_image}{/if}" alt="{$product->model}" style="border: 1px solid #787878; margin: 26px 0 16px 0;">
			</a>
			<div><a href="http://{$root_url}/products/{$product->url}/" style="color: #231F20; text-decoration: none;">
				{$product->model}
			</a></div>
			<div style="color: #aa8c64;">{$product->price|string_format:"%.0f"}&nbsp;{$main_currency->sign}</div>
			{if $product->size}<div> Размер {$product->size} </div>{/if}
		</td>
	{/foreach}
	{if $key%3 != 2}</tr>{/if}
</table>
