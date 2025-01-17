{foreach item=category from=$cc}

    <div class="list_left">
      <a href="index.php?section=Categories&set_enabled={$category->category_id}" class="fl"><img src="./images/{if $category->enabled}lamp_on.jpg{else}lamp_off.jpg{/if}" alt="Активность" title="Активность"/></a>
      <div class="padding">
        <div style='padding-left:0px;'>
          <p><a href="index.php?section=Category&item_id={$category->category_id}" class="{if $category->enabled}tovar_on{else}tovar_off{/if}">{$category->name|escape}{if $category->description != ""}*{/if}</a>
			{if $category->type_id}
				{if $category->type_id == 1}Верх{/if}
				{if $category->type_id == 2}Низ{/if}
				{if $category->type_id == 3}Обувь{/if}
			{/if}
      {if $category->canonical_id}
        -> <b>{$category->canonical_name}</b>
      {/if}
		  </p>

          {if $category->enabled}
          <a href="http://{$root_url}/categories/{$category->url}/" class="tovar_min">http://{$root_url}/categories/{$category->url}/</a>
          {else}
          <span class="tovar_min">http://{$root_url}/categories/{$category->url}/</span>
          {/if}
        </div>
      </div>
    </div>
{/foreach}
