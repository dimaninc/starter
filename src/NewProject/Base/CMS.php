<?php
/**
 * Created by [%CREATOR%].
 * User: [%USER%]
 * Date: [%DATE%]
 * Time: [%TIME%]
 */

namespace NewProject\Base;

class CMS extends \diCore\Base\CMS
{
	const MAIN_TEMPLATE_ENGINE = self::TEMPLATE_ENGINE_TWIG;

	protected $authUsed = false;

	public static $devDomains = [
		'[%FOLDER%]',
	];

	public static $stageDomains = [
		'[%DOMAIN%]',
	];

	static public $possibleLanguages = [
		'ru',
	];

	public static $defaultLanguage = 'ru';

	protected static $customSkipGetParams = [
	];

	public function go()
	{
		$this
			->start()
			->load_content_rec()
			->assignHtmlHead()
			->assign_ct_ar()
			->printAuthStuff()
			->printMainMenu()
			->initBreadCrumbs()
			->renderPage();
	}

	protected function renderAfterError()
	{
		//$this
		//	->printAuthStuff();

		return $this;
	}

	protected function getNeededSwitches()
	{
		return extend(parent::getNeededSwitches(), [
			'noindex' => $this->noIndexNeeded(),
		]);
	}

	protected function noIndexNeeded()
	{
		return true;
	}

	protected function shareBlockNeeded()
	{
		return false;
	}

	/**
	 * @return CMS
	 */
	protected function printAuthStuff()
	{
		/*
		if ($this->authUsed && diAuth::i()->authorized())
		{
			$this->printUserMenu();
		}
		*/

		/*
		parent::printAuthStuff();

		if ($this->authUsed)
		{
			$this->getAuth()->assignTwig($this->getTwig());
		}
		*/

		return $this;
	}

	/**
	 * @return CMS
	 */
	public function printMainMenu()
	{
		/*
		$this->getTwig()
			->assign([
				'top_menu' => array_filter($this->tables['content'], function(Model $m) {
					return $m->hasVisibleTop();
				}),
				'bottom_menu' => array_filter($this->tables['content'], function(Model $m) {
					return $m->hasVisibleBottom();
				}),
			]);
		*/

		return $this;
	}
}