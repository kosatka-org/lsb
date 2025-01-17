<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css">

<script src="/js/are_you_ie.js"></script>
{literal}
  <style type="text/css">
  body {
    background: none;
    height: initial;
    margin-top: 60px;
  }
  label {
    vertical-align: middle;
  }
  #page {
    width: 100%;
  }
  .mt-6 {
    margin-top: -6px;
  }
  .mt10 {
    margin-top: 10px;
  }
  .mt20 {
    margin-top: 20px;
  }
  .mt50 {
    margin-top: 50px;
  }
  .ml6 {
    margin-left: 6px;
  }
  #headBlock, #headBlock-hidden, .footer {
    display: none;
  }
  a:hover {
    border-bottom: none;
  }

  .img-thumbnail {
    min-width: 60px;
    min-height: 60px;
  }
  .form-inline .form-group {
    margin-right: 6px;
  }
  .debt-by-date {
    max-width: 120px;
  }
  </style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
  <div class="col-md-10">
    {if $confirm == 1}
      Уважаемый {$order->user_name}, платёж за покупку номер {$order->receipt_number} обрабатывается, обновите страницу позже.
    {elseif $confirm == 4}
      Уважаемый {$order->user_name}, оплата покупки номер {$order->receipt_number} была проведена успешно.
    {else}
      <div style="margin-bottom:20px;">Уважаемый {$order->user_name}, оплатите покупку №{$order->receipt_number} на сумму {$order->amount|number_format:0:",":","} рублей.</div>
      <span id="payment_button_sber">
        <a href="/sberbankpayment/?order_id={$order->code}&amp;order_total={$order->amount}&amp;offline">
          <input type="submit" value="Оплата" class="ShAA_popButton_input">
        </a>
      </span>
    {/if}
  </div>

</div>
<!-- Content #End /-->

<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();
</script>
