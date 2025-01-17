<ul id="inserts">
	{if $allowed_admin || $allowed_accountant}<li><a href="index.php?section=Analytics"		{if $active == 'main'}class="on"{else}class="off"{/if}>Аналитика продаж</a></li>{/if}
	{if $allowed_admin || $allowed_accountant}<li><a href="index.php?section=Analytics&cash_report=1"	{if $active == 'cash'}class="on"{else}class="off"{/if}>Отчет по кассам</a></li>{/if}
	<li><a href="index.php?section=Analytics&call_report=1"	{if $active == 'calls'}class="on"{else}class="off"{/if}>Персональные продажи</a></li>
	{if $allowed_admin || $allowed_accountant}<li><a href="index.php?section=Analytics&mtm_report=1"	{if $active == 'mtm'}class="on"{else}class="off"{/if}>Отчет по инд.пошиву</a></li>{/if}
	{if $allowed_admin || $allowed_accountant}<li><a href="index.php?section=Analytics&sales_report=1"	{if $active == 'sales'}class="on"{else}class="off"{/if}>Отчет по продажам</a></li>{/if}
</ul>
