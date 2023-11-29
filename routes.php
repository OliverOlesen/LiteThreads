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

    // User api's
    Route::get('/get_user_with_id', 'UsersController@GetUserById');
    Route::get('/users', 'UsersController@GetUsers');
    Route::get('/get_user_availability', 'UsersController@CheckUsernameEmailAvailable');

    // These should be post requests, but because of the hosting provider difficulties, they are get for now.
    Route::get('/create_mail_verf','UsersController@CreateUserMailVerf');
    Route::get('/verf_mail_code','UsersController@VerfMailCode');
    Route::get('/create_user', 'UsersController@CreateUser');
    Route::get('/login_user', 'UsersController@LoginUser');

    // Group api's
    Route::get('/get_users_followed_groups','GroupsController@GetUsersFollowedGroups');
    Route::get('/get_users_followed_category_groups','GroupsController@GetUsersFollowedCategoryGroups');
    Route::get('/create_new_group','GroupsController@CreateNewGroup');
    Route::get('/follow_group','GroupsController@FollowGroup');
    Route::get('/unfollow_group','GroupsController@UnfollowGroup');
    
    // Post api's
    Route::get('/create_user_post','PostsController@CreateUserPost');
    Route::get('/create_group_post','PostsController@CreateUserGroupPost');
    Route::get('/vote_on_post','PostsController@VoteOnPost');
    Route::get('/get_group_posts','PostsController@GetPostsFromGroup');
    Route::get('/get_users_wall_post','PostsController@GetPostsFromSpecificUserWall');
    Route::get('/get_users_post','PostsController@GetPostsFromSpecificUser');
    Route::get('/get_user_category_posts','PostsController@GetPostsFromUsersFollowedCategories');
    Route::get('/get_user_followed_groups_posts','PostsController@GetPostsFromFollowedGroups');
    Route::get('/get_user_followed_users_posts','PostsController@GetPostsFromFollowedUsers');
    Route::get('/get_user_followed_users_and_groups_posts','PostsController@GetPostsFromFollowedGroupsAndUsers');
    
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