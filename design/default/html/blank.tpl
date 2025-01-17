<html>
<head>
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
{literal}
<style>
    body {
        width: 52%;
        margin: 30px auto;
    }
    .ShAA_tableBlock {
        border: 1px solid #000;
        padding: 3%;
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
        <div style="border-bottom: 1px solid #000; width: 100%;">{$cashbox->entity}, ИНН {$cashbox->inn}</div>
        <div style="text-align: center; font-size: 12px;">(наименование организации, ИНН)</div>
        <div style="font-weight: bold; font-size: 20px; margin: 24px 0 12px;">
            Товарный чек №{$order->receipt_number} от {$order->date|date_format:"%d.%m.%Y"}г
        </div>
        <div>
            <table border="1" style="width: 100%; border: 0;" cellspacing="0">
                <tr style="padding: 12px; height: 20px;">
                    <th style=" padding: 3px 6px;">№ </br>п/п</th>
                    <th style=" padding: 3px 6px;">Наименование, характеристика товара</th>
                    <th style=" padding: 3px 6px;">Кол-во</th>
                    <th style=" padding: 3px 6px;">Цена</th>
                    <th style=" padding: 3px 6px;">Сумма</th>
                </tr>
                {foreach from=$order->products item=product key=index}
                    <tr>
                        <td style="height: 30px; padding: 3px 6px;">{$index+1}</td>
                        <td style="height: 30px; padding: 3px 6px;">{$product->product_name}, {$product->sku}, {$product->color}, {$product->size}</td>
                        <td style="height: 30px; padding: 3px 6px;" align="center">1</td>
                        <td style="height: 30px; padding: 3px 6px;" align="right">{$product->offline_price|string_format:"%.0f"}</td>
                        <td style="height: 30px; padding: 3px 6px;" align="right">{$product->price|string_format:"%.0f"}</td>
                    </tr>
                {/foreach}
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td colspan="4" style="border-left: 0; border-bottom: 0; height: 30px; text-align: right; padding: 3px 6px;">Всего</td>
                    <td style="height: 30px; padding: 3px 6px;" align="right">{$order->total_sum|string_format:"%.0f"}</td>
                </tr>
            </table>
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0; text-align: left; width: 100%;">
            <span style="border-bottom: 4px solid #fff;">Всего отпущено на сумму: &nbsp;&nbsp;&nbsp;</span>
            <span id="sum-words">{$order->total_sum_words} рублей</span>
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0; text-align: left; width: 100%;height:10px;">
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0 0; text-align: left; width: 100%;">
            <span style="border-bottom: 4px solid #fff;">Продавец: &nbsp;&nbsp;&nbsp;</span>
            <span></span>
        </div>
        <div style="font-size: 12px;">(ФИО/подпись)</div>
        {if $cashbox->stmp}
            <div style="float: left; margin: -106px 0 0 106px;position: absolute;">
                <img src="/design/adaptive/images/{$cashbox->stmp}" style="width: 40mm; height: 40mm;"/>
            </div>
        {/if}
    </div>
    <div class="ShAA_buttonPrint">
        <a class="btn btn-primary mt20" href="" onClick="window.print();">Распечатать</a>
        <b style="margin-left: 24px;">Отключить верхний и нижний колонтитулы!!!</b>
    </div>
<body>
</html>
