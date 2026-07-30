<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Анкета для соискателей на должность Работника в бутиках Лакшери Стор</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link media="all" href="/css/style.css" rel="stylesheet" type="text/css" />  
    <script type="text/javascript" src="/js/jquery/jquery.min.1.9.1.js"></script>
	<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
	<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
	<script src="/jscript/jquery.validationEngine.js?v=2"></script>
	{literal}
    <!--[if gte IE 9]>
	  <style type="text/css">
		.gradient {
		   filter: none;
		}
	  </style>
	<![endif]-->
	<script type="text/javascript">
		$("input[type=text], textarea").focus(zoomDisable).blur(zoomEnable);
		function zoomDisable(){
		  $('head meta[name=viewport]').remove();
		  $('head').prepend('<meta name="viewport" content="width=device-width user-scalable=0" />');
		}
		function zoomEnable(){
		  $('head meta[name=viewport]').remove();
		  $('head').prepend('<meta name="viewport" content="width=device-width user-scalable=1" />');
		}
		$(document).on("click", "#close", function(e) {
			window.location.href = "/";
		});
	</script>
	{/literal}
</head>
<body style="width: 100%;padding: 0;">
	<div class="work_wrap" id="slide3">
		<div class="work_head_wrap">
			<div class="work_logo"><a href="" alt="" title=""><img src="/images/new_logo.png" alt="Лакшери Стор" width="220" height="64"></a></div>
		</div>
		<div class="work_content_wrap">
			<div class="work_content gradient">
				<div class="work_center">
					<div class="work_text_small">
						Уважаемый, {$employment.name}!</br>
						Ваше резюме на должность {$employment.position} получено</br>
						В короткое время наш сотрудник перезвонит Вам</br>
						на {$employment.phone}</br></br>

						Спасибо</br>
						<div class="work_button" id="close">Закрыть</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>