<ul id="inserts">
	{if in_array('CopywriterTasksManager', $user_allowed)}<li><a href="index.php?section=CopywriterTasksManager&status=need_check" {if $active == 'tasksM'}class="on"{else}class="off"{/if}>&copy; задачи</a></li>{else}
	{if in_array('CopywriterTasks', $user_allowed)}<li><a href="index.php?section=CopywriterTasks&status=failed" {if $active == 'tasks'}class="on"{else}class="off"{/if}>&copy; задачи</a></li>{/if}{/if}
	{if in_array('CopywriterStat', $user_allowed)}<li><a href="index.php?section=CopywriterStat" {if $active == 'stat'}class="on"{else}class="off"{/if}>&copy; статистика</a></li>{/if}
</ul>