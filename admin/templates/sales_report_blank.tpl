<html>
<head>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/js/are_you_ie.js"></script>
{literal}
<style>
    body {
        margin: 30px auto;
    }
    .ShAA_buttonPrint {
        float: left;
        margin: 24px 0;
    }
    td{word-wrap: break-word!important;}
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
<body style="font-size: 14px!important; text-align: center;">
    <div style="font-weight: bold; font-size: 20px; margin: 24px 0 12px;">
        Отчет о продажах
    </div>
    <div>
      {if $data}
        <table border="1" style="word-wrap: break-word!important;width: 100%;table-layout: fixed;font-size: 14px!important;" cellspacing="0">
            <tr style="padding: 12px; height: 20px;">
                <th style=" padding: 3px;">ФИО</th>
                <th style=" padding: 3px;">Телефон</th>
                <th style="word-wrap:break-word; padding: 3px;">Наименование</th>
                <th style=" padding: 3px;">Артикул</th>
                <th style=" padding: 3px;">Дата</th>
                <th style=" padding: 3px;">Чек</th>
                <th style=" padding: 3px;">Сумма</th>
                <th style=" padding: 3px;">Фото</th>
                <th style=" padding: 3px;">Признак</th>
                <th style=" padding: 3px;">Бутик</th>
            </tr>
            {foreach from=$data item=d}
                <tr>
                    <td style="height: 30px; padding: 3px;">{$d->name}</td>
                    <td style="height: 30px; padding: 3px;">{$d->phone_number}</td>
                    <td style="height: 30px; padding: 3px;">{$d->model}</td>
                    <td style="height: 30px; padding: 3px;">{$d->sku}</td>
                    <td style="height: 30px; padding: 3px;">{$d->date|date_format:"%Y/%m/%d"}</td>
                    <td style="height: 30px; padding: 3px;">№{if $d->receipt_number}{$d->receipt_number}{else}{$d->order_id}{/if}</td>
                    <td style="height: 30px; padding: 3px;">{$d->price}</td>
                    <td style="height: 30px; padding: 3px;"><img src='https://lsboutique.ru/files/products/{$d->large_image}' width=60></td>
                    <td style="height: 30px; padding: 3px;">{$d->sign}</td>
                    <td style="height: 30px; padding: 3px;">{$d->shop_name}</td>
                </tr>
            {/foreach}
        </table>
      {else}
        Нет результатов
      {/if}
    </div>
    <div class="ShAA_buttonPrint">
        <a class="btn btn-primary mt20" href="" onClick="window.print();">Распечатать</a>
        <b style="margin-left: 24px;">Отключить верхний и нижний колонтитулы!!!</b>
    </div>
<body>
</html>
