<?php

declare(strict_types=1);

namespace Tests\Support\Helper;

// here you can define custom actions
// all public methods declared in helper class will be available in $I

use Codeception\Module\WebDriver;

class HandleCookie extends \Codeception\Module
{
    public function denyCookies()
    {
        /** @var WebDriver $webDriver */
        $webDriver = $this->getModule('WebDriver');
        $element = $webDriver->_findElements(['id' => 'usercentrics-root'])[0];
        codecept_debug($element);
    }
}
