<?php
/**
 * Created by [%CREATOR%].
 * User: [%USER%]
 * Date: [%DATE%]
 * Time: [%TIME%]
 */

namespace NewProject\Helper;

use diCore\Data\Environment;

class MailTemplate
{
	public static function getBaseTemplateName($template)
	{
		$baseTemplate = true //$template == 'customer'
			? 'emails/_parts/html_base' // local
			: 'emails/email_html_base'; // core

		return $baseTemplate;
	}

	public static function getFullHtml(\diTwig $twig, $templateType, $body)
	{
		$baseTemplate = self::getBaseTemplateName($templateType);

		$domain = Environment::getMainDomain();
		$protocol = $domain == '[%FOLDER%]' ? 'http' : 'https';
		$fullDomain = $templateType == 'pdf'
			? '../../..'
			: $protocol . '://' . $domain;

		return $twig->parse($baseTemplate, [
			'body' => $body,
			'title' => 'NewProject',
			'assets_domain' => $fullDomain,
		]);
	}
}