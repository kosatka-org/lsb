<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0"{* xmlns:ya="http://blogs.yandex.ru/yarss/"*} xmlns:atom="http://www.w3.org/2005/Atom" xmlns:wfw="http://wellformedweb.org/CommentAPI/">

<channel>
  <title>Luxury Store Boutique</title>
  <link>https://lsboutique.ru</link>
  <description>интернет магазин фирменной одежды из Италии и Франции - Лакшери стор</description>
  {*<wfw:commentRss>https://lsboutique.ru/rss/</wfw:commentRss>
  <ya:more>{ссылка на следующую страницу RSS - с постами 98 и 97}</ya:more>
  <image>
    <url>http://anton.example.com/userpic.png</url>
    <width>100</width>
    <height>100</height>
  </image>*}
<atom:link href="https://lsboutique.ru/index.php?module=Rss" rel="self" type="application/rss+xml" />
 
{foreach from=$news_generated item=item}
<item>
  <guid isPermaLink='true'>https://lsboutique.ru/{$item->url}</guid>
  <author>mail@lsboutique.ru</author>
  <pubDate>{$item->date}</pubDate>
  <title>{$item->title}</title>
  <link>https://lsboutique.ru/{$item->url}</link>
  <description>{$item->text}</description>
 
  {*<comments>https://anton.example.com/post100.html#comments</comments>*}
</item>
{/foreach}

</channel>

</rss>