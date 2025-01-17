{literal}
<script id="editor-template" type="text/x-handlebars-template">
	<textarea class="ckeditor" id="editor{{item_id}}" name="message">{{message}}</textarea>
	<input type="hidden" id="item_id" name="item_id" value={{item_id}}>
</script>

<script>

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
	name = $(this).attr('id').split('-')[0];
	Template[name] = Handlebars.compile($(this).html());
});

$(document).on("click", ".edit", function() {
	var item_id = $(this).attr('item-id');
	
	$.get( "/admin/index.php?section=Oneclick&email_message="+item_id, function( data ) {
		message = data;
		var html = Template.editor({message: data, item_id: item_id});
		$("#editor_"+item_id).html(html);
		$('#create_button_'+item_id).show();
		$('#test_email_'+item_id).show();
		CKEDITOR.replace( 'editor'+item_id );
	});
	
});

$(document).on('click', '.testbtn', function(event) {
	event.preventDefault();
	item_id = $(this).attr('data-item-id');
	email = $('#email_'+item_id).val();
	data = CKEDITOR.instances['editor'+item_id].getData();
	$.post('/admin/index.php?section=Oneclick', {test: 1, item_id: item_id, email: email, data: data}, function () {
		$('#test_success_'+item_id).html('Отправлено тестовое сообщение');
	});
});

</script>

{/literal}