<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='Copywriter_menu.tpl' active='tasksM'}
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
<div id="content" style="position:relative;">
  <div id="cont_border">
    <div id="cont">
     <div class="Rtext" id="Rtext"></div>
      <div id="cont_top">
        <!-- Иконка раздела /--> 
	    <img src="./images/icon_users.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline">Задания копирайтеров</h1>
        <!-- /Заголовок раздела /-->
		
		<div class="help2">
            <a href="index.php?section=CopywriterTaskManager&token={$Token}" class="fl"><img src="./images/add.jpg" alt="" class="fl"/>Добавить задание</a>
        </div>

        
        
      </div>
		{include file='tinymce_init.tpl'}
	    <div id="cont_left">
          <ul>
			<li {if $status == "new"}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasksManager&status=new">Новые ({$task_counters->new})</a></li>
			<li {if $status == "need_check"}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasksManager&status=need_check">На проверке ({$task_counters->need_check})</a></li>
			<li {if $status == "failed"}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasksManager&status=failed">На редактировании ({$task_counters->failed})</a></li>
			<li {if $status == "finished"}class="li_on"{/if} style='padding-left:15px;'><a href="?section=CopywriterTasksManager&status=finished">Выполненные ({$task_counters->finished})</a></li>
		  </ul>
        </div>
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
			<p style="padding:5px;">Даты: <input name="date_start" type="text" class="input3" style="width:150px;" value='{if empty($filter->date_start)}{$smarty.now-86400*31|date_format:"%Y-%m-%d"}{else}{$filter->date_start}{/if}' /> - <input name="date_finish" type="text" class="input3" style="width:150px;" value='{if empty($filter->date_finish)}{$smarty.now|date_format:"%Y-%m-%d"}{else}{$filter->date_finish}{/if}' /></p>
			<p style="padding:5px;">Копирайтер: <select name="copywriter_id"><option value="0">Все</option>{foreach from=$copywriters item=copywriter}<option value="{$copywriter->user_id}" {if $filter->copywriter_id == $copywriter->user_id}selected{/if}>{$copywriter->name|escape}</option>{/foreach}</select>&nbsp;<input type="submit" name="filter" value="Фильтр" /></p>
		</form>
		</div>
		<div id="cont_right" style="margin-top:30px;">
		{if $tasks}
          <table id="list2" style="width: 100%;">
				<tr>
				  <td style="padding:5px;">
					<p>Документ</p>
				  </td>
				  <td style="padding:5px;">
					<p>Поле</p>
				  </td>
				  <td style="padding:5px;">
					<p>Копирайтер</p>
				  </td>
				  <td style="padding:5px;">
					<p>Модератор</p>
				  </td>
				  {if in_array($status, array('finished', 'failed'))}
				  <td style="padding:5px;">
					<p>Дата проверки</p>
				  </td>
				  {else}
				  <td style="padding:5px;">
					<p>Ждет проверки</p>
				  </td>
				  {/if}
				  <td style="padding:5px;">
					<p>&nbsp;</p>
				  </td>
				</tr>	
            {foreach item=task from=$tasks}
				<tr class="tovar_on">	
				  <td style="padding:5px;">
					<p><a href="{if $task->status == "new"}index.php?section=CopywriterTaskManager&id={$task->id}
						{elseif $task->doc_type=="category"}index.php?section=Category&item_id={$task->doc_id}
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
					<p>{if $task->copywriter_id}<a href="index.php?section=User&user_id={$task->copywriter_id}" target="_blank">{$task->copywriter_name|escape}</a>{else}Нет{/if}</p>
				  </td>
				  <td style="padding:5px;">
					<p>{if $task->moderator_id}<a href="index.php?section=User&user_id={$task->moderator_id}" target="_blank">{$task->moderator_name|escape}</a>{else}Нет{/if}</p>
				  </td>	
				  {if in_array($status, array('finished', 'failed'))}
				  {if in_array($task->status, array('accepted', 'declined'))}
				  <td style="padding:5px;">
					  <p>{$task->data_check}</p>
				  </td>
				 {/if}
				  {else}
				  <td style="padding:5px;">
					<p>{$task->check2write} days</p>
				  </td>
				  {/if}
				  <td style="padding:5px;">
					<p> {if $task->delete_get}<a href="{$task->delete_get}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg" alt="Удалить" title="Удалить"/></a>{/if}</p>
				  </td>
				</tr>	
				{if $task->status == "need_check"}
					<tr class="tovar_on"><td colspan="10" style="padding:5px;">
						<p>
							{if $task->prod_pic}<a href="index.php?section=Product&item_id={$task->doc_id}" target="_blank"><img src="//lsboutique.ru/reimg/files/products/85x/{$task->prod_pic}" style="float:left;"></a>{/if}
							{$task->text}
						</p>
						<div style="clear:both;"></div>
						<hr />
						<form class="ajax_form" METHOD=POST onSubmit="if(!confirm('Вы уверены?')) return false;">
							<input type="hidden" name="task_id" value="{$task->id}" />
							<p><input type="submit" class="ajax_submit" data-res="Задание принято" value="Принять" name="accepted" /> | <input type="submit" value="Отредактировать" name="edit"  onCLick="$('.edit_reason', $(this).closest('form')).show();return false;"/> | <input type="button" value="Отклонить" onCLick="$('.decline_reason', $(this).closest('form')).show();return false;" />
							</p>
							<div class="area decline_reason" style="display:none;">
								<p><textarea name="decline_reason" cols="40" rows="5" placeholder="Укажите причину отказа">{$task->decline_reason}</textarea></p>
								<input type="submit" class="ajax_submit" data-res="Задание отклонено" value="Отклонить" name="declined" />
							</div>
							<div class="area edit_reason" style="display:none;">
								<p><textarea name="edit_reason" id="{$task->doc_type}{$task->doc_id}" class="editor_big" cols="60" rows="20" placeholder="">{$task->text}</textarea></p>
								<input type="submit" class="ajax_submit" data-res="Изменения сохранены. Задание принято" value="Сохранить и принять" name="save_accepted" />
							</div>
						</form>
					</td></tr>
				{elseif $task->status == "declined"}
					{if $task->decline_reason}
					<tr class="tovar_on"><td colspan="10" style="padding:5px;">
						Причина отказа: {$task->decline_reason|nl2br}
					</td></tr>
					{/if}
				{/if}
				{/foreach}
          </table>
          {else}
            <div class="emptylist">Нет записей</div>
          {/if}
			</div>
	 </div>
	</div>
</div>	
{literal}
<script>

    $(document).on('click', '.ajax_form input.ajax_submit', function() {
		var editorF = ($(this).prev().children('.editor_big')).attr('id');
		var cont = document.getElementById(editorF+'_ifr').contentWindow.document.body.innerHTML;
		$('#' + editorF).html(cont);
		event.preventDefault();
		
		if (confirm('Вы уверены?')){
			var container = $(this).parents('tr.tovar_on'),
				postData = $(this).closest('.ajax_form').serializeArray(),
				Rtext = $(this).attr('data-res'),
				link = '/admin/index.php?section=CopywriterTasksManager&ajax_form';
				var formData = postData.push({
					name: $(this).attr('name'),
					value: $(this).attr('value')
				});
			jQuery.ajax({
				url:link,
				type: "POST",
				data : postData,
				success: function() {
					container.prev().remove();
					container.remove();
					$('#Rtext').show();
					$('#Rtext').html(Rtext);
					setTimeout(function(){
						$('#Rtext').fadeOut(200, function() {$('#Rtext').hide();});
					}, 500)
				}
			})
		}
		return false;
    });
</script>
{/literal}
 