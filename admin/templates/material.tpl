<SCRIPT src="../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
<LINK href="../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    {if in_array('Storefront', $user_allowed)}<li><a href="index.php?section=Storefront&category={$Category->category_id}{if $smarty.get.brand_id}&brand_id={$smarty.get.brand_id}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}" class="off">товары</a></li>{/if}
    {if in_array('Categories', $user_allowed)}<li><a href="index.php?section=Categories" class="off">категории</a></li>{/if}
    {if in_array('Brands', $user_allowed)}<li><a href="index.php?section=Brands" class="off">бренды</a></li>{/if}
    {if in_array('Goods', $user_allowed)}<li><a href="index.php?section=Goods" class="off">бренд-категория</a></li>{/if}
	<li><a href="index.php?section=Materials" class="on">материалы</a></li>
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Simpla</a> →
          <a href="index.php?section=Goods">Эксклюзивные материалы</a> →
          {* Текущая категория *}
          {if $material}{$material->name}{else}создать{/if}

        </p>
      </td>
    </tr>
  </table>
  <!-- /Путь /-->
</div>	
 
<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">
     
      <div id="cont_top">
        <!-- Иконка раздела /--> 
	    <img src="./images/icon_categories.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline"> {if $material}{$material->name}{else}Создать{/if}</h1>
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

			<FORM name='material' METHOD=POST enctype='multipart/form-data'>
				<input type=hidden value='{$material->material_id}' name=id>
				<div id="over">		
					<div id="over_left">	
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="name" type="text" class="input3" value='{$material->name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/> <nobr><input name=visible type="checkbox" class="checkbox" {if $good->visible == 1 or !$good}checked{/if} value='1'/><span class="akt">Активна</span></nobr></p></td>
								</tr>
								<tr>
									<td class="model">Англ. Название</td>
									<td class="m_t"><p><input name="eng_name" type="text" class="input3" value='{$material->eng_name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/></td>
								</tr>
								<tr>
									<td class="model">Сокращения</td>
									<td class="m_t"><p><textarea name="aliases" style="height:100px"  class="input3">{$material->aliases|escape|nl2br}</textarea></p></td>
								</tr>
							</table>
							<p><input type="submit" value="Сохранить" class="submit"/></p>
					</div>
					
					
					<div id="over_right">
						<div class="gray_block1">
							<span class="model">Изображение</span>
																
							<table>
								<tr>
									<td>
									    <input type=hidden value='0' name=delete_image>
									    
									    {if $material->image}
										<img id=image class="image_preview" src='../files/materials/{$material->image}?r={math equation="rand(1,1000)"}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('image').src='images/no_photo.jpg'; window.document.material.delete_image.value = 1; return false;">Удалить</a></p>
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
				</div>
				<div class="area">
					<span class="model4">Описание
					{if $is_copywriter AND !empty($material)}
						{if !((empty($check_task->text) OR (in_array($check_task->text->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text->copywriter_id, array(0, $smarty.session.user->user_id)))) AND empty($material->description))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($material) AND $check_task->text->status == 'declined' AND !empty($check_task->text->decline_reason)}
						<p>Причина отказа: {$check_task->text->decline_reason}</p>
					{/if}
					<p><textarea name="description" style="width:930px;height:200px;">{if $material->description}{$material->description}{else}{$check_task->text->text}{/if}</textarea></p>
				</div>
				<div style="clear:both;"></div>

				<p><input type="submit" value="Сохранить" class="submitx" name="submit" /></p>
			</form>
			</div>
				<br/><br/>
		</div>
    </div>
  </div>	    
</div>
<!-- Content #End /--> 

{include file='tinymce_init.tpl'}

{if $Settings->meta_autofill}
<!-- Autogenerating meta tags -->
{literal}
<script>

// Templates
var item_form = document.good;

var meta_title_template = '%title';
var meta_keywords_template = '%title';
var meta_description_template = '%text';


