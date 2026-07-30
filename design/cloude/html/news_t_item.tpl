{if $news_texts}
	{foreach from=$news_texts item=feed}
		<div class="feed_item1">
			{if $feed->new}<div class="feed_new">{$feed->new|date_format:"%B %Y"}</div>{/if}
			<div class="feed_wrap">
				<div class="feed_date">{$feed->date|date_format:"%e.%m"}</div>
				<div class="feed_title"><a href='{$feed->url}/' target='_blank'>{$feed->title}</a></div>
				{if $feed->video}
					<div class="feed_text" id="video">{$feed->video}</div>
				{elseif $feed->image}
					<div class="feed_text" id="video"><img src="/files/{$feed->image}"></div>
				{/if}
				<div class="feed_text">{$feed->text}</div>
			</div>
			<div class="shadow">Читать всё</div>
		</div>
	{/foreach}
	
{else}
	<p>За этот месяц не произошло ничего интересного...</p>
{/if}