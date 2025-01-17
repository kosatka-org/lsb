<script src="/jscript/jquery.autocompleteNew.js"></script>
<link media="all" href="/jscript/jquery.autocompleteNew.css" rel="stylesheet" type="text/css" />
<div id="inserts_all">
  <!-- Вкладки /-->
  <ul id="inserts">
	{if !$DeliveryAgent}
    <li><a href="/admin/index.php?section=Oneclick&new_orders=1" class="off">предобработка</a></li>
    <li><a href="index.php?section=Orders" class="{if $View=='new'}on{else}off{/if}">новые</a></li>
    <li><a href="index.php?section=Orders&view=process" class="{if $View=='process'}on{else}off{/if}">обработка</a></li>
    <li><a href="index.php?section=Orders&view=delivery" class="{if $View=='delivery'}on{else}off{/if}">доставка</a></li>
    <li><a href="index.php?section=Orders&view=done" class="{if $View=='done'}on{else}off{/if}">выполнены</a></li>
    <li><a href="/admin/index.php?section=Special_orders" class="{if $View=='spec'}on{else}off{/if}">спец.заказы</a></li>
    </ul>
   <ul style="float:right; padding: 4px 0 5px 0;">
    <li style="display: inline;"><a href="index.php?section=Orders&view=cancel" class="{if $View=='cancel'}on{else}off{/if}">отменённые</a></li>
    <li style="display: inline;"><a href="index.php?section=Orders&view=search" class="{if $View=='search'}on{else}off{/if}">поиск</a></li>
  {else}
    <li><a href="index.php?section=Orders&delivery=stats" class="{if $DelView && $DelView=='stats'}on{else}off{/if}">статистика</a></li>
    {foreach from=$DeliveryStats item=stat key=statkey}
    <li><a href="index.php?section=Orders&delivery={$statkey}" class="{if $DelView==$statkey}on{else}off{/if}">{$stat}</a></li>
    {/foreach}
  {/if}
  </ul>
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a> →
          <a href="index.php?section=Special_orders">Специальные заказы</a> →
          <a href="index.php?section=Special_orders&s_order={$item->so_id}">Спец.заказ №{$item->so_id}</a>
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
	    <!-- /Иконка раздела /-->
	    
	    <!-- Заголовок раздела /-->
        <h1 id="headline" data-id="{$item->so_id}">Специальный заказ №{$item->so_id}</h1>
        <!-- /Заголовок раздела /-->
        
        
		 <!-- Помощь2 /-->
        <div class="help2">
            
        </div>
        <!-- /Помощь2 /-->

      </div>

      <div id="cont_center">
     
          
        <div class="clear">&nbsp;</div>	  
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
    <div id="over">
    {if $item->order_id}<h2>Создан заказ №<a href="/admin/index.php?section=Order&order_id={$item->order_id}" target="_blank">{$item->order_id}</a></h2>{/if}
        <div id="over_left">
        <form autocomplete="off" action="/admin/index.php?section=Special_orders&update_order={$item->so_id}" method="post" name="s_order_form" id="s_order_form" enctype="multipart/form-data">
            <table>
                <tr>
                    <td class="model">Товар</td>
                    <td class="model">
                        <a href='/products/{$item->url}' target="_blank" style="font-size:16px;">{$item->p_model}</a>
                        <p><a href="/products/{$item->url}" target="_blank"><img src="/reimg/files/products/85x/{$item->large_image}" style="float:left;" /></a></p>
                    </td>
                </tr>
                <tr>
                    <td class="model">Размер</td>
                    <td class="model"><p>
                        <select name="product_size" id="product_size">
                            <option selected value="">---</option>
                            {if $item->parent == 2 || $item->category_id == 2}
                                {foreach from=$shoesizes item=size}
                                    <option value="{$size}" {if $item->product_size == $size}selected{/if}>{$size}</option>
                                {/foreach}
                            {elseif $item->parent == 4 || $item->category_id == 4}
                                <option value="undefined">Нет размера</option>
                            {else}
                                {foreach from=$sizes item=size}
                                    <option value="{$size}" {if $item->product_size == $size}selected{/if}>{$size}</option>
                                {/foreach}
                            {/if}
                        </select>
                    </p></td>
                </tr>
                <tr>
                    <td class="model">Дата</td>
                    <td class="model"><p>{$item->create_date}</p></td>
                </tr>
                <tr>
                    <td class="model">Дата<br/> окончания</td>
                    <td class="model"><p><input name="end_date" class="date_time_picker" type="text" style="width:200px;" value="{$item->end_date}"/></p></td>
                </tr>
                <tr>
                    <td class="model">Имя пользователя</td>
                    <td class="model"><p>{if $item->user_id}<a href='/admin/index.php?section=User&user_id={$item->user_id}' target="_blank" style="font-size:14px;">{$item->user_name}</a>{else}{$item->user_name}{/if}</p></td>
                </tr>
                <tr>
                    <td class="model">Телефон</td>
                    <td class="model"><p>{$item->user_phone}</p></td>
                </tr>
                {if $item->user_email}
                <tr>
                    <td class="model">Email</td>
                    <td class="model"><p>{$item->user_email}</p></td>
                </tr>
                {/if}
                {if $item->card_number}
                <tr>
                    <td class="model">Номер карты</td>
                    <td class="model"><p>{$item->card_number}</p></td>
                </tr>
                {/if}
                <tr>
                    <td class="model">Менеджер заявки</td>
                    <td class="model">
                    <p>
                        <select name="manager_id" id="manager_select" {if $smarty.session.user->group_id != 2}disabled{/if} value="" /> 
                          {foreach from=$managers item=manager}
                            <option value="{$manager->user_id}" {if $manager->user_id == $item->manager_id}selected{/if}>{$manager->name}</option>
                          {/foreach}
                        </select>
                    </p>
                    </td>
                </tr>
                {if $item->comments}
                    <tr><td colspan=2><h2>История комментариев</h2></td></tr>
                    {foreach from=$item->comments item=comment}
                        <tr>
                            <td colspan=2 style="font-size: 14px;padding-bottom: 16px;">
                            {if $comment->commenter_id == $smarty.session.user->user_id}
                            <a href="/admin/index.php?section=Special_orders&amp;update_order={$item->so_id}&amp;delete_comment_id={$comment->id}" title="Удалить комментарий" class="fl" onclick="return confirm('Вы уверены, что хотите удалить комментарий?');"><img src="./images/cancel.jpg" alt="Удалить комментарий" class="fl_ch" style="padding: 12px 10px 0 0 ;"></a>
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
                    <td class="model">Комментарий менеджера</td>
                    <td class="m_t"><p><textarea id="comment" name="comment" class='textarea2'></textarea></p></td>
                </tr>
            </table>
            <input type="submit" style="float:right;" value="Сохранить" onclick="jQuery('#s_order_form').submit();return false;">
          </form>
        </div>
        <div id="over_right" style="font-size:14px;margin-top:50px;">
            <table style="width:100%;">
                <tr>
                    <td colspan="3" style="width:100%;border-bottom:1px #d0d0d0 solid;">
                        <div class="on u_link" id="t1" style="background:none;float:left;padding: 6px 10px;">Найти<br /> пользователя</div>
                        <div class="off u_link" id="t2" style="background:none;float:left; margin-left: 5px;padding: 6px 10px;">Создать<br /> пользователя</div>
                        <div class="off u_link" id="t3" style="background:none;float:left; margin-left: 5px;padding: 6px 10px;">Оформить<br /> заказ</div>
                    </td>
                </tr>
            </table>
            <div class="u_tab t1" style="margin:10px;">
                <form autocomplete="off" action="/index.php?module=Cart&client_find&spec&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'))" method="post" name="find_user" enctype="multipart/form-data">
                    <div>
                        <div>
                            Телефон, почта или Имя
                        </div>
                        <div style="float: left; margin: 10px 10px 10px 0; width: 100%;">
                            <input type="text" name="client_info" class="simple_big" id="client_info" value="">
                            <div class="person"></div>
                        </div>
                        <div style="float: left; width: 100%;">
                            <a href="#" onclick="jQuery('.popResult').load('/index.php?module=Cart&amp;client_find&amp;spec&amp;search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'));return false;" style="border-width:0px;">
                                <input type="submit" id="client_info" value="Найти">
                            </a>
                        </div>
                        <div class="clear"></div>
                        <div class="popResult"></div>
                    </div>
                </form>
            </div>
            <div class="u_tab t2" style="margin:10px;display:none;">
                <form autocomplete="off" action="/index.php?module=Login&client_add&spec_assign={$item->so_id}" method="post" name="client_add" id="client_add" enctype="multipart/form-data">
                    <div>
                        <div>
                            Имя Отчество<br/>
                            <input placeholder="Имя Отчество" type="text" name="name" id="name" {literal}class="simple_big validate[required]"{/literal} value="" />
                        </div>
                        <div>
                            Фамилия<br/>
                            <input placeholder="Фамилия" class="simple_big" type="text" name="surname" id="surname" value="" />
                        </div>
                        <div>
                            Телефон<br/>
                            <input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="simple_big validate[required,custom[phone]],custom[number]"{/literal} value="" maxlength="10" />
                        </div>
                        <div>
                            Почта<br/>
                            <input placeholder="Электронная почта" type="text" name="email" id="email" {literal}class="simple_big validate[custom[email]]"{/literal} value="" />
                        </div>
                        <div>
                            Город<br/>
                            <select name="city_id" id="city_id" class="simple_big validate[required]" {if $total < 10000}onchange="$('#delivery_area').html($('#delivery_area_holder').html());$('#delivery_area').load('/delivery_price.php?city_id=' + $('#city_id').eq(0).val() + '&total={$total}&weight={$weight}');"{/if}>
                                <option value="0">Пожалуйста, выберите город</option>
                                <option value="0"> </option>
                                {foreach from=$delivery_cities_main item=delivery_city}
                                    <option value="{$delivery_city->city_id}" ><b>{$delivery_city->city_name}</b></option>
                                {/foreach}
                                <option value="0"> </option>
                                {foreach from=$delivery_cities item=delivery_city}
                                    <option value="{$delivery_city->city_id}" >{$delivery_city->city_name}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div>
                            Адрес<br/>
                            <input placeholder="Адрес" class="simple_big" type="text" name="address" id="address" value="" />
                        </div>
                        <div>
                            Дата рождения<br/>
                            <input placeholder="дд.мм.гггг" class="simple_big" type="text" name="birthday" id="birthday" value="" />
                        </div>
                        <div style="width:100%;height:25px; margin:5px 0;">
                            <div style="float: left;margin: 0 10px 0 0;">
                                Пол
                            </div>
                            <div>
                                <label style="float: left;"><span>М</span><input name="sex" type="radio" value="1" checked style="margin: 4px 4px -4px;"></label>
                                <label style="float: left;"><span>Ж</span><input name="sex" type="radio" value="2" style="margin: 4px 4px -4px;"></label>
                            </div>
                        </div>
                        <div>
                            Размеры<br/>
                            <div style="margin-right: 10px; float:left;">
                                верх<br/>
                                <select name="sizetop">
                                    <option selected value="">---</option>
                                    {foreach from=$sizes item=size}
                                        <option value="{$size}">{$size}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div style="margin-right: 10px; float:left;">
                                низ<br/>
                                <select name="sizebottom">
                                    <option selected value="">---</option>
                                    {foreach from=$sizes item=size}
                                        <option value="{$size}">{$size}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div style="float:left;">
                                обувь<br/>
                                <select name="sizeshoe">
                                    <option selected value="">---</option>
                                    {foreach from=$shoesizes item=size}
                                        <option value="{$size}">{$size}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div style="margin: 32px 0 0 0;">
                        <input type="submit" value="Создать и выбрать" onclick="jQuery('#client_add').submit();return false;">
                    </div>
                </form>
            </div>
            <div class="u_tab t3" style="margin:10px;display:none;">
                <form  autocomplete="off" action="/index.php?module=Cart" method="post" name="form_order" id="form_order" enctype="multipart/form-data">
                    <div>
                        <label for="firstname">Имя</label>
                        <input type="text" class="simple_big" name="name" placeholder="Имя и фамилия" value="{$item->user_name}">
                    </div>
                    <div>
                        <label for="phone">Телефон</label>
                        <input type="text" name="phone" class="simple_big" placeholder="8ХХХХХХХХХХ" value="{$item->phone_number}">
                    </div>
                    <div>
                        <label for="phone">Адрес</label>
                        <input type="text" name="address" class="simple_big" placeholder="Адрес доставки" value="{$item->adress}">
                    </div>
                    <div>
                        <label for="email">Почта</label>
                        <input type="text" class="simple_big" name="email" placeholder="Почта" value="{$item->email}">
                    </div>
                    <div>
                        <label for="comment">Комментарий</label>
                        <textarea name="comment" class="simple_big" placeholder="Комментарий"></textarea>
                    </div>
                    <select name="city_id" class="simple_big">
                        <option value="0">Выберите город</option>
                        {foreach from=$delivery_cities_main item=delivery_city}
                            <option value="{$delivery_city->city_id}" {if $item->city_id == $delivery_city->city_id}selected{/if} ><b>{$delivery_city->city_name}</b></option>
                        {/foreach}
                        <option value="0"> </option>
                        {foreach from=$delivery_cities item=delivery_city}
                            <option value="{$delivery_city->city_id}" {if $item->city_id == $delivery_city->city_id}selected{/if}>{$delivery_city->city_name}</option>
                        {/foreach}
                    </select>
                    <div>
                        <label>
                            <input type="checkbox" name="no_notification" value="1"> Не отправлять оповещения о заказе
                        </label>
                    </div>
                    <input type="hidden" name="user_id" value="{$item->original_user_id}">
                    <input type="hidden" name="so_id" value="{$item->so_id}">
                    <input type="hidden" name="products[{$item->product_id}]" value="{$item->product_size}">
                    <input type="hidden" name="submit_order" value="1">
                    <input type="submit" value="Сформировать заказ" onclick="jQuery('#form_order').submit();return false;">
                </form>
            </div>
        </div>
    </div>
