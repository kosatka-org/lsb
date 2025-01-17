<script type="text/javascript">$luxury_obj['rowcount']={$rowcount};
{literal}
function limitChecks(type, elements) {
    if (elements) {
        jQuery("div#list-"+type).find(".handle").each( function() {
            var ch = jQuery(this);
            if (elements.indexOf(ch.find(".box").find("input").attr("name")) > -1) {
                ch.removeClass("handle-disabled").addClass("handle-enabled");
            }
            else {
                ch.removeClass("handle-enabled").addClass("handle-disabled");
            }
        });
    }
    else {
        jQuery("div#list-"+type).find(".handle").each( function() {
            jQuery(this).removeClass("handle-disabled").addClass("handle-enabled");
        });
    }
}
{/literal}
limitChecks("categories", {if $listcateg}{$listcateg}{else}null{/if});
limitChecks("brands", {if $listbrands}{$listbrands}{else}null{/if});
limitChecks("sizes", {if $listsizes}{$listsizes}{else}null{/if});
</script>
{foreach from=$wallproducts item=product}
    <div itemscope="" itemtype="http://schema.org/Product" id="{$product->product_id}" class="ShAA_catalogItem_new" {*onclick="window.location = '/products/{$product->url}/';"*}>
        <div id="img_{$product->product_id}" class="imgCatalog_new">
            <a href="/products/{$product->url}/" title="{$product->model} из Италии и Франции" target="_blank" style="border-bottom:none;">
                <img alt="{if $product->category}{$product->category} {/if}{$product->model}{if $product->brand} {$product->brand}{/if}" src="/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{/if}" src_out="/reimg/files/products/184x/{if $product->large_image}{$product->large_image}{/if}" src_over="/reimg/files/products/184x/{if $product->second_image}{$product->second_image}{/if}" itemprop="image"/>
            </a>
        </div>
        <div class="ShAA_descriptionCatalog" itemprop="description" style="margin-top:5px;">
            <a href="/products/{$product->url}/" target="_blank"><span itemprop="name">{$product->category}</span></a>
            <a href="/products/{$product->url}/" target="_blank" itemprop="brand">{$product->brand}</a>

            <a itemprop="offers" itemscope itemtype="http://schema.org/AggregateOffer" href="/products/{$product->url}/" target="_blank">
                <span style="text-decoration: line-through;" itemprop="highPrice">{$product->old_price|string_format:"%.0f"}</span>&nbsp;<i class="icon-rub"></i><br/>
                        <span style="color: #C30000;"><b itemprop="lowPrice">{$product->price|string_format:"%.0f"}</b>&nbsp;<i class="icon-rub"></i> со скидкой {$product->sale_value|string_format:"%.0f"}% <br/></span>
                {if $product->size != 'Р-р не задан' && $product->size != 'р-р не зад'}
                    <span style="clear: both;">Размеры: {$product->size}</span>
                {/if}
            </a>
            <br/>
        </div>
        <div style="margin-left: 35px;">
            {if (($product->old_price != 0) && ($product->old_price > $product->price) && (($product->old_price-$product->price)/$product->old_price > 0.1)) }
                {if $product->no_sale }
                    <div></div>
                {elseif 'swd'|array_key_exists:$promos && in_array($product->brand_id, explode(",", $promos.swd->brands)) }
                    <div class="ShAA_swdIcon" style="clear: none; margin: 2px 3px 0 0;">скидка выходного дня</div>
                {elseif $product->golden_sale }
                    <div class="ShAA_goldenPriceIcon" style="clear: none; margin: 2px 3px 0 0;">выгодное предложение</div>
                {else}
                    <div class="ShAA_saleIcon" style="clear: none; margin: 2px 3px 0 0;">скидка</div>
                {/if}
            {elseif ( $product->season == "14/2" || $product->season == "15/1" )}
                <div class="ShAA_newSeasonIcon">новый сезон</div>
            {/if}
            {if ( $product->s_material )}
                {foreach from=$product->s_material item=material}
                    <div class="ShAA_newSeasonIcon" style="clear: none; margin: 2px 3px 0 0;">{$material->name}</div>
                {/foreach}
            {/if}
        </div>
    </div>
{/foreach}
{literal}
<script type="text/javascript">
    $('#sp_params').val(JSON.stringify({brands: $luxury_obj.brands, categories: $luxury_obj.categories}));
</script>
{/literal}

{literal}
<script>
    jQuery(document).ready(function() {
        jQuery('.ShAA_timeClass').timeTo({
            timeTo: new Date('May 01 2016 15:00:00'),
            displayCaptions: false,
            fontSize: 13,
            gap: 8,
            width: 8,
            displayDays: 2,
            fontFamily: '"Roboto", sans-serif'
        });
    });
</script>
{/literal}
