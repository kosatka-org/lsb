<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
{literal}
	<style>
		.ui-widget-content {
			border: none;
			background: url(/images/tooltip_back.png) 7px 100% no-repeat;
			width: 191px;
			height: 280px;
			color: #222;
		}
		.prodImgTooltip {
			width: 184px;
			height: 276px;
		}
		.ui-tooltip {
			max-width: 184px;
			border: none;
			box-shadow: none;
		}
		.ui-corner-all {
			border: none;
		}
	</style>
	<script>
		$(function() {
			$( document ).tooltip({
				position: {
					my: "left bottom-1",
					at: "center top",
					using: function( position, feedback ) {
					$( this ).css( position );}
				},
				hide: {
					delay: 60
				},
				items: "img, [data-geo], [title]",
				content: function() {
					var element = $( this );
					if ( element.is( "[title]" ) ) {
						var alttext = element.attr( "title" );
						var text = element.attr( "imurl" );
						if (text) {
							var img_url = "https://lsboutique.ru/reimg/files/products/184x/" + text;
							var file_url = "https://lsboutique.ru/files/products/" + text;
							if ($.ajax({type: 'HEAD', async: false, url: file_url}).status == 200) {
								return "<img class='prodImgTooltip' alt='" + alttext +
									"' src='" + img_url + "'>";
							}
							else {
								return "<img class='prodImgTooltip' alt='" + alttext +
									"' src='https://lsboutique.ru/images/noimage_new.png'>";
							}
						}
					}
				}
			});
		});
	</script>
{/literal}
<!-- Заголовок  /-->
<div id="page_title">      
  <h1 class="float_left">{if $section->header}{$section->header|escape}{else}Карта сайта{/if}</h1>
</div> 

<!-- Текст раздела /-->
{if $section->body}
<div id="category_description">
  {$section->body}
</div>
{/if}
<!-- Текст раздела #End /-->

<ul class="catalog_menu">
<li><a href='/'>{$settings->site_name}</a></li>
<ul class="catalog_menu">
	<li><img class="ShAA_iconsSiteMap" src="/images/icon_catalog.png" width="16" height="11" /><a href='/catalog/'>Каталог</a></li>
	{defun name=cats_tree categories=$catalog}
		{if $categories}
			<ul class="catalog_menu">
				{foreach item=c from=$categories}
					{if $c->name}
						<li>
							{if $c->category_id == 38}
								<img class="ShAA_subIconsSiteMap" src="/images/icon_bag.png" width="16" height="16" />
							{elseif $c->category_id == 2}
								<img class="ShAA_subIconsSiteMap" src="/images/icon_shoes.png" width="16" height="13" />
							{elseif $c->category_id == 1}
								<img class="ShAA_subIconsSiteMap" src="/images/icon_clothes.png" width="16" height="15" />
							{elseif $c->category_id == 4}
								<img class="ShAA_subIconsSiteMap" src="/images/icon_accessories.png" width="16" height="12" />
							{/if}
							<a href='/catalog/?category={$c->category_id}&sex=1' tooltip='category' category_id='{$c->category_id}'>{$c->name|escape} муж</a>
							<a href='/catalog/?category={$c->category_id}&sex=2' tooltip='category' category_id='{$c->category_id}'>{$c->name|escape} жен</a>
						</li>
						<li style="margin: 0 0 0 20px;">
							{fun name=cats_tree categories=$c->subcategories}        
							{if $c->products}
								<span style="margin: 0 0 0 -10px; float: left;">
									{foreach from=$c->products item=product}
										<a class="ShAA_toolPhoto" href='/products/{$product->url}/' title='{$product->brand}' imurl='{$product->small_image}'>{$product->brand} {$product->price|string_format:"%.0f"}</a>,
									{/foreach}
								</span>
							{/if}
						</li>
					{/if}
				{/foreach}  
			</ul>
		{/if}    
	{/defun}
