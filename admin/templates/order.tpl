<SCRIPT type="text/javascript" src="../js/baloon/js/default.js"></SCRIPT>
<SCRIPT type="text/javascript" src="../js/baloon/js/validate.js"></SCRIPT>
<SCRIPT type="text/javascript" src="../js/baloon/js/baloon.js"></SCRIPT>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-migrate/1.2.1/jquery-migrate.js"></script>
<script type="text/javascript" src="../jscript/fancybox/js/jquery.fancybox-1.3.4.pack.js"></script>
<script type="text/javascript" src="/jscript/jquery.autocomplete.min.js"></script>
<link href="/jscript/jquery.autocomplete.min.css" rel="stylesheet" type="text/css" />

<link href="../jscript/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" type="text/css" />
<LINK href="../js/baloon/css/baloon.css"                   rel="stylesheet" type="text/css" />
{literal}
<style>
.lds-facebook {
  display: block;
  position: relative;
  margin: auto;
  width: 64px;
  height: 64px;
}
.lds-facebook div {
  display: inline-block;
  position: absolute;
  left: 6px;
  width: 13px;
  background: #000;
  animation: lds-facebook 1.2s cubic-bezier(0, 0.5, 0.5, 1) infinite;
}
.lds-facebook div:nth-child(1) {
  left: 6px;
  animation-delay: -0.24s;
}
.lds-facebook div:nth-child(2) {
  left: 26px;
  animation-delay: -0.12s;
}
.lds-facebook div:nth-child(3) {
  left: 45px;
  animation-delay: 0;
}
@keyframes lds-facebook {
  0% {
    top: 6px;
    height: 51px;
  }
  50%, 100% {
    top: 19px;
    height: 26px;
  }
}
</style>

<script type="text/javascript">
$(document).ready(function() {
    $(".P_images").fancybox({
        'padding'           : 0,
        'titlePosition'     : 'inside',
        'autoScale'         : 'true',
        'opacity'           : 'false',
        'scrolling'         : 'no',
        'overlayColor'      : '#000'
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
<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
{if !$DeliveryAgent}
      <li><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}"               class="{if $Order->status==0}on{else}off{/if}">новые</a></li>
      <li><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}&view=process"  class="{if $Order->status==1}on{else}off{/if}">обработка</a></li>
      <li><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}&view=delivery" class="{if $Order->status==6}on{else}off{/if}">доставка</a></li>
      <li><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}&view=done"     class="{if $Order->status==2}on{else}off{/if}">выполнены</a></li>
      <li><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}&view=pickup"   class="{if $Order->status==5}on{else}off{/if}">самовывоз</a></li>
  </ul>
  <ul style="float:right; padding: 4px 0 5px 0;">
      <li style="display: inline;"><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}&view=cancel" class="off">отменённые</a></li>
      <li style="display: inline;"><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}&view=search" class="off">поиск</a></li>
{else}
    {foreach from=$Tabs item=stat key=statkey}
      <li><a href="index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}&delivery={$statkey}" class="{if $DelView==$statkey}on{else}off{/if}">{$stat}</a></li>
    {/foreach}
{/if}
  </ul>
  <!-- /Вкладки /-->
