<div class="content" style="padding:0;">
    <div class="centerContent">
        <div class="centerRightContent">
            <div class="topContent" style="height:0px;margin: 10px 0 18px;">
            </div>
            <div class="clear"></div>
            {foreach from=$brands_full item=brand}
                <div class="abcColumn">
                    <div class="abcNames"><h1><a href={if $brand->url}"/brands/{$brand->url}/"{else}"/catalog/?brand={$brand->brand_id}&showbrand={$brand->brand_id}"{/if}>{$brand->name}</a></h1></div>
                </div>
            {/foreach}
        </div>
    </div>
</div>
