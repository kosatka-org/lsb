<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
{if $language=='eng'}<script src="/jscript/jquery.validationEngine-en.js" type="text/javascript"></script>
{else}<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>{/if}
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocomplete.js"></script>

<!-- Настройки - Ключи - Инфо -->

<script>
var user_sizes = 0;
{if $user_sizes}var user_sizes = 1;{/if}
{literal}
function clearText(thefield){
		if (thefield.defaultValue==thefield.value)
		thefield.value = "";
	}

function GetURLParameter(sParam) {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++)
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam)
        {
            return sParameterName[1];
        }
    }
}

$(document).ready(function() {
    if (GetURLParameter('serv') == 'on') {
        $('ul.tabsSett.tabs1 li').removeClass('tab-current');
        $('ul.tabsSett.tabs1 li.sett6').addClass('tab-current');
        $('div.sett').hide();
		$('div.sett6').show();
    } else {
        $('ul.tabsSett.tabs1 li').removeClass('tab-current');
        $('ul.tabsSett.tabs1 li.sett0').addClass('tab-current');
        $('div.sett').hide();
		$('div.sett0').show();
    }

	if (user_sizes == 0){
		$('#sizes_tab').addClass('red');
	}
	$('#sizes').on('change', 'input[type="checkbox"]', function(){
		var id = $(this).parents('.checks_wrap').attr('id'),
			checkboxes = $(this).parents('.checks_wrap').find("input[type='checkbox']");
		if(!checkboxes.is(":checked")){
			window['user_'+id] = 0;
		}
		else{
			window['user_'+id] = 1;
		}
		if (user_sizes == 0){
			$('#sizes_tab').addClass('red');
		}
		else{
			$('#sizes_tab').removeClass('red');
		}
	});
/*
    if (services_work == 0 && services_done == 0){
        $('.sett6').hide();
    }
*/

    $( ".this_selection_photo" ).error(function() {
        $(this).attr("src","/images/empty_photo.png");
    })


    $(document).on('click', '.service_tabs', function(e) {
        var t = $(this).attr("data-class");
        $(".stab").hide();
        $(".service_tabs").removeClass('act');
        $(this).addClass('act');
        $(".stab."+t).show();
    });

	$("#personal_data").validationEngine();

	$('ul.tabsSett li').css('cursor', 'pointer');

	$('ul.tabsSett.tabs1 li').click(function(){
		var thisClass = this.className.slice(0,5);
		$('div.sett').hide();
		$('div.' + thisClass).show();
		$('ul.tabsSett.tabs1 li').removeClass('tab-current');
		$(this).addClass('tab-current');
	});

    if ($("#stop").prop( 'checked' )){
		$('#subscriptions input').prop({'disabled': true});
	}
	$("#stop").change(function(){
		if ($(this).prop( 'checked' ) == true){
			$('#subscriptions input').prop({'disabled': true});
		}
		else {
			$('#subscriptions input').prop( "disabled", false );
		}
	});

	$("#name").focus();
/*
    $('.avatar').mouseenter(function() {
        $('.avatar_change').fadeIn()
    });
    $('.avatar').mouseleave(function() {
        $('.avatar_change').fadeOut()
    });
*/
});
</script>
<script type="text/javascript">
$(document).ready(function(){
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
                    $(this ).addClass('active-col');
                }
            });
        });
    });
    $(document).on("click", ".conformity-table td",function(){
        $(this).parent().find('.size_check').trigger('click');
    });
    $(document).on("click", "h2.slider",function(){
        $(this).find("i").toggleClass('icon-minus-square-o');
        $(this).next('.conformity-table').slideToggle();
    });
		$(document).on("click", ".conformity-table td .size_check",function(){
        $(this).trigger('click');
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
    $('.alt_address_inp').last().find('input').val('');
  });

  if ($(".ShAA_sexSizeButton.active").attr('id') == 'womensizes') {
    $('.slider').each(function(){
        if (!(Number($(this).attr('id'))%2)) {
            $(this).parent().show();
        }
        else $(this).parent().hide();
    });
  }
  else {
    $('.slider').each(function(){
        if ((Number($(this).attr('id'))%2)) {
            $(this).parent().show();
            }
        else $(this).parent().hide();
    });
  }
  $( ".manager_selection_card" ).click(function() {
    var this_box = $(this);
    $(".manager_selection_card").removeClass("checked");
    this_box.addClass("checked");
    var this_id = $('.checked .manager_selection_id').text();
    $('#this_manager_selection').val(this_id)
  });
  $(document).on("click", ".ShAA_sexSizeButton", function() {
    $(".ShAA_sexSizeButton").removeClass("active");
    $(this).addClass("active");
    if ($(this).attr('id') == 'womensizes') {
        $('.slider').each(function(){
            if (!(Number($(this).attr('id'))%2)) {
                $(this).parent().show();
            }
            else $(this).parent().hide();

        });
    }
    else {
        $('.slider').each(function(){
            if ((Number($(this).attr('id'))%2)) {
                $(this).parent().show();
            }
            else $(this).parent().hide();

        });
    }
  });

  if ($("body").width() < 701) {
    $("ul.tabsSett ").addClass('ShAA_mobilePersonalMenu');
  }
  else {
    $("ul.tabsSett ").removeClass('ShAA_mobilePersonalMenu');
  }
    $(function() {
        $(window).resize(function() {
            if ($("body").width() < 701) {
                $("ul.tabsSett ").addClass('ShAA_mobilePersonalMenu');
            }
            else {
                $("ul.tabsSett ").removeClass('ShAA_mobilePersonalMenu');
            }
        });
    });

    $('ul.ShAA_mobilePersonalMenu li').click(function(){
		$('.ShAA_mobilePersonalMenu').hide();
		$('.ShAA_backLinkMenu').show();
	});

    $('.ShAA_backLinkMenu').click(function(){
        $('.ShAA_backLinkMenu').hide();
		$('.ShAA_mobilePersonalMenu').show();
	});
});
</script>
{/literal}

