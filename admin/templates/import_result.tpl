<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Import" class="on">импорт</a></li>
    <li><a href="index.php?section=Export" class="off">экспорт</a></li>
    <li><a href="index.php?section=Backup" class="off">бекап</a></li>

  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          Имрорт

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
        <h1 id="headline">Импорт завершен</h1>
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
          
		

					
					<div id="over" style='padding-left:88px; font-size:18px;'>		
						
						Добавлено товаров: {$ProductsAdded}<br>
						Обновлено товаров: {$ProductsUpdated}<br>

					</div>	
			
					
		
	 
    </div>
  </div>	    
</div>
<!-- Content #End /--> 

