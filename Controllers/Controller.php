<?php

namespace Controllers;

class Controller
{
    public function __construct()
    {
        if (request()->getMethod() !== 'get') {
            $_SESSION['old'] = input()->all();
        }
    }
}