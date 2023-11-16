<?php

namespace Middleware;

use Pecee\Http\Middleware\IMiddleware;
use Pecee\Http\Request;

class Guest implements IMiddleware
{
    public function handle(Request $request): void
    {
        echo 'This user is a guest, if not, redirect them.';
        die;
    }
}