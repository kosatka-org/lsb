<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='sections_menu.tpl' active='faqs'}
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
        <h1 id="headline">Вопрос-ответ</h1>
        <!-- /Заголовок раздела /-->
        
        
      </div>

      <div id="cont_center">
	  
		<FORM METHOD=POST>
					<div id="over">		
				
						{if $action_success}
							<p>Данные сохранены. <a href="?section=Faqs&page={$smarty.get.page}">Вернуться назад</a></p>
						{/if}
							<table>
								<tr>
									<td class="model">&nbsp;</td>
									<td class="m_t"><p><label><input name="visible" type="checkbox" value='1' {if $question->visible == 1}checked{/if} /> Активный</label></p></td>
								</tr>
								<tr>
									<td class="model">Имя</td>
									<td class="m_t"><p><input name="user_name" type="text" class="input3" style="width:250px;" value='{$question->user_name}' /></p></td>
								</tr>
								<tr>
									<td class="model">E-mail</td>
									<td class="m_t"><p><input name="user_email" type="text" class="input3" style="width:250px;" value='{$question->user_email}' /></p></td>
								</tr>
								<tr>
									<td class="model">Телефон</td>
									<td class="m_t"><p><input name="user_phone" type="text" class="input3" style="width:250px;" value='{$question->user_phone}' /></p></td>
								</tr>
								<tr>
									<td class="model">Характеристика</td>
									<td class="m_t"><p><input name="user_feature" type="text" class="input3" style="width:250px;" value='{$question->user_feature}' /></p></td>
								</tr>
								<tr>
									<td class="model">Вопрос</td>
									<td class="m_t"><p><textarea class="input3" style="height:150px;" name="question">{$question->question|escape}</textarea></p></td>
								</tr>
								<tr>
									<td colspan="2" class="model">Ответ<p><textarea class="editor_small" style="height:150px;" name="answer">{$question->answer|nl2br}</textarea></p></td>
								</tr>
								<tr>
									<td class="model">Дата</td>
									<td class="m_t"><p><input name="dat" type="text" class="input3" style="width:250px;" value='{$question->dat}' /></p></td>
								</tr>
							</table>						
							<p><input type="submit" value="Сохранить" class="submit3"/></p>			
				</div>
		
			</form>

		
	  </div>
	
	 </div>
	</div>
</div>	
 
 {include file='tinymce_init.tpl'}