<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Анкета для соискателей на должность Работника в бутиках Лакшери Стор</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link media="all" href="/design/adaptive/css/style.css?v=1.76" rel="stylesheet" type="text/css" />
	<link media="all" href="/css/style.css" rel="stylesheet" type="text/css" />  
    <script type="text/javascript" src="/js/jquery/jquery.min.1.9.1.js"></script>
    
	<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2.1" type="text/css" media="screen" charset="utf-8" />
	<script src="/jscript/jquery.validationEngine-ru.js?v=2.1" type="text/javascript"></script>
	<script src="/jscript/jquery.validationEngine.js?v=2.1"></script>
  <script src='https://www.google.com/recaptcha/api.js'></script>
	{literal}
	<!--[if gte IE 9]>
	  <style type="text/css">
		.gradient {
		   filter: none;
		}
	  </style>
	<![endif]-->
	<script type="text/javascript">
		$(document).ready( function (){
			$("#show_slide2").click( function() {
				$("#slide1").slideUp(500);
				$("#slide2").slideDown(500);
			});
			$("#form_work").validationEngine();
		});
		$("input[type=text], textarea").focus(zoomDisable).blur(zoomEnable);
		function zoomDisable(){
		  $('head meta[name=viewport]').remove();
		  $('head').prepend('<meta name="viewport" content="width=device-width user-scalable=0" />');
		}
		function zoomEnable(){
		  $('head meta[name=viewport]').remove();
		  $('head').prepend('<meta name="viewport" content="width=device-width user-scalable=1" />');
		}

		function getFormData($form){
			var unindexed_array = $form.serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i){
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}

		$(document).on("click", "#submit", function(e) {
			var $form = $("#form_work");
			var data = getFormData($form);
			delete data.employment;
			$('#employment_object').val(JSON.stringify(data));
			$('#form_work').submit();
		});

	</script>
	{/literal}
</head>
<body style="width: 100%;padding: 0;">
	<div class="work_wrap" id="slide1">
		<div class="work_head_wrap">
			<div class="work_logo"><a href="" alt="" title=""><img src="/images/new_logo.png" alt="Лакшери Стор" width="220" height="64"></a></div>
		</div>
		<div class="work_content_wrap">
			<div class="work_content gradient">
				<div class="work_center">
					<div class="work_foto"><img src="/images/blank_face.png" alt="" title=""></div>
					<div class="work_text">
						<strong>ПРИГЛАШАЕМ НА РАБОТУ СОТРУДНИКОВ</strong><br />
						В новый проект - бутик брендовой одежды первой линии.<br />
						Мы ищем профессионалов с опытом более 3-х лет.<br />
						Работа по контракту. Высокая заработная плата.<br />
						Заполните анкету, чтобы получить работу.<br />
					</div>
					<div class="work_button ShAA_oneClickAdd" id="show_slide2">ПОЛУЧИТЬ РАБОТУ</div>
				</div>
			</div>
		</div>
	</div>
	<div class="work_wrap" style="display: none;" id="slide2">
		<div class="work_head_wrap">
			<div class="work_logo"><a href="" alt="" title=""><img src="/images/new_logo.png" alt="Лакшери Стор" width="220" height="64"></a></div>
		</div>
		<div class="work_content_wrap">
			<div class="work_content gradient">
				<div class="work_center">
					<form id="form_work" action="/index.php?module=Feedback" enctype="multipart/form-data" method="POST">
						{* <input type="file" name="photo" id="file">
						<label for="file"><div class="work_foto_bigger"><div class="work_foto_text">ФОТО</div></div></label> *}
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="name" class="work_input validate[required]" placeholder="ФИО">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="phone" class="work_input validate[required,minSize[10],custom[number]]" placeholder="НОМЕР ТЕЛЕФОНА">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="position" class="work_input validate[required]" placeholder="СПЕЦИАЛЬНОСТЬ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="salary" class="work_input validate[required]" placeholder="РАЗМЕР ЖЕЛАЕМОЙ ЗАРАБОТНОЙ ПЛАТЫ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="age" class="work_input" placeholder="УКАЖИТЕ ВАШ ВОЗРАСТ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="last_job" class="work_input" placeholder="УКАЖИТЕ ВАШЕ ПРОШЛОЕ МЕСТО РАБОТЫ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="education" class="work_input" placeholder="УКАЖИТЕ ВАШЕ ОБРАЗОВАНИЕ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="hours" class="work_input" placeholder="ЖЕЛАЕМЫЙ ГРАФИК РАБОТЫ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="family" class="work_input" placeholder="СЕМЕЙНОЕ ПОЛОЖЕНИЕ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="home_city" class="work_input" placeholder="МЕСТО ПОСТОЯННОГО ПРОЖИВАНИЯ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="drivers_license" class="work_input" placeholder="ВОДИТЕЛЬСКОЕ УДОСТОВЕРЕНИЕ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="children" class="work_input" placeholder="ДЕТИ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="citizenship" class="work_input" placeholder="ГРАЖДАНСТВО">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="languages" class="work_input" placeholder="ИНОСТРАННЫЕ ЯЗЫКИ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <input type="text" name="skills" class="work_input" placeholder="ДОПОЛНИТЕЛЬНЫЕ НАВЫКИ, КУРСЫ">
                            </div>
                        </div>
                        <div class="ShAA_popData ShAA_popDataSett" style="margin: 0;">
                            <div class="ShAA_popInput ShAA_inputWork">
                                <textarea name="resume" class="work_input" placeholder="ТЕКСТ РЕЗЮМЕ" style="height: 108px !important;"></textarea>
                            </div>
                        </div>
                        <div>
                            <div>
                                <img src="/images/blank_face.png" alt="" title="" style="width: 60px; height: 60px; float: left;">
                                <span style="float: left; margin: 18px 6px 60px;">
                                    Фотография:
                                    <input type="file" name="photo" id="file2">
                                    <input type="hidden" name="employment" id="employment_object" value="">
                                </span>
                            </div>
                        </div>
                        
                        <div class="clear"></div>
                        <div class="ShAA_popData ShAA_popDataSett">
                            <div class="g-recaptcha" data-sitekey="6LfDlk4UAAAAAAwQvfXiSySQrt89R8vDPb4i8qKK"></div>
                        </div>
                        <div class="clear"></div>
                        
						<div class="work_button ShAA_oneClickAdd" style="margin: 18px auto 0;" id="submit">ОТПРАВИТЬ</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>