<SCRIPT src="../../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
<LINK href="../../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Storefront&category={$Category->category_id}{if $smarty.get.brand_id}&brand_id={$smarty.get.brand_id}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}" class="on">товары</a></li>
    {if in_array('Categories', $user_allowed)}<li><a href="index.php?section=Categories" class="off">категории</a></li>{/if}
    {if in_array('Brands', $user_allowed)}<li><a href="index.php?section=Brands" class="off">бренды</a></li>{/if}
    {if in_array('Goods', $user_allowed)}<li><a href="index.php?section=Goods" class="off">бренд-категория</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          <a href="index.php?section=Storefront">Товары</a> →
          {if $Item->product_id}
          {if $Category}<a href="index.php?section=Storefront&category={$Category->category_id}">{$Category->name}</a>  →{/if}
          {if $Item->category_single_name}{$Item->category_single_name|escape}{else}{$Item->category_name|escape}{/if} {$Item->brand} {$Item->model}
          {else}
            Новый товар
          {/if}

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
	    <!-- <img src="./images/icon_products.jpg" alt="" class="line"/>-->
	    <!-- /Иконка раздела /-->

	    <!-- Заголовок раздела /-->
        <h1 id="headline" title='ID={$Item->product_id}' >{if $Item->product_id}{$Item->model}{else}Новый товар{/if}</h1>
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

				<FORM name=product METHOD=POST enctype='multipart/form-data'>
					<div id="over" style="overflow: visible;">
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="model" type="text" class="input3" value='{$Item->model|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/></p></td>
								</tr>
								<tr>
									<td class="model">Название модели</td>
									<td class="m_t"><p><input name="model_full" type="text" class="input3" value='{$Item->model_full|escape}'/></p></td>
								</tr>
                <tr>
									<td class="model">Товар на сайте</td>
									<td class="m_t"><p><a href="/products/{$Item->url}/" style="font-size:13px;">http://{$root_url}/products/{$Item->url}</a></p></td>
								</tr>
                <tr>
									<td class="model">Код 1С</td>
									<td class="m_t"><p style="font-size:14px;">{$Item->code}</p></td>
								</tr>
								<tr>
									<td class="model">Бренд</td>
									<td class="m_t"><p>
										<select name=brand_id class="select2">
											<option value=0 brand_name=''>Не указан</option>
                                            {foreach from=$Brands item=brand}
                                                 <option value='{$brand->brand_id}' {if $Item->brand_id == $brand->brand_id}selected{/if} brand_name='{$brand->name|escape}'>{$brand->name|escape}</option>
                                            {/foreach}
										</select>
										<nobr><input name=enabled type="checkbox" class="checkbox" {if $Item->enabled}checked{/if} value='1'/><span class="akt">{$Lang->ACTIVE}</span></nobr> &nbsp;
										<!--<nobr><input name=hit type="checkbox" class="checkbox" {if $Item->hit}checked{/if} value='1'/><span class="akt">{$Lang->HIT}</nobr></span>-->
									</p></td>
								</tr>
								<tr>
									<td class="model">Цвет</td>
									<td class="m_t"><p>
										<select name=color_id class="select2">
											<option value=0>Не определен</option>
                                            {foreach from=$Colors item=brand}
                                                 <option value='{$brand->color_id}' {if $Item->color_id == $brand->color_id}selected{/if}>{$brand->name|escape}</option>
                                            {/foreach}
										</select>
									</p></td>
								</tr>
								<tr>
									<td class="model">Группа</td>
									<td class="m_t"><p>
										<select name=category_id class="select2" onchange='display_properties(this.value);'>
                      {if $Category->canonical_id}
                        <option value='{$Category->category_id}' selected category_name='{$Category->single_name}'>{$Category->name} - Не канон</option>
                        <option value='' category_name=''></option>
                      {/if}
  										{foreach from=$Categories item=category}
  											<option value='{$category->category_id}' {if $category->category_id == $Item->category_id}selected{/if} category_name='{$category->single_name}'>{$category->name}</option>
  										{/foreach}
										</select>
                    <a href="/admin/index.php?section=Category&item_id={$Item->category_id}" target="_blank">карточка категории</a>
									</p>
                  </td>
								</tr>
								<tr>
									<td class="model">Посадка</td>
									<td class="m_t"><p>
										<select name=fitting class="select2">
                      <option value='0'>Не определен</option>
  										{foreach from=$fittings item=fit}
  											<option value='{$fit->id}' {if $fit->id == $Item->fitting}selected{/if}>{$fit->name}</option>
  										{/foreach}
										</select>
									</p></td>
								</tr>
								<tr>
									<td class="model">Материал</td>
									<td class="m_t"><p>
										<select name=stretch class="select2">
                      <option value='0'>Не определен</option>
  										{foreach from=$materials item=mat}
  											<option value='{$mat->id}' {if $mat->id == $Item->stretch}selected{/if}>{$mat->name}</option>
  										{/foreach}
										</select>
									</p></td>
								</tr>
								<tr>
									<td class="model">Пол</td>
									<td class="m_t"><p>
										<input type="radio" value="0" name="sex" id="sex0" {if $Item->sex == '0'}checked{/if} ><label for="sex0" style="font-size:14px;">Не определен</label>
										<input type="radio" value="1" name="sex" id="sex1" {if $Item->sex == '1'}checked{/if} ><label for="sex1" style="font-size:14px;">Мужской</label>
										<input type="radio" value="2" name="sex" id="sex2" {if $Item->sex == '2'}checked{/if} ><label for="sex2" style="font-size:14px;">Женский</label>
									</p></td>
								</tr>
                <tr>
                  <td class="model"><b>Оффлайн цена</b></td>
                  <td class="m_t" style="font-size:14px;">{$Item->offline_price|escape|number_format:0:'.':' '}</td>
                </tr>
                <tr>
                  <td class="model">Изменения цены</td>
                  <td class="m_t"></td>
                </tr>
                <tr>
                  <td class="model">Дата</td>
                  <td class="m_t">Старая цена > Новая цена</td>
                </tr>
                {foreach from=$price_changes item=price_change}
                  <tr>
                    <td class="model">{if $smarty.now|date_format:"%Y" == $price_change->date|date_format:"%Y"}{$price_change->date|date_format:"%d.%m"}{else}{$price_change->date|date_format:"%Y.%d.%m"}{/if}{if $price_change->username}<br>(<b>{$price_change->username}</b>){/if}</td>
                    <td class="m_t">{$price_change->old_price|escape|number_format:0:'.':' '} > {$price_change->new_price|escape|number_format:0:'.':' '}</td>
                  </tr>
                {/foreach}

							</table>

							<div class="yellow_block">
								<table>
									<tr>
										<td><span class="akt1">Цена, {$MainCurrency->sign}</span></td>
										<td><span class="akt2">Старая цена</span></td>
										<td><span class="akt2">Артикул</span></td>
									</tr>
									<tr>
										<td><p><input name=quantity value="10000" type="hidden" class="input5"/><input name=price id='price' value="{$Item->price|escape|number_format:0:'.':' '}" type="text" class="input4" value="0"/></p></td>
										<td><p><input name=old_price id='old_price' value="{$Item->old_price|escape|number_format:0:'.':' '}" type="text" class="input4" value="0"/></p></td>
										<td><p><input name=sku value='{$Item->sku|escape}' type="text" class="input4" value="0" /></p></td>
									</tr>
									<tr>
                    <td>
					            <input name="super_price" type="checkbox" class="checkbox" {if $Item->super_price}checked{/if} value='1'/><span class="akt">Супер-цена (цена не обновляется)</span>
                    </td>
									</tr>
                  <tr>
                    <td>
					            <input name="no_discount" type="checkbox" class="checkbox" {if $Item->no_discount}checked{/if} value='1'/><span class="akt">Нет персональной скидки на товар</span>
                    </td>
									</tr>
                  <tr>
                    <td>
										  <input name="show_out_of_stock" type="checkbox" class="checkbox" {if $Item->show_out_of_stock}checked{/if} value='1'/><span class="akt">Показывать в каталоге, если нет в наличии</span>
                    </td>
									</tr>
								</table>
							</div>

                            {if $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 5}
                            <div class="yellow_block" id="order_add_block">
                                <span class="akt">Добавить товар в заказ</span><table>
                                    <tbody><tr>
                                        <td><span class="akt1">Цена</span></td>
                                        <td><span class="akt2">Размер</span></td>
                                        <td><span class="akt2">Заказ</span></td>
                                    </tr>
                                    <tr>
                                        <td><p><input id="order_product_id" value="{$Item->product_id}" type="hidden" class="input5"><input id="order_price" value="{$Item->price|escape}" type="text" class="input4"></p></td>
                                        <td><p><input id="order_size" type="text" class="input4" autocomplete="off"></p></td>
                                        <td><p><select id="order_id">{foreach from=$orders item="order"}<option value="{$order->order_id}">{$order->order_id}</option>{/foreach}</select></p></td>
                                        <td><input id="order_add" type="submit" value="Добавить"></td>
                                    </tr>
                                    <tr>
                                        <span id="order_add_reply"></span>
                                    </tr>
                                </tbody></table>
                            </div>
                            {/if}

							<div class="gray_block" style="position:relative;">
								<table>
								<tr>
									<td class="model2">URL</td>
									<td class="m_t"><p><input name="url" type="text" class="input6" value='{$Item->url}'/></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Title</td>
									<td class="m_t"><p><input name="meta_title"  type="text" class="input6" value='{$Item->meta_title|escape}' maxlength=255/></p></td>
								</tr>
								<tr>
									<td class="model2">Meta Keywords</td>
									<td class="m_t"><p><input name="meta_keywords" type="text" class="input6" value='{$Item->meta_keywords|escape}' maxlength=255/></p></td>
								</tr>
