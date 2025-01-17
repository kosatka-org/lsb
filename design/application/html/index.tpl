<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=640" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>{$title|escape}</title>
		<link media="all" href="/design/application/css/app_style.css?v=1.7" rel="stylesheet" type="text/css" />		 
		<script type="text/javascript" src="//yandex.st/jquery/1.9.1/jquery.min.js"></script>
		<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-migrate/1.2.1/jquery-migrate.js"></script>
		<script type="text/javascript" src="/design/application/js/scroll.js"></script>
		<script type="text/javascript" src="/jscript/fancybox/js/jquery.fancybox-1.3.4.js"></script>
        <script type="text/javascript" src="/js/sourcebuster.min.js"></script>
		<link href="/jscript/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" type="text/css" />
		{if $smarty.session.user->group_id <= 1 && $config->enviroment == 'live' }
			{literal}
			<!-- google analytics -->
			<script>
			
				(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
				(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
				m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
				})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

				ga('create', 'UA-2641293-44', 'auto');
				ga('send', 'pageview');

			</script>
			<!-- /google analytics -->
			{/literal}
		{/if}
		{literal}
		<script>        
            sbjs.init();
            var ref = sbjs.get.current.src.replace(/^\(+|\)+$/g, '')+'_'+sbjs.get.current.mdm.replace(/^\(+|\)+$/g, '');

			$("input[type=text], textarea").focus(zoomDisable).blur(zoomEnable);
			function zoomDisable(){
			  $('head meta[name=viewport]').remove();
			  $('head').prepend('<meta name="viewport" content="width=device-width user-scalable=0" />');
			}
			function zoomEnable(){
			  $('head meta[name=viewport]').remove();
			  $('head').prepend('<meta name="viewport" content="width=device-width user-scalable=1" />');
			}
			$("body").css("display", "none");
			$(document).ready(function() {
				
				$("body").fadeIn(2000);

				$("a.transition").click(function(event){
					event.preventDefault();
					linkLocation = this.href;
					$("body").fadeOut(1000, redirectPage);
				});

				function redirectPage() {
					window.location = linkLocation;
				}
			});
		</script>
		{/literal}
	</head>
	<body>
			<!--Header-->
			{if !$no_header}
			<div class="head_wrap" id="header" style="position:fixed;">
				<div class="header">
					<div class="icon_wrap">
						<a href="/catalog/?enter_mobile={if $manOrWoman == 2}1{else}2{/if}">
							<img src="/design/application/images/{if $manOrWoman == '1'}m{else}w{/if}.jpg" class="man_or_woman_icon" />
						</a>
					</div>
					<div class="logo_wrap" style="text-transform: uppercase;">
						{if isset($main_page) || isset($whatsnew) || isset($catBrand) || isset($maincategory) || isset($form_search) || isset($parent_name)}
							<a href="/" class="transition">
								{if isset($maincategory) || isset($form_search) || isset($parent_name) && ($whatsnew == false) && !isset($catBrand)}
									<img src="/design/application/images/back.jpg" class="back" /><div class="cat_title">{if $maincategory}{$maincategory}{elseif $form_search}{$form_search}{elseif $parent_name}{$fcat->name}{/if}<div class="white_shadow"></div></div>
								{else}
									{if !$main_page}<img src="/design/application/images/back.jpg" style="margin-top:6px;" class="back" />{/if}<img class="logo" src="/design/application/images/ls_logo.jpg"{if !$main_page} style="margin: 0 0 0 5px;" {/if} />
								{/if}
							</a>
						{elseif $product_brand}
							<a href="{$smarty.server.HTTP_REFERER}" class="transition" /><img src="/design/application/images/back.jpg" class="back" ><div class="cat_title">{$product_brand}<div class="white_shadow"></div></div></a>
						{else}
							<a href="/" class="transition">
								<img src="/design/application/images/back.jpg" style="margin-top:6px;" class="back" /><img class="logo" src="/design/application/images/ls_logo.jpg" style="margin: 0 0 0 5px;" />
							</a>
						{/if}
					</div>
					<div class="head_clear"></div>
				</div>
			</div>
			<div class="app_divider" style="margin: 0;"></div>
			{/if}
			<!--Header end-->
		<!--{debug}-->
		<div class="content">
		{$content}
		</div>
		<!--Smarty template-->
		{literal}
		<script type="text/javascript">
			function rG(goal) {
				//console.log('Goal: ' + goal);
				if ( window.yaCounter10626637 !== undefined ) window.yaCounter10626637.reachGoal(goal);
			}
			// nastachku6RU^ 
		</script>	
{/literal}
{if $smarty.session.user->group_id <= 1 && $config->enviroment == 'live' }
		{literal}
		
		<!-- Yandex.Metrika counter -->
			<script type="text/javascript">
			(function (d, w, c) {
				(w[c] = w[c] || []).push(function() {
					try {
						w.yaCounter27121439 = new Ya.Metrika({id:27121439,
								webvisor:true,
								clickmap:true,
								trackLinks:true,
								accurateTrackBounce:true});
					} catch(e) { }
				});

				var n = d.getElementsByTagName("script")[0],
					s = d.createElement("script"),
					f = function () { n.parentNode.insertBefore(s, n); };
				s.type = "text/javascript";
				s.async = true;
				s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js";

				if (w.opera == "[object Opera]") {
					d.addEventListener("DOMContentLoaded", f, false);
				} else { f(); }
			})(document, window, "yandex_metrika_callbacks");
			</script>
			<noscript><div><img src="//mc.yandex.ru/watch/27121439" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
		<!-- /Yandex.Metrika counter -->


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
</body>
</html>