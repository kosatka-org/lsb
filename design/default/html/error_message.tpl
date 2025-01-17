{literal}
<style>
	#fancybox-bg-w, #fancybox-bg-e, #fancybox-bg-n, #fancybox-bg-s, #fancybox-bg-sw, #fancybox-bg-se, #fancybox-bg-nw, #fancybox-bg-ne {
		background: none;
	}
	#fancybox-outer {
		background: none;
	}
</style>
{/literal}

<div class="ShAA_manOrWoman" id="ShAA_manOrWoman">
	<div class="title">Сообщите об ошибке</div>
	<a onclick="{literal}jQuery.fancybox.close();{/literal}"><img src="/images/close_manorwoman.png" style="float: right; margin: 8px 0 0 0;" width="62"></a>
	<div class="line"></div>
	<div class="text">
		Укажите ошибку, которую вы заметили на странице.
	</div>
	<div class="clear"></div>
	<form autocomplete="off" action="/cart/error_message/" method="post" name="error_message" id="error_message">
		<input type="hidden" name="error_page" value="{$error_page}"/>
	<div class="ShAA_errorSelect">
		<div><label for="radio6">Некачественно обработанная фотография 	</label><input id="radio6" type="radio" name="error_mess" value="Некачественно обработанная фотография"/></div>
		<div><label for="radio1">Товара нет в наличии 		</label><input id="radio1" type="radio" name="error_mess" value="Товара нет в наличии"/></div>
		<div><label for="radio2">Ошибка в размерах 			</label><input id="radio2" type="radio" name="error_mess" value="Ошибка в размерах"/></div>
		<div><label for="radio3">Ошибка в категории товара 	</label><input id="radio3" type="radio" name="error_mess" value="Ошибка в категории товара"/></div>
		<div><label for="radio4">Ошибка в описании товара 	</label><input id="radio4" type="radio" name="error_mess" value="Ошибка в описании товара"/></div>
		<div><label for="radio4">Не работает оборудование торговой точки 	</label><input id="radio5" type="radio" name="error_mess" value="Не работает оборудование торговой точки"/></div>
		<div><label for="radio5">Другая ошибка 				</label><input id="radio6" type="radio" name="error_mess" checked value=Другая ошибка""/></div>
		<div>
			<textarea id="comment" name="comment" placeholder="Дополнительный комментарий"></textarea>
		</div>
	</div>
	<a href="javascript:void(0);" onclick="document.getElementById('error_message').submit();return false;">
		<input type="submit" id="client_info" class="ShAA_errorButton" value="Отправить отчет" />
	</a>
	</form>
</div>
