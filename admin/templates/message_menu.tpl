<ul id="inserts">
{if $allowed_admin}
	{if in_array('Users', $user_allowed)}<li><a href="index.php?section=Users&email"		{if $active == 'email'}class="on"{else}class="off"{/if}>Email-рассылка</a></li>{/if}
	{if in_array('Users', $user_allowed)}<li><a href="index.php?section=Users&sms"	{if $active == 'sms'}class="on"{else}class="off"{/if}>СМС-рассылка</a></li>{/if}
	{if in_array('Users', $user_allowed)}<li><a href="index.php?section=Users&push"	{if $active == 'push'}class="on"{else}class="off"{/if}>PUSH-рассылка</a></li>{/if}
	{if in_array('Oneclick', $user_allowed)}<li><a href="index.php?section=Oneclick&email_template=1"	{if $active == 'template'}class="on"{else}class="off"{/if}>Редактировать рассылки</a></li>{/if}
{/if}
</ul>