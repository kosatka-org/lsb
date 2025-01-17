<ul id="inserts">
	{if in_array('Sections', $user_allowed)}<li><a href="index.php?section=Sections" {if $active == 'sections'}class="on"{else}class="off"{/if}>страницы</a></li>{/if}
	{* if in_array('Cities', $user_allowed)}<li><a href="index.php?section=NewsLine" {if $active == 'news'}class="on"{else}class="off"{/if}>новости</a></li>{/if *}
	{if in_array('Cities', $user_allowed)}<li><a href="index.php?section=Cities" {if $active == 'cities'}class="on"{else}class="off"{/if}>города</a></li>{/if}
	{if in_array('Articles', $user_allowed)}<li><a href="index.php?section=Articles" {if $active == 'articles'}class="on"{else}class="off"{/if}>статьи</a></li>{/if}
	{if in_array('Specials', $user_allowed)}<li><a href="index.php?section=Specials" {if $active == 'specials'}class="on"{else}class="off"{/if}>подборки</a></li>{/if}
	{if in_array('Swd', $user_allowed)}<li><a href="index.php?section=Swd" {if $active == 'swd'}class="on"{else}class="off"{/if}>СВД</a></li>{/if}
	{if in_array('SaleSettings', $user_allowed)}<li><a href="index.php?section=SaleSettings" {if $active == 'sale_settings'}class="on"{else}class="off"{/if}>Настройки Sale</a></li>{/if}
	{if in_array('Faqs', $user_allowed)}<li><a href="index.php?section=Faqs" {if $active == 'faqs'}class="on"{else}class="off"{/if}>Вопрос-ответ</a></li>{/if}
	{if in_array('NewsLine', $user_allowed)}<li><a href="index.php?section=NewsLine" {if $active == 'news'}class="on"{else}class="off"{/if}>Новости</a></li>{/if}
	{if in_array('Video', $user_allowed)}<li><a href="index.php?section=Video" {if $active == 'video'}class="on"{else}class="off"{/if}>Видео</a></li>{/if}
</ul>
