<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>LuxuryStore</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link media="all" href="/css/style.css" rel="stylesheet" type="text/css" />  
	<script type="text/javascript" src="http://yandex.st/jquery/1.9.1/jquery.min.js"></script>
	<link rel="stylesheet" href="/jscript/validationEngine.jquery.css" type="text/css" media="screen" charset="utf-8" />
	<script src="/jscript/jquery.validationEngine-ru.js" type="text/javascript"></script>
	<script src="/jscript/jquery.validationEngine.js"></script>
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
			<div class="work_logo"><a href="" alt="" title=""><img src="/images/ls_logo.jpg" alt="" title="" /></a></div>
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
					<div class="work_button" id="show_slide2">ПОЛУЧИТЬ РАБОТУ</div>
				</div>
			</div>
		</div>
	</div>
	<div class="work_wrap" style="display: none;" id="slide2">
		<div class="work_head_wrap">
			<div class="work_logo"><a href="" alt="" title=""><img src="/images/ls_logo.jpg" alt="" title="" /></a></div>
		</div>
		<div class="work_content_wrap">
			<div class="work_content gradient">
				<div class="work_center">
					<form id="form_work" action="/index.php?module=Feedback" enctype="multipart/form-data" method="POST">
						{* <input type="file" name="photo" id="file">
						<label for="file"><div class="work_foto_bigger"><div class="work_foto_text">ФОТО</div></div></label> *}
						<input type="text" name="name" class="work_input validate[required]" placeholder="ФИО">
						<input type="text" name="phone" class="work_input validate[required]" placeholder="НОМЕР ТЕЛЕФОНА">
						<input type="text" name="position" class="work_input validate[required]" placeholder="СПЕЦИАЛЬНОСТЬ">
						<input type="text" name="salary" class="work_input validate[required]" placeholder="РАЗМЕР ЖЕЛАЕМОЙ ЗАРАБОТНОЙ ПЛАТЫ">
						<input type="text" name="age" class="work_input" placeholder="УКАЖИТЕ ВАШ ВОЗРАСТ">
						<input type="text" name="last_job" class="work_input" placeholder="УКАЖИТЕ ВАШЕ ПРОШЛОЕ МЕСТО РАБОТЫ">
						<input type="text" name="education" class="work_input" placeholder="УКАЖИТЕ ВАШЕ ОБРАЗОВАНИЕ">
						<input type="text" name="hours" class="work_input" placeholder="ЖЕЛАЕМЫЙ ГРАФИК РАБОТЫ">
						<input type="text" name="family" class="work_input" placeholder="СЕМЕЙНОЕ ПОЛОЖЕНИЕ">
						<input type="text" name="home_city" class="work_input" placeholder="МЕСТО ПОСТОЯННОГО ПРОЖИВАНИЯ">
						<input type="text" name="drivers_license" class="work_input" placeholder="ВОДИТЕЛЬСКОЕ УДОСТОВЕРЕНИЕ">
						<input type="text" name="children" class="work_input" placeholder="ДЕТИ">
						<input type="text" name="citizenship" class="work_input" placeholder="ГРАЖДАНСТВО">
						<input type="text" name="languages" class="work_input" placeholder="ИНОСТРАННЫЕ ЯЗЫКИ">
						<input type="text" name="skills" class="work_input" placeholder="ДОПОЛНИТЕЛЬНЫЕ НАВЫКИ, КУРСЫ">
						<textarea name="resume" class="work_input" placeholder="ТЕКСТ РЕЗЮМЕ" style="height: 108px;"></textarea>
						Фотография: <input type="file" name="photo" id="file2">
						<input type="hidden" name="employment" id="employment_object" value="">
						<div class="work_button" style="margin: 18px auto 0;" id="submit">ОТПРАВИТЬ</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>