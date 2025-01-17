$(document).ready(function(){
    if (document.documentMode || /Edge/.test(navigator.userAgent))
        {
            $('body').html('<div style="position: absolute; z-index: 99; background: #000; opacity: 0.5; width: 100%; height: 100%;"></div><div class="ShAA_chromInfo">Для корректной работы установите браузер Chrome<br> или Yandex браузер <a href="https://www.google.com/chrome/browser/desktop/index.html" class="ShAA_chromeButton" target="_blank">Скачать google Chrome</a><br><a href="https://browser.yandex.ru/desktop/main/" class="ShAA_chromeButton" target="_blank">Скачать Yandex браузер</a><div>Если возникли проблемы с установкой браузеров,<br> просьба связаться с Алексеем Воловиком <br> +7 903 600-86-30 <br> +7 999 136-25-15</div></div>');
        }
});
