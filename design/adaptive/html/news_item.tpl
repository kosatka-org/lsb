{*
  Template name: Новость
  Вывод новости.
  Используется классом NewsLine.class.php

  Передаваемые параметры:
  $news_item - новость
*}

<!-- Заголовок /-->
<div class="ShAA_newsItemPage">
<div id="page_title">
  <!-- Хлебные крошки /-->
  <div id="path">
    <a href="/">Главная</a>
    → <a href='/feed/'>Новости</a>
    → {$news_item->header|escape}                
  </div>
  <!-- Хлебные крошки #End /-->
  <h1  tooltip='news' news_id='{$news_item->news_id}' class="float_left">{$news_item->header|escape}</h1>
</div>
<br>
<p>
  {if ($news_item->video) && ($news_item->video !='')}
    <div class="feed_text" id="video">{$news_item->video}</div>
  {elseif ($news_item->image) && ($news_item->image !='')}
    <img src="{$news_item->image}" class="ShAA_newsForImg" alt="news">
  {/if}
</p>
<p>
   {$news_item->body}
</p>
<br>
<p class="news_date">{$news_item->date}</p>
<br>
<p>
  <a href='/feed/'>← все новости</a>
</p>
</div>