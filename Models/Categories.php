<?php
namespace Models;

use Models\DB;
// user extends from class DB, so that we can use the database connection made in the DB class
class Categories extends DB {
    public function getCategories() {
        $categories = DB::selectAll(
            "SELECT c.name FROM categories c"
        );

        return $categories;
    }

    public function getCategoryByName($category_name) {
        $category = DB::selectFirst(
            "SELECT c.id FROM categories AS c
            WHERE c.name = ?", [$category_name]);

        return $category;
    }

    public function userIsFollowingCategory($user_id, $category_id) {
        $alreadyFollowed = DB::selectFirst(
            "SELECT ufc.user_id FROM users_followed_categories AS ufc
            WHERE ufc.user_id = ? AND ufc.category_id = ?", [$user_id, $category_id]);

        return $alreadyFollowed;
    }

    public function userFollowCategory($user_id, $category_id) {
        $followedCategoryData = DB::insert(
            "INSERT INTO users_followed_categories (user_id, category_id)
            VALUES (?,?)", 
            [$user_id, $category_id]);
            
        return $followedCategoryData;
    }

    public function userUnfollowCategory($user_id, $category_id) {
        $unfollowedCategory = DB::delete(
            "DELETE FROM users_followed_categories ufc
            WHERE ufc.user_id = ? AND ufc.category_id = ?", 
            [$user_id, $category_id]);
            
        return $unfollowedCategory;
    }

    public function usersFollowedCategories($user_id) {
        $followedCategories = DB::selectAll(
            "SELECT c.name FROM categories c
            INNER JOIN users_followed_categories ufc
            ON ufc.category_id = c.id
            WHERE ufc.user_id = ?", [$user_id]);

        return $followedCategories;
    }
}