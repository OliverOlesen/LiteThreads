<?php
namespace Controllers;

use Models\Groups;
use Models\Users;
use Models\Posts;
class PostsController extends Controller
{
    private $groups;
    private $users;
    private $posts;
    private $jwtInfo;

    public function __construct() {
        $this->users = new Users();
        $this->groups = new Groups();
        $this->posts = new Posts();
        $this->jwtInfo = $this->decodeJwt();
    }

    public function CreateUserPost() {
        $requiredValues = ['title', 'content'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $createPost = $this->posts->createUserPost($this->jwtInfo['user_id'], $_GET['title'], $_GET['content']);
        if (!$createPost)
            return $this->jsonErrorResponse("Post could not be created");

        return $this-> jsonSuccessResponse("Post was created under user");
    }

    public function CreateUserGroupPost() {
        $requiredValues = ['group_name', 'title', 'content'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validGroup = $this->groups->getGroupWithName($_GET['group_name']);
        if (empty($validGroup))
            $error['invalid_value'][] = "Group";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $createPost = $this->posts->createUserGroupPost($this->jwtInfo['user_id'], $validGroup['id'], $_GET['title'], $_GET['content']);
        if (!$createPost)
            return $this->jsonErrorResponse("Post could not be created");

        return $this-> jsonSuccessResponse("Post was created under group");
    }

    public function ArchivePost() {
        $requiredValues = ['post_id'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validPost = $this->posts->getPostCred($_GET['post_id']);
        if (empty($validPost))
            $error['not_found'][] = "Post";

        if (isset($error) && !empty($error))
            return $this->jsonErrorResponse($error);

        if ($validPost['user_id'] !== $this->jwtInfo['user_id'])
            return $this->jsonErrorResponse("not owner of post");

        if ($validPost['is_archived'] == false) {
            $archivedPost = $this->posts->archivePost($_GET['post_id']);
            if (!$archivedPost)
                return $this->jsonErrorResponse("Post could not be archived");
        
            return $this->jsonSuccessResponse("Post was archived");
        } else {
            $unarchived = $this->posts->unarchivePost($_GET['post_id']);
            if (!$unarchived)
                return $this->jsonErrorResponse("Post could not be unarchived");
        
            return $this->jsonSuccessResponse("Post was unarchived");
        }
    }

    public function VoteOnPost() {
        $requiredValues = ['post_id', 'reaction_like'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

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

        $userAlreadyVoted = $this->posts->postAlreadyVotedOn($this->jwtInfo['user_id'], $validPost['id']);
        // If the user votes the same value, that it has already voted on the post, erase the vote on the post
        if (!empty($userAlreadyVoted)) {
            if($userAlreadyVoted['reaction_like'] == $validBoolean['reaction_like']) {
                $voteRevoked = $this->posts->revokePostVote($this->jwtInfo['user_id'], $validPost['id']);
                return $this->jsonSuccessResponse("Post vote revoked");
            } else {
                $voteUpdated = $this->posts->updatePostVote($this->jwtInfo['user_id'], $validPost['id'], $validBoolean['reaction_like']);
                return $this->jsonSuccessResponse("Post vote was changed");
            }
        }

        $postVotedOn = $this->posts->voteOnPost($this->jwtInfo['user_id'], $validPost['id'], $validBoolean['reaction_like']);
        if (!$postVotedOn) {
            return $this->jsonErrorResponse("Could not vote on post");
        }

        return $this->jsonSuccessResponse("Post was voted on");
    }

    public function GetPostsFromGroup() {
        $requiredValues = ['group_name'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validGroup = $this->groups->getGroupWithName($_GET['group_name']);
        if (empty($validGroup))
            $error['invalid_value'][] = "Group";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsInSpecificGroup($this->jwtInfo['user_id'], $validGroup['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts in that group");

        return $this->jsonSuccessResponse($posts);
    }

    public function GetPostsFromSpecificUserWall() {
        $requiredValues = ['specific_username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $specificValidUser = $this->users->getUserByUsername($_GET['specific_username']);
        if (empty($specificValidUser))
            $error['invalid_value'][] = "Specific user";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsFromSpecificUserWall($this->jwtInfo['user_id'], $specificValidUser['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts on users wall");

        return $this->jsonSuccessResponse($posts);
    }

    public function GetPostsFromSpecificUser() {
        $requiredValues = ['specific_username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $specificValidUser = $this->users->getUserByUsername($_GET['specific_username']);
        if (empty($specificValidUser))
            $error['invalid_value'][] = "Specific user";

        if (!empty($error['invalid_value']))
            return $this->jsonErrorResponse($error);

        $posts = $this->posts->getPostsFromSpecificUser($this->jwtInfo['user_id'], $specificValidUser['id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from user");

        return $this->jsonSuccessResponse($posts);
    }

    public function GetPostsFromUsersFollowedCategories() {
        $posts = $this->posts->getPostsFromGroupsWithFollowedCategory($this->jwtInfo['user_id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from followed categories");

        return $this->jsonSuccessResponse($posts); 
    }

    public function GetPostsFromFollowedGroups() {
        $posts = $this->posts->getPostsFromFollowedGroups($this->jwtInfo['user_id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from followed groups");

        return $this->jsonSuccessResponse($posts); 
    }

    public function GetPostsFromFollowedUsers() {
        $posts = $this->posts->getPostsFromFollowedUsersWall($this->jwtInfo['user_id']);
        if (empty($posts))
            return $this->jsonSuccessResponse("No posts from followed users");

        return $this->jsonSuccessResponse($posts); 
    }

    public function GetPostsFromFollowedGroupsAndUsers() {
        $posts['Users'] = $this->posts->getPostsFromFollowedUsersWall($this->jwtInfo['user_id']);
        if (empty($posts['Users'][0]))
            $posts['Users'] = "No posts from followed users";

        $posts['Groups'] = $this->posts->getPostsFromFollowedGroups($this->jwtInfo['user_id']);
        if (empty($posts['Groups'][0]))
            $posts['Groups'] = "No posts from followed groups";

        return $this->jsonSuccessResponse($posts); 
    }

}