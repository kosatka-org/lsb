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
        <div style="font-weight: bold; text-align: right;">{$movement->date|date_format:"%d.%m.%Y"}г</div>
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
                </tr>
                {foreach from=$movement->products item=product key=index}
                    <tr>
                        <td style="height: 30px; padding: 3px 6px;">{$index+1}</td>
                        <td style="height: 30px; padding: 3px 6px;">{$product->model}, {$product->sku}, {$product->color}, {$product->size}</td>
                        <td style="height: 30px; padding: 3px 6px;" align="center">{$product->quantity}</td>
                    </tr>
                {/foreach}
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
            </table>
        </div>

        <div style="border-bottom: 1px solid #000; margin: 24px 0 0; text-align: left; width: 46%; float: left;">
            <span style="border-bottom: 4px solid #fff;">Сдал: &nbsp;&nbsp;&nbsp;</span>
            <span></span>
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0 0; text-align: left; width: 46%; float: right;">
            <span style="border-bottom: 4px solid #fff;">Принял: &nbsp;&nbsp;&nbsp;</span>
            <span></span>
        </div>
    </div>
    <div class="ShAA_buttonPrint">
        <a class="btn btn-primary mt20" href="" onClick="window.print();">Распечатать</a>
        <b style="margin-left: 24px;">Отключить верхний и нижний колонтитулы!!!</b>
    </div>
<body>
</html>
