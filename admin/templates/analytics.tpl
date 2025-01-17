<script type="text/javascript" src="/third_party/js/jquery/jquery.js"></script>
<script src="/third_party/js/jquery/jqplot/jquery.jqplot.min.js" type="text/javascript"></script>
<link  href="/third_party/js/jquery/jqplot/jquery.jqplot.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.cursor.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.canvasTextRenderer.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.pieRenderer.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.dateAxisRenderer.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.logAxisRenderer.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.canvasAxisLabelRenderer.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.highlighter.min.js"></script>
<script type="text/javascript" src="/third_party/js/jquery/jqplot/plugins/jqplot.trendline.min.js"></script>

<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='analytics_menu.tpl' active='main'}
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Лакшери стор</a> → Аналитика продаж
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
        <img src="./images/icon_secure.jpg" alt="" class="line"/>
        <!-- /Иконка раздела /-->

        <!-- Заголовок раздела /-->
        <h1 id="headline">Аналитика продаж{$title}</h1>
        <!-- /Заголовок раздела /-->
      </div>


      <div id="cont_center">

          {if $Error}
          <!-- Error #Begin /-->
          <div id="error_minh">
            <div id="error">
              <img src="./images/error.jpg" alt=""/><p>{$Error}</p>
            </div>
          </div>
          <!-- Error #End /-->
          {/if}
          {if $Message}
          <!-- Error #Begin /-->
          <div id="message_minh">
            <div id="message">
              <img src="./images/info.png" alt=""/><p>{$Message}</p>
            </div>
          </div>
          <!-- Error #End /-->
          {/if}


