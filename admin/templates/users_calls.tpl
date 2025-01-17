<div id="inserts_all">
  <!-- Вкладки /-->
 {include file='users_menu.tpl' active='calls'}
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          Покупатели
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

    <div class="call_main_field" style="border:0px;">
      <div class="call_call_list">
        <div class="call_title">Обзвоны</div>
        <table class="call_gray_table">
          <tr class="call_gray_table_title">
            <td style="width: 85px;">
              Выполнено
            </td>
            <td style="width: 210px;">
              Параметры
            </td>
            <td style="width: 135px;">
              Статистика
            </td>
          </tr>

          {foreach item=ucall from=$users_calls}
          <tr>
            <td>
              <span class="big_blue_text">{$ucall->stat_total_percent}%</span><br>
              {if $ucall->stat_total}из {$ucall->stat_total}{/if}
            </td>
            <td>
              <b>{$ucall->name}</b>
              <br>
              Исполнитель: {$ucall->moderator_name}
              <br>
              создан {$ucall->date}<br>
              {if $ucall->sex==1}Мужчины{elseif $ucall->sex==2}Женщины{else}Пол не указан{/if}<br>
			  {if $ucall->brands_list}<ul>Бренды:
				{foreach from=$ucall->brands_list item=brand}<li>&nbsp;{$brand->name}</li>{/foreach}
			  </ul><br>{/if}
              {if $ucall->shop}Магазины: {$ucall->shop}<br>{/if}
              {if $ucall->sum_min}Сумма покупок: от {$ucall->sum_min}{/if}
            </td>
            <td>
              {$ucall->stat_called} дозвонились<br>
              <!--{$ucall->stat_missing} перезвонить<br>
              9 Поучили СМС<br>-->
              {if $ucall->stat_total_waiting}{$ucall->stat_total_waiting} ждут звонка<br>{/if}
             </td>
          </tr>
          {/foreach}
        </table>
        <input type="button" class="call_button160px" value="Подробнее" onclick="window.location='/admin/index.php?section=Calls&calls&archive';">
      </div>
      <div class="call_create">
        <div class="call_title">Создать новый обзвон</div>
        <form id="new_call_form" method="post" action="index.php?section=Calls&calls">
        <div class="call_input_title">&nbsp;</div>
        <input name="call_name" type="text" class="call_input" placeholder="Название обзвона">
        <div class="call_input_title">Пол</div>
        <table class="call_checktable">
          <tr>
            <td>
              <label for="sex_man"> <input name="sex" value="1" type="radio" id="sex_man">Мужской</label>
            </td>
            <td>
              <label for="sex_woman"> <input name="sex" value="2" type="radio" id="sex_woman">Женский</label>
            </td>
            <td>
              <label for="sex_body">  <input name="sex" value="0" type="radio" id="sex_body" checked="checked">Все</label>
            </td>
          </tr>
        </table>
        <div class="call_half_col" style="float:left;">
          <div class="call_input_title">Исполнитель</div>
          <select name="moderator">
            {foreach item=user from=$moderators}
              <option value="{$user->user_id}">{$user->name}</option>
            {/foreach}
          </select>
        </div>
        <div class="call_half_col" style="float: right;">
          <div class="call_input_title">Сумма покупок от</div>
          <select name="sum_min">
            <option value="0">0</option>
            <option value="1">1</option>
            <option value="100000">100 000</option>
            <option value="200000">200 000</option>
            <option value="500000">500 000</option>
            <option value="1000000">1000 000</option>
            <option value="1500000">1500 000</option>
            <option value="2000000">2000 000</option>
            <option value="3000000">3000 000</option>
          </select>
        </div>
        <div class="call_input_title">Бренды (оставьте пустым, если все)</div>
        <table class="call_checktable">
          <tr>
            {foreach from=$brands item=br key=ind}
              <td>
                <label for="brand_{$br->brand_id}"><input type="checkbox" name='call_brands[]' value='{$br->brand_id}' id="brand_{$br->brand_id}">&nbsp;{$br->name}</label>
              </td>
              {if ($ind+1)%3 ==0}
                </tr><tr>
              {/if}
            {/foreach}
          </tr>
        </table>
        <div class="call_input_title">Магазины (оставьте пустым, если все)</div>
        <table class="call_checktable">
          <tr>
            {foreach from=$shops item=sh key=ind}
              <td>
                <label><input type="checkbox" name='shop[]' value='{$sh->shop_id}'>&nbsp;{$sh->name}</label>
              </td>
              {if ($ind+1)%3 ==0}
                </tr><tr>
              {/if}
            {/foreach}
          </tr>
        </table>
        <div>
          <b>Найдено клиентов:</b> <span id="client_count"></span>
        </div>
        <div class="call_input_title">Шаблон SMS собщения</div>
        <textarea name="sms_template" class="call_textarea"></textarea>
        <div class="call_input_title">
          <span class="lil_text">{literal}{USERNAME} - автоматически заменяется на имя клиента<br>
          {CARDNUMBER}{/literal} - автоматически заменяется на номер карты клиента<br>
          www.lsboutique.ru - сайт нужно указывать с www, иначе телефон клиента не видит ссылку</span>
        </div>
        <!-- <div class="call_total">Итого: 336 человек</div> -->
        <input id="" type="submit" class="call_button160px" value="Создать" onclick="return confirm(&quot;Вы уверены?&quot;);">
        <input id="to_csv" type="submit" class="call_button160px" value="Получить CSV">
        </form>
      </div>
    </div>
    </div>
  </div>
</div>
<!-- Content #End /-->
{literal}
<script src="/third_party/js/jquery/jquery.serialize-object.min.js" type="text/javascript"></script>
<script type="text/javascript">
  function get_url() {
    var brands = $.map($('input[name="call_brands[]"]:checked'), function(e,i) { return $(e).val(); });
    var shops = $.map($('input[name="shop[]"]:checked'), function(e,i) { return $(e).val(); });
    var sum_min = $('select[name="sum_min"]').val();
    return $.param({shops: shops, brands: brands, sum_min: sum_min});
  }

  $("form :input").change(function() {
    $.get( "/rest_api/sales_to_csv?count=1&" + get_url(), function( response ) {
      $('#client_count').html(response);
    });
  });

  $(document).on("click", "#to_csv", function(e) {
    e.preventDefault();
    location.href = "/rest_api/sales_to_csv?" + get_url();
  });
</script>
{/literal}
