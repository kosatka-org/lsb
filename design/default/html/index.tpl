<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>{$title|escape}</title>
    <meta name="description" content="{$description|escape}" />
    <meta name="keywords" content="{$keywords|escape}" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    <meta http-equiv="Content-Language" content="ru" />
    <meta name='yandex-verification' content='5520ef1e14c90d1b' />
    <meta name="robots" content="all" />

    <link rel="alternate" type="application/rss+xml" title="rss feed" href="/rss/"/>
    <link media="all" href="/css/style.css?v=1.85" rel="stylesheet" type="text/css" />    
	<link rel="stylesheet" href="/sizes/css/style_s.css?v=1.87" type="text/css" />
	<link href="/favicon.ico" rel="icon" type="image/x-icon" />
    <script type="text/javascript" src="//yandex.st/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="//yandex.st/jquery/cookie/1.0/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-migrate/1.2.1/jquery-migrate.js"></script>
	<script type="text/javascript" src="/jscript/fancybox/js/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="/js/sourcebuster.min.js"></script>
	<link href="/jscript/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="/jscript/slider.css?v=1.01" />
	
	<link href='//fonts.googleapis.com/css?family=Roboto&subset=latin,cyrillic' rel='stylesheet' type='text/css'>
    {if $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
        <script>
        window.dataLayer = window.dataLayer || [];
        </script>
        {literal}
            <!-- Google Tag Manager -->
            <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
            new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
            j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
            'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
            })(window,document,'script','dataLayer','GTM-KMNDWNG');</script>
            <!-- End Google Tag Manager -->
        {/literal}
        {if $page->section_id == 160}
            <script>
            //Criteo dataLayer
                {literal}
                    jQuery(document).ready(function() {
                        dataLayer.push({
                            'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}{literal}', 
                            'PageType': 'HomePage'
                        })
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
    {/if}
    {if $smarty.session.user->group_id > 1}
        <script defer src="/js/admintooltip/php/admintooltip.php" language="JavaScript" type="text/javascript"></script>
        <link href="/js/admintooltip/css/admintooltip.css" rel="stylesheet" type="text/css" />
    {/if}
    

{if $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
{literal}
<script>
    <!-- Yandex.Metrika counter -->
    (function (d, w, c) {
        (w[c] = w[c] || []).push(function() {
            try {
                w.yaCounter10626637 = new Ya.Metrika({
                    id:10626637,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true,
                    webvisor:true,
                    ut:"noindex",
                    ecommerce:"dataLayer"
                });
            } catch(e) { }
        });

        var n = d.getElementsByTagName("script")[0],
            s = d.createElement("script"),
            f = function () { n.parentNode.insertBefore(s, n); };
        s.type = "text/javascript";
        s.async = true;
        s.src = "https://mc.yandex.ru/metrika/watch.js";

        if (w.opera == "[object Opera]") {
            d.addEventListener("DOMContentLoaded", f, false);
        } else { f(); }
    })(document, window, "yandex_metrika_callbacks");
    // dataLayer для отправки данных ecommerce
    window.dataLayer = window.dataLayer || [];
</script>
<noscript><div><img src="//mc.yandex.ru/watch/10626637?ut=noindex" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
<!-- /Yandex.Metrika counter -->
{/literal}
{/if}

	{literal}
	<script type="text/javascript">
	
		var $r = jQuery.noConflict();
		var $ = jQuery.noConflict();
        
        sbjs.init();
        var ref = sbjs.get.current.src.replace(/^\(+|\)+$/g, '')+'_'+sbjs.get.current.mdm.replace(/^\(+|\)+$/g, '');
   
	
		jQuery(document).ready(function() {
			jQuery("a[rel*=facebox]").fancybox({
				'padding'			: 0,
				'titlePosition'		: 'inside',
				'autoScale'			: 'true',
				'opacity'           : 'false',
				'scrolling'			: 'no',
				'overlayColor'      : '#000'
			});
			jQuery("a#feedbackbox").fancybox({
				'padding'			: 0,
				'titlePosition'		: 'inside',
				'autoScale'			: 'true',
				'opacity'           : 'false',
				'scrolling'			: 'no',
				'overlayColor'      : '#000'
			});
			jQuery("a#faq").fancybox({
				'padding'			: 0,
				'titlePosition'		: 'inside',
				'autoScale'			: 'true',
				'opacity'           : 'false',
				'scrolling'			: 'no',
				'overlayColor'      : '#000'
			});
			jQuery("a#vk_login_link").fancybox({
				'padding'			: 0,
				'titlePosition'		: 'inside',
				'autoScale'			: 'true',
				'opacity'           : 'false',
				'scrolling'			: 'no',
				'overlayColor'      : '#000'
			});
			jQuery("a#city_link").fancybox({
				'padding'			: 0,
				'titlePosition'		: 'inside',
				'autoScale'			: 'true',
				'opacity'           : 'false',
				'scrolling'			: 'no',
				'overlayColor'      : '#000'
			});
			if ( jQuery('#message_block').html() ) {
				jQuery.fancybox({
					'padding'			: 0,
					'titlePosition'		: 'inside',
					'autoScale'			: 'true',
					'opacity'           : 'false',
					'scrolling'			: 'no',
					'overlayColor'      : '#000',
					'content'			: jQuery('#message_block').html()
				});
			}
		});	

		var zoomEnable;

		zoomEnable = function() {
		  $("head meta[name=viewport]").prop("content", "width=device-width, initial-scale=1.0, user-scalable=yes");
		};

		$("input[type='text']").on("touchstart", function(e) {
		  $("head meta[name=viewport]").prop("content", "viewportmeta.content = 'width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no'");
		});

		$("input[type='text']").blur(zoomEnable);
	</script>

	<style media='print' type='text/css'>
		.mainMenu {display: none; height: 0px; visibility: hidden;}
		.rightTopLinks {display: none; height: 0px; visibility: hidden;}
		.footer {display: none; height: 0px; visibility: hidden;}
		.noprint {display: none;}
		body {background:#FFF; color:#000;}
		.userInfo {display: block; color: #000;}
		.tableOrder td {border-bottom: 2px solid #777777; padding: 15px 16px 10px 20px;}
		.userInfo div {margin: 16px 0 0 0;}
		.titleMain {font-size: 26px;}
		.titleMain b {font-size: 26px; border-bottom: 1px solid #FAC832;}
		.logoOnline {margin: 0 0 30px 0;}
	</style>
{/literal}
	
</head>
<body>
{if $history_back}
{literal}
<script>
	window.onpopstate = function(event) {
		setTimeout(location.reload(true), 300);
	}
	history.back();
</script>
{/literal}
{else}

{if $new_user}
<!-- Если новый пользователь -->
	{literal}
		<script type="text/javascript">setTimeout("jQuery('#hello_block').hide();", 10000);
			$(document).ready(function() {
				jQuery('#hello_block').fadeIn(1500);
			});
		</script>
	{/literal}
	<div id="hello_block" class="ShAA_helloBlockOut" style="display:none;">
	<div class="ShAA_helloBlockClose" onclick="jQuery('#hello_block').hide();"></div>
		<div class="ShAA_helloBlock">
			<div class="ShAA_helloSelectSex">
				<img src="/images/hello_arrow_1.png" alt="Указать пол" style="margin-left: 50px;" width="53" height="37" />
				<div class="ShAA_arrowText">
					<div class="ShAA_arrowTextImg">
						<img src="/images/hello1.png" width="29" alt="Указать пол" height="28" />
					</div>
					<div class="ShAA_arrowTextInfo">
						Выберите свой пол
						мужской или женский
					</div>
				</div>
			</div>
			<div class="ShAA_helloLogin">
				<img src="/images/hello_arrow_2.png" alt="Войти" style="margin-left: 53px;" width="58" height="44" />
				<div class="ShAA_arrowText">
					<div class="ShAA_arrowTextImg">
						<img src="/images/hello2.png" alt="Войти" width="29" height="28" />
					</div>
					<div class="ShAA_arrowTextInfo">
						Зарегистрируйтесь <br />
						и получите <br />
						скидку 10%
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div class="ShAA_helloText">
				<div class="ShAA_helloTitle">Добро пожаловать</div>
				в интернет-бутик “Лакшери Стор”. Мы Вам рады. 
				Две простые подсказки, которые помогут Вам 
				быстрее найти и выгоднее купить.<br /><br />
				<a href="#" onclick="jQuery('#hello_block').hide();">продолжить</a>
			</div>
		</div>
	</div>
<!-- end Если новый пользователь --> 
{/if}
{if $user_message}
	{literal}
	<style>
		#fancybox-bg-w, #fancybox-bg-e, #fancybox-bg-n, #fancybox-bg-s, #fancybox-bg-sw, #fancybox-bg-se, #fancybox-bg-nw, #fancybox-bg-ne {
			background: none;
		}
		#fancybox-outer {
			background: none;
		}
	</style>
	<script type="text/javascript">setTimeout("jQuery.fancybox.close();", 9000);</script>
	{/literal}
	<div id="message_block" style="display:none;">
		<div class="fullfield">			
				<div class="ShAA_loginBlock" style="background: #fff; border-radius: 10px; border: 1px solid #333; text-align: center;">
					<div class="ShAA_pop_title" style="color: #000;">
					<span>{$user_message}</span>
					</div>
				</div>
		</div>
	</div>
{/if}
<div id="headBlock">
	<div class="headBlock">
        <div class="logoOnline" style="text-align:right;">
            <a href="/"><img src="/images/new_logo.png" alt="Лакшери Стор" width="220" height="64" /></a>
        </div>
		<div class="ShAA_regionName">
			<a rel="nofollow" href="/cart/cities_select/" id="city_link">{if $x_city}{$x_city}{elseif $smarty.session.user->city}{$smarty.session.user->city}{elseif $x_region}{$x_region}{else}Выберите город{/if}</a>
		</div>
        <div class="rightTopLinks">
            <div class="links">
				<div class="phoneInfo" style="width: 180px; margin-top:17px;">
					<span style="float: left; margin: 5px 6px 0 0;"><img src="/images/phone.png" alt="Наш телефон" /></span>
					<a href="tel:88003332138" style="border: none !important;"><b style="color: #000000; font-size: 18px; font-weight: normal; word-spacing: 0.1em;" title="звонок бесплатный">8&ndash;800&ndash;333&ndash;21&ndash;38</b></a>
				</div>
				
				<div style="float: left;">
					{if $smarty.session.user}
						<div class="vk_logout">
							{if !$in_cart}
								<img width="25" src="{if $small_avatar}{$small_avatar}{else}/images/empty_photo.png{/if}" />
							{/if}
							{if $in_cart}
								<a href="/catalog/"><div style="margin: 0px 0 0 -26px;" class="ShAA_toCatalogMini"></div></a>
							{else}
								<div class="cartBlockImg" style="float: left; margin: -4px 8px 0 0;">
									<a rel="nofollow" href="/cart/">
										<span class="vk_logout_text" style="margin: 0;">{$smarty.session.user->name}</span>
										<span class="text">{if $cart_products_num}<br />Корзина&nbsp;({$cart_products_num}){/if}</span>
									<br />
									<span class="ShAA_discountText">скидка от {$smarty.session.group->discount|string_format:"%.0f"}%</span><br />
									{* <span class="ShAA_discountText">Персональная скидка до <span style="color:red;">45%</span></span> *}
									<span class="ShAA_discountText">{if $n_deposit}Депозит {$n_deposit} рублей{/if}</span>
									</a>
								</div>
							{/if}
						</div>
					{else}						
						{if $in_cart}
							<a href="/catalog/" title="Перейти в каталог"><div style="margin: 24px 0 0 -26px; float: left;" class="ShAA_toCatalogMini"></div></a>
						{else}
							<div class="cartBlockImg" style="float: left; margin: 36px 22px 0 18px;">
								<a rel="nofollow" href="/cart/" style="color: #807F7D; font-size: 11px;">
									<span class="cartImg"></span>
									<span class="text">Корзина{if $cart_products_num}&nbsp;({$cart_products_num}){/if}</span>
								</a>
							</div>
						{/if}
						<a rel="nofollow" href="/cart/vk_auth/" id="vk_login_link" class="ShAA_popButtonIn" onclick="{literal}rG('USER_WANNA_LOGIN');return false;{/literal}" 
							title="Войдите на сайт, используя свой аккаунт в популярных соцсетях, и получите скидку" style="float: right; height: 32px; letter-spacing: 1px; margin: 18px 0 0 32px; padding: 13px 0 0; text-align: center;">
							СКИДКА
						</a>
					{/if}
				</div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
	<a name="top"></a>
    <div class="mainMenu">
        <ul class="menuList">
			<li><div class="manOrWoman" style="margin: 0;">
					<div class="button_mw {if $manOrWoman == '1'}male{elseif $manOrWoman == '2'}female{/if}" 
					onmouseover="{literal}jQuery(this).css('background-position','0px -74px');{/literal}"
					onmouseout="{literal}jQuery(this).css('background-position','');{/literal}"
					onclick="{literal}rG('CHANGE_SEX');{/literal}{if isset($filter_url)}window.location.href='{$filter_url}&sex={if $manOrWoman == '1'}2{else}1{/if}';{elseif $page->section_id == 160}window.location.href='?sex={if $manOrWoman == '1'}2{else}1{/if}';{/if}{literal}jQuery(this).css('background-position','0px -50px');{/literal}"
					title="{if $manOrWoman == '1'}переключиться на женский каталог{elseif $manOrWoman == '2'}переключиться на мужской каталог{/if}">
					</div>
			</div></li>
			<li>|</li>
			<li><a href="/catalog/?category=new_season">Новый сезон</a>{if $new_season}<div id="active_menu"></div>{/if}</li>
	        {* <li>|</li>
	        <li><a href="/catalog/?category=new">Что нового</a>{if $whatsnew}<div id="active_menu"></div>{/if}</li> *}
	        <li>|</li>
	        <li><a href="/brandwall/">Дизайнеры</a>{if (preg_match('/brandwall/', $smarty.server.REQUEST_URI))}<div id="active_menu"></div>{/if}</li>
	        <li>|</li>
	        <li><a href="/catalog/?category=big_size">Большие размеры</a>{if $big_size}<div id="active_menu"></div>{/if}</li>
	        {*
			{foreach from=$categories item=cat}
				<li>|</li>
				<li><a href="/categories/{$cat->url}/">{$cat->name}</a>{if ($cat->category_id == $category || $cat->category_id == $view_category)}<div id="active_menu"></div>{/if}</li>
			{/foreach}
			*}
			<li>|</li>
			{if $manOrWoman == '2'}
			<li><a href="/catalog/?category=furs">Меха</a>{if $furs}<div id="active_menu"></div>{/if}</li>
			<li>|</li>
			{/if}
			<li style="width: 42px;"><a rel="nofollow" href="/sale" style="color: #C30000;">Sale</a>{if $sale}<div id="active_menu"></div>{/if}</li>
	    </ul>
        <div class="search">
			<form id="form" name="search" method="get" action="/catalog/" style="cursor:pointer;">
				<input id="textsearch" type="text" name="search" placeholder="Ищем по сайту" value="{if $form_search}{$form_search}{/if}" />
				<input type="submit" class="Search_submit" value=" " onclick="jQuery('#form').submit();{literal}rG('SEARCH');{/literal}" />
			</form>
        </div>
        <div class="clear"></div>
    </div>
	
	
    <div class="footerLine"></div>
</div>

  {*  <div class="active_item"><div class="item"
	{if $whatsnew }	style="display:block; margin-left:114px;"{/if}
	{if (preg_match('/brandwall/', $smarty.server.REQUEST_URI))}	style="display:block; margin-left:206px;"{/if}
		{if $view_category == 1}		style="display:block; margin-left:315px;"	
		{elseif $view_category == 2}	style="display:block; margin-left:253px;"
		{elseif $view_category == 3}	style="display:block; margin-left:400px;"
		{elseif $view_category == 38}	style="display:block; margin-left:195px;"
		{elseif $view_category == 4}	style="display:block; margin-left:391px;"
	{else}
		{if $category == 1}	style="display:block; margin-left:398px;"{/if}	
		{if $category == 2}	style="display:block; margin-left:337px;"{/if}	
		{if $category == 3}	style="display:block; margin-left:402px;"{/if}	
		{if $category ==38}	style="display:block; margin-left:280px;"{/if}	
		{if $category == 4}	style="display:block; margin-left:480px;"{/if}
	{/if}
	></div></div> *}

{* Только на главной *}
{if $page->section_id == 160}
{literal}
<style>
	.ShAA_miniHoverZoom {
		width: 927px;
		position: relative;
		overflow: hidden;
		display: block;
	}
	
	.ShAA_miniHoverZoomTop {
		width: 115px;
		height: 84px;
		position: relative;
		overflow: hidden;
		display: block;
		float: left;
	}
	
	.ShAA_miniHoverZoomTop:hover {
		border-bottom: none;
	}
	
	#wowslider-container2 a, #wowslider-container3 a {
		display: block;
		overflow: hidden;
		width: 456px;
		height: 161px;
		position: relative;
	}
</style>
{/literal}
{/if}

    {if $page->section_id == 160 && isset($specials) }
        <div class="ShAA_enterpoints">
            {foreach from=$specials item=special}
                <div class="ShAA_epItem">
                        <a rel="nofollow" href="/{if $special->look_special}look_{/if}specials/{$special->url}/" target="_blank" class="ShAA_miniHoverZoomTop"><img src="/files/images/{$special->small_picture}"/></a>
                        <a rel="nofollow" href="/{if $special->look_special}look_{/if}specials/{$special->url}/" target="_blank"><span>{$special->name}</span></a>
                </div>
            {/foreach}
        </div>
    {/if}

	<div class="clear"></div>

    <div class="mainContent">
    	{* {if $page->section_id == 160}
    		<div style="width: 927px; height: 338px;">
				<a href="/sale" target="_blank" style="border:none;" class="ShAA_miniHoverZoom">
					<img src="/images/sale_2014_2.png">
				</a>
			</div>
		{/if} *}
        {if $page->section_id == 160 && isset($banner_obj)}		
        	<div style="width: 927px;">
			{if $show_presale == 1}
                <a rel="nofollow" href="/catalog/?category=new_season" target="_blank" style="border:none;margin-bottom:18px;display: block;text-align: center;" onclick="{literal}rG('MAIN_BANNER');{/literal}">
                    {if $smarty.session.user->purchase_sum_real > 0}
                        <img src="/images/presale_{if $manOrWoman == '2'}fe{/if}male.jpg" alt="Закрытая предварительная распродажа для VIP-клиентов" title="Закрытая предварительная распродажа для VIP-клиентов" />
                    {else}
						<img src="/images/presale_5_{if $manOrWoman == '2'}fe{/if}male.png" alt="Скидка 5% на первую покупку" title="Скидка 5% на первую покупку" />
					{/if}
                </a>
            {/if}
			{if $show_total_fur}
				<a rel="nofollow" href="/specials/тотальная-ликвидация-итальянской-верхней-одежды/" target="_blank" style="border:none;margin-bottom:18px;" class="ShAA_miniHoverZoom" onclick="{literal}rG('MAIN_BANNER');{/literal}">
					<img src="/images/mainbaner_fur_new.png" alt="Тотальная ликвидация Итальянской верхней одежды" title="Тотальная ликвидация Итальянской верхней одежды" />
					<div class="ShAA_totalBanner">
						<script src="http://megatimer.ru/s/4a44517a611c43414060eeded2da072f.js"></script>
					</div>
				</a>
			{/if}
        	{if 'swd'|array_key_exists:$promos}
				<a rel="nofollow" href="/sale/" title="Скидка Выходного Дня на одежду и обувь DSQUARED" target="_blank" style="border:none;" class="ShAA_miniHoverZoom" onclick="{literal}rG('BANNER_SWD');{/literal}">
					<img alt="Скидка Выходного Дня на одежду и обувь DSQUARED" src="/files/images/swd/{$promos.swd->main_banner}">
				</a>
			{else}
				{foreach from=$banners item=banner}
	                <a rel="nofollow" href="{$banner->url}" title="{$banner->title}" target="_blank" style="border:none;margin-bottom:18px;" class="ShAA_miniHoverZoom" onclick="{literal}rG('MAIN_BANNER');{/literal}">
	                    <img src="/files/banners/{$banner->image}" alt="{$banner->title}" title="{$banner->title}" />
	                </a>
	            {/foreach}
				{if $show_isaia}
					{if $manOrWoman == '1'}
						<a rel="nofollow" href="http://ru.lsboutique.ru/isaia-custom-tailoring/" target="_blank" style="border:none;margin-bottom:18px;" class="ShAA_miniHoverZoom" onclick="{literal}rG('MAIN_BANNER');{/literal}">
							<img src="/images/isaia.jpg" alt="isaia" title="isaia" />
						</a>
					{/if}
				{/if}
				{foreach from=$banner_obj item=banner}
				<a rel="nofollow" href="/brands/{$banner->url}/" title="{$banner->name}" target="_blank" style="border:none;margin-bottom:18px;" class="ShAA_miniHoverZoom" onclick="{literal}rG('MAIN_BANNER');{/literal}">
					<img src="/files/brand_banners/{$banner->banner}" alt="{$banner->title}" title="{$banner->name}" />
				</a>
				{/foreach}
			{/if}
			</div>
        {/if}
        
        {$content}
		
		<div class="noLinkUnderline" style="text-align:center;">
			{foreach from=$brands item=brand}
				{if $brand->image}
					<a href="/brands/{$brand->url}/?main_page" target="_blank"><img width="212" alt="{$brand->name}" title="{$brand->meta_title}" src="/reimg/files/brands/212x/{$brand->image}" style="margin: 8px;"></a>
				{/if}
			{/foreach}
		</div>
		{if $page->section_id == 160}		
		<div style="width: 927px; height: 161px;">
		  <div style="float: left;margin:15px 15px 0 0;" id="wowslider-container3">
			<a rel="nofollow" target="_blank" title="Бесплатная доставка при заказе от 10 000 рублей" href="{if $city->url}/city/{$city->url}{else}/sections/shipping{/if}">
			  <img src="/files{if $city->image_right}/city/{$city->image_right}{else}/images/bottomright_deliv.png{/if}" alt="Бесплатная доставка при заказе от 10 000 рублей" />
			</a>
		  </div>
			
		{if $x_region_id == 43 || $x_region_id == 35 || $x_region_id == 30 || $x_region_id == 65 || $x_region_id == 73 || $x_region_id == 71 || $x_region_id == 27 || $x_region_id == 22 }
		<div style="float: left;margin-top:15px;" id="wowslider-container2">
			<a rel="nofollow" target="_blank" title="Доставка в {if $x_city}{$x_city}{else}{$x_region}{/if}" href="{if $city->url}/city/{$city->url}{else}/sections/shipping{/if}">
				<img src="/design/default/images/city_banner_{$x_region_id}.png" alt="Доставка в {$x_region}" />
			</a>
		</div>
		{else}
		<div id="wowslider-container2" style="float: left;margin-top:15px;">
			<a rel="nofollow" href="{if $city->url}/city/{$city->url}{else}/sections/shipping{/if}" title="Доставка в Москву за один день" target="_blank">
				<img alt="Доставка в Москву за один день" src="/files{if $city->image}/city/{$city->image}{else}/images/bottomright_moscow.jpg{/if}">
			</a>
		</div>
		{/if}
		</div>
		{/if}
    </div>
    
    <div class="footer">
        <div class="footerLine"></div>
        <div class="footerMenu">
			<div class="footerMenuBlock">
				<div class="footerMenuTitle">Интернет магазин:</div>
				<div>
					<ul>
						<!--{foreach from=$pages_menu item=page}
							<li><a rel="nofollow" href="/sections/{$page->url}" onclick="{literal}rG('SHIPPING_AND_PAYMENT');{/literal}">{$page->name}</a></li>
						{/foreach}-->
						<li><a rel="nofollow" href="{if $city->url}/city/{$city->url}{else}/sections/shipping{/if}" target="_blank">Доставка и оплата</a></li>
						<li><a rel="nofollow" href="/sections/sitemap" target="_blank">Карта сайта</a></li>
						<li><a rel="nofollow" href="/catalog/?mobile=1">Мобильная версия</a></li>
						<li><a rel="nofollow" href="/faq">FAQ</a></li>
						<li><a rel="nofollow" href="http://market.yandex.ru/shop/105646/reviews?clid=703" target="_blank" >Отзывы клиентов</a></li>
						<li><a rel="nofollow" href="/sections/help">Помощь</a></li>
						<li><a rel="nofollow" href="/sections/promo">Как применить промо код</a></li>
						<li><a rel="nofollow" href="/?old_design=0">Новая версия сайта</a></li>
						<li>
							<a rel="nofollow" href="http://ru.lsboutique.ru/zilli-auto/" target="_blank">Тюнинг ZILLI</a>
						</li>
                        <li><a rel="nofollow" href="/sections/personal_data">Согласие на обработку персональных данных</a></li>
					</ul>				
				</div>
			</div>
			<div class="footerMenuBlock">
				<div class="footerMenuTitle">Компания "Лакшери Стор":</div>
				<div>
					<ul>
                        <li><a href="/feed" target="_blank" rel="nofollow">Новости</a></li>
                        <li><a rel="nofollow" href="http://ru.lsboutique.ru/diskont" target="_blank">VIP скидки</a></li>
                        <li><a href="http://ru.lsboutique.ru/doctxt/atele/" target="_blank" rel="nofollow">Пошив костюма</a></li>
                        <li><a href="http://fur.lsboutique.ru/" target="_blank" rel="nofollow">Итальянские меха</a></li>
                        <li><a rel="nofollow" href="/brands/luxury-store/">Подарочные сертификаты</a></li>
                        <li><a href="http://ru.lsboutique.ru/db/shops/" target="_blank" rel="nofollow">Бутики</a></li>
                        <li><a rel="nofollow" href="/sections/contacts" target="_blank">Контакты</a></li>                        
                        <li><a rel="nofollow" href="/work" target="_blank">Работа</a></li>
					</ul>
				</div>
			</div>
			
			
			<div class="footerMenuBlock">
				<div class="footerMenuTitle">Социальные группы:</div>
				<div class="noLinkUnderline">
                    <div class="instagram"></div>
                    <a href="//instagram.com/ls.boutique.ru/"  title="Instagram новинки для мужчин" rel="nofollow" target="_blank" onclick="{literal}rG('SOC_INSTG');{/literal}">
                        новинки мужское
                    </a>
                    </br>
                    <a href="//instagram.com/lsboutique.ru/" title="Instagram новинки для женщин" rel="nofollow" target="_blank" onclick="{literal}rG('SOC_INSTG');{/literal}">
                        новинки женское
                    </a>
                    </br>
                    <a href="//instagram.com/discount.italy/" title="Instagram скидки для мужчин" rel="nofollow" target="_blank" onclick="{literal}rG('SOC_INSTG');{/literal}">
                        скидки мужское
                    </a>
                    </br>
                    <a href="//instagram.com/ls.outlet.italy/" title="Instagram скидки для женщин" rel="nofollow" target="_blank" onclick="{literal}rG('SOC_INSTG');{/literal}">
                        скидки женское
                    </a>
                    </br></br>
                    <div class="fb"></div>
                    <a href="//www.facebook.com/lsboutiq/?ref=bookmarks" title="Facebook мужской" target="_blank" rel="nofollow" onclick="{literal}rG('SOC_FB');{/literal}">
                        мужской
                    </a>
                    </br>
                    <a href="//www.facebook.com/lsboutique.ru/?ref=bookmarks" title="Facebook женский" target="_blank" rel="nofollow" onclick="{literal}rG('SOC_FB');{/literal}">
                        женский
                    </a>
                    </br>
                    </br>
                    <div class="vk"></div>
                    <a href="//vk.com/lsboutiq" title="ВКонтакте Лакшери стор" target="_blank" rel="nofollow" onclick="{literal}rG('SOC_VK');{/literal}">
                        Общая страница
                    </a>
                    </br></br>
                    <a href="//www.youtube.com/channel/UCLCtEXaZq_h2jAOfE2wtwFw" class="social ytub" title="Youtube" rel="nofollow" target="_blank"></a>
					<br>
				</div>
				<div class="footerMenuTitle">Приложения:</div>
				<div class="noLinkUnderline">
					<a rel="nofollow" href="https://itunes.apple.com/us/app/internet-magazin-brendovoj/id913481541?ls=1&mt=8" onclick="rG('wannaIOS');"><img src="/images/Download_on_the_App_Store_Badge_US-UK_135x40.png" style="margin: 0 0 15px 0;"></a>
					<a rel="nofollow" href="https://play.google.com/store/apps/details?id=com.lsboutqiue.app" onclick="rG('wannaAndroid');"><img src="/images/en_generic_rgb_wo_45.png"></a>
				</div>
			</div>
			
			<div class="footerMenuBlock">
				<div class="footerMenuTitle">Прием платежей:</div>
				<div class="copy noLinkUnderline">
					<a href="/sections/shipping" class="cardlogos noline">
						<img height="26" src="/files/payments/13.png?r=591" alt="Оплата и доставка" />
						<img height="27" src="/files/payments/14.png?r=591" alt="Оплата и доставка" />
						<img height="22" src="/files/payments/15.png?r=591" alt="Оплата и доставка" />
					</a>
				</div>
			</div>
			
			<div class="clear"></div>
			<div style="margin: 48px 0 0 0;" title="При использовании изображений прямая ссылка на сайт обязательна">
				&copy; lsboutique.ru {if $x_region}{$x_region}{/if} 2011-{$smarty.now|date_format:"%Y"}
			</div>
        </div>
        <div class="ok">
			{if $cache_link}
            <a href="{$cache_link->cache}" title="{$cache_link->tcache}">{$cache_link->tcache}</a>
			{/if}
            <a href="http://www.ooook.ru" target="_blank" rel="nofollow">Сделано в</a> <img src="/images/ok_logo.png" alt="ОК" />
        </div>
    </div>

{literal}
		<script type="text/javascript">
			function rG(goal, params) {
				if ( !params ) params = [];
				if ( window.yaCounter10626637 !== undefined ) {
					window.yaCounter10626637.reachGoal(goal, params);
					if ( params.order_id !== undefined ) {
						//console.log(goal + ' ' + params.order_id);
					}
				}
				else {
					console.log('yaCounter10626637 not defined');
				}
				return false;
			}
		</script>	
{/literal}


{if !$is_admin}

{literal}

<!-- Google Code for &#1058;&#1077;&#1075; &#1088;&#1077;&#1084;&#1072;&#1088;&#1082;&#1077;&#1090;&#1080;&#1085;&#1075;&#1072; -->
<!-- Remarketing tags may not be associated with personally identifiable information or placed on pages related to sensitive categories. For instructions on adding this tag and more information on the above requirements, read the setup guide: google.com/ads/remarketingsetup -->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 1040221604;
var google_conversion_label = "sRsHCLjg0wUQpIuC8AM";
var google_custom_params = window.google_tag_params;
var google_remarketing_only = true;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/1040221604/?value=0&amp;label=sRsHCLjg0wUQpIuC8AM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>
{/literal}
{/if}

{if $smarty.server.REQUEST_URI != "/" && $browser != "Chrome" }{literal}
<div id="online_helper"></div>
{/literal}{/if}

{/if} <!-- history back -->

{literal}
<script type="text/javascript">
	$r(function () {
		$r('#addToCart').click(function(e){
			e.preventDefault();
			href = $r(this).attr('href');
			href += ('&size='+$r('#userCurrentSize').eq(0).text()); document.cookie='from='+location.href+';path=/';
			rG('ADD_TO_CART');
			window.location = href;
		});	
		
		$r('#RemovePurchase').click(function(){
			item_id 		= $r(this).attr('data-item_id');
			price 			= $r(this).attr('data-price');
			is_available 	= $r(this).attr('data-is_available');
			category 		= $r(this).attr('data-category');

			window.location='/cart/delete/'+item_id;
		});	
	});
</script>
{/literal}

{literal}
<!-- Start Slaask code -->
<script src='https://cdn.slaask.com/chat.js'></script>
<script>
  if(typeof _slaask != "undefined") { 
   _slaask.init('743b120c1ef79fea97380ef35dbeb9fe');
  }
</script>
<!-- End Slaask code -->
{/literal}

<!--{$datetime}-->
</body>
</html>