</div>
{literal}      
	<script>
    jQuery.browser = {};
    (function () {
        jQuery.browser.msie = false;
        jQuery.browser.version = 0;
        if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
            jQuery.browser.msie = true;
            jQuery.browser.version = RegExp.$1;
        }
    })();
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
        $('.date_time_picker').datetimepicker({
            minDate:    new Date(),
            timeFormat: '',
            dateFormat: 'yy-mm-dd'
        });
    });
    $(document).on("click touchstart", "a.assign_user", function(e) {
      e.preventDefault();
      var so_id = $('#headline').attr("data-id");
      var user_id = $(this).attr("data-uid");
      window.location = "/admin/index.php?section=Special_orders&client_assign="+user_id+"&update_order="+so_id;
    });
    $(document).on("click touchstart", ".u_link", function() {
        var act_tab = $(this).attr("id");
        $(".u_link").removeClass("on").addClass("off");
        $(this).removeClass("off").addClass("on");
        $(".u_tab").hide();
        $("." + act_tab).show();
    });
	</script>
{/literal}
{literal}      
	<script>
    if ( jQuery("#id_card_number").autocomplete ) {
		jQuery("#id_card_number").autocomplete({
			 source: '/index.php?module=Cart&card_select',
			 minLength:3,
			 appendTo: '.personCard'
		});
		jQuery("#client_info").autocomplete({
			 source: '/index.php?module=Cart&person_select',
			 minLength:3,
			 appendTo: '.person'
		});
	}
	</script>
{/literal}
	  </div>  
    </div>
  </div>	    
</div>
<!-- Content #End /--> 

