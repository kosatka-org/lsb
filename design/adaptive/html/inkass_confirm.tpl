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
    {if $confirm === 1}
      Уважаемый {$inkass->user_name}, инкассация на сумму {$inkass->sum|number_format:0:",":","} подтверждена {$inkass->confirm_date|date_format:"%d.%m"}.
    {elseif $reject === 1}
      Отклонено
    {/if}
    {if $confirm === 2}
    Уважаемый {$inkass->user_name}, подтвердите инкассацию из магазина {$inkass->shop_name} касса {$inkass->cid}, дата {$inkass->date|date_format:"%d.%m"}, сумма {$inkass->sum|number_format:0:",":","}.
      <form action="/i/c/{$inkass->hash}/" method="post">
        <input type="hidden" value="{$inkass->id}" name="inkass_id">
        <div class="row">
          <div class="col-md-12">
            <div class="order-button-group mt20">
              <div style="float: left; margin: 4px 24px 0 0">
                  <button type="submit" name='confirm' value="1" class="btn btn-primary">Подтвердить</button>
              </div>
              <div style="float: left; margin: 4px 24px 0 0">
                  <button type="submit" name='confirm' value="0" class="btn btn-primary">Отклонить</button>
              </div>
            </div>
          </div>
        </div>
      </form>
    {/if}
  </div>

</div>
<!-- Content #End /-->

<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();
</script>
