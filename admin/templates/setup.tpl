<!-- Управление статьями /-->

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
      <li><a href="index.php?section=Setup" class="on">параметры</a></li>
      {if in_array('Currency', $user_allowed)}<li><a href="index.php?section=Currency" class="off">валюты</a></li>{/if}
      {if in_array('DeliveryMethods', $user_allowed)}<li><a href="index.php?section=DeliveryMethods" class="off">доставка</a></li>{/if}
      {if in_array('DeliveryCompanies', $user_allowed)}<li><a href="index.php?section=DeliveryCompanies" class="off">транспортные компании</a></li>{/if}
      {if in_array('PaymentMethods', $user_allowed)}<li><a href="index.php?section=PaymentMethods" class="off">оплата</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> → Параметры
          </a>
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
	    <img src="./images/icon_setup.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->

	    <!-- Заголовок раздела /-->
        <h1 id="headline">Параметры</h1>
        <!-- /Заголовок раздела /-->


      </div>

      <div id="cont_center">


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

        {if $smarty.session.user->group_id == 2}
				<FORM  METHOD=POST enctype='multipart/form-data'>
					<div id="over">
							<table>
                <tr>
									<td class="td_padding"></td>
									<td class="td_padding"><p><button id="deploy-button" style="width: 150px; height: 30px;">Обновить код</button></p></td>
								</tr>
								<tr>
									<td class="td_padding">{$Lang->SITE_NAME}</td>
									<td class="td_padding"><p><input type="text" class="input3" name=site_name value='{$Settings->site_name|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">{$Lang->COMPANY_NAME}</td>
									<td class="td_padding"><p><input type="text" class="input3" name=company_name value='{$Settings->company_name|escape}' /></p></td>
								</tr>
								<tr>
									<td class="td_padding">{$Lang->ADMIN_EMAIL}</td>
									<td class="td_padding"><p><input type="text" class="input3" name=admin_email value='{$Settings->admin_email|escape}' /></p></td>
								</tr>
								<tr>
									<td class="td_padding">Обратный email уведомлений</td>
									<td class="td_padding"><p><input type="text" class="input3" name=notify_from_email value='{$Settings->notify_from_email|escape}' /></p></td>
								</tr>
                <tr>
									<td class="td_padding">Новый сезон</td>
									<td class="td_padding"><p><input type="text" class="input3" name=current_new_season value='{$Settings->current_new_season|escape}' /></p></td>
								</tr>
                <tr>
									<td class="td_padding">Предыдущий сезон</td>
									<td class="td_padding"><p><input type="text" class="input3" name=previous_season value='{$Settings->previous_season|escape}' /></p></td>
								</tr>
								<tr>
									<td class="td_padding">{$Lang->MAIN_PAGE}</td>
									<td class="td_padding"><p>

									    Полная версия:<br>
										<select name=main_section style='font-size:17px;'>
                                          {foreach name=sections item=section from=$Sections}
                                          	{if $section->menu_id==2}
                                            <option value='{$section->url}' {if $Settings->main_section == $section->url}selected{/if}>{$section->name}</option>
                                            {/if}
                                          {/foreach}
										</select>
										<br>
									    Мобильная версия:<br>
										<select name=main_mobile_section style='font-size:17px;'>
                                          {foreach name=sections item=section from=$Sections}
                                          	{if $section->menu_id==3}
                                            <option value='{$section->url}' {if $Settings->main_mobile_section == $section->url}selected{/if}>{$section->name}</option>
                                            {/if}
                                          {/foreach}
										</select>

									</p>
									</td>
								</tr>
								<tr>
									<td class="td_padding">{$Lang->COUNTERS_CODE}</td>
									<td class="td_padding"><p><textarea style='width:350px;height:150px;' name=counters>{$Settings->counters}</textarea></p></td>
								</tr>

								<tr>
									<td class="td_padding">Размер иконки товара</td>
									<td class="td_padding"><p>
									                         <input type="text" class="input4" name=product_thumbnail_width value='{$Settings->product_thumbnail_width|escape}' />
									                         &times;
									                         <input type="text" class="input4" name=product_thumbnail_height value='{$Settings->product_thumbnail_height|escape}' />
									                         пикселей
									                       </p></td>
								</tr>
								<tr>
									<td class="td_padding">Размер картинки товара</td>
									<td class="td_padding"><p>
									                        <input type="text" class="input4" name=product_image_width value='{$Settings->product_image_width|escape}' />
								                             &times;
									                        <input type="text" class="input4" name=product_image_height value='{$Settings->product_image_height|escape}' />
									                        пикселей
									                       </p></td>

								</tr>
								<tr>
									<td class="td_padding">Доп. картинки товара</td>
									<td class="td_padding"><p>
									                        <input type="text" class="input4" name=product_adimage_width value='{$Settings->product_adimage_width|escape}' />
								                             &times;
									                        <input type="text" class="input4" name=product_adimage_height value='{$Settings->product_adimage_height|escape}' />
									                        пикселей
									                       </p></td>

								</tr>
								<tr>
									<td class="td_padding">Качество изображения</td>
									<td class="td_padding"><p><input type="text" class="input4" name=image_quality value='{$Settings->image_quality|escape}' /> (1-100)</p></td>
								</tr>

								<tr>
									<td class="td_padding">Товаров на странице</td>
									<td class="td_padding"><p>на сайте: <input type="text" class="input5" name=products_num value='{$Settings->products_num|escape}' /> в админке: <input type="text" class="input5" name=products_num_admin value='{$Settings->products_num_admin|escape}' /></p></td>
								</tr>


								<tr>
									<td class="td_padding">Автозаполнение метатегов</td>
									<td class="td_padding"><p>
									<input type=checkbox name=meta_autofill value='1' {if $Settings->meta_autofill==1}checked{/if}> Заполнять мета-теги автоматически
									</p></td>
								</tr>

								<tr>
									<td class="td_padding"></td>
									<td class="td_padding"><p>
									<input id=change_password style='width:20;' type=checkbox name=change_admin_password value='1' {literal}onclick='window.document.getElementById("admin_login").disabled=!this.checked;window.document.getElementById("admin_password").disabled=!this.checked;'{/literal}>
                                    Изменить логин и пароль администратора
									</p></td>
								</tr>
								<tr>
									<td class="td_padding">Новый логин</td>
									<td class="td_padding"><p><input class='input3' disabled id=admin_login type=text name=admin_login value=''/></p></td>
								</tr>
								<tr>
									<td class="td_padding">Новый пароль</td>
									<td class="td_padding"><p><input class="input3" disabled id=admin_password type=text name=admin_password value='' /></p></td>
								</tr>
								<tr>
									<td class="td_padding"></td>
									<td class="td_padding"><p>
									<input type='hidden' name='token' value='{$Token}'>
									</td>
								</tr>
							</table>

							<hr />
							<h2>Google авторизация</h2>
							<table>
								<tr>
									<td class="td_padding">client_id</td>
									<td class="td_padding"><p><input type="text" class="input3" name=google_login_client_id value='{$Settings->google_login_client_id|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">client_secret</td>
									<td class="td_padding"><p><input type="text" class="input3" name=google_login_client_secret value='{$Settings->google_login_client_secret|escape}'/></p></td>
								</tr>
							</table>
							<h2>Yandex авторизация</h2>
							<table>
								<tr>
									<td class="td_padding">client_id</td>
									<td class="td_padding"><p><input type="text" class="input3" name=yandex_login_client_id value='{$Settings->yandex_login_client_id|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">client_secret</td>
									<td class="td_padding"><p><input type="text" class="input3" name=yandex_login_client_secret value='{$Settings->yandex_login_client_secret|escape}'/></p></td>
								</tr>
							</table>
							<h2>FB авторизация</h2>
							<table>
								<tr>
									<td class="td_padding">client_id</td>
									<td class="td_padding"><p><input type="text" class="input3" name=fb_login_client_id value='{$Settings->fb_login_client_id|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">client_secret</td>
									<td class="td_padding"><p><input type="text" class="input3" name=fb_login_client_secret value='{$Settings->fb_login_client_secret|escape}'/></p></td>
								</tr>
							</table>
							<h2>VK авторизация</h2>
							<table>
								<tr>
									<td class="td_padding">ID приложения</td>
									<td class="td_padding"><p><input type="text" class="input3" name=vk_login_client_id value='{$Settings->vk_login_client_id|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">Защищенный ключ</td>
									<td class="td_padding"><p><input type="text" class="input3" name=vk_login_client_secret value='{$Settings->vk_login_client_secret|escape}'/></p></td>
								</tr>
							</table>
							<h2>OK авторизация</h2>
							<table>
								<tr>
									<td class="td_padding">Application ID</td>
									<td class="td_padding"><p><input type="text" class="input3" name=ok_login_client_id value='{$Settings->ok_login_client_id|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">Публичный ключ</td>
									<td class="td_padding"><p><input type="text" class="input3" name=ok_login_public_key value='{$Settings->ok_login_public_key|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">Секретный ключ</td>
									<td class="td_padding"><p><input type="text" class="input3" name=ok_login_client_secret value='{$Settings->ok_login_client_secret|escape}'/></p></td>
								</tr>
							</table>
							<h2>Mail авторизация</h2>
							<table>
								<tr>
									<td class="td_padding">ID</td>
									<td class="td_padding"><p><input type="text" class="input3" name=mail_login_client_id value='{$Settings->mail_login_client_id|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">Публичный ключ</td>
									<td class="td_padding"><p><input type="text" class="input3" name=mail_login_private_key value='{$Settings->mail_login_private_key|escape}'/></p></td>
								</tr>
								<tr>
									<td class="td_padding">Секретный ключ</td>
									<td class="td_padding"><p><input type="text" class="input3" name=mail_login_client_secret value='{$Settings->mail_login_client_secret|escape}'/></p></td>
								</tr>
							</table>
							<h2>RFI авторизация</h2>
							<table>
								<tr>
									<td class="td_padding">Переключить</td>
									<td class="td_padding">
										<p>
											<select name=rfi_login_id id="rfi_login_id" class="input3">
												{foreach from=$rfi_ids item=rfi}
													<option value="{$rfi->login_id}" {if $rfi_active == $rfi->login_id}selected{/if}><b>Аккаунт {$rfi->value}</b></option>
												{/foreach}
											</select>
										</p>
									</td>
								</tr>

							</table>
							<input type="submit" value="Сохранить" class="submit"/></p>


			  </div>
			</form>
      {/if}


    </div>
  </div>
</div>
<script language="javascript">
{literal}
    $(document).ready(function(){
  		$("#rfi_login_id").change(function(){
  			$(".hkey").hide();
  			$("#h"+$(this).val()).show();
  		});
      $()
    });

    $(document).on("click", "#deploy-button", function(e) {
      e.preventDefault();
      var t = $(this);
      if (window.confirm("Обновить код из git master?")) {
        $.post("/admin/index.php?section=Setup", {code_deploy: 1}, function(res) {
          if (res == "OK") {
            t.replaceWith('Код сайта будет обновлён в течение минуты');
          }
        });
      }
    });

</script>
{/literal}
<!-- Content #End /-->
