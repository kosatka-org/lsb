<!-- Управление товарами /-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/audiojs/1.0.1/audio.min.js"></script>
<script type="text/javascript" src="/jscript/jquery.autocomplete.min.js"></script>
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<link href="/jscript/jquery.autocomplete.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/jscript/picEdit/css/picedit.css" />
<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.0/clipboard.min.js"></script>
{literal}
<script>
$(document).ready(function() {
    audiojs.events.ready(function() {
        var as = audiojs.createAll();
    });
  $('#autocomplete').devbridgeAutocomplete({
      onSearchStart: function (params) {console.log(1);},
      serviceUrl: '/admin/index.php?section=Order&autocomplete',
      onSelect: function (suggestion) {
      console.log(suggestion.data);
        $('#city_id').val(suggestion.data);
      }
  });
});
</script>
{/literal}

{literal}
    <style media="all" type="text/css" >
        .ui-widget-content {
            border: none;
            background: url(/images/tooltip_back.png) 7px 100% no-repeat;
            width: 191px;
            height: 280px;
            color: #222;
        }
        .prodImgTooltip {
            width: 184px;
            height: 276px;
        }
        .ui-tooltip {
            max-width: 184px;
            border: none;
            box-shadow: none;
        }
        .ui-corner-all {
            border: none;
        }
    </style>
    <script type="text/javascript">
        $(function() {
            $( document ).tooltip({
                position: {
                    my: "left bottom-1",
                    at: "center top",
                    using: function( position, feedback ) {
                    $( this ).css( position );}
                },
                hide: {
                    delay: 60
                },
                items: "img, [data-geo], [title]",
                content: function() {
                    var element = $( this );
                    if ( element.is( "[title]" ) ) {
                        var alttext = element.attr( "title" );
                        var text = element.attr( "imurl" );
                        if (text) {
                            var img_url = "/reimg/files/products/184x/" + text;
                            var file_url = "/files/products/" + text;

                            if ($.ajax({type: 'HEAD', async: false, url: file_url}).status == 200) {
                                return "<img class='prodImgTooltip' alt='" + alttext +
                                    "' src='" + img_url + "'>";
                            }
                            else {
                                return "<img class='prodImgTooltip' alt='" + alttext +
                                    "' src='/images/noimage_new.png'>";
                            }
                        }
                    }
                }
            });
        });
    </script>
{/literal}

