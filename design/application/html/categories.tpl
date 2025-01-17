<a href="/catalog/?category_url={$fcat->url}&show_all=1" title="{$fcat->name}" alt="{$fcat->name}">
	<div class="main_button">
		<span style="text-transform: uppercase;">Все</span>
	</div>
</a>
{foreach from=$filtercategories item=category key=index}
	<a href="/categories/{$category->url}/" class="transition" title="{$category->name}" alt="{$category->name}">
		<div class="main_button"> 
			<span style="text-transform: uppercase;">{$category->name|upper} ({if $manOrWoman == 2}{$category->prod_count_w}{else}{$category->prod_count_m}{/if})</span>
		</div>
	</a>
{/foreach}
{literal}
<script>
//изменение высоты блоков категорий в зависимости от ширины экрана
$(document).ready (function () {
	function height_menu ()
	{
		var width_screen = $(window).width ();
		var blocks = $('.main_button');
		var _span = null;
		var _height = 0;
		var _height_str = '';
		for (var i = 0; i < blocks.length; i++)
		{
		//	if (!$(blocks [i]).find ('.v_divider'))		//если это не главное меню с опцией SALE
		//	{
				_span = $(blocks [i]).find ('span');
				if ($(_span).height () > 49)
				{
					_height = $(_span).height () + 48;
					_height_str = _height.toString () + 'px';
					$(blocks[i]).css({'height' : _height_str});
				}
				else 
				{
					$(blocks[i]).css({'height': '96px'});
				}
		//	}
	/*		else
			{
				if (width_scren < 575)
				{
					$(blocks [i]).find ('.v_divider').remove();
					var links = $(blocks [i]).find ('a');
					$(links [2]).remove ();
					$(blocks [i]).after (links [2]);
				}
				else
				{
					
				}
			}*/
		}
	}
	height_menu ();
	$(window).resize (height_menu);
});
</script>
{/literal}