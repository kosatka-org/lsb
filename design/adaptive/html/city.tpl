<div class="ShAA_RobotoFont">
{if $city}
    <div style="margin: 0 auto;">
        <h1><span style="float: left;">{$city->name}</span> <span class="ShAA_citySelectLink"><a rel="nofollow" href="/citiesselect/" id="city_link">Выберите другой город</a></span></h1>
        <div class="ShAA_cityPageMainText">
            <div class="ShAA_cpLeftBlock">
                {$city->text}
            </div>
        </div>
        <div class="ShAA_cityPageStrongBlock">
            <div class="ShAA_cpLeftBlock">
                <h1>{$city->name}: пункты самовывоза</h1>
            </div>
        </div>
        <div class="ShAA_cityPageShippInfo">
            <div class="ShAA_cpLeftBlock">
                {if !empty($city->map_url)}
                    <p style="margin: 12px 0;">{$city->map_url}</p>
                {/if}
                <div class="ShAA_cpTextUnderMap">
                    {$city->text2}
                </div>
                {if $payment_methods}
                <div class="ShAA_cpTextUnderMap">
                    <h1 style="margin-left: 0; display: none;"><b>Оплата</b></h1>
                    {foreach item=pm from=$payment_methods}
                    <div class=""><strong>{$pm->name}</strong>
                        {$pm->description}
                    </div>
                    <div class="delclear"></div>
                    {/foreach}
                </div>
                {/if}

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
      <p>Стоимость доставки определяется в соответствии с тарифами СПСР и зависит от веса, стоимости товара и места назначения. Вы можете воспользоваться <a target="_blank" href="http://www.spsr.ru/ru/service/calculator" rel="nofollow"><b>калькулятором на сайте компании СПСР</b></a>, чтобы рассчитать стоимость доставки из Нижнего Новгорода в ваш город.</p></div>
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
      <p><a class="links" target="_blank" title="СПСР" href="http://www.spsr.ru/" rel="nofollow"><span>Наличными по факту получения товара, то есть оплата производится наличными курьеру службы доставки на основании приложенного чека (доставка СПСР).</span></a></p></div>
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
    <div class="ShAA_cpLeftBlock">
        <div class="ShAA_staticPageDetails">
            <h1>Реквизиты магазина</h1>
            <div style="margin-left:0px;margin-bottom: 12px;">
                - Платежи принимают и несут полную ответственность в соответствии с гражданским кодексом РФ<br>
                Юридические лица: </br></br>
                ИП Жехарев Евгений Всеволодович<br>
                ИНН 526054606726</br>
                Свидетельство серия 52 №004487014 от 25.08.2010г.</br>
                ОГРНИП 310526023700014</br>
                Р/с  40802810110500017951</br>
                Филиал №6318 ВТБ (ПАО) г. Самара</br>
                к/с 30101810422023601968</br>
                БИК 043601968</br>
                Адрес: 603000 г. Нижний Новгород, ул.М.Горького, д.77, кв.113 </br>
                Директор — Жехарев Евгений Всеволодович
            </div>
            <div style="margin-left:0px;">
                ИП Жехарева Елена Николаевна</br>
                ИНН 526015264740</br>
                Свидетельство серия 52 №002989298 от 05.07.1999г.</br>
                ОГРНИП 304526016000127</br>
                р/с  40802810410500004509</br>
                Филиал №6318 ВТБ (ПАО) г. Самара</br>
                к/с 30101810422023601968</br>
                БИК 043601968</br>
                Адрес: 603001 г. Нижний Новгород, ул. Нижне-Волжская набережная, д.8/7, кв.5</br>
                Директор - Жехарева Елена Николаевна
            </div>
        </div>
        <div class="ShAA_staticPageChange">
            <h1>Возврат и обмен товара</h1>
            Осуществляется согласно ст.21 закона РФ «О защите прав потребителей» в течение 30 дней с момента продажи покупатель вправе:<br>
                <ol>
                    <li>Заменить товар ненадлежащего качества на товар аналогичной марки (модели, артикула) или на такой товар другой марки (модели, артикула) с соответствующим перерасчетом покупной цены.<div style="clear: both; height: 20px;"></div></li>
                    <li> Покупатель в праве отказаться от исполнения договора и потребовать возврата уплаченной за товар суммы. - В случае оплаты наличными возвращается полная стоимость товара по наличному расчёту соответственно. - В случае оплаты посредством пластиковой карты полная стоимость товара перечисляется на банковский счёт.</li>
                </ol>
                <br> - Замена товара и возврат средств производится на основании чека. Чек доставляется вместе с товаром.<br> Проверьте наличие чека в момент получения товара.
                <br><br>По вопросам возврата звоните <a href="tel:89276910611">8 (927) 691-06-11</a><br>Или заполните <a href="/return.doc" style="border-bottom: 1px solid #000;">заявление на возврат</a> и отправьте на почту <a href="mailto:vozvrat@{$serverName}">vozvrat@{$serverName}</a>
        </div>
        <div style="clear: both; height: 30px;"></div>
    </div>
</div>
