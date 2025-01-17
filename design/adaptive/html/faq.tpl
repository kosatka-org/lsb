<div class="Faq_col">
	<h1>{if $language=='eng'}Questions{else}Вопросы{/if}</h1>
{if $questions}
	{foreach from=$questions item=question}
	<div class="Faq_question_wrap"><div class="Faq_question_point"></div>― {$question->question|escape|nl2br} <br>{$question->user_name}{if $question->user_feature}, {$question->user_feature}{/if}</div>
	<div class="Faq_answer">{$question->answer|nl2br}</div>
	{/foreach}
	
	<!-- Постраничная навигация /-->
	{if $total_pages_num>1}
	<div style="clear:both;"></div>
	<script type="text/javascript" src="js/ctrlnavigate.js"></script>           
	<div id="paging">

	  {if $current_page_num>1}
	  <a id="PrevLink" href="/faq?page={$current_page_num-1}" class="back">←&nbsp;{if $language=='eng'}back{else}назад{/if}</a>
	  {/if}

	  {section name=pages loop=$total_pages_num}
	  <a {if $smarty.section.pages.index==($current_page_num-1)}class="current_page" {/if}href="/faq?page={$smarty.section.pages.index+1}">{$smarty.section.pages.index+1}</a>
	  {/section}
	  
	  {if $current_page_num<$total_pages_num}
	  <a id="NextLink" href="/faq?page={$current_page_num+1}" class="next">{if $language=='eng'}forth{else}вперед{/if}&nbsp;→</a>
	  {/if}

	</div>          
	{/if}
	<!-- Постраничная навигация #End /-->

{else}
	<p style="">Вопросов пока что нет...</p>
{/if}
</div>
<div style="clear:both;"></div>
<div class="ShAA_faqBlock">
	<form>
		<!--<a target="_blank" id="faq" href="/index.php?module=Faq&amp;action=question&amp;clear=true">-->
        <a id="faq" href="/faq/question/">
			<button type="button" class="ShAA_oneClickAdd" style="float: none; margin: 0 auto;">{if $language=='eng'}Ask a question{else}Задайте вопрос{/if}</button>
		</a>
	</form>
</div>
