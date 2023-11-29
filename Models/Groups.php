<?php
namespace Models;

use Models\DB;
// All the groups which are returned, will only be returned if they aren't marked as archived.
class Groups extends DB {
    public function createGroup($name, $category_id, $is_private, $is_age_restricted) {
        $groupData = DB::insert(
            "INSERT INTO `groups` (name, category_id, is_private, is_age_restricted) 
            VALUES (?,?,?,?)", 
            [$name, $category_id, $is_private, $is_age_restricted]);
            
        return $groupData;
    }

    public function followGroup($user_id, $group_id) {
        $groupData = DB::insert(
            "INSERT INTO followed_groups (user_id, group_id)
            VALUES (?,?)", 
            [$user_id, $group_id]);
            
        return $groupData;
    }

    public function unfollowGroup($user_id, $group_id) {
        $groupData = DB::delete(
            "DELETE FROM followed_groups
            WHERE user_id = ? AND group_id = ?", 
            [$user_id, $group_id]);
            
        return $groupData;
    }

    public function getUsersSpecificFollowedGroup($user_id, $group_id) {
        $followedGroup = DB::selectFirst(
            "SELECT * FROM followed_groups
            WHERE user_id = ? AND group_id = ?", [$user_id, $group_id]);

        return $followedGroup;
    }

    public function getUsersFollowedGroups($user_id) {
        $groups = DB::selectAll(
            "SELECT g.id, g.name 
            FROM followed_groups AS fg
            INNER JOIN `groups` AS g ON g.id = fg.group_id
            WHERE fg.user_id = ? AND g.is_archived = false", [$user_id]);

        return $groups;
    }

    public function getGroupWithName($group_name) {
        $group = DB::selectFirst(
            "SELECT id FROM `groups`
            WHERE NAME = ?", [$group_name]);

        return $group;
    }

    public function getSpecificCategory($category) {
        $category = DB::selectFirst(
            "SELECT id FROM category
            WHERE category_name = ?", [$category]);

        return $category;
    }

    public function createGroupModerator($group_id, $user_id) {
        $groupData = DB::insert(
            "INSERT INTO group_moderators (group_id, user_id)
            VALUES (?,?)", 
            [$group_id, $user_id]);
            
        return $groupData;
    }

    public function getGroupModerator($group_id, $user_id) {
        $groupModerator = DB::selectFirst(
            "SELECT u.username AS user 
            FROM group_moderators AS gm
            INNER JOIN users AS u
            ON u.id = gm.user_id
            WHERE gm.group_id = ? AND gm.user_id = ?", [$group_id, $user_id]);

        return $groupModerator;
    }

    // Finds all the groups that have the category which the user follows.
    public function getUserFollowedCategoryGroups($user_id) {
        $groups = DB::selectAll(
            "SELECT g.name 
            FROM `groups` AS g
            INNER JOIN users_followed_categories AS ufc 
            ON ufc.category_id = g.category_id AND ufc.user_id = ?
            LEFT JOIN user_blocked_groups AS ubg 
            ON ubg.group_id = g.id AND ubg.user_id =?
            WHERE g.is_archived = false AND ubg.user_id IS NULL", [$user_id, $user_id]);

        return $groups;
    }

    public function getUserBlockedGroups($user_id) {
        $groups = DB::selectAll(
            "SELECT g.name AS group_name 
            FROM `groups` AS g
            INNER JOIN user_blocked_groups AS ubg
            ON ubg.group_id = g.id
            WHERE ubg.user_id = ? AND g.is_archived = false", [$user_id]);

        return $groups;
    }

    public function getGroupsBlockedUsers($group_id) {
        $blockedUsers = DB::selectAll(
            "SELECT u.username AS blocked_users 
            FROM group_blocked_users AS gbu
            INNER JOIN users AS u
            ON u.id = gbu.user_id
            WHERE gbu.group_id = ?", [$group_id]);
            
        return $blockedUsers;
    }
}