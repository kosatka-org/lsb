<SCRIPT src="../js/baloon/js/default.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/validate.js" language="JavaScript" type="text/javascript"></SCRIPT>
<SCRIPT src="../js/baloon/js/baloon.js" language="JavaScript" type="text/javascript"></SCRIPT>
<LINK href="../js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    {if in_array('Storefront', $user_allowed)}<li><a href="index.php?section=Storefront&category={$Category->category_id}{if $smarty.get.brand_id}&brand_id={$smarty.get.brand_id}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}" class="off">товары</a></li>{/if}
    {if in_array('Categories', $user_allowed)}<li><a href="index.php?section=Categories" class="off">категории</a></li>{/if}
    {if in_array('Brands', $user_allowed)}<li><a href="index.php?section=Brands" class="off">бренды</a></li>{/if}
    <li><a href="index.php?section=Colors" class="on">цвета</a></li>
    {if in_array('Goods', $user_allowed)}<li><a href="index.php?section=Goods" class="off">бренд-категория</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          <a href="index.php?section=Storefront">Цвета</a> →
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
        <h1 id="headline">{if $Item->brand_id}{$Item->name}{else}Новый цвет{/if}</h1>
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

							
							
					</div>
					
					
				</div>
				
				
				<p><input type="submit" value="Сохранить" class="submitx"/></p>

				</div>
				<br/><br/>
			</div>
			</form>
			
	 
    </div>
  </div>	    
</div>
<!-- Content #End /--> 