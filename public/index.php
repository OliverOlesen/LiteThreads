<?php
define('ROOT_DIR', dirname(__DIR__));
define('UPLOAD_DIR', '/uploads');
define('VIEW_DIR', ROOT_DIR . '/resources/views');

require_once(ROOT_DIR.'/vendor/autoload.php');
use Pecee\SimpleRouter\SimpleRouter as Route;

require_once(ROOT_DIR.'/routes.php');

session_start();
Route::setDefaultNamespace('Controllers');

require_once(ROOT_DIR.'/helpers.php');

// Start the routing
Route::start();