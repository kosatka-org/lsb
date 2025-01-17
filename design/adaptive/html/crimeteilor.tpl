{literal}
<style media="all" type="text/css" >
	#headBlock, .footer, .menuList {
		display: none !important;
	}
	a:hover, a:visited, a:link, a:active
	{
	    text-decoration: none;
	}
	section a:hover {
	    border-bottom: none;
	}
</style>

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/featherlight/1.4.0/featherlight.min.css" />
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/featherlight/1.4.0/featherlight.gallery.min.css" />
<link href='//fonts.googleapis.com/css?family=PT+Sans:400,700&subset=latin,cyrillic' rel='stylesheet' type='text/css'>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/featherlight/1.4.0/featherlight.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/featherlight/1.4.0/featherlight.gallery.min.js"></script>
<script>
	$(document).ready(function(){
		$(".ShAA_CrimeMenu").on("click","a", function (event) {
			//отменяем стандартную обработку нажатия по ссылке
			event.preventDefault();

			//забираем идентификатор бока с атрибута href
			var id  = $(this).attr('href'),

			//узнаем высоту от начала страницы до блока на который ссылается якорь
				top = $(id).offset().top;
			
			//анимируем переход на расстояние - top за 1500 мс
			$('body,html').animate({scrollTop: top}, 1500);
		});

		$("a#cr_signup").on("click", function(e) {
			e.preventDefault();
			var email = $("input#cr_email").val();
			$.post("/index.php?module=Feedback&crime_teilor_tickets", { email: email }, function(r) {
				$('div#confirm').fadeIn();
			});
		});
	});
</script>


