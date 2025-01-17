<link rel="stylesheet" href="/jscript/validationEngine.jquery.css?v=2" type="text/css" media="screen" charset="utf-8" />
<script src="/jscript/jquery.validationEngine-ru.js?v=2" type="text/javascript"></script>
<script src="/jscript/jquery.validationEngine.js?v=2"></script>
<script src="/jscript/jquery.autocompleteNew.js"></script>
<link media="all" href="/jscript/jquery.autocompleteNew.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/javascript">
function clearText(thefield){
		if (thefield.defaultValue==thefield.value)
		thefield.value = "";
	}
	
jQuery(document).ready(function() {
	if ( jQuery("#id_card_number").autocomplete ) { 
		jQuery("#id_card_number").autocomplete({
			 source: '/index.php?module=Cart&card_select', 
			 minLength:3,
			 appendTo: '.ShAA_personCard'
		});
		
		jQuery("#client_info").autocomplete({
			 source: '/index.php?module=Cart&person_select', 
			 minLength:3,
			 appendTo: '.ShAA_person'
		});
	}
	jQuery(".imit_select").click(function() {
		jQuery(this).next(".drop_wrap").slideToggle();
	});

    var availableTags = [ {/literal}
        {foreach from=$delivery_cities item=city}
            "{$city->name}",
        {/foreach}{literal}
        ""];
    var pos = document.referrer.indexOf('?');
    var backurl = (pos == -1) ? document.referrer : document.referrer.substr(0, pos);    
    var regions =  { {/literal}
        {foreach from=$delivery_cities item=city}
            "{$city->name}": backurl+'?REGION={$city->region_id},209,{$city->city_id}',
        {/foreach}{literal}
        "":''};
    $( "#cities_array" ).autocomplete({
        appendTo: "#ui_widget",
        source: availableTags,
        close: function(event, ui) {
            if (typeof regions[$(this).val()] != "undefined") {                
                window.location.href = regions[$(this).val()];
            }
        }
    });
	$('#headBlock_container, .background_header_mobile').attr({style:'height: 0'});
});

</script>
{/literal}

{literal}
<style>
	#fancybox-outer {
		background: none;
	}
	#fancybox-title {
		display: none !important;
	}
	.ShAA_popDataSett {
		margin: 12px 0 6px 0;
	}
    
    .headBlock, .footer {
        display: none;
    }
    .fullfield, .ShAA_popBackCenter {
        box-shadow: none !important;
        border: none !important;
        margin: 0 auto;
    }
    .logoOnline {
        display: block !important;
    }
    .ShAA_cityLetter {
        width: 20%;
    }
    .ShAA_cityLetter {
        margin-right: 5%;
    }
    .ShAA_cityName>div {
        margin-bottom: 12px;
    }
    
    .ShAA_cityLetterName {
        font-weight: bold;
    }
    
@media (max-width: 767px) {
    .ShAA_cityLetter {
        width: 45%;
    }
}
</style>
{/literal}

