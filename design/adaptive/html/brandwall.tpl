<div class="content" style="padding:0;">
    <div class="centerContent" style="margin-top: 64px;">
        <div class="centerRightContent">
            <div class="topContent" style="height:0px;margin: 10px 0 18px;">
            </div>
            <div class="clear"></div>
            {foreach from=$brands_full item=brand}
                <div class="abcColumn" style="text-align: center;">
                    <div class="abcNames ShAAlogoBrandDiv">
                        <h1 style="line-height:24px;">
                            <a href={if $brand->url}"/brands/{$brand->url}/"{else}"/catalog/?brand={$brand->brand_id}&showbrand={$brand->brand_id}"{/if} style="font-size:24px;" {if $brand->bigsize_on_brandwall}style="font-size:24px;"{/if}>
                                <img src="{if $cdn_image_link}{$cdn_image_link}{else}//lsboutique.ru{/if}/reimg/files/brands/212x/{$brand->image}" alt="{$brand->name}" title="{$brand->name}" />
                            </a>
                        </h1>
                    </div>
                </div>
            {/foreach}
        </div>
    </div>
</div>