var meta_title_touched = true;
var meta_keywords_touched = true;
var meta_description_touched = true;
var title_touched = true;
var url_touched = true;
	
// generating meta_title
function generate_title(template, title, text)
{
	return template.replace('%title', title).replace('%text', text).replace(/^(,\s)+|\s+$/g,"");
}	

// generating meta_keywords
function generate_keywords(template, title, text)
{	
	return template.replace('%title', title).replace('%text', text).replace(/^(,\s)+|\s+$/g,"");
}	

// generating meta_description
function generate_description(template, title,  text)
{	
	return template.replace('%title', title).replace('%text', text).replace(/^\s+|\s+$/g,"");
}	

// generating meta_title
function generate_url(brand_url, category_url)
{
	url = brand_url+'-'+category_url;
	return translit(url);
}	


// sel all metatags
function set_meta()
{	
	var brand_url = item_form.brand_id.options[item_form.brand_id.selectedIndex].title;
	var category_url = item_form.category_id.options[item_form.category_id.selectedIndex].title;
	var brand = item_form.brand_id.options[item_form.brand_id.selectedIndex].text;
	var category = item_form.category_id.options[item_form.category_id.selectedIndex].text.replace(/[^0-9a-zа-я\-]+/gi, '');
	var text = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");
	
	// Заголовок
	if(!title_touched)
		item_form.title.value = category+' '+brand;
		
	var title = item_form.title.value;	

	// Meta Title
	if(!meta_title_touched)
		item_form.meta_title.value = generate_title(meta_title_template, title, text);		

	// Meta Keywords
	if(!meta_keywords_touched)
		item_form.meta_keywords.value = generate_keywords(meta_keywords_template, title, text);		

	// Meta Description
	if(!meta_description_touched)
		item_form.meta_description.value = generate_description(meta_description_template, title, text);	

	// Url
	if(!url_touched)
		item_form.url.value = generate_url(brand_url, category_url);		

}

function translit(url){
	url = url.replace(/[\s]+/gi, '_');
	return url.replace(/[^0-9a-zа-я_\-]+/gi, '');
}

function autometageneration_init()
{ 
	tinyMCE.get("description").onChange.add(set_meta);
	tinyMCE.get("description").onKeyUp.add(set_meta);
	
	var title = item_form.title.value;
	var brand_url = item_form.brand_id.options[item_form.brand_id.selectedIndex].title;
	var category_url = item_form.category_id.options[item_form.category_id.selectedIndex].title;
	var brand = item_form.brand_id.options[item_form.brand_id.selectedIndex].text;
	var category = item_form.category_id.options[item_form.category_id.selectedIndex].text.replace(/[^0-9a-zа-я\-]+/gi, '');

	var text = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

	if(item_form.meta_title.value == '' || item_form.meta_title.value == generate_title(meta_title_template, title, text))
		meta_title_touched=false;
	if(item_form.meta_keywords.value == '' || item_form.meta_keywords.value == generate_keywords(meta_keywords_template, title, text))
		meta_keywords_touched=false;
	if(item_form.meta_description.value == '' || item_form.meta_description.value == generate_description(meta_description_template, title, text))
		meta_description_touched=false;
	if(item_form.title.value == '' || item_form.title.value == category+' '+brand)
		title_touched=false;
	if(item_form.url.value == '' || item_form.url.value == generate_url(brand_url, category_url))
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
myattachevent(item_form.title, 'change', function(){title_touched = true});
myattachevent(item_form.meta_title, 'change', function(){meta_title_touched = true});
myattachevent(item_form.meta_keywords, 'change', function(){meta_keywords_touched = true});
myattachevent(item_form.meta_description, 'change', function(){meta_description_touched = true});
myattachevent(item_form.brand_id, 'change', set_meta);
myattachevent(item_form.category_id, 'change', set_meta);
myattachevent(item_form.title, 'keyup',  set_meta);
myattachevent(item_form.title, 'change', set_meta);

</script>
{/literal}
<!-- END Autogenerating meta tags -->
{/if}