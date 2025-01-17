  <SCRIPT src="../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
  <SCRIPT src="../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
  <SCRIPT src="../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
  <LINK href="../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

  <script language='javascript' src='js/calendar/calendar.js'></script>
  <script language='javascript' src='js/calendar/calendas.js'></script>
  <link rel='stylesheet' type='text/css' href='js/calendar/calendar.css'>

  <div id="inserts_all">
  <!-- Вкладки /-->
  {include file='sections_menu.tpl' active='news'}
  <!-- /Вкладки /-->
   
</div>	

 
<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">
     
      <div id="cont_top">
        <!-- Иконка раздела /--> 
	    <img src="./images/icon_content.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">{if $Item->news_id}{$Item->header}{else}Новая новость{/if}</h1>
        <!-- /Заголовок раздела /-->
        
        
      </div>

      <div id="cont_center">

     
        <div class="clear">&nbsp;</div>	  
        {if $Error}
        <!-- Error #Begin /-->
        <div id="error_minh">
          <div id="error">
            <img src="./images/error.jpg" alt=""/><p>{$Error}</p>					
          </div>
        </div>
        <!-- Error #End /-->
        {/if}
          



        <!-- Форма товара #Begin /-->

				<FORM name=news METHOD=POST enctype='multipart/form-data'>
					<div id="over">		
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Заголовок</td>
									<td class="m_t"><p><input name="header" type="text" class="input3" value='{$Item->header|escape}'  format='.+' notice='{$Lang->ENTER_TITLE}' /></p></td>
								</tr>
								              
								<tr>
									<td class="model">Дата</td>
									<td class="m_t"><p><INPUT class="input_date" NAME=date TYPE=TEXT VALUE='{if $Item->date}{$Item->date|escape}{else}{$smarty.now|date_format:"%d.%m.%Y"}{/if}' format='^\d\d\.\d\d\.\d\d\d\d$' notice='{$Lang->ENTER_CORRECT_DATE}'  onfocus="showCalendar('',this,this,'','holder',5,5,1)"/>
									&nbsp;&nbsp;&nbsp;&nbsp;<nobr><input name=enabled type="checkbox" class="checkbox" {if !$Item || $Item->enabled}checked{/if} value='1'/><span class="akt">Активна</span></nobr> &nbsp; &nbsp;
									</p>
									</td>
								</tr>
							</table>

							
							<div class="gray_block">
								<table>
								<tr>
									<td class="model2">URL</td>
									<td class="m_t"><p><input name="url" type="text" class="input6" value='{$Item->url}'/></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Title</td>
									<td class="m_t"><p><input name="meta_title"  type="text" class="input6" value='{$Item->meta_title}' /></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Keywords</td>
									<td class="m_t"><p><input name="meta_keywords" type="text" class="input6" value='{$Item->meta_keywords}' /></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Description</td>
									<td class="m_t"><p><input name="meta_description" type="text" class="input6" value='{$Item->meta_description}'/></p></td>
								</tr>
							</table>
							</div>
							<p><input type="submit" value="Сохранить" class="submit"/></p>
					</div>
					
					
					<div id="over_right">
						<div class="gray_block1">
							<span class="model">Изображение</span>
																
							<table>
								<tr>
									<td>
									    <input type=hidden value='0' name=delete_image>
									    
									    {if $Item->image}
										<img id=image class="image_preview" src='../files/news/{$Item->image}?r={math equation="rand(1,1000)"}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('image').src='images/no_photo.jpg'; window.document.news.delete_image.value = 1; return false;">Удалить</a></p>
										{else}
										<img id=image class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<p><input type="file" name="image" class="input7"/></p>
										<p class="mrg_top"><input name='image_url' type="text" class="input8" value="http://" /></p>
									</td>
								</tr>
							</table>
							<p><input type="submit" value="Сохранить" class="submit3"/></p>											
						</div>
					</div>
					

				<!--
				<div class="area">
					<span class="model4">Аннотация</span>
					<p><textarea id="annotation" name="annotation" class="editor_small">{$Item->annotation}</textarea></p>
				  <p>
				  <INPUT NAME=section_id TYPE=HIDDEN VALUE='{$Section->section_id}'>
				</div>-->
				<div class="area">
					<span class="model4">Видео</span>
					<p><textarea name="video" class="editor_big">{$Item->video}</textarea></p>
				  <p>
				  <input type="submit" value="Сохранить" class="submitx"/></p>
				</div>
				<div class="area">
					<span class="model4">Текст</span>
					<p><textarea name="body" class="editor_big">{$Item->body}</textarea></p>
				  <p>
				  <input type="submit" value="Сохранить" class="submitx"/></p>
				</div>


				</div>


			</div>
			</form>
			
	 
    </div>
  </div>	    
