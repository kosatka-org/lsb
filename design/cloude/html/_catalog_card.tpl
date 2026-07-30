{* =====================================================================
   _catalog_card.tpl — карточка товара в сетке каталога.
   Разметка — из catalog.html (.card / .img-wrap / .brand / .name / .price
   / .tags). Все поля $product и условия скидок/бейджей взяты из
   оригинального catalogwall.tpl без изменений логики (только вёрстка).
   Ожидает переменную $product (передаётся через {include ... product=$p}).
   ===================================================================== *}
<div class="card" itemscope itemtype="http://schema.org/Product"
     id="main_{$product->product_id}"
     data-category="{$product->category_id}" data-brand="{$product->brand_id}"
     {if $product->hidden}style="display:none"{/if}>

  <a target="_blank" class="img-wrap"
     href="/{if $big_size}b{/if}products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}">
    <img src="/files/products/{if $product->large_image}{$product->large_image}{else}{$product->second_image}{/if}"
         alt="{$product->model} из Италии и Франции" itemprop="image"
         onerror="this.onerror=null;this.src='/images/noimg.png';">
  </a>

  {if in_array($product->product_id, $cart_products)}
    <img class="cart-badge" src="/images/cart_buy.png" alt="" style="position:absolute;top:12px;left:12px;width:22px;">
  {/if}

  {* TODO: подтвердите реальный урл добавления в избранное с карточки каталога — здесь используется по аналогии с /cart/delete/{id}/, который встречается в cart.tpl *}
  <a href="/cart/wishlist/{$product->product_id}/" class="heart" title="В избранное">&#9825;</a>

  <div class="brand" itemprop="brand">{$product->brand}</div>
  <a target="_blank" class="name" itemprop="name"
     href="/{if $big_size}b{/if}products/{$product->url}/{if $recommended_by}?recommended_by={$recommended_by}{/if}">
    {$product->group_name}
  </a>
  {if $product->model_full}<div style="font-size:12px;opacity:.5;">{$product->model_full}</div>{/if}

  {if $product->size && $product->size != 'Р-р не задан' && $product->size != 'не задан' && !$product->hide_sizes}
    <div class="sizes">
      {foreach from=$product->size|explode:'|' item=sz name=szloop}
        <span>{$sz}</span>
      {/foreach}
    </div>
  {/if}

  {if $product->can_buy_from_site}
    <div class="price" itemscope itemtype="http://schema.org/AggregateOffer">
      {if $product->prices.first_price && $product->show_delta}
        <span itemprop="highPrice">{$product->prices.first_price|string_format:"%.0f"}</span>
        <span class="old">{$product->prices.price|string_format:"%.0f"}</span>
      {elseif $product->prices.sale_price.price > 0}
        <span itemprop="lowPrice">{$product->prices.sale_price.price|string_format:"%.0f"}</span>
        <span class="old">{$product->prices.price|string_format:"%.0f"}</span>
      {elseif $product->prices.vip_price.price > 0}
        <span itemprop="lowPrice">{$product->prices.vip_price.price|string_format:"%.0f"}</span>
        <span class="old">{$product->prices.price|string_format:"%.0f"}</span>
      {else}
        <span itemprop="highPrice">{if $product->size_price}{$product->size_price|string_format:"%.0f"}{else}{$product->prices.price|string_format:"%.0f"}{/if}</span>
      {/if}
      <span>₽</span>
    </div>
  {/if}

  <div class="tags">
    {if $product->season}<span class="accent">{$product->season}</span>{/if}

    {* ВАЖНО: это и есть основной источник тегов под ценой на большинстве
       товаров — в прошлой версии файла эта секция отсутствовала, поэтому
       у большинства карточек .tags был пустым. Взято из оригинала как есть. *}
    {foreach from=$product->characteristics item=characteristic}
      {if ($characteristic->id == 1103 || $characteristic->id == 837 || $characteristic->id == 403016 || $characteristic->id == 11369)}
        {if ($characteristic->value[0] != 'без вставки' && $characteristic->value[0] != 'без покрытия' && $characteristic->value[0] != 'нет')}
          <span title="{$characteristic->name}">{$characteristic->value[0]}</span>
        {/if}
      {/if}
    {/foreach}

    {if ($product->old_price != 0) && ($product->old_price > $product->price) && (($product->old_price-$product->price)/$product->old_price > 0.1)}
      {if $product->no_sale || $furs}
        {* скидка есть, но показывать бейдж нельзя — как и в оригинале *}
      {elseif 'swd'|array_key_exists:$promos && in_array($product->brand_id, explode(",", $promos.swd->brands))}
        <span>скидка выходного дня</span>
      {elseif $product->golden_sale}
        <span>выгодное предложение</span>
      {/if}
    {/if}
    {if $product->old_price != 0 && $product->old_price > $product->price && ($furs || $product->super_price)}
      <span style="color:var(--red);border-color:var(--red);">супер-цена</span>
    {/if}
    {foreach from=$product->s_material item=material}
      <span{if $material->description} title="{$material->description}"{/if}>{$material->name}</span>
    {/foreach}
    {if $product->vimeo}<span>360°</span>{/if}
    {if $product->video}<span>&#9658; video</span>{/if}
  </div>
</div>