-								<tr>
									<td class="model2">Meta Description</td>
									<td class="m_t">Берется из заметки редактора<input name="meta_description" type="hidden" class="input6" value='' maxlength=255/><!--<p><input name="meta_description" type="text" class="input6" value='{$Item->meta_description|escape}' maxlength=255/></p>--></td>
								</tr>
								<tr>
									<td class="model2">&nbsp;</td>
								</tr>
                <tr>
									<td class="model2">Ссылка на видео Youtube</td>
									<td class="m_t"><p><input name="video" type="text" class="input6" value="{$Item->video}"/></p></td>
								</tr>
                <tr>
									<td class="model2">Видео Vimeo 360</td>
									<td class="m_t"><p><input name="vimeo" type="text" class="input6" value="{$Item->vimeo}"/></p></td>
								</tr>
                <tr>
									<td class="model2">Видео Vimeo 360 женское (только для унисекс-товаров)</td>
									<td class="m_t"><p><input name="vimeo_w" type="text" class="input6" value="{$Item->vimeo_w}"/></p></td>
								</tr>
								<tr>
									<td class="model2">Ссылка на товар в ЦУМе</td>
									<td class="m_t"><p><input name="tsum_url" type="text" class="input6" value="{$Item->tsum_url}"/></p></td>
								</tr>
								<tr>
									<td class="model2">Наличие:<br></td>
									<td class="m_t" style="font-size: 13px;">
                    <div>
                      <p>{foreach from=$items item=i_item}{$i_item->warehouse_name}: <b>{$i_item->size}</b>x{$i_item->quantity}, ш/к {$i_item->barcode}, EAN: {if $i_item->ean == ''}отсутствует{else}{$i_item->ean}{/if}<br>{/foreach}</p>
                      <input id="measuring" type="button" value="Редактировать замеры">
                      <div class="links fatlist" id="measuring_form" style="display:none;top:0;left:0;">
                        <div class="fatlist_title">Редактирование замеров<div class="fatlist_close">Закрыть</div></div>
                        <div class="ajax_result" ></div>
                      </div>
                    </div>
                  </td>
								</tr>
								<tr>
									<td class="model2">&nbsp;</td>
								</tr>
								<tr>
									<td class="model2">Сезон</td>
									<td class="m_t"><p><input name="season" type="text" class="input6" value='{$Item->season|escape}' title="Сезон"/></p></td>
								</tr>
								</table>
								{if $Properties}
								{foreach from=$Properties item=property}
								<table id=properties[{$property->property_id}] class=property_table style='display:block;'>
								<tr>
									<td class="model2"><!--<a class=link href='index.php?section=Property&item_id={$property->property_id}&token={$Token}'>-->{$property->name|escape}</a></td>
									<td class="m_t"><p>
									{if $property->options}
									<select name='properties[{$property->property_id}]'>
										<option value=''>Неопределено</option>
										{foreach item=option from=$property->options}
										<option value='{$option|escape}' {if $option==$property->value}selected{/if}>{$option|escape}</option>
										{/foreach}
									</select>
									{else}
									<input class=input6 type='text' name='properties[{$property->property_id}]' value='{$property->value|escape}'>
									{/if}
									</p></td>
								</tr>
								</table>
								{/foreach}
								{/if}
							</div>

							<script>

							var properties = new Array();

							{foreach item=p from=$Properties}
							properties[{$p->property_id}] = Array({foreach name=pc item=pc from=$p->categories}'{$pc->category_id}'{if !$smarty.foreach.pc.last},{/if}{/foreach});
							{/foreach}

							var price = {if $Item->old_price != 0}0{else}{$Item->price|escape}{/if};
							{literal}

							$("input#price").change(function() {
								if(price != 0){
									$('#old_price').val(price);
								}
							});


							function display_properties(category_id) {
								return false;
								for(var i in properties) {
									if(in_array(category_id, properties[i])) {
										document.getElementById('properties['+i+']').style.display = 'block';
									}
									else {
										document.getElementById('properties['+i+']').style.display = 'none';
									}

								}
							}

							function in_array(what, where) {
								var a=false;
								for(var i=0; i<where.length; i++) {
									if(what == where[i]) {
										a=true;
										break;
									}
								}
								return a;
							}

							display_properties(document.product.category_id.value);
							{/literal}
							</script>


							<p><input type="submit" value="Сохранить" class="submit"/></p>
					</div>


					<div id="over_right">
						<div class="gray_block1">
							<table>
								<tr>
									<td>
								    {if $Item->large_image}
						          <img id=large_image class="image_preview" src='../files/products/{$Item->large_image}?r={math equation="rand(1,1000000)"}' alt=""/>
										{else}
						          <img id=large_image class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
                    <span class="model">Основное изображение №1</span>
									</td>
								</tr>
							</table><br/>
							<table>
								<tr>
									<td>
								    {if $Item->small_image}
									  	<img id=small_image class="image_preview" src='../files/products/{$Item->small_image}?r={math equation="rand(1,1000000)"}' alt=""/>
										{else}
										  <img id=small_image class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
                    <span class="model">Основное изображение №2</span>
									</td>
								</tr>
							</table>
							<br>

              <span class="model">Промо-лук</span>
							<table>
								<tr>
									<td>
									    <input type=hidden value='0' name=delete_promo_image>

								    {if $Item->promo_image}
  										<img id=promo_image class="image_preview" src='../files/products/{$Item->promo_image}?r={math equation="rand(1,1000000)"}' alt=""/>
  										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('promo_image').src='images/no_photo.jpg'; window.document.product.delete_promo_image.value = 1; return false;">Удалить</a></p>
										{else}
						          <img id=promo_image class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<p><input type="file" name="promo_image" class="input7"/></p>
