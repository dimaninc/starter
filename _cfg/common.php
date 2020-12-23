<?php
// cfg.common
// (q) by dimaninc

use diCore\Base\CMS;
use diCore\Database\Connection;

require \diPaths::fileSystem() . '/../vendor/autoload.php';

date_default_timezone_set('Etc/GMT-3');

\diLib::registerNamespace([
	'NewProject',
]);

// -[ mysql stuff ]-----------------------------------------------------------------
switch (CMS::getEnvironment())
{
	case CMS::ENV_DEV:
        Connection::open(Connection::localMysqlConnData('[%FOLDER%]'));
		break;

	case CMS::ENV_STAGE:
		Connection::open([
			'host' => 'localhost',
			'login' => 'root',
			'password' => '',
			'database' => 'stage_dbname',
		]);
		break;

	default:
		Connection::open([
			'host' => 'localhost',
			'login' => 'root',
			'password' => '',
			'database' => 'prod_dbname',
		]);
		break;
}

$db = Connection::get()->getDb();
//$db->enableDebug();

// -[ filesystem stuff ]------------------------------------------------------------
$tmp_folder = 'uploads/tmp/';
$dynamic_pics_folder = 'uploads/dynamic_pics/';
$ads_pics_folder = 'uploads/home_module/';
$orig_folder = 'orig/';
$big_folder = 'big/';
$pics_folder = 'pics/';
$files_folder = 'files/';
$tn_folder = 'preview/';
$tn2_folder = 'preview2/';
$tn3_folder = 'preview3/';
$hires_folder = 'hi/';
$lores_folder = 'lo/';
$db_dump_path = '_admin/db/dump/';

include 'configuration.php';
