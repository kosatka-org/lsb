{* 
  template name: Общий вид страницы

  Этот шаблон отвечает за общий вид страниц.
  Используется классом Site.class.php
  Передаваемые в шаблон параметры смотрите в конце файла  
  
*}<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>{$title|escape}</title>
    <base href="http://{$root_url}/">
    <meta name="description" content="{$description|escape}" />
    <meta name="keywords" content="{$keywords|escape}" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    <meta http-equiv="Content-Language" content="ru" />
    <meta name="robots" content="all" />
    {* Всплывающие подсказки для администратора *}
    {if $smarty.session.admin == 'admin'}
    <script src="js/admintooltip/php/admintooltip.php" language="JavaScript" type="text/javascript"></script>    
    <link href="js/admintooltip/css/admintooltip.css" rel="stylesheet" type="text/css" /> 
    {/if}

    <link media="all" href="/css/style.css" rel="stylesheet" type="text/css" />    
    <script type="text/javascript" src="/jscript/jquery-1.4.2.js"></script>
</head>


<body>


<body>
    <div class="headBlock">
        <div class="logoOnline">
            <a href="/"><img src="/images/logo.png"  width="220" height="64" /></a>
        </div>
        <div class="rightTopLinks">
            <div class="links">
            <!-- Информер корзины #End /-->         
	            <div><a href="/cart/"><span class="cartImg"></span><span class="text">Корзина ({$cart_products_num})</span></a></div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
    <div class="mainMenu">
        <ul class="menuList">
	        <li><a href="new">Что нового?</a></li>
	        <li>|</li>
	        <li><a href="/brands">Дизайнеры</a></li>
	        <li>|</li>
	        <li><a href="clothes">Одежда</a></li>
	        <li>|</li>
	        <li><a href="shoes">Обувь</a></li>
	        <li>|</li>
	        <li><a href="linen">Белье</a></li>
	        <li>|</li>
	        <li><a href="accessory">Аксессуары</a></li>
	    </ul>
        <div class="search">
            <input type="text" name="search" value="Ищем по сайту" />
            <img src="/images/search.png" width="15" height="15" />
        </div>
        <div class="clear"></div>
    </div>
    <div class="footerLine"></div>
    <div class="mainContent">

                
            
            <!-- Верхнее меню 
            <ul id="top_header_menu">
                {foreach name=sections from=$sections item=s}
                <li>
                  {if $section->section_id == $s->section_id}                  
                  <span tooltip='section' section_id='{$s->section_id}'>{$s->name|escape}</span>
                  {else}
                  <a tooltip='section' section_id='{$s->section_id}' href='sections/{$s->url}'>{$s->name|escape}</a>
                  {/if}
                </li>
                {/foreach}                
            </ul>
				Верхнее меню #end /-->     
                
    
    
        
            <!-- Меню каталога
            <div id="catalog_menu">
			{defun name=categories_tree categories=$categories}
			{if $categories}
			<ul class="catalog_menu">
			{foreach item=c from=$categories}
				{if $category->category_id != $c->category_id}
				<li><a href='/catalog/{$c->url}/' tooltip='category' category_id='{$c->category_id}'>{$c->name}</a></li>
				{else}
				<li><span tooltip='category' category_id='{$c->category_id}'>{$c->name}</span></li>
				{/if}
				{fun name=categories_tree categories=$c->subcategories}        
			{/foreach}  
			</ul>
			{/if}    
			{/defun}
            </div>
            Меню каталога #End /-->

            {if 0 && $all_brands}
            <!-- Список брендов /-->
            <div id="brands_menu">
            	{* Расчет размеров брендов и вывод их *}
                {assign var=min_size value=10}
                {assign var=max_size value=25}
                {assign var=max_count value=0}
                {assign var=min_count value=$all_brands.0->products_num}
                {foreach name=brands from=$all_brands item=b}
                	{if $b->products_num >= $max_count}{assign var=max_count value=$b->products_num}{/if}
                	{if $b->products_num <= $min_count}{assign var=min_count value=$b->products_num}{/if}
                {/foreach}

                {foreach name=brands from=$all_brands item=b}
                {if $max_count>$min_count}
                {math assign=coef equation="(count-min_count)/(max_count-min_count)" max_count=$max_count min_count=$min_count count=$b->products_num}
                {else}
                {assign var=coef value=0.5}
                {/if}
                {math assign=size equation="min_size+(max_size-min_size)*coef" max_size=$max_size min_size=$min_size coef=$coef}
                 <a style='font-size:{$size}px;' href='brands/{$b->url}'>{$b->name|escape}</a>
                {/foreach}  
            	{* END Расчет размеров брендов и вывод их *}
            </div>
            <!-- Список брендов #End /-->
            {/if}
            
            <!-- Поиск /-->
            <div id="search">
                <form name=search method=get action="index.php"  onsubmit="window.location='http://{$root_url}/search/'+encodeURIComponent(encodeURIComponent(this.keyword.value)); return false;">
                    <input type=hidden name=module value=Search>
                    <p><input type="text" name=keyword value="{$keyword|escape}" class="search_input_text"/><input type="submit" value="Найти" class="search_input_submit"/></p>
                </form>
            </div>
            <!-- Поиск #End /-->

                                    
            {if 0 && $news}
            <!-- Новости /-->
            <ul id="news">
            {foreach  name=news from=$news item=n}
                <li>
                    <p class="news_date">{$n->date}</p>
                    <p tooltip="news" news_id="{$n->news_id}"><a href="news/{$n->url}">{$n->header|escape}</a></p>
                    <p class="news_annotation">
                        {$n->annotation}
                    </p>
                </li>
            {/foreach}         
                <li><a href="news/">архив новостей →</a></li>
            </ul>
            <!-- Новости #End /-->
            {/if}
            
        
        <!-- Правая часть страницы #Begin /-->
        <div id="right_side">
                    
            {$content}
            
        </div>
        <!-- Правая часть страницы #End /-->

		
    <!-- Подвал #Begin /-->
    <div id="footer">
        <ul id="syst">
            <li><img src="design/{$settings->theme}/images/visa.jpg" alt=""/></li>
            <li><img src="design/{$settings->theme}/images/master_card.jpg" alt=""/></li>
            <li><img src="design/{$settings->theme}/images/web_money.jpg" alt=""/></li>
        </ul>
        {$settings->counters}
        <p id="copyright">© Интернет-магазин 2005-2009</p>
    </div>
    <!-- Подвал #End /-->
    
</div>
<!-- Вся страница #End /-->

</div></div>
</body>
</html>
{*

  Передаваемые в шаблон параметры:
  
  $title - заголовок страницы
  $description - описание страницы
  $keywords - ключевые слова
  
  $sections - разделы меню
  $categories - категории товаров
  $content - основная часть страницы
  
  Параметры, передаваемые для всех страниц, и этой в том чисте:
  
  $root_url - корневой url сайта (без http://)
  $settings - настройки сайта, хранящиеся в базе
  $config - настройки сайта, хранящиеся в файле Config.class.php
  $currencies - валюты
  $currency - текущая валюта
  $main_currency - основная валюта
  $user - пользователь, если залогинен  
  
*}