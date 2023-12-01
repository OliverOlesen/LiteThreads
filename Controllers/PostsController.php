<?php
namespace Controllers;

use Models\Groups;
use Models\Users;
use Models\Posts;
class PostsController extends Controller
{
    private $groups;
    private $users;

    public function __construct() {
        $this->users = new Users();
        $this->groups = new Groups();
        $this->posts = new Posts();
    }

    public function CreateUserPost() {
        $requiredValues = ['username', 'title', 'content'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser)) {
            return $this->jsonErrorResponse("User does not exist");
        }

        $createPost = $this->posts->createUserPost($validUser['id'], $_GET['title'], $_GET['content']);
        if (!$createPost)
            return $this->jsonErrorResponse("Post could not be created");

        return $this-> jsonSuccessResponse("Post was created under user");
    }

    public function CreateUserGroupPost() {
        $requiredValues = ['username', 'group_name', 'title', 'content'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        $validGroup = $this->groups->getGroupWithName($_GET['group_name']);
        if (empty($validGroup))
            $error['invalid_value'][] = "Group";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $createPost = $this->posts->createUserGroupPost($validUser['id'], $validGroup['id'], $_GET['title'], $_GET['content']);
        if (!$createPost)
            return $this->jsonErrorResponse("Post could not be created");

        return $this-> jsonSuccessResponse("Post was created under group");
    }

    public function VoteOnPost() {
        $requiredValues = ['username', 'post_id', 'reaction_like'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $errors['invalid_value'][] = "User";

        $validPost = $this->posts->getPost($_GET['post_id']);
        if (empty($validPost))
            $errors['invalid_value'][] = "Post";

        $validBoolean['reaction_like'] = $this->validateBoolean($_GET['reaction_like']);
        // If the return value is not a string, the values are valid booleans
        $errors['invalid_value'][] = array_filter($validBoolean, function ($value) {
            return is_string($value); // Check if the value is a string (error message)
        });
        
        $errors['invalid_value'] = array_filter($errors['invalid_value']);
        if (!empty($errors['invalid_value']))
            return $this->jsonErrorResponse($errors);

        $userAlreadyVoted = $this->posts->postAlreadyVotedOn($validUser['id'], $validPost['id']);
        // If the user votes the same value, that it has already voted on the post, erase the vote on the post
        if (!empty($userAlreadyVoted)) {
            if($userAlreadyVoted['reaction_like'] == $validBoolean['reaction_like']) {
                $voteRevoked = $this->posts->revokePostVote($validUser['id'], $validPost['id']);
                return $this->jsonSuccessResponse("Post vote revoked");
            } else {
                $voteUpdated = $this->posts->updatePostVote($validUser['id'], $validPost['id'], $validBoolean['reaction_like']);
                return $this->jsonSuccessResponse("Post vote was changed");
            }
        }

        $postVotedOn = $this->posts->voteOnPost($validUser['id'], $validPost['id'], $validBoolean['reaction_like']);
        if (!$postVotedOn) {
            return $this->jsonErrorResponse("Could not vote on post");
        }

        return $this->jsonSuccessResponse("Post was voted on");
    }

    public function GetPostsFromGroup() {
        $requiredValues = ['username', 'group_name'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        $validGroup = $this->groups->getGroupWithName($_GET['group_name']);
        if (empty($validGroup))
            $error['invalid_value'][] = "Group";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsInSpecificGroup($validUser['id'], $validGroup['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts in that group");

        return $this->jsonSuccessResponse($posts);
    }

    public function GetPostsFromSpecificUserWall() {
        $requiredValues = ['username', 'specific_username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        $specificValidUser = $this->users->getUserByUsername($_GET['specific_username']);
        if (empty($specificValidUser))
            $error['invalid_value'][] = "Specific user";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsFromSpecificUserWall($validUser['id'], $specificValidUser['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts on users wall");

        return $this->jsonSuccessResponse($posts);
    }

    public function GetPostsFromSpecificUser() {
        $requiredValues = ['username', 'specific_username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        $specificValidUser = $this->users->getUserByUsername($_GET['specific_username']);
        if (empty($specificValidUser))
            $error['invalid_value'][] = "Specific user";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsFromSpecificUser($validUser['id'], $specificValidUser['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from user");

        return $this->jsonSuccessResponse($posts);
    }

    public function GetPostsFromUsersFollowedCategories() {
        $requiredValues = ['username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsFromGroupsWithFollowedCategory($validUser['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from followed categories");

        return $this->jsonSuccessResponse($posts); 
    }

    public function GetPostsFromFollowedGroups() {
        $requiredValues = ['username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsFromFollowedGroups($validUser['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from followed groups");

        return $this->jsonSuccessResponse($posts); 
    }

    public function GetPostsFromFollowedUsers() {
        $requiredValues = ['username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsFromFollowedUsersWall($validUser['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from followed users");

        return $this->jsonSuccessResponse($posts); 
    }

    public function GetPostsFromFollowedGroupsAndUsers() {
        $requiredValues = ['username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validUser = $this->users->getUserByUsername($_GET['username']);
        if (empty($validUser))
            $error['invalid_value'][] = "User";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts['Users'] = $this->posts->getPostsFromFollowedUsersWall($validUser['id']);
        if (empty($posts['Users'][0]))
            $posts['Users'] = "No posts from followed users";

        $posts['Groups'] = $this->posts->getPostsFromFollowedGroups($validUser['id']);
        if (empty($posts['Groups'][0]))
            $posts['Groups'] = "No posts from followed groups";

        return $this->jsonSuccessResponse($posts); 
    }

}