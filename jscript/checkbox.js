	jQuery(document).ready(function(){
		/* при загрузке страницы нужно проверить какое значение имеет чекбокс и в соответствии с ним выставить вид */
		jQuery(".niceCheck").each( function() {
			 changeCheckStart(jQuery(this));
		});
	});


	/*
	    функция смены вида и значения чекбокса
	    el - span контейнер дял обычного чекбокса
	    input - чекбокс
	*/
	function changeCheck(el, value) {
		value = value ? value : 0;
	    var el = el, input = el.find("input");//.eq(0);
		value = !value ? !input.attr("checked") : (value == 1 ? true : false);
		//console.log(input.attr("id") +  ' ' + value);
	    if( value ) {
	        el.css("background-position","0 -15px");   
	        input.attr("checked", true);
			return true;
	    } else {
	        el.css("background-position","0 0");   
	        input.attr("checked", false);
			return false;
	    }
	    return true;
	}


	/*
	    если установлен атрибут checked, меняем вид чекбокса
	*/
	function changeCheckStart(el) {
		var el = el, input = el.find("input").eq(0);
	    if(input.attr("checked")) {
	        el.css("background-position","0 -15px");   
	    }
	    return true;
	} 
