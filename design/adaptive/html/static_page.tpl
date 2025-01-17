{*
  Template name: Статическая страница
  Used by: StaticPage.class.php   
  Assigned vars: $page
*}

{if $page->section_id == 161 || $page->section_id == 182}
<div class="delivery left">
  <h1>{if $language=='eng'}Delivery{else}Доставка{/if}</h1>
  {foreach from=$delivery item=variant}
  <div class="delpic left">{if $variant->image}<img src="/files/deliveries/{$variant->image}">{/if}</div>
  <div class="deltext"><strong>{if $language=='eng'}{$variant->eng_name}{else}{$variant->name}{/if}</strong><br />
  {if $language=='eng'}{$variant->eng_description}{else}{$variant->description}{/if}</div>
  <div class="delclear"></div>
  {/foreach}
</div>
  
<div class="delivery right">
  <h1>{if $language=='eng'}Payment{else}Оплата{/if}</h1>
  {foreach from=$payment item=variant}
  <div class="delpic left">{if $variant->image}<img src="/files/payments/{$variant->image}">{/if}</div>
  <div class="deltext"><strong>{if $language=='eng'}{$variant->eng_name}{else}{$variant->name}{/if}</strong><br />
  {if $language=='eng'}{$variant->eng_description}{else}{$variant->description}{/if}</div>
  <div class="delclear"></div>
  {/foreach}
</div>

{if $page->section_id == 161}
<script src="/jscript/jquery.autocompleteNew.js"></script>
<link media="all" href="/jscript/jquery.autocompleteNew.css" rel="stylesheet" type="text/css" />
{literal}
<script type="text/javascript">
function clearText(thefield){
		if (thefield.defaultValue==thefield.value)
		thefield.value = "";
	}
	
jQuery(document).ready(function() {
	jQuery(".imit_select").click(function() {
		jQuery(this).next(".drop_wrap").slideToggle();
	});
    
    var availableTags = [ {/literal}
        {foreach from=$delivery_cities item=city}
            "{$city->name}",
        {/foreach}{literal}
        ""];
    var regions =  { {/literal}
        {foreach from=$delivery_cities item=city}
            "{$city->name}": '?REGION={$city->region_id},209,{$city->city_id}',
        {/foreach}{literal}
        "":''};
    $( "#cities_array" ).autocomplete({
        appendTo: "#ui_widget",
        source: availableTags,
        close: function(event, ui) {
            window.location.href=regions[$(this).val()];
        }
    });
});

</script>

<style>
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
		<div style="float: left; width: 100%; margin: 48px 0 0 0;">
			<form autocomplete="off" action="/index.php?module=Cart&client_find&search='+jQuery('#client_info').eq(0).val().replace(/ /g, '+'))" method="post" name="client_add" id="client_add" enctype="multipart/form-data">
				<div class="ShAA_pop_title">ВЫБЕРИТЕ ВАШ ГОРОД</div>
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
                    <div><a href="/city/{$city->url}/?REGION={$city->region_id},209,{$city->city_id}" {if in_array($city->city_id,$big_cities)}style="color: #444; font-size: 20px;"{/if}>{$city->name}</a></div>
                  {/foreach}
                </div>
              </div>
            {/foreach}
            </div>
          {/foreach}
        </div>
			</form>
		</div>
        <div class="clear"></div>
{/if}	
<!-- end Настройки - Ключи - Инфо -->
{/if}

{$page->body}
