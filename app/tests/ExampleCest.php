<?php


namespace Tests\Acceptance;

use Codeception\Attribute\Prepare;
use Codeception\Module\WebDriver;
use Tests\Support\AcceptanceTester;

class ExampleCest
{
    #[Prepare('grabShadowDom')]
    public function _before(AcceptanceTester $I): void
    {
        /*
        $I->retry(3, 300);


        $I->amOnPage('/');
        $I->makeScreenshot();

        $I->denyCookies();

        $I->retryClick('Ablehnen');
        $I->makeScreenshot();
        */
    }








    public function putProductIntoBasket(AcceptanceTester $I)
    {
        $I->amOnPage('/warenkorb/');
        $I->dontSee('Stoßdämpfer V-F');
        $I->makeScreenshot();

        $I->amOnPage('/Ersatzteile/Achsen-Federungen/Stossdaempfer-V-F.html');
        $I->click('In den Warenkorb');
        $I->makeScreenshot();

        $I->amOnPage('/warenkorb/');
        $I->see('Stoßdämpfer V-F');
        $I->makeScreenshot();
    }


















    public function createAccount(AcceptanceTester $I): void
    {
        $I->amOnPage('/konto-eroeffnen/');

        $I->makeScreenshot();

        $I->see('Konto eröffnen');

        $I->makeScreenshot();

        $I->fillField('input[id=userLoginName]', uniqid() . 'a@q.com');
        $I->fillField('input[id=userPassword]', 'a@q.com');
        $I->fillField('input[id=userPasswordConfirm]', 'a@q.com');
        $I->fillField('invadr[oxuser__oxfname]', 'a@q.com');
        $I->fillField('invadr[oxuser__oxlname]', 'a@q.com');
        $I->fillField('invadr[oxuser__oxstreet]', 'a@q.com');
        $I->fillField('invadr[oxuser__oxstreetnr]', 'a@q.com');
        $I->fillField('invadr[oxuser__oxzip]', 'a@q.com');
        $I->fillField('invadr[oxuser__oxcity]', 'a@q.com');
        $I->selectOption('invadr[oxuser__oxcountryid]', 'a7c40f631fc920687.20179984'); //select

        $I->makeScreenshot('create_account_form');

        $I->click('Speichern');

        $I->makeScreenshot();

        $I->see('Herzlich willkommen als registrierter Kunde!');
    }

}
