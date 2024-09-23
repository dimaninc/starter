<?php
/**
 * Created by [%CREATOR%].
 * User: [%USER%]
 * Date: [%DATE%]
 * Time: [%TIME%]
 */

namespace NewProject\Admin;

class Base extends \diCore\Admin\Base
{
    protected $wysiwygVendor = \diCore\Admin\Form::wysiwygTinyMCE;
    protected $language = 'ru';

    protected function getStartModuleByAdminLevel($level)
    {
        switch ($level) {
            case 'root':
                return 'content';

            default:
                return null;
        }
    }

    protected function getAdminMenuMainTree()
    {
        return [
            'Страницы' => $this->getAdminMenuRow('content', [
                'permissions' => ['root'],
            ]),
        ];
    }
}
