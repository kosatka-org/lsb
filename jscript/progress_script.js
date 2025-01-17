$(document).ready(function(){
	jQuery.fn.anim_progressbar = function (aOptions) {
		// Определяем значения
		var iCms = 1000;
		var iMms = 60 * iCms;
		var iHms = 3600 * iCms;
		var iDms = 24 * 3600 * iCms;
 
		// Определяем опции
		var aDefOpts = {
			start: new Date(), // Текущее время
			finish: new Date().setTime(new Date().getTime() + 60 * iCms), // Текущее время  + 60 сек
			interval: 100
		}
		var aOpts = jQuery.extend(aDefOpts, aOptions);
		var vPb = this;
 
		// Каждый индикатор прогресса
		return this.each(
			function() {
				var iDuration = aOpts.finish - aOpts.start;
 
				// Вызываем оригинальный индикатор прогресса
				$(vPb).children('.pbar').progressbar();
 
				// Процесс обработки
				var vInterval = setInterval(
					function(){
						var iLeftMs = aOpts.finish - new Date(); // Оставшееся время в миллисекундах
						var iElapsedMs = new Date() - aOpts.start, // Прошедшее время в миллисекундах
							iDays = parseInt(iLeftMs / iDms), // Прошло дней
							iHours = parseInt((iLeftMs - (iDays * iDms)) / iHms), // Прошло часов
							iMin = parseInt((iLeftMs - (iDays * iDms) - (iHours * iHms)) / iMms), // Прошло минут
							iSec = parseInt((iLeftMs - (iDays * iDms) - (iMin * iMms) - (iHours * iHms)) / iCms), // Прошло секунд
							iPerc = (iElapsedMs > 0) ? iElapsedMs / iDuration * 100 : 0; // Процент выполнения
 
						// Выводим текущее положение и прогресс
						$(vPb).children('.percent').html('<b>'+iPerc.toFixed(1)+'%</b>');
						$(vPb).children('.elapsed').html(iDays+' дн. '+iHours+'ч.:'+iMin+'мин.:'+iSec+'сек.</b>');
						$(vPb).children('.pbar').children('.ui-progressbar-value').css('width', iPerc+'%');
 
						// В случае завершения
						if (iPerc >= 100) {
							clearInterval(vInterval);
							$(vPb).children('.percent').html('<b>100%</b>');
							$(vPb).children('.elapsed').html('Завершено');
						}
					} ,aOpts.interval
				);
			}
		);
	}
 
	// Для секунд с 1-й по 5-ю
	var iNow = new Date().setTime(new Date().getTime());
	var iEnd = new Date().setTime(new Date().getTime() + 5 * 1000);
	$('#progress').anim_progressbar({start: iNow, finish: iEnd, interval: 10});
 
});