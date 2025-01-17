<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='Copywriter_menu.tpl' active='stat'}
  <!-- /Вкладки /-->
   
</div>

<!-- Content #Begin /-->
<div id="content" style="position: relative;">
  <div id="cont_border">
    <div id="cont">
     
      <div id="cont_top">
        <!-- Иконка раздела /--> 
	    <img src="./images/icon_users.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">Статистика копирайтеров</h1>
        <!-- /Заголовок раздела /-->
		
      </div>
	  
      <div id="cont_center" style="margin-top:30px;">
	  
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
          
            $('#filter input[name="date_start"], #filter input[name="date_finish"]').datepicker({
              regional:'ru'
            });
          });
        </script>
        {/literal}
        <form method="post" id="filter">
          <p style="padding:5px;">Фильтр по дате: <input name="date_start" type="text" class="input3" style="width:150px;" value='{if empty($filter->date_start)}{$smarty.now-86400*31|date_format:"%Y-%m-%d"}{else}{$filter->date_start}{/if}' /> - <input name="date_finish" type="text" class="input3" style="width:150px;" value='{if empty($filter->date_finish)}{$smarty.now|date_format:"%Y-%m-%d"}{else}{$filter->date_finish}{/if}' /></p>
          <p style="padding:5px; text-align:right;"><input type="submit" name="filter" value="Фильтр" /></p>
        </form>
      
        {if $copywriters}
          <table id="list" style="width:800px;">
            <tr>
              <td valign="top">
                Копирайтер
              </td>
              <td valign="top" style="padding:0 15px;">
                Кол-во текстов
              </td>
              <td valign="top" style="padding:0 15px;">
                Кол-во символов
              </td>
              <td valign="top" style="padding:0 15px;">
                Средний текст
              </td>
              <td valign="top" style="padding:0 15px;">
                За текст (рублей)
              </td>
              <td valign="top" style="padding:0 15px;">
                Зарплата (рублей)
              </td>
            </tr>
            {foreach item=copywriter from=$copywriters}
              <tr>
                <td valign="top">
                  <div class="slide-toggle" style="color: blue;">{$copywriter->copywriter_name|escape}</div>
                  {if $copywriter->texts}
                  <div class="links fatlist" style="display:none;">
                    <div class="fatlist_title">{$copywriter->copywriter_name|escape}<div class="fatlist_close">Закрыть</div></div>
                    {foreach from=$copywriter->texts item=text}
                      <a href="/admin/index.php?{$text->link}" target="_blank">{$text->date_write|substr:0:10} ID {$text->id}</a>: {$text->name}<br>
                    {/foreach}
                  </div>
                  {/if}
                </td>
                <td valign="top" style="padding:0 15px; text-align:right;">
                  {$copywriter->text_cont}
                </td>
                <td valign="top" style="padding:0 15px; text-align:right;">
                   {$copywriter->text_len}
                </td>
                <td valign="top" style="padding:0 15px; text-align:right;">
                   {$copywriter->text_avg}
                </td>
                <td valign="top" style="padding:0 15px; text-align:right;">
                   {$copywriter->amount/$copywriter->text_cont}
                </td>
                <td valign="top" style="padding:0 15px; text-align:right;">
                  {$copywriter->amount}
                </td>
              </tr>
            {/foreach}
            <tr>
              <td valign="top">
                <div class="slide-toggle" style="color: blue;">Английские тексты</div>
              </td>
              <td valign="top" style="padding:0 15px; text-align:right;">
                {$eng_t}
              </td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
          </table>
        {/if}
      </div>
	
      {literal}
        <script>
          $(document).on("click touchstart", ".slide-toggle", function() {
            if ($('#cont').height() < ($(this).parent().children('.links').height()+240)){
              $('#cont').height($(this).parent().children('.links').height() + 240);
            }
            else{}
            $(this).parent().children('.links').slideDown(); 
          });
          $(document).on("click touchstart", ".fatlist_close", function() { $(this).parents('.links:first').slideUp(); $('#cont').attr('style', ''); });
        </script>
      {/literal}
	  </div>
	</div>
</div>	