</div>
<!-- Content #End /-->

{include file='tinymce_init.tpl'}


{literal}	
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
		<script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
		<script>
			$(function() {
				
				jQuery(function($){
					$.datepicker.regional['ru'] = {
						closeText: 'Закрыть',
						prevText: '&#x3c;Пред',
						nextText: 'След&#x3e;',
						currentText: 'Сегодня',
						monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
						'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
						monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
						'Июл','Авг','Сен','Окт','Ноя','Дек'],
						dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
						dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
						dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
						weekHeader: 'Не',
						dateFormat: 'dd.mm.yy',
						firstDay: 1,
						isRTL: false,
						showMonthAfterYear: false,
						yearSuffix: ''};
					$.datepicker.setDefaults($.datepicker.regional['ru']);
				});
			
				$('input[name="date"]').datepicker({
					regional:'ru'
				});
			});
		</script>
		{/literal}
{if $Settings->meta_autofill}
<!-- Autogenerating meta tags -->
{literal}
<script>

// Templates
var meta_title_template = '%name';
var meta_keywords_template = '%name';
var meta_description_template = '%text';

var item_form = document.news;

var meta_title_touched = true;
var meta_keywords_touched = true;
var meta_description_touched = true;
var url_touched = true;
	
// generating meta_title
function generate_title(template, name, text)
{
	return template.replace('%name', name).replace('%text', text).replace(/^(,\s)+|\s+$/g,"");
}	

// generating meta_keywords
function generate_keywords(template, name, text)
{	
	return template.replace('%name', name).replace('%text', text).replace(/^(,\s)+|\s+$/g,"");
}	

// generating meta_description
function generate_description(template, name,  text)
{	
	return template.replace('%name', name).replace('%text', text).replace(/^\s+|\s+$/g,"");
}	

function generate_url(url)
{
	url = url.replace(/[\s]+/gi, '-');
	url = translit(url);
	url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();	
	return url;
}

function translit(str)
{	
	var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")   
	var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")   
 	var res = '';
	for(var i=0, l=str.length; i<l; i++)
	{ 
		var s = str.charAt(i), n = ru.indexOf(s); 
		if(n >= 0) { res += en[n]; } 
		else { res += s; } 
    } 
    return res;  
}	


// sel all metatags
function set_meta()
{	
	var name = item_form.header.value;

	var text = tinyMCE.get("body").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

	// Meta Title
	if(!meta_title_touched)
		item_form.meta_title.value = generate_title(meta_title_template, name, text);		

	// Meta Keywords
	if(!meta_keywords_touched)
		item_form.meta_keywords.value = generate_keywords(meta_keywords_template, name, text);		

	// Meta Description
	if(!meta_description_touched)
		item_form.meta_description.value = generate_description(meta_description_template, name, text);		

	// Url
	if(!url_touched)
		item_form.url.value = generate_url(name);		

}


function autometageneration_init()
{
	tinyMCE.get("body").onChange.add(set_meta);
	tinyMCE.get("body").onKeyUp.add(set_meta);
	
	var name = item_form.header.value;

	var text = tinyMCE.get("body").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

	if(item_form.meta_title.value == '' || item_form.meta_title.value == generate_title(meta_title_template, name, text))
		meta_title_touched=false;
	if(item_form.meta_keywords.value == '' || item_form.meta_keywords.value == generate_keywords(meta_keywords_template, name, text))
		meta_keywords_touched=false;
	if(item_form.meta_description.value == '' || item_form.meta_description.value == generate_description(meta_description_template, name, text))
		meta_description_touched=false;
	if(item_form.url.value == '' || item_form.url.value == generate_url(name))
		url_touched=false;
}

// Attach events
function myattachevent(target, eventName, func)
{
    if ( target.addEventListener )
        target.addEventListener(eventName, func, false);
    else if ( target.attachEvent )
        target.attachEvent("on" + eventName, func);
    else
        target["on" + eventName] = func;
}

if (window.attachEvent) {
	window.attachEvent("onload", function(){setTimeout("autometageneration_init();", 1000)});
} else if (window.addEventListener) {
	window.addEventListener("DOMContentLoaded", autometageneration_init, false);
} else {
	document.addEventListener("DOMContentLoaded", autometageneration_init, false);
}

myattachevent(item_form.url, 'change', function(){url_touched = true});
myattachevent(item_form.meta_title, 'change', function(){meta_title_touched = true});
myattachevent(item_form.meta_keywords, 'change', function(){meta_keywords_touched = true});
myattachevent(item_form.meta_description, 'change', function(){meta_description_touched = true});
myattachevent(item_form.header, 'keyup',  set_meta);
myattachevent(item_form.header, 'change', set_meta);



</script>
{/literal}
<!-- END Autogenerating meta tags -->
{/if}