{literal}
<script>
{/literal}
var items_sum   = {$items_sum};
var items_count = {$items_count};
var ost_sum     = {$ost_sum};
var ost_count   = {$ost_count};
{if $view_mode == 1}
{literal}
$(document).ready( function() {
  var plot1 = $.jqplot ('chart1', [items_sum], {
    title: "Продажи в рублях {/literal}{$total.sum}{literal}",
      seriesDefaults: {
          trendline: {
            show: true,         // show the trend line
            color: '#666666',   // CSS color spec for the trend line.
            label: '',          // label for the trend line.
            type: 'linear',     // 'linear', 'exponential' or 'exp'
            shadow: true,       // show the trend line shadow.
            lineWidth: 1,       // width of the trend line.
            shadowAngle: 45,    // angle of the shadow.  Clockwise from x axis.
            shadowOffset: 1.5,  // offset from the line of the shadow.
            shadowDepth: 3,     // Number of strokes to make when drawing shadow.
            shadowAlpha: 0.07   // Opacity of the shadow
          },
      },
    axes: {
        xaxis: {
          renderer:$.jqplot.DateAxisRenderer,
          pad: 0
        },
        yaxis: {
          renderer:$.jqplot.LogAxisRenderer,
          tickOptions:{
            formatString:'%.2f руб'
          }
        }
      },
      cursor:{
            show: true,
            zoom: true
      },
      highlighter: {
        show: true,
        sizeAdjust: 7.5
      }
  });

  var plot2 = $.jqplot ('chart2', [items_count], {
    title: "Продажи в штуках {/literal}{$total.count}{literal}",
      seriesDefaults: {
          trendline: {
            show: true,         // show the trend line
            color: '#666666',   // CSS color spec for the trend line.
            label: '',          // label for the trend line.
            type: 'linear',     // 'linear', 'exponential' or 'exp'
            shadow: true,       // show the trend line shadow.
            lineWidth: 1,       // width of the trend line.
            shadowAngle: 45,    // angle of the shadow.  Clockwise from x axis.
            shadowOffset: 1.5,  // offset from the line of the shadow.
            shadowDepth: 3,     // Number of strokes to make when drawing shadow.
            shadowAlpha: 0.07   // Opacity of the shadow
          },
      },
    axes: {
        xaxis: {
          renderer:$.jqplot.DateAxisRenderer,
          pad: 0
        },
        yaxis: {
          renderer:$.jqplot.LogAxisRenderer,
          tickOptions:{
            formatString:'%.0f шт'
          }
        }
      },
      cursor:{
            show: true,
            zoom: true
      },
      highlighter: {
        show: true,
        sizeAdjust: 7.5
      }
  });

{/literal}
{else}
{literal}
$(document).ready(function(){
  $.jqplot.config.enablePlugins = true;
  var plot1 = $.jqplot ('chart1', [items_sum], {
    title: "Продажи в рублях {/literal}{$total.sum}{literal}",
    stackSeries: true,
    seriesDefaults: {
      renderer: $.jqplot.PieRenderer,
      rendererOptions: {
        sliceMargin:6,
        barMargin: 25
      }
    },
    legend: { show:true }
  });
  var plot2 = $.jqplot ('chart2', [items_count], {
    title: "Продажи в штуках {/literal}{$total.count}{literal}",
    stackSeries: true,
    seriesDefaults: {
      renderer: $.jqplot.PieRenderer,
      rendererOptions: {
        sliceMargin:6,
        barMargin: 25
      }
    },
    legend: { show:true }
  });
{/literal}
{/if}
{literal}

  var plot3 = $.jqplot ('chart3', [ost_sum], {
    title: "Остатки в рублях",
    stackSeries: true,
    seriesDefaults: {
      renderer: $.jqplot.PieRenderer,
      rendererOptions: {
        sliceMargin:6,
        barMargin: 25
      }
    },
    legend: { show:true }
  });

  var plot4 = $.jqplot ('chart4', [ost_count], {
    title: "Остатки в штуках",
    stackSeries: true,
    seriesDefaults: {
      renderer: $.jqplot.PieRenderer,
      rendererOptions: {
        sliceMargin:6,
        barMargin: 25
      }
    },
    legend: { show:true }
  });
});
</script>
{/literal}



<form method=get>
<div class="clear">&nbsp;</div>
<div class=filter style="width:880px;" action="/admin/index.php">
      <input name="section" type=hidden  value="Analytics">
      <input name="group_by" type=hidden  value="{$group_by_old}">
      Дата от: <input name="date_from" id="date_from" type=text  value='{$date_from|escape}'>
      до: <input name="date_to" id="date_to" type=text           value='{$date_to|escape}'>
      &nbsp;&nbsp;Групировка: <select name="group_by">
{foreach item=item key=group_by from=$group}
    <option value="{$group_by}" {if $smarty.get.group_by == $group_by }selected{/if}>{$item}</option>
{/foreach}
      </select>
      <input type='submit' value='Отфильтровать'>
      <br>
      <label for="view_mode"><input type="checkbox" id="view_mode" name="view_mode" value="1" {if $smarty.get.view_mode}checked="checked"{/if}> На временной шкале</label>

      <input onclick="window.location='/admin/index.php?section=Analytics&run_prepare=1';" type='button' style="float:right;" value='Обновить статистику'>
</div>

<div class="clear">&nbsp;</div>
<div id="filter" style="width:250px; float:left;">
<h3>Фильтр</h3>
<div class="clear">&nbsp;</div>
{foreach item=item key=group_by from=$group}
    <div>
    <b><i>{$item}:</i></b> &nbsp;&nbsp;<input id="filter_{$group_by}" type="checkbox" onclick="{literal}$('div input:checkbox', $('#filter_{/literal}{$group_by}{literal}').parent()).each(function() { if ( $('#filter_{/literal}{$group_by}{literal}').attr('checked') ) { $(this).attr('checked', 'checked'); } else { $(this).removeAttr('checked'); }  });{/literal}"><label for="filter_{$group_by}">&nbsp;Выбрать все</label><br>
    <div>
    {foreach item=item key=i from=$filter_o[$group_by]}
        <label for="filter_{$group_by}_{$i}"><nobr><input {if $smarty.get.filter.$group_by.$i}checked="checked"{/if} type="checkbox" id="filter_{$group_by}_{$i}" value="{$item->value}" name="filter[{$group_by}][{$i}]">&nbsp;{if $item->value}{$item->value}{else}Не определено{/if}</nobr></label>&nbsp;&nbsp;&nbsp;
    {/foreach}
    </div></div>
    <div class="clear">&nbsp;</div>
{/foreach}
</div>
</form>

<div id="chart1" style="min-height:{$height}px; min-width:650px; float:right;"></div>
<div id="chart2" style="min-height:{$height}px; min-width:650px; float:right;"></div>
<div id="chart3" style="min-height:{$height}px; min-width:650px; float:right;"></div>
<div id="chart4" style="min-height:{$height}px; min-width:650px; float:right;"></div>
</div>
</div></div>
