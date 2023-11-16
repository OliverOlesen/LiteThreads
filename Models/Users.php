<?php
namespace Models;

use Models\DB;
// user extends from class DB, so that we can use the database connection made in the DB class
class Users extends DB {
    public function getUser($id) {
        $userData = DB::selectFirst("SELECT * FROM users WHERE id = ?", [$id]);
        return $userData;
    }

    public function getUsers() {
        $userData = DB::selectAll("SELECT * FROM users");
        return $userData;
    }
}