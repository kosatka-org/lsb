<i style="font-size: 20px;"><b><a target="_blank" id="faq" href="/index.php?module=Faq&amp;action=question&amp;clear=true">Задайте свой вопрос</a></b> или
<b><a title="Попросить менеджера помочь" href="/index.php?module=cart&helpform&clear_template" rel="facebox" target="_blank" onclick="{literal}rG('REQUEST_CALL_SITE');{/literal}"> закажите обратный звонок</a></b>, мы перезвоним в ближайшее время.</i><br /><br />
<i>Искомый запрос нигде не встречается, пожалуйста, воспользуйтесь рубрикатором.</i><br />
<div class="content" style="padding:0;">
	<div class="centerContent">
		<div class="checks" style="margin: 20px 0px 0 0;">
			<b>Дизайнеры</b>
			<!--<div class="checkline"></div>-->
		</div>
		<div class="centerRightContent">
			<div class="topContent" style="height:0px;margin: 10px 0 18px;">
			</div>
			<div class="clear"></div>
{foreach from=$brands_full item=brand}
			<div class="abcColumn" style="height:30px;">
				<div class="abcNames"><h1><a href="/catalog/?brand={$brand->brand_id}&showbrand={$brand->brand_id}">{$brand->name}</a></h1></div>
			</div>
{/foreach}
		</div>
	</div>

{foreach from=$categories_full item=category1}
	<div class="centerContent">
		<div class="checks" style="margin: 20px 0px 0 0;">
			<b>{$category1->name}</b>
			<!--<div class="checkline"></div>-->
		</div>
		<div class="centerRightContent">
			<div class="topContent" style="height:0px;margin: 10px 0 18px;">
			</div>
			<div class="clear"></div>
{foreach from=$category1->subcategories item=subcategory}
			<div class="abcColumn" style="height:30px;">
				<div class="abcNames"><h1><a href="/catalog/?category={$subcategory->category_id}">{$subcategory->name}</a></h1></div>
			</div>
{/foreach}
		</div>
	</div>
</div>
{/foreach}
