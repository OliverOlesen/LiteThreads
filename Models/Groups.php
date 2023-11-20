<?php
namespace Models;

use Models\DB;
class Groups extends DB {
    public function getUserById($id) {
        $userData = DB::selectFirst("SELECT * FROM users WHERE id = ?", [$id]);
        return $userData;
    }

    public function getUsersFollowedGroupsByUserId($user_id) {
        $groups = DB::selectAll(
            "SELECT g.name FROM followed_groups AS fg
            INNER JOIN `groups` AS g ON g.id = fg.group_id
            WHERE fg.user_id = ?", [$user_id]);
        return $groups;
    }
}