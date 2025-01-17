
jQuery(document).ready(function(){

jQuery(".niceCheck").mousedown(
/* при клике на чекбоксе меняем его вид и значение */
function() {

     changeCheck(jQuery(this));
     
});


jQuery(".niceCheck").each(
/* при загрузке страницы нужно проверить какое значение имеет чекбокс и в соответствии с ним выставить вид */
function() {
     
     changeCheckStart(jQuery(this));
     
});

                                        });

function changeCheck(el)
/* 
	функция смены вида и значения чекбокса
	el - span контейнер дял обычного чекбокса
	input - чекбокс
*/
{
     var el = el,
          input = el.find("input").eq(0);
   	 if(!input.attr("checked")) {
		el.css("background-position","0 -15px");	
		input.attr("checked", true)
	} else {
		el.css("background-position","0 0");	
		input.attr("checked", false)
	}
     return true;
}

function changeCheckStart(el)
/* 
	если установлен атрибут checked, меняем вид чекбокса
*/
{
var el = el,
		input = el.find("input").eq(0);
      if(input.attr("checked")) {
		el.css("background-position","0 -15px");	
		}
     return true;
}



jQuery("#chooseAll1").mousedown(
/* выбрать | снять выделение все checkbox */
function() {
	if((this).val()=="actform")
	{
		("#myForm .niceCheck > input").attr("checked",false);
		("#myForm .niceCheck").addClass("niceChecked");
		(this).val("inactform");
	}
	else
	{
		("#myForm .niceCheck > input").attr("checked",true);
		("#myForm .niceCheck").removeClass("niceChecked");
		(this).val("actform");
	}
	return;

});
