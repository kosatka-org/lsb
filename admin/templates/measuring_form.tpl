{foreach from=$items item=item}
<div class="fatlist_col" style="width: 270px; border:1px solid gray;">
  <table class="measurings_form">
    <tr>
      <td class="model" style="font-size: 12px;">Штрихкод</td>
      <td class="m_t"><p>{$item->barcode}<input type="hidden" value='{$item->product}' name="product_id"></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Размер</td>
      <td class="m_t"><p>{$item->size}<input type="hidden" value='{$item->item}' name="item_id"><input type="hidden" value='{$item->barcode}' name="barcode"></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">замер по талии</td>
      <td class="m_t"><p><input name="waist" type="text" class="input5" value="{if $item->waist}{$item->waist}{/if}"></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">замер по бедрам</td>
      <td class="m_t"><p><input name="hips" type="text" class="input5" value="{if $item->hips}{$item->hips}{/if}"></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">замер по ширине ляжки</td>
      <td class="m_t"><p><input name="thigh" type="text" class="input5" value="{if $item->thigh}{$item->thigh}{/if}"></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">высота посадки</td>
      <td class="m_t"><p><input name="waist_height" type="text" class="input5" value="{if $item->waist_height}{$item->waist_height}{/if}"></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">замер низа брючины</td>
      <td class="m_t"><p><input name="bottom_width" type="text" class="input5" value="{if $item->bottom_width}{$item->bottom_width}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">замер колена (для спорт.)</td>
      <td class="m_t"><p><input name="knee_width" type="text" class="input5" value="{if $item->knee_width}{$item->knee_width}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">замер длины брючины</td>
      <td class="m_t"><p><input name="leg_lenght" type="text" class="input5" value="{if $item->leg_lenght}{$item->leg_lenght}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Замер по плечам</td>
      <td class="m_t"><p><input name="shoulders" type="text" class="input5" value="{if $item->shoulders}{$item->shoulders}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Замер объема груди</td>
      <td class="m_t"><p><input name="chest" type="text" class="input5" value="{if $item->chest}{$item->chest}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Длина изделия по спине</td>
      <td class="m_t"><p><input name="lenght_on_back" type="text" class="input5" value="{if $item->lenght_on_back}{$item->lenght_on_back}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Замер длины рукава изделия</td>
      <td class="m_t"><p><input name="sleeve" type="text" class="input5" value="{if $item->sleeve}{$item->sleeve}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Замер резинки внизу изделия</td>
      <td class="m_t"><p><input name="bottom_band" type="text" class="input5" value="{if $item->bottom_band}{$item->bottom_band}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Замер ширины стельки</td>
      <td class="m_t"><p><input name="insole_width" type="text" class="input5" value="{if $item->insole_width}{$item->insole_width|number_format:1:'.':' '}{/if}"/></p></td>
    </tr>
    <tr>
      <td class="model" style="font-size: 12px;">Замер длины стельки</td>
      <td class="m_t"><p><input name="insole_length" type="text" class="input5" value="{if $item->insole_length}{$item->insole_length|number_format:1:'.':' '}{/if}"/></p></td>
    </tr>
  </table>
