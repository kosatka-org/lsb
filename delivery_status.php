<?php
	$trac = simplexml_load_file('http://www.cpcr.ru/cgi-bin/postxml.pl?Monitoring&InvoiceNumber=' . $_GET['InvoiceNumber']);
	$res  = '';
	if ( !empty($trac->InvoiceInfo->PlanningPost->MarshDateTime) ) {
		$res .= 'Планируемая отправка: ' 	. date('Y-m-d H:i', strtotime($trac->InvoiceInfo->PlanningPost->MarshDateTime)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->RealPost->MarshDateTime) ) {
		$res .= 'Реальная отправка: ' 		. date('Y-m-d H:i', strtotime($trac->InvoiceInfo->RealPost->MarshDateTime)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->RecvPoint->DT) ) {
		$res .= "Доставка до города {$trac->InvoiceInfo->RecvPoint->Point}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->RecvPoint->DT)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Delivery->DT) && !empty($trac->InvoiceInfo->Delivery->Point) ) {
		$res .= "Вручение в городе {$trac->InvoiceInfo->Delivery->Point}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Delivery->DT)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Undelivery->Undelivery_reason) ) {
		$res .= "{$trac->InvoiceInfo->Undelivery->Undelivery_reason}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Undelivery->Delivery_Date)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Undelivery[1]->Undelivery_reason) ) {
		$res .= "{$trac->InvoiceInfo->Undelivery[1]->Undelivery_reason}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Undelivery[1]->Delivery_Date)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Undelivery[2]->Undelivery_reason) ) {
		$res .= "{$trac->InvoiceInfo->Undelivery[2]->Undelivery_reason}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Undelivery[2]->Delivery_Date)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Undelivery[3]->Undelivery_reason) ) {
		$res .= "{$trac->InvoiceInfo->Undelivery[3]->Undelivery_reason}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Undelivery[3]->Delivery_Date)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Undelivery[4]->Undelivery_reason) ) {
		$res .= "{$trac->InvoiceInfo->Undelivery[4]->Undelivery_reason}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Undelivery[4]->Delivery_Date)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Undelivery[5]->Undelivery_reason) ) {
		$res .= "{$trac->InvoiceInfo->Undelivery[5]->Undelivery_reason}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Undelivery[5]->Delivery_Date)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Undelivery[6]->Undelivery_reason) ) {
		$res .= "{$trac->InvoiceInfo->Undelivery[6]->Undelivery_reason}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Undelivery[6]->Delivery_Date)) . '<br>';
	}
	if ( !empty($trac->InvoiceInfo->Delivery->Delivery_Date) && !empty($trac->InvoiceInfo->Delivery->Recipient_FIO) ) {
		$res .= "{$trac->InvoiceInfo->Delivery->Recipient_FIO}: " . date('Y-m-d H:i', strtotime($trac->InvoiceInfo->Delivery->DT)) . '<br>';
	}
	echo !empty($res) ? '<span style="font-size: 10px;">' . $res . '</span>' : 'Пока нет информации по доставке';