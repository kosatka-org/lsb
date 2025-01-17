<script id="data-new-items"type="application/json">
  {$new_items}
</script>

<script id="data-special-items"type="application/json">
  {$special_items}
</script>

{literal}
<script id="product-template" type="text/x-handlebars-template">
	<p></p>
	{{#each products}}
		<div style="width:220px;display:inline-block;">
			<a href="https://lsboutique.ru/products/{{this.url}}/" target="_blank">
				<img alt="" src="https://lsboutique.ru/reimg/files/products/220x/{{this.large_image}}" style="height:330px;width:220px">
			</a>
			<br>
			<span>{{this.model}}</span>
		</div>
	{{/each}}
	<hr>
	<p></p>
</script>

<script>
var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
  name = $(this).attr('id').split('-')[0];
  Template[name] = Handlebars.compile($(this).html());
});

var new_items = JSON.parse(document.getElementById('data-new-items').innerHTML);
var special_items = JSON.parse(document.getElementById('data-special-items').innerHTML);

function calculate_destination() {
		$('#people').html('уточняю...');
		$.ajax({
			url: $('#form').attr('action') + '&only_people',
			dataType: 'html',
			type: 'POST',
			data: $('#form').serialize(),
			success: function(resp){
				$('#people').html(resp);
			}
		});
	}

$(document).ready(function() {
	calculate_destination();

	$.datepicker.regional['ru'] = {
		closeText: 'Закрыть',
		prevText: '<Пред',
		nextText: 'След>',
		currentText: 'Сегодня',
		monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
		'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
		monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
		'Июл','Авг','Сен','Окт','Ноя','Дек'],
		dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
		dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
		dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
		weekHeader: 'Не',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''
	};
	$.datepicker.setDefaults($.datepicker.regional['ru']);

	$('#date_time_picker').datetimepicker({
		minDate: new Date(),
		timeFormat: 'HH:mm',
		dateFormat: 'dd-mm-yy'
	});
});

CKEDITOR.config.allowedContent=true;
CKEDITOR.config.height = '35em';
CKEDITOR.replace('textbox');
var saved_data = localStorage.getItem('email_text_save');
if (saved_data) {
  CKEDITOR.instances.textbox.setData(saved_data);
}

var saved_subject = localStorage.getItem('email_subject_save');
if (saved_subject) {
  $('#subject').val(saved_subject);
}

var saved_address = localStorage.getItem('email_address_save');
if (saved_address) {
  $('#email').val(saved_address);
}

CKEDITOR.instances.textbox.on('change', function() {
  data = CKEDITOR.instances['textbox'].getData();
  localStorage.setItem('email_text_save', data);
});

$('#subject').on("input", function(e) {
	data = $(this).val();
	localStorage.setItem('email_subject_save', data);
})

$('#email').on("input", function(e) {
	data = $(this).val();
	localStorage.setItem('email_address_save', data);
})

$('#brand-new').on("change", function(e) {
	brand = $(this).val();
	if (brand == 0) {
		return false;
	}
	var products = new_items[brand];
	var sex = $(this).find('option:selected').data().sex;
	if (sex) {
		products = products.filter(function(p) {
			return p.sex == sex;
		})
	}
	while (products.length%3 > 0) {
	  products.push(products[products.length-1]);
	}
	html = Template.product({products: products});
	CKEDITOR.instances.textbox.setData(html);
})

$('#special').on("change", function(e) {
	special_id = $(this).val();
	if (special_id == 0) {
		return false;
	}
	var products = special_items[special_id];
	while (products.length%3 > 0) {
	  products.push(products[products.length-1]);
	}
	html = Template.product({products: products});
	CKEDITOR.instances.textbox.setData(html);
})

$(document).on('click', '.testbtn', function(event) {
	event.preventDefault();
	admin_email = $('#email').val();
	subject = $('#subject').val();
	sender_name = $('#sender_name').val();
	sender_email = $('#sender_email').val();
	data = CKEDITOR.instances['textbox'].getData();
	if (!subject || !data) {
		alert("Тема и текст письма должны быть заполнены.");
		return false;
	}
	$.post('/admin/index.php?section=Users&email', {test: 1, subject: subject, sender_name: sender_name, sender_email: sender_email, admin_email: admin_email, message: data}, function () {
		$('#test_success').html('Отправлено тестовое сообщение');
	});
});

</script>
{/literal}