<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
    <li><a href="index.php?section=Users{if $smarty.get.group}&group={$smarty.get.group}{/if}{if $smarty.get.page}&page={$smarty.get.page}{/if}{if $smarty.get.keyword}&keyword={$smarty.get.keyword}{/if}" class="on">покупатели</a></li>
    <li><a href="index.php?section=User&keys=1&user_id={$User->original_user_id}" class="off" >ключи</a></li>
    <li><a href="index.php?section=User&similar=1&user_id={$User->original_user_id}" class="off" >похожие клиенты</a></li>
    <li><a href="index.php?section=Groups" class="off">группы</a></li>
    <li><a href="index.php?section=User&deposit=1&user_id={$User->original_user_id}" class="off">депозит</a></li>
    <li><a href="index.php?section=User&measuring=1&user_id={$User->original_user_id}" class="off">мерки</a></li>
  </ul>
  <!-- /Вкладки /-->

  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href='index.php?section=Users'>Покупатели</a> →
          {if $User->user_id}{$User->name}{else}Новый покупатель{/if}
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
        <div style="float:left;">
          <span id="ava">
          <!-- Иконка раздела /-->
          {if $User->photo}
              <img src="{$User->photo}" width="150" class="line">
              <img src="/admin/images/delete.jpg" title="Удалить аватар" onclick="if ( !confirm('Вы уверены?') ) return false; $('#ava').hide(); $.get('/index.php?module=Login&delete_avatar&user_id={$User->user_id}');location.reload();" class="line">
          {else}
            <form autocomplete="off" action="/index.php?module=Login&avatar_change" method="post" name="avatar_change" id="avatar_change" enctype="multipart/form-data">
              <input type="file" name="avatar" id="avatar" {literal}class="validate[required] FileInput"{/literal} value=""/>
              <div>
                <input type="submit" value="Сохранить">
              </div>
            </form>
          {/if}
          </span>
        </div>

        <!--<img src="./images/icon_content.jpg" alt="" class="line"/>-->
        <!-- /Иконка раздела /-->

        <!-- Заголовок раздела /-->
        <h1 id="headline" {if $full_sum > 300000}style="padding:0;"{/if}>
            {if $full_sum > 1500000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $full_sum > 900000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $full_sum > 300000}<img src="./images/star_on.jpg">{/if}<br />
            {if $User->user_id}{$User->name}{else}Новый покупатель{/if}
             (<span title="original_user_id">{$User->original_user_id|escape}</span>&nbsp;/&nbsp;<span title="код 1C">{$User->code|escape}</span>)
         </h1>
        <!-- /Заголовок раздела /-->
        <table style="width:220px;float:right;margin:45px 10px 10px 10px;">
          <tr>
            <td valign="top">
              <div class="list_left">
                  <p>
                    {if $User->track_id == null}
                      <a href="#" class="btn btn-primary app-installed" data-user-id="{$User->user_id}" data-platform="apple" style="background-color: #337ab7;" title="Подтвердить установку приложения">
                        &#10004;
                      </a>
                      <br /><br />
                    {/if}
                    <a href="#" class="btn btn-primary send-wallet-link" data-user-id="{$User->user_id}" style="background-color: #337ab7;" title="отправить карту Wallet">
                      Wallet
                    </a>
                  </p>
              </div>
            </td>
            <td valign="top">
              <div class="list_left">
                  <p>
                      <a href="#" class="btn btn-primary send-app-link" data-user-id="{$User->user_id}" data-platform="apple" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на Apple приложение">
                        <i class="icon-envelope"></i> &#8594; <i class="icon-apple"></i>
                      </a><br /><br />
                      <a href="#" class="btn btn-primary send-app-link" data-user-id="{$User->user_id}" data-platform="android" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на Android приложение">
                        <i class="icon-envelope"></i> &#8594; <i class="icon-android"></i>
                      </a>
                  </p>
              </div>
            </td>
            <td valign="top">
              <div class="list_left">
                  <p>
                    <button class="btn btn-clipboard" data-clipboard-text="{$smarty.server.HTTP_HOST}/?module=Login&action=logout&nordr&phone={$User->phone_number|escape}&card_number={$User->card_number|escape}&no_welcome_sms=1">
                      <i class="icon-copy"></i>
                    </button>
                    <br>
                    <button class="btn btn-login" data-user-id="{$User->user_id}" data-type="sms">
                      <i class="icon-envelope"></i>
                    </button>
                    <br>
                    <button class="btn btn-login" data-user-id="{$User->user_id}" data-type="email">
                      <i class="icon-at"></i>
                    </button>
                  </p>
              </div>
            </td>
          </tr>
        </table>

      </div>

      <div id="cont_center">


        <div class="clear">&nbsp;</div>
        {if $Error}
        <!-- Error #Begin /-->
        <div id="error_minh">
          <div id="error">
            <img src="./images/error.jpg" alt=""/><p>{$Error}</p>
          </div>
        </div>
        <!-- Error #End /-->
        {/if}




        <!-- Форма товара #Begin /-->



                <FORM name=user METHOD=POST id='user_form'>
                    <div id="over">
                    <div id="over_right" style="float:right;padding-right:10px;">
                        <table style="width:100%;">
                            <tr>
                                <td colspan="3" style="width:100%;border-bottom:1px #d0d0d0 solid;">
                                    <div class="on u_link" id="t1" style="float:left;padding: 6px 10px;">История</div>
                                    <div class="off u_link" id="t2" style="float:left; margin-left: 5px;padding: 6px 10px;">Онлайн</div>
                                    <div class="off u_link" id="t3" style="float:left; margin-left: 5px;padding: 6px 10px;">Оффлайн</div>
                                    {if $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 5}
                                        <div class="off u_link" id="t4" style="float:left; margin-left: 5px;padding: 6px 10px;">Звонки</div>
                                    {/if}
                                </td>
                            </tr>
                        </table>
                        <table class="u_tab t1">
                        {foreach name=group key=key item=data from=$crm_data}
                            <tr>
                                <td class="m_t">{$data->date}, <b>{$data->type}</b>{if $data->admin_name},{if $data->admin_group == 2} администратор{/if} {if $data->admin_group == 3} модератор{/if} {$data->admin_name}{/if}</td>
                            </tr>
                            <tr><td class="m_t"><p><i>{$data->subject}</i></p></td></tr>
                            <tr><td class="m_t">&nbsp;</td></tr>
                        {/foreach}
                        </table>
                        <div class="u_tab t2" style="display: none;">
                        {if $purchases_on || $purchases_off}
                            <table>
                            {foreach item=data from=$purchases_on}
                                    <tr>
                                        <td rowspan='4' style="padding-top:25px;"><img src="/reimg/files/products/85x/{$data->image}"></td>
                                        <td class="m_t" style="padding-top:25px;">{$data->date}</td>
                                    </tr>
                                    <tr><td class="m_t" style="padding-left:25px;"><p>Заказ № <a href="/admin/index.php?section=Order&order_id={$data->order_id}"  target="_blank">{$data->order_id}</a> в интернет-магазине</p></td></tr>
                                    <tr><td class="m_t" style="padding-left:25px;">
                                        <p>товар
                                            <i><a href="/products/{$data->product_url}/" target="_blank" class="link">{$data->product_name}</a></i><br/>
                                            Статус: {if $data->status == 5}<span style="color:#00cc00;font-weight:bold;">Куплен</span>
                                                                    {elseif $data->status==1|| $data->status==4}<span style="color:red;font-weight:bold;">Отказались от товара</span>
                                                                    {elseif $data->status==3}Не найден
                                                                    {elseif $data->status==2}Потерян ТК
                                                                    {elseif $data->status==0}В примерке{/if}
                                        </p></td></tr>
                                    <tr><td class="m_t" style="padding-left:25px;"><p>{if $data->size}Размер - {$data->size}{/if}</p></td></tr>
                                    <tr><td class="m_t"><p>{if $data->price && $data->price != 0}Начальная цена - {$data->price}{/if}</p></td></tr>
                                    <tr><td class="m_t"><p>{if $data->real_price}Цена покупки - {$data->real_price}{/if}</p></td></tr>
                                    <tr><td class="m_t"><p>{if $data->sale && $data->sale != 0}Скидка - {$data->sale}%{/if}</p></td></tr>
                            {/foreach}
                            </table>
                        </div>
                        <div class="u_tab t3" style="display: none;">
                            <table>
                            {foreach item=data from=$purchases_off}
                                    <tr>
                                        <td style="padding-top:25px;"><img src="/reimg/files/products/85x/{$data->image}"></td>
                                        <td class="m_t" style="padding-top:25px;">
                                            {$data->date}<br>
                                            Продажа № <a href="/index.php?module=OfflineSale&order_id={$data->order_id}" target="_blank">{$data->receipt_number}</a><br>
                                            {if $data->size}Размер - {$data->size}<br>{/if}
                                            {if $data->price && $data->price != 0}Начальная цена - {$data->price}<br>{/if}
                                            {if $data->real_price}Цена покупки - {$data->real_price}<br>{/if}
                                            {if $data->sale && $data->sale != 0}Скидка - {$data->sale}%{/if}
                                        </td>
                                    </tr>
                            {/foreach}
                            </table>
                        {/if}
                        </div>
                        <div class="u_tab t4" style="display: none;">
                        {if $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 5}
                            <div id="calls_field">
                                {foreach from=$calls item=call}
                                    <div style="margin-top:12px;font-size:14px;">
                                        {$call->date} - {if $call->direction == "out"}звонок менеджера клиенту с номера{else}звонок клиента менеджеру на номер{/if} {$call->sip_id} -- <a href="/cron/sip_calls/{$call->filename}" download>Скачать</a><br>
                                        <audio src="/cron/sip_calls/{$call->filename}" preload="auto" />
                                    </div>
                                {/foreach}
                            </div>
                            <div style="cursor:pointer;text-align:center;font-size:16px;padding-top:15px;" id="moreCalls">Больше звонков&nbsp;→</div>
                        {/if}
                        </div>

