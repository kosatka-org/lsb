<script type="text/javascript">
{literal}
if (typeof $luxury_obj !== 'undefined'){
{/literal}
$luxury_obj['rowcount']={if $rowcount}{$rowcount}{else}0{/if};
{literal}
}
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
limitChecks("csizes", {if $listsizes}{$listsizes}{else}null{/if});
limitChecks("fsizes", {if $listsizes}{$listsizes}{else}null{/if});
</script>
{foreach from=$looks item=look}
    <div class="ShAA_catalogItem_new">
		<div class="imgCatalog_new look_image">
			<a href="/look/{$look->id}/" target="_blank" style="border-bottom:none;">
				<img src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/products/340x/{$look->image}">
			</a>
		</div>

		<div class="ShAA_descriptionCatalog" style="margin-top:5px;height:35px;">
			<a href="/look/{$look->id}/" target="_blank">
				{foreach from=$look->products item=product name=products}
					{$product->model}{if !$smarty.foreach.products.last}, {/if}
				{/foreach}
			</a>
			<br>
		</div>
	</div>
{/foreach}