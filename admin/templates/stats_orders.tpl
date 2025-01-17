<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="/admin/index.php?section=Statistics&brands=1" class="off">По брендам</a></li>
    <li><a href="/admin/index.php?section=Statistics&orders=1" class="on">По заказам</a></li>
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a>
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
          <img src="./images/icon_stat.png" alt="" class="line"/>
        <!-- /Иконка раздела /-->
	    
        <!-- Заголовок раздела /-->
          <h1 id="headline">Отчет по заказам</h1>
        <!-- /Заголовок раздела /-->
      </div>
      <div id="cont_center">
        <div class="clear">&nbsp;</div>	  
        <div id="cont_right">
          <div class=filter>
            <form method='post' action='/admin/index.php?section=Statistics&orders=1'>
              <select style="width:150px;margin-right:20px;" name="period" id="month">
              </select>
              <input type='submit' value='Найти' class="submit10">
            </form>
          </div>
          {if $totals}
          <h2>
          <table id="list" style="width:100%;margin:20px 0 10px;">
            <tr>
              <td>Количество:{$totals->o_count}</td>
              <td>Сумма:{$totals->o_sum|number_format:0:',':' '}</td>
            </tr> 
          </table>
          </h2>
          {/if}
          
          {if $orders}
          <div style="margin-bottom:20px;"><a href="#" class="toggler">Список</a></div>
          <table class="toggle" style="display: none;" >
            {foreach item=item from=$orders}
              <tr>
                <td style='width:150px;'>
                  <div class="list_left" style='width:150px;'>
                    <div class="flxc" style='width:150px;'>
                      <p>
                        <a href="/admin/index.php?section=Order&order_id={$item->order_id}" title='Страница заказа'>Заказ №{$item->order_id}</a><br/>
                        <a href="/admin/index.php?section=Special_orders&s_order={$item->so_id}" title='Страница заказа'>Спец.Заказ №{$item->so_id}</a><br/>
                        {$item->date}
                      </p>
                    </div>
                  </div>
                </td>
                </td>
                <td>
                  <div class="list_right" style='text-align: left;'>
                    {foreach item=prod from=$item->products}
                      <p style='margin-bottom:15px;'>
                        <b>Название: {$prod->product_name}</b><br/>
                        Артикул: {$prod->sku}<br/>
                        Цена: {$prod->price}<br/>
                      </p>
                    {/foreach}
                  </div>
                </td>
              </tr>
            {/foreach}
          </table>
          {/if}
        </div>
        <div class="clear">&nbsp;</div>	  
      </div>  
    </div>
  </div>	    
</div>
<!-- Content #End /--> 
<script>
var year = {if $allowed_admin}new Date(2012, 8){else}0{/if};
window.period_param = '{$date_from}';
{literal}
  $(document).on("ready", function() {
    moment.locale('ru');
    if(year == 0){year = moment().subtract(14, 'months').startOf('year');}
    var range = moment.range(year, Date.now());
    var cont = $('select#month');
    var now = moment();
    range.by("months", function(period) {
      var html = "<option value='" + period.format("Y-MM") + "'>" + period.format("MMMM Y") + "</option>";
      cont.prepend(html);
    });
    $('option[value="'+window.period_param+'"]').attr("selected",true);
  });
  
    $(document).on("click touchstart", ".toggler", function(e) {
        e.preventDefault();
        $(this).parent().next(".toggle").slideToggle();
    });
{/literal}
</script>