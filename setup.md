# Setting up Composer

$ cd app/Plugin
$ git clone git://github.com/uzyn/cakephp-composer.git Composer


vim Config/bootstrap.php
CakePlugin::load('Composer', array('bootstrap' => true));

    $ cd ../
    $ Console/cake composer.c
    Composer plugin for CakePHP

    Composer is not installed.
    Would you like to install the latest version of Composer? (y/n)
    [y] > y
    Setting up Composer
    Downloading composer.phar from http://getcomposer.org/composer.phar...
    Composer installed and saved successfully.

       ______
      / ____/___  ____ ___  ____  ____  ________  _____
     / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
    / /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
    \____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/

vim composer.json
{
    "require": {
        "cakephp/debug_kit": "2.2.*@dev",
        "cakedc/migrations": "dev-develop"
    },
    "config": {
        "vendor-dir": "Vendor"
    }
}


$ COMPOSER_PROCESS_TIMEOUT=4000 Console/cake composer.c install

app/PluginにDebugKitとMigrationsのディレクトリが出来る。

$ vim app/Config/bootstrap.php

    CakePlugin::load('DebugKit');
    CakePlugin::load('Migrations');