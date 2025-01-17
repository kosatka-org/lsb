<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='analytics_menu.tpl' active='sales'}
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
        <h1 id="headline">Отчет по продажам</h1>
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




<form method=get id=filter>
<div class="clear">&nbsp;</div>
<div class=filter style="width:880px;">
  <div>
    Дата от: <input name="date_from" id="date_from" type=text  value='{$date_from|escape}'>
    до: <input name="date_to" id="date_to" type=text           value='{$date_to|escape}'>
    <div style="margin-top:10px;">
  </div>
  <div style='overflow:hidden;'>
    Кассы: <br/>
    {foreach from=$cashboxes item=cashbox}
      <div style="width:205px; margin:10px 20px 0 0;float:left;">
        <input type='checkbox' value="{$cashbox->id}" name="cashboxes[]" {if $cashbox_f == $cashbox->id}checked{/if} />{$cashbox->name} ({$cashbox->shop_name})
      </div>
    {/foreach}
  </div>
  <div style="margin:10px 20px 0 0; float:left;">
    Клиент:
    <input type='text' name='user_phone' value='' style="width:205px;">
  </div>
  <div style="margin:10px 20px 0 0; float:left;">
    Бренд:
    <select name="brand" id="brand">
      <option value="" {if !$brand_f}selected{/if}>Не выбран</option>
      {foreach from=$brands item=brand}
        <option value="{$brand->brand_id}" {if $brand_f == $brand->brand_id}selected{/if}>{$brand->name}</option>
      {/foreach}
    </select>
  </div>
  <div style="margin:10px 0 0 0; float:left;">
    <a target="_blank" id="table_link" href="/admin/index.php?section=Analytics&sales_report=1&date_from={$date_from|escape}&date_to={$date_to|escape}"><input type='button' value='Показать'></a>
  </div>
  
</div>
<div class="clear">&nbsp;</div>
</form>

<div style="width:450px; font-size: 16px;">
  
</div>

</div>
</div>
</div>
</div>
</div>
{literal}
<script>
  $(document).on("change", "input, select", function(e) {
    var form = $("#filter").serialize(),
        base = "/admin/index.php?section=Analytics&sales_report=1&";
    $("#table_link").attr('href', base+form);
  });
</script>
{/literal}
