{if $Modernjs}
	<!DOCTYPE html>
	<html lang="ru">
{else}
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru">
{/if}

<head>
  <title>{$Title} Админка Svetlov</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Language" content="ru" />
  <meta name="description" content="{$Site_name}" />
  <meta name="keywords" content="" />
  <meta name="robots" content="all" />
  <meta name="format-detection" content="telephone=no" />
  <link rel="stylesheet" type="text/css" href="simpla.css?v=3.102" media="screen" />
  <link rel="stylesheet" type="text/css" href="/css/bootstrap.css" />
  <link rel="stylesheet" type="text/css" href="/css/font-awesome.css" />
  <link rel="apple-touch-icon" href="apple-touch-icon.png">
  <link rel="android-touch-icon" href="android-icon.png" />
  <link rel="apple-touch-icon" sizes="57x57" href="/images/icons/apple-touch-icon-57x57.png">
  <link rel="apple-touch-icon" sizes="114x114" href="/images/icons/apple-touch-icon-114x114.png">
  <link rel="apple-touch-icon" sizes="72x72" href="/images/icons/apple-touch-icon-72x72.png">
  <link rel="apple-touch-icon" sizes="144x144" href="/images/icons/apple-touch-icon-144x144.png">
  <link rel="apple-touch-icon" sizes="60x60" href="/images/icons/apple-touch-icon-60x60.png">
  <link rel="apple-touch-icon" sizes="120x120" href="/images/icons/apple-touch-icon-120x120.png">
  <link rel="apple-touch-icon" sizes="76x76" href="/images/icons/apple-touch-icon-76x76.png">
  <link rel="apple-touch-icon" sizes="152x152" href="/images/icons/apple-touch-icon-152x152.png">
  <link rel="apple-touch-icon" sizes="180x180" href="/images/icons/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="/images/icons/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="192x192" href="/images/icons/android-chrome-192x192.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/images/icons/favicon-16x16.png">
  <link rel="manifest" href="/images/icons/manifest.json">
  <link rel="mask-icon" href="/images/icons/safari-pinned-tab.svg" color="#5bbad5">
  <link rel="shortcut icon" href="/images/icons/favicon.ico">

  <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
  <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.4.5/jquery-ui-timepicker-addon.min.css" />
  {if $Modernjs}
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/bootstrap.daterangepicker/1.3.5/daterangepicker-bs3.css">
    <link rel="stylesheet" href="../third_party/js/bootstrap-sortable/bootstrap-sortable.css">
  {/if}
    <script>
      var theme = "{$Settings->theme}";
    </script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.4.5/jquery-ui-timepicker-addon.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.4.5/i18n/jquery-ui-timepicker-ru.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/moment.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/locale/ru.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment-range/2.2.0/moment-range.min.js"></script>

  {if $DeliveryAgent}
    {literal}
    <style>.off { padding: 6px 4px 6px 4px; font-size: 13px; }
      .on { padding: 6px 4px 6px 4px; font-size: 13px; }
      #inserts li { padding-right: 2px; }
    </style>
    {/literal}
  {/if}

</head>
<body>

