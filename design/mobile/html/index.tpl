<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=640 user-scalable=1"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>{$title|escape}</title>
		<link rel="stylesheet" href="/design/mobile/css/style_mobile.css?v=1.03" type="text/css" />
		<script type="text/javascript" src="//yandex.st/jquery/1.9.1/jquery.min.js"></script>
		<script type="text/javascript" src="//yandex.st/jquery/cookie/1.0/jquery.cookie.min.js"></script>
        <script type="text/javascript" src="/js/sourcebuster.min.js"></script>
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
    <link media="all" href="/design/adaptive/css/style_index.css" rel="stylesheet" type="text/css" />
{/if}
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
		<script>
            sbjs.init();
            var ref = sbjs.get.current.src.replace(/^\(+|\)+$/g, '')+'_'+sbjs.get.current.mdm.replace(/^\(+|\)+$/g, '');
   
			$(document).ready(function(){
				$(".button").mousedown(function(){
					$(this).addClass("mousedown");
				});
				$(".button").mouseup(function(){
					$(this).removeClass("mousedown");
				});
				$(".button").mouseleave(function(){
					$(this).removeClass("mousedown");
				});
			});
			
			jQuery(window).ready(function() {
              if(document.referrer.indexOf('lsboutiq') === -1 ){
                    if( jQuery.cookie('MA_banneragain') == 1 ){
                        jQuery('.B_overlay').show();
                        jQuery.cookie('MA_banneragain', 2, {expires: 7, path: "/"});
                    }
                    if( jQuery.cookie('MA_banneragain') === null ){
                        jQuery.cookie('MA_banneragain', 1, {expires: 7, path: "/"});
                    }
              }
			})

			$(document).ready(function(){
				$(".menu_icon").click(function(event){
					event.preventDefault();
					$(".menu_wrap").slideToggle(700);
					var con_height = $(".content").attr("style");
					if (con_height == undefined) {
						$(".content").height($(".menu").height() + 220);
					}
					else {
						$(".content").removeAttr("style");
					}
				});
			});

			$(document).on('click', '#call_me', function(event){
				$('#one_click').submit();
				return false;
			});
			$("input[type=text], textarea").focus(zoomDisable).blur(zoomEnable);
			function zoomDisable(){
			  $('head meta[name=viewport]').remove();
			  $('head').prepend('<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=no, maximum-scale=1.0" />');
			}
			function zoomEnable(){
			  $('head meta[name=viewport]').remove();
			  $('head').prepend('<meta name="viewport" content="width=device-width user-scalable=1" />');
			}
		</script>
		{/literal}
	</head>
	<body>
    {if $is_iphone || $is_ipod || $is_ipad}
	<div class="B_overlay">
		<div class="B_close" onclick="$('.B_overlay').fadeOut();"></div>
        <div class="B_close_overlay" onclick="$('.B_overlay').fadeOut();"></div>
		<div class="B_head">
			<div class="B_logo"><img src="/design/mobile/images/logo_white.png"></div>
		</div>
		<div class="B_gray_overlay">
			<div class="B_gray_content">
				<div class="B_Ccolumn left">
                    <a rel="nofollow" href="{if $is_iphone || $is_ipod || $is_ipad}https://itunes.apple.com/us/app/internet-magazin-brendovoj/id913481541?ls=1&amp;mt=8{else}https://play.google.com/store/apps/details?id=com.lsboutqiue.app{/if}" >
                        <img src="/design/mobile/images/logo_square.png">
                    </a>
					<div style="clear:both;"></div>
					<img src="/design/mobile/images/stars.png" style="margin:-12px 0 20px 10px;">
					<div style="clear:both;"></div>
					<img src="/design/mobile/images/text1.png">
					<div style="clear:both;"></div>
					<img src="/design/mobile/images/text2.png">
				</div>
				<div class="B_Ccolumn right"><a rel="nofollow" href="{if $is_iphone || $is_ipod || $is_ipad}https://itunes.apple.com/us/app/internet-magazin-brendovoj/id913481541?ls=1&amp;mt=8{else}https://play.google.com/store/apps/details?id=com.lsboutqiue.app{/if}" ><img src="/design/mobile/images/iphone6s.png"></a></div>
				<div class="B_Cbutton">
					<a rel="nofollow" href="{if $is_iphone || $is_ipod || $is_ipad}https://itunes.apple.com/us/app/internet-magazin-brendovoj/id913481541?ls=1&amp;mt=8{else}https://play.google.com/store/apps/details?id=com.lsboutqiue.app{/if}" >
						<img src="/design/mobile/images/{if $is_iphone || $is_ipod || $is_ipad}iphone6s_0000_Shape-1.png{else}android.png{/if}" style="width:402px;">
					</a>
					<div style="clear:both;"></div>
					<img src="/design/mobile/images/iphone6s_0006_©-2016-Luxury-Store.png">
				</div>
			</div>
		</div>
	</div>
	{/if}
   {if $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-KMNDWNG"
    height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->
   {/if}
		{if !$no_header}
			<div class="content">
				<!--Menu-->
				{include file='menu.tpl'}
				<!--Menu end-->

				<!--Header-->
				<a href="#" title="Меню" alt="Меню">
					{if $smarty.session.user}
						<div class="menu_icon">
							{if $smarty.session.user->photo}
								<img src="{$smarty.session.user->photo}" width="80px">
							{else}
								<img src="/images/empty_photo.png" width="80px">
							{/if}
						</div>
					{else}
						<div class="menu_icon"></div>
					{/if}
				</a>
				<a href="/" title="На главную">
					<div class="logo">
						<img src="/design/mobile/images/new_logo.png" title="" alt="">
					</div>
				</a>
				<div class="icon_wrap">
					<a href="/catalog/?enter_mobile={if $manOrWoman == 2}1{else}2{/if}">
						<img src="/design/mobile/images/{if $manOrWoman == '1'}m{else}w{/if}.jpg" class="man_or_woman_icon" />
					</a>
				</div>
<!--
				{if $smarty.session.user}
					<div class="bag">
						{if $smarty.session.user->photo}
							<img src="{$smarty.session.user->photo}" width="80px">
						{else}
							<img src="/images/empty_photo.png" width="80px">
						{/if}
					</div>
				{/if}
-->
				<!-- <a href="/cart/" title="" alt="">
					<div class="bag">
						<div class="bag_num">10</div>
					</div>
				</a> -->
				<!--Header end-->
				
				<div class="divider" style="margin: 0;"></div>
		{/if}
		{$content}
		<!--Smarty template-->
		{if !$no_header && !isset($smarty.get.call_me) && !isset($smarty.get.one_click) && !isset($smarty.get.helpform)}
			<div class="divider" style="margin: 0;"></div>
			<!--Footer-->
			<a href="/catalog/?mobile=0" title="Полная версия сайта" alt="Полная версия сайта" onclick="rG('TO_FULL_VERSION');">
				<div class="button button560px button_text">
					Полная версия сайта
				</div>
			</a>
			<div class="button_wrap" style="margin: 0px 0 10px 40px;">
				<a href="/sections/mobile_delivery/" title="Информация о доставке" alt="Информация о доставке">
					<div class="button button160px button_text">
						Доставка
					</div>
				</a>
				<a href="/sections/mobile_payment/" title="Информация об оплате" alt="Информация об оплате">
					<div class="button button160px button_text">
						Оплата
					</div>
				</a>
				<a href="/faq" title="вопросы и ответы" alt="вопросы и ответы">
					<div class="button button160px button_text">
						FAQ
					</div>
				</a>
			</div>
			<!--Footer end-->
			<div class="divider" style="margin: 0;"></div>
			<div class="item_wrap">
				<a href="https://itunes.apple.com/us/app/internet-magazin-brendovoj/id913481541?ls=1&mt=8" onclick="rG('wannaIOSmob');"><img src="/images/Download_on_the_App_Store_Badge_US-UK_135x40.png" style="float: left;"></a>
				<a href="https://play.google.com/store/apps/details?id=com.lsboutqiue.app" onclick="rG('wannaAndroidMob');"><img src="/images/en_generic_rgb_wo_45.png" style="float: right;"></a>
			</div>
		{/if}
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
{if $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
{literal}
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

	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

	  ga('create', 'UA-2641293-46', 'auto');
	  ga('send', 'pageview');
	</script>
{/literal}
{/if}
</body></html>