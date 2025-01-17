<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Import" class="on">импорт</a></li>
    {if in_array('Export', $user_allowed)}<li><a href="index.php?section=Export" class="off">экспорт</a></li>{/if}
    {if in_array('Backup', $user_allowed)}<li><a href="index.php?section=Backup" class="off">бекап</a></li>{/if}

  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          Импорт

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
	    <img src="./images/icon_auto.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">Импорт</h1>
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
          
		

           <FORM name=import METHOD=POST enctype='multipart/form-data'>

					
					
					<div id="over">		
					<div id="over_left">	
							<table>
								<tr>
									<td class="model5">Новый импорт</td>
									<td class="m_t"><p><input name="file" type="file" class="input3" /></p></td>
								</tr>
								<tr>
									<td class="model5">Источник</td>
									<td class="model5"><p>
                                    <nobr><input onclick='show_params();' name='format' type="radio" class="checkbox" checked value='csv'/>CSV</nobr><br>									
                                   </td>
								</tr>
							</table>							

					<input type=hidden name=token value='{$Token}'>
			        <input type="submit" value="Загрузить файл" class="submitx2"/>
					<br>
					<br>
					<br>
					<br>
					<br>

					<table>
						<tbody>
							<tr>
								<td class="model5">Загрузка seo-рекоммендаций (файл XLS)</td>
								<td class="m_t"><p><input name="seo_rec" type="file" class="input3"></p></td>
							</tr>
						</tbody>
					</table>
			        <input type=hidden name=token value='{$Token}'>
			        <input type="submit" value="Загрузить файл" class="submitx2"/>
			        <br>
					<br>
					<br>
					<br>
					<br>

					<table>
						<tbody>
							<tr>
								<td class="model5">Загрузка звонков (файл CSV)</td>
								<td class="m_t"><p><input name="calls" type="file" class="input3"></p></td>
							</tr>
						</tbody>
					</table>
					<input type=hidden name=token value='{$Token}'>
			        <input type="submit" value="Загрузить файл" class="submitx2"/>

					<br>
					<br>
					<br>
					<br>
					<br>
			        <input type="button" value="Очистить наличие" onclick="if (confirm('Вы уверены?')) window.location = '/admin/index.php?section=Import&clear_size';" class="submitx2"/>
					<br>
					<br>
					<br>
					<br>
					<br>
			        <input type="button" value="Скрыть без картинок" onclick="if (confirm('Вы уверены?')) window.location = '/admin/index.php?section=Import&hide_without_pictures';" class="submitx2"/>
					</div>					
					
					
			
					<div id="over_right">
						<div class="gray_block1" id='csv_params' name='params_div' style='display:none; font-size:12px;'>
						  
							<table>
								<tr>
									<td class="model5">Разделитель</td>
									<td class="m_t"><p>
									<select name=csv_delimiter class=select2>
									  <option value="	" {if $Settings->csv_import_delimiter == "\t"}selected{/if}>табуляция</option>
									  <option value=';' {if $Settings->csv_import_delimiter == ";"}selected{/if}>точка с запятой (;)</option>
									  <option value=',' {if $Settings->csv_import_delimiter == ","}selected{/if}>запятая (,)</option>
									  <option value='#' {if $Settings->csv_import_delimiter == "#"}selected{/if}>решетка (#)</option>
									</select>
								</tr>
								<tr>
									<td class="model5">Разд. размера</td>
									<td class="m_t"><p>
									<select name=size_delimiter class=select2>
									  <option value=','>запятая (,)</option>
									  <option value=';'>точка с запятой (;)</option>
									  <option value='#' selected>решетка (#)</option>
									</select>
								</tr>
<!--								<tr>
									<td class="model5">Колонки</td>
									<td class="m_t"><p>									
									<a href="#" onclick='window.document.getElementById("csv_columns").value=""; window.document.getElementById("csv_columns").focus(); return false;' class='fr' style='color:black;'><img align=absmiddle alt='очистить все колонки' title='очистить все колонки' border=0 src="./images/clean.jpg" alt=""/>Очистить</a>
		                            </td>
								</tr>-->
								<tr>
									<td class="model5" colspan=2>
									<input name="csv_columns" value='code;ctg;brnd;cat_brand_desc;null;sex;sku;country;sizes;color;size_color;prc;season;disc;location;barcode;sku2;pack_id;ann' type="hidden" class="inputimpcol" />
<!--									<input name="csv_columns" id="csv_columns" value='{$Settings->csv_import_columns}' type="text" class="inputimpcol" />-->
                                    </td>
								</tr>
							</table>
<!--							<br>
							<p class='akt'>Колонки могут иметь следующие значения:</p>

							<table width=100%>
							  <tr>
							    <td width=120><a href='#'  onclick='return append_column("ctg");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> ctg</td>
							    <td>категория товара</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("brnd");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> brnd</td>
							    <td>бренд</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("name");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> name</td>
							    <td>название товара</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("sku");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> sku</td>
							    <td>артикул</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("prc");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> prc</td>
							    <td>цена</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("oprc");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> oprc</td>
							    <td>старая цена</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("qty");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> qty</td>
							    <td>количество на складе</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("ann");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> ann</td>
							    <td>краткое описание</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("dsc");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> dsc</td>
							    <td>полное описание</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("url");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> url</td>
							    <td>URL товара</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("mttl");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> mttl</td>
							    <td>meta title</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("mkwd");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> mkwd</td>
							    <td>meta keywords</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("mdcs");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> mdsc</td>
							    <td>meta description</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("enbld");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> enbld</td>
							    <td>Товар виден на сайте (0 или 1)</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("hit");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> hit</td>
							    <td>Популярный товар  (0 или 1)</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("simg");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> simg</td>
							    <td>Маленькое изображение (имя файла)</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("limg");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> limg</td>
							    <td>Большое изображение (имя файла)</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("imgs");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> imgs</td>
							    <td>Дополнительные изображения (список файлов через запятую)</td>
							  </tr>
							  <tr>
							    <td><a href='#'  onclick='return append_column("null");'><img alt='добавить колонку' title='добавить колонку' src='images/add_mini.gif' border=0 align=absmiddle></a> null</td>
							    <td>Пропустить колонку</td>
							  </tr>
							</table>-->

						</div>
						<div class="gray_block1" id='shopscript_params' name='params_div' style='display:none;'>

						</div>
					</div>
				</div>


				</div>
				<br/><br/>
			</div>
			</form>
	 
    </div>
  </div>	    
</div>
<!-- Content #End /--> 

          {* JAVASCRIPT *}
          <script>
          {literal} 
            function show_params()
            {
              all_divs = document.getElementsByName('params_div');
		      for(i = 0; i < all_divs.length; i++) {
			    all_divs[i].style.display='none';
		      }
            
              var rbuttons = document.getElementsByName('format');
              for (i=0; i < rbuttons.length; i++)
              {
                if (rbuttons[i].checked)
                {
                  var format = rbuttons[i].value;
                }
              }

              div = window.document.getElementById(format+'_params');
              div.style.display='block';
            }
            
            function append_column(str)
            {
              input = window.document.getElementById("csv_columns");
              if(input.value == '')
                input.value = str;
              else
                input.value += ', '+str;
                
              input.scrollLeft=10000;
              return false;
            }
            show_params();
          {/literal}
          </script>
          {* /JAVASCRIPT *}	
