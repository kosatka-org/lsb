<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="/admin/index.php?section=Statistics&brands=1" class="on">По брендам</a></li>
    <li><a href="/admin/index.php?section=Statistics&orders=1" class="off">По заказам</a></li>
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
          <h1 id="headline">Отчет по брендам</h1>
        <!-- /Заголовок раздела /-->
      </div>
      <div id="cont_center">
        <div id="cont_left">
          <ul>
            {foreach item=brand from=$brands}
              <li class="{if $brand->brand_id == $CurrentBrand}li_on{else}li_off{/if}">
                <a href="/admin/index.php?section=Statistics&brands=1&brand={$brand->brand_id}">{$brand->name}</a>
              </li>
            {/foreach}
          </ul>
        </div>
        <div id="cont_right">
          <div class=filter>
            <form method='post' action='/admin/index.php?section=Statistics&brands=1&brand={$CurrentBrand}'>
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
          {if $graph1 || $graph2}
          <div style="margin-bottom:20px;"><a href="#" class="toggler">Графики</a></div>          
          <div class="toggle" id="graphs" style="float:left; margin-right:20px;width:700px;margin-top:20px;display: block;">
            {if $graph1}
              График по числу заказов<br/>
              <div style="float:left;width:700px;height:300px;margin-bottom:20px;" id="graph11"></div>
            {/if}
            {if $graph2}
              График по сумме стоимости<br/>
              <div style="float:left;width:700px;height:300px;" id="graph12"></div>
            {/if}
          </div>
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
<script language="javascript" type="text/javascript" src="../js/flot/jquery.canvaswrapper.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.colorhelpers.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.saturated.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.browser.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.drawSeries.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.uiConstants.js"></script>
<script language="javascript" type="text/javascript" src="../js/flot/jquery.flot.time.js"></script>
<script>
var d1 = JSON.parse("{$graph1}");
var d2 = JSON.parse("{$graph2}");
{literal}
  var options = {
    xaxis: {
      mode: "time",
      timeBase: "seconds",
      tickLength: 1,
      monthNames: ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"],
      tickSize: [1, "day"],
      gridLines: true
    },
    selection: {
      mode: "x"
    }
  };

  $.plot("#graph11", [{data: d1,bars: { show: true }}], options);
  $.plot("#graph12", [{data: d2,bars: { show: true }}], options);
  
  $("#graphs").hide();
{/literal}
</script>