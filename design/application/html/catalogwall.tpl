
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
	<div class="products" id="product_container">
		{include file='items_block.tpl' products=$wallproducts}
	</div>

	{if $rowcount > 60}
		<div style="clear:both;"></div>
		<a id="show_more" href="" title="" alt="">
			<div class="main_button" style="margin-top:40px;">
				<span>Показать еще</span>
			</div>
		</a>
	{/if}