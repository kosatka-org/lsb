{literal}
<script id="stat-template" type="text/x-handlebars-template">
<span class="big_blue_text">{{data.stat_total_percent}}% </span><br>
	из {{data.stat_total}}<br>
	{{data.stat_called}} дозвонились<br>
	{{data.stat_total_wating}} ждут звонка
</script>

<script>


var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
	name = $(this).attr('id').split('-')[0];
	Template[name] = Handlebars.compile($(this).html());
});

$(document).on('click', '.cbtn', function(e) {
	var data = $(this).data();
	var calldata = $(this).parent().data();
	var this_div = $(this).parent().parent();
	if (!confirm(data.confirm)) {
		return false;
	}
	parameters = {
		section: 'Calls',
		call_user: calldata.userId,
		status: data.status,
		phone_number: calldata.phone,
		call_id: calldata.callId
	}
	$.get('/admin/index.php', parameters)
		.done( function(d) {
		this_div.hide();
		var call = {};
		$.getJSON('/admin/index.php', {section: 'Calls', call_id: calldata.callId, stat: 1})
			.done( function(data) {
				call = data;
				var html = Template.stat({data: call});
				$('#stat_container').html(html);
			});
		});
});

</script>
{/literal}