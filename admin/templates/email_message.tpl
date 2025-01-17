<html>
<head>
	
</head>
<body style="margin:10px 0 0 0;" bgcolor="#ffffff" color="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<table width="686" align="center" border="0" cellpadding="0" cellspacing="0" style="font-size: 11px; font-family: Tahoma, Helvetica;" rules="none">
		<tr height="124"><td align="center"><a href="{$site}" style="color: #787878; font-size: 18px; text-decoration: none; font-weight: bold;"><img alt="Luxury Store" src="{$site}/email_img/logo.png" width="220" height="64" /></a></td>
		</tr>
		<tr style="background: #ffffff;">
			<td style="height: 9px; width: 100%;"></td>
		</tr>
		<tr>
			<td align="center" style="line-height: 41px; font-size: 41px; padding: 24px 0px;">
				<a target="_blank" style="color: #2b2b2b;font-family: Georgia,serif;font-size: 41px;letter-spacing: 2px;line-height: 41px;text-align: center;text-decoration: none;text-transform: uppercase;" href="{$site}/catalog/?category=new_season">{$subject}</a>
			</td>
		</tr>
		<tr>
			<td width="58%" align="center" valign="top" style="padding: 0 0 40px 0;font-family:Georgia,serif;color:#2b2b2b;font-size:16px;line-height:22px;text-decoration:none;text-align:center;">
				{$content}
			</td>
		</tr>
		<tr>
			<td bgcolor="#cccccc" style="height: 1px; width: 100%;"></td>
		</tr>
		<tr><td height="40" style="font-size:1px;line-height:1px"></td></tr>
	</table>
	<table cellspacing="0" cellpadding="0" border="0" width="100%" style="padding: 40px 0 0 0;background-color:#f0f0f0;">
		<tr>
			<td align="center" width="100%" valign="top">
				<table>
					<tr>
						<td width="30">
							<a title="Facebook" class="social fb" href="https://www.facebook.com/pages/Лакшери-Cтор/154801904576422">
								<img border="0" width="24" height="24" src="{$site}/images/social/FB_02.png" />
							</a>
						</td>
						<td width="30">
							<a title="В контакте" class="social vk" href="http://vk.com/lsboutiq">
								<img border="0" width="24" height="24" src="{$site}/images/social/BK_02.png" />
							</a>
						</td>
						<td width="30">
							<a title="Google+" class="social gplus" href="//plus.google.com/110520036601016657762?prsrc=3">
								<img border="0" width="24" height="24" src="{$site}/images/social/GPLS_02.png" />
							</a>
						</td>
						<td width="30">
							<a target="_blank" rel="nofollow" title="Odnoklassniki" class="social Odnoklassniki" href="http://www.odnoklassniki.ru/group/51999546998916">
								<img border="0" width="24" height="24" src="{$site}/images/social/SCHKL_02.png" />
							</a>
						</td>
						<td width="30">
							<a title="Instagram" class="social instagram" href="http://instagram.com/lsboutique_ru">
								<img border="0" width="24" height="24" src="{$site}/images/social/INSTA_02.png" />
							</a>
						</td>
						<td width="30">
							<a title="Twitter" class="social twitter" href="//twitter.com/lsboutique_ru">
								<img border="0" width="24" height="24" src="{$site}/images/social/TWEET_02.png" />
							</a>
						</td>
						<td width="30">
							<a title="RSS Feed" class="social rss_feed" href="{$site}/rss">
								<img border="0" width="24" height="24" src="{$site}/images/social/RSS_02.png" />
							</a>
						</td>
						<td width="30">
							<a title="Mail" class="social mail" href="http://my.mail.ru/community/lsboutique/">
								<img border="0" width="24" height="24" src="{$site}/images/social/MRU_02.png" />
							</a>
						</td>
						<td width="30">
							<a  title="Youtube" class="social ytub" href="https://lsboutique.ru/pass/{$user_phone}/{$user_card_number}/?output">
								<img border="0" width="24" height="24" src="{$site}/images/social/YTUB_02.png" />
							</a>
						</td>
					</tr>
					<tr><td height="25" style="font-size:1px;line-height:1px"></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="center" style="color: #2b2b2b;font-family: Georgia,serif;font-size: 14px;line-height: 28px;text-align: center;text-decoration: none;">
				<a href="mailto:{$order_manager_email}" style="color: #2b2b2b;font-size: 14px;line-height: 28px;text-decoration: none;">
					Это письмо было отправлено на <em>{$user_email}</em><br>
					Спасибо за Ваш интерес к интернет-магазину Лакшери Store.<br>
					Хорошего дня и хороших покупок!<br>
					С уважением, <span style="font-weight: bold;">{$order_manager}</span> - руководитель службы Вашей поддержки <em>{$order_manager_email}</em>
				</a><br><br>
					Для того, чтобы наши сообщения не попадали в спам, пожалуйста, добавьте <em>{$order_manager_email}</em> в адресную книгу.
			</td>
		</tr>
		<tr><td height="25" style="font-size:1px;line-height:1px"></td></tr>
		<tr>
			<td align="center" style="color: #999999;">&copy; Лакшери Store {'Y'|date}</td>
		</tr>
		<tr><td height="25" style="font-size:1px;line-height:1px"></td></tr>
	</table>
</body>
</html>