<div class="ShAA_RobotoFont">
{if $city}
    <div style="margin: 0 auto;">
        <h1 style=""><strong>{$city->name}</strong></h1>
        <div class="ShAA_cityPageMainText">
            {$city->text}
        </div>
        <div class="ShAA_cityPageStrongBlock">
            <b>Контакты транспортных компаний - партнеров "Лакшери Стор" на территории города {$city->name}:</b>
        </div>
        <div class="ShAA_cityPageShippInfo">
            <div class="ShAA_cpLeftBlock">
                {if !empty($city->map_url)}
                    <p style="margin: 12px -24px;">{$city->map_url}</p>
                {/if}
                
                {if $delivery_methods}   
                <div class="ShAA_cpTextUnderMap">
                    <h1 style="margin-left: 0; display: none;"><b>Доставка</b></h1>
                    {foreach item=dm from=$delivery_methods}
                    <div class="">
                        <strong>{$dm->name}</strong><br>
                        {$dm->description}
                    </div>
                    {/foreach}
                </div>
                {/if}

                {if $payment_methods}    
                <div class="ShAA_cpTextUnderMap">
                    <h1 style="margin-left: 0; display: none;"><b>Оплата</b></h1>
                    {foreach item=pm from=$payment_methods}
                    <div class=""><strong>{$pm->name}</strong><br>
                        {$pm->description}
                    </div>
                    <div class="delclear"></div>
                    {/foreach}
                </div>
                {/if}
        
            </div>
            <div class="ShAA_cpRightBlock">
                {$city->text2}
            </div>
        </div>
        
    </div>
    <div style="clear: both;"></div>
{else}
    {if $cities}
        {foreach item=c from=$cities}
            <div style="font-weight: normal; margin: 26px 0;"><a href="/city/{$c->url}">{$c->name}</a></div>
            {$c->text}
        {/foreach}
    {/if}

    {literal}
    <div class="delivery left">
      <h1><strong>Доставка</strong></h1>
        <div class="delpic left"><img src="/files/deliveries/1.png"></div>
      <div class="deltext right"><strong>Бесплатная доставка</strong><br>
      <p>Бесплатная доставка осуществляется в любой регион России <b>при заказе</b> товара на сумму <b>более 10000 рублей.</b> При заказе в дальние регионы из за высокой стоимости доставки магазин можеи попросить вас сделать предоплату стоимости доставки. Сумма предоплаты доставки отображается в накладной и учитевается при получении заказа.</p></div>
      <div class="delclear"></div>
        <div class="delpic left"><img src="/files/deliveries/3.png"></div>
      <div class="deltext right"><strong>Доставка СПСР Экспресс по России</strong><br>
      <p>Стоимость доставки определяется в соответствии с тарифами СПСР и зависит от веса, стоимости товара и места назначения. Вы можете воспользоваться <a target="_blank" href="http://www.spsr.ru/ru/service/calculator"><b>калькулятором на сайте компании СПСР</b></a>, чтобы рассчитать стоимость доставки из Нижнего Новгорода в ваш город.</p></div>
      <div class="delclear"></div>
        <div class="delpic left"><img src="/files/deliveries/10.png"></div>
      <div class="deltext right"><strong>Курьерская доставка до Москвы</strong><br>
      <p>Курьерская доставка до Москвы и Московской области осуществляется на следующий день после оформления заказа, если товар есть в наличии и оформлен до 12.00.&nbsp;</p></div>
      <div class="delclear"></div>
      </div>
      <div class="delivery right">
      <h1><strong>Оплата</strong></h1>
        <div class="delpic left"></div>
      <div class="deltext right"><strong>Оплата наличными курьеру</strong><br>
      <p><a class="links" target="_blank" title="СПСР" href="http://www.spsr.ru/"><span>Наличными по факту получения товара, то есть оплата производится наличными курьеру службы доставки на основании приложенного чека (доставка СПСР).</span></a></p></div>
      <div class="delclear"></div>
        <div class="delpic left"><img src="/files/payments/13.png"></div>
      <div class="deltext right"><strong>Пластиковыми картами Visa или Master Card</strong><br>
      <p><a class="links" target="_blank" title="RBK описание услуги" href="http://www.rbkmoney.ru/ru/internet-magazinam"><span>Оплата картами VISA, Master Card. Гарантии безопасности платежных данных от провайдера интернет-платежей "РБК деньги".</span></a></p></div>
      <div class="delclear"></div>
        <div class="delpic left"></div>
      <div class="deltext right"><strong>Оплата СБЕРКАРТОЙ</strong><br>
      <p>Перевод на сберкарту номер 639002429005935691 в комментарий к платежу укажите номер заказа.&nbsp;Улуга для пользователей системы Сбербанк on-line.</p></div>
      <div class="delclear"></div>
      </div>
  {/literal}
 
