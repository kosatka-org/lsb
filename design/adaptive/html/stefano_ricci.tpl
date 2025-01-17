<script src='/jscript/unitegallery/js/unitegallery.min.js' type='text/javascript'  ></script>
<link  href='/jscript/unitegallery/css/unite-gallery.css' rel='stylesheet' type='text/css' />
<script src='/jscript/unitegallery/js/ug-theme-tiles.js' type='text/javascript'></script>
{literal}
<style>
    .mainContent {
        margin: 24px auto;
        width: 100%;
    }
    
    .lightwidget--captions .lightwidget__caption {
        font-size: 2em !important;
        text-align: center;
    }
    .footer {
        margin-top: -24px;
    }
    
    .ShAA_overlay {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        background: #333;
        opacity: 0.3;
    }
    
    .ShAA_srTextOnBanner {
         text-align: center;
         color: #fff;
         position: absolute;
         top: 36%;
         font-size: 22px;
         line-height: 1.55em;
         width: 100%;
    }

    .ShAA_instaSeasonTitle {
        width: 100%;
        text-align: center;
        font-size: 32px;
        margin-bottom: 24px;
        line-height: 32px;
    }

    .ShAA_instaBlock {
        margin: 60px 0;
        float: left;
        width: 100%;
    }

    .ShAA_textBlockGray {
        width: 100%;
        float: left;
        background: #f0f0f0;
        padding: 135px 0 150px;
    }

    .ShAA_textBlockInner {
        max-width: 760px;
        margin: auto;
        text-align: center;
    }

    .ShAA_srTitle {
        font-size: 60px;
    }

    .ShAA_srTextDiv {
        margin: 40px 0 0 0;
        font-size: 20px;
        line-height: 32px;
    }

    .ShAA_srLineUnderTitle {
        background-color: #e3aa0d;
        max-width: 100px;
        height: 2px;
        margin-left: auto;
        margin-right: auto;
    }

    .ShAA_srSubscribe {
        text-align: center;
        margin: 60px auto 30px;
        width: 100%;
    }

    .ShAA_srSubscribeTitle {
        font-size: 38px;
        line-height: 42px;
    }

    .ShAA_srSubscribeText {
        font-size: 22px;
        line-height: 32px;
        margin: 30px auto;
        max-width: 760px;
    }

    .ShAA_srSocBlock {
        text-align: center;
        width: 100%;
    }

    .ShAA_srSocBlock a {
        margin: 0 6px;
        font-size: 1.4em;
    }

    .ShAA_srUnderSocText {
        font-size: 24px;
        margin: 50px auto;
        line-height: 32px;
        text-align: center;
    }

    .ShAA_srUnderSocTextMini {
        text-align: center;
        font-size: 16px;
        line-height: 24px;
        font-weight: 300;
    }
    
    .paddingNew {
        padding: 60px 0;
    }
    
    .ShAA_stRButton {
        background: #000;
        border-color: #000;
        color: #fff;
        font-weight: normal;
        margin-bottom: 32px;
        width: 38%;
        padding-top: 10px;
        padding-bottom: 10px;
    }
    
@media (max-width: 767px) {
    .ShAA_srTextOnBanner {
         top: 32%;
         font-size: 16px;
         line-height: 1em;
         width: 86%;
         left: 7%;
    }
    
    .ShAA_srUnderSocTextMini {
        font-size: 14px;
        line-height: 20px;        
    }
    
    .ShAA_instaBlock {
        margin: 30px 0;
    }
    .ShAA_instaSeasonTitle {
        width: 90%;
        margin: 0 auto;
        font-size: 21px;
    }
    
    .ShAA_textBlockGray {
        padding: 65px 0 70px;
    }
    .ShAA_textBlockInner {
        width: 90%;
    }
    .ShAA_srTitle {
        font-size: 48px;
    }
    .ShAA_srTextDiv {
        margin: 24px auto;
        font-size: 18px;
        line-height: 28px;
    }
    .ShAA_srSubscribe {
        margin: 40px 0 20px;
    }
    .ShAA_srSubscribeTitle {
        font-size: 30px;
        line-height: 34px;
        width: 90%;
        margin: auto;
    }
    .ShAA_srSubscribeText {
        font-size: 18px;
        line-height: 24px;
        margin: 20px auto;
        max-width: 760px;
        width: 90%;
    }
    
    .paddingNew {
        padding: 40px 0;
    }
    .ShAA_srUnderSocText {
        font-size: 20px;
        margin: 32px auto;
        line-height: 28px;
    }
    .ShAA_stRButton {
        margin-bottom: 12px;
        font-size: 12px;
        padding-top: 8px;
        padding-bottom: 8px;
    }
}