</div>
{/foreach}
<div style="clear:both;"></div>
<span id='measurings_send_reply'></span>
<input id="measurings_send" type="button" value="Сохранить замеры">
<img src="./images/line.jpg" alt="" class="clear" style='width: 100%;'>
{if $sold_items}
{foreach from=$sold_items item=item key=key}
  <div class="fatlist_col" style='width:290px'>
    <table class="measurings_form" Style='width:100%'>
      <tr>
        <td class="model" style="font-size: 12px;">Штрихкод</td>
        <td class="m_t"><p>{$item->barcode}</p></td>
      </tr>
      <tr>
        <td class="model" style="font-size: 12px;">Размер</td>
        <td class="m_t"><p>{$item->size}</p></td>
      </tr>
      <tr>
      {if $item->fitting}
        <tr>
          <td class="model" style="font-size: 12px;">Посадка</td>
          <td class="m_t"><p>{$item->fitting}</p></td>
        </tr>
      {/if}
      {if $item->material_stretch}
        <tr>
          <td class="model" style="font-size: 12px;">Материал</td>
          <td class="m_t"><p>{$item->material_stretch}</p></td>
        </tr>
      {/if}
      {if $item->waist}
        <tr>
          <td class="model" style="font-size: 12px;">замер по талии</td>
          <td class="m_t"><p>{$item->waist|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->hips}
        <tr>
          <td class="model" style="font-size: 12px;">замер по бедрам</td>
          <td class="m_t"><p>{$item->hips|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->thigh}
        <tr>
          <td class="model" style="font-size: 12px;">замер по ширине ляжки</td>
          <td class="m_t"><p>{$item->thigh|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->waist_height}
        <tr>
          <td class="model" style="font-size: 12px;">высота посадки</td>
          <td class="m_t"><p>{$item->waist_height|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->bottom_width}
        <tr>
          <td class="model" style="font-size: 12px;">замер низа брючины</td>
          <td class="m_t"><p>{$item->bottom_width|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->knee_width}
        <tr>
          <td class="model" style="font-size: 12px;">замер колена (для спорт.)</td>
          <td class="m_t"><p>{$item->knee_width|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->leg_lenght}
        <tr>
          <td class="model" style="font-size: 12px;">замер длины брючины</td>
          <td class="m_t"><p>{$item->leg_lenght|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->shoulders}
        <tr>
          <td class="model" style="font-size: 12px;">Замер по плечам</td>
          <td class="m_t"><p>{$item->shoulders|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->chest}
        <tr>
          <td class="model" style="font-size: 12px;">Замер объема груди</td>
          <td class="m_t"><p>{$item->chest|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->lenght_on_back}
        <tr>
          <td class="model" style="font-size: 12px;">Длина изделия по спине</td>
          <td class="m_t"><p>{$item->lenght_on_back|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->sleeve}
        <tr>
          <td class="model" style="font-size: 12px;">Замер длины рукава изделия</td>
          <td class="m_t"><p>{$item->sleeve|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->bottom_band}
        <tr>
          <td class="model" style="font-size: 12px;">Замер резинки внизу изделия</td>
          <td class="m_t"><p>{$item->bottom_band|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->insole_width}
        <tr>
          <td class="model" style="font-size: 12px;">Замер ширины стельки</td>
          <td class="m_t"><p>{$item->insole_width|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
      {if $item->insole_length}
        <tr>
          <td class="model" style="font-size: 12px;">Замер длины стельки</td>
          <td class="m_t"><p>{$item->insole_length|number_format:0:'.':' '}</p></td>
        </tr>
      {/if}
    </table>
  </div>
  {if ($key+1)%3 == 0}<img src="./images/line.jpg" alt="" class="clear" style='width: 100%;'>{/if}
{/foreach}
{/if}
  <script>
{literal}
    $(document).on("click", "#measurings_send", function(e) {
      e.preventDefault();
      var forms = $('.measurings_form');
      var formdata = [];
      jQuery.each( forms, function( i ) {
          var fields = $(this).find('input');
          var tempdata = {};
          jQuery.each( fields, function( i ) {
            tempdata[$(this).attr('name')] = $(this).val() || 0;
          });
          formdata.push(tempdata);
      });
      console.log(formdata);
      $.post("/admin/index.php?section=Product", {measurings_send: JSON.stringify(formdata)}, function(reply) {
        if(reply == 'ok'){
          $("span#measurings_send_reply").append("<span style='color:red;margin: 6px;'>Сохранено</span>");
          setTimeout(function(){
            $("div#measuring_form").find('.ajax_result').html('');
            $("#measuring_form").hide();
          }, 10000);
        }
      });
    });
  </script>
{/literal}