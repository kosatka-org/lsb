<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
      {if in_array('Setup', $user_allowed)}<li><a href="index.php?section=Setup" class="off">параметры</a></li>{/if}
      {if in_array('Currency', $user_allowed)}<li><a href="index.php?section=Currency" class="off">валюты</a></li>{/if}
      {if in_array('DeliveryMethods', $user_allowed)}<li><a href="index.php?section=DeliveryMethods" class="off">доставка</a></li>{/if}
      <li><a href="index.php?section=DeliveryCompanies" class="on">транспортные компании</a></li>
      {if in_array('PaymentMethods', $user_allowed)}<li><a href="index.php?section=PaymentMethods" class="off">оплата</a></li>{/if}
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">{$Site_name}</a> →
          транспортные компании</a>
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
        <!-- Иконка раздела /-->
        <img src="./images/icon_truck.jpg" alt="" class="line"/>
    	  <!-- /Иконка раздела /-->

  	    <!-- Заголовок раздела /-->
          <h1 id="headline">транспортные компании</h1>
        <!-- /Заголовок раздела /-->
      </div>

      <div id="cont_center">
          {if $Items}
          <!-- Форма товаров #Begin /-->
          <form name='products' method="post">
            <table id="list2">

              {* Список разделов *}
              {foreach item=item from=$Items}
              <tr>
                <td>
                  <div class="list_left">
                    <a href="index.php?section=DeliveryCompanies&enable_id={$item->id}&token={$Token}" class="fl"><img src="./images/{if $item->active}lamp_on.jpg{else}lamp_off.jpg{/if}" alt=""/></a>
                    <div class="flxc">
                      <p>
                        <a href="index.php{$item->edit_get}" class="{if $item->active}tovar_on{else}tovar_off{/if}">{$item->name|escape}</a>
                      </p>
                      <p class=tovar_min>
                      </p>
                    </div>
	                </div>
                </td>
              </tr>
              {/foreach}
              {* /Список разделов *}
            </table>
            </form>
            <!-- Форма Товаров #End /-->
            {else}
              Список пуст
            {/if}

        </div>
	    <!-- Right side #End/-->

    </div>
  </div>
</div>
<!-- Content #End /-->
