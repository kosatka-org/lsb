{if $banner_obj}
	<div style="width: 640px;margin: 0 auto;">
		<a href="http://mobile.lsboutique.ru/brands/{$banner_obj->url}/" title="{$banner_obj->name}" style="border:none;" onclick="{literal}rG('MAIN_BANNER_MOBILE');{/literal}">
			<img style="width: 100%;" src="/reimg/files/brand_banners/640x/{$banner_obj->banner}" alt="{$banner_obj->title}" title="{$banner_obj->name}">
		</a>
	</div>
{/if}
{* <div style="width:640px;margin: 0 auto;">
	<a href="/sale" style="border:none;" onclick="{literal}rG('MAIN_BANNER_MOBILE');{/literal}">
		<img style="width:640px;" src="/images/sale_2014_2.png">
	</a>
</div> *}

{if $info}
	<div class="centered_text" style="float: none;">
	<p>{$info}</p>
	</div>
{/if}

<a name="search" />
<form name="search" method="get" action="/catalog/">
	<div class="search_input"><input name="search" type="text" class="text_input"
		{if $form_search}value="{$form_search}"{else}placeholder="Поиск по названию, бренду или артикулу"{/if} 
		onfocus="location.href = '#search';{literal}if (document.getElementById('textsearch').value=='{/literal}{if $form_search}{$form_search}{else}Ищем по сайту{/if}{literal}') {document.getElementById('textsearch').value='';}" onblur="if (document.getElementById('textsearch').value=='') {document.getElementById('textsearch').value='{/literal}{if $form_search}{$form_search}{else}Поиск по названию, бренду или артикулу{/if}{literal}';}"/>{/literal}
	</div>
</form>
<div class="main_button" style="white-space: nowrap;">
	<a href="/catalog/?category=new" class="transition" alt="Что нового" title="Что нового"><span>ЧТО НОВОГО</span></a>
	<div class="v_divider"></div>
	<a href="/sale" class="transition" alt="Outlet" title="Outlet"><span style="line-height: 2.3; float: none;">SALE</span></a>
</div>
<a href="/brandwall/" class="transition" alt="Бренды" title="Бренды">
	<div class="main_button">
		<span>ДИЗАЙНЕРЫ</span>
	</div>
</a>
<a href="/categories/одежда/" class="transition" alt="Одежда" title="Одежда">
	<div class="main_button">
		<span>ОДЕЖДА</span>
		<div class="cat_icon">
			<table>
				<tr>
					<td>
						<img src="/design/application/images/{if $manOrWoman == '1'}m{else}w{/if}_01.jpg" alt="Одежда" title="Одежда">
					</td>
				</tr>
			</table>
		</div>
	</div>
</a>
<a href="/catalog/?category_url=обувь&show_all=1" class="transition" alt="Обувь" title="Обувь">
	<div class="main_button">
		<span>ОБУВЬ</span>
		<div class="cat_icon">
			<table>
				<tr>
					<td>
						<img src="/design/application/images/{if $manOrWoman == '1'}m{else}w{/if}_02.jpg" alt="Обувь" title="Обувь">
					</td>
				</tr>
			</table>
		</div>
	</div>
</a>
<a href="/catalog/?category_url=сумки&show_all=1" class="transition" alt="Сумки" title="Сумки">
	<div class="main_button">
		<span>СУМКИ</span>
		<div class="cat_icon">
			<table>
				<tr>
					<td>
						<img src="/design/application/images/{if $manOrWoman == '1'}m{else}w{/if}_03.jpg" alt="Сумки" title="Сумки">
					</td>
				</tr>
			</table>
		</div>
	</div>
</a>
<a href="/catalog/?category_url=аксессуары&show_all=1" class="transition" alt="Аксессуары" title="Аксессуары">
	<div class="main_button">
		<span>АКСЕССУАРЫ</span>
		<div class="cat_icon">
			<table>
				<tr>
					<td>
						<img src="/design/application/images/{if $manOrWoman == '1'}m{else}w{/if}_04.jpg" alt="Аксессуары" title="Аксессуары">
					</td>
				</tr>
			</table>
		</div>
	</div>
</a>
<a href="/sections/mobile_delivery/" class="transition" alt="" title="">
	<div class="main_button last">
		<span>ДОСТАВКА И ОПЛАТА</span>
	</div>
</a>