{/literal}
<div class="ShAA_mainCrime">
	<div class="ShAA_crimeMenuBlock">
		<div class="ShAA_redLineDashed"></div>
		<div class="ShAA_CrimeMenu" style="text-align: center;">
			<span class="ShAA_CrimeMenuItem"><a href="#trailer">Премьера</a></span>
			<span class="ShAA_CrimeMenuItem"><a href="#photo">Фотогалерея</a></span>
			<span class="ShAA_CrimeMenuItem"><a href="#tickets">Подписка</a></span>
		</div>
		<div class="ShAA_violetLineDashed"></div>
	</div>
	<div id="top" class="ShAA_topBlockCrime">
		<div class="ShAA_redTextCrime">
			всероссийская</br> премьера фильма
		</div>
		<div class="ShAA_crimeTitle">
			<img src="../images/crimeteilor/crime_teilor.png" width="100%" />
		</div>
		<div class="ShAA_crimeText">
			10 апреля 2016 года в Нижнем Новгороде в кинотеатре «Октябрь» состоялся уникальный закрытый кинопоказ в рамках всероссийской премьеры фильма "Преступление портного" о талантливый неаполитанских портных легендарного бренда ISAIA, организованный Галереей бутиков «Лакшери Стор».
		</div>
	</div>
	<div class="ShAA_violetLineDashed"></div>
	<div class="ShAA_redScissors"></div>
	
	<div class="ShAA_videoCrime" id="trailer">
		<iframe width="100%" height="auto" src="//www.youtube.com/embed/TacPCOm0a4w?rel=0&amp;controls=0" frameborder="0" allowfullscreen></iframe>
		<div class="ShAA_crimeText">
			Фильм «Преступление портного» снят в честь предстоящего столетия Модного дома, который входит в число мировых лидеров, специализирующихся на пошиве элитарной мужской одежды. Данный фильм уже был показал в Неаполе и Милане. Нижний Новгород стал третьим городом, где состоялась премьера. Далее демонстрация фильма состоится в Москве, Санкт-Петербурге и Екатеринбурге. Хедлайнерами кинопоказа стали представители компании ISAIA – талантливые мастера индивидуального пошива Джанлука Рубино и Энцо Магарачи. Организатором уникального небывалого для Нижнего Новгорода события выступила Галерея бутиков «Лакшери Стор» в лице Генерального директора Евгения Жехарева. Мероприятие посетили известные представители нижегородской элиты. В рамках кинопоказа гостей ждал приветственный фуршет и выступление певца, исполняющего шедевры итальянских классических песен. Далее все гости были приглашены в зал кинотеатра, где и состоялась всероссийская премьера «Преступления портного». Сразу же после премьеры гостей ждал неожиданный сюрприз от ISAIA – демонстрация новой весенне-летней коллекции 2016 года, а также приятные подарки от ISAIA. Завершил вечер розыгрыш сертификатов среди участников фотоконкурса #лакшериселфи, организованного Галереей бутиков "Лакшери Стор". Счастливые победители фотоконкурса стали обладателями сертификатов на общую сумму 500 000 рублей. Праздник завершился шикарным салютом.
		</div>
	</div>

	<div class="ShAA_violetLineDashed"></div>
	<div class="ShAA_redScissors"></div>
	<div class="ShAA_headlinerCrime" id="photo">
		<section data-featherlight-gallery data-featherlight-filter="a">
			<div class="ShAA_dateText">Фотогалерея</div>
			<a href='/images/crimeteilor/phot_136.jpg'><img src='/images/crimeteilor/t_phot_136.jpg'/></a>
			<a href='/images/crimeteilor/phot_139.jpg'><img src='/images/crimeteilor/t_phot_139.jpg'/></a>
			<a href='/images/crimeteilor/phot_141.jpg'><img src='/images/crimeteilor/t_phot_141.jpg'/></a>
			<a href='/images/crimeteilor/phot_145.jpg'><img src='/images/crimeteilor/t_phot_145.jpg'/></a>
			<a href='/images/crimeteilor/phot_151.jpg'><img src='/images/crimeteilor/t_phot_151.jpg'/></a>
			<a href='/images/crimeteilor/phot_153.jpg'><img src='/images/crimeteilor/t_phot_153.jpg'/></a>
			<a href='/images/crimeteilor/phot_155.jpg'><img src='/images/crimeteilor/t_phot_155.jpg'/></a>
			<a href='/images/crimeteilor/phot_158.jpg'><img src='/images/crimeteilor/t_phot_158.jpg'/></a>
			<a href='/images/crimeteilor/phot_160.jpg'><img src='/images/crimeteilor/t_phot_160.jpg'/></a>
			<a href='/images/crimeteilor/phot_162.jpg'><img src='/images/crimeteilor/t_phot_162.jpg'/></a>
			<a href='/images/crimeteilor/phot_163.jpg'><img src='/images/crimeteilor/t_phot_163.jpg'/></a>
			<a href='/images/crimeteilor/phot_167.jpg'><img src='/images/crimeteilor/t_phot_167.jpg'/></a>
			<a href='/images/crimeteilor/phot_169.jpg'><img src='/images/crimeteilor/t_phot_169.jpg'/></a>
			<a href='/images/crimeteilor/phot_174.jpg'><img src='/images/crimeteilor/t_phot_174.jpg'/></a>
			<a href='/images/crimeteilor/phot_175.jpg'><img src='/images/crimeteilor/t_phot_175.jpg'/></a>
			<a href='/images/crimeteilor/phot_178.jpg'><img src='/images/crimeteilor/t_phot_178.jpg'/></a>
			<a href='/images/crimeteilor/phot_179.jpg'><img src='/images/crimeteilor/t_phot_179.jpg'/></a>
			<a href='/images/crimeteilor/phot_180.jpg'><img src='/images/crimeteilor/t_phot_180.jpg'/></a>
			<a href='/images/crimeteilor/phot_181.jpg'><img src='/images/crimeteilor/t_phot_181.jpg'/></a>
			<a href='/images/crimeteilor/phot_183.jpg'><img src='/images/crimeteilor/t_phot_183.jpg'/></a>
			<a href='/images/crimeteilor/phot_184.jpg'><img src='/images/crimeteilor/t_phot_184.jpg'/></a>
			<a href='/images/crimeteilor/phot_187.jpg'><img src='/images/crimeteilor/t_phot_187.jpg'/></a>
			<a href='/images/crimeteilor/phot_189.jpg'><img src='/images/crimeteilor/t_phot_189.jpg'/></a>
			<a href='/images/crimeteilor/phot_190.jpg'><img src='/images/crimeteilor/t_phot_190.jpg'/></a>
			<a href='/images/crimeteilor/phot_192.jpg'><img src='/images/crimeteilor/t_phot_192.jpg'/></a>
			<a href='/images/crimeteilor/phot_194.jpg'><img src='/images/crimeteilor/t_phot_194.jpg'/></a>
			<a href='/images/crimeteilor/phot_197.jpg'><img src='/images/crimeteilor/t_phot_197.jpg'/></a>
			<a href='/images/crimeteilor/phot_199.jpg'><img src='/images/crimeteilor/t_phot_199.jpg'/></a>
			<a href='/images/crimeteilor/phot_202.jpg'><img src='/images/crimeteilor/t_phot_202.jpg'/></a>
			<a href='/images/crimeteilor/phot_203.jpg'><img src='/images/crimeteilor/t_phot_203.jpg'/></a>
			<a href='/images/crimeteilor/phot_205.jpg'><img src='/images/crimeteilor/t_phot_205.jpg'/></a>
			<a href='/images/crimeteilor/phot_207.jpg'><img src='/images/crimeteilor/t_phot_207.jpg'/></a>
			<a href='/images/crimeteilor/phot_214.jpg'><img src='/images/crimeteilor/t_phot_214.jpg'/></a>
			<a href='/images/crimeteilor/phot_216.jpg'><img src='/images/crimeteilor/t_phot_216.jpg'/></a>
			<a href='/images/crimeteilor/phot_217.jpg'><img src='/images/crimeteilor/t_phot_217.jpg'/></a>
			<a href='/images/crimeteilor/phot_223.jpg'><img src='/images/crimeteilor/t_phot_223.jpg'/></a>
			<a href='/images/crimeteilor/phot_225.jpg'><img src='/images/crimeteilor/t_phot_225.jpg'/></a>
			<a href='/images/crimeteilor/phot_228.jpg'><img src='/images/crimeteilor/t_phot_228.jpg'/></a>
			<a href='/images/crimeteilor/phot_231.jpg'><img src='/images/crimeteilor/t_phot_231.jpg'/></a>
			<a href='/images/crimeteilor/phot_233.jpg'><img src='/images/crimeteilor/t_phot_233.jpg'/></a>
			<a href='/images/crimeteilor/phot_238.jpg'><img src='/images/crimeteilor/t_phot_238.jpg'/></a>
			<a href='/images/crimeteilor/phot_240.jpg'><img src='/images/crimeteilor/t_phot_240.jpg'/></a>
			<a href='/images/crimeteilor/phot_243.jpg'><img src='/images/crimeteilor/t_phot_243.jpg'/></a>
			<a href='/images/crimeteilor/phot_249.jpg'><img src='/images/crimeteilor/t_phot_249.jpg'/></a>
			<a href='/images/crimeteilor/phot_252.jpg'><img src='/images/crimeteilor/t_phot_252.jpg'/></a>
			<a href='/images/crimeteilor/phot_261.jpg'><img src='/images/crimeteilor/t_phot_261.jpg'/></a>
			<a href='/images/crimeteilor/phot_264.jpg'><img src='/images/crimeteilor/t_phot_264.jpg'/></a>
			<a href='/images/crimeteilor/phot_267.jpg'><img src='/images/crimeteilor/t_phot_267.jpg'/></a>
			<a href='/images/crimeteilor/phot_275.jpg'><img src='/images/crimeteilor/t_phot_275.jpg'/></a>
			<a href='/images/crimeteilor/phot_279.jpg'><img src='/images/crimeteilor/t_phot_279.jpg'/></a>
			<a href='/images/crimeteilor/phot_282.jpg'><img src='/images/crimeteilor/t_phot_282.jpg'/></a>
			<a href='/images/crimeteilor/phot_283.jpg'><img src='/images/crimeteilor/t_phot_283.jpg'/></a>
			<a href='/images/crimeteilor/phot_286.jpg'><img src='/images/crimeteilor/t_phot_286.jpg'/></a>
			<a href='/images/crimeteilor/phot_287.jpg'><img src='/images/crimeteilor/t_phot_287.jpg'/></a>
			<a href='/images/crimeteilor/phot_291.jpg'><img src='/images/crimeteilor/t_phot_291.jpg'/></a>
			<a href='/images/crimeteilor/phot_307.jpg'><img src='/images/crimeteilor/t_phot_307.jpg'/></a>
			<a href='/images/crimeteilor/phot_308.jpg'><img src='/images/crimeteilor/t_phot_308.jpg'/></a>
			<a href='/images/crimeteilor/phot_313.jpg'><img src='/images/crimeteilor/t_phot_313.jpg'/></a>
			<a href='/images/crimeteilor/phot_314.jpg'><img src='/images/crimeteilor/t_phot_314.jpg'/></a>
			<a href='/images/crimeteilor/phot_316.jpg'><img src='/images/crimeteilor/t_phot_316.jpg'/></a>
			<a href='/images/crimeteilor/phot_323.jpg'><img src='/images/crimeteilor/t_phot_323.jpg'/></a>
			<a href='/images/crimeteilor/phot_326.jpg'><img src='/images/crimeteilor/t_phot_326.jpg'/></a>
			<a href='/images/crimeteilor/phot_333.jpg'><img src='/images/crimeteilor/t_phot_333.jpg'/></a>
			<a href='/images/crimeteilor/phot_335.jpg'><img src='/images/crimeteilor/t_phot_335.jpg'/></a>
			<a href='/images/crimeteilor/phot_338.jpg'><img src='/images/crimeteilor/t_phot_338.jpg'/></a>
			<a href='/images/crimeteilor/phot_341.jpg'><img src='/images/crimeteilor/t_phot_341.jpg'/></a>
			<a href='/images/crimeteilor/phot_348.jpg'><img src='/images/crimeteilor/t_phot_348.jpg'/></a>
			<a href='/images/crimeteilor/phot_352.jpg'><img src='/images/crimeteilor/t_phot_352.jpg'/></a>
			<a href='/images/crimeteilor/phot_359.jpg'><img src='/images/crimeteilor/t_phot_359.jpg'/></a>
			<a href='/images/crimeteilor/phot_364.jpg'><img src='/images/crimeteilor/t_phot_364.jpg'/></a>
		</section>
	</div>

	<div class="ShAA_violetLineDashed"></div>
	<div class="ShAA_redScissors"></div>
	<div class="ShAA_headlinerCrime" id="tickets">
		<div class="ShAA_dateText">Подписка</div>
		<div class="ShAA_crimeText" style="padding: 0 3% 6px;">
			После того, как фильм будет показан в Москве, Санкт-Петербурге и Екатеринбурге вы сможете посмотреть фильм on-line на нашем сайте. Желаете увидеть фильм «Преступление портного» первым — оформите заявку и мы уведомим вас электронным письмом о начале кинопоказа.<br>
			<input type="text" id="cr_email" style="border: dashed 1px;line-height: 18px;padding: 8px 43px;margin-bottom: 6px;margin-top: 12px;min-width: 264px;font-size: 16px;text-align: center;" autocomplete="off" placeholder="Укажите свой email">
			<a id="cr_signup" href="#">
				<div class="buttonNew" style="background: #6f2062; color: #fe0000; margin-top: 12px;">
					<span>ПОДПИСАТЬСЯ</span>
				</div>
			</a>
		</div>
		<div class="ShAA_crimeText" style="padding: 0px 3% 6px; display: none;" id="confirm">
			Мы вам напишем, когда фильм "Преступление портного" будет доступен для просмотра в сети.
        </div>
	</div>
</div>
<div class="ShAA_crimeFooter">
	<div class="ShAA_mainBerluti">
		<div class="ShAA_crimeSocItem">
			<a href="//facebook.com/lsboutiq" target="_blank"><i class="icon-facebook-square"></i> facebook.com/lsboutiq</a>
		</div>
		<div class="ShAA_crimeSocItem">
			<a href="//instagram.com/lsboutique.ru" target="_blank"><i class="icon-instagram"></i>  instagram.com/lsboutique.ru</a>
		</div>
		<div class="ShAA_crimeSocItem right">
			<a href="//periscope.tv/@luxurystore" target="_blank"><i class="icon-map-marker"></i>  periscope.tv/@luxurystore</a>
		</div>
		<div class="ShAA_crimeSocItem right">
			<a href="//vk.com/lsboutiq" target="_blank"><i class="icon-vk"></i>  vk.com/lsboutiq</a>
		</div>
	</div>
	<div class="ShAA_crimelogoFooter">
		<a href=""><img src="../images/crimeteilor/ls_logo.png"/></a>
		<a href="/brands/isaia/"><img src="../images/crimeteilor/isaia_logo.png" /></a>
	</div>
</div>