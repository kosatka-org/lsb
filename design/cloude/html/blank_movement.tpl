<html>
<head>
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/js/are_you_ie.js"></script>
{literal}
<style>
    body {
        width: 52%;
        min-width:800px;
        margin: 30px auto;
    }
    .ShAA_tableBlock {
        border: 1px solid #000;
        padding: 3%;
        float: left;
        width: 94%;
    }
    .ShAA_buttonPrint {
        float: left;
        margin: 24px 0;
    }
    @media (max-width: 767px) {
         body {
            width: 92%;
        }
    }
    @media print {
        body {
            width: 92%;
        }
        .ShAA_tableBlock {
            margin: 30px auto;
            border: 1px solid #000;
            padding: 3%;
        }
        .ShAA_buttonPrint {
            display: none;
        }
    }
    #sum-words {
        font-size: 20px;
        display: inline-block;
    }
    #sum-words::first-letter {
        text-transform: uppercase;
    }
</style>
{/literal}
</head>
<body style="font-size: 14px; text-align: center;">
    <div class="ShAA_tableBlock">
        <div style="font-weight: bold; text-align: right;">{$movement->date}</div>
        <div style="font-weight: bold; font-size: 20px; margin: 24px 0 12px;">
            Накладная на перемещение товара №{$movement->movement_id}
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0 0; text-align: left; width: 100%;">
            <span style="border-bottom: 4px solid #fff;">Куда: </span>
            <span style="margin: 0 0 0 30px;">{$movement->shop_to_name}</span>
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0; text-align: left; width: 100%;">
            <span style="border-bottom: 4px solid #fff;">Откуда: </span>
            <span style="margin: 0 0 0 30px;">{$movement->shop_from_name}</span>
        </div>

        <div>
            <table border="1" style="width: 100%; border: 0;" cellspacing="0">
                <tr style="padding: 12px; height: 20px;">
                    <th style=" padding: 3px 6px;">№ </br>п/п</th>
                    <th style=" padding: 3px 6px;">Наименование, характеристика товара</th>
                    <th style=" padding: 3px 6px;">Кол-во</th>
                    {if $movement->reservation}<th style=" padding: 3px 6px; text-align:right;">Цена, руб</th>{/if}
                </tr>
                {foreach from=$movement->products item=product key=index}
                    <tr>
                        <td style="height: 30px; padding: 3px 6px;">{$index+1}</td>
                        <td style="height: 30px; padding: 3px 6px;">{$product->model}, {$product->sku}, {$product->color}, {$product->size}</td>
                        <td style="height: 30px; padding: 3px 6px;" align="center">{$product->quantity}</td>
                        {if $movement->reservation}<td style="height: 30px; padding: 3px 6px;" align="right">{$product->price|number_format:0:",":" "}</td>{/if}
                    </tr>
                {/foreach}
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    {if $movement->reservation}<td style="height: 30px;"></td>{/if}
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    {if $movement->reservation}<td style="height: 30px;"></td>{/if}
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    {if $movement->reservation}<td style="height: 30px;"></td>{/if}
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    {if $movement->reservation}<td style="height: 30px;"></td>{/if}
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px; padding: 3px 6px;"><b>Всего:</b></td>
                    <td style="height: 30px; padding: 3px 6px;" align="center"><b>{$movement->totals->total_quantity}</b></td>
                    {if $movement->reservation}<td style="height: 30px; padding: 3px 6px;" align="right">{$movement->totals->total_price|number_format:0:",":" "}</td>{/if}
                </tr>
            </table>
        </div>

        <div style="border-bottom: 1px solid #000; margin: 24px 0 0; text-align: left; width: 46%; float: left;">
            <span style="border-bottom: 4px solid #fff;">Сдал: &nbsp;&nbsp;&nbsp;</span>
            <span>{if $movement->reservation}{$movement->responsible_user->name}{else}{$movement->created_user->name}{/if}</span>
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0 0; text-align: left; width: 46%; float: right;">
            <span style="border-bottom: 4px solid #fff;">Принял: &nbsp;&nbsp;&nbsp;</span>
            <span>{if $movement->reservation}{$movement->user->name}{elseif $movement->accepted_user}{$movement->accepted_user->name}{else}{$smarty.session.user->name}{/if}</span>
        </div>
    </div>
    <div class="ShAA_buttonPrint">
        <a class="btn btn-primary mt20" href="" onClick="window.print();">Распечатать</a>
        <b style="margin-left: 24px;">Отключить верхний и нижний колонтитулы!!!</b>
    </div>
<body>
</html>
