<?php session_start(); include_once $_SERVER['DOCUMENT_ROOT'] . '/models/user.php';
$user = new luser; ?>
function CreateTooltip() {
    container = document.createElement('div');
    container.classList.add('adminTabs_container');
    container.setAttribute('style', 'display: block;  width: 90%;   padding: 0 5% 0 5%; top: 0px; z-index: 1000;');
    document.body.insertBefore(container, document.body.firstChild);

    label = document.createElement('img');
    label.id = 'adminTabs_label';
    label.src = '/js/admintooltip/i/bookmark.gif';
    label.style.cssText = "position: absolute; left: 10px; top: 0px; z-index: 1000;";
    label.setAttribute('style', 'position: absolute; left: 10px; top: 0px; z-index: 1000;');

    
    
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
<?php   if ( $user->is_allowed_bookmark('2') ) { ?>
    adminpanel.innerHTML = "<a href='/admin/index.php?section=Orders'>админка</a>";
<?php   } ?>
<?php   if ( $user->is_allowed_bookmark('3') ) { ?>
    adminpanel.innerHTML = "<a href='/admin/index.php?section=Aorders'>админка</a>";
<?php   } ?>
<?php   if ( $user->is_allowed_bookmark('4') ) { ?>
    adminpanel.innerHTML = "<a href='/admin/index.php?section=Calls'>админка</a>";
<?php   } ?>
<?php   if ( $user->is_allowed_bookmark('5')) { ?>
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&storeroom'>личный кабинет</a>";
<?php   } ?>
<?php   if ( $user->is_allowed_bookmark('1')) { ?>
    adminpanel.innerHTML = "<a href='/admin/index.php'>админка</a>";
<?php   } ?>
    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);

<?php if ( $user->is_allowed_bookmark(6)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 35px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/cart/error_message/' target='_blank' id='error_message'>ошибка</a>";
    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php } ?>
<?php if ( $user->is_allowed_bookmark(7) ) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 60px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/cart/client_add/' target='_blank' id='client_add_link'>о клиенте</a>";
    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php } ?>


<?php   if (($user->is_allowed_bookmark(9)) && !($user->is_allowed('offline_manager'))) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 110px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales'>кассир</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if ($user->is_allowed_bookmark(10) && !$user->is_allowed('hostess')) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 135px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&movement_list=1'>перемещения</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if ($user->is_allowed_bookmark(11) && !in_array($_SESSION['user']->user_id, array(12526))) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 160px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&movement_list=1&reservation=1'>отложка</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if (($user->is_allowed_bookmark(12)) && !($user->is_allowed('offline_manager'))) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 185px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&debts=1<?php if ($_SESSION['user']->user_id == 132165) { ?>&cashbox=15<?php } ?>'>задолженности</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if (($user->is_allowed_bookmark(13)) && !($user->is_allowed('offline_manager'))) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 210px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&returns=1'>возвраты</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if ($user->is_allowed_bookmark(14)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 235px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&mtm=1'>пошив</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>


<?php   if ($user->is_allowed_bookmark(15)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 260px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&calls=1'>обзвоны</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if ($user->is_allowed_bookmark(16)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 285px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=Service&service_list=1'>услуги</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if ($user->is_allowed_bookmark(17) && !$user->is_allowed('sr_manager')) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 305px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=Premoderation'>первичка</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>


<?php   if ($user->is_allowed_bookmark(18)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 330px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&manager_orders=1'>продажи</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>


<?php   if ($user->is_allowed_bookmark(19)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 355px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&sklad=1'>склад</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if ($user->is_allowed_bookmark(20)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 380px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&cash_report=1'>кассы</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>

<?php   if ($user->is_allowed_bookmark(22)) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;";
    adminpanel.setAttribute('style', ' left: 405px; top: 0px; z-index: 1000; float: left; margin: 6px 12px;');
    adminpanel.innerHTML = "<a href='/index.php?module=OfflineSales&payments=1'>оплаты</a>";

    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>
<!--
<?php   if ($user->is_allowed('sum')) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000;";
    adminpanel.setAttribute('style', ' left: 285px; top: 0px; z-index: 1000;');
    adminpanel.innerHTML = "<a href=''><img  title='Заказ услуг' alt='Заказ услуг' border=0 src='/js/admintooltip/i/snot_sum.png'></a>";
    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
<?php   } ?>
<?php   if ($user->is_allowed('inkass')) { ?>
    adminpanel = document.createElement('div');
    adminpanel.classList.add('ShAA_adminTabs');
    adminpanel.style.cssText = " left: 10px; top: 0px; z-index: 1000;";
    adminpanel.setAttribute('style', ' left: 310px; top: 0px; z-index: 1000;');
    adminpanel.innerHTML = "<a href=''><img  title='Заказ услуг' alt='Заказ услуг' border=0 src='/js/admintooltip/i/snot_inkass.png'></a>";
    document.getElementsByClassName('adminTabs_container')[0].appendChild(adminpanel);
    $(document).ready(function(){
        $('#adminTabs_label').mouseover(function(){
            $('.adminTabs_container').stop().slideToggle(200);
            $(this).stop().slideToggle(100);
        });
        $('.adminTabs_container').mouseleave(function(){
            $('#adminTabs_label').stop().slideToggle(100);
            $(this).stop().slideToggle(200);
        });
    });
<?php   } ?>
-->
}

CreateTooltip();