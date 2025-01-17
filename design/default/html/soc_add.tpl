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
{/literal}

<div class="ShAA_popBackTopMiddle"></div>
<div class="ShAA_popBackCenterMiddle">
	<div class="ShAA_middlePopContent">
		<a onclick="{literal}$.fancybox.close();{/literal}"><img src="/images/pop_close.png" style="float: right; margin: -15px -35px 0 0;" width="16"></a>
		<div class="ShAA_pop_title">{$smarty.session.user->name}</div>
		<div class="ShAA_popText">Вы можете упростить возвращение на сайт Лакшери стор, присоединив аккаунты, которыми пользуетесь.</div>
		{include file="networks_auth_buttons.tpl"}
	</div>
	<div class="clear"></div>
</div>
<div class="ShAA_popBackBottomMiddle"></div>
<!-- end Вы можете упростить возвращение -->