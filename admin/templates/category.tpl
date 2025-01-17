<SCRIPT src="../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
<LINK href="../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
     {if in_array('Storefront', $user_allowed)}<li><a href="index.php?section=Storefront" class="off">товары</a></li>{/if}
    <li><a href="index.php?section=Categories" class="on">категории</a></li>
    {if in_array('Brands', $user_allowed)}<li><a href="index.php?section=Brands" class="off">бренды</a></li>{/if}
    {if in_array('Goods', $user_allowed)}<li><a href="index.php?section=Goods" class="off">бренд-категория</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          <a href="index.php?section=Storefront">Категории товаров</a> →
          {* Текущая категория *}
          {$Item->name}

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
        <h1 id="headline">{$Item->name}</h1>
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

				<FORM name=category METHOD=POST enctype='multipart/form-data'>
					<div id="over">
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="name" type="text" class="input3" value='{$Item->name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/></p></td>
								</tr>
								<tr>
									<td class="model">В ед. числе</td>
									<td class="m_t"><p><input name="single_name" type="text" class="input3" value='{$Item->single_name|escape}' /></p></td>
								</tr>
								<tr>
									<td class="model">Англ. Название</td>
									<td class="m_t"><p><input name="eng_name" type="text" class="input3" value='{$Item->eng_name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/></p></td>
								</tr>
								<tr>
									<td class="model">Англ. В ед. числе</td>
									<td class="m_t"><p><input name="eng_single_name" type="text" class="input3" value='{$Item->eng_single_name|escape}' /></p></td>
								</tr>
								<tr>
									<td class="model">Каноническая категория</td>
									<td class="m_t"><p>
										<select name='canonical' class="select1">
											<option value="0">Не выбран</option>
											{foreach from=$canonicalCategories item=ccat}
												<option value="{$ccat->category_id}" {if $Item->canonical_id == $ccat->category_id }selected{/if}>{$ccat->name}</option>
											{/foreach}
										</select>
									</td>
								</tr>
								<tr>
									<td class="model">Родитель</td>
									<td class="m_t"><p>
										<select name=parent class="select1">
                      <option value='0' {if $rcat->category_id == 0}selected{/if}>Не выбран</option>
                      {foreach from=$rootCategories item=rcat}
                        <option value='{$rcat->category_id}' {if $rcat->category_id == $Item->parent}selected{/if}>{$rcat->name}</option>
                      {/foreach}
										</select>
										<nobr><input name=enabled type="checkbox" class="checkbox" {if $Item->enabled}checked{/if} value='1'/><span class="akt">Активна</span></nobr> &nbsp; &nbsp;
									</p></td>
								</tr>
                <tr>
									<td class="model">Тип размерной сетки для мужских товаров</td>
									<td class="m_t"><p>
                    <select name="mens_size_type_id" class="select1">
                      <option value="0" {if !$Item->mens_size_type_id}selected{/if}>Не выбран</option>
                      {foreach from=$size_types item=st}
				                <option value={$st->type_id} {if $Item->mens_size_type_id == $st->type_id}selected{/if}>{$st->type_name}</option>
                      {/foreach}
										</select>
									</p></td>
								</tr>
                <tr>
									<td class="model">Тип размерной сетки для женских товаров</td>
									<td class="m_t"><p>
                    <select name="womens_size_type_id" class="select1">
                      <option value="0" {if !$Item->womens_size_type_id}selected{/if}>Не выбран</option>
                      {foreach from=$size_types item=st}
				                <option value={$st->type_id} {if $Item->womens_size_type_id == $st->type_id}selected{/if}>{$st->type_name}</option>
                      {/foreach}
										</select>
									</p></td>
								</tr>
								<tr>
									<td class="model">Тип</td>
									<td class="m_t"><p>
										<select name=type_id class="select1">
											<option value=0>Не определен</option>
											<option value=1 {if $Item->type_id == 1}selected{/if}>Верх</option>
											<option value=2 {if $Item->type_id == 2}selected{/if}>Низ</option>
											<option value=3 {if $Item->type_id == 3}selected{/if}>Обувь</option>
										</select>
									</p></td>
								</tr>
								<tr>
									<td class="model">Вес (кг)</td>
									<td class="m_t"><p>
										<select name=weight class="select1">
											<option value=0>Не определен</option>
							                {foreach item=weight from=$weights}
											<option value="{$weight}" {if $weight == $Item->weight}selected="selected"{/if}>{$weight}</option>
											{/foreach}
										</select>

									</p></td>
								</tr>
								<tr>
									<td class="model">Пол</td>
									<td class="m_t"><p>
										<input type="radio" value="0" name="sex" id="sex0" {if $Item->gender == '0'}checked{/if} ><label for="sex0" style="font-size:14px;">Не определен</label>
										<input type="radio" value="1" name="sex" id="sex1" {if $Item->gender == '1'}checked{/if} ><label for="sex1" style="font-size:14px;">Мужской</label>
										<input type="radio" value="2" name="sex" id="sex2" {if $Item->gender == '2'}checked{/if} ><label for="sex2" style="font-size:14px;">Женский</label>
									</p></td>
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
										<img id=image class="image_preview" src='../files/categories/{$Item->image}?r={math equation="rand(1,1000)"}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('image').src='images/no_photo.jpg'; window.document.category.delete_image.value = 1; return false;">Удалить</a></p>
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
					<span class="model4">SEO слова (Используйте эти слова при описании)</span>
					<div id="seo_words" style="font-size:14px;">{$Item->seo_words}</div>
				</div>

				<div class="area">
					<span class="model4">Описание
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->description) OR (in_array($check_task->description->status, array('new', 'declined', 'need_check')) AND in_array($check_task->description->copywriter_id, array(0, $smarty.session.user->user_id)))) AND empty($Item->description))}<span style="color:#f00;">- не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->description->status == 'declined' AND !empty($check_task->description->decline_reason)}
						<p>Причина отказа: {$check_task->description->decline_reason}</p>
					{/if}
					<p><textarea id="description" name="description" class="editor_small">{if $Item->description}{$Item->description}{else}{$check_task->description->text}{/if}</textarea></p>
				</div>
				<div style="clear:both;"></div>

				<div class="area">
					<span class="model4">Мужское описание
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->mens_description) OR (in_array($check_task->mens_description->status, array('new', 'declined', 'need_check')) AND in_array($check_task->mens_description->copywriter_id, array(0, $smarty.session.user->user_id)))) AND empty($Item->mens_description))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->mens_description->status == 'declined' AND !empty($check_task->mens_description->decline_reason)}
						<p>Причина отказа: {$check_task->mens_description->decline_reason}</p>
					{/if}
					<p><textarea id="mens_description" name="mens_description" class="editor_small">{if $Item->mens_description}{$Item->mens_description}{else}{$check_task->mens_description->text}{/if}</textarea></p>
				</div>
				<div style="clear:both;"></div>

				<div class="area">
					<span class="model4">Женское описание
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->womens_description) OR (in_array($check_task->womens_description->status, array('new', 'declined', 'need_check')) AND in_array($check_task->womens_description->copywriter_id, array(0, $smarty.session.user->user_id)))) AND empty($Item->womens_description))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->womens_description->status == 'declined' AND !empty($check_task->womens_description->decline_reason)}
						<p>Причина отказа: {$check_task->womens_description->decline_reason}</p>
					{/if}
					<p><textarea id="womens_description" name="womens_description" class="editor_small">{if $Item->womens_description}{$Item->womens_description}{else}{$check_task->womens_description->text}{/if}</textarea></p>
				</div>
				<div style="clear:both;"></div>

				<p><input type="submit" value="Сохранить" class="submitx"/></p>
				</div>
				<br/><br/>
			</div>
			</form>
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
var item_form = document.category;

var meta_title_template = '%name';
var meta_keywords_template = '%name';
var meta_description_template = '%text';


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

// generating meta_title
function generate_url(name)
{
	url = name;
	return translit(url);
}


// sel all metatags
function set_meta()
{
	var name = item_form.name.value;

	var text = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

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

function translit(url){
	url = url.replace(/[\s]+/gi, '_');
	return url.replace(/[^0-9a-zа-я_]+/gi, '');
}

function autometageneration_init()
{
	tinyMCE.get("description").onChange.add(set_meta);
	tinyMCE.get("description").onKeyUp.add(set_meta);

	var name = item_form.name.value;

	var text = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

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
myattachevent(item_form.name, 'keyup',  set_meta);
myattachevent(item_form.name, 'change', set_meta);

</script>
{/literal}
<!-- END Autogenerating meta tags -->
{/if}
