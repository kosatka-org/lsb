{literal}
<!-- Templates -->
<script id="user-template" type="text/x-handlebars-template">
    {{#each users}}
        <div class='row mt10'>
            <div class='col-md-6'><a href="/admin/index.php?section=Orders&view=search&keyword=user:{{this.original_user_id}}" target="_blank">{{this.name}}</a></div>
            <div class='col-md-3'>{{this.phone_number}}</div>
            <div class='col-md-3'>
                <button type='button' user-index='{{@index}}' class='btn btn-default choose-btn'>Выбрать</button>
            </div>
        </div>
    {{/each}}
</script>

<script id="form-template" type="text/x-handlebars-template">
    <form id="user-form" role="form">
        <div class="form-group">
            <label for="firstname">Имя</label>
            <input type="text" class="form-control" name="name" placeholder="Имя и фамилия" value="{{user.name}}">
        </div>
        <div class="form-group">
            <label for="phone">Телефон</label>
            <input class="form-control" name="phone" placeholder="8ХХХХХХХХХХ" value="{{user.phone_number}}">
        </div>
        <div class="form-group">
            <label for="phone">Адрес</label>
            <input class="form-control" name="address" placeholder="Адрес доставки" value="{{user.adress}}">
        </div>
        <div class="form-group">
            <label for="email">Почта</label>
            <input type="email" class="form-control" name="email" placeholder="Почта" value="{{user.email}}">
        </div>
        <div class="form-group">
            <label for="comment">Комментарий</label>
            <textarea class="form-control" name="comment" placeholder="Комментарий"></textarea>
        </div>
        <select name="city_id" class="form-control">
            В<option value="0">Выберите город</option>
            {{#each mcities}}
                <option value="{{this.city_id}}">{{this.city_name}}</option>
            {{/each}}
            <option value="0"> </option>
            {{#each cities}}
                <option value="{{this.city_id}}" {{#if this.selected}}selected="selected"{{/if}}>{{this.city_name}}</option>
            {{/each}}
        </select>
        <div class="checkbox">
            <label>
                <input type="checkbox" name="no_notification" value="1"> Не отправлять оповещения о заказе
            </label>
        </div>
        <input type="hidden" name="user_id" value="{{user.original_user_id}}">
        <button type="submit" id="order-new-user" data-loading-text="Загрузка.." class="btn btn-success mt10" {{#if btn_disabled}}disabled="disabled"{{/if}}>Сформировать заказ</button>
    </form>
</script>

<script id="alert-template" type="text/x-handlebars-template">
    <div class="alert alert-success alert-dismissable alert-link">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <a href="/admin/index.php?section=Order&order_id={{order_id}}">Заказ №{{order_id}}</a> успешно сформирован.
    </div>
</script>

<script id="disable-template" type="text/x-handlebars-template">
    <div class="panel panel-info mt10" item-id="{{item_id}}" style="display:none;">
        <div class="panel-heading">
            <h3 class="panel-title">Удалить заявку</h3>
        </div>
        <div class="panel-body">
            <form class="disable-form" item-id="{{item_id}}" role="form">
                {{#each selection}}
                    <div class="radio">
                        <label>
                            <input type="radio" name="disable_info" value="{{this.id}}" {{#if @first}}checked{{/if}}>
                            {{this.text}}
                        </label>
                    </div>
                {{/each}}
                <label for="disable_comment">Комментарий</label>
                <textarea name="disable_comment" class="form-control"></textarea>
                <div class="mt10">
                    <button type="button" item-id="{{item_id}}" class="send-disable-btn btn btn-danger">Удалить заявку</button>
                    <button type="button" item-id="{{item_id}}" class="dont-disable-btn btn" style="margin-left:8px;">Не удалять</button>
                </div>
            </form>
        </div>
    </div>
</script>

<script id="archive-template" type="text/x-handlebars-template">
    <div class="row mt10">
        <div class="row">
            <div class="col-md-6">
                Заявка
            </div>
            <div class="col-md-2">
                Время обработки заявки
            </div>
            <div class="col-md-2 from-icons">
                Тип заявки
            </div>
            <div class="col-md-2">
                Результат
            </div>
        </div>
        {{#each items}}
            <div class="row">
                <div class="col-md-6">
                    <p>{{this.date}} - <b>{{this.name}}</b> | {{this.phone}}
                    | <a href="/products/{{this.url}}">{{this.model}}</a></p>
					<p>{{this.disable_comment}}</p>
                </div>
                <div class="col-md-2">
                    {{this.time}}
                </div>
                <div class="col-md-1 from-icons">
                    <i class="fa fa-2x platform fa-{{this.platform}}"></i>
                    {{#if this.info}}<i class="fa fa-2x ml6 text-info fa-info"></i>{{/if}}
                </div>
                <div class="col-md-3">
                    <span class="label label-primary">{{this.disable_info}}</span>
                    <span class="label label-success">{{this.manager_name}}</span>
                </div>
            </div>
        {{/each}}
    </div>
</script>

<!-- /Templates -->

<script>

var Template = {};
$('script[type="text/x-handlebars-template"]').each(function() {
    name = $(this).attr('id').split('-')[0];
    Template[name] = Handlebars.compile($(this).html());
});

var selection = [
    {id: "out_of_stock", text: "Нужного размера нет в наличии"},
    {id: "offline_shop", text: "Самовывоз из магазина"},
    {id: "consultation", text: "Оказана консультация"},
    {id: "unreachable", text: "Не удалось связаться"},
    {id: "duplicate", text: "Дубль"},
    {id: "other", text: "Другое"}
];

var selection_obj = { "out_of_stock": "Нужного размера нет в наличии",
    "offline_shop": "Самовывоз из магазина",
    "consultation": "Оказана консультация",
    "unreachable": "Не удалось связаться",
    "ordered": "Сформирован заказ",
    "duplicate": "Дубль",
    "other": "Другое" };

var $order = {products: {}, client: undefined, oneclick_products: {}, item_type: $("div[item-list]").data("item-type")};
var user_list, mcities, cities;

$.getJSON("/admin/index.php?section=Oneclick&mcities=1", function(data) {
    mcities = data;
});
$.getJSON("/admin/index.php?section=Oneclick&cities=1", function(data) {
    cities = data;
});

String.prototype.chompLeft = function(prefix) {
    var s = this, p = prefix;
    if (p.constructor.name === "String") {
        p = [p];
    }
    if (p.constructor.name === "Array") {
        for (i in p) {
            if (s.indexOf(p[i]) === 0) {
                s = s.slice(p[i].length);
            }
        }
        return s;
    }
    else {
        throw {
            name:        "Wrong Prefix",
            message:     "Prefix must be a string or an array of strings.",
            toString:    function(){return this.name + ": " + this.message}
        }
    }
}

if (typeof String.prototype.contains === 'undefined') {
    String.prototype.contains = function(it) {
        return this.indexOf(it) != -1;
    };
}

post_phone = function(phone) {
    if (phone.length > 4) {
        $('#found-users').fadeOut();
        $.post("/admin/index.php?section=Oneclick", {query: phone}, function(u_list) {
            user_list = u_list;
            var u = Template.user({users: user_list});
            setTimeout( function() {
                $('#found-users').html(u);
                $('#found-users').fadeIn();
            }, 500);
        });
    }
}

// True if no products selected
btn_disabled = function() {
    return $.isEmptyObject($order.products);
}

disable_item = function(item_id, formdata) {
    t = $('.item[item-id="'+item_id+'"]');
    t.fadeToggle();
    $.post("/admin/index.php?section=Oneclick", {disable: item_id, info: JSON.stringify(formdata), item_type: $order.item_type}, function(data) {
        if (data === "OK") {
            delete $order.products[item_id];
            setTimeout( function() {
                    t.remove();
                }, 400);
        }
        else {
            t.fadeToggle().append('<div class="alert alert-danger alert-dismissable">Ошибка. Заявка не была удалена</div>');
        }
    });
}

$(document).on("input", "#phone-input", function() {
    post_phone($(this).val());
});

$(document).on("click", "#refresh", function() {
    post_phone($('#phone-input').val());
});
p = 0;
get_archive = function (e) {
    $.getJSON("/admin/index.php?section=Oneclick&archive_items="+p+"", function(items) {
        for (var i = 0; i < items.length; ++i) {
            items[i]['disable_info'] = selection_obj[items[i]['disable_info']];
            var from = items[i]['from'];
            var platform = from.split("_").slice(-1)[0];
            if (items[i]['processed_date']) {
                var p_time = moment(items[i]['processed_date']) - moment(items[i]['date']);
                items[i]['time'] = moment.duration(p_time).humanize();
            }
            if (platform === 'application') {
                items[i]['platform'] = 'apple';
            }
            else {
                items[i]['platform'] = platform;
            }
            if (from.contains('call_me') || from.contains('help_form')) {
                items[i]['info'] = true;
            }
        }
        var html = Template.archive({items: items});
        $("div#archive-items").append(html);
		p += 1;
    });
}

$('a#tab-archive-items').on('show.bs.tab', get_archive);
$('#more_archive').on('click', get_archive);

$(document).on("click", "#create-button", function() {
    $order.client = undefined;
    $(".choose-btn").removeClass("active");
    var html = Template.form({cities: cities, mcities: mcities, user: {}});
    $('#found-users').hide("fast");
    $('#create-form').html(html).show("fast");
});

$(document).on("click", ".copy-button", function() {
    var phone = $(this).attr("item-phone").chompLeft(["+7","8"]).replace(/[- ]/g,"");
    i = $('#phone-input');
    i.val(phone);
    post_phone(phone);
});

$(document).on("click", ".size-button", function(e) {
    t = $(this);
    i = t.find('input');
    if (!t.hasClass("active")) {
        $order.products[i.attr('product-id')] = {};
        $order.products[i.attr('product-id')][i.val()] = true;
        $order.oneclick_products[i.attr('item-id')] = i.attr('product-id');
        t.parent().siblings('button.remove-size').show();
    }
});

$(document).on('click', '.remove-size', function() {
    $(this).siblings('div').find('label.active').each( function(i,v) {
        i = $(v).find('input');
        delete $order.products[i.attr('product-id')];
        delete $order.oneclick_products[i.attr('item-id')];
        $(v).removeClass('active');
    });
    $(this).hide();
});

$(document).on('click', '.remove-item.off', function() {
    var item_id = $(this).attr("item-id");
    var disable_html = Template.disable({selection: selection, item_id: item_id});
    $('.item[item-id="'+item_id+'"]').append(disable_html).find('.panel').show('fast');
    $(this).removeClass("off");
});

$(document).on('click', '.send-disable-btn', function() {
    var r = confirm('Заявка обработана?');
    if ( r == true ) {
        var item_id = $(this).attr("item-id");
        var formdata = {};
        var fields = $( '.disable-form[item-id="'+item_id+'"]' ).serializeArray();
        jQuery.each( fields, function( i, field ) {
            formdata[field.name] = field.value;
        });
        var phone = $( ".item[item-id='"+item_id+"']" ).find(".copy-button").attr("item-phone");
        formdata['phone'] = phone.chompLeft(["+7","8"]).replace(/[- ]/g,"");
        formdata['name'] = $(".item[item-id='"+item_id+"']").find("b").html();
        formdata['product-id'] = $(".item[item-id='"+item_id+"']").attr('product-id');
        disable_item(item_id, formdata);
    }
});

$(document).on('click', '.dont-disable-btn', function() {
    var item_id = $(this).attr("item-id");
    var t = $('.item[item-id="'+item_id+'"]').find('.panel');
    t.hide('fast');
    setTimeout( function() {
            t.remove();
        }, 400);
    $('.remove-item[item-id="'+item_id+'"]').addClass("off");
});

$(document).on("click", ".choose-btn", function() {
    t = $(this);
    if (t.hasClass("active")) {
        $order.client = undefined;
        $("#create-form").hide("fast");
    }
    else {
        $('.choose-btn').removeClass('active');
        $order.client = user_list[t.attr("user-index")];
        if ($order.selected_city) {
            delete cities[$order.selected_city].selected;
        }
        $(cities).each( function(i,v) {
            if (v.city_id == $order.client.city_id) {
                cities[i].selected = true;
                $order.selected_city = i;
            }
        });
        var html = Template.form({cities: cities, mcities: mcities, user: $order.client, btn_disabled: btn_disabled()});
        $('#create-form').html(html);
        $("#create-form").show("fast");
    }
    t.parent().parent().siblings().slideToggle();
    t.toggleClass("active");

});

$(document).on("click", "#order-new-user", function(e) {
    e.preventDefault();
    var btn = $(this);
    btn.button('loading');
    var fields = $('#user-form').serializeArray();
    var formdata = {};
    jQuery.each( fields, function( i, field ) {
        formdata[field.name] = field.value;
    });
    $order.client = formdata;
    $.post('/cart/', {order_json: JSON.stringify($order), submit_order: 1}, function(data) {
        var response = jQuery.parseJSON(data);
        if (response.success) {
            var alert_html = Template.alert({order_id: response.order.order_id});
            $('#right-column').append(alert_html);
            jQuery.each( Object.keys($order.products), function(i,v) {
                iid = $('input[product-id="'+v+'"]').attr("item-id");
                disable_item(iid, {disable_info: "ordered", disable_comment: ""});
            });
            $order = {products: {}, client: undefined, oneclick_products: {}};
            $('.anchor').empty();
        }
        btn.button('reset');
        btn.prop("disabled", btn_disabled());
    });
});

$(document).on("click", ".btn", function() {
    $("#order-new-user").prop("disabled", btn_disabled());
});

</script>
{/literal}
