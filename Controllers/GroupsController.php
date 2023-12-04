<?php
namespace Controllers;

use Models\Groups;
use Models\Users;
class GroupsController extends Controller
{
    private $groups;
    private $users;
    private $jwtInfo;

    public function __construct() {
        $this->users = new Users();
        $this->groups = new Groups();
        $this->jwtInfo = $this->decodeJwt();
    }

    public function CreateNewGroup() {
        $requiredValues = ['name', 'category_name', 'is_private', 'is_age_restricted'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $groupExists = $this->groups->getGroupWithName($_GET['name']);
        if ($groupExists)
            return $this->jsonErrorResponse("Group name already exists");

        $categoryExists = $this->groups->getSpecificCategory($_GET['category_name']);
        if (!$categoryExists)
            return $this->jsonErrorResponse("Category does not exist");

        $validBoolean['is_private'] = $this->validateBoolean($_GET['is_private']);
        $validBoolean['is_age_restricted'] = $this->validateBoolean($_GET['is_age_restricted']);
        // If the return value is not a string, the values are valid booleans
        $errors = array_filter($validBoolean, function ($value) {
            return is_string($value); // Check if the value is a string (error message)
        });
        if (!empty($errors))
            return $this->jsonErrorResponse($errors);

        $newGroup = $this->groups->createGroup($_GET['name'], $categoryExists['id'], $validBoolean['is_private'], $validBoolean['is_age_restricted']);
        if (!$newGroup)
            return $this->jsonErrorResponse("Group could not be created");

        $group = $this->groups->getGroupWithName($_GET['name']);
        if (empty($group))
            return $this->jsonErrorResponse("Group does not exist");
        
        $groupModerator = $this->groups->createGroupModerator($group['id'], $this->jwtInfo['user_id']);
        
        return $this->jsonSuccessResponse("Group was created");
    }

    public function FollowGroup() {
        $requiredValues = ['group_name'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $group = $this->groups->getGroupWithName($_GET['group_name']);
        if (empty($group))
            $error['not_found'][] = "Group";


        if (isset($error) && !empty($error))
            return $this->jsonErrorResponse($error);

        $groupAlreadyFollowed = $this->groups->getUsersSpecificFollowedGroup($this->jwtInfo['user_id'], $group['id']);
        if (!empty($groupAlreadyFollowed))
            return $this->jsonSuccessResponse("Group already followed");

        $groupFollowed = $this->groups->followGroup($this->jwtInfo['user_id'], $group['id']);
        if (empty($groupFollowed))
            return $this->jsonErrorResponse("Group could not be followed");

        return $this->jsonSuccessResponse("Group was followed");
    }

    public function UnfollowGroup() {
        $requiredValues = ['group_name'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $group = $this->groups->getGroupWithName($_GET['group_name']);
        if (empty($group))
            $error['not_found'][] = "Group";

        if (isset($error) && !empty($error))
            return $this->jsonErrorResponse($error);

        $groupAlreadyFollowed = $this->groups->getUsersSpecificFollowedGroup($this->jwtInfo['user_id'], $group['id']);
        if (empty($groupAlreadyFollowed))
            return $this->jsonSuccessResponse("Group is not followed");

        $unfollowed = $this->groups->unfollowGroup($this->jwtInfo['user_id'], $group['id']);
        if (empty($unfollowed))
            return $this->jsonErrorResponse("Group could not be unfollowed");

        return $this->jsonSuccessResponse("Group was unfollowed");
    }

    public function GetUsersFollowedGroups() {        
        $followedGroups = $this->groups->getUsersFollowedGroups($this->jwtInfo['user_id']);
        if (empty($followedGroups))
            return $this->jsonSuccessResponse("User does not follow any groups");

        foreach ($followedGroups as $group) {
            $groups['followed_groups'][] = $group;
        }

        return $this->jsonSuccessResponse($groups);
    }

    public function GetUsersFollowedCategoryGroups() {
        $groupsInFollowedCategory = $this->groups->getUserFollowedCategoryGroups($this->jwtInfo['user_id']);
        if (empty($groupsInFollowedCategory))
            return $this->jsonSuccessResponse("No groups with followed categories");

        foreach ($groupsInFollowedCategory as $group) {
            $groups["groups_in_categories"][] = $group;
        }

        return $this->jsonSuccessResponse($groups);
    }

    public function ArchiveGroup() {
        $requiredValues = ['group_name'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validGroup = $this->groups->getGroupWithName($_GET['group_name']);
        if (empty($validGroup))
            $error['not_found'][] = "Group";

        if (isset($error) && !empty($error))
            return $this->jsonErrorResponse($error);

        $groupModerator = $this->groups->getGroupModerator($validGroup['id']);
        if (empty($groupModerator))
            return $this->jsonErrorResponse("No moderator for group");

        if ($groupModerator['user_id'] !== $this->jwtInfo['user_id'])
            return $this->jsonErrorResponse("not owner of group");

        if ($validGroup['is_archived'] == false) {
            $archivedGroup = $this->groups->archiveGroup($validGroup['id']);
            if (!$archivedGroup)
                return $this->jsonErrorResponse("Group could not be archived");
    
            return $this->jsonSuccessResponse("Group was archived");
        } else {
            $unarchivedGroup = $this->groups->unarchiveGroup($validGroup['id']);
            if (!$unarchivedGroup)
                return $this->jsonErrorResponse("Group could not be unarchived");
    
            return $this->jsonSuccessResponse("Group was unarchived");
        }
    }

}