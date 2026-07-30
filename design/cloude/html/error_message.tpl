<div style="width: 100%; background: #000; float: left;">
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
		<div><label for="radio6">Некачественно обработанная фотография 	</label><input id="radio6" type="radio" class="em_radio" name="error_mess" value="Некачественно обработанная фотография"/></div>
		<div><label for="radio1">Товара нет в наличии 		</label><input id="radio1" type="radio" class="em_radio" name="error_mess" value="Товара нет в наличии"/></div>
    {if $product}
    <div id="p_fields" style="display:none;">
      <input type="text" name="p_id" value="{$product->product_id}" readonly />
      <select name="size" id="size" class="" disabled>
        <option value=""></option>
        {foreach from=$product->sizes item=size}
          <option value="{$size}" id="s{$size}">{$size}</option>
        {/foreach}
      </select>
    </div>
    {/if}
		<div><label for="radio2">Ошибка в размерах 			</label><input id="radio2" type="radio" class="em_radio" name="error_mess" value="Ошибка в размерах"/></div>
		<div><label for="radio3">Ошибка в категории товара 	</label><input id="radio3" type="radio" class="em_radio" name="error_mess" value="Ошибка в категории товара"/></div>
		<div><label for="radio4">Ошибка в описании товара 	</label><input id="radio4" type="radio" class="em_radio" name="error_mess" value="Ошибка в описании товара"/></div>
		<div><label for="radio4">Не работает оборудование торговой точки 	</label><input id="radio5" type="radio" class="em_radio" name="error_mess" value="Не работает оборудование торговой точки"/></div>
		<div><label for="radio5">Другая ошибка 				</label><input id="radio6" type="radio" class="em_radio" name="error_mess" checked value="Другая ошибка"/></div>
		<div>
			<textarea id="comment" name="comment" placeholder="Дополнительный комментарий"></textarea>
		</div>
	</div>
	<a href="javascript:void(0);" id="client_info_cl">
		<input type="submit" id="client_info" class="ShAA_errorButton" value="Отправить отчет" />
	</a>
	</form>
  {literal}
<script>
    $ = jQuery;
    $(document).on('click', "#client_info_cl", function(e) {
      var size = $('#size').val();
      var em = $('#radio1').prop('checked');
      if (em && !size && $('.ShAA_sizeNotSelect').length > 0) {
        e.preventDefault();
        alert('Выберите размер.');
      }
      else{
        $('#error_message').submit();
      }
    });
    $(document).on('change', ".em_radio", function(e) {
      var em = $('#radio1').prop('checked');
      if (em) {
        $('#p_fields').slideDown();
        $('#p_fields input').prop('disabled',false);
        $('#p_fields select').prop('disabled',false);
      }
      if(!em){
        $('#p_fields').slideUp();
        $('#p_fields input').prop('disabled',true);
        $('#p_fields select').prop('disabled',true);
      }
    });
    jQuery(document).ready(function() {
      var size = '#s' + $('.ShAA_sizeNotSelect.on a').html();
      $(size).prop('selected',true);
    });

</script>
{/literal}

</div>
</div>