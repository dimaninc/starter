<?php
/**
 * Created by [%CREATOR%].
 * User: [%USER%]
 * Date: [%DATE%]
 * Time: [%TIME%]
 */

namespace NewProject\Data;

class Config extends \diCore\Data\Config
{
	const siteTitle = '';
	const mainDomain = '[%DOMAIN%]';
	const apiQueryPrefix = '/api/';
	const mainLanguage = 'ru';
	const folderForAssets = 'assets/';

	protected static $location = \diLib::LOCATION_BEYOND;
}