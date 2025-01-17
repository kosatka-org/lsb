<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='Copywriter_menu.tpl' active='tasks'}
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          задания копирайтеров</a>
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
        <h1 id="headline">Задачи</h1>
        <!-- /Заголовок раздела /-->    
        
      </div>
	  
	  <div id="cont_left">
        <ul>
			<li {if empty($status)}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasks">Доступные ({$task_counters->new})</a></li>
			<li {if $status == "failed"}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasks&status=failed">На редактировании ({$task_counters->failed})</a></li>
			<li {if $status == "need_check"}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasks&status=need_check">На проверке ({$task_counters->need_check})</a></li>
			<li {if $status == "finished"}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasks&status=finished">Выполненные ({$task_counters->finished})</a></li>
		</ul>
        </div>
        <!-- /Левое меню /-->
		<div id="cont_right" style="margin-top:30px;">
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
			<p style="padding:5px;">Фильтр по дате: <input name="date_start" type="text" class="input3" style="width:150px;" value='{if empty($filter->date_start)}{$smarty.now-86400*31|date_format:"%Y-%m-%d"}{else}{$filter->date_start}{/if}' /> - <input name="date_finish" type="text" class="input3" style="width:150px;" value='{if empty($filter->date_finish)}{$smarty.now|date_format:"%Y-%m-%d"}{else}{$filter->date_finish}{/if}' />&nbsp;<input type="submit" name="filter" value="Фильтр" /></p>
		</form>
		</div>
		<div id="cont_right" style="margin-top:30px;">
		{if $tasks}
        <!-- Форма товаров #Begin /-->
        <form name='products' method="post">
          <table id="list2">
				<tr>
				  <td style="padding:5px;">
					<p>Документ</p>
				  </td>
				  <td style="padding:5px;">
					<p>Поле</p>
				  </td>
				  <td style="padding:5px;">
					<p>Дата</p>
				  </td>
				  <td style="padding:5px;">
					{if in_array($status, array('finished', 'failed'))}<p>Модератор</p> {/if}
				  </td>
				  <td style="padding:5px;">
					{if in_array($status, array('finished', 'failed'))}<p>Дата проверки</p> {/if}
				  </td>
				</tr>	
            {foreach item=task from=$tasks}
				<tr class="tovar_on">		
				  <td style="padding:5px;">
					<p><a href="{if $task->doc_type=="category"}index.php?section=Category&item_id={$task->doc_id}
						{elseif $task->doc_type=="product"}index.php?section=Product&item_id={$task->doc_id}
						{elseif $task->doc_type=="city"}index.php?section=City&id={$task->doc_id}
						{elseif $task->doc_type=="special"}index.php?section=Special&item_id={$task->doc_id}
						{elseif $task->doc_type=="brand-category"}index.php?section=Good&id={$task->doc_id}
						{elseif $task->doc_type=="brand"}index.php?section=Brand&item_id={$task->doc_id}
						{/if}" target="_blank">{$task->doc_type}: {$task->doc_id}</a></p>
				  </td>
				  <td style="padding:5px;">
					<p>{$task->field}</p>
				  </td>
				  <td style="padding:5px;">
					  <p>{$task->date_write}</p>
				  </td>
				  <td style="padding:5px;">
					  {if in_array($task->status, array('accepted', 'declined'))}<p>{$task->moderator_name}</p>{/if}
				  </td>
				  <td style="padding:5px;">
					  {if in_array($task->status, array('accepted', 'declined'))}<p>{$task->data_check}</p>{/if}
				  </td>
				</tr>
				{if $task->status == "declined"}
					<tr><td colspan="5" style="padding:0 5px;">
						{if $task->decline_reason}Причина отказа: {$task->decline_reason|nl2br} - {/if}
						<a href="{if $task->doc_type=="category"}index.php?section=Category&item_id={$task->doc_id}
						{elseif $task->doc_type=="product"}index.php?section=Product&item_id={$task->doc_id}
						{elseif $task->doc_type=="city"}index.php?section=City&id={$task->doc_id}
						{elseif $task->doc_type=="special"}index.php?section=Special&item_id={$task->doc_id}
						{elseif $task->doc_type=="brand-category"}index.php?section=Good&id={$task->doc_id}
						{/if}" target="_blank">переделать!</a>
					</td></tr>
				{/if}
			{/foreach}
          </table>
          </form>
          <!-- Форма Товаров #End /-->
          {else}
            <div class="emptylist">Нет задач</div>
          {/if}
			</div>
	 </div>
	</div>
</div>