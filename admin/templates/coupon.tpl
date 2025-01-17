<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='users_menu.tpl' active='coupons'}
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Simpla</a> →
         Новый купон</a>
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
        <h1 id="headline">Новый купон</h1>
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
		{literal}	
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
		<script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
		<script>
			$(function() {
				
				jQuery(function($){
					$.datepicker.regional['ru'] = {
						closeText: 'Закрыть',
						prevText: '&#x3c;Пред',
						nextText: 'След&#x3e;',
						currentText: 'Сегодня',
						monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
						'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
						monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
						'Июл','Авг','Сен','Окт','Ноя','Дек'],
						dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
						dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
						dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
						weekHeader: 'Не',
						dateFormat: 'yy-mm-dd',
						firstDay: 1,
						isRTL: false,
						showMonthAfterYear: false,
						yearSuffix: ''};
					$.datepicker.setDefaults($.datepicker.regional['ru']);
				});
			
				$('input[name="date_start"], input[name="date_finish"]').datepicker({
					regional:'ru'
				});
			});
		</script>
		{/literal}
		<FORM METHOD=POST>
					<div id="over">	
							<table>
								<tr>
									<td class="model">Символов</td>
									<td class="m_t"><p><input name="num_char" type="text" class="input3" style="width:250px;" value='{if empty($num_char)}5{else}{$num_char}{/if}' /></p></td>
								</tr>
								<tr>
									<td class="model">Дата начала</td>
									<td class="m_t"><p><input name="date_start" type="text" class="input3" style="width:250px;" value='{if empty($coupon->date_start)}{$smarty.now|date_format:"%Y-%m-%d"}{else}{$coupon->date_start}{/if}' /></p></td>
								</tr>
								<tr>
									<td class="model">Дата конца</td>
									<td class="m_t"><p><input name="date_finish" type="text" class="input3" style="width:250px;" value='{if empty($coupon->date_finish)}{$smarty.now+86400*31|date_format:"%Y-%m-%d"}{else}{$coupon->date_finish}{/if}' /></p></td>
								</tr>
								<tr>
									<td class="model">Скидка</td>
									<td class="m_t"><p><input name="value" class="input3" type="text" value="{$coupon->value}" style="width:187px;" />
										<select class="input3" name="type" style="width:60px; height:24px;">
											<option value="percentage" {if $coupon->type=='percentage'}selected{/if}>%</option>
											<option value="absolute" {if $coupon->type=='absolute'}selected{/if}>руб.</option>
										</select>
										</p>
									</td>
								</tr>
								<tr>
									<td class="model">Описание</td>
									<td class="m_t"><p><textarea class="input3" style="height:150px;" name="text">{$question->text|escape}</textarea></p></td>
								</tr>
							</table>						
							<p><input type="submit" value="Создать" class="submit3" name="coupon_add" /></p>			
				</div>
		
			</form>

		
	  </div>
	
	 </div>
	</div>
</div>	
 