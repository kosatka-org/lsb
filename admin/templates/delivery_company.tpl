<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
      {if in_array('Setup', $user_allowed)}<li><a href="index.php?section=Setup" class="off">параметры</a></li>{/if}
      {if in_array('Currency', $user_allowed)}<li><a href="index.php?section=Currency" class="off">валюты</a></li>{/if}
      <li><a href="index.php?section=DeliveryCompanies" class="on">ТК</a></li>
      {if in_array('PaymentMethods', $user_allowed)}<li><a href="index.php?section=PaymentMethods" class="off">оплата</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          <a href="index.php?section=DeliveryCompanies">Транспортные компании</a> →
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
	      <img src="./images/icon_truck.jpg" alt="" class="line"/>
        <h1 id="headline">
        {$Item->name}
        </h1>
      </div>

      <div id="cont_center">
				<FORM name=product METHOD=POST enctype='multipart/form-data'>
					<div id="over">
					<div id="over_left">
							<table>
								<tr>
									<td class="model">Название</td>
									<td class="m_t"><p><input name="name" type="text" class="input3" value='{$Item->name|escape}' format='.+' notice='{$Lang->ENTER_NAME}'/>
									<nobr><input name="active" type="checkbox" class="checkbox" {if $Item->active}checked{/if} value='1'/><span class="akt">Активна</span></nobr> &nbsp; &nbsp;<br>
									</p></td>
								</tr>
                <tr>
									<td class="model">Email</td>
									<td class="m_t"><p><input name="email" type="text" class="input3" value='{$Item->email|escape}'/></p></td>
								</tr>
                <tr>
									<td class="model">Телефон</td>
									<td class="m_t"><p>
                    <input name="phone" type="text" class="input3" value='{$Item->phone|escape}'/>
									</p></td>
								</tr>
                <tr>
									<td class="model">ID календаря</td>
									<td class="m_t"><p>
                    <input name="calendar_id" type="text" class="input3" value='{$Item->calendar_id|escape}'/>
									</p></td>
								</tr>
                <tr>
									<td class="model">Адрес</td>
									<td class="m_t"><p>
                    <textarea name="address" rows="6" cols="50">{$Item->address|escape}</textarea>
									</p></td>
								</tr>
                <tr>
									<td class="model">Номер договора</td>
									<td class="m_t"><p>
                    <input name="dogovor_number" type="text" class="input3" value='{$Item->dogovor_number|escape}'/>
									</p></td>
								</tr>
                <tr>
									<td class="model">User ID</td>
									<td class="m_t"><p>
                    <input name="user_id" type="text" class="input3" value='{$Item->user_id}'/>
									</p></td>
								</tr>
							</table>

							<p><input type="submit" value="Сохранить" class="submit"/></p>
					</div>

					{* <div id="over_right">
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
								</tr>
							</table>
						</div>
					</div> *}

				</div>

        <div class="area">
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
