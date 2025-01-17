{literal}<html>
<body style="margin:10px 0 0 0;" bgcolor="#ffffff" color="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<table width="686" align="center" border="0" cellpadding="0" cellspacing="0" style="font-size: 11px; line-height: 13pt; font-family: Tahoma, Helvetica;" rules="none">
		<tr height="142">
			<td><a href="{SITE}?utm_source=email&utm_medium=email&utm_campaign=email_email_logo" style="color: #787878; font-size: 18px; text-decoration: none; font-weight: bold;">
				<img alt="Luxury Store" src="{SITE}/email_img/logo.png" width="220" height="64" /></a></td>
			<td>
				<div style="float: right; padding: 16px 20px 0 0;">
					<div style="font-size: 10px;">По частным вопросам</div>
					<a href="mailto:{SUPPORT_EMAIL}" style="color: #787878; text-decoration: underline; font-weight: bold;">{SUPPORT_EMAIL}</a>
				</div>
			</td>
		</tr>
		<tr style="background: #f2f2f1;">
			<td colspan="2" style="color: #80807d; font-size: 18px; font-weight: bold; padding: 8px 12px; border-top: 1px solid #e8e8e6; border-bottom: 1px solid #e8e8e6;">{/literal}{$subject}{literal}</td>
		</tr>
		<tr>
			<td colspan="2" style="padding: 32px 12px 32px 12px;">
				<div style="color: #424243; font-size: 18px; font-weight: bold;">Здравствуйте, {USER_NAME}</div><br>
				<div>{/literal}
					{$message}
					{literal}С уважением, <span style="font-weight: bold;">{ORDER_MANAGER}</span>, Руководитель службы Вашей поддержки <a href="mailto:{ORDER_MANAGER_EMAIL}" style="color: #787878; text-decoration: underline; font-weight: bold;">{ORDER_MANAGER_EMAIL}</a>
				</div>
			</td>
		</tr>
		<tr style="background: #e0ded9;">
			<td style="padding: 10px 12px;">Справочная служба с готовностью даст ответ<br> круглосуточно, 24/7 звонок по России бесплатно </td>
			<td style="padding: 10px 0;">
				<img src="{SITE}/email_img/phone.png" width="17" height="16" style="vertical-align: middle;"/>
				<span style="font-size: 18px; vertical-align: bottom; line-height: 22px;">&nbsp;{ORDER_MANAGER_PHONE}&nbsp;</span>
				<a href="{CALL_BY_CLICK}" style="color: #787878; text-decoration: underline; font-weight: bold; vertical-align: bottom;">или с компьютера</a>
			</td>
		</tr>
		<tr>
			<td style="padding: 16px 0 0 0;">
				<a href="http://ru.lsboutique.ru/doctxt/diskont/?utm_source=email&utm_medium=email&utm_campaign=discount_10_percent" style="color: #787878; font-size: 18px; text-decoration: none; font-weight: bold;">
					<img alt="Скидка 10% на все новинки!" src="{SITE}/email_img/vk_discount.png" width="338" height="119"/></a>
			</td>
			<td style="padding: 16px 0 0 0;">
				<a href="{SITE}/sections/shipping?utm_source=email&utm_medium=email&utm_campaign=to_moscow" style="color: #787878; font-size: 18px; text-decoration: none; font-weight: bold;">
					<img alt="На Москву! За сутки!" src="{SITE}/email_img/to_moscow.png" width="338" height="119"/></a>
			</td>
		</tr>
		<tr>
			<td colspan="2" style="font-size: 10px; padding: 16px 12px;">
				Сообщение было отправлено на <a href="mailto:{USER_EMAIL}" style="color: #787878; text-decoration: underline;">{USER_EMAIL}</a>. 
				<!--Если Вы не хотите получать письма от <a href="{SITE}" style="color: #787878; text-decoration: none;">{SITE}</a>, пожалуйста, <a href="#" style="color: #787878; text-decoration: none; border-bottom: 1px solid #787878;">отпишитесь</a>-->
			</td>
		</tr>
		<tr>
			<td colspan="2" style="font-size: 10px; padding: 0px 12px 16px 12px; color: #787878;">&copy; Luxury Store {YEAR}</td>
		</tr>
	</table>
</html>{/literal}