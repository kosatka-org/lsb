<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>VIPSALE {$title|escape}</title>
    <meta name="description" content="{$description|escape}" />
    <meta name="keywords" content="{$keywords|escape}" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    <meta http-equiv="Content-Language" content="ru" />
    <meta name='yandex-verification' content='5520ef1e14c90d1b' />
    <meta name="robots" content="all" />

    <link rel="alternate" type="application/rss+xml" title="rss feed" href="/rss/"/>
    <link media="all" href="/css/style.css?v=1.84" rel="stylesheet" type="text/css" />
    <link media="all" href="/design/discount/css/discount_style.css?v=1.3" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="/sizes/css/style_s.css?v=1.87" type="text/css" />
    <link href="/favicon.ico" rel="icon" type="image/x-icon" />
    <script type="text/javascript" src="//yandex.st/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="//yandex.st/jquery/cookie/1.0/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-migrate/1.2.1/jquery-migrate.js"></script>
    <script type="text/javascript" src="/jscript/fancybox/js/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="/js/sourcebuster.min.js"></script>
    <link href="/jscript/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="/jscript/slider.css?v=1.01" />

    <link media="all" href="/design/adaptive/css/font-awesome.css" rel="stylesheet" type="text/css" />

    {if $smarty.session.user->group_id > 1}
        <script src="/js/admintooltip/php/admintooltip.php" language="JavaScript" type="text/javascript"></script>
        <link href="/js/admintooltip/css/admintooltip.css" rel="stylesheet" type="text/css" />
    {/if}

{if $smarty.session.user->group_id <= 1 && $config->enviroment == 'live' }
{literal}
<!--Google Analytics-->
<script>
    var _gaq = _gaq || [];
     _gaq.push(['_setAccount', 'UA-2641293-27']);
     _gaq.push(['_setDomainName', 'none']);
     _gaq.push(['_setAllowLinker', true]);
     _gaq.push(['_trackPageview']);

    (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ga, s);
    })();

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
                'padding'           : 0,
                'titlePosition'     : 'inside',
                'autoScale'         : 'true',
                'opacity'           : 'false',
                'scrolling'         : 'no',
                'overlayColor'      : '#000'
            });
            jQuery("div[rel*=facebox]").fancybox({
                'padding'           : 0,
                'titlePosition'     : 'inside',
                'autoScale'         : 'true',
                'opacity'           : 'false',
                'scrolling'         : 'no',
                'overlayColor'      : '#000'
            });
            jQuery("a#feedbackbox").fancybox({
                'padding'           : 0,
                'titlePosition'     : 'inside',
                'autoScale'         : 'true',
                'opacity'           : 'false',
                'scrolling'         : 'no',
                'overlayColor'      : '#000'
            });
            jQuery("a#faq").fancybox({
                'padding'           : 0,
                'titlePosition'     : 'inside',
                'autoScale'         : 'true',
                'opacity'           : 'false',
                'scrolling'         : 'no',
                'overlayColor'      : '#000'
            });
            jQuery("a#vk_login_link").fancybox({
                'padding'           : 0,
                'titlePosition'     : 'inside',
                'autoScale'         : 'true',
                'opacity'           : 'false',
                'scrolling'         : 'no',
                'overlayColor'      : '#000'
            });
            jQuery("a#city_link").fancybox({
                'padding'           : 0,
                'titlePosition'     : 'inside',
                'autoScale'         : 'true',
                'opacity'           : 'false',
                'scrolling'         : 'no',
                'overlayColor'      : '#000'
            });
            if ( jQuery('#message_block').html() ) {
                jQuery.fancybox({
                    'padding'           : 0,
                    'titlePosition'     : 'inside',
                    'autoScale'         : 'true',
                    'opacity'           : 'false',
                    'scrolling'         : 'no',
                    'overlayColor'      : '#000',
                    'content'           : jQuery('#message_block').html()
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
    <div class="headBlock">
        <div class="logoOnline" style="text-align:right;">
            <a href="/"><img src="/images/vip_logo.jpg" alt="VIP Sale" title="на главную" width="220" height="64" style="width: 220px; height: 64px; border: none; float: left;" /></a>
        </div>
        <div class="manOrWoman">
            <a href="/catalog/?category=megasale&sex=1" onclick="{literal}rG('CHANGE_SEX');{/literal}" {if $manOrWoman == '1'} class="ShAA_boldLink" {/if} title="переключиться на мужской каталог">Для мужчин</a> /
            <a href="/catalog/?category=megasale&sex=2" onclick="{literal}rG('CHANGE_SEX');{/literal}" {if $manOrWoman == '2'} class="ShAA_boldLink" {/if} title="переключиться на женский каталог">Для женщин</a>
        </div>
        <div class="rightTopLinks">
            <div class="links">
                <div class="phoneInfo" style="width: 190px; margin:17px 0 0; text-align: right;">
                    <span style="float: left; margin: 5px 6px 0 0;display: none;"><img src="/images/phone.png" alt="Наш телефон" /></span>
                    <a href="tel:+74991108179" style="border: none !important;"><b style="color: #000000; font-size: 18px; font-weight: normal; word-spacing: 0.1em;" title="звонок бесплатный">+7&nbsp;(499)&nbsp;110&ndash;81&ndash;79</b></a>
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
    <a name="top"></a>
<!--
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
            <li><a rel="nofollow" href="/sale" style="color: #C30000; line-height: 26px; font-size: 18px;">MEGA Sale</a></li>
        </ul>
        <div class="clear"></div>
    </div>
-->

  {*  <div class="active_item"><div class="item"
    {if $whatsnew } style="display:block; margin-left:114px;"{/if}
    {if (preg_match('/brandwall/', $smarty.server.REQUEST_URI))}    style="display:block; margin-left:206px;"{/if}
        {if $view_category == 1}        style="display:block; margin-left:315px;"
        {elseif $view_category == 2}    style="display:block; margin-left:253px;"
        {elseif $view_category == 3}    style="display:block; margin-left:400px;"
        {elseif $view_category == 38}   style="display:block; margin-left:195px;"
        {elseif $view_category == 4}    style="display:block; margin-left:391px;"
    {else}
        {if $category == 1} style="display:block; margin-left:398px;"{/if}
        {if $category == 2} style="display:block; margin-left:337px;"{/if}
        {if $category == 3} style="display:block; margin-left:402px;"{/if}
        {if $category ==38} style="display:block; margin-left:280px;"{/if}
        {if $category == 4} style="display:block; margin-left:480px;"{/if}
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
        <div class="footerLine" style="opacity: 0;"></div>
        <div class="footerMenu">
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
            item_id         = $r(this).attr('data-item_id');
            price           = $r(this).attr('data-price');
            is_available    = $r(this).attr('data-is_available');
            category        = $r(this).attr('data-category');

            window.location='/cart/delete/'+item_id;
        });
    });
</script>
{/literal}

{literal}
<!-- Start Slaask code -->
<script src='https://cdn.slaask.com/chat.js'></script>
<script>
//   _slaask.init('743b120c1ef79fea97380ef35dbeb9fe');
</script>
<!-- End Slaask code -->
{/literal}

<!--{$datetime}-->
</body>
</html>
