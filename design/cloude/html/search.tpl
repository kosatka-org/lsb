{*
  Template name: Поиск
  Результаты поиска
  Used by: Search.class.php   
  Assigned vars: $products, $keyword
*}

<!-- Заголовок  /-->
<div id="page_title">      
    <h1 class="float_left">Поиск {$keyword|escape}</h1>

    <!-- Хлебные крошки /-->
    <div id="path">
      <a href="/">Главная</a>
      → Поиск {$keyword|escape}
    </div>
    <!-- Хлебные крошки #End /-->
</div>      

{if $products}
<!-- Список товаров  /-->
<div id="products_list">

    {foreach name=products item=product from=$products}    
    <!-- Товар /-->
    <div class="product_block">
    
        <!-- Картинка товара /-->
        <div class="product_block_img">
            <p>
              <a href="products/{$product->url}">
                <img src="{if $product->small_image}files/products/{$product->small_image}{elseif $product->category_image}foto/categories/{$product->category_image}{else}images/no_foto.gif{/if}" alt=""/>
              </a>
              </p>
        </div>
        <!-- Картинка товара #End /-->
        
        <!-- Информация о товаре /-->
        <div class="product_block_annotation" >
        
            <!-- Название /-->
            <p tooltip='product' product_id='{$product->product_id}'><a href="products/{$product->url}" {if $product->hit}class="product_name_link_hit"{else}class="product_name_link"{/if}>{$product->category|escape} {$product->brand|escape} {$product->model|escape}</a></p>
            <!-- Название #End /-->

            <!-- Цена /-->
            <p>
              {if $product->old_price>0}
              <span class="old_price">{$product->old_price|string_format:"%.2f"}&nbsp;{$currency->sign|escape}</span>
              {/if}
              <span class="price">{$product->discount_price|string_format:"%.2f"}&nbsp;{$currency->sign|escape}</span>
            </p>
            <!-- Цена #End /-->
            
            <!-- В корзину /-->
            {if $product->quantity>0}
            <p><a href="cart/add/{$product->product_id}" class="link_to_cart"  onclick="document.cookie='from='+location.href+';path=/';">в корзину</a></p>
            {else}
            Нет в наличии
            {/if} 
            <!-- В корзину #End /-->

            <!-- Описание товара /-->
            <p class="product_annotation">
                {$product->description}
            </p>
            <!-- Описание товара #End /-->
        </div>
        <!-- Информация о товаре #End /-->
        
    </div>
    <!-- Товар #End /-->
    {if $smarty.foreach.products.iteration%2 == 0}
      <div class="clear"><!-- /--></div>
    {/if}
    {/foreach}
    
    <div class="clear"><!-- /--></div>
    
</div>
<!-- Список товаров #End /-->
{else}
<p>
  По запросу &laquo;{$keyword|escape}&raquo; ничего не найдено
</p>
<br>
{/if}