{literal}
<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-left {
		display: none !important;
	}
	#fancybox-right {
		display: none !important;
	}

	.sett3{
		display: none;
	}

    .ShAA_popBackCenter {
        background: none;
        border: none;
        box-shadow: none;
        width: 70%;
        clear: both;
    }
    ul.tabsSett {
        width: 100%;
    }
    .ShAA_popDataSett .ShAA_popInput input {
        padding: 10px 2%;
    }

    .ShAA_popDataSett .ShAA_popInput select, .ShAA_popBackCenter .ShAA_popButton_input {
        padding: 10px 2%;
        width: 99%;
    }

    .ShAA_popDataSett .phone input {
        width: 93% !important;
    }

    .ShAA_pop_title {
        font-size: 16px;
    }

    .ShAA_subscrCols {
        float: left;
        width: 32%;
    }

    .ShAA_sizeCols {
        width: 20%;
        float: left;
        margin-bottom: 6px;
    }

#personal_data {
    float: left;
    width: 78%;
}

ul.tabsSett {
    float: left;
    width: 18%;
    margin-right: 16px;
}

ul.tabsSett li {
    float: none;
    /*width: 15%;*/
    padding-bottom: 4px;
}

ul.tabsSett li a {
    padding-top: 4px;
    font-size: 14px;
    text-transform: uppercase;
    color: #807f7d;
}

ul.tabsSett li, ul.tabsSett .tab-current {
    border-bottom: none;
    font-weight: 500;
    padding: 0 6px 12px;
}

.avatar img {
    border-radius: 75px;
    max-width: 150px;
    float: left;
    margin: 48px 24px 36px 0;
}

.avatar_change {
    display: block;
    float: left;
    position: relative;
    background: none;
    width: auto;
    margin: 100px 0 0 18px;
    text-align: left;
}

.avatar_change a {
    color: #000;
}

.ShAA_popData .ShAA_popInfoInput {
    display: none;
}

.ShAA_popData .ShAA_popTitleInput {
    margin: 12px 0 0 0;
}

.ShAA_sexInput {
    margin-left: 24px;
}

.ShAA_popData .ShAA_popInput input, .ShAA_popData .ShAA_popInputOrder input {
    width: 95%;
    padding: 12px 2% !important;
}

.profinfo {
    margin-top: 64px;
}
.ShAA_buttonInProfile {
     margin: 32px 0 0 0;
     width: 50%;
}
.icon-minus-square-o::before {
    content: "";
}
.icon-plus-square-o {
    display: inline-block;
    margin-right: 6px;
}
.icon-minus-square-o {
    display: inline-block !important;
    margin-right: 6px;
}

.ShAA_desctopNone {
    display: none;
}

.ShAA_backLinkMenu {
    font-weight: 500;
    text-transform: uppercase;
    float: left;
    border-bottom: 1px solid #767676;
    padding: 8px 4%;
    width: 110%;
    margin-left: -5%;
    margin-bottom: 24px;
    cursor: pointer;
}


@media (max-width: 1420px) {
    .ShAA_popBackCenter {
        width: 90%;
    }
}
@media (max-width: 1024px) {
    .ShAA_popBackCenter {
        width: 100%;
    }

    ul.tabsSett {
        height: 23px;
    }
}
@media (max-width: 930px) {
	table.service{width:100%;}
    .ShAA_popBackCenter {
        width: 100%;
    }
}

@media (max-width: 830px) {

    ul.tabsSett li {
        width: 28%;
        text-align: left;
    }

    ul.tabsSett {
       border-bottom: none;
    }
}

