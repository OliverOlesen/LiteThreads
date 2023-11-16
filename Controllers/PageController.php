<?php
namespace Controllers;
// This PageController will be used for error handling, and other stuff aswell.
// May be deleted at a later date, but for now, might be useful for testing.
class PageController extends Controller
{
    public function defaultRoute() {
        return view('notlogin');
    }

    public function methodNotAllowed(): string
    {
        return view('405');
    }

    public function notFound(): string
    {
        return view('404');
    }
}