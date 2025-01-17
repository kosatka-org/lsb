<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='products_menu.tpl' active='categories'}

  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          <a href="index.php?section=Storefront">Категории товаров</a>
        </p>
      </td>
    </tr>
  </table>
  <!-- /Путь /-->
</div>


<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">

      <div id="cont_top">
	       <img src="./images/icon_categories.jpg" alt="" class="line"/>
         <h1 id="headline">Категории товаров{* (<a href="/admin/index.php?section=Categories&with_seo">СЕО</a>)*}</h1>
      </div>

      <div id="cont_center">

        {if $Error}
          <div id="error_minh">
            <div id="error">
              <img src="./images/error.jpg" alt=""/><p>{$Error}</p>
            </div>
          </div>
        {/if}
        <div class="clear">&nbsp;</div>

        {$PagesNavigation}

          <form name='products' method="post">
            <table id="list2">
              <tr>
                <td>
                  <h2>Канонические категории</h2>
                </td>
              </tr>
              <tr>
                <td>
                  {include file=cat.tpl cc=$CanonicalCategories}
                </td>
              </tr>
              <tr>
                <td>
                  <h2>Остальные категории</h2>
                </td>
              </tr>
              <tr>
                <td>
                  {include file=cat.tpl cc=$Categories}
                </td>
              </tr>
            </table>
          </form>

        {$PagesNavigation}
	    </div>
    </div>
  </div>
</div>
<!-- Content #End /-->
