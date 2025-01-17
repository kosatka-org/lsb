<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<link rel="stylesheet" href="/jscript/picEdit/css/picedit.css" />
{literal}
<script>
	var restore_request_send = false;
	jQuery(document).ready( function() {
		jQuery(".formError").remove();
		jQuery("#avatar_change").validationEngine();
		
		if (jQuery("body").width() < 481) {
			jQuery("#fancybox-wrap").css('padding','0px !important');	
			jQuery(".ShAA_popBackCenter").width(jQuery("body").width()-100);
			jQuery(".ShAA_popDataSett .ShAA_popInput input").css('width','83%');
			jQuery(".ShAA_popDataSett .ShAA_popInput textarea").css('width','83%');
			jQuery(".ShAA_popDataSett .phone input").css('width','75%');
		}
	});
</script>
{/literal}
<div class="fullfield">
	<div class="ShAA_popBackCenter" style="background: #fff;">
		<div class="ShAA_loginBlock">
			<a onclick="jQuery.fancybox.close();"><img width="16" style="float: right;" src="/images/pop_close.png"></a>
			<form autocomplete="off" action="/index.php?module=Login&avatar_change" method="post" name="avatar_change" id="avatar_change" enctype="multipart/form-data">
				<div class="sett1">
					<div>
						<input name="module" type="hidden" value="Login"/>
						<div>
							<div class="ShAA_popData ShAA_popDataSett" style="float:left; width:240px;">
								<div class="ShAA_popInput">
									<input type="file" name="avatar" id="avatar" {literal}class="validate[required] FileInput"{/literal} value=""/>
								</div>
							</div>
              <div style="margin-left:260px;">
                <div class="ShAA_popData" style="margin: 23px 0px 0 0; width: 100%;" >
                  Аватарка должна быть изображением с размерами не более 300 пикселей в ширину и высоту и величиной не более 2 мегабайт. Изображения большего размера будут уменьшены автоматически.<br/> Пожалуйста, воспользуйтесь окном загрузки для обрезки и изменения размера.
                </div>
                <div style="float: left; margin: 14px 0 0; width: 100%;">		
                  <input type="submit" onclick="{literal}rG('SAVE_AVATAR');{/literal}" value="Сохранить" class="ShAA_popButton_input">
                  <div class="ShAA_popMiniInfo" style="margin-top: 12px;">Нажимая на кнопку "Сохранить", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a></div>
                </div>
              </div>
						</div>
					</div>
				</div>   
			</form>
		</div>
		<div class="clear"></div>
	</div>
</div>
<script type="text/javascript" src="/jscript/picEdit/js/picedit.min.js"></script>
{literal}
<script type="text/javascript">
	$(function() {
		$('#avatar').picEdit({
      maxWidth:240,
      redirectUrl:'/personal_data/'
    });
	});
</script>
{/literal}
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