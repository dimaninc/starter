<?php
$cfg = new \diCore\Data\Configuration();
$cfg->setTabsAr([
	'general' => 'General',
	'pics' => 'Pics',
	'counts' => 'Counts',
])->setInitialData([
	'auto_save_timeout' => [
		'title' => 'Auto-save timeout, sec',
		'type' => 'int',
		'value' => 0,
		'notes' => [
			'Auto-save works in every Admin form. If 0 then auto-save feature is off',
		],
	],

	'admin_per_page[admins]' => [
		'title' => 'Admins per page (in Admin)',
		'type' => 'int',
		'value' => 30,
		'tab' => 'counts',
	],

	'admin_per_page[mail_queue]' => [
		'title' => 'Mail queue records per page (in Admin)',
		'type' => 'int',
		'value' => 30,
		'tab' => 'counts',
	],

	'sender_email' => [
		'title' => 'E-mail for outgoing mail',
		'type' => 'string',
		'value' => 'noreply@' . \diCore\Data\Config::getMainDomain(),
		'tab' => 'general',
	],
])->loadCache();
