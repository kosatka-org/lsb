<SCRIPT src="../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
<LINK href="../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

{include file='tinymce_init.tpl'}

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
      {if in_array('Setup', $user_allowed)}<li><a href="index.php?section=Setup" class="off">параметры</a></li>{/if}
      {if in_array('Currency', $user_allowed)}<li><a href="index.php?section=Currency" class="off">валюты</a></li>{/if}
      <li><a href="index.php?section=DeliveryMethods" class="on">доставка</a></li>
      {if in_array('PaymentMethods', $user_allowed)}<li><a href="index.php?section=PaymentMethods" class="off">оплата</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          <a href="index.php?section=DeliveryMethods">Способы доставки</a> →
      {if $Item->delivery_method_id}
         {$Item->name}
      {else}
        Новый способ доставки
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
	    <img src="./images/icon_truck.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->

	    <!-- Заголовок раздела /-->
        <h1 id="headline">
      {if $Item->delivery_method_id}
        {$Item->name}
      {else}
        Новый способ доставки
      {/if}
        </h1>
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

				<FORM name=product METHOD=POST enctype='multipart/form-data'>
					<div id="over">
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="name" type="text" class="input3" value='{$Item->name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/>
									<nobr><input name=enabled type="checkbox" class="checkbox" {if $Item->enabled}checked{/if} value='1'/><span class="akt">Активна</span></nobr> &nbsp; &nbsp;<br>
									<nobr><input name=is_local type="checkbox" class="checkbox" {if $Item->is_local}checked{/if} value='1'/><span class="akt">Локальная доставка</span></nobr> &nbsp; &nbsp;
									</p></td>
								</tr>
                <tr>
									<td class="model">Англ. название</td>
									<td class="m_t"><p><input name="eng_name" type="text" class="input3" value='{$Item->eng_name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/></p></td>
								</tr>
							</table>



							<div class="yellow_block">
								<table width=100%>
									<tr>
										<td><span class="akt1">Стоимость доставки,</span></td><td><span class="akt1p">Бесплатна от</span></td>
									</tr>
									<tr>
										<td class='td_padding'><input name=price value='{$Item->price|escape}' type="text" class="input4"/> {$MainCurrency->sign}</td>
										<td class='td_padding'><input name=free_from value='{$Item->free_from|escape}' type="text" class="input4"/> {$MainCurrency->sign}</td>
									</tr>
								</table>
							</div>

              <div class="yellow_block">
								<table width=100%>
									<tr>
										<td><span class="akt1">Страховка</span></td><td><span class="akt1p">Комиссия за прием платежа</span></td>
									</tr>
									<tr>
										<td class='td_padding'><input name="insurance" value='{$Item->insurance|escape}' type="text" class="input4"/> %</td>
										<td class='td_padding'><input name="cash_comission" value='{$Item->cash_comission|escape}' type="text" class="input4"/> %</td>
									</tr>
								</table>
							</div>

							<p><input type="submit" value="Сохранить" class="submit"/></p>
					</div>


					<div id="over_right">


						<div class="gray_block1">
							<span class="model">Возможные формы оплаты</span>
							<br>


              {foreach from=$PaymentMethods item=payment_method}
                <input type=checkbox name=payment_methods[{$payment_method->payment_method_id}] value='1' {if $payment_method->enabled}checked{/if}> {$payment_method->name} &nbsp;
                <br>
              {/foreach}

						</div>
					</div>


					<div id="over_right">
						<div class="gray_block1">
							<span class="model">Изображение</span>

							<table>
								<tr>
									<td>
										<input type=hidden value='0' name=delete_image>

										{if $Item->image}
										<img id=image class="image_preview" src='../files/deliveries/{$Item->image}?r={math equation="rand(1,1000)"}' alt=""/>
										<p><img src="./images/cancel1.jpg" alt=""/><a href="#" class="link" onclick="javascript: window.document.getElementById('image').src='images/no_photo.jpg'; window.document.product.delete_image.value = 1; return false;">Удалить</a></p>
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
						</div>
					</div>

				</div>




				<div class="area">
					<span class="model4">Описание</span>
					<p><textarea name="description" class="editor_small">{$Item->description}</textarea></p>
				</div>
        <div class="area">
					<span class="model4">Англ. описание</span>
					<p><textarea name="eng_description" class="editor_small">{$Item->eng_description}</textarea></p>
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
