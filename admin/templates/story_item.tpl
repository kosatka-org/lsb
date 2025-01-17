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
    <div id="cont" style="padding-right: 12px;">
      <div id="cont_top">
        <!-- Иконка раздела /--> 
          <img src="./images/icon_products.png" alt="" class="line"/>
        <!-- /Иконка раздела /-->
	    
        <!-- Заголовок раздела /-->
          <h1 id="headline">{if $story->title}{$story->title}{else}Новый{/if}</h1>
          <div style="clear:both;"></div>
        <!-- /Заголовок раздела /-->
      </div>
      <div id="cont_center">
        <div class="clear">&nbsp;</div>	  
        <div class="row mt20">
          <div class="panel panel-default">
            <div class="panel-body">
              <form role="form" name="banner" method="POST" action="/admin/index.php?section=Storis&save_story" enctype='multipart/form-data'>
                <input type="hidden" name="story_id" id="story_id" value="{$story->id}"/>
                <div class = "form-group">
                  <span class="lim_tip" style="color:red; display: none;">* Длина описания не должна превышать 15 символов.</span>
                  <div class="input-group">
                    <span class="input-group-addon">Название</span>
                    <input type="text" class="form-control" name="title" value="{$story->title}">
                  </div>
                  <div class="input-group">
                    <span class="input-group-addon">Англ. Название</span>
                    <input type="text" class="form-control" name="eng_title" value="{$story->eng_title}">
                  </div>
                  <br>
                  <div class="row">
                    <div class="col-md-6">
                      <div class="input-group">
                        <span class="input-group-addon">URL</span>
                        <input type="text" class="form-control" name="url" value="{$story->url}">
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="input-group">
                        <span class="input-group-addon">Дата завершения</span>
                        <input type="text" class="form-control" name="end_date" value="{if $story->end_date && $story->end_date != '0000-00-00 00:00:00'}{$story->end_date}{else}{$end_date}{/if}">
                      </div>
                    </div>
                  </div>
                  <br>
                  <br>
                </div>
                <div class="form-group" style='overflow:hidden;'>
                  <div style='float:left;margin-right:50px;'>
                    <label for="banner">Картинка обложки</label>
                    <input type="file" name="banner" id="image_{$story->id}">
                    <div class="i_block">
                      {if $story->banner}
                        <img style="max-width:300px;" src="/files/stories/{$story->banner}">
                        <p>
                          <img src="./images/cancel1.jpg" alt=""/>
                          <a href="#" class="link del_pic" data-field="banner">Удалить</a>
                        </p>
                      {else}
                        <p class="help-block">Обложка не загружена</p>
                      {/if}
                    </div>
                  </div>
                  <div style='float:left;margin-right:20px;'>
                    <label for="eng_banner">Картинка англоязычной обложки</label>
                    <input type="file" name="eng_banner" id="eng_banner">
                    <div class="i_block">
                      {if $story->eng_banner}
                        <img style="max-width:300px;" src="/files/stories/{$story->eng_banner}">
                        <p>
                          <img src="./images/cancel1.jpg" alt=""/>
                          <a href="#" class="link del_pic" data-field="eng_banner">Удалить</a>
                        </p>
                      {else}
                        <p class="help-block">Обложка не загружена</p>
                      {/if}
                    </div>
                  </div>
                </div>
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                  {foreach item=block key=key from=$blocks}
                   {assign var="b_name" value="block_`$key`"}
                    <div class="panel panel-default">
                      <div class="panel-heading" role="tab" id="heading{$key}">
                        <h4 class="panel-title">
                          <a role="button" data-toggle="collapse" href="#collapse{$key}" aria-expanded="true" aria-controls="collapse{$key}">
                            Блок #{$key}
                          </a>
                        </h4>
                      </div>
                      <div id="collapse{$key}" class="panel-collapse collapse {if $block}in{/if}" role="tabpanel" aria-labelledby="heading{$key}">
                        <div class="panel-body">
                          <div>
                            <!-- Nav tabs -->
                            <ul class="nav nav-tabs" role="tablist">
                              <li role="presentation"{if $block == 'img'} class="active"{/if}><a href="#image{$key}" aria-controls="image{$key}" role="tab" data-toggle="tab">Изображение</a></li>
                              <li role="presentation"{if $block != 'img'} class="active"{/if}><a href="#video{$key}" aria-controls="video{$key}" role="tab" data-toggle="tab">Видео</a></li>
                            </ul>
                            <!-- Tab panes -->
                            <div class="tab-content">
                              <div role="tabpanel" class="tab-pane{if $block == 'img'} active{/if}" id="image{$key}">
                                <div style="clear:both;margin-top:10px;"></div>
                                <input type="file" name="blocks[{$key}]" id="block_{$key}">
                                <div class="i_block">
                                  {if $block == 'img'}
                                    <img src="/files/stories/{$story->$b_name}" width=300 />
                                    <p>
                                      <img src="./images/cancel1.jpg" alt=""/>
                                      <a href="#" class="link del_pic" data-field="block_{$key}">Удалить</a>
                                    </p>
                                  {else}
                                    <p class="help-block">Изображение не загружено</p>
                                  {/if}
                                </div>
                              </div>
                              <div role="tabpanel" class="tab-pane{if $block != 'img'} active{/if}" id="video{$key}">
                                <div style="clear:both;margin-top:10px;"></div>
                                <input type="text" name="blocks[{$key}]" id="block_{$key}"><br/>
                                <div class="v_block">
                                {if $block == 'vimeo'}
                                  <iframe src="{$story->$b_name}?autoplay=1&autopause=0&background=1&muted=1&loop=1" width="320" height="480"  frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="float: left;"></iframe>
                                  <p>
                                    <img src="./images/cancel1.jpg" alt=""/>
                                    <a href="#" class="link del_vid" data-field="block_{$key}">Удалить</a>
                                  </p>
                                {elseif $block == 'youtube'}
                                  <iframe src="{$story->$b_name|replace:'watch?v=':'embed/'}?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
                                  <p>
                                    <img src="./images/cancel1.jpg" alt=""/>
                                    <a href="#" class="link del_vid" data-field="block_{$key}">Удалить</a>
                                  </p>
                                {else}
                                  <p class="help-block">Видео не загружено</p>
                                {/if}
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  {/foreach}
                </div>
                <div class="form-inline">
                  <div class="checkbox" style="padding-right:12px;">
                    <label>
                      <input type="checkbox" name="enabled" value='1' {if $story->enabled == 1}checked="true"{/if}> Активен
                    </label>
                  </div>
                  <div class="form-group" style="padding-right:12px;">
                    <label for="position_{$story->id}">Позиция:</label>
                    <input id="position_{$story->id}" name="position" style="width: 42px;margin-left: 10px;" value="{$story->position}"/>
                  </div>
                  <button type="submit" class="btn btn-primary" style="padding-right:12px;">Сохранить</button>
                  <a tabindex="0" role="button" href="/admin/index.php?section=Storis&del_story={$story->id}" onclick="return alert('Вы действительно хотите удалить историю?');" class="btn btn-danger">Удалить</a>
                </div>
              </form>
            </div>
          </div>
        </div>
        <div class="clear">&nbsp;</div>	 
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
    $(document).on("click touchstart", ".del_pic", function(e) {
        e.preventDefault();
        var story = $('#story_id').val();
        var field = $(this).data('field');
        var cont = $(this).parents('.i_block');
        $.get("/admin/index.php?section=Storis&story="+story+"&del_pic="+field, function(reply) {
        if(reply == 'ok') cont.html('<p class="help-block">Изображение не загружено</p>');
        else console.log(0);
      });
    });
    $(document).on("click touchstart", ".del_vid", function(e) {
        e.preventDefault();
        var story = $('#story_id').val();
        var field = $(this).data('field');
        var cont = $(this).parents('.v_block');
        $.get("/admin/index.php?section=Storis&story="+story+"&del_vid="+field, function(reply) {
        if(reply == 'ok') cont.html('<p class="help-block">Видео не загружено</p>');
        else console.log(0);
      });
    });
{/literal}
</script>