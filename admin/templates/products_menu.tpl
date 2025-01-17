<ul id="inserts" >
  {if in_array('Storefront', $user_allowed)}<li><a href="index.php?section=Storefront" {if $active == 'storefront'}class="on"{else}class="off"{/if}>товары</a></li>{/if}
  {if in_array('Categories', $user_allowed)}<li><a href="index.php?section=Categories" {if $active == 'categories'}class="on"{else}class="off"{/if}>категории</a></li>{/if}
  {if in_array('Brands', $user_allowed)}<li><a href="index.php?section=Brands" {if $active == 'brands'}class="on"{else}class="off"{/if}>бренды</a></li>{/if}
  {if in_array('Goods', $user_allowed)}<li><a href="index.php?section=Goods" {if $active == 'goods'}class="on"{else}class="off"{/if}>бренд-категория</a></li>{/if}
	{if in_array('Materials', $user_allowed)}<li><a href="index.php?section=Materials" {if $active == 'materials'}class="on"{else}class="off"{/if}>материалы</a></li>{/if}
	{if in_array('Sets', $user_allowed)}<li><a href="index.php?section=Sets" {if $active == 'sets'}class="on"{else}class="off"{/if}>наборы</a></li>{/if}
  {if in_array('Banners', $user_allowed)}<li><a href="index.php?section=Banners" {if $active == 'banners'}class="on"{else}class="off"{/if}>баннеры</a></li>{/if}
	{if in_array('Shops', $user_allowed)}<li><a href="index.php?section=Shops" {if $active == 'shops'}class="on"{else}class="off"{/if}>магазины</a></li>{/if}
    {if in_array('Collections', $user_allowed)}<li><a href="index.php?section=Collections" {if $active == 'collections'}class="on"{else}class="off"{/if}>коллекции</a></li>{/if}
    {if in_array('Storis', $user_allowed)}<li><a href="index.php?section=Storis" {if $active == 'storis'}class="on"{else}class="off"{/if}>Сторис</a></li>{/if}
</ul>
