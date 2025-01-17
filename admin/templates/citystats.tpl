{literal}
<style type="text/css">
body {
	background: none;
}

tbody#city-table {
    counter-reset: rowNumber;
}

tbody#city-table tr {
    counter-increment: rowNumber;
}

tbody#city-table tr td:first-child::before {
    content: counter(rowNumber);
    min-width: 1em;
    margin-right: 0.5em;
}

</style>
{/literal}

<!-- Content #Begin /-->
<div class="container" style="margin-bottom:50px;">
	<h3>Статистика по городам</h3>
	<p><form action="/admin/index.php?section=CityStats" method="post">Дата: <input name="date_range" value="{$daterange}"><input style="margin-left: 10px" class="btn" type="submit" value="Применить"></form></p>

	<table class="table table-striped sortable">
		<thead>
			<tr>
				<th data-defaultsort='disabled'>#</th>
				<th>Город</th>
				<th data-firstsort="desc" style="text-align:right;"><span style="padding-right:10px;">Принято</span></th>
				<th data-firstsort="desc" style="text-align:right;"><span style="padding-right:10px;">Возвращено</span></th>
				<th data-firstsort="desc" style="text-align:right;"><span style="padding-right:10px;">Всего</span></th>
				<th data-firstsort="desc" style="text-align:right;"><span style="padding-right:10px;">Возвращено %</span></th>
				<th data-firstsort="desc" style="text-align:right;"><span style="padding-right:10px;">Заказы</span></th>
				<th data-firstsort="desc" style="text-align:right;"><span style="padding-right:10px;">Товары</span></th>
			</tr>
    	</thead>

		<tbody id="city-table">
			{foreach from=$cities item=city key=key name=cities_list}
				<tr>
					<td></td>
					<td>{$city->name}</td>
					<td style="text-align:right;">{$city->accepted|default:"0"}</td>
					<td style="text-align:right;">{$city->rejected|default:"0"}</td>
					<td style="text-align:right;">{$city->sum}</td>
					<td style="text-align:right;" data-value="{$city->rejected_percent}">{$city->rejected_percent|string_format:"%.1f"}%</td>
					<td style="text-align:right;">{$city->total_orders}</td>
					<td style="text-align:right;">{$city->total_order_products}</td>
				</tr>
			{/foreach}
		</tbody>
	</table>
</div>
<!-- Content #End /--> 