<script>
var u_id = {$User->original_user_id};
{literal}
$(document).ready(function() {
    $.datepicker.regional['ru'] = {
        closeText: 'Закрыть',
        prevText: '<Пред',
        nextText: 'След>',
        currentText: 'Сегодня',
        monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
        'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
        monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
        'Июл','Авг','Сен','Окт','Ноя','Дек'],
        dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
        dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
        dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
        weekHeader: 'Не',
        firstDay: 1,
        showMonthAfterYear: true,
        yearSuffix: ''
    };
    $.datepicker.setDefaults($.datepicker.regional['ru']);

    $('#date_time_picker').datetimepicker({
        minDate: new Date(1900, 1 - 1, 1),
        yearRange: "1900:-10y",
        changeYear: true,
        maxDate: "-10y",
        timeFormat: '',
        dateFormat: 'yy-mm-dd'
    });
});
$(document).ready(function(){
    $(document).on("click touchstart", ".u_link", function() {
        var act_tab = $(this).attr("id");
        $(".u_link").removeClass("on").addClass("off");
        $(this).removeClass("off").addClass("on");
        $(".u_tab").hide();
        $("." + act_tab).show();
    });
    $('.conformity-table td').mouseout(function(){
        $('.conformity-table td').removeClass('active-col');
        $('.conformity-table tr').removeClass('active-row');
    });
    $('.conformity-table td').mouseover(function(){
        $(this).parent().addClass('active-row');
        var index=$(this).index();
        $(this).parent().parent().find('tr').each(function(){
            $(this).children('td').each(function(i){
                if(i==index){
                    $(this).addClass('active-col');
                }
            });
        });
    });
    $(document).on("click", ".conformity-table td",function(){
        $(this).parent().find('.size_check').trigger('click');
    });
    $(document).on("click", ".conformity-table td .size_check",function(){
        $(this).trigger('click');
    });
});
var pg = 1;
jQuery("#moreCalls").click(function() {
    jQuery.ajax({
        url:"index.php?section=User&get_calls="+pg+"&user_id="+u_id+"",
        dataType: "html"
    })
    .done(function(html) {
       jQuery("#calls_field").append(html);
       pg += 1;
       audiojs.events.ready(function() {
         var as = audiojs.createAll();
       });
    });
});
$(document).ready(function(){
  $("#user_form").validationEngine();
});

