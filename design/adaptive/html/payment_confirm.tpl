<link rel="stylesheet" href="/design/adaptive/css/loader030218_style.css">


<!-- Content #Begin /-->
<div class="container" style="margin-bottom:40px;">
    {if $payment->status == 1}
      Уважаемый {$order->name}, оплата заказа №{$order->order_id} была проведена успешно.
    {elseif $payment->status == 0 && $payment->id}
      Что-то пошло не так, попробуйте еще раз, или свяжитесь с менеджером.
    {else}
      <div>Ожидается подтверждение от банка...</div>
      <div class="transition-loader">
        <div class="transition-loader-inner">
          <label></label>
          <label></label>
          <label></label>
          <label></label>
          <label></label>
          <label></label>
        </div>
      </div>
    {/if}
</div>

<!-- Content #End /-->

<script>
var orderId = '{$order->sber_order_id}';
{if !$payment}
{literal}
function update() {
    $.ajax({
        url: 'sberbankpayment/confirm/?check&orderId='+orderId,
        dataType: 'text',
        success: function(data) {
        console.log(data);
            if(data == 'ok'){location.reload();}
        },
        complete: function() {
            window.setTimeout(update, 10000);
        }
    });
}
window.setTimeout(update, 10000);
{/literal}
{/if}
</script>