</div>
<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">
      <div id="cont_top">
        <!-- Иконка раздела /-->
        {if !$DeliveryAgent}<img src="./images/icon_orders.jpg" alt="" class="line"/>{/if}
        <!-- /Иконка раздела /-->

        <!-- Заголовок раздела /-->
        <h1 id="headline">Заказ №{$Order->order_id} (<a href="index.php?section=User&user_id={$Order->user_id}" target="_blank">страница клиента</a>)</h1>
        <!-- /Заголовок раздела /-->
        <table style="width:220px;float:right;margin:45px 10px 10px 10px;">
          <tr>
            <td valign="top">
              {if $Order->status == 1 && !$DeliveryAgent}
                <p class="contact_on"><a class="pack_order" data-order-id='{$Order->order_id}' {if $Order->packed}style='font-weight:bold'{/if} href="#">Отправляем</a> / <a class="unpack_order" data-order-id='{$Order->order_id}' href="#" {if !$Order->packed}style='font-weight:bold'{/if}>Не отправляем</a></p>
              {/if}
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
<FORM name=product METHOD=POST enctype='multipart/form-data' id="prodform">
    <div id="over">
    <div id="over_left">
        <table>
            <tr>
                <td class="model">Дата</td>
                <td class="model"><p>{$Order->date}</p></td>
            </tr>
            <tr>
                <td class="model">IP-адрес</td>
                <td class="model"><p>{$Order->ip} (<a href='http://www.ip-adress.com/ip_tracer/{$Order->ip}/' target="_blank">где это?</a>)</p></td>
            </tr>
            <tr>
                <td class="model">ID пользователя</td>
                <td class="m_t"><p><input name="user_id" type="text" class="input3" value='{$Order->user_id|escape}' {if $DeliveryAgent || (($smarty.session.user->group_id != 5 || $smarty.session.user->subgroup_id != 3) && !$allowed_admin)}disabled{/if}/></p></td>
            </tr>
            <tr>
                <td class="model">Имя</td>
                <td class="m_t"><p><input name="name" type="text" class="input3" value='{$Order->name|escape}' {if $DeliveryAgent}disabled{/if}/></p></td>
            </tr>
            <tr>
                <td class="model">Email</td>
                <td class="m_t"><p><input name="email" type="text" class="input3" value='{$Order->email|escape}' {if $DeliveryAgent}disabled{/if}/></p></td>
            </tr>
            <tr>
                <td class="model">Телефон</td>
                <td class="m_t"><p><input name="phone" type="text" class="input3" value='{$Order->phone|escape}' {if $DeliveryAgent}disabled{/if}/></p></td>
            </tr>
            <tr>
                <td class="model">Город</td>
                <td class="m_t"><p>
                <input name="city_id" type="hidden" id="city_id" class="input3" value='{$Order->city_id}'/>
                <input name="city" type="text" class="input3" id="autocomplete" value='{$Order->city} ({$Order->region})' {if $DeliveryAgent}disabled{/if}/>

                </td>
            </tr>
            {if $city_comments}
                <tr><td colspan=2><h2>Комментарии к городу</h2></td></tr>
                {foreach from=$city_comments item=comment}
                    <tr>
                        <td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
                        {if $comment->commenter_id == $smarty.session.user->user_id || $allowed_admin}
                        <a href="/admin/index.php?section=Order&amp;delete_comment_id={$comment->id}&amp;order_id={$Order->order_id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
                        {/if}
                        {$comment->date}
                        <br>
                        <b>{if $comment->commenter_id != 0}{$comment->name}{else}Система{/if}</b>: {$comment->text|escape|nl2br}
                        <br>
                        </td>
                    </tr>
                {/foreach}
            {/if}
            {if $allowed_admin}
            <tr>
                <td class="model">Менеджер заказа</td>
                <td class="m_t">
                    <p>
                        <select name=manager_id class="select2" style="width:335px;">
                          <OPTION VALUE='' {if !$User->manager_id}SELECTED{/if}>Нет</OPTION>
                         {foreach key=key item=manager from=$Managers}
                            {if $manager->user_id == $Order->manager_id}
                              <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                            {else}
                              <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                            {/if}
                          {/foreach}
                        </select>
                    </p>
                </td>
            </tr>
            {/if}
            <tr>
                <td class="model">Упаковщик заказа</td>
                <td class="m_t">
                    <p>
                        <select name=packer_id class="select2" style="width:335px;" {if $Order->packer_id && !$allowed_admin}disabled{/if}>
                          <OPTION VALUE='' {if !$Order->packer_id}SELECTED{/if}>Нет</OPTION>
                         {foreach key=key item=manager from=$Logists}
                            {if $manager->user_id == $Order->packer_id}
                              <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                            {else}
                              <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                            {/if}
                          {/foreach}
                        </select>
                    </p>
                </td>
            </tr>
            <tr>
                <td class="model">Возврат по заказу принял</td>
                <td class="m_t">
                    <p>
                        <select name=return_manager_id class="select2" style="width:335px;" {if $Order->return_manager_id && !$allowed_admin}disabled{/if}>
                          <OPTION VALUE='' {if !$Order->return_manager_id}SELECTED{/if}>Нет</OPTION>
                         {foreach key=key item=manager from=$Logists}
                            {if $manager->user_id == $Order->return_manager_id}
                              <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                            {else}
                              <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                            {/if}
                          {/foreach}
                        </select>
                    </p>
                </td>
            </tr>
            {if $allowed_admin || $smarty.session.user->group_id}
            <tr>
                <td class="model">Курьер заказа</td>
                <td class="m_t">
                    <p>
                        <select name=courier_id class="select2" style="width:335px;">
                          <OPTION VALUE='' {if !$User->courier_id}SELECTED{/if}>Нет</OPTION>
                         {foreach key=key item=manager from=$Managers}
                            {if $manager->user_id == $Order->courier_id}
                              <OPTION VALUE='{$manager->user_id}' SELECTED>{$manager->name|escape}</OPTION>
                            {else}
                              <OPTION VALUE='{$manager->user_id}'>{$manager->name|escape}</OPTION>
                            {/if}
                          {/foreach}
                        </select>
                    </p>
                </td>
            </tr>
            {/if}
            <tr>
                <td class="model">Адрес</td>
                <td class="m_t"><p><input id=address name="address" type="text" class="input3" value='{$Order->address|escape}' {if $DeliveryAgent}disabled{/if}/>
                <br>
                <a id=maplink href="http://maps.yandex.ru/?text={$Order->address|escape}" target="_blank">найти адрес на карте</a>
                </p></td>
            </tr>
            {if $Order->user_comment}
                <tr>
                    <td class="model">Комментарий клиента</td>
                    <td class="m_t"><p>{$Order->user_comment|escape}</p></td>
                </tr>
            {/if}
            {if $comments}
                <tr><td colspan=2><h2>История комментариев заказа</h2></td></tr>
                {foreach from=$comments item=comment}
                    <tr>
                        <td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
                            <div style="width:335px">
                                {if $comment->user_id == $smarty.session.user->user_id || $allowed_admin}
                                <a href="/admin/index.php?section=Order&amp;delete_comment_id={$comment->id}&amp;order_id={$Order->order_id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
                                {/if}
                                {$comment->date}
                                <br>
                                <b>{if $comment->user_id != 0}{$comment->name}{else}Система{/if}</b>: {$comment->text|escape|nl2br}
                                <br>
                            </div>
                        </td>
                    </tr>
                {/foreach}
            {/if}
            <tr>
                <td class="model">Комментарий менеджера</td>
                <td class="m_t"><p><textarea id="comment" name="comment" class='textarea2'></textarea></p></td>
            </tr>
            <tr>
                <td class="model">Типовые комментарии</td>
                <td class="m_t">
                    <select class="select2" id="def_comments" style="width:335px;">
                        <option value=''>Выберите комментарий</option>
                        <option value='подтверждаем наличие'>подтверждаем наличие</option>
                        <option value='наличие подтверждено. отправляем'>наличие подтверждено. отправляем</option>
                        <option value='ждем оплаты за доставку'>ждем оплаты за доставку</option>
                        <option value='ждем оплаты всего заказа'>ждем оплаты всего заказа</option>
                        <option value='ждем доставки ранее отправленного заказа №(заполнить номер)'>ждем доставки ранее отправленного заказа №(заполнить номер)</option>
                        <option value='ждем возврата вещи(указать какой) из заказа №(заполнить номер)'>ждем возврата вещи(указать какой) из заказа №(заполнить номер)</option>
                        <option value='клиент просил перезвонить (указать время или дату)'>клиент просил перезвонить (указать время или дату)</option>
                        <option value='произвожу замер вещи'>произвожу замер вещи</option>
                        <option value='заказ находится в стадии наполнения'>заказ находится в стадии наполнения</option>
                        <option value='доставка согласована на позднюю дату (указать дату)'>доставка согласована на позднюю дату (указать дату)</option>
                        <option value='недозвон, перезвонить через 30 минут'>недозвон, перезвонить через 30 минут</option>
                        <option value='напечатал накладную'>напечатал накладную</option>
                        <option value='Упаковал Нижегородов'>Упаковал Нижегородов</option>
                        <option value='Упаковала Самсонова'>Упаковала Самсонова</option>
                        <option value='Упаковала Зимина'>Упаковала Зимина</option>
                        <option value='Упаковал Ильичев'>Упаковал Ильичев</option>
                    </select>
                </td>
            </tr>
        </table>

            <div class="yellow_block">
            <table>
                <tr>
                    <td class="model">Код купона</td>
                    <td class="m_t"><p>
                        <input name="coupon_code" type="text" class="input3" value='{$Order->coupon_code|escape}' />
                    </p></td>
                </tr>
                <tr>
                    <td class="model">Скидка</td>
                    <td class="m_t"><p>
                        <input name="coupon_discount" class="input3" type="text" value="{$Order->coupon_discount}" style="width:60px;" />
                        <select class="input3" name="coupon_type" style="width:60px; height:24px;">
                            <option value="percentage" {if $Order->coupon_type=='percentage'}selected{/if}>%</option>
                            <option value="absolute" {if $Order->coupon_type=='absolute'}selected{/if}>руб.</option>
                        </select>
                    </p></td>
                </tr>
                <tr>
                    <td></td>
                    <td><p>
                        Не применять скидку 5% при оплате онлайн
                        <input name="no_payment_discount" type="checkbox" value='1' {if $Order->no_payment_discount} checked="true" {/if} />
                    </p></td>
                </tr>
            </table>
            </div>

            <div class="yellow_block">
            <table>
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Доставка</span></td>
                    <td class="m_t">
                        <span {if $DeliveryAgent}style="display:none;"{/if}>
                            <input name="delivery_price" id="delivery_price_input" type="text" class="input4" value='{$Order->delivery_price|escape}' />
                            <span style="font-size:10px;">отображается клиенту</span><br>
                        </span>
                        <input name="delivery_agent_price" id="delivery_agent_price_input" type="text" class="input4" value='{$Order->delivery_agent_price|escape}' />
                        <span class=model>стоимость заполняется ТК</span>
                        <span {if $DeliveryAgent}style="display:none;"{/if}>
                            {if $Order->real_delivery_price != '0.00'}
                                <br><span style="font-size:16px;">расчитанная: <span style="color:red;">{$Order->real_delivery_price}</span></span>
                            {/if}
                        </span>
                    </td>
                </tr>
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Агентское вознаграждение</span></td>
                    <td class="m_t">
                      <input name="delivery_agent_fee" id="agent_fee_input" type="text" class="input4" value='{$Order->delivery_agent_fee|escape}' />
                    </td>
                </tr>
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Стоимость возврата</span></td>
                    <td class="m_t">
                      <input name="delivery_return_price" id="delivery_return_price_input" type="text" class="input4" value='{$Order->delivery_return_price|escape}' />
                    </td>
                </tr>
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Дата доставки</span></td>
                    <td class="m_t">
                        <span>
                            <input name="delivery_date" id="delivery_date_input" type="text" class="input4" style="width:150px;" value='{$Order->delivery_date|escape}' />
                            <span class=model>ГГГГ-ММ-ДД</span>
                        </span>
                    </td>
                </tr>
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Согласованная дата доставки</span></td>
                    <td class="m_t">
                        <span>
                            <input name="agreed_delivery_date" id="date_time_picker" type="text" class="input4" style="width:150px;" value='{if $Order->agreed_delivery_date != 0}{$Order->agreed_delivery_date|escape}{/if}' />
                            <span class=model>ГГГГ-ММ-ДД</span>
                        </span>
                    </td>
                </tr>
                <tr {if $DeliveryAgent}style="display:none;"{/if}>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">ТК</span></td>
                    <td class="m_t">
                        <select name="delivery_company_id" id="delivery_company_id" class="select2" style="width:100%;">
                            <option value='0'>Не определена</option>
                            {foreach name=payment from=$DeliveryCompanies item=dc}
                            <option value='{$dc->id}' {if $dc->id == $Order->delivery_company_id}selected{/if}>{$dc->name}</option>
                            {/foreach}
                        </select>
                    </td>
                    <!--<td class="model">
                        <input type="hidden" name="delivery_company_id" value='{$Order->delivery_company_id|escape}'>
                        {if $Order->delivery_company_id == 0}
                            <span>Не определена</span>
                        {else}
                            {foreach from=$DeliveryCompanies item=dc}
                            {if $dc->id == $Order->delivery_company_id}<span>{$dc->name}</span>{/if}
                            {/foreach}
                        {/if}
                    </td>-->
                </tr>
                {if $U_companies}
                    <tr {if $DeliveryAgent}style="display:none;"{/if}>
                        <td class="model" style="font-size:10px;">Предпочитаемые ТК:</td>
                        <td class="model" style="font-size:10px;">
                        {foreach from=$U_companies item=dc}
                            <span style="color:red;">{$dc->name}</span>,
                        {/foreach}
                        </td>
                    </tr>
                {/if}
                {if $Order->delivery_company_id == 1}
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Код доставки</span></td>
                    <td class="m_t"><p><input name="delivery_code" type="text" class="input3" value='{$Order->delivery_code|escape}'><br><span style="font-size:10px;">для СПСР</span></p></td>
                </tr>
                {/if}
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Номер накладной</span></td>
                    <td class="m_t"><p><input id="invoice_number" name="invoice_number" type="text" class="input3" value='{$Order->invoice_number|escape}'><br></p></td>
                </tr>
                <tr>
                    <td class="model" style="font-size:10px;"><span style="font-size:16px;">Номер возврвтной накладной</span></td>
                    <td class="m_t"><p><input id="return_invoice_number" name="return_invoice_number" type="text" class="input3" value='{$Order->return_invoice_number|escape}'><br></p></td>
                </tr>
            </table>
            </div>

            <div class="yellow_block">
            <table>
                <tr {if $DeliveryAgent}style="display:none;"{/if}>
                    <td class="model">Статус заказа</td>
                    <td class="m_t"><p>
                        <select id="order-status" name=status class="select2" {if $SCenabled != true && !$allowed_admin} disabled {/if}onchange='document.getElementById("notify_user").checked=1;'>
                            {if $Order->status < 2}
                              <option value=0 {if $Order->status==0}selected{/if}>Новый</option>
                              {if ($can_process && $Order->city) || $Order->status >=1 }<option value=1 {if $Order->status==1}selected{/if}>В обработке</option>{/if}
                            {/if}
                            <option value=6 {if $Order->status==6}selected{/if}>Доставка (заполните код доставки выше)</option>
                            <option value=2 {if $Order->status==2}selected{/if}>Выполнен</option>
                            {if $Order->manager_id == $smarty.session.user->user_id || $allowed_admin || $Order->status==3}<option value=3 {if $Order->status==3}selected{/if} onclick="$('#fault_reason_container').show();">Отмена заказа</option>{/if}
                            <option value=5 {if $Order->status==5}selected{/if}>Самовывоз</option>
                        </select>
                    </p></td>
                </tr>
                {if !$DeliveryAgent}
                <tr id="fault_reason_container" {if $Order->status!=3}style="display:none;"{/if}>
                    <td class="model">Причина отмены</td>
                    <td class="m_t"><p>
                      <select id="fault_reason" name=fault_reason class="select2">
                        <option value="" {if !$Order->fault_reason}selected{/if}>Выбрать</option>
                        <option value="out_of_stock" {if $Order->fault_reason=='out_of_stock'}selected{/if}>Нужного размера нет в наличии</option>
                        <option value="offline_shop" {if $Order->fault_reason=='offline_shop'}selected{/if}>Самовывоз из магазина</option>
                        <option value="consultation" {if $Order->fault_reason=='consultation'}selected{/if}>Оказана консультация</option>
                        <option value="unreachable" {if $Order->fault_reason=='unreachable'}selected{/if}>Не удалось связаться</option>
                        <option value="duplicate" {if $Order->fault_reason=='duplicate'}selected{/if}>Дубль</option>
                        <option value="other" {if $Order->fault_reason=='other'}selected{/if}>Другое</option>
                      </select>
                       <!-- <textarea id='fault_reason' name="fault_reason" cols="40" rows="7">{$Order->fault_reason}</textarea>-->
                    </p></td>
                </tr>
                {/if}
                <tr>
                    <td class="model">Статус доставки</td>
                    <td class="m_t"><p>
                        <select name="delivery_status" class="select2 delstatus" {if !$DeliveryAgent && !$allowed_admin && ($smarty.session.user->group_id == 5 && $smarty.session.user->subgroup_id != 3) || ($SCenabled != true && !$allowed_admin)}disabled{/if} {literal}onchange='if(this.value === "3"){document.getElementById("notify_user").checked=1;}'{/literal}>
                            {foreach from=$DeliveryStats item=statname key=statid}
                                <option value={$statid} {if $Order->delivery_status==$statid}selected{/if}>{$statname}</option>
                            {/foreach}
                        </select>
                    </p></td>
                </tr>
                <tr>
                    <td class="model">Форма оплаты</td>
                    <td class="m_t"><p>
                        <select name="payment_method_id" class="select2" {literal}onchange="if(this.value>0){val=1;}else{val=0};document.getElementById('payment_status').checked=val;"{/literal}{if $DeliveryAgent}disabled{/if}>
                            <option value='0' {if !$Order->payment_method_id}selected{/if}>Не определена</option>
                            {foreach name=payment from=$PaymentMethods item=payment_method}
                            <option value="{$payment_method->payment_method_id}" {if $payment_method->payment_method_id == $Order->payment_method_id}selected{/if}>{$payment_method->name}</option>
                            {/foreach}
                        </select>
                    </p>
                    </td>
                </tr>
                <tr>
                    <td class="model">Предоплата</td>
                    <td class="m_t"><p>
                        <input name="payment_prepaid" id="payment_prepaid" type="text" class="select2" value='{$Order->payment_prepaid}' placeholder="Внесенная клиентом">
                    </p></td>
                </tr>
                <tr>
                    <td class="model">Способ предоплаты</td>
                    <td class="m_t"><p>
                        <select name="prepaid_method_id" id="prepaid_method_id" class="select2" {if $DeliveryAgent}disabled{/if}>
                            <option value='0'{if !$Order->prepaid_method_id}selected{/if}>Не определена</option>
                            {foreach name=payment from=$PaymentMethods item=payment_method}
                            <option value="{$payment_method->payment_method_id}" {if $payment_method->payment_method_id == $Order->prepaid_method_id}selected{/if}>{$payment_method->name}</option>
                            {/foreach}
                        </select>
                    </p>
                    </td>
                </tr>
                <tr>
                    <td class="model">Оплата с депозита</td>
                    <td class="m_t"><p>
                        <span class=model>Оплачено: <span id='paid'>{$Order->deposit_payment}</span></span><br/>
                        <input id="deposit_payment" name="deposit_payment" type="text" class="select2" value='' placeholder="Сумма для снятия">
                        {if $deposit && ($allowed_admin || $allowed_accountant)}
                        <input type="button" value="Снять с депозита" class="from_deposit" style="margin-top:2px; width:169px; padding: 2px 0;">
                        <div style="float:left;"></div>
                        {/if}
                    </p></td>
                </tr>
                {if $Order->payment_status}
                <tr>
                    <td class="model">Дата оплаты</td>
                    <td class="m_t"><p>
                      <span class=model>{$Order->payment_date}</span>
                    </p></td>
                </tr>
                {/if}
                {if $DeliveryAgent}
                <tr>
                    <td>
                    </td>
                    <td>
                        <input name=delivery_paid id=payment_status type="checkbox" class="checkbox" {if $Order->delivery_paid==1}checked{/if} value='1' /><span class="akt">Услуги ТК оплачены</span>
                    </td>
                </tr>
                {/if}
                <tr>
                    <td class="model">Статус оплаты заказа</td>
                    <td class="m_t"><p>
                        <select name="money_status" class="select2" {if !$DeliveryAgent}disabled{/if}>
                            {foreach from=$MoneyStats item=statname key=statid}
                                <option value={$statid} {if $Order->money_status==$statid}selected{/if}>{$statname}</option>
                            {/foreach}
                        </select>
                    </p></td>
                </tr>
                </table>
            </div>

            <p >
				<label><input type='checkbox' name='notify_user' id='notify_user' value='1'> Уведомить пользователя о состоянии заказа</label>
				<input id="submit-order" type="submit" value="Сохранить" class="submit"/>
			</p>
            {if $show_partner}
			<p >
				<!--<label><input type='checkbox' name='partner_order' id='partner_order' {if $Order->partner_order==1}checked{/if} value='1'></label>-->
			</p>
            {/if}
    </div>


