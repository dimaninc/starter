<?php
// cfg.common
// (q) by dimaninc

require \diPaths::fileSystem() . '/../vendor/autoload.php';

date_default_timezone_set('Etc/GMT-3');

\diLib::registerNamespace([
	'NewProject',
]);

// -[ mysql stuff ]-----------------------------------------------------------------
switch (\diCore\Base\CMS::getEnvironment())
{
	case \diCore\Base\CMS::ENV_DEV:
		\diCore\Database\Connection::open([
			'host' => 'localhost',
			'login' => 'root',
			'password' => '',
			'database' => 'dev_dbname',
		]);
		break;

	case \diCore\Base\CMS::ENV_STAGE:
		\diCore\Database\Connection::open([
			'host' => 'localhost',
			'login' => 'root',
			'password' => '',
			'database' => 'stage_dbname',
		]);
		break;

	default:
		\diCore\Database\Connection::open([
			'host' => 'localhost',
			'login' => 'root',
			'password' => '',
			'database' => 'prod_dbname',
		]);
		break;
}

$db = \diCore\Database\Connection::get()->getDb();
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
