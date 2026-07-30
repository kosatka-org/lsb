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
        <div style="border-bottom: 1px solid #000; width: 100%;">{$user->name}, {$user->phone_number}</div>
        <div style="text-align: center; font-size: 12px;">(ФИО, телефон)</div>
        <div style="font-weight: bold; font-size: 20px; margin: 24px 0 12px;">
            Задолженность
        </div>
        <div>
            <table border="1" style="width: 100%; border: 0;" cellspacing="0">
                <tr style="padding: 12px; height: 20px;">
                    <th style=" padding: 3px 6px;">№ заказа</th>
                    <th style=" padding: 3px 6px;">Дата</th>
                    <th style=" padding: 3px 6px;">Дата возврата</th>
                    <th style=" padding: 3px 6px;">Продавец</th>
                    <th style=" padding: 3px 6px;">Сумма чека</th>
                    <th style=" padding: 3px 6px;">Долг</th>
                </tr>
                {foreach from=$debts item=debt key=index}
                    <tr>
                        <td style="height: 30px; padding: 3px 6px;">{$debt->receipt_number}</td>
                        <td style="height: 30px; padding: 3px 6px;">{$debt->date|date_format:"%Y/%m/%d, %H:%M"}</td>
                        <td style="height: 30px; padding: 3px 6px;">{if $debt->debt_by_date != '0000-00-00 00:00:00'}{$debt->debt_by_date|date_format:"%Y/%m/%d"}{/if}</td>
                        <td style="height: 30px; padding: 3px 6px;">{$debt->resp}</td>
                        <td style="height: 30px; padding: 3px 6px;" align="right">{$debt->total_order|number_format:0:",":" "}</td>
                        <td style="height: 30px; padding: 3px 6px;" align="right">{$debt->remaining_debt|number_format:0:",":" "}</td>
                    </tr>
                {/foreach}
                <tr>
                    <td style="height: 30px;"></td>
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
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                    <td style="height: 30px;"></td>
                </tr>
                <tr>
                    <td colspan="5" style="border-left: 0; border-bottom: 0; height: 30px; text-align: right; padding: 3px 6px;">Всего</td>
                    <td style="height: 30px; padding: 3px 6px;" align="right">{$user->debt_sum|number_format:0:",":" "}</td>
                </tr>
            </table>
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0; text-align: left; width: 100%;">
            <span style="border-bottom: 4px solid #fff;">Итого: &nbsp;&nbsp;&nbsp;</span>
            <span id="sum-words">{$user->debt_sum_words} рублей</span>
        </div>
        <div style="border-bottom: 1px solid #000; margin: 24px 0; text-align: left; width: 100%;height:10px;">
        </div>
    </div>
    <div class="ShAA_buttonPrint">
        <a class="btn btn-primary mt20" href="" onClick="window.print();">Распечатать</a>
        <b style="margin-left: 24px;">Отключить верхний и нижний колонтитулы!!!</b>
    </div>
<body>
</html>
