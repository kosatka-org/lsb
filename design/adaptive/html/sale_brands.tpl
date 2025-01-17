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

<link rel="stylesheet" href="/design/adaptive/css/offline.css?v=0.2">

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
  <table class="table table-striped">
		<thead>
			<tr>
				<th>Бренд</th>
				<th>Сезон</th>
				<th style="text-align:right;">Скидка по-умолчанию</span></th>
				<th style="text-align:right;">Максимальная скидка</span></th>
			</tr>
    	</thead>

		<tbody>
			{foreach from=$sale_brands item=brand}
        {if $brand->new_season}
  				<tr style="border-top-style:solid; border-top-width: 2px;">
  					<td rowspan="3">{$brand->name}</td>
  					<td>Новый сезон</b> ({$settings->current_new_season})</td>
  					<td style="text-align:right;">{$brand->new_season->sale}%</td>
  					<td style="text-align:right;">{$brand->new_season->max_sale}%</td>
  				</tr>
          <tr>
  					<td><b>Предыдущий сезон</b> ({$settings->previous_season}):</td>
  					<td style="text-align:right;">{$brand->previous_season->sale}%</td>
  					<td style="text-align:right;">{$brand->previous_season->max_sale}%</td>
  				</tr>
          <tr>
  					<td><b>Прошлые сезоны</td>
  					<td style="text-align:right;">{$brand->old_seasons->sale}%</td>
  					<td style="text-align:right;">{$brand->old_seasons->max_sale}%</td>
  				</tr>
        {/if}
			{/foreach}
		</tbody>
	</table>
</div>
<!-- Content #End /-->
