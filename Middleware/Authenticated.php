<?php

namespace Middleware;

use Pecee\Http\Middleware\IMiddleware;
use Pecee\Http\Request;

class Authenticated implements IMiddleware
{
    public function handle(Request $request): void
    {
        echo 'This user is authenticated, if not, redirect.';
        die;
    }
}