<div id="over_right">
<div class="gray_block1">

<span class="model">Что заказано:</span>
<table class="order_products">
{foreach from=$Order->products item=product}
{if !($DeliveryAgent && in_array($product->status,array(1,3)))}<tr>

<td class="td_1">
  <a href="http://{$root_url}/products/{$product->url}/" target="_blank">{$product->product_name}</a><br>
  {$product->sku}<br>
  {if $product->status == 5}(принят)
  {elseif $product->status==4}(отказ и возврат)
  {elseif $product->status==3}(нет товара)
  {elseif $product->status==2}(Потерян ТК)
  {elseif $product->status==1}(отказ клиента){/if}<br>
  {if $product->process_status}Статус обработки: {$product->process_status}<br>{/if}
  <a class="P_images" title='название:{$product->product_name} / артикул:{$product->sku} / цена:{$product->quantity} &times; {$product->price|string_format:"%.0f"} / размер:{$product->size}' href="https://lsboutique.ru/files/products/{$product->large_image}"><img src="https://lsboutique.ru/reimg/files/products/85x/{$product->large_image}"></a>
  {if $DeliveryAgent || $allowed_admin || ($smarty.session.user->group_id == 5 && $smarty.session.user->subgroup_id == 3)}
    <select class="prodstatus" style="width:132px;margin-top:10px;" name="products_status[{$product->id}]" onchange="if ( $(this).val() != '0' ) $('#status_date_{$product->id}').show(); else $('#status_date_{$product->id}').hide();">
    {foreach from=$products_status_select item=status key=statusid}
        <option value="{$statusid}" {if $statusid == $product->status}selected{/if}>{$status}</option>
    {/foreach}
    </select><br/>
    {if !$product->deposit_id}
      <input type="button" value="На депозит" data-id="{$product->id}" data-price="{$product->price}" data-model="{$product->product_name}" class="to_deposit" style="display:none; margin-top:5px;">
      <div style="float:left;"></div>
    {/if}
  {/if}
