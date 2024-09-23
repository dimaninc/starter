<?php
/**
 * Created by [%CREATOR%].
 * User: [%USER%]
 * Date: [%DATE%]
 * Time: [%TIME%]
 */

namespace NewProject\Module;

class Home extends \diModule
{
    public function render()
    {
        $this->getTwig()->renderPage('home/page');
    }
}
