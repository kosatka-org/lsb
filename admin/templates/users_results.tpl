<div class="fatlist_col">
	<div class="fatlist_title">Сайт</div>
	{foreach from=$Results->users2shops_count item=Ushop}
		<div style="clear:both;">
			<div class="list_left slide-toggle">{if $Ushop->shop !=''}{$Ushop->shop}{else}Не указан{/if} - {$Ushop->SoPro}<br>
        <div class="links fatlist" style="display:none;">
          <div class="fatlist_title">{if $Ushop->shop !=''}{$Ushop->shop}{else}Не указан{/if}<div class="fatlist_close">Закрыть</div></div>
          {foreach from=$Ushop->users item=User}
            {$User->last_login_date} - <a href="/admin/index.php?section=User&user_id={$User->user_id}">{$User->user_id} - {$User->name} № карты - {$User->card_number}</a> {if $User->ref_source}Источники: {$User->ref_source}{/if}<br />
          {/foreach}
        </div>
      </div>
		</div>
	{/foreach}
	<br>
	{if $Results->users_with_sizes_count}Пользователей с размерами - {$Results->users_with_sizes_count}<br>{/if}
	{if $Results->users_without_sizes_count}Пользователей без размеров - {$Results->users_without_sizes_count}{/if}
</div>
{if $Results->users2off_shops_count}
<div class="fatlist_col">
	<div class="fatlist_title">Касса</div>
	{foreach from=$Results->users2off_shops_count item=Ushop}
		<a data-shop="{$Ushop->p_location}" data-period="h_year" class="ajax_link">{if $Ushop->p_location !=''}{$Ushop->p_location}{else}Не указан{/if} - {$Ushop->SoPro}</a><br />
	{/foreach}
</div>
{/if}