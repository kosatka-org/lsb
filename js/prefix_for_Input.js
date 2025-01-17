$(document).ready(function(){
    if($(".ShAA_prefixForMiniInput").html()||function(){
        if($(".ShAA_popInput").html()){
            var arr = $(".ShAA_popInput");
            for(let i = 0; i< arr.length; ++i){
                if($(arr[i]).html().indexOf('phone')+1){
                    return true;
                }
            }
        }else{
            return false;
        }
    }){
        if(!$(".ShAA_prefixForMiniInput").html()&&function(){
            if($(".ShAA_popInput").html()){
                var arr = $(".ShAA_popInput");
                for(let i = 0; i< arr.length; ++i){
                    if($(arr[i]).html().indexOf('phone')+1){
                        return true;
                    }
                }
            }
        }){
            var codes = {
                "Russia":                "+7",
                "Austria":               "+43",
                "Albania":               "+355",
                "Andorra":               "+376",
                "Belarus":               "+375",
                "Belgium":               "+32",
                "Bulgaria":              "+359",
                "Bosnia and Herzegovina":"+387",
                "Vatican":               "+379",
                "Great Britain":         "+44",
                "Hungary":               "+36",
                "Germany":               "+49",
                "Greece":                "+30",
                "Denmark":               "+45",
                "Ireland":               "+353",
                "Iceland":               "+354",
                "Spain":                 "+34",
                "Italy":                 "+39",
                "Latvia":                "+371",
                "Lithuania":             "+370",
                "Liechtenstein":         "+423",
                "Luxembourg":            "+352",
                "Macedonia":             "+389",
                "Malta":                 "+356",
                "Moldova":               "+373",
                "Monaco":                "+377",
                "Netherlands":           "+31",
                "Norway":                "+47",
                "Poland":                "+48",
                "Portugal":              "+351",
                "Romania":               "+40",
                "San Marino":            "+378",
                "Serbia":                "+381",
                "Slovakia":              "+421",
                "Slovenia":              "+386",
                "Ukraine":               "+380",
                "Finland":               "+358",
                "France":                "+33",
                "Croatia":               "+385",
                "Montenegro":            "+382",
                "Czech":                 "+420",
                "Switzerland":           "+41",
                "Sweden":                "+46",
                "Estonia":               "+372",
                "Azerbaijan":            "+994",
                "Armenia":               "+374",
                "Georgia":               "+995",
                "Kazakhstan":            "+7",
                "Cyprus":                "+357",
                "Kyrgyzstan":            "+996",
                "Tajikistan":            "+992",
                "Turkmenistan":          "+993",
                "Turkey":                "+90"
            }
        }else{
            var codes = {
                "Россия":	            "+7",
                "Австрия":	            "+43",
                "Албания":	            "+355",
                "Андорра":	            "+376",
                "Белоруссия":	        "+375",
                "Бельгия":	            "+32",
                "Болгария":	            "+359",
                "Босния и Герцеговина":	"+387",
                "Ватикан":	            "+379",
                "Великобритания":	    "+44",
                "Венгрия":	            "+36",
                "Германия":	            "+49",
                "Греция":               "+30",
                "Дания":	            "+45",
                "Ирландия":	            "+353",
                "Исландия":	            "+354",
                "Испания":	            "+34",
                "Италия":	            "+39",
                "Латвия":	            "+371",
                "Литва":	            "+370",
                "Лихтенштейн":          "+423",
                "Люксембург":	        "+352",
                "Македония":	        "+389",
                "Мальта":	            "+356",
                "Молдавия":	            "+373",
                "Монако":	            "+377",
                "Нидерланды":	        "+31",
                "Норвегия":	            "+47",
                "Польша":	            "+48",
                "Португалия":	        "+351",
                "Румыния":	            "+40",
                "Сан-Марино":	        "+378",
                "Сербия":	            "+381",
                "Словакия":	            "+421",
                "Словения":	            "+386",
                "Украина":	            "+380",
                "Финляндия":	        "+358",
                "Франция":	            "+33",
                "Хорватия":	            "+385",
                "Черногория":	        "+382",
                "Чехия":	            "+420",
                "Швейцария":	        "+41",
                "Швеция":	            "+46",
                "Эстония":	            "+372",
                "Азербайджан":          "+994",
                "Армения":              "+374",
                "Грузия":               "+995",
                "Казахстан":            "+7",
                "Кипр":                 "+357",
                "Киргизия":             "+996",
                "Таджикистан":          "+992",
                "Туркмения":            "+993",
                "Турция":               "+90"
            }
        }
        if($(".ShAA_prefixForMiniInput").html()){
            var elems = $(".ShAA_prefixForMiniInput");
        }else{
            var container = $(".ShAA_popInput");
            for(var k=0;k<container.length;++k){
                if ($(container[k]).html().indexOf('phone')+1){
                    var span = document.createElement("span");
                    span.className = 'ShAA_prefixForMiniInput';
                    $(container[k]).prepend(span);
                }
            }
            var elems = $(".ShAA_prefixForMiniInput");
        }
        
        for(var i=0; i<elems.length; ++i){ 
            $(elems[i]).html("");
            var select = document.createElement("select");
            select.id = "country_"+ i;
            select.style = 'overflow: hidden;-webkit-appearance: none;-moz-appearance: none;appearance: none;padding: 0 0 0 3px;width: 40px; display:inline-block; float: left; position: relative; top: -12px; height: 44px; border-radius:0;'
            $(elems[i]).html(select);
            $(elems[i]).parent().addClass('parent_phone');
            $(elems[i]).parent().attr({style:'white-space:nowrap; width: calc(100% + 1px)'});
            $(elems[i]).find('~ input:first').addClass('first_input_for_phone');
            $('.first_input_for_phone').attr({maxLength: '15'});
            $(elems[i]).find('~ input').attr({style:'display : none !important'});
            if($('.first_input_for_phone').attr('value') == '7'){
                $('.first_input_for_phone').attr({value:''});
            }

            for (var key in codes) {
                var option = document.createElement("option");
                var country_name = document.createElement("div");
                var num = document.createElement('span');
                for(let i =0; i <   (7 - codes[key].length)*2; i++){
                    country_name.innerHTML = country_name.innerHTML + '&nbsp;'
                }
                country_name.innerHTML = country_name.innerHTML + key;
                country_name.className = 'country_name';
                num.text = codes[key];
                option.text = codes[key];// + ':  ' + key;
                $(option).attr({style:'background: rgba(255,255,255,1)'});
                document.getElementById("country_"+ i).appendChild(option);
                option.appendChild(country_name);
            }
            
            var field = document.createElement("input");
            field.name = 'input_for_phone';
            field.maxLength = '15';
            field.type = 'tel';
            field.value =  $(elems[i]).find('~ input.first_input_for_phone').val();
            field.placeholder = "(XXX) XXX-XX-XX";
            field.style = 'overflow: hidden;-webkit-appearance: none;-moz-appearance: none;appearance: none;padding: 0 0 0 5px !important;width: 40px; display:inline-block; float: left; position: relative; top: 0px; height: 42px; width: calc(100% - 55px) !important; border-radius:0;'
            $(elems[i]).parent().find('.first_input_for_phone').before(field);
        }
        
        function split_num(el, onload){
            var prefix = el.parent().find('select').val().replace(/\D+/g, "");
            var val = String(el.val());
            if(val[0]=='8'){
               val = val.replace('8', "7");
            }
            var num = val.replace(/\D/g, '').split(/(?=.)/);
            
            if (num[0] && !num[1] && num[0] != 9) {
                num[0] = 9;
            }
            if(onload){
                num_ = String(num).replace(prefix.split(''),'').replace(/[^-0-9]/gim,'').split('');
            }else{
                num_ = String(num).replace(/[^-0-9]/gim,'').split('');
            }
            
            var i = num_.length - 1;
            if (0 <= i && num_[0] != '') num_.splice(0, 0, '(');
            if (3 <= i) num_.splice(4, 0, ') ');
            if (6 <= i) num_.splice(8, 0, '-');
            if (8 <= i) num_.splice(11, 0, '-');
            // if (num_.length > 14) num_.pop();
            if (num_.length > 14) num_ = num_.slice(0,14);
            el.val(num_.join(''));
            
            let num2 = String(num_.splice(0, 15)).replace(/\D+/g, "");
            
            el.parent().find('.first_input_for_phone').val(num2? String(prefix) + String(num2): '');
        }
        
        $(".ShAA_prefixForMiniInput ~ input[name = input_for_phone]").keyup(function(){
            split_num($(this));
        });
        var inputs = $(".ShAA_prefixForMiniInput ~ input[name = input_for_phone]");
        for (let i = 0; i < inputs.length; i++){
            let val = String($(inputs[i]).parent().find('input.first_input_for_phone').val().replace(/\D/g, '').split(/(?=.)/));
            // val.splice(-10, 10);
            // let prefix = '+' + val;
            let codes = $(inputs[i]).parent().find('option');
            for (var index=0; codes.length>index; index++){
                if(String(val.replace(/\D/g, '').split(/(?=.)/)).indexOf(String($(codes[index]).text().replace(/\D/g, '').split(/(?=.)/))) == 0){
                    $(codes[index]).attr(({selected: ''}));
                    index = codes.length;
                }
            }
            split_num($(inputs[i]), true);
        }
        $('.parent_phone select').change(function(){
            split_num($(this).parent().find('~ input[name = input_for_phone]'));
        });
        $('input[name = input_for_phone]').focusout(function(){
            var element = $(this).parent().find('input.first_input_for_phone');
            element.attr({style:''})
            element.blur();
            element.attr({style:'opacity : 0 !important; user-select: none; cursor: default; height: 1px !important; width: 2px !important; padding: 0 !important',readonly:''});
            setTimeout(() => {
                element.parent().find('.phone_numberformError').attr({style:'white-space: initial;'});
                element.parent().find('.formErrorContent').attr({style:'white-space: initial;'});
            }, 100);	
            
        });
    }
});
