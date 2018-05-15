<?php
error_reporting(E_ALL);

require '../../vendor/dimaninc/di_core/php/functions.php';
require '../../_cfg/common.php';

$X = new \NewProject\Admin\Base();
$X->work();
