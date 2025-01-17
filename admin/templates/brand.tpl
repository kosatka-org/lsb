<SCRIPT src="../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
<LINK href="../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    {if in_array('Storefront', $user_allowed)}<li><a href="index.php?section=Storefront&category={$Category->category_id}{if $smarty.get.brand_id}&brand_id={$smarty.get.brand_id}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}" class="off">товары</a></li>{/if}
    {if in_array('Categories', $user_allowed)}<li><a href="index.php?section=Categories" class="off">категории</a></li>{/if}
    <li><a href="index.php?section=Brands" class="on">бренды</a></li>
    {if in_array('Goods', $user_allowed)}<li><a href="index.php?section=Goods" class="off">бренд-категория</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          <a href="index.php?section=Storefront">Бренды</a> →
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
	    <img src="./images/icon_brands.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->

	    <!-- Заголовок раздела /-->
        <h1 id="headline">{if $Item->brand_id}{$Item->name}{else}Новый бренд{/if}</h1>
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

				<FORM name=brand METHOD=POST enctype='multipart/form-data'>
					<div id="over">
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="name" type="text" class="input3" value='{$Item->name|escape}'  format='.+' notice='{$Lang->ENTER_NAME}'/></p></td>
								</tr>

							</table>


							<div class="gray_block">
								<table>
								<tr>
									<td class="model2">URL</td>
									<td class="m_t"><p><input name="url" type="text" class="input6" value='{$Item->url}' /></p></td>
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
                                <tr>
                                    <td class="model2">Заголовок для описания</td>
									<td class="m_t"><p><input name="title_descr" type="text" class="input6" value="{$Item->title_descr}"/></p></td>
                                </tr>
                                <tr>
                                    <td class="model2">Ссылка на видео Youtube</td>
									<td class="m_t"><p><input name="video" type="text" class="input6" value="{$Item->video}"/></p></td>
                                </tr>
								<tr>
									<td class="model">Пол</td>
									<td class="m_t"><p>
										<input type="radio" value="0" name="sex" id="sex0" {if $Item->gender == '0'}checked{/if} ><label for="sex0" style="font-size:14px;">Не определен</label>
										<input type="radio" value="1" name="sex" id="sex1" {if $Item->gender == '1'}checked{/if} ><label for="sex1" style="font-size:14px;">Мужской</label>
										<input type="radio" value="2" name="sex" id="sex2" {if $Item->gender == '2'}checked{/if} ><label for="sex2" style="font-size:14px;">Женский</label>
									</p></td>
								</tr>
								<tr>
									<td class="model">Пониженная скидка (Подиум)</td>
									<td class="m_t"><p>
										<input type="checkbox" name="low_discount" {if $Item->low_discount}checked{/if}>
									</p></td>
								</tr>
							</table>
							</div>

					</div>

					<div id="over_right">
						<div class="gray_block1">
							<span class="model">Изображение</span>

							<table>
								<tr>
									<td>
										<input type="hidden" value='0' name="delete_image">
										{if $Item->image}
											<img id="image" class="image_preview" src='../files/brands/{$Item->image}?r={math equation="rand(1,1000)"}' alt=""/>
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('image').src='images/no_photo.jpg'; window.document.brand.delete_image.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="image" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
                    Для сайта
										<p><input type="file" name="image" class="input7"/></p>
										<p class="mrg_top"><input name='image_url' type="text" class="input8" value="http://" /></p>
									</td>
								</tr>
                <tr>
									<td>
										<input type="hidden" value='0' name="delete_api_image">
										{if $api_image}
											<img id="api_image" class="image_preview" src='{$api_image}' alt=""/>
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('api_image').src='images/no_photo.jpg'; window.document.brand.delete_api_image.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="api_image" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
                    Для приложения<br>
                    <span style="font-size:12px">(455ш|426в, png, прозрачный фон)</span>
										<p><input type="file" name="api_image" class="input7"/></p>
										<p class="mrg_top"><input name='image_url' type="text" class="input8" value="http://" /></p>
									</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_m">
										{if $Item->banner_m}
											<img id="banner_m" class="image_preview" src="/files/brand_banners/{$Item->banner_m}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_m').src='images/no_photo.jpg'; window.document.brand.delete_banner_m.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_m" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Мужской баннер</label>
										<p><input type="file" name="banner_m" class="input7"></p>
									</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_m_r">
										{if $Item->banner_m_r}
											<img id="banner_m_r" class="image_preview" src="/files/brand_banners/{$Item->banner_m_r}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_m_r').src='images/no_photo.jpg'; window.document.brand.delete_banner_m_r.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_m_r" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Мужской баннер(текст справа)</label>
										<p><input type="file" name="banner_m_r" class="input7"></p>
									</td>
								</tr>
                <tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_m_eng">
										{if $Item->banner_m_eng}
											<img id="banner_m_eng" class="image_preview" src="/files/brand_banners/{$Item->banner_m_eng}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_m_eng').src='images/no_photo.jpg'; window.document.brand.delete_banner_m_eng.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_m_eng" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Англоязычный Мужской баннер</label>
										<p><input type="file" name="banner_m_eng" class="input7"></p>
									</td>
								</tr>
                <tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_m_eng_r">
										{if $Item->banner_m_eng_r}
											<img id="banner_m_eng_r" class="image_preview" src="/files/brand_banners/{$Item->banner_m_eng_r}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_m_eng_r').src='images/no_photo.jpg'; window.document.brand.delete_banner_m_eng_r.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_m_eng_r" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Англоязычный Мужской баннер(текст справа)</label>
										<p><input type="file" name="banner_m_eng_r" class="input7"></p>
									</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_w">
										{if $Item->banner_w}
											<img id="banner_w" class="image_preview" src="/files/brand_banners/{$Item->banner_w}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_w').src='images/no_photo.jpg'; window.document.brand.delete_banner_w.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_w" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Женский баннер</label>
										<p><input type="file" name="banner_w" class="input7"></p>
									</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_w_r">
										{if $Item->banner_w_r}
											<img id="banner_w_r" class="image_preview" src="/files/brand_banners/{$Item->banner_w_r}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_w_r').src='images/no_photo.jpg'; window.document.brand.delete_banner_w_r.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_w_r" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Женский баннер(текст справа)</label>
										<p><input type="file" name="banner_w_r" class="input7"></p>
									</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_w_eng">
										{if $Item->banner_w_eng}
											<img id="banner_w_eng" class="image_preview" src="/files/brand_banners/{$Item->banner_w_eng}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_w_eng').src='images/no_photo.jpg'; window.document.brand.delete_banner_w_eng.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_w_eng" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Англоязычный Женский баннер</label>
										<p><input type="file" name="banner_w_eng" class="input7"></p>
									</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" value='0' name="delete_banner_w_eng_r">
										{if $Item->banner_w_eng_r}
											<img id="banner_w_eng_r" class="image_preview" src="/files/brand_banners/{$Item->banner_w_eng_r}" alt="">
											<p>
												<img src="./images/cancel1.jpg" alt=""/>
												<a href="#" class="link" onclick="javascript: window.document.getElementById('banner_w_eng_r').src='images/no_photo.jpg'; window.document.brand.delete_banner_w_eng_r.value = 1; return false;">Удалить</a>
											</p>
										{else}
											<img id="banner_w_eng_r" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
										<label>Англоязычный Женский баннер(текст справа)</label>
										<p><input type="file" name="banner_w_eng_r" class="input7"></p>
									</td>
								</tr>
							</table>
						</div>
					</div>

				</div>

				<div style="clear:both;"></div>

				<p><input type="submit" value="Сохранить" class="submitx"/></p>

				<div class="area">
					<span class="model4">SEO слова (Используйте эти слова при описании)</span>
					<div id="seo_words" style="font-size:14px;">{$Item->seo_words}</div>
				</div>

				<div class="area">
					<span class="model4">Описание
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->description) OR (in_array($check_task->description->status, array('new', 'declined', 'need_check')) AND in_array($check_task->description->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->description)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->description->status == 'declined' AND !empty($check_task->description->decline_reason)}
						<p>Причина отказа: {$check_task->description->decline_reason}</p>
					{/if}
					<p><textarea id="description" name="description" class="editor_small">{if $Item->description}{$Item->description}{else}{$check_task->description->text}{/if}</textarea></p>
				</div>
        <div class="area">
					<span class="model4">Описание Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_description) OR (in_array($check_task->eng_description->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_description->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_description)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}
					</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_description->status == 'declined' AND !empty($check_task->eng_description->decline_reason)}
						<p>Причина отказа: {$check_task->eng_description->decline_reason}</p>
					{/if}
					<p><textarea id="eng_description" name="eng_description" class="editor_small">{if $Item->eng_description}{$Item->eng_description}{else}{$check_task->eng_description->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Описание Мужское
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->description_m) OR (in_array($check_task->description_m->status, array('new', 'declined', 'need_check')) AND in_array($check_task->description_m->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->description_m)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->description_m->status == 'declined' AND !empty($check_task->description_m->decline_reason)}
						<p>Причина отказа: {$check_task->description_m->decline_reason}</p>
					{/if}
					<p><textarea id="description_m" name="description_m" class="editor_small">{if $Item->description_m}{$Item->description_m}{else}{$check_task->description_m->text}{/if}</textarea></p>
				</div>
        
        <div class="area">
					<span class="model4">Описание Мужское Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_description_m) OR (in_array($check_task->eng_description_m->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_description_m->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_description_m)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_description_m->status == 'declined' AND !empty($check_task->eng_description_m->decline_reason)}
						<p>Причина отказа: {$check_task->eng_description_m->decline_reason}</p>
					{/if}
					<p><textarea id="eng_description_m" name="eng_description_m" class="editor_small">{if $Item->eng_description_m}{$Item->eng_description_m}{else}{$check_task->eng_description_m->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Описание Женское
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->description_w) OR (in_array($check_task->description_w->status, array('new', 'declined', 'need_check')) AND in_array($check_task->description_w->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->description_w)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->description_w->status == 'declined' AND !empty($check_task->description_w->decline_reason)}
						<p>Причина отказа: {$check_task->description_w->decline_reason}</p>
					{/if}
					<p><textarea id="description_w" name="description_w" class="editor_small">{if $Item->description_w}{$Item->description_w}{else}{$check_task->description_w->text}{/if}</textarea></p>
				</div>
        
        <div class="area">
					<span class="model4">Описание Женское Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_description_w) OR (in_array($check_task->eng_description_w->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_description_w->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_description_w)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_description_w->status == 'declined' AND !empty($check_task->eng_description_w->decline_reason)}
						<p>Причина отказа: {$check_task->eng_description_w->decline_reason}</p>
					{/if}
					<p><textarea id="eng_description_w" name="eng_description_w" class="editor_small">{if $Item->eng_description_w}{$Item->eng_description_w}{else}{$check_task->eng_description_w->text}{/if}</textarea></p>
				</div>

        <div class="area">
            <span class="model4">Описание для страницы образов
            {if $is_copywriter AND !empty($Item)}
                {if !((empty($check_task->description_looks) OR (in_array($check_task->description_looks->status, array('new', 'declined', 'need_check')) AND in_array($check_task->description_looks->copywriter_id, array(0, $smarty.session.user->user_id))))
                    AND empty($Item->description_looks)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
            {/if}</span>
            {if $is_copywriter AND !empty($Item) AND $check_task->description_looks->status == 'declined' AND !empty($check_task->description_looks->decline_reason)}
                <p>Причина отказа: {$check_task->description_looks->decline_reason}</p>
            {/if}
            <p><textarea id="description_looks" name="description_looks" class="editor_small">{if $Item->description_looks}{$Item->description_looks}{else}{$check_task->description_looks->text}{/if}</textarea></p>
        </div>
        
        <div class="area">
            <span class="model4">Описание для страницы образов Англ
            {if $is_copywriter AND !empty($Item)}
                {if !((empty($check_task->eng_description_looks) OR (in_array($check_task->eng_description_looks->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_description_looks->copywriter_id, array(0, $smarty.session.user->user_id))))
                    AND empty($Item->eng_description_looks)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
            {/if}</span>
            {if $is_copywriter AND !empty($Item) AND $check_task->eng_description_looks->status == 'declined' AND !empty($check_task->eng_description_looks->decline_reason)}
                <p>Причина отказа: {$check_task->eng_description_looks->decline_reason}</p>
            {/if}
            <p><textarea id="eng_description_looks" name="eng_description_looks" class="editor_small">{if $Item->eng_description_looks}{$Item->eng_description_looks}{else}{$check_task->eng_description_looks->text}{/if}</textarea></p>
        </div>

				<div class="area">
					<span class="model4">Рыбный текст: Сумки По умолчанию
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text38) OR (in_array($check_task->text38->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text38->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text38)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text38->status == 'declined' AND !empty($check_task->text38->decline_reason)}
						<p>Причина отказа: {$check_task->text38->decline_reason}</p>
					{/if}
					<p><textarea name="text38" style="width:930px;height:200px;">{if $Item->text38}{$Item->text38}{else}{$check_task->text38->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Сумки По умолчанию Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text38) OR (in_array($check_task->eng_text38->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text38->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text38)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text38->status == 'declined' AND !empty($check_task->eng_text38->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text38->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text38" style="width:930px;height:200px;">{if $Item->eng_text38}{$Item->eng_text38}{else}{$check_task->eng_text38->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Сумки Мужские
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text38_1) OR (in_array($check_task->text38_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text38_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text38_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text38_1->status == 'declined' AND !empty($check_task->text38_1->decline_reason)}
						<p>Причина отказа: {$check_task->text38_1->decline_reason}</p>
					{/if}
					<p><textarea name="text38_1" style="width:930px;height:200px;">{if $Item->text38_1}{$Item->text38_1}{else}{$check_task->text38_1->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Сумки Мужские Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text38_1) OR (in_array($check_task->eng_text38_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text38_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text38_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text38_1->status == 'declined' AND !empty($check_task->eng_text38_1->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text38_1->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text38_1" style="width:930px;height:200px;">{if $Item->eng_text38_1}{$Item->eng_text38_1}{else}{$check_task->eng_text38_1->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Сумки Женские
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text38_2) OR (in_array($check_task->text38_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text38_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text38_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text38_2->status == 'declined' AND !empty($check_task->text38_2->decline_reason)}
						<p>Причина отказа: {$check_task->text38_2->decline_reason}</p>
					{/if}
					<p><textarea name="text38_2" style="width:930px;height:200px;">{if $Item->text38_2}{$Item->text38_2}{else}{$check_task->text38_2->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Сумки Женские Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text38_2) OR (in_array($check_task->eng_text38_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text38_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text38_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text38_2->status == 'declined' AND !empty($check_task->eng_text38_2->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text38_2->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text38_2" style="width:930px;height:200px;">{if $Item->eng_text38_2}{$Item->eng_text38_2}{else}{$check_task->eng_text38_2->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Обувь По умолчанию
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text2) OR (in_array($check_task->text2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text2->status == 'declined' AND !empty($check_task->text2->decline_reason)}
						<p>Причина отказа: {$check_task->text2->decline_reason}</p>
					{/if}
					<p><textarea name="text2" style="width:930px;height:200px;">{if $Item->text2}{$Item->text2}{else}{$check_task->text2->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Обувь По умолчанию Англ
          {if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text2) OR (in_array($check_task->eng_text2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text2->status == 'declined' AND !empty($check_task->eng_text2->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text2->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text2" style="width:930px;height:200px;">{if $Item->eng_text2}{$Item->eng_text2}{else}{$check_task->eng_text2->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Обувь Мужская
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text2_1) OR (in_array($check_task->text2_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text2_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text2_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text2_1->status == 'declined' AND !empty($check_task->text2_1->decline_reason)}
						<p>Причина отказа: {$check_task->text2_1->decline_reason}</p>
					{/if}
					<p><textarea name="text2_1" style="width:930px;height:200px;">{if $Item->text2_1}{$Item->text2_1}{else}{$check_task->text2_1->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Обувь Мужская Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text2_1) OR (in_array($check_task->eng_text2_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text2_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text2_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text2_1->status == 'declined' AND !empty($check_task->eng_text2_1->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text2_1->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text2_1" style="width:930px;height:200px;">{if $Item->eng_text2_1}{$Item->eng_text2_1}{else}{$check_task->eng_text2_1->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Обувь Женская
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text2_2) OR (in_array($check_task->text2_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text2_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text2_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text2_2->status == 'declined' AND !empty($check_task->text2_2->decline_reason)}
						<p>Причина отказа: {$check_task->text2_2->decline_reason}</p>
					{/if}
					<p><textarea name="text2_2" style="width:930px;height:200px;">{if $Item->text2_2}{$Item->text2_2}{else}{$check_task->text2_2->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Обувь Женская Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text2_2) OR (in_array($check_task->eng_text2_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text2_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text2_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text2_2->status == 'declined' AND !empty($check_task->eng_text2_2->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text2_2->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text2_2" style="width:930px;height:200px;">{if $Item->eng_text2_2}{$Item->eng_text2_2}{else}{$check_task->eng_text2_2->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Одежда По умолчанию
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text1) OR (in_array($check_task->text1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text1->status == 'declined' AND !empty($check_task->text1->decline_reason)}
						<p>Причина отказа: {$check_task->text1->decline_reason}</p>
					{/if}
					<p><textarea name="text1" style="width:930px;height:200px;">{if $Item->text1}{$Item->text1}{else}{$check_task->text1->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Одежда По умолчанию Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text1) OR (in_array($check_task->eng_text1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text1->status == 'declined' AND !empty($check_task->eng_text1->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text1->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text1" style="width:930px;height:200px;">{if $Item->eng_text1}{$Item->eng_text1}{else}{$check_task->eng_text1->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Одежда Мужская
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text1_1) OR (in_array($check_task->text1_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text1_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text1_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text1_1->status == 'declined' AND !empty($check_task->text1_1->decline_reason)}
						<p>Причина отказа: {$check_task->text1_1->decline_reason}</p>
					{/if}
					<p><textarea name="text1_1" style="width:930px;height:200px;">{if $Item->text1_1}{$Item->text1_1}{else}{$check_task->text1_1->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Одежда Мужская Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text1_1) OR (in_array($check_task->eng_text1_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text1_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text1_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text1_1->status == 'declined' AND !empty($check_task->eng_text1_1->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text1_1->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text1_1" style="width:930px;height:200px;">{if $Item->eng_text1_1}{$Item->eng_text1_1}{else}{$check_task->eng_text1_1->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Одежда Женская
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text1_2) OR (in_array($check_task->text1_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text1_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text1_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text1_2->status == 'declined' AND !empty($check_task->text1_2->decline_reason)}
						<p>Причина отказа: {$check_task->text1_2->decline_reason}</p>
					{/if}
					<p><textarea name="text1_2" style="width:930px;height:200px;">{if $Item->text1_2}{$Item->text1_2}{else}{$check_task->text1_2->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Одежда Женская Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text1_2) OR (in_array($check_task->eng_text1_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text1_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text1_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text1_2->status == 'declined' AND !empty($check_task->eng_text1_2->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text1_2->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text1_2" style="width:930px;height:200px;">{if $Item->eng_text1_2}{$Item->eng_text1_2}{else}{$check_task->eng_text1_2->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Аксессуары По умолчанию
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text4) OR (in_array($check_task->text4->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text4->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text4)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text4->status == 'declined' AND !empty($check_task->text4->decline_reason)}
						<p>Причина отказа: {$check_task->text4->decline_reason}</p>
					{/if}
					<p><textarea name="text4" style="width:930px;height:200px;">{if $Item->text4}{$Item->text4}{else}{$check_task->text4->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Аксессуары По умолчанию Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text4) OR (in_array($check_task->eng_text4->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text4->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text4)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text4->status == 'declined' AND !empty($check_task->eng_text4->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text4->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text4" style="width:930px;height:200px;">{if $Item->eng_text4}{$Item->eng_text4}{else}{$check_task->eng_text4->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Аксессуары Мужские
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text4_1) OR (in_array($check_task->text4_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text4_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text4_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text4_1->status == 'declined' AND !empty($check_task->text4_1->decline_reason)}
						<p>Причина отказа: {$check_task->text4_1->decline_reason}</p>
					{/if}
					<p><textarea name="text4_1" style="width:930px;height:200px;">{if $Item->text4_1}{$Item->text4_1}{else}{$check_task->text4_1->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Аксессуары Мужские Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text4_1) OR (in_array($check_task->eng_text4_1->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text4_1->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text4_1)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text4_1->status == 'declined' AND !empty($check_task->eng_text4_1->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text4_1->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text4_1" style="width:930px;height:200px;">{if $Item->eng_text4_1}{$Item->eng_text4_1}{else}{$check_task->eng_text4_1->text}{/if}</textarea></p>
				</div>

				<div class="area">
					<span class="model4">Рыбный текст: Аксессуары Женские
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->text4_2) OR (in_array($check_task->text4_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->text4_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->text4_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->text4_2->status == 'declined' AND !empty($check_task->text4_2->decline_reason)}
						<p>Причина отказа: {$check_task->text4_2->decline_reason}</p>
					{/if}
					<p><textarea name="text4_2" style="width:930px;height:200px;">{if $Item->text4_2}{$Item->text4_2}{else}{$check_task->text4_2->text}{/if}</textarea></p>
				</div>
				<div class="area">
					<span class="model4">Рыбный текст: Аксессуары Женские Англ
					{if $is_copywriter AND !empty($Item)}
						{if !((empty($check_task->eng_text4_2) OR (in_array($check_task->eng_text4_2->status, array('new', 'declined', 'need_check')) AND in_array($check_task->eng_text4_2->copywriter_id, array(0, $smarty.session.user->user_id))))
							AND empty($Item->eng_text4_2)) }<span style="color:#f00;"> - не доступно для копирайтера</span>{/if}
					{/if}</span>
					{if $is_copywriter AND !empty($Item) AND $check_task->eng_text4_2->status == 'declined' AND !empty($check_task->eng_text4_2->decline_reason)}
						<p>Причина отказа: {$check_task->eng_text4_2->decline_reason}</p>
					{/if}
					<p><textarea name="eng_text4_2" style="width:930px;height:200px;">{if $Item->eng_text4_2}{$Item->eng_text4_2}{else}{$check_task->eng_text4_2->text}{/if}</textarea></p>
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
var meta_title_template = '%name';
var meta_keywords_template = '%name';
var meta_description_template = '%text';

var item_form = document.brand;

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

// generating meta_title
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
