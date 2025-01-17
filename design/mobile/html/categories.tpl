<div class="button_wrap" style="margin: 0 0 0 40px;">
	<a href="/catalog/?category_url={$fcat->url}&show_all=1" title="{$fcat->name}" alt="{$fcat->name}">
		<div style="margin-left: 0px;" class="button button560px button_text">
			Все
		</div>
	</a>
	{foreach from=$filtercategories item=category key=index}
		<a href="/categories/{$category->url}/" title="{$category->name}" alt="{$category->name}">
			<div class="button button240px button_text" style="margin: 10px 0 10px 0; {if ($index+1)%2 != 0}margin-right: 83px;{/if}>"> 
				<table>
					<tr>
						<td>
							{$category->name} ({if $manOrWoman == 2}{$category->prod_count_w}{else}{$category->prod_count_m}{/if})
						</td>
					</tr>
				</table>
			</div>
		</a>
	{/foreach}

	<a href="/catalog/" title="Вернуться к разделам" alt="Вернуться к разделам">
		<div class="button button560px button_text" style="margin: 10px 0 10px 0;">
			Вернуться к разделам
		</div>
	</a>
</div>
<div class="divider" style="margin: 0;"></div>
<form name="search" method="get" action="/catalog/">
	<div class="input_wrap" style="margin: 10px 40px;"><input name="search" type="text" class="text_input" placeholder="Поиск по названию, бренду или артикулу"></div>
</form>
<div class="divider"></div>