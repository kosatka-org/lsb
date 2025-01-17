{literal}
<style type="text/css">
body {
	background: none;
}
label {
	vertical-align: middle;
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

	{if $new_orders}
		<h3>Предобработка заказов</h3>
		<ul class="nav nav-tabs" id="myTab">
			<li class="active"><a href="#">Предобработка</a></li>
			<li><a href="/admin/index.php?section=Orders">Новые</a></li>
			<li><a href="/admin/index.php?section=Orders&view=process">В обработке</a></li>
			<li><a href="/admin/index.php?section=Orders&view=delivery">Доставка</a></li>
			<li><a href="/admin/index.php?section=Orders&view=done">Выполнены</a></li>
		</ul>
	{else}
		<h3>Заказы в один клик</h3>
		<ul class="nav nav-tabs" id="myTab">
			<li class="active"><a id="tab-active-items" href="#active" data-toggle="tab">Активные</a></li>
			<li><a id="tab-archive-items" href="#archive" data-toggle="tab">Обработанные</a></li>
		</ul>
	{/if}

	<div class="tab-content">
		<div class="tab-pane active" id="active">
			<div class="row">
				{* Здесь обозначаем тип списка - новые заказы или заказы в один клик *}
				<div class="col-md-6" id="left-column" item-list data-item-type="{if $new_orders}new_orders{else}one_click{/if}">
					{foreach from=$Items item=item key=key name=items}
						<div class="item" item-id="{$item->id}" product-id="{$item->product_id}">
							<div class="row mt20">
								<div class="col-md-10">
									<p>
										<b>{$item->name}</b> | {$item->phone} 
										<button type="button" item-phone="{$item->phone}" class="copy-button btn btn-default btn-xs">
											<span class="glyphicon glyphicon-plus"></span>
										</button>
										| <a href="/products/{$item->url}" target="_blank">{$item->model}</a>
									</p>
								</div>
								<div class="col-md-1">
									<button type="button" class="close remove-item off" aria-hidden="true" item-id="{$item->id}">
										<span class="glyphicon glyphicon-remove"></span>
									</button>
								</div>
								<div class="col-md-1"></div>
							</div>
							<div class="btn-group" data-toggle="buttons">
							{if !empty($item->sizes)}
								{foreach from=$item->sizes item=p_size}
									<label class="size-button btn btn-{if $p_size == $item->selected_size}info selected_size{else}primary{/if}">
										<input class="" type="radio" name="options" item-id="{$item->id}" product-id="{$item->product_id}" value="{$p_size}">{$p_size}
									</label>
								{/foreach}
							{else}
								Товара нет в наличии.
							{/if}
							</div>
							<button class="remove-size btn btn-default" type="submit" style="margin-left:8px;display:none;">Отменить выбор</button>
							<div class="row mt10">
								<div class="col-md-6">{$item->date}</div>
								<div class="col-md-6 mt-6">
									{if $item->from|strstr:"wish_list"}
										<img src="./images/discount.png" style="vertical-align: top;">
									{elseif $item->from|strstr:"application"|| $item->from|strstr:"apple"}
										<i class="fa fa-2x ml6 platform fa-apple"></i>	
									{elseif $item->from|strstr:"android"}
										<i class="fa fa-2x ml6 platform fa-android"></i>	
									{else}
										<i class="fa fa-2x platform fa-{if $item->from|strstr:"mobile"}mobile{else}desktop{/if}"></i>
										{if $item->from|strstr:"call_me" || $item->from|strstr:"helpform"}
											<i class="fa fa-2x ml6 text-info fa-info"></i>
										{/if}
									{/if}
								</div>
							</div>
							{if $item->comment}
							<div class="row mt10">
								<div class="col-md-10 comment_{$item->order_id}">Комментарий: {$item->comment}</div>
							</div>
							{/if}
						</div>
					{/foreach}
				</div>
				<div class="col-md-6" id="right-column">
					<div>
						<h2>Поиск клиента</h2>
						<div class="input-group">
						  <span class="input-group-addon">Телефон</span>
						  <span id="refresh" class="input-group-addon"><span class="glyphicon glyphicon-refresh"></span></span>
						  <input id="phone-input" type="text" class="form-control" placeholder="Введите телефон">
						</div>
						<div id="found-users" class="anchor" style="display:none;">
							<!--Anchor for user-template-->
						</div>
					</div>

					<div class="mt20">
						<button id="create-button" type="button" class="btn btn-primary">Создать нового клиента</button>
					</div>

					<div id="create-form" class="anchor mt20" style="display:none;">
						<!--Anchor for form-template-->
					</div>

				</div>
			</div>
		</div>
		<div class="tab-pane" id="archive">
			<div class="mt20"><h4>Обработанные за последние 2 недели заказы</h4></div>
			<div id="archive-items">
				<!--Anchor for archive-template-->
			</div>
			<div class="btn btn-primary" id="more_archive">Показать еще</div>
		</div>
	</div>
</div>
<!-- Content #End /--> 
