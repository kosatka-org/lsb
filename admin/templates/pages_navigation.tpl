<div class="peid">
{if $PrevPageUrl}
	<a id="PrevLink" href="{$PrevPageUrl}" class="alink" style="float: left; margin: 0 6px 0 0;">←&nbsp;назад</a>
{/if}
{foreach key=index item=page from=$Pages}
      {if $index!=$CurrentPage}
        <a href="{$page}{if $calls}&calls{/if}" class="peid_off">{$index+1}</a>
      {else}
        <a href="{$page}{if $calls}&calls{/if}" class="peid_on">{$index+1}</a>
      {/if}
{/foreach}

{if $NextPageUrl}
	<a id="NextLink" href="{$NextPageUrl}" class="alink">вперед&nbsp;→</a>
{/if}
</div>
<div style="float: left; width: 100%; margin: 6px 0 0;">Всего {$PagesNum} страниц</div>
