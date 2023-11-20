<?php
namespace Controllers;

use Models\Groups;
use Models\Users;
class GroupsController extends Controller
{
    private $groups;
    private $users;

    public function __construct() {
        $this->users = new Users();
        $this->groups = new Groups();
    }

    public function GetUsersFollowedGroups() {
        $requiredValues = ['username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $userId = $this->users->getUserIdByUsername($_GET['username']);
        if (!$userId)
            return $this->jsonErrorResponse("User does not exist");
        
        $followedGroups = $this->groups->getUsersFollowedGroupsByUserId($userId['id']);
        if (!$followedGroups)
            return $this->jsonSuccessResponse("User does not follow any groups");

        foreach ($followedGroups as $group) {
            $groups['followed_groups'][] = $group['name'];
        }

        return $this->jsonSuccessResponse($groups);
    }

}