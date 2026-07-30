<div class="content">
	<!--конкретный бренд-->
		<div class="centerContent">
	        	<div class="centerLeftContent">
	        		<ul>
	        			<li><a href="/brandwall/?type={$type}" {if $category == 0}style="font-weight:bold;"{/if}>Все дизайнеры</a></li>
{foreach from=$wall_categories item=category_item}
	        			<li><a href="/brandwall/?type={$type}&category={$category_item->category_id}" {if $category == $category_item->category_id}style="font-weight:bold;"{/if}>{$category_item->name}</a></li>
{/foreach}
	        		</ul>
	        	</div>
	        	<div class="centerRightContent">
					<div class="titleMain"><b>{$brand->name}</b></div>
					<div class="brandDescription mobileBrandDescr">
						{$brand->description}
					</div>
					<div class="brandImage"><img width="212" alt="{$brand->name}" title="{$brand->name}" src="/reimg/files/brands/212x/{$brand->image}"></div>
					<div class="clear"></div>
					<a href="/index.php?module=Feedback&name={$brand->name}&clear" rel="facebox"  onclick="{literal}rG('SUBSCRIBE_BRAND');{/literal}" target="_blank"><div class="buttonNew"><span>Подписаться на обновления</span></div></a>
					<div style="width:352px; float:right;margin-right:30px; display: none;">	
					<div style="width:97px; float:right;">					
						<div class="fb-like" data-send="false" data-layout="button_count" data-width="70" data-show-faces="false"></div>
					</div>
					<div style="width:80px; float:right; margin:0 10px 0px 0px;">	
						<div id="vk_like"></div>
						{literal}
							<script type="text/javascript" src="//userapi.com/js/api/openapi.js?48"></script>
							<script type="text/javascript">
								VK.init({apiId: 2834241, onlyWidgets: true});
							</script>
							<script type="text/javascript">
								VK.Widgets.Like("vk_like", {type: "mini", height: 20});
								window.___gcfg = {lang: 'ru'};
								(function() {
									var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
									po.src = 'https://apis.google.com/js/plusone.js';
									var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
								})();

								(function(d, s, id) {
									var js, fjs = d.getElementsByTagName(s)[0];
									if (d.getElementById(id)) return;
									js = d.createElement(s); js.id = id;
									js.src = "//connect.facebook.net/ru_RU/all.js#xfbml=1";
									fjs.parentNode.insertBefore(js, fjs);
								}(document, 'script', 'facebook-jssdk'));
							</script>
						{/literal}
					</div>
					<div style="width:60px; float:right; margin:0px 20px 0px 0px;">	
						<g:plusone size="medium"></g:plusone>
						<!-- Поместите этот вызов функции отображения в соответствующее место. -->
					</div>
				</div>
				<div class="clear"></div>
				<div class="newInBrand">
					<div class="choiceOfOurCustomers">
						<div class="titleGray"><span style="font-weight: normal;">Всё от </span>{$brand->name}</div>
						<div id="fb-root"></div>
						{literal}
							<script language="javascript">
								$(document).ready( function () {
									$('.button_count a').attr('style','padding:4px');
									$('.miniProduct').bind('mouseenter', function() {
										id = $(this).eq(0).attr('id');
										//$('#img_' + id).removeClass("imgCatalog").addClass("imgCatalogHover");
										$('#img_' + id + ' img').attr('src', $('#img_' + id + ' img').attr('src_over'));
										//$('#title_' + id + ' a').css({borderBottom: "2px solid #777"});
										return false;
									}).bind('mouseleave', function() {
										id = $(this).eq(0).attr('id');
										//$('#img_' + id).removeClass("imgCatalogHover").addClass("imgCatalog");
										$('#img_' + id + ' img').attr('src', $('#img_' + id + ' img').attr('src_out'));
										//$('#title_' + id + ' a').css({borderBottom: "none"});
										return false;
									});
								});
							</script>
						{/literal}
						{foreach from=$products item=product}
							<div class="miniProduct"  id="{$product->product_id}" >
								<div class="miniProductImg" id="img_{$product->product_id}" >
									<a href="/products/{$product->url}/"><img alt="{$product->model}{if $brand} {$brand->name}{/if}" title="{$product->model}{if $brand} {$brand->name}{/if}" src="/reimg/files/products/190x/{if $product->large_image}{$product->large_image}{else}{if $product->small_image}{$product->small_image}{/if}{/if}" src_out="/reimg/files/products/190x/{if $product->large_image}{$product->large_image}{else}{if $product->small_image}{$product->small_image}{/if}{/if}" src_over="/reimg/files/products/190x/{if $product->small_image}{$product->small_image}{else}{if $product->large_image}{$product->large_image}{/if}{/if}"/></a>
								</div>
								<div class="miniProductText">
									<a href="/products/{$product->url}/">
									<br />
									{$product->model}<br />
									{$product->price} руб.									
									</a>
								</div>
							</div>
						{/foreach}
					</div>
				</div>
			</div>
		</div>
	<!--end конкретный бренд-->		
</div>