@media (max-width: 368px) {
    .ShAA_srTextOnBanner {
        font-size: 14px;
    }
    .ShAA_instaSeasonTitle {
        width: 90%;
        margin: 0 auto;
        font-size: 18px;
    }
    .ShAA_textBlockGray {
        padding: 50px 0 60px;
    }
    .ShAA_srTitle {
        font-size: 42px;
    }
    .ShAA_srTextDiv {
        font-size: 16px;
        line-height: 24px;
    }
    ShAA_srSubscribeTitle {
        font-size: 24px;
        line-height: 28px;
    }
    
    .ShAA_srUnderSocText {
        font-size: 18px;
        margin: 24px auto;
        line-height: 24px;
        text-align: center;
    }
    .paddingNew {
        padding: 30px 0;
    }
}

</style>

<script type="text/javascript">

jQuery('.logoOnline').html('<a href="/"><img style="margin: 0;" alt="{/literal}{$showbrand->name|escape}{literal}" title="{/literal}{$showbrand->name|escape}{literal}" src="//lsboutique.ru/files/brands/{/literal}{$showbrand->image}{literal}" /></a>');

jQuery(document).ready(function(){    
    jQuery("#gallery").unitegallery({
        gallery_theme: "tiles",
        tiles_type: "justified"	,
        tiles_justified_row_height: 320,	//base row height of the justified type
		tiles_justified_space_between: 0,	//space between the tiles justified type 
        lightbox_show_numbers: false,
        lightbox_show_textpanel: false,
    });
});

</script>
{/literal}

