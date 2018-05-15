<?php
/**
 * Created by [%CREATOR%].
 * User: [%USER%]
 * Date: [%DATE%]
 * Time: [%TIME%]
 */

namespace NewProject\Tool\Mail;

use diCore\Tool\Mail\Transport;

class Sender extends \diCore\Tool\Mail\Sender
{
	const defaultFromName = '[%DOMAIN%]';
	const defaultFromEmail = 'noreply@[%DOMAIN%]';

	const transport = Transport::SMTP;

	protected static $accounts = [
		'noreply@[%DOMAIN%]' => '***',
	];
}