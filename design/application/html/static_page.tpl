{$page->body}
{if $page->url == "mobile_faq" || $page->url == "mobile_payment" || $page->url == "mobile_delivery"}
	<a href="/index.php?module=Cart&amp;call_me" title="Задать вопрос" alt="Задать вопрос" style="display:none;">
		<div class="button button320px button_text" style="margin: 50px 0 10px 160px;">Задать вопрос</div>
	</a>
	{literal}<style>
	.centered_text {
		margin: 30px 0 0;
	}
	.app_divider{
		width: 100%;
		margin: 5px 0;
		border-bottom: 1px solid #ccc;
	}
	</style>{/literal}
{/if}