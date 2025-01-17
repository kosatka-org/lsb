
{if $oc_ordered && $smarty.session.user->group_id < 2 && $config->enviroment == 'live'}
{literal}
    <script>
    jQuery(document).ready(function() {
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            dataLayer.push({
                'transactionId': 'c{/literal}{$oc_ordered->id}{literal}', // Required 
                'transactionAffiliation': 'Luxury Store', 
                'transactionTax': '{/literal}{if $new_user_order}0{else}1{/if}{literal}', 
                'transactionTotal': {/literal}{$oc_ordered_product->price}{literal}, // Required
                'transactionShipping': 'undefined',
                'transactionProducts': [
                    {
                        'sku': '{/literal}{$oc_ordered_product->sku}{literal}', // Required 
                        'name': '{/literal}{$oc_ordered_product->model}{literal}', // Required 
                        'category': '{/literal}{$oc_ordered_product->brand_name}{literal}', 
                        'price': {/literal}{$oc_ordered_product->price}{literal}, // Required 
                        'quantity': 1 // Required 
                    }
                ]
            });
        }
        {/literal}{if $oc_ordered_product->cat_enabled != 0}{literal}
        //Criteo dataLayer 
        if (typeof(dataLayer) !== 'undefined' && dataLayer) {
            var product_list = [];
            product_list.push(
                {
                    'id': '{/literal}{$oc_ordered_product->barcode}{literal}',
                    'price': {/literal}{$oc_ordered_product->price}{literal},
                    'quantity': 1 
                }
            );
            dataLayer.push({
                'CriteoEmail': {/literal}'{if $smarty.session.user->user_id}{$smarty.session.user->user_id}@luxury.ru{/if}'{literal}, 
                'PageType': 'TransactionPage',
                'OrderProducts' : product_list,
                'CriteoTransactionId': '{/literal}c{$oc_ordered->id}{literal}'
            })
        }
        {/literal}{/if}{literal}
    });
    </script>
{/literal}
{/if}
<div class="centered_text alert_text">
	Заявка заполнена
</div>
<div class="left_text2 descr_text" style="margin: 30px 0 30px 80px;">
	Наш сотрудник свяжется с Вами в ближайшее время{if $ordering} для оформления заказа{/if}.
</div>
<a href="/catalog/" title="Вернуться в каталог" alt="Вернуться в каталог">
	<div class="button button560px button_text" style="margin: 40px 0 0 40px;">
		Вернуться в каталог
	</div>
</a>

{if $purchase_data}
{literal}
<script type="text/javascript">
jQuery(document).ready(function() {
    if ( window._gaq !== undefined ) {
        _gaq.push(['_addTrans',
            '{/literal}{$purchase_data.order_id}{literal}',           // order ID - required
            'Luxury Store',  // affiliation or store name
            '{/literal}{$purchase_data.price|string_format:"%.2f"}{literal}',          // total - required
            '0', // tax
            '0', // shipping
            'Russia', // city
            'Russia', // state or province
            'Russia'  // country
        ]);
        _gaq.push(['_addItem',
            '{/literal}{$purchase_data.order_id}{literal}',           // order ID - required
            '{/literal}{$purchase_data.item_id|escape}{literal}',           // SKU/code - required
            '{/literal}{$purchase_data.model|escape}{literal}',        // product name
            '{/literal}{$purchase_data.price|string_format:"%.2f"}{literal}',          // unit price - required
            '1']);
        _gaq.push(['_trackTrans']); //submits transaction to the Analytics servers
    }

    if (typeof(dataLayer) !== 'undefined' && dataLayer) { // Коллектор данных для ecommerse
        product = {
            id:    "P{/literal}{$purchase_data.item_id|escape}{literal}",
            name:  "{/literal}{$purchase_data.model|escape}{literal}",
            price:  {/literal}{$purchase_data.price|string_format:"%.2f"}{literal}
        };
        ecommerce = {};
        ecommerce["currencyCode"] = "RUB";
        ecommerce['purchase']     = {"actionField": { "id"      : "M{/literal}{$purchase_data.order_id}{literal}",
                                                      "goal_id" : "10066135"}, 
                                     "products": [product]};
        dataLayer.push({"ecommerce" : ecommerce});
    }
});
</script>
{/literal}
{/if}