<div class="ShAA_mainBerluti" style="max-width: 100%;">
	<div class="ShAA_berlutiBannerBig" style="position: relative;">
        <div>
            <a href="/brands/stefano-ricci/" title="Фирменный бутик одежды обуви сумок и аксессуаров бренда Stefano Ricci">
                <img src="/../images/stefano_ricci/top_banner_new.jpg" alt="Фирменный бутик одежды обуви сумок и аксессуаров бренда Stefano Ricci" style="float: left;"/>
            </a>
        </div>
        <div class="ShAA_overlay"></div>
        <div class="ShAA_srTextOnBanner">
            <div>
                <a href="/subscription/{$showbrand->brand_id}" id="feedbackbox"  onclick="{literal}rG('BRAND_SUBSCRIBE');{/literal}">
                    <div class="buttonNew ShAA_stRButton">
                        <span>Подписаться на обновления</span>
                    </div>
                </a>
            </div>
            {$Settings->current_new_season}
            Stefano Ricci – знаменитый флорентийский Дом Моды.</br>
            Специализируется на выпуске мужской одежды высочайшего качества.</br>
            Многие изделия выпускаются лимитированными коллекциями.
        </div>
	</div>
    
    <div class="ShAA_instaBlock">
        <div id="instafeed">
            <div class="ShAA_instaSeasonTitle">Новое в коллекции {$season}</div>
            <!-- LightWidget WIDGET -->
            <script src="//lightwidget.com/widgets/lightwidget.js"></script>
            <iframe src="//lightwidget.com/widgets/5ec0e38b8841500bbaf0a1ab8bcc5533.html" scrolling="no" allowtransparency="true" class="lightwidget-widget ShAA_insta" style="width: 100%; border: 0; overflow: hidden;"></iframe>
        </div>
    </div>
    <div class="ShAA_textBlockGray">
        <div class="ShAA_textBlockInner">
            <div class="ShAA_srTitle">Stefano Ricci</div>
            <div class="ShAA_srTextDiv ShAA_srLineUnderTitle">
            </div>
            <div class="ShAA_srTextDiv">
                Stefano Ricci — знаменитый флорентийский Дом моды. Специализируется на выпуске мужской одежды высочайшего качества. 
                Многие изделия выпускаются строго ограниченным тиражом.
            </div>
            <div class="ShAA_srTextDiv">
                Визитной карточкой бренда являются галстуки, которые изготавливаются только вручную из сотен тончайших нитей. 
                К каждому галстуку прикладывается маленькая золотая игла, при помощи которой создавался аксессуар.
            </div>
            <div class="ShAA_srTextDiv">
                Еще одной гордостью марки являются сорочки, отшивающиеся только из египетского шелка, 
                на который Stefano Ricci имеет эксклюзивные права. Кроме того, бренд на весь мир знаменит своими изделиями из кожи аллигатора. 
                Шкуры для изготовления сумок, ремней и обуви поставляются флорентийской марке напрямую и в ограниченном количестве.
            </div>
            <div class="ShAA_srTextDiv">
                Каждую вещь, созданную в мастерских Stefano Ricci, можно по праву назвать произведением искусства.
            </div>
        </div>
    </div>

    <div id="gallery" style="display:none; clear: both;">
        <img alt="Stefano Ricci" src="/design/adaptive/images/sr_1.jpg" data-image="/design/adaptive/images/sr_1.jpg" data-description="Stefano Ricci"/>
        <img alt="Stefano Ricci" src="/design/adaptive/images/sr_2.jpg" data-image="/design/adaptive/images/sr_2.jpg" data-description="Stefano Ricci"/>
        <img alt="Stefano Ricci" src="/design/adaptive/images/sr_3.jpg" data-image="/design/adaptive/images/sr_3.jpg" data-description="Stefano Ricci"/>
    </div>
    
    <div class="ShAA_srSubscribe">
        <div class="ShAA_srSubscribeTitle">
            Новости, поступления и скидки
        </div>
        <div class="ShAA_srSubscribeText">
            Мы рады поделится с Вами новостями о новых поступлениях, скидках или других интересных событиях и акциях
        </div>
        <div>
            <a href="/subscription/{$showbrand->brand_id}" id="feedbackbox"  onclick="{literal}rG('BRAND_SUBSCRIBE');{/literal}">
                <div class="buttonNew"><span>Подписаться на обновления</span></div>
            </a>
        </div>
    </div>
    
    <div class="ShAA_textBlockGray paddingNew">
        <div class="ShAA_srSocBlock">
            <a href="https://www.facebook.com/lsboutiq/" target="_blank">
                <i class="icon-facebook icon-2x"></i>
            </a>
            <a href="https://vk.com/lsboutiq/" target="_blank">
                <i class="icon-vk icon-2x"></i>
            </a>
            <a href="https://www.youtube.com/channel/UCLCtEXaZq_h2jAOfE2wtwFw" target="_blank">
                <i class="icon-youtube-play icon-2x"></i>
            </a>
            <a href="https://www.instagram.com/ls.boutique.ru/" target="_blank">
                <i class="icon-instagram icon-2x"></i>
            </a>
        </div>
        <div class="ShAA_srUnderSocText">
            Так же вы можете посетить наши<br/>страницы в социальных сетях или<br/>фирменный магазин<br/>в Нижнем Новгороде
        </div>
        <div class="ShAA_srUnderSocTextMini">
            Россия, Нижний Новгород,<br/>Нижневолжская набережная, 8/7<br/>С 10:00 до 21:00
        </div>
    </div>
    <div>
        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2212.024767523988!2d43.992788319720695!3d56.32940271596004!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x4151d4377599987d%3A0x96d6a74e70d1eb22!2z0J3QuNC20L3QtdCy0L7Qu9C20YHQutCw0Y8g0L3QsNCxLiwgOC83LCDQndC40LbQvdC40Lkg0J3QvtCy0LPQvtGA0L7QtCwg0J3QuNC20LXQs9C-0YDQvtC00YHQutCw0Y8g0L7QsdC7LiwgNjAzMDAx!5e0!3m2!1sru!2sru!4v1513856966833" width="100%" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>
    </div>
</div>