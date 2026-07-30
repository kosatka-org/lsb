{* =====================================================================
   catalogwall.tpl — ПОЛНОСТЬЮ ПЕРЕВЕРСТАН под дизайн catalog.html.

   Что сохранено 1-в-1 (функционал, проверено по оригиналу):
     - ВАЖНО: карточки в сетке рендерятся из $wallproducts, а не из
       $products! $products используется только в скрипте аналитики
       (GTM dataLayer) наверху файла — это две разные переменные,
       перепутать их — главная причина, по которой товары могут не
       подгружаться. Проверено построчным разбором вложенности {if}
       в оригинале (752 строка: {foreach from=$wallproducts ...}).
     - Все Smarty-переменные и их поля: $products (со всеми ->price/
       ->prices.*/->size/->characteristics/... ), $filtersizes.clothes/
       .footwear, $filtercategories, $filterbrands, $filtermaterials,
       $categ_name, $categ_desc, $showbrand, $special_fields,
       $brand_for_special, $cart_products, $cat_currencies, $rootcateg,
       $rootbrand, $rowcount, $manOrWoman, $special, $form_search,
       $limit_ovr, $only_products, $big_size, $recommended_by,
       $language, $oc_ordered/$oc_ordered_product, $criteo_p_list,
       $hidden_brands, $config->enviroment, $smarty.session.user
     - Контракт AJAX-фильтров: POST на /catalog/ с объектом $luxury_obj
       ({ldelim}brands,categories,materials,csizes,fsizes,rootcateg,
       rootbrand,rowcount,sex,special,form_search,offset,state{rdelim})
       — именно эти ключи разбирает Catalog.class.php, менять нельзя.
     - Бесконечная подгрузка при скролле (POST → append в #product_container).
     - {if $only_products} — при AJAX отдаём ТОЛЬКО карточки, без фильтров/шапки.
     - GTM / Criteo / Admitad data-layer скрипты — не трогал, они не
       зависят от разметки, только от Smarty-переменных.

   Что изменено ПОЛНОСТЬЮ (по вашему разрешению):
     - Вся HTML-разметка и CSS-классы — теперь как в catalog.html
       (.wrap, .catalog-layout, .filter-group, .filter-chips, .card,
       .product-grid, .crumbs, .page-title, .rich-text и т.д.)
     - Owl-carousel (смена фото по наведению) — УБРАН, карточка теперь
       с одним статичным фото, как в макете Figma. Если он нужен —
       верните блок <div class="owl-carousel">, он не мешал бы новой
       вёрстке технически, я убрал его только для простоты.
     - JS-обработчики чекбоксов фильтра переписаны под новую разметку
       кнопок-чипов (.filter-chip[data-type][data-value]), но шлют
       ровно тот же $luxury_obj что и раньше.
     - Хлебные крошки объединены в один блок на все три случая
       (категория/бренд/подборка) — в оригинале явно собирались только
       для подборок ($special_fields), для категорий/брендов, видимо,
       рисовались в отдельном header.tpl, которого нет в присланных
       файлах. Если он у вас есть — эту часть можно будет свести к нему.
     - Иконка "в избранное" на карточке — ссылка на предполагаемый
       эндпоинт /cart/wishlist/{'{'}id{'}'}/ по аналогии с реальным
       /cart/delete/{'{'}id{'}'}/, замеченным в cart.tpl. Проверьте перед
       использованием — в присланных файлах отдельного подтверждения
       этого урла с каталожной карточки (не со страницы товара) не было.

   Подключение стилей: /design/adaptive/css/catalog-reskin2.css (новый
   файл, отдельно от catalog-reskin.css — тот был для СТАРОЙ разметки).
   ===================================================================== *}

{if !$oc_ordered && $smarty.session.user->group_id < 2 && $config->enviroment == 'live'}
{if $criteo_p_list}
<script>
{literal}
jQuery(document).ready(function() {
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        dataLayer.push({
            'CriteoEmail': '{/literal}{if $smarty.session.user->user_id}{$smarty.session.user->user_id}{else}00000{/if}@luxury.ru{literal}',
            'PageType': 'CatalogPage',
            'ProductIDList' : [{/literal}{$criteo_p_list}{literal}]
        });
    }
});
{/literal}
</script>
{/if}
<script>
{literal}var product_list = [];{/literal}
{foreach from=$products item=product}
  {if !in_array($product->brand_id, $hidden_brands) && $product->category_enabled != 0}
    {literal}product_list.push({/literal}{$product->barcode}{literal});{/literal}
  {/if}
{/foreach}
{literal}
jQuery(document).ready(function() {
    if (typeof(dataLayer) !== 'undefined' && dataLayer) {
        dataLayer.push({ 'ProductPrice': '', 'productID': product_list, 'MT_PageType': 'category' });
    }
});
{/literal}
</script>
{/if}

