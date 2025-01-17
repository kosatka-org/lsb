{literal}
<style type="text/css">
body {
	background: none;
	min-height: 6000px;
}
.affix {
	top: 0px;
}
label {
	vertical-align: middle;
}
#page {
  width: 100%;
}
.mt-6 {
	margin-top: -6px;
}
.mt10 {
	margin-top: 10px;
}
.mt20 {
	margin-top: 20px;
}
.ml6 {
	margin-left: 6px;
}
</style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:50px;">
	<h3>Наборы товаров</h3>
	<div class="row">
		{* Здесь обозначаем тип списка - новые заказы или заказы в один клик *}
		<div class="col-sm-6" id="left-column" item-list>
			{* <div class="mt20">
				<button id="create-button" type="button" class="btn btn-primary">Создать новый набор</button>
			</div> *}
			<div id="create-form" class="anchor mt20" style="display:none;">
				<!--Anchor for form-template-->
			</div>
			<div class="form-group">
				<label>Бренд</label>
				<select class="form-control">
					<option value="0">Не выбран</option>
					{foreach from=$brands item=brand}
						<option value="{$brand->brand_id}" {if $brand->brand_id == $brand_id}selected{/if}>{$brand->name}</option>
					{/foreach}
				</select>
			</div>
			<div class="panel-group mt20" id="accordion" role="tablist" aria-multiselectable="true">
			{foreach from=$Items item=item key=key name=items}
			  <div class="panel panel-default">
			    <div class="panel-heading" role="tab" id="heading_{$item->id}">
			      <h4 class="panel-title">
			        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_{$item->id}" aria-expanded="false" aria-controls="collapseOnecollapse_{$item->id}">
			          <b>{$item->name}</b> | {$item->date}
			        </a>
			      </h4>
			    </div>
			    <div id="collapse_{$item->id}" class="panel-collapse collapse" item-id="{$item->id}" role="tabpanel" aria-labelledby="heading_{$item->id}">
			      <div class="panel-body">
			        <div id="set_products_{$item->id}">
			        	<div class="row">
			        	{if $item->image}
							<div class="col-md-2 mt10"><a href="/files/products/{$item->image}" target="_blank"><img class="img-thumbnail" src="/reimg/files/products/60x/{$item->image}"></a></div>
							<div class="col-md-4 mt10">Фотография набора <a href="/look/{$item->id}">{$item->name}</a></div>
						{else}
							<div class="col-md-6 mt10">Нет фотографии набора <a href="/look/{$item->id}">{$item->name}</a></div>
						{/if}
						</div>
			        	{if $item->main_product}
				        	<div class="row">
								<div class="col-md-2 mt10"><img class="img-thumbnail" src="/reimg/files/products/60x/{$item->main_product->large_image}"></div>
								<div class="col-md-4 mt10"><a href="/products/{$item->main_product->url}/" target="_blank">{$item->main_product->model}</a><br>артикул: {$item->main_product->sku}</div>
							</div>
						{/if}
						{foreach from=$item->products item=product}
							<div class="row">
								<div class="col-md-2 mt10"><img class="img-thumbnail" src="/reimg/files/products/60x/{$product->large_image}"></div>
								<div class="col-md-4 mt10"><a href="/products/{$product->url}/" target="_blank">{$product->model}</a><br>артикул: {$product->sku}</div>
								<div class="col-md-5 mt10">{* Показывать на стр. товара &nbsp;<input class="show_on_product_page" product-id="{$product->product_id}" type="checkbox" {if $product->show_on_product_page}checked="checked"{/if}> *}</div>
								<div class="col-md-1 mt10">
									<button type="button" class="close remove-item off" aria-hidden="true" product-id="{$product->product_id}">
											<span class="glyphicon glyphicon-remove"></span>
									</button>
								</div>
							</div>
						{/foreach}
					</div>
			      </div>
			    </div>
			  </div>
			{/foreach}
			</div>
		</div>
		<div class="col-sm-6" id="right-column">
			<div data-spy="affix" data-offset-top="200">
				<h2>Поиск товара</h2>
				<div class="input-group">
				  <span class="input-group-addon">Артикул</span>
				  <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
				  <input id="sku-input" type="text" class="form-control" placeholder="Введите артикул">
				</div>
				<div id="found-products" class="anchor" style="display:none;">
					<!--Anchor for user-template-->
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Content #End /-->

{literal}
<script>
$("select").on("change", function(e) {
	window.location.href = '/admin/index.php?section=Sets&brand_id='+$(this).val();
});
</script>
{/literal}