<a href='/' class="bookmark"><img  title='Перейти на сайт' alt='Перейти на сайт' border=0 src='images/bookmark.gif'></a>
<div id="page">
  <!-- Icons #Begin /-->
  <div class="container" id="icon">
    {if $allowed_admin || $allowed_moderator || $allowed_accountant || $allowed_manager || $allowed_copywriter}
    <table id="table" style="width:auto!important;">
      <tr>
      {if $allowed_admin || $allowed_accountant || $allowed_copywriter || $allowed_manager}
      <td><a href="/admin/index.php{if $allowed_accountant || $allowed_manager}?section=MainPage{/if}"><img  src="./images/icon_main.jpg" alt="Главная" />Главная</a></td>
      {if in_array('Sections', $user_allowed) || in_array('NewsLine', $user_allowed) || in_array('Articles', $user_allowed) || in_array('Specials', $user_allowed) || in_array('Swd', $user_allowed) || in_array('SaleSettings', $user_allowed) || in_array('Sections', $Faqs)}
      <td><a href="/admin/index.php?section=Sections"><img src="./images/icon_content.jpg" alt="Cтраницы" />Cтраницы</a></td>
      {/if}

      {if in_array('Storefront', $user_allowed) || in_array('Categories', $user_allowed) || in_array('Brands', $user_allowed) || in_array('Colors', $user_allowed) || in_array('Goods', $user_allowed)}
      <td><a href="/admin/index.php?section=Storefront"><img src="./images/icon_products.jpg" alt="Товары" />Товары</a></td>
      {/if}

      {if in_array('Orders', $user_allowed)}
      <td><a href="/admin/index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}"><img src="./images/icon_orders.jpg" alt="Заказы" />Заказы</a></td>
      {/if}

      {if (in_array('Users', $user_allowed) || in_array('Groups', $user_allowed) || in_array('Calls', $user_allowed) || in_array('Coupons', $user_allowed)) && !$allowed_copywriter}
      <td><a href="/admin/index.php?section=Users"><img src="./images/icon_users.jpg" alt="Пользователи" />Пользователи</a></td>
      {/if}

      {if ($allowed_admin && (in_array('Users', $user_allowed) || in_array('Oneclick', $user_allowed))) || $allowed_copywriter}
      <td><a href="/admin/index.php?section=Users&email"><img src="./images/icon_email.jpg" alt="Рассылки" />Рассылки</a></td>
      {/if}

      {if in_array('Oneclick', $user_allowed)}
      <td><a href="/admin/index.php?section=Oneclick"><img src="./images/icon_comments.jpg" alt="Заявки" />Заявки</a></td>
      {/if}

      {if in_array('Analytics', $user_allowed)}
      <td><a href="/admin/index.php?section=Analytics"><img src="./images/icon_auto.jpg" alt="Аналитика продаж" />Аналитика продаж</a></td>
      {/if}

      {if in_array('Import', $user_allowed) || in_array('Export', $user_allowed) || in_array('Backup', $user_allowed)}
      <td><a href="/admin/index.php?section=Import"><img src="./images/icon_import.jpg" alt="Импорты" />Импорты</a></td>
      {/if}

      {if in_array('Setup', $user_allowed) || in_array('Currency', $user_allowed) || in_array('DeliveryMethods', $user_allowed) || in_array('PaymentMethods', $user_allowed)}
      <td><a href="/admin/index.php?section={if $smarty.session.user->user_id == 12625 || $smarty.session.user->user_id == 13556}PaymentMethods{else}Setup{/if}"><img src="./images/icon_setup.jpg" alt="Настройки"/>Настройки</a></td>
      {/if}
      {else}
      {if in_array('Calls', $user_allowed)}
      <td><a href="/admin/index.php?section=Calls"><img src="./images/icon_users.jpg" alt="Пользователи" />Пользователи</a></td>
      {/if}
      {if in_array('Orders', $user_allowed)}
      <td><a href="/admin/index.php?section={if $allowed_accountant}Aorders{else}Orders{/if}"><img src="./images/icon_orders.jpg" alt="Заказы" />Заказы</a></td>
      {/if}
      <td width="90%"> </td>
      {/if}
      {if in_array('Statistics', $user_allowed)}
      <td><a href="/admin/index.php?section=Statistics&brands=1"><img src="./images/icon_stat.png" alt="Сводки" />Сводки</a></td>
      {/if}
      </tr>
    </table>
    {/if}
  </div>
    <!-- Icons #End /-->

    {$Body}

    {if !$Modernjs}
    <!-- Footer #Begin /-->
    <div id="footer">
      <div id="footer_right">
        <img src="./images/logout.jpg" alt="" class="flx"/><a href="/logout" class="fl">Выход</a>
      </div>
    </div>
    <!-- Footer #End /-->
    {/if}


</div>

  <!--JS goes here-->
  {if $Modernjs}
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
		<script src="//cdn.ckeditor.com/4.9.1/standard/ckeditor.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.3.0/handlebars.min.js"></script>
    <script src="../third_party/js/bootstrap_daterangepicker/daterange.min.js"></script>
    <script src="../third_party/js/bootstrap-sortable/bootstrap-sortable.js"></script>
    {$JavaScript}
  {/if}
</body>
</html>