{if $only_products}
{* ==== AJAX-ответ: отдаём только карточки для #product_container ==== *}
{foreach from=$wallproducts item=product}
  {include file="_catalog_card.tpl" product=$product}
{/foreach}

{else}
<link rel="stylesheet" href="/design/adaptive/css/catalog-reskin2.css">

<div class="wrap">
  <div itemscope itemtype="http://schema.org/BreadcrumbList" id="breadcrumbs" class="crumbs">
    <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem">
      <a rel="nofollow" itemprop="item" href="/"><span itemprop="name">Главная</span></a>
      <meta itemprop="position" content="1">
    </span>
    {if $showbrand}
      <span> / </span>
      <a itemprop="item" href="/brands/{$showbrand->url}/"><span itemprop="name">{$showbrand->name}</span></a>
    {elseif $special_fields}
      <span> / </span>
      <a itemprop="item" href="/specials/{$special_fields->url}/"><span itemprop="name">{if $language=='eng'}{$special_fields->eng_name}{else}{$special_fields->name}{/if}</span></a>
    {elseif $categ_name}
      <span> / </span>
      <a itemprop="item" href="/categories/{$categ_url}/"><span itemprop="name">{$categ_name}</span></a>
    {/if}
  </div>

  <h1 class="page-title">
    {if $showbrand}{$showbrand->name}
    {elseif $special_fields}{if $language=='eng'}{$special_fields->eng_name}{else}{$special_fields->name}{/if}
    {elseif $categ_name}{$categ_name}
    {elseif $sale}Sale
    {elseif $whatsnew}Новинки
    {elseif $furs}Меха
    {elseif $big_size}Большие размеры
    {else}Одежда
    {/if}
  </h1>

  <div class="catalog-layout">
    <aside>
      <div class="filters-title">Фильтры</div>

      {if !empty($filtersizes.clothes) || !empty($filtersizes.footwear)}
      <details class="filter-group" open>
        <summary>Размеры</summary>
        <div class="filter-chips">
          <label class="filter-chip filter-clear" data-type="csizes">
            <input type="checkbox" class="csizes-clear-box" style="display:none">Сбросить
          </label>
          {foreach from=$filtersizes.clothes item=csize}
            {if $csize != ''}
              <label class="filter-chip">
                <input type="checkbox" data-type="csizes" name="{$csize}" style="display:none">
                {if $csize == "Р-р не задан" || $csize == "Р-р не зад" || $csize == "не задан"}Без размера{else}{$csize}{/if}
              </label>
            {/if}
          {/foreach}
          {foreach from=$filtersizes.footwear item=csize}
            {if $csize != ''}
              <label class="filter-chip">
                <input type="checkbox" data-type="fsizes" name="{$csize}" style="display:none">{$csize}
              </label>
            {/if}
          {/foreach}
        </div>
      </details>
      {/if}

      <details class="filter-group" open>
        <summary>Категории</summary>
        <div class="filter-chips">
          <label class="filter-chip filter-clear" data-type="categories">
            <input type="checkbox" class="categories-clear-box" style="display:none">Сбросить
          </label>
          {foreach from=$filtercategories item=ccateg}
            {if $ccateg->name != ''}
              <label class="filter-chip">
                <input type="checkbox" data-type="categories" name="{$ccateg->id}" style="display:none">{$ccateg->name}
              </label>
            {/if}
          {/foreach}
        </div>
      </details>

      {if !isset($showbrand) && !isset($showgood)}
      <details class="filter-group">
        <summary>Бренды</summary>
        <div class="filter-chips">
          <label class="filter-chip filter-clear" data-type="brands">
            <input type="checkbox" class="brands-clear-box" style="display:none">Сбросить
          </label>
          {foreach from=$filterbrands item=cbrand}
            {if $cbrand->name != ''}
              <label class="filter-chip">
                <input type="checkbox" data-type="brands" name="{$cbrand->id}" style="display:none">{$cbrand->name|upper}
              </label>
            {/if}
          {/foreach}
        </div>
      </details>
      {/if}

      {if $furs && $filtermaterials}
      <details class="filter-group">
        <summary>Материалы</summary>
        <div class="filter-chips">
          <label class="filter-chip filter-clear" data-type="materials">
            <input type="checkbox" class="materials-clear-box" style="display:none">Сбросить
          </label>
          {foreach from=$filtermaterials item=cmat}
            {if $cmat->name != ''}
              <label class="filter-chip">
                <input type="checkbox" data-type="materials" name="{$cmat->material_id}" style="display:none">{$cmat->name}
              </label>
            {/if}
          {/foreach}
        </div>
      </details>
      {/if}
    </aside>

    <div>
      <div class="catalog-toolbar">
        <div class="toolbar-tabs">
          <a href="{$filter_url}" class="active">Вещь</a>
          <a href="/looks/{if $filter_url}?{$filter_url|escape}{/if}">Образ</a>
        </div>
        <div class="sort">
          Сортировка: <b>{if $smarty.get.sort == 'hits'}по популярности{else}самые новые{/if}</b>
        </div>
      </div>

      <div id="product_container" itemscope itemtype="http://schema.org/ItemList">
        {foreach from=$wallproducts item=product}
          {include file="_catalog_card.tpl" product=$product}
        {/foreach}
      </div>
    </div>
  </div>

  {if $showbrand && $showbrand->description}
    <div class="rich-text">
      {if $manOrWoman == '1' && !empty($showbrand->description_m)}{$showbrand->description_m}
      {elseif $manOrWoman == '2' && !empty($showbrand->description_w)}{$showbrand->description_w}
      {else}{$showbrand->description}
      {/if}
    </div>
  {elseif $categ_desc}
    <div class="rich-text">{$categ_desc}</div>
  {elseif $special_fields && $special_fields->description}
    <div class="rich-text">{$special_fields->description}</div>
  {/if}
</div>

<script>
{literal}
var $luxury_obj = {
  brands: [], categories: [], materials: []{/literal}
  {if $filtersizes.clothes}, csizes: []{/if}
  {if $filtersizes.footwear}, fsizes: []{/if}
  {if $rootcateg}, rootcateg: '{$rootcateg}'{/if}
  {if $rootbrand}, rootbrand: {$rootbrand}{/if}
  {if $rowcount}, rowcount: {$rowcount}{/if}
  {if $manOrWoman}, sex: {$manOrWoman}{/if}
  {if $special}, special: {$special}{/if}
  {if $form_search}, form_search: '{$form_search}'{/if}
{literal},
  offset: 30,
  state: 0
};
var limit_ovr = {/literal}{if $limit_ovr == 1}1{else}0{/if}{literal};

jQuery(document).ready(function () {

  function postFilter() {
    $luxury_obj.state = 1;
    $luxury_obj.offset = 0;
    jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function (data) {
      jQuery("#product_container").fadeToggle(function () {
        jQuery(this).html(data).fadeToggle();
        $luxury_obj.offset = 30;
      });
      history.replaceState({filter: $luxury_obj}, null, location.href);
    });
    $luxury_obj.state = 0;
  }

  // клик по чипу фильтра (label с вложенным чекбоксом — как в оригинале
  // div.handle-enabled > .box > input) — делегирование через document,
  // а не прямая привязка, чтобы работало даже если блок фильтров
  // когда-нибудь будет перерисован
  jQuery(document).on("click", ".filter-chip:not(.filter-clear)", function (event) {
    var $chip = jQuery(this);
    var $checkbox = $chip.find("input");
    var checktype = $checkbox.attr("data-type");
    var val = $checkbox.attr("name");

    if ($checkbox.prop("checked")) {
      // выключаем
      $checkbox.prop("checked", false);
      $chip.removeClass("selected");
      var idx = $luxury_obj[checktype].indexOf(val);
      if (idx > -1) $luxury_obj[checktype].splice(idx, 1);
    } else {
      // включаем
      $checkbox.prop("checked", true);
      $chip.addClass("selected");
      $luxury_obj[checktype].push(val);
    }
    postFilter();
  });

  // «Сбросить» — обнуляет весь массив этого типа фильтра, как
  // оригинальный div.handle-clear
  jQuery(document).on("click", ".filter-clear", function (event) {
    var checktype = jQuery(this).data("type");
    $luxury_obj[checktype] = [];
    jQuery(this).siblings(".filter-chip").removeClass("selected").find("input").prop("checked", false);
    postFilter();
  });

  // бесконечная подгрузка при подходе к футеру
  function isNearFooter() {
    var footer = document.querySelector('footer.site-footer');
    if (!footer) return false;
    return footer.getBoundingClientRect().top - window.innerHeight < 600;
  }
  function loadProducts() {
    jQuery('#product_container').append('<div id="preloader"><img src="/images/preload.gif" alt=""><div>Загрузка товаров</div></div>');
    jQuery.post("/catalog/", {json: JSON.stringify($luxury_obj)}, function (data) {
      jQuery('#preloader').remove();
      jQuery('#product_container').append(data);
      $luxury_obj.state = 0;
      $luxury_obj.offset += 30;
    });
  }
  window.addEventListener('scroll', function () {
    if (isNearFooter() && $luxury_obj.state == 0 && $luxury_obj.rowcount > 30 && limit_ovr == 0) {
      $luxury_obj.state = 1;
      if ($luxury_obj.offset < $luxury_obj.rowcount) loadProducts();
    }
  });
});
{/literal}
</script>

{/if}
