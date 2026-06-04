<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>{$title|escape}</title>
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
    <meta name="description" content="{$description|escape}" />
    <meta name="keywords" content="{$keywords|escape}" />
    <meta name="title" content="{$title|escape}" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    <meta http-equiv="Content-Language" content="ru" />
    <meta name='yandex-verification' content='5520ef1e14c90d1b' />
	{if preg_match('/\Helpform\b/', $smarty.server.REQUEST_URI) || preg_match('/\Specialorder\b/', $smarty.server.REQUEST_URI) || preg_match('/\Subscription\b/', $smarty.server.REQUEST_URI) || preg_match('/\Oneclick\b/', $smarty.server.REQUEST_URI)}
	<meta name="robots" content="noindex, nofollow" />
	{else}
    <meta name="robots" content="all" />
	{/if}
	<meta property="og:url" content="{$smarty.server.SHOW_URI}">
	<meta property="og:title" content="{$title|escape}">
	<meta property="og:type" content="website">
	<meta property="og:description" content="{$description|escape}">
	{if $og_image}
	<meta property="og:image" content="{$og_image}">
	{else}
	<meta property="og:image" content="/images/og_link_image_l.jpeg ">
	<meta property="og:image" content="/images/og_link_image.jpeg ">
	<meta property="og:image" content="/images/og_link_image_l.jpeg ">
	{/if}
	<meta property="og:site_name" content="Luxury Store">
	<meta property="og:image:alt" content="{$title|escape}">
	{if $og_image}
	<meta property="og:image:secure_url" content="{$og_image}">
	{else}
	<meta property="og:image:secure_url" content="/images/og_link_image_l.jpeg ">
	{/if}

	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="{$smarty.server.SHOW_URI}">
	<meta name="twitter:title" content="{$title|escape}">
	{if $og_image}
	<meta property="twitter:image" content="{$og_image}">
	{else}
	<meta property="twitter:image" content="/images/og_link_image_l.jpeg ">
	{/if}
	<meta name="twitter:description" content="{$description|escape}">
	<meta name="twitter:site" content="@lsboutique">


    <meta name="apple-itunes-app" content="app-id=913481541" />
    <meta name="google-play-app" content="app-id=com.lsboutqiue.app">
    <link rel="apple-touch-icon" href="apple-touch-icon.png">
    <link rel="android-touch-icon" href="android-icon.png" />
    <link rel="apple-touch-icon" sizes="57x57" href="/images/icons/apple-touch-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/images/icons/apple-touch-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/images/icons/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/images/icons/apple-touch-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="60x60" href="/images/icons/apple-touch-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="120x120" href="/images/icons/apple-touch-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="76x76" href="/images/icons/apple-touch-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/images/icons/apple-touch-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/images/icons/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/images/icons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="192x192" href="/images/icons/android-chrome-192x192.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/images/icons/favicon-16x16.png">
    <link rel="manifest" href="/images/icons/manifest.json">
    <link rel="mask-icon" href="/images/icons/safari-pinned-tab.svg" color="#5bbad5">
    <link rel="shortcut icon" href="/images/icons/favicon.ico">
    <meta name="msapplication-TileColor" content="#da532c">
    <meta name="msapplication-TileImage" content="/images/icons/mstile-144x144.png">
    <meta name="msapplication-config" content="/images/icons/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">

    {if !$offlineSales && $smarty.session.user->group_id < 2 && $config->enviroment == 'live' }
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
    {/if}
    <link rel="alternate" type="application/rss+xml" title="rss feed" href="/rss/"/>
    <link media="all" href="/design/adaptive/css/style.css?v=1.252" rel="stylesheet" type="text/css" />

    <link href="/favicon.ico" rel="icon" type="image/x-icon" />
    <script type="text/javascript" src="/js/jquery/jquery.min.1.9.1.js"></script>
    {literal}
    <script type="text/javascript">
        var $r = jQuery.noConflict();
        var $ = jQuery.noConflict();
    </script>
    {/literal}
    <script type="text/javascript" src="/js/jquery/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-migrate.1.2.1.js"></script>
    <script type="text/javascript" src="/jscript/fancybox/js/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="/js/sourcebuster.min.js"></script>
    <script type="text/javascript" src="/jscript/jquery.visible.min.js"></script>

    <script type="text/javascript" src="/design/adaptive/css/bootstrap-toggle.js"></script>
    <link href="/jscript/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" type="text/css" />
    {if !$is_iphone && !$is_ipod && !$is_ipad && $smarty.session.user->group_id < 2 && $config->enviroment == 'live'}
      {if $page->section_id == 160}
          <script>
          //Criteo dataLayer
              {literal}
                  jQuery(document).ready(function() {
                      dataLayer.push({
                          'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
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
    <link href='/fonts/roboto_google_font.css' rel='stylesheet' type='text/css' />
    <link media="all" href="/design/adaptive/css/font-awesome.css?v=1" rel="stylesheet" type="text/css" />
    {if $smarty.session.user->group_id > 1}
        <script defer src="/js/admintooltip/php/admintooltip.php" language="JavaScript" type="text/javascript"></script>
        <link href="/js/admintooltip/css/admintooltip.css" rel="stylesheet" type="text/css" />
    {/if}
    {if $page->section_id == 160}
        <link media="all" href="/design/adaptive/css/style_index.css" rel="stylesheet" type="text/css" />
    {/if}
{assign var="query" value=$smarty.server.QUERY_STRING|replace:'lang=eng':''|replace:'lang=ru':''}

<script type="text/javascript">
var eng_link = "{if $query}{$smarty.server.PATH_INFO}?{$query}&lang=eng{else}{$smarty.server.PATH_INFO}?lang=eng{/if}";
var geolocation ='{$geolocation}';
{literal}
    sbjs.init();
    if (typeof(sbjs.get.current.src) !== 'undefined') {
        var ref = sbjs.get.current.src.replace(/^\(+|\)+$/g, '')+'_'+sbjs.get.current.mdm.replace(/^\(+|\)+$/g, '');
    }

    var language = window.navigator ? (window.navigator.language ||
                  window.navigator.systemLanguage ||
                  window.navigator.userLanguage) : "ru";
    language = language.substr(0, 2).toLowerCase();
    if(language != "ru" && jQuery.cookie('language') == null){
      window.location = eng_link;
    }

    function set_currency(currency){
      jQuery.cookie("currency", currency, {expires: 7, path: "/"});
      $('.price').hide();
      $(".price."+currency).css('display', 'inline-block');
      $.get('/index.php?module=Login&set_currency='+currency);
    }

    $(document).on('change', "#currency_switch", function(e) {
      var currency = $(this).val();
      set_currency(currency);
    });

    jQuery(document).ready(function() {
        var elems = $('.ShAA_adminTabs');
        for(var i=0;i<elems.length; i++){
            var new_elem = document.createElement("a");
            new_elem.href = $(elems[i]).find('a').attr('href');
            new_elem.text = $(elems[i]).find('a').html();
            new_elem.style = 'display: block; margin: 1.3vh'
            document.getElementById('secondlist_mobile_menu_container').appendChild(new_elem);
            //$(elems[i]).find('a').attr('href')
        }

        $('#ShAA_hideMenuToLeft').click(function(){
            $('.mobile_menuList').removeClass('second_list_menu');
        });
        $('.admin_mobile').click(function(){
            $('.mobile_menuList').toggleClass('second_list_menu');
        });
        $('.secondlist_mobile_menu_container').click(function(){
            $('.mobile_menuList').toggleClass('second_list_menu');
        });
		if(!(jQuery(".ShAA_popBackCenter")[0])) {
			jQuery(".breadCrumbs").css('display','block');
		}
        if( jQuery.cookie('currency') ){
          var currency = jQuery.cookie('currency');
          set_currency(currency);
        }
        jQuery("a[rel*=facebox]").fancybox({
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

        jQuery("a#popUp_leaving").fancybox({
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
        if ( jQuery('#error_message').html() ) {
          jQuery("a#error_message").fancybox({
              'padding'           : 0,
              'titlePosition'     : 'inside',
              'autoScale'         : 'true',
              'opacity'           : 'false',
              'scrolling'         : 'no',
              'overlayColor'      : '#000'
          });
        }
        if ( jQuery('#client_add_link').html() ) {
          jQuery("a#client_add_link").fancybox({
              'padding'           : 0,
              'titlePosition'     : 'inside',
              'autoScale'         : 'true',
              'opacity'           : 'false',
              'scrolling'         : 'no',
              'overlayColor'      : '#000'
          });
        }
        if ( jQuery('#service_add_link').html() ) {
          jQuery("a#service_add_link").fancybox({
              'padding'           : 0,
              'titlePosition'     : 'inside',
              'autoScale'         : 'true',
              'opacity'           : 'false',
              'scrolling'         : 'no',
              'overlayColor'      : '#000'
          });
        }
        /* Подготавливаем иконку меню */
        jQuery('#nav-wrap').prepend('<a class="ShAA_toUp"><span id="menu-icon"><i class="icon-reorder icon-2x"></i></span></a>');

        /* Переключаем навигацию */
        jQuery('body').css('marginLeft','0px');

        function menuLeftRight() {
            var lefty = jQuery("#nav");
            var leftcontent = jQuery('body');

            lefty.fadeToggle("fast","swing");;
            lefty.css('width', '94%');
            lefty.css('padding', '0 3%');
            if (jQuery("#headBlock").hasClass("ShAA_fixedMenu")) {
                lefty.css('margin-top', '-26px');
            } else {lefty.css('margin-top', '0px');}
        }

        jQuery("#menu-icon").on("click", function(){
            menuLeftRight();
            jQuery('body').css('overflow','hidden');
        });

        jQuery("#ShAA_hideMenuToLeft").on("click", function(){
            menuLeftRight();
            jQuery('body').css('overflow','auto');
        });
        jQuery('.ShAA_mobileFilters:not(:first)').remove();
        jQuery('.ShAA_filterBig:not(:first)').remove();
        if (geolocation == 'KZ'){
            let arr = $('#currency_switch option');
            for(let i=0; i<arr.length; i++){
                if (arr[i].value == 'kzt'){
                    arr[i].selected = "selected";
                }
            }
            set_currency('kzt');
            if(!localStorage.getItem('noKZ')) {
                $('.message_fof_KZ__bg').show();
                localStorage.setItem('noKZ', 'true')
            }
        }
        $('.message_fof_KZ__close, .message_fof_KZ__button, .message_fof_KZ__bg').click(function(){
            $('.message_fof_KZ__bg').hide();
        });
    });

    var zoomEnable;
    zoomEnable = function() {
      jQuery("head meta[name=viewport]").prop("content", "width=device-width, initial-scale=1.0, user-scalable=yes");
    };

    jQuery("input[type='text']").on("touchstart", function(e) {
      jQuery("head meta[name=viewport]").prop("content", "viewportmeta.content = 'width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no'");
    });

    jQuery("input[type='text']").blur(zoomEnable);

    jQuery(document).on("click", "#active_menu", function() {
        if( jQuery.cookie('language') === 'eng'){
          var filter = 'Filters',
          hide = 'hide';
        }else{
          var filter = 'Фильтры',
          hide = 'скрыть';
        }
        if ((jQuery('#catalog_left').is(":visible") == true) && ( "" + jQuery(this).html() != hide ) ) {
            jQuery(this).html(hide);
        }
        else {
            jQuery("#catalog_left").slideToggle();
            if ( "" + jQuery(this).html() != hide ) {
                jQuery(this).html(hide);
            }
            else {
                jQuery(this).html(filter);
            }
        }
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

    jQuery(document).on("click", "#active_menu_mob", function() {
        jQuery("#catalog_left").slideToggle();
    });
        jQuery(window).ready(function() {
            var tabNum = (Number(jQuery.cookie('tabNum')) + 1);
            jQuery.cookie('tabNum', tabNum, {expires: 1, path: "/"});
            if( jQuery.cookie('ShowTab') === null ){
                setTimeout(function() {jQuery.cookie("ShowTab", 1, {expires: 7, path: "/"});}, 30000);
            }
        })
        jQuery(window).on('beforeunload', function() {
            var tabNum = (Number(jQuery.cookie('tabNum')) - 1);
            jQuery.cookie('tabNum', tabNum, {expires: 1, path: "/"});
        })
    </script>
    <style media="print" type="text/css" >
        .mainMenu {display: none; height: 0px; visibility: hidden;}
        .rightTopLinks {display: none; height: 0px; visibility: hidden;}
        .footer {display: none; height: 0px; visibility: hidden;}
        .noprint {display: none;}
        body {background:#FFF; color:#000;}
        .userInfo {display: block; color: #000;}
        .tableOrder td {border-bottom: 2px solid #777777; padding: 15px 6px 10px 6px;}
        .userInfo div {margin: 16px 0 0 0;}
        .titleMain {font-size: 26px;}
        .titleMain b {font-size: 26px; border-bottom: 1px solid #FAC832;}
        .logoOnline {margin: 0 0 30px 0;}
    </style>
{/literal}
 {if $page->section_id == 160}
        <script>
    {literal}
        var send_banners = [];
        var impressions = [];
        var size = 0;
        function get_data(){
          var data = {
              block_height: jQuery('.ShAA_miniHoverZoom').first().height(),
              cont_height: jQuery(window).height(),
              scroll: jQuery(window).scrollTop() -  200
          }
          data['rows'] = parseInt((data['scroll'] + data['cont_height']) / data['block_height']);
          data['blocks'] = data['rows'] - 1;
          return data;
        }
        function process_blocks(){
          if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            var blocs = jQuery('.ShAA_miniHoverZoom')
                data = get_data();
            for(i = data['blocks']; i < blocs.length; i++){
              var e = jQuery('.ShAA_miniHoverZoom').eq(i);
              if (e.visible(true)){
                var id = e.data('id');
                if(typeof(send_banners[id]) === "undefined"){
                  impressions[i] = {
                    id: id,
                    name: e.find('img').attr('title'),
                    position: i+1
                  };
                  size++;
                  send_banners[id] = id;
                }
              }
              else{break;}
            }
            if(size>0){
              dataLayer.push({
                'ecommerce': {
                'promoView': {
                  'promotions': impressions
                }
              },
              'event': 'gtm-ee-event',
              'gtm-ee-event-category': 'Enhanced Ecommerce',
              'gtm-ee-event-action': 'Promotion Impressions',
              'gtm-ee-event-non-interaction': true,
              });
              //impressions = [];
              size = 0;
              console.log(dataLayer);
            }
          }
        }
        function block_click(e){
          if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            var click_block = {
              id: e.data('id'),
              name: e.find('img').attr('title'),
              position: jQuery('.ShAA_miniHoverZoom').index(e)+1
            };
            dataLayer.push({
             'ecommerce': {
               'promoClick': {
                 'promotions': [click_block]
               }
             },
             'event': 'gtm-ee-event',
             'gtm-ee-event-category': 'Enhanced Ecommerce',
             'gtm-ee-event-action': 'Promotion Clicks',
             'gtm-ee-event-non-interaction': false,
            });
            console.log(dataLayer);
          }
        }


        jQuery(document).on('click touchstart', 'a.ShAA_miniHoverZoom',function (){
          block_click(jQuery(this));
        });

        jQuery(window).ready(function() {
          process_blocks();
        });
        jQuery(window).on('scroll',function (){
          process_blocks();
        });
      {/literal}
        </script>
    {/if}
<script src='https://www.google.com/recaptcha/api.js'></script>
</head>
<body>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-KMNDWNG"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<div name="top" id="top" style=""></div>
{if $history_back}
{literal}
<script type="text/javascript">
    window.onpopstate = function(event) {
        setTimeout(location.reload(true), 300);
    }
    history.back();
</script>
{/literal}
{else}

{if $show_furs}
<!-- скрипты progressbar для перекрывающего баннера -->
<script type="text/javascript" src="/jscript/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="/jscript/progress_script.js"></script>
<link rel="stylesheet" type="text/css" href="/jscript/jquery-ui-1.8.16.custom.css" />
<link rel="stylesheet" type="text/css" href="/jscript/progress_script.css" />
<!-- end скрипты progressbar для перекрывающего баннера -->
{literal}
    <script type="text/javascript">
        setTimeout("jQuery('#fur_banner').fadeOut(400);", 6000);
    </script>
{/literal}

<!-- перекрывающий баннер -->
<div id="fur_banner" class="ShAA_furBannerBlockOut">
    <div class="ShAA_furBannerImg">
        <img style="width: 95%; height: auto;" src="/design/adaptive/images/fur_banner_photo.png" />
    </div>
    <div class="ShAA_furBannerRightBlock">
        <div style="text-align: center; margin-bottom: 15%;">
            <img style="width: 80%; height: auto; margin: 12% 0 20% 0;" src="/design/adaptive/images/fur_banner_logo.png" />
            <img style="width: 80%; height: auto;" src="/design/adaptive/images/fur_banner_100.png" />
        </div>
        <div class="ShAA_buttonFur">
            <a href="/catalog/?category=furs">
                <span class="ShAA_buttonFurYes">узнать больше</span>
            </a>
            <a href="#" onclick="jQuery('#fur_banner').hide();">
                <span class="ShAA_buttonFurNo">нет, спасибо</span>
            </a>
        </div>
    </div>
    <div class="ShAA_progressBarBlock" id="progress">
        <div class="pbar"></div>
    </div>
</div>
<!--END перекрывающий баннер -->
{/if}

{if 0 && $new_user}
<!-- Если новый пользователь -->
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
    {literal}
        <script type="text/javascript">setTimeout("jQuery('#hello_block').hide();", 10000);
            jQuery(document).ready(function() {
                jQuery('#hello_block').fadeIn(1500);
            });
        </script>
    {/literal}
<!-- end Если новый пользователь -->
{/if}

{if $user_message}
    <div id="message_block" style="display:none;">
        <div class="fullfield">
            <div class="ShAA_popBackCenter">
                <div class="ShAA_loginBlock" style="text-align: center;">
                    <div class="ShAA_pop_title" style="color: #000;">
                    <span>{$user_message}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {literal}
    <script type="text/javascript">setTimeout("jQuery.fancybox.close();", 9000);</script>
    {/literal}
{/if}
    <ul class="menuList mobile_menuList" id="nav" style="display: none;">

            <li class="first_li" style="margin: 40px 0 24px;">
                <div style="width: 100%; text-align: center;">
                    <div id="ShAA_hideMenuToLeft">
                        <i class="icon-close icon-2x" aria-hidden="true" style="width: auto;"></i>
                    </div>
<!--
                    <input style="position: absolute !important; right: 50x;" {if $manOrWoman != '2'}checked="checked"{/if} data-on="{if $language == 'eng'}for Him{else}для Него{/if}" data-off="{if $language == 'eng'}for Her{else}для Неё{/if}" data-toggle="toggle" data-style="ios" type="checkbox" onchange="{literal}rG('CHANGE_SEX');{/literal}{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex={if $manOrWoman != '2'}2{else}1{/if}';{elseif $page->section_id == 160}window.location.href='?sex={if $manOrWoman != '2'}2{else}1{/if}';{/if}" />
-->
                    <div style="overflow:hidden;float:right;margin-top:-2px;">
                      <div style="float: left;margin:2px 10px 0 0;">
                        <select name="currency_switch" id="currency_switch" style="background-color:#fafafa;border:1px solid #fafafa; height: 26px;">
                          {foreach from=$currencies item=currency}
                            <option value="{$currency->code}" style="background-color:#fafafa;border:1px solid #fafafa;" {if $currency->main == 1 && !$smarty.cookies.currency}selected{elseif $currency->code == $smarty.cookies.currency}selected{/if}>{$currency->code}</option>
                          {/foreach}
                        </select>
                      </div>
                      <div style="float: left;margin:0 20px 20px 0;">
                        {if $language == 'eng'}<a href="{if $query}{$smarty.server.PATH_INFO}?{$query}&lang=ru{else}{$smarty.server.PATH_INFO}?lang=ru{/if}" title="Русская версия"><img width="30" src="/images/eng_icon.png" style="" alt="RU" /></a>
                        {else}<a href="{if $query}{$smarty.server.PATH_INFO}?{$query}&lang=eng{else}{$smarty.server.PATH_INFO}?lang=eng{/if}" title="English version"><img width="30" src="/images/rus_icon.png?v=2" style="" alt="RU" /></a>{/if}
                      </div>
                    </div>
					{if !$showbrand->gender && !preg_match('/\blook\b/', $smarty.server.REQUEST_URI) && !$no_show}
						<div class="ShAA_upBlock ShAA_sexMobileBlock" style="text-transform: uppercase; margin-bottom: 24px;">
							<span {if $manOrWoman == '1'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=1';{elseif $page->section_id == 160}window.location.href='?sex=1';{/if}">{if $language == 'eng'}men{else}мужское{/if}</span>
							<span {if $manOrWoman == '2'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=2';{elseif $page->section_id == 160}window.location.href='?sex=2';{/if}">{if $language == 'eng'}women{else}женское{/if}</span>
							<span {if $manOrWoman != '1' && $manOrWoman != '2'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=0&amp;allsex=1';{elseif $page->section_id == 160}window.location.href='?allsex=1&amp;sex=0';{/if}">{if $language == 'eng'}all{else}все{/if}</span>
						</div>
					{/if}
                </div>
            </li>

        <li style="display: none;">
            <div class="phoneInfoMini">
                <a href="tel:+74953748934" style="border: none !important;"><b style="font-weight: normal; word-spacing: 0.1em;" title="">+7&nbsp;(495)&nbsp;374&ndash;89&ndash;34</b></a>
            </div>
        </li>
        <li><a href="/catalog/?category=new_season">{if $language == 'eng'}New arrivals{else}Новый сезон{/if}</a>{if $new_season}{/if}</li>
        {if $manOrWoman == '2'}
        <li><a href="/catalog/?category=furs" style="color: rgb(216, 0, 104);">{if $language == 'eng'}Furs{else}Меха{/if}</a>{if $furs}{/if}</li>
        {/if}
        <li><a href="/brandwall/">{if $language == 'eng'}Designers{else}Бренды{/if}</a></li>
        <li><a href="/looks/">{if $language == 'eng'}Looks{else}Образы{/if}</a></li>

        {foreach from=$categories item=cat}
            <li><a href="/categories/{$cat->url}/">{if $language == 'eng'}{$cat->eng_name}{else}{$cat->name}{/if}</a>{if ($cat->category_id == $category || $cat->category_id == $view_category)}{/if}</li>
        {/foreach}

        <li><a rel="nofollow" href="/sale" style="color: #C30000;">Sale</a>{if $sale}{/if}</li>
        {if $smarty.session.user}
            <li style="width: 200vw;">
                <a style="width: 99vw; float: left; margin-bottom: 15px" class="admin_mobile">меню администратора</a>
                <div id="secondlist_mobile_menu_container"  class="secondlist_mobile_menu_container"><a style="position: relative; top: -20px">назад</a></div>
            </li>
        {/if}
        <li style="margin-left: -24px;"><hr size="1"/></li>
        <li style="clear: none;">
                {if $smarty.session.user}
                    <div>
                        <a rel="nofollow" href="/personal_data/">
                            <img width="80" height="80" src="{if $small_avatar}{$small_avatar}{else}/images/empty_photo.png{/if}" alt="" style="border-radius: 40px;margin-right: 13px;" />
                        </a>
                        {if $in_cart}
                            <!-- <br/><br/><a href="/catalog/" class="ShAA__oneClickAdd ShAA__continueShopping"><span>Продолжить выбор</span></a> -->
                        {else}
                            <div class="cartBlockImg" style="margin: 2px 8px 0 0;">
                                <a rel="nofollow" href="/personal_data/" style="font-size: 14px;">
                                    <span class="vk_logout_text" style="margin: 0;">{$smarty.session.user->name}</span>
                                <br />
                                <span class="ShAA_discountText">бонус от {$smarty.session.group->discount|string_format:"%.0f"}%</span><br />

                                <span class="ShAA_discountText">{if $n_deposit}Депозит {$n_deposit} рублей{/if}</span>
                                </a>
                            </div>
                            <!-- <div>
                                <a href="/personal_data/?serv=on" style="float: left; margin: 12px 0; font-size: 14px;">Услуги</a>
                            </div> -->
                        {/if}
                    </div>
                {else}
                    {if $in_cart}
                        <a href="/catalog/" title="Перейти в каталог" class="ShAA__oneClickAdd ShAA__continueShopping"><span>Продолжить выбор</span></a>
                    {else}
                    {/if}
        </li>
        <li>
                    <a rel="nofollow" href="/auth/" class="ShAA__oneClickAdd ShAA__mobEnter" onclick="{literal}rG('USER_WANNA_LOGIN');{/literal}"
                        title="{if $language == 'eng'}Sign in, using your account in popular social networks and get a discount{else}Войдите на сайт, используя свой аккаунт в популярных соцсетях, и получите скидку{/if}" style="background: none; letter-spacing: 1px; text-align: center; text-transform: uppercase;">
                        {if $language == 'eng'}login{else}войти{/if}
                    </a>
                {/if}
        </li>
        <li>
            <form id="form" name="search" method="get" action="/catalog/" style="cursor:pointer; margin: 6px 0 0 0px;">
                <input id="textsearch" type="text" name="search" placeholder="{if $language == 'eng'}Search{else}Поиск по сайту{/if}" style="padding: 6px; border: 1px solid rgba(0,0,0,0.3); border-radius: 10px; width: 80%" value="{if $form_search}{$form_search}{/if}" />
                <input type="submit" class="Search_submit" value=" " onclick="jQuery('#form').submit();{literal}rG('SEARCH');{/literal}" />
            </form>
        </li>
    </ul>
    <div class="clear"></div>
    <div style="" id='headBlock_container'>
    <div id="headBlock" class="headBlock ShAA_defaultMenu">
        <div class="ShAA_cartForMobile">
            <div class="links">
                <div style="float: left;">
                    <div {if !$in_cart}style="margin: 26px 0 20px 0;"{/if}>
                        {if !$in_cart}
                            <div class="cartBlockImg" style="float: left; margin: 0px 8px 0 0; position: relative;">
                                <a href="/cart/">
                                    <i class="icon-shopping-bag ShAA_shopingBag"></i>
                                    {if $cart_products_num}<span class="ShAA_cartQnt">{$cart_products_num}</span>{/if}
                                </a>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
        <div class="rightTopLinks">
		<!--телефон и город-->
			<div class="ShAA_upBlock">
				<div class="phoneInfo">
					<a href="tel:+74953748934" style="border: none !important;">
						<i class="icon-phone"></i>
						<b style="font-weight: normal; word-spacing: 0.1em;" title="">+7&nbsp;(495)&nbsp;374&ndash;89&ndash;34</b>
					</a>
				</div>
				<div class="ShAA_clear"></div>
				<div class="ShAA_regionName">
					{if $language != 'eng'}<a rel="nofollow" href=" /citiesselect/" id="city_link">{if $x_city}{$x_city}{elseif $smarty.session.user->city}{$smarty.session.user->city}{elseif $x_region}{$x_region}{else}Выберите город{/if}</a>{/if}
				</div>
			</div>
		<!--END телефон и город-->
            <div class="links">
              <div style="float: left;margin:27px 10px 0 0;">
                <select name="currency_switch" id="currency_switch" style="height: 26px;">
                  {foreach from=$currencies item=currency}
                    <option value="{$currency->code}" {if $currency->main == 1 && !$smarty.cookies.currency}selected{elseif $currency->code == $smarty.cookies.currency}selected{/if}>{$currency->code}</option>
                  {/foreach}
                </select>
              </div>
              <div id='flag_img' style="float: left; margin:27px 20px 0 0;">
                {if $language == 'eng'}<a href="{if $query}{$smarty.server.PATH_INFO}?{$query}&lang=ru{else}{$smarty.server.PATH_INFO}?lang=ru{/if}" title="Русская версия"><img width="26" src="/images/eng_icon.png" style="" alt="RU" /></a>
                {else}<a href="{if $query}{$smarty.server.PATH_INFO}?{$query}&lang=eng{else}{$smarty.server.PATH_INFO}?lang=eng{/if}" title="English version"><img width="26" src="/images/{if $geolocation=='KZ'}Flag_of_Kazakhstan.png{else}rus_icon.png?v=2{/if}" style="" alt="RU" /></a>{/if}
              </div>
                <div style="float: left;margin: 27px 0 19px 0;">
                    {if $smarty.session.user}
                        <div style="">
                            {if $in_cart}
                            {else}
                                <div class="cartBlockImg" style="float: right; margin: 0px 0 0 8px; position: relative;">
                                    <a href="/cart/">
                                        <i class="icon-shopping-bag ShAA_shopingBag"  style="margin: -1px 0 0 12px !important;"></i>
                                        {if $cart_products_num}<span class="ShAA_cartQnt">{$cart_products_num}</span>{/if}
                                    </a>
                                </div>
                            {/if}
                              <a rel="nofollow" href="/personal_data/">
                                  <img width="40" src="{if $small_avatar}{$small_avatar}{else}/images/empty_photo.png{/if}" style="max-width: 26px; max-height: 26px; border-radius: 20px;" alt="фото" />
                              </a>
                        </div>
                    {else}
                        {if $in_cart}
                            <!--<a href="/catalog/" title="Перейти в каталог" style="width: auto; float: right; margin: 24px 0 0 12px; clear: none;" class="ShAA_oneClickAdd"><div>Продолжить выбор</div></a>-->
                        {else}
                            <div class="cartBlockImg" style="float: right; margin: 0px 0 0 8px; position: relative;">
                                <a rel="nofollow" href="/cart/">
                                    <i class="icon-shopping-bag ShAA_shopingBag" style="margin: -1px 0 0 12px !important;"></i>
                                    {if $cart_products_num}<span class="ShAA_cartQnt" style="right: -10px;top: -10px;">{$cart_products_num}</span>{/if}
                                </a>
                            </div>
                        {/if}
                        <a rel="nofollow" href="/auth/" class="ShAA_mobEnter" onclick="{literal}rG('USER_WANNA_LOGIN');{/literal}"
                            title="{if $language == 'eng'}Sign in, using your account in popular social networks and get a discount{else}Войдите на сайт, используя свой аккаунт в популярных соцсетях, и получите скидку{/if}" style="border: none !important; float: right; margin: -5px 0 0 0px; clear: none;">
                            <i class="icon-key ShAA_keyEnter"></i>
                        </a>
                    {/if}
                </div>
            </div>
        </div>
	<!--переключатель пола desktop-->
		{if !$showbrand->gender && !preg_match('/\blook\b/', $smarty.server.REQUEST_URI) && !$no_show}
			<div id='gender_switch' class="ShAA_upBlock" style="text-transform: uppercase;">
				<span {if $manOrWoman == '1'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=1';{elseif $page->section_id == 160}window.location.href='?sex=1';{/if}">{if $language == 'eng'}men{else}МУЖСКОЕ{/if}</span>
				<span {if $manOrWoman == '2'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=2';{elseif $page->section_id == 160}window.location.href='?sex=2';{/if}">{if $language == 'eng'}women{else}ЖЕНСКОЕ{/if}</span>
				<span {if $manOrWoman != '1' && $manOrWoman != '2'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=0&amp;allsex=1';{elseif $page->section_id == 160}window.location.href='?allsex=1&amp;sex=0';{/if}">{if $language == 'eng'}all{else}ВСЕ{/if}</span>
			</div>
			<div style="display: none;">
				<input {if $manOrWoman != '2'}checked="checked"{/if} data-on="{if $language == 'eng'}for Him{else}для Него{/if}" data-off="{if $language == 'eng'}for Her{else}для Неё{/if}" data-toggle="toggle" data-style="ios" type="checkbox" onchange="{literal}rG('CHANGE_SEX');{/literal}{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex={if $manOrWoman != '2'}2{else}1{/if}';{elseif $page->section_id == 160}window.location.href='?sex={if $manOrWoman != '2'}2{else}1{/if}';{/if}" />
			</div>
		{/if}
	<!--END переключатель пола desktop-->
        <div class="logoOnline" style="text-align:left;">

            <a href="/"><img style='display: none' src="/images/logo_svetlov.png" class="main_logo" alt="Лакшери Стор" /></a>
            <a href="/"><img style='display: none' src="/images/logo_svetlov.png" class="main_logo_mobile" alt="Лакшери Стор"   /></a>
        </div>

{literal}
<script type="text/javascript">
	var $menu = jQuery("#headBlock"); //в переменную определим наше меню
    var $height_head = jQuery("#headBlock").height();

    jQuery(function(){ //функция обертка
        $('#change_view_mobile').click(function(){
            var arr_owl = $(".owl-carousel");

            for(var i=0; i<arr_owl.length;i++){
                if($(this).text()=='ВИД'||$(this).text()=='ОБРАЗ'){
                    if($(this).text()=='ВИД'){
                        $(arr_owl[i]).data('owlCarousel').jumpTo(0);
                        if(i==arr_owl.length-1){
                            $(this).text('ОБРАЗ');
                        }
                    }else{
                        $(arr_owl[i]).data('owlCarousel').jumpTo(1);
                        if(i==arr_owl.length-1){
                            $(this).text('ВИД');
                        }
                    }
                }else if($(this).text()=='VIEW'||$(this).text()=='FASHION'){
                    if($(this).text()=='VIEW'){
                        $(arr_owl[i]).data('owlCarousel').jumpTo(0);
                        if(i==arr_owl.length-1){
                            $(this).text('FASHION');
                        }
                    }else{
                        $(arr_owl[i]).data('owlCarousel').jumpTo(1);
                        if(i==arr_owl.length-1){
                            $(this).text('VIEW');
                        }
                    }
                }

            }
        });
		jQuery(window).scroll(function(){ //событие скролл
			$scroll_height = jQuery("#headBlock").height();

			if ( (jQuery('#active_menu').html() == "скрыть") || (jQuery('#active_menu_mob').html() == "скрыть") ) {
				$scroll_height = jQuery('#catalog_left').height() - jQuery("#headBlock").height() ;
			}
            if(window.innerWidth>770){
                if (jQuery(this).scrollTop() > $scroll_height + (jQuery(".adminTabs_container").height()?jQuery(".adminTabs_container").height()+20: 0 ) + 18 && $menu.hasClass("ShAA_defaultMenu") ){ //(1)
                if( jQuery.cookie('language') === 'eng'){
                    var filter = 'Filters',
                    hide = 'hide';
                }else{
                    var filter = 'Фильтры',
                    hide = 'скрыть';
                }
                    if ( jQuery('#active_menu').html() == hide ) {
                        jQuery('#active_menu').html(filter);
                    }

                    if ( jQuery('#active_menu_mob').html() == hide ) {
                        jQuery('#active_menu_mob').html(filter);
                    }
                    $menu.removeClass("ShAA_defaultMenu");
                    $menu.addClass("ShAA_fixedMenu");
                    $('#nav-wrap').css('top', '-60px');
                    $('#nav-wrap').css('width', '100%');
                    $('#nav-wrap').css('padding-left', '0px');
                    $('.ShAA_filterBig').attr({style: 'position: relative; top: -65px'});
                    if(window.innerWidth > 1473){
                        $('#gender_switch').attr({style:'position: fixed !important;  top: -4px; display: block; margin-top: -70px; margin-left: 0px; z-index: 99'});
                        $('#gender_switch').addClass('gender_switch_fixed');
                        setTimeout(() => {
                            $('#gender_switch').css('margin-top', '26px');
                            $('#gender_switch').css('margin-left', '0px');
                            $('#gender_switch').css('transition', 'all 0.4s');
                        }, 10);
                    }
                    if(jQuery(window).width() > 481) {
                        if (jQuery("div").is(".ShAA_filterBig")) {
                            jQuery('.mainContent').css('marginTop', '55px');
                        }
                        else {
                            if(jQuery("#headBlock")[0]) {jQuery('.mainContent').css('marginTop', '20px');}
                        }
                    }
                    else {
                        jQuery('.mainContent').css('marginTop', '124px');
                    }
                } else if(jQuery(this).scrollTop() < $scroll_height + (jQuery(".adminTabs_container").height()?jQuery(".adminTabs_container").height()+20: 0 ) + 50 && $menu.hasClass("ShAA_fixedMenu")){ //(2)
                $menu.removeClass("ShAA_fixedMenu");
                $menu.addClass("ShAA_defaultMenu");
                $('#nav-wrap').css('position', 'relative');
                $('#nav-wrap').css('width', '100%');
                $('#nav-wrap').css('padding-left', '0');
                $('#nav-wrap').css('top', '0px');
                $('.ShAA_filterBig').attr({style: 'position: relative; top: 0px'})
                if(window.innerWidth > 1473 || $('#gender_switch').hasClass('gender_switch_fixed')){
                    $('#gender_switch').attr({style:'position: relative;  top: 20px; margin-top: 70px; margin-left: 0px'});
                    $('#gender_switch').removeClass('gender_switch_fixed')
                    setTimeout(() => {
                        $('#gender_switch').css('margin-top', '0px');
                        $('#gender_switch').css('margin-left', '0px');
                        $('#gender_switch').css('transition', 'all 0.5s');
                    }, 10);
                }
                jQuery('.mainContent').css('marginTop', '24px');
                }
            }else{
                if (jQuery(this).scrollTop() > $scroll_height + (jQuery(".adminTabs_container").height()?jQuery(".adminTabs_container").height()+25: 0 ) - 35 + (jQuery(".smartbanner-container").height()?jQuery(".smartbanner-container").height()+22: 0 ) && $menu.hasClass("ShAA_defaultMenu") ){
                    $('#headBlock_container').addClass('mobile_header_fixed');
                } else {
                    $('#headBlock_container').removeClass('mobile_header_fixed');
                }
            }
		});
	});
</script>
{/literal}

        <nav id="nav-wrap">


            <ul class="menuList desktop">
                <li>
                    <a href="#">Новая коллекция</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-cepochki/">Цепи</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-kolca/">Кольца</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-sergi/">Серьги</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-braslety/">Браслеты</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-podveski/">Подвески</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-kole/">Колье</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-broshi/">Броши</a>
                </li>
                <li>
                    <a href="/brandwall/">{if $language == 'eng'}Designers{else}Бренды{/if}</a>
                </li>
                <li>
                    <a href="#/looks/">{if $language == 'eng'}Looks{else}Образы{/if}</a>
                </li>
                <li>
                    <a href="/categories/yuvelirnye-izdeliya/">Каталог</a>
                </li>

                <li><a rel="nofollow" href="/sale" style="color: #C30000;">Sale</a></li>

				<!--Поиск desktop-->
				<li class="search">
					<form id="form" name="search" method="get" action="/catalog/" style="cursor:pointer;float: left;margin-top: -2px;">
						<input type="submit" class="Search_submit" value=" " onclick="if(jQuery('#textsearch').val())jQuery('#form').submit();{literal}rG('SEARCH');{/literal}" />
						<input id="textsearch" type="text" name="search" placeholder="{if $language == 'eng'}Search{else}Поиск по сайту{/if}" value="{if $form_search}{$form_search}{/if}" />
					</form>
				</li>
				<!--END Поиск desktop-->
				</li>
            </ul>
        </nav>

        {foreach from=$categories item=cat}
            {if ($cat->category_id == $category || $cat->category_id == $view_category) & (!preg_match('/products/', $smarty.server.REQUEST_URI)) & (!preg_match('/product/', $smarty.server.REQUEST_URI)) & (!preg_match('/goods/', $smarty.server.REQUEST_URI))}
                <div style = 'display: none' id="change_view_mobile">{if $language == 'eng'}FASHION{else}ОБРАЗ{/if}</div>
                <div style = 'display: none' class="ShAA_onlyMobileVer ShAA_mobileFilters">
                    <!-- <span href="#top" class="ShAA_toUp"><span id="active_menu_mob" class="ShAA_activeOnlyMobileVer"><i class="icon-filter icon-2x"></i></span></a> -->
                    <a href="#top" class="ShAA_toUp"><span id="active_menu_mob" class="ShAA_activeOnlyMobileVer"><div class=" ">{if $language == 'eng'}Filters{else}Фильтры{/if}</div></span></a>
                </div>
            {/if}
        {/foreach}
        {if ($new_season || (preg_match('/specials/', $smarty.server.REQUEST_URI)) || $furs || $looks || $whatsnew || ($brand && !preg_match('/brandwall/', $smarty.server.REQUEST_URI) && !preg_match('/personal_data/', $smarty.server.REQUEST_URI)) || $big_size || $sale) & (!preg_match('/product/', $smarty.server.REQUEST_URI))}
            <div style = 'display: none' id="change_view_mobile">{if $language == 'eng'}FASHION{else}ОБРАЗ{/if}</div>
            <div style = 'display: none' class="ShAA_onlyMobileVer ShAA_mobileFilters">
                <a href="#top" class="ShAA_toUp"><span id="active_menu_mob" class="ShAA_activeOnlyMobileVer"><div class=" ">{if $language == 'eng'}Filters{else}Фильтры{/if}</div></span></a>
            </div>
        {elseif (!preg_match('/catalog/', $smarty.server.REQUEST_URI))  & (!preg_match('/product/', $smarty.server.REQUEST_URI)) }
            <div class="ShAA_upBlock ShAA_sexMobileBlock" style="text-transform: uppercase;">
                <span {if $manOrWoman == '1'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=1';{elseif $page->section_id == 160}window.location.href='?sex=1';{/if}">{if $language == 'eng'}men{else}МУЖСКОЕ{/if}</span>
                <span {if $manOrWoman == '2'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=2';{elseif $page->section_id == 160}window.location.href='?sex=2';{/if}">{if $language == 'eng'}women{else}ЖЕНСКОЕ{/if}</span>
                <span {if $manOrWoman != '1' && $manOrWoman != '2'}class="ShAA_activeSex"{/if} onchange="{literal}rG('CHANGE_SEX');{/literal}" onClick="{if isset($filter_url)}window.location.href='{$filter_url}&amp;sex=0&amp;allsex=1';{elseif $page->section_id == 160}window.location.href='?allsex=1&amp;sex=0';{/if}">{if $language == 'eng'}all{else}ВСЕ{/if}</span>
            </div>
        {/if}

        {if ($new_season || (preg_match('/specials/', $smarty.server.REQUEST_URI)) || $furs || $looks || $whatsnew || ($brand && !preg_match('/brandwall/', $smarty.server.REQUEST_URI) && !preg_match('/personal_data/', $smarty.server.REQUEST_URI)) || $big_size || $sale) & (!preg_match('/product/', $smarty.server.REQUEST_URI))}
            <div class="ShAA_filterBig">
                <a id="active_menu" class="ShAA_toUp" href="#top">{if $language == 'eng'}Filters{else}Фильтры{/if}</a>
            </div>
        {/if}
        {foreach from=$categories item=cat}
            {if ($cat->category_id == $category || $cat->category_id == $view_category) & (!preg_match('/products/', $smarty.server.REQUEST_URI)) & (!preg_match('/product/', $smarty.server.REQUEST_URI)) & (!preg_match('/goods/', $smarty.server.REQUEST_URI))}
                <div class="ShAA_filterBig">
                    <a id="active_menu" class="ShAA_toUp" href="#top">{if $language == 'eng'}Filters{else}Фильтры{/if}</a>
                </div>
            {/if}
        {/foreach}
        <div class="clear"></div>
    </div>
    </div>
    <div class="background_header_mobile"></div>
    <div class="clear"></div>
    {if $page->section_id == 160 && isset($banner_obj)}
        <div style="width: 100%; margin: 0; height: auto;">
            {if $show_presale == 1}
                <a rel="nofollow" href="/catalog/?category=new_season" target="_blank" style="border:none;display: block;text-align: center;" onclick="{literal}rG('MAIN_BANNER');{/literal}">
                    {if $smarty.session.user->purchase_sum_real > 0}
                        <img src="/images/presale_{if $manOrWoman == '2'}fe{/if}male.jpg" alt="{if $language == 'eng'}Closed pre-sale for VIP customers{else}Закрытая предварительная распродажа для VIP-клиентов{/if}" style="width: 100%;max-width: 927px;" title="{if $language == 'eng'}Closed pre-sale for VIP customers{else}Закрытая предварительная распродажа для VIP-клиентов{/if}" />
                    {else}
                        <img src="/images/presale_5_{if $manOrWoman == '2'}fe{/if}male.png" alt="{if $language == 'eng'}5% discount on first purchase{else}Скидка 5% на первую покупку{/if}" style="width: 100%;max-width: 927px;" title="Скидка 5% на первую покупку" />
                    {/if}
                </a>
            {/if}
            {if $show_super_furs}
                <a rel="nofollow" href="/catalog/?category=furs&sex=2" target="_blank" style="border:none;" class="ShAA_miniHoverZoom" data-id="furs_promo" onclick="{literal}rG('MAIN_BANNER');{/literal}">
                    <img src="/images/fur_banner_2018_new.jpg" alt="{if $language == 'eng'}Super prices on Italian furs{else}Суперцена на итальянские меха{/if}" title="{if $language == 'eng'}Super prices on Italian furs{else}Суперцена на итальянские меха{/if}" />
                    <div class="ShAA_totalBanner">
            <!-- код этого скрипта копируем к нам, т.к. он не работает через https
                        <script type="text/javascript" src="http://megatimer.ru/s/4a44517a611c43414060eeded2da072f.js"></script>
            -->
                        <script type="text/javascript" src="/jscript/timeto/timer_for_mainbanner.js?6"></script>
                    </div>
                </a>
            {/if}

        {if 'swd'|array_key_exists:$promos}
            <a rel="nofollow" href="/sale/" title="{if $language == 'eng'}Weekend discount on DSQUARED clothing and shoes{else}Скидка Выходного Дня на одежду и обувь DSQUARED{/if}" target="_blank" style="border:none;" class="ShAA_miniHoverZoom" data-id="swd_promo" onclick="{literal}rG('BANNER_SWD');{/literal}">
                <img alt="{if $language == 'eng'}Weekend discount on DSQUARED clothing and shoes{else}Скидка Выходного Дня на одежду и обувь DSQUARED{/if}" src="/files/images/swd/{$promos.swd->main_banner}" />
            </a>
        {else}
            {foreach from=$banners item=banner}
                <a rel="nofollow" href="{$banner->url}" title="{$banner->title}" target="_blank" style="border:none;" class="ShAA_miniHoverZoom" data-id="ba{$banner->id}" onclick="{literal}rG('MAIN_BANNER');{/literal}">
                    <img src="/files/banners/{if $language == 'eng' && $banner->eng_image}{$banner->eng_image}{else}{$banner->image}{/if}" alt="{if $language == 'eng' && $banner->eng_title}{$banner->eng_title}{else}{$banner->title}{/if}" title="{if $language == 'eng' && $banner->eng_title}{$banner->eng_title}{else}{$banner->title}{/if}" />
                </a>
            {/foreach}
        {/if}
        </div>
    {/if}
    <div class="mainContent" id="main_top">
        {$content}

{if !$special_fields}
<!-- Breadcumbs для всех кроме страниц подборок. Для них отдельно -->
		<!-- <div  itemscope="" itemtype="http://schema.org/BreadcrumbList" id="breadcrumbs" class="breadCrumbs">
			<span itemscope="" itemprop="itemListElement" itemtype="http://schema.org/ListItem">
				<a rel="nofollow" itemprop="item" title="Главная страница" href="/">
					<span itemprop="name">Главная страница</span>
					<meta itemprop="position" content="1">
				</a>
			</span>
			{if $manOrWoman}
			<span itemscope="" itemprop="itemListElement" itemtype="http://schema.org/ListItem">
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="{if $manOrWoman != '2'}Для него {else}Для неё{/if}" href="/?sex={$manOrWoman}">
					<span itemprop="name">{if $manOrWoman != '2'}Для него {else}Для неё{/if}</span>
					<meta itemprop="position" content="2">
				</a>
			</span>
			{/if}
			{if $new_season || $sale}
				<span itemscope="" itemprop="itemListElement" itemtype="http://schema.org/ListItem">
					<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
					<a itemprop="item" title="{if $new_season}Новый сeзон{else}sale{/if}" href={if $new_season}"/catalog/?category=new_season"{else}"/catalog/?category=sale"{/if}>
						<span itemprop="name">{if $new_season}Новый сeзон{else}SALE{/if}</span>
						<meta itemprop="position" content="3">
					</a>
				</span>
			{elseif $brand_item}
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="Бренды" href="/brandwall/">
					<span itemprop="name">Бренды</span>
					<meta itemprop="position" content="3">
				</a>
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="{$brand_item->name}" href="/brands/{$brand_item->name}">
					<span itemprop="name">{$brand_item->name}</span>
					<meta itemprop="position" content="4">
				</a>
			{elseif $parent_name && !$special_fields}
				<span itemscope="" itemprop="itemListElement" itemtype="http://schema.org/ListItem">
					<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
					<a itemprop="item" title="{$parent_name}" href="/categories/{$parent_name}/">
						<span itemprop="name">{$parent_name}</span>
						<meta itemprop="position" content="3">
					</a>
				</span>
				{if ($categ_name) && ($categ_name != $parent_name)}
					<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
					<a itemprop="item" title="Образы" href="/{$categ_url}/">
						<span itemprop="name">{$categ_name}</span>
						<meta itemprop="position" content="4">
					</a>
				{/if}
			{elseif $brands_full}
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="Бренды" href="/brandwall/">
					<span itemprop="name">Бренды</span>
					<meta itemprop="position" content="3">
				</a>
			{elseif $looks || $set->main_product_id}
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="Образы" href="/looks/">
					<span itemprop="name">Образы</span>
					<meta itemprop="position" content="3">
				</a>
			{/if}
			{if $product->category_parent}
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="{$product->brand}" href="/brands/{$product->brand_url}/">
					<span itemprop="name">{$product->brand}</span>
					<meta itemprop="position" content="3">
				</a>
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				{if $product->category_parent == 1}<a itemprop="item" title="Одежда" href="/categories/одежда/">
				{elseif $product->category_parent == 2}<a itemprop="item" title="Обувь" href="/categories/обувь/">
				{elseif $product->category_parent == 4}<a itemprop="item" title="Аксессуары" href="/categories/аксессуары/">
				{elseif $product->category_parent == 38}<a itemprop="item" title="Сумки" href="/categories/сумки/">
				{/if}
					<span itemprop="name">{if $product->category_parent == 1}Одежда{elseif $product->category_parent == 2}Обувь{elseif $product->category_parent == 4}Аксессуары{elseif $product->category_parent == 38}Сумки{/if}</span>
					<meta itemprop="position" content="4">
				</a>
				<span>&nbsp;&nbsp;<i class="icon-caret-right"></i>&nbsp;&nbsp;</span>
				<a itemprop="item" title="{$product->category_name}" href="/categories/{$product->category_url}/">
					<span itemprop="name">{$product->category_name}</span>
					<meta itemprop="position" content="5">
				</a>
			{/if}
		</div> -->
<!-- END Breadcumbs -->
{/if}
        {if $page->section_id == 160}
            <div class="noLinkUnderline" style="text-align:center;">
                {foreach from=$brands item=brand}
                    {if $brand->image}
                        {if !in_array($brand->url, array(''))}
                            <a href="/brands/{$brand->url}/?main_page" target="_blank"><img width="212" alt="{$brand->name|replace:'&':'&amp;'}" title="{$brand->meta_title|replace:'&':'&amp;'}" src="/reimg/files/brands/212x/{$brand->image}" style="margin: 32px;" /></a>
                        {else}
                            <a href="/{$brand->url}/" target="_blank"><img width="212" alt="{$brand->name|replace:'&':'&amp;'}" title="{$brand->meta_title|replace:'&':'&amp;'}" src="/reimg/files/brands/212x/{$brand->image}" style="margin: 32px;" /></a>
                        {/if}
                    {/if}
                {/foreach}
            </div>
        {/if}
        {if $page->section_id == 160 && isset($specials) }
            <div class="ShAA_enterpoints">
                {foreach from=$specials item=special}
                    <div class="ShAA_epItem">
                            <a rel="nofollow" href="/{if $special->look_special}look_{/if}specials/{$special->url}/" target="_blank" class="ShAA_miniHoverZoomTop">
                                <img src="/files/images/{$special->small_picture}" style="width: 100%; height: 100%;" alt="{if $language=='eng'}{$special->eng_name}{else}{$special->name}{/if}" />
                            </a>
                            <a rel="nofollow" href="/{if $special->look_special}look_{/if}specials/{$special->url}/" target="_blank"><span>{if $language=='eng'}{$special->eng_name}{else}{$special->name}{/if}</span></a>
                    </div>
                {/foreach}
            </div>
        {/if}
        {if $page->section_id == 160}
{literal}
<script>
jQuery(document).ready(function() {
    jQuery(".ShAA_iframeYoutubeLink").width(jQuery(".ShAA_iframeYoutube").width());
    jQuery(".ShAA_iframeYoutubeLink").height(jQuery(".ShAA_iframeYoutube").height());
    $(function() {
        $(window).resize(function() {
            jQuery(".ShAA_iframeYoutubeLink").width(jQuery(".ShAA_iframeYoutube").width());
            jQuery(".ShAA_iframeYoutubeLink").height(jQuery(".ShAA_iframeYoutube").height());
        });
    });
})
</script>
{/literal}
          {if $language != 'eng'}
            <!-- <div class="ShAA_videoBlockForMainPage">
                <h2 style="width:100%; text-align: center; text-transform: uppercase; font-size: 16px;">{if $language=='eng'}New video from Luxury Store{else}новые видео от лакшери стор{/if}</h2>
              {foreach from=$video item=vid}
                <div class="ShAA_videoItem">
                    <a class="ShAA_iframeYoutubeLink" href="https://www.youtube.com/embed/{$vid->youtube_id}?rel=0&autoplay=1" target="_blank" style="position: absolute;"></a>
                    <iframe class="ShAA_iframeYoutube" width="100%" height="auto" src="https://www.youtube.com/embed/{$vid->youtube_id}?rel=0" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>
                </div>
              {/foreach}
            </div> -->
        {/if}
        {/if}
    </div>
    <div class="clear"></div>
    <div class="footer">
        <div class="footerMenu">
            <div class="footerMenuBlock">
                <div class="footerMenuTitle">{if $language=='eng'}Online store{else}Интернет магазин{/if}:</div>
                <div>
                    <ul>
                        {if $language != 'eng'}<li><a rel="nofollow" href="/citiesselect/" id="city_link">{if !$x_city && !$smarty.session.user->city && !$x_region}{if $language=='eng'}Choose your city{else}Выберите город{/if}{/if}</a></li>{/if}
                        <li><a rel="nofollow" href="{if $city->url}/city/{$city->url}{else}/sections/shipping{if $language=='eng'}_eng{/if}{/if}" target="_blank">{if $language=='eng'}Shipping and payment{else}Доставка {if $x_city}{$x_city}{elseif $smarty.session.user->city}{$smarty.session.user->city}{elseif $x_region}{$x_region}{else} и оплата{/if}{/if}</a></li>
                        <li><a rel="nofollow" href="/sections/sitemap/" target="_blank">{if $language=='eng'}Sitemap{else}Карта сайта{/if}</a></li>
                        {if $language != 'eng'}<li><a rel="nofollow" href="/faq/">{if $language=='eng'}Help{else}Вопрос-ответ{/if}</a></li>{/if}
                        {if $language != 'eng'}<li><a rel="nofollow" href="http://market.yandex.ru/shop/105646/reviews?clid=703" target="_blank" >{if $language=='eng'}Client feedback{else}Отзывы клиентов{/if}</a></li>{/if}
{if $is_mobile}
                        <li><a rel="nofollow" href="/catalog/?mobile=1">{if $language=='eng'}Mobile version{else}Мобильная версия сайта{/if}</a></li>
{/if}
                        <li><a rel="nofollow" href="/sections/personal_data{if $language=='eng'}_eng{/if}/">{if $language=='eng'}Privacy & Cookies{else}Согласие на обработку персональных данных{/if}</a></li>
                    </ul>
                </div>
            </div>
            <div class="footerMenuBlock">
                <div>
                    <ul>
                        {if $language != 'eng'}<li><a href="/feed/" target="_blank" rel="nofollow">Новости</a></li>{/if}
                        <li><a rel="nofollow" href="/sections/{if $language=='eng'}Boutiques{else}contacts{/if}/" target="_blank">{if $language=='eng'}Contact us{else}Контакты{/if}</a></li>
                    </ul>
                </div>
            </div>

            <div class="footerMenuBlock ShAA_socFooterBlock">
                <div class="footerMenuTitle">{if $language=='eng'}Follow us{else}Социальные сети{/if}:</div>
                <div class="noLinkUnderline">
                    <i class="icon-vk icon-2x"></i>
                    </br>
                    <i class="icon-telegram icon-2x"></i>
                </div>
            </div>

            <div class="footerMenuBlock">
                <div class="footerMenuTitle">{if $language=='eng'}Accept payments{else}Прием платежей{/if}:</div>
                <div class="copy noLinkUnderline"><ul><li>
                    <a href="/sections/shipping{if $language=='eng'}_eng{/if}/" class="cardlogos noline">
                        <i class="icon-cc-visa icon-3x" style="margin-right: 12px;"></i>
                        <i class="icon-cc-mastercard icon-3x"></i>
                    </a></li>
                    </ul></div>
                <div class="ShAA_footerPhone">
                    <a href="tel:88003332138">8 (800) 333-21-38</a>
                </div>
                <div class="ShAA_footerPhone">
                    <a target="_blank" href="https://api.whatsapp.com/send?phone=79200271027">
                        <i class="icon-whatsapp icon-2x" style="margin-right: 12px; float: left; height: 60px;"></i>
                        <div style="font-size: 14px; line-height: 14px;">
                        {if $language=='eng'}
                            Online-consultant whatsApp (viber, telegram) everyday 10:00-20:00
                        {else}
                            Менеджер магазина whatsApp (viber, telegram) <br /> ежедневно с 10:00 до 20:00
                        {/if}
                        </div>
                        <!-- <div class="ShAA_whatsAppPhone">
                            <a href="tel:+79200271027">+7 920 027-10-27</a>
                        </div> -->
                    </a>
                </div>
                <div class="copy noLinkUnderline">
                    <ul>
                        <li>
                            <a href="/sections/shipping{if $language=='eng'}_eng{/if}/" class="cardlogos noline">
                                <img src="/design/adaptive/images/cdek.png" style="width: 30%;" />
                                <img src="/design/adaptive/images/dhl-express.png" style="width: 30%;" />
                                <img src="/design/adaptive/images/pony-express.png" style="width: 30%;" />
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="clear"></div>
            <div style="margin: 48px 0 0 0;" title="При использовании изображений прямая ссылка на сайт обязательна">
                &copy; kosatka.org {if $x_region}{$x_region}{/if} 2011-{$smarty.now|date_format:"%Y"}
            </div>
        </div>
        <div class="ok">
            {if $cache_link}
            <a href="{$cache_link->cache}" title="{$cache_link->tcache}">{$cache_link->tcache}</a>
            {/if}
            <a href="http://www.ooook.ru" target="_blank" rel="nofollow">Сделано в</a> <img src="/images/ok_logo.png" alt="ОК" />
        </div>
    </div>
    <div id="vk_api_transport"></div>
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

{if !($smarty.session.user->group_id > 1) && !$offlineSales }
{literal}
<script type="text/javascript" src='https://cdn.slaask.com/chat.js'></script>
<script type="text/javascript">
  if(typeof _slaask != "undefined") {
    _slaask.init('743b120c1ef79fea97380ef35dbeb9fe');
  }
</script>
{/literal}
{/if}

<link media="all" href="/design/adaptive/css/bootstrap.css?v=1.1" rel="stylesheet" type="text/css" />
<link href="/design/adaptive/css/bootstrap-toggle.css?v=1.2" rel="stylesheet" />

{literal}
<style media="all" type="text/css" >
    .toggle.ios, .toggle-on.ios, .toggle-off.ios, .btn { -moz-border-radius: 4px; -webkit-border-radius: 4px; -khtml-border-radius: 4px; border-radius: 4px; }
    .toggle.ios .toggle-handle { -moz-border-radius: 4px; -webkit-border-radius: 4px; -khtml-border-radius: 4px; border-radius: 4px; }

    {/literal}{if $user_message}{literal}
        #fancybox-bg-w, #fancybox-bg-e, #fancybox-bg-n, #fancybox-bg-s, #fancybox-bg-sw, #fancybox-bg-se, #fancybox-bg-nw, #fancybox-bg-ne {
            background: none;
        }
        #fancybox-outer {
            background: none;
        }
    {/literal}{/if}{literal}
    .ShAA_defaultMenu .ShAA_sexMobileBlock{

    }
    .ShAA_sexMobileBlock{
        background: none !important;
        margin-top: 20px;
    }
    .ShAA_sexMobileBlock .ShAA_activeSex{
        background: none !important;
        color: #000;
        font-weight: 700;
    }
    .ShAA_fixedMenu .ShAA_cartForMobile{
        margin: 3px -12px 0 0 !important;
    }
    @media (min-width: 771px) {
        .main_logo_mobile{
            display: none
        }
        #headBlock_container{
            height: 165px
        }
        .main_logo{
            display:block !important;
        }
    }
    @media (max-width: 770px) {
        .main_logo{
            display: none
        }
        .main_logo_mobile{
            margin: 18px 0 0 15px;
            display: block !important;
        }
        #headBlock_container{
            height: 110px;
            width: 100%;
            z-index: 9999;
            position: absolute;
        }
        .ShAA_sexMobileBlock{
            margin-top: 5px;
            left: 0;
            width: 100%;
            position: relative;
            left: 10px;
        }
        .ShAA_sexMobileBlock span{
            display: inline-block;
            width: 32%;
            padding: 0
        }
        .mobile_header_fixed{
            background: #fff;
            position: fixed !important;
            top: 0;
            right: 0;
            margin-top: -30px;
            width: 100%;
            z-index: 9999;
        }
        .background_header_mobile{
            height: 110px
        }
        .ShAA_onlyMobileVer{
            float: none;
            position: absolute;
            right: 20px;
            font-size: 14px;
            text-transform: uppercase;
            margin-top: 3px;
            display: block !important;
        }
        #change_view_mobile{
            position: absolute;
            left: 20px;
            font-size: 14px;
            text-transform: uppercase;
            margin-top: 3px;
            display: block !important;
        }

    }
    @media (min-width: 771px) {
        #change_view_mobile{
            display: none;
        }
    }
</style>

<script type="text/javascript">
    $(function () {

        $('#addToCart').click(function(e){
            e.preventDefault();
            href = $(this).attr('href');
            href += ('&amp;size='+$('#userCurrentSize').eq(0).text()); document.cookie='from='+location.href+';path=/';
            rG('ADD_TO_CART');
            window.location = href;
        });

        $('#RemovePurchase').click(function(){
            item_id         = $(this).attr('data-item_id');
            price           = $(this).attr('data-price');
            is_available    = $(this).attr('data-is_available');
            category        = $(this).attr('data-category');

            window.location='/cart/delete/'+item_id;
        });
    });
</script>
{/literal}
{if !$is_admin && !$offlineSales }
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
    <script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js"></script>
    <noscript>
        <div style="display:inline;">
            <img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/1040221604/?value=0&amp;label=sRsHCLjg0wUQpIuC8AM&amp;guid=ON&amp;script=0"/>
        </div>
    </noscript>
{/literal}
{/if}
<!--{$datetime}-->
<!-- message for KZ -->
<div class="message_fof_KZ__bg">
    <div id="message_fof_KZ">
        <img class="message_fof_KZ__close" src="images/closeform.png" alt="close">
        <img class="message_fof_KZ__sun" src="/images/Flag_of_Kazakhstan_mini.png" alt="img"><br/>
        <img class="message_fof_KZ__logo" src="/images/eng_new_logo_x2.png?v=2" alt="img">
        <div class="message_fof_KZ__text">
            казакстанға жедел жеткізу. түбіртек бойынша курьерге акы твлеу. барлык бағалар тенгеде.
        </div>
        <button class="message_fof_KZ__button">толығырак</button>
    </div>
</div>
<!-- message for KZ end-->
<div id="tooltip"></div>
<script>
</script>
{if $smarty.session.user->group_id < 2 && !$offlineSales }
    <link rel="stylesheet" href="/jscript/smart-app-banner/dist/smart-app-banner.css" type="text/css" media="all">
    <script src="/jscript/smart-app-banner/dist/smart-app-banner.js"></script>
    {literal}
    <script>
        new SmartBanner({
              daysHidden: 15,   // days to hide banner after close button is clicked (defaults to 15)
              daysReminder: 90, // days to hide banner after "VIEW" button is clicked (defaults to 90)
              appStoreLanguage: '', // language code for the App Store (defaults to user's browser language)
              title: 'Лакшери Стор',
              author: 'lsboutique.ru',
              button: 'Смотреть',
              store: {
                  ios: 'ЗАГРУЗИТЬ в App Store',
                  android: 'ЗАГРУЗИТЬ в Google Play',
              },
              price: {
                  ios: '',
                  android: '',
              }
             // , theme: 'ios' // put platform type ('ios', 'android', etc.) here to force single theme on all device
              , icon: 'http://is1.mzstatic.com/image/thumb/Purple128/v4/56/ab/60/56ab6087-760e-968c-671d-a0fa1771d2cb/source/175x175bb.jpg' // full path to icon image if not using website icon image
             // , force: 'ios' // Uncomment for platform emulation
          });
    </script>
    {/literal}
{/if}
<script type="text/javascript" src="/js/prefix_for_Input.js?5"></script>
<script type="text/javascript" src="/js/events/vk_events.js?12"></script>
</body>
</html>
