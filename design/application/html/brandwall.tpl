{foreach from=$brands_full item=brand}
	<a href="/brands/{$brand->url}/" class="transition" title="{$brand->name}" alt="{$brand->name}">
		<div class="main_button">
			<span>{$brand->name|upper}</span>
		</div>
	</a>
{/foreach}