</td>
<td class="td_2" style="width:auto;">
    Начальная: {$product->quantity} &times; {if $product->offline_price != 0}{$product->offline_price}{else}{$product->price}{/if}<br />
    {if $product->offline_price != 0}Со скидкой: {$product->quantity} &times; {$product->price}{/if}<br />
    Продажи: {$product->quantity} &times; <span data-order-product-id="{$product->id}" class="product-price">{$product->price|string_format:"%.0f"}<br /></span>
    {if $product->sale != 0}Скидка: {$product->sale}%{/if}<br />
  {if $smarty.session.user->group_id == 2 || $smarty.session.user->group_id == 5}
    <span class="product-price-input" data-order-product-id="{$product->id}" style="display:none;">
      <input value="{$product->price}" style="width:72px;"><br>
      <a href="#" class="update-product-price">Применить</a>
      <a href="#" class="cancel-product-price">Отмена</a>
      <br />
    </span>
  {/if}
{if $Order->status == 1 || $Order->status == 0}
    <select style="{if $DeliveryAgent}display:none;{/if}width:178px;margin-top:10px;" data-product-id="{$product->id}" class="product_size" name="products_size[{$product->id}]">
        <option value="0">Размер не выбран</option>
      {foreach from=$product->items item=i}
        <option value="{$i->item_id}" {if $product->size == $i->size || $product->barcode == $i->barcode}selected{/if}>{$i->size} (ш/х {$i->barcode})</option>
      {/foreach}
    </select>
    {if $product->u_sizes == 1}{elseif $product->u_sizes}
      <br/><span style="color:{if $product->u_sizes|strstr:$product->size}green{else}red{/if};">Размеры пользователя {$product->u_sizes}</span>
    {else}
      <br/><span style="color:red;">Заполнить размеры пользователя!</span>
    {/if}
{else}
    <input type="hidden" name="products_size[{$product->id}]" value="{$product->size}">
    <b>{$product->size}</b>
{/if}
{if $DeliveryAgent}{$product->size}{/if}
</td>
<td {if $DeliveryAgent || $Order->status != 1}style="display:none;"{/if} width="10%" valign="top">
    <a style="float:right;" href="{$product->clone_url}" title="Клонировать товар" class="fl" onclick="return confirm('Вы уверены, что хотите КЛОНИРОВАТЬ товар?');"><img src="./images/lamp_on.jpg" alt="" class="fl_ch" style="padding: 0 0 0 0 ;"/></a>
    <a style="float:right;" href="{$product->delete_url}" title="Удалить товар" class="fl" onclick="return confirm('Вы уверены, что хотите УДАЛИТЬ товар?');"><img src="./images/cancel.jpg" alt="" class="fl_ch" style="padding: 10px 0 0 0 ;"/></a>
