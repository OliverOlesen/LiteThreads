<?php
namespace Controllers;

use Models\Users;
use Models\Categories;
class CategoriesController extends Controller
{
    private $users;
    private $categories;
    private $jwtInfo;

    public function __construct() {
        $this->users = new Users();
        $this->categories = new Categories();
        $this->jwtInfo = $this->decodeJwt();
    }

    public function GetCategories() {
        $categories = $this->categories->getCategories();
        if (empty($categories))
            return $this->jsonErrorResponse("There are not categories");

        return $this->jsonSuccessResponse($categories);
    }

    public function GetUsersFollowedCategories() {
        $followedCategories = $this->categories->usersFollowedCategories($this->jwtInfo['user_id']);
        if (empty($followedCategories))
            return $this->jsonSuccessResponse("No followed categories");

        return $this->jsonSuccessResponse($followedCategories);
    }

    public function userFollowUnfollowCategory() {
        $requiredValues = ['category_name'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $validCategory = $this->categories->getCategoryByName($_GET['category_name']);
        if (empty($validCategory))
            $errors['invalid_value'][] = "Category";

        if (!empty($errors['invalid_value'])) {
            $errors['invalid_value'] = array_filter($errors['invalid_value']);
            return $this->jsonErrorResponse($errors);
        }

        $alreadyFollowed = $this->categories->userIsFollowingCategory($this->jwtInfo['user_id'], $validCategory['id']);
        if (!empty($alreadyFollowed)) {
            $unfollowCategory = $this->categories->userUnfollowCategory($this->jwtInfo['user_id'], $validCategory['id']);
            if (!$unfollowCategory)
                return $this->jsonErrorResponse("Category could not be unfollowed");

            return $this->jsonSuccessResponse("Category was unfollowed");
        }

        $userFollowCategory = $this->categories->userFollowCategory($this->jwtInfo['user_id'], $validCategory['id']);
        if (!$userFollowCategory)
            return $this->jsonErrorResponse("Category could not be followed");

        return $this->jsonSuccessResponse("Category was followed");
    }

}