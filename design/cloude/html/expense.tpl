<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css">

<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/locales/bootstrap-datepicker.ru.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.min.js"></script>
<script src="/third_party/js/handlebars-intl/handlebars-intl-with-locales.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/accounting.js/0.4.1/accounting.min.js"></script>
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
  <form action="/index.php?module=OfflineSales" method="post">
    <div class="row">
      <div class="col-md-12">
        <div class="form-group">
          <label>Магазин</label>
          <select id="cashbox" name="shop_id" class="form-control" {if $block}disabled{/if}>
            {foreach from=$shops item=cb}
              <option value="{$cb->shop_id}" {if $cb->shop_id == $expense->shop_id}selected="selected"{/if}>{$cb->name}</option>
            {/foreach}
          </select>
        </div>
      </div>
    </div>
    
    <div class="row">
      <div class="col-md-12">
        <div class="form-group">
          <label>Касса</label>
          <select id="cashbox" name="cashbox_id" class="form-control">
            {foreach from=$cashbox_ids item=cb}
              <option value="{$cb->id}" {if $cb->id == $expense->cashbox_id}selected="selected"{/if}>{$cb->name}</option>
            {/foreach}
          </select>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <div class="form-group">
          <label>Статья расходов</label>
          <select id="expense_type" name="expense_type" class="form-control" {if $block}disabled{/if}>
              <option value="general" {if $expense->expense_type == 'general'}selected="selected"{/if}>Расходы персонала</option>
              <option value="advance_payment" {if $expense->expense_type == 'advance_payment'}selected="selected"{/if}>Авансы</option>
              <option value="other" {if $expense->expense_type == 'other'}selected="selected"{/if}>Прочее</option>
          </select>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <div class="form-group">
          <label>Комментарий</label>
          <input type="text" name="comment" class="form-control" id="comment" {if $block}disabled{/if} {if $expense}value="{$expense->comment}"{/if}>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-12">
        <div class="form-group">
          <label>Сумма</label>
          <input type="number" class="form-control" id="sum" name="sum" {if $block}disabled{/if} {if $expense}value="{$expense->sum}"{/if}>
        </div>
      </div>
    </div>

    {if $expense}
      <input type="hidden" value="{$expense->id}" name="expense_id">
    {/if}

    <div class="row">
      <div class="col-md-12">
        <div class="order-button-group mt20">
          <div style="float: left; margin: 4px 24px 0 0">
              <button type="submit" class="btn btn-primary">Сохранить</button>
          </div>
        </div>
      </div>
    </div>
  </form>
  </div>

</div>
<!-- Content #End /-->

<script>
$("#headBlock_container").prop("class", null);
$("#headBlock_container").prop("id", "headBlock-hidden");
$(".background_header_mobile").hide();
</script>
