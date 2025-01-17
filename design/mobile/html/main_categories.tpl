{if $banner_obj}
	 <div style="width:640px;">
	 {* {if $manOrWoman == '1'}
		<a rel="nofollow" href="/brands/zilli/" title="ZILLI" target="_blank" style="border:none;" class="ShAA_miniHoverZoom" onclick="{literal}rG('MAIN_BANNER');{/literal}">
			<img src="/reimg/files/brand_banners/640x/zilli_banner_m_1426703294.png" alt="ZILLI" title="ZILLI" />
		</a>
	{else} *}
	 	{if 'swd'|array_key_exists:$promos}
		 	<a href="/swd/" title="Скидка Выходного Дня на одежду и обувь" target="_blank" style="border:none;" class="ShAA_miniHoverZoom">
				<img alt="Скидка Выходного Дня на одежду и обувь" style="width:640px;" src="/files/images/swd/{$promos.swd->main_banner}">
			</a>
		{else}
			<a href="/brands/{$banner_obj->url}/" title="{$banner_obj->name}" style="border:none;" onclick="{literal}rG('MAIN_BANNER_MOBILE');{/literal}">
				<img src="/reimg/files/brand_banners/640x/{$banner_obj->banner}" alt="{$banner_obj->title}" title="{$banner_obj->name}">
			</a>
		{/if}
		<a href="/sale" style="border:none;" onclick="{literal}rG('MAIN_BANNER_MOBILE');{/literal}">
			<img style="width:640px;" src="/images/yarmarka2.jpg">
		</a>
	{* {/if} *}
	</div>
{/if}

{if $info}
	<div class="centered_text descr_text">
	<p>{$info}</p>
	</div>
{/if}

{if $searchfail}
	<div class="centered_text button_text" style="font-size: 20px;">
		<p>
			По вашему запросу ничего не найдено.<br /><br />
			<i style="font-size: 26px; line-height: 36px;">
				Вы можете
				<a style="color: #000;" id="faq" href="/index.php?module=Faq&amp;action=question"><b>задать вопрос</b></a><br />
				или
				<a style="color: #000;" href="/index.php?module=Cart&amp;call_me" title="Перезвоните мне" onclick="{literal}rG('REQUEST_CALL_MOBILE');{/literal}" alt="Перезвоните мне"><b>оставить свой номер</b></a>
			</i>
		</p>
	</div>
{/if}
<form name="search" method="get" action="/catalog/">
	<div class="input_wrap" style="margin: 10px 40px;"><input name="search" type="text" class="text_input"
		{if $form_search}value="{$form_search}"{else}placeholder="Поиск по названию, бренду или артикулу"{/if} 
		onfocus="{literal}if (document.getElementById('textsearch').value=='{/literal}{if $form_search}{$form_search}{else}Ищем по сайту{/if}{literal}') {document.getElementById('textsearch').value='';}" onblur="if (document.getElementById('textsearch').value=='') {document.getElementById('textsearch').value='{/literal}{if $form_search}{$form_search}{else}Поиск по названию, бренду или артикулу{/if}{literal}';}"/>{/literal}</div>
</form>
<div class="divider" style="margin: 0;"></div>
<a href="/catalog/?category_url=одежда" title="Одежда" alt="Одежда">
	<div class="button button560px button_text">
		Одежда
	</div>
</a>
<a href="/catalog/?category_url=обувь" title="Обувь" alt="Обувь">
	<div class="button button560px button_text">
		Обувь
	</div>
</a>
<a href="/catalog/?category_url=аксессуары" title="Аксессуары" alt="Аксессуары">
	<div class="button button560px button_text">
		Аксессуары
	</div>
</a>
<a href="/catalog/?category_url=сумки" title="Сумки" alt="Сумки">
	<div class="button button560px button_text">
		Сумки
	</div>
</a>
{if $manOrWoman == '2'}
<a href="/catalog/?category=furs" title="Меха" alt="Меха">
	<div class="button button560px button_text">
		Меха
	</div>
</a>
{/if}
<div class="button_wrap" style="margin: 10px 0 10px 40px;">
	<a href="/catalog/?category=new" title="Что нового" alt="Что нового">
		<div class="button button240px button_text" style="margin: 0 83px 0 0;">
			<table>
				<tr>
					<td class="center-text button_text">
						Что нового
					</td>
				</tr>
			</table>
		</div>
	</a>
	<a href="/brandwall/" title="Бренды" alt="Бренды">
		<div class="button button240px button_text">
			<table>
				<tr>
					<td class="center-text button_text">
						Бренды
					</td>
				</tr>
			</table>
		</div>
	</a>
</div>
<a href="/sale" title="Outlet" alt="Outlet">
	<div class="button button560px button_text">
		Sale
	</div>
</a>
<a href="/catalog/?enter_mobile={if $manOrWoman == 2}1{else}2{/if}" title="" alt="">
	<div class="button button560px button_text">
		Перейти в {if $manOrWoman == 2}мужской{else}женский{/if} каталог
	</div>
</a>
<div class="divider" style="margin: 0;"></div>
{if $greeting_text}
	{$greeting_text->body}
{/if}
{if !$offlineSales && $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
<script>
//Criteo dataLayer
    {literal}
        jQuery(document).ready(function() {
            if (typeof(dataLayer) !== 'undefined' && dataLayer) {
                dataLayer.push({
                    'CriteoEmail': {/literal}'{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}'{literal}, 
                    'PageType': 'HomePage'
                })
            }
        });
    {/literal}
    //MyTarget dataLayer
      {literal}
          jQuery(document).ready(function() {
              dataLayer.push({
                  'MT_PageType': 'home'
              });
          });
      {/literal}
</script>
{/if}
<!-- <div class="centered_text alert_text">
	Бесплатная доставка
</div>
<div class="left_text2 descr_text" style="margin: 30px 0 30px 80px;">
	Бесплатная доставка осуществляется в любой регион России при заказе товара на сумму более 10000 рублей.
</div> -->
