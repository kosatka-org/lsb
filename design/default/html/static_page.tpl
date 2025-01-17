{*
  Template name: Статическая страница
  Used by: StaticPage.class.php   
  Assigned vars: $page
*}

{if ($page->section_id == 161)}
<div class="delivery left">
  <h1><strong>Доставка</strong></h1>
  {foreach from=$delivery item=variant}
  <div class="delpic left">{if $variant->image}<img src="/files/deliveries/{$variant->image}">{/if}</div>
  <div class="deltext right"><strong>{$variant->name}</strong><br />
  {$variant->description}</div>
  <div class="delclear"></div>
  {/foreach}
</div>
  
<div class="delivery right">
  <h1><strong>Оплата</strong></h1>
  {foreach from=$payment item=variant}
  <div class="delpic left">{if $variant->image}<img src="/files/payments/{$variant->image}">{/if}</div>
  <div class="deltext right"><strong>{$variant->name}</strong><br />
  {$variant->description}</div>
  <div class="delclear"></div>
  {/foreach}
</div>
  
{/if}

{$page->body}
