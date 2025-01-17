<SCRIPT src="../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
<script type="text/javascript" src="/jscript/jquery.autocomplete.min.js"></script>
<link href="/jscript/jquery.autocomplete.min.css" rel="stylesheet" type="text/css" />
<LINK href="../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/javascript">
$(document).ready(function() {
  $('#autocomplete').devbridgeAutocomplete({
      onSearchStart: function (params) {console.log(1);},
      serviceUrl: '/admin/index.php?section=Order&autocomplete',
      onSelect: function (suggestion) {
      console.log(suggestion.data);
        $('#city_id').val(suggestion.data);
      }
  });
});
</script>
{/literal}
<div id="inserts_all">
  <!-- Вкладки /-->
   {include file='sections_menu.tpl' active='cities'}
  <!-- /Вкладки /-->

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
        <h1 id="headline"> {if $city}{$city->name}{else}Создать{/if}</h1>
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

				<FORM name=city METHOD=POST enctype='multipart/form-data'>
				<input type=hidden value='{$city->id}' name=id>
					<div id="over">
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="name" type="text" class="input3" value='{$city->name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/> <nobr><input name=visible type="checkbox" class="checkbox" {if $city->visible == 1 or !$city}checked{/if} value='1'/><span class="akt">Активен</span></nobr></p></td>
								</tr>
								<tr>
									<td class="model">Город</td>
									<td class="m_t"><p>
                    <input name="city_id" type="hidden" id="city_id" class="input3" value='{$city->city_id}'/>
                    <input name="city" type="text" class="input3" id="autocomplete" value='{$city->name|escape}' {if $DeliveryAgent}disabled{/if}/>
									</p></td>
								</tr>
								<tr>
									<td class="model">Код карты (из конструктора карт Яндекса)</td>
									<td class="m_t"><p><textarea name="map_url" class="input3" style="width:354px;height:150px;">{$city->map_url}</textarea></p></td>
								</tr>
								{if $comments}
									<tr><td colspan=2><h2>Комментарии к городу</h2></td></tr>
									{foreach from=$comments item=comment}
										<tr>
											<td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
											{if $comment->commenter_id == $smarty.session.user->user_id || $allowed_admin}
											<a href="/admin/index.php?section=City&amp;delete_comment_id={$comment->id}&amp;city_id={$city->city_id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
											{/if}
											{$comment->date}
											<br>
											<b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}</b>: {$comment->text|escape|nl2br}
											<br>
											</td>
										</tr>
									{/foreach}
								{/if}
                                <tr>
								<tr>
									<td class="model">Комментарий</td>
									<td class="m_t"><p><textarea name="comment" class="input3" style="width:354px;height:60px;"></textarea></p></td>
								</tr>
							</table>


							<div class="gray_block">
								<table>
								<tr>
									<td class="model2">URL</td>
									<td class="m_t"><p><input name="url" type="text" class="input6" value='{$city->url}'/></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Title</td>
									<td class="m_t"><p><input name="meta_title"  type="text" class="input6" value='{$city->meta_title}' /></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Keywords</td>
									<td class="m_t"><p><input name="meta_keywords" type="text" class="input6" value='{$city->meta_keywords}' /></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Description</td>
									<td class="m_t"><p><input name="meta_description" type="text" class="input6" value='{$city->meta_description}'/></p></td>
								</tr>
							</table>
							</div>
							<p><input type="submit" value="Сохранить" class="submit"/></p>
					</div>


					<div id="over_right">
						<div class="gray_block1">
							<span class="model">Способы доставки</span>

							<table>
								{foreach item=dm from=$delivery_methods}
									<tr>
										<td>
                      <label><input type="checkbox" value="{$dm->delivery_method_id}" name="delivery_methods[]" {if in_array($dm->delivery_method_id, $city->delivery_methods)}checked{/if} /> {$dm->name}</label>
                      <br>
                      <label>Базовая цена:</label><input name="delivery_prices[{$dm->delivery_method_id}]" value="{$dm->city_price}"/>р
                    </td>
									</tr>
								{/foreach}
							</table>
							<p><input type="submit" value="Сохранить" class="submit3"/></p>
						</div>
						<div class="gray_block1">
							<span class="model">Способы оплаты</span>

							<table>
								{foreach item=pm from=$payment_methods}
									<tr>
										<td><label><input type="checkbox" value="{$pm->payment_method_id}" name="payment_methods[]" {if in_array($pm->payment_method_id, $city->payment_methods)}checked{/if} /> {$pm->name}</label></td>
									</tr>
								{/foreach}
							</table>
							<p><input type="submit" value="Сохранить" class="submit3"/></p>
						</div>
						<div class="gray_block1">
							<span class="model">Геобаннер левый</span>
							<table>
								<tr>
									<td>
									    <input type=hidden value='0' name=delete_image>
									    {if $city->image}
										<img id=image class="image_preview" src='../files/cities/{$city->image}?r={math equation="rand(1,1000)"}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('image').src='images/no_photo.jpg'; window.document.city.delete_image.value = 1; return false;">Удалить</a></p>
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
							<span class="model">Геобаннер правый</span>
							<table>
								<tr>
									<td>
									    <input type=hidden value='0' name=delete_image_right>
									    {if $city->image_right}
										<img id=image_right class="image_preview" src='../files/cities/{$city->image_right}?r={math equation="rand(1,1000)"}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('image_right').src='images/no_photo.jpg'; window.document.city.delete_image_right.value = 1; return false;">Удалить</a></p>
										{else}
										<img id=image_right class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<p><input type="file" name="image_right" class="input7"/></p>
										<p class="mrg_top"><input name='image_url_right' type="text" class="input8" value="http://" /></p>
									</td>
								</tr>
							</table>
							<p><input type="submit" value="Сохранить" class="submit3"/></p>
						</div>
					</div>
				</div>


				<div class="area">
					<span class="model4">Описание
					<p><textarea id="description" name="text" class="editor_small">{$city->text}</textarea></p>
				</div>
				<div style="clear:both;"></div>

				<div class="area">
					<span class="model4">Транспортные компании и адреса
					<p><textarea id="description2" name="text2" class="editor_small">{$city->text2}</textarea></p>
				</div>
				<div style="clear:both;"></div>


				<p><input type="submit" value="Сохранить" class="submitx" name="submit" /></p>

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
var item_form = document.city;

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

	var text = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ") + tinyMCE.get("description2").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

	// Meta Title
	if(!meta_title_touched)
		item_form.meta_title.value = generate_title(meta_title_template, 'Доставка в город ' + name, text);

	// Meta Keywords
	if(!meta_keywords_touched)
		item_form.meta_keywords.value = generate_keywords(meta_keywords_template, 'Доставка в город ' + name, text);

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

	tinyMCE.get("description").onChange.add(set_meta);
	tinyMCE.get("description2").onKeyUp.add(set_meta);

	var name = item_form.name.value;

	var text = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ") + tinyMCE.get("description2").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

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

myattachevent(item_form.city_id, 'change', function(){item_form.name.value = item_form.city_id.options[item_form.city_id.selectedIndex].text; set_meta();});
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
