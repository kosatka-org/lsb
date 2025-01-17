<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='analytics_menu.tpl' active='calls'}
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
        <h1 id="headline">Отчет по звонкам</h1>
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
      <input name="call_report" type=hidden  value="true">
      <input name="group_by" type=hidden  value="{$group_by_old}">
      Дата от: <input name="date_from" id="date_from" type=text  value='{$date_from|escape}'>
      до: <input name="date_to" id="date_to" type=text           value='{$date_to|escape}'>
      <div style="margin-top:10px;">
      Касса: 
      <select name="cashbox" id="cashbox">
        <option value="">Не выбран</option>
        {foreach from=$cashboxes item=cashbox}
          <option value="{$cashbox->id}" {if $cashbox_f == $cashbox->id}selected{/if}>{$cashbox->name} ({$cashbox->shop_name})</option>
        {/foreach}
      </select>
      <input type='submit' value='Отфильтровать'>
      </div>
      <input onclick="window.location='/admin/index.php?section=Analytics&call_report=1';" type='button' style="float:right;" value='Обновить статистику'>
</div>
<div class="clear">&nbsp;</div>
</form>

<div style="width:450px; font-size: 16px;">
  {foreach from=$managers item=manager}
    {if $manager->total || $manager->sales_today}
      {if !$manager->manager_id}<hr/>{/if}
      <h3>{$manager->name}</h3>
      <!--<div style="width: 100%; float: left; margin: 3px 0;">
          <div style="float:left;">Всего действий:</div>
          <div style="float: right;">{$manager->total}</div>
      </div>-->
      {if $manager->sales_today}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Продажи:</div>
            <div style="float: right;">{$manager->sales_today|default:'0'|number_format:0:'.':' '}</div>
        </div>
      {/if}
      {if $manager->debt_total}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Долгов всего:</div>
            <div style="float: right;{if $manager->manager_id}color:{if $manager->debt_total > $manager->debt_limit}red{else}green{/if};{/if}">{$manager->debt_total|default:'0'|number_format:0:'.':' '}</div>
        </div>
      {/if}
      {if $manager->mtm_today}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Пошив:</div>
            <div style="float: right;">{$manager->mtm_today|default:'0'|number_format:0:'.':' '}</div>
        </div>
      {/if}
      {if $manager->debt_mtm}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Долгов по пошиву:</div>
            <div style="float: right;{if $manager->manager_id}color:grey;{/if}">{$manager->debt_mtm|default:'0'|number_format:0:'.':' '}</div>
        </div>
      {/if}
      {if $manager->services_today}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Услуги:</div>
            <div style="float: right;">{$manager->services_today|default:'0'|number_format:0:'.':' '}</div>
        </div>
      {/if}
      {if $manager->debt_serv}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Долгов по услугам:</div>
            <div style="float: right;{if $manager->manager_id}color:grey;{/if}">{$manager->debt_serv|default:'0'|number_format:0:'.':' '}</div>
        </div>
      {/if}
      {if $manager->success || $manager->fail}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Дозвонились / Не дозвонились:</div>
            <div style="float: right;">{$manager->success} / {$manager->fail}</div>
        </div>
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Уникальных:</div>
            <div style="float: right;">{$manager->uniq->success} / {$manager->uniq->fail}</div>
        </div>
      {/if}
      {if $manager->users_total}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Клиентов всего:</div>
            <div style="float: right;">{$manager->users_total}</div>
        </div>
      {/if}
      {if $manager->users_called}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Обзвонено:</div>
            <div style="float: right;">{$manager->users_called}</div>
        </div>
      {/if}
      {if $manager->users_bought}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Совершили покупку:</div>
            <div style="float: right;">{$manager->users_bought}</div>
        </div>
      {/if}
      {if $manager->sms_app}
        <div style="width: 100%; float: left; margin: 3px 0;position:relative;" class="slide-toggle">
            <div style="float:left;">Отправлено СМС со ссылкой на приложение:</div>
            <div style="float: right;">{$manager->sms_app}</div>
            <div class="links fatlist" style="display:none;left:0;top:25px;">
                <div class="fatlist_title">Отправлено СМС<div class="fatlist_close">Закрыть</div></div>
                <table>
                {foreach from=$manager->app_users item=user}
                    <tr><td><a href="/admin/index.php?section=User&user_id={$user->user_id}" target="_blank">{$user->name}</a>&emsp;&emsp;&emsp;</td><td> {$user->phone_number}</td></tr>
                {/foreach}
                </table>
            </div>
        </div>
      {/if}
      {if $manager->app_track}
        <div style="width: 100%; float: left; margin: 3px 0;position:relative;" class="slide-toggle">
            <div style="float:left;">Приложений установлено:</div>
            <div style="float: right;">{$manager->app_track}</div>
            <div class="links fatlist" style="display:none;left:0;top:25px;">
                <div class="fatlist_title">Отправлено СМС<div class="fatlist_close">Закрыть</div></div>
                <table>
                {foreach from=$manager->app_track_users item=user}
                    <tr><td><a href="/admin/index.php?section=User&user_id={$user->user_id}" target="_blank">{$user->name}</a>&emsp;&emsp;&emsp;</td><td> {$user->phone_number}</td></tr>
                {/foreach}
                </table>
            </div>
        </div>
      {/if}
      {if $manager->app_auth}
        <div style="width: 100%; float: left; margin: 3px 0;position:relative;" class="slide-toggle">
            <div style="float:left;">В приложении авторизовано:</div>
            <div style="float: right;">{$manager->app_auth}</div>
            <div class="links fatlist" style="display:none;left:0;top:25px;">
                <div class="fatlist_title">В приложении авторизованы<div class="fatlist_close">Закрыть</div></div>
                <table>
                {foreach from=$manager->app_auth_users item=user}
                    <tr><td><a href="/admin/index.php?section=User&user_id={$user->user_id}" target="_blank">{$user->name}</a>&emsp;&emsp;&emsp;</td><td> {$user->phone_number}</td></tr>
                {/foreach}
                </table>
            </div>
        </div>
      {/if}
      {if $manager->sms_wal}
        <div style="width: 100%; float: left; margin: 3px 0;position:relative;" class="slide-toggle">
            <div style="float:left;">Отправлено СМС со ссылкой на wallet-карточку:</div>
            <div style="float: right;">{$manager->sms_wal}</div>
            <div class="links fatlist" style="display:none;left:0;top:25px;">
                <div class="fatlist_title">Отправлено СМС<div class="fatlist_close">Закрыть</div></div>
                <table>
                {foreach from=$manager->wal_users item=user}
                    <tr><td><a href="/admin/index.php?section=User&user_id={$user->user_id}" target="_blank">{$user->name}</a>&emsp;&emsp;&emsp;</td><td> {$user->phone_number}</td></tr>
                {/foreach}
                </table>
            </div>
        </div>
      {/if}
      {if $manager->wal_downloads}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Карточек загружено:</div>
            <div style="float: right;">{$manager->wal_downloads}</div>
        </div>
      {/if}
      {if $manager->comments}
        <div style="width: 100%; float: left; margin: 3px 0;">
            <div style="float:left;">Оставлено комментариев:</div>
            <div style="float: right;">{$manager->comments}</div>
        </div>
      {/if}
      {if $manager->app_reg}
        <div style="width: 100%; float: left; margin: 3px 0;position:relative;" class="slide-toggle">
            <div style="float:left;">В приложении зарегистрировали:</div>
            <div style="float: right;">{$manager->app_reg}</div>
            <div class="links fatlist" style="display:none;left:0;top:25px;">
                <div class="fatlist_title">В приложении зарегистрировали<div class="fatlist_close">Закрыть</div></div>
                <table>
                {foreach from=$manager->app_reg_users item=user}
                    <tr><td><a href="/admin/index.php?section=User&user_id={$user->user_id}" target="_blank">{$user->name}</a>&emsp;&emsp;&emsp;</td><td> {$user->phone_number}</td></tr>
                {/foreach}
                </table>
            </div>
        </div>
      {/if}
    {/if}
    <div class="clear" style="margin-bottom: 20px;"></div>
  {/foreach}
</div>

</div>
</div></div>
{literal}
<script>
  $(document).on("click touchstart", ".slide-toggle", function(e) {
      if ($('#cont_center').height() < ($(this).find('.links').height()+$(this).offset().top)){
          $('#cont_center').height($(this).find('.links').height() + $(this).offset().top);
      }
      else{}
      $(this).find('.links').slideDown();
      e.stopPropagation();
  });
  
  $(document).on("click touchstart", ".fatlist_close", function(e) { $(this).parents('.links:first').slideUp(); $('#cont_center').attr('style', ''); e.stopPropagation(); });
</script>
{/literal}