<div class="ShAA_popBackCenter" style="width: 100%;">
	<div class="ShAA_loginBlock">
		<a href="#" onclick="history.back();return false;" class="ShAA_closeImg"><img width="16" style="position: absolute; right: 24px;" src="/images/pop_close.png"></a>
		<div class="">
			<form autocomplete="off" action="/index.php?module=Cart&client_find&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'))" method="post" name="client_add" id="client_add" enctype="multipart/form-data">
				<div class="ShAA_pop_title">ВЫБЕРИТЕ ВАШ ГОРОД</div>
				<div class="ShAA_popData ShAA_popDataSett">
					<div class="ShAA_popTitleInput">
						Это позволит получать точную информацию о <a href="/sections/shipping" target="_blank">доставке товаров</a>
					</div>
				</div>
				<div class="ShAA_popData ShAA_popDataSett">
					<div class="imit_select_wrap" >
                        <div class="ui-widget" id="ui_widget">
                            <div class="imit_select" >
                              <input id="cities_array" value="" placeholder="Введите название" style="border: none;">
                            </div>
                        </div>
					</div>
				</div>
        <div class="ShAA_cityNamesBlock">
          {foreach from=$del_cities_sorted item=col key=key}
            <div style='float:left;width:25%;'>
            {foreach from=$col item=cities key=key}
              <div class="ShAA_cityLetter" style="width:100%;">
                <div class="ShAA_cityLetterName">{$key}</div>
                <div class="ShAA_cityName">
                  {foreach from=$cities item=city}
                    <div><a href="{$back_url}/?REGION={$city->region_id},209,{$city->city_id}" {if in_array($city->city_id,$big_cities)}style="color: #444; font-size: 20px;"{/if}>{$city->name}</a></div>
                  {/foreach}
                </div>
              </div>
            {/foreach}
            </div>
          {/foreach}
        </div>
				<!--<div class="ShAA_cityNamesBlock">
          <div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">А</div>
						<div class="ShAA_cityName">
                            <div><a href="{$back_url}?REGION=42,209,512">Алматы</a></div>
                            <div><a href="{$back_url}?REGION=7,209,122">Астрахань</a></div>
						</div>
						<div class="ShAA_cityLetterName">В</div>
						<div class="ShAA_cityName">
                            <div><a href="{$back_url}?REGION=51,209,1324">Владивосток</a></div>
							<div><a href="{$back_url}?REGION=64,209,1633">Владикавказ</a></div>
							<div><a href="{$back_url}?REGION=12,209,286">Волгоград</a></div>
						</div>
						<div class="ShAA_cityLetterName">Г</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=30,209,733">Геленджик</a></div>
						</div>
                        <div class="ShAA_cityLetterName">Д</div>
                        <div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=57,209,411">Дербент</a></div>
						</div>
                        <div class="ShAA_cityLetterName">Е</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=73,209,1587">Екатеринбург</a></div>
						</div>
					</div>                    
					<div class="ShAA_cityLetter">
                        <div class="ShAA_cityLetterName">И</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=18,209,481">Иркутск</a></div>
						</div>
						<div class="ShAA_cityLetterName">К</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=65,209,1726">Казань</a></div>
							<div><a href="{$back_url}?REGION=27,209,642" style="color: #444; font-size: 20px;">Киров</a></div>
                            <div><a href="{$back_url}?REGION=25,209,620">Киселевск</a></div>
							<div><a href="{$back_url}?REGION=30,209,735">Краснодар</a></div>
						</div>
						<div class="ShAA_cityLetterName">М</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=57,209,398">Махачкала</a></div>
							<div><a href="{$back_url}?REGION=40,209,992" style="color: #444; font-size: 20px;">Москва</a></div>
						</div>
						<div class="ShAA_cityLetterName">Н</div>
						<div class="ShAA_cityName">
                            <div><a href="{$back_url}?REGION=19,209,502">Нальчик</a></div>
							<div><a href="{$back_url}?REGION=43,209,1054" style="color: #444; font-size: 20px;">Нижний Новгород</a></div>
							<div><a href="{$back_url}?REGION=45,209,1145">Новосибирск</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">О</div>
                        <div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=46,209,1176">Омск</a></div>
							<div><a href="{$back_url}?REGION=48,209,1243">Орел</a></div>
						</div>
						<div class="ShAA_cityLetterName">Р</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=68,209,1387">Ростов-на-Дону</a></div>
							<div><a href="{$back_url}?REGION=69,209,1448">Рязань</a></div>
						</div>
						<div class="ShAA_cityLetterName">С</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=70,209,1472">Самара</a></div>
							<div><a href="{$back_url}?REGION=35,209,893" style="color: #444; font-size: 20px;">Санкт-Петербург</a></div>
                            <div><a href="{$back_url}?REGION=71,209,1522">Саратов</a></div>
                            <div><a href="{$back_url}?REGION=30,209,739">Сочи</a></div>
							<div><a href="{$back_url}?REGION=75,209,1674">Ставрополь</a></div>
                            <div><a href="{$back_url}?REGION=90,209,1904">Сургут</a></div>
						</div>
					</div>
					<div class="ShAA_cityLetter">
						<div class="ShAA_cityLetterName">Т</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=79,209,1781">Тверь</a></div>
                            <div><a href="{$back_url}?REGION=70,209,1485">Тольятти</a></div>
							<div><a href="{$back_url}?REGION=83,209,1907">Тюмень</a></div>
						</div>
						<div class="ShAA_cityLetterName">У</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=87,209,1944">Ульяновск</a></div>
						</div>
						<div class="ShAA_cityLetterName">Х</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=89,209,1988">Хабаровск</a></div>
						</div>
						<div class="ShAA_cityLetterName">Ч</div>
						<div class="ShAA_cityName">
							<div><a href="{$back_url}?REGION=91,209,2011">Челябинск</a></div>
							<div><a href="{$back_url}?REGION=24,209,591">Черкесск</a></div>
						</div>
					</div>
				</div>-->
			</form>
		</div>
	</div>
	<div class="clear"></div>
</div>

<!-- end Настройки - Ключи - Инфо -->

