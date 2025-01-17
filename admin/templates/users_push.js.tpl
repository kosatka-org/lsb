{literal}
<script>

function get_filter_data() {
  var filter = {};
  filter.shops = $('.shop-input:checked').map(function(i) { return $(this).val(); }).get();
  filter.cities = $('.city-input:checked').map(function(i) { return $(this).val(); }).get();
  filter.brands = $('.brand-input:checked').map(function(i) { return $(this).val(); }).get();
  filter.sex = $('.sex-input:checked').val();
  filter.sum = $('.sum-input').val();
  return filter;
}

function post_data(type) {
  var data = {};
  data.filter = get_filter_data();
  data.type = type;
  if (type !== 'count') {
    data.title = $('#subject').val();
    data.body = CKEDITOR.instances['textbox'].document.getBody().getText();
    if (!data.title || !data.body) {
      alert("Тема и текст сообщения должны быть заполнены.");
      return false;
    }
    data.date = $('#date_time_picker').val();
  }
	$.post('/rest_api/push_notification', JSON.stringify(data), function (response) {
    if (type === 'count') {
      $('#people').html(response.users_count);
    }
    if (response.success) {
      $('#send_success').html('Сообщение отправлено');
    }
	});
}

$(document).ready(function() {
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
var saved_data = localStorage.getItem('push_text_save');
if (saved_data) {
		CKEDITOR.instances.textbox.setData(saved_data);
}

var saved_subject = localStorage.getItem('push_subject_save');
if (saved_subject) {
	$('#subject').val(saved_subject);
}

CKEDITOR.instances.textbox.on('change', function() {
	data = CKEDITOR.instances['textbox'].getData();
	localStorage.setItem('push_text_save', data);
  $('#symbols').html(CKEDITOR.instances['textbox'].document.getBody().getText().length);
});

post_data('count');

$('#subject').on("input", function(e) {
	data = $(this).val();
	localStorage.setItem('push_subject_save', data);
})

$(document).on('click', '.testbtn', function(event) {
	event.preventDefault();
  post_data('test');
});

$(document).on('click', '#send_button', function(event) {
	event.preventDefault();
  post_data('send');
  $(this).prop('disabled', 'disabled');
  $(this).html('Отправлено');
});

$(document).on('change', '.filter-input', function(event) {
	event.preventDefault();
  post_data('count');
});

</script>
{/literal}
