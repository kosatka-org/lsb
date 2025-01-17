<div class="menu_wrap">
	<div class="menu">
		{if $smarty.session.user}
			<div class="user_field">
			<div class="user_field_image">
				{if $smarty.session.user->photo}
					<img src="{$smarty.session.user->photo}">
				{else}
					<img src="/images/empty_photo.png">
				{/if}
			</div>
				<div class="user_field_info">
					<div class="centered_text normal_text">
						{$smarty.session.user->name}
					</div>
					<div class="centered_text user_info_text2">
						Карта № {$smarty.session.user->card_number}, скидка от {$smarty.session.group->discount|string_format:"%.0f"}%
					</div>
				</div>
			</div>
			<div class="divider" style="margin: 0;"></div>
			<a href="/logout/">
				<div class="button button560px_black button_text_white">
					Выйти
				</div>
			</a>
		{else}
			<a href="/index.php?module=Cart&vk_auth" onclick="{literal}rG('LOGIN_FROM_MOBILE');{/literal}" title="Войдите на сайт и получите скидку" alt="">
				<div class="button button560px_black button_text_white">
					Войти
				</div>
			</a>
		{/if}
<!--		<div class="divider" style="margin: 0;"></div>
		<a href="/?show_token" title="" alt="">
			<div class="button button560px_black button_text_white">
				Show token
			</div>
		</a>-->
		<div class="divider" style="margin: 0;"></div>
		<a href="/categories/одежда/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Одежда
			</div>
		</a>
		<a href="/categories/обувь/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Обувь
			</div>
		</a>
		<a href="/categories/сумки/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Сумки
			</div>
		</a>
		<a href="/categories/аксессуары/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Аксессуары
			</div>
		</a>
		<div class="divider" style="margin: 0;"></div>
		<a href="/sale" title="" alt="">
			<div class="button button560px_black button_text_white">
				Outlet
			</div>
		</a>
		<a href="/brandwall/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Бренды
			</div>
		</a>
		<div class="divider" style="margin: 0;"></div>
		<a href="/sections/mobile_delivery/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Доставка
			</div>
		</a>
		<a href="/sections/mobile_payment/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Оплата
			</div>
		</a>
		<a href="/sections/mobile_faq/" title="" alt="">
			<div class="button button560px_black button_text_white">
				Вопросы
			</div>
		</a>
		<div class="divider" style="margin: 0;"></div>
		<a href="/catalog/?enter_mobile={if $smarty.cookies.sex == 2}1{else}2{/if}" title="" alt="">
			<div class="button button560px_black button_text_white">
				Перейти в {if $smarty.cookies.sex == 2}мужской{else}женский{/if} каталог
			</div>
		</a>
	</div>
</div>