<!--										<p class="mrg_top"><input name="promo_image_url" value="{if $smarty.post.promo_image_url}{$smarty.post.promo_image_url}{else}http://{/if}" type="text" class="input8" /></p>-->
										<p class="mrg_top"><span style="font-size:10px;">Введите путь до картинки вручную <b>без /files/products</b></span><br><input name="promo_image_path" value="" type="text" class="input8"  /></p>
									</td>
								</tr>
							</table>
							<br>


							<p><input type="submit" value="Сохранить" class="submit3"/></p>
						</div>
						<div class="gray_block1" style="margin-top: 20px;">
							<span class="model">Эксклюзивные материалы</span><br />
              <div class="toggler"><span class="show"{if $is_copywriter || $smarty.session.user->user_id == 10405} style='display:none;'{/if}>Показать</span><span class="hide"{if !$is_copywriter && $smarty.session.user->user_id != 10405} style='display:none;'{/if}>Спрятать</span> список</div>
              <div class="toggle"{if $is_copywriter || $smarty.session.user->user_id == 10405} style='display:block;'{/if}>
							{foreach from=$S_materials item=material}
								<nobr><input name="materials[]" type="checkbox" class="checkbox" {if in_array($material->material_id, $item_materials)}checked{/if} value='{$material->material_id}'/><span class="akt">{$material->name}</span></nobr>
							{/foreach}
              </div>
							<p><input type="submit" value="Сохранить" class="submit3"/></p>
						</div>
					</div>
				</div>


				<div class="area">
					<span class="model4">SEO слова (Используйте эти слова при описании)</span>
					<div id="seo_words" style="font-size:14px;">{$Item->seo_words}</div>
				</div>
        <div class="toggler model4" style="font-size:18px;"><span class="show"{if $is_copywriter || $smarty.session.user->user_id == 10405} style='display:none;'{/if}>Показать</span><span class="hide"{if !$is_copywriter && $smarty.session.user->user_id != 10405} style='display:none;'{/if}>Спрятать</span> описания</div>
        <div class="toggle"{if $is_copywriter || $smarty.session.user->user_id == 10405} style='display:block;'{/if}>
				<div class="area">
					<span class="model4">Заметка редактора
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->description) OR (in_array($check_task->description->status, array('new', 'declined', 'need_check')) AND in_array($check_task->description->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->description) OR ($check_task->description->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->description->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->description->status == 'declined' AND !empty($check_task->description->decline_reason)}
						<p>Причина отказа: {$check_task->description->decline_reason}</p>
					{/if}
					<p><textarea id="description" name="description" class="editor_small">{if $Item->description}{$Item->description}{else}{$check_task->description->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Заметка редактора(Английский язык)
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_description) OR (in_array($check_task->eng_description->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_description->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->eng_description) OR ($check_task->eng_description->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->eng_description->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_description->status == 'declined' AND !empty($check_task->eng_description->decline_reason)}
						<p>Причина отказа: {$check_task->eng_description->decline_reason}</p>
					{/if}
					<p><textarea id="eng_description" name="eng_description" class="editor_small">{if $Item->eng_description}{$Item->eng_description}{else}{$check_task->eng_description->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Детали
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->body) OR (in_array($check_task->body->status, array('new', 'declined', 'need_check')) AND in_array($check_task->body->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->body) OR ($check_task->body->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->body->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->body->status == 'declined' AND !empty($check_task->body->decline_reason)}
						<p>Причина отказа: {$check_task->body->decline_reason}</p>
					{/if}
					<p><textarea name="body" class="editor_small" style="height:150px;">{if $Item->body}{$Item->body}{else}{$check_task->body->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Детали(Английский язык)
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_body) OR (in_array($check_task->eng_body->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_body->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->eng_body) OR ($check_task->eng_body->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->eng_body->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_body->status == 'declined' AND !empty($check_task->eng_body->decline_reason)}
						<p>Причина отказа: {$check_task->eng_body->decline_reason}</p>
					{/if}
					<p><textarea name="eng_body" class="editor_small" style="height:150px;">{if $Item->eng_body}{$Item->eng_body}{else}{$check_task->eng_body->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Состав
						{if $is_copywriter AND !empty($Item)}
							{if !((empty($check_task->text_sizes) OR (in_array($check_task->text_sizes->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text_sizes->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->text_sizes) OR ($check_task->text_sizes->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->text_sizes->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
						{/if}
						</span>
						{if $is_copywriter AND !empty($Item) AND $check_task->text_sizes->status == 'declined' AND !empty($check_task->text_sizes->decline_reason)}
							<p>Причина отказа: {$check_task->text_sizes->decline_reason}</p>
						{/if}
					</span>
					<p><textarea name="text_sizes" id="text_sizes" class="editor_small" style="height:150px;">{if $Item->text_sizes}{$Item->text_sizes}{else}{$check_task->text_sizes->text}{/if}</textarea></p>
          <a href='' class="translate" data-text="text_sizes">Перевести</a>
				</div>
				<div class="area">
					<span class="model4">Состав(Английский язык)
						{if $is_copywriter AND !empty($Item)}
							{if !((empty($check_task->eng_text_sizes) OR (in_array($check_task->eng_text_sizes->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text_sizes->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->eng_text_sizes) OR ($check_task->eng_text_sizes->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->eng_text_sizes->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
						{/if}
						</span>
						{if $is_copywriter AND !empty($Item) AND $check_task->eng_text_sizes->status == 'declined' AND !empty($check_task->eng_text_sizes->decline_reason)}
							<p>Причина отказа: {$check_task->eng_text_sizes->decline_reason}</p>
						{/if}
					</span>
					<p><textarea name="eng_text_sizes" class="editor_small" style="height:150px;">{if $Item->eng_text_sizes}{$Item->eng_text_sizes}{else}{$check_task->eng_text_sizes->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Уход
						{if $is_copywriter AND !empty($Item)}
							{if !((empty($check_task->uhod) OR (in_array($check_task->uhod->status, array('new', 'declined', 'need_check')) AND in_array($check_task->uhod->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->uhod) OR ($check_task->uhod->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->uhod->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
						{/if}
						</span>
						{if $is_copywriter AND !empty($Item) AND $check_task->uhod->status == 'declined' AND !empty($check_task->uhod->decline_reason)}
							<p>Причина отказа: {$check_task->uhod->decline_reason}</p>
						{/if}
					</span>
					<p><textarea name="uhod" id="uhod" class="editor_small" style="height:150px;">{if $Item->uhod}{$Item->uhod}{else}{$check_task->uhod->text}{/if}</textarea></p>
          <a href='' class="translate" data-text="uhod">Перевести</a>
				</div>
				<div class="area">
					<span class="model4">Уход(Английский язык)
						{if $is_copywriter AND !empty($Item)}
							{if !((empty($check_task->eng_uhod) OR (in_array($check_task->eng_uhod->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_uhod->copywriter_id, array(0, $smarty.session.user->user_id)))) AND (empty($Item->eng_uhod) OR ($check_task->eng_uhod->copywriter_id == $smarty.session.user->user_id AND in_array($check_task->eng_uhod->status, array('declined', 'need_check')))))}<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
						{/if}
						</span>
						{if $is_copywriter AND !empty($Item) AND $check_task->eng_uhod->status == 'declined' AND !empty($check_task->eng_uhod->decline_reason)}
							<p>Причина отказа: {$check_task->eng_uhod->decline_reason}</p>
						{/if}
					</span>
					<p><textarea name="eng_uhod" class="editor_small" style="height:150px;">{if $Item->eng_uhod}{$Item->eng_uhod}{else}{$check_task->eng_uhod->text}{/if}</textarea></p>
				</div>
				<div style="clear:both;"></div>
        </div>
				<p>
				<input type=hidden name='product_id' value='{$Item->product_id}'>
				<input type="submit" value="Сохранить" class="submitx"/></p>




				<div>
					<span class="model3">Дополнительные изображения</span>
						<div class="gray_block2">

          <input type=hidden value='' name=delete_fotos>
          {section name=foto loop=$FotosNum start=0}
          {assign var="i" value=$smarty.section.foto.index}
          {assign var="fotos" value=$Item->fotos}
          {assign var="foto" value=$fotos[$i]}



							<div class="additional_image">
							<table>
								<tr>
									<td>
									    {if $foto && $Item->product_id}
										<a href='../files/products/{$foto}?r={math equation="rand(1,1000000)"}'><img id=image_{$i} class="image_preview" src='../files/products/{$foto}?r={math equation="rand(1,1000000)"}' alt=""/></a>
										{else}
										<img id=image_{$i} class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									</td>
								</tr>
							</table>
							</div>
          {/section}

						</div>
						<p><input type="submit" value="Сохранить" class="submitx"/></p>

				</div>
				<br/>

				<h2>История просмотров товара</h2>
        <span id="filter_on">Включить фильтр</span><span id="filter_off" style="display:none;">Выключить фильтр</span>
				{foreach from=$product_views item=pv}
					<p {if !$pv->available}class="filter"{/if}>{$pv->date}: <a href="/admin/index.php?section=User&user_id={$pv->user_id}">{$pv->name}</a>{if $pv->int_size || $pv->ru_size}, размер {$pv->ru_size}{if $pv->int_size}({$pv->int_size}){/if}{/if}, цена: {$pv->price_at_the_time}</p>
				{/foreach}
        <br>
        <br>
        <h2>Данные последнего импорта из 1С от {$ImportData->updated}</h2>
				{foreach from=$ImportData->parsed_data item=data key=key}
					<p><b>{$key}</b>: {$data}</p>
				{/foreach}
			</div>
			</form>
{literal}
<script>
$(document).on("click", "#filter_on", function(e) {
  $('.filter, #filter_on').hide();
  $('#filter_off').show();
});
$(document).on("click", "#filter_off", function(e) {
  $('.filter, #filter_on').show();
  $('#filter_off').hide();
});
</script>
{/literal}
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
var meta_title_template = '%category %brand %name';
var meta_keywords_template = '%category, %brand, %name';
var meta_description_template = '%description';

var item_form = document.product;

var meta_title_touched = true;
var meta_keywords_touched = true;
var meta_description_touched = true;
var url_touched = true;

// generating meta_title
function generate_title(template, category, brand, name, description)
{
	return template.replace('%category', category).replace('%brand', brand).replace('%name', name).replace('%description', description).replace(/^\s+/g,"");
}

// generating meta_keywords
function generate_keywords(template, category, brand, name, description)
{
	return template.replace('%category', category).replace('%brand', brand).replace('%name', name).replace('%description', description).replace(/^(,\s)+|\s+$/g,"");
}

// generating meta_title
function generate_description(template, category, brand, name, description)
{
	return template.replace('%category', category).replace('%brand', brand).replace('%name', name).replace('%description', description).replace(/^\s+|\s+$/g,"");
}

// generating meta_title
function generate_url(category, brand, name)
{
	url = name;
	if(brand != '') url = brand+' '+url;
	if(category != '') url = category+' '+url;
	return translit(url);
}


// sel all metatags
function set_meta()
{
	var category_name = item_form.category_id.options[item_form.category_id.selectedIndex].getAttribute('category_name');
	var brand_name = item_form.brand_id.options[item_form.brand_id.selectedIndex].getAttribute('brand_name');
	var product_name = item_form.model.value;

	var product_description = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

	// Meta Title
	if(!meta_title_touched)
		item_form.meta_title.value = generate_title(meta_title_template, category_name, brand_name, product_name, product_description);

	// Meta Keywords
	if(!meta_keywords_touched)
		item_form.meta_keywords.value = generate_keywords(meta_keywords_template, category_name, brand_name, product_name, product_description);

	// Meta Description
	if(!meta_description_touched)
		item_form.meta_description.value = generate_description(meta_description_template, category_name, brand_name, product_name, product_description);

	// Url
	if(!url_touched)
		item_form.url.value = generate_url(category_name, brand_name, product_name, product_description);

}

function translit(url){
	url = url.replace(/[\s]+/gi, '_');
	return url.replace(/[^0-9a-zа-я_]+/gi, '');
}

function autometageneration_init()
{
	tinyMCE.get("description").onChange.add(function(ed, e) { set_meta(); });
	tinyMCE.get("description").onKeyUp.add(function(ed, e) { set_meta(); });

	var product_description = tinyMCE.get("description").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ");

	var category_name = item_form.category_id.options[item_form.category_id.selectedIndex].getAttribute('category_name');
	var brand_name = item_form.brand_id.options[item_form.brand_id.selectedIndex].getAttribute('brand_name');
	var product_name = item_form.model.value;
	var product_description = tinyMCE.get("description").contentDocument.documentElement.textContent;
	if(item_form.meta_title.value == '' || item_form.meta_title.value == generate_title(meta_title_template, category_name, brand_name, product_name, product_description))
		meta_title_touched=false;
	if(item_form.meta_keywords.value == '' || item_form.meta_keywords.value == generate_keywords(meta_keywords_template, category_name, brand_name, product_name, product_description))
		meta_keywords_touched=false;
	if(item_form.meta_description.value == '' || item_form.meta_description.value == generate_description(meta_description_template, category_name, brand_name, product_name, product_description))
		meta_description_touched=false;
	if(item_form.url.value == '' || item_form.url.value == generate_url(category_name, brand_name, product_name, product_description))
		url_touched=false;
}

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

myattachevent(item_form.model, 'keyup',  set_meta);
myattachevent(item_form.model, 'change', set_meta);
myattachevent(item_form.brand_id, 'change',  set_meta);
myattachevent(item_form.category_id, 'change', set_meta);


</script>
{/literal}
<!-- END Autogenerating meta tags -->
{/if}

<!-- Управление товарами /-->

<script>
{literal}
    $(document).on("click", "#order_add", function(e) {
        e.preventDefault();
        if(confirm('Вы уверены, что хотите добавить товар в заказ?')){
          var order_product = {};
          order_product.product_id = $('input#order_product_id').val();
          order_product.order_id = $( "select#order_id" ).find(":selected").text();
          order_product.price = $('input#order_price').val();
          order_product.size = $('input#order_size').val();
          $.post("/admin/index.php?section=Product", {order_add: JSON.stringify(order_product)}, function(reply) {
              $("span#order_add_reply").append("<span style='color:red;margin: 6px;'>Товар добавлен</span>");
              setTimeout(function(){ $('span#order_add_reply').html(''); }, 10000);
          });
        }
    });
    $(document).on("click", "#measuring", function(e) {
        e.preventDefault();
        var product_id = $('input#order_product_id').val();
        $.get("/admin/index.php?section=Product&measuring="+product_id, function(reply) {
            $("div#measuring_form").find('.ajax_result').html(reply);
            $("div#measuring_form").show();
        });
    });
    $(document).on("click touchstart", ".toggler", function(e) {
        e.preventDefault();
        $(this).next(".toggle").slideToggle();
        $(this).find("span.show").toggle();
        $(this).find("span.hide").toggle();
    });
    $(document).on("click touchstart", ".fatlist_close", function() {
        $(this).parents('.links:first').slideUp(); $('#cont').attr('style', '');
    });
    $(document).on("click", ".translate", function(e) {
      e.preventDefault();
      var id = $(this).data('text');
      var text = tinyMCE.get(id).getContent();
      $.get("/admin/index.php?section=Product&y_translate="+text, function(reply) {
        tinyMCE.get("eng_"+id).setContent(reply);
      });
    });
</script>
{/literal}
