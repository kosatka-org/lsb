<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
{literal}
<script>
	var restore_request_send = false;
	jQuery(document).ready( function() {
		jQuery(".formError").remove();
		jQuery("#avatar_change").validationEngine();
	});
</script>
{/literal}
<div class="fullfield">
	<div class="ShAA_popBackTop"></div>
	<div class="ShAA_popBackCenter">
		<div class="ShAA_loginBlock">
			<a onclick="jQuery.fancybox.close();"><img width="16" style="float: right; margin: -15px -35px 0 0;" src="/images/pop_close.png"></a>
			<form autocomplete="off" action="/index.php?module=Login&avatar_change" method="post" name="avatar_change" id="avatar_change" enctype="multipart/form-data">
				<div class="sett1">
					<div>
						<input name="module" type="hidden" value="Login"/>
						<div class="ShAA_settingLeftBlock">
							<div class="ShAA_popData ShAA_popDataSett">
								<div class="ShAA_popInput">
									<input type="file" name="avatar" id="avatar" {literal}class="validate[required] FileInput"{/literal} value=""/>
								</div>
							</div>
						</div>
						<div class="ShAA_settingRightBlock">
							<div class="ShAA_popData" style="margin: 23px 0px 0 0;" >
								Аватарка должна быть изображением с размером не более 5 мегабайт
							</div>
						</div>
					</div>
					<div style="float: left; margin: 20px 0 16px 0; width: 100%;">
						<a href="javascript:void(0);" onclick="jQuery('#avatar_change').submit();{literal}rG('SAVE_AVATAR');return false;{/literal}">				
							<input type="submit" value="Сохранить" class="ShAA_popButton_input">
						</a>
					</div>
				</div>
			</form>
		</div>
		<div class="clear"></div>
	</div>
	<div class="ShAA_popBackBottom"></div>
</div>
{literal}
	<style>
		#fancybox-outer {
			background: none;
		}
		#fancybox-title {
			display: none !important;
		}
	</style>
{/literal}