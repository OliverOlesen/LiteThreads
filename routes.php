<?php
    use Pecee\SimpleRouter\SimpleRouter as Route;
    use Pecee\Http\Request; 
    Route::setDefaultNamespace('Controllers');

    use Middleware\{
    Authenticated,
    Guest
    };

    Route::get('/', function () {
        return "This website is for litethreads api's";        
    });
    Route::get('/page_not_found', function () {
        return "Page or api call not found";        
    });
    Route::get('/access_denied', function () {
        return "Don't have access to that api / page";        
    });

    // User api's
    Route::get('/get_user_availability', 'UsersController@CheckUsernameEmailAvailable');
    Route::get('/create_mail_verf','UsersController@CreateUserMailVerf');
    Route::get('/verf_mail_code','UsersController@VerfMailCode');
    Route::get('/create_user', 'UsersController@CreateUser');
    Route::get('/login_user', 'UsersController@LoginUser');
    
    
    
    // These routes are only available if a valid JWToken is sent with the request (For now as a get(provider issues))
    Route::group(['middleware' => Authenticated::class], function () {
        // Most of these requests should be post requests, but because of hosting provider difficulties
        // they have been set and updated to be get requests

        // Followed Users api
        Route::get('/follow_unfollow_user', 'UsersController@FollowUnfollowUser');
        Route::get('/get_followed_users', 'UsersController@GetFollowedUsers');
        
        // Group api's
        Route::get('/get_users_followed_groups','GroupsController@GetUsersFollowedGroups');
        Route::get('/get_users_followed_category_groups','GroupsController@GetUsersFollowedCategoryGroups');
        Route::get('/create_new_group','GroupsController@CreateNewGroup');
        Route::get('/follow_group','GroupsController@FollowGroup');
        Route::get('/unfollow_group','GroupsController@UnfollowGroup');
        
        // Post api calls
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
    });
        

    // This is error handling routing, and will be looked at later. This is only and example.
    Route::error(function(Request $request, \Exception $exception) {
        switch($exception->getCode()) {
            // Page not found
            case 404:
                response()->redirect('/page_not_found');
            // Forbidden
            // This only happens if a jwtoken is sent with, but it doesn't have the correct values, 
            // which it needs for the Route::Group that it's in.
            case 403:
                response()->redirect('/access_denied');
        }
        
    });




?>