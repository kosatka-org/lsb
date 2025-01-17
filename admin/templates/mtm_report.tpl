{literal}
<style>
  table#customers {
      font-family: arial, sans-serif;
      border-collapse: collapse;
      width: 100%;
      font-size: 16px;
  }

  #customers td, #customers th {
      border: 1px solid #dddddd;
      text-align: left;
      padding: 8px;
  }
</style>
{/literal}

<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='analytics_menu.tpl' active='mtm'}
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
        <h1 id="headline">Отчет по индивидуальному пошиву</h1>
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




<form method=get>
<div class="clear">&nbsp;</div>
<div class=filter style="width:880px;" action="/admin/index.php">
      <input name="section" type=hidden  value="Analytics">
      <input name="mtm_report" type=hidden  value="true">
      <input name="group_by" type=hidden  value="{$group_by_old}">
      Дата от: <input name="date_from" id="date_from" type=text  value='{$date_from|escape}'>
      до: <input name="date_to" id="date_to" type=text           value='{$date_to|escape}'>
      <input type='submit' value='Отфильтровать'>
      <input onclick="window.location='/admin/index.php?section=Analytics&mtm_report=1';" type='button' style="float:right;" value='Обновить статистику'>
</div>
<div class="clear">&nbsp;</div>
</form>


<table id="customers" style="width:100%">
  <tr>
    <th></th>
    <th>Долг</th>
    <th>Всего</th>
  </tr>
  <tr>
    <td><b>Итого</b></td>
    <td>{$summary->debt|number_format:0:",":" "}</td>
    <td>{$summary->total|number_format:0:",":" "}</td>
  </tr>
  <tr style="background: lightgrey;">
    <td></td>
    <td></td>
    <td></td>
  </tr>
  {foreach from=$brands item=brand}
    <tr>
      <td><b>{$brand->name}</b></td>
      <td>{$brand->debt|number_format:0:",":" "}</td>
      <td>{$brand->total|number_format:0:",":" "}</td>
    </tr>
    {foreach from=$brand->by_user item=by_user}
      <tr>
        <td>{$by_user->name}</td>
        <td>{$by_user->debt|number_format:0:",":" "}</td>
        <td>{$by_user->sum|number_format:0:",":" "}</td>
      </tr>
    {/foreach}
    <tr style="background: lightgrey;">
      <td></td>
      <td></td>
      <td></td>
    </tr>
  {/foreach}
</table>

</div>
</div></div>
