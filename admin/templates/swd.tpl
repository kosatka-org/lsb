<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='sections_menu.tpl' active='swd'}
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
        <h1 id="headline">Скидка выходного дня</h1>
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
									<td class="model">Акция:</td>
									<td class="m_t"><h2>Скидка выходного дня</h2></td>
								</tr>

								<tr>
									<td class="model">Дата</td>
									<td class="m_t"><input type="text" class="input3" name="date" placeholder="Например, '11-14 сентября'" value="{$Item->date}"></td>
								</tr>

								<tr>
								    <td class="model"></td><td class="m_t"><span class="model">Баннеры</span></td>
							    </tr>

								<tr>
									<td>
										
										{if $Item->main_banner}
										<img id="large_image" class="image_preview" src='/files/images/swd/{$Item->main_banner}' alt=""/>
										{else}
										<img id="main_banner" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>На главную.</p>
										<p><input type="file" name="main_banner" class="input7"/></p>
									</td>
								</tr>

								<tr>
									<td>
										{if $Item->product_banner}
										<img id="product_banner" class="image_preview" src='/files/images/swd/{$Item->product_banner}' alt=""/>
										{else}
										<img id="product_banner" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>На страницу товара.</p>
										<p><input type="file" name="product_banner" class="input7"/></p>
									</td>
								</tr>

								<tr>
									<td>
										{if $Item->promo_banner1}
										<img id="promo_banner1" class="image_preview" src='/files/images/swd/{$Item->promo_banner1}' alt=""/>
										{else}
										<img id="promo_banner1" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>На промо-страницу.</p>
										<p><input type="file" name="promo_banner1" class="input7"/></p>
									</td>
								</tr>

								<tr>
									<td>
										{if $Item->promo_banner2}
										<img id="promo_banner2" class="image_preview" src='/files/images/swd/{$Item->promo_banner2}' alt=""/>
										{else}
										<img id="promo_banner2" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>На промо-страницу.</p>
										<p><input type="file" name="promo_banner2" class="input7"/></p>
									</td>
								</tr>

								<tr>
									<td>
										{if $Item->promo_banner3}
										<img id="promo_banner3" class="image_preview" src='/files/images/swd/{$Item->promo_banner3}' alt=""/>
										{else}
										<img id="promo_banner3" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>На промо-страницу.</p>
										<p><input type="file" name="promo_banner3" class="input7"/></p>
									</td>
								</tr>

								<tr>
									<td>
										{if $Item->catalog_icon}
										<img id="small_image" class="image_preview" src='/files/images/swd/{$Item->catalog_icon}' alt=""/>
										{else}
										<img id="small_image" class="image_preview" src='images/no_photo.jpg' alt=""/>
										{/if}
									</td>
									<td class="pad_l">
									    <p>Иконка для каталога.</p>
										<p><input type="file" name="catalog_icon" class="input7"/></p>
									</td>
								</tr>

								<tr>
									<td></td>
									<td>
									  <nobr><input name="enabled" type="checkbox" class="checkbox" {if $Item->enabled}checked{/if} value='1'/><span class="akt">Активна</span></nobr>
									</p>
									</td>
								</tr>
							</table>

							
							<p><input type="submit" value="Сохранить" class="submit"/></p>
					</div>
					<div id="over_right">
						<div class="gray_block1">
							<table>
								<tr>
								<input type="hidden" id="brands_handler" data-brandlist="{$Item->brands}">
								{foreach from=$brands item=br key=ind}
									<td>
										<label for="brand_{$br->brand_id}">
											<input type="checkbox" name='brands[]' value='{$br->brand_id}' id="brand_{$br->brand_id}">&nbsp;{$br->name}
										</label>
									</td>
									{if ($ind+1)%3 ==0}
										</tr><tr>
									{/if}
								{/foreach}
								</tr>
							</table>
						</div>
					</div>
					

				</div>

			</div>
			</form>
			
	 
    </div>
  </div>	    
</div>
<!-- Content #End /-->
{literal}
<script>
var brands = $('#brands_handler').attr("data-brandlist").split(',');
$.each(brands, function(i,v) {
	$('#brand_'+v).attr('checked', true);
});
</script>
{/literal}