{$page->body}
{if $page->url == "mobile_faq" || $page->url == "mobile_payment" || $page->url == "mobile_delivery"}
	<a href="/index.php?module=Cart&amp;call_me" title="Задать вопрос" alt="Задать вопрос">
		<div class="button button320px button_text" style="margin: 50px 0 10px 160px;">Задать вопрос</div>
	</a>
{/if}