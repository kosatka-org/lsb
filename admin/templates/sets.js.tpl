{literal}
<!-- Templates -->
<script id="product-template" type="text/x-handlebars-template">
	{{#each products}}
		<div class='row mt10'>
			<div class='col-md-3'><img class="img-thumbnail" src="/reimg/files/products/85x/{{this.large_image}}"></div>
			<div class='col-md-6' style="padding-top: 44px;">{{this.model}}, арт {{this.sku}}</div>
			<div class='col-md-3' style="padding-top: 44px;">
				<button type='button' product-id='{{this.product_id}}' product-index='{{@index}}' class='btn btn-default add-btn' {{#if btn_disabled}}disabled="disabled"{{/if}}>Добавить</button>
			</div>
		</div>
	{{/each}}
</script>

<script id="form-template" type="text/x-handlebars-template">
	<form id="set-form" role="form">
		<div class="form-group">
			<label for="name">Название набора</label>
			<input type="text" id="input-new-set" class="form-control" name="name" placeholder="Название" value="">
		</div>
		<button type="submit" id="create-new-set" data-loading-text="Загрузка.." class="btn btn-success mt10" {{#if btn_disabled}}disabled="disabled"{{/if}}>Создать</button>
	</form>
</script>

<script id="set-template" type="text/x-handlebars-template">
	<div class="panel panel-default">
	    <div class="panel-heading" role="tab" id="heading_{{id}}">
	      <h4 class="panel-title">
	        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_{{id}}" aria-expanded="true" aria-controls="collapseOnecollapse_{{id}}">
	          <b>{{name}}</b> | {{date}}
	        </a>
	      </h4>
	    </div>
	    <div id="collapse_{{id}}" class="panel-collapse collapse in" item-id="{{id}}" role="tabpanel" aria-labelledby="heading_{{id}}">
	      <div class="panel-body">
	        <div class="row" id="set_products_{{id}}">
			</div>
	      </div>
	    </div>
	</div>
</script>

<script id="setproduct-template" type="text/x-handlebars-template">
	<div class="row">
		<div class="col-md-2 mt10"><img class="img-thumbnail" src="/reimg/files/products/60x/{{large_image}}"></div>
		<div class="col-md-4 mt10"><a href="/products/{{url}}/" target="_blank">{{model}}</a><br>артикул: {{sku}}</div>
		<div class="col-md-5 mt10">Показывать на стр. товара &nbsp;<input class="show_on_product_page" product-id="{{product_id}}" type="checkbox"></div>
		<div class="col-md-1 mt10">
			<button type="button" class="close remove-product off" aria-hidden="true" product-id="{{product_id}}">
				<span class="glyphicon glyphicon-remove"></span>
			</button>
		</div>
	</div>
</script>
<!-- /Templates -->

<script>

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
	name = $(this).attr('id').split('-')[0];
	Template[name] = Handlebars.compile($(this).html());
});

var $current_set = {};
var $product_list = [];

if (typeof String.prototype.contains === 'undefined') {
	String.prototype.contains = function(it) {
		return this.indexOf(it) != -1;
	};
}

post_sku = function(sku) {
	if (sku.length > 2) {
		$('#found-products').fadeOut();
		$.post("/admin/index.php?section=Sets", {query: sku}, function(p_list) {
			$product_list = p_list;
			var u = Template.product({products: $product_list});
			setTimeout( function() {
				$('#found-products').html(u);
				$('#found-products').fadeIn();
			}, 500);
		});
	}
}

// True if no products selected
btn_disabled = function() {
	return $.isEmptyObject($current_set);
}

$(document).on("input", "#sku-input", function() {
	post_sku($(this).val());
});

$(document).on("click", "#refresh", function() {
	post_sku($('#sku-input').val());
});

$(document).on("click", "#create-button", function() {
	$current_set = {};
	// $(".choose-btn").removeClass("active");
	var html = Template.form({});
	$('#found-products').hide("fast");
	$('#create-form').html(html).show("fast");
});

// $(document).on("click", ".choose-button", function(e) {
// 	t = $(this);
// 	if (!t.hasClass("active")) {
// 		$('.choose-button').removeClass('active');
// 		t.addClass('active');
// 		$current_set = {id: t.attr('item-id')};
// 	}
// });

$(document).on('show.bs.collapse', '.collapse', function () {
	t = $(this);
	$current_set = {id: t.attr('item-id')};
})

$(document).on("click", ".add-btn", function() {
	t = $(this);
	var product_id = t.attr('product-id');
	var product_index = t.attr('product-index');
	var product = $product_list[product_index];
	$.post('/admin/index.php?section=Sets', {set_id: $current_set.id, add_product: 1, product_id: product_id}, function(data) {
		var html = Template.setproduct(product);
		$('#set_products_'+$current_set.id).append(html);
		var row = t.parent().parent();
		row.hide('fast');
		row.remove();
	});
});

$(document).on('click', '.remove-item', function() {
	t = $(this);
	var product_id = $(this).attr("product-id");
	$.post('/admin/index.php?section=Sets', {set_id: $current_set.id, remove_product: 1, product_id: product_id}, function(data) {
		t.parent().parent().remove();
	});
});

$(document).on('change', '.show_on_product_page', function() {
	t = $(this);
	var product_id = t.attr("product-id");
	var show_on_product_page = t.prop('checked') ? 1 : 0;
	$.post('/admin/index.php?section=Sets', {set_id: $current_set.id, show_on_product_page: show_on_product_page, product_id: product_id});
});

$(document).on("click", "#create-new-set", function(e) {
	var btn = $(this);
	e.preventDefault();
	var name = $('#input-new-set').val();
	btn.button('loading');
	$.post('/admin/index.php?section=Sets', {name: name}, function(data) {
		$('.collapse').collapse('hide');
		$current_set = {id: data.id};
		var html = Template.set(data);
		$('#accordion').prepend(html);
		$('#input-new-set').val("");
		$('#sku-input').val("");
		$('.anchor').empty();
		btn.button('reset');
		btn.prop("disabled", btn_disabled());
	});
});

$(document).on("click", ".btn", function() {
	$("#order-new-user").prop("disabled", btn_disabled());
});


</script>
{/literal}
