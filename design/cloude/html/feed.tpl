<div class="popUp_leaving"></div>
<div class="left_col">
	<h1 class="col_title">Новости</h1>
	{if $news_texts}
		<div id="news_texts">
			{foreach from=$news_texts item=feed}
				{if $feed->new}<div class="feed_new">{$feed->new|date_format:"%B %Y"}</div>{/if}
				<div class="feed_item1">
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
		</div>
		<div class="moreLink" id="moreLink_text">Предыдущий месяц&nbsp;→</div>
	{else}
		<div id="news_texts">
			<p>За этот месяц не произошло ничего интересного...</p>
		</div>
		<div class="moreLink" id="moreLink_text">Предыдущий месяц&nbsp;→</div>
	{/if}
</div>
<div class="right_col_wrap">
	<h1 class="col_title" style="float: right;">События</h1>
	<div class="right_col">
		{if $news_generated}
			<div id="news_generated">
				{foreach from=$news_generated item=feed}
				{if $feed->new}<div class="feed_new">{$feed->new|date_format:"%B %Y"}</div>{/if}
					<div class="feed_item2">
						<div class="feed_date"><a href='{$feed->url}' target='_blank'>{$feed->date|date_format:"%e.%m"}</a></div>
						{if $feed->anons}<div class="feed_text"><p>{$feed->anons}</p></div>{/if}
						<div class="feed_text">{$feed->text}</div>
					</div>
				{/foreach}
			</div>
			<div class="moreLink" id="moreLink_gen">Предыдущий месяц&nbsp;→</div>
		{else}
			<div id="news_generated">
				<p>За этот месяц не произошло ничего интересного...</p>
			</div>
			<div class="moreLink" id="moreLink_gen">Предыдущий месяц&nbsp;→</div>
		{/if}
	</div>
</div>

{literal}
	<script type="text/javascript">
		jQuery(document).ready(function() {
			var pg = 3;
			var pt = 3;
			jQuery(".feed_item1").each( function(){
				jQuery(this).height($(this).find('#video').height() + $(this).find('.feed_title').height() + 200);
			});
			jQuery("#moreLink_gen").click(function() {
				jQuery.ajax({
					url:"/feed?update_generated_news&period="+pg+"",
					dataType: "html"
				})
				.done(function(html) {
				   jQuery("#news_generated").append(html);
				   pg += 1;
				});
			});
			jQuery("#moreLink_text").click(function() {
				jQuery.ajax({
					url:"/feed?update_text_news&period="+pt+"",
					dataType: "html"
				})
				.done(function(html) {
				   jQuery("#news_texts").append(html);
				   pt += 1;
				});
			});
			jQuery(".shadow").on("click", function() {
				var h = jQuery(this).prev(".feed_wrap").height() + 29;
				var Sh = jQuery(this).prev(".feed_wrap").find('#video').height() + 200;
				if(jQuery(this).parent(".feed_item1").hasClass('hide')) {
					jQuery(this).parent(".feed_item1").animate({height:Sh},1000).removeClass('hide');
					jQuery(this).html("Читать всё");
				} else { 
					jQuery(this).parent(".feed_item1").animate({height:h},1000).addClass('hide');
					jQuery(this).html("Закрыть");
				}
			});
			jQuery(".show_pr").click(function() {
				jQuery(this).prev(".h_products").fadeToggle();
				jQuery(".popUp_leaving").fadeToggle();
			});
			jQuery(".popUp_leaving").click(function() {
				jQuery(".h_products").fadeOut();
				jQuery(this).fadeOut();
			});
			//jQuery(".right_col").height(jQuery(".left_col").height());
		});
	</script>
{/literal}