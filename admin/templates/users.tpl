<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.0/clipboard.min.js"></script>
<div id="inserts_all">
  <!-- Вкладки /-->
 {include file='users_menu.tpl' active='users'}
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

      <div id="cont_top">
        <!-- Иконка раздела /-->
	    <img src="./images/icon_users.jpg" alt="" class="line"/>
	    <!-- /Иконка раздела /-->

	    <!-- Заголовок раздела /-->
        <h1 id="headline">Покупатели</h1>
        <!-- /Заголовок раздела /-->


      </div>

      <div id="cont_center">
{if $allowed_admin}
        <!-- Левое меню /-->
        <div id="cont_left">

          <ul>
            {if !$smarty.get.group}
            <li class="li_on" style='padding-left:{$level*5+15}px;'>
              <a href="index.php?section=Users">Не определена</a>
            </li>
        	{* /Текущая категория *}
        	{* Категория *}
        	{else}
            <li class="li_off" style='padding-left:{$level*5+15}px;'>
              <a href="index.php?section=Users">Не определена</a>
            </li>
            {/if}

            {foreach from=$Groups item=group}
            {* Выводим категории *}

            {if $group->group_id == $smarty.get.group}
            <li class="li_on" style='padding-left:{$level*5+15}px;'>
              <a href="index.php?section=Users&group={$group->group_id}">{$group->name}</a>
            </li>
        	{* /Текущая категория *}
        	{* Категория *}
        	{else}
            <li class="li_off" style='padding-left:{$level*5+15}px;'>
              <a href="index.php?section=Users&group={$group->group_id}">{$group->name}</a>
            </li>
            {/if}
            {/foreach}
      		{* /Выводим категории *}
          </ul>

        </div>
        <!-- /Левое меню /-->
{/if}

	    <!-- Right Side #Begin/-->
        <div id="cont_right">

          {if $Error}
          <!-- Error #Begin /-->
          <div id="error_minh">
            <div id="error">
              <img src="./images/error.jpg" alt=""/><p>{$Error}</p>
            </div>
          </div>
          <!-- Error #End /-->
          {/if}

          <div class=filter style="width:600px;">
            <form method=get>
              <table><tr><td>
                <input name=keyword type=text  class="input3" value='{$smarty.get.keyword|escape}'><br>
                {if !$smarty.get.group || $smarty.get.group == 1}
                <input name=with_out_sex type=checkbox value=1 id="with_out_sex" {$with_out_sex}><label for="with_out_sex">без пола</label>&nbsp;&nbsp;&nbsp;
                <nobr><input name=with_out_shop type=checkbox value=1 id="with_out_shop" {$with_out_shop}><label for="with_out_shop">без магазина</label></nobr>&nbsp;&nbsp;&nbsp;
                <nobr><input name=with_out_phone type=checkbox value=1 id="with_out_phone" {$with_out_phone}><label for="with_out_phone">проблемы с телефоном</label></nobr>
                <nobr><input name=info_1c type=checkbox value=1 id="info_1c" {$info_1c}><label for="info_1c">Информация из 1С</label></nobr>&nbsp;&nbsp;&nbsp;
                <nobr><input name="big_size" type="checkbox" value="1" id="big_size" {$big_size}><label for="big_size">Big Size</label></nobr>&nbsp;&nbsp;&nbsp;
                <nobr><input name=have_orders type=checkbox value=1 id="have_orders" {$have_orders}><label for="have_orders">есть хотя бы один заказ</label></nobr><br/>
                <nobr>последний заказ более
                <select name=last_purchase class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <option value=''>00</option>
                  <option value='30' {if $last_purchase == 30}SELECTED{/if}>30</option>
                  <option value='60' {if $last_purchase == 60}SELECTED{/if}>60</option>
                  <option value='90' {if $last_purchase == 90}SELECTED{/if}>90</option>
                </select>
                дней назад</nobr><br/>
                <nobr>последний звонок
                <select name=have_calls class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <option value=''>00</option>
                  <option value='30' {if $have_calls == 30}SELECTED{/if}>30</option>
                  <option value='60' {if $have_calls == 60}SELECTED{/if}>60</option>
                  <option value='90' {if $have_calls == 90}SELECTED{/if}>90</option>
                </select>
                дней назад</nobr><br/>
                <nobr>последний заход на сайт
                <select name=logined class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <option value=''>00</option>
                  <option value='30' {if $logined == 30}SELECTED{/if}>30</option>
                  <option value='60' {if $logined == 60}SELECTED{/if}>60</option>
                  <option value='90' {if $logined == 90}SELECTED{/if}>90</option>
                </select>
                дней назад</nobr><br/>
                <select name=p_manager class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <OPTION VALUE='' {if !$p_manager_id}SELECTED{/if}>по менеджеру</OPTION>
                          <OPTION VALUE='none' {if $p_manager_id == 'none'}SELECTED{/if}>без менеджера</OPTION>
                  {foreach key=key item=manager from=$Managers}
                  <OPTION VALUE='{$manager->user_id}' {if $p_manager_id == $manager->user_id}SELECTED{/if}>{$manager->name|escape}</OPTION>
                  {/foreach}
                </select>
                <select name=stars class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <OPTION VALUE='' {if !$stars}SELECTED{/if}>по звездам</OPTION>
                  <OPTION VALUE='1' {if $stars == 1}SELECTED{/if}>1</OPTION>
                  <OPTION VALUE='2' {if $stars == 2}SELECTED{/if}>2</OPTION>
                  <OPTION VALUE='3' {if $stars == 3}SELECTED{/if}>3</OPTION>
                </select>
                <select name=user_status class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <OPTION VALUE='' {if !$U_Status}SELECTED{/if}>по статусу</OPTION>
                  {foreach item=status from=$Statuses}
                  <OPTION VALUE='{$status}' {if $U_Status == $status}SELECTED{/if}>{$status|escape}</OPTION>
                  {/foreach}
                </select>
                <select name=sex class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <OPTION VALUE='' {if !$sex}SELECTED{/if}>по полу</OPTION>
                  <OPTION VALUE='1' {if $sex == 1}SELECTED{/if}>Мужской</OPTION>
                  <OPTION VALUE='2' {if $sex == 2}SELECTED{/if}>Женский</OPTION>
                </select>
                <select name=shop class="select2" style="height:20px;margin-bottom:5px;margin-right: 3px;">
                  <OPTION VALUE='' {if !$shop_selected}SELECTED{/if}>по магазину</OPTION>
                  {foreach item=shop from=$shops}
                  <OPTION VALUE='{$shop->shop_id}' {if $sshop == $shop->shop_id}SELECTED{/if}>{$shop->name|escape}</OPTION>
                  {/foreach}
                </select>
                <select name=brand class="select2" style="height:20px;margin-bottom:5px;width:auto;margin-right: 3px;">
                  <OPTION VALUE='' {if !$brand_id}SELECTED{/if}>по бренду</OPTION>
                  {foreach item=brand from=$brands}
                  <OPTION VALUE='{$brand->brand_id}' {if $brand_id == $brand->brand_id}SELECTED{/if}>{$brand->name|escape}</OPTION>
                  {/foreach}
                </select>
                <select name="city" id="city" class="select2" style="height:20px;margin-bottom:5px;margin-right: 3px;">
                  <option value="0">по городу</option>
                  {foreach from=$delivery_cities_main item=dcity}
                    <option value="{$dcity->city_id}" {if $city == $dcity->city_id}selected{/if}><b>{$dcity->city_name} ({$dcity->region_name})</b></option>
                  {/foreach}
                </select>
              {/if}
              </td><td>
              </td><td width="15%">
              </td><td>
                <input name=section type=hidden value='{$smarty.get.section}'>
                <input name=group type=hidden value='{$smarty.get.group}'>
                <input type='submit' value='Найти' class="submit10" style="float:right;">
              </td></tr></table>
            </form>
          </div>

          <div class="clear">&nbsp;</div>

          {if $Users}
          {if $allowed_admin}
            {if $disabled_users}<a href="index.php{$disabled_users}" onclick="return confirm('Вы точно хотите включить всех пользователей?') ? true : false;" class="btn btn-primary btn-confirm" style="background-color: #337ab7;" title="Включить всех пользователей">Включить всех</a>{/if}
            {if $enabled_users}<a href="index.php{$enabled_users}"onclick="return confirm('Вы точно хотите выключить всех пользователей?') ? true : false;" class="btn btn-primary" style="background-color: #337ab7;" title="Выключить всех пользователей">Выключить всех</a>{/if}
          {/if}

            <table id="list">

              {foreach item=item from=$Users}
              <tr>
                <td valign="top">
                    <a href="index.php{$item->enable_get}" class="fl"><img src="./images/{if $item->enabled}lamp_on.jpg{else}lamp_off.jpg{/if}" alt=""/></a>
                  <div class="list_left" style="width:250px;">
                    <div class="flxc">
                      <p>
					    {if $item->total_purchase_sum > 1500000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $item->total_purchase_sum > 900000}<img src="./images/star_on.jpg"><img src="./images/star_on.jpg">{elseif $item->total_purchase_sum > 300000}<img src="./images/star_on.jpg">{/if}<br />
                        <a href="index.php{$item->edit_get}" class="{if $item->enabled}tovar_on{else}tovar_off{/if}">{$item->name|escape}</a> ({if $item->user_status}{$item->user_status}{else}New{/if})<br />
                        {if $allowed_admin && !$smarty.get.group} {$item->group_name}<br />{/if}
							{if $item->user_age && (!$smarty.get.group || $smarty.get.group == 1)}Пользователь зарегистрировался {$item->user_age} месяцев назад<br />{/if}
						(<span title="original_user_id">{$item->original_user_id|escape}</span>&nbsp;/&nbsp;<span title="код 1C">{$item->code|escape}</span>)<br />
						{if $item->sex == 0}(&nbsp;<a href="/admin/index.php?keyword={$smarty.get.keyword|escape}&with_out_sex=1&section=Users&group={$smarty.get.group}&user_id={$item->user_id}&sex=1">M</a>&nbsp;/&nbsp;<a href="/admin/index.php?keyword={$smarty.get.keyword|escape}&with_out_sex=1&section=Users&group={$smarty.get.group}&user_id={$item->user_id}&sex=2">Ж</a>&nbsp;){/if}
                      </p>
                      <p>
                        <!--<span class="tovar_min">{$item->email|escape}</span>-->
                      </p>
                    </div>
					  {if $item->group_id > 1 && $item->last_ip != ''}
						<div class="flxc">
						  <p>
							<span class="tovar_min">IP: {$item->last_ip|escape}</span><br>
							<!--<span class="tovar_min">{$item->last_user_agent|escape}</span>-->
						  </p>
						</div>
					  {/if}
					 {if $item->last_login_date}<span class="tovar_on">Логин: {$item->last_login_date|escape}</span><br>{/if}
					 {if $item->last_api_login_date}<span class="tovar_on">Аpi логина: {$item->last_api_login_date|escape}</span><br>{/if}
					 <!--{if $item->messengers}
					 Мессенджеры:
					   {foreach from=$Messengers item=Messenger}
							{if in_array($Messenger->id, $item->messengers)}<nobr><img src="/admin/images/icons/{$Messenger->icon}" style="width:15px; margin:4px 4px -4px 0; ">{$Messenger->name}&nbsp;</nobr>{/if}
						{/foreach}
					 {/if}-->
			      </div>
  			    </td>
                <td valign="top">
					<div class="tovar_min" style="width:150px;">
						<!--{$item->city}<br>
						{$item->adress}-->
					</div>
                </td>
                <td valign="top">
                  <div class="list_left">
                      <p>
                        {if $item->track_id == null}
                          <a href="#" class="btn btn-primary app-installed" data-user-id="{$item->user_id}" data-platform="apple" style="background-color: #337ab7;" title="Подтвердить установку приложения">
                            &#10004;
                          </a>
                          <br /><br />
                        {/if}
                        <a href="#" class="btn btn-primary send-wallet-link" data-user-id="{$item->user_id}" style="background-color: #337ab7;" title="отправить карту Wallet">
                          Wallet
                        </a>
                      </p>
                  </div>
                </td>
                <td valign="top">
                  <div class="list_left">
                      <p>
                          <a href="#" class="btn btn-primary send-app-link" data-user-id="{$item->user_id}" data-platform="apple" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на Apple приложение">
                            <i class="icon-envelope"></i> &#8594; <i class="icon-apple"></i>
                          </a><br /><br />
                          <a href="#" class="btn btn-primary send-app-link" data-user-id="{$item->user_id}" data-platform="android" style="background-color: #337ab7;" title="Отправить СМС со ссылкой на Android приложение">
                            <i class="icon-envelope"></i> &#8594; <i class="icon-android"></i>
                          </a>
                        <!--<span class="tovar_min">{$item->phone_number|escape}</span><br>
                        <span class="tovar_min">{$item->card_number|escape}</span>-->
                      </p>
                  </div>
                </td>
                <td valign="top">
                  <div class="list_left">
                      <p>
                        <button class="btn btn-clipboard" data-clipboard-text="{$smarty.server.HTTP_HOST}/?module=Login&action=logout&nordr&phone={$item->phone_number|escape}&card_number={$item->card_number|escape}&no_welcome_sms=1">
                          <i class="icon-copy"></i>
                        </button>
                        <br>
                        <button class="btn btn-login" data-user-id="{$item->user_id}" data-type="sms">
                          <i class="icon-envelope"></i>
                        </button>
                        <br>
                        <button class="btn btn-login" data-user-id="{$item->user_id}" data-type="email">
                          <i class="icon-at"></i>
                        </button>
                      </p>
                  </div>
                </td>
                <td valign="top">
                <div class="list_right">
					{if $item->stop_sms != 1}<!--<img src="/images/stop_sms.png" style="width:25px;cursor:pointer;" title="Добавить в смс СТОП-лист" onclick="if ( !confirm('Вы уверены, что нужно добавить в СТОП-лист?') ) return false; $.get('/index.php?module=Login&do_not_disturb&type=sms&user_id={$item->original_user_id}');$(this).hide();">-->{/if}
					{if $item->orders_num>0}<a href="index.php?section=Orders&view=search&keyword=user:{$item->user_id}" class="fl"><img src="./images/card_on.jpg" title="{$item->orders_num} заказов"/></a>{/if}
					<a href="index.php{$item->delete_get}" class="fl" onclick='if(!confirm("{$Lang->ARE_YOU_SURE_TO_DELETE}")) return false;'><img src="./images/delete.jpg" title="Удалить"/></a>
				</div>
                </td>
              </tr>
              {/foreach}
            </table>
            <input type=submit value='Сохранить изменения' style='display:none;'>


            {else}
              <div class="emptylist">Нет покупателей</div>
            {/if}

            {$PagesNavigation}
            <div class="clear">&nbsp;</div>

        </div>
	    <!-- Right side #End/-->
	  </div>
    </div>
  </div>
</div>

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
