<script src="../third_party/js/ckeditor_standard/ckeditor.js"></script>

<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='sections_menu.tpl' active='specials'}
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
        <h1 id="headline">{if $Item->special_id}{$Item->name}{else}Новая подборка{/if}</h1>
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

				<FORM name=article METHOD=POST enctype='multipart/form-data'>
					<div id="over">
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="name" type="text" class="input3" value='{$Item->name|escape}'/></p></td>
								</tr>
								<tr>
									<td class="model">Англ. Название</td>
									<td class="m_t"><p><input name="eng_name" type="text" class="input3" value='{$Item->eng_name|escape}'/></p></td>
								</tr>
                <tr>
									<td class="model">URL</td>
									<td class="m_t"><p><input name="url" type="text" class="input3" value='{$Item->url|escape}' /></p></td>
								</tr>


								<tr>
									<td></td>
									<td>
									  <nobr><input name=enabled type="checkbox" class="checkbox" {if $Item->enabled}checked{/if} value='1'/><span class="akt">Активна</span></nobr>
									</td>
								</tr>

                <tr>
									<td></td>
									<td>
									  <nobr><input name="sp_sale" type="checkbox" class="checkbox" {if $Item->sale}checked{/if} value='1'/><span class="akt">Товары со скидкой</span></nobr>
									</td>
								</tr>

								<tr>
									<td></td>
									<td>
									  <nobr><input name="look_special" type="checkbox" class="checkbox" {if $Item->look_special}checked{/if} value='1'/><span class="akt">Подборка из луков</span></nobr>
									</td>
								</tr>

								<tr>
								    <td>
									  <input name=gender type="radio" {if $Item->gender == 0}checked="checked"{/if} value='0'/><span class="akt">Пол не выбран</span><br>
									  <input name=gender type="radio" {if $Item->gender == 1}checked="checked"{/if} value='1'/><span class="akt">Мужской</span><br>
									  <input name=gender type="radio" {if $Item->gender == 2}checked="checked"{/if} value='2'/><span class="akt">Женский</span><br>
									</td>
								</tr>
							</table>


							<div class="gray_block">
								<table>
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


							<table>
								<tr>
								    <span class="model">Изображения</span>
									<td>
										<input id="delete_large_image" type=hidden value='0' name=delete_large_image>

										{if $Item->picture}
										<img id="large_image" class="image_preview" src='/files/images/{$Item->picture}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('large_image').src='images/no_photo.jpg'; window.document.getElementById('delete_large_image').value = 1; return false;">Удалить</a></p>
										{else}
										<img id=large_image class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>На страницу подборки</p>
										<p><input type="file" name="image" class="input7"/></p>
									</td>
								</tr>
								<tr>
									<td>
										<input id="delete_small_image" type=hidden value='0' name=delete_small_image>

										{if $Item->small_picture}
										<img id="small_image" class="image_preview" src='/files/images/{$Item->small_picture}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('small_image').src='images/no_photo.jpg'; window.document.getElementById('delete_small_image').value = 1; return false;">Удалить</a></p>
										{else}
										<img id=small_image class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>На главную. Размер 488х290</p>
										<p><input type="file" name="small_image" class="input7"/></p>
									</td>
								</tr>
							</table>
						</div>
					</div>


				<div class="area">
					<span class="model4">SEO слова (Используйте эти слова при описании)</span>
					<div id="seo_words" style="font-size:14px;">{$Item->seo_words}</div>
				</div>

				<div class="area" style="width: 90%;">
					<span class="model4">Описание</span>
					<p><textarea id="textbox" name="description" cols="54" rows="8">{$Item->description}</textarea><br></p>
				  <p>
				  <INPUT NAME=section_id TYPE=HIDDEN VALUE='{$Section->section_id}'>
				</div>

				<div class="area">
					<span class="model4">Параметры запроса</span>
					<p><textarea style="width:700px;height:500px;" name="params">{$Item->query_params}</textarea></p>
					<br><br>
					<span class="model4">Список товаров</span>
					<p><textarea style="width:700px;height:500px;" name="urls">{$Urls}</textarea></p>
				  <p>
				  <INPUT NAME=section_id TYPE=HIDDEN VALUE='{$Section->section_id}'>
				  <input type="submit" value="Сохранить" class="submitx"/></p>
				</div>


				</div>

			</div>
			</form>


    </div>
  </div>
</div>
<!-- Content #End /-->

<script>
CKEDITOR.config.allowedContent=true;
CKEDITOR.config.height = '55em';
CKEDITOR.replace('textbox');
</script>
