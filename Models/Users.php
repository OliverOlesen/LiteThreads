<?php
namespace Models;

use Models\DB;
// user extends from class DB, so that we can use the database connection made in the DB class
class Users extends DB {
    public function getUserById($id) {
        $userData = DB::selectFirst("SELECT * FROM users WHERE id = ?", [$id]);
        return $userData;
    }

    public function getUsers() {
        $userData = DB::selectAll("SELECT * FROM users");
        return $userData;
    }

    public function getUserCredByMail($email) {
        $userData = DB::selectFirst("SELECT username, password FROM users WHERE email = ?", [$email]);
        return $userData;
    }

    public function getUserByMail($email) {
        $userData = DB::selectFirst("SELECT email FROM users WHERE email = ?", [$email]);
        return $userData;
    }

    public function getUserByUsername($username) {
        $userData = DB::selectFirst("SELECT username FROM users WHERE username = ?", [$username]);
        return $userData;
    }

    public function createUser($username, $password, $email, $birthdate) {
        $userData = DB::insert(
            "INSERT INTO users (username, password, email, birthdate) 
            VALUES (?,?,?,?)", 
            [$username, $password, $email, $birthdate]);
            
        return $userData;
    }

    public function createEmailVerf($email, $verf_code) {
        $verfData = DB::insert(
            "INSERT INTO email_verification (email, verf_code) 
            VALUES (?,?)", 
            [$email, $verf_code]);
            
        return $verfData;
    }

    public function getVerfCodeByMail($email) {
        $verfData = DB::selectFirst("SELECT * FROM email_verification WHERE email = ?", [$email]);
        return $verfData;
    }

    public function deleteVerfCodeByMailAndCode($email, $verf_code) {
        $request = DB::delete("DELETE FROM email_verification WHERE email = ? AND verf_code = ?", [$email, $verf_code]);
        return $request;
    }

    public function deleteVerfCodeByMail($email) {
        $request = DB::delete("DELETE FROM email_verification WHERE email = ?", [$email]);
        return $request;
    }
}