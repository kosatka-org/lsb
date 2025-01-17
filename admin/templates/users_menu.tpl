<ul id="inserts">
{if $allowed_admin}
	{if in_array('Users', $user_allowed)}<li><a href="index.php?section=Users"		{if $active == 'users'}class="on"{else}class="off"{/if}>покупатели</a></li>{/if}
	{if in_array('Groups', $user_allowed)}<li><a href="index.php?section=Groups"		{if $active == 'groups'}class="on"{else}class="off"{/if}>группы</a></li>{/if}
	{if in_array('Calls', $user_allowed)}<li><a href="index.php?section=Calls&calls"	{if $active == 'calls'}class="on"{else}class="off"{/if}>Обзвоны</a></li>{/if}
{/if}	
	{if in_array('Coupons', $user_allowed)}<li><a href="index.php?section=Coupons"		{if $active == 'coupons'}class="on"{else}class="off"{/if}>Купоны</a></li>{/if}
	{if in_array('Calls', $user_allowed)}<li><a href="index.php?section=Calls"		{if $active == 'call'}class="on"{else}class="off"{/if}>Звонки</a></li>{/if}
</ul>