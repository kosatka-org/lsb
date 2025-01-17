{if $news_generated}
	{foreach from=$news_generated item=feed}
		<div class="feed_item2">
			{if $feed->new}<div class="feed_new">{$feed->new|date_format:"%B %Y"}</div>{/if}
			<div class="feed_date"><a href='{$feed->url}' target='_blank'>{$feed->date|date_format:"%e.%m"}</a></div>
			<div class="feed_text">{$feed->text}</div>
		</div>
	{/foreach}
	
{else}
	<p>За этот месяц не произошло ничего интересного...</p>
{/if}