@media (max-width: 700px) {
    .ShAA_popBackCenter {
        width: 100%;
    }

    ul.tabsSett {
       float: left;
       width: 105%;
       height: auto !important;
       margin-left: -5%;
    }

    ul.tabsSett li {
        width: 104%;
        float: left;
        border-bottom: 1px solid #767676 !important;
        padding-left: 4% !important;
    }

    ul.tabsSett li a {
        color: #000 !important;
    }

    ul.tabsSett .sett0 {
        padding-top: 8px !important;
        border-top: 1px solid #767676;
    }

    .ShAA_popDataSett .phone input {
        width: 89%;
    }
    .ShAA_sizeCols {
        width: 25%;
    }
    .profinfo {
        margin-top: 48px;
    }
    .avatar_change {
        margin-top: 64px;
    }
    #personal_data {
        width: 100%;
    }
    .ShAA_popDataSett .ShAA_popInput input {
        width: 93%;
    }
    .ShAA_popDataSett .phone input {
        width: 88% !important;
    }
    .ShAA_buttonInProfile {
     margin: 12px 0 0 0;
     width: 100%;
    }

    .ShAA_desctopNone {
        display: block;
    }


}
@media (max-width: 560px) {
    .ShAA_subscrCols {
            width: 49%;
        }
}
/*
@media (max-width: 770px) {
    .ShAA_popDataSett .ShAA_popInput input {
        width: 89%;
    }
}
*/
</style>
{/literal}
<div class="ShAA_popBackCenter">
	<div class="ShAA_personalForMobile">
		<div class="ShAA_settingTabs">
            <div class="ShAA_desctopNone">
                <div class="ShAA_backLinkMenu" style="display: none;">
                    <i class="icon-angle-up icon-2x" style="font-weight:bold;margin:-8px 9px 0 0;float:left;"></i> назад к меню
                </div>
            </div>
			<div>
				<ul class="tabsSett tabs1">
                  <li class="sett0"><a>{if $language=='eng'}Profile{else}Данные{/if}</a></li>
                  <li class="sett1 hide"><a>{if $language=='eng'}Your manager{else}Ваш менеджер{/if}</a></li>
                  {if $smarty.session.user}
                      <li class="sett2 hide"><a>{if $language=='eng'}Discount card{else}Дисконтная карта{/if}</a></li>
                  {/if}
                  <li class="sett3"><a>{if $language=='eng'}Info{else}Инфо{/if}</a></li>
                  <li class="sett4"><a onclick="{literal}rG('SUBSCRIBE_PERSONAL');return false;{/literal}">{if $language=='eng'}Subscriptions{else}Подписки{/if}</a></li>
                  <li class="sett5 hide"><a id="sizes_tab">{if $language=='eng'}Sizes{else}Размеры{/if} <span class="tiptext">({if $language=='eng'}not set{else}не указаны{/if})</span></a></li>
                  {if $smarty.session.user}
                      <li class="sett6"><a>{if $language=='eng'}Services{else}Услуги{/if}</a></li>
                  {/if}
                  <li class="sett7"><a>{if $language=='eng'}Accounts{else}Ключи{/if}</a></li>
				</ul>

				<form autocomplete="off" action="/cart/save_user/" method="post" name="personal_data" id="personal_data" enctype="multipart/form-data">
                <div class="sett0 sett">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Profile info{else}Данные профиля{/if}</div>
                    <div class="ShAA_pop_title">{if $language=='eng'}Enter valid information{else}Укажите актуальную информацию о себе{/if}</div>
<!--
                    {if $smarty.session.user}
                        <div class="ShAA_titleForTab">{$user->name}</div>
                    {else}
                        <div class="ShAA_titleForTab">{if $language=='eng'}Unknown{else}Незнакомец{/if}</div>
                    {/if}
-->
                    {if $smarty.session.user}
                        {if $big_avatar}
                            <div class="avatar">
                                <img src="{$big_avatar}" alt="" />
                            </div>
                            <div class="avatar_change">
                                <a href="/cart/avatar_change/" id="vk_login_link">{if $language=='eng'}Change avatar{else}Изменить </br>фото профиля{/if}</a>
                            </div>
                        {else}
                            <div class="avatar">
                                <img src="/images/empty_photo.png" width="200px" alt="" />
                            </div>
                            <div class="avatar_change">
                                <a href="/cart/avatar_change/" id="vk_login_link">{if $language=='eng'}Set avatar{else}Изменить </br>фото профиля{/if}</a>
                            </div>
                        {/if}
<!--
                        <div class="profinfo">
                            {if $user->city}{if $language=='eng'}Delivery{else}доставка{/if}: {$user->city}, <br />{/if}
                            {if $user->adress}{$user->adress}<br />{/if}
                            {if $user->phone_number}{$user->phone_number}<br />{/if}
                            {if $user->email}{$user->email}<br />{/if}
                            {if $user->card_number}{if $language=='eng'}Card number{else}Номер дисконтной карты{/if}:<br />{$user->card_number}<br />{/if}
                            {if $smarty.session.group->discount}{if $language=='eng'}Bonus{else}бонус от{/if} {$smarty.session.group->discount|string_format:"%.0f"}%<br />{/if}
                            {if $n_deposit}{if $language=='eng'}Deposit{else}Сумма депозита{/if} {$n_deposit}&nbsp;<i class="icon-rub"></i><br />{/if}
                            <br />

                            <a href="/personal_data/" target="_blank" id="edit_link" class="ShAA_oneClickAdd" style="padding: 2%; width: 96%;" onclick="{literal}rG('EDIT_FROM_CART');{/literal}">Редактировать</a>

                            <a href="/logout/" class="ShAA_oneClickAddOld vk_button_logout" style="padding: 2%; width: 96%; margin-bottom: 24px; font-size: 14px;" onclick="{literal}rG('PRESS_EXIT');{/literal}">{if $language=='eng'}Logout{else}Выйти из аккаунта{/if}</a>
                        </div>
