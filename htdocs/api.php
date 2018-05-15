<?php
require '../vendor/dimaninc/di_core/php/functions.php';
require '../_cfg/common.php';

try {
	$beginning = preg_replace('#^(/_core/php/(admin/)?workers/|' . \diCore\Data\Config::getApiQueryPrefix() . ').*$#', '\1', \diRequest::requestUri());

	\diBaseController::autoCreate([
		'pathBeginning' => $beginning,
	]);
} catch (Exception $e) {
	\diBaseController::autoError($e);
}