</td>
</tr>
{/if}
{/foreach}
{if $Order->delivery_method}
<tr>
<td class="td_1">
  Доставка
</td>
<td>
</td>
<td class="td_2">
   <span id='delivery_price'>{$Order->delivery_price*$MainCurrency->rate_from/$MainCurrency->rate_to|string_format:"%.0f"}</span>
</td>
<td>
</td>
</tr>
{/if}
<tr>
<td class="td_3">
  Итого
</td>
<td class="td_3">
</td>
<td class="td_4">
  {$Order->amount+$Order->delivery_price}
</td>
<td class="td_3">
</td>
</tr>
{if $Order->discount_amount}
<tr>
<td class="td_3">
  Со скидкой
</td>
<td class="td_3">
</td>
<td class="td_4">
  {$Order->discount_amount}
</td>
<td class="td_3">
</td>
</tr>
{/if}
{if $Order->accepted_amount}
<tr>
<td class="td_3">
  Приняли
</td>
<td class="td_3">
</td>
<td class="td_4">
  {$Order->accepted_amount}
</td>
<td class="td_3">
</td>
</tr>
{/if}
{if $Order->returned_amount}
<tr>
<td class="td_3">
  Отказались
</td>
<td class="td_3">
</td>
<td class="td_4">
  {$Order->returned_amount}
