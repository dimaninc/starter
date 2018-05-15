<?php
if (empty($_SERVER["DOCUMENT_ROOT"]))
{
	$_SERVER["DOCUMENT_ROOT"] = realpath(dirname(dirname(__FILE__)) . '/htdocs');
}

require $_SERVER['DOCUMENT_ROOT'] . '/../vendor/dimaninc/di_core/php/functions.php';

$info = \diRequest::convertFromCommandLine();

if (\diRequest::isCli())
{
	if (!$info)
	{
		$info = [
			'env' => 'prod',
		];
	}

	switch ($info['env'])
	{
		default:
		case 'prod':
			$_SERVER['DOCUMENT_ROOT'] = '/web/[%FOLDER%]/htdocs';
			$_SERVER['HTTP_HOST'] = '[%DOMAIN%]';
			$_SERVER['SERVER_PORT'] = 443;
			break;

		case 'stage':
			$_SERVER['DOCUMENT_ROOT'] = '/var/www/[%FOLDER%]/htdocs';
			$_SERVER['HTTP_HOST'] = '[%DOMAIN%]';
			$_SERVER['SERVER_PORT'] = 443;
			break;

		case 'dev':
			$_SERVER['DOCUMENT_ROOT'] = 'D:/OpenServer/domains/[%FOLDER%]/htdocs';
			$_SERVER['HTTP_HOST'] = '[%FOLDER%]';
			$_SERVER['SERVER_PORT'] = 80;
			break;
	}
}

require $_SERVER['DOCUMENT_ROOT'] . '/../_cfg/common.php';

\diCore\Controller\Cache::rebuildTemplateAndContentCache();
\diTwig::flushCache();