-->
                    {else}
                        <div class="avatar">
<!--                            <a href="/cart/vk_auth/" id="vk_login_link" class="notUnderline" title="{if $language == 'eng'}Sign in, using your account in popular social networks and get a discount{else}Войдите на сайт, используя свой аккаунт в популярных соцсетях, и получите скидку{/if}">
-->
                                <img src="/images/empty_photo.png" width="200px" alt="" />
<!--
                            </a>
-->
                        </div>
                        <div class="profinfo">
                            <span>{if $language=='eng'}You make purchases as an unregistered user{else}Вы совершаете покупки как неизвестный{/if}, <a {if $is_mobile} href="/reg/" {else} href="/cart/self_register/"{/if} class="cart_login_link" {if !$is_mobile} id="vk_login_link"{/if} onclick="{literal}rG('LOGIN_FROM_CART');{/literal}"
                                title="{if $language=='eng'}Sign up{else}Зарегистрируйтесь{/if}">{if $language=='eng'}Get a personal card of Luxury Store{else}Получите персональную карту "Лакшери Стор"{/if}<!-- и совершайте покупки с 10-ти% скидкой-->.</a></span><br />
                        </div>
                    {/if}
					<div class="">
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Name{else}Обращение{/if}
							</div>
							<div class="ShAA_popInput">
								<input placeholder="{if $language=='eng'}Name{else}Ф.И.О.{/if}" type="text" name="name" id="name" {literal}class="validate[required]"{/literal} value="{$smarty.session.user->name}" autofocus/>
							</div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example: John Doe{else}пример: Иванов Петр Сергеевич{/if}
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Phone number{else}Номер телефона{/if}
							</div>
							<div class="ShAA_popInput {if $language != 'eng'} phone{/if}">
								{if $language != 'eng'}<span class="ShAA_prefixForMiniInput">+7</span>{/if}<input placeholder="XXXXXXXXXX" type="text" name="phone_number" id="phone_number" {literal}class="validate[required,custom[phone]],custom[number]"{/literal} value="{if $smarty.session.user->phone_number}{$smarty.session.user->phone_number}{/if}" maxlength="15" {literal}pattern="[0-9]{10,15}"{/literal} />
							</div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example: +449206003322{else}пример: 9206003322{/if}
							</div>
						</div>
            <div class="ShAA_popData ShAA_popDataSett">
              <div class="ShAA_popTitleInput">
                {if $language=='eng'}Additional phone numbers{else}Дополнительные номера телефона{/if}
              </div>
              {foreach from=$user->alt_phones item=ap}
                <div class="ShAA_popInput{if $language != 'eng'} phone{/if} alt_phone_inp">
                  {if $language != 'eng'}<span class="ShAA_prefixForMiniInput">+7</span>{/if}<input placeholder="XXXXXXXXXX" type="text" name="alt_phone[]" {literal}class="validate[custom[phone]],custom[number]"{/literal} value="{$ap}" maxlength="{if $language=='eng'}15{else}10{/if}" />
                </div>
              {/foreach}
              <div id="alt_phone_block"></div>
              <div class="ShAA_popInfoInput">
                {if $language=='eng'}example{else}пример{/if}: 9206003322
              </div>
            </div>
            <div class="add_field" id="add_phone"><i class="icon-edit" style="margin: 0 6px 0 0;"></i>{if $language=='eng'}Add one more{else}Добавить телефон{/if}</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<span class="ShAA_sexName">{if $language=='eng'}Gender{else}Пол{/if}</span>
							<input type="radio" name="sex" value="1" {if $user->sex == '1'}checked="checked"{/if} class="ShAA_sexInput"><span class="ShAA_sexName">{if $language=='eng'}Male{else}Мужской{/if}</span>
							<input type="radio" name="sex" value="2" {if $user->sex == '2'}checked="checked"{/if} class="ShAA_sexInput"><span class="ShAA_sexName">{if $language=='eng'}Female{else}Женский{/if}</span>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Email{else}Почта{/if}
							</div>
							<div class="ShAA_popInput">
								<input placeholder="{if $language=='eng'}Email{else}Электронная почта{/if}" type="text" name="email" id="email" {literal}class="validate[custom[email]]"{/literal} value="{if $smarty.session.user->email}{$smarty.session.user->email}{else}{/if}">
							</div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example{else}пример{/if}: name@mail.com
							</div>
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}City{else}Город{/if}
							</div>
              {if $language=='eng'}
                <div class="ShAA_popTitleInput" style="margin-top:8px;">
                    Please, enter your city
                </div>
                <div class="ShAA_popInput">
                    <input id="city_id" data-order-id="{$order->order_id}" type="text" name="city_id" value="{$user->city}" placeholder="London">
                </div>
              {else}
							<div class="ShAA_popInput">
								<select name="city_id" id="city_id" class="validate[required]" >
									<option value="0">{if $language=='eng'}Please choose your city{else}Пожалуйста, выберите ваш город{/if}</option>
									<option value="0"> </option>
									{foreach from=$delivery_cities_main item=delivery_city}
										<option value="{$delivery_city->city_id}" {if $user->city_id == $delivery_city->city_id}selected{/if}><b>{$delivery_city->city_name}</b></option>
									{/foreach}
									<option value="0"> </option>
									{foreach from=$delivery_cities item=delivery_city}
										<option value="{$delivery_city->city_id}" {if $user->city_id == $delivery_city->city_id}selected{/if}>{$delivery_city->city_name}</option>
									{/foreach}
								</select>
							</div>
              {/if}
						</div>
						<div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Address{else}Адрес{/if}
							</div>
							<div class="ShAA_popInput">
								<input placeholder="{if $language=='eng'}Your address{else}Ваш адрес{/if}" type="text" name="address" id="address" value="{if $smarty.session.user->adress}{$smarty.session.user->adress}{else}{/if}">
							</div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example: Lenin 10-22{else}пример: Ленина 10-22{/if}
							</div>
						</div>
            <div class="ShAA_popData ShAA_popDataSett">
							<div class="ShAA_popTitleInput">
								{if $language=='eng'}Additional address{else}Дополнительные адреса{/if}
							</div>
              {foreach from=$user->alt_addresses item=aa}
                <div class="ShAA_popInput alt_address_inp">
                  <input placeholder="{if $language=='eng'}Your address{else}Ваш адрес{/if}" type="text" name="alt_address[]" value="{$aa}">
                </div>
              {/foreach}
              <div id="alt_address_block"></div>
							<div class="ShAA_popInfoInput">
								{if $language=='eng'}example{else}пример{/if}: Ленина 10-22
							</div>
						</div>
                    <div class="add_field" id="add_address"><i class="icon-edit" style="margin: 0 6px 0 0;"></i>{if $language=='eng'}Add one more{else}Добавить адрес{/if}</div>
					</div>
					<div class="clear"></div>
					<div class="ShAA_buttonInProfile">
						<a href="javascript:void(0);" onclick="$('#personal_data').submit();return false;"><input type="submit" style="font-size: 14px;" value="{if $language=='eng'}Save{else}Сохранить{/if}" class="ShAA_popButton_input"></a>
						<div style="float: left; margin: 16px 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">{if $language=='eng'}Details about personal discounts{else}Подробно о персональных скидках{/if}</a></div>
					</div>
                    <div class="clear"></div>
                    <div class="ShAA_popMiniInfo" style="margin-bottom: 12px;">{if $language=='eng'}Pressing an "Save" button you agreeing to our <a href="/sections/personal_data">Privacy & Cookies</a> policy{else}Нажимая на кнопку "Сохранить", вы даете <a href="/sections/personal_data">согласие на обработку персональных данных</a>{/if}</div>
                    {if $smarty.session.user}
                        <div class="ShAA_buttonInProfile">
                            <a href="/logout/" class="ShAA_oneClickAddOld vk_button_logout" style="padding: 2%; width: 96%; margin-bottom: 24px; font-size: 14px;" onclick="{literal}rG('PRESS_EXIT');{/literal}">{if $language=='eng'}Logout{else}Выйти из аккаунта{/if}</a>
                        </div>
                    {/if}
				</div>

                <div class="sett1 sett" style="display:none;">
                    <div class="ShAA_titleForTab">{if $language=='eng'}You personal manager{else}Ваш персональный менеджер{/if}</div>
                    <div class="ShAA_pop_title">{if $language=='eng'}{else}{/if}</div>
                    <div class="ShAA_popText">
                        {if $user->p_manager_id}
                            {foreach from=$user->p_manager item=p_manager}
                                {if $p_manager->photo}
                                    <div class="avatar">
                                        <img src="{$p_manager->photo}" alt="" />
                                    </div>
                                {else}
                                    <div class="avatar">
                                        <img src="/images/empty_photo.png" width="200px" alt="" />
                                    </div>
                                {/if}
                                <div class="ShAA_managerInfo">
                                    <div ><b>{$p_manager->name}</b></div>
																		{if $p_manager->start && $p_manager->end}
																			{if $language=='eng'}
																				<div>Today's working hours: {$p_manager->start} - {$p_manager->end}</div>
																			{else}
																				<div>Сегодня работает с {$p_manager->start} до {$p_manager->end}</div>
																			{/if}
																		{/if}
                                    <div style="margin-top: 24px;">{if $language=='eng'}Contact phone{else}Контактный телефон{/if}: <a href="tel:+{$p_manager->phone_number}">{$p_manager->phone_number}</a></div>
                                    <div>Email: <a href="mailto:{$p_manager->email}">{$p_manager->email}</a></div>
                            {/foreach}
                                <div style="margin-top: 24px;">Доступные мессенджеры:</div>
                                <div>
                                    <i class="icon-telegram"></i> Telegram &nbsp;&nbsp;&nbsp;&nbsp;
                                    <!--<i class="icon-viber"></i> Viber -->
                                    <a target="_blank" href="https://api.whatsapp.com/send?phone={$p_manager->phone_number}"><i class="icon-whatsapp"></i> WhatsApp</a>
                                </div>
                                <div style="margin-top: 24px; display: none;">
                                    <a href="javascript:void(0);" onclick="$('#personal_data').submit();return false;">
                                        <input type="submit" style="font-size: 14px;" value="{if $language=='eng'}Call back{else}Заказать звонок{/if}" class="ShAA_popButton_input">
                                    </a>
                                </div>
                                <input type="submit" style="font-size: 12px; width: 220px;" value="{if $language=='eng'}Choose another manager{else}Выбрать другого менеджера{/if}" class="ShAA_popButton_input"></input>
                            </div>
                            <div class="clear"></div>
                            <input id='this_manager_selection' value='00' name="p_manager_id" type='text' style='display: none'></input>
                        {else}

                            <div>
                               {if $language=='eng'}You don't have a personal manager yet <br/> You can choose it right now{else}Вам пока не назначен персональный менеджер <br/> Вы можете его выбрать прямо сейчас{/if}
                               <div class='manager_selection'>
                                    {foreach from=$managers item=manager}
                                        {if $manager->name != 'Стажёр Лакшери'}
                                            <div class='manager_selection_card'>
                                                {if $manager->photo}
                                                    <div class='manager_selection_photo'>
                                                        <img class='this_selection_photo' src="{$manager->photo}" alt="" />
                                                    </div>
                                                {else}
                                                    <div class='manager_selection_photo'>
                                                        <img src="/images/empty_photo.png" width="200px" alt="" />
                                                    </div>
                                                {/if}
                                                <table class='manager_selection_info'>
                                                    <tr>
                                                        <td style="vertical-align: middle">
                                                            <div>{$manager->name}</div>
                                                            {if $manager->start && $manager->end}
                                                                {if $language=='eng'}
                                                                    <div>Today's working hours: {$manager->wh.start} - {$manager->end}</div>
                                                                {else}
                                                                    <div>Сегодня работает с {$manager->wh.start} до {$manager->end}</div>
                                                                {/if}
                                                            {/if}
                                                            <input type="submit" style="font-size: 14px; width: 110px; height: 30px; line-height: 10px;" value="{if $language=='eng'}Сhoose{else}Выбрать{/if}" class="ShAA_popButton_input">
                                                        </td>
                                                    </tr>
                                                </table>
                                                <div style='display: none' class='manager_selection_id'>{$manager->user_id}</div>
                                            </div>
                                        {/if}
                                    {/foreach}
                                    <div style='clear:both'> </div>
                                    <input id='this_manager_selection' value='' name="p_manager_id" style='display: none' type='text' >
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>
                <div class="sett2 sett">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Discount card{else}Дисконтная карта{/if}</div>
                    <div class="ShAA_pop_title">{if $language=='eng'}{else}{/if}</div>
                    <div class="ShAA_popText">
                        <div class="ShAA_cardImgBlock">
                            {if $smarty.session.group->discount}
                                {if $smarty.session.group->discount|string_format:"%.0f" < 20}
                                    <img src="/images/social/card_lux.png" />
                                {else}
                                    <img src="/images/social/card_gold.png" />
                                {/if}
                            {/if}
                        </div>
                        <div class="ShAA_cardInfoBlock">
                            {if $user->card_number}{if $language=='eng'}Card number{else}Дисконтная карта №{/if}:<br />{$user->card_number}<br />{/if}
                            {if $smarty.session.group->discount}{if $language=='eng'}Bonus{else}Бонус от{/if} {$smarty.session.group->discount|string_format:"%.0f"}%<br />{/if}
                        </div>
                        {if $user->phone_number && $user->card_number}
                            <div class="ShAA_socialWalletImg" onClick="location.href='/pass/{$user->phone_number}/{$user->card_number}/?output'"></div>
                        {/if}
                    </div>
                </div>
				<div class="sett4 sett" style="display:none;">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Subscription to Luxury Store news{else}Подписка на новости SVETLOV{/if}</div>
					<div class="ShAA_pop_title">{if $language=='eng'}Mark your favorite brands{else}Отметьте бренды, новые поступления которые вам интересны{/if}</div>
					<div class="ShAA_popText">
						<div id="subscriptions">
							{foreach from=$brands item=brand}
								<div class="ShAA_subscrCols">
									<label>
										<input type="checkbox" value="{$brand->brand_id}"  onchange="{literal}jQuery('#subscribe_result').load('/index.php?module=Login&subscribe&brand_id={/literal}{$brand->brand_id}');" {if in_array($brand->brand_id, $subscribed_brands)}checked{/if} autocomplete="off" /> {$brand->name}
									</label>
								</div>
							{/foreach}
						</div>
					</div>
					<div style="margin: 20px 0 0 0; float: left; clear: both;">
						<input type="checkbox" id="stop" onchange="jQuery.get('/index.php?module=Login&do_not_disturb&type=sms&user_id={$user->original_user_id}');" {if $user->stop_sms == 1}checked{/if} autocomplete="off" />
						{if $language=='eng'}I don't want to receive sms from lsboutique.ru{else}Не получать sms-рассылки с сайта{/if}
					</div>
					<div style="margin: 20px 0 0 0; float: left; clear: both;">
						<input type="checkbox" id="stop" onchange="jQuery.get('/index.php?module=Login&do_not_disturb&type=email&email={$user->email}&user_id={$user->original_user_id}');" {if $user->stop_email == 1}checked{/if}{if $user->email == ''}checked disabled{/if} autocomplete="off" />
						{if $language=='eng'}I don't want to receive emails from lsboutique.ru{else}Не получать email-рассылки с сайта{/if}
					</div>
					<div id="subscribe_result" style="width:100%;float:left;margin: 24px 0; color: #807f7d;"></div>
				</div>
				<div class="sett5 sett" style="display:none;">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Your sizes{else}Ваши размеры{/if}</div>
					<div class="ShAA_pop_title">{if $language=='eng'}Please mark your sizes for easy service of your orders.{else}Пожалуйста, отметьте размеры для удобства обработки ваших заказов.{/if}</div>
					<div class="ShAA_popText">
						<div id="sizes">
                        <div class="ShAA_sexSizeButton {if $user->sex != '2'} active {/if}" id="mensizes">{if $language=='eng'}Man{else}Мужские{/if}</div>
                        <div class="ShAA_sexSizeButton {if $user->sex == '2'} active {/if}" id="womensizes">{if $language=='eng'}Woman{else}Женские{/if}</div>
                        {foreach key=type_id item=size_t from=$sizes}
                            <div class="table" style='float:left'>
                                <h2 class="slider" id="{$type_id}"><i class="icon-plus-square-o"></i>{$size_t->name}</h2>
                                <div class="conformity-table">
                                    <table class="responsive">
                                        <tbody>
                                        {foreach item=size_l from=$size_t->sizes}
                                            <tr>
                                            {if $size_l->id}
                                                <td class="row-even"><input class='size_check' type="checkbox" name="sizes[{$type_id}][]" value="{$size_l->id}"  onchange="{literal}jQuery('#subscribe_result').load('/index.php?module=Login&users2sizes&type_id={/literal}{$type_id}{literal}&size={/literal}{$size_l->id}');" {if in_array($size_l->id, $user_sizes)}checked{/if} autocomplete="off" /></td>
                                            {else}
                                                <td class="row-even"></td>
                                            {/if}
                                            {cycle values="" reset=true}
                                            {foreach item=value from=$size_l->values}
                                                <td {if in_array($type_id,array(3,4,5,6))}style="padding: 12px 4px;"{/if} class='{cycle values="row-odd,row-even"}'>{$value}</td>
                                            {/foreach}
                                            </tr>
                                        {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        {/foreach}
						</div>
					</div>
					<div id="subscribe_result" style="width:100%;float:left;margin-top: 20px;"></div>
				</div>
                <div class="sett6 sett" style="display:none;">
                    <div class="ShAA_emptyTextForService">
                        <div class="ShAA_titleForTab">
                            {if $language=='eng'}Special services{else}Спецуслуги Лакшери Стор{/if}:
                        </div>
                        <div class="ShAA_pop_title">
                            {if $language=='eng'}Atelier, shoe manufactory, dry cleaning{else}Ателье, обувная мастерская, химчистка{/if}
                        </div>
                        <div class="ShAA_popText">
                            &bull; {if $language=='eng'}Fitting your clothes on the figure, repair of clothing and footwear and replacement details{else}Подгонка выбранной вами вещи по фигуре, ремонт изделий и замена фурнитуры{/if};<br />
                            &bull; {if $language=='eng'}All types of work with shoes{else}Все виды работы с обувью{/if};<br />
                            &bull; {if $language=='eng'}Professional cleaning of any complexity, including furs, leather and wool{else}Профессиональная химчистка любой сложности, в том числе мехов, кожи и шерсти{/if};<br /><br />
                            <!--
                            {if $language=='eng'}You will see the status of readiness of the order in the Services{else}Статус исполнения заказа будет отражаться в разделе "Услуги"{/if}
                            -->
                        </div>
                    </div>
                    <div class="ShAA_processButton service_tabs act" data-class="st1">{if $language=='eng'}In process ({$services_work_count}){else}В работе ({$services_work_count}){/if}</div>
                    <div class="ShAA_processButton service_tabs" data-class="st2">{if $language=='eng'}Сomplete{else}Выдано{/if}</div>
                    {if $services_work}
                        <div class="stab st1">
                            {foreach from=$services_work item=service}
                                <table class="service">
                                    <tr class="ShAA_serviceTitle">
                                        <th style="padding-bottom: 6px;">
                                            Номер заказа
                                        </th>
                                        <th>
                                            Услуга
                                        </th>
                                        <th>
                                            Цена
                                        </th>
                                        <th>
                                            Статус
                                        </th>
                                    </tr>
                                    {foreach from=$service->items item=item}
                                        {if $item->name != "Всего" || $item->price != 0}
                                            <tr style="border-top:1px solid #ccc;">
                                                <td><b>{if $language=='eng'}Order{else}Заказ{/if} №{$service->id}</b></br>{if $item->product_name}{$item->product_name}{else}{$service->item_name}{/if}</td>
                                                <td>{if $language=='eng'}{$item->eng_name}{else}{$item->name}</br>{if $item->defect_description}(Дефекты: {$item->defect_description}){/if}{/if}</td>
                                                <td><nobr>{if $item->price != 0}{$item->price} <i class="icon-rub"></i>{/if}<nobr></td>
                                                <td><b>{if $language=='eng'}{$item->status_eng}{else}{$item->status}{/if}</b></td>
                                            </tr>
                                        {/if}
                                    {/foreach}
<!--
                                    <tr class="grey">
                                        <td colspan="2" class="c1 s_title"><strong>{$service->item_name}</strong></td>
                                        <td class="c3">{$service->date}</td>
                                    </tr>
                                    <tr class="grey">
                                        <td colspan="3" style="padding-bottom: 15px;">{$service->defect_description}</td>
                                    </tr>
                                    {foreach from=$service->items item=item}
                                    {if $item->name != "Всего" || $item->price != 0}
                                        <tr>
                                            <td class="c1">{if $language=='eng'}{$item->eng_name}{else}{$item->name}{/if}</td>
                                            <td>{if $language=='eng'}{$item->status_eng}{else}{$item->status}{/if}</td>
                                            <td class="c3"><nobr>{if $item->price != 0}{$item->price} <i class="icon-rub"></i>{/if}<nobr></td>
                                        </tr>
                                    {/if}
                                    {/foreach}
-->
                                </table>
                            {/foreach}
                        </div>
                    {/if}
                    <div class="stab st2" style="display:none">
                        {foreach from=$services_done item=service}
                            <table class="service">
                                <tr class="ShAA_serviceTitle">
                                    <th style="padding-bottom: 6px;">
                                        Номер заказа
                                    </th>
                                    <th>
                                        Услуга
                                    </th>
                                    <th>
                                        Цена
                                    </th>
                                    <th>
                                        Статус
                                    </th>
                                </tr>
                                {foreach from=$service->items item=item}
                                    {if $item->name != "Всего" || $item->price != 0}
                                        <tr style="border-top:1px solid #ccc;">
                                            <td><b>{if $language=='eng'}Order{else}Заказ{/if} №{$service->id}</b></br> {if $item->product_name}{$item->product_name}{else}{$service->item_name}{/if}</td>
                                            <td>{if $language=='eng'}{$item->eng_name}{else}{$item->name}</br>{if $item->defect_description}(Дефекты: {$item->defect_description}){/if}{/if}</td>
                                            <td><nobr>{if $item->price != 0}{$item->price} <i class="icon-rub"></i>{/if}<nobr></td>
                                            <td><b>{if $language=='eng'}{$item->status_eng}{else}{$item->status}{/if}</b></td>
                                        </tr>
                                    {/if}
                                {/foreach}
<!--
                                <tr class="grey">
                                    <td colspan="2" class="c1 s_title"><strong>{$service->item_name}</strong></td>
                                    <td class="c3">{$service->date}</td>
                                </tr>
                                <tr class="grey">
                                    <td colspan="3" style="padding-bottom: 15px;">{$service->defect_description}</td>
                                </tr>
                                {foreach from=$service->items item=item}
                                {if $item->name != "Всего" || $item->price != 0}
                                    <tr>
                                        <td class="c1">{if $language=='eng'}{$item->eng_name}{else}{$item->name}{/if}</td>
                                        <td>{if $language=='eng'}{$item->status_eng}{else}{$item->status}{/if}</td>
                                        <td class="c3"><nobr>{if $item->price != 0}{$item->price} <i class="icon-rub"></i>{/if}<nobr></td>
                                    </tr>
                                {/if}
                                {/foreach}
-->
                            </table>
                        {/foreach}
                    </div>
				</div>
                <div class="sett7 sett">
                    <div class="ShAA_titleForTab">{if $language=='eng'}Accounts{else}Аккаунты{/if}</div>
					<div class="ShAA_pop_title">{if $language=='eng'}SIGN UP WITH{else}Объедините свои данные, чтобы входить на сайт как удобно{/if}</div>
					<div class="ShAA_popText" style="margin-top: 24px;">
						{$social}
					</div>
					<div class="ShAA_popText">
						{if $language=='eng'}You can link accounts from other sites{else}Предлагаем Вам присоединить учетные записи с других сайтов{/if}
					</div>
					<div class="ShAA_socButtonsPersonal" style="float: left;">
						{include file="networks_auth_buttons.tpl"}
					</div>
					<div style="float: left; margin: 16px 0;" class="ShAA_popMiniInfo"><a target="_blank" href="http://ru.lsboutique.ru/doctxt/diskont/">{if $language=='eng'}Details about personal discounts{else}Подробно о персональных скидках{/if}</a></div>
				</div>
</form>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>

<!-- end Настройки - Ключи - Инфо -->