$(document).on("click", "#add_phone", function(e) {
  e.preventDefault();
  var data = $('.alt_phone_inp').first().clone();
  $("#alt_phone_block").append(data);
  $('.alt_phone_inp').last().find('input').val('');
});
$(document).on("click", "#add_address", function(e) {
  e.preventDefault();
  var data = $('.alt_address_inp').first().clone();
  $("#alt_address_block").append(data);
  $('.alt_address_inp').last().find('textarea').val('');
});
$(document).on("click", "#add_manager", function(e) {
  e.preventDefault();
  var data = $('.sr_manager_inp').first().clone();
  $("#sr_manager_id_block").append(data);
  $('.sr_manager_inp').last().val('');
});
</script>
                        {/literal}
                    </div>
                    <div id="over_left" style="float:left;">
                        {if $User->user_age}<p style="font-size:14px;">Пользователь зарегистрировался {$User->user_age} месяцев назад</p>{/if}
                        {if $User->user_return_rate && $User->online_sum}<p style="font-size:14px;color:red;">Процент возвратов клиентом: {$User->user_return_rate|round:"1"}%</p>{/if}
                        {if $User->debt_unpaid}<p style="font-size:14px;color:red;">Неоплаченный долг: {$User->debt_unpaid|round:"1"|number_format:0:'.':' '}</p>{/if}
                        <table>
                                {if $User->deposit}
                                  <tr>
                                      <td class="model" style="color:green;">Депозит: </td>
                                      <td class="model" style="color:green;">{$User->deposit|escape|number_format:0:'.':' '}</td>
                                  </tr>
                                {/if}
                                {if $User->online_sum}
                                  <tr>
                                      <td class="model" style="color:green;">Покупки(онлайн): </td>
                                      <td class="model" style="color:green;">{$User->online_sum|escape|number_format:0:'.':' '}</td>
                                  </tr>
                                {/if}
                                {if $User->offline_sum}
                                  <tr>
                                      <td class="model" style="color:green;">Покупки(оффлайн): </td>
                                      <td class="model" style="color:green;">{$User->offline_sum|escape|number_format:0:'.':' '}</td>
                                  </tr>
                                {/if}
                                {if !$User->user_status || !$User->email || !$U_Messengers || !$U_companies || !$User->adress || !$User->sex || !$User->birth_date || $User->last_login_date=='0000-00-00 00:00:00' || $User->last_api_login_date=='0000-00-00 00:00:00'}
                                  <tr><td colspan=2>
                                    <p class="contact_on" style='margin:0 0 5px;color:red;'>
                                    Заполнить:</br>
                                    {if !$User->user_status}Статус</br>{/if}
                                    {if !$User->email}Email</br>{/if}
                                    {if !$U_Messengers}Мессенджеры</br>{/if}
                                    {if !$U_companies}Транспортные компании</br>{/if}
                                    {if !$User->sex}Пол</br>{/if}
                                    {if !$User->adress}Адрес</br>{/if}
                                    {if !$User->birth_date}День рождения</br>{/if}
                                    {if $User->last_login_date=='0000-00-00 00:00:00'}Не пользуется аккаунтом!</br>{/if}
                                    {if $User->last_api_login_date=='0000-00-00 00:00:00'}Не пользуется приложением!</br>{/if}
                                    </p>
                                  </td></tr>
                                {/if}
                                <tr>
                                    <td class="model">Из Инстаграмм</td>
                                    <td class="m_t"><p><input name="intagramm_user" type="text" {literal}class=" input3 validate[custom[url]]"{/literal} style="width:250px;border-radius:0;padding: 1px 0 1px 3px!important;" value='{$User->intagramm_user|escape}' /></p></td>
                                </tr>
                                {if $allowed_admin}
                                  <tr>
                                      <td class="model" title="Функции массового логаута и отключения не влияют на суперпользователей">Суперпользователь</td>
                                      <td class="m_t"><input type="checkbox" name="superuser" value="1" {if $User->superuser}checked{/if} /></td>
                                  </tr>
                                {/if}
                                <tr>
                                    <td class="model">Имя</td>
                                    <td class="m_t"><p><input name="name" type="text" {literal}class="validate[required] input3"{/literal} style="width:250px;" value='{$User->name|escape}'  {literal}pattern='.{1,}'{/literal} notice='{$Lang->ENTER_NAME}'/></p></td>
                                </tr>
                                <tr>
                                    <td class="model"{if !$User->email} style='color:red;'{/if}>Почта{if !$User->email} (Заполнить!){/if}</td>
                                    <td class="m_t"><p><input name="email" type="text" class="input3" style="width:250px;" value='{$User->email|escape}' /></p></td>
                                </tr>
                                <tr>
                                    <td class="model"{if !$User->phone_number} style='color:red;'{/if}>{if $User->phone_number}<a href="tel:{$User->phone_number}">Мобильный</a>{else}Мобильный (Заполнить!){/if}</td>
                                    <td class="m_t"><p><input name="phone_number" type="text" class="input3" style="width:250px;" value='{$User->phone_number|escape}' maxlength="15" {literal}pattern="[0-9]{10,15}"{/literal} /></p></td>
                                </tr>
                                <tr>
                                    <td class="model">Дополнительные номера телефона</td>
                                    <td class="m_t">
                                      {foreach from=$User->alt_phones item=ap}
                                        <p class="alt_phone_inp"><input name="alt_phone[]" type="text" class="input3" style="width:250px;margin-bottom:2px;" value='{$ap|escape}' /></p>
                                      {/foreach}
                                      <div id="alt_phone_block"></div>
                                      <div class="add_field" id="add_phone"><div>&#9997;</div>Добавить еще один телефон</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="model">Городской</td>
                                    <td class="m_t"><p><input name="home_phone" type="text" class="input3" style="width:250px;" value='{$User->home_phone|escape}' /></p></td>
                                </tr>
                                <tr>
                                    <td class="model">Номер карты</td>
                                    <td class="m_t"><p><input name="card_number" type="text" class="input3" style="width:250px;" value='{$User->card_number|escape}' /></p></td>
                                </tr>
                                <tr>
                                    <td class="model"{if !$User->city_id} style='color:red;'{/if}>Город{if !$User->city_id} (Заполнить!){/if}</td>
                                    <td class="model">
                                        <p>
                                          <input name="city_id" type="hidden" id="city_id" class="input3" value='{$User->city_id}'/>
                                          <input name="city" type="text" class="input3" id="autocomplete" value='{$User->city}'/>
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="model"{if !$User->adress} style='color:red;'{/if}>Адрес{if !$User->adress} (Заполнить!){/if}</td>
                                    <td class="m_t"><p><textarea name="adress" class="input3" style="width:250px;height:40px;">{$User->adress|escape}</textarea></p></td>
                                </tr>
                                <tr>
                                    <td class="model">Дополнительные адреса</td>
                                    <td class="m_t">
                                      {foreach from=$User->alt_addresses item=aa}
                                        <p class="alt_address_inp"><textarea name="alt_address[]" class="input3" style="width:250px;height:30px;">{$aa|escape}</textarea></p>
                                      {/foreach}
                                      <div id="alt_address_block"></div>
                                      <div class="add_field" id="add_address"><div>&#9997;</div>Добавить еще один адрес</div>
                                    </td>
                                </tr>
                                {if $allowed_admin}
                                <tr>
                                    <td class="model">Персональный менеджер</td>
                                    <td class="m_t">
                                        <p>
                                            <select name=p_manager_id class="select2" style="width:255px;">
                                              <OPTION VALUE='' {if !$User->p_manager_id}SELECTED{/if}>Нет</OPTION>
                                             {foreach key=key item=manager from=$Managers}
                                                {if $User->p_manager_id == $manager->user_id}
                                                  <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                                                {else}
                                                  <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                                                {/if}
                                              {/foreach}
                                            </select>
                                        </p>
                                    </td>
                                </tr>
                                {else}
                                <tr>
                                    <td class="model">Персональный менеджер</td>
                                    <td class="m_t" style="font-size: 16px;">
                                        {$User->p_manager_name}
                                        <input type="hidden" value="{$User->p_manager_id}" name="p_manager_id">
                                    </td>
                                </tr>
                                {/if}
                                {if $allowed_admin}
                                <tr>
                                    <td class="model">Менеджер торгового зала</td>
                                    <td class="m_t">
                                        <p>
                                          {foreach item=manager_act from=$sr_Managers_act}
                                            <select name="sr_manager_id[]" class="select2 sr_manager_inp" style="width:255px; margin-bottom:2px;">
                                              <OPTION VALUE='' {if !$manager_act->user_id}SELECTED{/if}>Нет</OPTION>
                                             {foreach key=key item=manager from=$sr_Managers}
                                                {if $manager_act->manager_id == $manager->user_id}
                                                  <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                                                {else}
                                                  <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                                                {/if}
                                              {/foreach}
                                            </select>
                                          {/foreach}
                                          <div id="sr_manager_id_block"></div>
                                          <div class="add_field" id="add_manager"><div>&#9997;</div>Добавить еще одного менеджера</div>
                                        </p>
                                    </td>
                                </tr>
                                {else}
                                <tr>
                                    <td class="model">Менеджер торгового зала</td>
                                    <td class="m_t" style="font-size: 16px;">
                                      {foreach item=manager from=$sr_Managers_act}
                                        {$manager->name}
                                      {/foreach}
                                    </td>
                                </tr>
                                {/if}
                                <tr>
                                    <td class="model"{if !$U_companies} style='color:red;'{/if}>Предпочитаемая ТК{if !$U_companies} (Заполнить!){/if}</td>
                                    <td class="m_t" style="width: 304px;">
                                        {foreach from=$dcompanies item=company}
                                            <input type="checkbox" name="pref_delivery[]" value="{$company->id}" {if in_array($company->id, $U_companies)}checked{/if}>{$company->name}
                                        {/foreach}
                                    </td>
                                </tr>
                                <tr>
                                    <td class="model"{if !$U_Messengers} style='color:red;'{/if}>Предпочитаемый месcеджер{if !$U_Messengers} (Заполнить!){/if}</td>
                                    <td class="m_t" style="width: 304px;">
                                        {foreach from=$Messengers item=Messenger}
                                            <label><nobr> 
                                                {if $Messenger->name== "Whatsapp"}
                                                    <a target="_blank" href="https://api.whatsapp.com/send?phone={$User->phone_number}"> 
                                                {/if}
                                                {if $Messenger->name== "Viber"} 
                                                    <a target="_blank" href="viber://chat?number={$User->phone_number}"> 
                                                {/if}
                                                <img src="/admin/images/icons/{$Messenger->icon}" style="width:25px;">
                                                {if $Messenger->name== "Viber"}
                                                    </a> 
                                                {/if}
                                                {if $Messenger->name== "Whatsapp"}
                                                    </a> 
                                                {/if}
                                                <input type="checkbox" name="pref_messenger[]" value="{$Messenger->id}" {if in_array($Messenger->id, $U_Messengers)}checked{/if}>{$Messenger->name}&nbsp;
                                            </nobr></label>
                                        {/foreach}
                                    </td>
                                </tr>
                                {if $comments}
                                    <tr><td colspan=2><h2>Комментарии к пользователю</h2></td></tr>
                                    {foreach from=$comments item=comment}
                                        <tr>
                                            <td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
                                            {if $comment->commenter_id == $smarty.session.user->user_id || $allowed_admin}
                                            <a href="/admin/index.php?section=User&amp;delete_comment_id={$comment->id}&amp;user_id={$User->user_id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
                                            {/if}
                                            {$comment->date}
                                            <br>
                                            <b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}</b>: {$comment->text|escape|nl2br}
                                            <br>
                                            </td>
                                        </tr>
                                    {/foreach}
                                {/if}
                                <tr>
                                <tr>
                                    <td class="model">Комментарий</td>
                                    <td class="m_t"><p><textarea name="comment" class="input3" style="width:250px;height:60px;"></textarea></p></td>
                                </tr>
                                <tr>
                                    <td class="model"{if !$User->sex} style='color:red;'{/if}>Пол{if !$User->sex} (Заполнить!){/if}</td>
                                    <td class="m_t">
                                        <p>
                                            <span class="ShAA_sexName">М</span><input type="radio" name="sex" value="1" {if ($User->sex|escape) == '1'} checked="checked" {/if} class="ShAA_sexInput" />
                                            <span class="ShAA_sexName">Ж</span><input type="radio" name="sex" value="2" {if ($User->sex|escape) == '2'} checked="checked" {/if} class="ShAA_sexInput" />
                                            <span class="ShAA_sexName">0</span><input type="radio" name="sex" value="0" {if ($User->sex|escape) == '0'} checked="checked" {/if} class="ShAA_sexInput" />
                                        </p>
                                    </td>
                                </tr>
                                {if $User->clothing_size}
                                <tr>
                                    <td class="model">Информация из 1С</td>
                                    <td class="m_t"><p><textarea name="clothing_size" class="input3" style="width:250px;height:60px;">{$User->clothing_size|escape}</textarea></p></td>
                                </tr>
                                {/if}
                                {if $sips}
                                <tr>
                                    <td class="model">Sip-адреса</td>
                                    <td class="m_t"><p>
                                        {foreach from=$sips item=sip}
                                        <div style="clear:both;font-size:16px;">
                                            {$sip->sip_id}
                                            {if $allowed_admin}
                                            <a href="/admin/index.php?section=User&amp;delete_sip_id={$sip->id}" title="Удалить sip-адрес" class="fl" onclick="return confirm('Вы уверены, что хотите удалить sip-адрес?');"><img src="./images/cancel.jpg" alt="Удалить sip-адрес" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
                                            {/if}<br/>
                                        </div>
                                        {/foreach}
                                    </p></td>
                                </tr>
                                {/if}
                                {if $allowed_admin}
                                <tr>
                                    <td class="model">Добавить Sip-адрес</td>
                                    <td class="m_t"><p><input name="sip" class="input3" type="text" /></p></td>
                                </tr>
                                <tr>
                                    <td class="model">Имя пользователя Slack</td>
                                    <td class="m_t"><p><input name="slack_name" class="input3" type="text" value="{$User->slack_name}"/></p></td>
                                </tr>
                                {/if}
                                {if $allowed_admin && $User->group_id == 5}
                                  <tr>
                                      <td class="model">План продаж</td>
                                      <td class="m_t"><p><input name="sales_target" class="input3" type="text" value="{$User->sales_target}"/></p></td>
                                  </tr>
                                {/if}
                                {if $allowed_admin && $User->group_id == 5}
                                  <tr>
                                      <td class="model">Допустимый отказ</td>
                                      <td class="m_t"><p><input name="decline_rate" class="input3" type="text" value="{$User->decline_rate}"/></p></td>
                                  </tr>
                                {/if}
                                {if $allowed_admin && $User->group_id > 1}
                                <tr>
                                    <td class="model">Предел вычачи долга</td>
                                    <td class="m_t"><p><input name="debt_limit" class="input3" type="text" value="{$User->debt_limit|escape}"/></p></td>
                                </tr>
                                {/if}
                                <tr>
                                    <td class="model"{if !$User->birth_date} style='color:red;'{/if}>Дата рождения{if !$User->birth_date} (Заполнить!){/if}</td>
                                    <td class="m_t"><p><input name="birth_date" id="date_time_picker" type="text" class="input3" style="width:250px;" value='{if $User->birth_date}{$User->birth_date}{else}0000-00-00{/if}' /></p></td>
                                </tr>

                                <tr>
                                    <td class="model">Группа</td>
                                    <td class="m_t"><p>
{if $allowed_admin}
                                        <select name=group_id class="select2">
                                          <OPTION VALUE='' {if !$User->group_id}SELECTED{/if}>Не определена</OPTION>
                                         {foreach name=group key=key item=group from=$Groups}
                                            {if $User->group_id == $group->group_id}
                                              <OPTION VALUE='{$group->group_id}' SELECTED>{$group->name|escape}</OPTION>
                                            {else}
                                              <OPTION VALUE='{$group->group_id}'>{$group->name|escape}</OPTION>
                                            {/if}
                                          {/foreach}
                                        </select>
{else}
                                        <input type="hidden" name="group_id" value="{if $User->group_id}{$User->group_id}{else}1{/if}">
{/if}
                                        <nobr><input name=enabled type="checkbox" class="checkbox" {if $User->enabled}checked{/if} value='1'/><span class="akt">Актив</span></nobr> &nbsp; &nbsp;
                                    </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="model">Подгруппа</td>
                                    <td class="m_t"><p>
{if $allowed_admin && ($User->group_id == 5 || $User->group_id == 13)}
                                        <select name=subgroup_id class="select2">
                                          <OPTION VALUE='' {if !$User->subgroup_id}SELECTED{/if}>Не определена</OPTION>
                                         {foreach key=key item=group from=$SubGroups}
                                            {if $User->subgroup_id == $group->subgroup_id}
                                              <OPTION VALUE='{$group->subgroup_id}' SELECTED>{$group->name|escape}</OPTION>
                                            {else}
                                              <OPTION VALUE='{$group->subgroup_id}'>{$group->name|escape}</OPTION>
                                            {/if}
                                          {/foreach}
                                        </select>
{else}
                                        <input type="hidden" name="subgroup_id" value="{if $User->subgroup_id}{$User->subgroup_id}{else}0{/if}">
{/if}
                                    </p>
                                    </td>
                                </tr>
                                <tr>
{if $allowed_admin && ($User->group_id > 8 && $User->subgroup_id != 4)}
                                    <td class="model">Старший менеджер</td>
                                    <td class="m_t"><p>
                                        <select name=sen_manager class="select2">
                                          <OPTION VALUE='' {if !$User->sen_manager}SELECTED{/if}>Не определен</OPTION>
                                          {if $sen_managers}
                                            {foreach key=key item=manager from=$sen_managers}
                                              {if $User->sen_manager == $manager->user_id}
                                                <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                                              {else}
                                                <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                                              {/if}
                                            {/foreach}
                                          {/if}
                                        </select>
{else}
                                        <input type="hidden" name="sen_manager" value="{if $User->sen_manager}{$User->sen_manager}{else}{/if}">
                                    </p>
                                    </td>
{/if}
                                </tr>
                                {if $allowed_admin && $User->group_id == 5}
                                  <tr>
                                      <td class="model">Город работы</td>
                                      <td class="m_t"><p>
                                          <select name=workcity_id class="select2">
                                            <OPTION VALUE='0' {if !$User->workcity_id}SELECTED{/if}>Все</OPTION>
                                            {foreach item=workcity from=$workcities}
                                              {if $User->workcity_id == $workcity->city_id}
                                                <OPTION VALUE='{$workcity->city_id}' SELECTED>{$workcity->city_name|escape}</OPTION>
                                              {else}
                                                <OPTION VALUE='{$workcity->city_id}'>{$workcity->city_name|escape}</OPTION>
                                              {/if}
                                            {/foreach}
                                          </select>
                                      </p>
                                      </td>
                                  </tr>
                                {/if}
                                <tr>
                                    <td class="model"{if !$User->user_status} style='color:red;'{/if}>Статус{if !$User->user_status} (Заполнить!){/if}</td>
                                    <td class="m_t">
                                        <p>
                                            <select name=user_status class="select2">
                                              <OPTION VALUE='' {if !$User->user_status}SELECTED{/if}>New</OPTION>
                                             {foreach key=key item=status from=$Statuses}
                                                {if $User->user_status == $status}
                                                  <OPTION VALUE='{$status}' SELECTED>{$status|escape}</OPTION>
                                                {else}
                                                  <OPTION VALUE='{$status}'>{$status|escape}</OPTION>
                                                {/if}
                                              {/foreach}
                                            </select>
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="model">Скидка</td>
                                    <td class="m_t"><p><input name="personal_discount" type="text" class="input3" style="width:250px;" value='{$User->personal_discount|escape}' /></p></td>
                                </tr>
                                <tr>
                                    <td class="model">
                                      <label>Пользователь с покупками</label>
                                    </td>
                                    <td class="model">
                                      <input type="checkbox" value="1" name="has_purchase" {if $User->has_purchase}checked{/if}>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><p><input type="submit" value="Сохранить" class="submit" onclick="return confirm('Вы уверены?');"/></p></td>
                                </tr>
                                {if $User->last_login_date != '0000-00-00 00:00:00' }
                                <tr>
                                    <td class="model">Визит на сайт</td>
                                    <td class="model">{$User->last_login_date|escape}</td>
                                </tr>
                                {/if}
                                {if $User->last_api_login_date != '0000-00-00 00:00:00' }
                                <tr>
                                    <td class="model">Действие в приложении</td>
                                    <td class="model">{$User->last_api_login_date|escape}</td>
                                </tr>
                                {/if}
                                <tr>
                                    <td class="model">Процент возвратов</td>
                                    <td class="model">{$User->user_return_rate|round:"1"}%</td>
                                </tr>
                                <tr>
                                    <td class="model">Стоп-лист</td>
                                    <td class="model">
                                        <label>SMS</label>
                                        <input type="checkbox" onchange="jQuery.get('/index.php?module=Login&do_not_disturb&type=sms&user_id={$User->original_user_id}');" name="stop_sms" {if $User->stop_sms}checked{/if}>
                                        <label>Email</label>
                                        <input type="checkbox" onchange="jQuery.get('/index.php?module=Login&do_not_disturb&type=email&email={$User->email}&user_id={$User->original_user_id}');" name="stop_email" {if $User->stop_email}checked{/if}>
                                    </td>
                                </tr>
                                {if $User->stop_list_history}
                                {foreach item=item from=$User->stop_list_history}
                                <tr>
                                  <td colspan=2>
                                    {$item->date}
                                    {if $item->user_id == $item->manager_id}
                                      <span style="color:red;">Пользователь лично {if $item->del == 0}отписался от{else}подписался на{/if} {if $item->type == 0}смс{else}email{/if}-рассылки</span>
                                    {else}
                                      {$item->m_name} {if $item->del == 0}отписал{else}подписал{/if} пользователя {if $item->del == 0}от{else}на{/if} {if $item->type == 0}смс{else}email{/if}-рассылки.
                                    {/if}
                                  </td>
                                </tr>
                                {/foreach}
                                {/if}
                                {foreach key=type_id item=size_t from=$sizes}
                                <tr>
                                    <td colspan=2>
                                        <div class="table" id="men-clothing">
                                            <h2>{$size_t->name}</h2>
                                            <div class="conformity-table">
                                                <table class="responsive">
                                                    <tbody>
                                                    {foreach item=size_l from=$size_t->sizes}
                                                        <tr>
                                                        {if $size_l->id}
                                                            <td class="empty"><input class='size_check' type="checkbox"  onchange="{literal}jQuery.get('/index.php?module=Login&users2sizes&user_id={/literal}{$User->original_user_id}{literal}&type_id={/literal}{$type_id}{literal}&size={/literal}{$size_l->id}');" name="sizes[{$type_id}][]" value="{$size_l->id}" {if in_array($size_l->id, $user_sizes)}checked{/if} autocomplete="off" /></td>
                                                        {else}
                                                            <td class="empty"></td>
                                                        {/if}
                                                        {cycle values="" reset=true}
                                                        {foreach item=value from=$size_l->values}
                                                            <td class='{cycle values="row-odd,row-even"}'>{$value}</td>
                                                        {/foreach}
                                                        </tr>
                                                    {/foreach}
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                {/foreach}
                                <tr>
                                    <td class="model">Магазин</td>
                                    <td class="m_t" style="width: 304px;">
                                        {foreach from=$shops item=shop}
                                            <input type="checkbox" name="shop[]" value="{$shop->shop_id}" {if in_array($shop->shop_id, $User->shops)}checked{/if}>{$shop->name}
                                        {/foreach}
                                    </td>
                                </tr>
                                <tr>
                                    <td class="model">Бренды</td>
                                    <td class="m_t">
                                        {foreach from=$brands item=brand}
                                            <div style="float:left; margin-right:5px;">
                                                <label>
                                                    <input type="checkbox" name="brand[]" value="{$brand->brand_id}" {if in_array($brand->brand_id, $subscribed_brands)}checked{/if} autocomplete="off" /> {$brand->name}
                                                </label>
                                            </div>
                                        {/foreach}
                                    </td>
                                </tr>
                                <tr>
                                    <td class="model">Оффлайн бренды, доступные через сайт</td>
                                    <td class="m_t">
                                        <b>Внимание!</b> Доступ к Stefano Ricci предоставляется только в исключительных случаях.<br>
                                        {foreach from=$offline_brands item=brand}
                                            <div style="float:left; margin-right:5px;">
                                                <label>
                                                    <input type="checkbox" name="offline_brands[]" value="{$brand->brand_id}" {if $brand->active}checked{/if} autocomplete="off" /> {$brand->name}
                                                </label>
                                            </div>
                                        {/foreach}
                                    </td>
                                </tr>

                                <tr>
                                    <td class="model">Скрытые бренды</td>
                                    <td class="m_t">
                                        {foreach from=$all_hidden_brands item=hidden_brand}
                                        <div style="float:left; margin-right:5px;">
                                            <label>
                                                <input type="checkbox" name="hidden_brands[]" value="{$hidden_brand->brand_id}" {if in_array($hidden_brand->brand_id, $show_hidden_brands)}checked{/if} autocomplete="off" /> {$hidden_brand->name}
                                            </label>
                                        </div>
                                        {/foreach}
                                    </td>
                                </tr>

                                {if $smarty.session.user->group_id == 2}
                                    <tr>
                                        <td class="model">Доступные кассы</td>
                                        <td class="m_t">
                                            {foreach from=$all_cashboxes item=cb}
                                            <div style="float:left; margin-right:5px;">
                                                <label>
                                                    <input type="checkbox" name="cashboxes[]" value="{$cb->id}" {if in_array($cb->id, $active_cashboxes)}checked{/if} autocomplete="off" /> {$cb->name}
                                                </label>
                                            </div>
                                            {/foreach}
                                        </td>
                                    </tr>
                                {/if}

                                {if $smarty.session.user->group_id == 2}
                                    <tr>
                                        <td class="model">Доступные закладки</td>
                                        <td class="m_t">
                                            {foreach from=$all_bookmarks item=bm}
                                            <div style="float:left; margin-right:5px;">
                                                <label>
                                                    <input type="checkbox" name="bookmarks[]" value="{$bm->id}" {if in_array($bm->id, $active_bookmarks)}checked{/if} autocomplete="off" /> {$bm->name}
                                                </label>
                                            </div>
                                            {/foreach}
                                        </td>
                                    </tr>
                                {/if}

                                {if $smarty.session.user->group_id == 2}
                                    <tr>
                                        <td class="model">Доступные склады</td>
                                        <td class="m_t">
                                            {foreach from=$all_warehouses item=bm}
                                            <div style="float:left; margin-right:5px;">
                                                <label>
                                                    <input type="checkbox" name="warehouses[]" value="{$bm->warehouse_id}" {if in_array($bm->warehouse_id, $active_warehouses)}checked{/if} autocomplete="off" /> {$bm->name}
                                                </label>
                                            </div>
                                            {/foreach}
                                        </td>
                                    </tr>
                                {/if}
                                {if $smarty.session.user->group_id == 2}
                                    <tr>
                                        <td class="model">Доступные типы перемещений</td>
                                        <td class="m_t">
                                            {foreach from=$all_m_types item=bm}
                                            <div style="float:left; margin-right:5px;">
                                                <label>
                                                    <input type="checkbox" name="m_types[]" value="{$bm->id}" {if in_array($bm->id, $active_m_types)}checked{/if} autocomplete="off" /> {$bm->name}
                                                </label>
                                            </div>
                                            {/foreach}
                                        </td>
                                    </tr>
                                {/if}
                                <tr>
                                    <td class="model">Последние просмотренные товары</td>
                                    <td class="m_t">
                                        {foreach from=$viewed_products item=product}
                                        <div style="float:left; margin-right:5px;">
                                            <b>{$product->view_date}:</b><br>
                                            <b>{if $product->app_view == 1}APP{else}Desktop{/if}</b><a class="ShAA_toolPhoto" href="/products/{$product->url}/" title='{$product->model}' imurl='{$product->small_image}' target="_blank"> {$product->model}</a>, артикул {$product->sku}, цена {$product->view_price}
                                        </div><br>
                                        {/foreach}
                                    </td>
                                </tr>

                            </table>
                    </div>
                </div>
            </div>
            </form>


    </div>
  </div>