</td>
<td class="td_3">
</td>
</tr>
{/if}
</table>
</div>
</div>

<div id="over_right" style="margin-top:50px;">
    <div class="gray_block1">
        <p style="float:right;">
            <br>
            <br>
            <h3>{$request_spsr_status}</h3>
            <br>
            <input type="button" value="Обратная накладная" class="submit" onclick="if (confirm('Вы уверены, что хотите сформировать и отправить обратную накладную?')) window.location='{$request_spsr}&norequest_spsr=4';" style="width:350px;margin:0 2px 10px;"/>
            <br>
            <br>
            {if !$DeliveryAgent && !$Order->invoice_number}
            <div id="cdek-loader" class="lds-facebook" style="display: none;"><div></div><div></div><div></div></div>
            <div id="cdek-info"></div>
            <br>
            <div id="cdek-block" style="border:1px solid #ccc;width:351px;float:right;margin-bottom:10px;">
                <div style="width:350px;float:right;">Выбрать тариф CDEK</div>
                <select id="tariff" style="width:350px;margin-bottom:10px;float:right;" name="tariff">
                  <option value="1" {if $tariff == 1}selected{/if} >Экспресс-Лайт дверь-дверь</option>
                  <option value="3" {if $tariff == 3}selected{/if} >Супер-Экспресс 18</option>
                  <option value="139" {if $tariff == 139}selected{/if} >Посылка Дверь-Дверь</option>
                  <option value="138" {if $tariff == 138}selected{/if} >Посылка Дверь-Склад</option>
                </select><br/>
                {foreach from=$cdek_accounts item=cdek_account}
                  <input type="button" value="Авт. накладная в {$cdek_account->name}" class="submit cdek" data-text="ВН" data-ip="{$cdek_account->id}" style="width:350px;margin-bottom:10px;"/><br>
                {/foreach}
            </div>
                <!--<input type="button" value="Автоматическая накладная в СПСР" class="submit" onclick="if (confirm('Вы уверены, что хотите сформировать накладную и отправить в СПСР?')) window.location='{$request_spsr}';" style="width:350px;margin:0 2px 10px;"/><br><br>-->
                <input type="button" value="Автоматическая накладная в ПОНИ" class="submit" onclick="if (confirm('Вы уверены, что хотите сформировать накладную и отправить в ПОНИ Экспресс?')) window.location='{$request_spsr}&norequest_spsr=2';" style="width:350px;margin:0 2px 10px;"/>
            {/if}
            <br><br>
            <a href="{$order_print_link}" target="_blank">Печатная форма накладной СПСР</a><br>
            <a href="{$order_print_link}&excel" target="_blank">Скачать форму накладной для excel</a><br>
            <a href="{$print_reversinvoice_link}" target="_blank">Печатная форма обратной накладной</a><br>
            <a href="{$order_print_ponylink}" target="_blank">Печатная форма накладной ПОНИ Экспресс</a><br>
            <a href="{$order_print_maximalink}" target="_blank">Печатная форма накладной для Maxima Berutti</a>
            <br>
            <a href="{$order_labels_link}" target="_blank">Наклейки на товары</a>
        </p>
    </div>
    <div>
      <h2>Отслеживание доставки</h2>
      {foreach from=$delivery_events item=event}
          <div style="font-size: 14px;margin-bottom: 26px;">{$event->date}
          <br>
          Событие: {$event->description} (г. {$event->city_name})
          <br>
          </div>
      {/foreach}
    </div>
