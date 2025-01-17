<div id="inserts_all">
  <!-- Вкладки /-->
 {include file='users_menu.tpl' active='calls'} 
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          Покупатели
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
      <img src="./images/icon_users.jpg" alt="" class="line"/>
      <!-- /Иконка раздела /-->
      
      <!-- Заголовок раздела /-->
        <h1 id="headline">Покупатели</h1>
        <!-- /Заголовок раздела /-->
        

      </div>
      <div id="cont_left"></div>
      <div id="cont_right">
      <form method="post" action="index.php?section=Users&calls">
    		<table style="width:100%">
          <tr><td>
            <span style="font-size:16px;">Название обзвона:</span><br>
            <input name="call_name" type="text" class="input3">
          </td></tr>
    			<tr><td>
    				Магазин:<br>
    				<select name="shop">
    				<option value="">Не выбран</option>
    				{foreach item=shop from=$shops}
    					<option value="{$shop->name}">{$shop->name}</option>
    				{/foreach}
    				</select>
    			</td></tr>
    			<tr><td>
    				Пол:<br>
    				<label for="sex_man">	<input name="sex" value="1" type="radio" id="sex_man">Муж</label>
    				<label for="sex_woman">	<input name="sex" value="2" type="radio" id="sex_woman">Жен</label>
    				<label for="sex_body">	<input name="sex" value="0" type="radio" id="sex_body">Неопределен</label>
    			</td></tr>
          <tr><td>
            <span style="font-size:16px;">Бренды через запятую:</span><br>
            <input name="brands" type="text" class="input3">
          </td></tr>
          <tr><td>
            <span style="font-size:16px;">Сумма покупок</span>
            <br>
            От: <input name="sum_min" type="text" class="input3">
             До: <input name="sum_max" type="text" class="input3">
          </td></tr>
          <tr><td>
            <input type="submit" value="Сохранить" class="submit">
          </td></tr>
    		</table>
        </form>
      </div>
      </div>  
    </div>
  </div>      
</div>
<!-- Content #End /--> 