</div>
<script type="text/javascript" src="/jscript/picEdit/js/picedit.min.js"></script>
<script type="text/javascript">
{literal}
	$(function() {
		$('#avatar').picEdit({
      maxWidth:150,
      redirectUrl:'/admin/index.php?section=User&user_id={/literal}{$User->user_id}{literal}'
    });
	});
</script>
{/literal}
{literal}
<script>
$(document).on("click", ".send-app-link", function(e) {
  e.preventDefault();
  var t = $(this);
  var platform = t.data().platform;
  result = window.confirm("Отправить клиенту СМС со ссылкой на приложение " + platform.charAt(0).toUpperCase() + platform.slice(1) + "?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {send_app_link_to_user: user_id, platform: platform}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div style="color:#3c763d;">Готово</div>');
      }
    });
  }
});
$(document).on("click", ".send-wallet-link", function(e) {
  e.preventDefault();
  var t = $(this);
  var platform = t.data().platform;
  result = window.confirm("Отправить клиенту СМС со ссылкой на карту Wallet?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {send_wallet_link_to_user: user_id}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div style="color:#3c763d;">Готово</div>');
      }
    });
  }
});
$(document).on("click", ".app-installed", function(e) {
  e.preventDefault();
  var t = $(this);
  result = window.confirm("Приложение установлено?");
  if (result) {
    var user_id = t.data().userId;
    $.post("/index.php?module=OfflineSale", {app_installed: user_id}, function(r) {
      if (r == 'OK') {
        t.replaceWith('<div style="color:#3c763d;">Готово</div>');
      }
    });
  }
});

new ClipboardJS('.btn-clipboard');

$(document).on("click", ".btn-login", function(e) {
  e.preventDefault();
  var t = $(this);
  var type = t.data().type;
  var userId = t.data().userId;
  result = window.confirm("Отправить пользователю "+type.toUpperCase()+" со ссылкой для входа?");
  if (result) {
    $.post("/rest_api/otll/"+userId+"/"+type, {}, function(r) {
      if (r == 'OK') {
        alert(type.toUpperCase() + ' отправлен');
      }
      else {
        alert("Произошла ошибка");
      }
    });
  }
});

</script>
{/literal}
<!-- Content #End /-->
