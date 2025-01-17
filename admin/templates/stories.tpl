{literal}
<style type="text/css">
body {
  background: none;
}
.mt20 {
  margin-top: 20px;
}
</style>
{/literal}
<div id="inserts_all">
  <!-- Вкладки /-->
  {include file='products_menu.tpl' active='storis'}
  <!-- /Вкладки /-->
   
  <!-- Путь /-->
  <table id="in_right">
    <tr>
      <td>
        <p>
          <a href="./">Luxury Store</a>
        </p>
      </td>
    </tr>
  </table>
  <!-- /Путь /-->
</div>	


<!-- Content #Begin /-->
<div id="content">
  <div id="cont_border">
    <div id="cont">
      <div id="cont_top">
        <!-- Иконка раздела /--> 
          <img src="./images/icon_products.png" alt="" class="line"/>
        <!-- /Иконка раздела /-->
	    
        <!-- Заголовок раздела /-->
          <h1 id="headline">Сторис</h1>
          <div style="clear:both;"></div>
          <a class="btn btn-default" href="/admin/index.php?section=Storis&create_new=1" role="button">Создать новую</a>
        <!-- /Заголовок раздела /-->
      </div>
      <div id="cont_center">
        <div class="clear">&nbsp;</div>	  
        
        <div class="clear">&nbsp;
          {if $Storis}
          {foreach from=$Storis item=item key=key name=items}
            <div class="row mt20">
              <div class="panel panel-default">
                <div class="panel-body">
                    <a href="/admin/index.php?section=Storis&story={$item->id}"><h2>{$item->title}</h2></a>
                    <div class="form-group">
                      {if $item->banner}
                        <img style="max-width:300px;" src="/files/stories/{$item->banner}">
                      {else}
                        <p class="help-block">Баннер не загружен</p>
                      {/if}
                    </div>
                    <div class="form-inline">
                      <div class="checkbox" style="padding-right:12px;">
                        <label>
                          <input type="checkbox" id="enabled_{$item->id}" name="enabled" value='1' {if $item->enabled == 1}checked="true"{/if}> Активен
                        </label>
                      </div>
                      <div class="form-group" style="padding-right:12px;">
                        <label for="position_{$item->id}">Позиция:</label>
                        <input id="position_{$item->id}" name="position" style="width: 42px;margin-left: 10px;" value="{$item->position}"/>
                      </div>
                      <button type="submit" class="btn btn-primary quick_save" id="{$item->id}" style="padding-right:12px;">Сохранить</button>
                      <a tabindex="0" role="button" href="/admin/index.php?section=Storis&del_story={$item->id}" onclick="return alert('Вы действительно хотите удалить историю?');" class="btn btn-danger">Удалить</a>
                      <div class="results"></div>
                    </div>
                </div>
              </div>
            </div>
          {/foreach}
          {/if}
        </div>	  
      </div>  
    </div>
  </div>	    
</div>
<!-- Content #End /--> 
<script>
{literal}
    $(document).on("click touchstart", ".toggler", function(e) {
        e.preventDefault();
        $(this).parent().next(".toggle").slideToggle();
    });
    
    $(document).on("click touchstart", ".quick_save", function(e) {
        e.preventDefault();
        var story = $(this).attr('id');
        var enabled = $("#enabled_"+story).val();
        var position = $("#position_"+story).val();
        var cont = $(this).siblings('.results');
        $.get("/admin/index.php?section=Storis&quick_save="+story+"&position="+position+"&enabled="+enabled, function(reply) {
        if(reply == 'ok') cont.html('<div class="alert alert-success" role="alert">Сохранено</div>');
        else console.log(0);
      });
    });
{/literal}
</script>