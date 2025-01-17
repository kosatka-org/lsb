<div class="Faq_col">
	<div class="centered_text alert_text">
		Вопрос ответ
	</div>
{if $questions}
	{foreach from=$questions item=question}
	<div class="question item_txt">― {$question->question|escape|nl2br} <br>{$question->user_name}{if $question->user_feature}, {$question->user_feature}{/if}</div>
	<div class="answer item_txt">{$question->answer|nl2br}</div>
	<div class="divider_line"></div>
	{/foreach}
	
	<!-- Постраничная навигация /-->
	{if $total_pages_num>1}
	<div style="clear:both;"></div>
	<script type="text/javascript" src="js/ctrlnavigate.js"></script>           
	<div id="paging">

	  {if $current_page_num>1}
	  <a id="PrevLink" href="/faq?page={$current_page_num-1}" class="back">←&nbsp;назад</a>
	  {/if}

	  {section name=pages loop=$total_pages_num}
	  <a {if $smarty.section.pages.index==($current_page_num-1)}class="current_page" {/if}href="/faq?page={$smarty.section.pages.index+1}">{$smarty.section.pages.index+1}</a>
	  {/section}
	  
	  {if $current_page_num<$total_pages_num}
	  <a id="NextLink" href="/faq?page={$current_page_num+1}" class="next">вперед&nbsp;→</a>
	  {/if}

	</div>          
	{/if}
	<!-- Постраничная навигация #End /-->

{else}
<div class="centered_text alert_text">
	<p style="margin-left:20px;">Вопросов пока что нет...</p>
</div>
{/if}
</div>
<div style="clear:both;"></div>
<div style="margin-left:20px;">
	<form>
		<a target="_blank" id="faq" href="/index.php?module=Faq&amp;action=question"><button type="button" style="height:80px;padding:0;margin: 10px 0 10px 20px;" class="button button560px button_text">Задайте вопрос</button></a>
	</form>
</div>