</ul>
{if $brands}
	<ul class="catalog_menu">
		<li><img class="ShAA_iconsSiteMap" src="/images/icon_catalog.png" width="16" height="11" /><a href='/catalog/'>Бренды</a></li>
		<ul class="catalog_menu">
			{foreach item=brand from=$brands}
				{if $brand->name}
					<li>
						<a href={if $brand->url}"/brands/{$brand->url}/?sex=1"{else}"/catalog/?brand={$brand->brand_id}&showbrand={$brand->brand_id}&sex=1"{/if}>Мужской каталог {$brand->name|escape}</a>,
						<a href={if $brand->url}"/brands/{$brand->url}/?sex=2"{else}"/catalog/?brand={$brand->brand_id}&showbrand={$brand->brand_id}&sex=2"{/if}>Женский каталог {$brand->name|escape}</a>
					</li>
					<!--<li style="margin: 0 0 0 20px;">    
						{if $brand->products}
							<span style="margin: 0 0 0 -10px; float: left;">
								{foreach from=$brand->products item=product}
									<a class="ShAA_toolPhoto" href='/products/{$product->url}/' title='{$product->model}' imurl='{$product->small_image}'>{$product->name} {$product->price|string_format:"%.0f"}</a>,
								{/foreach}
							</span>
						{/if}
					</li>-->
				{/if}
			{/foreach}
		</ul>
	</ul>
{/if}

<ul class="catalog_menu">
	<li><img class="ShAA_iconsSiteMap" src="/images/icon_designers.png" width="16" height="17" /><a href='/brandwall/'>Дизайнеры</a></li>
	<ul class="catalog_menu">
				{foreach item=good from=$goods}
					{if $good->title}
						<li>
							<a href='/goods/{$good->url}/' tooltip='good' good_id='{$good->id}'>{$good->title|escape}</a>
						</li>
						<li style="margin: 0 0 0 20px;">
							     
							{if $good->products}
								<span style="margin: 0 0 0 -10px; float: left;">
									{foreach from=$good->products item=product}
										<a class="ShAA_toolPhoto" href='/products/{$product->url}/' title='{$product->model}' imurl='{$product->small_image}'>{$product->model} {$product->price|string_format:"%.0f"}</a>,
									{/foreach}
								</span>
							{/if}
						</li>
					{/if}
				{/foreach}  
			</ul>
</ul>

{if $news}
<ul class="catalog_menu">
	<li><a href='news/'>Новости</a></li>
	<ul class="catalog_menu">
		{foreach from=$news item=n}
			<li><a href='news/{$n->url}'>{$n->header|escape}</a></li>
		{/foreach}
	</ul>
</ul>
{/if}

{if $updates}
	<ul class="catalog_menu">
		<li><a href='feed/'>Обновления</a></li>
		<ul class="catalog_menu">
			{foreach from=$updates item=u}
				<li style="display: inline;"><a href='/feed/generate_page/{$u->lastmod}'>{$u->lastmod|escape}</a>, </li>
			{/foreach}
		</ul>
	</ul>
{/if}

{if $articles}
	<ul class="catalog_menu">
		<li><a href='articles/'>Статьи</a></li>
		<ul class="catalog_menu">
			{foreach from=$articles item=a}
				<li><a href='articles/{$a->url}'>{$a->header|escape}</a></li>
			{/foreach}
		</ul>
	</ul>
{/if}

{if $stock}
<ul class="catalog_menu">
	<li><a href='catalog/'>Остатки</a></li>
	<ul class="catalog_menu">
		{foreach from=$stock item=n}
			<li style="display: inline;">
				<a class="ShAA_toolPhoto" href='/stock/{$n->url}/' title='{$n->brand|escape}' imurl='{$n->code|str_pad:11:'0':$smarty.const.STR_PAD_LEFT}.jpg'>{$n->category_name|escape} {$n->brand|escape}</a>, 
			</li>
		{/foreach}
	</ul>
</ul>
{/if}


{if $cities}
<ul class="catalog_menu">
	<li><a href='/sections/shipping'>Города</a></li>
	<ul class="catalog_menu">
		{foreach from=$cities item=city}
			<li><a href='/city/{$city->url}' title="Описание доставки в город {$city->name} курьерской службой магазина Лакшери Стор">Доставка в город {$city->name}</a></li>
		{/foreach}
	</ul>
</ul>
{/if}