</div>
</div>
</div>
</form>

            <div style="margin-left:226px;">
                <h2>История событий заказа</h2>
                {foreach from=$events item=event}
                    <div style="font-size: 14px;margin-bottom: 26px;">{$event->date}
                    <br>
                    Событие: {$event->text}
                    <br>
                    </div>
                {/foreach}
            </div>

    </div>
  </div>
</div>
<!-- Content #End /-->
<div id="invoicer" style="display:none">
</div>

<script>
var user_id   = {$Order->user_id},
    order_id  = {$Order->order_id};
var cdek_link   = "{$request_spsr}&norequest_spsr=5";
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
        isRTL: false,
        showMonthAfterYear: false,
        yearSuffix: ''
    };
    $.datepicker.setDefaults($.datepicker.regional['ru']);
    $('#date_time_picker').datetimepicker({
        minDate:    new Date(),
        timeFormat: 'HH:00',
        dateFormat: 'dd-mm-yy'
    });
});
$('.delstatus').each(function() {
    $(this).data('lastSelected', $(this).find('option:selected'));
});
$('.delstatus').change(function() {
prim = false;
$.each($('.prodstatus'), function(i,v) { if (v.value == 0) {prim = true;} });
    if(this.value > 2 && prim) {
        $(this).data('lastSelected').attr('selected', true);
        alert("Необходимо сменить статус товаров 'примерка' на другой.");
    }
});
$('.delstatus').click(function() {
    $(this).data('lastSelected', $(this).find('option:selected'));
});
$("#def_comments").change(function() {
    $("#comment").val($(this).val());
    $(this).val('');
});
$("#comment").change(function() {
    if ( $(this).val().toLowerCase().indexOf("предопл") > -1 ){
        alert("Не забудьте внести предоплату в графу Предоплата!");
    }
});
$(document).on("dblclick", "span.product-price", function(e) {
  $(this).siblings("span.product-price-input").show();
  $(this).hide();
});
$(document).on("click", "a.update-product-price", function(e) {
  e.preventDefault();
  var op_id = $(this).parent().data("order-product-id");
  var price = $(this).siblings("input").val();
  window.location = "/admin/index.php?section=Order&change_price_product="+op_id+"&price="+price;
});
$(document).on("click", "a.cancel-product-price", function(e) {
  e.preventDefault();
  $(this).parent().siblings("span.product-price").show();
  $(this).parent().hide();
});
$(document).on("change", "select.prodstatus", function(e) {
  if ( $(this).val() == '4' ) {
  $(this).nextAll('.to_deposit').slideDown();
  }
  else {$(this).nextAll('.to_deposit').slideUp();}
});


