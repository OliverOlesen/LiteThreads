<?php
    use Pecee\SimpleRouter\SimpleRouter as Route;
    use Pecee\Http\Request; 
    Route::setDefaultNamespace('Controllers');

    use Middleware\{
    Authenticated,
    Guest
    };

    Route::get('/', function () {
        return "Default route";        
    });

    Route::get('/get_user_with_id', 'UsersController@GetUserById');
    Route::get('/users', 'UsersController@GetUsers');
    Route::get('/get_user_availability', 'UsersController@CheckUsernameEmailAvailable');
    Route::post('/create_mail_verf','UsersController@CreateUserMailVerf');
    Route::post('/verf_mail_code','UsersController@VerfMailCode');
    Route::post('/create_user', 'UsersController@CreateUser');
    Route::post('/login_user', 'UsersController@LoginUser');
    Route::get('/sendmail', 'MailsController@SendMail');

    //For testing purposes
    Route::get('/api/get_hello', function () {
            $people["1"] = array("Peter"=>35, "Ben"=>37, "Joe"=>43);
            $people["2"] = array("David"=>35, "Carl"=>37, "Doesen"=>43);
            return json_encode($age);
            //view('login');
        });

    // This is how the setup looks, when you need to stop people from accessing a route, unless they are stopped by the authenticating middleware.
    Route::group(['middleware' => Authenticated::class], function () {
        Route::get('/check', function () {
            // return 'Hello world'. $_SESSION['user_role'];
            view('login');
        });
    });
        

    // This is error handling routing, and will be looked at later. This is only and example.
    // Route::error(function(Request $request, \Exception $exception) {
    //     switch($exception->getCode()) {
    //         // Page not found
    //         case 404:
    //             response()->redirect('/');
    //         // Forbidden
    //         case 403:
    //             response()->redirect('/');
    //     }
        
    // });




?>