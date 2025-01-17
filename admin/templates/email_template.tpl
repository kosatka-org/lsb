{literal}
<style type="text/css">
body {
	background: none;
}
.mt20 {
	margin-top: 20px;
}
</style>
{/literal}

<div id="inserts_all">
  <!-- Вкладки /-->
{include file='message_menu.tpl' active='template'}

<div class="container" style="margin-bottom:50px;">
	<div class="tab-content">
		<div class="tab-pane active" id="active">
			<div class="row">

				<div class="col-md-8 col-md-offset-2" id="left-column">
					{foreach from=$Items item=item key=key name=items}
						<div class="item" item-id="{$item->id}">

							<div class="row mt20">
								<div class="col-md-8">
									<p>
										{$item->name}
									</p>
								</div>
								<div class="col-md-3">
									<button type="button" class="edit btn" item-id="{$item->id}">
										Редактировать
									</button>
								</div>
								<div class="col-md-1"></div>
							</div>

							<div class="row mt20">
								<div class="col-md-12" id="right-column">
									<form action="/admin/index.php?section=Oneclick" method="post">
										<div>
											<div id="editor_{$item->id}">
												
											</div>
										</div>

										<div class="mt20">
											<button id="create_button_{$item->id}" style="display:none;" type="submit" class="btn btn-primary">Сохранить</button>
										</div>
										<div style="display:none;" id="test_email_{$item->id}" class="mt20">
											<label style="margin-right: 12px;"><input id="email_{$item->id}" name="email" value="{$smarty.session.user->email}" style="margin-right: 4px;">Ваш имейл</label>
											<button id="test_button_{$item->id}" type="submit" data-item-id="{$item->id}" class="btn testbtn btn-primary">Отправить тестовое письмо</button>
											<span style="margin-left: 20px;" id='test_success_{$item->id}'></span>
										</div>
									</form>
								</div>
							</div>

						</div>
					{/foreach}
				</div>

			</div>
		</div>
	</div>
</div>
</div>