$(document).on("change", ".product_size", function(e) {
  var size = $(this).val(),
  p_id = $(this).data('product-id');
});

$(document).on("click", ".cdek", function(e) {
  var tf = $('#tariff').val(),
      ip = $(this).data('ip'),
      txt = $(this).data('text');
  if (confirm('Вы уверены, что хотите сформировать накладную и отправить в CDEK '+ txt +'?')) {
    $('#cdek-block').hide()
    $('#cdek-loader').show()
    $.get("/rest_api/cdek_delivery_request/"+order_id+"/"+ip+"/"+tf, function(data) {
      $('#cdek-loader').hide()
      console.log(data);
      if (data.order) {
        $('#cdek-info').html("Накладная сформирована, номер накладной заполнен.")
        $('#invoice_number').val(data.order.invoice_number)
        $('#delivery_company_id').val(data.order.delivery_company_id)
      }
      else if (data.error_code) {
        $('#cdek-info').html("Ошибка при формировании накладной CDEK: " + data.error_msg)
        $('#cdek-block').show()
      }
    })
  }
});

$(document).on("click", ".to_deposit", function(e) {
  if (confirm('Вы уверены, что хотите положить стоимость товара на депозит пользователя?')) {
    var t = $(this);
    var data = {
      deposit_sum: t.data('price'),
      resiever_info: user_id,
      order_product_id: t.data('id'),
      order_id: order_id,
      field_reason: "Отказ от товара " + t.data('model')
    };
    $.post('/index.php?module=Login&deposit&ajax=1', data, function (r) {
      if(r == 'OK'){
        t.next().append("Депозит сохранен")
        t.remove();
      }
    });
    }
});
$(document).on("submit", "#prodform", function(e) {
  var prepaid_method_id = $('#prepaid_method_id').val(),
    payment_prepaid = $('#payment_prepaid').val();
  if (payment_prepaid > 0 && prepaid_method_id == 0) {
    e.preventDefault();
    alert('Заполните метод предоплаты!');
    $('#prepaid_method_id').focus();
  }

  var orderStatus = $('#order-status').val();
  var faultReason = $("#fault_reason").val();
  var sizeUnset = $('.product_size').toArray().map(e => e.value).some(v => v == 0);
  if (orderStatus == '6' && sizeUnset) {
    alert('Выберите размер для всех товаров.')
    return false
  }
  if (orderStatus == '3' && faultReason == '') {
    alert('Выберите причину отмены товара');
    return false;
  }
});
$(document).on("change", "#order-status", function(e) {
  var orderStatus = $('#order-status').val()
if (orderStatus == '3') {$('#fault_reason_container').show();}
if (orderStatus != '3') {$('#fault_reason_container').hide();}
});

$(document).on("click", ".from_deposit", function(e) {
  var sum = $('#deposit_payment').val();
  if (sum == ''){
    var message = 'Будет оплачена максимальная сумма заказа, Вы уверены, что хотите снять деньги с депозита пользователя?';
  }
  else{var message = 'Вы уверены, что хотите снять указанную сумму с депозита пользователя?';}
  if (confirm(message)) {
    var t = $(this);
    var data = {
      sum: sum,
      user_id: user_id,
      order_id: order_id
    };
    console.log(data);
    $.post('/admin/index.php?section=Order&pay_from_deposit', data, function (r) {
      console.log(r);
      if(r > 0){
        var p = parseInt($('#paid').html()),
            r = parseInt(r);
        $('#paid').html(p+r);
        t.next().append("Депозит сохранен")
        t.remove();
      }
    });
    }
});
$(document).on("click", "a.pack_order", function(e) {
  e.preventDefault();
  var order = $(this).data('order-id');
  var link = $(this);
  console.log(order);
  $.get("/admin/index.php?section=Orders&pack_order="+order, function(r) {
    if(r=='ok'){
      link.css('font-weight','bold');
      link.next().css('font-weight','normal');
    }
  });
});
$(document).on("click", "a.unpack_order", function(e) {
  e.preventDefault();
  var order = $(this).data('order-id');
  var link = $(this);
  console.log(order);
  $.get("/admin/index.php?section=Orders&unpack_order="+order, function(r) {
    if(r=='ok'){
      link.css('font-weight','bold');
      link.prev().css('font-weight','normal');
    }
  });
});
</script>
{/literal}
