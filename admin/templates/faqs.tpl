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
	  
		 {if $questions}
			
            <table id="list">
            
              {foreach item=question from=$questions}
              <tr class="tovar_on">
                <td valign="top" width="40px">
					{if $question->visible == 1}
						<a href="{$question->enable_get}" class="fl"><img src="./images/lamp_on.jpg" alt=""/></a>
					{else}
						<a href="{$question->enable_get}" class="fl"><img src="./images/lamp_off.jpg" alt=""/></a>
					{/if}
                </td>
				<td valign="top">
                  <a href="{$question->answer_get}">{$question->question|escape|nl2br}</a>
                </td>
                <td valign="top" width="120px">
                  {$question->dat}
                </td>
				<td valign="top" width="40px">
					<a href="{$question->delete_get}" class="fl" onclick='if(!confirm("Подтвердите удаление")) return false;'><img src="./images/delete.jpg" title="Удалить"/></a>
                </td>
              </tr>
              {/foreach}
            </table>
		 {/if}
	   {$PagesNavigation}
	  </div>
	
	 </div>
	</div>
</div>	
 