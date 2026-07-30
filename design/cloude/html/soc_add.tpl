<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

<!-- Вы можете упростить возвращение -->
{literal}
<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-left {
		display: none !important;
	}
	#fancybox-right {
		display: none !important;
	}
</style>

<script>	
	$(document).ready( function() {
		if (jQuery("body").width() < 481) {
			jQuery("#fancybox-wrap").css('padding','0px !important');	
			jQuery(".ShAA_popBackCenter").width(jQuery("body").width()-100);
			jQuery(".ShAA_popInput input").css('width','83%');
			jQuery(".ShAA_popInput textarea").css('width','83%');
			jQuery(".phone input").css('width','75%');
		}
	});
</script>

{/literal}

<div class="ShAA_popBackCenter">
	<div class="ShAA_loginBlock" style="float: left;">
		<a onclick="jQuery.fancybox.close();"><img src="/images/pop_close.png" style="float: right;" width="16"></a>
		<div class="ShAA_pop_title">{$smarty.session.user->name}</div>
		<div class="ShAA_popText">Вы можете упростить возвращение на сайт Лакшери стор, присоединив аккаунты, которыми пользуетесь.</div>
		{include file="networks_auth_buttons.tpl"}
	</div>
	<div class="clear"></div>
</div>
<!-- end Вы можете упростить возвращение -->