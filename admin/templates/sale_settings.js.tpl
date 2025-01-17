{literal}
<script>

function get_data(brand_id) {
  var data = {next_season: {}, new_season: {}, previous_season: {}, old_seasons: {}};
  $('#'+brand_id).find('.sale-value').each(function(i,e) {
    data[$(e).data().season].sale = $(e).val();
    data[$(e).data().season].id = $(e).data().settingId;
  });
  $('#'+brand_id).find('.max-sale-value').each(function(i,e) {
    data[$(e).data().season].max_sale = $(e).val();
  });
  $('#'+brand_id).find('.sale-show').each(function(i,e) {
    data[$(e).data().season][$(e).data().user] = $(e).prop('checked') | 0;
  });
  return data;
}

function post_data(brand_id) {
	$.post('/admin/index.php?section=SaleSettings', {data: JSON.stringify({brand_id: brand_id, settings: get_data(brand_id)})}, function (response) {
		console.log(response);
	});
}

$(document).on('click', '.save-data', function(event) {
	event.preventDefault();
  var brand_id = $(this).data().brandId;
  post_data(brand_id);
});

</script>
{/literal}