{/if}
<div style="margin: 24px auto;">
    
    <div class="ShAA_citiesGrayBlock" style="width: 42%; float: left;"><h1>Реквизиты магазина</h1><div style="margin-left:0px;">
        - Платежи принимают и несут полную ответственность в соответствии с гражданским кодексом РФ<br>
        Юридические лица: </br>
        ИП Жехарев Илья Всеволодович<br>
        ИНН 526003230948<br>
        р/с 40802810100454794590 Нижегородский Филиал<br>
        ЗАО ЮНИКРЕДИТ БАНК г. Нижний Новгород<br>
        к/с 30101810500000000799<br>
        БИК 042202799<br>
        ОГРНИП 313526022800012<br>
        Юридический и фактический Адрес 603002 г. Нижний Новгород, Нижневолжская наб. 8/7 </br></br>
        ИП Жехарев Всеволод Николаевич </br>
        ИНН 525709427782</br>
        р/с  40802810910500001727</br>
        ОГРНИП 315526000003522</br>
        Филиал №6318 ВТБ 24 (ПАО) г. Самара</br>
        к/с 30101810700000000955</br>
        БИК 043602955</br>
        Адрес: г. Нижний Новгород ул.Нижне-Волжская набережная 8/7-8 </br></br>
        ИП Жехарева Елена Николаевна</br>
        ИНН 526015264740</br>
        р/с  40802810410500004509</br>
        ОГРНИП 304526016000127</br>
        Филиал №6318 ВТБ 24 (ПАО) г. Самара</br>
        к/с 30101810700000000955</br>
        БИК 043602955</br>
        Адрес: г. Нижний Новгород ул Нижневолжская набережная 8/7</br></br>
        ИП Жехарев Евгений Всеволодович</br>
        ИНН 526054606726</br>
        р/с  40802810110500017951</br>
        Филиал №6318 ВТБ 24 (ПАО) г. Самара</br>
        к/с 30101810700000000955</br>
        БИК 043602955</br>
        Адрес: г. Нижний Новгород ул. Н.Новгород, М.Горького 77-113
    </div></div>

    <div class="ShAA_citiesGrayBlock" style="width: 42%; float: right;"><h1><strong>Возврат и обмен товара</strong></h1> Осуществляется согласно ст.21 закона РФ «О защите прав потребителей» в течении 30 дней с момента продажы покупатель вправе:<br><ol><li> Заменить товар ненадлежащего качества на товар аналогичной марки (модели, артикула) или на такой товар другой марки (модели, артикула) с соответствующим перерасчетом покупной цены.<div style="clear: both; height: 20px;"></div></li><li> Покупатель в праве отказаться от исполнения договора и потребовать возврата уплаченной за товар суммы. - В случае оплаты наличными возвращается полная стоимость товара по наличному расчёту соответственно. - В случае оплаты посредством пластиковой карты полная стоимость товара перечисляется на банковский счёт.</li></ol><br> - Замена товара и возврат средств производится на основании чека. Чек доставляется вместе с товаром.<br> Проверьте наличие чека в момент получения товара.</div>
    <div style="clear: both; height: 30px;"></div>
</div>
</div>